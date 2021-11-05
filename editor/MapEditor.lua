MapEditor = Class{}

require 'libs.tilemap2d.Button'
require 'libs.tilemap2d.tilemap2d'
require 'libs.tilemap2d.editor.MapEditorUI'

function MapEditor:init(config)
    self.TileMap2d = {}
    self.selectionUI = {}
    self.loadButton = Button(20,200,100,14,'Load','load',self)
    self.saveButton = Button(20,225,100,14,'Save','save',self)
    self.prevMouseDown = false
    self.mapLoaded = false
end

function MapEditor:render()
    self.saveButton:draw()
    self.loadButton:draw()
    if self.mapLoaded then
        self.TileMap2d:draw()
        self.selectionUI:render()
    end
end

function MapEditor:update(dt)
    if self.mapLoaded then
        self.selectionUI:update(dt)
    end
    if love.mouse.isDown(1) and not self.prevMouseDown then
        local x,y = Push:toGame(love.mouse.getX(), love.mouse.getY())
        self.loadButton:mouseClick(x, y, 1)
        self.saveButton:mouseClick(x, y, 1)
        if self.mapLoaded then
            local res = self.TileMap2d:detectClick(x, y, 1)
            if res.success then
                print("You clicked on tile2 " .. res.mapX .. " " .. res.mapY)
            end
        end
    end
    self.prevMouseDown = love.mouse.isDown(1)
end

function MapEditor:save()
    print("Save clicked")
    -- TileMap2d:save()
end

function MapEditor:load()
    local tileConfig = {}
    tileConfig['map'] = self:getDefaultMap()
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
    self.selectionUI = MapEditorUI(selectionUIConfig)
    self.mapLoaded = true
end

function MapEditor:mousereleased(x, y, button)
    self.saveButton:mousereleased(x, y, button)
    self.loadButton:mousereleased(x, y, button)
end

function MapEditor:click(x, y, button)
    self.saveButton:mouseClick(x, y, button)
    self.loadButton:mouseClick(x, y, button)
end

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