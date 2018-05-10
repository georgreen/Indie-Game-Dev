Level = class{}

function Level:init(rows, cols)
    self.rows = rows
    self.cols = cols
    self.map = createMap(self.rows, self.cols)
end


function createMap(rows, cols)
    print('Rows: '..rows ..' Cols: '..cols)
    local bricks = {}
    local BRICK_WIDTH = 32
    local PADDING = 8
    local BRICKHEIGHT = 16
    local LEFTPADDING = (13 - cols) * BRICKHEIGHT

    for row = 1, rows, 1 do
        for col = 1, cols, 1 do
            brick = Brick((col - 1) * BRICK_WIDTH + PADDING + LEFTPADDING, row * 16)
            table.insert(bricks, brick)
        end
    end
    return bricks
end
