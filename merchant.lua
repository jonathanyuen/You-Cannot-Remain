Merchant = Object:extend()
require "item"
require "equipment"

equipment = Equipment()

local button = require "Button"

purchasingFlag = 0
local blindBoxPurchaseCounter = 0

confirmationCursorAnim = LoveAnimation.new("menuCursorAnimations.lua")
confirmationCursorAnim:setPosition(140, 145)

--backdrop for merchant
local merchantBackground = love.graphics.newImage("/sprites/merchant-bg.png")
local blindBoxCardBackground = love.graphics.newImage("/sprites/blind-box-card.png")
local itemCardBackground = love.graphics.newImage("/sprites/item-card.png")
local blindBoxIdle = love.graphics.newImage("/sprites/blind-box-idle.png")
local blindBoxRevealAnim = LoveAnimation.new("blindBoxAnimations.lua")
blindBoxRevealAnim:setPosition(0,0)



local function optionSelect(selection)
	--this function needs to somehow lock the player into the purchase decision, until player selects "no" 
	purchasingFlag = selection
	print("purchasing flag after selection: " .. purchasingFlag)
end

local function purchaseDecision(decision)
	--this function handles if a player says "yes" or "no" to purchasing an item
	if purchasingFlag ~= 0 then
		if decision == 0 then
			purchasingFlag = 0
		elseif decision == 1 then
			if purchasingFlag == 1 then
				if score >= merchant.item1Cost then
					equipment:addItem(merchant.item1.id)
					print(merchant.item1Cost)
					score = score - merchant.item1Cost
					print ("item 1 - " .. merchant.item1.name .. " added!")
					merchant.buttons.item1 = button("ITEM 1 - SOLD OUT", nil, nil, 50,13)
					--add a kaching sound after all of them
				else
					--can't afford dialogue pops up and denied SFX plays
				end
			elseif purchasingFlag == 2 then
				if score >= merchant.item2Cost then
					equipment:addItem(merchant.item2.id)
					score = score - merchant.item2Cost
					print ("item 1 - " .. merchant.item1.name .. " added!")
					merchant.buttons.item2 = button("ITEM 2 - SOLD OUT", nil, nil, 50,13)
					--add a kaching sound after all of them
				else
					--can't afford dialogue pops up and denied SFX plays
				end
			elseif purchasingFlag == 3 then
				if score >= merchant.item3Cost then
					equipment:addItem(merchant.item3.id)
					score = score - merchant.item3Cost
					print ("item 1 - " .. merchant.item1.name .. " added!")
					merchant.buttons.item3 = button("ITEM 3 - SOLD OUT", nil, nil, 50,13)
					--add a kaching sound after all of them
				else
					--can't afford dialogue pops up and denied SFX plays
				end
			elseif purchasingFlag == 4 then
				if score >= merchant.blindBoxCost then
					equipment:addItem(merchant.blindBox.id)
					score = score - merchant.blindBoxCost
					print ("item 1 - " .. merchant.item1.name .. " added!")
					--add a kaching sound after all of them
				else
					--can't afford dialogue pops up and denied SFX plays
				end
			end
			purchasingFlag = 0
			print("purchase decision triggered")
		end
	end
end

function Merchant:new()
	self.buttons = {}
	self.decisionButtons = {}
	--Merchant Buttons
	--second argument is a function without (), but you gotta write it!
    self.buttons.item1 = button("ITEM 1", optionSelect, 1, 50,13)
    self.buttons.item2 = button("ITEM 2", optionSelect, 2, 50,13)
    self.buttons.item3 = button("ITEM 3", optionSelect, 3, 50,13)
    self.buttons.blindBox = button("BLIND BOX", optionSelect, 4, 50,13)
    self.buttons.quitShop = button("EXIT SHOP", endMerchant, nil, 50,13)

	table.insert(self.buttons, self.buttons.item1)
    table.insert(self.buttons, self.buttons.item2)
    table.insert(self.buttons, self.buttons.item3)
    table.insert(self.buttons, self.buttons.blindBox)
    table.insert(self.buttons, self.buttons.quitShop)

	self.decisionButtons.yes = button("YES", purchaseDecision, 1 , 20, 13)
	self.decisionButtons.no = button("NO", purchaseDecision, 0, 20,13)

	table.insert(self.decisionButtons, self.decisionButtons.yes)
	table.insert(self.decisionButtons, self.decisionButtons.no)

	self.ItemsList = {}

	self.selectedMerchantButton = self.buttons[1]
	self.selectedDecisionButton = self.decisionButtons[1]

	--special stats

	--items
	self.item1 = nil
	self.item2 = nil
	self.item3 = nil
	self.blindBox = nil

	--costs for the items
	self.item1Cost = 0
	self.item2Cost = 0
	self.item3Cost = 0
	self.blindBoxCost = 0
	self.extraEggCost = 0
	
	
	
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
	
	--making sure there aren't duplicates
	local item1Num = self:rollItem()
	local item2Num = self:rollItem()
	local item3Num = self:rollItem()
	local blindBoxNum = self:rollItem()
	self:makeItemsUnique(item1Num,item2Num,item3Num,blindBoxNum)

	--set the shop items
	self.item1 = equipment:returnItem(item1Num)
	self.item2 = equipment:returnItem(item2Num)
	self.item3 = equipment:returnItem(item3Num)
	self.blindBox = equipment:returnItem(blindBoxNum)

	--determine cost of items
	self.item1Cost = self:getItemCost(self.item1)
	self.item2Cost = self:getItemCost(self.item2)
	self.item3Cost = self:getItemCost(self.item3)
	self.blindBoxCost = 100 * (1 + blindBoxPurchaseCounter)

