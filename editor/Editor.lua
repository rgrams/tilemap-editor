
local Editor = Object:extend()

local Commands = require "lib.commands"
local editCommands = require "commands.editor-commands"
local Map = require "editor.Map"
local DefaultTool = require "editor.tools.Brush"
local mapSettings = require "editor.map-settings"
local edit = require "editor.edit"
local serialize = require "lib.serialize"

local outputPath = "OUTPUT_TEST.lua"

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
	elseif action == "save" and change == 1 then
		print("Saving...")
		local t = love.timer.getTime()
		io.output(outputPath)
		io.write("\nlocal Map = ")
		local str = serialize(edit.curMap.map)
		io.write("\n\nreturn Map\n")
		io.output():close()
		t = math.round((love.timer.getTime() - t)*1000, 0.01)
		print("...Finished saving. Elapsed Time: "..t.." ms.")
	end
end

local function openAsImage(file, filename)
	print("Opening as an Image File")
	local result, errMsg = love.filesystem.newFileData(file:read("string"), filename)
	if not result then
		print(errMsg)
		return
	end
	local isSuccess, result = pcall(love.image.newImageData, result)
	if not isSuccess then
		print(result)
		return
	end
	local isSuccess, result = pcall(love.graphics.newImage, result)
	if not isSuccess then
		print(result)
		return
	end
	print(result)
	return result
end

local function openAsMap(file, filepath)
	print("Opening as a Map File")
	local success, map = pcall(dofile, filepath)
	if type(map) ~= "table" then  success = nil  end
	print(success, map)
	if success then
		for y,row in pairs(map) do
			if type(row) ~= "table" then  return  end
			for x,i in pairs(row) do
				if type(i) ~= "number" then  return  end
			end
		end
		return map
	end
end

function love.filedropped(file)
	file:open("r")
	local filepath = file:getFilename()
	print(filepath)
	local filename = filepath:match(".*[\\/](.-)$")
	print(filename)
	local result

	-- First try to load it as an image.
	result = openAsImage(file, filename)
	-- If successful, use it as the tile source image.
	if result then
		print("  Successfully loaded a tile source image.")
	else
		-- If image loading fails, try to load it as tile-map data.
		result = openAsMap(file, filepath)
		if result then
			print("  Successfully loaded a map.")
			edit.curMap.map = result
		else
			print("  Failed.")
		end
	end
	file:close()
end

return Editor
