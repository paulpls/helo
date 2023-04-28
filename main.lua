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
local Helicopter = require "helicopter"
local helo = Helicopter:new()


--
--  Load callbacks
--
love.load = function ()
    helo:load()
end



--
--  Update callbacks
--
love.update = function (dt)
    helo:update(dt)
end



--
--  Draw callbacks
--
love.draw = function ()
    helo:draw()
end



--
--  Exit strategies
--
love.quit = function ()
    local msg = "Bye, Felicia"
    print(msg)
end



