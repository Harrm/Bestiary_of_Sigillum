local Game = {}

local Logic = require('logic.logic')
local Graphic = require('graphic.graphic')
local Heroes = require('logic.heroes')

function Game:start()
	self:init()

	while not self.isOver do
		Graphic:processMouse()
		coroutine.yield()
	end

	os.exit()
end



function Game:init()
	Graphic:init()
	Graphic.newGameCallback = function()self:newGame()end
	Graphic.exitCallback = function() Game.isOver=true end
	Graphic.tileCheckedCallback = function(x, y)self:tileChecked(x, y)end
	MOAIInputMgr.device.keyboard:setCallback(self.onKeyboardEvent)
end



function Game:newGame()
	Logic:init("Radiant", "Dire")
	Logic:addHero("Radiant", Heroes.Vinctume)

	Logic:start()
	self:createHeroesIcons()
	Graphic.phaseTextbox:setString(Logic.phase.." phase")
end



function Game:tileChecked(tileX, tileY)
	local logicCoords = self:graphicToLogicCoords({x=tileX, y=tileY})
	local hero = Logic:getHero(logicCoords)
	if hero ~= nil then
		self.currentHero = hero
	
	elseif self.currentHero ~= nil then
		self.currentHero:moveTo(logicCoords)
		local graphicCoords = self:logicToGraphicCoords(self.currentHero.position)
		Graphic:moveHeroIcon(self.currentHero.name, graphicCoords.x, graphicCoords.y)
	end
end



function Game:createHeroesIcons()
	for _, hero in pairs(Logic:getHeroes()) do
		local tile = self:logicToGraphicCoords(hero.position)
		Graphic:addHeroIcon(hero.name, tile.x, tile.y)
	end
end



function Game:logicToGraphicCoords(logicCoords)
	local graphicCoords = {}

	graphicCoords.x = math.ceil(logicCoords.x / 2)

	if logicCoords.x % 2 == 0 then
		graphicCoords.y = logicCoords.y * 2
	
	elseif logicCoords.x == 3 then
		graphicCoords.y = logicCoords.y * 2 - 1
	
	else
		graphicCoords.y = logicCoords.y * 2 + 1
	end

	return graphicCoords
end



function Game:graphicToLogicCoords(graphicCoords)
	local logicCoords = {}

	if graphicCoords.y % 2 == 0 then
		logicCoords.x = graphicCoords.x * 2
	else
		logicCoords.x = graphicCoords.x * 2 - 1
	end

	if logicCoords.x ~= 3 then
		logicCoords.y = math.floor(graphicCoords.y / 2)
	else
		logicCoords.y = math.ceil(graphicCoords.y / 2)
	end

	return logicCoords
end



function Game.onKeyboardEvent(key, down)
	if down then
		if key == 27 then
			Graphic:showMenu()
		end
	end
end

return Game
