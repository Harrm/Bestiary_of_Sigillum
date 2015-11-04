local Field = {}

Field.Landscapes = {Plain = 1, Forest = 2, Hill = 3, Water = 4, Castle = 5}

function Field:new()
	local field = {}
	field.cells = {{},{},{},{},{}}

	local Landscapes = Field.Landscapes
	field.cells[1][1] = Landscapes.Forest
	field.cells[1][2] = Landscapes.Plain
	field.cells[1][3] = Landscapes.Hill

	field.cells[2][1] = Landscapes.Plain
	field.cells[2][2] = Landscapes.Hill
	field.cells[2][3] = Landscapes.Forest
	field.cells[2][4] = Landscapes.Plain

	field.cells[3][1] = Landscapes.Castle
	field.cells[3][2] = Landscapes.Plain
	field.cells[3][3] = Landscapes.Water
	field.cells[3][4] = Landscapes.Plain
	field.cells[3][5] = Landscapes.Castle

	field.cells[4][1] = Landscapes.Forest
	field.cells[4][2] = Landscapes.Water
	field.cells[4][3] = Landscapes.Water
	field.cells[4][4] = Landscapes.Plain

	field.cells[5][1] = Landscapes.Plain
	field.cells[5][2] = Landscapes.Hill
	field.cells[5][3] = Landscapes.Forest

	field.towers = {{x=1, y=2}, {x=5, y=2}}

	setmetatable(field, {__index = Field})
	return field
end



function Field:getLandscape(x, y)
	if self.cells[x] ~= nil then
		return self.cells[x][y]
	end
	return nil
end



function Field.isAdjast(point1, point2)
	for _, coords in ipairs(self.getAdjastentsCoords(point1)) do
		if coords.x == point2.x and coords.y == point2.y then
			return true
		end
	end
	return false
end



function Field.getAdjastentsCoords(point)
	local x, y = point.x, point.y
	local adjastents = {
		{x = x, y = y},
		{x = x-1, y = y-1},
		{x = x-1, y = y  },
		{x = x,   y = y+1},
		{x = x,   y = y-1},
		{x = x+1, y = y  },
		{x = x+1, y = y-1}
	}

	for i, pos in ipairs(adjastents) do
		if self[pos.x] == nil or self[pos.x][pos.y] == nil then
			table.remove(adjastents, i)
		end
	end

	return adjastents
end



function Field:print()
	for _, row in ipairs(self) do
		for _, cell in ipairs(row) do
			if cell == Field.Landscapes.Castle then
				io.write("C")
			
			elseif cell == Field.Landscapes.Plain then
				io.write("P")
	
			elseif cell == Field.Landscapes.Water then
				io.write("W")
	
			elseif cell == Field.Landscapes.Hill then
				io.write("H")

			elseif cell == Field.Landscapes.Forest then
				io.write("F")
			end
		end
		io.write("\n")
	end
end

return Field