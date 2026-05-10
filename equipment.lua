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
	local tempItem
	for row, values in ipairs(csv) do
		if unpack(values,1) == id then
			tempItem = Item(unpack(values))
			table.insert(self.equippedItemList, tempItem)
			print (tempItem.name .. " added")
		end
	end
	for i,v in ipairs(self.equippedItemList) do
		print(v.name)
	end
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
		if v.resolved == false then
			if v.id == 1 then
				--tail weapon range and damage goes up
				player.ironTail.hitboxExtensionVert = player.ironTail.hitboxExtensionVert + 3
				player.ironTail.damage = player.ironTail.damage + 1
				v.resolved = true

			elseif v.id == 2 then
				--active reload success replenishes one ammo
				player.item2Flag = true
				v.resolved = true
			elseif v.id == 3 then
				--tail increases length
				player.ironTail.hitboxExtensionVert = player.ironTail.hitboxExtensionVert + 3
				v.resolved = true
			elseif v.id == 4 then
				--tail increases width
				player.ironTail.hitboxExtensionHori = player.ironTail.hitboxExtensionHori + 3
				v.resolved = true
			elseif v.id == 5 then
				--flamethrower gets more fuel
				player.fireBreath.fuel = player.fireBreath.fuel + 10
				v.resolved = true
			elseif v.id == 6 then
				--hp up 1 
				print(player.health)
				player:takeDmg(-1)
				print("healed! new player health: " .. player.health)
				v.resolved = true
			elseif v.id == 7 then
				--spitter ammo up 20
				player.spitter.maxCapacity = player.spitter.maxCapacity + 20
				v.resolved = true
			elseif v.id == 8 then
				--flamethrower ammo up 20
				player.fireBreath.fuel = player.fireBreath.fuel + 20
				v.resolved = true
			elseif v.id == 9 then
				--dmg up 1
				player:statUp("dmg",1)
				v.resolved = true
			elseif v.id == 10 then
				--spd up 1
				player:statUp("spd",5)
				v.resolved = true
			elseif v.id == 11 then
				--pspd +1
				player:statUp("pspd",1)
				v.resolved = true
			elseif v.id == 12 then
				--rad +1
				player:statUp("rad",1)
				v.resolved = true
			elseif v.id == 13 then
				--renown gain rate x1.25
				scoreGainRate = 1.25
				v.resolved = true
			elseif v.id == 14 then
				--gain a random power up when you take damage
				player.item14Flag = true
				v.resolved = true
			elseif v.id == 15 then
				--enemy spit kills +1 renown
				player.item15Flag = true
				v.resolved = true
			elseif v.id == 16 then
				--enemy tail kills +1 renown
				player.item16Flag = true
				v.resolved = true
			elseif v.id == 17 then
				--enemy fire kills +1 renown
				player.item17Flag = false
				v.resolved = true
			elseif v.id == 18 then
				--block 1 damage
				player.item18Flag = true
				v.resolved = true
			elseif v.id == 19 then
				--shell recovery time reduced
				player.recoveryTime = player.recoveryTime - 1
				v.resolved = true
			elseif v.id == 20 then
				--clip size -1, damage up 2
				player.spitter.maxCapacity = player.spitter.maxCapacity - 1
				player.spitter.damage = player.spitter.damage + 2
				v.resolved = true
			elseif v.id == 21 then
				--pspd -1, rad +1
				player.pspd = player.pspd - 1
				player.rad = player.rad + 1
				v.resolved = true
			elseif v.id == 22 then
				--reload speed increased
				player.spitter.reloadTime = player.spitter.reloadTime - 1
				v.resolved = true
			elseif v.id == 23 then
				--infinite clip but slower firerate
				player.spitter.maxCapacity = 999
				v.resolved = true
			elseif v.id == 24 then
				--hp up 3
				player.health = player.health + 3
				v.resolved = true
			elseif v.id == 25 then
				--gives 200 renown
				scoreboard:updateTicker("Free Renown!", 200)
				v.resolved = true
			elseif v.id == 26 then
				--dmg up 2
				player.dmg = player.dmg + 2
				v.resolved = true
			elseif v.id == 27 then
				--spd up 2
				player.speed = player.speed + 5
				player.baseSpd = player.baseSpd + 5
				v.resolved = true
			elseif v.id == 28 then
				--pspd up 2
				player.pspd = player.pspd + 2
				v.resolved = true
			elseif v.id == 29 then
				--rad up 2
				player.rad = player.rad + 2
				v.resolved = true
			elseif v.id == 30 then
				--increases damage based on renown - 5 renown = 1 dmg
				player.item30Flag = true
				player.baseDmg = player.dmg
				v.resolved = true
			elseif v.id == 31 then
				--all ammo based weapons have +2 clip size
				player.spitter.maxCapacity = player.spitter.maxCapacity + 2
				v.resolved = true
			elseif v.id == 32 then
				--everyone moves 30% slower
				player.baseSpd = player.baseSpd*.7
				player.speed = player.speed*.7
				player.item32Flag = true
				v.resolved = true
			elseif v.id == 33 then
				--add 50 Renown
				scoreboard:updateTicker("Free Renown",500)
				v.resolved = true
			elseif v.id == 34 then
				--hp up 6
				player.health = player.health + 6
				v.resolved = true
			elseif v.id == 35 then
				--dmg up 3
				player.dmg = player.dmg + 3
				v.resolved = true
			elseif v.id == 36 then
				--spd up 3
				player.speed = player.speed + 15
				player.baseSpd = player.baseSpd + 15
				v.resolved = true
			elseif v.id == 37 then
				--pspd up 3
				player.pspd = player.pspd + 3
				v.resolved = true
			elseif v.id == 38 then
				--rad up 3
				player.rad = player.rad + 3
				v.resolved = true
			elseif v.id == 39 then
				--all stats up
				player.dmg = player.dmg + 1
				player.rad = player.rad + 1
				player.pspd = player.pspd + 1
				player.baseSpd = player.baseSpd + 5
				player.speed = player.speed + 5
				v.resolved = true
			elseif v.id == 40 then
				--adds an additional stream of spit for spitter
				player.item40Flag = true
				v.resolved = true
			end
		end
	end
end


function Equipment:update(dt)

end

function Equipment:draw()
	

end