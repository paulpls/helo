---
--- Global variable definitions
---



--
--  Window
--
windowWidth = 960
windowHeight = 544
windowMarginX = 16
windowMarginY = 16
windowTitle = "HELO"
windowIconPath = "assets/img/icon.png"
windowBounds = {
                    x1 = 0,
                    y1 = 0,
                    x2 = windowWidth,
                    y2 = windowHeight
                                        }



--
--  Walls
--
wallHeight = 32



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
helicopterSpeedX = 3.0
helicopterLiftSpeed = 2.0
helicopterFallSpeed = 2.5
helicopterFallDelay = 0.1
helicopterBounds = {
                        x1 = windowMarginX,
                        y1 = windowMarginY,
                        x2 = windowWidth - spriteWidth - windowMarginX,
                        y2 = windowHeight - spriteHeight - windowMarginY
                                                                          }
helicopterImgPath = "assets/img/helo.png"
helicopterFireImgPath = "assets/img/helo_fire.png"
helicopterHitboxTolerance = {
                                x1 = 2,
                                y1 = 6,
                                x2 = 2,
                                y2 = 9
                                         }
helicopterHitbox = {
                       x1 = helicopterX + helicopterHitboxTolerance.x1,
                       y1 = helicopterY + helicopterHitboxTolerance.y1,
                       x2 = helicopterX + spriteWidth - helicopterHitboxTolerance.x2,
                       y2 = helicopterY + spriteHeight - helicopterHitboxTolerance.y2
                                                     }



--
--  Camera
--
cameraX = 0
cameraY = 0
cameraSpeedX = 1
cameraSpeedY = 1
cameraScaleX = 1
cameraScaleY = 1
cameraRotation = 0
cameraBounds = windowBounds



--
--  Blocks
--
blockWidth = 64
blockHeight = 64
blockX = windowWidth
blockY = math.floor((windowHeight-(windowMarginY*2)/2) - math.floor(blockHeight/2))
blockMoving = false
blockSpeedX = 1
blockSpeedY = 1
blockBounds = {
                  x1 = windowMarginX - blockWidth,
                  y1 = windowMarginY,
                  x2 = windowWidth - windowMarginX,
                  y2 = windowHeight - windowMarginY
                                                     }



