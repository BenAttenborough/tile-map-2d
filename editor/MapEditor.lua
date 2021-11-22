MapEditor = Class{}

local Button = require 'libs.tilemap2d.Button'
local TileMap2d = require 'libs.tilemap2d.TileMap2d'
local MapEditorUI = require 'libs.tilemap2d.editor.MapEditorUI'

-- TO DO move this to main
require 'libs.tilemap2d.input'

function MapEditor:init(config)
    self.TileMap2d = {}
    self.selectionUI = {}
    self.loadButton = Button({
        x = 20,
        y = 200,
        width = 100,
        height = 14,
        label = 'Load',
        clickHandler = 'load',
        boundObj = self})
    self.saveButton = Button({
        x = 20,
        y = 225,
        width = 100,
        height = 14,
        label = 'Save',
        clickHandler = 'save',
        boundObj = self})
    self.prevMouseDown = false
    self.mapLoaded = false
    self.loadWindowOpen = false
    self.selectedSpriteNumber = 1
    self.tileMapOffsetX = 0
    self.tileMapOffsetY = 0
    self.buttons = {}
end

function MapEditor:render()
    self.saveButton:draw()
    self.loadButton:draw()
    self:debug()
    if self.mapLoaded then
        self.TileMap2d:draw(self.tileMapOffsetX, self.tileMapOffsetY)
        self.selectionUI:render()
    end
    if self.loadWindowOpen then
        self:renderLoadWindow()
    end
end

function MapEditor:update(dt)
    if self.mapLoaded then
        self.selectionUI:update(dt)
        if love.keyboard.wasPressed("right") then
            self.tileMapOffsetX = self.tileMapOffsetX - 1
            love.keyboard.reset()
        end
        if love.keyboard.wasPressed("left") then
            self.tileMapOffsetX = self.tileMapOffsetX + 1
            love.keyboard.reset()
        end
    end
    if love.mouse.isDown(1) and not self.prevMouseDown then
        local x,y = Push:toGame(love.mouse.getX(), love.mouse.getY())
        self.loadButton:mouseClick(x, y, 1)
        self.saveButton:mouseClick(x, y, 1)
        if self.loadWindowOpen then
            for k, button in ipairs(self.buttons) do
                button:mouseClick(x, y, 1)
            end
        end
        if self.mapLoaded then
            local res = self.TileMap2d:detectClick(x, y, 1)
            if res.success then
                self.TileMap2d:updateMap(res.mapY, res.mapX, self.selectedSpriteNumber)
            end
        end
    end
    self.prevMouseDown = love.mouse.isDown(1)
end

function MapEditor:save()
    self.TileMap2d:save()
end

function MapEditor:renderLoadWindow()
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle('line', 10,10,200,100)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle('fill', 11,11,198,98)
    love.graphics.setColor(1,1,1)
    
    
    for k, button in ipairs(self.buttons) do
        button:draw()
    end
end

function MapEditor:testLoad(test)
    print(test)
end

function MapEditor:getFiles()
    local dir = "levels"
    local files = love.filesystem.getDirectoryItems(dir)
    local y = 15
    for k, file in ipairs(files) do
        table.insert(self.buttons, Button({
            x = 15,
            y = y,
            width = 100,
            height = 14,
            label = file,
            clickHandler = 'testLoad',
            boundObj = self,
            optionalParam = file}))
        y = y + 20
    end
end

function MapEditor:load()
    -- self:getFiles()
    -- self.loadWindowOpen = true


    local tileConfig = {}
    tileConfig['map'] = self:loadFromFile()
    tileConfig['spriteSheet'] = 'sprites/tilemap.png'
    tileConfig['spriteSize'] = {}
    tileConfig['spriteSize']['width'] = 10
    tileConfig['spriteSize']['height'] = 10
    tileConfig['spriteCount'] = 4
    tileConfig['offsetX'] = 20
    tileConfig['offsetY'] = 50
    self.TileMap2d = TileMap2d(tileConfig)
    local selectionUIConfig = {}
    selectionUIConfig['offsetX'] = 200
    selectionUIConfig['offsetY'] = 50
    selectionUIConfig['spriteSheet'] = tileConfig['spriteSheet']
    selectionUIConfig['tileWidth'] = tileConfig['spriteSize']['width']
    selectionUIConfig['tileHeight'] = tileConfig['spriteSize']['height']
    selectionUIConfig['tileCount'] = tileConfig['spriteCount']
    selectionUIConfig['mapEditorContext'] = self
    self.selectionUI = MapEditorUI(selectionUIConfig)
    self.mapLoaded = true
end

function MapEditor:mousereleased(x, y, button)
    self.saveButton:mousereleased(x, y, button)
    self.loadButton:mousereleased(x, y, button)
    for k, item in ipairs(self.buttons) do
        item:mousereleased(x, y, button)
        -- print("Button down")
    end
end

-- function MapEditor:click(x, y, button)
--     self.saveButton:mouseClick(x, y, button)
--     self.loadButton:mouseClick(x, y, button)
-- end

function MapEditor:getDefaultMap()
    local row1 = {1,1,1,2,2,3,1,3,2,3,1,1}
    local row2 = {1,2,3,2,2,3,1,4,1,3,1,1}
    local row3 = {1,1,4,2,2,3,1,1,1,1,1,1}
    local row4 = {1,1,1,1,2,3,1,3,4,1,1,1}
    local row5 = {1,3,1,2,4,1,1,3,2,3,1,1}
    local map = {}
    map[1] = row1
    map[2] = row2
    map[3] = row3
    map[4] = row4
    map[5] = row5
    return map
end

function MapEditor:debug()
    love.graphics.print("Selected tile no. " .. self.selectedSpriteNumber, 10, 245)
end

function MapEditor:loadFromFile()
    local mapString = love.filesystem.read( 'tilefile' )
    local firstComma = string.find(mapString, ',')
    local mapWidth = string.match(mapString, '([^,]+)')
    local mapOnlyString = string.sub(mapString, firstComma + 1)
    local mapData = {}
    for number in string.gmatch(mapOnlyString, '([^,]+)') do
        table.insert(mapData, number)
    end

    local mapHeight = #mapData / mapWidth
    local finalMap = {}
    local j = 1
    finalMap[1] = {}
    for i = 1, #mapData do
        table.insert(finalMap[j], tonumber(mapData[i]))
        if i % mapWidth == 0 and j ~= mapHeight then
            j = j + 1
            finalMap[j] = {}
        end
    end

    return finalMap
end

function MapEditor:debugMap(map)
    local result = ""
    for row = 1, #map do
        for col = 1, #map[1] do
            result = result .. map[row][col] .. ", "
        end
        result = result .. " | "
    end
end

function MapEditor:serializeMap(mapData)
    local data = table.maxn(mapData[1]) .. ','
    for x = 1,table.maxn(mapData) do
        for y = 1,table.maxn(mapData[x]) do
            data = data .. mapData[x][y] .. ','
        end
    end
    return data
end

return MapEditor