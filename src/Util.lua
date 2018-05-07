function generateQuads(texture, titleWidth, titleHeight)
  local sheetCounter = 1
  local spriteQuads = {}

  local numQuadsHeight = texture:getHeight() / titleHeight
  local numQuadsWidth = texture:getWidth() / titleWidth

  for y = 0, numQuadsHeight - 1, 1 do
    for x = 0, numQuadsWidth - 1, 1 do
      spriteQuads[sheetCounter] = love.graphics.newQuad(
        x * titleWidth,
        y * titleHeight,
        titleWidth,
        titleHeight,
        texture:getDimensions()
      )
      sheetCounter = sheetCounter + 1
    end
  end
  return spriteQuads
end


function generateQuadPaddles(texture)
  local x = 0
  local y = 64
  local counter = 0
  local quads = {}

  for i = 0, 3, 1 do
    quads[counter] = love.graphics.newQuad(x, y, 32, 16, texture:getDimensions())
    counter = counter + 1
    quads[counter] = love.graphics.newQuad(x + 32, y, 64, 16, texture:getDimensions())
    counter = counter + 1
    quads[counter] = love.graphics.newQuad(x + 96, y, 96, 16, texture:getDimensions())
    counter = counter + 1
    quads[counter] = love.graphics.newQuad(x, y + 16, 128, 16, texture:getDimensions())
    counter = counter + 1

    x = 0
    y = y + 32
  end
  return quads
end


function table.slice(tbl, first, last, step)
  local sliced = {}

  for i = first or 1, last or #tbl, step or 1 do
    sliced[#sliced + 1] = tbl[i]
  end
  return sliced
end
