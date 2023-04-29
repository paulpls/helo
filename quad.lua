---
--- Quad Data
---

QuadData = class:new()



--
--  Init
--
function QuadData:init (img, x, y, width, height)
    self.img = img
    self.quad = love.graphics.newQuad(x, y, spriteWidth, spriteHeight, width, height)
end



