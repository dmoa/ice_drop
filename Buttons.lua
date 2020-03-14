local function mouseOver(x, y, width, height)
    local mx, my = push:toGame(lmouse.getPosition())
    return mx and my and mx > x and mx < x + width and my > y and my < y + height
end

local buttons = {}
buttons.buttons = {}

local htpImg = lg.newImage("assets/imgs/howtoplay.png")
local startImg = lg.newImage("assets/imgs/start.png")
openingButtons = {
    {name = "how to play", image = htpImg,
     x = gameWidth / 2 - htpImg:getWidth() / 2, y = 20,
     activate =
        function()
            buttons.buttons = howToPlayButtons
            loadingScreen.moving = false
        end},
    {name = "start", image = startImg,
     x = gameWidth / 2 - startImg:getWidth() / 2, y = 70,
     activate = function() start() end}
}

local escapeImg = lg.newImage("assets/imgs/escape.png")
local tryAgainButtons = {
    {name = "escape", image = escapeImg, x = 2, y = 2, activate =
    function()
        isPlaying = false
        introSound:play()
        loadingScreen.shifted = false
        loadingScreen.offsetX = 0
        loadingScreen.shifting = false
    end}
}

howToPlayButtons = {
    {name = "back", image = escapeImg, x = 2, y = 2, activate =
    function()
        buttons.buttons = openingButtons
        loadingScreen.moving = true
        if score then score.score = 0 end
    end},
    {name = "how_to", image = lg.newImage("assets/imgs/tutorial.png"), x = 0, y = 0, activate = function() end, noBold = true}
}

function buttons:draw()
    for k, button in ipairs(self.buttons) do
        lg.draw(button.image, button.x, button.y)
        if not button.noBold and mouseOver(button.x, button.y, button.image:getDimensions()) then
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
            break
        end
    end
    if loadingScreen.flipped and self.buttons ~= openingButtons and self.buttons ~= howToPlayButtons then
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