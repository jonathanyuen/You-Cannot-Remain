Scoreboard = Object:extend()
score = 0
scoreGainRate = 1
--cumulative scoring
scoring = {
    counterAntsKilled = 0,
    counterFalconsKilled = 0,
    counterSquirrelsKilled = 0,
    counterActiveReloadSuccess = 0,
    totalBulletsFired = 0,
    totalBulletsHit = 0,
    flagBulletsMissed = false,
    blessingsObtained = 0,
    timesTouched = 0,
    nestDamage = 0,
    clearTime = 0
}

--the last counts of the scoring components before the most recent wave started
waveScoring = {
    lastTotalBulletsFired = 0,
    lastTotalBulletsHit = 0,
    lastBlessingsObtained = 0,
    lastActiveReloadSuccess = 0,
    lastClearTime = 0,
    lastTimesTouched = 0,
    lastNestDamage = 0,
    lastSecondCounter = 0
}


scoreboardColorPalette = {
    white = {184/255,181/255,185/255},
    lightGrey = {134/255,129/255,136/255},
    grey = {100/255,100/255,101/255},
    darkGray = {69/255,68/255,79/255}
}

function Scoreboard:new()
    self.ticker = {}
    
end

--saves the current stats of the run
function Scoreboard:saveScoringStats()
    --save the scoring stats - invoke this method upon wave clear!
    waveScoring["lastTotalBulletsFired"] = scoring["totalBulletsFired"]
    waveScoring["lastTotalBulletsHit"] = scoring["totalBulletsHit"]
    waveScoring["lastTimesTouched"] = scoring["timesTouched"]
    waveScoring["lastNestDamage"] = scoring["nestDamage"]
    waveScoring["lastActiveReloadSuccess"] = scoring["counterActiveReloadSuccess"]
    waveScoring["lastBlessingsObtained"] = scoring["blessingsObtained"]
    waveScoring["lastSecondCounter"] = secondCounter
end

--calculates the scoring breakdown and bonuses for wave clear
function Scoreboard:waveClearCalcStats()
    --calculate the scoring breakdown
    local clearTime = scoring["clearTime"]
    local accuracy = (scoring["totalBulletsHit"] - waveScoring["lastTotalBulletsHit"]) / (scoring["totalBulletsFired"] - waveScoring["lastTotalBulletsFired"])
    local statsTimesTouched = scoring["timesTouched"] - waveScoring["lastTimesTouched"]
    local statsNestDamage = scoring["nestDamage"] - waveScoring["lastNestDamage"]
    local activeReloads = scoring["counterActiveReloadSuccess"] - waveScoring["lastActiveReloadSuccess"]
    local statsBlessingsObtained = scoring["blessingsObtained"] - waveScoring["lastBlessingsObtained"]
    
    --calculate possible bonuses
    local waveClearStats = {
        clearTime = clearTime,
        accuracy = accuracy,
        statsTimesTouched = statsTimesTouched,
        statsNestDamage = statsNestDamage,
        activeReloads = activeReloads,
        statsBlessingsObtained = statsBlessingsObtained,
        timeBonus = 0,
        accuracyBonus = 0,
        timesTouchedBonus = 0,
        nestDmgBonus = 0,
        activeReloadBonus = 0,
        blessingsBonus = 0,
        totalBonus = 0,
        rank = ""
    }

    --debug this
    for key,value in ipairs(waveClearStats) do print(key,value) end

    --calculate timeBonus
    waveClearStats.timeBonus = (60 - waveClearStats.clearTime) * 20

    --calculate accuracyBonus   
    if waveClearStats.accuracy == 1 then
        waveClearStats.accuracyBonus = 2000 --perfect accuracy
    elseif waveClearStats.accuracy < 1 and waveClearStats.accuracy >= .85 then
        waveClearStats.accuracyBonus = 1000
    elseif waveClearStats.accuracy < .85 and waveClearStats.accuracy >= .65 then
        waveClearStats.accuracyBonus = 500
    end

    --calculate timesTouchedBonus
    if waveClearStats.statsTimesTouched == 0 then
        waveClearStats.timesTouchedBonus = 1000 * (mastermind.level + 1) --untouchable
    end

    --calculate nestDmgBonus
    if waveClearStats.statsNestDamage == 0 then
        waveClearStats.nestDmgBonus = 400 * (mastermind.level + 1) --perfect
    end

    --calculate activeReloadBonus
    waveClearStats["activeReloadBonus"] = waveClearStats.activeReloads * 5
    --calculate blessingsBonus
    waveClearStats["blessingsBonus"] = waveClearStats.statsBlessingsObtained * 5

    --calculate totalBonus
    waveClearStats.totalBonus = waveClearStats.timeBonus + waveClearStats.accuracyBonus + waveClearStats.timesTouchedBonus + waveClearStats.nestDmgBonus + waveClearStats.activeReloadBonus + waveClearStats.blessingsBonus
    --calculate rank!
    if waveClearStats.totalBonus >= (4300 + (1400 * mastermind.level)) then
        waveClearStats.rank = "S"
    elseif waveClearStats.totalBonus >= (3100 + (1400 * mastermind.level)) then
        waveClearStats.rank = "A"
    elseif waveClearStats.totalBonus >= (1600 + (400 * mastermind.level)) then
        waveClearStats.rank = "B"
    elseif waveClearStats.totalBonus >= (1100 + (400 * mastermind.level)) then
        waveClearStats.rank = "C"
    else
        waveClearStats.rank = "D"
    end
    --call saveScoringStats
    self:saveScoringStats()
    --return an array with the breakdown for easy access
    return waveClearStats
