la = love.audio
ld = love.data
le = love.event
lfile = love.filesystem
lf = love.font
lg = love.graphics
li = love.image
lj = love.joystick
lk = love.keyboard
lm = love.math
lmouse = love.mouse
lp = love.physics
lsound = love.sound
lsys = love.system
lth = love.thread
lt = love.timer
ltouch = love.touch
lv = love.video
lw = love.window

lg.setDefaultFilter("nearest", "nearest", 1)

splash = require "libs/splash"

function love.draw() splash:update() end
splash:startSplashScreen("assets/imgs/start_screen.png", "", 1500, 500, 5, {}, function()



-- love.draw and love.update are defined as game loops after start screen loads

push = require "libs/push"
gameWidth, gameHeight = 128, 128
gameWL = 512
lw.setMode(gameWL, gameWL, {borderless = false})
push:setupScreen(gameWidth, gameHeight, gameWL, gameWL, {fullscreen = false, resizable = true, borderless = false})

screen = require "libs/shack"
screen:setDimensions(push:getDimensions())


function round(n) return n % 1 >= 0.5 and math.ceil(n) or math.floor(n) end
scale = 4
canvasScale = 4
love.mouse.setVisible(false)

isPlaying = false

loadingScreen = require("loadingScreen")
bonusPopup = require("Bonus")

sounds = {
    bonus = la.newSource("assets/sounds/bonus.wav","static"),
    death = la.newSource("assets/sounds/death.wav", "static")
}
anthem = la.newSource("assets/sounds/anthem.ogg", "stream")
anthem:isLooping(true)

introSound = la.newSource("assets/sounds/intro.mp3", "stream")
introSound:isLooping(true)
introSound:play()


function love.draw()
    screen:apply()
    push:start()


    if isPlaying then

        lg.draw(bgImage, 0, bgY)
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
    bgImage = lg.newImage("assets/imgs/bg.png")
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
    if key == "escape" then le.quit() end
    if key == "space" and not isPlaying then start() end
    if (key == "r" or key == "space") and isPlaying and player.isDead then restart() end
    if key == "return" and lk.isDown("lalt") then push:switchFullscreen() end
end

function love.resize(w, h)
  push:resize(w, h)
end

end)