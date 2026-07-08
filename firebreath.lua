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

    --flag to detect if the flame is still active aka if you're holding down the firing button
    
    --flag to detect if the fire breath is initalizing - starting up the startup animations
    self.newPull = false

    
    --exclamation mark when it hits lower?

    self.prevBreathingState = false
    self.currBreathingState = false
    

    self.flameAnim = LoveAnimation.new('firebreathAnimations.lua')

    
    
end

--[[

triggerPull is the function that's called when the weapon's "trigger" is pulled.
does the calculations of whether or not a projectile is *fired*    

]]
function FireBreath:triggerPull()
    if self.currBreathingState == false then
        self:fire()
        self.flameAnim:setState("startup")
        self:changeBreathState(true)
        --("new instance of firebreath")
    else
        --need new sound
        self:fire()
        self:changeBreathState(true)
        
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
        --print("out of ammo")
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
    if self.prevBreathingState == false and self.currBreathingState == false then
        sfxFireBreathLoop:stop()
        sfxFireBreathStart:stop()
    elseif self.prevBreathingState == false and self.currBreathingState == true then
        sfxFireBreathStart:play()
        Timer.after(3, function()
            sfxFireBreathLoop:play()
        end)
    elseif self.prevBreathingState == true and self.currBreathingState == false then
        sfxFireBreathLoop:stop()
        sfxFireBreathEnd:play()
        self.flameAnim:setState("stop")
    end

    --flame anim position
	self.flameAnim:setPosition(player.x-6, player.y-35)
    self.flameAnim:update(dt)
end

function FireBreath:draw()
    
    if self.currBreathingState == true then
        self.flameAnim:draw()
    end
end
