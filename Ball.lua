Ball = Class{}

function Ball:init(x, y, width, height)
  self.x = x
  self.y = y

  self.width = width
  self.height = height

  self.dx, self.dy = ball_direction()
end


function Ball:collides(paddle)
  -- Check if the right or left edge are colliding
  if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
    return false
  end

  -- Check if the bottom or the top edge are colliding
  if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
    return false
  end

  return true
end


function Ball:update(dt)
  self.x = self.x + (dt * self.dx)
  self.y = self.y + (dt * self.dy)
end


function Ball:reset()
  self.x = VIRTUAL_WIDTH / 2 - 2
  self.y = VIRTUAL_HEIGHT / 2 - 2

  self.dx, self.dy = ball_direction()
end


function Ball:render()
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end


function ball_direction()
  return math.random(2) == 1 and 100 or -100, math.random(-50, 50)
end
