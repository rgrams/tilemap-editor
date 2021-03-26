
local M = {}

local edit = require "editor.edit"

local function setTile(tx, ty, ti, isRounded)
	if ti == false then  ti = nil  end
	local oldIdx = edit.curMap:getTile(tx, ty, isRounded)
	if not oldIdx then  oldIdx = false  end
	edit.curMap:setTile(tx, ty, ti, isRounded)
	return tx, ty, oldIdx, isRounded
end

M.setTile = { setTile, setTile }

return M
