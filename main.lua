function love.load()
    scale = 4
    WW, WH = love.graphics.getDimensions()
    love.graphics.setDefaultFilter("nearest", "nearest", 1)

    love.mouse.setVisible(false)

    function round(n) return n % 1 >= 0.5 and math.ceil(n) or math.floor(n) end    

    loadingScreen = require("loadingScreen")
    bonusPopup = require("Bonus")

    isPlaying = false

    sounds = {
        bonus = love.audio.newSource("assets/sounds/bonus.wav","static"),
        death = love.audio.newSource("assets/sounds/death.wav", "static")
    }

    anthem = love.audio.newSource("assets/sounds/anthem.ogg", "stream")
    anthem:isLooping(true)
end


function love.draw()
    if isPlaying then
        love.graphics.draw(bgImage, 0, round(bgY / scale) * scale, 0, scale, scale)
        player:draw()
        platforms:draw()
        snowman:draw()
        if player.isDead or tryAgainPopup.reversing then
            tryAgainPopup:draw()
        end
        score:draw()
    end
    if not loadingScreen.shifted then
        loadingScreen:draw()
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
            platforms:update(dt)
            snowman:update(dt)
            bgY = bgY - scrollSpeed * dt
            if bgY < -bgImage:getHeight() / 2 * scale then bgY = 0 end  
            score:update(dt)   
        end
        if player.isDead or tryAgainPopup.reversing then
            tryAgainPopup:update(dt)
        end
        if bonusPopup.poppingOut then
            bonusPopup:update(dt)
        end
    end
    if not loadingScreen.shifted then
        loadingScreen:update(dt)
    end
end

function start()
    scrollSpeed = 125

    -- local _platform = require("Platform")

    -- for i = 1, 20 do

    --     local platform = deepcopy(_platform)
    --     platform:generatePosition()
        
    --     table.insert(platforms, platform)
    --     local platform = deepcopy(_platform)
    --     table.insert(platforms, platform)
    -- end

    platforms = require("Platforms")

    bgImage = love.graphics.newImage("assets/imgs/bg.png")
    bgY = 0

    player = require("Player")
    player:restart()
    isPlaying = true
    tryAgainPopup = require("tryAgain")

    loadingScreen.shifting = true

    score = require("score")
    snowman = require("Snowman")

    anthem:play()
end

function restart()
    scrollSpeed = 125
    platforms:resetPlatforms()
    player:restart()
    tryAgainPopup.reversing = true
    score.timer = 0
    snowman.y = -100
    anthem:play()
end

function love.keypressed(key)
    if key == "escape" then love.event.quit() end
    if key == "space" and not isPlaying then start() end
    if key == "r" and isPlaying and player.isDead then restart() end
end