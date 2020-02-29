-- Stan O
-- stan.xyz
-- copyright: pls don't steal kthxbye

local Splash = {
    debug = false,
    errorF = "\nSPLASH SCREEN LIBRARY ERROR",
    finished = true,
    timer = 0,
    image = nil,
    imagePos = nil,
    textPos = nil
}

function Splash:startSplashScreen(img, text, width, height, delay, flags, _function)
    -- error handling
    if not img then
        error("image/path to image not given"..self.errorF, 2)
    elseif tostring(text) ~= text then
        error("text parameter not supplied with string"..self.errorF, 2)
    elseif tonumber(width) ~= width then
        error("width parameter not supplied with number"..self.errorF, 2)
    elseif tonumber(height) ~= height then
        error("height parameter not supplied with number"..self.errorF, 2)
    elseif tonumber(delay) ~= delay then
        error("delay parameter not supplied with number"..self.errorF, 2)
    end

    -- starting splash screen
    self.finished = false

    -- checking if "img" is path to image or if image type
    if tostring(img) == img then
        if self.debug then print("string given, now making image") end
        self.image = love.graphics.newImage(img)
    else
        if self.debug then print("string not given, assuming type is already image") end
        self.image = img
    end

    -- setting timer
    self.timer = delay

    -- making window borderless
    love.window.setMode(width, height, {borderless = true})

    -- setting function which will run after timer is done
    self._function = _function

    -- setting specific positions of text and images if "flags" is defined
    self.imagePos = (flags and flags.imagePos) and flags.imagePos or {0, 0}
    self.textPos = (flags and flags.textPos) and flags.textPos or {0, 0}
    self.textStyle = (flags and flags.textStyle) and love.graphics.newFont(flags.textStyle[1], flags.textStyle[2]) or love.graphics.newFont(25)

    -- defining text
    self.text = love.graphics.newText(self.textStyle, text)

    -- error checking
    if #self.textPos ~= 2 then
        error("text position flag requires 2 values"..self.errorF, 2)
    elseif #self.imagePos ~= 2 then
        error("image position flag requires 2 values"..self.errorF, 2)
    end

end

function Splash:update()
    if not self.finished then
        love.graphics.clear()

        self.timer = self.timer - love.timer.getDelta()

        love.graphics.draw(self.image, self.imagePos[1], self.imagePos[2])
        love.graphics.draw(self.text, self.textPos[1], self.textPos[2])

        if self.timer < 0 then
            self.finished = true

            if self._function then
                self._function()
            end
        end

    end
end

return Splash