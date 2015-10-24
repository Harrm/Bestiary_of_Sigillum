local Field = {}

Field.Landscapes = {Plain = 1, Forest = 2, Hill = 3, Water = 4, Castle = 5}

function Field:new(player1, player2)
	local field = {}
	field.cells = {{},{},{},{},{}}

	local Landscapes = Field.Landscapes
	field.cells[1][3] = Landscapes.Forest
	field.cells[1][5] = Landscapes.Plain
	field.cells[1][7] = Landscapes.Hill

	field.cells[2][2] = Landscapes.Plain
	field.cells[2][4] = Landscapes.Hill
	field.cells[2][6] = Landscapes.Forest
	field.cells[2][8] = Landscapes.Plain

	field.cells[3][1] = Landscapes.Castle
	field.cells[3][3] = Landscapes.Plain
	field.cells[3][5] = Landscapes.Water
	field.cells[3][7] = Landscapes.Plain
	field.cells[3][9] = Landscapes.Castle

	field.cells[4][2] = Landscapes.Forest
	field.cells[4][4] = Landscapes.Water
	field.cells[4][6] = Landscapes.Water
	field.cells[4][8] = Landscapes.Plain

	field.cells[5][3] = Landscapes.Plain
	field.cells[5][5] = Landscapes.Hill
	field.cells[5][7] = Landscapes.Forest

	field.towers = {{x=1, y=2}, {x=5, y=2}}

	setmetatable(field, {__index = Field})
	return field
end



function Field:getCell(x, y)
	if self.cells[x] ~= nil then
		return self.cells[x][y]
	end
	return nil
end


function Field.isAdjast(x1, y1, x2, y2)
	for _, coords in pairs(self.getAdjastentCellsCoords(x1, y1)) do
		if coords.x == x2 and coords.y == y2 then
			return true
		end
	end
	return false
end

function Field.getAdjastentCellsCoords(x, y)
	local adjastents = {}

	for dy = -2, 2 do
		for dx = -1, 1 do
			if self[x+dx] ~= nil and self[x+dx][y+dy] ~= nil
			   and (x ~= 0 or y ~= 0) then
				table.insert(adjastents, 1, {x=x+dx, y=y+dy})
			end
		end
	end

	return adjastents
end

function Field:print()
	for _, row in pairs(self) do
		for _, cell in pairs(row) do
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