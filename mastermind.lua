Mastermind = Object:extend()
require "wave"

local waveCursor = love.graphics.newImage("sprites/wave-clear-cursor.png")
--local wavesCsv = player.equipment:loadCsvFile(wavesCsv)



function Mastermind:new()
	self.wavesCsv = loadCsvFile("waves.csv")
	self.level = 1
	self.enemyKillCount = 0 --total
	self.killCountStatUpSpawned = false
	self.item60ResolvedFlag = false
	self.waves = {}
	self:setUpWaves()

	self.killsNeededToAdvance = self.waves[self.level+1].numKillsToClear
	self.currentKillCount = 0 --by wave 

	
end

--[[

	levels are decided by how many enemies you've killed
	the more enemies killed, the higher level the game gets
	the higher the level the game gets, the harder the enemies are to kill, and the more power ups you get

]]--

--accepts an argument for what type of entity to spawn, then spawns once instance entity
function Mastermind:spawnEntity(type,i)
	if type == "ant" then
		table.insert(listOfEnemies, Ant(self.level-1, math.random(120,200), 0 - (math.random(1,14)*i)))
	elseif type == "falcon" then
		table.insert(listOfEnemies,Falcon(self.level-1,math.random(120,200),0-(math.random(4,24)*i)))
	elseif type == "squirrel" then
		table.insert(listOfEnemies,Squirrel(self.level-1,math.random(120,200),0-(math.random(4,24)*i)))

	elseif type == "ice" then
		--not done yet
	elseif type == "rock" then
		--not done yet
	elseif type == "powerup" then
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

--spawns the wave for the current level
function Mastermind:spawnWave()
	--randomseed
	math.randomseed(os.time())
	
	--Ants
	for i = 1,self.waves[self.level+1].numAnts do
		self:spawnEntity("ant",i)
	end

	--Falcons
	for i = 1, self.waves[self.level+1].numFalcons do
		Timer.after(math.random(1,8*self.level), function ()
			self:spawnEntity("falcon",i)
		end)
	end

	--Squirrels
	for i = 1, self.waves[self.level+1].numSquirrels do
		Timer.after(math.random(1,2*self.level), function ()
			self:spawnEntity("squirrel",i)
		end)
	end
	--Ice TODO

	--Rocks TODO

	--Power Ups
	for i = 1, self.waves[self.level+1].numPowerUps do
		self:spawnEntity("powerup",i)
	end

end

--TODO finish new Mastermind function

--sets up waves array with each wave and how much should spawn
function Mastermind:setUpWaves()
	local tempWave
	for row, values in ipairs(self.wavesCsv) do
		tempWave = Wave(unpack(values))
		table.insert(self.waves, tempWave)
	end
end

--OLD
--setLevel checks if the level has changed from the input (lvl), if it has, then it changes, otherwise, stays the same
function Mastermind:nextLevel()
	self.level = self.level + 1
	self.currentKillCount = 0
	self.killsNeededToAdvance = self.waves[self.level+1].numKillsToClear
	self:spawnWave()
	
end


function Mastermind:keyPressed(key)
	--p
	if key == "/" then
		table.insert(listOfEnemies,Falcon(1,math.random(120,200),-16))
	end
	if key == "o" then
		
		table.insert(listOfPowerups,Powerup(math.random(120,200),-24,"fireBreath",math.random(1,5*(self.level+1))))
	end
end

function Mastermind:killCheck()
	self.currentKillCount = self.currentKillCount + 1
	if self.currentKillCount ~= 0 and self.currentKillCount >= self.killsNeededToAdvance then
		if player.item60Flag == true and self.item60ResolvedFlag == false then
			print("merchant skipped bc of item :L")
			self.item60ResolvedFlag = true
			self:nextLevel()
		else
			waveCleared()
			self:nextLevel()
		end
	end
	-- debugging for kill count and wave spawning
	print("wave killcount: " .. self.currentKillCount)
	print("total killcount: ".. self.enemyKillCount)
	print("kills needed for next wave: " .. self.killsNeededToAdvance)
end

function Mastermind:update(dt)
end

function Mastermind:draw()
	--a drawn progress indicator until wave clear
	

	love.graphics.setColor(colorPalette.fauxWhite)
	love.graphics.rectangle("fill", 20, 36, math.floor(60 * (self.currentKillCount/self.killsNeededToAdvance)), 4)
	love.graphics.setColor(1,1,1)

	--cursor for the progress indicator
	--[[the math here is: the cursor is drawn so it follows the 
		rightmost edge of the rectangle that is the wave progress indicator

		so it's: (your killcount / the kills needed for next wave) * width of the progress indicator (which is 60)
	]]
	love.graphics.draw(waveCursor, math.floor(60 * (self.currentKillCount/self.killsNeededToAdvance))+ 15 , 43)
end