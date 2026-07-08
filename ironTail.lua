IronTail = Weapon:extend()

function IronTail:new()
    --super class
    IronTail.super.new(self)
    
    self.level = 0
    self.hitstun = 1.2
 
    self.damage = 1
    self.fireRate = 1
    self.swinging = false

    self.hitboxExtensionVert = 0
    self.hitboxExtensionHori = 0


    --array to keep the targets who are being calculate for their hit
    self.attackSuccessFlag = {}

end

--[[

triggerPull is the function that's called when the weapon's "trigger" is pulled.
does the calculations of whether or not a projectile is *fired*    

]]

function IronTail:smackTail()

    sfxIronTailSwipe:clone():play()

    local hbox_left = player.x - self.hitboxExtensionHori
    local hbox_right = player.x + 16 + self.hitboxExtensionHori
    local hbox_top = player.y - 8 - self.hitboxExtensionVert
    local hbox_bottom = player.y

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
            Timer.after(.1,function() freezeGame(.2) end)
        end
    end

    for i,v in ipairs(listOfPowerups) do

        local enemy_left = v.x 
        local enemy_right = v.x +v.width
        local enemy_top = v.y
        local enemy_bottom = v.y + v.height

        if  enemy_right > hbox_left
        and enemy_left < hbox_right
        and enemy_bottom > hbox_top
        and enemy_top < hbox_bottom then
            v:takeDmg(10000)
            freezeGame(.1)
            player.spitter.ammoLeft = player.spitter.ammoLeft + 16
        end
    end
    
    self.clip = self.clip - 1

end

function IronTail:damageCalc(enemyIndex,enemy)
    --include damage scaling here
    enemy:takeDmg(self.damage + player.dmg,"tail")
    if enemy:isDead() == true then
        --refill ammo
        player.spitter.ammoLeft = player.spitter.ammoLeft + 2

        --item26--give bonus renown on kill
        if player.item26Flag == true then
            scoreboard:updateTicker("Tail Kill Bonus",10)
        end

        for i,v in ipairs(player.weaponEquipped) do
            print (v)
            print (v.ammoLeft)
            v.ammoLeft = v.ammoLeft + 4
        end
    end
    --[[
    if the array is searched and there isn't a damage instance being calculated, then add the instance... then the instance will be done, and removed from the table.

        so if enemy[1] is hit, "1" will be added to array, ONLY if "1" isn't in there already. Once the hit on "1" is calculated and damage is done, "1" is removed from the table

    
    table.insert(self.attackSuccessFlag,enemyIndex)
    print(enemyIndex .. " inserted into attack success array")
    local attackInstances = 0
    for i,v in ipairs(self.attackSuccessFlag) do
        if v == enemyIndex then
            attackInstances = attackInstances + 1
        end
    end 

    if attackInstances == 1 then
        enemy:takeDmg(self.damage)
        print("enemy hit")
        for i,v in ipairs(self.attackSuccessFlag) do
            if v == enemyIndex then
                v = nil
            end
        end
    end]]
end

function IronTail:draw()
   
end

