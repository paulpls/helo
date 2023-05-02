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
    self.scoreDelay = blockSpawnDelay
    self.scoreElapsed = 0
    --  Game event flags
    self.start = true
    self.paused = false
    self.over = false
end



--
--  Update score
--
function Game:updateScore(dt)
    if self.scoreElapsed >= self.scoreDelay then
        self.score = self.score + self.scoreMultiplier
        self.scoreElapsed = self.scoreElapsed - self.scoreDelay
    else
        self.scoreElapsed = self.scoreElapsed + dt
    end
end



--
--  Returns true if game is running
--
function Game:isRunning ()
    return not self.paused and not self.over
end



