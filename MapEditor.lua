MapEditor = Class{}

require 'objects.Button'

function MapEditor:init(config)
    self.saveButton = Button(20,200,100,14,'Save',self.saveHandler)
    self.loadButton = Button(20,225,100,14,'Load',self.loadHandler)
end

function MapEditor:render()
    self.saveButton:draw()
    self.loadButton:draw()
end

function MapEditor:saveHandler()
    print("Save clicked")
    -- Tilemap2d:save()
end

function MapEditor:loadHandler()
    print("Load clicked")
    -- Tilemap2d:load()
end

function MapEditor:mousereleased(x, y, button)
    self.saveButton:mousereleased(x, y, button)
    self.loadButton:mousereleased(x, y, button)
end

function MapEditor:click(x, y, button)
    self.saveButton:mouseClick(x, y, button)
    self.loadButton:mouseClick(x, y, button)
end