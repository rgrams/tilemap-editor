
local script = {}

local edit = require "editor.edit"

function script.postInit(self)
	self.mapCam = self.tree:get("/MapCamera")
end

local function updateEditorCursorPos(self)
	local sx, sy = love.mouse.getPosition()
	local wx, wy = self.mapCam:screenToWorld(sx, sy)
	edit.cursorWX, edit.cursorWY = wx, wy
end

function script.drag(self, dx, dy, dragType)
	if dragType == "pan" then
		local wdx, wdy = self.mapCam:screenToWorld(dx, dy, true)
		local pos = self.mapCam.pos
		pos.x, pos.y = pos.x - wdx, pos.y - wdy
	elseif dragType == nil then
		updateEditorCursorPos(self)
		if edit.curTool then  edit.curTool:call("drag")  end
	end
end

local zoomRate = 0.1

function script.ruuinput(self, action, value, change)
	if action == "mouseMoved" then
		updateEditorCursorPos(self)
	elseif action == "click" and change == 1 then
		if edit.curTool then  edit.curTool:call("click")  end
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
	local kx, ky = 0.5 + self.px/2, 0.5 + self.py/2
	local x, y = -self.w * kx, -self.h * ky
	self.parent:updateTransform()
	self:updateTransform()
	x, y = self:toWorld(x, y)

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
