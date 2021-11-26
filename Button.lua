Button = Class{}

local helper = require "libs.tilemap2d.helpers"

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
    local config = {
        left = self.left,
        top = self.top,
        width = self.width,
        height = self.height,
        label = self.label
    }
    if self.clicked then
        config.pressed = true
    end
    helper.drawBox(config)
end

function Button:mousereleased(x, y, button)
    if self.clicked and button == 1 and x >= self.left and x <= self.right and y >= self.top and y <= self.bottom then
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
    end
end

return Button