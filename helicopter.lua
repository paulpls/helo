--
--  Helicopter prototype
--

Helicopter = class:new()



--
--  init
--
function Helicopter:init (x, y, speedX, liftSpeed, liftDelay, fallSpeed, fallDelay, bounds, hitbox, hitboxTolerance, scale)

    --  Coordinates
    self.x = x or 0
    self.y = y or 0

    --  Scaling
    self.scale = scale or helicopterScale

    --  Velocity and acceleration
    self.speedX = speedX or helicopterSpeedX
    self.liftSpeed = liftSpeed or helicopterLiftSpeed
    self.liftDelay = liftDelay or helicopterLiftDelay
    self.liftElapsedTime = 0
    self.fallSpeed = fallSpeed or helicopterFallSpeed
    self.fallDelay = fallDelay or helicopterFallDelay
    self.fallElapsedTime = 0

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
                                            self.frames.w,
                                            self.frames.h,
                                            self.frames.w * self.frames.total,
                                            self.frames.h                        )
    end
    
    --  Hitbox
    self.hitbox = hitbox or helicopterHitbox
    self.hitboxTolerance = hitboxTolerance or helicopterHitboxTolerance

    --  Statuses
    self.falling = false
    self.lifting = false
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
function Helicopter:move (dx, dy, speedX, liftSpeed, fallSpeed)
    local dx = dx or 0
    local dy = dy or 0
    local speedX = speedX or self.speedX
    local liftSpeed = liftSpeed or self.liftSpeed
    local fallSpeed = fallSpeed or self.fallSpeed
    dx = dx * speedX or 0
    dy = dy or 0
    if dy > 0 then
        dy = dy * liftSpeed
    elseif dy < 0 then
        dy = dy * fallSpeed
    end
    self:setX(self.x + dx)
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
    local s = self.scale
    self.hitbox = {
                      x1 = x + (t.x1 * s),
                      y1 = y + (t.y1 * s),
                      x2 = x + ((w - t.x2) * s),
                      y2 = y + ((h - t.y2) * s)
                  }
end



--
--  Collision detection
--
function Helicopter:detectCollisions (obj)

    --  If crashed, skip collision detection
    if self.crashed then return end

    --  Setup locals
    local collision = false
    local hurtbox = self.hitbox

    --  Detect collision with provided hitbox
    if obj then
        local hitbox = obj.hitbox
        local left = hurtbox.x2 >= hitbox.x1
        local right = hurtbox.x1 <= hitbox.x2
        local top = hurtbox.y2 >= hitbox.y1
        local bottom = hurtbox.y1 <= hitbox.y2
        if left and top and bottom and right then collision = true end

    --  Detect collision with boundaries if no obj is provided
    else
        local hitbox = self.bounds
        local y = self.y
        local top = hurtbox.y2 <= hitbox.y1
        local bottom = hurtbox.y1 >= hitbox.y2
        if top or bottom then collision = true end
    end

    return collision
end



--
--  Set bounds
--
function Helicopter:setBounds (bounds)
    self.bounds = bounds
end



--
--  Move bounds
--
function Helicopter:moveBounds (dx,dy)
    local dx = dx or 0
    local dy = dy or 0
    local x1,x2 = self.bounds.x1, self.bounds.x2
    local y1,y2 = self.bounds.y1, self.bounds.y2
    local bounds = {
                       x1 = x1 + dx,
                       x2 = x2 + dx,
                       y1 = y1 + dy,
                       y2 = y2 + dy
                   }
    self:setBounds(bounds)
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

    --  Draw the helicopter
    love.graphics.draw( self.image,
                        self.frames.list[self.frames.current].quad,
                        self.x,
                        self.y,
                        0,
                        self.scale,
                        self.scale        )

    --  Draw debug overlays
    if debugHelicopter and not debugNone or debugAll then
        --  Draw sprite outline
        love.graphics.setColor(debugColorOutline)
        love.graphics.rectangle( "line",
                                 self.x,
                                 self.y,
                                 self.frames.w * self.scale,
                                 self.frames.h * self.scale )
        --  Draw hitbox
        love.graphics.setColor(debugColorHitbox)
        love.graphics.rectangle( "line",
                                 self.hitbox.x1,
                                 self.hitbox.y1,
                                 self.hitbox.x2 - self.hitbox.x1,
                                 self.hitbox.y2 - self.hitbox.y1    )
    end
end



