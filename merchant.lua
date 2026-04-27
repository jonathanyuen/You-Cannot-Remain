Merchant = Object:extend()
require "item"
require "equipment"

equipment = Equipment()

local button = require "Button"


--backdrop for merchant
local merchantBackground = love.graphics.newImage("/sprites/merchant-bg.png")
local blindBoxCardBackground = love.graphics.newImage("/sprites/blind-box-card.png")
local itemCardBackground = love.graphics.newImage("/sprites/item-card.png")
local blindBoxIdle = love.graphics.newImage("/sprites/blind-box-idle.png")
local blindBoxRevealAnim = LoveAnimation.new("blindBoxAnimations.lua")
blindBoxRevealAnim:setPosition(0,0)

function Merchant:new()
	self.buttons = {}
	self.decisionButtons = {}
	--Merchant Buttons
	--second argument is a function without (), but you gotta write it!
    self.buttons.item1 = button("Item 1 (5)", item1Select, nil, 50,13)
    self.buttons.item2 = button("Item 2 (5)", item2Select, nil, 50,13)
    self.buttons.item3 = button("Item 3 (5)", item3Select, nil, 50,13)
    self.buttons.blindBox = button("BLIND BOX (2)", blindBoxSelect, nil, 50,13)
    self.buttons.extraEgg = button("EXTRA EGG (5)", extraEggSelect, nil, 50,13)

    table.insert(self.buttons, self.buttons.item1)
    table.insert(self.buttons, self.buttons.item2)
    table.insert(self.buttons, self.buttons.item3)
    table.insert(self.buttons, self.buttons.blindBox)
    table.insert(self.buttons, self.buttons.extraEgg)

	self.decisionButtons.yes = button("YES",decisionYes, nil, 20, 13)
	self.decisionButtons.no = button("NO", decisionNo, nil, 20,13)

	self.ItemsList = {}

	self.selectedMerchantButton = self.buttons[1]
	self.selectedDecisionButton = self.decisionButtons[1]

	--special stats
	
	
	
end

function Merchant:openShop()
	--initialize the items in this shop instance
	--[[
	math.random(1,40) randomize item in list... maybe randomize and take out the equipped items?

	item1 = random blach
	item2 = random
	item3 = random
	blindBox = random
	]]

	local item1Num = love.math.random(1,40)
	local item2Num = love.math.random(1,40)
	self:makeItemsUnique(item1Num,item2Num)
	local item3Num = love.math.random(1,40)
	self:makeItemsUnique(item2Num,item3Num)
	local blindBoxNum = love.math.random(1,40)
	self:makeItemsUnique(item3Num,blindBoxNum)

	self.item1 = equipment:returnItem(item1Num)
	self.item2 = equipment:returnItem(item2Num)
	self.item3 = equipment:returnItem(item3Num)
	self.blindBox = equipment:returnItem(blindBoxNum)

end

function Merchant:makeItemsUnique(h, j)
	while h == j do
		j = math.random(1,40)
	end
end


function Merchant:update(dt)

end

function Merchant:draw()
	--draw merchant background and merchant persistent first tier menu options
	love.graphics.draw(merchantBackground,0,0)
	self.buttons.item1:draw(10, 119, 0, 0)
	self.buttons.item2:draw(10, 129, 0, 0)
	self.buttons.item3:draw(10, 139, 0, 0)
	self.buttons.blindBox:draw(10, 149, 0, 0)
	self.buttons.extraEgg:draw(10, 159, 0, 0)
	menuCursorAnim:draw()

	--display depending on what is selected
	if self.selectedMerchantButton == self.buttons[1] or self.selectedMerchantButton == self.buttons[2] or self.selectedMerchantButton == self.buttons[3] then
		--display an item card
		love.graphics.draw(itemCardBackground, 123, 8)
		if self.selectedMerchantButton == self.buttons[1] then
		
		elseif self.selectedMerchantButton == self.buttons[2] then

		elseif self.selectedMerchantButton == self.buttons[3] then

		end
	elseif self.selectedMerchantButton == self.buttons[4] then
		--display blind box background!
		love.graphics.draw(blindBoxCardBackground, 123, 8)

		--display blind box
		love.graphics.draw(blindBoxIdle,0,0)

		--display writing
		love.graphics.printf("Unknown glyphs cover the top of the box's wrapping.",136,23,66,'center')

		--
	elseif self.selectedMerchantButton == self.buttons[5] then
		--health!
	end


	--draw score
	love.graphics.setFont(renownFont)
	---colored printing scores and whatnot... still haven't done calcs yet either
	love.graphics.print({colorPalette.red,"RENOWN "},227,171)
	love.graphics.print({colorPalette.fauxWhite,string.format("%04d",score)},285,171)
	love.graphics.setFont(font)

end