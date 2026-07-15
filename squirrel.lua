Squirrel = Ant:extend()

-- TODO: change spawning to set position - falcons will stay put for a second then fly fast towards end
function Squirrel:new(lvl,spawnX,spawnY)
	--coordinates/attributes
	self.x = spawnX
	self.y = spawnY
	self.speed = 4+(.5*lvl)
	if player.item32Flag == true then
		self.speed = self.speed*.7
	end
	self.anim = LoveAnimation.new('squirrelAnimations.lua')
	self.deathAnimation = LoveAnimation.new('deathAnimations.lua')
	self.health = 1+(.5*lvl)
	self.height = 20
	self.width = 20
	self.deathLocationX = self.x
	self.deathLocationY = self.y
	self.newlyDead = true
	self.deathValue = 100 -- more than standard bc of speed?
	self.readyToClean = 5
	self.collisionDmg = 1
    self.damageFlag = false
	self.direction = math.random(0,1) --0 is left, 1 is right
end

--handles damage
-- TODO: damaged animation needs to be made?
function Squirrel:takeDmg(dmgNum,type)
	--damaged animation
	self.anim:setState("damaged")
	--play sfx
	if type == "spit" then
		if dmgNum >= self.health then
			if player.item15Flag == true then
				scoreboard:updateTicker("Spit Kill Bonus", 10)
			end
			
		end
		sfxSuccessfulHit:clone():play()
		self.y = self.y - 5
		
		--freeze position for duration
		self.hitStunned = true
		
		--expire the hitstun
		Timer.after(player.spitter.hitstun,function() 
			self.hitStunned = false
			self.anim:setState("running")
		end)
	elseif type == "tail" then
		if dmgNum >= self.health then
			if player.item16Flag == true then
				scoreboard:updateTicker("Tail Kill Bonus", 10)
			end
			
		end
		Timer.after(.1, function ()
			sfxIronTailHit:clone():play()
		end)
		--freeze position for duration
		self.hitStunned = true

		self.y = self.y - 5
		
		--expire the hitstun
		Timer.after(player.ironTail.hitstun,function() 
			self.hitStunned = false
			self.anim:setState("running")
		end)
	elseif type == "fireBreath" then
		if dmgNum >= self.health then
			if player.item17Flag == true then
				scoreboard:updateTicker("Fire Kill Bonus", 10)

			end
			
		end
		sfxFireBreathDamage:clone():play()
		--freeze position for duration
		self.hitStunned = true
		
		--expire the hitstun
		Timer.after(player.fireBreath.hitstun,function() 
			self.hitStunned = false
			self.anim:setState("running")
		end)
	end

	--health reduction
	self.health = self.health - dmgNum

	
	
	if player.item49Flag == true then
		self.y = self.y-2 --enemy gets knocked back
	end

	
end

function Squirrel:update(dt)
	-- status: alive, so keep it pushin
	if self:isDead() == false and waveClearState == false then	
		--y axis movement
        self.y = self.y + self.speed * dt
        if self.y > 180 then
            player:takeDmg(1)
            self.health = 0
            self.readyToClean = 6
        end

		--x axis movement
		if self.direction == 1 then
			self.x = self.x + ((8 + self.speed) * dt)
			if self.x >= 200 then
				self.direction = 0
			end
		elseif self.direction == 0 then
			self.x = self.x - ((8 + self.speed) * dt)
			if self.x <= 102 then
				self.direction = 1
			end
		end
        self:checkCollision(player)
	
	-- status: dead! play death animation
	elseif self:isDead() == true and self.newlyDead == true then
		self.deathLocationX = self.x
		self.deathLocationY = self.y
		self.deathAnimation:setPosition(self.deathLocationX,self.deathLocationY)
		self.deathAnimation:update(dt)
		self.x = -1000
		self.y = -1000
		self.newlyDead = false
		mastermind.enemyKillCount = mastermind.enemyKillCount+1
		scoring.counterSquirrelsKilled = scoring.counterSquirrelsKilled + 1
		scoreboard:updateTicker("Squirrel slain", self.deathValue)
		mastermind:killCheck()
		screenshake(.3,.3)


	elseif self:isDead() == true and self.newlyDead == false then
		self.deathAnimation:update(dt)
		self.readyToClean = self.readyToClean+1
	end

	self.anim:update(dt)

end



function Squirrel:draw()
	--alive, draw alive bug
	self.anim:setPosition(self.x,self.y)
	if self:isDead() == false then
		self.anim:draw()
		--love.graphics.print(self.health,self.x+8, self.y+16)
	end

	--dead, play death animation, whatever it may be
	if self:isDead() == true and self.newlyDead == false then
		self.deathAnimation:draw()
	end

    --hit flash white
    if self.damageFlag == true then
        love.graphics.setColor(.999,.999,.999)
    else love.graphics.setColor(1,1,1)
    end

end