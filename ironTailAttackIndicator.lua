IronTailAttackIndicator = Object:extend()

function IronTailAttackIndicator:new()
    --animations
    self.visualIndicatorAnim = LoveAnimation.new('IronTailAttackAnimations.lua')
    self.xPos = player.x - player.ironTail.hitboxExtensionHori
    self.yPos = player.y - 10 - player.ironTail.hitboxExtensionVert

    self.xScale = 1
    self.yScale = 1

    self.animationDone = false
    
end

function IronTailAttackIndicator:update(dt)
    self.visualIndicatorAnim:setPosition(self.xPos, self.yPos)
    
    self.visualIndicatorAnim:update(dt)
end


function IronTailAttackIndicator:draw()
    print("drawing at " .. self.xPos .. ", " .. self.yPos)   
    self.visualIndicatorAnim:draw(self.xScale, self.yScale)
end
