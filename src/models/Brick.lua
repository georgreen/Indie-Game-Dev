Brick = class{}

function Brick:init(x, y)
  self.x = x
  self.y = y
  self.color = 1
  self.tier = 0
  self.width = 32
  self.height = 16
  self.renderBrick = true
  self.dust = DustParticles(gTextures['particle'], 64)
end


function Brick:update(dt)
  self.dust:update(dt)
end


function Brick:hit()
  self.dust:colorize(self)
  self.dust:emit(64)

  gSounds['brick-hit-2']:play()

  if self.tier > 0 then
    if self.color == 1 then
      self.tier = self.tier - 1
      self.color = 5
    else
      self.color = self.color - 1
    end
  else
    if self.color == 1 then
      self.renderBrick = false
    else
      self.color = self.color - 1
    end
  end

  if not self.renderBrick then
    gSounds['brick-hit-1']:play()
  end
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


-- helpers
paletteColors = {
  [1] = {
    ['r'] = 99,
    ['g'] = 155, -- blue
    ['b'] = 255
  },
  [2] = {
    ['r'] = 106,
    ['g'] = 190, -- reen
    ['b'] = 47
  },
  [3] = {
    ['r'] = 217,
    ['g'] = 87,  -- red
    ['b'] = 99
  },
  [4] = {
    ['r'] = 215,
    ['g'] = 123,  -- purple
    ['b'] = 186
  },
  [5] = {
    ['r'] = 251,
    ['g'] = 242,  -- gold
    ['b'] = 54
  },
}

DustParticles = class{}

function DustParticles:init(particle, numOfparticle)
  self.particles = love.graphics.newParticleSystem(particle, numOfparticle)
  self.particles:setParticleLifetime(0.5, 1)
  self.particles:setLinearAcceleration(-15, 0, 15, 80)
  self.particles:setEmissionArea('normal', 10, 10)
end

function DustParticles:colorize(brick)
  self.particles:setColors(
  paletteColors[brick.color].r,
  paletteColors[brick.color].g,
  paletteColors[brick.color].b,
  55 * (brick.tier + 1),
  paletteColors[brick.color].r,
  paletteColors[brick.color].g,
  paletteColors[brick.color].b,
  0)
end

function DustParticles:update(dt)
  self.particles:update(dt)
end

function DustParticles:emit(numOfparticle)
  self.particles:emit(numOfparticle)
end

function DustParticles:render(x, y)
  love.graphics.draw(self.particles, x + 16, y + 8)
end
