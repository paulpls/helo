--[[

         s        s      soisoisois    s              isoiso
        soi      soi    soisoisois    soi           oisoisoiso
        ois      ois    ois           ois          ois      ois
        isoisoisoiso    isoisoiso     iso          iso      iso
        soisoisoisoi    soisoiso      soi          soi      soi
        ois      ois    ois           ois          ois      ois
        iso      iso    isoisoisoi    isoisoisoi    soisoisois
         o        o      oisoisoiso    oisoisoiso     soisoi
   
    HELO - Pixel-art helicopter game for the LOVE 2d game engine
    Author:  paulpls
    License: GPL 3
    Version: alpha

]]



--
--  Imports
--
require "class"
require "variables"
require "debugging"

require "font"
require "color"
require "game"
require "quad"
require "helicopter"
require "camera"
require "block"
require "trail"
require "message"


--
--  RNGsus
--
math.randomseed(os.time())
rng = function (n, m, o)
    math.random()
    math.random()
    math.random()
    n = n or 100
    if m then
        if o then
            return math.random(n,m,o)
        else
            return math.random(n,m)
        end
    else
        return math.random(n)
    end
end
    


--
--  Locals
--
local collision = false
local wallSpawnElapsed = 0
local blockSpawnElapsed = 0
local trailSpawnElapsed = 0
local firstRun = true



--  Game state manager
game = Game:new() 



--
--  Load callbacks
--
love.load = function ()

    -- Reset game state
    game.over = false
    game.start = true
    game.score = 0

    --  Use nearest-neighbor interpolation for scaling drawable objects
    love.graphics.setDefaultFilter("nearest", "nearest")

    --  Font
    font = Font:new()
    font:load()

    --  Camera
    camera = Camera:new( cameraX,
                         cameraY,
                         cameraSpeedX,
                         cameraSpeedY,
                         cameraScaleX,
                         cameraScaleY,
                         cameraRotation,
                         cameraBounds    )
    camera:load()

    --  Player (Helicopter)
    player = Helicopter:new( helicopterX,
                             helicopterY,
                             helicopterXSpeed,
                             helicopterLiftSpeed,
                             helicopterLiftDelay,
                             helicopterFallSpeed,
                             helicopterFallDelay,
                             helicopterStatus,
                             helicopterBounds   )
    player:load()

    --  Blocks
    blocks = {}

    --  Add initial walls if at game start
    --  FIXME Y spawnpoint remains constant from game to game
    local startWallX = 0
    local startWallY1 = 0
    local startWallY2 = windowHeight - blockMargin
    local startWallW = windowWidth + (2 * blockWidth)
    local startWallH = blockMargin
    local color = colorBlock
    if Color.rainbow then color = Color.rainbowCycle[1] end
    table.insert(blocks, Block:new(startWallX, startWallY1, startWallW, startWallH, color))
    table.insert(blocks, Block:new(startWallX, startWallY2, startWallW, startWallH, color))

    --  Trails
    trails = {}

    --  Messages
    messages = {}
    --  Draw init message on first run
    local initMsg = nil
    if firstRun then
        initMsg = Message:new("PRESS SPACEBAR OR CLICK MOUSE TO START", true)
    else
        initMsg = Message:new("HIGH SCORE: "..game:getHighScoreDisplay(scoreDisplayMinLength), true)
    end
    table.insert(messages, initMsg)

end



