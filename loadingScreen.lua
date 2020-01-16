local loadingScreen = {

    image =  love.graphics.newImage("assets/imgs/loading.png"),
    angle = 0,
    -- when drawing it is angle + flippedAngle
    -- when flipping image, flipped angle becomes math.pi
    flippedAngle = 0,
    isRotatingCW = true,
    timeToLoad = 2.5,
    flipping = false,
    flipped = false,
    shifting = false,
    shifted = false,
    offsetX = 0

}

function loadingScreen:draw()
    love.graphics.draw(self.image, (math.floor(gameWL / 2 / scale) * scale) / scale, -115 / scale, 
                       self.angle + self.flippedAngle, 1, 1, self.image:getWidth() / 2 + self.offsetX,
                       self.image:getHeight() / 2)
end

-- not my cleanest code...
function loadingScreen:update(dt)
    if (not self.flipping) then
        if self.isRotatingCW then
            self.angle = self.angle + dt / 5
            if self.angle > math.pi / 50 then self.isRotatingCW = false end
        else
            self.angle = self.angle - dt / 5
            if self.angle < -  math.pi / 50 then self.isRotatingCW = true end
        end
    else
        self.flippedAngle = self.flippedAngle + dt * 4 
        if self.flippedAngle > math.pi then 
            self.flipping = false
            self.flipped = true
        end
    end

    if self.timeToLoad < 0 then
        if not self.flipped then
            self.flipping = true
        end
    else
        self.timeToLoad = self.timeToLoad - dt
    end

    if self.shifting then
        self.offsetX = self.offsetX - 800 * dt
        if self.offsetX > gameWL * 1.5 then
            self.shifting = false
            self.shifted = true
        end
    end
end

return loadingScreen