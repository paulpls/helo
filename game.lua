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
        self.score = self.score + self.scoreMultiplier
        self.scoreElapsed = self.scoreElapsed - self.scoreDelay
    else
        self.scoreElapsed = self.scoreElapsed + dt
    end
end



--
--  Display score with left zero padding
--
function Game:getScoreDisplay (pad, ch)
    local str = tostring(game.score)
    local ch = ch or "0"
    local len = #tostring(self.score)
    if len < pad then
        for i=len, pad do str = ch..str end
    end
    return str
end



--
--  Returns true if game is running
--
function Game:isRunning ()
    return not self.paused and not self.over
end



