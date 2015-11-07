local Menu = {}

local ResourceManager = require("resource_manager")
local ResourceDefinitions = require("resource_definitions")

local allods_west = {
	type = RESOURCE_TYPE_FONT,
	fileName = "allods_west.ttf",
	glyphs = "qwertyuiopasdfghjklzxcvbnm,./;'[]!@#$%^&*()_+-=QWERTYUIOPASDFGHJKLZXCVBNM0123456789",
	fontSize = 26,
	dpi = 160
}



function Menu:init()
	local viewport = MOAIViewport.new()
	viewport:setSize(SCREEN_RESOLUTION_X, SCREEN_RESOLUTION_Y)
	viewport:setScale(WORLD_SIZE_X, WORLD_SIZE_Y)

	self.layer = MOAILayer2D.new()
	self.layer:setViewport(viewport)

	ResourceDefinitions:set("allods_west", allods_west)

	self.shown = false

	local buttRect = {width = 300, height = 80}
	local textSize = 52

	self.buttons = {
		newGame = self:createTextbox("New game", {x=0, y=buttRect.height}, buttRect, textSize),
		options = self:createTextbox("Options", {x=0, y=0}, buttRect, textSize),
		exit = self:createTextbox("Exit", {x=0, y=-buttRect.height}, buttRect, textSize),
	}
	for _, textbox in pairs(self.buttons) do
		self.layer:insertProp(textbox)
	end
end



function Menu:show()
	if self.shown == false then
		self.shown = true
		local renderTable = MOAIRenderMgr.getRenderTable()
		table.insert(renderTable, 1, self.layer)
		MOAIRenderMgr.setRenderTable(renderTable)
	end
end



function Menu:hide()
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



function Menu:createTextbox(text, pos, size, textSize)
	local textbox = MOAITextBox.new()
	textbox:setString(text)
	textbox:setFont(ResourceManager:get("allods_west"))
	textbox:setRect(pos.x - size.width/2, pos.y - size.height/2, 
					pos.x + size.width/2, pos.y + size.height/2)
	textbox:setYFlip(true)
	textbox:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
	textbox:setTextSize(textSize or 16)
	
	return textbox
end


return Menu