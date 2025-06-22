game.ReplicatedStorage.MainEvent.OnServerEvent:Connect(function(plr)
    spawn(function()
        plr.Character.Humanoid.Walkspeed = 5
        task.wait(0.5)
        plr.Character.Humanoid.Walkspeed = 16
    end)

    local hitbox = Instance.new("Part")

    hitbox.Parent = workspace
    hitbox.CanCollide = false
    hitbox.Anchored = true
    hitbox.Size = Vector3.new(7,7,7)
    hitbox.BrickColor = BrickColor.new("Bright red")
    hitbox.Transparency = 0.5
    hitbox.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -2)
    game.Debris:AddItem(hitbox, 0.5)
    hitbox.Touched:Connect(function(hit)
        if hitboxcooldown == true then return end
        hitboxcooldown = true

        hit.Parent:FindFirstChild("Humanoid"):TakeDamage(10)
        task.wait(.5)
        hitboxcooldown = false
    end)
    
end)