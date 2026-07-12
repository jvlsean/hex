local utf8 = require("utf8")
local terminalFont
local commands = require("commands")
local menu = require("menu")
local scrollOffset = 0

-- Game State
local game = {
    traceLevel = 0,
    connected = false,

    stage = 1,
    objective = "Locate the attacker's relay node",

    -- Flags
    relayFound = false,
    relayConnected = false,
    logsRead = false,
    attackerTraced = false,
    firewallBypassed = false,
    adminAccess = false,
    wormInjected = false,
    attackerDisconnected = false,
}

-- Menu
local state = "menu"

-- Main
local input = ''
local history = {
    "hex! v1.1.0 Orange Bay, Copyrighted HiTier Studios 2026",
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
local typingQueue = {}
local currentTyping = nil
local typingSpeed = 100

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

function addTypingQueue(text)
    table.insert(typingQueue, {
        text = text,
        type = "system"
    })
end

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

    menu.load()
end

function love.update(dt)

    if state == "menu" then
        menu.update(dt)
        return
    end

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

    if currentTyping == nil and #typingQueue > 0 then
        currentTyping = {
            text = typingQueue[1].text,
            type = typingQueue[1].type,
            visible = "",
            index = 0
        }

        table.remove(typingQueue, 1)
    end

    if currentTyping then
        currentTyping.index = currentTyping.index + typingSpeed * dt

        currentTyping.visible = currentTyping.text:sub(1, math.floor(currentTyping.index))

        if currentTyping.index >= #currentTyping.text then
            table.insert(history, {
                text = currentTyping.text,
                type = currentTyping.type
            })

            currentTyping = nil
        end
    end

    if game.traceLevel >= 100 then
        state = "menu"

        history = {
        "hex! v1.1.0 Orange Bay, Copyrighted HiTier Studios 2026",
        "TRACE DETECTED",
        "you were caught by the attacker.",
        "press enter / return to try again."
        }

        input = ""
        scrollOffset = 0

        game.traceLevel = 0
        game.connected = false

        game.stage = 1
        game.objective = "locate the attacker's relay node"

        relayFound = false
        relayConnected = false
        logsRead = false
        attackerTraced = false
        firewallBypassed = false
        adminAccess = false
        wormInjected = false
        attackerDisconnected = false
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

    if state == "menu" then
        local selection = menu.keypressed(key)

        if selection == "START" then
            state = "game"
            input = ""

        elseif selection == "QUIT" then
            love.event.quit()
        end

        return
    end

    if key == "backspace" then
        local byteoffset = utf8.offset(input, -1)

        if byteoffset then
            input = string.sub(input, 1, byteoffset - 1)
        end

    elseif key == "return" then
        table.insert(history, {
            text = "> "..input,
            type = "user"
        })
        scrollOffset = 0
        history = commands.execute(input, history, game)

        if game.returnToMenu then
            state = "menu"
            game.returnToMenu = false

            history = {
                "Trace.EXE v1.1-release",
                "Type 'help' to begin"
            }

            input = ""
            scrollOffset = 0
            game.traceLevel = 0
            game.connected = false
        end

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

function queueSystemMessage(text, msgType)
    table.insert(typingQueue, {
        text = text,
        type = msgType or "system"
    })
end

function love.draw()

    if state == "menu" then
        menu.draw()
        return
    end

    love.graphics.clear(0, 0, 0)

    love.graphics.setColor(0,0.3,0)

    for _,drop in ipairs(rain) do
        local index = math.random(#chars)
        local char = chars:sub(index, index)

        love.graphics.print(char,drop.x,drop.y)
    end

    local y = 20

    local lineHeight = 19
    local maxLines = math.floor((love.graphics.getHeight() - 75) / lineHeight)

    local startLine = math.max(1, #history - maxLines + 1 - scrollOffset)

    local endLine = math.min(#history, startLine + maxLines - 2)

    for i = startLine, endLine do
        local line = history[i]

        local text = line.text or line
        local msgType = line.type or "normal"

        -- Shadow color
        love.graphics.setColor(0,0,0)
        love.graphics.print(text,21,y+1)

        if msgType == "user" then
            -- Orange Bay
            love.graphics.setColor(1,0.55,0)

        elseif msgType == "system" then
            -- Light blue
            love.graphics.setColor(255, 140, 0)

        elseif msgType == "warning" then
            love.graphics.setColor(1,0.2,0.2)

        elseif msgType == "success" then
            love.graphics.setColor(0.3,1,0.3)
        
        else
            -- Default green
            love.graphics.setColor(255, 140, 0)
        end
        
        love.graphics.print(text,20,y)

        y = y + lineHeight
    end

    if currentTyping then
        love.graphics.setColor(0,0,0)
        love.graphics.print(
            currentTyping.visible,
            21,
            y + 1
        )

        love.graphics.setColor(0.45,0.85,1)
        love.graphics.print(
            currentTyping.visible,
            20,
            y
        )
    
        y = y + lineHeight
    end

    love.graphics.setColor(1,0.55,0)

    local cursor = ""

    if cursorVisible then
        cursor = "|"
    end

    love.graphics.print(
        "> " .. input .. cursor,
        20,
        love.graphics.getHeight() - 40
    )

    love.graphics.print(
        "trace level: "..game.traceLevel.."%",
        love.graphics.getWidth()-220,
        20
    )

    love.graphics.print(
        "objective: "..game.objective,
        20,
        love.graphics.getHeight() - 70
    )
end
