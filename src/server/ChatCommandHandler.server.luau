local Playtime = require(game.ServerScriptService.Server.PlaytimeModule)

game.Players.PlayerAdded:Connect(function(plr)
    plr.Chatted:Connect(function(msg)
        local args = string.split(msg, " ")

        if msg == "test" then
            print("Command Received!")
        elseif msg == ";reset playtime" then
            print("Resetting playtime for player: " .. plr.Name)
            local success, err = pcall(function()
                Playtime.resetPlaytime(plr)
            end)
            if not success then
                warn("Failed to reset playtime for player:", plr.Name, "Error:", err)
            else
                print("Playtime reset successfully for player: " .. plr.Name)
            end
        elseif args[1] == ";set" and args[2] == "playtime" and args[3] and args[4] then
            local targetName = args[3]
            local value = tonumber(args[4])
            local targetPlayer = game.Players:FindFirstChild(targetName)
            if targetPlayer and value then
                local success, err = pcall(function()
                    Playtime.setPlaytime(targetPlayer, value)
                end)
                if not success then
                    warn("Failed to set playtime for player:", targetName, "Error:", err)
                else
                    print("Set playtime for " .. targetName .. " to " .. value)
                end
            else
                print("Invalid player or value.")
            end
        else
            print("Unknown command received: " .. msg)
        end
    end)
end)