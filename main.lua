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

require "quad"
require "helicopter"
require "camera"
require "block"



--
--  RNGsus
--
math.randomseed(os.time())



--
--  Locals
--
local collision = false
local score = 0
local scoreMultiplier = 1
local scoreDelay = 0.25
local scoreElapsed = 0
local rng = math.random()



--
--  Load callbacks
--
love.load = function ()

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

    --  Walls
    walls = {}
    table.insert(walls, Block:new(0,0,windowWidth,wallHeight))
    table.insert(walls, Block:new(0,windowHeight-wallHeight,windowWidth,wallHeight))

    --  Blocks
    blocks = {}
    -- Use these for debugging the collision detectors
    --table.insert(blocks, Block:new(player.x,16,32,64))
    --table.insert(blocks, Block:new(player.x,480,32,64))
    --table.insert(blocks, Block:new(player.x-64,300,32,64))
    --table.insert(blocks, Block:new(player.x+128,364,32,64))
    --
    -- Randomly place some blocks
    for i=1,12 do
        rng = math.floor(math.random(8))
        table.insert(blocks, Block:new(player.x+(128*i),windowHeight-math.floor(windowHeight/rng),128,196))
    end
    -- I didn't hear no bell!
    for i=1,12 do
        rng = math.floor(math.random(8))
        table.insert(blocks, Block:new(player.x+(128*i),windowHeight-math.floor(windowHeight/rng),128,196))
    end
    

end



--
--  Update callbacks
--
love.update = function (dt)
    
    if not(player.crashed) then

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
            if not(player.falling) then
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

        --  Pan the cameera and move the player and walls with it
        camera:pan(1)
        player:move(-1,0,camera.speedX)
        for _,w in ipairs(walls) do w:move(-1,0,camera.speedX) end

        -- Update camera, wall, block, and player boundaries
        camera:moveBounds(1)
        player:moveBounds(1)

        --  Crash the helicopter if collided with bounds
        if player:detectCollisions() then player:crash() end

        --  Crash the helicopter if collided with walls
        for _,w in ipairs(walls) do
            if player:detectCollisions(w) then player:crash() end
        end

        --  Crash the helicopter if collided with blocks
        for _,b in ipairs(blocks) do
            if player:detectCollisions(b) then player:crash() end
        end

        --  Update player score
        if scoreElapsed >= scoreDelay then
            score = score + scoreMultiplier
            scoreElapsed = scoreElapsed - scoreDelay
        else
            scoreElapsed = scoreElapsed + dt
        end

        if player.crashed then print("Your score: "..score) end
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
    
    --  Draw walls
    love.graphics.setColor(0.25, 1, 0.33, 1)
    for _,w in ipairs(walls) do w:draw() end

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



