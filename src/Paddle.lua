PADDLE_SPEED = 200

Paddle = class{}

function Paddle:init()
  self.x = VIRTUAL_WIDTH / 2 - 32
  self.y = VIRTUAL_HEIGHT - 32
  self.width = 64
  self.height = 16
  self.dx = 0

  self.skin = 1
  self.size = 2
end


function Paddle:update(dt)
  if love.keyboard.isDown('left') then
    self.dx = - PADDLE_SPEED
  elseif love.keyboard.isDown('right') then
    self.dx = PADDLE_SPEED
  else
    self.dx = 0
  end

  if self.x < 0 then
    self.x = math.max(-1, self.x + self.dx * dt)
  else
    self.x = math.min(VIRTUAL_WIDTH - (self.width + 32), self.x + self.dx * dt)
  end
end


function Paddle:render()
  love.graphics.draw(
  gTextures['main'],
  gQuads['paddles'][self.size + 4 * (self.skin - 1)],
  self.x,
  self.y)
end
