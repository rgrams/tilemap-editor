
local script = {}

local mapSettings = require "editor.map-settings"
local edit = require "editor.edit"

local gridX, gridY = mapSettings.gridX, mapSettings.gridY

function script.drag(self)
	local tx, ty = edit.worldToTile(edit.cursorWX, edit.cursorWY)
	self:setTile(tx, ty, edit.brushTile, true)
end

function script.click(self)
	local tx, ty = edit.worldToTile(edit.cursorWX, edit.cursorWY)
	self:setTile(tx, ty, edit.brushTile, true)
end

function script.draw(self)
	love.graphics.setColor(1, 1, 1, 1)
	local tx, ty = edit.worldToTile(edit.cursorWX, edit.cursorWY)
	local x, y = edit.tileToWorld(tx, ty)
	love.graphics.rectangle("line", x - gridX/2, y - gridY/2, gridX, gridY)
	love.graphics.print(tx..", "..ty, edit.cursorWX + 50, edit.cursorWY)
end

return script
