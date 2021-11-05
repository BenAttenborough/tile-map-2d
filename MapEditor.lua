MapEditor = Class{}

require 'libs.tilemap2d.Button'
require 'libs.tilemap2d.tilemap2d'

function MapEditor:init(config)
    self.TileMap2d = {}
    self.loadButton = Button(20,200,100,14,'Load','load',self)
    self.saveButton = Button(20,225,100,14,'Save','save',self)
    self.prevMouseDown = false
    -- This next is broken because of incorrect sprite config (number instead of quad)
    self.tileButtons = {}
    self.tileSheet = {}
    self.mapLoaded = false
end

function MapEditor:render()
    self.saveButton:draw()
    self.loadButton:draw()
    if self.mapLoaded then
        self.TileMap2d:draw()
        self:renderUI()
    end
end

function MapEditor:update(dt)
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
    self.tileSheet = love.graphics.newImage(tileConfig['spriteSheet'])
    self.tileButtons = self:createTileButtons(tileConfig)
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
    local tileButtons = {}
    local tiles = {}
    local tw = config['spriteSize']['width']
    local th = config['spriteSize']['height']
    -- local tileSheet = love.graphics.newImage(config['spriteSheet'])
    for i=1, config['spriteCount']
    do
        tiles[i] = love.graphics.newQuad( (i - 1) * tw , 0, tw, th, self.tileSheet )
    end
    for i = 1, config['spriteCount'] do
        local tileConfig = {
            ['x'] = ((i - 1) + 20) * tw,
            ['y'] = 50,
            ['width'] = tw,
            ['height'] = th,
            ['sprite'] = tiles[i]
        }
        tileButtons[i] = Tile(tileConfig)
    end
    return tileButtons
end

function MapEditor:renderUI()
    for i = 1,table.maxn(self.tileButtons)
    do
        local tile = self.tileButtons[i]
        love.graphics.draw(self.tileSheet, tile.sprite, tile.x, tile.y)
    end
end

-- function MapEditor:clickWithinUI(x,y)
--     local offsetx = 20
--     local offsety = 50
--     local uiw = 
--     if x < offsetx then return false end
--     if x > offsetx + uiw then return false end
--     if y < offsety then return false end
--     if y > offsety + uih then return false end
--     return true
-- end

function MapEditor:detectUIClick()
end