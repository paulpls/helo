---
--- Camera controller
---

Camera = class:new()



--
--  Camera init
--
function Camera:init (x, y, vX, vY, sX, sY, r, bounds)
    self.x = x or cameraX
    self.y = x or cameraY
    self.speedX = vX or cameraSpeedX
    self.speedY = vY or cameraSpeedY
    self.scaleX = sX or cameraScaleX
    self.scaleY = sY or cameraScaleY
    self.rotation = r or cameraRotation
    self.bounds = bounds or cameraBounds
end


--
--  Clamp to boundaries
--
local clamp = function (n, min, max) return n < min and min or (n > max and max or n) end



--
--  Debug
--
function Camera:debugPrint ()
    msg = {
        "x:        "..self.x.."\n",
        "y:        "..self.y.."\n",
        "scaleX:   "..self.scaleX.."\n",
        "scaleY:   "..self.scaleY.."\n",
        "rotation: "..self.rotation.."\n",
        "",
    }
    print("-- Camera info: ---\n"..table.concat(msg))
end



--
--  Set the camera according to the current state
--
function Camera:set ()
    local x,y = self.x, self.y
    local scaleX,scaleY = 1/self.scaleX, 1/self.scaleY
    local rotation = -self.rotation
    love.graphics.push()
    love.graphics.translate(x,y)
    love.graphics.scale(scaleX, scaleY)
    love.graphics.rotate(rotation)
end



--
--  Unset the camera
--
function Camera:unset ()
    love.graphics.pop()
end



--
--  Pan the camera
--
function Camera:pan (dx,dy)
    local dx = dx or 0
    local dy = dy or 0
    self:setX(self.x - (dx * self.speedX))
    self:setY(self.y - (dy * self.speedY))
end



--
--  Rotate the camera
--
function Camera:rotate (dr)
    self.rotation = self.rotation + dr
end



--
--  Scale the camera
--
--  Defaults to 1x scale and equal scaling per axis
--  unless `dy` is provided.
--
function Camera:scale (dx,dy)
    dx = dx or 1                           -- setup x scale factor
    self.scaleX = self.scaleX * dx         -- scale the x axis
    self.scaleY = self.scaleY * (dy or dx) -- scale the y axis
end



--
--  Set camera x coordinate and check bounds
--
function Camera:setX (x)
    if self.bounds then
        self.x = clamp(x, self.bounds.x1, self.bounds.x2)
        self.x = x
    else
        self.x = x
    end
end



--
--  Set camera y coordinate and check bounds
--
function Camera:setY (y)
    if self.bounds then
        self.y = clamp(y, self.bounds.y1, self.bounds.y2)
    else
        self.y = y
    end
end



--
--  Warp the camera to specific coordinates
--
function Camera:warp (x,y)
    if x then self:setX(x) end
    if y then self:setY(y) end
end



--
--  Change camera scaling factors
--
function Camera:setScale (dx,dy)
    self.scaleX = dx or self.scaleX
    self.scaleY = dy or self.scaleY
end



--
--  Set camera bounds
--
--  `bounds` is a table with the following keys:
--      x1, y1, x2, y2
--
function Camera:setBounds (bounds)
    self.bounds = bounds
end



--
--  Move bounds
--
function Camera:moveBounds (dx,dy)
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
--  Return the camera bounds
--
function Camera:getBounds ()
    return unpack(self.bounds)
end



--
--  Load callback
--
function Camera:load ()
end



--
--  Update callback
--
function Camera:update (dt)
end



--
--  Draw callback
--
function Camera:draw ()
end



