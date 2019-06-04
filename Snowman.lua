Snowman = class(
    function(self)
        self.image = love.graphics.newImage("assets/imgs/snowman.png")
        self.topQuad = love.graphics.newQuad(0, 0, 8, 8, self.image:getDimensions())
        self.bottomQuad = love.graphics.newQuad(0, 8, 8, 8, self.image:getDimensions())

        self.angle = 0
        self.isRotatingCW = true

        self.x = love.math.random(0, WW - self.image:getWidth() * scale)
        self.y = -100

        self.canvas = love.graphics.newCanvas()

        self.isHit = false
        self.rotationSpeed = 1
        self.maxRotation = math.pi / 8
    end
)

function Snowman:draw()
    love.graphics.draw(self.canvas, 0, 0, 0, scale, scale)
    love.graphics.draw(self.image, self.bottomQuad, (round(self.x / scale) * scale), 
    (round((self.y) / scale) * scale) + 8 * scale, 0, scale, scale, self.image:getWidth() / 2, self.image:getHeight() / 2)
end

function Snowman:update(dt)
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()
    love.graphics.draw(self.image, self.topQuad, (round(self.x / scale) * scale) / scale, (round((self.y) / scale) * scale) / scale, 
    self.angle, 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2)
    love.graphics.setCanvas()

    if self.isRotatingCW then
        self.angle = self.angle + dt * self.rotationSpeed
        if self.angle > self.maxRotation then self.isRotatingCW = false end
    else
        self.angle = self.angle - dt * self.rotationSpeed
        if self.angle < -  self.maxRotation then self.isRotatingCW = true end
    end
    self.y = self.y - scrollSpeed * dt
    if self.y + self.image:getHeight() * scale < 0 then
        self.x = love.math.random(platforms[#platforms].x + self.image:getWidth() * scale / 2,
        platforms[#platforms].x + platforms[#platforms].image:getWidth() * scale - self.image:getWidth() * scale / 2)
         self.y = platforms[#platforms].y - (self.image:getHeight() - 8) * scale
         self.isHit = false
         self.rotationSpeed = 1
         self.maxRotation = math.pi / 8
    end
end

function Snowman:hasHit()
    return (self.x + self.image:getWidth() * scale > player.x - player.image:getWidth() * scale / 2
    and self.x - self.image:getWidth() * scale < player.x + player.image:getWidth() * scale / 2 and 
    self.y - self.image:getHeight() / 2 * scale + self.image:getHeight() * scale > player.y - player.image:getHeight() * scale / 2
    and self.y - self.image:getHeight() / 2 * scale < player.y + player.image:getHeight() * scale / 2)
end

function Snowman:dwindle()
    self.isHit = true
    self.rotationSpeed = 15
    self.maxRotation = math.pi / 2
end