
local script = {}

function script.init(self)
	Input.enable(self)
end

function script.final(self)
	Input.disable(self)
end

local hoverActions = {
	pan = 1, scrollx = 1, scrolly = 1, zoomIn = 1, zoomOut = 1
}

function script.input(self, action, value, change, ...)
	self.ruu:inputWrapper(hoverActions, action, value, change, ...)
	if action == "pan" and change == -1 then
		self.ruu:stopDrag("type", "pan")
	end
end

return script
