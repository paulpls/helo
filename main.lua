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
                             helicopterBounds,
                             helicopterImgPath  )
    player:load()

end



--
--  Update callbacks
--
love.update = function (dt)

    --  Player (Helicopter)
    local dy = 1
    if love.keyboard.isDown("space") then
        dy = 1
        player.fallElapsedTime = 0
        player.falling = false
    else
        if not(player.falling) then
            -- Evaluate delay
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
    player:move(0, dy)
    player:update(dt)

end



--
--  Draw callbacks
--
love.draw = function ()

    --  Player (Helicopter)
    player:draw()

end



--
--  Exit strategies
--
love.quit = function ()
    local msg = "\nBye, Felicia"
    print(msg)
end



