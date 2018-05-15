local highlighted = 1

StartState = class{__includes = BaseState}

function StartState:update(dt)
  if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
    highlighted = highlighted == 1 and 2 or 1 -- tenary oparator
    gSounds['paddle-hit']:play()
  end

  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    gSounds['select']:play()

    if highlighted == 1 then
      props = {}
      gStateMachine:change('select-paddle', props)
    end
  end

  if love.keyboard.wasPressed('escape') then
    love.event.quit()
  end
end


function StartState:render()
  love.graphics.setFont(gFonts['large'])
  love.graphics.printf("BREAKOUT", 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')

  love.graphics.setFont(gFonts['medium'])
  if highlighted == 1 then
    love.graphics.setColor(0, 1, 0, 100)
  end
  love.graphics.printf("START", 0, VIRTUAL_HEIGHT / 2 + 70, VIRTUAL_WIDTH, 'center')
  love.graphics.setColor(255, 255, 255, 255)

  if highlighted == 2 then
    love.graphics.setColor(0, 1, 0, 100)
  end
  love.graphics.printf("HIGH SCORES", 0, VIRTUAL_HEIGHT / 2 + 90, VIRTUAL_WIDTH, 'center')
  love.graphics.setColor(255, 255, 255, 255)
end
