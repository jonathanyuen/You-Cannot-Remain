Player = Object:extend()
require "spitWeapon"
require "equipment"
require "firebreath"


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
	self.healthAnim:setPosition(27,133)

	self.activeReloadSuccessPointValue = 10

	--amt of time it takes to come out of shell when dmg'd
	self.recoveryTime = 2

	self.inShell = false

	--timer
	self.reloadTimerForPlayer = Timer.new()


	--upgradable stats
	self.health = 3
	self.dmg = 0 
	self.baseDmg = 0
	self.rad = 0
	self.pspd = 0
	self.baseSpd = 35
	self.speed = 35
	self.tailDmg = 1

	--power up status
	self.onFire = false
	self.onFireDuration = 5 -- base fireBreath powerup lasts 5 seconds -- called by powerups class

	--what weapons are unlocked
	self.weaponsUnlocked = {
		unlockedSpit = true,
		--unlockedFlameThrower = false,
		--unlockedZapBreath = false,
		unlockedIronTail = true
	}

	--what weapons are equipped/available to be equipped
	self.spitter = SpitWeapon()
	self.ironTail = IronTail()
	self.fireBreath = FireBreath()
	self.weaponEquipped = {
		spitter = self.spitter, ironTail = self.ironTail
	}

	--items
	self.equipment = Equipment()

	--item specific flags
	--active reload success replenishes ammo
	self.item2Flag = false
	--- on dmg, get a random power up
	self.item14Flag = false
	--spit kills give more renown
	self.item15Flag = false
	--tail kills give more renown
	self.item16Flag = false
	--fire kills give more renown
	self.item17Flag = false
	--block 1 instance of damage
	self.item18Flag = false
	--renown based dmg bonus
	self.item30Flag = false
	--slows everyone down 30%
	self.item32Flag = false
	--additional spit stream
	self.item40Flag = false
	--knockback
	self.item49Flag = false
	--active reload is easier
	self.item53Flag = false
	--spit goes through foes
	self.item56Flag = false
	--dmg enemies on contact
	self.item57Flag = false
	--burstfire spit
	self.item59Flag = false
	--skip next store
	self.item60Flag = false
	--cone shaped spit fire pattern
	self.item62Flag = false
	--use renown instead of ammo
	self.item64Flag = false
	--go through enemies
	self.item56Flag = false
	--more flamethrower occurrences
	self.item50Flag = false
	--free item in shop
	self.item51Flag = false
	--renown on weapon swap
	self.item58Flag = false
end


function Player:cycleWeapon()
	if self.weaponEquipped["spitter"].equipped == true then
		self.weaponEquipped["spitter"].equipped = false
		self.weaponEquipped["ironTail"].equipped = true
		--self.weaponEquipped["fireBreath"].equipped = false
	elseif self.weaponEquipped["ironTail"].equipped == true then
		self.weaponEquipped["spitter"].equipped = true
		self.weaponEquipped["ironTail"].equipped = false
		--self.weaponEquipped["fireBreath"].equipped = true
	end
	--weaponswaps -> renown gain
	if self.item58Flag == true then
		scoreboard:updateTicker("Quick Hands", 1)
	end
end

--upgrade a stat (stat) by an amount (upgradeAmt) -- these need to pass through to bullet...
function Player:statUp(stat, upgradeAmt)
	if stat == "pspd" then
		self.pspd = self.pspd + 1*upgradeAmt
    	
	elseif stat == "spd" then
		self.speed = self.speed + 10*upgradeAmt
		self.baseSpd = self.baseSpd + 10 * upgradeAmt
		
	elseif stat == "dmg" then
		self.dmg = self.dmg + 1*upgradeAmt
		
    
	elseif stat == "rad" then
		self.rad = self.rad + 1*upgradeAmt
		
    
	end
end

function Player:takeDmg(dmgNum)
	--item 27 -- block 1 damage
	if player.item18Flag == true then
		dmgNum = 0
		player.item18Flag = false
	end


	if dmgNum < 0  then
		scoreboard.scoring["nestDamage"] = scoreboard.scoring["nestDamage"] + dmgNum
	end
	self.health = self.health - dmgNum
	sfxHPDown:play()
	screenshake(.5,1)
	

	--item 14 logic - providing a power up upon damage
	if self.item14Flag == true and self.health > 0 then
		local rngType = math.random(1,4)
		if rngType == 1 then
			player:statUp("dmg",1)
		elseif rngType == 2 then
			player:statUp("spd",5)
		elseif rngType == 3 then
			player:statUp("pspd",1)
		elseif rngType == 4 then
			player:statUp("rad",1)
		end
	end

	--play health anim
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

function Player:getHit()
	if self.item65Flag == true then
		--nothin!
	else
		screenshake(.1,.5)
		player.anim:setState("intoShell")
		self.portraitAnim:setState("sad")
		sfxInShell:play()
		self.inShell = true
		player.speed = 0
		scoring["timesTouched"] = scoring["timesTouched"] + 1
		Timer.after(self.recoveryTime, function() 
			--sfxOutOfShell:play()
			player.anim:setState("outOfShell") 
			self.portraitAnim:setState("idle")
			player.speed = player.baseSpd
			player.inShell = false
		end)
	end
	
    
