local Graphic = {}

function Graphic:init()
	self.layer = MOAILayer2D.new()
	self.layer:setViewport(viewport)

	local GRID_COLUMNS = 3
	local GRID_ROWS = 9
	self.grid = MOAIGrid.new()
	self.grid:initHexGrid(GRID_COLUMNS, GRID_ROWS, 32)
	self.grid:setRepeat(false)
	
	self.tileDeck = MOAITileDeck2D.new()
	self.tileDeck:setTexture("../data/hex-tiles.png")
	self.tileDeck:setSize(4, 4, 0.25, 0.216796875)

	self.tilesProp = MOAIProp2D.new()
	self.tilesProp:setDeck(self.tileDeck)
	self.tilesProp:setGrid(self.grid)
	local width, height = self.tilesProp:getDims()
	print(width, height)
	self.tilesProp:setLoc(-width/2+24, height/2)
	self.tilesProp:forceUpdate()
	self.layer:insertProp(self.tilesProp)

	local font = MOAIFont.new()
	font:load("../data/allods_west.ttf")

	for c = 1, GRID_COLUMNS do
		for r = 1, GRID_ROWS do
			local x, y = self.grid:getTileLoc(c, r)
			x, y = self.tilesProp:modelToWorld(x, y)
			textbox = MOAITextBox.new ()
			textbox:setFont ( font )
			textbox:setTextSize ( 20 )
			textbox:setRect ( -20, -20, 20, 20 )
			textbox:setLoc ( x, y )
			textbox:setYFlip ( true )
			textbox:setAlignment ( MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY )
			self.layer:insertProp ( textbox )
	
			textbox:setString ( string.format("%d,%d", c, r) )
		end
	end
end



function Graphic:show()
	self.shown = true
	MOAIRenderMgr.setRenderTable({self.layer})
end



function Graphic:hide()
	self.shown = false
	MOAIRenderMgr.setRenderTable({})
end


function Graphic:setField(field)
	local gridRows, gridColumns = self.grid:getSize()
	for column_id, column in pairs(field.cells) do
		for row_id, cell in pairs(column) do
			if field:getCell(column_id, row_id) ~= nil then
				print(column_id, row_id, cell)
				self.grid:setTile((column_id+1)/2, row_id, cell)
			end
		end
	end
end


--[[
function Graphic:tileToFieldCoords(tileX, tileY)
	fieldX, fieldY = tileX, tileY

	if tileY % 2 ~= 0 then
		if tileX ~= 2 then
			fieldY = tileY - 1
		end
		if tileX ~= 1 then
			fieldX = tileX + math.ceil(tileX/2)
		end
	else
		fieldX = tileX * 2
	end
	fieldY = math.ceil(fieldY / 2)
	return fieldX, fieldY
end]]

return Graphic