end

--determines cost of items through parsing rarity strings and giving them values
function Merchant:getItemCost(item)
	if item.rarity == "everyday" then
		return 1 * (mastermind.level+.5) * 200
	elseif item.rarity == "odd" then
		return 2 * (mastermind.level+.5) * 200
	elseif item.rarity == "remarkable" then
		return 5 * (mastermind.level+.5) * 200
	elseif item.rarity == "aberrant" then
		return 10 * (mastermind.level+.5) * 200
	end
end

function Merchant:rollItem()
	local everydayPctg = 50
	local oddPctg = 30
	local remarkablePctg = 15
	local aberrantPctg = 5

	local randomNum = math.random(1,100)
	if randomNum <= everydayPctg then
		return math.random(1,22)
	elseif randomNum <= everydayPctg + oddPctg then
		return math.random(23,30)
	elseif randomNum <= everydayPctg + oddPctg + remarkablePctg then
		return math.random(31,39)
	elseif randomNum <= everydayPctg + oddPctg + remarkablePctg + aberrantPctg then
		return 40
	end
end

function Merchant:makeItemsUnique(h, i, j, k)
	while h == j or h == i or h == k do
		h = self:rollItem()
	end
	while j == h or j == i or j == k do
		j = self:rollItem()
	end
	while i == h or i == j or i == k do
		i = self:rollItem()
	end
	while k == h or k == i or k == j do
		j = self:rollItem()
	end
	print("item 1: " .. h .. "\nitem2: " .. i .. "\nitem3: " .. j .. "\nblind box: " .. k)
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
	self.buttons.quitShop:draw(10, 159, 0, 0)
	menuCursorAnim:draw()

	--display depending on what is selected
	if self.selectedMerchantButton == self.buttons[1] or self.selectedMerchantButton == self.buttons[2] or self.selectedMerchantButton == self.buttons[3] then
		--display an item card
		love.graphics.draw(itemCardBackground, 123, 8)
		if self.selectedMerchantButton == self.buttons[1] then
			love.graphics.setFont(itemHeadingFont)
			love.graphics.printf({colorPalette.fauxWhite, self.item1.name},138,78,66,'center')
			--reset font
			love.graphics.setFont(font)
			love.graphics.printf({colorPalette.fauxWhite, "COST: " .. self.item1Cost},138,108,66,'center')
		elseif self.selectedMerchantButton == self.buttons[2] then
			love.graphics.setFont(itemHeadingFont)
			love.graphics.printf({colorPalette.fauxWhite, self.item2.name},138,78,66,'center')
			--reset font
			love.graphics.setFont(font)
			love.graphics.printf({colorPalette.fauxWhite, "COST: " .. self.item2Cost},138,108,66,'center')
		elseif self.selectedMerchantButton == self.buttons[3] then
			love.graphics.setFont(itemHeadingFont)
			love.graphics.printf({colorPalette.fauxWhite, self.item3.name},138,78,66,'center')
			--reset font
			love.graphics.setFont(font)
			love.graphics.printf({colorPalette.fauxWhite, "COST: " .. self.item3Cost},138,108,66,'center')
		end

		-- purchasing
		if purchasingFlag ~= 0 then
			print("decision dialogue should display")
			confirmationCursorAnim:draw()

			love.graphics.setFont(pixelPurlFont)
			love.graphics.printf({colorPalette.red, "BUY?"}, 140, 130, 66, 'center')
			love.graphics.setFont(font)

			--decision buttons
			self.decisionButtons.no:draw(170, 140, 0, 0)
			self.decisionButtons.yes:draw(140, 140, 0, 0)
		end
	elseif self.selectedMerchantButton == self.buttons[4] then
		--display blind box background!
		love.graphics.draw(blindBoxCardBackground, 123, 8)

		--display blind box
		love.graphics.draw(blindBoxIdle,0,0)

		--display writing
		love.graphics.printf({colorPalette.fauxWhite, "Unknown glyphs cover the top of the box's wrapping."},136,23,66,'center')

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