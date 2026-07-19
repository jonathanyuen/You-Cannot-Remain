ScoringScreen = Object:extend()

local slideNum = 1
local waveClearStats = {}

function ScoringScreen:new()
    --scoringScreen bg
    scoringScreenBG = love.graphics.newImage("/sprites/scoring-screen-bg.png")
end

function ScoringScreen:refresh()
    slideNum = 1
    --get the stats from scoreboard so we can print them
    waveClearStats = scoreboard:waveClearCalcStats()
end

function ScoringScreen:update(dt)

end

function ScoringScreen:advanceSlide()
    slideNum = slideNum + 1
end

function ScoringScreen:draw()
    --background
    love.graphics.draw(scoringScreenBG, 0, 0)

    --[[
    slide flow:
    1. the stats
    2. the total bonus with scrolling
    3. rank reveal
    
    ]]
    if slideNum == 1 then
        love.graphics.printf({colorPalette.fauxWhite, "CLEAR TIME: " .. waveClearStats["clearTime"] .. " SECS"}, 12,59, 97, 'right')

    end

end

