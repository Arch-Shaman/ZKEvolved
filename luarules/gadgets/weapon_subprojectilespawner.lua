	function gadget:GetInfo()
		return {
			name      = "Cluster Ammunition Spawner",
			desc      = "Spawns subprojectiles",
			author    = "_Shaman",
			date      = "March 12, 2019",
			license   = "CC-0",
			layer     = 5,
			enabled   = true,
		}
	end

	--[[
		Expected customParams:
		{
			numprojectiles = int, -- how many of the weapondef we spawn. OPTIONAL. Default: 1.
			projectile = string, -- the weapondef name. we will convert this to an ID in init. REQUIRED. If defined in the unitdef, it will be unitdefname_weapondefname.
			keepmomentum = 1/0, -- should the projectile we spawn keep momentum of the mother projectile? OPTIONAL. Default: True
			spreadradius = num, -- used in clusters. OPTIONAL. Default: 100.
			clusterposition = string,
			clustervelocity = string,
			use2ddist = 1/0, -- should we check 2d or 3d distance? OPTIONAL. Default: 0.
			spawndist = num, -- at what distance should we spawn the projectile(s)? REQUIRED.
			soundspawn = file, -- file to play when we spawn the projectiles. OPTIONAL. Default: None.
			timeoutspawn = 1/0, -- Can this missile spawn its subprojectiles when it times out? OPTIONAL. Default: 1.
			vradius = num, -- velocity that is randomly added. covers range of +-vradius. OPTIONAL. Default: 4.2
			groundimpact = 1/0 -- check the distance between ground and projectile? OPTIONAL.
			proxy = 1/0 -- check for nearby units?
			proxydist = num, -- how far to check for units? Default: spawndist
		}
	]]

	if not gadgetHandler:IsSyncedCode() then -- no unsynced nonsense
		return
	end

	--Speedups--
	local spEcho = Spring.Echo
	local spGetGameFrame = Spring.GetGameFrame
	local spGetProjectilePosition = Spring.GetProjectilePosition
	local spGetProjectileTarget = Spring.GetProjectileTarget
	local spGetProjectileTimeToLive = Spring.GetProjectileTimeToLive
	local spGetGroundHeight = Spring.GetGroundHeight
	local spDeleteProjectile = Spring.DeleteProjectile
	local spGetProjectileOwnerID = Spring.GetProjectileOwnerID
	local spGetProjectileVelocity = Spring.GetProjectileVelocity
	local spGetUnitTeam = Spring.GetUnitTeam
	local spPlaySoundFile = Spring.PlaySoundFile
	local spSpawnExplosion = Spring.SpawnExplosion
	local spSpawnProjectile = Spring.SpawnProjectile
	local spGetFeaturePosition = Spring.GetFeaturePosition
	local spGetUnitPosition = Spring.GetUnitPosition
	local spGetUnitsInCylinder = Spring.GetUnitsInCylinder
	local spGetUnitsInSphere = Spring.GetUnitsInSphere
	local spSetProjectileTarget = Spring.SetProjectileTarget
	local spSetProjectileIgnoreTrackingError = Spring.SetProjectileIgnoreTrackingError
	local spGetProjectileDefID = Spring.GetProjectileDefID
	local spAreTeamsAllied = Spring.AreTeamsAllied
	local spGetUnitIsCloaked = Spring.GetUnitIsCloaked
	local SetWatchWeapon = Script.SetWatchWeapon
	local spSetProjectileAlwaysVisible = Spring.SetProjectileAlwaysVisible
	local random = math.random
	local sqrt = math.sqrt
	local byte = string.byte
	local abs = math.abs
	local pi = math.pi
	local strfind = string.find


	--variables--
	local config = {} -- projectile configuration data
	local projectileattributes = {pos = {0,0,0}, speed = {0,0,0}, owner = 0, team = 0, ttl= 0,gravity = 0,tracking = tracks,} -- optimization
	local projectiles = {} -- stuff we need to act on.
	local debug = false
	-- functions --
	local function distance3d(x1,y1,z1,x2,y2,z2)
		return sqrt(((x2-x1)*(x2-x1))+((y2-y1)*(y2-y1))+((z2-z1)*(z2-z1)))
	end


	spEcho("CAS: Scanning weapondefs")

	for i=1, #WeaponDefs do
		local wd = WeaponDefs[i]
		local curRef = wd.customParams -- hold table for referencing
		if curRef and curRef.projectile then -- found it!
			spEcho("CAS: Discovered " .. i .. "(" .. wd.name .. ")")
			if type(curRef.projectile) == "string" then -- reason we use it like this is to provide an error if something doesn't seem right.
				if WeaponDefNames[curRef.projectile] then
					if type(curRef.spawndist) == "string" then -- all ok
						SetWatchWeapon(i, true)
						if debug then spEcho("CAS: Enabled watch for " .. i) end
						config[i] = {}
						if wd.type == "AircraftBomb" then
							config[i]["isBomb"] = true
						else
							config[i]["isBomb"] = false
						end
						config[i]["projectile"] = WeaponDefNames[curRef.projectile].id -- transform into an id
						config[i]["spawndist"] = tonumber(curRef.spawndist)
						if type(curRef.timeoutspawn) ~= "string" then
							config[i]["timeoutspawn"] = 1
						else
							config[i]["timeoutspawn"] = tonumber(curRef.timeoutspawn)
						end
						if type(curRef.numprojectiles) ~= "string" then
							config[i]["numprojectiles"] = 1
						else
							config[i]["numprojectiles"] = tonumber(curRef.numprojectiles)
						end
						if type(curRef.use2ddist) ~= "string" then
							config[i]["use2ddist"] = 0
							spEcho("CAS: Set 2ddist to false for " .. name)
						else
							config[i]["use2ddist"] = tonumber(curRef.use2ddist)
						end
						if type(curRef.keepmomentum) ~= "string" then
							config[i]["keepmomentum"] = 1
						else
							config[i]["keepmomentum"] = tonumber(curRef.keepmomentum)
						end
						if type(curRef.spreadradius) ~= "string" then
							config[i]["spreadradius"] = 100
						else
							config[i]["spreadradius"] = tonumber(curRef.spreadradius)
						end
						if type(curRef.vradius) ~= "string" then
							config[i]["vradius"] = 4.2
						else
							config[i]["vradius"] = curRef.vradius
						end
						if type(curRef.proxy) ~= "string" then
							config[i]["proxy"] = 0
						else
							config[i]["proxy"] = tonumber(curRef.proxy)
						end
						if type(curRef.proxydist) ~= "string" then
							config[i]["proxydist"] = config[i]["spawndist"]
						else
							config[i]["proxydist"] = tonumber(curRef.proxydist)
						end
						if type(curRef.clusterpos) ~= "string" then
							config[i]["clusterpos"] = "no"
						else
							config[i]["clusterpos"] = curRef.clusterpos
						end
						if type(curRef.clustervec) ~= "string" then
							config[i]["clustervec"] = "no"
						else
							config[i]["clustervec"] = curRef.clustervec
						end
						if type(curRef.clusternuke) ~= "string" then
							config[i]["clusternuke"] = false
						else
							config[i]["clusternuke"] = true
						end
						if type(curRef.useheight) ~= "string" then
							config[i]["useheight"] = 0
						else
							config[i]["useheight"] = tonumber(curRef.useheight)
						end
					else
						spEcho("Error: " .. i .. "(" .. WeaponDefs[i].name .. "): spawndist is not present.")
					end
				else
					spEcho("Error: " .. i .. "( " .. WeaponDefs[i].name .. "): subprojectile is not a valid weapondef name.")
				end
			else
				spEcho("Error: " .. i .. "( " .. WeaponDefs[i].name .. "): subprojectile is not a string.")
			end
		end
		wd = nil
		curRef = nil
	end
	spEcho("CAS: done.")

	local function unittest(tab,self)
		if #tab == 0 or (#tab == 1 and tab[1] == self) then
			return false
		end
		for i=1, #tab do
			if not spAreTeamsAllied(spGetUnitTeam(tab[i]),spGetUnitTeam(self)) and not spGetUnitIsCloaked(tab[i]) then -- condition: enemy unit that isn't cloaked.
				return true
			end
		end
		return false
	end

	if debug then 
		for name,data in pairs(config) do
			spEcho(name .. " : ON")
			for k,v in pairs(data) do
				spEcho(k .. " = " .. tostring(v))
			end
		end 
	end

	local function distance2d(x1,y1,x2,y2)
		return sqrt(((x2-x1)*(x2-x1))+((y2-y1)*(y2-y1)))
	end

	local function RegisterSubProjectiles(p,me)
		if config[me] then
			projectiles[p] = me
			if config[me]["clusternuke"] then
				spSetProjectileAlwaysVisible(p,true)
			end
		end
	end

	function gadget:ProjectileCreated(proID, proOwnerID, weaponDefID)
		--spEcho("ProjectileCreated: " .. tostring(proID, proOwnerID, weaponDefID))
		if weaponDefID == nil then
			weaponDefID = spGetProjectileDefID(proID)
		end
		if config[weaponDefID] then
			projectiles[proID] = weaponDefID 
			if config[weaponDefID]["clusternuke"] then
				spSetProjectileAlwaysVisible(proID,true)
			end
		end
	end

	local function SpawnSubProjectiles(id, wd)
		if debug then spEcho("Fire the submunitions!") end
		local x,y,z = spGetProjectilePosition(id)
		local vx,vy,vz = spGetProjectileVelocity(id)
		local ttype,target = spGetProjectileTarget(id)
		local r = config[wd]["spreadradius"]
		local vr = config[wd]["vradius"]
		local me = config[wd]["projectile"]
		local step = (2*vr)/config[wd]["numprojectiles"]
		spEcho(tostring(config[wd].clusterpos),tostring(config[wd].clustervec))
		spEcho(tostring(step))
		local positioning = config[wd].clusterpos or "none"
		local vectoring = config[wd].clustervec or "none"
		-- update projectile attributes --
		projectileattributes["gravity"] = -WeaponDefs[wd].myGravity or -1
		projectileattributes["owner"] = spGetProjectileOwnerID(id)
		projectileattributes["team"] = spGetUnitTeam(projectileattributes["owner"])
		projectileattributes["ttl"] = WeaponDefs[wd].flightTime
		projectileattributes["tracking"] = WeaponDefs[wd].tracks or false
		projectileattributes["pos"][1] = x
		projectileattributes["pos"][2] = y
		projectileattributes["pos"][3] = z
		projectileattributes["speed"][1] = vx
		projectileattributes["speed"][2] = vy
		projectileattributes["speed"][3] = vz
		projectileattributes["tracking"] = tracks
		-- create the explosion --
		spSpawnExplosion(x,y,z,0,0,0,{weaponDef = wd, owner = spGetProjectileOwnerID(id), craterAreaOfEffect = WeaponDefs[wd].craterAreaOfEffect, damageAreaOfEffect = WeaponDefs[wd].damageAreaOfEffect, edgeEffectiveness = WeaponDefs[wd].edgeEffectiveness, explosionSpeed = WeaponDefs[wd].explosionSpeed, impactOnly = WeaponDefs[wd].impactOnly, ignoreOwner = WeaponDefs[wd].noSelfDamage, damageGround = true})
		spPlaySoundFile(WeaponDefs[wd].hitSound[1].name,WeaponDefs[wd].hitSound[1].volume,x,y,z)
		spDeleteProjectile(id)
		-- Create the projectiles --
		for i=1, config[wd]["numprojectiles"] do
			local p
			if strfind(positioning,"random") then
				if strfind(positioning,"x") then
					projectileattributes["pos"][1] = x+random(-r,r)
				end
				if strfind(positioning,"y") then
					projectileattributes["pos"][2] = y+random(-r,r)
				end
				if strfind(positioning,"z") then
					projectileattributes["pos"][3] = z+random(-r,r)
				end
			end
			if strfind(vectoring,"random") then
				if strfind(vectoring,"x") then
					projectileattributes["speed"][1] = vx+random(-vr,vr)
				end
				if strfind(vectoring,"y") then
					projectileattributes["speed"][2] = vy+random(-vr,vr)
				end
				if strfind(vectoring,"z") then
					projectileattributes["speed"][3] = vz+random(-vr,vr)
				end
			elseif strfind(vectoring,"even") then
				if strfind(vectoring,"x") then
					projectileattributes["speed"][1] = vx+(-vr+(step*(i-1)))
				end
				if strfind(vectoring,"y") then
					projectileattributes["speed"][2] = vy+(-vr+(step*(i-1)))
				end
				if strfind(vectoring,"z") then
					projectileattributes["speed"][3] = vz+(-vr+(step*(i-1)))
				end
			end
			if debug then spEcho("Projectile Speed: " .. projectileattributes["speed"][1],projectileattributes["speed"][2],projectileattributes["speed"][3]) end
			p = spSpawnProjectile(me, projectileattributes)
			if ttype ~= byte("g") then
				if debug then spEcho("setting target for " .. p .. " = " .. target) end
				spSetProjectileTarget(p, target,ttype)
			end
			RegisterSubProjectiles(p,me)
		end
	end

	local function CheckProjectile(id)
		local wd = spGetProjectileDefID(id)
		if wd == nil or wd ~= projectiles[id] then
			projectiles[id] = nil
			return
		end
		local isMissile = false -- check for missile status. When the missile times out, the subprojectiles will be spawned if allowed.
		if WeaponDefs[wd]["flightTime"] ~= nil and WeaponDefs[wd].type == "Missile" then
			isMissile = true
		end
		--spEcho("CheckProjectile: " .. id .. ", " .. wd)
		if isMissile and debug then spEcho("ttl: " .. spGetProjectileTimeToLive(id)) end
		if isMissile and config[wd].timeoutspawn and spGetProjectileTimeToLive(id) == 0 then
			SpawnSubProjectiles(id,wd)
		end
		local use3d = (config[wd].use2ddist == 0)
		local distance
		local x2,y2,z2 = spGetProjectilePosition(id)
		local x1,y1,z1
		local vx,vy,vz = spGetProjectileVelocity(id)
		local targettype,targetID,targetPos = spGetProjectileTarget(id)
		if debug then spEcho("Attack type: " .. targettype) ; spEcho("Target: " .. tostring(targetID)) end
		if config[wd].useheight then -- this spawns at the selected height when vy < 0
			if y2 - spGetGroundHeight(x2,z2) < config[wd].spawndist and vy < 0 then
				SpawnSubProjectiles(id,wd)
			else
				return
			end
		end
		if targettype == byte("g") then -- this is an undocumented case. Aircraft bombs when targeting ground returns 103 or byte(49).
			x1 = targetID[1]
			y1 = targetID[2]
			z1 = targetID[3]
			if debug then spEcho(x1,y1,z1) end
		elseif targettype == 103 then
			x1 = x2
			y1 = spGetGroundHeight(x2,z2)
			z1 = z2
		elseif targettype == byte("u") then
			x1,y1,z1 = spGetUnitPosition(targetID)
		elseif targettype == byte("f") then
			x1,y1,z1 = spGetFeaturePosition(targetID)
		elseif targettype == byte("p") then
			x1,y1,z1 = spGetProjectilePosition(targetID)
		end
		if use3d then
			distance = distance3d(x2,y2,z2,x1,y1,z1)
		else
			distance = distance2d(x2,z2,x1,z1)
		end
		local height = y2 - spGetGroundHeight(x2,z2)
		if debug then spEcho("d: " .. distance .. "\nisBomb: " .. tostring(config[wd]["isBomb"]) .. "\nVelocity: (" .. vx,vy,vz .. ")" .. "\nH: " .. height .. "\nexplosion dist: " .. height - config[wd].spawndist) end
		if distance < config[wd].spawndist and not config[wd]["isBomb"] then -- bombs ignore distance and explode based on height. This is due to bomb ground attacks being absolutely fucked in current spring build.
			SpawnSubProjectiles(id,wd)
			if debug then spEcho("distance") end
		elseif config[wd]["isBomb"] and height <= config[wd].spawndist then
			SpawnSubProjectiles(id,wd)
			if debug then spEcho("bomb engage") end
		elseif config[wd].groundimpact == 1 and vy < -1 and height <= config[wd].spawndist then
			if debug then spEcho("ground impact") end
			SpawnSubProjectiles(id,wd)
		elseif config[wd]["proxy"] == 1 then
			local units
			if use3d then
				units = spGetUnitsInSphere(x2,y2,z2,config[wd]["proxydist"])
			else 
				units = spGetUnitsInCylinder(x2,z2,config[wd]["proxydist"])
			end
			if unittest(units,spGetProjectileOwnerID(id)) == true then
				if debug then spEcho("Unit passed unittest. Passed to SpawnSubProjectiles") end
				SpawnSubProjectiles(id,wd)
			end
		end
	end

	function gadget:GameFrame(f)
		if f%5 == 4 then
			for id,_ in pairs(projectiles) do
				CheckProjectile(id)
			end
		end
	end