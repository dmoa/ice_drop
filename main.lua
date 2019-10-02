function love.load()
    scale = 4
    WW, WH = love.graphics.getDimensions()
    love.graphics.setDefaultFilter("nearest", "nearest", 1)

    love.mouse.setVisible(false)

    require("Class")
    function round(n) return n % 1 >= 0.5 and math.ceil(n) or math.floor(n) end    

    loadingScreen = require("loadingScreen")
    bonusPopup = require("Bonus")

    require("Platform")
    require("Snowman")

    isPlaying = false

    sounds = {
        bonus = love.audio.newSource("assets/sounds/bonus.wav","static"), 
        death = love.audio.newSource("assets/sounds/death.wav", "static"),
        jump = love.audio.newSource("assets/sounds/jump.wav", "static")
}
end


function love.draw()
    if isPlaying then
        love.graphics.draw(bgImage, 0, round(bgY / scale) * scale, 0, scale, scale)
        player:draw()
        for k, platform in ipairs(platforms) do
            platform:draw()
        end
        snowman:draw()
        if player.isDead or tryAgainPopup.reversing then
            tryAgainPopup.draw()
        end
        score:draw()
    end
    if not loadingScreen.shifted then
        loadingScreen.draw()
    end 
    if bonusPopup.poppingOut then
        bonusPopup.draw()
    end
end

function love.update(dt)
    if isPlaying then
        scrollSpeed = scrollSpeed + dt * 3
        player:update(dt)
        if not player.isDead then
            for k, platform in ipairs(platforms) do
                platform:update(dt)
            end
            snowman:update(dt)
            bgY = bgY - scrollSpeed * dt
            if bgY < -bgImage:getHeight() / 2 * scale then bgY = 0 end  
            score.update(dt)   
        end
        if player.isDead or tryAgainPopup.reversing then
            tryAgainPopup.update(dt)
        end
        if bonusPopup.poppingOut then
            bonusPopup.update(dt)
        end
    end
    if not loadingScreen.shifted then
        loadingScreen.update(dt)
    end
end

function start()
    scrollSpeed = 125

    platforms = {}
    platformGap = 150
    for i = 1, 20 do
        table.insert(platforms, Platform(platformGap * i))
        table.insert(platforms, Platform(platformGap * i))
    end

    platforms[1].x = 75

    bgImage = love.graphics.newImage("assets/imgs/bg.png")
    bgY = 0

    player = require("Player")
    player:restart()
    isPlaying = true
    tryAgainPopup = require("tryAgain")

    loadingScreen.shifting = true

    score = require("score")
    snowman = Snowman()
end

function restart()
    scrollSpeed = 125
    for _, platform in ipairs(platforms) do
        platform:GPosition()
    end
    platforms[5].x = 75
    player:restart()
    tryAgainPopup.reversing = true
    score.timer = 0
    snowman.y = -100
end

function love.keypressed(key)
    if key == "escape" then love.event.quit() end
    if key == "space" and not isPlaying then start() end
    if key == "r" and isPlaying and player.isDead then restart() end
end