--
--  Block mechanics
--

Block = class:new()
--  These properties are shared for all block instances
Block.spawnpoint = math.floor(windowHeight / 2)
Block.gapMinSize = blockGapMinSize
Block.gapMaxSize = blockGapMaxSize
Block.gapSize = blockGapMaxSize
Block.randomSpawnGapMin = blockRandomSpawnGapMin
Block.wallsDirection = true -- `true` for up, `false` for down



--
--  Init
--
function Block:init (x, y, width, height, color, moving, speedX, speedY, bounds)
    self.x = x or blockX
    self.y = y or blockY
    self.width = width or blockWidth
    self.height = height or blockHeight
    self.color = color or blockColor
    self.moving = moving or blockMoving
    self.speedX = speedX or blockSpeedX
    self.speedY = speedY or blockSpeedY
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
            "speed:  "..self.speedX..", "..self.speedY.."\n",
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
--  Set block x coordinate and check bounds
--
function Block:setX (x)
    if self.bounds then
        self.x = clamp(x, self.bounds.x1, self.bounds.x2)
    else
        self.x = x
    end
    self:updateHitbox()
end



--
--  Set block y coordinate and check bounds
--
function Block:setY (y)
    if self.bounds then
        self.y = clamp(y, self.bounds.y1, self.bounds.y2)
    else
        self.y = y
    end
    self:updateHitbox()
end



--
--  Move the block
--
function Block:move (dx, dy, speedX, speedY)
    local dx = dx or 0
    local dy = dy or 0
    local speedX = speedX or self.speedX
    local speedY = speedY or self.speedY
    dx = dx * speedX or 0
    dy = dy * speedY or 0
    self:setX(self.x - dx)
    self:setY(self.y - dy)
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
--  Offscreen check
--
function Block:isOffscreen (bounds)

    --  Define boundaries
    local x1,y1 = self.x, self.y
    local x2,y2 = self.x + self.width, self.y + self.height
    local bx1, bx2 = bounds.x1, bounds.x2
    local by1, by2 = bounds.y1, bounds.y2

    --  Check each side of the window
    local left = x2 < bx1    -- right edge of block is past the left edge
    local right = x1 > bx2   -- left edge of block is past the right edge
    local top = y2 < by1     -- top edge of block is past the bottom edge
    local bottom = y1 > by2  -- bottom edge of block is past the top edge

    --  Return offscreen status
    return left or right or top or bottom

end



--
--  Return new walls and update spawning parameters
--
function Block:spawnWalls (spawnX, spawnY, color)

    local x,y = spawnX, spawnY
    local c = color or self.color
    local above = above or false
    local w = blockWidth

    --  Spawn the block above the spawnpoint
    local y1 = y
    local h1 = math.max(Block.spawnpoint - math.ceil(Block.gapSize / 2), blockMargin)

    --  Spawn the block below the spawnpoint
    local y2 = math.min(Block.spawnpoint + math.floor(Block.gapSize / 2), camera.bounds.y2 - blockMargin)
    local h2 = camera.bounds.y2 - y2

    --  Update spawn parameters
    Block.updateWalls(camera.bounds)

    --  Return new block instances
    return {
               Block:new(x, y1, w, h1, c),
               Block:new(x, y2, w, h2, c)
           }

end



--
--  Update walls spawnpoint
--
function Block.updateWalls (bounds)

    --  Fetch current parameters
    local y,ymin,ymax = Block.spawnpoint, bounds.y1 + blockMargin, bounds.y2 - blockMargin
    --local g,gmin,gmax = Block.gapSize, Block.gapMinSize, Block.gapMaxSize

    --  Randomize the y value change
    local dyList = {0, 1, 1, 1, 1, 1, 2, 3, 5, 8, 13, 21}

    --  Get a random value from the table above
    local dy = dyList[rng(1, #dyList)]

    --  Subtract (move up) if direction is true, add (move down) if false
    if Block.wallsDirection then dy = y - dy else dy = y + dy end

    --  Clamp the changes to the boundaries
    dy = clamp(math.floor(dy), ymin, ymax)

    --  Reverse direction if top or bottom is reached
    local wallsTop = y == ymin and Block.wallsDirection
    local wallsBottom = y == ymax and not Block.wallsDirection
    if wallsTop or wallsBottom then
        Block.wallsDirection = not Block.wallsDirection

    --  Randomize the gap size change
    --local dg = rng(66, 150) / 100
    --g = clamp(math.floor(g * dg), gmin, gmax)
    end

    --  Set the changed values
    Block.spawnpoint = dy
    --Block.gapSize = dg

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

    love.graphics.setColor(self.color)
    love.graphics.rectangle( "fill",
                             self.x,
                             self.y,
                             self.width,
                             self.height    )

end



