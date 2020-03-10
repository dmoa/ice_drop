local tryAgainPopup = {
    image = lg.newImage("assets/imgs/tryAgain.png"),
    angle = 0,
    turnedAngle = math.pi / 2,
    isRotatingCW = true,
    turned = false,
    reversing = false
}

function tryAgainPopup:draw()
    lg.draw(tryAgainPopup.image, 0, 0, tryAgainPopup.angle + tryAgainPopup.turnedAngle)
    for i = 1, #tostring(math.floor(score.highscore)) do
        lg.draw(score.spritesheet, score.quads[tonumber(tostring(math.floor(score.highscore)):sub(i, i)) + 1],
        0, 0, tryAgainPopup.angle + tryAgainPopup.turnedAngle, 1, 1, (windowL / 2 + (i - 1) * 50) / -scale, 420 / -scale)
    end
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
end

return tryAgainPopup