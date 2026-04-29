Equipment = Object:extend()
require "item"

function Equipment:new()

	self.equippedItemList = {}
	
end

--functions to help with csv
---pretty much stolen piecemeal from love2d.org lol
function splitCsvLine(line)
    local values = {}

    for value in line:gmatch("[^,]+") do
        --converts value string to other Lua types in a "smart" way
        if     tonumber(value)  then  table.insert(values, tonumber(value)) -- Number.
		elseif value == "true"  then  table.insert(values, true)            -- Boolean.
		elseif value == "false" then  table.insert(values, false)           -- Boolean.
		else                          table.insert(values, value)           -- String.
		end
    end

    return values
end

function loadCsvFile(filename)
	local csv = {}
	for line in love.filesystem.lines(filename) do
		table.insert(csv, splitCsvLine(line))
	end
	return csv
end
--load in items from csv file
local csv = loadCsvFile("items.csv")


--test: looks through and unpacks the csv. Identifies based off the "id" column, and prints out the relevant ones... useful!!
    --[[
    local equipped id = 8
    for row, values in ipairs(csv) do
        if unpack(values,1) == 8 then
            print (unpack(values))
        end
    end
    ]]--

--searches through items.csv for the item via id - once found, turns it into an Item object, adds it to the list of equipped Items!
--works! yay!
function Equipment:addItem(id)
	for row, values in ipairs(csv) do
		if unpack(values,1) == id then
			local tempItem = Item(unpack(values))
			print (tempItem.name .. " added")
		end
	end
	table.insert(self.equippedItemList, tempItem)
end

function Equipment:returnItem(id)
	for row, values in ipairs(csv) do
		if unpack(values,1) == id then
			local tempItem = Item(unpack(values))
			for i=1, 5 do
				print (tempItem[i])
			end
			print (tempItem.name .. " returned")
			return tempItem
		end
	end
	
end

function Equipment:removeItem(id)
	for i,v in ipairs(self.equippedItemList) do
		if v.id == id then
			v = nil
		end
	end
end

