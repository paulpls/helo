--
--  Color management
--

Color = {}
Color.default = colorDefault or {1, 1, 1, 1}
Color.rainbow = colorRainbow or false
Color.rainbowResolution = colorRainbowResolution or 255



--
--  Rainbow color cycle
--
Color.rainbowCycle = {}
local res = Color.rainbowResolution
--  Red -> Add green
for i=0, res do table.insert(Color.rainbowCycle, {1, i/res, 0}) end
--  Green -> Subtract red
for i=1, res do table.insert(Color.rainbowCycle, {1-(i/res), 1, 0}) end
--  Green -> Add blue
for i=1, res do table.insert(Color.rainbowCycle, {0, 1, i/res}) end
--  Blue -> Subtract green
for i=1, res do table.insert(Color.rainbowCycle, {0, 1-(i/res), 1}) end
--  Blue -> Add red
for i=1, res do table.insert(Color.rainbowCycle, {i/res, 0, 1}) end
--  Red -> Subtract blue
for i=1, res do table.insert(Color.rainbowCycle, {1, 0, 1-(i/res)}) end



