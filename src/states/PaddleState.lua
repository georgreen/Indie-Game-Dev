PaddleState = class{__includes = BaseState}


function PaddleState:init()
  self.currentPaddle = 1
end


function PaddleState:enter(params)
end


function PaddleState:update(dt)
  if love.keyboard.wasPressed('left') then
    if self.currentPaddle == 1 then
      gSounds['no-select']:play()
    else
      gSounds['select']:play()
      self.currentPaddle = self.currentPaddle - 1
    end
  elseif love.keyboard.wasPressed('right') then
    if self.currentPaddle == 4 then
      gSounds['no-select']:play()
    else
      gSounds['select']:play()
      self.currentPaddle = self.currentPaddle + 1
    end
  end

  if love.keyboard.wasPressed('return') then
    gSounds['confirm']:play()
    props = {
         paddle = Paddle(self.currentPaddle, VIRTUAL_WIDTH / 2 - 32, VIRTUAL_HEIGHT - 32),
         level = Level(math.random(1, 1), math.random(1, 1), 1),
         health = 3,
         score = 0
       }
    gStateMachine:change('serve', props)
  end

  if love.keyboard.wasPressed('escape') then
    love.event.quit()
  end
end


function PaddleState:render()
  love.graphics.setFont(gFonts['medium'])
    love.graphics.printf("Select your paddle with left and right!",
                         0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['small'])
    love.graphics.printf("(Press Enter to continue!)",
                         0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')

    if self.currentPaddle == 1 then
      love.graphics.setColor(40, 40, 40, 128)
    end

    love.graphics.draw(gTextures['arrows'], gQuads['arrows'][1],
        VIRTUAL_WIDTH / 4 - 24, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)

    love.graphics.setColor(255, 255, 255, 255)

    if self.currentPaddle == 4 then
      love.graphics.setColor(40, 40, 40, 128)
    end

    love.graphics.draw(gTextures['arrows'], gQuads['arrows'][2],
     VIRTUAL_WIDTH - VIRTUAL_WIDTH / 4, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)

    love.graphics.setColor(255, 255, 255, 255)

    love.graphics.draw(gTextures['main'],
                       gQuads['paddles'][2 + 4 * (self.currentPaddle - 1)],
                       VIRTUAL_WIDTH / 2 - 32, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)
end
