
local Panel = require "interface.widgets.Panel"
local PaletteImage = require "interface.PaletteImage"

local script = {}

function script.postInit(self)
	self.paletteCam = self.tree:get("/PaletteCamera")
end

function script.init(self)
	self.paletteImg = self.tree:add(PaletteImage())
end

function script.drag(self, dx, dy, dragType)
	if dragType == "pan" then
		local wdx, wdy = self.paletteCam:screenToWorld(dx, dy, true)
		local pos = self.paletteCam.pos
		pos.x, pos.y = pos.x - wdx, pos.y - wdy
	end
end

local zoomRate = 0.1

function script.ruuinput(self, action, value, change)
	if action == "mouseMoved" then
		local wx, wy = self.paletteCam:screenToWorld(love.mouse.getPosition())
		self.paletteImg:call("mouseMoved", wx, wy)
	elseif action == "click" and change == 1 then
		local wx, wy = self.paletteCam:screenToWorld(love.mouse.getPosition())
		self.paletteImg:call("click", wx, wy)
	elseif action == "pan" and change == 1 then
		self.ruu:startDrag(self, "pan")
	elseif action == "zoomIn" and change == 1 then
		local msx, msy = love.mouse.getPosition()
		self.paletteCam:zoomIn(zoomRate, msx, msy)
	elseif action == "zoomOut" and change == 1 then
		local msx, msy = love.mouse.getPosition()
		self.paletteCam:zoomIn(-zoomRate, msx, msy)
	end
end

function script.allocate(self, alloc)
	local kx, ky = 0.5 + self.px/2, 0.5 + self.py/2
	local x, y = -self.w * kx, -self.h * ky
	self.parent:updateTransform()
	self:updateTransform()
	x, y = self:toWorld(x, y)

	self.paletteCam = self.paletteCam or self.tree:get("/PaletteCamera")
	self.paletteCam:setViewport(x, y, self.w, self.h)
end

local function Palette(ruu)
	local self = gui.Node():size(400, 900):mode("fill", "fill")
	self.ruu = ruu
	self.ruu:makePanel(self, true)
	self.isGreedy = true
	self.name = "Palette"
	self.isDraggable = true
	self.scripts = { script }
	return self
end

return Palette
