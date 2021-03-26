
local script = {}

local edit = require "editor.edit"

function script.init(self)
	self.mapCam = self.tree:get("/MapCamera")
end

function script.drag(self, dx, dy, dragType)
	if dragType == "pan" then
		local wdx, wdy = self.mapCam:screenToWorld(dx, dy, true)
		local pos = self.mapCam.pos
		pos.x, pos.y = pos.x - wdx, pos.y - wdy
	end
end

local zoomRate = 0.1

function script.ruuinput(self, action, value, change)
	-- print("Viewport.ruuinput", action, value)
	if action == "mouseMoved" then
		local msx, msy = love.mouse.getPosition()
		local mwx, mwy = self.mapCam:screenToWorld(msx, msy)
		edit.cursorWX, edit.cursorWY = mwx, mwy
		if Input.get("click") == 1 then
			self.tree:get("/Editor"):call("drag")
		end
	elseif action == "click" and change == 1 then
		self.tree:get("/Editor"):call("click")
	elseif action == "pan" and change == 1 then
		self.ruu:startDrag(self, "pan")
	elseif action == "zoomIn" and change == 1 then
		local msx, msy = love.mouse.getPosition()
		self.mapCam:zoomIn(zoomRate, msx, msy)
	elseif action == "zoomOut" and change == 1 then
		local msx, msy = love.mouse.getPosition()
		self.mapCam:zoomIn(-zoomRate, msx, msy)
	end
end

function script.allocate(self, alloc)
	local x, y = 0, 0
	self.mapCam = self.mapCam or self.tree:get("/MapCamera")
	self.mapCam:setViewport(x, y, self.w, self.h)
end

local function Viewport(ruu)
	local self = gui.Node():size(1200, 900):mode("fill", "fill")
	self.ruu = ruu
	self.ruu:makePanel(self, true)
	self.name = "Viewport"
	self.isGreedy = true
	self.isDraggable = true
	self.scripts = { script }
	return self
end

return Viewport
