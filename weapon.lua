Weapon = Object:extend()

local reloadTimer = Timer.new()

-- see if we can get away with spitWeapon being called only in the player class?

function Weapon:new()
    --defaulted to spit config
    --Spit weapon level
    self.equipped = 0
    self.damage = 0
    self.level = 0
    self.maxCapacity = 4
    self.clip = self.maxCapacity
    self.hitstun = 0.2
    --not including what's in the clip already
    self.ammoLeft = 4
    self.outOfAmmoFlag = false
    self.reloadTime = 3
    self.reloadComplete = true
    self.reloadInstance = 0
    self.activeReloadTimer = 0
    self.activeReloadInstance = 0
    self.fireRate = .5
    self.onCooldown = false

    --colored text for temp active reload timer
    self.coloredText = {{184/255,181/255, 185/255},self.activeReloadTimer}

    --active reload variables?
    self.activeReloadBarWidth = 15
    self.activeReloadBarHeight = 3
    self.activeReloadBarColor = colorPalette.fauxBlack

    --for input purposes
    self.activeReloadLowerBound = 4
    self.activeReloadUpperBound = 9
    --for drawing purposes
    self.activeReloadActiveZoneWidth = self.activeReloadUpperBound - self.activeReloadLowerBound
    self.activeReloadActiveZoneColor = colorPalette.reloadBlue

    self.activeReloadCursorWidth = 1
    self.activeReloadCursorHeight = 5
    self.activeReloadCursorColor = {1,1,1}
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
    if self.outOfAmmoFlag == false and self.onCooldown == false then
        if self.clip > 0 and self.reloadComplete == true and self.reloadInstance == 0 and self.activeReloadInstance == 0 then
            if player.rad < 20 then
                sfxSpit:setPitch(1-(player.rad/20))
            else
                sfxSpit:setPitch(.01)
            end
            sfxSpit:clone():play()
            self.onCooldown = true
            Timer.after(self.fireRate, function ()
                self.onCooldown = false
            end)
            
            self:fireBullet()
            player.y = player.y+player.rad*.5

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
        
        if player.item40Flag == true then
            table.insert(listOfSpitBullets, Spit(player.x+7, player.y))
            table.insert(listOfSpitBullets, Spit(player.x+3, player.y))
        else
            table.insert(listOfSpitBullets, Spit(player.x+5, player.y))
        end
        if player.item59Flag == true then
            --burst fire
            Timer.after(.1, function ()
                if player.item40Flag == true then
                    table.insert(listOfSpitBullets, Spit(player.x+7, player.y))
                    table.insert(listOfSpitBullets, Spit(player.x+3, player.y))
                else
                    table.insert(listOfSpitBullets, Spit(player.x+5, player.y))
                end
            end)
        end
        self.clip = self.clip - 1
        
    elseif self.activeReloadSuccessFlag == 1 then
        if player.item40Flag == true then
            if player.item62Flag == true then
                table.insert(listOfSpitBullets, Spit(player.x+9, player.y))
                listOfSpitBullets[#listOfSpitBullets].direction = -1 
                table.insert(listOfSpitBullets, Spit(player.x+6, player.y))

                table.insert(listOfSpitBullets, Spit(player.x+3, player.y))
                listOfSpitBullets[#listOfSpitBullets].direction = 1 
            else
                table.insert(listOfSpitBullets, Spit(player.x+9, player.y))
                table.insert(listOfSpitBullets, Spit(player.x+6, player.y))
                table.insert(listOfSpitBullets, Spit(player.x+3, player.y))
            end
        else
            if player.item62Flag == true then
                table.insert(listOfSpitBullets, Spit(player.x+7, player.y))
                listOfSpitBullets[#listOfSpitBullets].direction = -1 

                table.insert(listOfSpitBullets, Spit(player.x+3, player.y))
                listOfSpitBullets[#listOfSpitBullets].direction = 1 

            else
                table.insert(listOfSpitBullets, Spit(player.x+7, player.y))
                table.insert(listOfSpitBullets, Spit(player.x+3, player.y))
            end
            
        end

        if player.item59Flag == true then
            --repeat but delayed for the burst!
            Timer.after(.1, function ()
                if player.item40Flag == true then
                    if player.item62Flag == true then
                        table.insert(listOfSpitBullets, Spit(player.x+9, player.y))
                        listOfSpitBullets[#listOfSpitBullets].direction = -1 
                        table.insert(listOfSpitBullets, Spit(player.x+6, player.y))

                        table.insert(listOfSpitBullets, Spit(player.x+3, player.y))
                        listOfSpitBullets[#listOfSpitBullets].direction = 1 
                    else
                        table.insert(listOfSpitBullets, Spit(player.x+9, player.y))
                        table.insert(listOfSpitBullets, Spit(player.x+6, player.y))
                        table.insert(listOfSpitBullets, Spit(player.x+3, player.y))
                    end
                else
                    if player.item62Flag == true then
                        table.insert(listOfSpitBullets, Spit(player.x+7, player.y))
                        listOfSpitBullets[#listOfSpitBullets].direction = -1 

                        table.insert(listOfSpitBullets, Spit(player.x+3, player.y))
                        listOfSpitBullets[#listOfSpitBullets].direction = 1 

                    else
                        table.insert(listOfSpitBullets, Spit(player.x+7, player.y))
                        table.insert(listOfSpitBullets, Spit(player.x+3, player.y))
                    end
                    
                end
            end)
        end
        
        self.clip = self.clip - 1
    end
end


--checks if out of ammo and sets a flag to true
function Weapon:outOfAmmo()
    if self.clip == 0 and self.ammoLeft == 0 then
        if player.item64Flag == true then
            if score >= 480 then
                self.ammoLeft = 24
                score = score - 480
            else
                self.outOfAmmoFlag = true
            end
        else
            self.outOfAmmoFlag = true
        end
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
    --reset activeReloadZoneWidth
    self.activeReloadActiveZoneWidth = self.activeReloadUpperBound - self.activeReloadLowerBound

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
