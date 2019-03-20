include "constants.lua"
VFS.Include("LuaRules/Configs/customcmds.h.lua")

--pieces
local base = piece "base"
local wingR, wingL, wingtipR, wingtipL = piece("wingr", "wingl", "wingtip1", "wingtip2")
local engineR, engineL, thrust1, thrust2, thrust3 = piece("jetr", "jetl", "thrust1", "thrust2", "thrust3")
local missR, missL = piece("m1", "m2")

local smokePiece = {base, engineL, engineR}

--constants

--variables
local gun = false

local RESTORE_DELAY = 250
local FIRE_SLOWDOWN = tonumber(UnitDef.customParams.combat_slowdown)

--signals
local SIG_Aim = 1
local SIG_RESTORE = 2

-- Speedups --
local spGetUnitRulesParam = Spring.GetUnitRulesParam
local spGetUnitStates = Spring.GetUnitStates
local spSetUnitRulesParam = Spring.SetUnitRulesParam
local spGiveOrderToUnit = Spring.GiveOrderToUnit
local spGetUnitMoveTypeData = Spring.GetUnitMoveTypeData

----------------------------------------------------------

local function getState()
	local state = spGetUnitStates(unitID)
	return state and state.active
end

function script.Create()
	Turn(thrust1, x_axis, -math.rad(90), 1)
	Turn(thrust2, x_axis, -math.rad(90), 1)
	StartThread(SmokeUnit, smokePiece)
end

function script.StartMoving()
	Turn(engineL, z_axis, -1.57, 1)
	Turn(engineR, z_axis, 1.57, 1)
	Turn(engineL, y_axis, -1.57, 1)
	Turn(engineR, y_axis, 1.57, 1)
	Turn(engineL, x_axis, 0, 1)
	Turn(engineR, x_axis, 0, 1)
end

function script.StopMoving()
	Turn(engineL, z_axis, 0, 1)
	Turn(engineR, z_axis, 0, 1)
	Turn(engineL, y_axis, 0, 1)
	Turn(engineR, y_axis, 0, 1)
	Turn(engineL, x_axis, 0, 1)
	Turn(engineR, x_axis, 0, 1)
end

function script.QueryWeapon(num)
	if gun then 
		return missR
	else 
		return missL 
	end
end

function script.AimFromWeapon(num)
	return base 
end

function script.AimWeapon(num, heading, pitch)
	if num ~= 3 then -- allow minigun to fire.
		return not (GetUnitValue(COB.CRASHING) == 1)
	end
end

function script.Shot(num)
	gun = not gun
end

local function RestoreAfterDelay()
	Signal(SIG_RESTORE)
	SetSignalMask(SIG_RESTORE)
	
	if getState() then
		Turn(engineL, z_axis, -1.2, 1)
		Turn(engineR, z_axis, 1.2, 1)
		Turn(engineL, y_axis, -1.2, 1)
		Turn(engineR, y_axis, 1.2, 1)
		Turn(engineL, x_axis, 0.6, 1)
		Turn(engineR, x_axis, 0.6, 1)
	end
	Sleep(RESTORE_DELAY)
	spGetUnitRulesParam(unitID, "selfMoveSpeedChange", 1)
	spGetUnitRulesParam(unitID, "selfTurnSpeedChange", 1)

	-- Don't ask me why this must be called twice for planes, Spring is crazy
	GG.UpdateUnitAttributes(unitID)
	GG.UpdateUnitAttributes(unitID)
	
	
	if getState() then
		script.StartMoving()
	else
		script.StopMoving()
	end
end

function script.BlockShot(num)
	if GetUnitValue(CRASHING) == 1 then
		return true
	else
		if spGetUnitRulesParam(unitID, "selfMoveSpeedChange") ~= FIRE_SLOWDOWN then
			spSetUnitRulesParam(unitID, "selfMoveSpeedChange", FIRE_SLOWDOWN)
			spSetUnitRulesParam(unitID, "selfTurnSpeedChange", 1/FIRE_SLOWDOWN)
			GG.UpdateUnitAttributes(unitID)
		end
		StartThread(RestoreAfterDelay)
		return false
	end
end

function OnLoadGame()
	spSetUnitRulesParam(unitID, "selfMoveSpeedChange", 1)
	spSetUnitRulesParam(unitID, "selfTurnSpeedChange", 1)
	GG.UpdateUnitAttributes(unitID)
end

function script.Killed(recentDamage, maxHealth)
	local severity = recentDamage/maxHealth
	if severity < 0.25 then
		Explode(base, sfxNone)
		Explode(wingL, sfxNone)
		Explode(wingR, sfxNone)
		return 1
	elseif severity < 0.5 or (spGetUnitMoveTypeData(unitID).aircraftState == "crashing") then
		Explode(base, sfxNone)
		Explode(engineL, sfxSmoke)
		Explode(engineR, sfxSmoke)
		Explode(wingL, sfxNone)
		Explode(wingR, sfxNone)
		return 1
	elseif severity < 0.75 then
		Explode(engineL, sfxSmoke + sfxFire + sfxExplode)
		Explode(engineR, sfxSmoke + sfxFire + sfxExplode)
		Explode(wingL, sfxFall + sfxSmoke)
		Explode(wingR, sfxFall + sfxSmoke)
		return 2
	else
		Explode(base, sfxShatter)
		Explode(engineL, sfxSmoke + sfxFire + sfxExplode)
		Explode(engineR, sfxSmoke + sfxFire + sfxExplode)
		Explode(wingL, sfxSmoke + sfxExplode)
		Explode(wingR, sfxSmoke + sfxExplode)
		return 2
	end
end
