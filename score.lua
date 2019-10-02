local score = {

    spritesheet = love.graphics.newImage("assets/imgs/numbers.png"),
    quads = {},
    numberLength = 16,
    timer = 0,
    highscore = 0

}

for i = 0, 9 do
    table.insert(score.quads, love.graphics.newQuad(i * score.numberLength, 0, 
                score.numberLength, score.numberLength, score.spritesheet:getDimensions()))
end

function score:draw()
    for i = 1, #tostring(math.floor(self.timer)) do
        love.graphics.draw(self.spritesheet, self.quads[tostring(math.floor(self.timer)):sub(i, i) + 1], 
        WW - self.numberLength * scale, (i - 1) * self.numberLength * scale, 0, scale, scale)
    end
end

function score:update(dt)
    self.timer = self.timer + dt / 6 * 7
end

function score:updateHighscore()
    if math.floor(self.timer) > self.highscore then
        self.highscore = math.floor(self.timer)
    end
end

return score