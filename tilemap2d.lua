TileMap2d = Class{}

function TileMap2d:init(config)
    self.map = config['map']
    self.tileSheet = love.graphics.newImage(config['spriteSheet'])
    self.tw = config['spriteSize']['width']
    self.th = config['spriteSize']['height']
    self.tiles = {}
    for i=1,config['spriteCount']
    do
        self.tiles[i] = love.graphics.newQuad( (i - 1) * self.tw , 0, self.tw, self.th, self.tileSheet )
    end
end

function TileMap2d:draw(offsetx, offsety, width, height) 
    originalOffsetX = offsetx
    tile = self.tiles[1]
    for x = 1,table.maxn(self.map)
    do
        for y = 1,table.maxn(self.map[1])
        do
            tile = self.tiles[self.map[x][y]]
            love.graphics.draw(self.tileSheet, tile, offsetx, offsety)
            r, g, b, a = love.graphics.getColor( )
            -- if x == self.hoveredTile[1] and y == self.hoveredTile[2] then
            --     r, g, b, a = love.graphics.getColor( )
            --     love.graphics.setColor(1,1,1)
            --     love.graphics.rectangle("line", offsetx, offsety, self.tileWidth, self.tileHeight)
            -- end
            offsetx = offsetx + self.tw
        end
        offsetx = originalOffsetX
        offsety = offsety + self.th
    end
end