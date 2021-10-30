TileMap2d = Class{}

require 'libs.tilemap2d.Tile'

function TileMap2d:init(config)
    self.map = self:convertMap(config)
    -- self.map = config['map']
    -- self.tileSheet = love.graphics.newImage(config['spriteSheet'])
    -- self.tw = config['spriteSize']['width']
    -- self.th = config['spriteSize']['height']
    -- self.mw = self.tw * #self.map[1]
    -- self.mh = self.th * #self.map
    -- self.tiles = {}
    -- self.offsetx = 20
    -- self.offsety = 50
    -- self.spriteCount = config['spriteCount']
    -- self.uix = 50
    -- self.uiy = 50
    -- self.editMode = true
    -- for i=1, self.spriteCount
    -- do
    --     self.tiles[i] = love.graphics.newQuad( (i - 1) * self.tw , 0, self.tw, self.th, self.tileSheet )
    -- end
end

function TileMap2d:draw() 
    -- local offsetx = self.offsetx
    -- local offsety = self.offsety
    -- local originalOffsetX = offsetx
    -- local tile = self.tiles[1]
    -- for x = 1,table.maxn(self.map)
    -- do
    --     for y = 1,table.maxn(self.map[1])
    --     do
    --         tile = self.tiles[self.map[x][y]]
    --         love.graphics.draw(self.tileSheet, tile, offsetx, offsety)
    --         offsetx = offsetx + self.tw
    --     end
    --     offsetx = originalOffsetX
    --     offsety = offsety + self.th
    -- end
end

function TileMap2d:save()
    local data = self:serializeMap(self.map)
    print(data)
    local success, message =love.filesystem.write( "tilefile", data)
    if success then 
        print ('file created')
    else 
        print ('file not created: '..message)
    end
end

function TileMap2d:load()
    local mapString = love.filesystem.read( 'tilefile' ) 
    print('result: ' .. mapString)
    for word in string.gmatch(mapString, '([^,]+)') do
        print(word)
    end
    local firstComma = string.find(mapString, ',')
    local mapWidth = string.match(mapString, '([^,]+)')
    local mapOnlyString = string.sub(mapString, firstComma + 1)
    print('First comma: ' ..  firstComma)
    print('mapWidth : ' ..  mapWidth)
    print('mapOnlyString : ' ..  mapOnlyString)
    local mapData = {}
    for number in string.gmatch(mapOnlyString, '([^,]+)') do
        table.insert(mapData, number)
    end
    local mapHeight = #mapData / mapWidth
    print('map width: ' .. mapWidth)
    print('map height: ' .. mapHeight)
    local finalMap = {}
    for row = 1, mapHeight do
        mapData[row] = {}
        for col = 1, mapWidth do
            table.insert(finalMap[row], mapData[col]) 
        end
    end
end

function TileMap2d:serializeMap(mapData)
    local data = table.maxn(mapData[1]) .. ','
    for x = 1,table.maxn(mapData) do
        for y = 1,table.maxn(mapData[x]) do
            data = data .. mapData[x][y] .. ','
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

function TileMap2d:isWithinTile(tileX, tileY, userX, userY)
    if userX < tileX then return false end
    if userX > tileX + self.tw then return false end
    if userY < tileY then return false end
    if userY > tileY + self.tw then return false end
    return true
end

function TileMap2d:detectClick(x,y)
    if self:isWithinBounds(push:toGame(x,y)) then
        -- print("In bounds")
        for col = 1, self.mw
        do
            for row = 1, self.mh
            do
                local xStart = self.offsetx + ((col - 1) * self.tw)
                local yStart = self.offsety + ((row - 1) * self.th)
                if self:isWithinTile(xStart, yStart, push:toGame(x,y)) then
                    print("Within tile r: " .. row .. " column: " .. col)
                end
            end
        end
    else
        -- print("OO bounds")
    end
end

function TileMap2d:renderUI(x,y)
    -- self.uix = x
    -- self.uiy = y
    -- for i = 1, self.spriteCount do
    --     local tile = self.tiles[i]
    --     love.graphics.draw(self.tileSheet, tile, self.uix + (i * 20), self.uiy)
    -- end
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
            -- print("col: " .. col .. " row: " .. row)
            -- print(map[row][col])
            local spriteValue = map[row][col]
            local tileConfig = {
                ['x'] = col - 1,
                ['y'] = row - 1,
                ['width'] = config['spriteSize']['width'],
                ['height'] = config['spriteSize']['height'],
                ['sprite'] = tiles[spriteValue]
            }
            map[row][col] = Tile(tileConfig)
        end
    end
    -- print(map)
    -- print(map[1])
    -- print(map[1][1])
    -- print(map[1][1].x)
    -- print(map[1][1].y)
    -- print(map[1][1].width)
    -- print(map[1][1].height)
    return map
end