local Graphic = {}

local Menu = require('graphic.menu')
local Field = require('graphic.space_sygil')
local HeroesIcons = require('graphic.heroes_icons')
local Logic = require('logic.logic')
Graphic.GUI = require('graphic.gui')
local GUI = Graphic.GUI

function Graphic:init()
	if DEBUG then
		MOAIDebugLines.setStyle(MOAIDebugLines.TEXT_BOX, 1, 1, 1, 1, 1)
		MOAIDebugLines.setStyle(MOAIDebugLines.TEXT_BOX_LAYOUT, 1, 0, 0, 1, 1)
		MOAIDebugLines.setStyle(MOAIDebugLines.TEXT_BOX_BASELINES, 1, 1, 0, 0, 1)

		MOAIDebugLines.setStyle(MOAIDebugLines.PROP_MODEL_BOUNDS, 1, 1, 1, 0, 0)
		MOAIDebugLines.setStyle(MOAIDebugLines.PROP_WORLD_BOUNDS, 1, 0, 0, 1, 0)
	end

	local viewport = MOAIViewport.new()
	viewport:setSize(SCREEN_RESOLUTION_X, SCREEN_RESOLUTION_Y)
	viewport:setScale(WORLD_SIZE_X, WORLD_SIZE_Y)

	self.layer = MOAILayer2D.new()
	self.layer:setViewport(viewport)

	MOAIRenderMgr.setRenderTable({self.layer})

	Menu:init()
	Menu:show()

	GUI:init()
	
	Field:init()
	self.heroesIcons = HeroesIcons:create()
end



function Graphic:processMouse()
	local screenX, screenY = MOAIInputMgr.device.pointer:getLoc()
	local worldX, worldY = self.layer:wndToWorld(screenX, screenY)

	if MOAIInputMgr.device.mouseLeft:down() then
		if Menu.shown then
			if Menu.buttons.newGame:inside(worldX, worldY) then
				self.newGameCallback()
				Graphic:showField()

			elseif Menu.buttons.options:inside(worldX, worldY) then

			elseif Menu.buttons.exit:inside(worldX, worldY) then
				self.exitCallback()
			end

		elseif Field.shown then
			local checkedHeroName = nil
			for heroName, textbox in pairs(GUI.heroesBars) do
				if textbox:inside(worldX, worldY) then
					checkedHeroName = heroName
				end
			end
			if checkedHeroName ~= nil then
				self.heroCheckedCallback(checkedHeroName)

			elseif GUI.nextPhaseTextbox:inside(worldX, worldY) then
				self.nextPhaseCallback()
			
			elseif Field.tilesProp:inside(worldX, worldY) then
				local modelX, modelY = Field.tilesProp:worldToModel(worldX, worldY)
				local tileX, tileY = Field.grid:locToCoord(modelX, modelY)

				self.tileCheckedCallback(tileX, tileY)
			end
		end
		self:update()
	end
end



function Graphic:showMenu()
	Field:hide()
	self.heroesIcons:hide()
	GUI:hide()
	Menu:show()
end



function Graphic:showField()
	Menu:hide()
	self.heroesIcons:show()
	GUI:show()
	Field:show()
end



function Graphic:showVictoryScreen(winner_name)
	MOAIRenderMgr.setRenderTable({self.layer})

	local textbox = MOAITextBox.new()
	textbox:setString("Victory: Player "..winner_name)
	textbox:setFont(ResourceManager:get("allods_west"))
	textbox:setRect(-150, -50, 
					150, 50)
	textbox:setYFlip(true)
	textbox:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
	textbox:setTextSize(32)

	self.layer:insertProp(textbox)
end



function Graphic:update()
	GUI:update()
end



function Graphic:addHeroIcon(name, tileX, tileY)
	local modelX, modelY = Field.grid:getTileLoc(tileX, tileY)
	local worldX, worldY = Field.tilesProp:modelToWorld(modelX, modelY)
	self.heroesIcons:addHero(name, {x=worldX, y=worldY})
end



function Graphic:moveHeroIcon(name, tileX, tileY)
	local modelX, modelY = Field.grid:getTileLoc(tileX, tileY)
	local worldX, worldY = Field.tilesProp:modelToWorld(modelX, modelY)
	local prop = self.heroesIcons.icons[name]

	if not prop.moving then
		local propX, propY = prop:getLoc()
		prop.moving = true
		self.action = prop:seekLoc(worldX, worldY, 1)
		self.action:setListener(MOAITimer.EVENT_TIMER_END_SPAN, function() prop.moving = false end)
	else
		self.action:stop()
		self.action = prop:seekLoc(worldX, worldY, 1)
		self.action:setListener(MOAITimer.EVENT_TIMER_END_SPAN, function() prop.moving = false end)
	end
end

return Graphic