end

function Player:keyPressed(key)
	--firing weapons

	--spitter
	if love.keyboard.isDown("space") and self.weaponEquipped["spitter"].equipped == true and self.onFire == false and player.inShell == false and self.spitter.outOfAmmoFlag == false then
		self.spitter:triggerPull()
	end

	
	

	--ironTail
	if love.keyboard.isDown("space") and self.weaponEquipped["ironTail"].equipped == true and self.onFire == false and player.inShell == false and self.ironTail.swinging == false then
		self.ironTail.swinging = true
		
		self.ironTail:smackTail()
		self.anim:setState("melee")
		
		Timer.after(self.ironTail.fireRate, function()
			self.ironTail.swinging = false
		end)
		
	end

	--active reload
	if self.spitter.outOfAmmoFlag == false and self.spitter.activeReloadCursorXPos >= self.spitter.activeReloadLowerBound and self.spitter.activeReloadCursorXPos <= self.spitter.activeReloadUpperBound and love.keyboard.isDown("space") and player.inShell == false then
		sfxActiveReloadSuccess:play()
		self.portraitAnim:setState("activeReloadSuccess")

		if self.item2Flag == true then
			self.spitter.ammoLeft = self.spitter.ammoLeft + 2
		end

		self.spitter.activeReloadSuccessFlag = 1
		scoring.counterActiveReloadSuccess = scoring.counterActiveReloadSuccess + 1
		scoreboard:updateTicker("Active Reload", self.activeReloadSuccessPointValue)
		self.reloadTimerForPlayer:after(5, function() 
			--print(self.spitter.activeReloadSuccessFlag)
			self.portraitAnim:setState("idle")
			self.spitter.activeReloadSuccessFlag = 0
			self.reloadTimerForPlayer:clear()
		end)
		self.spitter:reloadOverride()
	end
end

function Player:keyReleased(key)
	--[[
	if key == "space" and self.weaponEquipped["fireBreath"].equipped == true and player.inShell == false then
		self.fireBreath.flameAnim:setState("stop")
		self.fireBreath:changeBreathState(false)
		--print("flames should stop")
	end
	]]
end

function Player:update(dt)
	--renown damage - item 30
	if self.item30Flag == true then
		self.dmg = self.baseDmg + (score/1000)
	end

	--fireBreath
	if self.onFire == true then
		self.fireBreath:triggerPull()
		self.anim:setState("fireBreathing")
	else
		self.fireBreath.flameAnim:setState("stop")
		self.fireBreath:changeBreathState(false)
	end

	--update clock
	self.reloadTimerForPlayer:update(dt)
	--update weapons
	self.spitter:update(dt)
	self.ironTail:update(dt)
	self.fireBreath:update(dt)

	--portrait animation
	self.portraitAnim:setPosition(229,10)
	self.portraitAnim:update(dt)

	--fire breath (here bc you hold down a key)
	--[[
	if self.weaponEquipped["fireBreath"].equipped == true and player.inShell == false and player.fireBreath.overheatFlag == false then
		if love.keyboard.isDown("space") then
		--print("firebreath triggered")
			self.fireBreath:triggerPull()
			self.anim:setState("shoot")
		else
			self.fireBreath.flameAnim:setState("stop")
			self.fireBreath:changeBreathState(false)
		end
	end
	]]
	


	--moving left and right
	if love.keyboard.isDown("left") and waveClearState == false then
		self.x = self.x - self.speed * dt
	elseif love.keyboard.isDown("right") and waveClearState == false then
		self.x = self.x + self.speed * dt
	end

	--moving up and down

	if love.keyboard.isDown("up") and waveClearState == false then
		self.y = self.y -self.speed * dt
	elseif love.keyboard.isDown("down") and waveClearState == false then
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

	--mango animations
	if love.keyboard.isDown("space") and self.weaponEquipped["spitter"].equipped == true and self.inShell == false then
		self.anim:setState("shoot")
	end


	if love.keyboard.isDown("space") and self.weaponEquipped["ironTail"].equipped == true and player.inShell == false and self.weaponEquipped["ironTail"].swinging == false then
		self.anim:setState("melee")
	end

	self.anim:update(dt)

	local window_width = 320

	--update player health
    self.healthAnim:update(dt)

    
end

function Player:draw()
	
	--set player pos
	self.anim:setPosition(self.x,self.y-4)
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

    --draw weapon associated graphics under mango
	if self.weaponEquipped["spitter"].equipped == true then
		self.spitter:draw()
	elseif self.weaponEquipped["ironTail"].equipped == true then
    	self.ironTail:draw()
	end
	if self.onFire == true then
		self.fireBreath:draw()
	end
end