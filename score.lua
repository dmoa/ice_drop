local score = {
    spritesheet = love.graphics.newImage("assets/imgs/numbers.png"),
    quads = {},
    numberLength = 16,
    timer = 0,
    highscore = 0
}

for i = 0, 9 do
    table.insert(score.quads, love.graphics.newQuad(i * score.numberLength, 0, score.numberLength, score.numberLength, score.spritesheet:getDimensions()))
end

score.draw = function()
    for i = 1, #tostring(math.floor(score.timer)) do
        love.graphics.draw(score.spritesheet, score.quads[tostring(math.floor(score.timer)):sub(i, i) + 1], 
        WW - score.numberLength * scale, (i - 1) * score.numberLength * scale, 0, scale, scale)
    end
end

score.update = function(dt)
    score.timer = score.timer + dt
end

score.updateHighscore = function()
    if math.floor(score.timer) > score.highscore then
        score.highscore = math.floor(score.timer)
    end
end

return score