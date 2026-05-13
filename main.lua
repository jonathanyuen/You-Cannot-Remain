if arg[2] == "debug" then
    require("lldebugger").start()
end

Object = require "classic"
Timer = require "timer"
require "weapon"
require "player"
require "ant"
require "ironTail"
require "spit"
require "animation"
require "mastermind"
require "powerups"
require "dialogue"
require "scoreboard"
require "merchant"


local push = require "push"
local button = require "Button"
local gameWidth, gameHeight = 320,180
local windowWidth, windowHeight = love.window.getDesktopDimensions()

gameIsFrozen = false

--merchant transition in play variable
merchantTransitionIsPlaying = false

collisionInstance = 0




--palette of colors
colorPalette = {
    red = {180/255,82/255,82/255,1},
    fauxWhite = {184/255, 181/255, 185/255,1},
    fauxBlack = {33/255,33/255,35/255,1}
}


--debug timer
local secondCounter = 0

--game states
local game = {
    state = {
        menu = true,
        merchant = false,
        pause = false,
        running = false,
        ended = false
    }
}

--holds buttons for different states
local buttons = {
    menu_state = {},
    pause_state = {},
    ended_state = {}
}



function freezeGame(secs)
    gameIsFrozen = true
    Timer.after(secs, function()
        gameIsFrozen = false
        print("game unfrozen")
        if merchantTransitionIsPlaying == true then
            merchantTransitionIsPlaying = false
        end
    end)
end

--merchant (global)
function startMerchant()
    --print ("merchant started")
    game.state["running"] = false
    game.state["pause"] = false
    game.state["ended"] = false
    game.state["merchant"] = true
    --freeze game to reduce spam affecting shop
    freezeGame(3)
    merchantTransitionIsPlaying = true
    merchantTransitionAnim:setState("default")
    menuCursorAnim:setPosition(10-1, 19+3)
    merchant:openShop()
end

--transition from merchant state to game state
function endMerchant()
    game.state["running"] = true
    game.state["pause"] = false
    game.state["ended"] = false
    game.state["merchant"] = false

    equipment:updateMango() --adds effects from items!
    --print("merchant ended")
end

--start the game
local function startNewGame()
    game.state["menu"] = false
    game.state["running"] = true
    score = 0
    scoring.counterAntsKilled = 0
    scoring.counterActiveReloadSuccess = 0
    player = nil
    player = Player()
    mastermind = nil
    mastermind = Mastermind()
    --reset arrays
    listOfEnemies = nil
    listOfSpitBullets = nil
    listOfPowerups = nil

    listOfEnemies = {}
    listOfSpitBullets = {}
    listOfPowerups = {}

    merchant = Merchant()

    --initialize enemies and powerups 
    mastermind:spawn()
    mastermind:spawnPowerup()
    

end

local function goToMainMenu()
    game.state["menu"] = true
    game.state["running"] = false
    game.state["pause"] = false
    game.state["ended"] = false
    menuCursorAnim:setPosition(140-1, 140+3)
end

local function deathScreen()
    game.state["ended"] = true
    game.state["running"] = false
    game.state["pause"] = false
    game.state["menu"] = false

    Timer.script(function(wait)
        wait(3)
        deathScreenAnim:setState("gameOverFadeIn")
        wait(3)
        deathScreenAnim:setState("gameOverFadeOut")
        wait(3)
        deathScreenAnim:setState("mantra1")
        wait(15)
        goToMainMenu()
    end)
   
end

local function resumeGame()
    game.state["pause"] = false
    game.state["running"] = true
end



