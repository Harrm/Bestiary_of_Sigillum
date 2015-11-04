local ResourceDefinitions = {}

local definitions = {}

function ResourceDefinitions:setDefinitions(new_definitions)
	definitions = new_definitions
end

function ResourceDefinitions:set(name, definition)
	definitions[name] = definition
end

function ResourceDefinitions:get(name)
	return definitions[name]
end

function ResourceDefinitions:remove(name)
	definitions[name] = nil
end

--[[

{
	type = RESOURCE_TYPE_IMAGE
	fileName = "image.png",
	width = 62,
	height = 62
}

{
	type = RESOURCE_TYPE_TILED_IMAGE,
	fileName = "tiles.png",
	tileMapSize = {3, 2}
}

{
	type = RESOURCE_TYPE_FONT,
	fileName = "myfont.ttf",
	glyphs = “0123456789”,
	fontSize = 26,
	dpi = 160
}

{
	type = RESOURCE_TYPE_SOUND,
	fileName = "sugarfree.mp3",
	loop = true,
	volume = 0.6
}


--]]
return ResourceDefinitions