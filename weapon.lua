Weapon = Object:extend()

reloadTimer = Timer.new()

-- see if we can get away with spitWeapon being called only in the player class?

function Weapon:new()
    --defaulted to spit config
    --Spit weapon level
    self.equipped = 0
    self.level = 0
    self.maxCapacity = 4
    self.clip = self.maxCapacity
    --not including what's in the clip already
    self.ammoLeft = 4
    self.outOfAmmoFlag = false
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

    --flag for if the active reload cursor should bounce and reverse
    self.reverseFlag = false


    self.activeReloadSuccessSprite = love.graphics.newImage("sprites/active-reload-success.png")
    self.activeReloadSuccessFlag = 0
end

--[[

triggerPull is the function that's called when the weapon's "trigger" is pulled.
does the calculations of whether or not a projectile is *fired*    

]]
function Weapon:triggerPull()
    if self.outOfAmmoFlag == false then
        if self.clip > 0 and self.reloadComplete == true and self.reloadInstance == 0 and self.activeReloadInstance == 0 then
            self:fireBullet()
        elseif self.clip <= 0 then
            self:reload()
        end
    end
    
end

--handles logic on reloading - timing and also active reload
function Weapon:reload()
    self.reloadComplete = false
    --flags to help manage reload
    self.reloadInstance = self.reloadInstance+1
    self.activeReloadInstance = self.activeReloadInstance+1
    --timing of 'natural' reload
    if self.reloadInstance == 1 and self.activeReloadInstance == 1 then
        reloadTimer:after(self.reloadTime, function()
            self:reloadOverride()
        end)
        
    end
end

--actual reloading function without handling logic
--resets clip size, resets flags
function Weapon:reloadOverride()

    if self.ammoLeft >= self.maxCapacity then
        self.clip = self.maxCapacity
        self.ammoLeft = self.ammoLeft - self.maxCapacity
    elseif self.ammoLeft < self.maxCapacity then
        self.clip = self.ammoLeft
        self.ammoLeft = 0
    end
    self.reloadComplete = true
    self.reloadInstance = 0 
    self.activeReloadTimer = 0
    self.activeReloadInstance = 0
    self.activeReloadCursorXPos = 0
    if self.activeReloadSuccessFlag == -1 then
        self.activeReloadSuccessFlag = 0
    end
    reloadTimer:clear()
end

function Weapon:fireBullet()
    if self.activeReloadSuccessFlag == 0 then
        table.insert(listOfSpitBullets, Spit(player.x+4, player.y))
        self.clip = self.clip - 1
    elseif self.activeReloadSuccessFlag == 1 then
        table.insert(listOfSpitBullets, Spit(player.x+2, player.y))
        table.insert(listOfSpitBullets, Spit(player.x+6, player.y))
        self.clip = self.clip - 1
    end
end


--checks if out of ammo and sets a flag to true
function Weapon:outOfAmmo()
    if self.clip == 0 and self.ammoLeft == 0 then
        self.outOfAmmoFlag = true
    else
        self.outOfAmmoFlag = false
    end
end

function Weapon:update(dt)
    --checks if its out of ammo
    self:outOfAmmo()

    if self.reloadInstance == 1 and self.activeReloadInstance == 1 and self.outOfAmmoFlag == false then
        if self.reverseFlag == false and self.activeReloadCursorXPos < 15 then
            self.activeReloadCursorXPos = self.activeReloadCursorXPos + 15 * dt
        elseif self.reverseFlag == false and self.activeReloadCursorXPos >= 15 then
            self.reverseFlag = true
        elseif self.reverseFlag == true and self.activeReloadCursorXPos > 0 then
            self.activeReloadCursorXPos = self.activeReloadCursorXPos - 15 * dt
        elseif self.reverseFlag == true and self.activeReloadCursorXPos <= 0 then
            self.reverseFlag = false
        end
    end
    reloadTimer:update(dt)
end

function Weapon:draw()
    --ammo counter for dev purposes
    if self.reloadComplete == true and self.outOfAmmoFlag == false then
        love.graphics.print(self.clip .. "/" .. self.ammoLeft,player.x+7,player.y+15)
    elseif self.reloadComplete == false and self.activeReloadSuccessFlag >= 0 and self.outOfAmmoFlag == false then
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
    elseif self.reloadComplete == false and self.activeReloadSuccessFlag == -1 and self.outOfAmmoFlag == false then
        --draw background bar
        love.graphics.setColor(self.activeReloadBarColor)
        love.graphics.rectangle("fill", player.x+1, player.y+18, self.activeReloadBarWidth, self.activeReloadBarHeight)
        love.graphics.setColor(1,1,1)
    elseif self.outOfAmmoFlag == true then
        love.graphics.print(self.clip .. "/" .. self.ammoLeft,player.x+7,player.y+15)
    end
end
