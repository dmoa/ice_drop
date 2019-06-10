Platform = class(
    function(self, y)
        self.image = love.graphics.newImage("assets/imgs/platform.png")
        self.canvas = love.graphics.newCanvas()
        self:GPosition(y)
    end
)

function Platform:draw()
    love.graphics.draw(self.canvas, 0, 0, 0, scale, scale)
end

function Platform:update(dt)
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()
    love.graphics.draw(self.image, (round(self.x / scale) * scale) / scale, (round(self.y / scale) * scale) / scale)
    love.graphics.setCanvas()

    self.oldY = self.y
    self.y = self.y - scrollSpeed * dt
    if self.y + self.image:getHeight() * scale < 0 then 
        self:GPosition() 
        self:moveToBottom()
    end
end

function Platform:isPlayerOn()
    return (player.x + player.image:getWidth() / 2 * scale > self.x and 
    player.x - player.image:getWidth() / 2 * scale < self.x + self.image:getWidth() * scale
    and player.y + player.image:getHeight() / 2 * scale > self.y and 
    player.y - player.image:getHeight() / 2 * scale < self.y + self.image:getHeight() * scale)
end

function Platform:GPosition(y)
    self.x = love.math.random(0, WW - self.image:getWidth() * scale)
    if y then
        self.y = y
        self.oldY = self.y
    end
end

function Platform:moveToBottom()
    self.y = platformGap * #platforms / 2
end