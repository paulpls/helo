--
--  Trail mechanics
--

Trail = class:new()



--
--  Init
--
function Trail:init (x, y, path) 

    --  Basics
    self.x = x
    self.y = y
    self.path = path or trailImgPath
    self.image = love.graphics.newImage(self.path)
    self.w,self.h = self.image:getDimensions()

    --  Animation-related things
    self.frames = {}
    self.frames.total = trailFrames
    self.frames.list = {}
    self.frames.w = trailSpriteWidth
    self.frames.h = trailSpriteHeight
    self.frames.current = 1
    self.delay = trailAnimationDelay
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
--  Animation
--
function Trail:animate (dt)
    --  Add to elapsed time
    self.elapsedTime = self.elapsedTime + dt
    --  Increment frame if delay has been passed
    if self.delay <= self.elapsedTime then
        self.elapsedTime = self.elapsedTime - self.delay
        if not (self.frames.current == self.frames.total) then
            self.frames.current = self.frames.current + 1
        end
    end
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
    self:animate(dt)
end



--
--  Draw callback
--
function Trail:draw ()

    love.graphics.setColor(colorDefault)
    --  Draw the trail
    love.graphics.draw( self.image,
                        self.frames.list[self.frames.current].quad,
                        self.x,
                        self.y  )

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



