TileMap2d = Class{}

function TileMap2d:init(playX,playY,playWidth,playHeight)
    self.playX = playX
    self.playY = playY
    self.playWidth = playWidth
    self.playHeight = playHeight
end

function TileMap2d:draw() 
    love.graphics.rectangle("fill",self.playX,self.playY,self.playWidth,self.playHeight)
end