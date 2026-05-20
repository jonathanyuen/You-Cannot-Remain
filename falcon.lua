Falcon = Ant:extend()

-- TODO: change spawning to set position - falcons will stay put for a second then fly fast towards end
function Falcon:new(lvl,spawnX,spawnY)
	--coordinates/attributes
	self.x = spawnX
	self.y = spawnY
	self.speed = 24+(.15*lvl)
	if player.item32Flag == true then
		self.speed = self.speed*.7
	end
	self.anim = LoveAnimation.new('falconAnimations.lua')
	self.deathAnimation = LoveAnimation.new('deathAnimations.lua')
	self.health = 1
	self.height = 11
	self.width = 23
	self.deathLocationX = self.x
	self.deathLocationY = self.y
	self.newlyDead = true
	self.deathValue = 75 -- more than standard bc of speed?
	self.readyToClean = 5
	self.collisionDmg = 1
    self.damageFlag = false
end

--handles damage
-- TODO: damaged animation needs to be made?
function Falcon:takeDmg(dmgNum,type)
	--damaged animation
    self.damageFlag = true
    Timer.after(.1, function ()
        self.damageFlag = false
    end)
    
	--play sfx
	if type == "spit" then
		if dmgNum >= self.health then
			if player.item15Flag == true then
				scoreboard:updateTicker("Spit Kill Bonus", 10)
			end
			
		end
		sfxSuccessfulHit:clone():play()
		
	elseif type == "tail" then
        dmgNum = 1000 -- tail hits on this enemy instant kills
		if dmgNum >= self.health then
			if self.item16Flag == true then
				scoreboard:updateTicker("Tail Kill Bonus", 10)
			end
			
		end
		Timer.after(.1, function ()
			sfxIronTailHit:clone():play()
		end)
		
	elseif type == "fireBreath" then
		if dmgNum >= self.health then
			if player.item17Flag == true then
				scoreboard:updateTicker("Fire Kill Bonus", 10)

			end
			
		end
		sfxFireBreathDamage:clone():play()
	end

	--health reduction
	self.health = self.health - dmgNum

	
end

-- TODO: these enemies can't be hitstun!!
function Falcon:update(dt)
	-- status: alive, so keep it pushin
	if self:isDead() == false then	
        self.y = self.y + self.speed * dt
        if self.y > 180 then
            player:takeDmg(1)
            self.health = 0
            self.readyToClean = 6
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
		scoring.counterFalconsKilled = scoring.counterFalconsKilled + 1
		scoreboard:updateTicker("Falcon slain", self.deathValue)
		mastermind:killCheck()

	elseif self:isDead() == true and self.newlyDead == false then
		self.deathAnimation:update(dt)
		self.readyToClean = self.readyToClean+1
	end

	self.anim:update(dt)

end



function Falcon:draw()
	--alive, draw alive bug
	self.anim:setPosition(self.x-5,self.y-10)
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