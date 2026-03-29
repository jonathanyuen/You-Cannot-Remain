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
		for i = 0, 5 do
			table.insert(listOfEnemies,Ant(self.level,math.random(120,200),0-(16*i)))
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

	for i = 1, (5 * (lvl + 1)) do
		table.insert(listOfEnemies,Ant(lvl,math.random(120,200),-16*i))
		print ("ant for wave " .. i .. " created")
	end

	for i = 0,lvl do
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

			table.insert(listOfPowerups,Powerup(math.random(120,200),0-(30*i),rngType,math.random(1*self.level+1,5*(self.level+1))))
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
	if key == "p" then
		table.insert(listOfEnemies,Ant(math.random(120,200),-16))
	end
	if key == "o" then
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
		table.insert(listOfPowerups,Powerup(math.random(120,200),-24,rngType,math.random(1,5*(self.level+1))))
	end
end

function Mastermind:update(dt)
	if 12 > self.enemyKillCount and self.enemyKillCount > 5 then
		self:setLevel(2)
	elseif 20 > self.enemyKillCount and self.enemyKillCount > 12 then
		self:setLevel(3)
	elseif 35 > self.enemyKillCount and self.enemyKillCount > 20 then
		self:setLevel(4)
	elseif 60 > self.enemyKillCount and self.enemyKillCount > 35 then
		self:setLevel(5)
	elseif 100 > self.enemyKillCount and self.enemyKillCount > 60 then
		self:setLevel(6)
	elseif 150 > self.enemyKillCount and self.enemyKillCount > 100 then
		self:setLevel(7)
	elseif 225 > self.enemyKillCount and self.enemyKillCount > 150 then
		self:setLevel(8)
	elseif self.enemyKillCount and self.enemyKillCount > 225 then
		self:setLevel(9)
	end
end

function Mastermind:draw()
	
end