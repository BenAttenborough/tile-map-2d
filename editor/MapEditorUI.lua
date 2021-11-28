MapEditorUI = Class{}

local Tile = require 'libs.tilemap2d.Tile'
local helper = require "libs.tilemap2d.helpers"

function MapEditorUI:init(config)
    self.offsetX = config['offsetX']
    self.offsetY = config['offsetY']
    self.height = config['tileHeight']
    self.width = config['tileWidth'] * config['tileCount']
    self.mapEditorContext = config['mapEditorContext']
    self.tileSheet = love.graphics.newImage(config['spriteSheet'])
    self.padding = 2
    self.prevMouseDown = false
    self.buttonsOffsetTop = 19
    self.buttonsOffsetLeft = 5
    self.tileButtons = self:createTileButtons(config)

end

function MapEditorUI:render()
    local config = {
        left = self.offsetX,
        top = self.offsetY,
        width = 480,
        height = 35,
        label = "Spritesheet"
    }
    helper.drawBox(config)
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("line", self.offsetX - self.padding + self.buttonsOffsetLeft, self.offsetY - self.padding + self.buttonsOffsetTop, self.width + (self.padding * 2), self.height + (self.padding * 2))
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
    for i=1, config['tileCount']
    do
        tiles[i] = love.graphics.newQuad( (i - 1) * tw , 0, tw, th, self.tileSheet )
    end
    for i = 1, config['tileCount'] do
        local tileConfig = {
            ['x'] = ((i - 1) * tw) + self.offsetX + self.buttonsOffsetLeft,
            ['y'] = self.offsetY + self.buttonsOffsetTop,
            ['width'] = tw,
            ['height'] = th,
            ['sprite'] = tiles[i]
        }
        tileButtons[i] = Tile(tileConfig)
    end
    return tileButtons
end

function MapEditorUI:isWithinBounds(x,y)
    if x < self.offsetX then return false end
    if x > self.offsetX + self.width then return false end
    if y < self.offsetY then return false end
    if y > self.offsetY + self.height then return false end
    return true
end

function MapEditorUI:update(dt)
    if love.mouse.isDown(1) and not self.prevMouseDown then
        local x,y = Push:toGame(love.mouse.getX(), love.mouse.getY())
        self:detectClick(x,y)
    end
    self.prevMouseDown = love.mouse.isDown(1)
end

function MapEditorUI:detectClick(x,y,button)
    -- if self:isWithinBounds(x,y) then
    --     print("Clicked on tile UI")
    --     for i = 1, #self.tileButtons
    --     do
    --         if self.tileButtons[i]:isClickWithinTile(x,y) then
    --             print("You clicked on title type " .. i)
    --             self.mapEditorContext.selectedSpriteNumber = i
    --         end
    --     end
    -- else
    --     local res = {}
    --     res["success"] = false
    --     return res
    -- end
end

return MapEditorUI