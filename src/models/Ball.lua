Ball = class{}


function Ball:init(skin, x, y)
  self.width = 8
  self.height = 8
  self.x = x
  self.y = y
  self.dx = 0
  self.dy = 0
  self.skin = skin
end


function Ball:collides(target)
  if self.x > target.x + target.width or target.x > self.x + self.width then
    return false
  elseif self.y > target.y + target.height or target.y > self.y + self.height then
    return false
  end

  return true
end


function Ball:update(dt)
  self.x = self.x + self.dx * dt
  self.y = self.y + self.dy * dt

  if self.x <= 0 then
    self.x = 0
    self.dx = - self.dx
    gSounds['wall-hit']:play()
  elseif self.x >= VIRTUAL_WIDTH - 8 then
    self.x = VIRTUAL_WIDTH - 8
    self.dx = -self.dx
    gSounds['wall-hit']:play()
  end

  if self.y <= 0 then
    self.y = 0
    self.dy = - self.dy
    gSounds['wall-hit']:play()
  end
end


function Ball:render()
  love.graphics.draw(gTextures['main'], gQuads['balls'][self.skin], self.x, self.y)
end


function Ball:reset()
  self.dx = 0
  self.dy = 0
  self.x = VIRTUAL_WIDTH / 2 - self.width
  self.y = VIRTUAL_HEIGHT / 2 - self.height
end
