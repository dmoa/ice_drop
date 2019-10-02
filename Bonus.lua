local Bonus = {
    image = love.graphics.newImage("assets/imgs/bonus.png"),
    x = WW,
    y = 150,
    poppingOut = false,
    acceleration = 1600,
    popoutSpeed = -1000
}

function Bonus:draw()
    love.graphics.draw(Bonus.image, (round(Bonus.x / scale) * scale), (round(Bonus.y / scale) * scale), 0, scale, scale)
end

function Bonus:update(dt)
    if Bonus.poppingOut then
        Bonus.x = Bonus.x + Bonus.popoutSpeed * dt
        Bonus.popoutSpeed = Bonus.popoutSpeed + Bonus.acceleration * dt
        print(Bonus.x)
        if Bonus.x > WW then
            Bonus.poppingOut = false
            Bonus.x = WW
            Bonus.popoutSpeed = -1000
        end
    end
end

return Bonus