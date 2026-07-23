IronTailAttackIndicator = Object:extend()

function IronTailAttackIndicator:new()
    --animations
    self.visualIndicatorAnim = LoveAnimation.new('IronTailAttackAnimations.lua')
    self.xPos = player.x - player.ironTail.hitboxExtensionHori - 4
    self.yPos = player.y - 10 - player.ironTail.hitboxExtensionVert

    self.xScale = 1+(player.ironTail.hitboxExtensionHori/20)
    self.yScale = 1+(player.ironTail.hitboxExtensionVert/10)

    self.animationDone = false
    
end

function IronTailAttackIndicator:update(dt)
    self.visualIndicatorAnim:setPosition(self.xPos, self.yPos)
    
    self.visualIndicatorAnim:update(dt)
end


function IronTailAttackIndicator:draw()
     self.visualIndicatorAnim:draw(self.xScale, self.yScale)
end
