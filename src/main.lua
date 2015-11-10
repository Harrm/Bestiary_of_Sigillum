WORLD_SIZE_X = 800;
WORLD_SIZE_Y = 600;

SCREEN_RESOLUTION_X = 800;
SCREEN_RESOLUTION_Y = 600;

-- DEBUG = true

MOAISim.openWindow("Bestiary", SCREEN_RESOLUTION_X, SCREEN_RESOLUTION_Y) 

RESOURCE_TYPE_IMAGE = 0
RESOURCE_TYPE_TILED_IMAGE = 1
RESOURCE_TYPE_FONT = 2
RESOURCE_TYPE_SOUND = 3

Game = require("game")

function mainLoop()
	Game:start()
end

gameThread = MOAICoroutine.new()
gameThread:run(mainLoop)

