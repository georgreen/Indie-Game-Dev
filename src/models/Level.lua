Level = class{}

function Level:init(rows, cols, level)
    self.rows = rows
    self.cols = cols
    self.currentLevel = level
    self.map = createMap(self.rows, self.cols, level)
end


function Level:checkVictory()
    for k, brick in pairs(self.map) do
      if brick.renderBrick then
        return false
      end
    end
    return true
end


-- local helpers
local SOLID = 1
local ALTERNATE = 2
local KIP = 3
local NONE = 4


-- Generate bricks for a Level
-- @param rows:integer number of rows
-- @param cols:integer number of coloumns
function createMap(rows, cols, level)
    print('Rows: '..rows ..' Cols: '..cols)
    cols = cols % 2 == 0 and (cols + 1) or cols
    local bricks = {}
    local BRICK_WIDTH = 32
    local PADDING = 8
    local BRICKHEIGHT = 16
    local LEFTPADDING = (13 - cols) * BRICKHEIGHT

    local highestTier = math.min(3, math.floor(level / 5))
    local highestColor = math.min(5, level % 5 + 3)

    for row = 1, rows, 1 do
        local skipPattern = math.random(1, 2) == 1 and true or false
        local alternatPattern = math.random(1, 2) == 1 and true or false

        local alternateTier1 = math.random(0, highestTier)
        local alternateTier2 = math.random(0, highestTier)
        local alternateColor1 = math.random(1, highestColor)
        local alternateColor2 = math.random(1, highestColor)

        local skipFlag = math.random(2) == 1 and true or false
        local alternateFlag = math.random(2) == 1 and true or false

        local solidColor = math.random(1, highestColor)
        local solidTier = math.random(1, highestTier)

        local continue = false
        for col = 1, cols, 1 do
            if skipPattern and skipFlag then
                skipFlag = not skipFlag
                continue = true
            else
                skipFlag = not skipFlag
            end

            if not continue then
                local brick = Brick((col - 1) * BRICK_WIDTH + PADDING + LEFTPADDING, row * 16)

                if alternatPattern and alternateFlag then
                    brick.color = alternateColor1
                    brick.tier = alternateTier1
                else
                    brick.color = alternateColor1
                    brick.tier = alternateTier1
                end
                alternateFlag = not alternateFlag

                if not alternatPattern then
                    brick.color = solidColor
                    brick.tier = solidTier
                end

                table.insert(bricks, brick)
            else
                continue = false
            end
        end

    end

    return bricks
end
