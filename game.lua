--
--  Game state management
--

Game = class:new()



--
--  Init
--
function Game:init ()
    --  Scoring
    self.score = 0
    self.highScore = 0
    self.scoreMultiplier = 1
    self.scoreDelay = wallSpawnDelay
    self.scoreElapsed = 0
    --  Game event flags
    self.start = true
    self.paused = false
    self.over = false
end



--
--  Update score
--
function Game:updateScore (dt)
    if self.scoreElapsed >= self.scoreDelay then
        --  Update score
        self.score = self.score + self.scoreMultiplier
        --  Update high score
        if self.score > self.highScore then self.highScore = self.score end
        --  Now what we're gonna do right here is go back
        --  Way back
        --  Back into time
        self.scoreElapsed = self.scoreElapsed - self.scoreDelay
    else
        self.scoreElapsed = self.scoreElapsed + dt
    end
end



--
--
--
local function _pad (str, pad, ch)
    local str = str
    local ch = ch or " "
    local len = #str
    if len < pad then
        for i=len, pad-1 do str = ch..str end
    end
    return str
end



--
--  Display score with left zero padding
--
function Game:getScoreDisplay (pad)
    local str = tostring(self.score)
    local ch = "0"
    return _pad(str, pad, ch)
end



--
--  Display score with left zero padding
--
function Game:getHighScoreDisplay (pad)
    local str = tostring(self.highScore)
    local ch = "0"
    return _pad(str, pad, ch)
end



--
--  Returns true if game is running
--
function Game:isRunning ()
    return not self.paused and not self.over
end



