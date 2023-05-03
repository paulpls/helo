--
--  Messages
--

Message = class:new()



--  Init
function Message:init (text, bold, x, y)
    --  Message text
    self.text = text
    --  Bold text
    self.bold = bold or false
    --  Calculate message width and height
    local w = #text * (fontWidth + fontKerning)
    local h = fontHeight
    --  Find the camera centerpoint to use as default
    --  NOTE The y coordinate defaults to slightly below the centerline
    local cX = camera.bounds.x1 + math.floor((camera.bounds.x2 - camera.bounds.x1) / 2)
    local cY = camera.bounds.y1 + math.floor((camera.bounds.y2 - camera.bounds.y1) / 1.5)
    --  Calculate message x,y if not provided
    self.x = x or cX - math.floor(w / 2)
    self.y = y or cY - math.floor(h / 2)
end



function Message:draw ()
    love.graphics.setColor(Color.text)
    if self.bold then
        for o=0, fontBoldWidth-1 do
            love.graphics.print(self.text, self.x + o, self.y)
        end
    end
end



