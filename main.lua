require('src/Dependency')


function love.load()
  math.randomseed(os.time())

  -- setup screen
  love.graphics.setDefaultFilter('nearest', 'nearest')
  love.window.setTitle('Breakout')
  options = {vsync = true, fullscreen = false, resizable = true}
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, options)

  -- setup assets
  gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
  }

  gTextures = {
    ['background'] = love.graphics.newImage('graphics/background.png'),
    ['main'] = love.graphics.newImage('graphics/breakout.png'),
    ['arrows'] = love.graphics.newImage('graphics/arrows.png'),
    ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
    ['particle'] = love.graphics.newImage('graphics/particle.png'),
  }

  gSounds = {
    ['paddle-hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
    ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
    ['wall-hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
    ['confirm'] = love.audio.newSource('sounds/confirm.wav', 'static'),
    ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
    ['no-select'] = love.audio.newSource('sounds/no-select.wav', 'static'),
    ['brick-hit-1'] = love.audio.newSource('sounds/brick-hit-1.wav', 'static'),
    ['brick-hit-2'] = love.audio.newSource('sounds/brick-hit-2.wav', 'static'),
    ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
    ['victory'] = love.audio.newSource('sounds/victory.wav', 'static'),
    ['recover'] = love.audio.newSource('sounds/recover.wav', 'static'),
    ['high-score'] = love.audio.newSource('sounds/high_score.wav', 'static'),
    ['pause'] = love.audio.newSource('sounds/pause.wav', 'static'),
    ['music'] = love.audio.newSource('sounds/music.wav', 'static'),
  }

  gQuads = {
    ['paddles'] = generateQuadPaddles(gTextures['main']),
    ['balls'] = generateQuadsBall(gTextures['main']),
    ['bricks'] = generateQuadsBricks(gTextures['main']),
    ['hearts'] = generateQuads(gTextures['hearts'], 10, 9),
    ['arrows'] = generateQuads(gTextures['arrows'], 24, 24)
  }

  -- setup states
  states = {
    ['start'] = function() return StartState() end,
    ['select-paddle'] = function() return PaddleState() end,
    ['serve'] = function() return ServeState() end,
    ['play'] = function() return PlayState() end,
    ['victory'] = function() return VictoryState() end,
    ['gameOver'] = function() return GameOverState() end,
  }
  gStateMachine = StateMachine(states)

  -- setup Initial state
  backgroundWidth = gTextures['background']:getWidth()
  backgroundHeight = gTextures['background']:getHeight()
  love.keyboard.keyPressed = {}
  love.graphics.setFont(gFonts['small'])
  gStateMachine:change('start')
end


function love.resize(w, h)
  push:resize(w, h)
end


function love.keypressed(key)
  love.keyboard.keyPressed[key] = true
end


function love.update(dt)
  gStateMachine:update(dt)
  love.keyboard.keyPressed = {}
end


function love.draw()
  push:apply('start')
  love.graphics.draw(gTextures['background'],
                      0, 0,
                      0,
                      VIRTUAL_WIDTH / (backgroundWidth - 1),
                      VIRTUAL_HEIGHT / (backgroundHeight - 1))

  gStateMachine:render()
  renderFps()
  push:apply('end')
end


-- Helpers
function love.keyboard.wasPressed(key)
  if love.keyboard.keyPressed[key] then
    return true
  end
  return false
end


function renderFps()
  love.graphics.setFont(gFonts['small'])
  love.graphics.setColor(0, 255, 0, 255)
  love.graphics.print('FPS : ' ..tostring(love.timer.getFPS()), 5, 5)
  love.graphics.setColor(255, 255, 255, 255)
end


function renderScore(score)
  love.graphics.setFont(gFonts['small'])
  love.graphics.print('Score:', VIRTUAL_WIDTH - 60, 5)
  love.graphics.printf(tostring(score), VIRTUAL_WIDTH - 50, 5, 40, 'right')
end


function renderHealth(health)
  local healthX = VIRTUAL_WIDTH - 100

  for i = 1, health do
    love.graphics.draw(gTextures['hearts'], gQuads['hearts'][1], healthX, 4)
    healthX = healthX + 11
  end

  for i = 1, 3 - health do
    love.graphics.draw(gTextures['hearts'], gQuads['hearts'][2], healthX, 4)
    healthX = healthX + 11
  end
end
