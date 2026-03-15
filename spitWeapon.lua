SpitWeapon = Object:extend()

Timer = require "timer"

-- see if we can get away with spitWeapon being called only in the player class?

function SpitWeapon:new()
    --Spit weapon level
    self.spitLevel = 0
    self.spitMaxCapacity = 4
    self.spitClip = self.spitMaxCapacity
    self.spitReloadTime = 3
    self.reloadComplete = true
    self.reloadInstance = 0
    self.activeReloadTimer = 0
    self.activeReloadInstance = 0

    self.coloredText = {{184/255,181/255, 185/255},self.activeReloadTimer}
end

--[[

triggerPull is the function that's called when the weapon's "trigger" is pulled.
does the calculations of whether or not a projectile is *fired*    

]]
function SpitWeapon:triggerPull()
    --spit logic -- is it worth doing this by weapon?
    if self.spitClip > 0 and self.reloadComplete == true then
        self:fireBullet()
    elseif self.spitClip <= 0 then
        self:reload()
    end
    
end

function SpitWeapon:reload()
    --reload!
    self.reloadComplete = false
    self.reloadInstance = self.reloadInstance+1
    self.activeReloadInstance = self.activeReloadInstance+1
    --timing of reload
    if self.reloadInstance == 1 and self.activeReloadInstance == 1 then
        Timer.after(self.spitReloadTime, function()
            self:reloadOverride()
        end)
        Timer.script(function(wait)
            for i = 0, self.spitReloadTime do
                wait(1)
                print("timer is running on active reload ".. self.activeReloadTimer)
                self.activeReloadTimer = self.activeReloadTimer +1
                
            end
        end
            )
    end
end

function SpitWeapon:reloadOverride()
    self.spitClip = self.spitMaxCapacity
    self.reloadComplete = true
    self.reloadInstance = 0 
    self.activeReloadTimer = 0
    self.activeReloadInstance = 0
    print("reloading complete")
end

function SpitWeapon:fireBullet()
    table.insert(listOfSpitBullets, Spit(player.x+4, player.y))
    print("spit fired")
    self.spitClip = self.spitClip - 1
    print ("Clip: ".. self.spitClip)
end

function SpitWeapon:update(dt)
end

function SpitWeapon:draw()
    --ammo counter for dev purposes
    love.graphics.print(self.spitClip,player.x+7,player.y+15)
    --reloading status counter
    if self.reloadComplete == false then
        if self.activeReloadTimer == 2 then
            self.coloredText = {{180/255,82/255, 82/255},self.activeReloadTimer}
        else 
            self.coloredText = {{184/255,181/255, 185/255},self.activeReloadTimer}
        end
        love.graphics.print(self.coloredText,player.x, player.y+19)
    end
end
