
local Panel = require "interface.widgets.Panel"
local PaletteImage = require "interface.PaletteImage"

local script = {}

function script.init(self)
	self.paletteCam = self.tree:get("/PaletteCamera")

	local root = self.tree:get("/GameManager")
	self.tree:add(PaletteImage(), root)
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
	-- print("Palette.ruuinput", action, value)
	if action == "mouseMoved" then
		local sx, sy = love.mouse.getPosition()
		-- self.tileImage:call("mouseMoved", sx, sy)
	elseif action == "click" and change == 1 then
		local sx, sy = love.mouse.getPosition()
		-- self.tileImage:call("click", sx, sy)
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
	local winW, winH = love.window.getMode()
	local x, y = winW - self.w, winH - self.h
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
	-- self.mask = gui.Mask():mode("fill", "fill")
	-- self.tileImage = PaletteImage()
	-- self.mask.children = { self.tileImage }
	-- self.children = { self.mask }
	-- self.imgW, self.imgH = self.tileImage.w, self.tileImage.h
	self.zoom = 1
	return self
end

return Palette
