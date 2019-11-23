function love.load()
    
    function round(n) return n % 1 >= 0.5 and math.ceil(n) or math.floor(n) end    
    gameWL = 512
    scale = 4
    canvasScale = 4
    love.graphics.setDefaultFilter("nearest", "nearest", 1)
    mainCanvas = love.graphics.newCanvas()
    love.mouse.setVisible(false)

    isPlaying = false
    
    loadingScreen = require("loadingScreen")
    bonusPopup = require("Bonus")

    sounds = {
        bonus = love.audio.newSource("assets/sounds/bonus.wav","static"),
        death = love.audio.newSource("assets/sounds/death.wav", "static")
    }
    anthem = love.audio.newSource("assets/sounds/anthem.ogg", "stream")
    anthem:isLooping(true)

end


function love.draw()

    love.graphics.setCanvas(mainCanvas)

    if isPlaying then

        love.graphics.draw(bgImage, 0, bgY)
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
    bonusPopup:draw()

    love.graphics.setCanvas()
    love.graphics.draw(mainCanvas, 0, 0, 0, canvasScale, canvasScale)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 128 * canvasScale, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1)
end

function love.update(dt)

    if isPlaying then

        scrollSpeed = scrollSpeed + dt
        player:update(dt)
        if not player.isDead then
            
            platforms:update(dt)
            snowman:update(dt)

            bgY = bgY - scrollSpeed * dt
            if bgY < -bgImage:getHeight() / 2 then bgY = 0 end

            score:update(dt)
        end

        if player.isDead or tryAgainPopup.reversing then
            tryAgainPopup:update(dt)
        end
        bonusPopup:update(dt)

    end

    if not loadingScreen.shifted then
        loadingScreen:update(dt)
    end
end

function start()

    scrollSpeed = 40
    bgImage = love.graphics.newImage("assets/imgs/bg.png")
    bgY = 0

    platforms = require("Platforms")
    player = require("Player")
    player:restart()
    snowman = require("Snowman")

    isPlaying = true
    tryAgainPopup = require("tryAgain")
    loadingScreen.shifting = true
    
    score = require("score")

    anthem:play()
    
end

function restart()

    scrollSpeed = 40
    
    platforms:resetPlatforms()
    player:restart()
    snowman.y = -100
    
    tryAgainPopup.reversing = true
    
    score.timer = 0
    
    anthem:play()

end

function love.keypressed(key)
    if key == "escape" then love.event.quit() end
    if key == "space" and not isPlaying then start() end
    if (key == "r" or key == "space") and isPlaying and player.isDead then restart() end
    if key == "f" then 
        love.window.setFullscreen(not love.window.getFullscreen())
        canvasScale = love.graphics.getHeight() / gameWL * 4
    end
end