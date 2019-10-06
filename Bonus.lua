local Bonus = {
    image = love.graphics.newImage("assets/imgs/bonus.png"),
    x = WW,
    y = 37.5,
    poppingOut = false,
    acceleration = 400,
    popoutSpeed = -200
}

function Bonus:draw()
    love.graphics.draw(Bonus.image, round(self.x), round(self.y))
end

function Bonus:update(dt)
    if self.poppingOut then
        self.x = self.x + self.popoutSpeed * dt
        self.popoutSpeed = self.popoutSpeed + self.acceleration * dt

        if self.x > WW / scale then
            self.poppingOut = false
            self.x = WW / scale
            self.popoutSpeed = -200
        end
    end
end

function Bonus:pop()
    self.poppingOut = true
    self.x = WW / scale
end

return Bonus