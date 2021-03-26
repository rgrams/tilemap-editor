
io.stdout:setvbuf("no") -- For use with external console.

require "init-global-libs"

local worldDebugEnabled = true
local guiDebugEnabled = true

local scene, guiRoot, gameRoot
local Interface = require "interface.Interface"

local sw, sh = love.window.getMode()
local screenAlloc = { x = 0, y = 0, w = sw, h = sh, designW = sw, designH = sh, scale = 1 }

function love.load()
	math.randomseed(love.timer.getTime() * 10000)

	Input.init()
	Input.bindMultiple(require("input-bindings"))

	physics.setCategoryNames(unpack(config.physicsCategoryNames))

	-- Root objects & scripts may require physics categories, and are only used in load().
	local GuiRoot = require "GuiRoot"
	local menuSwitcher_script = require "interface.menuSwitcher_script"
	local Editor = require "editor.Editor"

	scene = SceneTree(config.drawLayers, config.defaultDrawLayer)

   guiRoot = mod(GuiRoot(), { children = {Interface()} })
	scene:add(guiRoot)
	guiRoot:allocate(screenAlloc)

	gameRoot = mod(Object(), {name = "GameManager"})
	scene:add(gameRoot)
	scene:add(Camera(), gameRoot)
	scene:add(Editor(), gameRoot)
end

function love.update(dt)
	scene:update(dt)
end

local function debugDraw(rootObject, layer)
	rootObject:callRecursive("debugDraw", layer)
	rootObject.tree:draw(layer)
	rootObject.tree.draw_order:clear(layer)
end

function love.draw()
	Camera.current:applyTransform()
	scene:draw("world")
	if worldDebugEnabled then  debugDraw(gameRoot, "debug")  end
	Camera.current:resetTransform()
	scene:draw("gui")
	if guiDebugEnabled then  debugDraw(guiRoot, "guiDebug")  end
end

function love.resize(w, h)
	Camera.setAllViewports(0, 0, w, h)
	screenAlloc.w, screenAlloc.h = w, h
	guiRoot:allocate(screenAlloc)
end
