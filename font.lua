--
--  Custom fonts
--

Font = class:new()



--
--  Init
--
function Font:init(path, glyphs)
    path = path or fontPath
    glyphs = glyphs or fontGlyphs
    self.face = love.graphics.newImageFont(path, glyphs)
end



--
--  Set the font
--
function Font:set()
    love.graphics.setFont(self.face)
end



--
--  Load callback
--
function Font:load()
    self:set()
end



