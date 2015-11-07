local GUI = {}

local Logic = require('logic.logic')



function GUI:init()
	
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