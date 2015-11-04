local HeroPickScreen = {}

--Heroes = require("heroes")



function HeroPickScreen:init(player1, player2)
	self.viewport = MOAIViewport.new()
	self.viewport:setSize(SCREEN_RESOLUTION_X, SCREEN_RESOLUTION_Y)
	self.viewport:setScale(WORLD_SIZE_X, WORLD_SIZE_Y)
	
	self.layer = MOAILayer2D.new()
	self.layer:setViewport(self.viewport)

	self.players = {first = player1, second = player2}

	self.heroNames = {
		"Vinctume", "Ferrariuns", "Suxum",
		"Cerberus", "Redux", "Ballistarius",
		"Manus", "Messum", "Goecio"
	}

	local GRID_ROWS = 3
	local GRID_COLUMNS = 3
	self.grid = MOAIGrid.new()
	self.grid:initRectGrid(GRID_COLUMNS, GRID_ROWS, 64, 64)
	self.grid:setRepeat(false)
	for row = 1, GRID_ROWS do
		for column = 1, GRID_COLUMNS do
			self.grid:setTile(column, GRID_ROWS-row+1, (row-1)*3+column)
		end
	end

	self.tileDeck = MOAITileDeck2D.new()
	self.tileDeck:setTexture("../data/heroes_icons.png")
	self.tileDeck:setSize(3, 3)

	self.tilesProp = MOAIProp2D.new()
	self.tilesProp:setDeck(self.tileDeck)
	self.tilesProp:setGrid(self.grid)
	local width, height = self.tilesProp:getDims()
	self.tilesProp:setLoc(-width/2, height/2)
	self.tilesProp:forceUpdate()
	self.layer:insertProp(self.tilesProp)

	self.font = MOAIFont.new()
	self.font:load("../data/allods_west.ttf")

	local textbox = self.createTextBox("ALL PICK", self.font, {0, 0}, {-50, -50, 50, 50})
	self.layer:insertProp(textbox)
end



function HeroPickScreen:show()
	self.shown = true
	MOAIRenderMgr.setRenderTable({self.layer})
end



function HeroPickScreen:hide()
	self.shown = false

	MOAIRenderMgr.setRenderTable({})
end



function HeroPickScreen:proccessInput(worldX, worldY)
	local modelX, modelY = self.tilesProp:worldToModel(worldX, worldY)
	local tileX, tileY = self.grid:locToCoord(modelX, modelY)
	
	self:pick(tileX, tileY)
end



function HeroPickScreen:pick(tileX, tileY)
	--local pickedHeroName = self.heroIcons[self.grid:getTile(tileX, tileY)]
	--local hero = Heroes[pickedHeroName]
	--table.insert(self.players.first.heroes, hero)

	local x, y = self.tilesProp:modelToWorld(self.grid:getTileLoc(tileX, tileY))
end



return HeroPickScreen