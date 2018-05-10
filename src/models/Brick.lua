Brick = class{}

function Brick:init(x, y)
  self.x = x
  self.y = y
  self.color = 1
  self.tier = 0
  self.width = 32
  self.height = 16
  self.renderBrick = true
end


function Brick:update(dt)
end


function Brick:hit()
  self.renderBrick = false
  gSounds['brick-hit-2']:play()
end


function Brick:render()
  if self.renderBrick then
    love.graphics.draw(
      gTextures['main'],
      gQuads['bricks'][1 + ((self.color - 1) * 4) + self.tier],
      self.x,
      self.y)
  end
end
