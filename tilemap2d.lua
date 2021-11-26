TileMap2d = Class{}

local Tile = require 'libs.tilemap2d.Tile'

function TileMap2d:init(config)
    self.map = self:convertMap(config)
    self.tileSheet = love.graphics.newImage(config['spriteSheet'])
    self.tw = config['spriteSize']['width']
    self.th = config['spriteSize']['height']
    self.offsetx = config['offsetX']
    self.offsety = config['offsetY']
    self.mw = self.tw * #self.map[1]
    self.mh = self.th * #self.map
end

function TileMap2d:draw(offsetX, offsetY)
    
    -- Some clever shit needed to work out which tiles to draw
    local tileToStart = 1
    if offsetX < 0 then
        tileToStart = math.floor(math.abs(offsetX / self.tw)) + 1
    end
    local numberOfTiles = #self.map[1]
    local numberOfTilesPassed = math.floor(offsetX / self.tw)
    local tileToEnd = numberOfTiles - numberOfTilesPassed

    for y = 1,table.maxn(self.map)
    do
        for x = 1,table.maxn(self.map[1])
        do
            if x >= tileToStart and x<= tileToEnd then
                local tile = self.map[y][x]
                love.graphics.draw(self.tileSheet, tile.sprite, tile.x + offsetX, tile.y + offsetY)
            end
        end
    end
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("fill", (self.offsetx - self.tw), self.offsety, self.tw, self.mh )
    love.graphics.rectangle("fill", (self.offsetx + self.mw), self.offsety, self.tw, self.mh )
end

function TileMap2d:save()
    local data = self:serializeMap(self.map)
    local success, message =love.filesystem.write( "tilefile", data)
    if success then
        print ('file created')
    else
        print ('file not created: '..message)
    end
end

function TileMap2d:serializeMap(mapData)    
    local data = table.maxn(mapData[1]) .. ','
    for x = 1,table.maxn(mapData) do
        for y = 1,table.maxn(mapData[x]) do
            data = data .. mapData[x][y]['spriteNumber'] .. ','
        end
    end
    return data
end

function TileMap2d:debug()
    local x,y = push:toGame(love.mouse.getX(),love.mouse.getY())
    love.graphics.print("Mouse: " .. x .. " " .. y, 10, 10)
    -- love.graphics.print("TW:" .. self.tw .. " TH:" .. self.th .. " MW:" .. self.mw .. " MH:" .. self.mh, 180, 10)
end

function TileMap2d:isWithinBounds(x,y)
    if x < self.offsetx then return false end
    if x > self.offsetx + self.mw then return false end
    if y < self.offsety then return false end
    if y > self.offsety + self.mh then return false end
    return true
end

function TileMap2d:detectClick(x,y,button)
    if self:isWithinBounds(x,y) then
        for col = 1, #self.map[1]
        do
            for row = 1, #self.map
            do
                if button == 1 and self.map[row][col]:isClickWithinTile(x,y) then
                    local res = {}
                    res["success"] = true
                    res["mapX"] = col
                    res["mapY"] = row
                    return res
                end
            end
        end
    else
        local res = {}
        res["success"] = false
        return res
    end
end

function TileMap2d:convertMap(config)
    local map = config['map']
    local tw = config['spriteSize']['width']
    local th = config['spriteSize']['height']
    local tileSheet = love.graphics.newImage(config['spriteSheet'])
    local tiles = {}
    for i=1, config['spriteCount']
    do
        tiles[i] = love.graphics.newQuad( (i - 1) * tw , 0, tw, th, tileSheet )
    end

    for col = 1, #map[1] do
        for row = 1, #map do
            local spriteValue = map[row][col]
            local tileConfig = {
                ['x'] = config['offsetX'] + ((col - 1) * tw ),
                ['y'] = config['offsetY'] + ((row - 1) * th ),
                ['width'] = config['spriteSize']['width'],
                ['height'] = config['spriteSize']['height'],
                ['sprite'] = tiles[spriteValue],
                ['spriteNumber'] = spriteValue
            }
            map[row][col] = Tile(tileConfig)
        end
    end
    return map
end

function TileMap2d:updateMap(row, col, spriteNumber)
    self.map[row][col]:setTileSprite(spriteNumber, self.tileSheet)
end

return TileMap2d