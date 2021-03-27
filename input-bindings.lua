
-- { "button", combo, actionName }
-- { "axis", -combo, +combo, actionName }
local M = {
	{ "button", "enter", "confirm" },
	{ "axis", "left", "right", "move x" },
	{ "button", "up", "up" },
	{ "button", "down", "down" },
	{ "button", "left", "left" },
	{ "button", "right", "right" },
	{ "button", "enter", "enter" },
	{ "button", "escape", "pause" },
	{ "text", "text" },
	{ "button", "M:1", "left click" },
	{ "mouseMoved", "updateCursor" },

	{ "button", "M:3", "pan" },
	{ "button", "m:wheely+", "zoomIn" },
	{ "button", "m:wheely-", "zoomOut" },
	{ "button", "M:1", "click" },
	{ "mouseMoved", "mouseMoved" },

	{ "button", "shift", "shift" },
	{ "button", "ctrl z", "undo/redo" },
	{ "button", "ctrl k:z", "undo/redo" },
	{ "button", "ctrl k:s", "save" },
}

return M
