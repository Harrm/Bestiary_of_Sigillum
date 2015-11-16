local Graphic = {}

local Menu = require('graphic.menu')
local Field = require('graphic.space_sygil')
local HeroesIcons = require('graphic.heroes_icons')
local GUI = require('graphic.gui')
local ResourceManager = require('resource_manager')
local ResourceDefinitions = require("resource_definitions")

local allods_west = {
	type = RESOURCE_TYPE_FONT,
	fileName = "allods_west.ttf",
	glyphs = "qwertyuiopasdfghjklzxcvbnm,./;'[]!@#$%^&*()_+-=QWERTYUIOPASDFGHJKLZXCVBNM0123456789",
	fontSize = 26,
	dpi = 160
}

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

	ResourceDefinitions:set("allods_west", allods_west)

	local textbox = MOAITextBox.new()
	textbox:setFont(ResourceManager:get("allods_west"))
	textbox:setLoc(0, 0)
	textbox:setRect(-150, -50, 
						 150, 50)
	textbox:setYFlip(true)
	textbox:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
	textbox:setTextSize(32)
	
	self.textbox = textbox

	MOAIRenderMgr.setRenderTable({self.layer})

	Menu:init()
	Menu:show()

	GUI:init()
	self.gui = GUI

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
	self.layer:removeProp(self.textbox)
	Field:hide()
	self.heroesIcons:hide()
	GUI:hide()
	Menu:show()
end



function Graphic:showField()
	self.layer:removeProp(self.textbox)
	Menu:hide()
	self.heroesIcons:show()
	GUI:show()
	Field:show()
end



function Graphic:showVictoryScreen(winner_name)
	MOAIRenderMgr.setRenderTable({self.layer})

	self.textbox:setString(winner_name.." victory")
	
	self.layer:insertProp(self.textbox)
end



function Graphic:update()
	GUI:update()
end



function Graphic:addHeroIcon(name, tileX, tileY, isEnemy)
	local modelX, modelY = Field.grid:getTileLoc(tileX, tileY)
	local worldX, worldY = Field.tilesProp:modelToWorld(modelX, modelY)
	self.heroesIcons:addHero(name, {x=worldX, y=worldY}, isEnemy)
end



function Graphic:moveHeroIcon(name, tileX, tileY)
	local modelX, modelY = Field.grid:getTileLoc(tileX, tileY)
	local worldX, worldY = Field.tilesProp:modelToWorld(modelX, modelY)

	self.heroesIcons:moveHero(name, {x=worldX, y=worldY})
end

return Graphic