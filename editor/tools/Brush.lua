
local Brush = Object:extend()

local mapSettings = require "editor.map-settings"
local edit = require "editor.edit"

local gridX, gridY = mapSettings.gridX, mapSettings.gridY

function Brush.postInit(self)
	self.viewport = self.tree:get("/GuiRoot/Interface/Viewport")
	edit.curTool = self
end

function Brush.drag(self)
	local tx, ty = edit.worldToTile(edit.cursorWX, edit.cursorWY)
	edit.curMap:setTile(tx, ty, edit.brushTile, true)
end

function Brush.click(self)
	local tx, ty = edit.worldToTile(edit.cursorWX, edit.cursorWY)
	edit.curMap:setTile(tx, ty, edit.brushTile, true)
end

function Brush.draw(self)
	if self.viewport.isHovered then
		love.graphics.setColor(1, 1, 1, 1)
		local tx, ty = edit.worldToTile(edit.cursorWX, edit.cursorWY)
		local x, y = edit.tileToWorld(tx, ty)
		love.graphics.rectangle("line", x - gridX/2, y - gridY/2, gridX, gridY)
		love.graphics.print(tx..", "..ty, edit.cursorWX + 50, edit.cursorWY)
	end
end

return Brush
