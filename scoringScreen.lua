ScoringScreen = Object:extend()

function ScoringScreen:new()
    --scoringScreen bg
    scoringScreenBG = love.graphics.newImage("/sprites/scoring-screen-bg.png")
end

function ScoringScreen:update(dt)

end

function ScoringScreen:draw(dt)
    love.graphics.draw(scoringScreenBG, 0, 0)
end

