---
--- Helicopter prototype
---

Helicopter = class:new()



--
--  init
--
function Helicopter:init (x, y, speed, status, bounds, imgPath)
    Helicopter.x = x or 0
    Helicopter.y = y or 0
    Helicopter.speed = speed or helicopterSpeed
    Helicopter.status = status or {}
    --  Boundaries
    Helicopter.bounds = bounds or helicopterBounds
    --  Image attributes
    Helicopter.image = nil
    Helicopter.imgPath = helicopterImgPath or imgPath
    --  Animation-related things
    Helicopter.frames = {}
    Helicopter.frames.total = spriteFrames
    Helicopter.frames.list = {}
    Helicopter.frames.w = spriteWidth
    Helicopter.frames.h = spriteHeight
    Helicopter.frames.current = 1
    Helicopter.delay = spriteAnimationDelay
    Helicopter.elapsedTime = 0
end



--
--  Clamp to window boundaries
--
local clamp = function (n, min, max) return n < min and min or (n > max and max or n) end



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
--  Animation
--
function Helicopter:animate (dt)
    -- Add to elapsed time
    self.elapsedTime = self.elapsedTime + dt
    -- Increment frame if delay has been passed
    if self.delay <= self.elapsedTime then
        self.elapsedTime = self.elapsedTime - self.delay
        self.frames.current = self.frames.current % (self.frames.total) + 1
    end
end



--
--  Set helicopter x coordinate and check bounds
--
function Helicopter:setX (x)
    if self.bounds then
        self.x = clamp(x, self.bounds.x1, self.bounds.x2)
    else
        self.x = x
    end
end



--
--  Set helicopter y coordinate and check bounds
--
function Helicopter:setY (y)
    if self.bounds then
        self.y = clamp(y, self.bounds.y1, self.bounds.y2)
    else
        self.y = y
    end
end



--
--  Move the helicopter
--
function Helicopter:move (dx,dy)
    dx = dx or 0
    dy = dy or -1
    self:setX(self.x - dx)
    self:setY(self.y - dy)
end



--
--  Load callback
--
function Helicopter:load ()
    -- Load the image
    self.image = love.graphics.newImage(self.imgPath)
    -- populate frames list
    for f=1,self.frames.total do
        self.frames.list[f] = love.graphics.newQuad((f-1) * self.frames.w,
                                                    0,
                                                    self.frames.w,
                                                    self.frames.h,
                                                    self.image:getDimensions()  ) 
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



