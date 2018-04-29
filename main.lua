-- Require for resolution
local push = require('push')

Class = require "class"

require "Ball"
require "Paddle"

-- set the width and height of the screen
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

 -- set a virtual screen resolution
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- Paddle speed
paddleSpeed = 200

-- intializing the game
function love.load()
  math.randomseed(os.time())
  love.graphics.setDefaultFilter('nearest', 'nearest')
  smallFont = love.graphics.newFont('font.ttf', 8)
  scoreFont = love.graphics.newFont('font.ttf', 32)

  options = {fullscreen=false, resizable=true, vsync=true}
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT,
                   WINDOW_WIDTH, WINDOW_HEIGHT,
                   options)

  love.window.setTitle("Pong")

  -- capture players scores
  player1Score = 0
  player2Score = 0

  -- initialize the position of each players paddleSpeed
  player1 = Paddle(5, 10, 5, 20) -- paddle on the left
  player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20) -- player on the right

  -- initialize ball
   ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

  gamestate = 'start'
end


-- called every frame update
function love.update(dt)

  if ball.x <= 0 then
    player2Score = player2Score + 1
    gamestate = 'serve'
    servingPlayer = 1
    ball:reset()
  end

  if ball.x >= VIRTUAL_WIDTH then
    player1Score = player1Score + 1
    gamestate = 'serve'
    servingPlayer = 2
    ball:reset()
  end

  if love.keyboard.isDown('w') then
    player1.dy = - paddleSpeed
  elseif love.keyboard.isDown('s') then
     player1.dy = paddleSpeed
  else
    player1.dy = 0
  end

  if love.keyboard.isDown('up') then
    player2.dy = - paddleSpeed
  elseif love.keyboard.isDown('down') then
    player2.dy = paddleSpeed
  else
    player2.dy = 0
  end

  if gamestate == 'play' then
    if ball:collides(player1) then
      ball.dx = - ball.dx * 1.03
      ball.x = player1.x + 5 -- makes sure it doesn't get stuck on paddle

      -- change the angle of deflection
      if ball.dy < 0 then
        ball.dy = - math.random(10, 150)
      else
        ball.dy = math.random(10, 150)
      end
    end

    if ball:collides(player2) then
      ball.dx = - ball.dx * 1.03
      ball.x = player2.x - 4

      -- change the angle of deflection
      if ball.dy < 0 then
        ball.dy = - math.random(10, 150)
      else
        ball.dy = math.random(10, 150)
      end
    end

    if ball.y <= 0 then
      ball.y = 0
      ball.dy = - ball.dy
    end

    if ball.y >= VIRTUAL_HEIGHT - 4 then
      ball.y = VIRTUAL_HEIGHT - 4
      ball.dy = - ball.dy
    end

    ball:update(dt)
  end

  player1:update(dt)
  player2:update(dt)
end


-- called every time we press a key
function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end

  if key == 'enter' or key =='return'then
    if gamestate == 'start' then
      gamestate = 'play'
    else
      gamestate = 'start'
      ball:reset()
    end

  end
end


-- called for drawing and render
function love.draw()
  push:apply('start')

  love.graphics.clear(40, 45, 52, 255) -- change background color

  love.graphics.setFont(smallFont)
  love.graphics.printf("Hello Pong!", 0, 20, VIRTUAL_WIDTH, 'center') -- print on screen

  love.graphics.setFont(scoreFont)
  scoreHeight = VIRTUAL_HEIGHT / 3
  love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, scoreHeight)
  love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, scoreHeight)

  player1:render() -- paddle on the right
  player2:render() -- paddle on the left

  ball:render() -- ball

  displayFrames()

  push:apply('end')
end

-- display frames a second
function displayFrames()
  love.graphics.setFont(smallFont)
  love.graphics.setColor(0, 255, 0, 255)
  love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 15, 0)
end
