local Player = {

    image = love.graphics.newImage("assets/imgs/ice.png"),
    reflectionImage = love.graphics.newImage("assets/imgs/iceReflection.png"),

    angle = 0,

    x = 75,
    xv = 0,
    xv_acceleration = 700,
    xvMax = 50,
    friction = 0.4,

    y = 50,
    oldY = y,
    yv = 0,

    direction = "left",
    isDead = false,
    isFalling = false
}


function Player:draw()
    love.graphics.draw(self.image, (self.x), (self.y),
                       self.angle, 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2)
    love.graphics.draw(self.reflectionImage, (self.x), (self.y),
                       self.angle / 4, 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2)
end

function Player:update(dt)
    if not self.isDead then

        Player:updateRotation(dt)
        Player:updateMovement(dt)

        Player:updateWithPlatforms()
        Player:updateWithSnowman()

        Player:updateIsDead()

    end
end

function Player:updateRotation(dt)
    if love.keyboard.isDown("d") or love.keyboard.isDown("right") then self.direction = "right" end
    if love.keyboard.isDown("a") or love.keyboard.isDown("left") then self.direction = "left" end

    if self.isFalling then
        if self.direction == "right" then
            self.angle = (self.angle + dt * 5) % (math.pi * 2)
        else
            self.angle = (self.angle - dt * 5) % (math.pi * 2)
        end
    end
end

function Player:updateMovement(dt)
    if love.keyboard.isDown("a") or love.keyboard.isDown("left") then self.xv = self.xv - self.xv_acceleration * dt end
    if love.keyboard.isDown("d") or love.keyboard.isDown("right") then self.xv = self.xv + self.xv_acceleration * dt end

    if not love.keyboard.isDown("a") and not love.keyboard.isDown("d") and not love.keyboard.isDown("right") and not love.keyboard.isDown("left") then
        self.xv = self.xv * math.pow(self.friction, dt)
    end

    if self.xv > self.xvMax then self.xv = self.xvMax end
    if self.xv < -self.xvMax then self.xv = -self.xvMax end

    self.oldX = self.x
    self.oldY = self.y
    self.x = self.x + self.xv * dt
    self.y = self.y + self.yv * dt
    self.yv = self.yv + 200 * dt

    if self.x < 0 then self.x = 0 end
    if self.x > gameWL / 4 then self.x = gameWL / 4 end
end

function Player:updateWithPlatforms()
    self.isFalling = true
    for k, platform in ipairs(platforms.platforms) do
        if platform.y < gameWL then
            if platforms:isPlayerOn(platform) then
                if self.oldY + self.image:getHeight() / 2 <= platform.oldY then
                    self.y = platform.y - self.image:getWidth() / 2
                    self.yv = 0
                    self.angle = 0
                    self.isFalling = false
                end
            end
            if platforms:isPlayerOn(platform) then
                if self.oldX + self.image:getWidth() / 2 <= platform.x or
                self.oldX - self.image:getWidth() / 2 >= platform.x + platforms.image:getWidth() then
                    self.x = self.oldX
                    self.xv = 0
                end
            end
        end
    end
end

function Player:updateIsDead()
    if (self.y > (gameWL / scale) or (self.y + self.image:getHeight() / 2 -1 < 0)) and not self.isDead then
        self.isDead = true
        self.y = gameWL + 50
        playerDied()
    end
end

function Player:updateWithSnowman()
    if snowman:hasHit() and not snowman.isHit and not self.isDead then
        snowman:dwindle()
        bonusPopup:pop()
        score.score = score.score + 10
    end
end

function Player:restart()
    self.isDead = false
    self.x = 20
    self.y = 50
    self.xv = 0
    self.yv = 0
end

return Player