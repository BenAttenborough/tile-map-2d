Button = Class{}

-- Note buttons are "debounced", you need to click AND release on the button to activate it

function Button:init(x,y,width,height,label,clickHandler,boundObj,optonalParam)
    self.label = label
    self.left = x
    self.top = y
    self.right = x + width
    self.bottom = y + height
    self.width = width
    self.height = height
    self.saveButtonCoords = {x, y, width, height}
    self.clickHandler = clickHandler
    self.clicked = false
    self.boundObj = boundObj
    self.optionalParam = optonalParam or nil
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