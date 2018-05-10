PlayState = class{__includes = BaseState}

function PlayState:init()
  self.paddle = Paddle(2, VIRTUAL_WIDTH / 2 - 32, VIRTUAL_HEIGHT - 32)
  self.ball = Ball(math.random(7), (VIRTUAL_WIDTH / 2) - 4, VIRTUAL_HEIGHT - 40)
  self.ball.dx = math.random(-200, 200)
  self.ball.dy = math.random(-60, -60)
  self.level = Level(math.random(1, 5), math.random(7, 13))
  self.paused = false
end


function PlayState:update(dt)
  if love.keyboard.wasPressed('space') then
    self.paused = not self.paused
    gSounds['pause']:play()
    return
  elseif self.paused then
    return
  end

  -- bug #quick fix
  self.paddle.width = self.paddle.width + 20
  if self.ball:collides(self.paddle) then
    self.ball.y = self.paddle.y - self.ball.height
    self.ball.dy = - self.ball.dy

    -- change the deflection of the ball
    local DEFLECTIONLEN = self.paddle.x + self.paddle.width / 2 - self.ball.x
    if self.ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
      self.ball.dx = -50 + - (8 * DEFLECTIONLEN)
    elseif self.ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
      self.ball.dx = 50 + 8 * math.abs(DEFLECTIONLEN)
    end
    gSounds['paddle-hit']:play()
  end
  -- bug #quick fix
  self.paddle.width = self.paddle.width - 20

  for k, brick in pairs(self.level.map) do
    if brick.renderBrick and self.ball:collides(brick) then
      brick:hit()
      if self.ball.x + 2 < brick.x and self.ball.dx > 0 then
        self.ball.dx = - self.ball.dx
        self.ball.x = brick. x - 8
      elseif self.ball.x + 6 > brick.x + brick.width and self.ball.dx < 0 then
        self.ball.dx = - self.ball.dx
        self.ball.x = brick. x + 32
      elseif self.ball.y < brick.y then
        self.ball.dy = - self.ball.dy
        self.ball.y = brick.y - 8
      else
        self.ball.dy = - self.ball.dy
        self.ball.y = brick.y + 16
      end
    end

  end

  self.ball:update(dt)
  self.paddle:update(dt)

  if love.keyboard.wasPressed('escape') then
      love.event.quit()
  end
end


function PlayState:render()
  for k, brick in pairs(self.level.map) do
    brick:render()
  end

  self.paddle:render()
  self.ball:render()
  if self.paused then
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('PAUSED', 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
  end
end
