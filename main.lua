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
    love.graphics.clear()

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
    love.graphics.draw(mainCanvas, (love.graphics.getWidth() - (gameWL * canvasScale / 4)) / 2, 0, 0, canvasScale, canvasScale)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 128 * canvasScale + (love.graphics.getWidth() - (gameWL * canvasScale / 4)) / 2, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1)
end

function love.update(dt)

    if isPlaying then

        player:update(dt)
        if not player.isDead then
            
            scrollSpeed = scrollSpeed + dt
            platforms:update(dt)
            snowman:update(dt)

            bgY = bgY - scrollSpeed * dt
            if bgY < -bgImage:getHeight() / 2 then 
                --[[
                ok basically here is the most annoying bug,
                at some random point, platforms (very slightly) start bouncing weirdly.
                I figured out why though...
                So ideally, the background Y and platform Ys are supposed to be pixel perfect, and
                relative to each other also be pixel perfect, so that it is a seemless aligned background.
                However, a good rule in game programming is to DRAW pixel perfectly, 
                but always keep the maths (update()) as float point values.
                This becomes a problem when bgY is set to 0, as platform Ys could still be float points,
                Causing the background and platforms to be misaligned.

                To fix this, we sprinkle some code magic to make it work.
                ]]
     
                local addedDecimal = platforms.platforms[1].y - math.floor(platforms.platforms[1].y)
                bgY = addedDecimal
                platforms:alignPlatforms(addedDecimal)
            end

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
    
    score.score = 0
    
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