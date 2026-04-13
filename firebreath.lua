FireBreath = Weapon:extend()

--will prob need another type of timer
local reloadTimer = Timer.new()

-- see if we can get away with spitWeapon being called only in the player class?

function FireBreath:new()
    --defaulted to spit config
    --weapon level
    self.equipped = 0
    self.level = 0
    self.fuel = 4
    self.outOfAmmoFlag = false
    
    --exclamation mark when it hits lower?
    self.tempResistance = 10
    self.temp = 0
    self.overheatFlag = false

    

    self.flameAnim = LoveAnimation.new('firebreathAnimations.lua')

    
    
end

--[[

triggerPull is the function that's called when the weapon's "trigger" is pulled.
does the calculations of whether or not a projectile is *fired*    

]]
function FireBreath:triggerPull()
    if self.outOfAmmoFlag == false and self.overheatFlag == false then
        if self.fuel > 0 then
            --need new sound
            sfxSpit:clone():play()
            self:fire()
        end
    end
    
end

function FireBreath:fire()
    --so this should pretty much make it so the animation plays... and then also create a hitbox for the enemies
    self.flameAnim:setState("startup")
end


--checks if out of ammo and sets a flag to true
function FireBreath:outOfAmmo()
    if self.fuel == 0 then
        self.outOfAmmoFlag = true
    else
        self.outOfAmmoFlag = false
    end
end

function FireBreath:update(dt)
    --checks if its out of ammo
    self:outOfAmmo()
    --flame anim position
	self.flameAnim:setPosition(player.x-6, player.y-35)
    self.flameAnim:update(dt)
end

function FireBreath:draw()
    --ammo counter for dev purposes
    if self.outOfAmmoFlag == false then
        love.graphics.print(self.fuel,player.x+7,player.y+15)
        self.flameAnim:draw()
    end

    --needs exclamation mark for overheatin'
end