function love.load()

    love.window.setTitle("You Cannot Remain")

    

    love.graphics.setDefaultFilter("nearest","nearest")
    --font
    font = love.graphics.newFont("/fonts/Tiny5-Regular.ttf",8 )
    love.graphics.setFont(font)

    --renown font
    renownFont = love.graphics.newFont("/fonts/NotJamChunky8.ttf", 8)

    --merchant heading font
    itemHeadingFont = love.graphics.newFont("/fonts/NotJamOldStyle11.ttf",11)

    --Decision header font
    pixelPurlFont = love.graphics.newFont("/fonts/PixelPurl.ttf", 16)
    --ui
    --[[
    note that ui left side is: 102x180
    right side is also 102x180

    left bound of playable area should be 102
    right bound is 218

    ]]--


    --infinite scrolling backdrop
    backdrop = love.graphics.newImage("sprites/world1.png")
    backdrop:setWrap("repeat","repeat")
    u = 0
    backQuad = love.graphics.newQuad(0,0,backdrop:getWidth(), backdrop:getHeight(),backdrop:getWidth(), backdrop:getHeight())
    

    ui = love.graphics.newImage("/sprites/ui.png")
    --weapons image
    spitImage = love.graphics.newImage("/sprites/spit.png")
    tailImage = love.graphics.newImage("/sprites/irontail.png")
    flameBreathImage = love.graphics.newImage("/sprites/fireBreathIcon.png")


    
    --load the music
    songStageOne = love.audio.newSource("/sound/music/stage 1.mp3", "stream")

    --load the sfx
    sfxActiveReloadSuccess = love.audio.newSource("/sound/sfx/active-reload-success.ogg", "static")
    sfxButtonNav = love.audio.newSource("/sound/sfx/button-nav.wav", "static")
    sfxButtonSelect = love.audio.newSource("/sound/sfx/button-select.wav", "static")
    sfxHPDown = love.audio.newSource("/sound/sfx/hp-down.ogg", "static")
    sfxInShell = love.audio.newSource("/sound/sfx/in-shell.ogg", "static")
    sfxIronTailSwipe = love.audio.newSource("/sound/sfx/irontailswipe.wav", "static")
    --sfOutOfShell broken
    --sfxOutOfShell = love.audio.newSource("/sound/sfx/outofshell.m4a", "stream")
    --a little quiet, might need to adjust volume upward
    sfxPowerUp = love.audio.newSource("/sound/sfx/powerup.wav", "static")
    sfxSpit = love.audio.newSource("/sound/sfx/spit.wav", "static")
    sfxSuccessfulHit= love.audio.newSource("/sound/sfx/successfulhit.wav", "static")
    sfxIronTailHit = love.audio.newSource("/sound/sfx/irontailcollision.wav","static")
    sfxIronTailHit:setVolume(1.5)
    sfxFireBreathDamage = love.audio.newSource("/sound/sfx/firebreathdamage.wav","static")
    sfxFireBreathDamage:setVolume(1.1)
    sfxFireBreathStart = love.audio.newSource("/sound/sfx/firebreath-start.wav","static")
    sfxFireBreathStart:setVolume(.2)
    sfxFireBreathLoop = love.audio.newSource("/sound/sfx/firebreath-loop.wav","static")
    sfxFireBreathLoop:setVolume(.2)
    sfxFireBreathLoop:setLooping(true)
    sfxFireBreathEnd = love.audio.newSource("/sound/sfx/firebreath-end.wav","static")
    sfxFireBreathEnd:setVolume(.2)
    sfx_kaching = love.audio.newSource("/sound/sfx/roblox-cash-register.mp3","static")
    sfx_broke = love.audio.newSource("/sound/sfx/too-broke.wav","static")



    --title screen
    titleScreen = love.graphics.newImage("/sprites/title screen.png")
   
    
    push:setupScreen(gameWidth, gameHeight, 1280, 720, {fullscreen = false, vsync = true, pixelperfect = true})
    
    
    local r,g,b = love.math.colorFromBytes(33,33,35)
    love.graphics.setBackgroundColor(r, g, b,1)
    --print (love.graphics.getBackgroundColor())
    mastermind = Mastermind()
    player = Player()
    scoreboard = Scoreboard()
    --initialize merchant
    merchant = Merchant()

    --arrays
    listOfEnemies = {}
    listOfSpitBullets = {}
    listOfPowerups = {}


    --death screen animation setup
    deathScreenAnim = LoveAnimation.new("deathScreenAnimations.lua")
    deathScreenAnim:setPosition(0,0)

    --merchant transition setup
    merchantTransitionAnim = LoveAnimation.new("merchant_transition_animation.lua")
    merchantTransitionAnim:setPosition(0,0)

    

    --MAIN MENU
    --buttons!
    buttons.menu_state.play_game = button("Play", startNewGame, nil, 50, 13)
    buttons.menu_state.settings = button("Settings", nil, nil, 50, 13)
    buttons.menu_state.quit_game = button("Quit Game", love.event.quit, nil, 50, 13)


    table.insert(buttons.menu_state, buttons.menu_state.play_game)
    table.insert(buttons.menu_state, buttons.menu_state.settings)
    table.insert(buttons.menu_state, buttons.menu_state.quit_game)

    
    --cursor for main menu
    menuCursorAnim = LoveAnimation.new("menuCursorAnimations.lua")
    --set pos for cursor for main menu
    menuCursorAnim:setPosition(140-1, 140+3)


    --PAUSE MENU
    buttons.pause_state.resume = button("Play", resumeGame, nil, 50, 13)
    buttons.pause_state.settings = button("Settings", nil, nil, 50, 13)
    buttons.pause_state.quitToMenu = button("Quit to Menu", goToMainMenu,nil, 50,13)
    buttons.pause_state.quit_game = button("Quit Game", love.event.quit, nil, 50, 13)



    table.insert(buttons.pause_state, buttons.pause_state.resume)
    table.insert(buttons.pause_state, buttons.pause_state.settings)
    table.insert(buttons.pause_state, buttons.pause_state.quitToMenu)
    table.insert(buttons.pause_state, buttons.pause_state.quit_game)


    


    --figure out where/how to do this so its not just in load?
    mastermind:spawn()
    mastermind:spawnPowerup()

    

    --initiate Stage UI element & designate position
    --stageAnim = LoveAnimation.new('stageAnimations.lua')
    --stageAnim:setPosition(237,154)

     --stat upgrade animations (chevrons first then actual progress) & designate positions
    dmgStatUpChevronAnim = LoveAnimation.new('statupAnimations.lua')
    dmgStatUpChevronAnim:setPosition(89,13)
    radStatUpChevronAnim = LoveAnimation.new('statupAnimations.lua')
    radStatUpChevronAnim:setPosition(89,27)
    spdStatUpChevronAnim = LoveAnimation.new('statupAnimations.lua')
    spdStatUpChevronAnim:setPosition(89,41)
    pspdStatUpChevronAnim = LoveAnimation.new('statupAnimations.lua')
    pspdStatUpChevronAnim:setPosition(89,55)

    dmgStatLevelAnim = LoveAnimation.new('statLevelIndicatorAnimations.lua')
    dmgStatLevelAnim:setPosition(48,13)
    radStatLevelAnim = LoveAnimation.new('statLevelIndicatorAnimations.lua')
    radStatLevelAnim:setPosition(48,27)
    spdStatLevelAnim = LoveAnimation.new('statLevelIndicatorAnimations.lua')
    spdStatLevelAnim:setPosition(48,41)
    pspdStatLevelAnim = LoveAnimation.new('statLevelIndicatorAnimations.lua')
    pspdStatLevelAnim:setPosition(48,55)
    
    
    
    --set cursor to play by default
        

    --keep track of what is selected using buttons.menu_state array index - "play" by default
    selectedMenuButton = buttons.menu_state[1]
    selectedPauseButton = buttons.pause_state[1]


    --timer just to help debug
    Timer.every(1, function()
        secondCounter = secondCounter+1
        print (secondCounter .. " seconds elapsed =======================================") 
    end)
    

