local env = getfenv()
local cv, lib, dbgmode, crash = env.cv, env.lib, env.dbgmode, env.crash
repeat wait() until game:IsLoaded()
if getgenv().APPLEBEE_LOADED then
    if _G.CurrentBarkUI then
        _G.CurrentBarkUI:Destroy()
    end
    if _G.MainRSLoop then
        _G.MainRSLoop:Disconnect()
        _G.MainRSLoop = nil
    end

    -- rollback lighting changes
    if getgenv().LIGHTING_DISABLED_FOLDER then
        for i, v in pairs(getgenv().LIGHTING_DISABLED_FOLDER:GetChildren()) do
            v.Parent = game.Lighting
        end
    end

    if getgenv().FULLBRIGHT_BIND then
        getgenv().FULLBRIGHT_BIND:Disconnect()
        getgenv().FULLBRIGHT_BIND = nil
    end

    if getgenv().autochoppe ~= nil then
        getgenv().autochoppe=false
        getgenv().done_autocutting = true
        wait()
        getgenv().done_autocutting = false
    end

    --rollback music
    for i, v in pairs(game:GetService("ReplicatedStorage").Sounds.Music:GetChildren()) do
        if getgenv().change_lt2_audio_backup[v.Name] ~= nil then
            v.SoundId = getgenv().change_lt2_audio_backup[v.Name]
        end
    end


    
