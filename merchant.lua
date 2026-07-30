Merchant = Object:extend()
require "item"
require "equipment"

equipment = Equipment()

local button = require "Button"

purchasingFlag = 0
--local blindBoxPurchaseCounter = 0

confirmationCursorAnim = LoveAnimation.new("menuCursorAnimations.lua")
confirmationCursorAnim:setPosition(140, 143)

--backdrop for merchant
local merchantBackground = love.graphics.newImage("/sprites/merchant-bg.png")
--local blindBoxCardBackground = love.graphics.newImage("/sprites/blind-box-card.png")
local itemCardBackground = love.graphics.newImage("/sprites/item-card.png")
--local blindBoxIdle = love.graphics.newImage("/sprites/blind-box-idle.png")
--local blindBoxRevealAnim = LoveAnimation.new("blindBoxAnimations.lua")
--blindBoxRevealAnim:setPosition(0,0)



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
					merchant.buttons[1].text = "ITEM 1 - SOLD OUT"
					merchant.buttons[1].func = function()
						print ("This button has no function attached")
					end
					sfx_kaching:play()
					--add a kaching sound after all of them
				else
					--can't afford dialogue pops up and denied SFX plays
					sfx_broke:clone():play()
				end
			elseif purchasingFlag == 2 then
				if score >= merchant.item2Cost then
					equipment:addItem(merchant.item2.id)
					score = score - merchant.item2Cost
					merchant.buttons[2].text = "ITEM 2 - SOLD OUT"
					merchant.buttons[2].func = function()
						print ("This button has no function attached")
					end				
					sfx_kaching:play()
					--add a kaching sound after all of them
				else
					--can't afford dialogue pops up and denied SFX plays
					sfx_broke:clone():play()
				end
			elseif purchasingFlag == 3 then
				if score >= merchant.item3Cost then
					equipment:addItem(merchant.item3.id)
					score = score - merchant.item3Cost
					merchant.buttons[3].text = "ITEM 3 - SOLD OUT"
					merchant.buttons[3].func = function()
						print ("This button has no function attached")
					end
					sfx_kaching:play()
					--add a kaching sound after all of them
				else
					--can't afford dialogue pops up and denied SFX plays
					sfx_broke:clone():play()
				end
			--[[elseif purchasingFlag == 4 then
				if score >= merchant.blindBoxCost then
					equipment:addItem(merchant.blindBox.id)
					score = score - merchant.blindBoxCost
					sfx_kaching:play()
					--add a kaching sound after all of them
				else
					--can't afford dialogue pops up and denied SFX plays
					sfx_broke:clone():play()
				end]]
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
    self.buttons[1] = button("ITEM 1", optionSelect, 1, 50,13)
    self.buttons[2] = button("ITEM 2", optionSelect, 2, 50,13)
    self.buttons[3] = button("ITEM 3", optionSelect, 3, 50,13)
    self.buttons[4] = button("EXIT SHOP", endMerchant, nil, 50,13)

	self.decisionButtons.yes = button("YES", purchaseDecision, 1 , 20, 13)
	self.decisionButtons.no = button("NO", purchaseDecision, 0, 20,13)

	table.insert(self.decisionButtons, self.decisionButtons.yes)
	table.insert(self.decisionButtons, self.decisionButtons.no)

	self.ItemsList = {}

	

	--special stats

	--items
	self.item1 = nil
	self.item2 = nil
	self.item3 = nil

	--costs for the items
	self.item1Cost = 0
	self.item2Cost = 0
	self.item3Cost = 0
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
	item1Num = self:makeItemUnique(item1Num,item2Num,item3Num)
	item2Num = self:makeItemUnique(item2Num, item1Num, item3Num)
	item3Num = self:makeItemUnique(item3Num, item1Num, item2Num)

	--set the shop items
	self.item1 = equipment:returnItem(item1Num)
	self.item2 = equipment:returnItem(item2Num)
	self.item3 = equipment:returnItem(item3Num)

	--determine cost of items
	
	self.item1Cost = self:getItemCost(self.item1)

	
	self.item2Cost = self:getItemCost(self.item2)
	self.item3Cost = self:getItemCost(self.item3)

	--reset buttons
	self.buttons[1] = button("ITEM 1", optionSelect, 1, 50,13)
    self.buttons[2] = button("ITEM 2", optionSelect, 2, 50,13)
    self.buttons[3] = button("ITEM 3", optionSelect, 3, 50,13)

	self.selectedMerchantButton = self.buttons[1]
	self.selectedDecisionButton = self.decisionButtons[1]

