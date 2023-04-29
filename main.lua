---
---      s        s      soisoisois    s              isoiso
---     soi      soi    soisoisois    soi           oisoisoiso
---     ois      ois    ois           ois          ois      ois
---     isoisoisoiso    isoisoiso     iso          iso      iso
---     soisoisoisoi    soisoiso      soi          soi      soi
---     ois      ois    ois           ois          ois      ois
---     iso      iso    isoisoisoi    isoisoisoi    soisoisois
---      o        o      oisoisoiso    oisoisoiso     soisoi
---
--- Helo: Helicopter game for LOVE
--- Author: paulpls
---



--
--  Variables, imports, etc
--
local Camera = require "camera"
local camera = Camera:new()

local Helicopter = require "helicopter"
local player = Helicopter:new()


--
--  Load callbacks
--
love.load = function ()
    player:load()
end



--
--  Update callbacks
--
love.update = function (dt)
    player:update(dt)
    if love.keyboard.isDown("space") then
        player:move(0,1)
    else
        player:move()
    end
end



--
--  Draw callbacks
--
love.draw = function ()
    player:draw()
end



--
--  Exit strategies
--
love.quit = function ()
    local msg = "Bye, Felicia"
    print(msg)
end



