MOAISim.openWindow("Bestiary of Sigillum", 800, 600)

viewport = MOAIViewport.new()
viewport:setSize(800, 600)
viewport:setScale(800, 600)

layer = MOAILayer2D.new()
layer:setViewport(viewport)
MOAISim.pushRenderPass(layer)
 
local grid_rows = 8
local grid_columns = 8
grid = MOAIGrid.new()
grid:initHexGrid(grid_columns, grid_rows, 32)
grid:setRepeat(false)

for c = 1, grid_columns do
	for r = 1, grid_rows do
		grid:setTile(c, r, ((c + r) % 4) + 1)
	end
end

tileDeck = MOAITileDeck2D.new ()
tileDeck:setTexture("../data/hex-tiles.png")
tileDeck:setSize(4, 4, 0.25, 0.216796875)

prop = MOAIProp2D.new()
prop:setDeck(tileDeck)
prop:setGrid(grid)
prop:setLoc(-400, -0)
prop:forceUpdate()
layer:insertProp(prop)

cursor = MOAIProp2D.new()
cursor:setDeck(tileDeck)
cursor:setScl(grid:getTileSize())
cursor:addScl(-10)
layer:insertProp(cursor)

font = MOAIFont.new()
font:load("../data/allods_west.ttf")

for column = 1, grid_columns do
	for row = 1, grid_rows do
		local x, y = grid:getTileLoc(column, row)
		x, y = prop:modelToWorld(x, y)
		textbox = MOAITextBox.new()
		textbox:setFont(font)
		textbox:setTextSize(20)
		textbox:setRect(-20, -20, 20, 20)
		textbox:setLoc(x, y)
		textbox:setYFlip(true)
		textbox:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
		layer:insertProp(textbox)

		textbox:setString(string.format("%d,%d", column, row))
	end
end


----------------------------------------------------------------
local xTileCoord = 0
local yTileCoord = 0

function onPointerEvent(x, y)
	grid:clearTileFlags(xTileCoord, yTileCoord, MOAIGrid.TILE_HIDE)
	x, y = layer:wndToWorld(x, y)
	x, y = prop:worldToModel(x, y)
	xTileCoord, yTileCoord = grid:locToCoord(x, y)
	
	x, y = grid:getTileLoc(xTileCoord, yTileCoord, MOAIGrid.TILE_CENTER)
	x, y = prop:modelToWorld(x, y)
	cursor:setLoc(x, y)
	
	xTileCoord, yTileCoord = grid:wrapCoord(xTileCoord, yTileCoord)
	cursor:setIndex(grid:getTile(xTileCoord, yTileCoord))
	
	grid:setTileFlags(xTileCoord, yTileCoord, MOAIGrid.TILE_HIDE)
end

function onMouseLeftEvent(down)
	if down then
		local x, y = MOAIInputMgr.device.pointer:getLoc()
		x, y = layer:wndToWorld(x, y)

		print(grid:locToCoord(prop:worldToModel(x, y)))
	end
end


MOAIInputMgr.device.pointer:setCallback(onPointerEvent)
MOAIInputMgr.device.mouseLeft:setCallback(onMouseLeftEvent)
onPointerEvent(0, 0)
