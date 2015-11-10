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
	Logic:init("Radiant", "Dire")
	Logic:addHero("Radiant", Heroes.Vinctume)
	Logic:addHero("Radiant", Heroes.Redux)
	Logic:addHero("Radiant", Heroes.Manus)
	Logic:addHero("Dire", Heroes.Ferrarius)
	Logic:addHero("Dire", Heroes.Ballistarius)
	Logic:addHero("Dire", Heroes.Messum)

	Graphic:init()
	Graphic.newGameCallback = function() self:newGame() end
	Graphic.exitCallback = function() Game.isOver = true end
	Graphic.tileCheckedCallback = function(x, y) self:tileChecked(x, y) end
	Graphic.nextPhaseCallback = function() Logic:nextPhase() end
	Graphic.heroCheckedCallback = 
		function(heroName) self:setCurrentHero(Logic:getHero(nil, heroName)) end
	
	self:createHeroesIcons()
	MOAIInputMgr.device.keyboard:setCallback(self.onKeyboardEvent)
end



function Game:newGame()
	Logic:start()
	Graphic:update()
end



function Game:tileChecked(tileX, tileY)
	io.flush()
	local logicCoords = Game.graphicToLogicCoords({x=tileX, y=tileY})
	local hero = Logic:getHero(logicCoords)
	if hero ~= nil then
		self:setCurrentHero(hero)

	elseif self.currentHero ~= nil then
		print("Move", self.currentHero.name, "to", logicCoords.x, logicCoords.y,
				"from", self.currentHero:getPosition().x, self.currentHero:getPosition().y)
		Logic:moveHero(self.currentHero, logicCoords)
		print("Now is", self.currentHero:getPosition().x, self.currentHero:getPosition().y)
		local graphicCoords = Game.logicToGraphicCoords(self.currentHero:getPosition())
		Graphic:moveHeroIcon(self.currentHero.name, graphicCoords.x, graphicCoords.y)
	end
	Graphic:update()
	io.flush()
end



function Game:setCurrentHero(hero)
	if self.currentHero ~= nil then
		Graphic.heroesIcons.icons[self.currentHero.name]:setScl(1)
	end
	self.currentHero = hero
	Graphic.heroesIcons.icons[hero.name]:setScl(0.9)
end



function Game:heroChecked(heroName)


end



function Game:createHeroesIcons()
	for _, hero in pairs(Logic.players.first.heroes) do
		local tile = Game.logicToGraphicCoords(hero:getPosition())
		Graphic:addHeroIcon(hero.name, tile.x, tile.y)
	end

	for _, hero in pairs(Logic.players.second.heroes) do
		local tile = Game.logicToGraphicCoords(hero:getPosition())
		Graphic:addHeroIcon(hero.name, tile.x, tile.y)
	end

end



function Game.onKeyboardEvent(key, down)
	if down then
		if key == 27 then
			Graphic:showMenu()
		end
	end
end



function Game.logicToGraphicCoords(logicCoords)
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



function Game.graphicToLogicCoords(graphicCoords)
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

return Game
