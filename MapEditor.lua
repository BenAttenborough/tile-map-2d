MapEditor = Class{}

require 'objects.Button'

function MapEditor:init(config)
    self.saveButton = Button(20,200,100,14,'Save',self.saveHandler)
    self.loadButton = Button(20,225,100,14,'Load',self.loadHandler)
    -- This next is broken because of incorrect sprite config (number instead of quad)
    -- self.tiles = self:createTileButtons(config)
end

function MapEditor:render()
    self.saveButton:draw()
    self.loadButton:draw()
end

function MapEditor:saveHandler()
    print("Save clicked")
    -- Tilemap2d:save()
end

function MapEditor:loadHandler()
    print("Load clicked")
    -- Tilemap2d:load()
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