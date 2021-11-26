Tile = Class{}

function Tile:init(config)
    self.x = config['x']
    self.y = config['y']
    self.width = config['width']
    self.height = config['height']
    self.sprite = config['sprite']
    self.spriteNumber = config['spriteNumber']
end

function Tile:isClickWithinTile(userX, userY)
    if userX < self.x then return false end
    if userX > self.x + self.width then return false end
    if userY < self.y then return false end
    if userY > self.y + self.width then return false end
    return true
end

function Tile:setTileSprite(spriteNumber, tileSheet)
    self.sprite = love.graphics.newQuad( (spriteNumber - 1) * self.width , 0, self.width, self.height, tileSheet )
    self.spriteNumber = spriteNumber
end

return Tile