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
--  Locals
--
local collision = false



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
    table.insert(blocks, Block:new(player.x,16,32,64))
    table.insert(blocks, Block:new(player.x,480,32,64))
    table.insert(blocks, Block:new(player.x-64,300,32,64))
    table.insert(blocks, Block:new(player.x+128,364,32,64))

end



--
--  Update callbacks
--
love.update = function (dt)
    
    --  Move the player
    local dx,dy = 0,0
    if not(player.crashed) then
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
    end
    player:move(dx, dy)

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

    --  Update player
    player:update(dt)
    camera:pan(1,0)
    player:move(-1,0,camera.speedX)


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



