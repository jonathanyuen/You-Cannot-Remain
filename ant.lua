Ant = Object:extend()

function Ant:new(lvl,spawnX,spawnY)
	--coordinates/attributes
	self.x = spawnX
	self.y = spawnY
	self.speed = 5+(.15*lvl)
	if player.item32Flag == true then
		self.speed = self.speed*.7
	end
	self.anim = LoveAnimation.new('antAnimations.lua')
	self.deathAnimation = LoveAnimation.new('deathAnimations.lua')
	self.health = math.ceil((lvl/2)+1)
	self.height = 16
	self.width = 16
	self.deathLocationX = self.x
	self.deathLocationY = self.y
	self.newlyDead = true
	self.deathValue = 50
	self.readyToClean = 5
	self.collisionDmg = 1
	self.hitStunned = false
	self.scorelessDeath = false
end

--handles damage
function Ant:takeDmg(dmgNum,type)
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
		--knockback
		self.y = self.y - 1
		
		--freeze position for duration
		self.hitStunned = true
		
		--expire the hitstun
		Timer.after(player.spitter.hitstun,function() 
			self.hitStunned = false
			self.anim:setState("walking")
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
			self.anim:setState("walking")
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
			self.anim:setState("walking")
		end)
	end

	--health reduction
	self.health = self.health - dmgNum

	

	if player.item49Flag == true then
		self.y = self.y-2 --enemy gets knocked back
	end

	
end

--checks Collisions
function Ant:checkCollision(obj)
    local self_left = self.x 
    local self_right = self.x + self.width
    local self_top = self.y
    local self_bottom = self.y + self.height

    local obj_left = obj.x
    local obj_right = obj.x + obj.width
    local obj_top = obj.y
    local obj_bottom = obj.y + obj.height

    if  self_right > obj_left
    and self_left < obj_right
    and self_bottom > obj_top
    and self_top < obj_bottom then
        self:collisionWithMango()
    end
end

--handles consequences of collision with Mango
function Ant:collisionWithMango()
	if collisionInstance == 0 then

        --on collision with player - mango goes into shell

        ---!!!WORK ON INSTANCES SO IT JUST HAPPENS ONCE UGHHG
        collisionInstance = collisionInstance + 1
        print(collisionInstance)
        player:getHit()
		if player.item57Flag == true then
			self:takeDmg(player.baseDmg, "thorns")
		end
        Timer.after(3,function() 
        	collisionInstance = 0 
    	end)
	end
end

--literally *only* checks if the health of the Ant is zero
function Ant:isDead()
	if self.health <= 0 then
		return true
	else 
		return false
	end
end

function Ant:update(dt)
	-- status: alive, so keep it pushin
	if self:isDead() == false then
		if self.hitStunned == false and waveClearState == false then
			self.y = self.y + self.speed * dt
			if self.y > 180 then
				player:takeDmg(1)
				self.health = 0
				self.readyToClean = 6
				self.scorelessDeath = true
			end
			self:checkCollision(player)
		end
	
	-- status: dead! play death animation
	elseif self:isDead() == true and self.newlyDead == true then
		self.deathLocationX = self.x
		self.deathLocationY = self.y
		self.deathAnimation:setPosition(self.deathLocationX,self.deathLocationY)
		self.deathAnimation:update(dt)
		self.x = -1000
		self.y = -1000
		self.newlyDead = false
		if self.scorelessDeath == false then
			mastermind.enemyKillCount = mastermind.enemyKillCount+1
			scoring.counterAntsKilled = scoring.counterAntsKilled + 1
			scoreboard:updateTicker("Enemy slain", self.deathValue)
			mastermind:killCheck()
		end
		screenshake(.05,.2)

	elseif self:isDead() == true and self.newlyDead == false then
		self.deathAnimation:update(dt)
		self.readyToClean = self.readyToClean+1
	end

	self.anim:update(dt)

end

function Ant:draw()
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

end