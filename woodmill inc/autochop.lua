getgenv().autochoppe = false
getgenv().done_autocutting = false
getgenv().autocut = function(woodsection,height, axe)
    getgenv().autochoppe = false
    local Wood = woodsection.Parent.TreeClass.Value
    local added = game.Workspace.LooseWood.ChildAdded:Connect(function(v)
        v:WaitForChild("Owner")
        if v.Owner.Value == game.Players.LocalPlayer and v.TreeClass.Value == Wood then
            getgenv().done_autocutting = true
        end
    end)
    local pleasestop = false
    repeat
        wait(0.112)
        spawn(function()
            game:GetService("ReplicatedStorage").Remotes.HitTree:FireServer(woodsection,height, axe)
        end)
    until getgenv().done_autocutting or pleasestop
    pleasestop = true
    added:Disconnect()
    added = nil
    getgenv().done_autocutting = false
    wait(1.5)
    getgenv().autochoppe = true
end

getgenv().car_pitch_hack = false
getgenv().car_pitch = 0
--namecall hooks
getgenv().antiban_loaded = true -- compability with LS api
local metatable_hooking = [[
    local protectedPart = Instance.new("IntValue", workspace)
    protectedPart.Name = game:GetService("HttpService"):GenerateGUID(false)
    local mt = getrawmetatable(game)
    local protect = newcclosure or protect_function
    setreadonly(mt, false)
    local old_namecall = mt.__namecall
    local old_index = mt.__index
    mt.__namecall = protect(function(self, ...)
        local arguments = {...}
        local method = getnamecallmethod()
        if arguments[1]=="Set Pitch" and getgenv().car_pitch_hack == true then
            return old_namecall(self, "Set Pitch", getgenv().car_pitch)
        end
        if method == "FireServer" and self == game.ReplicatedStorage.Remotes.HitTree and getgenv().autochoppe then
            if typeof(arguments[1]) == "Instance" then
                if arguments[1].Name == "VWOOD" then
                    getgenv().autochoppe = false
                    spawn(function()getgenv().autocut(arguments[1],arguments[2],arguments[3])end)
                end
            end
            return old_namecall(self, ...)
        end
        return old_namecall(self, ...)
    end)
]]
loadstring(metatable_hooking)()