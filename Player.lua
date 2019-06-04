Player = class(
    function(self)
        self.image = love.graphics.newImage("assets/imgs/ice.png")
        self.reflectionImage = love.graphics.newImage("assets/imgs/iceReflection.png")

        self.angle = 0
        self.canvas = love.graphics.newCanvas()

        self.x = 75
        self.xv = 0
        self.xv_acceleration = 3000
        self.xvMax = 200
        self.friction = 0.5

        self.y = 100
        self.yv = 0

        self.direction = "left"
        self.isDead = false
        self.isFalling = false
    end
)

function Player:draw()
    love.graphics.draw(self.canvas, 0, 0, 0, scale, scale)
end

function Player:update(dt)

    if love.keyboard.isDown("d") then self.direction = "right" end
    if love.keyboard.isDown("a") then self.direction = "left" end

    if self.isFalling then 
        if self.direction == "right" then
            self.angle = (self.angle + dt * 5) % (math.pi * 2) 
        else
            self.angle = (self.angle - dt * 5) % (math.pi * 2) 
        end
    end
    -- coords / scale so that enlarging the canvas doesn't displace the player
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()
    love.graphics.draw(self.image, (round(self.x / scale) * scale) / scale, (round(self.y / scale) * scale) / scale, 
    self.angle, 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2)
    love.graphics.draw(self.reflectionImage, (round(self.x / scale) * scale) / scale, (round(self.y / scale) * scale) / scale, 
    self.angle / 4, 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2)
    love.graphics.setCanvas()

    if love.keyboard.isDown("a") then self.xv = self.xv - self.xv_acceleration * dt end
    if love.keyboard.isDown("d") then self.xv = self.xv + self.xv_acceleration * dt end

    if not love.keyboard.isDown("a") and not love.keyboard.isDown("d") then
        self.xv = self.xv * math.pow(self.friction, dt)
    end 

    if self.xv > self.xvMax then self.xv = self.xvMax end
    if self.xv < -self.xvMax then self.xv = -self.xvMax end
    
    self.oldX = self.x
    self.oldY = self.y
    self.x = self.x + self.xv * dt
    self.y = self.y + self.yv * dt

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
    self.yv = self.yv + 600 * dt

    if self.y > WH + 10 and not self.isDead then
        self.isDead = true
        sounds.death:play()
        score.updateHighscore()
    end

    if snowman:hasHit() and not snowman.isHit then
        snowman:dwindle()
        bonusPopup.poppingOut = true
        score.timer = score.timer + 10
        sounds.bonus:play()
    end
end

function Player:restart()
    self.isDead = false
    self.x = 75
    self.y = 50
    self.xv = 0
    self.yv = 0
end