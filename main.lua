---
---      o        o      oisoisoiso    o              soisoi 
---     soi      soi    soisoisois    soi           oisoisoiso
---     soi      soi    soi           soi          soi      soi
---     soisoisoisoi    soisoisoi     soi          soi      soi
---     soisoisoisoi    soisoiso      soi          soi      soi
---     soi      soi    soi           soi          soi      soi
---     soi      soi    soisoisois    soisoisois    oisoisoiso
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



