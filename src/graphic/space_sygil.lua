local Field = {}

local ResourceManager = require("resource_manager")
local ResourceDefinitions = require("resource_definitions")

Field.Landscapes = {Plain = 1, Forest = 2, Hill = 3, Water = 4, Castle = 5}

local tiles = {
	type = RESOURCE_TYPE_TILED_IMAGE,
	fileName = "hex-tiles.png",
	tileMapSize = {4, 4}
}

local field = {
	type = RESOURCE_TYPE_IMAGE,
	fileName = "field.png",
	width = 10, height = 10
}


function Field:init()
	local viewport = MOAIViewport.new()
	viewport:setSize(SCREEN_RESOLUTION_X, SCREEN_RESOLUTION_Y)
	viewport:setScale(WORLD_SIZE_X, WORLD_SIZE_Y)

	self.layer = MOAILayer2D.new()
	self.layer:setViewport(viewport)
	
	ResourceDefinitions:set("tiles", tiles)
	ResourceDefinitions:set("field", field)

	self.shown = false

	local GRID_COLUMNS = 3
	local GRID_ROWS = 9
	self.grid = MOAIGrid.new()
	self.grid:initHexGrid(GRID_COLUMNS, GRID_ROWS, 58)
	self.grid:setRepeat(false)
	local HIDE = MOAIGridSpace.TILE_HIDE
	self.grid:fill(HIDE)

	local tileDeck = ResourceManager:get("tiles")
	local width, height, cellWidth, cellHeight = 4, 4, 0.25, 0.216796875
	tileDeck:setSize(width, height, cellWidth, cellHeight)

	local tilesProp = MOAIProp2D.new()
	tilesProp:setDeck(tileDeck)
	tilesProp:setGrid(self.grid)
	local width, height = tilesProp:getDims()
	tilesProp:setLoc(-width/2, height/2)
	tilesProp:forceUpdate()
	self.tilesProp = tilesProp
	
	local fieldDeck = ResourceManager:get("field")
	local width, height = 480, 480
	fieldDeck:setRect(-width/2, -height/2, width/2, height/2)
	local fieldProp = MOAIProp2D.new()
	fieldProp:setDeck(fieldDeck)
	fieldProp:setLoc(-40, -32)

	self.layer:insertProp(fieldProp)
	self.layer:insertProp(self.tilesProp)

	local font = ResourceManager:get("allods_west")

	if DEBUG then
	for c = 1, GRID_COLUMNS do
		for r = 1, GRID_ROWS do
			local x, y = self.grid:getTileLoc(c, r)
			x, y = tilesProp:modelToWorld(x, y)
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
end



function Field:show()
	if self.shown == false then
		self.shown = true
		local renderTable = MOAIRenderMgr.getRenderTable()
		table.insert(renderTable, 1, self.layer)
		MOAIRenderMgr.setRenderTable(renderTable)
	end
end



function Field:hide()
	if self.shown == true then
		self.shown = false
		local renderTable = MOAIRenderMgr.getRenderTable()
		for i, layer in ipairs(renderTable) do
			if layer == self.layer then
				table.remove(renderTable, i)
			end
		end
		MOAIRenderMgr.setRenderTable(renderTable)
	end
end

return Field