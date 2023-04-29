---
--- Helicopter prototype
---

Helicopter = class:new()



--
--  init
--
function Helicopter:init (x, y, liftSpeed, dropSpeed, dropDelay, bounds, imgPath)
    self.x = x or 0
    self.y = y or 0
    self.liftSpeed = liftSpeed or helicopterLiftSpeed
    self.dropSpeed = dropSpeed or helicopterDropSpeed
    self.dropDelay = dropDelay or helicopterDropDelay
    --  Boundaries
    self.bounds = bounds or helicopterBounds
    --  Image attributes
    self.imgPath = helicopterImgPath or imgPath
    self.image = love.graphics.newImage(self.imgPath)
    --  Animation-related things
    self.frames = {}
    self.frames.total = spriteFrames
    self.frames.list = {}
    self.frames.w = spriteWidth
    self.frames.h = spriteHeight
    self.frames.current = 1
    self.delay = spriteAnimationDelay
    self.elapsedTime = 0
    --  Build the frames list
    for f=1,self.frames.total do
        self.frames.list[f] = QuadData:new( self.image,
                                            (f-1) * self.frames.w,
                                            0,
                                            self.frames.w * self.frames.total,
                                            self.frames.h                        )
    end
    self.fallDelay = helicopterFallDelay
    self.fallElapsedTime = 0
    --  Statuses
    self.falling = false
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
function Helicopter:move (dx, dy)
    dx = dx or 0
    dy = dy or -1
    if dy > 0 then
        dy = dy * self.liftSpeed
    elseif dy < 0 then
        if self.falling then
            dy = dy * self.dropSpeed
        else
            dy = 0
        end
    end
    self:setX(self.x - dx)
    self:setY(self.y - dy)
end



--
--  Load callback
--
function Helicopter:load ()
end



--
--  Update callback
--
function Helicopter:update (dt)
    self:animate(dt)
end



--
--  Draw callback
--
function Helicopter:draw ()
    love.graphics.draw(self.image,
                       self.frames.list[self.frames.current].quad,
                       self.x,
                       self.y   )
end



