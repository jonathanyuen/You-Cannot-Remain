ScoringScreen = Object:extend()

local slideNum = 1
local waveClearStats = {}
local totalBonusFont = love.graphics.newFont("/fonts/Not Jam UI 12.ttf",12)
local rankingFont = love.graphics.newFont("/fonts/NotJamOldStyle11.ttf", 33)

--sfx
local sfxTotalBonus = love.audio.newSource("/sound/sfx/bonuspoints.wav", "static")
local sfxRank = love.audio.newSource("/sound/sfx/ranknormal.ogg", "static")
local sfxRankHigh = love.audio.newSource("/sound/sfx/rankhighest.ogg", "static")

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

    if slideNum == 2 then
        sfxTotalBonus:play()
    end

    if slideNum == 3 then
        if waveClearStats["rank"] == "S" or waveClearStats["rank"] == "A" then
            sfxRankHigh:play()
        else sfxRank:play()
        end
    end

    --slide limit reached... start Merchant
    if slideNum == 4 then
        scoreboard:updateTicker("Wave Clear", waveClearStats["totalBonus"])

        startMerchant()
    end
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
    if slideNum >= 1 then
        --left side stats
        love.graphics.printf({colorPalette.fauxWhite, "CLEAR TIME: " .. waveClearStats["clearTime"] .. " SECS"}, 12,59, 97, 'right')
        love.graphics.printf({colorPalette.fauxWhite, "ACCURACY: " .. math.floor(waveClearStats["accuracy"]*100) .. "%"}, 12,69, 97, 'right')
        love.graphics.printf({colorPalette.fauxWhite, "TIMES HIT: " .. waveClearStats["statsTimesTouched"]}, 12,79, 97, 'right')
        love.graphics.printf({colorPalette.fauxWhite, "DAMAGE TAKEN: " .. waveClearStats["statsNestDamage"]}, 12,89, 97, 'right')
        love.graphics.printf({colorPalette.fauxWhite, "ACTIVE RELOADS: " .. waveClearStats["activeReloads"]}, 12,99, 97, 'right')
        love.graphics.printf({colorPalette.fauxWhite, "BLESSINGS COLLECTED: " .. waveClearStats["statsBlessingsObtained"]}, 12,109, 97, 'right')
    
        --right side bonuses
        love.graphics.printf({colorPalette.red, "TIME BONUS: +" .. waveClearStats["timeBonus"]}, 114,59, 99, 'left')
        love.graphics.printf({colorPalette.red, "ACCURACY BONUS: +" .. waveClearStats["accuracyBonus"]}, 114,69, 99, 'left')
        if waveClearStats["timesTouchedBonus"] > 0 then
            love.graphics.printf({colorPalette.red, "UNTOUCHABLE: +" .. waveClearStats["timesTouchedBonus"]}, 114,79, 99, 'left')
        end

        if waveClearStats["nestDmgBonus"] > 0 then
            love.graphics.printf({colorPalette.red, "NEST UNTOUCHED: +" .. waveClearStats["nestDmgBonus"]}, 114,89, 99, 'left')

        end
        love.graphics.printf({colorPalette.red, "+" .. waveClearStats["activeReloadBonus"]}, 114,99, 99, 'left')
        love.graphics.printf({colorPalette.red, "+" .. waveClearStats["blessingsBonus"]}, 114,109, 99, 'left')
    
    
    end
    if slideNum >= 2 then
        love.graphics.setFont(totalBonusFont)
        love.graphics.printf({colorPalette.red, waveClearStats["totalBonus"]},115, 143, 75, 'left')
        love.graphics.setFont(font)
    end
    if slideNum >= 3 then
        love.graphics.setFont(rankingFont)
        love.graphics.printf({colorPalette.red, waveClearStats["rank"]},276, 141, 36, 'left')
        love.graphics.setFont(font)
    end

end

