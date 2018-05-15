ServeState = class{__includes = BaseState}


function ServeState:enter(params)
  self.paddle = params.paddle
  self.level = params.level
  self.health = params.health
  self.score = params.score
  self.ball = Ball(math.random(7), (VIRTUAL_WIDTH / 2) - 4, VIRTUAL_HEIGHT - 40)
end


function ServeState:update(dt)
  self.paddle:update(dt)
  self.ball.x = self.paddle.x + (self.paddle.width + 25) / 2 
  self.ball.y = self.paddle.y - self.ball.height

  if love.keyboard.wasPressed('escape') then
    love.event.quit()
  end

  if love.keyboard.wasPressed('return') then
    props = {paddle = self.paddle,
             ball = self.ball,
             level = self.level,
             score = self.score,
             health = self.health}
    gStateMachine:change('play', props)
  end
end


function ServeState:render()
  for k, brick in pairs(self.level.map) do
    brick:render()
  end

  self.paddle:render()
  self.ball:render()
  renderScore(self.score)
  renderHealth(self.health)
  love.graphics.setFont(gFonts['medium'])
  love.graphics.printf('Press Enter to serve!', 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
end
