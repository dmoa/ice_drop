local Platforms = {

    image = love.graphics.newImage("assets/imgs/platform.png"),
    canvas = love.graphics.newCanvas(),
    platforms = {},
    platformGap = 150
    
}

function Platforms:draw()
    love.graphics.draw(self.canvas, 0, 0, 0, scale, scale)
end

function Platforms:update(dt)
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear() 
    for k, platform in ipairs(self.platforms) do
        love.graphics.draw(self.image, (round(platform.x / scale) * scale) / scale, (round(platform.y / scale) * scale) / scale)
    end
    love.graphics.setCanvas()

    for k, platform in ipairs(platforms.platforms) do
        platform.oldY = platform.y
        platform.y = platform.y - scrollSpeed * dt
        if platform.y + self.image:getHeight() * scale < 0 then 
            self:generatePosition(platform) 
            self:moveToBottom(platform)
        end
    end

end

function Platforms:isPlayerOn(platform)
    return (player.x + player.image:getWidth() / 2 * scale > platform.x and 
    player.x - player.image:getWidth() / 2 * scale < platform.x + self.image:getWidth() * scale
    and player.y + player.image:getHeight() / 2 * scale > platform.y and 
    player.y - player.image:getHeight() / 2 * scale < platform.y + self.image:getHeight() * scale)
end

function Platforms:generatePosition(platform, y)
    platform.x = love.math.random(0, WW - self.image:getWidth() * scale)
    if y then
        platform.y = y
        platform.oldY = platform.y
    end
end

function Platforms:moveToBottom(platform)
    platform.y = self.platformGap * #self.platforms / 2
end

function Platforms:resetPlatforms()
    for k, platform in ipairs(self.platforms) do
        self:generatePosition(platform)
        if platform.y < WH and platform.y > 300 then 
            platform.x = 60
        end
    end
end

for i = 1, 20 do
    table.insert(Platforms.platforms, {x = 0, y = Platforms.platformGap * i, oldY = 0})
    table.insert(Platforms.platforms, {x = 0, y = Platforms.platformGap * i, oldY = 0})
end
Platforms:resetPlatforms()

return Platforms