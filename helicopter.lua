---
--- Helicopter prototype
---

Helicopter = class:new()



--
--  init
--
function Helicopter:init (x, y, xSpeed, liftSpeed, dropSpeed, dropDelay, bounds, hitbox, hitboxTolerance)
    self.x = x or 0
    self.y = y or 0
    self.xSpeed = xSpeed or helicopterXSpeed
    self.liftSpeed = liftSpeed or helicopterLiftSpeed
    self.dropSpeed = dropSpeed or helicopterDropSpeed
    self.dropDelay = dropDelay or helicopterDropDelay
    --  Boundaries
    self.bounds = bounds or helicopterBounds
    --  Image paths
    self.imgPath = helicopterImgPath
    self.fireImagePath = helicopterFireImgPath
    --  Load images
    self.image = love.graphics.newImage(self.imgPath)   --  current image
    self.normalImage = love.graphics.newImage(self.imgPath)
    self.fireImage = love.graphics.newImage(self.fireImagePath)
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
    --  Hitbox
    self.hitbox = hitbox or helicopterHitbox
    self.hitboxTolerance = hitboxTolerance or helicopterHitboxTolerance
    --  Statuses
    self.falling = false
    self.crashed = false
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
    --  Add to elapsed time
    self.elapsedTime = self.elapsedTime + dt
    --  Increment frame if delay has been passed
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
    self:updateHitbox()
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
    self:updateHitbox()
end



--
--  Move the helicopter
--
function Helicopter:move (dx, dy)
    dx = dx * self.xSpeed or 0
    dy = dy or 0
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
--  Crash the helicopter
--
function Helicopter:crash ()
    self.crashed = true
    self.image = self.fireImage
end



--
--  Update hitbox
--
function Helicopter:updateHitbox ()
    local x,y = self.x, self.y
    local w,h = self.frames.w, self.frames.h
    local t = self.hitboxTolerance
    self.hitbox = {
                      x1 = x + t.x1,
                      y1 = y + t.y1,
                      x2 = x + w - t.x2,
                      y2 = y + h - t.y2
                                                    }
end



--
--  Collision detection
--
function Helicopter:detectCollisions (hitbox)
    --  If crashed, skip collision detection
    if self.crashed then return end
    --  Setup locals
    local collision = false
    local hurtbox = self.hitbox
    --  Detect collision with provided hitbox
    if hitbox then
        local left = hurtbox.x2 >= hitbox.x1
        local right = hurtbox.x1 <= hitbox.x2
        local top = hurtbox.y2 >= hitbox.y1
        local bottom = hurtbox.y1 <= hitbox.y2
        if left and top and bottom and right then collision = true end
    end
    --  Detect collision with boundaries if no hitbox is provided
    if not(hitbox) then
        local x,y = self.x, self.y
        local left = hurtbox.x1 <= self.bounds.x1
        local right = hurtbox.x2 >= self.bounds.x2
        local top = hurtbox.y1 <= self.bounds.y1
        local bottom = hurtbox.y2 >= self.bounds.y2
        if left or right or top or bottom then collision = true end
    end
    return collision
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



