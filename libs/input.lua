-- Stan O
-- stan.xyz
-- copyright: pls don't steal kthxbye

local input = {}

joystick = lj.getJoysticks()[1]
-- joystick:setVibration(1, 1, 0.5)

input = {
    right = function()
        return (lk.isDown("right") or lk.isDown("d") or (joystick and joystick:getAxis(1) > 0.5))
    end,
    left = function()
        return (lk.isDown("left") or lk.isDown("a") or (joystick and joystick:getAxis(1) < -0.5))
    end,
    up = function()
        return (lk.isDown("up") or lk.isDown("w") or (joystick and joystick:getAxis(2) < -0.5))
    end,
    down = function()
        return (lk.isDown("down") or lk.isDown("s") or (joystick and joystick:getAxis(2) > 0.5))
    end
}

return input