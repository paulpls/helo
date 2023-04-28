---
--- Helicopter prototype
---



--
--  Setup
--
local Helicopter = {}

--  Basic attributes
Helicopter.x = 0
Helicopter.y = 0
Helicopter.status = {}
--  Image attributes
Helicopter.image = nil
Helicopter.imgPath = "assets/img/helo.png"
--  Animation-related things
Helicopter.frames = {}
Helicopter.frames.total = 8
Helicopter.frames.list = {}
Helicopter.frames.w = 32
Helicopter.frames.h = 32
Helicopter.frames.current = 1
Helicopter.delay = 0.1
Helicopter.elapsedTime = 0



--
--  Factory
--
function Helicopter:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end



--
--  Debug
--
function Helicopter:debugPrint ()
    msg = {
            "x:     "..self.x.."\n",
            "y:     "..self.y.."\n",
                                     } 
    print("-- Helicopter info: ---\n"..table.concat(msg))
end



--
--  Load callback
--
function Helicopter:load ()
    -- Load the image
    self.image = love.graphics.newImage(self.imgPath)
    -- populate frames list
    for f=1,self.frames.total do
        self.frames.list[f] = love.graphics.newQuad(f * self.frames.w,
                                                    0,
                                                    self.frames.w,
                                                    self.frames.h,
                                                    self.image:getDimensions()  ) 
    end
end



--
--  Animation
--
function Helicopter:animate (dt)
    -- Add to elapsed time
    self.elapsedTime = self.elapsedTime + dt
    -- Increment frame if delay has been passed
    if self.delay <= self.elapsedTime then
        self.elapsedTime = self.elapsedTime - self.delay
        self.frames.current = self.frames.current % (self.frames.total-1) + 1
    end
end



--
--  Update callback
--
function Helicopter:update (dt)
    self:animate(dt)
    self.image = love.graphics.newImage(self.imgPath)
end



--
--  Draw callback
--
function Helicopter:draw ()
    love.graphics.draw(self.image,
                       self.frames.list[self.frames.current],
                       self.x,
                       self.y   )
end
    


return Helicopter



