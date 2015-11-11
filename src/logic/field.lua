local Field = {}

Field.Landscapes = {Plain = 1, Forest = 2, Hill = 3, Water = 4, Castle = 5}

function Field:new()
	local field = {}
	field.cells = {{},{},{},{},{}}

	local Landscapes = Field.Landscapes
	field.cells[1][3] = Landscapes.Forest
	field.cells[1][5] = Landscapes.Plain
	field.cells[1][7] = Landscapes.Hill

	field.cells[1][2] = Landscapes.Plain
	field.cells[1][4] = Landscapes.Hill
	field.cells[1][6] = Landscapes.Forest
	field.cells[1][8] = Landscapes.Plain

	field.cells[2][1] = Landscapes.Castle
	field.cells[2][3] = Landscapes.Plain
	field.cells[2][5] = Landscapes.Water
	field.cells[2][7] = Landscapes.Plain
	field.cells[2][9] = Landscapes.Castle

	field.cells[2][2] = Landscapes.Forest
	field.cells[2][4] = Landscapes.Water
	field.cells[2][6] = Landscapes.Water
	field.cells[2][8] = Landscapes.Plain

	field.cells[3][3] = Landscapes.Plain
	field.cells[3][5] = Landscapes.Hill
	field.cells[3][7] = Landscapes.Forest

	field.towers = {{x=1, y=5}, {x=3, y=5}}

	setmetatable(field, {__index = Field})
	return field
end



function Field:getLandscape(x, y)
	if self.cells[x] ~= nil then
		return self.cells[x][y]
	end
	return nil
end



function Field:isAdjast(point1, point2)
	local adjastents = self:getAdjastentsCoords(point1)

	for _, coords in pairs(adjastents) do
		if coords.x == point2.x and coords.y == point2.y then
			return true
		end
	end

	point1, point2 = point2, point1

	adjastents = self:getAdjastentsCoords(point1)

	for _, coords in pairs(adjastents) do
		if coords.x == point2.x and coords.y == point2.y then
			return true
		end
	end

	return false
end



function Field:getAdjastentsCoords(point)
	local x, y = point.x, point.y
	local adjastents = {
		{x = x, y = y},
		{x = x,   y = y+2},
		{x = x,   y = y-2},
		{x = (y%2==0 and x+1 or x), y = y-1},
		{x = (y%2==0 and x+1 or x), y = y+1},
		{x = (y%2==0 and x or x-1), y = y-1},
		{x = (y%2==0 and x or x-1), y = y+1}
	}
	for i, pos in ipairs(adjastents) do
		if self.cells[pos.x] == nil or self.cells[pos.x][pos.y] == nil then
			adjastents[i] = nil
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