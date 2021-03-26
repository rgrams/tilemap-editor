
local M = {}

local mapSettings = require "editor.map-settings"

M.cursorWX, M.cursorWY = 0, 0
M.brushTile = 1
M.curTool = nil
M.curMap = nil

function M.roundToGrid(wx, wy)
	return math.round(wx, mapSettings.gridX), math.round(wy, mapSettings.gridY)
end

function M.worldToTile(wx, wy)
	return math.round((wx) / mapSettings.gridX), math.round((wy) / mapSettings.gridY)
end

function M.tileToWorld(tx, ty)
	return (tx) * mapSettings.gridX, (ty) * mapSettings.gridY
end

function M.paletteTileToIndex(tx, ty)
	local pw = mapSettings.paletteWidth
	return (ty - 1) * pw + tx
end

function M.paletteIndexToXY(ti)
	local tx = ti % mapSettings.paletteWidth
	local ty = math.floor(ti/mapSettings.paletteWidth) + 1
	return tx, ty
end

return M
