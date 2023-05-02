--
--  Trail mechanics
--

Trail = class:new()



--
--  Init
--
function Trail:init (x, y, path) 
    self.x = x
    self.y = y
    self.path = path or trailImgPath
    self.image = love.graphics.newImage(self.path)
    self.w,self.h = self.image:getDimensions()
end



--
--  Debug
--
function Trail:debugPrint ()
    msg = {
            "x:      "..self.x.."\n",
            "y:      "..self.y.."\n",
            "w:      "..self.w.."\n",
            "h:      "..self.h.."\n",
            "path:   "..self.path.."\n",
          } 
    print("-- Trail info: ---\n"..table.concat(msg))
end



--
--  Offscreen check
--
function Trail:isOffscreen (x)
    --  Return true if trail is past the left edge
    return x >= self.x + self.w
end



--
--  Load callback
--
function Trail:load ()
end



--
--  Update callback
--
function Trail:update (dt)
end



--
--  Draw callback
--
function Trail:draw ()

    love.graphics.setColor(colorDefault)
    --  Draw the trail
    love.graphics.draw(self.image, self.x, self.y)

    --  Draw debug overlays
    if debugTrail and not debugNone or debugAll then
        --  Trail outline
        love.graphics.setColor(debugColorOutline)
        love.graphics.rectangle( "line",
                                 self.x,
                                 self.y,
                                 self.w,
                                 self.h)
    end

end



