
local script = {}

local Cursor = require "editor.Cursor"
local mapSettings = require "editor.map-settings"
local edit = require "editor.edit"

local gridX, gridY = mapSettings.gridX, mapSettings.gridY

function script.init(self)
	print(self)
end

local function roundToGrid(wx, wy)
	return math.round(wx, gridX), math.round(wy, gridY)
end

local function worldToTile(wx, wy)
	return math.round((wx) / gridX), math.round((wy) / gridY)
end

local function tileToWorld(tx, ty)
	return (tx) * gridX, (ty) * gridY
end

function script.drag(self, sdx, sdy)
	local wdx, wdy = Camera.current:screenToWorld(sdx, sdy, true)
end

function script.click(self)
	print("Editor click")
	local tx, ty = worldToTile(edit.cursorWX, edit.cursorWY)
	print(tx, ty)
	self:setTile(tx, ty, edit.brushTile, true)
end

function script.draw(self)
	-- local x, y = roundToGrid(self.cursor.pos.x, self.cursor.pos.y)
	love.graphics.setColor(1, 1, 1, 1)
	local tx, ty = worldToTile(edit.cursorWX, edit.cursorWY)
	local x, y = tileToWorld(tx, ty)
	love.graphics.rectangle("line", x - gridX/2, y - gridY/2, gridX, gridY)
	love.graphics.print(tx..", "..ty, edit.cursorWX + 50, edit.cursorWY)
end

return script
