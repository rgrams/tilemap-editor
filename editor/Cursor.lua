
local script = {
	init = function(self)  print(self)  end
}

local function Cursor(x, y)
	local self = Sprite("common/tex/cross_64.png", x, y)
	self.name = "Cursor"
	self.scripts = { script }
	self.color[4] = 0.2
	return self
end

return Cursor
