ScoringScreen = Object:extend()

function ScoringScreen:new()
    --scoringScreen bg
    scoringScreenBG = love.graphics.newImage("/sprites/scoring-screen-bg.png")
end

function ScoringScreen:update(dt)

end

function ScoringScreen:draw()
    --background
    love.graphics.draw(scoringScreenBG, 0, 0)

    --the score breakdowns
    --[[
    TODO:
    Clear time
    Accuracy
    Times Hit
    Damage Taken
    Active Reloads
    Blessings Collected
    ]]
    love.graphics.print("CLEAR TIME: ")
end

