Spit = Object:extend()

function Spit:new(x,y)
    self.image = love.graphics.newImage("sprites/bullet.png")
    self.x = x
    self.y = y
    self.speed = 50 + player.pspd*100
    self.damage = 1 + player.dmg

    self.width = 1+ player.rad
    self.height = 1+player.rad
    self.rad = 1+player.rad
end

function Spit:update(dt)
    self.y = self.y - self.speed * dt
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
        if player.item39Flag == false then
            self.dead = true
        else
            Timer.after(4, function()
                self.dead = true
            end)
        end
        

        --give extra renown for a kill
        if player.item25Flag == true and obj.health <= self.damage then
            score = score + 1
        end
        --decrease health
        obj:takeDmg(self.damage)
        
    else
        scoring.flagBulletsMissed = true
    end
end


function Spit:draw()
    love.graphics.draw(self.image, self.x, self.y,0,self.rad,self.rad)
end
