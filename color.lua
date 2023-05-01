--
--  Color management
--

Color = {}
Color.default = colorDefault or {1, 1, 1, 1}
Color.rainbow = colorRainbow or false



--
--  Rainbow color cycle
--
Color.rainbowCycle = {}
--  Red -> Add green
for i=0, 255 do table.insert(Color.rainbowCycle, {1, i/255, 0}) end
--  Green -> Subtract red
for i=1, 255 do table.insert(Color.rainbowCycle, {1-(i/255), 1, 0}) end
--  Green -> Add blue
for i=1, 255 do table.insert(Color.rainbowCycle, {0, 1, i/255}) end
--  Blue -> Subtract green
for i=1, 255 do table.insert(Color.rainbowCycle, {0, 1-(i/255), 1}) end
--  Blue -> Add red
for i=1, 255 do table.insert(Color.rainbowCycle, {i/255, 0, 1}) end
--  Red -> Subtract blue
for i=1, 255 do table.insert(Color.rainbowCycle, {1, 0, 1-(i/255)}) end



