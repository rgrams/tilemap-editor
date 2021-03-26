
local mapSettings = require "editor.map-settings"
local edit = require "editor.edit"

local function Map()
	local img, extrudeBorders = mapSettings.imagePath, mapSettings.extrudeBorders
	local gridX, gridY = mapSettings.gridX, mapSettings.gridY
	local self = Tilemap(img, 0, 0, 0, gridX, gridY, extrudeBorders)
	edit.curMap = self
	return self
end

return Map
