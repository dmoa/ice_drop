love.graphics.setDefaultFilter("nearest", "nearest", 1)


local push = require "libs/push"
local gameWidth, gameHeight = 128, 128
push:setupScreen(gameWidth, gameHeight, 512, 512, {fullscreen = false, resizable = true})

local screen = require "libs/shack"
screen:setDimensions(push:getDimensions())

function love.load()

    function round(n) return n % 1 >= 0.5 and math.ceil(n) or math.floor(n) end
    gameWL = 512
    scale = 4
    canvasScale = 4
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

    introSound = love.audio.newSource("assets/sounds/intro.mp3", "stream")
    introSound:isLooping(true)
    introSound:play()
end


function love.draw()
    screen:apply()
    push:start()


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

    push:finish()
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


    screen:update(dt)
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

    introSound:stop()
    anthem:play()

end

function playerDied()
    score:updateHighscore()
    anthem:stop()
    sounds.death:play()
    screen:setShake(15)
end

function restart()

    scrollSpeed = 40

    platforms:resetPlatforms()
    player:restart()
    snowman.y = -100

    tryAgainPopup.reversing = true

    score.score = 0

    anthem:seek(love.math.random(anthem:getDuration() * 0.9))
    anthem:play()

end

function love.keypressed(key)
    if key == "escape" then love.event.quit() end
    if key == "space" and not isPlaying then start() end
    if (key == "r" or key == "space") and isPlaying and player.isDead then restart() end
    if key == "return" and love.keyboard.isDown("lalt") then push:switchFullscreen() end
end

function love.resize(w, h)
  push:resize(w, h)
end