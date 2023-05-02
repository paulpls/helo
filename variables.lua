--
--  Global variable definitions
--



--
--  Window
--
windowWidth = 640
windowHeight = 480
windowMarginX = 0
windowMarginY = 0
windowTitle = "HELO"
windowIconPath = "assets/img/icon_16.png"
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
helicopterScale = 2
helicopterSpeedX = 3.0
helicopterLiftSpeed = 2.0
helicopterLiftDelay = 0.25
helicopterFallSpeed = 3.5
helicopterFallDelay = 0.33
helicopterHitboxTolerance = {
                                x1 = 2,
                                y1 = 6,
                                x2 = 2,
                                y2 = 9
                            }
helicopterHitbox = {
                       x1 = helicopterX + helicopterHitboxTolerance.x1,
                       y1 = helicopterY + helicopterHitboxTolerance.y1,
                       x2 = helicopterX + (spriteWidth * helicopterScale) - helicopterHitboxTolerance.x2,
                       y2 = helicopterY + (spriteHeight * helicopterScale) - helicopterHitboxTolerance.y2
                   }
helicopterBounds = {
                        x1 = windowMarginX - (helicopterHitboxTolerance.x1 * helicopterScale),
                        y1 = windowMarginY - (helicopterHitboxTolerance.y1 * helicopterScale),
                        x2 = windowWidth - ((spriteWidth - helicopterHitboxTolerance.x2) * helicopterScale) - windowMarginX,
                        y2 = windowHeight - ((spriteHeight - helicopterHitboxTolerance.y2) * helicopterScale) - windowMarginY
                   }
helicopterImgPath = "assets/img/helo.png"
helicopterFireImgPath = "assets/img/helo_fire.png"



--
--  Camera
--
cameraX = 0
cameraY = 0
cameraSpeedX = 2
cameraSpeedY = 1
cameraScaleX = 1
cameraScaleY = 1
cameraRotation = 0
cameraBounds = windowBounds



--
--  Blocks
--
blockWidth = 32
blockHeight = 128
blockMargin = 32
blockX = windowWidth
blockY = math.floor((windowHeight-(windowMarginY*2)/2) - math.floor(blockHeight/2))
blockColor = {0.25, 1, 0.33}
blockMoving = false
blockSpeedX = 1
blockSpeedY = 1
blockBounds = {
                  x1 = windowMarginX - blockWidth,
                  y1 = windowMarginY,
                  x2 = windowWidth - windowMarginX,
                  y2 = windowHeight - windowMarginY
              }
blockSpawnDelay = 0.225
blockGapMinSize = 96
blockRandomSpawnGapMin = 512
blockGapMaxSize = math.floor(windowHeight * 0.75)
blockChangeGap = 30



--
--  Colors
--
colorDefault = {1, 1, 1, 1}
colorRainbow = false
colorRainbowResolution = 1023



--
--  Fonts
--
fontPath = "assets/fonts/pixel.png"
fontGlyphs = " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
fontWidth = 11
fontHeight = 16
fontKerning = 3
fontBoldWidth = 2



--
--  Messages
--
msgGameOver = "GAME OVER"
msgQuit = "Bye, Felicia"



