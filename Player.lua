local Player = {

    image = love.graphics.newImage("assets/imgs/ice.png"),
    reflectionImage = love.graphics.newImage("assets/imgs/iceReflection.png"),

    angle = 0,
    canvas = love.graphics.newCanvas(),

    x = 75,
    xv = 0,
    xv_acceleration = 3000,
    xvMax = 200,
    friction = 0.5,

    y = 300,
    oldY = y,
    yv = 0,

    direction = "left",
    isDead = false,
    isFalling = false
}


function Player:draw()
    love.graphics.draw(self.canvas, 0, 0, 0, scale, scale)
end

function Player:update(dt)

    Player:updateRotation(dt)
    Player:updateMovement(dt)

    Player:updateWithPlatforms()
    Player:updateWithSnowman()
    
    Player:updateIsDead()
    
    Player:updateCanvas()

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

function Player:updateCanvas()
    -- coords / scale so that enlarging the canvas doesn't displace the self
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()
    love.graphics.draw(self.image, (round(self.x / scale) * scale) / scale, (round(self.y / scale) * scale) / scale, 
    self.angle, 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2)
    love.graphics.draw(self.reflectionImage, (round(self.x / scale) * scale) / scale, (round(self.y / scale) * scale) / scale, 
    self.angle / 4, 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2)
    love.graphics.setCanvas()
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
    self.yv = self.yv + 600 * dt
end

function Player:updateWithPlatforms()
    self.isFalling = true
    for k, platform in ipairs(platforms) do
        if platform.y < WH then
            if platform:isPlayerOn() then
                if self.oldY + self.image:getHeight() * scale / 2 <= platform.oldY then
                    self.y = platform.y - self.image:getWidth() / 2 * scale
                    self.yv = 0
                    self.angle = 0
                    self.isFalling = false
                    sounds.jump:play()
                end
            end
            if platform:isPlayerOn() then
                if self.oldX + self.image:getWidth() / 2 * scale <= platform.x or 
                self.oldX - self.image:getWidth() / 2 * scale >= platform.x + platform.image:getWidth() * scale then
                    self.x = self.oldX
                    self.xv = 0
                end
            end
        end
    end
end

function Player:updateIsDead()
    if (self.y > WH or self.y + self.image:getHeight() < 0) and not self.isDead then
        -- move self off screen | Also removes sound effect when on platform
        self.x = -100
        
        self.isDead = true
        sounds.death:play()
        score.updateHighscore()
    end
end

function Player:updateWithSnowman()
    if snowman:hasHit() and not snowman.isHit and not self.isDead then
        snowman:dwindle()
        bonusPopup.poppingOut = true
        score.timer = score.timer + 10
        sounds.bonus:play()
    end
end

function Player:restart()
    self.isDead = false
    self.x = 75
    self.y = 150
    self.xv = 0
    self.yv = 0
end

return Player