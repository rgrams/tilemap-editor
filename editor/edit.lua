
local M = {}

local mapSettings = require "editor.map-settings"

M.cursorWX, M.cursorWY = 0, 0
M.brushTile = 1

function M.roundToGrid(wx, wy)
	return math.round(wx, mapSettings.gridX), math.round(wy, mapSettings.gridY)
end

function M.worldToTile(wx, wy)
	return math.round((wx) / mapSettings.gridX), math.round((wy) / mapSettings.gridY)
end

function M.tileToWorld(tx, ty)
	return (tx) * mapSettings.gridX, (ty) * mapSettings.gridY
end

return M
