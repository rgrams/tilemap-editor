
local indentStr = "\t"

function serialize(a, indent)
	indent = indent or ""
	if type(a) == "number" then
		io.write(a)
	elseif type(a) == "string" then
		io.write(string.format("%q", a))
	elseif type(a) == "table" then
		io.write("{\n", indent .. indentStr)
		for k,v in pairs(a) do
			if type(k) == "number" then  io.write("[", k, "] = ")
			else  io.write(k, " = ")  end
			serialize(v, indent .. indentStr)
			io.write(",\n")
			if next(a, k) then  io.write(indent .. indentStr)  end
		end
		io.write(indent, "}")
	elseif type(a) == "boolean" then
		io.write(tostring(a))
	else
		error("cannot serialize a " .. type(a))
	end
end

return serialize
