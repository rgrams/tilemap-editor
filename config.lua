
local M = {}

M.drawLayers = {
	world = { "default" },
	palette = { "palette", },
	debug = { "debug" },
	gui = { "text", "widgets", "gui", "panel" },
	guiDebug = { "guiDebug" },
}
M.defaultDrawLayer = "default"

M.physicsCategoryNames = {
}

M.menuList = {
	main = require "interface.menus.MainMenu",
	options = require "interface.menus.OptionsMenu",
	pause = require "interface.menus.PauseMenu",
	gameOver = require "interface.menus.GameOverMenu",
	win = require "interface.menus.WinMenu",
}
M.startMenuName = "main"

return M
