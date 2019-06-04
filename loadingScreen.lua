local loadingScreen = {
    image =  love.graphics.newImage("assets/imgs/loading.png"),
    canvas = love.graphics.newCanvas(),
    angle = 0,
    -- when drawing it is angle + flippedAngle
    -- when flipping image, flipped angle becomes math.pi
    flippedAngle = 0,
    isRotatingCW = true,
    timeToLoad = 4,
    flipping = false,
    flipped = false,
    shifting = false,
    shifted = false,
    offsetX = 0
}

loadingScreen.draw = function()
    love.graphics.draw(loadingScreen.canvas, 0, 0, 0, scale, scale)
end

loadingScreen.update = function(dt)
    if not loadingScreen.flipping then
        if loadingScreen.isRotatingCW then
            loadingScreen.angle = loadingScreen.angle + dt / 3
            if loadingScreen.angle > math.pi / 50 then loadingScreen.isRotatingCW = false end
        else
            loadingScreen.angle = loadingScreen.angle - dt / 3
            if loadingScreen.angle < -  math.pi / 50 then loadingScreen.isRotatingCW = true end
        end
    else
        loadingScreen.flippedAngle = loadingScreen.flippedAngle + dt * 4
        if loadingScreen.flippedAngle > math.pi then 
            loadingScreen.flipping = false
            loadingScreen.flipped = true
        end
    end
    love.graphics.setCanvas(loadingScreen.canvas)
    love.graphics.clear()
    love.graphics.draw(loadingScreen.image, (round(WW / 2 / scale) * scale) / scale, -115 / scale, 
    loadingScreen.angle + loadingScreen.flippedAngle, 1, 1, loadingScreen.image:getWidth() / 2 + loadingScreen.offsetX,
    loadingScreen.image:getHeight() / 2)
    love.graphics.setCanvas()

    if loadingScreen.timeToLoad < 0 then
        if not loadingScreen.flipped then
            loadingScreen.flipping = true
        end
    else
        loadingScreen.timeToLoad = loadingScreen.timeToLoad - dt
    end

    if loadingScreen.shifting then
        loadingScreen.offsetX = loadingScreen.offsetX - 800 * dt
        if loadingScreen.offsetX > WW * 1.5 then
            loadingScreen.shifting = false
            loadingScreen.shifted = true
        end
    end
end

return loadingScreen