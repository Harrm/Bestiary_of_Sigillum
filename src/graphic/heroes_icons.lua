local HeroesIcons = {}

local ResourceManager = require("resource_manager")
local ResourceDefinitions = require("resource_definitions")

local heroes_icons = {
	type = RESOURCE_TYPE_TILED_IMAGE,
	fileName = "heroes_portraits.png",
	tileMapSize = {3, 3}
}

local auras = {
	type = RESOURCE_TYPE_TILED_IMAGE,
	fileName = "aura.png",
	tileMapSize = {2, 1}
}

function HeroesIcons:create()
	local self = {}

	local viewport = MOAIViewport.new()
	viewport:setSize(SCREEN_RESOLUTION_X, SCREEN_RESOLUTION_Y)
	viewport:setScale(WORLD_SIZE_X, WORLD_SIZE_Y)

	self.layer = MOAILayer2D.new()
	self.layer:setViewport(viewport)
	
	ResourceDefinitions:set("heroes_icons", heroes_icons)
	ResourceDefinitions:set("auras", auras)

	self.shown = false
	
	self.iconsDeck = ResourceManager:get("heroes_icons")
	self.iconsDeck:setRect(-42, -42, 42, 42)

	self.icons = {}

	self.aurasDeck = ResourceManager:get("auras")
	self.aurasDeck:setRect(-56, -56, 56, 56)

	self.auras = {}

	self.heroNames = {
		Vinctume=1, Ferrarius=2, Suxum=3,
		Cerberus=4, Redux=5, Ballistarius=6,
		Manus=7, Messum=8, Goecio=9
	}

	setmetatable(self, {__index = HeroesIcons})

	return self
end



function HeroesIcons:show()
	if not self.shown then
		self.shown = true
		local renderTable = MOAIRenderMgr.getRenderTable()
		table.insert(renderTable, 1, self.layer)
		MOAIRenderMgr.setRenderTable(renderTable)
	end
end



function HeroesIcons:hide()
	if self.shown then
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



function HeroesIcons:addHero(name, pos, isEnemy)
	local aura = MOAIProp2D.new()
	aura:setDeck(self.aurasDeck)
	aura:setIndex(isEnemy and 1 or 2)
	self.layer:insertProp(aura)
	self.auras[name] = aura

	local icon = MOAIProp2D.new()
	icon:setDeck(self.iconsDeck)
	icon:setLoc(pos.x, pos.y)
	icon:setIndex(self.heroNames[name])
	self.layer:insertProp(icon)
	self.icons[name] = icon

	self.auras[name]:setParent(self.icons[name])
end



function HeroesIcons:moveHero(name, pos)
	local icon = self.icons[name]

	if not icon.moving then
		icon.moving = true
		self.action = icon:seekLoc(pos.x, pos.y, 0.5, MOAIEaseType.SOFT_EASE_OUT)
		self.action:setListener(MOAITimer.EVENT_TIMER_END_SPAN, function() icon.moving = false end)
	else
		self.action:stop()
		self.action = icon:seekLoc(pos.x, pos.y, 0.5, MOAIEaseType.SOFT_EASE_OUT)
		self.action:setListener(MOAITimer.EVENT_TIMER_END_SPAN, function() icon.moving = false end)
	end
end



function HeroesIcons:swapAuras()
	for _, aura in pairs(self.auras) do
		if aura:getIndex() == 1 then
			aura:setIndex(2)
		elseif aura:getIndex() == 2 then
			aura:setIndex(1)
		else
			error("Something bad with auras indicies")
		end
	end
end



return HeroesIcons