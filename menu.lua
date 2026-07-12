local menu = {}

local selected = 1

local logo
local startButton
local optionButton
local exitButton

local scales = {1,1,1}
local offsets = {0,0,0}

function menu.load()
    logo = love.graphics.newImage("assets/hexlogo.png")

    startButton = love.graphics.newImage("assets/start_menu.png")
    optionButton = love.graphics.newImage("assets/option_menu.png")
    exitButton = love.graphics.newImage("assets/exit_menu.png")
end

function menu.update(dt)

    for i=1,3 do
        local targetScale = 1
        local targetOffset = 0

        if selected == i then
            targetScale = 1.08
            targetOffset = 0
        end

        scales[i] =
            scales[i] +
            (targetScale - scales[i]) *
            dt * 10

        offsets[i] =
            offsets[i] +
            (targetOffset - offsets[i]) *
            dt * 10
    end
end

function menu.keypressed(key)

    if key == "a" or key == "left" then
        selected = selected - 1

        if selected < 1 then
            selected = 3
        end

    elseif key == "d" or key == "right" then
        selected = selected + 1

        if selected > 3 then
            selected = 1
        end

    elseif key == "return" then

        if selected == 1 then
            return "START"

        elseif selected == 2 then
            return "OPTION"

        elseif selected == 3 then
            return "QUIT"
        end
    end
end

function menu.draw()

    local sw = love.graphics.getWidth()
    local sh = love.graphics.getHeight()

    love.graphics.clear(0,0,0)

    love.graphics.setColor(1,1,1)

    love.graphics.draw(
        logo,
        sw/2,
        170,
        0,
        1,
        1,
        logo:getWidth()/2,
        logo:getHeight()/2
    )

    local positions = {
        {x = sw/2 - 270, image = startButton},
        {x = sw/2 + 10, image = optionButton},
        {x = sw/2 + 270, image = exitButton}
    }

    for i=1,3 do
        if i ~= selected then
            love.graphics.draw(
                positions[i].image,
                positions[i].x,
                500 + offsets[i],
                0,
                scales[i],
                scales[i],
                positions[i].image:getWidth()/2,
                positions[i].image:getHeight()/2
            )
        end
    end

    ------------------------------------------------
    -- DRAW SELECTED LAST
    ------------------------------------------------

    love.graphics.draw(
        positions[selected].image,
        positions[selected].x,
        500 + offsets[selected],
        0,
        scales[selected],
        scales[selected],
        positions[selected].image:getWidth()/2,
        positions[selected].image:getHeight()/2
    )

    ------------------------------------------------
    -- VERSION TEXT
    ------------------------------------------------

    love.graphics.print(
        "hex! v1.1.0 cn-Orange Bay",
        20,
        sh - 50
    )

    love.graphics.print(
        "HiTier Studios 2026",
        20,
        sh - 30
    )
end

return menu
