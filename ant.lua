Ant = Object:extend()

function Ant:new(lvl,spawnX,spawnY)
	--coordinates/attributes
	self.x = spawnX
	self.y = spawnY
	self.speed = 10
	self.anim = LoveAnimation.new('antAnimations.lua')
	self.deathAnimation = LoveAnimation.new('deathAnimations.lua')
	self.health = lvl
	self.height = 16
	self.width = 16
	self.deathLocationX = self.x
	self.deathLocationY = self.y
	self.newlyDead = true
	self.readyToClean = 5
end

--handles damage
function Ant:takeDmg(dmgNum)
	self.health = self.health - dmgNum
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
		
		self.y = self.y + self.speed * dt
		if self.y > 180 then
			player:takeDmg(1)
			self.health = 0
			self.readyToClean = 6
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
		mastermind.enemyKillCount = mastermind.enemyKillCount+1

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
		love.graphics.print(self.health,self.x+8, self.y+16)
	end

	--dead, play death animation, whatever it may be
	if self:isDead() == true and self.newlyDead == false then
		self.deathAnimation:draw()
	end

end