local function mouseOver(x, y, width, height)
    local mx, my = push:toGame(lmouse.getPosition())
    return mx and my and mx > x and mx < x + width and my > y and my < y + height
end

local buttons = {}


local htpImg = lg.newImage("assets/imgs/howtoplay.png")
local startImg = lg.newImage("assets/imgs/start.png")

buttons.buttons = {
    {name = "how to play", image = htpImg,
     x = gameWidth / 2 - htpImg:getWidth() / 2, y = 20,
     activate = function()  end},
    {name = "start", image = startImg,
     x = gameWidth / 2 - startImg:getWidth() / 2, y = 70,
     activate = function() end}
}

function buttons:draw()
    for k, button in ipairs(self.buttons) do
        lg.draw(button.image, button.x, button.y)
        if mouseOver(button.x, button.y, button.image:getDimensions()) then
            lg.setColor(0, 0, 0)
            lg.rectangle("line", button.x, button.y, button.image:getDimensions())
            lg.setColor(1, 1, 1)
        end
    end
end

function buttons:update()
    for k, button in ipairs(self.buttons) do
        if mouseOver(button.x, button.y, button.image:getDimensions()) and lmouse.isDown() then
            button.activate()
        end
    end
end

return buttons