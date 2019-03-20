-- $Id: unit_explosion_spawner.lua 3171 2008-11-06 09:06:29Z det $
function gadget:GetInfo()
	return {
		name = "100 Unit Explosion Spawner",
		desc = "Spawns units using an explosion as a trigger.",
		author = "KDR_11k (David Becker), lurker",
		date = "2007-11-18",
		license = "None",
		layer = 50,
		enabled = not Spring.Utilities.IsCurrentVersionNewerThan(100, 0)
	}
end

if not (gadgetHandler:IsSyncedCode()) then
	return
end

--SYNCED

local wantedList = {}
local spawn_defs_id = {}
local shieldCollide_id = {}
local createList = {}
local expireList = {}
local noCreate = {}

-- Speedups --
local SetWatchProjectile = Script.SetWatchProjectile
local SetWatchWeapon = Script.SetWatchWeapon
local spGetModOptions = Spring.GetModOptions
local spGetProjectileDefID = Spring.GetProjectileDefID
local spGetProjectileTeamID = Spring.GetProjectileTeamID
local spGetProjectilePosition = Spring.GetProjectilePosition
local spUseTeamResource = Spring.UseTeamResource
local spGetUnitShieldState = Spring.GetUnitShieldState
local pi = math.pi()
local random = math.random
local spCreateFeature = Spring.CreateFeature
local vectorPolarToCart = Spring.Utilities.Vector.PolarToCart
local spSetFeatureDirection = Spring.SetFeatureDirection
local spDestroyUnit = Spring.DestroyUnit
local spCreateUnit = Spring.CreateUnit


function gadget:Initialize()
	local modOptions = spGetModOptions()
	local spawn_defs_name, shieldCollide_names = VFS.Include("LuaRules/Configs/explosion_spawn_defs.lua")
	for weapon,spawn_def in pairs(spawn_defs_name) do
		if WeaponDefNames[weapon] then
			local weaponID = WeaponDefNames[weapon].id
			if (UnitDefNames[spawn_def.name] and not spawn_def.feature) or (FeatureDefNames[spawn_def.name] and spawn_def.feature) then
				spawn_defs_id[weaponID] = spawn_def
				wantedList[#wantedList + 1] = weaponID
				if SetWatchProjectile then
					SetWatchProjectile(weaponID, true)
				else
					SetWatchWeapon(weaponID, true)
				end
			end
		end
	end
	for name, v in pairs(shieldCollide_names) do
		if WeaponDefNames[name] then
			local id = WeaponDefNames[name].id
			shieldCollide_id[id] = v
		end
	end
end

function gadget:Explosion_GetWantedWeaponDef()
	return wantedList
end

function gadget:ProjectileDestroyed(proID)
	local weapDefID=spGetProjectileDefID(proID)
	local teamID=spGetProjectileTeamID(proID)
	if spawn_defs_id[weapDefID] then
		if not noCreate[proID] then
			local x,y,z = spGetProjectilePosition(proID)
			local spawnDef = spawn_defs_id[weapDefID]
			if (spawnDef.feature and Spring.Utilities.IsValidPosition(x, z)) or 
					spUseTeamResource(teamID, "m", spawnDef.cost) then -- Should it be UseUnitResource? But what gonna happen if projection owner is dead?
				createList[#createList+1] = {
					name = spawnDef.name,
					team = teamID, 
					x = x,y = y,z = z, 
					expire = spawnDef.expire, 
					feature = spawnDef.feature
				}
				return false
			end
		else
			noCreate[proID] = nil
			return false
		end
	end
	return false
end

-- in event of shield impact, gets data about both units and passes it to UnitPreDamaged
function gadget:ShieldPreDamaged(proID, proOwnerID, shieldEmitterWeaponNum, shieldCarrierUnitID, bounceProjectile)
	
	if shieldCarrierUnitID and Spring.ValidUnitID(shieldCarrierUnitID) then
		local proDefID = Spring.GetProjectileDefID(proID)
		if proDefID and shieldCollide_id[proDefID] then
			local shieldOn,shieldCharge = spGetUnitShieldState(shieldCarrierUnitID)
			local damage = shieldCollide_id[proDefID].damage
			if shieldCharge < damage then
				return true
			end
			--Spring.SetUnitShieldState(shieldCarrierUnitID, -1, shieldCharge - shieldCollide_id[udid].gadgetDamage)
			noCreate[proID] = true
		end
	end
	return false
end


function gadget:UnitDestroyed(unitID, unitDefID, teamID, attackerID, attackerDefID, attackerTeamID)
	expireList[unitID] = nil
end


function gadget:GameFrame(f)
	for i = 1, #createList do -- converted into i from pairs
		local config = createList[i]
		if config.feature then
			local featureID = spCreateFeature(config.name , config.x, config.y, config.z, 0, config.team)
			local dir = vectorPolarToCart(1, 2*pi*random())
			spSetFeatureDirection(featureID, dir[1], 0 , dir[2])
		else
			local unitID = spCreateUnit(config.name , config.x, config.y, config.z, 0, config.team)
			-- Spring.SetUnitRulesParam(unitID, "parent_unit_id", c.owner)
			if (config.expire > 0) and unitID then 
				expireList[unitID] = f + config.expire * 32
			end
		end
		createList[i]=nil
	end
	if ((f+6)%64<0.1) then 
		for i, e in pairs(expireList) do
			if (f > e) then
				spDestroyUnit(i, true)
			end
		end
	end
end