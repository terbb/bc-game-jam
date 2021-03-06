local screen = require "modules/shack"

GameOver = State:subclass("GameOver")
GameOver.static.PITCH = 0.9

function GameOver:initialize()
  Sound:clearAll()
  local score = score or 0
  love.mouse.setVisible(true)
  
  local function gameOverAppear(self, args)
    Sound:createAndPlay("assets/audio/sfx/sfx_deskslam.wav", "damage_1", false)
    self.color = args.color
    screen:setShake(40)
    screen:setRotation(0.3)
    screen:zoom(1.15)    
  end
  
  local gameOver = TextPlaceable("YOU'RE FIRED!", nil, nil, Graphics.GONE, 1)
  gameOver.position.x = baseRes.width * 0.5 - gameOver.dimensions.width * 0.5
  gameOver.position.y = baseRes.height * 0.09
  gameOver:replaceTimer("appear", 0.1, gameOverAppear, {color = Graphics.RED})
  
  local yourScore = TextPlaceable(("Score: %i"):format(score), nil, nil, Graphics.GONE)
  yourScore:setCentreHorizontal(gameOver)
  yourScore:setBelow(gameOver, 5)
  
  highScore:createScorePlaceables(yourScore.position.y + 45)
  highScore:hidePlaceables()
  
  local onClickRetry = function()
    Sound:createAndPlay("assets/audio/sfx/sfx_click.mp3", "click")
    state = Game()
  end

  local onClickMenu = function()
    Sound:createAndPlay("assets/audio/sfx/sfx_click.mp3", "click")
    state = MainMenu()
  end
  
  local retry = TextOnImageButton("assets/graphics/misc/button_thin.png", onClickRetry, nil, "Retry", Graphics.GONE)
  retry:setPosition(Point(baseRes.width * 0.375 - retry.dimensions.width * 0.5, highScore:endY() + 45))

  local menu = TextOnImageButton("assets/graphics/misc/button_thin.png", onClickMenu, nil, "Menu", Graphics.GONE)
  menu:setPosition(Point(baseRes.width * 0.625 - retry.dimensions.width * 0.5, highScore:endY() + 45))
  
  local placeables = {gameOver, yourScore, retry, menu}
  
  local function highScoreAppear(self, args)
    salary:add(score)
    self:resetColor()
    Sound:createAndPlay("assets/audio/sfx/sfx_damage2.wav", "damage_2", false)
    screen:setShake(35)
    screen:setRotation(.1)
    screen:zoom(1.20)    
    yourScore.color = Graphics.NORMAL
    retry:setColor(Graphics.NORMAL)
    menu:setColor(Graphics.NORMAL)
    Sound:createAndPlay("assets/audio/music/bgm_papercutter.ogg", "bgm", true, "stream")
    Sound:setPitch("bgm", GameOver.PITCH)  
  end
  
  highScore:replaceTimer("appear", 1, highScoreAppear)
  
  self.placeables = placeables
  self.buttons = {retry, menu}
  
  for _, v in ipairs(self.placeables) do
    v:convertWorldBoundsToScreen()
  end
end

function GameOver:update(dt)
  screen:update(dt)
  for _, v in ipairs(self.placeables) do
    v:update(dt)
  end
  highScore:update(dt)
  salary:update(dt)
end                            

function GameOver:draw()  
  screen:apply()
  highScore:draw()
  for _, v in ipairs(self.placeables) do
    v:draw()
  end
  salary:draw()
end

function GameOver:mousePressed(x, y, button, isTouch)
end

function GameOver:mouseRelease(x, y, button, isTouch)
  for _, v in ipairs(self.buttons) do
    v:mouseRelease(x, y, button, isTouch)
  end  
end    

function GameOver:__tostring()
  return "GameOver"
end