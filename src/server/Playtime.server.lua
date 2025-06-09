local DataStoreService = game:GetService("DataStoreService")
local TimeDataStore = DataStoreService:GetDataStore("TimeDataStore")

game.Players.PlayerAdded:Connect(function(player)
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player

    local Time = Instance.new("IntValue")
    Time.Name = "Playtime"
    Time.Value = 0
    Time.Parent = leaderstats

    local data
    local success, err = pcall(function()
        data = TimeDataStore:GetAsync(tostring(player.UserId))
    end)

    if success and data then
        Time.Value = data
    end

    while wait(60) do
        Time.Value = Time.Value + 1
        local success, err = pcall(function()
            TimeDataStore:SetAsync(tostring(player.UserId), Time.Value)
        end)
        if not success then
            warn("Failed to save data:", err)
        end
    end
	end)

function resetPlaytime(player)
    local success, err = pcall(function()
        TimeDataStore:SetAsync(tostring(player.UserId), 0)
    end)
    if not success then
        warn("Failed to reset playtime data:", err)
    end
end
