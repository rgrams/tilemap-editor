
local Object = require 'philtre.objects.Object'
local Tilemap = Object:extend()
Tilemap.className = 'Tilemap'

local floor = math.floor

local function round(x)
	return floor(x + 0.5)
end

local function debugDraw(self)
end

function Tilemap.debugDraw(self, layer)
	-- self.tree.draw_order:addFunction(layer, self._to_world, debugDraw, self)
end

function Tilemap.draw(self)
	love.graphics.setBlendMode(self.blendMode)
	love.graphics.setColor(self.color)
	local ox, oy = self.ox, self.oy
	for y,row in pairs(self.map) do
		for x,i in pairs(row) do
			love.graphics.draw(self.image, self.quads[i], x*self.gridX, y*self.gridY, nil, nil, nil, ox, oy)
		end
	end
end

function Tilemap.setTile(self, x, y, tileIndex, isRounded)
	if tileIndex then
		tileIndex = round(tileIndex)
		assert(tileIndex and tileIndex > 0 and tileIndex <= self.maxTileIndex,
			'ERROR: Tilemap.setTile - Invalid tileIndex: "'..tostring(tileIndex)..
			'". Must be either nil or a number from 1 to '..self.maxTileIndex..' for this Tilemap.')
	end -- nil/false tileIndex removes the tile.
	if not isRounded then  x, y = round(x), round(y)  end
	local row = self.map[y]
	if not row then
		row = {}
		self.map[y] = row
	end
	row[x] = tileIndex
end

function Tilemap.getTile(self, x, y, isRounded)
	if not isRounded then  x, y = round(x), round(y)  end
	local row = self.map[y]
	if row then
		return row[x]
	end
end

function Tilemap.set(self, image, x, y, angle, gridX, gridY, extrudeBorders, tileCount)
	assert(image, 'Tilemap() - first argument must be a texture file path or Image object.')
	Tilemap.super.set(self, x, y, angle)
	gridX, gridY = gridX or 32, gridY or gridX or 32
	self.gridX, self.gridY = gridX, gridY
	extrudeBorders = extrudeBorders or 0
	tileCount = tileCount or math.huge
	if type(image) == 'string' then
		image = new.image(image)
	end
	self.image = image
	self.quads = {} -- Tile quads by index.
	local iw, ih = self.image:getDimensions()
	local atlasGridX, atlasGridY = gridX + extrudeBorders*2, gridY + extrudeBorders*2
	local gridW, gridH = math.ceil(iw / atlasGridX), math.ceil(ih / atlasGridY)
	local i = 0
	for y=0,(gridH - 1) do
		for x=0,(gridW - 1) do
			i = i + 1
			local top, left = y * atlasGridY + extrudeBorders, x * atlasGridX + extrudeBorders
			quad = love.graphics.newQuad(left, top, gridX, gridY, iw, ih)
			self.quads[i] = quad
			if i >= tileCount then  break  end
		end
		if i >= tileCount then  break  end
	end
	self.maxTileIndex = i
	self.blendMode = 'alpha'
	self.color = {1, 1, 1, 1}
	self.ox, self.oy = self.gridX * 0.5, self.gridY * 0.5
	self.map = {}
end

return Tilemap
