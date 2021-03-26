
local Editor = Object:extend()

local Commands = require "lib.commands"
local editCommands = require "commands.editor-commands"
local Map = require "editor.Map"
local DefaultTool = require "editor.tools.Brush"
local mapSettings = require "editor.map-settings"
local edit = require "editor.edit"

function Editor.init(self)
	edit.cmd = Commands(editCommands)
	edit.curMap = self.tree:add(Map())
	edit.curTool = self.tree:add(DefaultTool())
	Input.enable(self)
end

function Editor.final(self)
	Input.disable(self)
end

function Editor.postInit(self)
	self.viewport = self.tree:get("/GuiRoot/Interface/Viewport")
end

function Editor.input(self, action, value, change, rawChange, isRepeat, ...)
	if action == "undo/redo" and (change == 1 or isRepeat) then
		if Input.get("shift") == 1 then
			edit.cmd:redo()
		else
			edit.cmd:undo()
		end
	end
end

return Editor
