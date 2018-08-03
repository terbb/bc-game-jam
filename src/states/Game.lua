Game = State:subclass("Game")
Game.static.WAIT_DURATION = 1.5

function Game:update(dt)
  self.level:update(dt)

  if self.mode == "wait" then
    self:wait(dt)
  end
  
  if self.mode == "cut" then  
    self.drawing:update()
    if self.drawing.closed or not love.mouse.isDown(1) then 
      self.mode = "score" 
    elseif not self.drawing:isMouseAtSamePoint() then
      Sound:play("sfx_cutting")
      self.cursor:update(self.drawing.lines)
      local mouseCoord = scale:getWorldMouseCoordinates()
      self.drawing:insertPoint(mouseCoord)
    else
      Sound:stop("sfx_cutting")
    end
  end
  
  if self.mode == "score" then
    Sound:play("sfx_snip")
    self.drawing:updateValues()
    self.level:scoreDrawing(self.drawing) 
    self.mode = "wait"
  end

  if self.mode == "ready" then
    if love.mouse.isDown(1) then self.mode = "cut" end
  end
end

function Game:draw()
  self.level:draw()
  self.drawing:draw()
  self.cursor:draw(self.mode)
end

function Game:initialize()  
  love.mouse.setVisible(false)
  user:applyModifiers()
  self.mode = "ready"
  self.waitTimer = 0
  self.bg = ImagePlaceable("assets/graphics/game/bg/bg_game16x9.png")
  self.level = Level()
  self.drawing = Polygon()
  self.cursor = Cursor()
  Sound:create("assets/audio/sfx/sfx_blipmale.wav", "blipmale", false)
  Sound:create("assets/audio/sfx/sfx_blipfemale.wav", "blipfemale", false)
  Sound:createAndPlay("assets/audio/music/bgm_papercutter.ogg", "bgm", true, "stream")
end

function Game:wait(dt)
  self.waitTimer = self.waitTimer + dt
  
  if self.waitTimer >= Game.WAIT_DURATION then
    self.waitTimer = 0
    self.mode = "ready"
    self.drawing = Polygon()
    self.level:generateProblem()
  end
end

function Game:mouseRelease(x, y, button, isTouch) 
end

function Game:mousePressed(x, y, button, isTouch)
end

function Game:__tostring()
  return "Game"
end