local Player = {

    image = lg.newImage("assets/imgs/ice.png"),
    reflectionImage = lg.newImage("assets/imgs/iceReflection.png"),

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
    isFalling = false,

    j = lj.getJoysticks()[1]
}


function Player:draw()
    lg.draw(self.image, (self.x), (self.y),
                       self.angle, 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2)
    lg.draw(self.reflectionImage, (self.x), (self.y),
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
    if input.left() then self.direction = "left" end
    if input.right() then self.direction = "right" end

    if self.isFalling then
        if self.direction == "right" then
            self.angle = (self.angle + dt * 5) % (math.pi * 2)
        else
            self.angle = (self.angle - dt * 5) % (math.pi * 2)
        end
    end
end

function Player:updateMovement(dt)
    if input.left() then self.xv = self.xv - self.xv_acceleration * dt end
    if input.right() then self.xv = self.xv + self.xv_acceleration * dt end

    if not input.left() and not input.right() then
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
    if self.x > gameWidth then self.x = gameWidth end
end

function Player:updateWithPlatforms()
    self.isFalling = true
    for k, platform in ipairs(platforms.platforms) do
        if platform.y < gameHeight then
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
    if (self.y > gameHeight or (self.y + self.image:getHeight() / 2 -4 < 0)) and not self.isDead then
        self.isDead = true
        self.y = gameHeight + 50
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