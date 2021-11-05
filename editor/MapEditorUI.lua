MapEditorUI = Class{}

require 'libs.tilemap2d.Button'
require 'libs.tilemap2d.tilemap2d'

function MapEditorUI:init(config)
    self.offsetX = config['offsetX']
    self.offsetY = config['offsetY']
    self.tileSheet = love.graphics.newImage(config['spriteSheet'])
    self.tileButtons = self:createTileButtons(config)
    self.prevMouseDown = false
end

function MapEditorUI:render()
    love.graphics.rectangle("fill", self.offsetX ,self.offsetY ,50,50)
    for i = 1,table.maxn(self.tileButtons)
    do
        local tile = self.tileButtons[i]
        love.graphics.draw(self.tileSheet, tile.sprite, tile.x, tile.y)
    end
end

function MapEditorUI:createTileButtons(config)
    local tileButtons = {}
    local tiles = {}
    local tw = config['tileWidth']
    local th = config['tileHeight']
    -- local tileSheet = love.graphics.newImage(config['spriteSheet'])
    for i=1, config['tileCount']
    do
        tiles[i] = love.graphics.newQuad( (i - 1) * tw , 0, tw, th, self.tileSheet )
    end
    for i = 1, config['tileCount'] do
        local tileConfig = {
            ['x'] = ((i - 1) * tw) + self.offsetX,
            ['y'] = self.offsetY,
            ['width'] = tw,
            ['height'] = th,
            ['sprite'] = tiles[i]
        }
        tileButtons[i] = Tile(tileConfig)
    end
    return tileButtons
end