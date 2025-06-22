--[[
kick and ban commands using chat interface is still not working properly (only works in studio)
might have to change using command GUI instead
]]

local Playtime = require(game.ServerScriptService.Server.PlaytimeModule)

local DataStoreService = game:GetService("DataStoreService")
local BanStore = DataStoreService:GetDataStore("BanStore")

local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")
local OWNER_USERID = 476204928 -- khoa's userid (admin)

local function findPlayerCaseInsensitive(name)
    for _, player in ipairs(Players:GetPlayers()) do
        if string.lower(player.Name) == string.lower(name) then
            return player
        end
    end
    return nil
end

game.Players.PlayerAdded:Connect(function(plr)
    local banData
    local success, err = pcall(function()
        banData = BanStore:GetAsync(plr.UserId)
        task.wait(2);
    end)
    print(banData)
    print(plr)
    if success and banData then
        if banData == "permanent" or (tonumber(banData) and os.time() < tonumber(banData)) then
            plr:Kick("You are banned from this game.")
            return
        end
    end

    plr.Chatted:Connect(function(msg)
        print("Admin check:", plr.Name, plr.UserId)
        if plr.UserId ~= OWNER_USERID then
            print("You do not have permission to use admin commands.")
            return
        end

        local args = string.split(msg, " ")

        if msg == "test" then
            print("Command Received!")
        elseif args[1] == ";unban" and args[2] then
            local targetName = args[2]
            local targetUserId

            -- Try to find the player in-game first
            local targetPlayer = game.Players:FindFirstChild(targetName)
            if targetPlayer then
                targetUserId = targetPlayer.UserId
            else
                -- Try to get UserId from username
                local successId, userIdOrErr = pcall(function()
                    return game.Players:GetUserIdFromNameAsync(targetName)
                end)
                if successId then
                    targetUserId = userIdOrErr
                end
            end

            if targetUserId then
                local successUnban, errUnban = pcall(function()
                    BanStore:RemoveAsync(targetUserId)
                end)
                if successUnban then
                    print("Unbanned " .. targetName .. " (UserId: " .. targetUserId .. ")")
                else
                    warn("Failed to unban player:", targetName, "Error:", errUnban)
                end
            else
                print("Player/User not found.")
            end
        elseif args[1] == ";ban" and args[2] then
            local targetName = args[2]
            local banTime = args[3]
            local reason = table.concat(args, " ", 4)
            local targetUserId

            -- Try to find the player in-game first
            local targetPlayer = game.Players:FindFirstChild(targetName)
            if targetPlayer then
                targetUserId = targetPlayer.UserId
            else
                -- Try to get UserId from username
                local successId, userIdOrErr = pcall(function()
                    return game.Players:GetUserIdFromNameAsync(targetName)
                end)
                if successId then
                    targetUserId = userIdOrErr
                end
            end

            if targetUserId then
                local banValue = "permanent"
                if banTime and tonumber(banTime) then
                    banValue = tostring(os.time() + tonumber(banTime))
                end
                local successBan, errBan = pcall(function()
                    BanStore:SetAsync(targetUserId, banValue)
                end)
                if successBan then
                    if targetPlayer then
                        targetPlayer:Kick(reason ~= "" and reason or "You have been banned from the game.")
                    end
                    print("Banned " .. targetName .. " (UserId: " .. targetUserId .. ") for: " .. (banTime or "permanent") .. " seconds. Reason: " .. (reason ~= "" and reason or "No reason"))
                else
                    warn("Failed to ban player:", targetName, "Error:", errBan)
                end
            else
                print("Player/User not found.")
            end
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
        elseif args[1] == ";kick" and args[2] then
            local targetPlayer = findPlayerCaseInsensitive(args[2])
            local reason = table.concat(args, " ", 3)
            print("Kick command issued by", plr.Name, "target:", args[2], "found:", targetPlayer and targetPlayer.Name or "nil")
            if targetPlayer then
                targetPlayer:Kick(reason ~= "" and reason or "You have been kicked from the game.")
                print("Kicked " .. targetPlayer.Name .. " for: " .. (reason ~= "" and reason or "No reason"))
            else
                print("Player not found.")
            end
        else
            print("Unknown command received: " .. msg)
        end
    end)

    TextChatService.OnIncomingMessage = function(message)
        local plr = Players:FindFirstChild(message.TextSource.Name)
        if not plr then return end

        -- Only allow owner
        if plr.UserId ~= OWNER_USERID then
            return
        end

        local msg = message.Text
        local args = string.split(msg, " ")

        if args[1] == ";kick" and args[2] then
            local targetPlayer = findPlayerCaseInsensitive(args[2])
            local reason = table.concat(args, " ", 3)
            if targetPlayer then
                targetPlayer:Kick(reason ~= "" and reason or "You have been kicked from the game.")
            end
        elseif args[1] == ";ban" and args[2] then
            local targetName = args[2]
            local banTime = args[3]
            local reason = table.concat(args, " ", 4)
            local targetUserId

            local targetPlayer = findPlayerCaseInsensitive(targetName)
            if targetPlayer then
                targetUserId = targetPlayer.UserId
            else
                local successId, userIdOrErr = pcall(function()
                    return Players:GetUserIdFromNameAsync(targetName)
                end)
                if successId then
                    targetUserId = userIdOrErr
                end
            end

            if targetUserId then
                local banValue = "permanent"
                if banTime and tonumber(banTime) then
                    banValue = tostring(os.time() + tonumber(banTime))
                end
                local successBan, errBan = pcall(function()
                    BanStore:SetAsync(targetUserId, banValue)
                end)
                if successBan then
                    if targetPlayer then
                        targetPlayer:Kick(reason ~= "" and reason or "You have been banned from the game.")
                    end
                end
            end
        end
        -- Add other commands here...
    end
end)