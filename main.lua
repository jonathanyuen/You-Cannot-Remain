Object = require "classic"
Timer = require "timer"
require "player"
require "ant"
require "spit"
require "animation"
require "mastermind"
require "powerups"


local push = require "push"
local button = require "Button"
local gameWidth, gameHeight = 320,180
local windowWidth, windowHeight = love.window.getDesktopDimensions()


--game states
local game = {
    state = {
        menu = true,
        merchant = false,
        paused = false,
        running = false,
        ended = false
    }
}

--holds buttons for different states
local buttons = {
    menu_state = {},
    merchant_state = {},
    paused_state = {},
    ended_state = {}
}

--start the game
local function startNewGame()
    game.state["menu"] = false
    game.state["running"] = true

end


function love.load()

    love.window.setTitle("You Cannot Remain")
    

    

    love.graphics.setDefaultFilter("nearest","nearest")
    --font
    font = love.graphics.newFont("/fonts/Tiny5-Regular.ttf",8 )
    love.graphics.setFont(font)
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
    --weapons
    spit = love.graphics.newImage("/sprites/spit.png")

   
    
    push:setupScreen(gameWidth, gameHeight, 1280, 720, {fullscreen = false, vsync = true, pixelperfect = true})
    
    
    local r,g,b = love.math.colorFromBytes(33,33,35)
    love.graphics.setBackgroundColor(r, g, b,1)
    print (love.graphics.getBackgroundColor())
    mastermind = Mastermind()
    player = Player()

    listOfEnemies = {}
    listOfSpitBullets = {}
    listOfPowerups = {}


    --buttons!
    buttons.menu_state.play_game = button("Play", startNewGame, nil, 50, 13)
    buttons.menu_state.settings = button("Settings", nil, nil, 50, 13)
    buttons.menu_state.quit_game = button("Quit Game", love.event.quit, nil, 50, 13)


    table.insert(buttons.menu_state, buttons.menu_state.play_game)
    table.insert(buttons.menu_state, buttons.menu_state.settings)
    table.insert(buttons.menu_state, buttons.menu_state.quit_game)

    
    --cursor
    menuCursorAnim = LoveAnimation.new("menuCursorAnimations.lua")
    menuCursorAnim:setPosition(10-1, 20+3)
    


    --figure out where/how to do this so its not just in load?
    mastermind:spawn()
    mastermind:spawnPowerup()

    

    --initiate Stage UI element & designate position
    stageAnim = LoveAnimation.new('stageAnimations.lua')
    stageAnim:setPosition(237,154)

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
end

function love.keypressed(key)
    player:keyPressed(key)
    mastermind:keyPressed(key)


    --main menu nav
    if game.state["menu"] then
    -----option selection
        if  (love.keyboard.isDown("return") == true) or (love.keyboard.isDown("space")) then
            selectedMenuButton:pressed()
        end

        --option navigation
        if love.keyboard.isDown("down") == true then
            if selectedMenuButton == buttons.menu_state[1] then
                selectedMenuButton = buttons.menu_state[2]
                menuCursorAnim:setPosition(selectedMenuButton.button_x-1,selectedMenuButton.button_y+3)
            elseif selectedMenuButton == buttons.menu_state[2] then
                selectedMenuButton = buttons.menu_state[3]
                menuCursorAnim:setPosition(selectedMenuButton.button_x-1,selectedMenuButton.button_y+3)
            end
        elseif love.keyboard.isDown("up") == true then
            if selectedMenuButton == buttons.menu_state[2] then
                selectedMenuButton = buttons.menu_state[1]
                menuCursorAnim:setPosition(selectedMenuButton.button_x-1, selectedMenuButton.button_y+3)
            elseif selectedMenuButton == buttons.menu_state[3] then
                selectedMenuButton = buttons.menu_state[2]
                menuCursorAnim:setPosition(selectedMenuButton.button_x-1, selectedMenuButton.button_y+3)
            end
        end
    end
end

function love.update(dt)
    --menuuu
    if game.state["menu"] then
        menuCursorAnim:update(dt)

        

        --[[
        
        handle logic of menu game state

        - player navigates buttons using arrow keys up/down
        - player can press enter/space to select an option and trigger function of the option


        WISHLIST: Cursor code is a bit repetitive

        ]]

        

        
    end

    --game runnin
    if game.state["running"] then



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
        stageAnim:update(dt)

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
        --update scroll background
        u = u-2*dt
    end
    --update timer
    Timer.update(dt)
end



function love.draw()
    --scaling...
    push:start()

    --if game.state is menu
    if game.state["menu"] then
        menuCursorAnim:draw()
    end

    --if game.state is running
    if game.state["running"] then
        -- scrolling background
        backQuad:setViewport(0,u,backdrop:getWidth(),backdrop:getHeight())
        love.graphics.draw(backdrop, backQuad, 102,0,0)
        --ui & stage
        love.graphics.draw(ui,0,0)
        stageAnim:draw()
        dmgStatUpChevronAnim:draw()
        radStatUpChevronAnim:draw()
        spdStatUpChevronAnim:draw()
        pspdStatUpChevronAnim:draw()

        dmgStatLevelAnim:draw()
        radStatLevelAnim:draw()
        spdStatLevelAnim:draw()
        pspdStatLevelAnim:draw()
        -----weapon drawing
        love.graphics.draw(spit,18,70)
        
        --draw mango
        player:draw()

        

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

    --game is menu state
    elseif game.state["menu"] then
        buttons.menu_state.play_game:draw(10,20,0,0)
        buttons.menu_state.settings:draw(10,60,0,0)
        buttons.menu_state.quit_game:draw(10,100,0,0)
    end



    --finish scaling
    push:finish()
end