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
  }

  -- setup states
  states = {
    ['start'] = function() return StartState() end,
    ['play'] = function() return PlayState() end,
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
  displayFps()
  push:apply('end')
end


function love.keypressed(key)
  love.keyboard.keyPressed[key] = true
end


function love.keyboard.wasPressed(key)
  if love.keyboard.keyPressed[key] then
    return true
  end
  return false
end


function displayFps()
  love.graphics.setFont(gFonts['small'])
  love.graphics.setColor(0, 255, 0, 255)
  love.graphics.print('FPS : ' ..tostring(love.timer.getFPS()), 5, 5)
  love.graphics.setColor(255, 255, 255, 255)
end
