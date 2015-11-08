local GUI = {}

local Logic = require('logic.logic')
local ResourceManager = require('resource_manager')


function GUI:init()
	local viewport = MOAIViewport.new()
	viewport:setSize(SCREEN_RESOLUTION_X, SCREEN_RESOLUTION_Y)
	viewport:setScale(WORLD_SIZE_X, WORLD_SIZE_Y)

	self.layer = MOAILayer2D.new()
	self.layer:setViewport(viewport)

	self.shown = false
	
	self.phaseTextbox = self:createTextbox("Phase", {x = 0, y = 270}, {width=300, height=100}, 28)
	self.layer:insertProp(self.phaseTextbox)

	local firstPlayer, secondPlayer = Logic.players.first, Logic.players.second
	self.playersHpTextboxes = {}
	self.playersHpTextboxes.first = self:createTextbox(firstPlayer.name..": HEALTH", {x=-250, y=285}, {width=300, height=30}, 22)
	self.playersHpTextboxes.second = self:createTextbox(secondPlayer.name..": HEALTH", {x=250, y=285}, {width=300, height=30}, 22)

	self.layer:insertProp(self.playersHpTextboxes.first)
	self.layer:insertProp(self.playersHpTextboxes.second)

	self.heroesBars = {}
	for i = 1, #Logic.players.first.heroes do
		local hero = Logic.players.first.heroes[i]
		local str = hero.name..": "..hero.wounds.."/"..hero.maxHP
		local textbox = self:createTextbox(str, {x=-250, y=235-i*30}, {width=300, height=30}, 22)
		self.heroesBars[hero.name] = textbox
		self.layer:insertProp(textbox)
	end
	for i = 1, #Logic.players.second.heroes do
		local hero = Logic.players.second.heroes[i]
		local str = hero.name..": "..hero.wounds.."/"..hero.maxHP
		local textbox = self:createTextbox(str, {x=250, y=235-i*30}, {width=300, height=30}, 22)
		self.heroesBars[hero.name] = textbox
		self.layer:insertProp(textbox)
	end

	self.nextPhaseTextbox = self:createTextbox("Next phase", {x = 250, y = -275}, {width=300, height=30}, 22)
	self.layer:insertProp(self.nextPhaseTextbox)
end



function GUI:show()
	if self.shown == false then
		self.shown = true
		local renderTable = MOAIRenderMgr.getRenderTable()
		table.insert(renderTable, 1, self.layer)
		MOAIRenderMgr.setRenderTable(renderTable)
	end
end



function GUI:hide()
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



function GUI:update()
	local players = Logic.players
	self.playersHpTextboxes.first:setString(players.first.name..": "..players.first.hp)
	self.playersHpTextboxes.second:setString(players.second.name..": "..players.second.hp)

	for heroName, textbox in pairs(self.heroesBars) do
		local hero = Logic:getHero(nil, heroName)
		textbox:setString(hero.name..": "..hero.wounds.."/"..hero.maxHP)
	end

	self.phaseTextbox:setString(Logic.phase.." phase\n"..Logic.currentPlayer.name)
end


function GUI:createTextbox(text, pos, size, textSize)
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


return GUI