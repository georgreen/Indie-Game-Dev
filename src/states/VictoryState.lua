VictoryState = class{__includes = BaseState}

function VictoryState:enter(params)
  self.level = params.level
  self.score = params.score
  self.paddle = params.paddle
  self.health = params.health
  self.ball = params.ball
end


function VictoryState:update(dt)
  self.paddle:update(dt)
  self.ball.x = self.paddle.x + (self.paddle.width / 2)
  self.ball.y = self.paddle.y - 8

  if love.keyboard.wasPressed('return') then
    props = {
      paddle = self.paddle,
      level = Level(math.random(1, 5), math.random(7, 13), self.level.currentLevel + 1),
      health = self.health,
      score = self.score
    }
    gStateMachine:change('serve', props)
  end

  if love.keyboard.wasPressed('escape') then
      love.event.quit()
  end
end


function VictoryState:render()
  self.paddle:render()
  self.ball:render()

  renderHealth(self.health)
  renderScore(self.score)

  love.graphics.setFont(gFonts['large'])
  love.graphics.printf("Level " ..tostring(self.level.currentLevel) .." Complete",
                         0, VIRTUAL_HEIGHT / 4 , VIRTUAL_WIDTH, 'center')

  love.graphics.setFont(gFonts['medium'])
  love.graphics.printf("Press Enter to start again! ", 0, VIRTUAL_HEIGHT / 2,
                        VIRTUAL_WIDTH, 'center')
end
