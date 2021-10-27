Tile = Class{}

function Tile:init(config)
    self.x = config['x']
    self.y = config['y']
    self.width = config['width']
    self.height = config['height']
    self.sprite = config['sprite']
end

function Tile:mousereleased(x, y, button)
    x,y = push:toGame(x,y)
    if button == 1 and x >= self.left and x <= self.right and y >= self.top and y <= self.bottom then
        print("Tile " .. self.x .. " " .. self.y .. " clicked")
    end
end

function Tile:render(offsetX, offsetY)
    -- draw x + offsetX, y + offsetY
    -- love.graphics.draw(self.tileSheet, tile, offsetx, offsety)
end