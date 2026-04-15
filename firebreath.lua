FireBreath = Weapon:extend()

--will prob need another type of timer
local reloadTimer = Timer.new()

-- see if we can get away with spitWeapon being called only in the player class?

function FireBreath:new()
    --defaulted to spit config
    --weapon level
    self.hitstun = 0.2
    self.equipped = 0
    self.damage = 1
    self.level = 0
    self.fuel = 250
    self.outOfAmmoFlag = false
    --flag to detect if the flame is still active aka if you're holding down the firing button
    
    --flag to detect if the fire breath is initalizing - starting up the startup animations
    self.newPull = false
    self.startingFuelCost = 2
    
    --exclamation mark when it hits lower?
    self.tempThreshold = 5
    self.temp = 0
    self.overheatFlag = false
    self.prevBreathingState = false
    self.currBreathingState = false
    

    self.flameAnim = LoveAnimation.new('firebreathAnimations.lua')

    
    
end

--[[

triggerPull is the function that's called when the weapon's "trigger" is pulled.
does the calculations of whether or not a projectile is *fired*    

]]
function FireBreath:triggerPull()
    if self.outOfAmmoFlag == false and self.overheatFlag == false then
        if self.currBreathingState == false then
            if self.fuel > self.startingFuelCost then
                --need new sound
                self:fire()
                self.fuel = self.fuel - self.startingFuelCost
                self.flameAnim:setState("startup")
                self:changeBreathState(true)
                print("new instance of firebreath")
            end
        else
            if self.fuel > self.startingFuelCost then
                --need new sound
                self:fire()
                self:changeBreathState(true)
                print("continuing firebreath")
            end
        end
    end
    
end


function FireBreath:fire()
    --so this should pretty much make it so the animation plays... and then also create a hitbox for the enemies
    local hbox_left = player.x - 8
    local hbox_right = player.x + 8
    local hbox_top = player.y - 30
    local hbox_bottom = player.y - 2
    for i,v in ipairs(listOfEnemies) do
        local enemy_left = v.x 
        local enemy_right = v.x +v.width
        local enemy_top = v.y
        local enemy_bottom = v.y + v.height

        if  enemy_right > hbox_left
        and enemy_left < hbox_right
        and enemy_bottom > hbox_top
        and enemy_top < hbox_bottom then
            self:damageCalc(i,v)
        end
    end
end

function FireBreath:damageCalc(enemyIndex,enemy)
    --include damage scaling here
    --damage is adjusted because its calculated by like... frame?? we'll see how this works
    enemy:takeDmg((self.damage + player.dmg)/50,"fireBreath")
end


--checks if out of ammo and sets a flag to true
function FireBreath:outOfAmmo()
    if self.fuel <= 0 then
        self.outOfAmmoFlag = true
        print("out of ammo")
        self.fuel = 0
        self:changeBreathState(false)

    else
        self.outOfAmmoFlag = false
    end
end

function FireBreath:changeBreathState(state)
    self.prevBreathingState = self.currBreathingState
    self.currBreathingState = state
end

function FireBreath:update(dt)
    --sound playing (please work)
    if self.prevBreathingState == false and self.currBreathingState == false and self.overheatFlag == false then
        sfxFireBreathLoop:stop()
        sfxFireBreathStart:stop()
    elseif self.prevBreathingState == false and self.currBreathingState == true and self.overheatFlag == false then
        sfxFireBreathStart:play()
        Timer.after(3, function()
            sfxFireBreathLoop:play()
        end)
    elseif self.prevBreathingState == true and self.currBreathingState == false and self.overheatFlag == false then
        sfxFireBreathLoop:stop()
        sfxFireBreathEnd:play()
        self.flameAnim:setState("stop")
    end

    --temp check
    if self.currBreathingState == false then
        if self.temp >= 1 then
            self.temp = self.temp - .5 *dt
        else
            self.temp = 0
        end
    else
        if self.temp >= self.tempThreshold then
            --overheat!
            self.overheatFlag = true
            sfxFireBreathStart:stop()
            sfxFireBreathLoop:stop()
            self.flameAnim:setState("stop")
            Timer.after(5, function ()
                self.overheatFlag = false
            end)
        else
            self.temp = self.temp + 1 * dt
            if self.temp <= self.tempThreshold - 3 then
                --danger zone
                
            end
        end
    end
    print("flameBreath temp: " .. self.temp)
    print("overheat flag: " .. tostring(self.overheatFlag))

    --consume ammo
    if self.currBreathingState == true then
        self.fuel = self.fuel - 2*dt
    end

    --checks if its out of ammo
    self:outOfAmmo()
    --flame anim position
	self.flameAnim:setPosition(player.x-6, player.y-35)
    self.flameAnim:update(dt)
end

function FireBreath:draw()
    
    if self.outOfAmmoFlag == false and self.currBreathingState == true and self.overheatFlag == false then
        self.flameAnim:draw()
    end
    --ammo counter for dev purposes
    love.graphics.print(self.fuel,player.x+7,player.y+15)
    love.graphics.print(self.temp .. "/" .. self.tempThreshold,player.x+2,player.y+22)
    --needs exclamation mark for overheatin'
end
