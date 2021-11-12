love.keyboard.keysPressed = {}
love.keyboard.keysHeld = {}

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    love.keyboard.keysHeld[key] = true
end

function love.keyreleased(key)
    love.keyboard.keysHeld[key] = false
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.keyboard.wasAnyPressed()
    return tablelength(love.keyboard.keysPressed) > 0
end

function love.keyboard.wasHeld(key)
    return love.keyboard.keysHeld[key]
end

function love.keyboard.reset()
    love.keyboard.keysPressed = {}
    love.keyboard.keysHeld = {}
end

function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
  end