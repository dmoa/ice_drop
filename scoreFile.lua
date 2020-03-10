local scoreFile = {
    file = nil
}

function scoreFile:getHighscore()
    if not lfile.getInfo("score.txt") then
        lfile.write("score.txt", "0")
    end

    self.file = lfile.newFile("score.txt", "r")

    local score = self.file:read()
    return tonumber( score )
end

function scoreFile:updateFile()
    self.file:close()
    self.file = lfile.newFile("score.txt", "w")
    self.file:write(score.highscore)
    self.file:close()
end

return scoreFile