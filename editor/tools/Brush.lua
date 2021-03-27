
local Brush = Object:extend()

local mapSettings = require "editor.map-settings"
local edit = require "editor.edit"

local gridX, gridY = mapSettings.gridX, mapSettings.gridY

function Brush.postInit(self)
	self.viewport = self.tree:get("/GuiRoot/Interface/Viewport")
end

function Brush.drag(self)
	local tx, ty = edit.worldToTile(edit.cursorWX, edit.cursorWY)
	if edit.curMap:getTile(tx, ty, true) ~= edit.brushTile then
		edit.cmd:perform("setTile", tx, ty, edit.brushTile, true)
	end
end

function Brush.click(self)
	local tx, ty = edit.worldToTile(edit.cursorWX, edit.cursorWY)
	edit.cmd:perform("setTile", tx, ty, edit.brushTile, true)
end

function Brush.draw(self)
	if self.viewport.isHovered then
		local tx, ty = edit.worldToTile(edit.cursorWX, edit.cursorWY)
		local x, y = edit.tileToWorld(tx, ty)
		x, y = x - gridX/2, y - gridY/2

		-- Draw tile preview.
		if edit.brushTile then
			love.graphics.setColor(1, 1, 1, 0.5)
			local img, quad = edit.curMap.image, edit.curMap.quads[edit.brushTile]
			love.graphics.draw(img, quad, x, y, nil, nil, nil, ox, oy)
		else -- Nil tile brush / eraser.
			local r, g, b, a = love.graphics.getBackgroundColor()
			love.graphics.setColor(r, g, b, 0.5)
			love.graphics.rectangle("fill", x, y, gridX, gridY)
		end

		-- Draw tile outline.
		love.graphics.setColor(1, 1, 1, 1)
		love.graphics.rectangle("line", x, y, gridX, gridY)
		love.graphics.print(tx..", "..ty, edit.cursorWX + 50, edit.cursorWY)

	end
end

return Brush