--run this when the player leaves the shop and starts the next stage
function Equipment:updateMango()
	for i,v in ipairs(self.equippedItemList) do
		--if v.id == 1 then
			--enemies are covered in oil... take more flame damage
		--elseif v.id == 2 then
			--knockback
		--elseif v.id == 3 then
			--increases odds of rarities with blind box drops
		if v.id == 4 then
			--tail weapon range and damage goes up
			player.ironTail.hitboxExtensionVert = player.ironTail.hitboxExtensionVert + 3
			player.ironTail.damage = player.ironTail.damage + 1
		--elseif v.id == 5 then
			--one item in next shop is free			
		--elseif v.id == 6 then
			--two items are buy one get one free
		--elseif v.id == 7 then
			--active reload is easier
			--easier

		elseif v.id == 8 then
			--active reload success replenishes one ammo
			player.item8Flag = true
		elseif v.id == 9 then
			--tail increases length
			player.ironTail.hitboxExtensionVert = player.ironTail.hitboxExtensionVert + 3
		elseif v.id == 10 then
			--tail increases width
			player.ironTail.hitboxExtensionHori = player.ironTail.hitboxExtensionHori + 3
		elseif v.id == 11 then
			--flamethrower gets more fuel
			player.fireBreath.fuel = player.fireBreath.fuel + 10
		elseif v.id == 12 then
			--hp up 1 
			print(player.health)
			player:takeDmg(-1)
			print("healed! new player health: " .. player.health)
		elseif v.id == 13 then
			--spitter ammo up 20
			player.spitter.maxCapacity = player.spitter.maxCapacity + 20
		elseif v.id == 14 then
			--flamethrower ammo up 20
			player.fireBreath.fuel = player.fireBreath.fuel + 20
		--elseif v.id == 15 then
			--lightning ammo up 5
		elseif v.id == 16 then
			--dmg up 1
			player:statUp("dmg",1)
		elseif v.id == 17 then
			--spd up 1
			player:statUp("spd",5)
		elseif v.id == 18 then
			--pspd +1
			player:statUp("pspd",1)
		elseif v.id == 19 then
			--rad +1
			player:statUp("rad",1)
		elseif v.id == 20 then
			--renown gain rate x1.25
			scoreGainRate = 1.25
		elseif v.id == 21 then
			--gain a random power up when you take damage
			player.item21Flag = true
		--elseif v.id == 22 then
			--you get one reroll for a blind box
		--elseif v.id == 23 then
			--first item bought in the shop is discounted 20%
		--elseif v.id == 24 then
			--add 1 clip size to a chosen weapon
		elseif v.id == 25 then
			--enemy spit kills +1 renown
			player.item25Flag = true
		elseif v.id == 26 then
			--enemy tail kills +1 renown
			player.item26Flag = true
		elseif v.id == 27 then
			--enemy fire kills +1 renown
			player.item27Flag = false
		elseif v.id == 28 then
			--enemy lightning kills +1 renown
		elseif v.id == 29 then
			--block 1 damage
			player.item29Flag = true
		--elseif v.id == 30 then
			--next enemy you kill explodes on death, effect resets every five seconds
		elseif v.id == 31 then
			--shell recovery time reduced
			player.recoveryTime = player.recoveryTime - 1
		--elseif v.id == 32 then
			--altar donations accessible via start menu
		--elseif v.id == 33 then
			--first blind box after getting this item is free
		elseif v.id == 34 then
			--clip size -1, damage up 2
			player.spitter.maxCapacity = player.spitter.maxCapacity - 1
			player.spitter.damage = player.spitter.damage + 2
		elseif v.id == 35 then
			--pspd -1, rad +1
			player.pspd = player.pspd - 1
			player.rad = player.rad + 1
		--elseif v.id == 36 then
			--lore drops happen more frequently
		--elseif v.id == 37 then
			--dmg +1, rad +1, recoil/knockback added
		elseif v.id == 38 then
			--reload speed increased
			player.spitter.reloadTime = player.spitter.reloadTime - 1
		elseif v.id == 39 then
			--bullets pass through enemies
			player.item39Flag = true
		--elseif v.id == 40 then
			--bullets freeze enemies
		elseif v.id == 41 then
			--infinite clip but slower firerate
			player.spitter.maxCapacity = 999
		--elseif v.id == 42 then
			--increases proficiency gain rate by 100%
		--elseif v.id == 43 then
			--enemies take damage whenever they contact mango
		--elseif v.id == 44 then
			--every time you swap weapons, you do a 1 second flip animation and gain +5 renown
		--elseif v.id == 45 then
			--renown donations to the altar are worth triple
		--elseif v.id == 46 then
			--burst fire spit
		elseif v.id == 47 then
			--hp up 3
			player.health = player.health + 3
		elseif v.id == 48 then
			--gives 200 renown
			scoreboard:updateTicker("Free Renown!", 200)
		elseif v.id == 49 then
			--dmg up 2
			player.dmg = player.dmg + 2
		elseif v.id == 50 then
			--spd up 2
			player.speed = player.speed + 5
			player.baseSpd = player.baseSpd + 5
		elseif v.id == 51 then
			--pspd up 2
			player.pspd = player.pspd + 2
		elseif v.id == 52 then
			--rad up 2
			player.rad = player.rad + 2
		elseif v.id == 53 then
			--increases damage based on renown - 5 renown = 1 dmg
			player.item53Flag = true
		--elseif v.id == 54 then
			--friend spawns at the edge, prevents one enemy from passing by the line
		--elseif v.id == 55 then
			--keep one item your next run
		--elseif v.id == 56 then
			--taking an egg's worth of damage explodes all enemies spawned in
		elseif v.id == 57 then
			--all ammo based weapons have +2 clip size
			player.spitter.maxCapacity = player.spitter.maxCapacity + 2
		--elseif v.id == 58 then
			--colliding with enemies freezes them for 2 seconds
		--elseif v.id == 59 then
			--makes you 20% bigger
		--elseif v.id == 60 then
			--bubble that shields you for 5 hits
		elseif v.id == 61 then
			--everyone moves 30% slower
			player.baseSpd = player.baseSpd*.7
			player.speed = player.speed*.7
			player.item61Flag = true
		--elseif v.id == 62 then
			--removes an item of your choice
		elseif v.id == 63 then
			--add 50 Renown
			scoreboard:updateTicker("Free Renown",500)
		--elseif v.id == 64 then
			--next shop is unavailable

		--elseif v.id == 65 then
			--mango is 20% smaller
		--elseif v.id == 66 then
			--blind boxes stay the same price and don't scale up
		--elseif v.id == 67 then
			--spit homes towards enemies
		--elseif v.id == 68 then
			--spit shoots out in a cone
		--elseif v.id == 69 then
			--lightning strikes twice
		elseif v.id == 70 then
			--hp up 6
			player.health = player.health + 6
		--elseif v.id == 71 then
			--power ups can be instant killed by tail
		elseif v.id == 72 then
			--dmg up 3
			player.dmg = player.dmg + 3
		elseif v.id == 73 then
			--spd up 3
			player.speed = player.speed + 15
			player.baseSpd = player.baseSpd + 15
		elseif v.id == 74 then
			--pspd up 3
			player.pspd = player.pspd + 3
		elseif v.id == 75 then
			--rad up 3
			player.rad = player.rad + 3
		elseif v.id == 76 then
			--all stats up
			player.dmg = player.dmg + 1
			player.rad = player.rad + 1
			player.pspd = player.pspd + 1
			player.baseSpd = player.baseSpd + 5
			player.speed = player.speed + 5
		--elseif v.id == 77 then
			--first blind box is always free
		--elseif v.id == 78 then
			--grants flight - mango can fly over enemies instead of colliding with them
		elseif v.id == 79 then
			--adds an additional stream of spit for spitter
			player.item79Flag = true
		--elseif v.id == 80 then
			--spit poisons enemies - making them explode upon death
		--elseif v.id == 81 then
			--when you're out of ammo, you replenish using renown instead
		--elseif v.id == 82 then
			--lightning keeps striking upon successful active reload, if failed, weapon is disabled for 5 seconds
		--elseif v.id == 83 then
			--mango becomes intangible
		--elseif v.id == 84 then
			--when lightning bolt is equipped, collisions stun enemies for 2 seconds
		--elseif v.id == 85 then
			--when enemies get close to you, they move slower
		--elseif v.id == 86 then
			--kills no longer count to renown, but go to the next altar
		--elseif v.id == 87 then
			--you get one reroll permanently for each blind box
		--elseif v.id == 88 then
			--whenever mango moves, its by a spinning shell that moves 10% faster than normal
		--elseif v.id == 19 then
			--you can only keep one item of your choice
		--elseif v.id == 90 then
			--lightning chains to nearby enemies
		--elseif v.id == 91 then
			--familiar stays near you, firing spit automatically - spit upgrades apply to them as well	
		end
	end
end


function Equipment:update(dt)

end

function Equipment:draw()
	

end