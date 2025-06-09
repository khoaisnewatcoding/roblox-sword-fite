game.Players.PlayerAdded:connect(function(plr)
	plr.Chatted:Connect(function(msg)
		msg = string.lower(msg)
		
		if msg == "test" then
			print("Command Received!")
		end
	end)
end)