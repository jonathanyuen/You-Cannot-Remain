Merchant = Object:extend()
require "item"

local button = require "Button"
local buttons = {}

--backdrop for merchant
local merchantBackground = love.graphics.newImage("/sprites/merchant-bg.png")


function Merchant:new()
	--Merchant Buttons
    buttons.item1 = button("Item 1 (5)", item1Select, nil, 50,13)
    buttons.item2 = button("Item 2 (5)", item2Select, nil, 50,13)
    buttons.item3 = button("Item 3 (5)", item3Select, nil, 50,13)
    buttons.blindBox = button("BLIND BOX (2)", blindBoxSelect, nil, 50,13)
    buttons.extraEgg = button("EXTRA EGG (5)", extraEggSelect, nil, 50,13)

    table.insert(buttons, buttons.item1)
    table.insert(buttons, buttons.item2)
    table.insert(buttons, buttons.item3)
    table.insert(buttons, buttons.blindBox)
    table.insert(buttons, buttons.extraEgg)

	self.selectedMerchantButton = buttons[1]

	--special stats
	
	
	
end

function Merchant:openShop()
	--initialize the items in this shop instance
	--[[
	math.random(1,92) randomize item in list... maybe randomize and take out the equipped items?

	item1 = random blach
	item2 = random
	item3 = random
	blindBox = random
	]]

end


function Merchant:update(dt)

end

function Merchant:draw()
	love.graphics.draw(merchantBackground,0,0)
	buttons.merchant_state.item1:draw(10, 119, 0, 0)
	buttons.merchant_state.item2:draw(10, 129, 0, 0)
	buttons.merchant_state.item3:draw(10, 139, 0, 0)
	buttons.merchant_state.blindBox:draw(10, 149, 0, 0)
	buttons.merchant_state.extraEgg:draw(10, 159, 0, 0)
	menuCursorAnim:draw()

	--draw score
	love.graphics.setFont(renownFont)
	---colored printing scores and whatnot... still haven't done calcs yet either
	love.graphics.print({colorPalette.red,"RENOWN "},227,171)
	love.graphics.print({colorPalette.fauxWhite,string.format("%04d",score)},285,171)
	love.graphics.setFont(font)

end