end



function love.keypressed(key)
    if gameIsFrozen == false then
        if game.state["running"] then
        --what happens when you press pause
            if love.keyboard.isDown("p") == true or love.keyboard.isDown("escape") == true then
                menuCursorAnim:setPosition(138,53)
                game.state["running"] = false
                game.state["pause"] = true
                game.state["menu"] = false
            end

            if player.spitter.activeReloadInstance == 1 and player.spitter.activeReloadCursorXPos < 4 or player.spitter.activeReloadCursorXPos > 7 then
                if key == "space" then
                    --print("nope")
                    scoring.flagActiveReloadMissed = true
                    player.spitter.activeReloadSuccessFlag= -1
                end
            end

            if love.keyboard.isDown("q") == true and player.inShell == false then
                player:cycleWeapon()
            end

            player:keyPressed(key)
            player:keyReleased(key)
            mastermind:keyPressed(key)
        end

        --main menu nav
        if game.state["menu"] then
        -----option selection
            if  (love.keyboard.isDown("return") == true) or (love.keyboard.isDown("space")) then
                selectedMenuButton:pressed()
                sfxButtonSelect:play()
            end

            --option navigation
            if love.keyboard.isDown("down") == true then
                if selectedMenuButton == buttons.menu_state[1] then
                    sfxButtonNav:clone():play()
                    selectedMenuButton = buttons.menu_state[2]
                    menuCursorAnim:setPosition(selectedMenuButton.button_x-1,selectedMenuButton.button_y+3)
                elseif selectedMenuButton == buttons.menu_state[2] then
                    sfxButtonNav:clone():play()
                    selectedMenuButton = buttons.menu_state[3]
                    menuCursorAnim:setPosition(selectedMenuButton.button_x-1,selectedMenuButton.button_y+3)
                end
            elseif love.keyboard.isDown("up") == true then
                if selectedMenuButton == buttons.menu_state[2] then
                    sfxButtonNav:clone():play()
                    selectedMenuButton = buttons.menu_state[1]
                    menuCursorAnim:setPosition(selectedMenuButton.button_x-1, selectedMenuButton.button_y+3)
                elseif selectedMenuButton == buttons.menu_state[3] then
                    sfxButtonNav:clone():play()
                    selectedMenuButton = buttons.menu_state[2]
                    menuCursorAnim:setPosition(selectedMenuButton.button_x-1, selectedMenuButton.button_y+3)
                end
            end
        end

        --merchant state nav
        if game.state["merchant"] then
            --initial option selection
            -----option selection
            if  (love.keyboard.isDown("return") == true) or (love.keyboard.isDown("space")) and purchasingFlag == 0 then
                merchant.selectedMerchantButton:pressed()
                print(merchant.selectedMerchantButton.text)
                sfxButtonSelect:play()
            --purchase selection
            elseif (love.keyboard.isDown("return") == true) or (love.keyboard.isDown("space")) and purchasingFlag ~= 0 then
                merchant.selectedDecisionButton:pressed()
                purchasingFlag = 0
                
            
            end

            --purchase navigation
            if love.keyboard.isDown("left") == true then
                if merchant.selectedDecisionButton == merchant.decisionButtons[1] then
                    --can't move more left...
                elseif merchant.selectedDecisionButton == merchant.decisionButtons[2] then
                    --move left
                    sfxButtonNav:clone():play()
                    merchant.selectedDecisionButton = merchant.decisionButtons[1]
                    confirmationCursorAnim:setPosition(merchant.selectedDecisionButton.button_x-1, merchant.selectedDecisionButton.button_y+3)
                end
            elseif love.keyboard.isDown("right") == true then
                if merchant.selectedDecisionButton == merchant.decisionButtons[2] then
                    --can't move more right...
                elseif merchant.selectedDecisionButton == merchant.decisionButtons[1] then
                    --move right
                    sfxButtonNav:clone():play()
                    merchant.selectedDecisionButton = merchant.decisionButtons[2]
                    confirmationCursorAnim:setPosition(merchant.selectedDecisionButton.button_x-1, merchant.selectedDecisionButton.button_y+3)
                end
            end

            
            

            --option navigation
            if love.keyboard.isDown("down") == true then
                if merchant.selectedMerchantButton == merchant.buttons[1] then
                    purchasingFlag = 0
                    print(purchasingFlag)
                    sfxButtonNav:clone():play()
                    merchant.selectedMerchantButton = merchant.buttons[2]
                    menuCursorAnim:setPosition(merchant.selectedMerchantButton.button_x-1,merchant.selectedMerchantButton.button_y+3)
                elseif merchant.selectedMerchantButton == merchant.buttons[2] then
                    purchasingFlag = 0
                    print(purchasingFlag)
                    sfxButtonNav:clone():play()
                    merchant.selectedMerchantButton = merchant.buttons[3]
                    menuCursorAnim:setPosition(merchant.selectedMerchantButton.button_x-1,merchant.selectedMerchantButton.button_y+3)
                elseif merchant.selectedMerchantButton == merchant.buttons[3] then
                    purchasingFlag = 0
                    print(purchasingFlag)
                    sfxButtonNav:clone():play()
                    merchant.selectedMerchantButton = merchant.buttons[4]
                    menuCursorAnim:setPosition(merchant.selectedMerchantButton.button_x-1,merchant.selectedMerchantButton.button_y+3)
                elseif merchant.selectedMerchantButton == merchant.buttons[4] then
                    purchasingFlag = 0
                    print(purchasingFlag)
                    sfxButtonNav:clone():play()
                    merchant.selectedMerchantButton = merchant.buttons[5]
                    menuCursorAnim:setPosition(merchant.selectedMerchantButton.button_x-1,merchant.selectedMerchantButton.button_y+3)
                end
            elseif love.keyboard.isDown("up") == true then
                if merchant.selectedMerchantButton == merchant.buttons[5] then
                    purchasingFlag = 0
                    print(purchasingFlag)
                    sfxButtonNav:clone():play()
                    merchant.selectedMerchantButton = merchant.buttons[4]
                    menuCursorAnim:setPosition(merchant.selectedMerchantButton.button_x-1, merchant.selectedMerchantButton.button_y+3)
                elseif merchant.selectedMerchantButton == merchant.buttons[4] then
                    purchasingFlag = 0
                    print(purchasingFlag)
                    sfxButtonNav:clone():play()
                    merchant.selectedMerchantButton = merchant.buttons[3]
                    menuCursorAnim:setPosition(merchant.selectedMerchantButton.button_x-1, merchant.selectedMerchantButton.button_y+3)
                elseif merchant.selectedMerchantButton == merchant.buttons[3] then
                    purchasingFlag = 0
                    print(purchasingFlag)
                    sfxButtonNav:clone():play()
                    merchant.selectedMerchantButton = merchant.buttons[2]
                    menuCursorAnim:setPosition(merchant.selectedMerchantButton.button_x-1, merchant.selectedMerchantButton.button_y+3)
                elseif merchant.selectedMerchantButton == merchant.buttons[2] then
                    purchasingFlag = 0
                    print(purchasingFlag)
                    sfxButtonNav:clone():play()
                    merchant.selectedMerchantButton = merchant.buttons[1]
                    menuCursorAnim:setPosition(merchant.selectedMerchantButton.button_x-1, merchant.selectedMerchantButton.button_y+3)
                end
            end
            --secondary option selection
        end

        --pause menu nav
        if game.state["pause"] then
            -----option selection
            if  (love.keyboard.isDown("return") == true) or (love.keyboard.isDown("space")) then
                selectedPauseButton:pressed()
                sfxButtonSelect:play()

            end

            --option navigation
            if love.keyboard.isDown("down") == true then
                if selectedPauseButton == buttons.pause_state[1] then
                    sfxButtonNav:clone():play()
                    selectedPauseButton = buttons.pause_state[2]
                    menuCursorAnim:setPosition(selectedPauseButton.button_x-1,selectedPauseButton.button_y+3)
                elseif selectedPauseButton == buttons.pause_state[2] then
                    sfxButtonNav:clone():play()
                    selectedPauseButton = buttons.pause_state[3]
                    menuCursorAnim:setPosition(selectedPauseButton.button_x-1,selectedPauseButton.button_y+3)
                elseif selectedPauseButton == buttons.pause_state[3] then
                    sfxButtonNav:clone():play()
                    selectedPauseButton = buttons.pause_state[4]
                    menuCursorAnim:setPosition(selectedPauseButton.button_x-1,selectedPauseButton.button_y+3)
                end
            elseif love.keyboard.isDown("up") == true then
                if selectedPauseButton == buttons.pause_state[2] then
                    sfxButtonNav:clone():play()
                    selectedPauseButton = buttons.pause_state[1]
                    menuCursorAnim:setPosition(selectedPauseButton.button_x-1, selectedPauseButton.button_y+3)
                elseif selectedPauseButton == buttons.pause_state[3] then
                    sfxButtonNav:clone():play()
                    selectedPauseButton = buttons.pause_state[2]
                    menuCursorAnim:setPosition(selectedPauseButton.button_x-1, selectedPauseButton.button_y+3)
                elseif selectedPauseButton == buttons.pause_state[4] then
                    sfxButtonNav:clone():play()
                    selectedPauseButton = buttons.pause_state[3]
                    menuCursorAnim:setPosition(selectedPauseButton.button_x-1, selectedPauseButton.button_y+3)
                end
            end
        end
    end
    