end

function Scoreboard:getSize()
    local tickerSize = 0
    for i,v in ipairs(self.ticker) do
        tickerSize = tickerSize + 1
    end
    return tickerSize
end

--updates score and ticker
function Scoreboard:updateTicker(feat,pointValue)
    --update Score
    score = score + (pointValue* scoreGainRate)

    --feat is what's done, pointValue is how much it's worth
    -- ex. feat could be active Reload success, point value of that could be like 10 
    -- goal is for this method to update the ticker that's drawn above Renown
    local toBeAdded = feat .. " +".. pointValue*scoreGainRate

    --if statement cases
    --[[
    if ticker has no entries, table.add
    if ticker has less than 4 entries, then table.add
    if ticker has more than 4 entries, shift table down and table.add?
    ]]
    local tickerSize = self:getSize()

    if tickerSize < 4 then
        table.insert(self.ticker, toBeAdded)
    else
        for i,v in ipairs(self.ticker) do
            self.ticker[i] = self.ticker [i+1]
        end
        self.ticker[4] = toBeAdded
    end
end

function Scoreboard:update(dt)

end

function Scoreboard:draw(dt)
    --draw the ticker
    --text will be in reverse order, aligned to the right
    
    local tickerSize = self:getSize()

    if tickerSize == 1 then
        love.graphics.printf({scoreboardColorPalette.white,self.ticker[1]},232,162,80,"right")
        
    elseif tickerSize == 2 then
        for i=1, 2 do
            if i == 2 then
                love.graphics.printf({scoreboardColorPalette.white,self.ticker[i]},232,162, 80, "right")
            elseif i ==1 then
                love.graphics.printf({scoreboardColorPalette.lightGrey,self.ticker[i]},232,162 - 7, 80, "right")
            end
        end
    elseif tickerSize == 3 then
        for i=1, 3 do
            if i == 3 then
                love.graphics.printf({scoreboardColorPalette.white,self.ticker[i]},232,162, 80, "right")
            elseif i ==2 then
                love.graphics.printf({scoreboardColorPalette.lightGrey,self.ticker[i]},232,162 - 7, 80, "right")
            elseif i == 1 then
                love.graphics.printf({scoreboardColorPalette.grey,self.ticker[i]},232,162 - 14, 80, "right")
            end
        end
    elseif tickerSize == 4 then
        for i=1, 4 do
            if i == 4 then
                love.graphics.printf({scoreboardColorPalette.white,self.ticker[i]},232,162, 80, "right")
            elseif i ==3 then
                love.graphics.printf({scoreboardColorPalette.lightGrey,self.ticker[i]},232,162 - 7, 80, "right")
            elseif i == 2 then
                love.graphics.printf({scoreboardColorPalette.grey,self.ticker[i]},232,162 - 14, 80, "right")
            elseif i == 1 then
                love.graphics.printf({scoreboardColorPalette.darkGray,self.ticker[i]},232,162 - 21, 80, "right")
            end
        end
    end
    
end

