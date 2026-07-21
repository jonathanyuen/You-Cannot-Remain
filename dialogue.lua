Dialogue = Object:extend()

local dialogueFont = love.graphics.newFont("/fonts/Pixuf.ttf",8)
--refer to scoring.["clearTime"] for in-game timer

--game.state[""]
--[[
    menu = true,
    merchant = false,
    waveClear = false,
    pause = false,
    running = false,
    ended = false,
    scoringScreen = false
]]

local lines = {
    tutLine01 = "Press [SPACE] to shoot. Press [Q] to switch weapons.",
    tutLine02 = "Press [SPACE] to reload. Time it well, and I'll get stronger.",
    tutLine03 = "I need to stop these things from reaching Foreston!",
    tutLine04 = "Destroying things with my tail gives me more spit.",
    tutLine05 = "If I hit a Blessing with my tail, it'll break instantly.",
    shopLine01 = "I can use my RENOWN to buy these items...",
    shopLine02 = "I already bought this.",
    shopLine03 = "I can't afford anything..."
}

--prints line in dialogue box, changes Mango's mood in status portrait
--moods are: "idle", "sad", "activeReloadSuccess", "happyLoop"
function Dialogue:sayLine(line, mood)
    love.graphics.setFont(dialogueFont) --change font
    love.graphics.printf({colorPalette.fauxWhite,line},232,104,74,"left")
    player.portraitAnim:setState(mood)
    Timer.after(2, function ()
        player.portraitAnim:setState("idle")
    end)
    love.graphics.setFont(font) --reset font
end

function Dialogue:sayLine(line)
    love.graphics.setFont(dialogueFont) --change font

    love.graphics.printf({colorPalette.fauxWhite,line},232,104,74)

    love.graphics.setFont(font) --reset font

end

function Dialogue:new()

end

function Dialogue:update(dt)
   
end

function Dialogue:draw()
     --main gameplay dialogue
    if game.state["running"] == true then
        --tutorial dialogue
        --time range from 0 - 4
        if scoring["clearTime"] >= 0 and scoring["clearTime"] < 5 then
            self:sayLine(lines.tutLine01)
        elseif scoring.clearTime >= 5 and scoring.clearTime < 10 then
            self:sayLine(lines.tutLine02)
        elseif scoring.clearTime >= 10 and scoring.clearTime < 14 then
            self:sayLine(lines.tutLine03)
        elseif scoring.clearTime >= 14 and scoring.clearTime < 19 then
            self:sayLine(lines.tutLine04)
        elseif scoring.clearTime >= 19 and scoring.clearTime < 30 then
            self:sayLine(lines.tutLine05)
        end

    elseif game.state["merchant"] == true then
        
        --already bought
        if string.find(merchant.selectedMerchantButton.text, "SOLD OUT") then
            self:sayLine(lines.shopLine02)
        --too poor
        elseif score < merchant.item1Cost and score < merchant.item2Cost and score < merchant.item3Cost then
            self:sayLine(lines.shopLine03, "sad")
        --typical situation
        else self:sayLine(lines.shopLine01)
        end
        

    end
end

