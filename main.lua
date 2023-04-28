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
--  Globals, imports, etc
--



--
--  Load callbacks
--
love.load = function ()
end



--
--  Update callbacks
--
love.update = function (dt)
end



--
--  Draw callbacks
--
love.draw = function ()
    local msg = "Hello, world!"
    local x,y = 0,0
    love.graphics.print(msg, x, y)
end



--
--  Exit strategies
--
love.quit = function ()
    local msg = "Bye, Felicia"
    print(msg)
end



