local Graphic = {}

local Menu = require('graphic.menu')
local Field = require('graphic.space_sygil')
local HeroesIcons = require('graphic.heroes_icons')



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

	self.phaseTextbox = Menu:createTextbox("Phase", {x = 0, y = 250}, {width=300, height=50}, 28)
	
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
			local modelX, modelY = Field.tilesProp:worldToModel(worldX, worldY)
			local tileX, tileY = Field.grid:locToCoord(modelX, modelY)

			self.tileCheckedCallback(tileX, tileY)
		end
	end
end



function Graphic:showMenu()
	Field:hide()
	self.layer:removeProp(self.phaseTextbox)
	self.heroesIcons:hide()
	Menu:show()
end



function Graphic:showField()
	Menu:hide()
	self.heroesIcons:show()
	Field:show()
	self.layer:insertProp(self.phaseTextbox)
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
	local propX, propY = prop:getLoc()
	MOAICoroutine.blockOnAction(prop:seekLoc(worldX, worldY, 1))
end



return Graphic