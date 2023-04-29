---
--- Class prototyping
---



local classMetatable = {}



function classMetatable:__index (key)
    return self.__baseclass[key]
end



class = setmetatable({__baseclass={}}, classMetatable)



--
--  Factory
--
function class:new(...)
    local c = {}
    c.__baseclass = self
    setmetatable(c, getmetatable(self))
    if c.init then c:init(...) end
    return c
end



