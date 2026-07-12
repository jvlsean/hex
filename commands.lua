local commands = {}

function commands.execute(command, history, game)
    command = command:lower()

    -- BASIC TERMINAL
    if command == "help" then
        addTypingQueue("/// commands ///")
        addTypingQueue("help | clear | about | version | date | time | exit")
        addTypingQueue("scan | connect relay | disconnect | ping | trace | status | netstat")
        addTypingQueue("whoami | users | passwd")
        addTypingQueue("ls | cd logs | cat instrusion.log")
        addTypingQueue("download secrets.zip | rm evidence.log")
        addTypingQueue("decrypt vault | spoof trace | inject worm")
        addTypingQueue("bruteforce admin | bypass firewall")
        addTypingQueue("helpp | objective")

    elseif command == "helpp" then
        addTypingQueue("coffee | sudo | hack nasa | rickroll | matrix")
        addTypingQueue("xyzzy | konami | 42 | open sesame | fcmobile")

    elseif command == "about" then
        addTypingQueue("hex! v1.1.0-Orange-Bay")
        addTypingQueue("Authorized access simulation environment.")

    elseif command == "version" then
        addTypingQueue("v1.1.0-Orange-Bay")

    elseif command == "date" then
        addTypingQueue(os.date("%d %B %Y"))

    elseif command == "time" then
        addTypingQueue(os.date("%H:%M:%S"))

    elseif command == "exit" then
        addTypingQueue("disconnecting...")
        addTypingQueue("connection closed.")
        game.returnToMenu = true

    elseif command == "clear" then
        history = {}

    -- NETWORK
    elseif command == "scan" then
        game.traceLevel = math.min(game.traceLevel + 5,100)

        addTypingQueue("scanning network....")
        addTypingQueue("[FOUND] 1xA relay node")
        addTypingQueue("[LOCKED] 1xA data vault")

        game.relayFound = true
        game.stage = 2
        game.objective = "connect to the relay node"

    elseif command == "connect relay" then
        if not game.relayFound then
            addTypingQueue("no relay node found.")
        else
            addTypingQueue("connecting.........")
            addTypingQueue("connected to relay.")
            game.connected = true
            game.relayConnected = true

            game.stage = 3
            game.objective = "inspect intrusion logs"
        end

    elseif command == "disconnect" then
        if not game.wormInjected then
            addTypingQueue("countermeasure not deployed.")
        else
            addTypingQueue("terminating hostile session...")
            addTypingQueue("connection closed.")
            addTypingQueue("your data is safe.")
            addTypingQueue("")
            addTypingQueue("MISSION COMPLETE")

            game.attackerDisconnected = true
            game.stage = 9
            game.objective = "well done! mission completed. exit to go back to home menu."
        end

    elseif command == "ping" then
        addTypingQueue("reply from gateway 193.120.0.2 : 15ms")

    elseif command == "trace" then
        addTypingQueue("trace level: "..game.traceLevel.."%")

    elseif command == "trace attacker" then
        game.traceLevel = math.min(game.traceLevel + 10,100)
        addTypingQueue("tracing hostile connection...")
        addTypingQueue(" ")
        addTypingQueue("origin found: NODE-1xA")

        game.stage = 5
        game.objective = "bypass attacker firewall"
        game.attackerTraced = true

    elseif command == "status" then
        if game.connected then
            addTypingQueue("connection: active")
        else
            addTypingQueue("connection: disconnected")
        end

    elseif command == "netstat" then
        addTypingQueue("3 active nodes detected.")

    elseif command == "objective" then
        addTypingQueue("current objective:"..game.objective)

    -- USER
    elseif command == "whoami" then
        addTypingQueue("user")

    elseif command == "users" then
        addTypingQueue("admin")
        addTypingQueue("user")
        addTypingQueue("security_bot")

    elseif command == "passwd" then
        addTypingQueue("password modification disabled.")

    -- FILESYSTEM
    elseif command == "ls" then
        addTypingQueue("logs")
        addTypingQueue("users")
        addTypingQueue("vault")
        addTypingQueue("config.sys")
        addTypingQueue("system32")

    elseif command == "cd logs" then
        addTypingQueue("nothing inside logs. failed.")

    elseif command == "cat instrusion.log" then
        if not game.relayConnected then
            addTypingQueue("access denied.")
        else
            addTypingQueue("attacker id: mrEast")
            addTypingQueue("founded from: user_data.db")

            game.logsRead = true
            game.stage = 4
            game.objective = "trace the attacker"
        end

    elseif command == "download secrets.zip" then
        addTypingQueue("download failed, no!")

    elseif command == "rm evidence.log" then
        game.traceLevel = math.max(game.traceLevel - 10,0)
        addTypingQueue("evidence removed.")

    -- HACKING TOOLS
    elseif command == "decrypt vault" then
        game.traceLevel = math.min(game.traceLevel + 10,100)
        addTypingQueue("decrypting vault...")

    elseif command == "spoof trace" then
        game.traceLevel = math.max(game.traceLevel - 20,0)
        addTypingQueue("trace is successfully spoofed.")

    elseif command == "inject worm" then
        if not game.adminAccess then
            addTypingQueue("administrator privileges required.")
        else
            addTypingQueue("uploading payload..............")
            addTypingQueue("payload injected.")
            addTypingQueue("attacker systems destabilizing.")

            game.traceLevel = math.min(game.traceLevel + 25,100)

            game.wormInjected = true
            game.stage = 8
            game.objective = "disconnect attacker"
        end

    elseif command == "bruteforce admin" then
        if not game.firewallBypassed then
            addTypingQueue("access denied.")
        else
            game.traceLevel = math.min(game.traceLevel + 5,100)

            addTypingQueue("bruteforcing credentials...")
            addTypingQueue("password hash captured.")
            addTypingQueue("administrator access granted.")

            game.adminAccess = true
            game.stage = 7
            game.objective = "inject worm into attacker node"
        end

    elseif command == "bypass firewall" then
        if not game.attackerTraced then
            addTypingQueue("attacker is not traced!")
        else
            addTypingQueue("please wait...................")
            addTypingQueue("firewall bypassed")
            addTypingQueue("admin authentication required!")

            game.traceLevel = math.min(game.traceLevel + 10,100)

            game.firewallBypassed = true
            game.stage = 6
            game.objective = "gain admin access"
        end

    elseif command == "full trace" then
        game.traceLevel = math.min(game.traceLevel + 95,100)

    -- FUN
    elseif command == "coffee" then
        addTypingQueue("brewing coffee...")
        addTypingQueue("ready.")

    elseif command == "sudo" then
        addTypingQueue("permission denied.")

    elseif command == "sudo please" then
        addTypingQueue("still no")

    elseif command == "sudo please please" then
        addTypingQueue("whatever.............................")
        addTypingQueue("HAHA THERES NO SUDO")

    elseif command == "hack nasa" then
        addTypingQueue("you really think that gonna work?.")

    elseif command == "rickroll" then
        addTypingQueue("Never gonna give you up...")

    elseif command == "matrix" then
        addTypingQueue("wake up, broski.")

    -- HIDDEN
    elseif command == "xyzzy" then
        addTypingQueue("nothing happens... ig?")

    elseif command == "konami" then
        addTypingQueue("cheat mode unlocked.")

    elseif command == "42" then
        addTypingQueue("The answer is isnt 42.")

    elseif command == "open sesame" then
        addTypingQueue("Sescret access point undiscovered.")

    elseif command == "fcmobile" then
        addTypingQueue("EA servers are unavailable here. ask haaland.")

    else
        addTypingQueue("unknown command.")
    end

    return history
end

return commands