end

--determines cost of items through parsing rarity strings and giving them values
function Merchant:getItemCost(item)
	if item.rarity == "everyday" then
		print("item rarity: everyday")
		return math.random(3500,7000)
	elseif item.rarity == "odd" then
		print("item rarity: odd")
		return math.random(7500,10000)
	elseif item.rarity == "remarkable" then
		print("item rarity: remarkable")
		return math.random(15000,25000)
	elseif item.rarity == "aberrant" then
		print("item rarity: aberrant")
		return math.random(25000,35000)
	end
end

function Merchant:rollItem()
	returnValue = math.random(1,65)

	-- TODO: recursive script? or a while loop that keeps rolling if item was already purchased... use isDupe()
	while self:isDupe(returnValue) == true or returnValue == 60 or returnValue == 47 or returnValue == 48 or returnValue == 52 or returnValue == 61 or returnValue == 63 do
		returnValue = math.random(1,65)
	end

	return returnValue
end

-- checks if an item has already been bought by player. Boolean. Used to assist in rollItem() method
function Merchant:isDupe(targetItem)
	local itemAlreadyBought = false
	for i,v in ipairs(equipment.equippedItemList) do
		if targetItem == v.id then
			itemAlreadyBought = true -- breaks loop if its a dupe!
			print("dupe detected")
			return itemAlreadyBought
		end
	end
	print("dupe not detected")
	return itemAlreadyBought --returns Boolean
	
end

-- makes all the items in the shop unique, so there aren't two of the same item
function Merchant:makeItemUnique(d,e,f)

	while d == e or d == f do
		d = self:rollItem()
	end
	return d
end


function Merchant:update(dt)
	
end

function Merchant:draw()
	--draw merchant background and merchant persistent first tier menu options
	love.graphics.draw(merchantBackground,0,0)
	self.buttons[1]:draw(10, 119, 0, 0)
	self.buttons[2]:draw(10, 129, 0, 0)
	self.buttons[3]:draw(10, 139, 0, 0)
	self.buttons[4]:draw(10, 149, 0, 0)
	menuCursorAnim:draw()

	--display depending on what is selected
	if self.selectedMerchantButton == self.buttons[1] or self.selectedMerchantButton == self.buttons[2] or self.selectedMerchantButton == self.buttons[3] then
		--display an item card
		love.graphics.draw(itemCardBackground, 123, 6)
		if self.selectedMerchantButton == self.buttons[1] then
			love.graphics.setFont(itemHeadingFont)
			love.graphics.printf({colorPalette.fauxWhite, self.item1.name},126,20,88,'center')
			--reset font
			love.graphics.setFont(font)
			love.graphics.printf({colorPalette.fauxWhite, self.item1.effect}, 138, 65, 66, 'center')
			love.graphics.printf({colorPalette.fauxWhite, "COST: " .. self.item1Cost},138,108,66,'center')
		elseif self.selectedMerchantButton == self.buttons[2] then
			love.graphics.setFont(itemHeadingFont)
			love.graphics.printf({colorPalette.fauxWhite, self.item2.name},126,20,88,'center')
			--reset font
			love.graphics.setFont(font)
			love.graphics.printf({colorPalette.fauxWhite, self.item2.effect}, 138, 65, 66, 'center')
			love.graphics.printf({colorPalette.fauxWhite, "COST: " .. self.item2Cost},138,108,66,'center')
		elseif self.selectedMerchantButton == self.buttons[3] then
			love.graphics.setFont(itemHeadingFont)
			love.graphics.printf({colorPalette.fauxWhite, self.item3.name},126,20,88,'center')
			--reset font
			love.graphics.setFont(font)
			love.graphics.printf({colorPalette.fauxWhite, self.item3.effect}, 138, 65, 66, 'center')
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