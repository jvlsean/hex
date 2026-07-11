local commands = {}

function commands.execute(command, history, game)
    command = command:lower()

    -- BASIC TERMINAL
    if command == "help" then
        table.insert(history, "=== COMMANDS ===")
        table.insert(history, "help | clear | about | version | date | time | exit")
        table.insert(history, "scan | connect gateway | disconnect | ping | trace | status | netstat")
        table.insert(history, "whoami | users | passwd")
        table.insert(history, "ls | cd logs | cat admin.txt")
        table.insert(history, "download secrets.zip | rm evidence.log")
        table.insert(history, "decrypt vault | spoof trace | inject worm")
        table.insert(history, "bruteforce admin | bypass firewall")
        table.insert(history, "helpp")

    elseif command == "helpp" then
        table.insert(history, "coffee | sudo | hack nasa | rickroll | matrix")
        table.insert(history, "xyzzy | konami | 42 | open sesame | fcmobile")

    elseif command == "about" then
        table.insert(history, "Trace.EXE v1.0.1A")
        table.insert(history, "Unauthorized access simulation environment.")

    elseif command == "version" then
        table.insert(history, "v1.0.1A")

    elseif command == "date" then
        table.insert(history, os.date("%d %B %Y"))

    elseif command == "time" then
        table.insert(history, os.date("%H:%M:%S"))

    elseif command == "exit" then
        table.insert(history, "Disconnecting...")
        table.insert(history, "Connection closed.")

    elseif command == "clear" then
        history = {}

    -- NETWORK
    elseif command == "scan" then
        game.traceLevel = math.min(game.traceLevel + 5,100)

        table.insert(history, "[FOUND] Gateway Node")
        table.insert(history, "[LOCKED] Data Vault")

    elseif command == "connect gateway" then
        game.connected = true
        game.traceLevel = math.min(game.traceLevel + 10,100)

        table.insert(history, "Connected to Gateway Node.")
        table.insert(history, "Access Level: USER")

    elseif command == "disconnect" then
        game.connected = false
        table.insert(history, "Disconnected.")

    elseif command == "ping" then
        table.insert(history, "Reply from gateway: 24ms")

    elseif command == "trace" then
        table.insert(history, "Trace Level: "..game.traceLevel.."%")

    elseif command == "status" then
        if game.connected then
            table.insert(history, "Connection: ACTIVE")
        else
            table.insert(history, "Connection: DISCONNECTED")
        end

    elseif command == "netstat" then
        table.insert(history, "3 active nodes detected.")

    -- USER
    elseif command == "whoami" then
        table.insert(history, "guest")

    elseif command == "users" then
        table.insert(history, "admin")
        table.insert(history, "guest")
        table.insert(history, "security_bot")

    elseif command == "passwd" then
        table.insert(history, "Password modification disabled.")

    -- FILESYSTEM
    elseif command == "ls" then
        table.insert(history, "logs")
        table.insert(history, "users")
        table.insert(history, "vault")
        table.insert(history, "config.sys")

    elseif command == "cd logs" then
        table.insert(history, "Entered logs directory.")

    elseif command == "cat admin.txt" then
        table.insert(history, "Reminder:")
        table.insert(history, "Change vault password before Friday.")

    elseif command == "download secrets.zip" then
        table.insert(history, "Download complete.")

    elseif command == "rm evidence.log" then
        game.traceLevel = math.max(game.traceLevel - 10,0)
        table.insert(history, "Evidence removed.")
        table.insert(history, "Trace reduced by 10%.")

    -- HACKING TOOLS
    elseif command == "decrypt vault" then
        table.insert(history, "Decrypting vault...")

    elseif command == "spoof trace" then
        game.traceLevel = math.max(game.traceLevel - 20,0)
        table.insert(history, "Trace spoofed.")

    elseif command == "inject worm" then
        table.insert(history, "Worm injected successfully.")

    elseif command == "bruteforce admin" then
        game.traceLevel = math.min(game.traceLevel + 20,100)
        table.insert(history, "Bruteforcing credentials...")

    elseif command == "bypass firewall" then
        table.insert(history, "Firewall bypassed.")

    -- FUN
    elseif command == "coffee" then
        table.insert(history, "Brewing coffee...")
        table.insert(history, "☕ Ready.")

    elseif command == "sudo" then
        table.insert(history, "Permission denied.")

    elseif command == "hack nasa" then
        table.insert(history, "Target too ambitious.")

    elseif command == "rickroll" then
        table.insert(history, "Never gonna give you up...")

    elseif command == "matrix" then
        table.insert(history, "Wake up, hacker.")

    -- HIDDEN
    elseif command == "xyzzy" then
        table.insert(history, "Nothing happens.")

    elseif command == "konami" then
        table.insert(history, "Cheat mode unlocked.")

    elseif command == "42" then
        table.insert(history, "The answer is 42.")

    elseif command == "open sesame" then
        table.insert(history, "Secret access point discovered.")

    elseif command == "fcmobile" then
        table.insert(history, "EA servers are unavailable.")

    else
        table.insert(history, "Unknown command.")
    end

    return history
end

return commands
