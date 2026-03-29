IronTail = Weapon:extend()

function IronTail:new()
    --super class
    IronTail.super.new(self)
    
    self.level = 0
 
    self.damage = 1


    --array to keep the targets who are being calculate for their hit
    self.attackSuccessFlag = {}

end

--[[

triggerPull is the function that's called when the weapon's "trigger" is pulled.
does the calculations of whether or not a projectile is *fired*    

]]

function IronTail:smackTail()

    local hbox_left = player.x
    local hbox_right = player.x + 16
    local hbox_top = player.y - 8
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
        end
    end
    
    self.clip = self.clip - 1

end

function IronTail:damageCalc(enemyIndex,enemy)
    enemy:takeDmg(self.damage)
    if enemy:isDead() == true then
        player.spitter.ammoLeft = player.spitter.ammoLeft + 2

        for i,v in ipairs(player.weaponEquipped) do
            print (v)
            print (v.ammoLeft)
            v.ammoLeft = v.ammoLeft + 2
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

