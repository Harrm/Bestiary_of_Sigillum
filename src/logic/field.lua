local Field = {}

Field.Landscapes = {Plain = 1, Forest = 2, Hill = 3, Water = 4, Castle = 5}

function Field:init()
	self.cells = {{},{},{},{},{}}

	local Landscapes = Field.Landscapes
	self.cells[1][3] = Landscapes.Forest
	self.cells[1][5] = Landscapes.Plain
	self.cells[1][7] = Landscapes.Hill

	self.cells[1][2] = Landscapes.Plain
	self.cells[1][4] = Landscapes.Hill
	self.cells[1][6] = Landscapes.Forest
	self.cells[1][8] = Landscapes.Plain

	self.cells[2][1] = Landscapes.Castle
	self.cells[2][3] = Landscapes.Plain
	self.cells[2][5] = Landscapes.Water
	self.cells[2][7] = Landscapes.Plain
	self.cells[2][9] = Landscapes.Castle

	self.cells[2][2] = Landscapes.Forest
	self.cells[2][4] = Landscapes.Water
	self.cells[2][6] = Landscapes.Water
	self.cells[2][8] = Landscapes.Plain

	self.cells[3][3] = Landscapes.Plain
	self.cells[3][5] = Landscapes.Hill
	self.cells[3][7] = Landscapes.Forest

	self.towers = {{x=1, y=5}, {x=3, y=5}}

	setmetatable(self, {__index = Field})
	return self
end



function Field:getLandscape(x, y)
	if self.cells[x] ~= nil then
		return self.cells[x][y]
	end
	return nil
end


local function makePoint(x, y)
	return {x=x, y=y}
end

Field.StraightLines = {
	{makePoint(1, 7), makePoint(1, 8), makePoint(2, 9)},
	{makePoint(1, 5), makePoint(1, 6), makePoint(2, 7), makePoint(2, 8)},
	{makePoint(1, 3), makePoint(1, 4), makePoint(2, 5), makePoint(2, 6), makePoint(3, 7)},
	{makePoint(1, 2), makePoint(2, 3), makePoint(2, 4), makePoint(3, 5)},
	{makePoint(2, 1), makePoint(2, 2), makePoint(3, 3)},

	{makePoint(3, 1),makePoint(1, 2),makePoint(1, 3)},
	{makePoint(2, 2),makePoint(2, 3),makePoint(1, 4),makePoint(1, 5)},
	{makePoint(3, 3),makePoint(2, 4),makePoint(2, 5),makePoint(1, 6), makePoint(1, 7)},
	{makePoint(3, 5),makePoint(2, 6),makePoint(2, 7),makePoint(1, 8)},
	{makePoint(3, 7),makePoint(2, 8),makePoint(2, 9)}
}



function Field:getStraightLine(point1, point2)	-- I HATE FUCKING HEXAGONAL GRID.
	if point1 == nil or point2 == nil then
		error("Point is nil!")
	end
	local result_line = {}

	if self:isAdjast(point1, point2) then
		return {point1, point2}

	else
		if point1.x == point2.x and point1.y%2 == point2.y%2 then
			if point1.x < point2.x then
				for i = point1.y, point2.y, 2 do
					table.insert(result_line, {x=point1.x, y=i})
				end
			else
				for i = point1.y, point2.y, -2 do
					table.insert(result_line, {x=point1.x, y=i})
				end
			end
			return result_line
		end

		for _, line in ipairs(Field.StraightLines) do
			for pos1, point in ipairs(line) do
				if point.x == point1.x and point.y == point1.y then
					for pos2, point in ipairs(line) do
						if point.x == point2.x and point.y == point2.y then
							if pos1 < pos2 then
								for i = pos1, pos2 do
									table.insert(result_line, line[i])
								end
							else
								for i = pos1, pos2, -1 do
									table.insert(result_line, line[i])
								end
							end
							return result_line
						end
					end
				end
			end
		end
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