--
--  Update callbacks
--
love.update = function (dt)

    local color, colorIndex

    --  Game is waiting to start
    if game.start then
        if love.mouse.isDown(1) or love.keyboard.isDown("space") then
            firstRun = false
            game.start = false
        end
        

    --  Game is started
    else

        --  Do movement/updates if game is running
        if game:isRunning() then
    
            --  Move the player
            local dy = 1        --  Velocity
            local dl,df = 1, 1  --  Lift / fall accel
            --  Lift / Throttle
            if love.mouse.isDown(1) or love.keyboard.isDown("space") then
                player.falling = false
                player.fallElapsedTime = 0
                --  Evaluate lift acceleration
                player.liftElapsedTime = player.liftElapsedTime + dt
                if player.liftElapsedTime <= player.liftDelay then
                    dy = 1
                    dl = math.min(1, player.liftElapsedTime / player.liftDelay)
                else
                    player.lifting = true
                    dy = 1
                    --dl = math.min(3.0, player.liftElapsedTime / player.liftDelay)
                end
            --  Falling / No throttle
            else
                player.lifting = false
                player.liftElapsedTime = 0
                --  Evaluate fall acceleration
                player.fallElapsedTime = player.fallElapsedTime + dt
                if player.fallElapsedTime <= player.fallDelay then
                    dy = -1
                    df = math.min(1, player.fallElapsedTime / player.fallDelay)
                else
                    player.falling = true
                    dy = -1
                    df = math.min(1.25, player.fallElapsedTime / player.fallDelay)
                end
            end
    
            --  Move the player
            player:move(0, dy, camera.speedX, player.liftSpeed * dl, player.fallSpeed * df)
    
            --  Pan the camera and move the player
            camera:pan(1)
            player:move(1, 0, camera.speedX)
    
            --  Update camera, wall, block, and player boundaries
            camera:moveBounds(camera.speedX)
            player:moveBounds(camera.speedX)
    
            --  Crash the helicopter if collided with bounds
            if player:detectCollisions() then player:crash() end
    
            --  Crash the helicopter if collided with blocks
            for _,b in ipairs(blocks) do
                if player:detectCollisions(b) then player:crash() end
            end
    
            --  Update player score
            game:updateScore(dt)
    
            --  Delete off-screen blocks
            for i,b in ipairs(blocks) do
                if b:isOffscreen(camera.bounds) then
                    table.remove(blocks,i)
                end
            end


            --  Spawn random blocks
            if blockSpawnElapsed <= blockSpawnDelay then
                blockSpawnElapsed = blockSpawnElapsed + dt
            else
                blockSpawnElapsed = 0
                --  Rainbow color cycle
                if Color.rainbow then
                    colorIndex = (game.score % #Color.rainbowCycle) + 1
                    color = Color.rainbowCycle[colorIndex]
                end
                --  Insert new blocks
                local newBlock = Block:spawnBlock(color)
                table.insert(blocks, newBlock)
            end
    
            --  Spawn new walls as necessary
            if wallSpawnElapsed <= wallSpawnDelay then
                wallSpawnElapsed = wallSpawnElapsed + dt
            else
                wallSpawnElapsed = 0
                --  Rainbow color cycle
                if Color.rainbow then
                    colorIndex = (game.score % #Color.rainbowCycle) + 1
                    color = Color.rainbowCycle[colorIndex]
                end
                --  Insert new blocks
                local newWalls = Block:spawnWalls(camera.bounds.x2, camera.bounds.y1, color)
                table.insert(blocks, newWalls[1])
                table.insert(blocks, newWalls[2])
            end
    
            --  Delete off-screen trails
            for i,t in ipairs(trails) do
                if t:isOffscreen(camera.bounds.x1) then
                    table.remove(trails,i)
                end
            end
    
            --  Spawn new trails as necessary
            if trailSpawnElapsed <= trailSpawnDelay then
                trailSpawnElapsed = trailSpawnElapsed + dt
            else
                trailSpawnElapsed = 0
                --  Insert new trails
                local newTrail = Trail:new(player.x, player.y + math.floor(player.frames.h / 2))
                table.insert(trails, newTrail)
            end
    
            --  End the game and print score to stdout if player crashes
            if player.crashed then
                game.over = true
            end
    
        end
    
        --  Unset game start flag if set
        if game.start then game.start = false end
    
        --  Update trails
        for _,t in ipairs(trails) do t:update(dt) end

    end
    
    --  Update the player parameters
    player:update(dt)

end



--
--  Draw callbacks
--
love.draw = function ()

    --  Set camera
    camera:set()

    --  Draw blocks
    for _,b in ipairs(blocks) do b:draw() end

    --  Draw trails
    for _,t in ipairs(trails) do t:draw() end

    --  Draw score in top left corner
    local scoreDisplay = game:getScoreDisplay(scoreDisplayMinLength)
    local scoreX,scoreY = camera.bounds.x1 + scoreX, camera.bounds.y1 + scoreY
    local scoreW = #scoreDisplay * (fontWidth + fontKerning) + scoreMargin
    local scoreH = fontHeight + scoreMargin
    --  Draw the background
    love.graphics.setColor(Color.background)
    love.graphics.rectangle("fill", scoreX, scoreY, scoreW, scoreH)
    --  Draw the score display
    love.graphics.setColor(Color.text)
    for o=0, fontBoldWidth-1 do love.graphics.print(scoreDisplay, scoreX + scoreOffset, scoreY + scoreOffset) end

    --  Draw messages
    for _,m in ipairs(messages) do m:draw() end

    --  Draw the player over the rest of the objects
    love.graphics.setColor(Color.default)
    player:draw()
    
    --  Unset camera
    camera:unset()

    --  Game Over overlay
    if game.over then
        --  Configure box parameters
        --  TODO Move dialog box stuff to its own module
        --
        --  (X1,Y1)
        --  @---------------------------------------.  -
        --  |                                       |  |
        --  |<--msgLength * fontWidth + 2*margin -->|  | fontHeight + 2*margin
        --  |                                       |  |
        --  '---------------------------------------'  -
        --
        local gameOverMargin = 8
        local gameOverX1 = camera.centerX - math.floor(((fontWidth + fontKerning) * #msgGameOver) / 2) - gameOverMargin
        local gameOverY1 = camera.centerY - math.floor(fontHeight / 2) - gameOverMargin
        local gameOverW = ((fontWidth + fontKerning) * #msgGameOver) + (2 * gameOverMargin)
        local gameOverH = fontHeight + (2 * gameOverMargin)
        --  Draw the box
        love.graphics.setColor(Color.background)
        love.graphics.rectangle( "fill",
                                 gameOverX1,
                                 gameOverY1,
                                 gameOverW,
                                 gameOverH
                               )
        --  Draw the box outline
        love.graphics.setColor(Color.gameOver)
        love.graphics.rectangle( "line",
                                 gameOverX1,
                                 gameOverY1,
                                 gameOverW,
                                 gameOverH
                               )
        --  Configure msg parameters
        local gameOverMsgX = math.floor(gameOverX1 + gameOverMargin + fontKerning)
        local gameOverMsgY = math.floor(gameOverY1 + gameOverMargin)
        --  Repeatedly draw the message to achieve a bold effect
        love.graphics.setColor(Color.gameOver)
        for o=0, fontBoldWidth-1 do love.graphics.print(msgGameOver, gameOverMsgX+o, gameOverMsgY) end
    end

    --  Game over, <CR> restarts
    if game.over then
        if love.keyboard.isDown("return") then
            love.load()
        end
    end

end



--
--  Exit strategies
--
love.quit = function ()
    print(msgQuit)
end



