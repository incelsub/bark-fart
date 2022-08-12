local gui = game:GetObjects("rbxassetid://6527673375")[1]
if PROTOSMASHER_LOADED or is_sirhurt_closure then 
  gui.Parent = get_hidden_gui() 
elseif syn then
  --fuck shitnapse x
  syn.protect_gui(gui)
  gui.Parent = game:GetService("CoreGui")
else
    gui.Parent = game:GetService("CoreGui")
end
getgenv().galaxybark = gui
--insert main script

--applebee's added re-skin and stuff
gui.Main.Navigation.Visible = false
gui.Main.Editor.CodeTabs.Visible = false
gui.Main.Editor.Position = UDim2.new(0, 5, 0, 10)
gui.Main.Editor.Size = UDim2.new(1, -10, 1, -60)
--gui.Main.Editor.Monaco.Position = UDim2.new(0,0,0,20)
local textbox = gui.Main.Editor.Monaco.Container.MonacoText

local function call_rpc(path, body, method)
    if method == nil then method = "GET" end
    if body then body = game.HttpService:JSONEncode(body) end
    local resp = http_request({Url="http://localhost:65021/rpc/"..path, Body=body, Method=method})
    local respjson = game.HttpService:JSONDecode(resp.Body)
    if respjson.code ~= nil and respjson.code ~= 200 then
        error("Bark Executor RPC Failure! "..resp.Body)
    end
    return respjson
end

