local Bonus = {
    image = lg.newImage("assets/imgs/bonus.png"),
    x = windowL,
    y = 37.5,
    poppingOut = false,
    acceleration = 400,
    popoutSpeed = -200
}

function Bonus:draw()
    lg.draw(Bonus.image, math.floor(self.x), math.floor(self.y))
end

function Bonus:update(dt)
    if self.poppingOut then
        self.x = self.x + self.popoutSpeed * dt
        self.popoutSpeed = self.popoutSpeed + self.acceleration * dt

        if self.x > gameWidth then
            self.poppingOut = false
            self.x = gameWidth
            self.popoutSpeed = -200
        end
    end
end

function Bonus:pop()
    self.poppingOut = true
    self.x = gameWidth
end

return Bonus