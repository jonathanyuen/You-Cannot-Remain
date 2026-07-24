Spit = Object:extend()

function Spit:new(x,y)
    self.image = love.graphics.newImage("sprites/bullet.png")
    self.x = x
    self.y = y
    self.speed = 50 + player.pspd*100
    self.damage = 1 + player.dmg + player.spitter.damage
    self.width = 1+ player.rad
    self.height = 1+player.rad
    self.rad = 1+player.rad
    self.tiltAngle = .3
    self.direction = 0 --spit can be -1, 0, or 1 - helps define if its a left, middle, or right spit for cone firing!
    scoring["totalBulletsFired"] = scoring["totalBulletsFired"] + 1
end

function Spit:update(dt)
    if self.direction == 0 then
        self.y = self.y - self.speed * dt
    elseif self.direction == -1 then
        self.y = self.y - self.speed * dt
        self.x = self.x - self.tiltAngle * self.speed * dt
    elseif self.direction == 1 then
        self.y = self.y - self.speed * dt
        self.x = self.x + self.tiltAngle * self.speed * dt
    end

    if self.y <= 0 or self.x <= 102 or self.x >= 218 then
        self.dead = true
    end
end

function Spit:checkCollision(obj)
    local self_left = self.x 
    local self_right = self.x + self.width
    local self_top = self.y
    local self_bottom = self.y + self.height

    local obj_left = obj.x
    local obj_right = obj.x + obj.width
    local obj_top = obj.y
    local obj_bottom = obj.y + obj.height

    if  self_right > obj_left
    and self_left < obj_right
    and self_bottom > obj_top
    and self_top < obj_bottom then
        --spit hit!

        --get rid of spit bullet
        if player.item56Flag == true then
            if self.y <= 0 then
                self.dead = true
            end
        else
            self.dead = true
        end

        --decrease health
        obj:takeDmg(self.damage,"spit")
        --keeps track of bullets that hit
        scoring["totalBulletsHit"] = scoring["totalBulletsHit"] + 1
        
    else
        scoring.flagBulletsMissed = true
    end
end


function Spit:draw()
    love.graphics.draw(self.image, self.x, self.y,0,self.rad,self.rad)
end
