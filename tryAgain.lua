local tryAgainPopup = {
    image = love.graphics.newImage("assets/imgs/tryAgain.png"),
    canvas = love.graphics.newCanvas(),
    angle = 0,
    turnedAngle = math.pi / 2,
    isRotatingCW = true,
    turned = false,
    reversing = false
}

function tryAgainPopup:draw()
    love.graphics.draw(tryAgainPopup.canvas, 0, 0, 0)
end

function tryAgainPopup:update(dt)

    if tryAgainPopup.reversing then
        tryAgainPopup.turnedAngle = tryAgainPopup.turnedAngle + dt * 4
        if tryAgainPopup.turnedAngle > math.pi / 2 then 
            tryAgainPopup.reversing = false
            tryAgainPopup.turned = false
        end
    else
        if tryAgainPopup.turned then
            if tryAgainPopup.isRotatingCW then
                tryAgainPopup.angle = tryAgainPopup.angle + dt / 3
                if tryAgainPopup.angle > math.pi / 50 then tryAgainPopup.isRotatingCW = false end
            else
                tryAgainPopup.angle = tryAgainPopup.angle - dt / 3
                if tryAgainPopup.angle < -  math.pi / 50 then tryAgainPopup.isRotatingCW = true end
            end
        else
            tryAgainPopup.turnedAngle = tryAgainPopup.turnedAngle - dt * 4
            if tryAgainPopup.turnedAngle < 0 then 
                tryAgainPopup.turned = true
            end
        end
    end

    love.graphics.setCanvas(tryAgainPopup.canvas)
    love.graphics.clear()
    love.graphics.draw(tryAgainPopup.image, 0, 0, tryAgainPopup.angle + tryAgainPopup.turnedAngle)
    for i = 1, #tostring(math.floor(score.timer)) do
        love.graphics.draw(score.spritesheet, score.quads[tostring(math.floor(score.timer)):sub(i, i) + 1], 
        0, 0, tryAgainPopup.angle + tryAgainPopup.turnedAngle, 1, 1, (gameWL / 2 + (i - 1) * 50) / -scale, 380 / -scale)
    end
    love.graphics.setCanvas()
end

return tryAgainPopup