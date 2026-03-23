Player = Object:extend()
require "spitWeapon"


function Player:new()
	
	--coordinates/attributes
	self.x = 160
	self.y = 140
	self.width = 16
	self.height = 16
	self.anim = LoveAnimation.new('mangoAnimations.lua')
	self.portraitAnim = LoveAnimation.new('portraitAnimations.lua')
	self.healthAnim = LoveAnimation.new('healthAnimations.lua')
	self.healthAnim:setState("three")
	self.healthAnim:setPosition(22,142)


	--upgradable stats
	self.health = 3
	self.dmg = 0 
	self.rad = 0
	self.pspd = 0
	self.speed = 50


	--what weapons are unlocked
	self.weaponsUnlocked = {
		spit = true,
		flameThrower = false,
		railBreath = false,
		ironTail = false
	}

	--what weapons are equipped/available to be equipped
	self.spitter = SpitWeapon(self.x,self.y)
	self.weaponEquipped = {
		spitter = true
	}


	


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
	--firing
	if love.keyboard.isDown("space") and self.weaponEquipped["spitter"] then
		self.spitter:triggerPull()
	end

	--active reload
	if self.spitter.activeReloadCursorXPos >= 4 and self.spitter.activeReloadCursorXPos <= 7 and love.keyboard.isDown("space") then
		self.spitter.activeReloadSuccessFlag = 1
		scoring.counterActiveReloadSuccess = scoring.counterActiveReloadSuccess + 1
		Timer.after(5, function() 
			self.spitter.activeReloadSuccessFlag = 0
			Timer.clear()
		end)
		self.spitter:reloadOverride()
	end


end

function Player:update(dt)
	self.spitter:update(dt)

	--portrait animation
	self.portraitAnim:setPosition(229,10)
	self.portraitAnim:update(dt)


	--moving left and right
	if love.keyboard.isDown("left") then
		self.x = self.x - self.speed * dt
	elseif love.keyboard.isDown("right") then
		self.x = self.x + self.speed * dt
	end

	--moving up and down

	if love.keyboard.isDown("up") then
		self.y = self.y -self.speed * dt
	elseif love.keyboard.isDown("down") then
		self.y = self.y + self.speed * dt
	end

	--if too far to the left
	if self.x < 102 then
		self.x = 102
	end

	--if too far to the right
	if self.x + self.width> 218 then
		self.x = 218 - self.width
	end

	--if too far up
	if self.y < 0 then
		self.y = 0
	end

	--too far down
	if self.y >160 then
		self.y = 160
	end

	--animations
	if love.keyboard.isDown("space") then
		self.anim:setState("shoot")
	end
	self.anim:update(dt)

	local window_width = 320

	--update player health
    self.healthAnim:update(dt)


    
end

function Player:draw()
	
	--set player pos
	self.anim:setPosition(self.x,self.y)
	--active reload success blue?
	if self.spitter.activeReloadSuccessFlag == 1 then
		love.graphics.setColor(0,0,1)
	end

	if self.spitter.activeReloadSuccessFlag == -1 then
		love.graphics.setColor(.2,.2,.2,1)
	end
	--draw frame of player sprite
	self.anim:draw()
	love.graphics.setColor(1,1,1)
	--draw frame of player portrait
	self.portraitAnim:draw()
	--draw health
    self.healthAnim:draw()

    --draw spitter
    self.spitter:draw()
end