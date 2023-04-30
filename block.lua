---
--- Block mechanics
---

Block = class:new()



--
--  init
--
function Block:init (x, y, width, height, moving, speed, bounds)
    self.x = x or blockX
    self.y = y or blockY
    self.width = width or blockWidth
    self.height = height or blockHeight
    self.moving = moving or blockMoving
    self.speed = speed or blockSpeed
    self.bounds = bounds or blockBounds
    self.hitbox = {
                      x1 = self.x,
                      y1 = self.y,
                      x2 = self.x + self.width,
                      y2 = self.y + self.height
                                                  }
end



--
--  Debug
--
function Block:debugPrint ()
    msg = {
            "x:      "..self.x.."\n",
            "y:      "..self.y.."\n",
            "width:  "..self.width.."\n",
            "height: "..self.height.."\n",
            "moving: "..tostring(self.moving).."\n",
            "speed:  "..self.speed.."\n",
                                     } 
    print("-- Block info: ---\n"..table.concat(msg))
end



--
--  Clamp to boundaries
--
local clamp = function (n, min, max) return n < min and min or (n > max and max or n) end



--
--  Detect out-of-bounds
--
function Block:outOfBounds ()
    --  NOTE Not checking x2 because blocks spawn on that side
    local x1 = self.x < self.bounds.x1
    local y1 = self.y < self.bounds.y1
    local y2 = self.y > self.bounds.y2
    return x1 or y1 or y2
end



--
--  Update hitbox
--
function Block:updateHitbox ()
    self.hitbox = {
                      x1 = self.x,
                      y1 = self.y,
                      x2 = self.x + self.width,
                      y2 = self.y + self.height
                                                  }
end
    


--
--  Load callback
--
function Block:load ()
end



--
--  Update callback
--
function Block:update (dt)
    self:updateHitbox()
end



--
--  Draw callback
--
function Block:draw ()
    love.graphics.setColor(0.25,1,0.33,1)
    love.graphics.rectangle( "fill",
                             self.x,
                             self.y,
                             self.width,
                             self.height    )
end



