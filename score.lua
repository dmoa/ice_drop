local score = {

    spritesheet = lg.newImage("assets/imgs/numbers.png"),
    quads = {},
    numberLength = 16,
    score = 0,
    highscore = 0

}

for i = 0, 9 do
    table.insert(score.quads, lg.newQuad(i * score.numberLength, 0,
                score.numberLength, score.numberLength, score.spritesheet:getDimensions()))
end

function score:draw()
    for i = 1, #tostring(math.floor(self.score)) do
        lg.draw(self.spritesheet, self.quads[tostring(math.floor(self.score)):sub(i, i) + 1],
                            (gameWL / scale) - self.numberLength + (i - #tostring(math.floor(self.score))) * self.numberLength, 0, 0)
    end
end

function score:update(dt)
    self.score = self.score + dt / 6 * 7
end

function score:updateHighscore()
    if math.floor(self.score) > self.highscore then
        self.highscore = math.floor(self.score)
    end
end

return score