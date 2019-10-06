local _image = love.graphics.newImage("assets/imgs/snowman.png")

local Snowman = {

    image = _image,
    topQuad = love.graphics.newQuad(0, 0, 8, 8, _image:getDimensions()),
    bottomQuad = love.graphics.newQuad(0, 8, 8, 8, _image:getDimensions()),

    arrowImage = love.graphics.newImage("assets/imgs/arrow.png"),

    angle = 0,
    isRotatingCW = true,

    x = love.math.random(0, 50 * scale),
    y = -100,

    canvas = love.graphics.newCanvas(),

    isHit = false,
    rotationSpeed = 1,
    maxRotation = math.pi / 8

}

function Snowman:draw()
    love.graphics.draw(self.image, self.bottomQuad, round(self.x), 
                        round(self.y) + 8, 0, 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2)
    love.graphics.draw(self.arrowImage, round(self.x), 
                        round(self.y) - 15, 0, 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2)
    love.graphics.draw(self.image, self.topQuad, round(self.x), round(self.y), 
                        self.angle, 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2)
end

function Snowman:update(dt)

    if self.isRotatingCW then
        self.angle = self.angle + dt * self.rotationSpeed
        if self.angle > self.maxRotation then self.isRotatingCW = false end
    else
        self.angle = self.angle - dt * self.rotationSpeed
        if self.angle < -  self.maxRotation then self.isRotatingCW = true end
    end
    self.y = self.y - scrollSpeed * dt
    if self.y + self.image:getHeight() < 0 then
        self.x = love.math.random(platforms.platforms[#platforms.platforms].x + self.image:getWidth() / 2,
        platforms.platforms[#platforms.platforms].x + platforms.image:getWidth() - self.image:getWidth() / 2)
         self.y = platforms.platforms[#platforms.platforms].y - (self.image:getHeight() - 8)
         self.isHit = false
         self.rotationSpeed = 1
         self.maxRotation = math.pi / 8
    end
end

function Snowman:hasHit()
    return (self.x + self.image:getWidth() > player.x - player.image:getWidth() / 2
    and self.x - self.image:getWidth() < player.x + player.image:getWidth() / 2 and 
    self.y - self.image:getHeight() / 2 + self.image:getHeight() > player.y - player.image:getHeight() / 2
    and self.y - self.image:getHeight() / 2 < player.y + player.image:getHeight() / 2)
end

function Snowman:dwindle()
    self.isHit = true
    self.rotationSpeed = 15
    self.maxRotation = math.pi / 2
end

return Snowman