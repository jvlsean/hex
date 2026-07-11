local utf8 = require("utf8")
local terminalFont
local commands = require("commands")
local scrollOffset = 0

-- Game State
local game = {
    traceLevel = 0,
    connected = false
}

-- Main
local input = ''
local history = {
    "Trace.EXE v0.1 EARLY",
    "Type 'help' to begin."
}

-- Trace Level
local traceLevel = 0

-- Matrix Rain
local rain = {}
local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789#$%&"

-- Blinking Cursor
local cursorVisible = true
local cursorTimer = 0

-- Typing Queue
local systemTyping = false
local systemText = ""
local visibleSystemText = ""
local typingSpeed = 40 -- characters per second
local typingIndex = 0

-- Themes
local themes = {
    green = {
        bg = {0,0,0},
        text = {0,1,0},
        shadow = {0,0.4,0}
    },

    amber = {
        bg = {0,0,0},
        text = {1,0.8,0},
        shadow = {0.4,0.2,0}
    },

    cyber = {
        bg = {0.02,0.02,0.05},
        text = {0,1,1},
        shadow = {0,0.5,0.5}
    }
}

local currentTheme = themes.green

function love.load()
    terminalFont = love.graphics.newFont(18)
    love.graphics.setFont(terminalFont)

    for i=1,80 do
        table.insert(rain,{
            x = math.random(0,love.graphics.getWidth()),
            y = math.random(-800,0),
            speed = math.random(100,300)
        })
    end
end

function love.update(dt)
    for _,drop in ipairs(rain) do
        drop.y = drop.y + drop.speed * dt

        if drop.y > love.graphics.getHeight() then
            drop.y = math.random(-500,-50)
            drop.x = math.random(0,love.graphics.getWidth())
        end
    end

    cursorTimer = cursorTimer + dt

    if cursorTimer >= 0.5 then
        cursorVisible = not cursorVisible
        cursorTimer = 0
    end

    if systemTyping then
        typingIndex = typingIndex + typingSpeed * dt

        visibleSystemText = systemText:sub(
            1,
            math.floor(typingIndex)
        )

        if typingIndex >= #systemText then
            systemTyping = false
            table.insert(history, systemText)
        end
    end
end

function love.textinput(text)
    input = input .. text
end

function love.wheelmoved(x, y)
    scrollOffset = scrollOffset - y

    if scrollOffset < 0 then
        scrollOffset = 0
    end
end

love.graphics.rectangle(
    "fill",
    0,
    0,
    love.graphics.getWidth(),
                        30
)

love.graphics.setColor(0,1,0)
love.graphics.print(
    "TRACE.EXE TERMINAL",
    10,
    5
)

function love.keypressed(key)
    if key == "backspace" then
        local byteoffset = utf8.offset(input, -1)

        if byteoffset then
            input = string.sub(input, 1, byteoffset - 1)
        end

    elseif key == "return" then
        table.insert(history, "> "..input)
        scrollOffset = 0
        history = commands.execute(input, history, game)
        input = ""
    end
end

function addTrace(amount)
    traceLevel = traceLevel + amount

    if traceLevel > 100 then
        traceLevel = 100
    end

    if traceLevel >= 100 then
        table.insert(history, "")
        table.insert(history, "!!! TRACE DETECTED !!!")
        table.insert(history, "Connection terminated.")
        table.insert(history, "Type 'restart' to try again.")
    end
end

function startTyping(text)
    systemTyping = true
    systemText = text
    visibleSystemText = ""
    typingIndex = 0
end

function love.draw()
    love.graphics.clear(0, 0, 0)

    love.graphics.setColor(0,0.3,0)

    for _,drop in ipairs(rain) do
        local index = math.random(#chars)
        local char = chars:sub(index, index)

        love.graphics.print(char,drop.x,drop.y)
    end

    local y = 20

    local lineHeight = 22
    local maxLines = math.floor((love.graphics.getHeight() - 60) / lineHeight)

    local startLine = math.max(1, #history - maxLines + 1 - scrollOffset)

    local endLine = math.min(#history, startLine + maxLines - 1)

    for i = startLine, endLine do
        local line = history[i]

        love.graphics.setColor(0, 0.4, 0)
        love.graphics.print(line, 21, y + 1)

        love.graphics.setColor(0, 1, 0)
        love.graphics.print(line, 20, y)

        y = y + lineHeight
    end

    love.graphics.setColor(0, 1, 0)

    local cursor = ""

    if cursorVisible then
        cursor = "_"
    end

    love.graphics.print(
        "> " .. input .. cursor,
        20,
        love.graphics.getHeight() - 40
    )

    love.graphics.print(
        "TRACE LEVEL: "..game.traceLevel.."%",
        love.graphics.getWidth()-220,
        20
    )

    if systemTyping then
        love.graphics.setColor(0, 0.4, 0)
        love.graphics.print(visibleSystemText, 21, y + 1)

        love.graphics.setColor(0, 1, 0)
        love.graphics.print(visibleSystemText, 20, y)
    end
end
