Button = Class{}

-- Note buttons are "debounced", you need to click AND release on the button to activate it

function Button:init(config)
    self.label = config.label
    self.left = config.x
    self.top = config.y
    self.right = config.x + config.width
    self.bottom = config.y + config.height
    self.width = config.width
    self.height = config.height
    self.saveButtonCoords = {config.x, config.y, config.width, config.height}
    self.clickHandler = config.clickHandler
    self.boundObj = config.boundObj
    self.optionalParam = config.optonalParam or nil
    self.clicked = false
end

function Button:draw()
    love.graphics.rectangle('line', self.left, self.top, self.width, self.height)
    love.graphics.setFont(Fonts['medium'])
    love.graphics.print(self.label, self.left + 2, self.top)
end

function Button:mousereleased(x, y, button)
    -- print("mousereleased: " .. self.label)
    -- print("x: " .. x .. " y: " .. y .. " button: " .. tostring(button))
    if self.clicked == true and button == 1 and x >= self.left and x <= self.right and y >= self.top and y <= self.bottom then
        print("qwe: " .. self.label )
        if self.optionalParam then
            self.boundObj[self.clickHandler](self.boundObj, self.optionalParam)
        else
            self.boundObj[self.clickHandler](self.boundObj)
        end
    end
    self.clicked = false
end

function Button:mouseClick(x, y, button)
    if button == 1 and x >= self.left and x <= self.right and y >= self.top and y <= self.bottom then
        self.clicked = true
        print("Btn clicked")
    end
end

return Button