end

function love.update(dt)
    if gameIsFrozen == false then
        --merchant
        if game.state["merchant"] == true then
            menuCursorAnim:update(dt)
            merchant:update(dt)
        end

        --menuuu
        if game.state["menu"] == true then
            menuCursorAnim:update(dt)        
        end

        ---game pause
        if game.state["pause"] == true then
            menuCursorAnim:update(dt)
        end

        --game runnin
        if game.state["running"] == true then
        
            songStageOne:setLooping(true)
            songStageOne:play()
        

            for i,v in ipairs(listOfEnemies) do
                v:update(dt)
            end

            for i,v in ipairs(listOfPowerups) do
                v:update(dt)
            end

            for i,v in ipairs(listOfSpitBullets) do 
                v:update(dt)

                --collision checking of spit bullets to enemies
                for j,k in ipairs(listOfEnemies) do
                    v:checkCollision(k)
                    --remove dead enemies
                    if k:isDead()==true and k.readyToClean > 5 then
                        table.remove(listOfEnemies,j)
                end
                end

                --collision checking of spit bullets to powerups
                for j,k in ipairs(listOfPowerups) do
                    v:checkCollision(k)
                    --"redeem" completed power ups
                    if k:isDead()==true and k.readyToClean > 5 then
                        table.remove(listOfPowerups,j)
                    end
                end



                --remove 'dead' bullets
                if v.dead then
                    table.remove(listOfSpitBullets,i)
                end
            end
            
            --update player
            player:update(dt)

            --update stage
            --stageAnim:update(dt)

            --update mastermind
            mastermind:update(dt)

            --update stats
            dmgStatUpChevronAnim:update(dt)
            radStatUpChevronAnim:update(dt)
            spdStatUpChevronAnim:update(dt)
            pspdStatUpChevronAnim:update(dt)

            dmgStatLevelAnim:update(dt)
            radStatLevelAnim:update(dt)
            spdStatLevelAnim:update(dt)
            pspdStatLevelAnim:update(dt)

            --trigger death screen
            if player.health <= 0 then
                deathScreen()
            end

            --scoring
            --[[

            score = 0
            scoring = {
                counterAntsKilled = 0,
                counterActiveReloadSuccess = 0,
                flagBulletsMissed = false,
                flagActiveReloadMissed = false
            }

            ]]

            --update scroll background
            u = u-4*dt
            --update timer
            
        end

        --death screen
        if game.state["ended"] == true then
            deathScreenAnim:update(dt)
        end
        
        
    else
        merchantTransitionAnim:update(dt)
    end
    Timer.update(dt)
