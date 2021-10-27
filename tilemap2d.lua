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
    -- local ok, chunk, result
    -- ok, chunk = pcall( love.filesystem.load, "tilefile" ) -- load the chunk safely
    -- if not ok then
    --     print('The following error happened: ' .. tostring(chunk))
    -- else
    --     ok, result = pcall(chunk) -- execute the chunk safely
    --     if not ok then -- will be false if there is an error
    --         print('The following error happened: ' .. tostring(result))
    --     else
    --         print('The result of loading is: ' .. tostring(result))
    --     end
    -- end
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
    -- Should be enough info to decode the string into a table
    local mapData = {}
    for number in string.gmatch(mapOnlyString, '([^,]+)') do
        table.insert(mapData, number)
    end
    local mapHeight = #mapData / mapWidth
    print('map width: ' .. mapWidth)
    print('map height: ' .. mapHeight)
    local finalMap = {}
    for row = 1, mapHeight do
        for col = 1, mapWidth do
            finalMap[row] = mapData[col]
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