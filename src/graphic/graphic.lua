local Graphic = {}

local ResourceManager = require("resource_manager")
local ResourceDefinitions = require("resource_definitions")

definitions = {
	allods_west = {
		type = RESOURCE_TYPE_FONT,
		fileName = "allods_west.ttf",
		glyphs = "QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjklzxcvbnm0123456789!-?,.",
		fontSize = 16,
		dpi = 256
	},

	heroes_portraits = {
		type = RESOURCE_TYPE_TILED_IMAGE,
		fileName = "heroes_icons.png",
		tileMapSize = {3, 3},
		width = 64, height = 64
	}

}


function Graphic:init()
	local viewport = MOAIViewport.new()
	viewport:setSize(SCREEN_RESOLUTION_X, SCREEN_RESOLUTION_Y)
	viewport:setScale(WORLD_SIZE_X, WORLD_SIZE_Y)

	self.layer = MOAILayer2D.new()
	self.layer:setViewport(viewport)

	ResourceDefinitions:setDefinitions(definitions)

	MOAIRenderMgr.setRenderTable({self.layer})
end



function Graphic:createLabel(text, pos, size, textSize)
	local textbox = MOAITextBox.new()
	textbox:setString(text)
	textbox:setFont(ResourceManager:get("allods_west"))
	textbox:setRect(pos.x - size.width/2, pos.y - size.height/2, 
					pos.x + size.width/2, pos.y + size.height/2)
	textbox:setYFlip(true)
		textbox:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
	if textSize ~= nil then
		textbox:setTextSize(textSize)
	end
	
	self.layer:insertProp(textbox)

	return textbox
end



function Graphic:createSprite(deck_name, pos, size)
	local deck = ResourceManager:get(deck_name)
	deck:setRect(pos.x-size.width/2, pos.y-size.height/2,
				 pos.x+size.width/2, pos.y+size.height/2)
	local prop = MOAIProp2D.new()
	prop:setDeck(deck)
	prop:setLoc(pos.x, pos.y)
	prop:setIndex(3)
	self.layer:insertProp(prop)
	return prop
end



return Graphic