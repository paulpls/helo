--[[

         s        s      soisoisois    s              isoiso
        soi      soi    soisoisois    soi           oisoisoiso
        ois      ois    ois           ois          ois      ois
        isoisoisoiso    isoisoiso     iso          iso      iso
        soisoisoisoi    soisoiso      soi          soi      soi
        ois      ois    ois           ois          ois      ois
        iso      iso    isoisoisoi    isoisoisoi    soisoisois
         o        o      oisoisoiso    oisoisoiso     soisoi
   
    Helo: Pixel-art helicopter game for the LOVE 2d game engine
    Author: paulpls

]]



--
--  Imports
--
require "class"
require "variables"

require "game"
require "quad"
require "helicopter"
require "camera"
require "block"



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
local blockSpawnElapsed = 0



--
--  Load callbacks
--
love.load = function ()

    --  Game state manager
    game = Game:new() 

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
                             helicopterFallSpeed,
                             helicopterFallDelay,
                             helicopterStatus,
                             helicopterBounds   )
    player:load()

    --  Blocks
    blocks = {}
     

end



--
--  Update callbacks
--
love.update = function (dt)

    --  Do movement/updates if game is running
    if game:isRunning() then

        --  Move the player
        local dx,dy = 0,0
        if love.keyboard.isDown("left") then
            dx = 1
        elseif love.keyboard.isDown("right") then
            dx = -1
        end
        if love.keyboard.isDown("space") then
            dy = 1
            player.fallElapsedTime = 0
            player.falling = false
        else
            if not player.falling then
                --  Evaluate delay
                if player.fallElapsedTime <= player.fallDelay then
                    player.fallElapsedTime = player.fallElapsedTime + dt
                    dy = 0
                else
                    player.falling = true
                    player.fallElapsedTime = 0
                    dy = -1
                end
            else
                dy = -1
            end
        end

        --  Move the player
        player:move(dx,dy)

        --  Pan the cameera and move the player
        camera:pan(1)
        player:move(-1,0,camera.speedX)

        -- Update camera, wall, block, and player boundaries
        -- TODO debug methods to draw bounds, hitboxes, etc.
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

        --  Spawn new blocks as necessary
        if blockSpawnElapsed <= blockSpawnDelay then
            blockSpawnElapsed = blockSpawnElapsed + dt
        else
            blockSpawnElapsed = 0
            table.insert(blocks, Block:spawn(camera.bounds.x2, true))
            table.insert(blocks, Block:spawn(camera.bounds.x2))
        end

        --  Update block spawning parameters
        Block.updateSpawn(camera.bounds)

        --  End the game and print score to stdout if player crashes
        if player.crashed then
            game.over = true
            print("Your score: "..game.score)
        end

    --  If game is not running, handle pause or gameover events
    else
        --  TODO Add paused/gameover functionality
    end

    player:update(dt)

end



--
--  Draw callbacks
--
love.draw = function ()

    --  Set camera
    camera:set()

    --  Draw the player
    love.graphics.setColor(1, 1, 1, 1)
    player:draw()

    --  Draw blocks
    love.graphics.setColor(0.25, 1, 0.33, 1)
    for _,b in ipairs(blocks) do b:draw() end

    --  Unset camera
    camera:unset()

end



--
--  Exit strategies
--
love.quit = function ()
    local msg = "\nBye, Felicia"
    print(msg)
end



