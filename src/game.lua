local Game = {}

local Menu = require('graphic.menu')
local Field = require('graphic.space_sygil')
local Logic = require('logic.logic')
local HeroesIcons = require('graphic.heroes_icons')


function Game:start()
	self:init()

	while not self.isOver do
		self:processInput()
		coroutine.yield()
	end

	os.exit()
end



function Game:init()
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

	MOAIInputMgr.device.keyboard:setCallback(self.onKeyboardEvent)

	Menu:init()
	self.menu = Menu.buttons

	Menu:show()
end



function Game:processInput()
	local screenX, screenY = MOAIInputMgr.device.pointer:getLoc()
	local worldX, worldY = self.layer:wndToWorld(screenX, screenY)

	if MOAIInputMgr.device.mouseLeft:down() then
		if Menu.shown then
			if self.menu.newGame:inside(worldX, worldY) then
				Menu:hide()
				self:newGame()

			elseif self.menu.options:inside(worldX, worldY) then

			elseif self.menu.exit:inside(worldX, worldY) then
				self.isOver = true
			end

		elseif Field.shown then
			local modelX, modelY = Field.tilesProp:worldToModel(worldX, worldY)
			local tileX, tileY = Field.grid:locToCoord(modelX, modelY)

			
		end
	end

end



function Game:newGame()
	Field:init()
	Logic:init()

	Logic:start("Radiant", "Dire")
	Field:show()
	HeroesIcons:init()
	self:createHeroesIcons()
	HeroesIcons:show()
end



function Game:createHeroesIcons()
	for _, hero in pairs(Logic:getHeroes()) do
		local tileLocX, tileLocY = Field.grid:getTileLoc(self:logicToGraphicCoords(hero.position))
		local worldX, worldY = Field.tilesProp:modelToWorld(tileLocX, tileLocY)
		HeroesIcons:addHero(hero.name, {x=worldX, y=worldY})
	end
end



function Game:logicToGraphicCoords(logicCoords)
	local graphicCoords = {}

	graphicCoords.x = math.ceil(logicCoords.x / 2)
	
end



function Game.onKeyboardEvent(key, down)
	if down then
		if key == 27 then
			Field:hide()
			Menu:show()
		end
	end
end

return Game