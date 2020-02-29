local function isClicking(x, y, width, height)
    local mx, my = lmouse.getPosition()
    return mx > x and mx < x + width and my > y and my < y + height
end

local buttons = {}


local htpImg = lg.newImage("assets/imgs/howtoplay.png")
buttons.buttons = {
    {name = "how to play", image = htpImg,
     x = gameWidth / 2 - htpImg:getWidth() / 2, y = 0,
     activate = function()  end},
    {name = "start", image = lg.newImage("assets/imgs/start.png"), x = 60, y = 100,
     activate = function() end}
}

function buttons:draw()
    for k, button in ipairs(self.buttons) do
        lg.draw(button.image, button.x, button.y)
    end
end

function buttons:update()
    for k, button in ipairs(self.buttons) do
        if isClicking(button.x, button.y, button.image:getDimensions()) then
            button.activate()
        end
    end
end

return buttons