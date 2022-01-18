local M = {}

function M.drawBox(config)
    local pressed = config.pressed or false

    setLightColour()
    love.graphics.rectangle('fill', config.left + 0.5, config.top + 0.5,
                            config.width - 1, config.height - 1)
    love.graphics.setFont(Fonts['small'])
    setDarkColour()

    if pressed then
        setOffWhiteColour()
        love.graphics.rectangle('line', config.left, config.top, config.width,
                                config.height)
        setDarkColour()
        love.graphics.line(config.left, config.top, config.left + config.width,
                           config.top)
        love.graphics.line(config.left, config.top, config.left,
                           config.top + config.height)
        love.graphics.print(config.label, config.left + 3, config.top + 2)
        love.graphics.setColor(1, 1, 1)
    else
        setDarkColour()
        love.graphics.rectangle('line', config.left, config.top, config.width,
                                config.height)
        setOffWhiteColour()
        love.graphics.line(config.left, config.top, config.left + config.width,
                           config.top)
        love.graphics.line(config.left, config.top, config.left,
                           config.top + config.height)
        love.graphics.print(config.label, config.left + 3, config.top + 2)
        love.graphics.setColor(1, 1, 1)
    end

end

function setLightColour() love.graphics.setColor(0.7, 0.7, 0.7) end

function setDarkColour() love.graphics.setColor(0.4, 0.4, 0.4) end

function setOffWhiteColour() love.graphics.setColor(0.95, 0.95, 0.95) end

return M
