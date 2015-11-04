local HeroesIcons = {}

local ResourceManager = require("resource_manager")
local ResourceDefinitions = require("resource_definitions")

local heroes_icons = {
	type = RESOURCE_TYPE_TILED_IMAGE,
	fileName = "heroes_portraits.png",
	tileMapSize = {3, 3}
}

function HeroesIcons:init()
	local viewport = MOAIViewport.new()
	viewport:setSize(SCREEN_RESOLUTION_X, SCREEN_RESOLUTION_Y)
	viewport:setScale(WORLD_SIZE_X, WORLD_SIZE_Y)

	self.layer = MOAILayer2D.new()
	self.layer:setViewport(viewport)
	
	ResourceDefinitions:set("heroes_icons", heroes_icons)

	self.shown = false
	
	self.tileDeck = ResourceManager:get("heroes_icons")
	self.tileDeck:setRect(-32, -32, 32, 32)

	self.icons = {}
end



function HeroesIcons:show()
	if not self.shown then
		self.shown = true
		local renderTable = MOAIRenderMgr.getRenderTable()
		table.insert(renderTable, self.layer)
		MOAIRenderMgr.setRenderTable(renderTable)
	end
end



function HeroesIcons:hide()
	if not self.shown then
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



function HeroesIcons:addHero(index, pos)
	local prop = MOAIProp2D.new()
	prop:setDeck(self.tileDeck)
	prop:setLoc(pos.x, pos.y)
	prop:setIndex(index)
	self.layer:insertProp(prop)
	table.insert(self.icons, prop)
end


return HeroesIcons