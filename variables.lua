---
--- Global variable definitions
---



--
--  Window
--
windowWidth = 960
windowHeight = 544
windowTitle = "HELO"
windowIconPath = "assets/img/icon.png"
windowBounds = {
                    x1 = 0,
                    y1 = 0,
                    x2 = windowWidth,
                    y2 = windowHeight
                                        }



--
--  Sprites
--
spriteWidth = 32
spriteHeight = 32
spriteFrames = 8
spriteAnimationDelay = 0.1



--
--  Helicopter
--
helicopterX = math.floor(windowWidth / 3) - math.floor(spriteWidth / 2)
helicopterY = math.floor(windowHeight / 2) - math.floor(spriteHeight / 2)
helicopterLiftSpeed = 2.0
helicopterDropSpeed = 2.5
helicopterDropDelay = 1.0
helicopterBounds = {
                        x1 = 0,
                        y1 = 0,
                        x2 = windowWidth - spriteWidth,
                        y2 = windowHeight - spriteHeight
                                                          }
helicopterImgPath = "assets/img/helo.png"
helicopterFireImgPath = "assets/img/helo_fire.png"
helicopterFallDelay = 0.1



--
--  Camera
--
cameraX = 0
cameraY = 0
cameraScaleX = 1
cameraScaleY = 1
cameraRotation = 0
cameraBounds = windowBounds



