local msg = [[You must use Bark for this wire art! Get Bark here at https://dogix.wtf/discord or https://discord.gg/bark]]
spawn(function() game.Players.LocalPlayer:Kick(msg) end)
spawn(function() game.Players.LocalPlayer.Kick(game.Players.LocalPlayer, msg) end)
spawn(function() local sg = Instance.new("ScreenGui", game.CoreGui) local label = Instance.new("TextLabel", sg) label.Size=UDim2.new(1,0,1,0) label.Text = msg label.BackgroundColor3 = Color3.fromRGB(255,255,255) label.ZIndex=10000000 label.TextSize = 30 end)