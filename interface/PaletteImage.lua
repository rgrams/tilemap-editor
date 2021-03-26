
local mapSettings = require "editor.map-settings"
local edit = require "editor.edit"

local script = {}

local function snapToGrid(lx, ly)
	local w, h = mapSettings.gridX, mapSettings.gridY
	local x, y = edit.roundToGrid(lx - w/2, ly - w/2)
	x, y = x + w/2, y + h/2
	return x, y
end

function script.postInit(self)
	self.palette = self.tree:get("/GuiRoot/Interface/Palette")
end

function script.draw(self)
	-- Draw cyan border around whole image.
	love.graphics.setColor(0, 1, 1, 1)
	love.graphics.rectangle("line", -self.ox-1, -self.oy-1, self.imgW+2, self.imgH+2)

	-- Draw the currently-selected tile.
	if edit.brushTile then
		love.graphics.setColor(1, 1, 0, 1)
		love.graphics.setLineWidth(3)
		local tx, ty = edit.paletteIndexToXY(edit.brushTile)
		local w, h = mapSettings.gridX, mapSettings.gridY
		local x, y = tx * w - w/2 - self.ox, ty * h - h/2 - self.oy
		love.graphics.rectangle("line", x - w/2, y - h/2, w, h)
		love.graphics.setLineWidth(1)
	end

	-- Draw a cursor, snapped to the grid.
	if self.palette.isHovered and self.lmx and self.lmy then
		love.graphics.setColor(1, 0.5, 0, 0.5)
		local w, h = mapSettings.gridX, mapSettings.gridY
		local x, y = snapToGrid(self.lmx, self.lmy)
		love.graphics.circle("line", x, y, 4, 4)
		love.graphics.rectangle("line", x - w/2, y - h/2, w, h)
	end
end

function script.mouseMoved(self, wx, wy)
	self.lmx, self.lmy = self:toLocal(wx, wy)
end

function script.click(self, wx, wy)
	self.lmx, self.lmy = self:toLocal(wx, wy)
	local x, y = snapToGrid(self.lmx, self.lmy)
	x, y = x + self.ox, y + self.oy
	local tx, ty = edit.worldToTile(x, y)
	local ti = edit.paletteTileToIndex(tx, ty)
	local maxTI = mapSettings.paletteWidth * mapSettings.paletteHeight
	if ti < 1 or ti > maxTI then  ti = nil  end
	edit.brushTile = ti
end

local function PaletteImage()
	local self = Sprite(mapSettings.imagePath)
	self.scripts = { script }
	self.layer = "palette"

	local pw, ph = self.imgW / mapSettings.gridX, self.imgH / mapSettings.gridY
	pw, ph = math.floor(pw), math.floor(ph)
	mapSettings.paletteWidth, mapSettings.paletteHeight = pw, ph

	return self
end

return PaletteImage
