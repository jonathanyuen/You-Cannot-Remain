Player = Object:extend()

function Player:new()
	
	--coordinates/attributes
	self.x = 160
	self.y = 140
	self.width = 16
	self.anim = LoveAnimation.new('mangoAnimations.lua')
	self.portraitAnim = LoveAnimation.new('portraitAnimations.lua')
	self.healthAnim = LoveAnimation.new('healthAnimations.lua')
	self.healthAnim:setPosition(22,142)


	--upgradable stats
	self.health = 9
	self.dmg = 0 
	self.rad = 0
	self.pspd = 0
	self.speed = 50
end

--upgrade a stat (stat) by an amount (upgradeAmt) -- these need to pass through to bullet...
function Player:statUp(stat, upgradeAmt)
	if stat == "pspd" then
		self.pspd = self.pspd + 1*upgradeAmt
    	pspdStatUpChevronAnim:setState("active")
    	if self.pspd == 1 then
    		pspdStatLevelAnim:setState("one")
    	elseif self.pspd == 2 then
    		pspdStatLevelAnim:setState("two")
    	elseif self.pspd == 3 then
    		pspdStatLevelAnim:setState("three")
    	elseif self.pspd == 4 then
    		pspdStatLevelAnim:setState("four")
    	elseif self.pspd == 5 then
    		pspdStatLevelAnim:setState("five")
    	elseif self.pspd == 6 then
    		pspdStatLevelAnim:setState("six")
    	end
	elseif stat == "spd" then
		self.speed = self.speed + 50*upgradeAmt
		spdStatUpChevronAnim:setState("active")
		if self.speed == 50 + 50*1 then
    		spdStatLevelAnim:setState("one")
    	elseif self.speed == 50 + 50*2 then
    		spdStatLevelAnim:setState("two")
    	elseif self.speed == 50 + 50*3 then
    		spdStatLevelAnim:setState("three")
    	elseif self.speed == 50 + 50*4 then
    		spdStatLevelAnim:setState("four")
    	elseif self.speed == 50 + 50*5 then
    		spdStatLevelAnim:setState("five")
    	elseif self.speed == 50 + 50*6 then
    		spdStatLevelAnim:setState("six")
    	end
	elseif stat == "dmg" then
		self.dmg = self.dmg + 1*upgradeAmt
		dmgStatUpChevronAnim:setState("active")
		if self.dmg == 1 then
    		dmgStatLevelAnim:setState("one")
    	elseif self.dmg == 2 then
    		dmgStatLevelAnim:setState("two")
    	elseif self.dmg == 3 then
    		dmgStatLevelAnim:setState("three")
    	elseif self.dmg == 4 then
    		dmgStatLevelAnim:setState("four")
    	elseif self.dmg == 5 then
    		dmgStatLevelAnim:setState("five")
    	elseif self.dmg == 6 then
    		dmgStatLevelAnim:setState("six")
    	end
    
	elseif stat == "rad" then
		self.rad = self.rad + 1*upgradeAmt
		radStatUpChevronAnim:setState("active")
		if self.rad == 1 then
    		radStatLevelAnim:setState("one")
    	elseif self.rad == 2 then
    		radStatLevelAnim:setState("two")
    	elseif self.rad == 3 then
    		radStatLevelAnim:setState("three")
    	elseif self.rad == 4 then
    		radStatLevelAnim:setState("four")
    	elseif self.rad == 5 then
    		radStatLevelAnim:setState("five")
    	elseif self.rad == 6 then
    		radStatLevelAnim:setState("six")
    	end
    
	end
	print ("hp: ".. self.health .. "\ndmg: " .. self.dmg .. "\nrad: " .. self.rad .. "\nspd: " .. self.speed .. "\npspd: " .. self.pspd)
end

function Player:takeDmg(dmgNum)
	self.health = self.health - dmgNum
	if self.health == 9 then
        self.healthAnim:setState("nine")
    elseif player.health == 8 then
        self.healthAnim:setState("eight")
    elseif player.health == 7 then
        self.healthAnim:setState("seven")
    elseif player.health == 6 then
        self.healthAnim:setState("sevenToSix")
    elseif player.health == 5 then
        self.healthAnim:setState("five")
    elseif player.health == 4 then
        self.healthAnim:setState("four")
    elseif player.health == 3 then
        self.healthAnim:setState("fourToThree")
    elseif player.health == 2 then
        self.healthAnim:setState("two")
    elseif player.health == 1 then
        self.healthAnim:setState("one")
    elseif player.health == 0 then
        self.healthAnim:setState("oneToZero")
    end
end

function Player:keyPressed(key)
	--spacebar
	if key == "space" then
		table.insert(listOfBullets, Bullet(self.x+4, self.y))
	end
end

function Player:update(dt)
	--portrait animation
	self.portraitAnim:setPosition(229,10)
	self.portraitAnim:update(dt)


	--moving left and right
	if love.keyboard.isDown("left") then
		self.x = self.x - self.speed * dt
	elseif love.keyboard.isDown("right") then
		self.x = self.x + self.speed * dt
	end

	--animations
	if love.keyboard.isDown("space") then
		self.anim:setState("shoot")
	end
	self.anim:update(dt)

	local window_width = 320

	--if too far to the left
	if self.x < 102 then
		self.x = 102
	end

	--if too far to the right
	if self.x + self.width> 218 then
		self.x = 218 - self.width
	end

	--update player health
    self.healthAnim:update(dt)
end

function Player:draw()
	--set player pos
	self.anim:setPosition(self.x,self.y)
	--draw frame of player sprite
	self.anim:draw()
	--draw frame of player portrait
	self.portraitAnim:draw()
	--draw health
    self.healthAnim:draw()
end