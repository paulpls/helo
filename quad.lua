--
--  Quad Data
--

QuadData = class:new()



--
--  Init
--
function QuadData:init (img, x, y, sWidth, sHeight, width, height)
    local sWidth = sWidth or spriteWidth
    local sHeight = sHeight or spriteHeight
    self.img = img
    self.quad = love.graphics.newQuad(x, y, sWidth, sHeight, width, height)
end



