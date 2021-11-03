MapEditor = Class{}

require 'objects.Button'
require 'libs.tilemap2d.tilemap2d'

function MapEditor:init(config)
    self.TileMap2d = {}
    self.loadButton = Button(20,200,100,14,'Load','load',self)
    self.saveButton = Button(20,225,100,14,'Save','save',self)
    self.prevMouseDown = false
    -- This next is broken because of incorrect sprite config (number instead of quad)
    -- self.tiles = self:createTileButtons(config)
    self.mapLoaded = false
end

function MapEditor:render()
    self.saveButton:draw()
    self.loadButton:draw()
    if self.mapLoaded then
        self.TileMap2d:draw()
    end
end

function MapEditor:update(dt)
    if love.mouse.isDown(1) and not self.prevMouseDown then
        local x,y = Push:toGame(love.mouse.getX(), love.mouse.getY())
        self.loadButton:mouseClick(x, y, 1)
        self.saveButton:mouseClick(x, y, 1)
    end
    self.prevMouseDown = love.mouse.isDown(1)
end

function MapEditor:save()
    print("Save clicked")
    -- TileMap2d:save()
end

function MapEditor:load()
    print("Load clicked")
    -- TileMap2d:load()
    local tileConfig = {}
    tileConfig['map'] = map
    tileConfig['spriteSheet'] = 'sprites/tilemap.png'
    tileConfig['spriteSize'] = {}
    tileConfig['spriteSize']['width'] = 10
    tileConfig['spriteSize']['height'] = 10
    tileConfig['spriteCount'] = 4
    tileConfig['offsetX'] = 20
    tileConfig['offsetY'] = 50
    self.TileMap2d = TileMap2d(tileConfig)
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

function MapEditor:createTileButtons(config)
    local tiles = {}
    for i = 1, config['spriteCount'] do
        local tileConfig = {
            ['x'] = ((i - 1) + 20) * config['spriteSize']['width'],
            ['y'] = 50,
            ['width'] = config['spriteSize']['width'],
            ['height'] = config['spriteSize']['height'],
            ['sprite'] = i
        }
        tiles[i] = Tile(tileConfig)
    end
    return tiles
end