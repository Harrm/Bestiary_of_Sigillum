FieldModule = {}


local Cell = {}
FieldModule.Landscapes = {Hill = 1, Forest = 2, Plain = 3, Water = 4}

function Cell.new(landscape)
	local newCell = {}
	newCell.landscape = landscape or FieldModule.Landscapes.Plain;
	newCell.occupyingHero = nil
	setmetatable(newCell, {__index = Cell})
	return newCell
end



local Castle = {}
setmetatable(Castle, {__index = Cell})
function Castle.new(ownerPlayer)
	local newCastle = Cell.new()
	newCastle.landscape = nil
	newCastle.isCastle = true
	newCastle.ownerPlayer = ownerPlayer
	setmetatable(newCastle, {__index = Castle})
	return newCastle
end


local Field = {}
function FieldModule.createField(player1, player2)
	local field = {}

	local Landscapes = FieldModule.Landscapes
	field[1] = {Cell.new(Landscapes.Forest), 
				Cell.new(Landscapes.Plain),
				Cell.new(Landscapes.Plain)
				}
	field[2] = {Cell.new(Landscapes.Plain),
				Cell.new(Landscapes.Hill), 
				Cell.new(Landscapes.Forest), 
				Cell.new(Landscapes.Plain)
				}
	field[3] = {Castle.new(player1), 
				Cell.new(Landscapes.Plain), 
				Cell.new(Landscapes.Water), 
				Cell.new(Landscapes.Plain),
				Castle.new(player2)
				}
	field[4] = {Cell.new(Landscapes.Forest), 
				Cell.new(Landscapes.Water), 
				Cell.new(Landscapes.Water), 
				Cell.new(Landscapes.Plain)
				}
	field[5] = {Cell.new(Landscapes.Plain), 
				Cell.new(Landscapes.Hill), 
				Cell.new(Landscapes.Forest),
				}
	field.towers = {{x=1, y=2}, {x=5, y=2}}

	setmetatable(field, {__index = Field})
	return field
end

function Field:isAdjast(x1, y1, x2, y2)
	for _, cell in pairs(self:getAdjastentCells(x1, y1)) do
		if cell.x == x2 and cell.y == y2 then
			return true
		end
	end
	return false
end

function Field:getAdjastentCells(x, y)
	local adjastents = {}

	for dy = -1, 1 do
		for dx = -1, 1 do
			if  (y+dy > 0 and y+dy < 6) and 
				(x+dx > 0 and x+dx < 6) and 
				(x ~= 0 or y ~= 0) then
				table.insert(adjastents, 1, {x=x+dx, y=y+dy})
			end
		end
	end

	return adjastents
end

function Field:isAdjast(x1, y1, x2, y2)
	for _, cell in pairs(self:getAdjastentCells(x1, y1)) do
		if cell.x == x2 and cell.y == y2 then
			return true
		end
	end
	return false
end

function Field:draw()
	for _, row in pairs(self) do
		for _, cell in pairs(row) do
			if cell.isCastle then
				io.write("C")

			elseif cell.hasTower then
				io.write("T")

			elseif cell.landscape == FieldModule.Landscapes.Plain then
				io.write("P")
	
			elseif cell.landscape == FieldModule.Landscapes.Water then
				io.write("W")
	
			elseif cell.landscape == FieldModule.Landscapes.Hill then
				io.write("H")

			elseif cell.landscape == FieldModule.Landscapes.Forest then
				io.write("F")
			end
		end
		io.write("\n")
	end
end

return FieldModule