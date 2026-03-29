SpitWeapon = Weapon:extend()

reloadTimer = Timer.new()

-- see if we can get away with spitWeapon being called only in the player class?

function SpitWeapon:new()
    SpitWeapon.super.new(self)
    self.equipped = true
end

