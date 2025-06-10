local DataStoreServer = game:GetService("DataStoreService")
local TimeDataStore = DataStoreServer:GetDataStore("TimeDataStore")

local function resetPlaytime(player)
    local success, err = pcall(function()
        TimeDataStore:SetAsync(tostring(player.UserId), 0)
    end)
    if not success then
        warn("Failed to reset playtime data:", err)
    end

    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local playtimeValue = leaderstats:FindFirstChild("Playtime")
        if playtimeValue then
            playtimeValue.Value = 0
        end
    end
end

local function setPlaytime(player, value)
    value = tonumber(value)
    if not value then return end

    local success, err = pcall(function()
        TimeDataStore:SetAsync(tostring(player.UserId), value)
    end)
    if not success then
        warn("Failed to set playtime data:", err)
    end

    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local playtimeValue = leaderstats:FindFirstChild("Playtime")
        if playtimeValue then
            playtimeValue.Value = value
        end
    end
end

return {
    resetPlaytime = resetPlaytime,
    setPlaytime = setPlaytime
}