--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
	return {
		name      = "Draw Mouse Build",
		desc      = "Draws build icons at the mouse position.",
		author    = "GoogleFrog, xponen",
		date      = "10 Novemember 2016",
		license   = "GNU GPL, v2 or later",
		layer     = 0,
		enabled   = true,
		handler   = true,

		api         = true,
		alwaysStart = true,
	}
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Local Variables

local unitDefID
local size
local count
local badX, badY, badRight, badBottom
local screenHeight

-- Speedups --
local glColor = gl.Color
local glTexture = gl.Texture
local glTexRect = gl.TexRect
local glText = gl.Text

local spGetMouseState = Spring.GetMouseState
local spGetWindowGeometry = Spring.GetWindowGeometry
local wgGetBuildIconFrame = WG.GetBuildIconFrame

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Draw Icon

local function DrawMouseIcon()
	if unitDefID then
		local mx,my,lmb = spGetMouseState()
		if not lmb then
			return
		end
		
		if mx > badX and mx < badRight and my > badY and my < badBottom then
			return
		end		
		
		glColor(1,1,1,0.5)
		glTexture(wgGetBuildIconFrame(UnitDefs[unitDefID])) --draw build icon on screen. Copied from gui_chili_gesture_menu.lua
		glTexRect(mx-size, my-size, mx+size, my+size)
		glTexture("#"..unitDefID)
		glTexRect(mx-size, my-size, mx+size, my+size)
		glTexture(false)
		glColor(1,1,1,1)
		if count > 1 then
			glText(count+1,mx-size*0.82, my+size*0.45,14,"")
		end
	end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- External Functions

local externalFunctions = {}

function externalFunctions.SetMouseIcon(newUnitDefID, newSize, newCount, bX, bY, bWidth, bHeight)
	unitDefID = newUnitDefID
	size = newSize
	count = newCount
	badX, badY, badRight, badBottom = bX, bY, bX + bWidth, bY + bHeight
	badY, badBottom = screenHeight - badBottom, screenHeight - badY
	widgetHandler:UpdateWidgetCallIn("DrawScreen", widget)
end

function externalFunctions.ClearMouseIcon()
	unitDefID = nil
	widgetHandler:RemoveWidgetCallIn("DrawScreen", widget)
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Widget Interface

function widget:ViewResize(viewSizeX, viewSizeY)
	screenHeight = viewSizeY
end

function widget:DrawScreen()
	DrawMouseIcon()
end

function widget:Initialize()
	screenHeight = select(2, spGetWindowGeometry())
	WG.DrawMouseBuild = externalFunctions
	widgetHandler:RemoveWidgetCallIn("DrawScreen", widget)
end
