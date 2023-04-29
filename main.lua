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
                             helicopterSpeed,
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
    if love.keyboard.isDown("space") then
        player:move(0,1)
    else
        player:move()
    end
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
    local msg = "Bye, Felicia"
    print(msg)
end



