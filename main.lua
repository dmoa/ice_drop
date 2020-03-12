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
lg.setLineStyle('rough')

splash = require "libs/splash"

function love.draw() splash:update() end
splash:startSplashScreen("assets/imgs/start_screen.png", "", 1500, 500, 2, {}, function()



-- love.draw and love.update are defined as game loops after start screen loads

push = require "libs/push"
gameWidth, gameHeight = 128, 128
windowL = 512
lw.setMode(windowL, windowL, {borderless = false})
push:setupScreen(gameWidth, gameHeight, windowL, windowL, {fullscreen = false, resizable = true, borderless = false})
push:setBorderColor(0.96, 0.96, 0.96)

screen = require "libs/shack"
screen:setDimensions(push:getDimensions())


function round(n) return n % 1 >= 0.5 and math.ceil(n) or math.floor(n) end
scale = 4
canvasScale = 4
cursorImg = lg.newImage("assets/imgs/cursor.png")
love.mouse.setVisible(false)

isPlaying = false

-- SOUNDS
-- {
loadingScreen = require("loadingScreen")
bonusPopup = require("Bonus")

sounds = {
    bonus = la.newSource("assets/sounds/bonus.wav","static"),
    death = la.newSource("assets/sounds/death.wav", "static")
}
anthem = la.newSource("assets/sounds/anthem.ogg", "stream")
anthem:setLooping(true)

introSound = la.newSource("assets/sounds/intro.mp3", "stream")
introSound:setLooping(true)
introSound:play()
-- }


local buttons = require("Buttons")

local scoreFile = require("scoreFile")

function love.draw()
    screen:apply()
    push:start()


    if isPlaying then

        lg.draw(bgImage, 0, round(bgY))
        -- lg.draw(bgImage, 0, bgY2)

        player:draw()
        platforms:draw()
        snowman:draw()
        if player.isDead or tryAgainPopup.reversing then
            tryAgainPopup:draw()
        end
        score:draw()
        bonusPopup:draw()
    else
    end

    if not loadingScreen.shifted then
        loadingScreen:draw()
    end

    buttons:draw()

    if push:toGame(lmouse.getPosition()) then
        lmouse.setVisible(false)
        lg.draw(cursorImg, push:toGame(lmouse.getX(), lmouse.getY()))
    else
        lmouse.setVisible(true)
    end

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
                -- local platformY = platforms.platforms[1].y
                -- local addedDecimal = platformY - math.floor(platformY)
                -- print(bgY)
                -- print(addedDecimal)
                bgY = 0
                for k, platform in ipairs(platforms.platforms) do
                    platform.y = math.ceil(platform.y)
                end
                snowman.y = math.ceil(snowman.y)
                -- platforms:alignPlatforms(addedDecimal)
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

    buttons:update()
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
    screen:setShake(50)
    scoreFile:updateFile()
end

function restart()

    scrollSpeed = 40
    player:restart()
    platforms:resetPlatforms()
    snowman.y = -100

    tryAgainPopup.reversing = true

    score.score = 0

    anthem:seek(love.math.random(anthem:getDuration() * 0.9))
    anthem:play()

end

function love.keypressed(key)
    if key == "escape" then le.quit() end
    -- if key == "space" and not isPlaying and loadingScreen.flipped then start() end
    if (key == "r" or key == "space") and isPlaying and player.isDead then restart() end
    if key == "return" and lk.isDown("lalt") then push:switchFullscreen() end
    if key == "p" then debug.debug() end
    if key == "g" then love.graphics.captureScreenshot("screenshot.png") end
end

function love.resize(w, h)
  push:resize(w, h)
  loadingScreen.angle = 0
  lg.clear()
end

push:switchFullscreen()

end)