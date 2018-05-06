require('src/Dependency')


function love.load()
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

  -- setup states
  states = {}
  gStateMachine = StateMachine(states)

  -- setup Initial state
  love.keyboard.keysPressed = {}
  love.graphics.setFont(gFonts['small'])
end


function love.update(dt)
end


function love.draw()
  push:apply('start')
  displayFps()
  push:apply('end')
end


function love.resize()
end


function love.keypressed(key)
end


function displayFps()
  love.graphics.setFont(gFonts['small'])
  love.graphics.setColor(0, 255, 0, 255)
  love.graphics.print('FPS : ' ..tostring(love.timer.getFPS()), 5, 5)
end
