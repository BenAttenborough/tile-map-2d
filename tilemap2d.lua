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
    local data = self:serializeTable(self.map)
    local success, message =love.filesystem.write( "tilefile", data)
    if success then 
        print ('file created')
    else 
        print ('file not created: '..message)
    end
end

function TileMap2d:load()
    local ok, chunk, result
    ok, chunk = pcall( love.filesystem.load, "tilefile" ) -- load the chunk safely
    if not ok then -- will be false if there is an error
        print('The following error happened: ' .. tostring(result))
    else
        print('The result of loading is: ' .. tostring(result))
    end
end

function TileMap2d:serializeTable(val, name, skipnewlines, depth)
    skipnewlines = skipnewlines or false
    depth = depth or 0

    local tmp = string.rep(" ", depth)

    if name then tmp = tmp .. name .. " = " end

    if type(val) == "table" then
        tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")

        for k, v in pairs(val) do
            tmp =  tmp .. serializeTable(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
        end

        tmp = tmp .. string.rep(" ", depth) .. "}"
    elseif type(val) == "number" then
        tmp = tmp .. tostring(val)
    elseif type(val) == "string" then
        tmp = tmp .. string.format("%q", val)
    elseif type(val) == "boolean" then
        tmp = tmp .. (val and "true" or "false")
    else
        tmp = tmp .. "\"[inserializeable datatype:" .. type(val) .. "]\""
    end

    return tmp
end