SpitWeapon = Object:extend()

Timer = require "timer"

-- see if we can get away with spitWeapon being called only in the player class?

function SpitWeapon:new()
    --Spit weapon level
    self.level = 0
    self.maxCapacity = 4
    self.clip = self.maxCapacity
    self.reloadTime = 3
    self.reloadComplete = true
    self.reloadInstance = 0
    self.activeReloadTimer = 0
    self.activeReloadInstance = 0

    --colored text for temp active reload timer
    self.coloredText = {{184/255,181/255, 185/255},self.activeReloadTimer}

    --active reload variables?
    self.activeReloadBarWidth = 15
    self.activeReloadBarHeight = 3
    self.activeReloadBarColor = {100/255,99/255,101/255}

    self.activeReloadActiveZoneWidth = 3
    self.activeReloadActiveZoneColor = {184/255, 181/255, 185/255}

    self.activeReloadCursorWidth = 1
    self.activeReloadCursorHeight = 5
    self.activeReloadCursorColor = {237/255,225/255,158/255}
    self.activeReloadCursorXPos = 0
    self.activeReloadCursorYPos = 0


end

--[[

triggerPull is the function that's called when the weapon's "trigger" is pulled.
does the calculations of whether or not a projectile is *fired*    

]]
function SpitWeapon:triggerPull()
    --spit logic -- is it worth doing this by weapon?
    if self.clip > 0 and self.reloadComplete == true and self.reloadInstance == 0 and self.activeReloadInstance == 0 then
        self:fireBullet()
    elseif self.clip <= 0 then
        self:reload()
    end
    
end

--handles logic on reloading - timing and also active reload
function SpitWeapon:reload()
    self.reloadComplete = false
    --flags to help manage reload
    self.reloadInstance = self.reloadInstance+1
    self.activeReloadInstance = self.activeReloadInstance+1
    --timing of 'natural' reload
    if self.reloadInstance == 1 and self.activeReloadInstance == 1 then
        Timer.after(self.reloadTime, function()
            self:reloadOverride()
        end)
        
    end
end

--actual reloading function without handling logic
--resets clip size, resets flags
function SpitWeapon:reloadOverride()
    self.clip = self.maxCapacity
    self.reloadComplete = true
    self.reloadInstance = 0 
    self.activeReloadTimer = 0
    self.activeReloadInstance = 0
    self.activeReloadCursorXPos = 0
    Timer.clear()
end

function SpitWeapon:fireBullet()
    table.insert(listOfSpitBullets, Spit(player.x+4, player.y))
    self.clip = self.clip - 1
end

function SpitWeapon:update(dt)
    if self.reloadInstance == 1 and self.activeReloadInstance == 1 then
        self.activeReloadCursorXPos = self.activeReloadCursorXPos + 15 * dt
    end
end

function SpitWeapon:draw()
    --ammo counter for dev purposes
    if self.reloadComplete == true then
        love.graphics.print(self.clip,player.x+7,player.y+15)
    else
        --draw background bar
        love.graphics.setColor(self.activeReloadBarColor)
        love.graphics.rectangle("fill", player.x+1, player.y+18, self.activeReloadBarWidth, self.activeReloadBarHeight)
        love.graphics.setColor(1,1,1)

        --draw active reload range
        love.graphics.setColor(self.activeReloadActiveZoneColor)
        love.graphics.rectangle("fill", player.x+6, player.y+18, self.activeReloadActiveZoneWidth, self.activeReloadBarHeight)
        --have to reset color or shades get weird!!!
        love.graphics.setColor(1,1,1)

        --draw active reload cursor
        love.graphics.setColor(self.activeReloadCursorColor)
        love.graphics.rectangle("fill", self.activeReloadCursorXPos + player.x+1, self.activeReloadCursorYPos+player.y+17,self.activeReloadCursorWidth,self.activeReloadCursorHeight)
        love.graphics.setColor(1,1,1)
    end
end
