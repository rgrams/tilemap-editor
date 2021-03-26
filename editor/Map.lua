
local mapSettings = require "editor.map-settings"

local function Map()
	local img, extrudeBorders = mapSettings.imagePath, mapSettings.extrudeBorders
	local gridX, gridY = mapSettings.gridX, mapSettings.gridY
	local self = Tilemap(img, 0, 0, 0, gridX, gridY, extrudeBorders)
	return self
end

return Map
