Powerup = Object:extend()
	--[[
	
	power-ups.png - sprite sheet
		20x24 single sprite size

	]]--

function Powerup:new(spawnX,spawnY,type,hp)
	--coordinates/attributes
	self.x = spawnX
	self.y = spawnY
	
	self.speed = 2

	self.type = type

	
	--set animation file
	self.anim = LoveAnimation.new('powerupAnimations.lua')

	--set visible animation type
	if self.type == "pspd" then
		self.anim:setState("pspd")
	elseif self.type == "spd" then
		self.anim:setState("spd")
	elseif self.type == "dmg" then
		self.anim:setState("dmg")
	elseif self.type == "rad" then
		self.anim:setState("rad")
	end

	-- probably needs a new death animation...
	self.deathAnimation = LoveAnimation.new('deathAnimations.lua')


	self.health = hp
	self.height = 24
	self.width = 20
	self.deathLocationX = self.x
	self.deathLocationY = self.y
	self.newlyDead = true
	self.readyToClean = 5
end

--handles damage
function Powerup:takeDmg(dmgNum)
	self.health = self.health - dmgNum
end

--literally *only* checks if the health of the Ant is zero
function Powerup:isDead()
	if self.health <= 0 then
		return true
	else 
		return false
	end
end

function Powerup:update(dt)
	
	-- status: alive, so keep it pushin
	if self:isDead() == false then
		self.y = self.y + self.speed * dt
		if self.y > 180 then
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

		--dead, so pass through an upgrade
		if self.type == "pspd" then
			player:statUp("pspd",1)
		elseif self.type == "spd" then
			player:statUp("spd",1)
		elseif self.type == "dmg" then
			player:statUp("dmg",1)
		elseif self.type == "rad" then
			player:statUp("rad",1)
		end

	elseif self:isDead() == true and self.newlyDead == false then
		self.deathAnimation:update(dt)
		self.readyToClean = self.readyToClean+1
	end

	self.anim:update(dt)

end

function Powerup:draw()
	--alive, draw health

	--alive, draw alive buff
	self.anim:setPosition(self.x,self.y)
	if self:isDead() == false then
		self.anim:draw()
		love.graphics.print(self.health,self.x+10, self.y+24)
	end

	--dead, play death animation, whatever it may be
	if self:isDead() == true and self.newlyDead == false then
		self.deathAnimation:draw()
	end

end