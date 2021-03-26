
local Ruu = require "ruu.ruu"
local theme = require "interface.theme.theme"
local Panel = require "interface.widgets.Panel"
local Splitter = require "interface.widgets.Splitter"
local Palette = require "interface.Palette"
local Viewport = require "interface.Viewport"
local script = require "interface.Interface_script"

local function Interface()
	local ruu = Ruu(Input.get, theme)

	local self = mod(gui.Row():size(1600, 900):mode("fill", "fill"), { children = {
		Viewport(ruu),
		Splitter(ruu, "x", "/GuiRoot/Interface/Viewport", "/GuiRoot/Interface/Palette"),
		Palette(ruu)
	}, layer = "gui", name = "Interface", ruu = ruu, scripts = {script} })
	return self
end

return Interface
