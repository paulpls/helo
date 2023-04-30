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
                         cameraScaleX,
                         cameraScaleY,
                         cameraRotation,
                         cameraBounds    )
    camera:load()

    --  Player (Helicopter)
    player = Helicopter:new( helicopterX,
                             helicopterY,
                             helicopterLiftSpeed,
                             helicopterDropSpeed,
                             helicopterDropDelay,
                             helicopterStatus,
                             helicopterBounds   )
    player:load()


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
    
    --  Player (Helicopter)
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
    --  Crash the helicopter if any collisions detected
    if player:detectCollisions() then player:crash() end
    for _,b in ipairs(blocks) do
        if player:detectCollisions(b.hitbox) then player:crash() end
    end
    player:update(dt)

end



--
--  Draw callbacks
--
love.draw = function ()

    --  Player (Helicopter)
    player:draw()
    
    --  Blocks
    for _,b in ipairs(blocks) do b:draw() end

end



--
--  Exit strategies
--
love.quit = function ()
    local msg = "\nBye, Felicia"
    print(msg)
end



