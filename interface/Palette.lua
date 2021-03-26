
local Panel = require "interface.widgets.Panel"

local script = {}

function script.drag(self, dx, dy, dragType)
	self.tileImage.imgOX = self.tileImage.imgOX - dx / self.zoom
	self.tileImage.imgOY = self.tileImage.imgOY - dy / self.zoom
end

local zoomRate = 0.1

local function zoom(self, zoomIn)
	local z = 1 + (zoomIn and zoomRate or -zoomRate)
	local s = self.tileImage.sx * z
	self.zoom = self.zoom * z
	self.tileImage:size(self.imgW*self.zoom, self.imgH*self.zoom, true)
end

function script.ruuinput(self, action, value, change)
	-- print("Palette.ruuinput", action, value)
	if action == "mouseMoved" then

	elseif action == "pan" and change == 1 then
		self.ruu:startDrag(self, "pan")
	elseif action == "zoomIn" and change == 1 then
		zoom(self, true)
	elseif action == "zoomOut" and change == 1 then
		zoom(self, false)
	end
end

local function Palette(ruu)
	local self = Panel(ruu):size(400, 900):mode("fill", "fill")
	self.name = "Palette"
	self.isGreedy = true
	self.isDraggable = true
	self.scripts = { script }
	self.mask = gui.Mask():mode("fill", "fill")
	self.tileImage = gui.Sprite("common/tex/Tiles_2.png")
	self.mask.children = { self.tileImage }
	self.children = { self.mask }
	self.imgW, self.imgH = self.tileImage.w, self.tileImage.h
	self.zoom = 1
	return self
end

return Palette
