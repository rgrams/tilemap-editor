
local mapSettings = require "editor.map-settings"
local editor_script = require "editor.Editor_script"

local function Editor()
	local img, extrudeBorders = mapSettings.imagePath, mapSettings.extrudeBorders
	local gridX, gridY = mapSettings.gridX, mapSettings.gridY
	local self = Tilemap(img, 0, 0, 0, gridX, gridY, extrudeBorders)
	self.name = "Editor"
	self.scripts = { editor_script }
	return self
end

return Editor
