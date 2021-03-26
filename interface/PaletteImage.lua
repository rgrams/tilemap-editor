
local mapSettings = require "editor.map-settings"
local edit = require "editor.edit"

local script = {}

function script.draw(self)
	if self.lmx and self.lmy then
		love.graphics.setColor(1, 1, 0, 1)
		local w, h = mapSettings.gridX * self.zoom, mapSettings.gridY * self.zoom
		local x, y = self.lmx, self.lmy
		x = math.round(x, w) -- w/2
		y = math.round(y, h) -- h/2
		love.graphics.circle("line", x, y, 10, 20)
		love.graphics.rectangle("line", x - w/2, y - h/2, w, h)
	end
end

function script.mouseMoved(self, sx, sy)
	self.lmx, self.lmy = self:toLocal(sx, sy)
end

function script.click(self)
end

local function PaletteImage()
	local self = Sprite(mapSettings.imagePath)
	self.scripts = { script }
	self.layer = "palette"
	self.zoom = 1
	return self
end

return PaletteImage
