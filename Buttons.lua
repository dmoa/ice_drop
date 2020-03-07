local function mouseOver(x, y, width, height)
    local mx, my = push:toGame(lmouse.getPosition())
    return mx and my and mx > x and mx < x + width and my > y and my < y + height
end

local buttons = {}


local htpImg = lg.newImage("assets/imgs/howtoplay.png")
local startImg = lg.newImage("assets/imgs/start.png")
local openingButtons = {
    {name = "how to play", image = htpImg,
     x = gameWidth / 2 - htpImg:getWidth() / 2, y = 20,
     activate = function()  end},
    {name = "start", image = startImg,
     x = gameWidth / 2 - startImg:getWidth() / 2, y = 70,
     activate = function() start() end}
}

local escapeImg = lg.newImage("assets/imgs/escape.png")
local tryAgainButtons = {
    {name = "escape", image = escapeImg, x = 2, y = 2, activate = function() end}
}

buttons.buttons = {}

function buttons:draw()
    print(self.buttons)
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
        if mouseOver(button.x, button.y, button.image:getDimensions()) and lmouse.isDown(1) then
            button.activate()
        end
    end
    if loadingScreen.flipped and self.buttons ~= openingButtons then
        self.buttons = openingButtons
    end
    if isPlaying then
        if player.isDead then
            self.buttons = tryAgainButtons
        else
            self.buttons = {}
        end
    end
end

return buttons