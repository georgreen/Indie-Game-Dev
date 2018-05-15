PlayState = class{__includes = BaseState}


function PlayState:init()
  self.bricksHit = 0
end


function PlayState:enter(params)
  self.ball = params.ball
  self.paddle = params.paddle
  self.score = params.score
  self.health = params.health
  self.level = params.level
  self.ball.dx = math.random(-200, 200)
  self.ball.dy = math.random(-60, -60)
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
  self.paddle.width = self.paddle.width + 25

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
  self.paddle.width = self.paddle.width - 25

  -- collision with bricks logic
  for k, brick in pairs(self.level.map) do
    if brick.renderBrick and self.ball:collides(brick) then
      brick:hit()
      self.score = self.score + brick.tier * 20 + brick.color * 10 -- update score

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

      -- only detect one collision per frame
      break
    end
  end

  if self.ball.y >= VIRTUAL_HEIGHT then
    self.health = self.health - 1
    gSounds['hurt']:play()

    if self.health == 0 then
      props = {score = self.score}
      gStateMachine:change('gameOver', props)
    else
      props = {
        paddle = self.paddle,
        level = self.level,
        health = self.health,
        score = self.score
      }
      gStateMachine:change('serve', props)
    end
  end

  self.ball:update(dt)
  self.paddle:update(dt)

  for k, brick in pairs(self.level.map) do
    brick:update(dt)
  end

  if self.level:checkVictory() then
    gSounds['victory']:play()
    props = {
      paddle = self.paddle,
      level = self.level,
      health = self.health,
      score = self.score,
      ball = self.ball
    }
    gStateMachine:change('victory', props)
  end

  if love.keyboard.wasPressed('escape') then
      love.event.quit()
  end
end


function PlayState:render()
  for k, brick in pairs(self.level.map) do
    brick:render()
  end

  for k, brick in pairs(self.level.map) do
    brick.dust:render(brick.x, brick.y)
  end

  self.paddle:render()
  self.ball:render()
  renderScore(self.score)
  renderHealth(self.health)

  if self.paused then
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('PAUSED', 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
  end
end
