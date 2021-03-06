
io.stdout:setvbuf("no") -- For use with external console.

require "init-global-libs"

local guiDebugEnabled = true

local scene, guiRoot, gameRoot
local mapCam, paletteCam

local sw, sh = love.window.getMode()
local screenAlloc = { x = 0, y = 0, w = sw, h = sh, designW = sw, designH = sh, scale = 1 }

function love.load()
	math.randomseed(love.timer.getTime() * 10000)

	love.graphics.setBackgroundColor(0.1, 0.1, 0.1, 1)

	Input.init()
	Input.bindMultiple(require("input-bindings"))
	love.keyboard.setKeyRepeat(true)

	physics.setCategoryNames(unpack(config.physicsCategoryNames))

	-- Root objects & scripts may require physics categories, and are only used in load().
	local GuiRoot = require "GuiRoot"
	local Editor = require "editor.Editor"
	local Interface = require "interface.Interface"

	scene = SceneTree(config.drawLayers, config.defaultDrawLayer)

	mapCam = scene:add(mod(Camera(0, 0, 0, nil, "expand view"), {name = "MapCamera"}))
	paletteCam = scene:add(mod(Camera(0, 0, 0, {900, 900}, "fixed area"), {name = "PaletteCamera"}))

	scene:add(Editor())

   guiRoot = mod(GuiRoot(), { children = {Interface()} })
	scene:add(guiRoot)
	guiRoot:allocate(screenAlloc, true)

	scene:callRecursive("postInit") -- So objects can get references to each other.
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
	mapCam:applyTransform()
	scene:draw("world")
	mapCam:resetTransform()

	paletteCam:applyTransform()
	scene:draw("palette")
	paletteCam:resetTransform()

	scene:draw("gui")
	if guiDebugEnabled then  debugDraw(guiRoot, "guiDebug")  end
end

function love.resize(w, h)
	screenAlloc.w, screenAlloc.h = w, h
	guiRoot:allocate(screenAlloc)
end