end



function love.draw()
    --scaling...
    push:start()


    --if game.state is merchant
    if game.state["merchant"] then
        merchant:draw()

        if merchantTransitionIsPlaying == true then
            merchantTransitionAnim:draw()
        end
    end

    --if game.state is menu
    if game.state["menu"] then
        love.graphics.draw(titleScreen,0,0)
        buttons.menu_state.play_game:draw(140,140,0,0)
        buttons.menu_state.settings:draw(140,150,0,0)
        buttons.menu_state.quit_game:draw(140,160,0,0)
        menuCursorAnim:draw()
    

    --if game.state is running
    elseif game.state["running"] then
        -- scrolling background
        backQuad:setViewport(0,u,backdrop:getWidth(),backdrop:getHeight())
        love.graphics.draw(backdrop, backQuad, 102,0,0)
        --ui & stage
        love.graphics.draw(ui,0,0)
        --stageAnim:draw()
        dmgStatUpChevronAnim:draw()
        radStatUpChevronAnim:draw()
        spdStatUpChevronAnim:draw()
        pspdStatUpChevronAnim:draw()

        dmgStatLevelAnim:draw()
        radStatLevelAnim:draw()
        spdStatLevelAnim:draw()
        pspdStatLevelAnim:draw()
        -----weapon drawing
        if player.weaponEquipped["spitter"].equipped == true then
            love.graphics.draw(spitImage,18,70)
        elseif player.weaponEquipped["ironTail"].equipped == true then
            love.graphics.draw(tailImage,28,68)
        elseif player.weaponEquipped["fireBreath"].equipped == true then
            love.graphics.draw(flameBreathImage,24,76)
        end

        --draw mango
        player:draw()
        scoreboard:draw()
        

        --draw enemies
        for i,v in ipairs(listOfEnemies) do
            v:draw()
        end

        --draw powerups
        for i,v in ipairs(listOfPowerups) do
            v:draw()
        end

        --draw spit bullets
        for i,v in ipairs(listOfSpitBullets) do
            v:draw()
        end

        --draw score
        love.graphics.setFont(renownFont)
        ---colored printing scores and whatnot... still haven't done calcs yet either
        love.graphics.print({colorPalette.red,"RENOWN "},227,171)
        love.graphics.print({colorPalette.fauxWhite,string.format("%04d",score)},285,171)
        love.graphics.setFont(font)


    --game is pause state
    elseif game.state["pause"] then
        buttons.pause_state.resume:draw(140,50,0,0)
        buttons.pause_state.settings:draw(140,60,0,0)
        buttons.pause_state.quitToMenu:draw(140,70,0,0)
        buttons.pause_state.quit_game:draw(140,80,0,0)
        menuCursorAnim:draw()
    elseif game.state["ended"] then
        deathScreenAnim:draw()
    end

    --finish scaling
    push:finish()
end

local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end