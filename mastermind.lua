Mastermind = Object:extend()

function Mastermind:new()
	self.level = 0
	self.enemyKillCount = 0
	self.killCountStatUpSpawned = false
end

--[[

	levels are decided by how many enemies you've killed
	the more enemies killed, the higher level the game gets
	the higher the level the game gets, the harder the enemies are to kill, and the more power ups you get

]]--

function Mastermind:spawn()
	--randomseed
	math.randomseed(os.time())
	--Ants
	--level indicator
	if self.level == 0 then
		for i = 0, 10 do
			table.insert(listOfEnemies,Ant(self.level,math.random(120,200),0-(math.random(12,20)*i)))
		end
		for i = 1, 3 do
			table.insert(listOfEnemies,Squirrel(1,math.random(120,200),0-(math.random(4,24)*i)))
		end
	end
end

--setLevel checks if the level has changed from the input (lvl), if it has, then it changes, otherwise, stays the same
function Mastermind:setLevel(lvl)
	if self.level ~= lvl then
		self.level = lvl
		self:nextLevel(lvl)
	end
end

--nextLevel is basically the spawn function? may be redundant
function Mastermind:nextLevel(lvl)
	-- ant spawns
	for i = 1, ((6+lvl) * (lvl+1)) do
		table.insert(listOfEnemies,Ant(lvl,math.random(120,200),0-(math.random(4,24)*i)))
		table.insert(listOfEnemies,Ant(lvl,math.random(120,200),0-(math.random(4,24)*i)))
	end

	--falcon spawns
	for i = 1, lvl+1 do
		Timer.after(math.random(1,10*lvl), function ()
			table.insert(listOfEnemies,Falcon(lvl,math.random(120,200),0-(math.random(4,24)*i)))
		end)
	end

	--squirrel spawns
	for i = 1, (2*lvl)+1 do
		Timer.after(math.random(1,2*lvl), function ()
			table.insert(listOfEnemies,Squirrel(lvl,math.random(120,200),0-(math.random(4,24)*i)))
		end)
	end

	-- power up spawns
	for i = 0,lvl do
		if player.item50Flag == true then
			local rngType = math.random(1,8)
			if rngType == 1 then
				rngType = "pspd"
			elseif rngType == 2 then
				rngType = "spd"
			elseif rngType == 3 then
				rngType = "dmg"
			elseif rngType == 4 then
				rngType = "rad"
			elseif rngType == 5 then
				rngType = "ammo"
			elseif rngType >= 6 then
				rngType = "fireBreath"
			end

			table.insert(listOfPowerups,Powerup(math.random(120,200),0-(30*i),rngType,math.random(1*self.level+1,5*(self.level+1))))
		
		else
			local rngType = math.random(1,6)
			if rngType == 1 then
				rngType = "pspd"
			elseif rngType == 2 then
				rngType = "spd"
			elseif rngType == 3 then
				rngType = "dmg"
			elseif rngType == 4 then
				rngType = "rad"
			elseif rngType == 5 then
				rngType = "fireBreath"
			elseif rngType == 6 then
				rngType = "ammo"
			end

			table.insert(listOfPowerups,Powerup(math.random(120,200),0-(30*i),rngType,math.random(1*self.level+1,5*(self.level+1))))
		end
			
	end
end

function Mastermind:spawnPowerup()
	--randomseed
	math.randomseed(os.time())

	--stat upgrades
	--[[if level == 0 then
		for i = 1,5 do
			local rngType = math.random(1,4)
			if rngType == 1 then
				rngType = "pspd"
			elseif rngType == 2 then
				rngType = "spd"
			elseif rngType == 3 then
				rngType = "dmg"
			elseif rngType == 4 then
				rngType = "rad"
			end

			table.insert(listOfPowerups,Powerup(math.random(120,200),0-(24*i),rngType,math.random(1,5*(level+1))))
		end
	end]]--
end

function Mastermind:keyPressed(key)
	--p
	if key == "/" then
		table.insert(listOfEnemies,Falcon(1,math.random(120,200),-16))
	end
	if key == "o" then
		local rngType = math.random(1,6)
			if rngType == 1 then
				rngType = "pspd"
			elseif rngType == 2 then
				rngType = "spd"
			elseif rngType == 3 then
				rngType = "dmg"
			elseif rngType == 4 then
				rngType = "rad"
			elseif rngType == 5 then
				rngType = "fireBreath"
			elseif rngType == 6 then
				rngType = "ammo"
			end
		table.insert(listOfPowerups,Powerup(math.random(120,200),-24,rngType,math.random(1,5*(self.level+1))))
	end
end

function Mastermind:killCheck()
	if self.enemyKillCount ~= 0 and self.enemyKillCount >= ((((2.5*(self.level+1)) ^ 2)+(2.5 * (self.level+1)))) then
		if player.item60Flag == true then
			print("merchant skipped bc of item :L")
		else
			startMerchant()
			print("merchant started from mastermind")
			self:setLevel(self.level + 1)
		end
	end
	-- debugging for kill count and wave spawning
	print("killcount: " .. self.enemyKillCount)
	print("kills needed for next wave: " .. ((((2.5*(self.level+1)) ^ 2)+(2.5 * (self.level+1)))))
end

function Mastermind:update(dt)
	
end

function Mastermind:draw()
	
end