gui.Main.Control.Execute.Activated:Connect(function()
    loadstring(textbox.Text)()
end)
gui.Main.Control.ExecuteFile.Activated:Connect(function()
    local success, resp = pcall(call_rpc, "selectfile-dialog", {title="Select Script"}, "POST")
    if not success then 
        return
    end
    loadstring(resp.content)()
end)
gui.Main.Control.LoadFile.Activated:Connect(function()
    local success, resp = pcall(call_rpc, "selectfile-dialog", {title="Select Script"}, "POST")
    if not success then 
        return
    end
    textbox.Text = resp.content
end)
gui.Main.Control.SaveFile.Activated:Connect(function()
    local success, resp = pcall(call_rpc, "savefile-dialog", {title="Select Location", content=textbox.Text}, "POST")
    if not success then 
        return
    end
end)
gui.Main.Control.Clear.Activated:Connect(function()
    textbox.Text = ""
end)
gui.Main.Header.Title.Text = "Bark Executor"
gui.Main.Header.User.Text = game.Players.LocalPlayer.Name
-- Galaxy Script
spawn(function()
    local script = gui.Galaxy
    local charset = {}  do
        for c = 48, 57  do table.insert(charset, string.char(c)) end
        for c = 65, 90  do table.insert(charset, string.char(c)) end
        for c = 97, 122 do table.insert(charset, string.char(c)) end
    end
    
    local function randomString(length)
        if not length or length <= 0 then return '' end
        math.randomseed(os.time()^5/math.random(1,5290)*9/62^27*3.1528*6*10^23*math.random(-86, 259))
        return randomString(length - 1) .. charset[math.random(1, #charset)]
    end
    
    local Galaxy = {}
    Galaxy.mainFrame = script.Parent.Main
    Galaxy.Editor = Galaxy.mainFrame.Editor
    Galaxy.CodeTabs = Galaxy.Editor.CodeTabs
    Galaxy.mainHeader = Galaxy.mainFrame.Header
    Galaxy.Navigation = Galaxy.mainFrame.Navigation
    Galaxy.ScriptBox = Galaxy.mainFrame.Editor.Monaco.Container.MonacoText
    Galaxy.Options = Galaxy.mainFrame.Options
    
    local UserInputService = game:GetService("UserInputService")
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        script.Parent.Main:TweenPosition(UDim2.new(startPos.X.Scale,startPos.X.Offset + delta.X,startPos.Y.Scale,startPos.Y.Offset + delta.Y),"Out", "Linear", 0.1, true)
    end
    Galaxy.mainHeader.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
            input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Galaxy.mainFrame.Position
    
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    Galaxy.mainHeader.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or
            input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)
    
    Galaxy.mainHeader.Exit.MouseButton1Click:Connect(function()
        script.Parent:Destroy()
        getgenv().galaxybark = nil
        return
    end)
    
    local mainFrameMinimized = false
    
    Galaxy.mainHeader.Minimize.MouseButton1Click:Connect(function()
        if mainFrameMinimized == false then
            mainFrameMinimized = true
            Galaxy.mainFrame:TweenSize(UDim2.new(0, 555, 0, 25), "In", "Linear", .25 )
            Galaxy.mainHeader.Minimize.Text = "+"
        else
            mainFrameMinimized = false
            Galaxy.mainFrame:TweenSize(UDim2.new(0, 555, 0, 387), "In", "Linear", .25 )
            Galaxy.mainHeader.Minimize.Text = "-"
        end
    end)
    
    spawn(function()
        script.Name = randomString(20)
    end)
end)

-- Main.Editor.MonacoLua
spawn(function()

    local script = gui.Main.Editor.MonacoLua

    local charset = {}  do
        for c = 48, 57  do table.insert(charset, string.char(c)) end
        for c = 65, 90  do table.insert(charset, string.char(c)) end
        for c = 97, 122 do table.insert(charset, string.char(c)) end
    end
    
    local function randomString(length)
        if not length or length <= 0 then return '' end
        math.randomseed(os.time()^5/math.random(1,5290)*9/62^27*3.1528*6*10^23*math.random(-86, 259))
        return randomString(length - 1) .. charset[math.random(1, #charset)]
    end
    
    local MonacoText = script.Parent.Monaco.Container.MonacoText
    local MonacoLines = script.Parent.Monaco.LinesContainer.MonacoLines
    
    local autoClosingPairs = {
        { open = '{', close = '}' },
        { open = '[', close = ']' },
        { open = '(', close = ')' },
        { open = '"', close = '"' },
        { open = '\'', close = '\'' },
    }
    local syntaxConfig = {
        lua_keywords = Color3.fromRGB(248, 109, 124),
        lua_builtin = Color3.fromRGB(0, 255, 255),
        lua_numbers = Color3.fromRGB(255, 198, 0),
        lua_strings = Color3.fromRGB(173, 241, 149),
        lua_comments = Color3.fromRGB(102, 102, 102),
        lua_operators = Color3.fromRGB(255, 255, 255),
        lua_iden = Color3.fromRGB(200, 200, 200),
    }
    
    local createdTabCount = 0
    local lvalue = 0
    function createTab(tabName, textCode)
        lvalue = lvalue + 1
        local newTab = script.Parent:WaitForChild("CodeTabs").ScriptTab:Clone()
        newTab.Visible = true
        newTab.Parent = script.Parent:WaitForChild("CodeTabs")
        newTab.Name = tabName
        newTab.ScriptName.Text = tabName
        newTab.Size = UDim2.new(0, 52 + newTab.ScriptName.TextBounds.X + 9, 0, 25)
        newTab.DeleteTab.MouseButton1Click:Connect(function()
            if lvalue ~= 1 then
                newTab:Destroy()
                lvalue = lvalue - 1
            end
        end)
        local click = tick()
        local TabInputFocused = false
        local saveText
        newTab.ScriptName.InputBegan:connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if tick() - click < 0.5 then
                        newTab.TabInput.Visible = true
                        newTab.TabInput.Text = ""
                        newTab.ScriptName.Visible = false
                        newTab.TabInput:CaptureFocus()
                    end
                    click = tick()
                end
            end)
        newTab.TabInput.Changed:Connect(function()
            if TabInputFocused == true then
                newTab.Size = UDim2.new(0, 52 + newTab.TabInput.TextBounds.X + 9, 0,25)
            end
            if newTab.TabInput then
                if string.len(newTab.TabInput.Text) > 20 then
                    newTab.TabInput.Text = string.sub(newTab.TabInput.Text, 1, 20)
                end
            end
        end)
        newTab.TabInput.Focused:Connect(function() TabInputFocused = true end)
        newTab.TabInput.FocusLost:Connect(function()
            TabInputFocused = false
            newTab.TabInput.Visible = false
            if newTab.TabInput.Text ~= "" then
                newTab.ScriptName.Text = newTab.TabInput.Text
                newTab.Name = newTab.TabInput.Text
            end
            newTab.ScriptName.Visible = true
            newTab.Size = UDim2.new(0, 52 + newTab.ScriptName.TextBounds.X + 9, 0, 25)
        end)
    end
    
    createdTabCount = 1
    createTab("Script " .. createdTabCount)
    
    script.Parent:WaitForChild("CodeTabs").NewTab.MouseButton1Click:Connect(function()
        createdTabCount = createdTabCount + 1
        createTab("Script " .. createdTabCount)
    end)
    
    for i,v in next, syntaxConfig do
        local newSyntax = Instance.new("TextLabel")
        newSyntax.TextSize = 15
        newSyntax.BackgroundTransparency = 1
        newSyntax.Parent = MonacoText
        newSyntax.TextColor3 = v
        newSyntax.Name = i
        newSyntax.Size = UDim2.new(1,0,1,0)
        newSyntax.Text = ""
        newSyntax.Font = Enum.Font.Code
        newSyntax.TextXAlignment = Enum.TextXAlignment.Left
        newSyntax.TextYAlignment = Enum.TextYAlignment.Top
        newSyntax.ZIndex = 5
    end
    
    local cacheText = MonacoText.Text
    local currentLineM = 0
    
    script.Parent.Monaco.Container.Changed:Connect(function()
        if script.Parent.Monaco.Container.CanvasPosition.Y < 3 then
            script.Parent.Monaco.Shadow.Visible = false
        else
            script.Parent.Monaco.Shadow.Visible = true
        end
        MonacoLines.Position = UDim2.new(0, 0, 0, 0 - script.Parent.Monaco.Container.CanvasPosition.Y)
        script.Parent.Monaco.LinesContainer.Size = UDim2.new(0, 63, 0, script.Parent.Monaco.LinesContainer.MonacoLines.TextBounds.Y)
    end)
    
    local function lineBoundary(text)
        local lineBoundaryl = Instance.new("TextLabel")
        lineBoundaryl.Parent = script.Parent
        lineBoundaryl.Visible = false
        lineBoundaryl.Font = Enum.Font.Code
        lineBoundaryl.TextSize = 15
        lineBoundaryl.Text = text
        lineBoundaryl.TextXAlignment = Enum.TextXAlignment.Left
        lineBoundaryl.TextYAlignment = Enum.TextYAlignment.Top
        lineBoundaryl.Size = MonacoText.Size
        local re = lineBoundaryl.TextBounds
        lineBoundaryl:Destroy()
        return re
    end
    
    function refreshMonaco()
        if MonacoText.CursorPosition ~= -1 then
            local lineA = 0
            local lineW = ""
            local mcl = string.sub(MonacoText.Text, 1, MonacoText.CursorPosition - 1)
            mcl:gsub(".", function(c)
                lineW = lineW..c
                if c == "\n" then
                    lineA = lineA + 1
                    lineW = ""
                end
            end)
            script.Parent.Monaco.Container.CharacterIndicator.Position = UDim2.new(0, lineBoundary(lineW).X + 4, 0, (15 * lineA) + 1)
        end
        
        if MonacoText.SelectionStart ~= -1 and string.len(MonacoText.Text) ~= 0 then
            script.Parent.Monaco.Container.CurrentLine.Visible = false
            local SelectionStart = math.min(MonacoText.CursorPosition, MonacoText.SelectionStart)
            local SelectionEnd = math.max(MonacoText.CursorPosition, MonacoText.SelectionStart)
            for _,v in next, script.Parent.Monaco.Container:GetChildren() do
                if v.Name == "Highlight" then
                    v:Destroy()
                end
            end
            local lineCount = 1
            MonacoText.Text:gsub(".", function(c)
                if c == "\n" then
                    lineCount = lineCount + 1
                end
            end)
            
            local newHighlight = Instance.new("Frame")
            newHighlight.Parent = script.Parent.Monaco.Container
            newHighlight.BackgroundTransparency = 0.85
            newHighlight.BackgroundColor3 = Color3.fromRGB(80, 170, 255)
            newHighlight.Size = UDim2.new(0, 50, 0, 18)
            newHighlight.Position = UDim2.new(0, 0, 0, -2)
            newHighlight.BorderSizePixel = 0
            newHighlight.Name = "Highlight"
            newHighlight.ZIndex = 1
        else
            script.Parent.Monaco.Container.CurrentLine.Visible = true
            for _,v in next, script.Parent.Monaco.Container:GetChildren() do
                if v.Name == "Highlight" then
                    v:Destroy()
                end
            end
        end
        
        script.Parent.Monaco.Container.CanvasSize = UDim2.new(0, MonacoText.TextBounds.X + 20, 0, 240 + MonacoText.TextBounds.Y)
        
        MonacoLines.Position = UDim2.new(0, 0, 0, 0-script.Parent.Monaco.Container.CanvasPosition.Y)
        
        script.Parent.Monaco.LinesContainer.Size = UDim2.new(0, 63, 0, script.Parent.Monaco.LinesContainer.MonacoLines.TextBounds.Y)
        
        local lin = 1
        MonacoText.Text:gsub("\n", function()
            lin = lin + 1
        end)
        
        MonacoLines.Text = ""
        for i = 1, lin do
            MonacoLines.Text = MonacoLines.Text .. i .. "\n"
        end
        
        local selectOffset = 0
        string.sub(MonacoText.Text, 1, MonacoText.CursorPosition - 1):gsub("\n", function()
            selectOffset = selectOffset + 1
        end)
        if MonacoText.CursorPosition ~= - 1 then
            script.Parent.Monaco.Container.CurrentLine.Position = UDim2.new(0, 0, 0, 15*selectOffset)
        end
        currentLineM = selectOffset
        
        if cacheText == MonacoText.Text then
            return
        end
        
        for _,v in next, autoClosingPairs do
            if string.sub(MonacoText.Text, MonacoText.CursorPosition - 1, MonacoText.CursorPosition - 1) == v.open then
                if string.sub(MonacoText.Text, MonacoText.CursorPosition, MonacoText.CursorPosition) ~= v.close and string.sub(MonacoText.Text, MonacoText.CursorPosition + 1, MonacoText.CursorPosition + 1) ~= v.close then
                    if string.len(MonacoText.Text) == string.len(cacheText) + 1 then
                        MonacoText.Text = string.sub(MonacoText.Text, 1, MonacoText.CursorPosition - 1) .. v.close .. string.sub(MonacoText.Text, MonacoText.CursorPosition)
                    end
                    elseif string.sub(MonacoText.Text, MonacoText.CursorPosition - 2, MonacoText.CursorPosition - 2) == v.open and string.sub(MonacoText.Text, MonacoText.CursorPosition, MonacoText.CursorPosition) == v.close and string.sub(MonacoText.Text, MonacoText.CursorPosition + 1, MonacoText.CursorPosition + 1) ~= v.close then
                    if string.len(MonacoText.Text) == string.len(cacheText) + 1 then
                        MonacoText.Text = string.sub(MonacoText.Text, 1, MonacoText.CursorPosition - 1) .. v.close .. string.sub(MonacoText.Text, MonacoText.CursorPosition)
                    end
                end
            end
            if string.len(MonacoText.Text) == string.len(cacheText) - 1 then
                if string.sub(cacheText, MonacoText.CursorPosition, MonacoText.CursorPosition) == v.open and string.sub(cacheText, MonacoText.CursorPosition + 1, MonacoText.CursorPosition + 1) == v.close then
                    MonacoText.Text = string.sub(MonacoText.Text, 1, MonacoText.CursorPosition - 1) .. string.sub(MonacoText.Text, MonacoText.CursorPosition + 1)
                end
            end
            
            if string.sub(MonacoText.Text, MonacoText.CursorPosition - 1, MonacoText.CursorPosition - 1) == v.close then
                if string.sub(MonacoText.Text, MonacoText.CursorPosition, MonacoText.CursorPosition) == v.close then
                    if string.len(MonacoText.Text) == string.len(cacheText) + 1 then
                        MonacoText.Text = string.sub(MonacoText.Text, 1, MonacoText.CursorPosition - 1) .. string.sub(MonacoText.Text, MonacoText.CursorPosition + 1)
                    end
                end
            end
        end
        
        cacheText = MonacoText.Text
        
        local MonacoSource = MonacoText.Text
        function get_fRYRpgNnPmbIG2mez62Z()
            local a={}local b,c=coroutine.yield,coroutine.wrap;local d=string.find;local e=string.sub;local f=table.insert;local type=type;local g="^[%+%-]?%d+%.?%d*[eE][%+%-]?%d+"local h="^[%+%-]?%d+%.?%d*"local i="^0x[%da-fA-F]+"local j="^%d+%.?%d*[eE][%+%-]?%d+"local k="^%d+%.?%d*"local l="^[%a_][%w_]*"local m="^%s+"local n="^(['\"])%1"local o=[[^(['"])(\*)%2%1]]local p=[[^(['"]).-[^\](\*)%2%1]]local q="^(['\"]).-.*"local r="^%[(=*)%[.-%]%1%]"local s="^%[%[.-.*"local t="^''"local u=[[^'(\*)%1']]local v=[[^'.-[^\](\*)%1']]local w="^#.-[^\\]\n"local x="^%-%-%[(=*)%[.-%]%1%]"local y="^%-%-%[%[.-.*"local z="^%-%-.-\n"local A="^%-%-.-.*"local B={["and"]=true,["break"]=true,["do"]=true,["else"]=true,["elseif"]=true,["end"]=true,["false"]=true,["for"]=true,["function"]=true,["if"]=true,["in"]=true,["local"]=true,["nil"]=true,["not"]=true,["while"]=true,["or"]=true,["repeat"]=true,["return"]=true,["then"]=true,["true"]=true,["self"]=true,["until"]=true}local C={["assert"]=true,["collectgarbage"]=true,["error"]=true,["_G"]=true,["gcinfo"]=true,["getfenv"]=true,["getmetatable"]=true,["ipairs"]=true,["loadstring"]=true,["newproxy"]=true,["next"]=true,["pairs"]=true,["pcall"]=true,["print"]=true,["rawequal"]=true,["rawget"]=true,["rawset"]=true,["select"]=true,["setfenv"]=true,["setmetatable"]=true,["tonumber"]=true,["tostring"]=true,["type"]=true,["unpack"]=true,["_VERSION"]=true,["xpcall"]=true,["delay"]=true,["elapsedTime"]=true,["require"]=true,["spawn"]=true,["tick"]=true,["time"]=true,["typeof"]=true,["UserSettings"]=true,["wait"]=true,["warn"]=true,["game"]=true,["Enum"]=true,["script"]=true,["shared"]=true,["workspace"]=true,["Axes"]=true,["BrickColor"]=true,["CFrame"]=true,["Color3"]=true,["ColorSequence"]=true,["ColorSequenceKeypoint"]=true,["Faces"]=true,["Instance"]=true,["NumberRange"]=true,["NumberSequence"]=true,["NumberSequenceKeypoint"]=true,["PhysicalProperties"]=true,["Random"]=true,["Ray"]=true,["Rect"]=true,["Region3"]=true,["Region3int16"]=true,["TweenInfo"]=true,["UDim"]=true,["UDim2"]=true,["Vector2"]=true,["Vector3"]=true,["Vector3int16"]=true,["next"]=true,["os"]=true,["os.time"]=true,["os.date"]=true,["os.difftime"]=true,["debug"]=true,["debug.traceback"]=true,["debug.profilebegin"]=true,["debug.profileend"]=true,["math"]=true,["math.abs"]=true,["math.acos"]=true,["math.asin"]=true,["math.atan"]=true,["math.atan2"]=true,["math.ceil"]=true,["math.clamp"]=true,["math.cos"]=true,["math.cosh"]=true,["math.deg"]=true,["math.exp"]=true,["math.floor"]=true,["math.fmod"]=true,["math.frexp"]=true,["math.ldexp"]=true,["math.log"]=true,["math.log10"]=true,["math.max"]=true,["math.min"]=true,["math.modf"]=true,["math.noise"]=true,["math.pow"]=true,["math.rad"]=true,["math.random"]=true,["math.randomseed"]=true,["math.sign"]=true,["math.sin"]=true,["math.sinh"]=true,["math.sqrt"]=true,["math.tan"]=true,["math.tanh"]=true,["coroutine"]=true,["coroutine.create"]=true,["coroutine.resume"]=true,["coroutine.running"]=true,["coroutine.status"]=true,["coroutine.wrap"]=true,["coroutine.yield"]=true,["string"]=true,["string.byte"]=true,["string.char"]=true,["string.dump"]=true,["string.find"]=true,["string.format"]=true,["string.len"]=true,["string.lower"]=true,["string.match"]=true,["string.rep"]=true,["string.reverse"]=true,["string.sub"]=true,["string.upper"]=true,["string.gmatch"]=true,["string.gsub"]=true,["table"]=true,["table.concat"]=true,["table.insert"]=true,["table.remove"]=true,["table.sort"]=true}local function D(E)return b(E,E)end;local function F(E)return b("number",E)end;local function G(E)return b("string",E)end;local function H(E)return b("comment",E)end;local function I(E)return b("space",E)end;local function J(E)if B[E]then return b("keyword",E)elseif C[E]then return b("builtin",E)else return b("iden",E)end end;local K={{l,J},{m,I},{i,F},{j,F},{k,F},{n,G},{o,G},{p,G},{q,G},{r,G},{s,G},{x,H},{y,H},{z,H},{A,H},{"^==",D},{"^~=",D},{"^<=",D},{"^>=",D},{"^%.%.%.",D},{"^%.%.",D},{"^.",D}}local L=#K;function a.scan(M)local function N(O)local P=0;local Q=#M;local R=1;local function S(T)while T do local U=type(T)if U=="table"then T=b("","")for V=1,#T do local W=T[V]T=b(W[1],W[2])end elseif U=="string"then local X,Y=d(M,T,R)if X then local E=e(M,X,Y)R=Y+1;T=b("",E)else T=b("","")R=Q+1 end else T=b(P,R)end end end;S(O)P=1;while true do if R>Q then while true do S(b())end end;for V=1,L do local Z=K[V]local _=Z[1]local a0=Z[2]local a1={d(M,_,R)}local X,Y=a1[1],a1[2]if X then local E=e(M,X,Y)R=Y+1;a.finished=R>Q;local T=a0(E,a1)if E:find("\n")then local a2,a3=E:gsub("\n",{})P=P+a3 end;S(T)break end end end end;return c(N)end;return a
        end
        local fRYRpgNnPmbIG2mez62Z = get_fRYRpgNnPmbIG2mez62Z()
        --local fRYRpgNnPmbIG2mez62Z = require(script.Parent.fRYRpgNnPmbIG2mez62Z)
        
        for _,v in next, MonacoText:GetChildren() do
            v.Text = ""
        end
    
        local lua_keywords = MonacoText:WaitForChild("lua_keywords")
        local lua_builtin = MonacoText:WaitForChild("lua_builtin")
        local lua_numbers = MonacoText:WaitForChild("lua_numbers")
        local lua_strings = MonacoText:WaitForChild("lua_strings")
        local lua_comments = MonacoText:WaitForChild("lua_comments")
        local lua_operators = MonacoText:WaitForChild("lua_operators")
        local lua_iden = MonacoText:WaitForChild("lua_iden")
        
        for token,src in fRYRpgNnPmbIG2mez62Z.scan(MonacoSource) do
            if token == "keyword" then
                lua_keywords.Text = lua_keywords.Text .. src
            else
                src:gsub('.', function(c)
                    if c ~= '\n' and c ~= '\t' then
                        lua_keywords.Text = lua_keywords.Text .. '\32'
                    elseif c == '\n' then
                        lua_keywords.Text = lua_keywords.Text .. '\n'
                    elseif c == '\t' then
                        lua_keywords.Text = lua_keywords.Text .. '\t'
                    end
                end)
            end
            
            if token == "builtin" then
                lua_builtin.Text = lua_builtin.Text .. src
            else
                src:gsub('.', function(c)
                    if c ~= '\n' and c ~= '\t' then
                        lua_builtin.Text = lua_builtin.Text .. '\32'
                    elseif c == '\n' then
                        lua_builtin.Text = lua_builtin.Text .. '\n'
                    elseif c == '\t' then
                        lua_builtin.Text = lua_builtin.Text .. '\t'
                    end
                end)
            end
            
            if token == "iden" then
                lua_iden.Text = lua_iden.Text .. src
            else
                src:gsub('.', function(c)
                    if c ~= '\n' and c ~= '\t' then
                        lua_iden.Text = lua_iden.Text .. '\32'
                    elseif c == '\n' then
                        lua_iden.Text = lua_iden.Text .. '\n'
                    elseif c == '\t' then
                        lua_iden.Text = lua_iden.Text .. '\t'
                    end
                end)
            end
            
            if token == "string" then
                lua_strings.Text = lua_strings.Text .. src
            else
                src:gsub('.', function(c)
                    if c ~= '\n' and c ~= '\t' then
                        lua_strings.Text = lua_strings.Text .. '\32'
                    elseif c == '\n' then
                        lua_strings.Text = lua_strings.Text .. '\n'
                    elseif c == '\t' then
                        lua_strings.Text = lua_strings.Text .. '\t'
                    end
                end)
            end
            
            
            if token == "number" then
                lua_numbers.Text = lua_numbers.Text .. src
            else
                src:gsub('.', function(c)
                    if c ~= '\n' and c ~= '\t' then
                        lua_numbers.Text = lua_numbers.Text .. '\32'
                    elseif c == '\n' then
                        lua_numbers.Text = lua_numbers.Text .. '\n'
                    elseif c == '\t' then
                        lua_numbers.Text = lua_numbers.Text .. '\t'
                    end
                end)
            end
            
            if token == "comment" then
                lua_comments.Text = lua_comments.Text .. src
            else
                src:gsub('.', function(c)
                    if c ~= '\n' and c ~= '\t' then
                        lua_comments.Text = lua_comments.Text .. '\32'
                    elseif c == '\n' then
                        lua_comments.Text = lua_comments.Text .. '\n'
                    elseif c == '\t' then
                        lua_comments.Text = lua_comments.Text .. '\t'
                    end
                end)
            end
            
            if token == src then
                lua_operators.Text = lua_operators.Text .. src
            else
                src:gsub('.', function(c)
                    if c ~= '\n' and c ~= '\t' then
                        lua_operators.Text = lua_operators.Text .. '\32'
                    elseif c == '\n' then
                        lua_operators.Text = lua_operators.Text .. '\n'
                    elseif c == '\t' then
                        lua_operators.Text = lua_operators.Text .. '\t'
                    end
                end)
            end
        end
    end
    
    spawn(function()
        while true do
            if script.Parent.Monaco.Container.MonacoText:IsFocused() then
                script.Parent.Monaco.Container.CharacterIndicator.Visible = not script.Parent.Monaco.Container.CharacterIndicator.Visible
                if script.Parent.Monaco.Container.MonacoText.SelectionStart ~= - 1 then
                    script.Parent.Monaco.Container.CharacterIndicator.Visible = false
                end
            end
            wait(0.5)
        end
    end)
    
    MonacoText.Changed:Connect(refreshMonaco)
    MonacoText.Focused:Connect(function()
        script.Parent.Monaco.Container.CharacterIndicator.Visible = true
    end)
    MonacoText.FocusLost:Connect(function()
        script.Parent.Monaco.Container.CharacterIndicator.Visible = false
        for _,v in next, script.Parent.Monaco.Container:GetChildren() do
            if v.Name == "Highlight" then
                v:Destroy()
            end
        end
    end)
    
    MonacoText.SelectionLost:Connect(function()
        for _,v in next, script.Parent.Monaco.Container:GetChildren() do
            if v.Name == "Highlight" then
                v:Destroy()
            end
        end
    end)
    
    spawn(function()
        script.Name = randomString(20)
    end)
end)