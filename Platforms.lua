local Platforms = {

    image = lg.newImage("assets/imgs/platform.png"),
    platforms = {},
    platformGap = 38
}

function Platforms:draw()
    for k, platform in ipairs(self.platforms) do
        lg.draw(self.image, platform.x, round(platform.y))
    end
end

function Platforms:update(dt)
    for k, platform in ipairs(self.platforms) do
        platform.oldY = platform.y
        platform.y = platform.y - scrollSpeed * dt
        if platform.y + self.image:getHeight() < 0 then
            self:generatePosition(platform)
            self:moveToBottom(platform)
        end
    end
end

function Platforms:isPlayerOn(platform)
    return (player.x + player.image:getWidth() / 2 > platform.x and
            player.x - player.image:getWidth() / 2 < platform.x + self.image:getWidth()
            and player.y + player.image:getHeight() / 2 > platform.y and
            player.y - player.image:getHeight() / 2 < platform.y + self.image:getHeight())
end

function Platforms:generatePosition(platform, y)
    platform.x = lm.random(0, gameHeight - self.image:getWidth())
end

function Platforms:moveToBottom(platform)
    platform.y = self.platformGap * #self.platforms / 2
end

function Platforms:resetPlatforms()
    for k, platform in ipairs(self.platforms) do
        self:generatePosition(platform)
        if platform.y < gameHeight and platform.y > 75 then
            platform.x = 20
        end
    end
end

function Platforms:alignPlatforms(alignY)
    for k, platform in ipairs(self.platforms) do
        platform.y = math.floor(platform.y) + alignY
    end
end

for i = 1, 20 do
    table.insert(Platforms.platforms, {x = 0, y = Platforms.platformGap * i, oldY = 0})
    table.insert(Platforms.platforms, {x = 0, y = Platforms.platformGap * i, oldY = 0})
end

Platforms:resetPlatforms()

return Platforms