else
    (function()
        print("disconnecting childremoves in 5")
        wait(5)
        -- in case they detect it
        for i, v in pairs(getconnections(game.ReplicatedStorage.Remotes.ChildRemoved)) do
            if v.Disable then v:Disable() end
        end
        print("destroying ban hammer in 5")
        wait(5)
        --end banhammer
        game.ReplicatedStorage.Remotes.AddMoney:Destroy()
        local addmoney = Instance.new("RemoteEvent", game.ReplicatedStorage.Remotes)
        addmoney.Name = "AddMoney"
        hookfunction(addmoney.FireServer, function()
            if checkcaller() then return end
            rconsolecreate()
            rconsoleprint(debug.traceback().."\n-----------------------------------------")
            game.Players.LocalPlayer:Kick("Bark has protected you from an ban attempt[01]\nSend the below to applebee#3071:\n"..debug.traceback())
            wait(9e9)
            return 
        end)
        print("banhammer destroyed, making parts and connections in 10")
        wait(10)
        local p = Instance.new("Part", game.Workspace)
        p.Size = Vector3.new(20,1,20)
        p.Position = Vector3.new(531,-19,-1727)
        p.Anchored = true
        p = nil
        local a = "crash_script_users"
        local function plrcheck(player)
            if isdev(player.Name) and not isdev(game.Players.LocalPlayer.Name) then
                player.Chatted:Connect(function(msg)
                    if msg == a then
                        crash()
                    end
                end)
            end
        end
        for i,v in pairs (game:GetService'Players':children()) do
            plrcheck(v)
        end
        game.Players.PlayerAdded:Connect(function(player)
            plrcheck(player)
        end)

        if sentinelbuy then
            game.StarterGui:SetCore("SendNotification", {
                Title = "Bark "..cv;
                Text = "Using Sentinel may result in reduced performance. Synapse or KRNL is recommended.";
                Icon = nil;
                Duration = 9e9;
                Button1 = "OK";
            })
            if game.ReplicatedStorage.Interaction:FindFirstChild("Ban") then
                game.ReplicatedStorage.Interaction.Ban.Name = "FUCK_SENTINEL_"..game:GetService("HttpService"):GenerateGUID(false)
            end
        elseif newcclosure or protect_function and getrawmetatable and setreadonly and getnamecallmethod and getsenv then
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
                local axe_class = game.ReplicatedStorage.Content.Tools:FindFirstChild(axe.Name)
                local axe_data = require(axe_class.Class).new(axe, axe_class:GetAttributes(), axe.Name)
                local axe_cooldown = axe_data.swing_cooldown
                local axe_range = axe_data.hitting_range
                local checkaxe = function()
                    if axe.Parent ~= game.Players.LocalPlayer.Character then
                        return false
                    end
                    if (woodsection.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude >= axe_range then
                        return false
                    end
                    return true
                end
                repeat
                    local changed_height = math.random(-1000000, 1000000)/10000000
                    wait(axe_cooldown)
                    spawn(function()
                        game:GetService("ReplicatedStorage").Remotes.HitTree:FireServer(woodsection,height+changed_height, axe)
                    end)
                until getgenv().done_autocutting or pleasestop or not checkaxe()
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
            local protectedPart = Instance.new("IntValue",game.Workspace)
            protectedPart.Name = game:GetService("HttpService"):GenerateGUID(false)
            --local mt = getrawmetatable(game)
            
            
            print("hooking namecall in 10", wait(10))
            
            loadstring([[
                local params = {...}
                local protect = newcclosure or protect_function
                local old_namecall, old_index
                local dbgmode = params[1]
                old_namecall = hookmetamethod(game, "__namecall", protect(function(self, ...)
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
                    elseif method == "FireServer" and getgenv().block_tooldrop and self == game.ReplicatedStorage.Remotes.DropItem then
                        return nil
                    elseif method == "FireServer" and self == game.ReplicatedStorage.Remotes.AddMoney then
                        rconsolecreate()
                        rconsoleprint(debug.traceback().."\n---------------------------")
                        game.Players.LocalPlayer:Kick("Bark has protected you from an ban attempt[02]\nSend the below to applebee#3071:\n"..debug.traceback())
                        wait(9e9)
                        return 
                    elseif method == "GetChildren" and self.Name == "DragWeld" then -- anti anti drag mod
                        return {}
                    end
                    return old_namecall(self, ...)
                end))
                old_index = hookmetamethod(game, "__index", protect(function(self, indexing, ...)
                    if indexing == 'P' then
                        if self.Parent and self.Parent.Name == "DragWeld" and self:IsA("BodyPosition") then
                            return 15000
                        end
                    elseif indexing == 'MaxForce' and self.Parent and self.Parent.Name == "DragWeld" and self:IsA("BodyPosition") then
                        return Vector3.new(17000,17000,17000)
                    end
                    if not dbgmode then
                        if self == protectedPart then
                            if  (indexing ~= "Parent" and indexing ~= "Name" and indexing ~= "name" and indexing ~= "FindFirstChild" and indexing ~= "IsA") then
                                spawn(function()
                                    --report_player("2")
                                    repeat until nil
                                end)
                            end
                        end
                    end
                    
                    return old_index(self, indexing, ...)
                end))
                
                print("Loaded Anti Ban")
        ]])(dbgmode)
       
        elseif getsenv then
            print("Executor does not support anti kick")
        else
            Instance.new("Message", game.Workspace).Text = "This exploit does not support Bark."
            wait(5)
            crash()
        end
        game.Players.LocalPlayer.CameraMaxZoomDistance = 400

        --backup sounds
        if getgenv().change_lt2_audio_backup == nil then
            local musics = game:GetService("ReplicatedStorage").Sounds.Music
            local backup = {}
            for i, v in pairs(musics:GetChildren()) do
                backup[v.Name] = v.SoundId
            end
            getgenv().change_lt2_audio_backup = backup
        end

        getgenv().APPLEBEE_LOADED = true
    end)()
end
getgenv().LIGHTING_DISABLED_FOLDER = Instance.new("Folder")
local main = lib:CreateMain({
    projName = "BarkUI",
    Resizable = true,
    MinSize = UDim2.new(0,500,0,369),
    MaxSize = UDim2.new(0,769,0,514),
})
local obj = main.Screengui.Motherframe.Upline.UIGradient
spawn(function()
    while true do
        for i=0, 255 do
            obj.Color = ColorSequence.new(Color3.fromHSV(i/255, 1, 1), Color3.fromHSV((((i + 60 > 255 and i - 255) or i)+60)/255, 1, 1))
            wait(0.05)
        end;
    end
end)

_G.CurrentBarkUI = main.Screengui
local emain = main

local function confirm(x)
    if getgenv().disable_confirm then return true end
    emain.Screengui.Enabled = false
    --local tlib = loadstring(game:HttpGet("https://dogix.wtf/scripts/ui_library", true))()
    local tlib = loadstring(game:HttpGetAsync("https://cdn.applebee1558.com/bark/confirm-ui-lib.lua", 0))()
    tlib.options.underlinecolor = Color3.new(255,0,0)
    local w = tlib:CreateWindow("Confirmation")
    local confirmed = nil
    local Box = nil
    local array = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'}
    local rnum = ""
    for i=1,5 do
        rnum = rnum..array[math.random(1,#array)]
    end
    w:Section("To continue, type:")
    Box = w:Box(rnum, {flag = "confirming"; type = 'text';}, function(new, old, enter)
        if new == rnum then
            confirmed = true
        end
    end)
    local Cancel = w:Button("Cancel",function()
        confirmed = false
    end)
    repeat wait() until confirmed ~= nil
    Box.Parent.Parent.Parent.Parent.Parent.Parent.Container.Visible = false
    emain.Screengui.Enabled = true
    return confirmed
end

local wc = main:CreateCategory("Bark "..cv)
local opts2 = wc:CreateSection("Welcome to Bark "..cv.." | https://discord.gg/bark")


--teleporting
function _G.applebeeWMINCTP(cframe)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = cframe
end


--keybind handler

_G.GuiToggleKey = Enum.KeyCode.RightControl
_G.ClickTPKey = Enum.KeyCode.LeftControl
_G.SprintKey = Enum.KeyCode.LeftShift
_G.ZoomKey = Enum.KeyCode.Delete
local noclipkeyset = Enum.KeyCode.N
local flykeyset = Enum.KeyCode.Q

local m = game:GetService'Players'.LocalPlayer:GetMouse()
local can = false
local spam_jp = false
local toggle = true
local sprinting = false
local doclick = true

local keybinds = {
    [1] = _G.GuiToggleKey,
    [2] = Enum.KeyCode.RightShift,
    [3] = _G.ClickTPKey,
    [4] = doclick,
    [5] = noclipkeyset,
    [6] = flykeyset,
    [7] = _G.SprintKey
}
pcall(function()
    if readfile then
        if pcall(function()readfile('bark.winning.always.has.been')end) == true then
            local reconstructed = readfile('bark.winning.always.has.been'):split(',')
            for i,v in pairs (reconstructed) do
                if i ~= 4 then
                	for _,ae in pairs(Enum.KeyCode:GetEnumItems()) do
                		if ae.Value == tonumber(v) then
                		    reconstructed[i] = ae
            		    end
                	end
                end
            end
            _G.GuiToggleKey = reconstructed[1]
            _G.ClickTPKey = reconstructed[3]
            _G.SprintKey = reconstructed[7]
            doclick = reconstructed[4]=="true"
            noclipkeyset = reconstructed[5]
            flykeyset = reconstructed[6]
            keybinds = {
                [1] = _G.GuiToggleKey,
                [2] = reconstructed[2],
                [3] = _G.ClickTPKey,
                [4] = doclick,
                [5] = noclipkeyset,
                [6] = flykeyset,
                [7] = _G.SprintKey
            }
        end
    end
end)
opts2:Create(
    "KeyBind",
    "Toggle GUI Visibility",
    function(a)
        _G.GuiToggleKey = a
        if getgenv().alphax_ui_init then
            getgenv().alphax_ui_init:SetCloseBind(_G.GuiToggleKey)
        end
    end,
    {
        default = _G.GuiToggleKey
    }
)
if writefile then
    opts2:Create(
        "Button",
        "Save Keybinds",
        function()
            if pcall(function()readfile("bark.winning.always.has.been")end) ~= false then
                delfile("bark.winning.always.has.been")
            end
            keybinds[1] = _G.GuiToggleKey
            keybinds[3] = _G.ClickTPKey
            keybinds[4] = doclick
            keybinds[5] = noclipkeyset
            keybinds[6] = flykeyset
            local newkeybinds = keybinds
            for i=1,#newkeybinds do
                if i ~= 4 then
                    newkeybinds[i] = newkeybinds[i].Value
                elseif keybinds[i] == true then
                    newkeybinds[i] = "true"
                else
                    newkeybinds[i] = "false"
                end
            end
            writefile("bark.winning.always.has.been",table.concat(newkeybinds,","))
            notify("Keybind Handler", "Saved keybinds!",2)
        end,
        {
            animated = true,
        }
    )
end


--keybind: actual handling

_G.SetStats = {
    16;
    50;
    0;
    1.15;
	120;
	48;
	1;
	70;
}

local function getMouseTarget()
	local cursorPosition = game:GetService("UserInputService"):GetMouseLocation()
	--print'pen'
	return game.Workspace:FindPartOnRayWithIgnoreList(Ray.new(game.Workspace.CurrentCamera.CFrame.p,(game.Workspace.CurrentCamera:ViewportPointToRay(cursorPosition.x, cursorPosition.y, 0).Direction * 1000)),game.Players.LocalPlayer.Character:GetDescendants())
end
m.Button1Down:connect(function()
    if not toggle then return end
    if can and toggle then
        local angle = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame - game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Position
        _G.applebeeWMINCTP(CFrame.new(m.Hit.p)*angle+Vector3.new(0,3,0), true)
    end
end)

game:GetService('UserInputService').InputBegan:connect(function(ip, n)
    if ip.UserInputType == Enum.UserInputType.Keyboard and toggle then
        if ip.KeyCode == _G.ClickTPKey then
            if doclick == true then
                can = true
            else
                local angle = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame - game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Position
                _G.applebeeWMINCTP(CFrame.new(m.Hit.p)*angle+Vector3.new(0,3,0), true)
            end
        end
        if ip.KeyCode == Enum.KeyCode.Space and _G.ijp_toggle then
            spam_jp = true
        end
        if ip.KeyCode == _G.SprintKey then
            sprinting = true
        end
        if ip.KeyCode == _G.ZoomKey then
            zoom = true
        end
    end
end)
game:GetService('UserInputService').InputEnded:connect(function(ip, n)
    if ip.UserInputType == Enum.UserInputType.Keyboard and toggle then
        if ip.KeyCode == Enum.KeyCode.LeftControl then
            can = false
        end
        if ip.KeyCode == _G.GuiToggleKey then
            for i,v in pairs(game:GetService'CoreGui':children()) do
                if v.Name == "BarkUI" then
                    v.Enabled = not v.Enabled
                end
            end
        end
        if ip.KeyCode == Enum.KeyCode.Space and _G.ijp_toggle then
            spam_jp = false
        end
        if ip.KeyCode == _G.SprintKey then
            sprinting = false
        end
        if ip.KeyCode == _G.ZoomKey then
            zoom = false
            game.Workspace.CurrentCamera.FieldOfView = _G.SetStats[8]
        end
    end
end)

local rotate_func = getsenv(game.Players.LocalPlayer.PlayerGui.Scripts.DragClient).rotate
local ws_index = 0
for i, v in pairs(debug.getupvalues(rotate_func)) do
    if type(v) == 'number' and v==game.Players.LocalPlayer.Character.Humanoid.WalkSpeed then
		ws_index = i
	end
end

-- fix respawn breaking walkspeed
game.Players.LocalPlayer.CharacterAdded:Connect(function()
    repeat wait() until getsenv(game.Players.LocalPlayer.PlayerGui:WaitForChild("Scripts"):WaitForChild("DragClient")).rotate
    rotate_func = getsenv(game.Players.LocalPlayer.PlayerGui:WaitForChild("Scripts"):WaitForChild("DragClient")).rotate
end)
--main runservice loop
_G.MainRSLoop = game:GetService'RunService'.RenderStepped:connect(function()
    -- anti reversing
    --[[
    if not dbgmode then
        if game.CoreGui:FindFirstChild("DevConsoleMaster") then 
            game:GetService("CoreGui").DevConsoleMaster:Destroy()
        end
        for i, v in pairs(getconnections(game:GetService("ScriptContext").Error)) do
            if v.Disable then v:Disable() end
        end
    end
    ]]

    local plr = game:GetService'Players'.LocalPlayer
    local plrc = plr.Character
    local hmd = plr.Character:FindFirstChild('Humanoid')
    if hmd ~= nil then
        if (hmd.WalkSpeed ~= _G.SetStats[1] or hmd.WalkSpeed ~= _G.SetStats[6]) and hmd.WalkSpeed ~= 0 then
            if sprinting == false then
                --hmd.WalkSpeed = _G.SetStats[1]
                debug.setupvalue(rotate_func, ws_index, _G.SetStats[1])
            else
                --hmd.WalkSpeed = _G.SetStats[6]
                debug.setupvalue(rotate_func, ws_index, _G.SetStats[6])
            end
        end
        if hmd.JumpPower ~= _G.SetStats[2] then
            hmd.JumpPower = _G.SetStats[2]
        end
        if hmd.HipHeight ~= _G.SetStats[3] then
            hmd.HipHeight = _G.SetStats[3]
        end
         if zoom then
            game.Workspace.CurrentCamera.FieldOfView = 30
        else
            game.Workspace.CurrentCamera.FieldOfView = _G.SetStats[8]
        end
        if spam_jp then
            local function Action(Object, Function) if Object ~= nil then Function(Object); end end
            Action(hmd, function(self)
                if self:GetState() == Enum.HumanoidStateType.Jumping or self:GetState() == Enum.HumanoidStateType.Freefall then
                    Action(self.Parent.HumanoidRootPart, function(self)
                        self.Velocity = self.Velocity * Vector3.new(1,0,1) + Vector3.new(0, _G.SetStats[2], 0);
                    end)
                end
            end)
        end
    end
    
end)

--Player Utilities
local playerutils = main:CreateCategory("Player")
local tps = playerutils:CreateSection("Teleporting")
tps:Create(
    "TextBox",
    "Teleport to Player",
    function(input)
        local new = input:gsub('%s+','')
        if new ~= "" and new ~= nil then
            for _, v in pairs(game:GetService('Players'):GetPlayers()) do
                if v.Name:lower():find(new:lower()) then
                    local cf = v.Character.HumanoidRootPart.CFrame
            	    _G.applebeeWMINCTP(cf)
                end
            end
        end
    end,
    {
        text = ""
    }
)
local ctps = playerutils:CreateSection("Click Teleporting")
ctps:Create(
    "KeyBind",
    "Teleport Key",
    function(a)
        _G.ClickTPKey = a
    end,
    {
        default = _G.ClickTPKey
    }
)
ctps:Create(
    "Toggle",
    "Require Click for Teleport Key",
    function(a)
        doclick = a
        keybinds[4] = a
    end,
    {
        default = keybinds[4]
    }
)
ctps:Create(
    "Button",
    "Get Click Teleport Tool",
    function()
        local plr = game:GetService("Players").LocalPlayer
        local tool = Instance.new("Tool",plr.Backpack)
        tool.RequiresHandle = false
        tool.Name = "Click Teleport"
        tool.Activated:Connect(function()
            _G.applebeeWMINCTP(CFrame.new(plr:GetMouse().Hit.p)+Vector3.new(0,3,0))
        end)
    end,
    {
        default = false,
        animated = true
    }
)

--humanoid mods
local hmd = playerutils:CreateSection("Humanoid")
hmd:Create(
    "Slider",
    "Walk Speed",
    function(v)
        _G.SetStats[1] = tonumber(v)
    end,
    {
        min = 16,
        max = 100,
        default = 16,
        changablevalue = true
    }
)
hmd:Create(
    "KeyBind",
    "Sprint Key",
    function(a)
        _G.SprintKey = a
        keybinds[7] = a
    end,
    {
        default = keybinds[7]
    }
)
hmd:Create(
    "Slider",
    "Sprint Speed",
    function(v)
        _G.SetStats[6] = tonumber(v)
    end,
    {
        min = 16,
        max = 100,
        default = 48,
        changablevalue = true
    }
)

hmd:Create(
    "Slider",
    "Hip Height",
    function(v)
        _G.SetStats[3] = tonumber(v)
    end,
    {
        min = 0,
        max = 500,
        default = 0,
        changablevalue = true
    }
)

hmd:Create(
    "Slider",
    "Field of View",
    function(v)
        _G.SetStats[8] = v
        game.Workspace.CurrentCamera.FieldOfView = v
    end,
    {
        min = 50,
        max = 120,
        default = 70,
        changablevalue = true
    }
)

hmd:Create(
    "KeyBind",
    "Zoom Key",
    function(a)
        _G.ZoomKey = a
    end,
    {
        default = _G.ZoomKey
    }
)

hmd:Create(
    "Toggle",
    "Infinite Jump",
    function(state)
        _G.ijp_toggle = state
    end,
    {
        default = false
    }
)
hmd:Create(
    "Toggle",
    "Safe Suicide (Blocks axe dropping)",
    function(state)
        getgenv().block_tooldrop = state
    end,
    {
        animated = true,
    }
)
hmd:Create(
    "Button",
    "Safe Respawn",
    function()
        local orig = getgenv().block_tooldrop
        getgenv().block_tooldrop=true
        local plr = game.Players.LocalPlayer
        local plrc = plr.Character
        local oldc = plrc.HumanoidRootPart.CFrame
        local t = plrc.Head
        t.Parent = nil
        t.Parent = plrc
        plr.CharacterAdded:Wait()
        plr.Character:WaitForChild'HumanoidRootPart'
        wait(0.8)
        okinsta(oldc)
        getgenv().block_tooldrop = orig
    end,
    {
        animated = true,
    }
)
-- environment mods
local environment = main:CreateCategory("Environment")
local lighting = environment:CreateSection("Lighting")
-- no fog
lighting:Create("Toggle", "Disable Fog", function(state)
    if state then
        if game.Lighting:FindFirstChild("Atmosphere") then
            game.Lighting.Atmosphere.Parent = getgenv().LIGHTING_DISABLED_FOLDER
        end
        if game.Lighting:FindFirstChild("Sky") then
            game.Lighting.Sky.Parent = getgenv().LIGHTING_DISABLED_FOLDER
        end
    else
        for i, v in pairs(getgenv().LIGHTING_DISABLED_FOLDER:GetChildren()) do
            v.Parent = game.Lighting
        end
    end
end)
lighting:Create("Toggle", "Full Bright", function(state)
    if state then
        getgenv().FULLBRIGHT_BIND = game.Lighting.Changed:Connect(function ()
            if game.Lighting.ClockTime ~= 11 then
                game.Lighting.ClockTime = 11
                game.Lighting.Brightness = 0.8
                game.Lighting.Ambient = Color3.new(1, 1, 1)
                game.Lighting.OutdoorAmbient = Color3.new(1,1,1)
            end
        end)
    else
        if getgenv().FULLBRIGHT_BIND then
            getgenv().FULLBRIGHT_BIND:Disconnect()
            getgenv().FULLBRIGHT_BIND = nil
            game.Lighting.Ambient = Color3.new(70/255,70/255,70/255)
        end
    end
end)

local soundmods = environment:CreateSection("Sounds")
soundmods:Create("Toggle", "Night Sounds", function(state)
    game.Lighting.Night.Value = state
end)
soundmods:Create("Toggle", "Use Pre-Alpha Music", function(state)
    if state then
        game:GetService("ReplicatedStorage").Sounds.Music.Main.SoundId = "rbxassetid://2927108004"
    else
        game:GetService("ReplicatedStorage").Sounds.Music.Main.SoundId =  getgenv().change_lt2_audio_backup['Main']
    end
end)
soundmods:Create("Toggle", "Replace Sounds with LT2", function(state)
    local change_music_table = {
        ["Main"] = "http://www.roblox.com/asset/?id=261678778",
        ['Mountain'] = "http://www.roblox.com/asset/?id=269828329",
        ['Safari'] = "rbxassetid://281900798",
        ['Volcano'] = "http://www.roblox.com/asset/?id=269820276",
        ['VolcanoDangerous'] = "http://www.roblox.com/asset/?id=269820276",
        ['VolcanoSafe'] = "rbxassetid://281883645",
        ['Taiga'] = "rbxassetid://3283126671",

        ["WoodsWeR"] = "http://www.roblox.com/asset/?id=261679928",
        ['LandStore'] = "http://www.roblox.com/asset/?id=261761820",      
        ["Shack"] = "rbxassetid://281900798"
    }
    
    if state then
        for i, v in pairs(game:GetService("ReplicatedStorage").Sounds.Music:GetChildren()) do
            if change_music_table[v.Name] ~= nil then
                v.SoundId = change_music_table[v.Name]
            end
        end
    else
        for i, v in pairs(game:GetService("ReplicatedStorage").Sounds.Music:GetChildren()) do
            if getgenv().change_lt2_audio_backup[v.Name] ~= nil then
                v.SoundId = getgenv().change_lt2_audio_backup[v.Name]
            end
        end
    end
end)

local items = main:CreateCategory("Items")

local function tp_tree(model, pos, doloop)
    local wood = model:FindFirstChild("VWOOD")
    if wood and wood:IsA("BasePart") and wood.Name == "VWOOD" then
        if (wood.CFrame.p - game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.p).magnitude > 20 then
            _G.applebeeWMINCTP(wood.CFrame)
            wait(.2)
        end

        local dist = (wood.CFrame.p - pos.p).magnitude
        
        for i=0, 100 do
            _G.applebeeWMINCTP(wood.CFrame)
            if not wood.Parent or not wood.Parent.Parent then break end
            wood.Parent.PrimaryPart = wood
            game:GetService("ReplicatedStorage").Remotes.DragObject:FireServer(wood, wood.Position)
            wood.Parent:SetPrimaryPartCFrame(pos)
            wood.CFrame = pos
            game:GetService("RunService").RenderStepped:wait()
        end
    end
end

local wood_utils = items:CreateSection("Wood")
wood_utils:Create("Toggle", "Auto Chop", function (state)
    getgenv().autochoppe = state
end)
wood_utils:Create("Button", "Teleport All Trees (does not work 99% of time)", function()
    local currentcframe = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    for _, v in pairs(game.Workspace.LooseWood:GetChildren()) do
        if v:FindFirstChild("Owner") and v.Owner.Value == game.Players.LocalPlayer then
            tp_tree(v, currentcframe+Vector3.new(0, 10, 0))
        end
    end
    wait(.5)
    _G.applebeeWMINCTP(currentcframe)
end)
wood_utils:Create("Button", "Sell All Trees", function()
    local currentcframe = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    for _, v in pairs(game.Workspace.LooseWood:GetChildren()) do
        if v:FindFirstChild("Owner") and v.Owner.Value == game.Players.LocalPlayer then
            tp_tree(v, CFrame.new(94, 25, -146) * CFrame.Angles(math.rad(15), 0, 0))
        end
    end
    wait(.5)
    _G.applebeeWMINCTP(currentcframe)
end)

local drag_utils = items:CreateSection("Dragging")
drag_utils:Create("Button", "Hard Dragger", function ()
    if not getgenv().HARD_DRAG_ENABLED then
        getgenv().HARD_DRAG_ENABLED = true
        game.Workspace.TemporaryEffects.ChildAdded:connect(function(a)
            if a.Name == "DragWeld" then
                local bg = a:WaitForChild("BodyGyro")
                local bp = a:WaitForChild("BodyPosition")
                repeat
                    wait()
                    bp.P = 120000
                    bp.D = 1000
                    bp.maxForce = Vector3.new(1,1,1)*1000000
                    bg.maxTorque = Vector3.new(1, 1, 1) * 200
                    bg.P = 1200
                    bg.D = 140
                until not a
            end
        end)
    end
end)