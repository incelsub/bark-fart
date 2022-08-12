local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")

ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.new(0.098, 0.459, 1)
Frame.BackgroundTransparency = 0.8
Frame.BorderColor3 = Color3.new(0.09, 0.137, 0.776)
Frame.BorderSizePixel = 2
Frame.Position = UDim2.new(0, 0, 0, 0)
Frame.Size = UDim2.new(0, 0, 0, 0)

local Mouse = game.Players.LocalPlayer:GetMouse()
local Run = game:GetService("RunService")
local Player = game.Players.LocalPlayer
local userinputservice = game:GetService("UserInputService")
local camera = game.Workspace.CurrentCamera

function is_in_frame(screenpos, frame)
    return screenpos.X >= frame.AbsolutePosition.X and screenpos.X <= frame.AbsolutePosition.X + frame.AbsoluteSize.X and screenpos.Y >= frame.AbsolutePosition.Y and screenpos.Y <= frame.AbsolutePosition.Y + frame.AbsoluteSize.Y 
end

local selected = {}
userinputservice.InputBegan:connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Frame.Visible = true
        Frame.Position = UDim2.new(0,Mouse.X,0,Mouse.Y)
        while userinputservice:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
            Run.RenderStepped:wait()
            Frame.Size = UDim2.new(0,Mouse.X,0,Mouse.Y) - Frame.Position
            for i,v in pairs(game.Workspace.PlayerModels:GetChildren()) do
                if v:FindFirstChild("Main") then
                    local screenpos, visible = camera:WorldToScreenPoint(v.Main.CFrame.p)
                    if visible then
                        if is_in_frame(screenpos, Frame) then
                            local a = Instance.new("BoxHandleAdornment", v.Main)
                            a.Name = "Selection"
                            a.Adornee = a.Parent
                            --a.AlwaysOnTop = true
                            a.ZIndex = 0
                            a.Size = a.Parent.Size
                            a.Transparency = 0.3
                            a.Color = BrickColor.new("Electric blue")
                        else
                            if v.Main:FindFirstChild("Selection") then
                                v.Main.Selection:Destroy()
                            end
                        end
                    else
                        if v.Main:FindFirstChild("Selection") then
                            v.Main.Selection:Destroy()
                        end
                    end
                end
            end
        end
        print("released")
        
        Frame.Size = UDim2.new(0,1,0,1)
        Frame.Visible = false
    end
end)
