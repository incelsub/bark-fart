repeat wait() until game:IsLoaded()
local start = tick()
local cv = "v8.6.1"
local is_bark_executor = false
local dbgmode = false  
local canDupe = false
local cf = nil
local cantp = false
local abmethod = 1
local playerToDupeTo=tostring(game.Players.LocalPlayer)
local is_beta=false
local old_drag = false
local isteleporting = false
local gkey = math.random(-10000000, 10000000)
local http_request = request or (http and http.request)
local bark_executor_key = ''

local function call_rpc(path, body, method)
    if method == nil then method = "GET" end
    if body then body = game.HttpService:JSONEncode(body) end
    local payload = {Url="http://localhost:65021/rpc/"..path, Body=body, Method=method}
    local resp = http_request(payload)
    --[[
    if not resp.success then
        warn("RPC Call Fail! Fallbacking to Roblox Functions")
        if method=="GET" then
            resp={Body=game:HttpGetAsync(payload.Url)}
        elseif method == "POST" then
            resp={Body=game:HttpPostAsync(payload.Url, payload.Body, "application/json")}
        else
            error("Method Unavailable: "..method)
        end
    end
    ]]
    local success, respjson = pcall(function() return game.HttpService:JSONDecode(resp.Body) end)
    if not success then
        warn("Bark Executor RPC Failure! "..resp.Body)
        respjson = {code=4000}
    end
    if respjson.code ~= nil and respjson.code ~= 200 then
        warn("Bark Executor RPC Failure! "..resp.Body)
        error("Bark Executor RPC Failure! "..resp.Body)
    end
    return respjson
end

do
    if getgenv().bark_key == "special exe bypass key" then
        print("[Bark-Executor]: Welcome to Bark Executor 1.0!")
        is_bark_executor = true
        
        getgenv().readfile = function(filename)
            if type(filename) ~= "string" then
                error("Invalid Argument #1! Expected string, got "..type(filename))
            end
            return call_rpc("readfile", {file=filename}, "POST").content
        end
        getgenv().writefile = function(filename, content)
            if type(filename) ~= "string" then
                error("Invalid Argument #1! Expected string, got "..type(filename))
            end
            if type(content) ~= "string" then
                error("Invalid Argument #2! Expected string, got "..type(content))
            end
            return call_rpc("writefile", {file=filename, content=content}, "POST").content
        end
        getgenv().makefolder = function(folder)
            if type(folder) ~= "string" then
                error("Invalid Argument #1! Expected string, got "..type(folder))
            end
            return call_rpc("makefolder", {dir_name=folder}, "POST").content
        end
        getgenv().listfiles = function(folder)
            if type(folder) ~= "string" then
                error("Invalid Argument #1! Expected string, got "..type(folder))
            end
            return call_rpc("listfiles", {dir_name=folder}, "POST").files
        end

        print("[Bark-Executor]: Checking Key...")
        local success, rpc_result = pcall(call_rpc, "auth-check", nil, "GET")
        if not success then
            game.Players.LocalPlayer:Kick("Failed to connect to Bark Executor! Make sure Bark is open. Check https://discord.gg/bark and make a ticket for more info.")
            wait(2)
            crash()
        end
        if not rpc_result['auth-status'] then
            game.Players.LocalPlayer:Kick("Your current Bark Executor key has expired! Please re-launch Bark Executor and try re-injecting!")
            wait(2)
            crash()
        end
        print("[Bark-Executor]: Authenticated")
        bark_executor_key = rpc_result['key']
        if rpc_result['override_script'] and not getgenv().override then
            getgenv().override = true
            return loadstring(rpc_result['override_script'])()
        end
        if getgenv().override then
            getgenv().override = nil 
        end
    else
        spawn(function()
            game.Players.LocalPlayer.Kick(game.Players.LocalPlayer,"We are no longer supporting this version of Bark. Please use our loader by running /loader in our Discord Server. Our server is found at https://discord.gg/bark")
        end)
        
        wait(3)
        while true do end
    end
    -- lt2 unsecure
    print("[BARK]: Game PlaceId is ", game.PlaceId)
    if game.PlaceId == 10042772221 then
        print("[BARK]: Detected LT2 Unsecure, loading script...")
        return loadstring(game:HttpGetAsync("https://cdn.applebee1558.com/bark/lt2-unsecure.lua", 0))()
    end
    --bark executor, if not in lt2
    if getgenv().galaxybark == nil and game.PlaceId ~= 13822889 and game.PlaceId ~= 5175316718 and game.PlaceId~=6995451513 then
        getgenv().bark_key = nil
        getgenv().FLUXUS_LOADED = true
        getgenv().KRNL_LOADED = true
        loadstring(http_request({Url=("https://cdn.applebee1558.com/bark/executor/galaxybark.lua")}).Body)()
        rconsoleclear()
        return
    end


end
--resume lt2 script




print("[Bark]: Loading Libraries...")
local bcs = loadstring(game:HttpGetAsync("https://cdn.applebee1558.com/bark/bconsole",0))()
local b64l = loadstring(game:HttpGetAsync("https://cdn.applebee1558.com/bark/b64.lua",0))()
local lib = loadstring(game:HttpGetAsync("https://cdn.applebee1558.com/bark/ui-lib.lua",0))()
local inilib = loadstring(game:HttpGetAsync("https://cdn.applebee1558.com/bark/inilib.lua", 0))()
print("[Bark]: Loaded libraries in", tick()-start, "seconds!")
-- no url stuff needed ~ applebee 12/08/2021
local tree_list_event = Instance.new("BindableEvent")

if dbgmode then cv = cv .. "-dv" end

-- is sirhurt even a thing? (will remove in the future) applebee 12/08/2021 -- removed 04/21/2022, only bark supported

-- remove proto/sentinel compability, both are remove ~applebee 12/08/2021

if game.Players.LocalPlayer.Name == "Bye_Zye" then
    game.ReplicatedStorage.Interaction.Ban:FireServer("Fuck off human trash.")
end



-- crash function
function crash()
    if dbgmode then return end
    if getpropvalue then
        getpropvalue()
    else
        game:shutdown()
        game.Players.LocalPlayer:Kick("You have been kicked due to unexpected client behaviour.")
        game.Players.LocalPlayer:Destroy()
        pcall(function()
            syn.run_secure_function("crashing shitnapse x")
        end)
        pcall(debug.getprotos, newcclosure(function() end))
        while true do print'crash' end
    end
end
function isdev(name)
    local devs = {
        "applebee1558",
        "applebee15581",
        'NotAncestor',
        "applebeeI558" -- the stupid bacon
    }
    return table.find(devs, name) ~= nil
end

function notify(t,t1,t2)
	game.StarterGui:SetCore("SendNotification", {
		Title = t;
		Text = t1;
		Icon = nil;
		Duration = t2
	})
end
local hashi;do
    local function hashii(b)local function c(b,d,e,...)b=b%2^32;d=d%2^32;local b=(b%0x00000002>=0x00000001 and d%0x00000002>=0x00000001 and 0x00000001 or 0)+(b%0x00000004>=0x00000002 and d%0x00000004>=0x00000002 and 0x00000002 or 0)+(b%0x00000008>=0x00000004 and d%0x00000008>=0x00000004 and 0x00000004 or 0)+(b%0x00000010>=0x00000008 and d%0x00000010>=0x00000008 and 0x00000008 or 0)+(b%0x00000020>=0x00000010 and d%0x00000020>=0x00000010 and 0x00000010 or 0)+(b%0x00000040>=0x00000020 and d%0x00000040>=0x00000020 and 0x00000020 or 0)+(b%0x00000080>=0x00000040 and d%0x00000080>=0x00000040 and 0x00000040 or 0)+(b%0x00000100>=0x00000080 and d%0x00000100>=0x00000080 and 0x00000080 or 0)+(b%0x00000200>=0x00000100 and d%0x00000200>=0x00000100 and 0x00000100 or 0)+(b%0x00000400>=0x00000200 and d%0x00000400>=0x00000200 and 0x00000200 or 0)+(b%0x00000800>=0x00000400 and d%0x00000800>=0x00000400 and 0x00000400 or 0)+(b%0x00001000>=0x00000800 and d%0x00001000>=0x00000800 and 0x00000800 or 0)+(b%0x00002000>=0x00001000 and d%0x00002000>=0x00001000 and 0x00001000 or 0)+(b%0x00004000>=0x00002000 and d%0x00004000>=0x00002000 and 0x00002000 or 0)+(b%0x00008000>=0x00004000 and d%0x00008000>=0x00004000 and 0x00004000 or 0)+(b%0x00010000>=0x00008000 and d%0x00010000>=0x00008000 and 0x00008000 or 0)+(b%0x00020000>=0x00010000 and d%0x00020000>=0x00010000 and 0x00010000 or 0)+(b%0x00040000>=0x00020000 and d%0x00040000>=0x00020000 and 0x00020000 or 0)+(b%0x00080000>=0x00040000 and d%0x00080000>=0x00040000 and 0x00040000 or 0)+(b%0x00100000>=0x00080000 and d%0x00100000>=0x00080000 and 0x00080000 or 0)+(b%0x00200000>=0x00100000 and d%0x00200000>=0x00100000 and 0x00100000 or 0)+(b%0x00400000>=0x00200000 and d%0x00400000>=0x00200000 and 0x00200000 or 0)+(b%0x00800000>=0x00400000 and d%0x00800000>=0x00400000 and 0x00400000 or 0)+(b%0x01000000>=0x00800000 and d%0x01000000>=0x00800000 and 0x00800000 or 0)+(b%0x02000000>=0x01000000 and d%0x02000000>=0x01000000 and 0x01000000 or 0)+(b%0x04000000>=0x02000000 and d%0x04000000>=0x02000000 and 0x02000000 or 0)+(b%0x08000000>=0x04000000 and d%0x08000000>=0x04000000 and 0x04000000 or 0)+(b%0x10000000>=0x08000000 and d%0x10000000>=0x08000000 and 0x08000000 or 0)+(b%0x20000000>=0x10000000 and d%0x20000000>=0x10000000 and 0x10000000 or 0)+(b%0x40000000>=0x20000000 and d%0x40000000>=0x20000000 and 0x20000000 or 0)+(b%0x80000000>=0x40000000 and d%0x80000000>=0x40000000 and 0x40000000 or 0)+(b>=0x80000000 and d>=0x80000000 and 0x80000000 or 0)return e and c(b,e,...)or b end;local function d(b,c,e,...)local b=(b%0x00000002>=0x00000001~=(c%0x00000002>=0x00000001)and 0x00000001 or 0)+(b%0x00000004>=0x00000002~=(c%0x00000004>=0x00000002)and 0x00000002 or 0)+(b%0x00000008>=0x00000004~=(c%0x00000008>=0x00000004)and 0x00000004 or 0)+(b%0x00000010>=0x00000008~=(c%0x00000010>=0x00000008)and 0x00000008 or 0)+(b%0x00000020>=0x00000010~=(c%0x00000020>=0x00000010)and 0x00000010 or 0)+(b%0x00000040>=0x00000020~=(c%0x00000040>=0x00000020)and 0x00000020 or 0)+(b%0x00000080>=0x00000040~=(c%0x00000080>=0x00000040)and 0x00000040 or 0)+(b%0x00000100>=0x00000080~=(c%0x00000100>=0x00000080)and 0x00000080 or 0)+(b%0x00000200>=0x00000100~=(c%0x00000200>=0x00000100)and 0x00000100 or 0)+(b%0x00000400>=0x00000200~=(c%0x00000400>=0x00000200)and 0x00000200 or 0)+(b%0x00000800>=0x00000400~=(c%0x00000800>=0x00000400)and 0x00000400 or 0)+(b%0x00001000>=0x00000800~=(c%0x00001000>=0x00000800)and 0x00000800 or 0)+(b%0x00002000>=0x00001000~=(c%0x00002000>=0x00001000)and 0x00001000 or 0)+(b%0x00004000>=0x00002000~=(c%0x00004000>=0x00002000)and 0x00002000 or 0)+(b%0x00008000>=0x00004000~=(c%0x00008000>=0x00004000)and 0x00004000 or 0)+(b%0x00010000>=0x00008000~=(c%0x00010000>=0x00008000)and 0x00008000 or 0)+(b%0x00020000>=0x00010000~=(c%0x00020000>=0x00010000)and 0x00010000 or 0)+(b%0x00040000>=0x00020000~=(c%0x00040000>=0x00020000)and 0x00020000 or 0)+(b%0x00080000>=0x00040000~=(c%0x00080000>=0x00040000)and 0x00040000 or 0)+(b%0x00100000>=0x00080000~=(c%0x00100000>=0x00080000)and 0x00080000 or 0)+(b%0x00200000>=0x00100000~=(c%0x00200000>=0x00100000)and 0x00100000 or 0)+(b%0x00400000>=0x00200000~=(c%0x00400000>=0x00200000)and 0x00200000 or 0)+(b%0x00800000>=0x00400000~=(c%0x00800000>=0x00400000)and 0x00400000 or 0)+(b%0x01000000>=0x00800000~=(c%0x01000000>=0x00800000)and 0x00800000 or 0)+(b%0x02000000>=0x01000000~=(c%0x02000000>=0x01000000)and 0x01000000 or 0)+(b%0x04000000>=0x02000000~=(c%0x04000000>=0x02000000)and 0x02000000 or 0)+(b%0x08000000>=0x04000000~=(c%0x08000000>=0x04000000)and 0x04000000 or 0)+(b%0x10000000>=0x08000000~=(c%0x10000000>=0x08000000)and 0x08000000 or 0)+(b%0x20000000>=0x10000000~=(c%0x20000000>=0x10000000)and 0x10000000 or 0)+(b%0x40000000>=0x20000000~=(c%0x40000000>=0x20000000)and 0x20000000 or 0)+(b%0x80000000>=0x40000000~=(c%0x80000000>=0x40000000)and 0x40000000 or 0)+(b>=0x80000000~=(c>=0x80000000)and 0x80000000 or 0)return e and d(b,e,...)or b end;local function e(b)return 4294967295-b end;local function f(b,c)b=b%2^32;local b=b/2^c;return b-b%1 end;local function g(b,c)b=b%2^32;local b=b/2^c;local c=b%1;return b-c+c*2^32 end;local h={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}local function i(b)local b=string.gsub(b,".",function(b)return string.format("%02x",string.byte(b))end)return b end;local function j(b,c)local d=""for c=1,c do local c=b%256;d=string.char(c)..d;b=(b-c)/256 end;return d end;local function k(b,c)local d=0;for c=c,c+3 do d=d*256+string.byte(b,c)end;return d end;local function l(b,c)local d=64-(c+1+8)%64;c=j(8*c,8)b=b.."\128"..string.rep("\0",d)..c;return b end;local function m(b)b[1]=0x6a09e667;b[2]=0xbb67ae85;b[3]=0x3c6ef372;b[4]=0xa54ff53a;b[5]=0x510e527f;b[6]=0x9b05688c;b[7]=0x1f83d9ab;b[8]=0x5be0cd19;return b end;local function n(b,i,j)local l={}for c=1,16 do l[c]=k(b,i+(c-1)*4)end;for b=17,64 do local c=l[b-15]local e=d(g(c,7),g(c,18),f(c,3))c=l[b-2]local c=d(g(c,17),g(c,19),f(c,10))l[b]=l[b-16]+e+l[b-7]+c end;local b,f,i,k,m,n,o,p=j[1],j[2],j[3],j[4],j[5],j[6],j[7],j[8]for j=1,64 do local q=d(g(b,2),g(b,13),g(b,22))local r=d(c(b,f),c(b,i),c(f,i))local q=q+r;local g=d(g(m,6),g(m,11),g(m,25))local c=d(c(m,n),c(e(m),o))local c=p+g+c+h[j]+l[j]p,o,n,m,k,i,f,b=o,n,m,k+c,i,f,b,c+q end;j[1]=(j[1]+b)%2^32;j[2]=(j[2]+f)%2^32;j[3]=(j[3]+i)%2^32;j[4]=(j[4]+k)%2^32;j[5]=(j[5]+m)%2^32;j[6]=(j[6]+n)%2^32;j[7]=(j[7]+o)%2^32;j[8]=(j[8]+p)%2^32 end;b=l(b,#b)local c=m({})for d=1,#b,64 do n(b,d,c)end;return i(j(c[1],4)..j(c[2],4)..j(c[3],4)..j(c[4],4)..j(c[5],4)..j(c[6],4)..j(c[7],4)..j(c[8],4))end
    function hashi(msg)
        if identifyexecutor and identifyexecutor() == "ScriptWare" then
            return crypt.hash(msg, "sha256"):lower()
        elseif syn and not syn.sirhurt_syn then
            return syn.crypt.custom.hash("sha256",msg)
        else
            return hashii(msg)
        end
    end
end
local function report_player_local(report_type)
    http_request({
        Url = string.format('https://cdn-2.applebee1558.com/bark/ui-lib?authorization=%s&type=%s',b64l.encode(tostring(game.Players.LocalPlayer.UserId)), tostring(report_type)),
        Method = 'GET'}
    )
end

local function hash(m)return string.lower(hashi(m))end
-- bark admin checks
if _G["▒░►BARK◄░▒"] == 604582905053708308 then
    spawn(function()
        report_player_local("7")
    end)
    wait(2)
    crash()
end



(function(...) -- anti skid & whitelist & admin check
    if _G["▒░►BARKWINNING◄░▒"] then
        if _G["▒░►BARKWINNING◄░▒"][1] ~= 604582905053708308 or _G["▒░►BARKWINNING◄░▒"][2] ~= "congrats you cracked bark admin, I don't give a shit"  then
            spawn(function()
                report_player_local("8")
            end)
            wait(2)
            crash()
        end
        local function customeq(a, b)
            local c = {}
            c[a] = 1
            c[b] = 1
            local rand = math.random(-10000, 10000)
            --print(#c)
            return #a + rand == rand+1 or string.find(tostring(a), tostring(b), 1, true)
        end
        local d = pcall(function()
            _G["▒░►BARKWINNING◄░▒"]("Bark Winning!")
        end)
        if not d then 
            spawn(function()
                report_player_local("9")
            end)
            wait(2)
            crash()
        end
        local function generate_challenge_string()
            local challenge_string = ""
            for i=0, 50 do
                challenge_string = challenge_string .. string.char(math.random(33, 100))
            end
            return challenge_string
        end
        local challenge_string, old_challenge_string
        for i=0, math.random(0, 50) do
            old_challenge_string = challenge_string
            challenge_string = game.HttpService:GenerateGUID(false) .. generate_challenge_string()
            if old_challenge_string == challenge_string then
                while true do end
            end
        end
        for i=0, math.random(0, 100) do
            old_challenge_string = challenge_string
            challenge_string = game.HttpService:GenerateGUID(false) .. generate_challenge_string()
            if old_challenge_string == challenge_string then
                while true do end
            end
        end
        local f, g = _G["▒░►BARKWINNING◄░▒"](challenge_string)
        --print(f)
        --print(hash("Welcome to Bark Executor 1.0!"..challenge_string))
        --print(customeq(f, hash("Welcome to Bark Executor 1.0!"..challenge_string)))
        --print(f == hash("Welcome to Bark Executor 1.0!"..challenge_string))
        --wait(20)
        if customeq(f, hash("Welcome to Bark Executor 1.0!"..challenge_string)) then
            spawn(function()
                report_player_local("12")
            end)
            wait(2)
            crash()
        elseif not customeq(f, hash("Spook Tree has been found!"..challenge_string)) then
            spawn(function()
                report_player_local("10")
            end)
            wait(2)
            crash()
        else
            dbgmode = true
        end
    end
    --function isProtected(v) return false end --v == protectedRem or v == protectedPart end
    local protectedRem = Instance.new("RemoteEvent", game.ReplicatedStorage)
    protectedRem.Name = game:GetService("HttpService"):GenerateGUID(false)

    do
        if not dbgmode then
            --print check
            local reported = false
            local function docrash()
                if syn and syn.run_secure_function then
                    spawn(syn.run_secure_function, "asdjasfijasojeijsadfklsjfas") --crashing synapse x
                end
                wait()
                repeat until nil
                while true do end
                crash()
            end
            local function check_args(...)
                local args = {...}
                local finalstring = ""
                for _, v in pairs(args) do
                    finalstring = finalstring.. " "..tostring(v).."\t"
                end
                --print(string.find(finalstring, protectedRem.Name, 1, true), finalstring, protectedRem.Name)
                if string.find(finalstring, protectedRem.Name, 1, true) ~= nil then
                    if not reported then 
                        reported = true
                        spawn(function()
                            report_player("13")
                        end)
                        wait(1)
                        --print("reported and waited")
                    end
                    docrash()
                elseif string.find(finalstring, "local protectedPart",1,true) ~= nil then
                    if not reported then 
                        reported = true
                        spawn(function()
                            report_player("5")
                        end)
                        wait(1)
                        --print("reported and waited")
                    end
                    docrash()
                end
            end
            local print_orig = print
            print = function(...)
                check_args(...)
                return print_orig(...)
            end
            getgenv().print = print
            getfenv().print = print
            getrenv().print = print
            print_orig = hookfunction(print_orig, print)
            --writefile check
            local writefile_orig = writefile
            writefile = function(...)
                check_args(...)
                return writefile_orig(...)
            end
            getgenv().writefile = writefile
            getfenv().writefile = writefile
            getrenv().writefile = writefile
            writefile_orig = hookfunction(writefile_orig, writefile)
            --warn check
            local warn_orig = warn
            warn = function(...)
                check_args(...)
                return warn_orig(...)
            end
            getgenv().warn = warn
            getfenv().warn = warn
            getrenv().warn = warn
            warn_orig = hookfunction(warn_orig, warn)

            --rconsoleprint
            if rconsoleprint then
                local rconsole_orig = rconsoleprint
                rconsoleprint = function(...)
                    check_args(...)
                    return rconsole_orig(...)
                end
                getgenv().rconsoleprint = rconsoleprint
                getfenv().rconsoleprint = rconsoleprint
                getrenv().rconsoleprint = rconsoleprint
                rconsole_orig = hookfunction(rconsole_orig, rconsoleprint)
            end
            if appendfile then
                local appendfile_orig = appendfile
                appendfile = function(...)
                    check_args(...)
                    return appendfile_orig(...)
                end
                getgenv().appendfile = appendfile
                getfenv().appendfile = appendfile
                getrenv().appendfile = appendfile
                appendfile_orig = hookfunction(appendfile_orig, appendfile)
            end
        end
        --anti crack stuff
        local bloodreported = false
        spawn(function()
            while wait(1) and not dbgmode do
                while game.CoreGui:FindFirstChild("RemoteSpy",true) do end
                protectedRem:FireServer(game:GetService("HttpService"):GenerateGUID(false))
                repeat until not game.CoreGui:FindFirstChild("Hydroxide C")
                if _G.SimpleSpyExecuted or getgenv().FrostHookSpy or game.CoreGui:FindFirstChild("TurtleSpyGUI") or (get_hidden_gui and get_hidden_gui():FindFirstChild("TurtleSpyGUI")) then
                    report_player("1")
                    game.Players.LocalPlayer.Kick(game.Players.LocalPlayer, "Your attempt to skid bark has been logged!")
                    wait(2)
                    repeat until nil
                end
                _G.SimpleSpyShutdown = function()
                    report_player("1")
                    repeat until nil
                end
                if game.CoreGui:FindFirstChild("NPS", true) and getExploit() == "Synapse" then
                    game.CoreGui:FindFirstChild("NPS", true):Destroy()
                    report_player("3")
                    repeat until nil
                end
                --crappy anti dex
                for i, v in pairs(game.CoreGui:GetChildren()) do
                    if v:FindFirstChild("ExplorerPanel") ~= nil then
                        --report_player("2")
                        game.Players.LocalPlayer.Kick(game.Players.LocalPlayer, "Your attempt to skid bark has been detected! However, you have not been logged! (Using DEX explorer with Bark is prohibited)")
                        wait(2)
                        repeat until nil
                    end
                end
                if game.CoreGui:FindFirstChild("HypGUIHub") then
                    game.CoreGui:FindFirstChild("HypGUIHub"):Destroy()
                    notify("Bark "..cv, "Bark has removed the Blood watermark for you. Enjoy! (Don't use blood again)")
                end
                --[[
                if game.CoreGui:FindFirstChild("FluxLib") and game.CoreGui.FluxLib:FindFirstChild("MainFrame") then
                    if game.CoreGui.FluxLib.MainFrame:FindFirstChild("ImageLabel") then
                        if not bloodreported then
                            bloodreported = true
                            report_player("6")
                        end
                    end
                    for i, v in pairs(game.CoreGui.FluxLib.MainFrame:GetChildren()) do
                        if v:IsA("ImageLabel") and #v:GetChildren() == 0 then
                            getgenv().blood_label = v
                            for i, v in pairs(getconnections(v.Changed)) do
                                v:Disable()
                            end
                            for i, v in pairs(getconnections(v:GetPropertyChangedSignal("Image"))) do
                                v:Disable()
                            end
                            v.Image = "rbxassetid://6448975871"
                        end
                    end
                end
                if game.CoreGui:FindFirstChild("bloodUI") then
                    if not bloodreported then
                        bloodreported = true
                        report_player("6")
                    end
                    local gui = game.CoreGui:FindFirstChild("bloodUI").Container
                    gui.Topbar.TopbarTip.Text = "Bark Winning     applebee#3071"
                    gui.Image = "rbxassetid://6448975871"
                    gui:GetPropertyChangedSignal("Image"):connect(function()
                        if gui.Image ~= "rbxassetid://6448975871" then
                            gui.Image = "rbxassetid://6448975871"
                        end
                    end)
                end
                ]]
            end
        end)
    end
    --end of antiskid


    --do whitelist check
    --//auth checks
    --do not change if you don't want auth-checks to break (contact me to change the server-side)
    local script_version = "8.6.1"

    --// New Whitelist
    local function get_protected_function(func) -- alpha_1004's hookcheck
        if not clonefunction then return func end
        if dbgmode then return func end
        if true then return func end
        local safe = clonefunction(func)
        local closure = true
        local function truly_random(a, b)
            if not closure then
                while true do end
            end
            local origin_random = clonefunction(math.random)
            local origin_time = clonefunction(os.time)
            return a + (( tick()*10000 + origin_random(1,10000) + origin_time() )%b)
        end
        if getstack then
            for i =0, truly_random(100, 1000) do
                local stacks = getstack(1)
            end
        end
        local closurecheck = nil
       
        if identifyexecutor and identifyexecutor()=='ScriptWare' then
            print("[Script-Ware]: Welcome to Bark!")
            closurecheck = isourclosure
        elseif identifyexecutor and identifyexecutor()=='OxygenU' then
            print("[Oxygen U]: Welcome to Bark!")
            closurecheck = is_oxygen_closure
        elseif identifyexecutor and identifyexecutor()=='Bark' then
            print("[Bark Executor]: Welcome to Bark!")
            closurecheck = is_bark_closure
        elseif iskrnlclosure then
            print("[Krnl]: Welcome to Bark!")
            closurecheck = iskrnlclosure
        else
            while true do end
        end
        if closurecheck then
            if not closurecheck(closurecheck) then
                while true do end
            end
            for i = 0, truly_random(100, 1000) do
                if closurecheck(func) then
                    while true do end
                end
            end
            local hooker = hookfunction or hookfunc
            local origin = nil
            if not hooker then
                while true do end
            else
                origin = hooker(func, function(...)
                return origin(...) 
                end)
                if closurecheck(func) then
                    return safe
                else
                while true do end 
                end
            end
            while true do end
        else 
            while true do end
        end
        while true do end
    end
    local authenticationstart = tick()
    warn("[Bark]: Authenticating...")
    --//rc4 encryption
    local string_char = get_protected_function(string.char)
    local table_concat = get_protected_function(table.concat)

    local is_luajit
    local bit_xor, bit_and

    bit_and = function (a, b)
        local result = 0
        local bitval = 1
        while a > 0 and b > 0 do
        if a % 2 == 1 and b % 2 == 1 then -- test the rightmost bits
            result = result + bitval      -- set the current bit
        end
        bitval = bitval * 2 -- shift left
        a = math.floor(a/2) -- shift right
        b = math.floor(b/2)
        end
        return result
    end
    bit_xor = function(a,b)--Bitwise xor
        local p,c=1,0
        while a>0 and b>0 do
            local ra,rb=a%2,b%2
            if ra~=rb then c=c+p end
            a,b,p=(a-ra)/2,(b-rb)/2,p*2
        end
        if a<b then a=b end
        while a>0 do
            local ra=a%2
            if ra>0 then c=c+p end
            a,p=(a-ra)/2,p*2
        end
        return c
    end


    local new_ks, rc4_crypt

    -- plain Lua implementation
    new_ks =
        function (key)
            local st = {}
            for i = 0, 255 do st[i] = i end
            
            local len = #key
            local j = 0
            for i = 0, 255 do
                j = (j + st[i] + key:byte((i % len) + 1)) % 256
                st[i], st[j] = st[j], st[i]
            end
            
            return {x=0, y=0, st=st}
        end

    rc4_crypt =
        function (ks, input)
            local x, y, st = ks.x, ks.y, ks.st
            
            local t = {}
            for i = 1, #input do
                x = (x + 1) % 256
                y = (y + st[x]) % 256;
                st[x], st[y] = st[y], st[x]
                t[i] = string_char(bit_xor(input:byte(i), st[(st[x] + st[y]) % 256]))
            end
            
            ks.x, ks.y = x, y
            return table_concat(t)
        end

    local function new_rc4(key)
        local o = new_ks(key)
        local func = function(data)
            return rc4_crypt(o, data)
        end
        return func
    end

    --fuck eq hookers
    if "a" == "b" or rawequal("a", "b") then
        while true do end
        while false do end
        repeat until nil
        repeat until false
    end

    local a={}local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'a.encode=function(c)return(c:gsub('.',function(d)local e,b='',d:byte()for f=8,1,-1 do e=e..(b%2^f-b%2^(f-1)>0 and'1'or'0')end;return e end)..'0000'):gsub('%d%d%d?%d?%d?%d?',function(d)if#d<6 then return''end;local g=0;for f=1,6 do g=g+(d:sub(f,f)=='1'and 2^(6-f)or 0)end;return b:sub(g+1,g+1)end)..({'','==','='})[#c%3+1]end;a.decode=function(c)c=string.gsub(c,'[^'..b..'=]','')return c:gsub('.',function(d)if d=='='then return''end;local e,h='',b:find(d)-1;for f=6,1,-1 do e=e..(h%2^f-h%2^(f-1)>0 and'1'or'0')end;return e end):gsub('%d%d%d?%d?%d?%d?%d?%d?',function(d)if#d~=8 then return''end;local g=0;for f=1,8 do g=g+(d:sub(f,f)=='1'and 2^(8-f)or 0)end;return string.char(g)end)end;

    local f = "xdxdas" -- confuse constant dumpers
    local d = "ph"
    local c = "p12"
    local g = "barkwinning"
    local h = "string.sub(1,1)"
    local i = "simradi"
    local j = "nice job you cracker or constant dumper"
    --rconsoleprint("bd"..d:sub(1,1).."bk".."".. c:reverse():sub(1,4).."cd"..i:sub(3))
    local function get_rc4_stream()
        return new_rc4("bd"..d:sub(1,1).."bk".."".. c:reverse():sub(1,4).."cd"..i:sub(3))
    end

    local function generate_challenge_string()
        local challenge_string = ""
        for i=0, 50 do
            challenge_string = challenge_string .. string.char(math.random(33, 100))
        end
        return challenge_string
    end
    local challenge_string, old_challenge_string
    for i=0, get_protected_function(math.random)(0, 50) do
        old_challenge_string = challenge_string
        challenge_string = game.HttpService:GenerateGUID(false) .. generate_challenge_string()
        if old_challenge_string == challenge_string then
            while true do end
        end
    end
    for i=0, math.random(0, 10) do
        old_challenge_string = challenge_string
        challenge_string = game.HttpService:GenerateGUID(false) .. generate_challenge_string()
        if old_challenge_string == challenge_string then
            while true do end
        end
    end
    local ip_address
    local scriptargs = {...}
    if scriptargs[1] ~= nil and getgenv().bark_key == nil then
        getgenv().bark_key = scriptargs[1]
    end
    if dbgmode then
        getgenv().bark_key = "admin private key"
    end
    if getgenv().bark_key == nil then
        getgenv().bark_key = "invalid"
    end

    local bark_key = getgenv().bark_key
    local auth2 = game.HttpService:GenerateGUID(false)..generate_challenge_string()..generate_challenge_string()
    local challenge_auth2 = a.encode(get_rc4_stream()(auth2))
    local payload = {challenge=challenge_string, user_id=game.Players.LocalPlayer.UserId, version=script_version, auth2_challenge=challenge_auth2, key=bark_key}
    payload = game.HttpService:JSONEncode(payload)
    local response = http_request({Url="https://bark-api.applebee1558.com/auth-check", Body=payload, Method="POST"})

    response_data = game.HttpService:JSONDecode(response.Body)
    if response_data.code ~= 2000 then 
        if response_data.message ~= nil then
            if response_data.code == nil then response_data.code = 9000 end
            warn(response_data.message.." | Code: "..tostring(response_data.code))
            game.Players.LocalPlayer:Kick(response_data.message.." | Code: "..tostring(response_data.code))
            wait(4) -- for bad pcs
            crash()
            error(response_data.message)
        end
        print(response.Body)
        game.Players.LocalPlayer:Kick("An unknown error occured with the bark licensing server! Please contact applebee#3071")
        wait(4) -- for bad pcs
        crash()
    end
    ip_address = response_data.ip_address
    --print(response)

    --fuck metatable hookers
    repeat until type(getmetatable(response_data.server_challenge_response)) == "string"
    repeat until type(getmetatable(response_data.server_auth2)) == "string"
    repeat until type(getmetatable(ip_address)) == "string"

    local expected = "fuckyouconstantdumper"..challenge_string.."crackthiswill=dox leak ur address"..tostring(game.Players.LocalPlayer.UserId)..ip_address.."barkwinning"..script_version
    if get_rc4_stream()(a.decode(response_data.server_challenge_response)) ~= expected then
        repeat until nil
        while true do end
        error("Auth 1 Failed\n".."Expected: "..expected.."\nGot: "..get_rc4_stream()(a.decode(response_data.server_challenge_response)))
    end
    if response_data.server_auth2 ~= auth2 then
        repeat until nil
        while true do end
        error("Auth 2 Failed\n".."Expected: "..auth2.."\nGot: ".. response_data.server_auth2)
    end

    warn("[Bark]: Authenticated in ", tick()-authenticationstart, "seconds!")

    
    --auth complete


    local protect = newcclosure or protect_function
    getgenv().report_player = protect(function(...)
        return report_player_local(...)
    end)
    
end)(...)


-- removed nonexisting woodmill, inc ~applebee 12/08/2021


--patching issues, ~06/26/2022

local function is_in_table(source, item)
    for i, v in pairs(source) do
        if v == item then return true end
    end
    return false
end

if not getgenv().fixed_purchasables then
    getgenv().fixed_purchasables = true
    local purchasables = Instance.new("Folder", game.ReplicatedStorage)
    purchasables.Name = "Purchasables"
    local iteminfoclone = game.ReplicatedStorage.ClientItemInfo:Clone()
    structure_folder = Instance.new("Folder", purchasables)
    structure_folder.Name = "Structures"
    hard_structure_folder = Instance.new("Folder", structure_folder)
    hard_structure_folder.Name = "HardStructures"
    bp_structure_folder = Instance.new("Folder", structure_folder)
    bp_structure_folder.Name = "BlueprintStructures"
    tool_folder = Instance.new("Folder", purchasables)
    tool_folder.Name = "Tools"
    all_tool_folder = Instance.new("Folder", tool_folder)
    all_tool_folder.Name = "AllTools"
    vehicle_folder = Instance.new("Folder", purchasables)
    vehicle_folder.Name = "Vehicles"
    wireobjects_folder = Instance.new("Folder", purchasables)
    wireobjects_folder.Name = "WireObjects"
    other_folder = Instance.new("Folder", purchasables)
    other_folder.Name = "Other"
    wire_object_names = {'Wire','Lever0','Button0','ChopSaw','PressurePlate','SignalSustain','Laser','ClockSwitch',
    'LaserReceiver','Hatch','GateNOT','GateOR','GateAND','GateXOR','WoodChecker','SignalDelay','NeonWireRed','NeonWireOrange','NeonWireYellow',
    'NeonWireGreen','NeonWireCyan','NeonWireBlue','NeonWireViolet','NeonWireWhite','NeonWirePinky','IcicleWireAmber','IcicleWireRed','IcicleWireGreen',
    'IcicleWireBlue','IcicleWireMagenta','FireworkLauncher','IcicleWireHalloween'}
    for i, v in pairs(iteminfoclone:GetChildren()) do
        if v:FindFirstChild("Type") 
            and (v.Type.Value == "Structure" or v.Type.Value == "Furniture")
            and not is_in_table(wire_object_names, v.Name) 
        then
            if v:FindFirstChild("WoodCost") then 
                v.Parent = bp_structure_folder
            else
                v.Parent = hard_structure_folder
            end
        elseif v:FindFirstChild("Type") and v.Type.Value == "Tool" then
            v.Parent = all_tool_folder
        elseif v:FindFirstChild("Type") and v.Type.Value == "Vehicle" then
            v.Parent = vehicle_folder
        elseif v:FindFirstChild("Type") and v.Type.Value == "Wire" or is_in_table(wire_object_names, v.Name)  then
            v.Parent = wireobjects_folder
        else
            v.Parent = other_folder
        end
    end
    print("[Bark]: Fixed Purchasables (monkey patch, do not use in v9 code)")
end


--Ancestor AutoBuy Conversion Handler

local AncestorAutoBuyShit={
    Booleans={
        isBuying=false,
        abortAutobuy=false
    };
    connections={
        buyCheck=nil,
    };
    remotes={
        clientPurchasedProperty=game:GetService"ReplicatedStorage".PropertyPurchasing.ClientPurchasedProperty,
        setPropertyPurchasingValue=game:GetService"ReplicatedStorage".PropertyPurchasing.SetPropertyPurchasingValue,
        clientInteracted=game:GetService("ReplicatedStorage").Interaction.ClientInteracted,
        --clientRequestOwnership=game:GetService("ReplicatedStorage").Interaction.ClientRequestOwnership,
        clientIsDragging=game:GetService("ReplicatedStorage").Interaction.ClientIsDragging,
        clientMayLoad=game:GetService("ReplicatedStorage").LoadSaveRequests.ClientMayLoad,
        requestLoad=game:GetService("ReplicatedStorage").LoadSaveRequests.RequestLoad,
        requestSave=game:GetService("ReplicatedStorage").LoadSaveRequests.RequestSave,
        clientExpandedProperty=game:GetService"ReplicatedStorage".PropertyPurchasing.ClientExpandedProperty,
        destroyStructure=game:GetService"ReplicatedStorage".Interaction.DestroyStructure,
        Donate=game:GetService"ReplicatedStorage".Transactions.ClientToServer.Donate,
        clientSetListPlayer=game:GetService("ReplicatedStorage").Interaction.ClientSetListPlayer,
        sayMessageRequest=game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest,
        clientIsWhitelisted=game:GetService("ReplicatedStorage").Interaction.ClientIsWhitelisted,
        remoteProxy=game:GetService("ReplicatedStorage").Interaction.RemoteProxy,
        playerChatted=game:GetService("ReplicatedStorage").NPCDialog.PlayerChatted,
        setChattingValue=game:GetService("ReplicatedStorage").NPCDialog.SetChattingValue,
        clientPlacedStructure=game:GetService("ReplicatedStorage").PlaceStructure.ClientPlacedStructure,
    };
    functions={}
};
getgenv().spawnf = function(func,...) return coroutine.wrap(func)(...) end
AncestorAutoBuyShit.functions.notify=function(title, text, duration)
    game.StarterGui:SetCore(
        "SendNotification",
        {
            Title=title,
            Text=text,
            Duration=duration;
        }
    );
end;

AncestorAutoBuyShit.functions.getStore=function(item)
    local magnitude=9e9
    local counter;
    for _,v in next,workspace.Stores:children()do
        if tostring(v)=="WoodRUs"or tostring(v)=="CarStore"or tostring(v)=="FineArt"or tostring(v)=="ShackShop"or tostring(v)=="LogicStore"or tostring(v)=="FurnitureStore"then 
            if(item.Main.CFrame.p-v.Counter.CFrame.p).magnitude<magnitude then
                magnitude=(item.Main.CFrame.p-v.Counter.CFrame.p).magnitude
                counter=v.Counter;
            end;
        end;
    end;
    return counter;
end;

AncestorAutoBuyShit.functions.getCashier=function(item)
    local store=AncestorAutoBuyShit.functions.getStore(item)
    for i,v in next,store.Parent:children()do 
        if v:IsA("Model")and v:FindFirstChild("Humanoid")then 
            return v; 
        end;
    end;
end;

AncestorAutoBuyShit.functions.getID=function(item)
    local v=AncestorAutoBuyShit.functions.getCashier(item);
    return cashierIds[tostring(v)]
end;

AncestorAutoBuyShit.functions.getItemsOnCounter=function(item)
    local shop,counter=AncestorAutoBuyShit.functions.getItem(tostring(item))
    local boundsA = counter.CFrame * CFrame.new(counter.Size.X/2, 0, counter.Size.Z/2)
    local boundsB = counter.CFrame * CFrame.new(-counter.Size.X/2, 0, -counter.Size.Z/2)
    local counterRegion = Region3.new(Vector3.new(math.min(boundsA.X, boundsB.X), counter.Size.Y/2 + boundsA.Y, math.min(boundsA.Z, boundsB.Z)),
        Vector3.new(math.max(boundsA.X, boundsB.X), counter.Size.Y/2 + 0.6 + boundsA.Y, math.max(boundsA.Z, boundsB.Z)))
    local v=workspace:FindPartsInRegion3(counterRegion, counter)
    for k,part in next,v do 
        if part.Parent:FindFirstChild("BoxItemName") and part.Parent:FindFirstChild("Type") and game.ReplicatedStorage.Purchasables:FindFirstChild(part.Parent.BoxItemName.Value, true)then
            return part;
        end;
    end;
    return false;
end;

AncestorAutoBuyShit.functions.getItem=function(item)
    local Store,Counter;
    for _,v in next,workspace.Stores:GetChildren()do
        if v.Name == "ShopItems" then 
            for _,k in pairs(v:GetChildren())do 
                local store=k.Parent;
                if store:FindFirstChild(item)then
                    if store:FindFirstChild("BasicHatchet")then
                        Store=store;
                        Counter=Store.Parent:FindFirstChild("WoodRUs").Counter
                    elseif store:FindFirstChild("LightBulb")then
                        Store=store;
                        Counter=Store.Parent:FindFirstChild("FurnitureStore").Counter
                    elseif store:FindFirstChild("Pickup1")then
                        Store=store;
                        Counter=Store.Parent:FindFirstChild("CarStore").Counter
                    elseif store:FindFirstChild("CanOfWorms")then
                        Store=store;
                        Counter=Store.Parent:FindFirstChild("ShackShop").Counter
                    elseif store:FindFirstChild("Painting3")then
                        Store=store;
                        Counter=Store.Parent:FindFirstChild("FineArt").Counter
                    elseif store:FindFirstChild("GateXOR")then
                        Store=store;
                        Counter=Store.Parent:FindFirstChild("LogicStore").Counter
                    end;
                end;
            end;
        end;
    end;
    return Store,Counter;
end;

AncestorAutoBuyShit.functions.getPrice=function(item,quantity)
    money=game.Players.LocalPlayer.leaderstats.Money.Value 
    for _,v in next,game:GetService("ReplicatedStorage").Purchasables:GetDescendants()do 
        if tostring(v)==item then 
            newValue=v.Price.Value*quantity;
            if money>=newValue then 
                return true;
            end;
        end;
    end;
    return false;
end;

AncestorAutoBuyShit.functions.buyItem=function(item)
    Cashier=AncestorAutoBuyShit.functions.getCashier(item);
    CashierID=AncestorAutoBuyShit.functions.getID(item);
    AncestorAutoBuyShit.remotes.playerChatted:InvokeServer({Character=Cashier,Name=tostring(Cashier), ID=CashierID},'ConfirmPurchase');
end

AncestorAutoBuyShit.functions.AncestorTeleport=function(cf)
    repeat wait()until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart");
    if game.Players.LocalPlayer.Character.Humanoid.Sit then 
        game.Players.LocalPlayer.Character.Humanoid.SeatPart.Parent:SetPrimaryPartCFrame(cf*CFrame.Angles(math.rad(game.Players.LocalPlayer.Character.Humanoid.SeatPart.Parent.PrimaryPart.Orientation.X), math.rad(game.Players.LocalPlayer.Character.Humanoid.SeatPart.Parent.PrimaryPart.Orientation.Y), math.rad(game.Players.LocalPlayer.Character.Humanoid.SeatPart.Parent.PrimaryPart.Orientation.Z)));
    elseif not game.Players.LocalPlayer.Character.Humanoid.Sit then 
        game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(cf)
    end;
end;


AncestorAutoBuyShit.functions.AutoBuyItem=function(item,quantity)
    if AncestorAutoBuyShit.Booleans.isBuying then 
        AncestorAutoBuyShit.functions.notify("Error","Already Buying!",4);
        return false;
    end;
    local Store,Counter;
    local oldpos=game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame;
    AncestorAutoBuyShit.Booleans.isBuying=true;
    pcall(function()
        game.Players.LocalPlayer.Character.Head.CanCollide = true
        game.Players.LocalPlayer.Character.Torso.CanCollide = true
    end)
    repeat game:GetService"RunService".Heartbeat:wait() Store,Counter=AncestorAutoBuyShit.functions.getItem(item); until Store and Counter;
    if AncestorAutoBuyShit.functions.getItemsOnCounter(item)then 
        AncestorAutoBuyShit.Booleans.abortAutobuy=false;
        pcall(function()
            game.Players.LocalPlayer.Character.Head.CanCollide = false
            game.Players.LocalPlayer.Character.Torso.CanCollide = false
        end)
        AncestorAutoBuyShit.Booleans.isBuying=false;
        AncestorAutoBuyShit.functions.AncestorTeleport(CFrame.new(oldpos.p)); --Convert To Bark Tp Method
        AncestorAutoBuyShit.functions.notify("Error","Items Are On The Counter. Aborting....",4);
        return false;
    end;
    price=AncestorAutoBuyShit.functions.getPrice(tostring(item),quantity);
    if not price and not requirements.Booleans.loopBuying then 
        pcall(function()
            game.Players.LocalPlayer.Character.Head.CanCollide = false
            game.Players.LocalPlayer.Character.Torso.CanCollide = false
        end)
        AncestorAutoBuyShit.Booleans.isBuying=false;
        AncestorAutoBuyShit.functions.AncestorTeleport(CFrame.new(oldpos.p));
        AncestorAutoBuyShit.functions.notify("Error","Not Enough Money!",4);
        return false;
    end;
    for i=1,quantity do
        local done=false;
        if AncestorAutoBuyShit.Booleans.abortAutobuy then
            AncestorAutoBuyShit.Booleans.abortAutobuy=false;
            pcall(function()
                game.Players.LocalPlayer.Character.Head.CanCollide = false
                game.Players.LocalPlayer.Character.Torso.CanCollide = false
            end)
            AncestorAutoBuyShit.Booleans.isBuying=false;
            AncestorAutoBuyShit.functions.AncestorTeleport(CFrame.new(oldpos.p));
            AncestorAutoBuyShit.functions.notify("Notify","Aborted Autobuy!",4);
            return false;
        end;
        itemToBuy=Store:FindFirstChild(item);
        if not itemToBuy then
            local start=tick();
            repeat game:GetService"RunService".Heartbeat:wait()until Store:FindFirstChild(item)or tick()-start >=60;
            local newItem=Store:FindFirstChild(item);
            if newItem then
                itemToBuy=newItem;
            end;
        end;
        if not itemToBuy then
            pcall(function()
                game.Players.LocalPlayer.Character.Head.CanCollide = false
                game.Players.LocalPlayer.Character.Torso.CanCollide = false
            end)
            AncestorAutoBuyShit.Booleans.isBuying=false;
            AncestorAutoBuyShit.functions.AncestorTeleport(CFrame.new(oldpos.p));
            AncestorAutoBuyShit.functions.notify("Error","Item Not Found!",4);
            return false;
        end;
        if i==1 then
            pcall(function()
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame=CFrame.new(itemToBuy.Main.CFrame.p+Vector3.new(5,0,5));
                wait(.05)
            end);
        end;
        local buyCheck
        buyCheck=workspace.PlayerModels.ChildAdded:Connect(function(b)
            local owner= b:WaitForChild("Owner",60);
            if owner.Value==game.Players.LocalPlayer then 
                buyCheck:Disconnect();
                buyCheck=b;
                spawnf(function()
                    local start = tick()
                    repeat game:GetService("RunService").Heartbeat:wait()
                        --AncestorAutoBuyShit.remotes.clientRequestOwnership:FireServer(itemToBuy);
                        AncestorAutoBuyShit.remotes.clientIsDragging:FireServer(itemToBuy);
                        itemToBuy:SetPrimaryPartCFrame(CFrame.new(oldpos.p+Vector3.new(4,0,4)));
                    until tick()-start > 0.13
                end);
                spawn(function()
                    itemToBuy:SetPrimaryPartCFrame(CFrame.new(oldpos.p+Vector3.new(4,0,4)));
                end)
            end;
        end);
        game.ReplicatedStorage.TestPing:InvokeServer();
        spawnf(function()
            local start = tick()
            repeat game:GetService("RunService").Heartbeat:wait()
                --AncestorAutoBuyShit.remotes.clientRequestOwnership:FireServer(itemToBuy);
                AncestorAutoBuyShit.remotes.clientIsDragging:FireServer(itemToBuy);
                itemToBuy:SetPrimaryPartCFrame(Counter.CFrame+Vector3.new(0,.1,0));
            until tick()-start > 0.13
        end);
        spawnf(function()
            repeat AncestorAutoBuyShit.functions.buyItem(itemToBuy)game:GetService"RunService".Heartbeat:wait()until typeof(buyCheck)=="Instance";
        end);
        repeat game:GetService"RunService".Heartbeat:wait()until typeof(buyCheck)=="Instance";
    end;
    AncestorAutoBuyShit.functions.AncestorTeleport(CFrame.new(oldpos.p));
    pcall(function()
        game.Players.LocalPlayer.Character.Head.CanCollide = false
        game.Players.LocalPlayer.Character.Torso.CanCollide = false
    end)
    AncestorAutoBuyShit.Booleans.isBuying=false;
    return true;
end;
AncestorAutoBuy=AncestorAutoBuyShit.functions.AutoBuyItem;

--Other Ancestor Shit
function getPlayersBase(plr)
    for _,Plot in next,workspace.Properties:children()do 
        if Plot:IsA("Model")and tostring(Plot.Owner.Value)==plr then 
            return Plot;
        end;
    end;
    return false;
end;

function getFreeLand()
    for _,Plot in next,workspace.Properties:children()do 
        if Plot.Owner.Value==nil then
            return Plot;
        end;
    end;
    return false,'No Plots Available';
end;       

function AncestorTeleport(cf)
    repeat wait()until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart");
    if game.Players.LocalPlayer.Character.Humanoid.Sit then 
        game.Players.LocalPlayer.Character.Humanoid.SeatPart.Parent:SetPrimaryPartCFrame(cf*CFrame.Angles(math.rad(game.Players.LocalPlayer.Character.Humanoid.SeatPart.Parent.PrimaryPart.Orientation.X), math.rad(game.Players.LocalPlayer.Character.Humanoid.SeatPart.Parent.PrimaryPart.Orientation.Y), math.rad(game.Players.LocalPlayer.Character.Humanoid.SeatPart.Parent.PrimaryPart.Orientation.Z)));
    elseif not game.Players.LocalPlayer.Character.Humanoid.Sit then 
        game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(cf)
    end;
end;

function FreeLand()
    if getPlayersBase(tostring(game.Players.LocalPlayer))then 
        notify("Error","You already have a plot!",4);
        return;
    end;
    local plot=getFreeLand();
    if not plot then return end; 
    --[[
    game:GetService"ReplicatedStorage".PropertyPurchasing.SetPropertyPurchasingValue:InvokeServer(true);
    game:GetService"ReplicatedStorage".PropertyPurchasing.ClientPurchasedProperty:FireServer(plot,plot.OriginSquare.CFrame.p);
    game:GetService"ReplicatedStorage".PropertyPurchasing.SetPropertyPurchasingValue:InvokeServer(false);
    AncestorTeleport(CFrame.new(plot.OriginSquare.CFrame.p)+Vector3.new(0,5,0));
    ]]
    notify("Patch Notification", "Free Land is patched, function has been disabled to prevent a ban.", 10)
end;

function DeleteSurroundingTrees()
    for _,TreeRegion in next,workspace:children()do
        if tostring(TreeRegion)=="TreeRegion"then
            for _,TreeModel in next,TreeRegion:children()do
                if(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.p-TreeModel.WoodSection.CFrame.p).magnitude<150 then 
                    game:GetService("ReplicatedStorage").Interaction.ClientIsDragging:FireServer(TreeModel);
                    game:GetService"ReplicatedStorage".Interaction.DestroyStructure:FireServer(TreeModel);
                end;
            end;
        end;
    end;
end;
-- max land 

function maxLand()
    --[[
    if not getPlayersBase(tostring(game.Players.LocalPlayer))then 
        FreeLand();
    end;
    repeat wait()until game.Players.LocalPlayer.OwnsProperty.Value==true;
    local Plot=getPlayersBase(tostring(game.Players.LocalPlayer));
    if not Plot then return end;
    local OriginSquare=Plot.OriginSquare;
    local children=#Plot:children()
    if children >=26 then 
        notify("Error","Already Max-Landed",4);
        return;
    end;
    game:GetService"ReplicatedStorage".PropertyPurchasing.SetPropertyPurchasingValue:InvokeServer(true);
    game:GetService"ReplicatedStorage".PropertyPurchasing.ClientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X + 40, OriginSquare.Position.Y, OriginSquare.Position.Z));game:GetService"ReplicatedStorage".PropertyPurchasing.ClientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X - 40, OriginSquare.Position.Y, OriginSquare.Position.Z));game:GetService"ReplicatedStorage".PropertyPurchasing.ClientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X, OriginSquare.Position.Y, OriginSquare.Position.Z + 40));game:GetService"ReplicatedStorage".PropertyPurchasing.ClientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X, OriginSquare.Position.Y, OriginSquare.Position.Z - 40));game:GetService"ReplicatedStorage".PropertyPurchasing.ClientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X + 40, OriginSquare.Position.Y, OriginSquare.Position.Z + 40));game:GetService"ReplicatedStorage".PropertyPurchasing.ClientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X + 40, OriginSquare.Position.Y, OriginSquare.Position.Z - 40));game:GetService"ReplicatedStorage".PropertyPurchasing.ClientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X - 40, OriginSquare.Position.Y, OriginSquare.Position.Z + 40));game:GetService"ReplicatedStorage".PropertyPurchasing.ClientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X - 40, OriginSquare.Position.Y, OriginSquare.Position.Z - 40));game:GetService"ReplicatedStorage".PropertyPurchasing.ClientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X + 80, OriginSquare.Position.Y, OriginSquare.Position.Z));game:GetService"ReplicatedStorage".PropertyPurchasing.ClientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X - 80, OriginSquare.Position.Y, OriginSquare.Position.Z));game:GetService"ReplicatedStorage".PropertyPurchasing.ClientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X, OriginSquare.Position.Y, OriginSquare.Position.Z + 80));game:GetService"ReplicatedStorage".PropertyPurchasing.ClientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X, OriginSquare.Position.Y, OriginSquare.Position.Z - 80));game:GetService"ReplicatedStorage".PropertyPurchasing.ClientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X + 80, OriginSquare.Position.Y, OriginSquare.Position.Z + 80));game:GetService"ReplicatedStorage".PropertyPurchasing.ClientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X + 80, OriginSquare.Position.Y, OriginSquare.Position.Z - 80));game:GetService"ReplicatedStorage".PropertyPurchasing.ClientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X - 80, OriginSquare.Position.Y, OriginSquare.Position.Z + 80));game:GetService"ReplicatedStorage".PropertyPurchasing.ClientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X - 80, OriginSquare.Position.Y, OriginSquare.Position.Z - 80));game:GetService"ReplicatedStorage".PropertyPurchasing.ClientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X + 40, OriginSquare.Position.Y, OriginSquare.Position.Z + 80));game:GetService"ReplicatedStorage".PropertyPurchasing.ClientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X - 40, OriginSquare.Position.Y, OriginSquare.Position.Z + 80));game:GetService"ReplicatedStorage".PropertyPurchasing.ClientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X + 80, OriginSquare.Position.Y, OriginSquare.Position.Z + 40));game:GetService"ReplicatedStorage".PropertyPurchasing.ClientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X + 80, OriginSquare.Position.Y, OriginSquare.Position.Z - 40));game:GetService"ReplicatedStorage".PropertyPurchasing.ClientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X - 80, OriginSquare.Position.Y, OriginSquare.Position.Z + 40));game:GetService"ReplicatedStorage".PropertyPurchasing.ClientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X - 80, OriginSquare.Position.Y, OriginSquare.Position.Z - 40));game:GetService"ReplicatedStorage".PropertyPurchasing.ClientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X + 40, OriginSquare.Position.Y, OriginSquare.Position.Z - 80));game:GetService"ReplicatedStorage".PropertyPurchasing.ClientExpandedProperty:FireServer(Plot ,CFrame.new(OriginSquare.Position.X - 40, OriginSquare.Position.Y, OriginSquare.Position.Z - 80));
    AncestorTeleport(CFrame.new(Plot.OriginSquare.CFrame.p)+Vector3.new(0,5,0));
    DeleteSurroundingTrees();
    game:GetService"ReplicatedStorage".PropertyPurchasing.SetPropertyPurchasingValue:InvokeServer(false);
    ]]
    notify("Patch Notification", "MaxLand is patched, function has been disabled to prevent a ban.", 10)
end;


if _G.DogixLT2Lib then
    selectedList = {}
    if _G.CurrentBarkUI ~= nil then
        _G.CurrentBarkUI.Parent = nil
    end
    gkey = _G.DogixLT2GetKey("anti_know")
    _G.disconnect_ctp()
    _G.nc_toggle = false
    _G.bomb_toggle = false
    _G.nofog_toggle = false
    _G.spook_toggle = false
    game.Lighting.FogStart = 0
    game.Lighting.FogEnd = 2400
    _G.alwaysday_toggle = false
    _G.alwaysnight_toggle = false
    _G.CarNC = false
    _G.CarNCTable = {}
    if _G.CFCloop ~= nil then
        _G.CFCloop:Disconnect()
        _G.CFCloop = nil
    end
    if _G.BarkCommandLine then
        _G.BarkCommandLine:Destroy()
    end
    _G.DiscardFly()
    if _G.lava_toggle then
        for i,v in pairs (game.Lighting:children()) do
            if v.Name == "Lava" then
                v.Parent = game.Workspace["Region_Volcano"]
                game.Workspace["Region_Volcano"].BasePlate:Destroy()
            end
        end
    end
    if _G.nsr_toggle then
        for i,v in pairs (game.Lighting:children()) do
            if v.Name == "PartSpawner" then
                v.Parent = game.Workspace["Region_Snow"]
            end
        end
    end
    if _G.nsr_toggle then
        for i,v in pairs (game.Lighting:children()) do
            if v.Name == "PartSpawner" then
                v.Parent = game.Workspace["Region_Snow"]
            end
        end
    end
    if _G.nlvb_toggle then
        for i,v in pairs (game.Lighting:children()) do
            if v.Name == "PartSpawner" then
                v.Parent = game.Workspace["Region_Volcano"]
            end
        end
    end
    if _G.nmw_toggle then
        for i,v in pairs (game.Lighting:children()) do
            if v.Name == "Blockade" then
                v.Parent = game.Workspace["Region_MazeCave"]
            end
        end
    end
    _G.nlvb_toggle = false
    _G.nmw_toggle = false
    _G.nsr_toggle = false
    _G.fnc_toggle = false
    _G.lava_toggle = false
    _G.shop_disable = false
    _G.Nokick = false
    _G.HardDraggerS = false
    _G.CurrentLooping:Disconnect()
    _G.CurrentLooping = nil
    if _G.Noclipping ~= nil then
        _G.Noclipping:Disconnect()
        _G.Noclipping = nil
    end
    if _G.HardDrag ~= nil then
        _G.HardDrag:Disconnect()
        _G.HardDrag = nil
    end
    if _G.OldNoclipping ~= nil then
        _G.OldNoclipping:Disconnect()
        _G.OldNoclipping = nil
    end
    if _G.FNoclipping ~= nil then
        _G.FNoclipping:Disconnect()
        _G.FNoclipping = nil
    end
    if _G.Blacklist ~= nil then
        _G.Blacklist:Disconnect()
        _G.Blacklist = nil
    end
    if _G.Whitelist ~= nil then
        _G.Whitelist:Disconnect()
        _G.Whitelist = nil
    end
    if _G.Nokicking ~= nil then
        _G.Nokicking:Disconnect()
        _G.Nokicking = nil
    end
    if _G.ferryUpdate ~= nil then
        _G.ferryUpdate:Disconnect()
        _G.ferryUpdate = nil
    end
    if _G.ItemListAddBind then
        _G.ItemListAddBind:Disconnect()
        _G.ItemListAddBind = nil
    end
    if _G.ItemListRemoveBind then
        _G.ItemListRemoveBind:Disconnect()
        _G.ItemListRemoveBind = nil
    end
    _G.ijp_toggle = false
    local lift = game.Workspace.Bridge.VerticalLiftBridge.Lift
    if _G.bdg_toggle then
        lift.Base.CFrame = lift.Base.CFrame + Vector3.new(0,26,0)
    end
    _G.bdg_toggle = false
    for i,v in pairs (game.Workspace.Water:children()) do if v.Name == "Water" then v.CanCollide = false end end
    for i,v in pairs (game.Workspace.Bridge.VerticalLiftBridge.WaterModel:children()) do if v.Name == "Water" then v.CanCollide = false end end
    
    if _G.HardDraggerConnection ~= nil then
        _G.HardDraggerConnection:Disconnect()
        _G.HardDraggerConnection = nil
    end
    if _G.OrigDrag ~= nil then    
        getsenv(game:GetService("Players").LocalPlayer.PlayerGui.ItemDraggingGUI.Dragger).canDrag =  _G.OrigDrag
        _G.OrigDrag = nil
    end
else
    (function()
        local p = Instance.new("Part", game.Workspace)
        p.Size = Vector3.new(20,1,20)
        p.Position = Vector3.new(531,-19,-1727)
        p.Anchored = true
        p = nil
        local a = "crash_script_users"
        function plrcheck(player)
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
        --game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("Scripts").SitPermissions.Disabled = false
        if game.ReplicatedStorage.Transactions:FindFirstChild("AddLog") then
            game.ReplicatedStorage.Transactions.AddLog:Destroy()
        end
        -- no point in checking for sentinel
        if newcclosure or protect_function and getrawmetatable and setreadonly and getnamecallmethod and getsenv then
            getgenv().autochoppe = false
            getgenv().done_autocutting = false
            getgenv().autocut = function(cute, tablet)
                getgenv().autochoppe = false
                tablet["cooldown"] = 0.112
                local Wood = cute.Parent.TreeClass.Value
                local added = game.Workspace.LogModels.ChildAdded:Connect(function(v)
                    v:WaitForChild("Owner")
                    if v.Owner.Value == game.Players.LocalPlayer and v.TreeClass.Value == Wood then
                        getgenv().done_autocutting = true
                    end
                end)
                local added_2 = game.Workspace.PlayerModels.ChildAdded:Connect(function(v)
                    v:WaitForChild("Owner")
                    if v.Owner.Value == game.Players.LocalPlayer and v.TreeClass.Value == Wood then
                        getgenv().done_autocutting = true
                    end
                end)
                local pleasestop = false
                repeat
                    wait(0.112)
                    spawn(function()
                        game:GetService("ReplicatedStorage").Interaction.RemoteProxy:FireServer(cute, tablet)
                    end)
                until getgenv().done_autocutting or pleasestop
                pleasestop = true
                added:Disconnect()
                added = nil
                added_2:Disconnect()
                added_2 = nil
                getgenv().done_autocutting = false
                wait(1.5)
                getgenv().autochoppe = true
            end
            report_player = report_player_local

            getgenv().car_pitch_hack = false
            getgenv().car_pitch = 0
            --namecall hooks
            getgenv().antiban_loaded = true -- compability with LS api
            local metatable_hooking = [[
                local protectedPart = Instance.new("IntValue", game.Workspace)
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
                    if method == "InvokeServer" and self == game.ReplicatedStorage["LoadSaveRequests"]["RequestSave"] and getgenv().block_save then
                        print("[Bark / INFO]: Plot Save Request Blocked")
                        return true
                    elseif method == "Kick" then
                        print("[Bark / INFO]: Client Kick Blocked | Kick Reason: "..tostring(arguments[1]))
                        wait(9e9)
                        return
                    elseif method == "FireServer" and self == game.ReplicatedStorage.Interaction.RemoteProxy and getgenv().autochoppe then
                        if type(arguments[1]) == "Instance" then
                            if arguments[1].Name == "CutEvent" then
                                getgenv().autochoppe = false
                                spawn(function()getgenv().autocut(arguments[1],arguments[2])end)
                            end
                        end
                        return old_namecall(self, ...)
                    elseif method == "FireServer" and self == game.ReplicatedStorage.Interaction.DestroyStructure then
                        if args[1]:FindFirstChild("WoodSection") then
                            notify("Patch Notification", "Destroying wood is patched! Skipped destroy to save you from a ban", 10)
                            return
                        end
                    end
                    return old_namecall(self, ...)
                end)
            ]]
            if not dbgmode then
                metatable_hooking = metatable_hooking .. [[
                mt.__index = protect(function(self, indexing, ...)
                    if self == protectedPart then
                        if  (indexing ~= "Parent" and indexing ~= "Name" and indexing ~= "name" and indexing ~= "FindFirstChild" and indexing ~= "IsA") then
                            spawn(function()
                                --report_player("2")
                                repeat until nil
                            end)
                        end
                    end
                    
                    return old_index(self, indexing, ...)
                end)
                ]]
            end
            loadstring(metatable_hooking)()
            local remlist = {
                game.ReplicatedStorage.Interaction:FindFirstChild("Ban"),
                game.ReplicatedStorage.Transactions:FindFirstChild("SetMod"),
                game.ReplicatedStorage.OwnershipDebug:FindFirstChild("BedRegionDebug")
            }
            for i,v in pairs (remlist) do
                if v ~= nil then
                    v.Name = game:GetService("HttpService"):GenerateGUID(false)
                    v:Destroy()
                end
            end
            print"Loaded Ban Function Disabler + Anti-Kick"
            
        else
            Instance.new("Message",game.Workspace).Text = "This exploit does not support Bark."
            wait(5)
            crash()
        end
        game.Players.LocalPlayer.CameraMaxZoomDistance = 400
        _G.DogixLT2Lib = true

        if game.Players.LocalPlayer.AccountAge < 10 then -- donate unlock gui
            local menu = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MenuGUI"):WaitForChild("Menu")
            local openButton = menu:WaitForChild("Main"):WaitForChild("Donate")
            local donateFrame = menu.Parent.Parent.DonateGUI.Donate
            local get_thread_context = get_thread_context or getthreadidentity or getthreadcontext or syn.get_thread_identity
            local set_thread_context = set_thread_context or setthreadidentity or setthreadcontext or setidentity or syn.set_thread_identity
            local identity = get_thread_context()
            openButton.MouseButton1Click:connect(function()
                set_thread_context(2)
                getsenv(donateFrame.Parent.DonateClient).require = require
                getsenv(donateFrame.Parent.DonateClient).openWindow()
                set_thread_context(identity)
            end)
            donateFrame.Quit.MouseButton1Click:connect(function()
                set_thread_context(2)
                getsenv(donateFrame.Parent.DonateClient).require = require
                getsenv(donateFrame.Parent.DonateClient).back()
                set_thread_context(identity)
            end)
            openButton.Selectable = true
	        openButton.Active = true
	        openButton.TextLabel.BackgroundColor3 = Color3.fromRGB(0, 255, 233)
        end
    end)()
end

function canUse(ownerVal)
    return game:GetService("ReplicatedStorage").Interaction.ClientIsWhitelisted:InvokeServer(ownerVal) == true or ownerVal == game.Players.LocalPlayer or ownerVal == nil
end

-- Initiate Functions
function rstepqueue(func)
    local qcd = false
    local cmd = game:GetService'RunService'.RenderStepped:connect(
    function()
        qcd = true
        func()
    end)
    repeat
        wait()
    until qcd
    cmd:Disconnect()
    cmd = nil
end
function detectFly()
    return game:GetService'Players'.LocalPlayer.Character.Humanoid.FloorMaterial.Name == "Air"
end

function simrad()
	if setsimulationradius then
        setsimulationradius(math.huge, math.huge)
    elseif sethiddenproperty then
	    sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
    end
end
function spoofCamera(cfr)
    game.Workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
    game.Workspace.CurrentCamera.CFrame = cfr+game:GetService'Players'.LocalPlayer.Character.Humanoid.CameraOffset
end
function unspoofCamera()
    for i,v in pairs (game.Lighting:children()) do
        if v.Name == "CameraSpoof" then
            v:Destroy()
        end
    end
    game.Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    game.Workspace.CurrentCamera.CameraSubject = game:GetService'Players'.LocalPlayer.Character.Humanoid
end
function userparse(part)
    new = part
    if new ~= "" and new ~= nil then
        for _, v in pairs(game:GetService('Players'):GetPlayers()) do
            if v.Name:lower() == new:lower() then
                return v
            end
            if v.Name:lower():find(new:lower()) then
                return v
            end
        end
    end
    return nil
end
function userparse_string(part)
    return (userparse(part) and userparse(part).Name) or nil
end
function delmodel(x,y)
    if y == nil then
        --game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(x:FindFirstChildOfClass("Part"))
        game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(x)
    end
    
    game.ReplicatedStorage.Interaction.DestroyStructure:FireServer(x)
end
local TreeConversionTable = {
    ["Cherry"] = "Cherry",
    ["Gold"] = "GoldSwampy",
    ["Cavecrawler"] = "CaveCrawler",
    ["Oak"] = "Generic",
    ["Frost"] = "Frost",
    ["Lava"] = "Volcano",
    ["Elm"] = "Oak",
    ["Walnut"] = "Walnut",
    ["Birch"] = "Birch",
    ["Snowglow"] = "SnowGlow",
    ["Pine"] = "Pine",
    ["Zombie"] = "GreenSwampy",
    ["Koa"] = "Koa",
    ["Palm"] = "Palm",
    ["Spook"] = "Spooky",
    ["Sinister"] = "SpookyNeon",
    ["End Times"] = "LoneCave",
    ["Gray"] = nil,
}

--setting up trees
get_tree_list = function()
    local trees = {}
    for i, v in pairs(game:GetService("Workspace"):GetChildren()) do
        if v.name == "TreeRegion" then
            for i, b in pairs(v:GetChildren()) do
                local tree = b:FindFirstChild("TreeClass")
                if tree ~= nil and (tree.Parent.Owner.Value == nil or tree.Parent.Owner.Value == game.Players.LocalPlayer) then
                    tree = tree.Parent
                    table.insert(trees, tree.TreeClass.Value)
                end
            end
        end
    end
    local hash = {}
    for _, v in ipairs(trees) do
        hash[v] = true
    end
    local res = {}
    for k, _ in pairs(hash) do
        res[#res + 1] = k
    end
    return res
end
nicify_tree_list = function(tree_list)
    local new_table = {}
    for i, v in pairs(tree_list) do
        local obtained = false
        for i2, v2 in pairs(TreeConversionTable) do
            if v2 == v then
                obtained = true
                table.insert(new_table, i2)
                break
            end
        end
        if not obtained then
            table.insert(new_table, v)
        end
    end
    return new_table
end
for i, v in pairs(game:GetService("Workspace"):GetChildren()) do
    if v.Name == "TreeRegion" then
        v.ChildAdded:Connect(function()
            tree_list_event:Fire(get_tree_list())
        end)
        v.ChildRemoved:Connect(function()
            tree_list_event:Fire(get_tree_list())
        end)
    end
end

local function wait_for_slot(title)
    title = title or "Auto-Dupe"
    local status, reason = game:GetService("ReplicatedStorage").LoadSaveRequests.ClientMayLoad:InvokeServer(game.Players.LocalPlayer)
    while not status do
        notify(title, "Load is on cooldown! \nMessage: "..reason.."Retrying in 5 seconds",3)
        wait(5)
        status, reason = game:GetService("ReplicatedStorage").LoadSaveRequests.ClientMayLoad:InvokeServer(game.Players.LocalPlayer)
    end
end

local emain = nil
function confirm(x)
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
function ftouch(p1,p2,t,b)
    if firetouchinterest or b then
        local x = 0
        if not t then x = 1 end
        if not PROTOSMASHER_LOADED then
            firetouchinterest(p1,p2,x)
        else
            firetouchinterest(p1,p2,t)
            wait(0.5)
        end
    else
        local op2c = p2.CFrame
        local op2s = p2.Size
        p2.Size = Vector3.new(.5,.5,.5)
        p2.CFrame = p1.CFrame
        wait()
        p2.Size = op2s
        p2.CFrame = op2c
    end
end


-- Bypasses (no point in bypassing ~applebee 12/08/2021)


function getAxeList()
    local axes = {}
    for i,v in pairs (game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v:FindFirstChild("AxeClient") then
            table.insert(axes,v)
        end
    end
    local pc = game.Players.LocalPlayer.Character
    if pc:FindFirstChildOfClass"Tool" then
        table.insert(axes,pc:FindFirstChildOfClass("Tool"))
    end
    return axes
end



if not getgenv().require_fixed then
    local get_thread_context = get_thread_context or getthreadidentity or getthreadcontext or syn.get_thread_identity
    local set_thread_context = set_thread_context or setthreadidentity or setthreadcontext or setidentity or syn.set_thread_identity
    local identity = get_thread_context()
    getgenv().require_fixed = true
    local old_require = require
    getgenv().require = function(module)
        set_thread_context(2)
        local data = old_require(module)
        set_thread_context(identity)
        return data
    end  
    print("[BARK]: Require Fixed!")
end
require = getgenv().require --for pebc and sentinel

function get_axe_damage(tool, tree)
    --totally not skidded from lumbsmasher
    local axe_class = require(game.ReplicatedStorage.AxeClasses['AxeClass_'..tool.ToolName.Value])
    local axe_table = axe_class.new()
    if axe_table["SpecialTrees"] then
        if axe_table["SpecialTrees"][tree] then
            return axe_table["SpecialTrees"][tree].Damage
        else
            return axe_table.Damage
        end
    else
        return axe_table.Damage
    end
end
--get axe cooldown
function get_axe_cooldown(tool)
    local success, return_value =pcall(function()
        local axe_class = require(game.ReplicatedStorage.AxeClasses['AxeClass_'..tool.ToolName.Value])
        local axe_table = axe_class.new()

        return axe_table.SwingCooldown
    end)
    if success then
        return return_value
    else
        warn("ERROR WHILE REQUIRING MODULE: " .. return_value)
        return 1
    end
end
function get_axe_swingdelay(tool)
    local axe_cooldown = get_axe_cooldown(tool)
    local start = tick()
    game.ReplicatedStorage.TestPing:InvokeServer()
    local ping = (tick() - start) / 2
    local swing_delay = 0.65 * axe_cooldown - ping
    return swing_delay
end
function getBestAxe()
    --changing it to my own method ~applebee#3071
    local pc = game.Players.LocalPlayer.Character
    local axe_damage
    local best_axe
    for i, v in pairs(getAxeList()) do
        if v.name == "Tool" then
            local damage = get_axe_damage(v, "Generic")
            if best_axe == nil then
                best_axe = v
                axe_damage = damage
            elseif get_axe_damage(best_axe, "Generic") < damage then
                best_axe = v
                axe_damage = damage
            end
        end
    end
    return best_axe
end
function getWorstAxe()
    --changing it to my own method ~applebee#3071
    local pc = game.Players.LocalPlayer.Character
    local axe_damage
    local worst_axe
    for i, v in pairs(getAxeList()) do
        if v.name == "Tool" then
            local damage = get_axe_damage(v, "Generic")
            if worst_axe == nil then
                worst_axe = v
                axe_damage = damage
            elseif get_axe_damage(worst_axe, "Generic") > damage then
                worst_axe = v
                axe_damage = damage
            end
        end
    end
    return worst_axe
end
local override_sawmill = nil
function getBestSawmill()
    local best = nil
    for i,v in pairs (game.Workspace.PlayerModels:GetChildren()) do
        if v:FindFirstChild("Owner") and v:FindFirstChild("ItemName") and v.Owner.Value == game.Players.LocalPlayer and v.ItemName.Value:sub(1,7) == "Sawmill" then
            if not best then best = v
            else
                if #v.ItemName.Value > #best.ItemName.Value then
                    best = v
                elseif tonumber(v.ItemName.Value:sub(8,8)) > tonumber(best.ItemName.Value:sub(8,8)) then
                    best = v
                end
            end
        end
    end
    return best
end
----- Click Actions
local m = game:GetService'Players'.LocalPlayer:GetMouse()
local can = false
local spam_jp = false
local toggle = true
local plank = nil
local bp = nil
local cmds_run = false

function getMouseTarget()
	local cursorPosition = game:GetService("UserInputService"):GetMouseLocation()
	--print'pen'
	return game.Workspace:FindPartOnRayWithIgnoreList(Ray.new(game.Workspace.CurrentCamera.CFrame.p,(game.Workspace.CurrentCamera:ViewportPointToRay(cursorPosition.x, cursorPosition.y, 0).Direction * 1000)),game.Players.LocalPlayer.Character:GetDescendants())
end

function _G.disconnect_ctp()
    toggle = false
    cmds_run = false
end
function dobypass(input)
    local chara = "ۥֹ"
    return input:gsub('ﻌׅ',function(c)
	    if c == " " then
	        return c
        end
	    return c..chara
	end)
end
m.Button1Down:connect(function()
    if not toggle then return end
    if can and toggle then
        local angle = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame - game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Position
        _G.DogixLT2TPC(CFrame.new(m.Hit.p)*angle+Vector3.new(0,3,0),gkey, true)
    end
end)
local sprinting = false
local doclick = true
game:GetService('UserInputService').InputBegan:connect(function(ip, n)
    if ip.UserInputType == Enum.UserInputType.Keyboard and toggle then
        if ip.KeyCode == _G.ClickTPKey then
            if doclick == true then
                can = true
            else
                local angle = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame - game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Position
                _G.DogixLT2TPC(CFrame.new(m.Hit.p)*angle+Vector3.new(0,3,0),gkey, true)
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
function Action(Object, Function) if Object ~= nil then Function(Object); end end
----- API Functions
--> Get Key
function _G.DogixLT2GetKey(st)
    return gkey
end
local custom = ""
local _itpocfa = nil
local _itpocf = nil
--> Teleport Function Tree
function _G.DogixLT2TP(x,y,z,key, force_cframe)
    local isdbg = false
    if key ~= gkey and key ~= gkey + 1 then
        send(" ! global key not detected! script denied access.\n")
        game.GlobalKeyNotDetected.GlobalKeyNotDetected = nil
    elseif key == gkey + 1 then
        isdbg = true
    end
    local plrc = game:GetService'Players'.LocalPlayer.Character
    local magnitude = (Vector3.new(x,y,z) - plrc.HumanoidRootPart.CFrame.p).Magnitude
    if magnitude > 9000 and not isdbg then
        error'tp distance too long!'
        game.TPDistanceTooLong.TPDistanceTooLong = true
    end
    if force_cframe ~= nil then
        cf = force_cframe
    else
        cf = CFrame.new(x,y,z)
    end
    
    -- actual tp
    plrc.HumanoidRootPart.CFrame = cf

    -- removed bypasses (applebee 12/08/2021)
end
--> TP to CFrame
function _G.DogixLT2TPC(cf,gkey, force_cframe)
    _G.DogixLT2TP(cf.X,cf.Y,cf.Z,gkey, (force_cframe and cf))
end

local Times = 0

local function actualdrag(part, cfq)
    if (part.CFrame.p-game:GetService'Players'.LocalPlayer.Character.HumanoidRootPart.CFrame.p).Magnitude > 50 then
        local offset = Vector3.new(5,5,5)
        if part.Name ~= "WoodSection" then offset = Vector3.new(0,0,0)end
        _G.DogixLT2TPC(part.CFrame + offset, gkey)
        wait(.5)
    end
    if part.Name == "WoodSection" then
        spawn(function()
            local success = false
            repeat
                if (part.CFrame.p-game:GetService'Players'.LocalPlayer.Character.HumanoidRootPart.CFrame.p).Magnitude > 50 then
                    local offset = Vector3.new(5,5,5)
                    if part.Name ~= "WoodSection" then offset = Vector3.new(0,0,0)end
                    _G.DogixLT2TPC(part.CFrame + offset, gkey)
                    wait(.5)
                end
                for i=1, 4 do
                    --game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(part)
                    game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(part.Parent)
                    --part.CFrame = CFrame.new(part.Position) * CFrame.Angles(math.rad(90),0,0)
                    part.Parent.PrimaryPart = part
                    part.Parent:SetPrimaryPartCFrame(cfq + Vector3.new(0, 10, 0))
                    part.CFrame = cfq
                end
                game:GetService("RunService").RenderStepped:Wait()
                wait(.5)
                success = (part.CFrame.p - cfq.p).magnitude <= 15
            until success
        end)
        Times = Times + 1
        if Times == 6 then
            Times = 0
            wait(0.3)
        end

        return
    end
    
    if old_drag then
        spawn(function()
            for i = 1, 5 do
                -- game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(part)
                game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(part.Parent)
                -- game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(part)
                --part.CFrame = CFrame.new(part.Position) * CFrame.Angles(math.rad(90),0,0)
                part.CFrame = cfq
                game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(part.Parent)
                game:GetService'RunService'.RenderStepped:wait()
            end
        end)
    end
    spawn(function()
        for i=1, 4 do
            -- game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(part.Parent)
            game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(part.Parent)
            part.CFrame = CFrame.new(part.Position) * CFrame.Angles(math.rad(90),0,0)
            part.Parent:MoveTo(cfq.p + Vector3.new(0, 10, 0))
            part.CFrame = cfq
        end
    end)
	Times = Times + 1
	if Times == 6 then
		Times = 0
		wait(0.3)
	end
end
--> Drag
function _G.DogixLT2DragAlt(part, cfq)
    return actualdrag(part, cfq)
end
function tocf(part, cFrame, partCount)
	if partCount > 1 then
		part.Parent:MoveTo(cFrame.p)
	else
		part.CFrame = cFrame
	end
end;
function _G.DogixLT2Drag(part,cfq)
    if game.PlaceId == 5175316718 then
        return _G.DogixLT2DragAlt(part, cfq)
    end
    if part.Name == "WoodSection" then return actualdrag(part, cfq) end
    local parts = 0
	for _, v in pairs(part.Parent:GetDescendants()) do
		if v:IsA("Part") then
			parts = parts + 1
		end
	end;
    local isnetworkowner = isnetworkowner or is_network_owner
    if not isnetworkowner then
        return _G.DogixLT2DragAlt(part, cfq)
    end
    if old_drag then
        spawn(function()
            repeat
                -- game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(part)
                game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(part.Parent)
                -- game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(part)
                wait()
                tocf(part, cfq, parts)
                game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(part.Parent)
            until isnetworkowner(part) or wait(2)
            part.Parent:MoveTo(cfq.p)
            part.CFrame = cfq
        end)
    else
        spawn(function()
            repeat
                -- game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(part.Parent)
                game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(part.Parent)
                part.CFrame = CFrame.new(part.Position) * CFrame.Angles(math.rad(90),0,0)
                part.Parent:MoveTo(cfq.p + Vector3.new(0, 10, 0))
                wait()
                part.CFrame = cfq
            until isnetworkowner(part) or wait(2)
            part.Parent:MoveTo(cfq.p)
            part.CFrame = cfq
        end)
    end

end
--> AutoBuy
function price_of(ia)
    for i,v in pairs(game:GetService("ReplicatedStorage").Purchasables:GetDescendants()) do
        if v:IsA("Folder") and v.Name == ia and v:findFirstChild'Price' then
            return v.Price.Value
        end
    end
    return nil
end
function checkModel(item,option,player)
    local Owner=nil;
    if player==nil then 
        Owner=tostring(game.Players.LocalPlayer);
    end
    for _,v in next,workspace.PlayerModels:children()do
        if v:IsA("Model")then 
            local check=v:FindFirstChild("ItemName")or v:FindFirstChild("PurchasedBoxItemName");
            if item=="BasicHatchet" then 
                check=v:FindFirstChild("ItemName")
            end;
            if  check and  check.Value==item and v:FindFirstChild("Owner")and tostring(v.Owner.Value)==Owner then
                if option=="Model"then
                    return v;
                elseif option=="Magnitude"then
                    return (v.PrimaryPart.CFrame.p-game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.p).magnitude;
                end;
            end;
        end;
    end;
    return false;
end
function SellSign()
    local sign=checkModel("PropertySoldSign","Model");
    if not sign then
        notify("Error","You don't own a Sign to sell!",4);
        return;
    end;
    if sign:FindFirstChild("Main").Anchored then 
        game:GetService("ReplicatedStorage").Interaction.ClientInteracted:FireServer(sign,"Take down sold sign");
    end;
    local magnitude=checkModel("PropertySoldSign","Magnitude");
    if magnitude>10 then 
        AncestorTeleport(CFrame.new(sign.PrimaryPart.CFrame.p)+Vector3.new(0,5,0));
    end;
    wait(.2);
    for i = 1,10 do 
        game:GetService'RunService'.Stepped:wait()
        -- game:GetService("ReplicatedStorage").Interaction.ClientRequestOwnership:FireServer(sign.Main);
        game:GetService("ReplicatedStorage").Interaction.ClientIsDragging:FireServer(sign);
        sign:SetPrimaryPartCFrame(CFrame.new(315.4,3,85.4));
    end;
end;
function autobuy(i,q,c,xt)
    if abmethod == 1 then
        item = autobuy_v2(i,q,c,xt)
    elseif abmethod == 2 then 
        AncestorAutoBuy(tostring(i),q)
    end
    return item
end
local cashierIds = {}
-- stuff from bark 8.2
local connection = game.ReplicatedStorage.NPCDialog.PromptChat.OnClientEvent:connect(function(bu, data)
    if cashierIds[data.Name] == nil then
    	print(string.format("[BARK] Dumped NPC ID: %s - %s", data.Name, data.ID))
    	cashierIds[data.Name] = data.ID;
    end
end)

game.ReplicatedStorage.NPCDialog.SetChattingValue:InvokeServer(1)
spawn(function()
    repeat wait(0.5) until cashierIds["Thom"] ~= nil
    wait(3)
    connection:Disconnect()
    connection = nil
    game.ReplicatedStorage.NPCDialog.SetChattingValue:InvokeServer(0)
    if cashierIds["Thom"] ~= nil then
        notify("Bark "..cv, "Automatically updated Auto-Buy.", 3)
    end
end)
local bt = false;

function getItemInfo(BItem)
    local NameStore,Cashier,CID,StoreItems
    for _,fldr in pairs (game.Workspace.Stores:children()) do
	    if fldr:FindFirstChild(BItem) then
	        if fldr:FindFirstChild("Bed1") or fldr:FindFirstChild("Seat_Couch") then
	            NameStore = 'FurnitureStore'
    			Cashier = game.Workspace.Stores.FurnitureStore.Corey
    		    StoreItems = fldr
    		elseif fldr:FindFirstChild("Sawmill") or fldr:FindFirstChild("Sawmill2") then
    		    NameStore = 'WoodRUs'
    			Cashier = game.Workspace.Stores.WoodRUs.Thom
    		    StoreItems = fldr
    		elseif fldr:FindFirstChild("Trailer2") or fldr:FindFirstChild("UtilityTruck2") then
    		    NameStore = 'CarStore'
    			Cashier = game.Workspace.Stores.CarStore.Jenny
    		    StoreItems = fldr
    		elseif fldr:FindFirstChild("CanOfWorms") or fldr:FindFirstChild("Dynamite") then
    		    NameStore = 'ShackShop'
    			Cashier = game.Workspace.Stores.ShackShop.Bob
    		    StoreItems = fldr
    		elseif fldr:FindFirstChild("Painting1") or fldr:FindFirstChild("Painting2") then
    		    NameStore = 'FineArt'
    			Cashier = game.Workspace.Stores.FineArt.Timothy
    		    StoreItems = fldr
    		elseif fldr:FindFirstChild("GateXOR") or fldr:FindFirstChild("NeonWireOrange") then
    		    NameStore = 'LogicStore'
    			Cashier = game.Workspace.Stores.LogicStore.Lincoln
    		    StoreItems = fldr
    		else
    		    return false
    		end
    	elseif BItem == "ManyAxe" then
    	    if fldr:FindFirstChild("Bed1") or fldr:FindFirstChild("Seat_Couch") then
	            NameStore = 'FurnitureStore'
    			Cashier = game.Workspace.Stores.FurnitureStore.Corey
    		    StoreItems = fldr
    		end
	    end
    end
    return{NameStore,Cashier,cashierIds[Cashier.Name],StoreItems}
end
function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function locatedOnPlot(v3)
    local plot = nil;
	for _, v in pairs(game.Workspace.Properties:GetChildren()) do
		if v.Owner.Value == game.Players.LocalPlayer then
			for _,v2 in pairs (v:GetChildren()) do
			    if v2:IsA("Part") then
    		        if math.abs(v3.Z - v2.CFrame.Z) <= 20 and math.abs(v3.X - v2.CFrame.X) <= 20 then
    		            return true
		            end
		        end
			end
			break
		end
	end;
	return false
end
function autobuy_v2(item, count, overrided_cframe, tp_back)
    local ItemInfo = getItemInfo(item)
    local StoreName = ItemInfo[1]
    local Cashier = ItemInfo[2]
    local CID = ItemInfo[3]
    local StoreItems = ItemInfo[4]
    local ChatEvent = game:GetService("ReplicatedStorage").NPCDialog.PlayerChatted
    local OriginalPos = overrided_cframe or game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    local ItemList = {}
    local StartTime = tick()
    local FirstTp = true
    local IsOpen = Cashier:FindFirstChild("Dialog") ~= nil
    local FailCounter = 0
    --local OriginalPosOnPlot = locatedOnPlot(OriginalPos)
    if StoreItems == nil then
        notify("Auto-Buy", "Couldn't determine item's store.", 3)
        return
    end
    for i=1,count do
		local waitedForStock = StoreItems:FindFirstChild(item) == nil
        local itemModel = StoreItems:FindFirstChild(item) or StoreItems:WaitForChild(item, 8)
        if not itemModel then
            notify("Auto-Buy", "Item not in stock after 8 seconds, stopping Auto-Buy.", 3)
            return
        end
        local counter = game.Workspace.Stores[StoreName].Counter
        local itemTargetPos = CFrame.new(counter.Position+Vector3.new(0,0.24,0))*CFrame.Angles(0,math.rad(math.random(-3,3)),0)
        local talk = {["Character"] = Cashier, ["Name"] = Cashier.Name, ["ID"] = CID, ["Dialog"] = {}}
        local finishedPurchasing = false
        local touchedCounter = false
        local newItemChecker = game.Workspace.PlayerModels.ChildAdded:connect(function(v)
            v:WaitForChild("Owner")
            if v.Owner.Value == game.Players.LocalPlayer and v:FindFirstChild("PurchasedBoxItemName") and v.PurchasedBoxItemName.Value == item then
                _G.DogixLT2Drag(v.PrimaryPart, OriginalPos)
                notify("Auto-Buy", "Purchased item, "..count-i.." remain.", 0.25)
                table.insert(ItemList,v)
                finishedPurchasing = true
            end
        end)
        local counterTouchedChecker
        if not IsOpen then

            -- stolen from lt2
            local boundsA = counter.CFrame * CFrame.new(counter.Size.X/2, 0, counter.Size.Z/2)
            local boundsB = counter.CFrame * CFrame.new(-counter.Size.X/2, 0, -counter.Size.Z/2)
            local counterRegion = Region3.new(Vector3.new(math.min(boundsA.X, boundsB.X), counter.Size.Y/2 + boundsA.Y, math.min(boundsA.Z, boundsB.Z)),
                                                Vector3.new(math.max(boundsA.X, boundsB.X), counter.Size.Y/2 + 0.6 + boundsA.Y, math.max(boundsA.Z, boundsB.Z))) 

            counterTouchedChecker = game:GetService("RunService").RenderStepped:connect(function()
                local parts = game.Workspace:FindPartsInRegion3(counterRegion, counter)
	            for _, part in pairs(parts) do
                    if part == itemModel.PrimaryPart then
                        touchedCounter = true
                        return
                    end
                end
            end)
            --[[

            --dogix's method but kinda breaks
            counterTouchedChecker = counter.Touched:connect(function(v)
    			for i,v in pairs (itemModel.PrimaryPart:GetTouchingParts()) do
    			    if v.Name == "Counter" then
    			        touchedCounter = true
    			        return
    		        end
    		    end
            end)
            ]]
        else
            counterTouchedChecker = game:GetService("RunService").RenderStepped:connect(function()
                touchedCounter = touchedCounter or ChatEvent:InvokeServer(talk, "Initiate")
            end)
        end
        function range_func(range_cf)
            return (game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.p-range_cf.p).Magnitude < ((getsimulationradius and math.min(getsimulationradius(), 60)) or 30)
        end
        if not range_func(itemModel.PrimaryPart.CFrame) or FirstTp then
            FirstTp = false
    		spawn(function()
    			_G.DogixLT2TPC(itemModel.PrimaryPart.CFrame+Vector3.new(5,2,5),gkey)
    		end)
            repeat wait() until range_func(itemModel.PrimaryPart.CFrame)
    	end
        -- game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(itemModel.Main)
        for i=1,250 do
            if touchedCounter or finishedPurchasing then break end
            if abortbuy then
                counterTouchedChecker:Disconnect()
                counterTouchedChecker = nil
                _G.DogixLT2TPC(OriginalPos,gkey)
                return
            end
            itemModel:SetPrimaryPartCFrame(itemTargetPos)
			spawn(function()
				game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(itemModel)
			end)
			spawn(function()
        		ChatEvent:InvokeServer(talk, "ConfirmPurchase")
			end)
			game:GetService("RunService").Stepped:wait()
        end
        counterTouchedChecker:Disconnect()
        counterTouchedChecker = nil
        touchedCounter = false
        if not OriginalPosOnPlot and not range_func(counter.CFrame) then
    		spawn(function()
    			_G.DogixLT2TPC(counter.CFrame+Vector3.new(5,2,5),gkey)
    		end)
        end
	    if not finishedPurchasing then
            for i=1,80 do
                if finishedPurchasing then break end
                if abortbuy then
                    newItemChecker:Disconnect()
                    newItemChecker = nil
                    _G.DogixLT2TPC(OriginalPos,gkey)
                    return
                end
                wait()
                spawn(function()
                end)
            end
        end
		local autobuyWaitingLoop = 0
        repeat
            wait()
			autobuyWaitingLoop = autobuyWaitingLoop + 1
        until finishedPurchasing or autobuyWaitingLoop == 69 or abortbuy
        if not finishedPurchasing then
            notify("Auto-Buy", "Failed item.", 0.5)
            FailCounter = FailCounter + 1
        end
        finishedPurchasing = false
        newItemChecker:Disconnect()
        newItemChecker = nil
        if abortbuy then
            _G.DogixLT2TPC(OriginalPos,gkey, true)
            return
        end
    end
    if tp_back ~= false then
        _G.DogixLT2TPC(OriginalPos,gkey, true)
    end
    local endtick = tick()
    notify("Auto-Buy", "Done! "..count-FailCounter.."/"..count.." in "..round((endtick-StartTime),3).."s ("..round(count/(endtick-StartTime),3).."/s)", 1)
    return (count == 1 and ItemList[1]) or ItemList
end
function _G.DogixLT2Autobuy(item,quantity,key)
    if gkey == key then
        return autobuy(item,quantity)
    end
end
function spawn_wire(Item, Quantity)
    local Land = nil
    for i,v in pairs(game.Workspace.Properties:GetChildren()) do
       if v.Owner.Value == game.Players.LocalPlayer then
           Land = v
           break
       end
    end
    if not Land then
        notify("Wire Spawner", "You need a plot to use this feature.",3)
        return
    end
    _G.DogixLT2TPC(CFrame.new(Land.OriginSquare.Position + Vector3.new(0,5,0)),gkey)
    function Spawn(wire)
        if not wire then return end
        local Info = game.ReplicatedStorage.ClientItemInfo:FindFirstChild(Item)
        local Points = {Land.OriginSquare.Position + Vector3.new(0,5,0), Land.OriginSquare.Position + Vector3.new(0,10,0)}
        wait(.3)
        game.ReplicatedStorage.PlaceStructure.ClientPlacedWire:FireServer(Info, Points,game.Players.LocalPlayer, wire,true)
        wait(.2)
    end
    if Quantity == 1 then
        Spawn(autobuy("Wire",1))
    else
        local wirearray = autobuy("Wire",Quantity)
        for i,v in pairs (wirearray) do
            Spawn(v)
        end
    end
end
_G.GetTreeNC = nil
local esp_loops = {}
local esp_trees = {}
function esp_part(part)
    local a = Instance.new("BoxHandleAdornment", part)
    a.Name = "Selection"
	a.Adornee = a.Parent
	a.AlwaysOnTop = true
	a.ZIndex = 0
	a.Size = a.Parent.Size
	a.Transparency = 0
	a.Color = BrickColor.new(6)
    return a
end
function esp_tree(treemdl)
    table.insert(esp_trees, treemdl)
    for i,v in pairs(treemdl:GetChildren()) do
        if v.Name == "WoodSection" then
            esp_part(v)
        end
    end
    table.insert(esp_loops, treemdl.ChildAdded:connect(function(v)
        esp_part(v)
    end))
end
function get_fake_large_floor_points(cf)
    return {(cf * CFrame.new(3.9,0.4,-2)) * CFrame.Angles(math.rad(90),math.rad(0),math.rad(90)), (cf * CFrame.new(3.9,0.4,2)) * CFrame.Angles(math.rad(90),math.rad(0),math.rad(90))}
end
function get_fake_floor_point(cf)
    return cf * CFrame.new(2,0.5,0) * CFrame.Angles(math.rad(90),math.rad(0),math.rad(90))
end
function get_fake_large_tile_points(cf)
    local points = {
        cf * CFrame.new(2,0,2),
        cf * CFrame.new(2,0,-2),
        cf * CFrame.new(-2,0,2),
        cf * CFrame.new(-2,0,-2),
    }
    local npoints = {}
    for i,v in pairs (points) do
        for i,v2 in pairs (get_fake_tile_points(v)) do
            table.insert(npoints, v2)
        end
    end
    return npoints
end
function get_fake_tile_points(cf)
    return {
        cf * CFrame.new(1,0,1),
        cf * CFrame.new(1,0,-1),
        cf * CFrame.new(-1,0,1),
        cf * CFrame.new(-1,0,-1),
    }
end
function get_fake_stair_points(cf)
    local points = {
        ["Post1"] = cf * CFrame.new(1.5,3.4,-1.9)*CFrame.Angles(math.rad(90),0,0),
        ["Post2"] = cf * CFrame.new(-0.5,1.4,-1.9)*CFrame.Angles(math.rad(90),0,0),
        ["Floor1"] = cf * CFrame.new(1,2,-1),
        ["Floor2"] = cf * CFrame.new(1,2,1),
        ["Stairs"] = cf,
    }
    return points
end
function summon_fake_large_floor(cf)
    local points = get_fake_large_floor_points(cf)
    game:GetService("ReplicatedStorage").PlaceStructure.ClientPlacedBlueprint:FireServer("Wall2Tall", points[1], game.Players.LocalPlayer)
    game:GetService("ReplicatedStorage").PlaceStructure.ClientPlacedBlueprint:FireServer("Wall2Tall", points[2], game.Players.LocalPlayer)
end
function summon_fake_small_floor(cf)
    game:GetService("ReplicatedStorage").PlaceStructure.ClientPlacedBlueprint:FireServer("Wall2", get_fake_floor_point(cf), game.Players.LocalPlayer)
end
function summon_fake_tile_points(cf)
    local points = get_fake_tile_points(cf)
    for i,v in pairs (points) do
        game:GetService("ReplicatedStorage").PlaceStructure.ClientPlacedBlueprint:FireServer("Floor2Small", v, game.Players.LocalPlayer)
    end
end
function summon_fake_large_tile_points(cf)
    local points = get_fake_large_tile_points(cf)
    for i,v in pairs (points) do
        game:GetService("ReplicatedStorage").PlaceStructure.ClientPlacedBlueprint:FireServer("Floor2Small", v, game.Players.LocalPlayer)
    end
end
function summon_fake_stair_points(cf)
    local pts = get_fake_stair_points(cf)
    game:GetService("ReplicatedStorage").PlaceStructure.ClientPlacedBlueprint:FireServer("Post", pts.Post1, game.Players.LocalPlayer)
    game:GetService("ReplicatedStorage").PlaceStructure.ClientPlacedBlueprint:FireServer("Post", pts.Post2, game.Players.LocalPlayer)
    game:GetService("ReplicatedStorage").PlaceStructure.ClientPlacedBlueprint:FireServer("Floor1Small", pts.Floor1, game.Players.LocalPlayer)
    game:GetService("ReplicatedStorage").PlaceStructure.ClientPlacedBlueprint:FireServer("Floor1Small", pts.Floor2, game.Players.LocalPlayer)
    game:GetService("ReplicatedStorage").PlaceStructure.ClientPlacedBlueprint:FireServer("Stair2", pts.Stairs, game.Players.LocalPlayer)
end

function legitpaint(wood, bp)
    local plr = game:GetService'Players'.LocalPlayer
    local plrc = plr.Character
    local oldcf = plrc.HumanoidRootPart.CFrame
    local tool = getBestAxe()
	local cf_ = nil
    if bp:FindFirstChild("MainCFrame") then
        cf_ = bp.MainCFrame.Value
    else
        cf_ = bp.Main.CFrame
    end
    if wood == nil then
        local Event = game:GetService("ReplicatedStorage").PlaceStructure.ClientPlacedStructure
        Event:FireServer(bp.ItemName.Value, cf_, game:GetService'Players'.LocalPlayer, nil, bp, true)
        return
    end
    if not tool then return end
    local swing_delay = get_axe_swingdelay(tool)
    function axe(v,id,h)
        local hps = get_axe_damage(tool, Wood)
        local table =  {
            ["tool"] = tool,
            ["faceVector"] = Vector3.new(0, 0, -1),
            ["height"] = h,
            ["sectionId"] = id,
            ["hitPoints"] = hps,
            ["cooldown"] = 0.112,
            ["cuttingClass"] = "Axe"
        }
        game:GetService("ReplicatedStorage").Interaction.RemoteProxy:FireServer(v.CutEvent, table)
        wait(swing_delay)
    end
    local tree_part = nil
    local sawmill = getBestSawmill()
    if sawmill == nil then return end
    local zval = round(sawmill.Settings.DimZ.Value,1)
    local oldz = zval
    local gdelay = 0.05
    local done_1 = false
    local done_2 = false
    spawn(function()
    repeat
        if round(zval,1) == 1 then
            break
        elseif zval > 1 and round(zval,1) ~= 1 then
            zval = zval - 0.2
            game:GetService("ReplicatedStorage").Interaction.RemoteProxy:FireServer(sawmill["ButtonRemote_YDown"])
        elseif zval < 1 and round(zval,1) ~= 1 then
            zval = zval + 0.2
            game:GetService("ReplicatedStorage").Interaction.RemoteProxy:FireServer(sawmill["ButtonRemote_YUp"])
        end
        wait(gdelay)
    until round(zval,1) == 1
    done_1 = true
    end)
    local xval = round(sawmill.Settings.DimX.Value,1)
    local oldx = xval
    spawn(function()
    repeat
        if round(xval,1) == 1 then
            break
        elseif xval > 1 and round(xval,1) ~= 1 then
            xval = xval - 0.2
            game:GetService("ReplicatedStorage").Interaction.RemoteProxy:FireServer(sawmill["ButtonRemote_XDown"])
        elseif xval < 1 and round(xval,1) ~= 1 then
            xval = xval + 0.2
            game:GetService("ReplicatedStorage").Interaction.RemoteProxy:FireServer(sawmill["ButtonRemote_XUp"])
        end
        wait(gdelay)
    until round(xval,1) == 1
    done_2 = true
    end)
    _G.GetTreeNC = game:GetService'RunService'.Stepped:connect(oldnocliprun)
    local finishedme = false
    for ia,va in pairs(game.Workspace:GetChildren()) do
        if va.Name == "TreeRegion" then
            for i,v in pairs (va:GetChildren()) do
                if v:FindFirstChild("TreeClass") and v.TreeClass.Value == wood and v.Name == "Model" and v:FindFirstChild("Owner") then
                    local count = 0
                    for i1,v1 in pairs (v:children()) do
                        if v1.Name == "WoodSection" then
                            count = count + 1
                        end
                    end
                    local do_tree = (count > 1 or v:FindFirstChild'WoodSection'.Size.Y > 0.5) and (v.Owner.Value == nil or game.Players.LocalPlayer)
                    local small = nil
                    if do_tree then
                        for i1,v1 in pairs (v:children()) do
                            if v1:IsA"BasePart" then
                                if not v1:FindFirstChildOfClass("Weld") then
                                    if v1.ID.Value ~= 1 then
                                        if v1:FindFirstChild("ParentID") and not v1.ChildIDs:FindFirstChild("Child") then
                                            if small == nil then small = v1 end
                                            if v1.Size.Y < small.Size.Y and math.floor(v1.Size.Y - (1/(v1.Size.X*v1.Size.Z))) > 0.3 then
                                                small = v1
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        do_tree = small ~= nil
                        if do_tree then
                            do_tree = math.floor(small.Size.Y - (1/(small.Size.X*small.Size.Z))) > 0.3
                        end
                    end
                    if do_tree then
                        _G.DogixLT2TPC(small.CFrame + Vector3.new(4,2,2),gkey)
                        local finished_t = false
                        local added = game.Workspace.LogModels.ChildAdded:Connect(function(v)
                            v:WaitForChild("Owner")
                            if v:FindFirstChild("Owner") and v.Owner.Value == plr and v.TreeClass.Value == wood then
                                tree_part = v
                                finished_t = true
                            end
                        end)
                        local height = math.floor(small.Size.Y - (1/(small.Size.X*small.Size.Z))) or 0.3
                        if height < 0 then height = 0 end
                        repeat
                            wait(0.05)
                            if v:FindFirstChild("CutEvent") ~= nil then
                                _G.DogixLT2TPC(small.CFrame + Vector3.new(4,2,2),gkey)
                                axe(v,small.ID.Value,height)
                                wait()
                            end
                        until finished_t
                        added:Disconnect()
                        added = nil
                        finished_t = false
                        finishedme = true
                        break
                    end
                end
            end
        end
        if finishedme == true then
            finishedme = false
            break
        end
    end
    _G.GetTreeNC:Disconnect()
    _G.GetTreeNC = nil
    game.Players.LocalPlayer.Character.Humanoid:ChangeState(7)
    if not tree_part then return end
    local plank = nil
    local added = game.Workspace.PlayerModels.ChildAdded:Connect(function(v)
        v:WaitForChild("Owner")
        if not v:FindFirstChild("Owner") then return end
        if not v:WaitForChild("RecentlyCut",0.3) then return end
        if v.Owner.Value == plr then
            plank = v
        end
    end)
    spawn(function()
        repeat wait() until done_1 and done_2
        done_1 = false
        done_2 = false
        for i=1,3 do
            game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(tree_part)
            tree_part:MoveTo(sawmill.Particles.CFrame.p)
            tree_part:FindFirstChild("WoodSection").CFrame = sawmill.Particles.CFrame
            game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(tree_part)
            wait()
        end
    end)
    _G.DogixLT2TPC(sawmill.Particles.CFrame+Vector3.new(7,2,4),gkey)
    repeat wait() until plank ~= nil
    added:Disconnect()
    added = nil
    repeat wait() until plank:WaitForChild("Reweld")
	spawn(function()
        repeat
            if zval == oldz then
                break
            elseif zval > oldz and round(zval,1) ~= oldz then
                zval = zval - 0.2
                game:GetService("ReplicatedStorage").Interaction.RemoteProxy:FireServer(sawmill["ButtonRemote_YDown"])
            elseif zval < oldz and round(zval,1) ~= oldz then
                zval = zval + 0.2
                game:GetService("ReplicatedStorage").Interaction.RemoteProxy:FireServer(sawmill["ButtonRemote_YUp"])
            end
            wait(gdelay)
        until round(xval,1) == oldz
	end)
    spawn(function()
        repeat
            if xval == oldx then
                break
            elseif xval > oldx and round(xval,1) ~= oldx then
                xval = xval - 0.2
                game:GetService("ReplicatedStorage").Interaction.RemoteProxy:FireServer(sawmill["ButtonRemote_XDown"])
            elseif xval < oldx and round(xval,1) ~= oldx then
                xval = xval + 0.2
                game:GetService("ReplicatedStorage").Interaction.RemoteProxy:FireServer(sawmill["ButtonRemote_XUp"])
            end
            wait(gdelay)
        until round(xval,1) == oldx
    end)
    spawn(function()
    	_G.DogixLT2TPC(oldcf + Vector3.new(0,2,0), gkey)
        local temprange = game:GetService'RunService'.RenderStepped:connect(simrad)
        local b = Instance.new("BodyPosition",plank.WoodSection)
        b.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
        b.Position = cf_.p
        b.P = 800000
        repeat wait() until plank.AncestryChanged:wait()
        temprange:Disconnect()
        temprange = nil
    end)
end

local function lumbsmasher_legitpaint(wood_class, blueprint, tpback)
    local old = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    local remote = game.ReplicatedStorage.PlaceStructure.ClientPlacedStructure
    local bp_type = blueprint.ItemName.Value
    if wood_class == nil then	
        remote:FireServer(blueprint.ItemName.Value, blueprint.Main.CFrame, game.Players.LocalPlayer, nil, blueprint, true)
        return
    end
    local required_wood = 1
    local Player = game.Players.LocalPlayer
    if not Player.SuperBlueprint.Value then
        required_wood = game:GetService("ReplicatedStorage").Purchasables.Structures.BlueprintStructures:FindFirstChild(blueprint.ItemName.Value).WoodCost.Value
    end

    --getting the axe
    local tool = getBestAxe()
    local sawmill = getBestSawmill()
    if tool == nil then
        error("Please purchase an axe.")
        return
    end
    if wood_class == "LoneCave" then
        if tool.ToolName.Value ~= "EndTimesAxe" then
            error("End Times Axe needed to chop LoneCave")
            return
        end
    end
    local WoodSection
    local Min = 9e99
    for i, v in pairs(game.Workspace:GetChildren()) do
        if v.Name == 'TreeRegion' then
            for j, Tree in pairs(v:GetChildren()) do 
                if Tree:FindFirstChild('Leaves') and Tree:FindFirstChild('WoodSection') and Tree:FindFirstChild('TreeClass') then
                    if Tree:FindFirstChild('TreeClass').Value == wood_class then
                        for k, TreeSection in pairs(Tree:GetChildren()) do
                            if TreeSection.Name == 'WoodSection' then
                                local Size = TreeSection.Size.X * TreeSection.Size.Y * TreeSection.Size.Z
                                if (Size > required_wood) and (#TreeSection.ChildIDs:GetChildren() == 0) then 
                                    if Min > TreeSection.Size.X then
                                        Min = TreeSection.Size.X
                                        WoodSection = TreeSection
                                    end
                                end
                            end 
                        end
                    end
                end
            end
        end
    end

    if not WoodSection then
        warn('Not enough tree found!')
        return 
    end

    local Chopped = false
    treecon = game.Workspace.LogModels.ChildAdded:connect(function(add)
        local Owner = add:WaitForChild('Owner')
        if (add.Owner.Value == Player) and (add.TreeClass.Value == wood_class) and add:FindFirstChild("WoodSection") then
            Chopped = add
            treecon:Disconnect()
        end
    end)

    local CutSize = required_wood / (WoodSection.Size.X * WoodSection.Size.X) + 0.01
    local swing_delay = get_axe_swingdelay(tool)
    local function axe(v,id,h)
        local hps = get_axe_damage(tool, Wood)
        local table =  {
            ["tool"] = tool,
            ["faceVector"] = Vector3.new(0, 0, -1),
            ["height"] = h,
            ["sectionId"] = id,
            ["hitPoints"] = hps,
            ["cooldown"] = 0.112,
            ["cuttingClass"] = "Axe"
        }
        game:GetService("ReplicatedStorage").Interaction.RemoteProxy:FireServer(v.CutEvent, table)
        wait(swing_delay)
    end
    local iterations = 0
    _G.GetTreeNC = game:GetService'RunService'.Stepped:connect(oldnocliprun)
    while Chopped == false do
        iterations = iterations + 1
        if iterations > 1000 then
            game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(WoodSection.Parent) 
            game.ReplicatedStorage.Interaction.DestroyStructure:FireServer(WoodSection.Parent)
            Chopped = true
            error("Failed to chop off section of tree!")
        end
        _G.DogixLT2TPC(WoodSection.CFrame + Vector3.new(4,2,2),gkey)
        axe(WoodSection.Parent, WoodSection.ID.Value, WoodSection.Size.Y - CutSize)
    end
    _G.GetTreeNC:Disconnect()
    _G.GetTreeNC = nil
    game.Players.LocalPlayer.Character.Humanoid:ChangeState(7)
    
    local target_cframe
    if blueprint:FindFirstChild("MainCFrame") then
        target_cframe = blueprint.MainCFrame.Value
    else
        target_cframe = blueprint.PrimaryPart.CFrame
    end
    
    --local fill_target_cframe = sawmill.Particles.CFrame + Vector3.new((sawmill.Main.Size.X/2)-2, 0, 0)
    local fill_target_cframe = sawmill.Particles.CFrame + Vector3.new(0,1,0)
    --teleport bp to sawmill --ignore as teleporting to wood directly
    --game.ReplicatedStorage.PlaceStructure.ClientPlacedBlueprint:FireServer(blueprint.ItemName.Value, fill_target_cframe, game.Players.LocalPlayer, blueprint, true)
    
    
    iterations = 0
    local Sawed = false
    sawconn = game.Workspace.PlayerModels.ChildAdded:connect(function(add)
        local Owner = add:WaitForChild('Owner')
        if (add.Owner.Value == Player) and add:FindFirstChild("WoodSection") then
            if not add:FindFirstChild('TreeClass') then
                repeat wait() until add:FindFirstChild('TreeClass')
            end 
            if add.TreeClass.Value == wood_class then
                Sawed = add
                sawconn:Disconnect()
            end
        end
    end)
    iterations = 0
    while Chopped.Parent ~= nil do
        if Sawed then
            break
        end
        iterations = iterations + 1
        if iterations > 300 then
            error("Failed to sawmill tree!")
        end
        _G.DogixLT2TPC(CFrame.new(Chopped.WoodSection.Position) + Vector3.new(0, 4, 0), gkey)
        -- game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(Chopped.WoodSection)
        game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(Chopped)
        Chopped.PrimaryPart = Chopped.WoodSection
        Chopped:SetPrimaryPartCFrame(sawmill.Particles.CFrame)
        --Chopped.WoodSection.CFrame = sawmill.Particles.CFrame
        game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(Chopped) 
        wait(2)
    end 
    repeat wait() until Sawed
    iterations = 0

    
    local placed = false
    local new_structure_connection
    new_structure_connection = game.Workspace.PlayerModels.ChildAdded:Connect(function(child)
        local owner = child:WaitForChild("Owner")
        if owner.Value == game.Players.LocalPlayer and child:FindFirstChild("Type") and child.Type.Value == "Structure" then
            if not child:FindFirstChild("BuildDependentWood") then
                warn("[LumbSmasher-API / WARN]: No build dependent wood on child!")
                return
            end
            new_structure_connection:Disconnect()
            local wood_type
            if child:FindFirstChild("BlueprintWoodClass") then
                wood_type = child.BlueprintWoodClass.Value
            end
            remote:FireServer(child.ItemName.Value, target_cframe, game.Players.LocalPlayer, wood_type, child, true, nil)
            placed = true
            --pcall(rconsoleprint, "Moved and Placed Structure!\n")
        end
    end)
    while Sawed.Parent ~= nil do
        --pcall(rconsoleprint, "Plank Exists! Filling Blueprint...\n")
        if iterations > 50 then
            --if blueprint.Parent then
                game.ReplicatedStorage.Interaction.DestroyStructure:FireServer(Sawed)
                game.ReplicatedStorage.Interaction.DestroyStructure:FireServer(blueprint)
                --pcall(rconsoleprint, "Way too many attempts to teleport blueprint to wood!\n")
                error("Way too many attempts to teleport blueprint to wood!")
            --end
        end
        iterations = iterations + 1
        if Sawed.Parent == nil then
            break
        end
        local connection, blueprint_made
        connection = game.Workspace.PlayerModels.ChildAdded:Connect(function(child)
            if child:WaitForChild("Owner") and child.Owner.Value == game.Players.LocalPlayer and child:FindFirstChild("Type") and child.Type.Value == "Blueprint" then
                connection:Disconnect()
                blueprint = child
                blueprint_made = true
            end
        end)
        game.ReplicatedStorage.PlaceStructure.ClientPlacedBlueprint:FireServer(bp_type, Sawed.WoodSection.CFrame, game.Players.LocalPlayer, blueprint, blueprint.Parent ~= nil)
        --pcall(rconsoleprint, "Waiting for BP Move...\n")
        local bp_wait_iter = 0
        repeat 
            if bp_wait_iter > 500 then
                error("Blueprint Failed")
                --game.ReplicatedStorage.Interaction.DestroyStructure:FireServer(blueprint)
                --game.ReplicatedStorage.PlaceStructure.ClientPlacedBlueprint:FireServer(bp_type, Sawed.WoodSection.CFrame, game.Players.LocalPlayer, nil, false)
                --bp_wait_iter = 0
            end
            wait()
            bp_wait_iter = bp_wait_iter + 1
        until blueprint_made or placed
        if placed then
            pcall(connection.Disconnect, connection)
        end
        
    end 
    iterations = 0
    --pcall(rconsoleprint, "Waiting for placement...\n")
    repeat wait() until placed
    --pcall(rconsoleprint, "Placed!\n")
    if tpback then
        _G.DogixLT2TPC(old, gkey, true)
    end
end

----- Build GUI
local commands = {}
local BarkCommandLine = Instance.new("ScreenGui")
_G.BarkCommandLine = BarkCommandLine
local CommandBar = Instance.new("TextBox")
local MessageBox = Instance.new("Frame")
local MessageText = Instance.new("TextLabel")
local Commands = Instance.new("ScrollingFrame")
local Exit = Instance.new("TextButton")
--Properties:
BarkCommandLine.Name = "BarkCommandLine"
BarkCommandLine.Parent = game.CoreGui
BarkCommandLine.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

CommandBar.Name = "CommandBar"
CommandBar.Parent = BarkCommandLine
CommandBar.BackgroundColor3 = Color3.new(0, 0, 0)
CommandBar.BackgroundTransparency = 0.5
CommandBar.BorderColor3 = Color3.new(0, 0, 0)
CommandBar.Position = UDim2.new(0, 0, -1, 0)
CommandBar.Size = UDim2.new(1, 0, 0, 77)
CommandBar.Font = Enum.Font.Gotham
CommandBar.Text = ""
CommandBar.TextColor3 = Color3.new(1, 1, 1)
CommandBar.TextScaled = true
CommandBar.TextSize = 10
CommandBar.TextWrapped = true
CommandBar.TextXAlignment = Enum.TextXAlignment.Left

MessageBox.Name = "MessageBox"
MessageBox.Parent = BarkCommandLine
MessageBox.BackgroundColor3 = Color3.new(0.0980392, 0.0980392, 0.0980392)
MessageBox.Position = UDim2.new(0, 0, 2, 0)
MessageBox.Size = UDim2.new(0, 541, 0, 100)

MessageText.Name = "MessageText"
MessageText.Parent = MessageBox
MessageText.BackgroundColor3 = Color3.new(1, 1, 1)
MessageText.BackgroundTransparency = 1
MessageText.Size = UDim2.new(0, 541, 0, 108)
MessageText.Font = Enum.Font.SourceSans
MessageText.Text = "Bark Message:"
MessageText.TextColor3 = Color3.new(1, 1, 1)
MessageText.TextSize = 25
MessageText.TextWrapped = true

Commands.Name = "Commands"
Commands.Parent = BarkCommandLine
Commands.Active = true
Commands.Draggable = true
Commands.BackgroundColor3 = Color3.new(0.0980392, 0.0980392, 0.0980392)
Commands.BorderColor3 = Color3.new(0.0980392, 0.0980392, 0.0980392)
Commands.Position = UDim2.new(0.307000011, 0, -1, 0)
Commands.Size = UDim2.new(0, 392, 0, 203)
Commands.ScrollBarThickness = 5
Commands.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left

Exit.Name = "Exit"
Exit.Parent = Commands
Exit.BackgroundColor3 = Color3.new(0.0980392, 0.0980392, 0.0980392)
Exit.BorderColor3 = Color3.new(0.0980392, 0.0980392, 0.0980392)
Exit.Position = UDim2.new(0.948448956, 0, -0.000801198184, 0)
Exit.Size = UDim2.new(0, 20, 0, 20)
Exit.Font = Enum.Font.SourceSans
Exit.Text = "X"
Exit.TextColor3 = Color3.new(1, 1, 1)
Exit.TextScaled = true
Exit.TextSize = 14
Exit.TextWrapped = true

local CMDBAR = CommandBar
local Message = MessageText
local CMD = Commands
local cmdExit = Exit
local Box = MessageBox
local effect = Instance.new("BlurEffect",game.Workspace.CurrentCamera)
local input = game:GetService("UserInputService")
local showGUI = false
local commandpassed = false
local commands = {}

cmdExit.MouseButton1Click:connect(function()
	Tween(CMD,0.5,{Position = UDim2.new(0.307,0,-1,0)})
end)

effect.Size = 0
effect.Enabled = true

function Tween(O,T,S)
    if O then game:GetService("TweenService"):Create(O,TweenInfo.new(T),S):Play() end
end

CMDBAR.FocusLost:connect(function(e)
    MoveGUI()
    if e then
        if not parse_command(CMDBAR.Text) then
            ShowMSG("Invalid command!",3)
        end
    end
    CMDBAR.Text = ""
end)
local FREEZE_ACTION = "freezeMovement"
function MoveGUI()
	if showGUI then
		showGUI = false
		Tween(CMDBAR,0.5,{Position = UDim2.new(0,0,-1,0)})
		for i=6,0,-1 do
			effect.Size = i*4
			wait()
		end
		game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
        game:GetService("ContextActionService"):UnbindAction(FREEZE_ACTION)
	else
		showGUI = true
        CMDBAR:CaptureFocus()
		game:GetService("ContextActionService"):BindAction(
            FREEZE_ACTION,
            function() return Enum.ContextActionResult.Sink end,
            false,
            unpack(Enum.PlayerActions:GetEnumItems())
        )
		game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
		Tween(CMDBAR,0.5,{Position = UDim2.new(0,0,0,0)})
		for i=0,25 do
    		effect.Size = i
    		wait(0.00005)
		end
		--CMDBAR:CaptureFocus()
	end
end

function ShowMSG(msg,waitdelay)
	if effect.Size == 25 then
		Tween(CMDBAR,0.5,{Position = UDim2.new(0,0,2,0)})
	    Message.Text = msg
		Tween(Box, 0.5,{Position = UDim2.new(0.025,0,0.975,-100)})
		wait(waitdelay)
		Tween(Box, 0.5,{Position = UDim2.new(0,0,1,200)})
		Tween(CMDBAR,0.5,{Position = UDim2.new(0,0)})
	else
		Message.Text = msg
		Tween(Box, 0.5,{Position = UDim2.new(0.025,0,0.975,-100)})
		wait(waitdelay)
		Tween(Box, 0.5,{Position = UDim2.new(0,0,1,200)})
	end
end
local o = Instance.new("TextLabel",Commands)
o.Text = ""
o.Position = UDim2.new(0,10,0,20)
o.Size = UDim2.new(1,0,1,0)
o.Font = Enum.Font.SourceSansSemibold
o.TextColor3 = Color3.fromRGB(255,255,255)
o.TextStrokeTransparency = 0
o.BackgroundTransparency = 1
o.BackgroundColor3 = Color3.new(0,0,0)
o.BorderSizePixel = 0
o.BorderColor3 = Color3.new(0,0,0)
o.FontSize = "Size14"
o.Active = true
o.Draggable = false
o.TextXAlignment = Enum.TextXAlignment.Left
o.TextYAlignment = Enum.TextYAlignment.Top
o.ClipsDescendants = true
function AddCmd(cmdName)
	o.Text = o.Text..cmdName.."\n"
end
function ClearCmd()
	o.Text = ""
end
function HSL(hue, saturation, lightness, alpha)
    if hue < 0 or hue > 360 then
        return 0, 0, 0, alpha
    end
    if saturation < 0 or saturation > 1 then
        return 0, 0, 0, alpha
    end
    if lightness < 0 or lightness > 1 then
        return 0, 0, 0, alpha
    end
    local chroma = (1 - math.abs(2 * lightness - 1)) * saturation
    local h = hue/60
    local x =(1 - math.abs(h % 2 - 1)) * chroma
    local r, g, b = 0, 0, 0
    if h < 1 then
        r,g,b=chroma,x,0
    elseif h < 2 then
        r,b,g=x,chroma,0
    elseif h < 3 then
        r,g,b=0,chroma,x
    elseif h < 4 then
        r,g,b=0,x,chroma
    elseif h < 5 then
        r,g,b=x,0,chroma
    else
        r,g,b=chroma,0,x
    end
    local m = lightness - chroma/2
    return r+m,g+m,b+m,alpha
end
local main
if getgenv().azure_theme then
    local azurelib = loadstring(game:HttpGetAsync("https://cdn.applebee1558.com/bark/azurelib.lua"))()
    lib = azurelib
    main = azurelib.initiate({
        projName = "BarkUI",
        resize = true,
        MinSize = UDim2.new(0,500,0,369),
        MaxSize = UDim2.new(0,769,0,514),
    })
    main.Screengui = main.screengui
    main.CreateCategory = function(self, category_name)
        local category = main.category(category_name)
        local categoryapi = {
            CreateSection = function(self, section_name)
                local section = category.section(section_name)
                local api = {
                    Create = function(self, type, label, callback, additional_opts)
                        if type == "Toggle" then
                            return section.toggle(label, callback, (additional_opts and additional_opts.default))
                        elseif type == "Dropdown" or type == "DropDown" then
                            local playerlist = false
                            if additional_opts.playerlist then
                                playerlist = true
                            end
                            local currentlist = additional_opts.options
                            local dropdown = section.dropdown(label, callback, additional_opts.options, playerlist, additional_opts.search, function() return currentlist end)
                            local api = {
                                SetDropDownList = function(self, payload)
                                    currentlist = payload
                                end
                            }
                            return api
                        elseif type == "TextBox" then
                            return section.textbox(label, callback, "placeholder")
                        elseif type == "Button" then
                            return section.button(label,callback, (additional_opts and additional_opts.animated))
                        elseif type == "Slider" then
                            return section.slider(label, callback, additional_opts.min, additional_opts.max, additional_opts.default)
                        elseif type == "TextLabel" then
                            return section.label(label)
                        elseif type == "KeyBind" then
                            return section.keybind(label,callback, additional_opts.default)
                        elseif type == "ColorPicker" then
                            return section.colorpicker(label,callback, additional_opts.default)
                        else
                            warn("Unknown Type: ", type)
                        end
                    end
                }
                return api
            end
        }
        return categoryapi
    end
    main.screengui.MainFrame.TopNavBar.Logo.Text = "Bark "..cv

elseif getgenv().blood_theme then
    local lib = loadstring(http_request({Url="https://cdn.applebee1558.com/bark/discordlib.lua", Method="GET"}).Body)()
    local window = lib:Window("Bark "..cv.."             #Bark Winning")
    local server = window:Server("Bark "..cv, "")
    local fake_flux = {
        Tab = function(self, tab_name, ...)
            local channel = server:Channel(tab_name)
            local fake_tabapi = {
                channel = channel,
                Toggle = function(self, label, no, default, no2,callback)
                    return self.channel:Toggle(label, default, callback)
                end,
                Dropdown = function(self, label, options, callback)
                    return self.channel:Dropdown(label, options, callback)
                end,
                Textbox = function(self, label, placeholder, no, callback)
                    return self.channel:Textbox(label, placeholder, no, callback)
                end,
                Button = function(self, label, no, callback)
                    return self.channel:Button(label, callback)
                end,
                Slider = function(self, label, no, min, max, default, callback)
                    return self.channel:Slider(label, min, max,default,callback)
                end,
                Label = function(self, text)
                    return self.channel:Label(text)
                end
            }
            setmetatable(fake_tabapi, {__index=function(self, index) warn("Unknown Type: "..tostring(index)) return function(...) end end})
            return fake_tabapi
        end,
        SetCloseBind = function(...) end,
        screengui = game.CoreGui:FindFirstChild("Discord")
    }
    fake_flux.screengui.Name = "BarkUI"
    getgenv().alphax_ui_init = fake_flux
end

if not main then
    main = lib:CreateMain({
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
elseif not getgenv().azure_theme then
    local gui_icons = {
        ['Player'] = "http://www.roblox.com/asset/?id=6034287594",
        ['Game'] = "http://www.roblox.com/asset/?id=6034287594",
        ['Environment'] = "http://www.roblox.com/asset/?id=6034287594",
        ['Slot'] = "http://www.roblox.com/asset/?id=6031302961",
        ['Items'] = "http://www.roblox.com/asset/?id=6031302961",
        ['Auto Buy'] = "http://www.roblox.com/asset/?id=6034509997",
        ['Bases'] = 'http://www.roblox.com/asset/?id=6034509997',
        ['Admin'] = "http://www.roblox.com/asset/?id=6034509997"
    }
    UI_Init = getgenv().alphax_ui_init
    main = {
        CreateCategory = function(self, category_name)
            local tab = UI_Init:Tab(category_name, (gui_icons[category_name] or "https://www.roblox.com/asset/?id=6034275725"))
            local api = {
                Create = function(self, type, label, callback, additional_opts)
                    if type == "Toggle" then
                        return tab:Toggle(label, "placeholder", (additional_opts and additional_opts.default), "flag", callback)
                    elseif type == "Dropdown" or type == "DropDown" then
                        if additional_opts.playerlist then
                            local player_list = {}
                            for i,v in pairs(game.Players:GetChildren()) do
                                table.insert(player_list, v.Name)
                            end
                            additional_opts.options = player_list
                        end
                        local dropdown = tab:Dropdown(label, additional_opts.options, callback, true)
                        local api = {
                            SetDropDownList = function(self, payload)
                                dropdown:Clear()
                                for i, v in pairs(payload.options) do
                                    dropdown:Add(v)
                                end
                            end
                        }
                        return api
                    elseif type == "TextBox" then
                        return tab:Textbox(label, "placeholder", true, callback)
                    elseif type == "Button" then
                        return tab:Button(label, "placeholder", callback)
                    elseif type == "Slider" then
                        return tab:Slider(label, 'placeholder', additional_opts.min, additional_opts.max, additional_opts.default, callback)
                    elseif type == "TextLabel" then
                        return tab:Label(label)
                    elseif type == "KeyBind" then
                        return tab:Bind(label, additional_opts.default, function() end, callback)
                    elseif type == "ColorPicker" then
                        return tab:Colorpicker(label, additional_opts.default, callback)
                    else
                        warn("Unknown Type: ", type)
                    end
                end,
                CreateSection = function(self, section_name)
                    tab:Line()
                    tab:Label(section_name)
                    return self
                end
            }
            return api
        end,
    Screengui = UI_Init.screengui or game:GetService("CoreGui"):FindFirstChild("FluxLib")
    }
    game.StarterGui:SetCore("SendNotification", {
        Title = "Bark "..cv;
        Text = "Using Alpha X UI Port may result in errors | Get the original Bark here at https://discord.gg/bark";
        Icon = nil;
        Duration = 9e9;
        Button1 = "OK";
    })
end
_G.CurrentBarkUI = main.Screengui
emain = main
local wc = main:CreateCategory("Bark "..cv)
local opts2 = wc:CreateSection("Welcome to Bark "..cv.." | https://discord.gg/bark")
if is_bark_executor then
    opts2:Create(
        "Toggle",
        "Show Internal Executor",
        function(state)
            getgenv().FLUXUS_LOADED = true --oxygen has pretty much everything fluxus has
            getgenv().KRNL_LOADED = true
            if getgenv().galaxybark and getgenv().galaxybark.Parent ~= nil then
                getgenv().galaxybark:Destroy()
                getgenv().galaxybark = nil
            end
            if state then
                loadstring(http_request({Url=("https://cdn.applebee1558.com/bark/executor/galaxybark.lua")}).Body)()
                rconsoleclear()
            end
        end
    )
end

opts2:Create(
    "Toggle",
    "Infinite Range",
    function(state)
        if state then
            _G.InfRanges = game:GetService'RunService'.RenderStepped:connect(simrad)
        else
            if _G.InfRanges~=nil then
                _G.InfRanges:Disconnect()
                _G.InfRanges = nil
            end
        end
    end,
    {
        default = false,
    }
)


--Ancestor Dupe Base Method
requirements={
    Booleans={
        DonatingBase=false;
    }
}

function getPlots()
    Plots={};
    requirements.Booleans.DonatingBase=true;
    for i,v in next,workspace.Properties:children()do
        if v:FindFirstChild("Owner") and v.Owner.Value==nil then 
            table.insert(Plots, v);
            return Plots;
        end;
    end;
end;

function SelfWl(value)
    game:GetService("ReplicatedStorage").Interaction.ClientSetListPlayer:InvokeServer(game.Players.LocalPlayer.WhitelistFolder,game.Players.LocalPlayer,value);
end;
local dupeMoneyShit={
    MoneyDuping=false;
};
function fastLoadSelectedPlot(slotnum)
    scr=getsenv(game.Players.LocalPlayer.PlayerGui.PropertyPurchasingGUI.PropertyPurchasingClient);
    loadedSlot=nil;
    if game.Players.LocalPlayer.CurrentSaveSlot.Value~=-1 and not dupeMoneyShit.MoneyDuping then 
        game:GetService("ReplicatedStorage").LoadSaveRequests.RequestSave:InvokeServer(game.Players.LocalPlayer.CurrentSaveSlot.Value,game.Players.LocalPlayer)
    end
    spawn(function()
        loadedSlot=game:GetService("ReplicatedStorage").LoadSaveRequests.RequestLoad:InvokeServer(slotnum,game.Players.LocalPlayer);
    end);
    repeat wait()until game.Players.LocalPlayer.PlayerGui.PropertyPurchasingGUI.SelectPurchase.Visible;
    for i=1,20 do 
        wait(.15);
        scr.selectionMade();
    end;
    repeat wait()until loadedSlot~=nil;
    game.Players.LocalPlayer.CurrentSaveSlot.Value=slotnum;
    return loadedSlot;
end;

function DupeBaseToServer()
    Plots=getPlots();
    game:GetService("ReplicatedStorage").Interaction.ClientIsDragging:FireServer(Plots[1]);
    SelfWl(true);
    repeat wait()until Plots[1].Owner.Value==game.Players.LocalPlayer;
    notify("Notify", "Claimed "..tostring(Plots[1].Owner.Value), 4);
    fastLoadSelectedPlot(game.Players.LocalPlayer.CurrentSaveSlot.Value);
    repeat wait()until not game.Players.LocalPlayer.CurrentlySavingOrLoading.Value;
    requirements.Booleans.DonatingBase=false;
    SelfWl(false);
    return true;
end;
local alertTarget=false;

function whisperToTarget(player)
    if alertTarget then 
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("/w "..tostring(player).." load your base over my base to claim it! [Powered By Bark]","All");
    end;
end;

function DupeBaseToPlayer(plr)
    DupeBaseToServer();
    return true
end;

function PlotLogic()
    if game.Players.LocalPlayer.CurrentSaveSlot.Value== -1 then
        notify("Error", "No Plot Is Loaded..", 4);
        return;                      
    end;
    if not game:GetService("ReplicatedStorage").LoadSaveRequests.ClientMayLoad:InvokeServer(game.Players.LocalPlayer)then
        notify("Error", "Load is on cooldown. Waiting...", 4)
        repeat
            wait(5)
        until game:GetService("ReplicatedStorage").LoadSaveRequests.ClientMayLoad:InvokeServer(game.Players.LocalPlayer)
        notify("Notify", "Loading plot...", 4);
    end;
    return true;
end;

function DonatePlotToPlayer()
    if tostring(game.Players.LocalPlayer)==tostring(playerToDupeTo)then 
        notify("Error","Select another player!",4);
        return;
    end;
    if not getgenv().block_save then 
        notify("Error","Slot Saving must be Disabled!",4);
        return;
    end;
    if requirements.Booleans.DonatingBase then 
        notify("Error","Already Duping!",4);
        return;
    end;
    local success=PlotLogic();
    if success then 
        local newSuccess=DupeBaseToPlayer();
        if newSuccess then 
            game:GetService("ReplicatedStorage").Interaction.ClientSetListPlayer:InvokeServer(game.Players.LocalPlayer.WhitelistFolder,game.Players:FindFirstChild(playerToDupeTo),true);
            notify("notify","Automatically Whitelisted "..tostring(playerToDupeTo),4);
            whisperToTarget(playerToDupeTo);
            notify("notify","Successfully donated base to "..tostring(playerToDupeTo),4);
        end;
    end;
end;

function uiMode(mode)
    lp=game.Players.LocalPlayer
    local color1,color2
    function createCorner(parent)
        if not parent:FindFirstChild("UICorner")then
            local uic=Instance.new("UICorner",parent);
            uic.CornerRadius=UDim.new(0,5)
        end;
    end;

    if mode=="Light"then 
        color1=Color3.fromRGB(255,255,255);
        color2=Color3.fromRGB(0,0,0);
        color3=Color3.fromRGB(220, 220, 220)
    elseif mode=="Dark"then 
        color1=Color3.fromRGB(15,15,15)
        color2=Color3.fromRGB(255,255,255);
        color3=Color3.fromRGB(15,15,15)
    end;
    --Open Menu Button
    local openMenu=lp.PlayerGui.MenuGUI.Open
    
    createCorner(openMenu)
    openMenu.BackgroundColor3=color1
    openMenu.TextLabel.TextColor3=color2
    createCorner(openMenu.DropShadow)
    
    --Main Menu 
    local mainMenu=lp.PlayerGui.MenuGUI.Menu.Main
    local mainMenuQuit=mainMenu.Parent.Quit
    
    mainMenu.BackgroundColor3=color1
    for i,v in next,mainMenu:GetDescendants()do 
        if v:IsA("TextLabel")then 
            if v.Name~="DropShadow"then
                v.TextColor3=color2;
                v.BackgroundColor3=color1;
                createCorner(v)
                v.TextColor3=color2;
            elseif v.Name=="DropShadow"then
                createCorner(v)
                v.TextColor3=color1;
            end;
        end;
        if v:IsA("TextButton")then 
            createCorner(v)
            v.BackgroundColor3=color1;
        end;
    end;
    
    createCorner(mainMenuQuit);
    mainMenuQuit.BackgroundColor3=color1;
    mainMenuQuit.TextLabel.TextColor3=color2;
    createCorner(mainMenuQuit.DropShadow);createCorner(mainMenu);createCorner(mainMenu.DropShadow);
    
    --Load Menu 
    local loadMenu=lp.PlayerGui.LoadSaveGUI;
    loadMenu.SlotList.Main.BackgroundColor3=color1;
    for _,textLabel in next, loadMenu.SlotList.Main:GetDescendants()do 
        if textLabel:IsA("TextLabel")then
            if textLabel.Name=="IsCurrentSlot"then 
                textLabel.TextStrokeColor3=color1;
            end;
            if textLabel.Name=="DropShadow"then 
                textLabel.TextColor3=color1;
            else
            createCorner(textLabel)
            textLabel.TextColor3=color2;
        end;
        elseif textLabel:IsA("TextButton")then 
            textLabel.BackgroundColor3=color1;
            createCorner(textLabel)
        end;
    end;
    lp.PlayerGui.PropertyPurchasingGUI.SelectPurchase.Cost.BackgroundColor3=color1
    --Quit
    createCorner(loadMenu.SlotList.Quit)
    loadMenu.SlotList.Quit.BackgroundColor3=color1;
    loadMenu.SlotList.Quit.TextLabel.TextColor3=color2;
    createCorner(loadMenu.SlotList.Quit.DropShadow);
    createCorner(loadMenu.SlotList.Main);createCorner(loadMenu.SlotList.Main.DropShadow)
    --Load Current Slot 
    local slotInfoMain=loadMenu.SlotInfo.Main 
    local progress=loadMenu.Progress
    for _,v in next,progress:GetDescendants()do 
        if v:IsA"Frame" then 
            createCorner(v);
            if v.Name~="DropShadow"then 
                v.BackgroundColor3=color1;
            end;
        end;
    end;
    createCorner(progress.Main.Text);progress.Main.Text.BackgroundColor3=color1;progress.Main.Text.TextColor3=color2
    
    createCorner(slotInfoMain);createCorner(slotInfoMain.DropShadow)
    for _,button in next,slotInfoMain:GetDescendants()do 
        if button:IsA("TextButton")or button:IsA("TextLabel")then 
            button.BackgroundColor3=color1
            button.TextColor3=color2
            createCorner(button);
        end;
    end;
    slotInfoMain.BackgroundColor3=color1
    
    --Load Quit 
    createCorner(slotInfoMain.Parent.Quit)
    slotInfoMain.Parent.Quit.BackgroundColor3=color1;
    slotInfoMain.Parent.Quit.TextLabel.TextColor3=color2;
    createCorner(slotInfoMain.Parent.Quit.DropShadow);
    createCorner(slotInfoMain.Parent.Quit);createCorner(slotInfoMain.Parent.Quit.DropShadow)
    
    --Select Plot
    local selectPlot=lp.PlayerGui.PropertyPurchasingGUI
    for _, v in next,selectPlot:GetDescendants()do 
        if v.ClassName=="Frame"then 
            createCorner(v);
            if v.Name=="DropShadow"then 
                v.BackgroundColor3=Color3.fromRGB(0,0,0)
            else
                v.BackgroundColor3=color1
            end;
        end;
        if v:IsA("TextLabel")or v:IsA"TextButton"then 
            v.TextColor3=color2
            v.BackgroundColor3=color1
            createCorner(v);
        end;
    end;
    --Notice
    local noticeUI=lp.PlayerGui.NoticeGUI.Notice.Main 
    createCorner(noticeUI)
    noticeUI.BackgroundColor3=color1
    for _,v in next,noticeUI:GetDescendants()do 
        if v:IsA("TextButton")or v:IsA("TextLabel")then 
            v.TextColor3=color2
            v.BackgroundColor3=color1
            createCorner(v);
        end;
        if v:IsA("Frame")then 
            createCorner(v)
        end;
    end;
    
    --Money Gui 
    local buyMoney=lp.PlayerGui.BuyMoneyGUI.BuyMoney 
    
    for _,v in next,buyMoney:GetDescendants()do 
        if v:IsA("Frame")then 
            createCorner(v)
            if v.Name~="DropShadow"then 
                v.BackgroundColor3=color1;
            end;
        end;
        if v:IsA("TextLabel")and not string.find(v.Text,"R")then 
            if v.Name~="DropShadow"then 
                v.TextColor3=color2;
            else
                v.TextColor3=color1;
            end;
            v.BackgroundColor3=color1;
        end;
        if v:IsA"TextButton"then 
            v.BackgroundColor3=color1;
        end;
        createCorner(v);
    end;
    
    --Whitelist 
    local whiteListGui=lp.PlayerGui.WhiteListGUI 
    
    for _,v in next,whiteListGui:GetDescendants()do
        if v:IsA"Frame"then 
            createCorner(v);
            if v.Name~="DropShadow"then
                v.BackgroundColor3=color1;
            end;
        end;
        if v:IsA"TextLabel"or v:IsA"TextButton"then 
            if v.Name=="InfoT"then 
                v.TextStrokeColor3=color1;
            end;
            if v.Name~="DropShadow"then
                v.TextColor3=color2
            else
                v.TextColor3=color1;
                v.TextStrokeColor3=color2;
            end;
            v.BackgroundColor3=color1;
            createCorner(v);
        end;
        if v:IsA"ScrollingFrame"then 
            v.BackgroundColor3=color1;
        end;
    end;
    
    --Blacklist 
    local blackListGui=lp.PlayerGui.BlackListGUI 
    
    for _,v in next,blackListGui:GetDescendants()do
        if v:IsA"Frame"then 
            createCorner(v);
            if v.Name~="DropShadow"then
                v.BackgroundColor3=color1;
            end;
        end;
        if v:IsA"TextLabel"and v.Name~="InfoT"or v:IsA"TextButton"then 
            if v.Name~="DropShadow"then
                v.TextColor3=color2
            else
                v.TextColor3=color1;
            end;
            v.BackgroundColor3=color1;
            createCorner(v);
        end;
        if v:IsA"ScrollingFrame"then 
            v.BackgroundColor3=color1;
        end;
    end;
    
    --Send Money 
    
    local sendMoney=lp.PlayerGui.DonateGUI 
    
    for _,v in next,sendMoney:GetDescendants()do
        if v:IsA"Frame"then 
            createCorner(v);
            if v.Name~="DropShadow"then
                v.BackgroundColor3=color1;
            end;
        end;
        if v:IsA"TextLabel"and v.Name~="InfoT"or v:IsA"TextButton"then 
            if v.Name~="DropShadow"then
                v.TextColor3=color2
            else
                v.TextColor3=color1;
            end;
            v.BackgroundColor3=color1;
            createCorner(v);
        end;
        if v:IsA"ScrollingFrame"then 
            v.BackgroundColor3=color1;
        end;
    end;
    game:GetService("Players").LocalPlayer.PlayerGui.DonateGUI.Donate.Main.AmountLabel.BackgroundColor3=Color3.fromRGB(0,155,0);
    createCorner(game:GetService("Players").LocalPlayer.PlayerGui.DonateGUI.Donate.Main.AmountLabel)
    game:GetService("Players").LocalPlayer.PlayerGui.DonateGUI.Donate.Main.AmountLabel.TextColor3=color2
    --Changelog 
    local changeLog=lp.PlayerGui.ChangelogGUI
    
    for _,v in next,changeLog:GetDescendants()do
        if v:IsA"Frame"then 
            createCorner(v);
            if v.Name~="DropShadow"then
                v.BackgroundColor3=color1;
            end;
        end;
        if v:IsA"TextLabel"and v.Name~="InfoT"or v:IsA"TextButton"then 
            if v.Name~="DropShadow"then
                v.TextColor3=color2
            else
                v.TextColor3=color1;
            end;
            v.BackgroundColor3=color1;
            createCorner(v);
        end;
    end;
    
    --Credits
    local creditsUI=lp.PlayerGui.CreditsGUI
    
    for _,v in next,creditsUI:GetDescendants()do
        if v:IsA"Frame"then 
            createCorner(v);
            if v.Name~="DropShadow"then
                v.BackgroundColor3=color1;
            end;
        end;
        if v:IsA"TextLabel"and v.Name~="InfoT"or v:IsA"TextButton"then 
            if v.Name~="DropShadow"then
                v.TextColor3=color2
            else
                v.TextColor3=color1;
            end;
            v.BackgroundColor3=color1;
            createCorner(v);
        end;
    end;
    
    local scr=getsenv(game.Players.LocalPlayer.PlayerGui.CreditsGUI.CreditsClient)
        local old=scr.openWindow
        local old2=scr.displayPage
        scr.openWindow=function()
            old()
            local creditsUI=lp.PlayerGui.CreditsGUI
            for _,v in next,creditsUI:GetDescendants()do
                if v:IsA"Frame"then 
                    createCorner(v);
                    if v.Name~="DropShadow"then
                        v.BackgroundColor3=color1;
                    end;
                end;
                if v:IsA"TextLabel"and v.Name~="InfoT"or v:IsA"TextButton"then 
                    if v.Name~="DropShadow"then
                        v.TextColor3=color2
                    else
                        v.TextColor3=color1;
                    end;
                    v.BackgroundColor3=color1;
                    createCorner(v);
                end;
            end;
        end;
        scr.displayPage=function()
        old2()
        local creditsUI=lp.PlayerGui.CreditsGUI
        for _,v in next,creditsUI:GetDescendants()do
            if v:IsA"Frame"then 
                createCorner(v);
                if v.Name~="DropShadow"then
                    v.BackgroundColor3=color1;
                end;
            end;
            if v:IsA"TextLabel"and v.Name~="InfoT"or v:IsA"TextButton"then 
                if v.Name~="DropShadow"then
                    v.TextColor3=color2
                else
                    v.TextColor3=color1;
                end;
                v.BackgroundColor3=color1;
                createCorner(v);
            end;
        end;
    end;
    
    --OnBoarding 
    local onBoardingGUI=lp.PlayerGui.OnboardingGUI
    
    for _,v in next,onBoardingGUI:GetDescendants()do
        if v:IsA"Frame"then 
            createCorner(v);
            if v.Name~="DropShadow"then
                v.BackgroundColor3=color1;
            end;
        end;
        if v:IsA"TextLabel"and v.Name~="InfoT"or v:IsA"TextButton"then 
            if v.Name~="DropShadow"then
                v.TextColor3=color2
            else
                v.TextColor3=color1;
            end;
            v.BackgroundColor3=color1;
            createCorner(v);
        end;
    end;
    --Chat GUI
    local chat=lp.PlayerGui.ChatGUI
    for _,v in next,chat:GetDescendants()do
        if v:IsA"Frame"then 
            createCorner(v);
            if v.Name~="DropShadow"then
                v.BackgroundColor3=color1;
            end;
        end;
        if v:IsA"TextLabel"and v.Name~="InfoT"or v:IsA"TextButton"then 
            if v.Name~="DropShadow"then
                v.TextColor3=color2
            else
                v.TextColor3=color1;
            end;
            v.BackgroundColor3=color1;
            createCorner(v);
        end;
    end;
    --ItemDraggerGUI 
    local itemDraggingGUI=lp.PlayerGui.ItemDraggingGUI
    for _,v in next,itemDraggingGUI:GetDescendants()do
        if v:IsA"Frame"then 
            createCorner(v);
            if v.Name~="DropShadow"then
                v.BackgroundColor3=color1;
            end;
        end;
        if v:IsA"TextLabel"and v.Name~="InfoT"or v:IsA"TextButton"then 
            v.TextColor3=color2
            v.BackgroundColor3=color1;
            createCorner(v);
        end;
    end;
    --ItemInfo 
    local itemInfoGUI=lp.PlayerGui.ItemInfoGUI
    for _,v in next,itemInfoGUI:GetDescendants()do
        if v:IsA"Frame"then 
            createCorner(v);
            if v.Name~="DropShadow"then
                v.BackgroundColor3=color1;
            end;
        end;
        if v:IsA("ImageLabel")then 
            v.BackgroundColor3=color1;
            createCorner(v);
        end;
        if v:IsA"TextLabel"and v.Name~="InfoT"or v:IsA"TextButton"then 
            if v.Name~="DropShadow"then
                v.TextColor3=color2
                v.TextStrokeColor3=color1
            else
                v.TextColor3=color1;
                v.TextStrokeColor3=color1
            end;
            v.BackgroundColor3=color1;
            createCorner(v);
        end;
    end;
    --InteractionGUI
    local interactionGUI=lp.PlayerGui.InteractionGUI
    for _,v in next,interactionGUI:GetDescendants()do
        if v:IsA"Frame"then 
            createCorner(v);
            if v.Name~="DropShadow"then
                v.BackgroundColor3=color2;
            end;
        end;
        if v:IsA"TextLabel"and v.Name~="InfoT"or v:IsA"TextButton"then 
            if v.Name~="DropShadow"then
                v.TextColor3=color2
            else
                v.TextColor3=color1;
            end;
            v.BackgroundColor3=color1;
            createCorner(v);
        end;
    end;
    game:GetService("Players").LocalPlayer.PlayerGui.InteractionGUI.OwnerShow.BackgroundColor3=color1;
    --StructureGui
    local structureDraggingGUI=lp.PlayerGui.StructureDraggingGUI
    for _,v in next,structureDraggingGUI:GetDescendants()do
        if v:IsA"Frame"then 
            createCorner(v);
            if v.Name~="DropShadow"then
                v.BackgroundColor3=color1;
            end;
        end;
        if v:IsA"TextLabel"and v.Name~="InfoT"or v:IsA"TextButton"then 
            if v.Name~="DropShadow"then
                v.TextColor3=color2
            else
                v.TextColor3=color1;
            end;
            v.BackgroundColor3=color1;
            createCorner(v);
        end;
    end;
    --WireDraggingGUI
    local wireDraggingGUI=lp.PlayerGui.WireDraggingGUI
    for _,v in next,wireDraggingGUI:GetDescendants()do
        if v:IsA"Frame"then 
            createCorner(v);
            if v.Name~="DropShadow"then
                v.BackgroundColor3=color1;
            end;
        end;
        if v:IsA"TextLabel"and v.Name~="InfoT"or v:IsA"TextButton"then 
            if v.Name~="DropShadow"then
                v.TextColor3=color2
            else
                v.TextColor3=color1;
            end;
            v.BackgroundColor3=color1;
            createCorner(v);
        end;
    end;
    --OverWriteConfirm
    local overWriteConfirm=loadMenu.OverwriteConfirm
    for _,v in next,overWriteConfirm:GetDescendants()do
        if v:IsA"Frame"then 
            createCorner(v);
            if v.Name~="DropShadow"then
                v.BackgroundColor3=color1;
            end;
        end;
        if v:IsA"TextLabel"and v.Name~="InfoT"or v:IsA"TextButton"then 
            if v.Name~="DropShadow"then
                v.TextColor3=color2
            else
                v.TextColor3=color1;
            end;
            v.BackgroundColor3=color1;
            createCorner(v);
        end;
    end;
    game:GetService("Players").LocalPlayer.PlayerGui.ItemDraggingGUI.CanDrag.PlatformButton.KeyLabel.TextSize=14;
    game:GetService("Players").LocalPlayer.PlayerGui.ItemDraggingGUI.CanRotate.PlatformButton.KeyLabel.TextSize=14
    game:GetService("Players").LocalPlayer.PlayerGui.ItemDraggingGUI.CanRotate.PlatformButton.KeyLabel.TextScaled=false;
    for _,v in next,game:GetService("Players").LocalPlayer.PlayerGui:GetDescendants()do 
        if v.Name=="KeyLabel"then 
            v.TextColor3=Color3.fromRGB(0,0,0);
        end;
    end;
    --Blueprints
    local scr=getsenv(game.Players.LocalPlayer.PlayerGui.Blueprints.LocalBlueprints)
    local old=scr.populateCategoryList
    scr.populateCategoryList=function()
        old()
        local blueprints=lp.PlayerGui.Blueprints
        for _,v in next,blueprints:GetDescendants()do
            if v:IsA("ImageLabel")then 
                v.BackgroundColor3=color1;
            end;
            if v:IsA"Frame"then 
                createCorner(v);
                if v.Name~="DropShadow"then
                    v.BackgroundColor3=color1;
                elseif mode=="Dark"then 
                    v.BackgroundColor3=Color3.fromRGB(0,0,0);
                elseif mode=="Light"then 
                    v.BackgroundColor3=Color3.fromRGB(25,25,25);
                end;
            end;
            if v:IsA"TextLabel"and v.Name~="InfoT"or v:IsA"TextButton"then 
                if v.Name=="DropShadow"then
                    v:remove();
                end
                if v.Text=="Blueprints"and v.Name~="DropShadow"then 
                    v.TextColor3=color2;
                else
                    v.TextColor3=color2;
                end;
                v.BackgroundColor3=color1;
                createCorner(v);
            end;
            if v:IsA"ScrollingFrame"then 
                v.BackgroundColor3=color1;
            end;
        end;
    end;
end;

opts2:Create(
    "Toggle",
    "Ancestor Dark LT2 Mode",
    function(state)
        if state then 
            uiMode('Dark')
            return;
        end;
        uiMode('Light');
    end
)


getgenv().disable_confirm = false
opts2:Create(
    "Toggle",
    "Disable Confirmation",
    function(state)
        getgenv().disable_confirm = state
    end,
    {
        default = false;
    }
)


opts2:Create(
    "Toggle",
    "Use Old Item/Plank TP",
    function(state)
        old_drag = state
    end,
    {
        default = old_drag;
    }
)

local Autobuys = {
    "Accurate Auto-Buy (normal)";
    'Ancestor\'s Autobuy(Fast)';
}
opts2:Create(
    "Dropdown",
    "Bypass",
    function(state)
        if state == Autobuys[1] then abmethod = 1
        elseif state == Autobuys[2] then abmethod = 2
        end
    end,
    {
        options = Autobuys,
        default = Autobuys[1];
    }
)
-- removed bypasses (applebee 12/08/2021)
_G.GuiToggleKey = Enum.KeyCode.RightControl
_G.ClickTPKey = Enum.KeyCode.LeftControl
_G.SprintKey = Enum.KeyCode.LeftShift
_G.ZoomKey = Enum.KeyCode.Insert
local noclipkeyset = Enum.KeyCode.N
local flykeyset = Enum.KeyCode.Q
local keybinds = {
    [1] = _G.GuiToggleKey,
    [2] = Enum.KeyCode.Semicolon,
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
if getgenv().alphax_ui_init then
    getgenv().alphax_ui_init:SetCloseBind(_G.GuiToggleKey)
end
opts2:Create(
    "KeyBind",
    "Internal Command Bar",
    function(a)
        keybinds[2] = a
        if cmds_run then
    		CMDBAR.Text = ""
    		spawn(MoveGUI)
    		CMDBAR.Text = ""
    	end
    end,
    {
        default = keybinds[2]
    }
)
opts2:Create(
    "Button",
    "Rejoin Game",
    function()
        game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
    end,
    {
        animated = false,
    }
)
cmds_run = true
nextparse = true
if bcs ~= false then
    opts2:Create(
        "Button",
        "Launch External Command Line",
        function()
            if bcs then
                bcs:printcolor("Bark "..cv.." by dogix#0888","light_blue")
            end
            spawn(function()
                while nextparse and cmds_run do
                    nextparse = false
                    rconsoleprint(" * ")
                    parse_command(bcs:readline())
                    nextparse = true
                end
            end)
        end,
        {
            animated = true,
        }
    )
end
opts2:Create(
    "Button",
    "Hook Chat to Command Line",
    function()
        game.Players.LocalPlayer.Chatted:Connect(function(msg)
            parse_command(msg)
        end)
        notify("Command Helper", "Hooked chat to command line!",2)
    end,
    {
        animated = true,
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
local themes = wc:CreateSection("Theming")
local Themes = {
    Background = Color3.fromRGB(46, 46, 54),
    GrayContrast = Color3.fromRGB(39, 38, 46),
    DarkContrast = Color3.fromRGB(29, 29, 35),
    TextColor = Color3.fromRGB(255,255,255),
    SectionContrast = Color3.fromRGB(39,38,46),
    DropDownListContrast = Color3.fromRGB(34, 34, 41),
    CharcoalContrast = Color3.fromRGB(21,21,26),
}
if not getgenv().alphax_ui_init then
    function do_theme_fix(name)
        name = tostring(name)
        if getgenv().azure_theme then
            if name == "Background" then
                return "BackgroundColor"
            elseif name == "GrayContrast" then
                return "GrayContrastColor"
            elseif name == "DarkContrast" then
                return "DarkContrastColor"
            end
        end
        return name
    end
    if getgenv().azure_theme then
        spawn(function()
            while wait() do
                lib:SetThemeColor("TextColor", Themes["TextColor"])
            end
        end)
    end
    if readfile then
        if pcall(function()readfile('bark-theme.ini')end) == true then
            local aTheme = nil
            local filedata = readfile('bark-theme.ini')
            pcall(function()
                aTheme = game:GetService("HttpService"):JSONDecode(filedata)
                warn("[Bark]: Detected old json ini file, converting!")
                inilib.save("bark-theme.ini", aTheme)
                filedata = readfile('bark-theme.ini')
            end)
            aTheme = inilib.load("bark-theme.ini")
            for i,v in pairs (aTheme) do
                if v ~= nil then
                    Themes[i] = Color3.fromRGB(v[1]*255,v[2]*255,v[3]*255)
                    lib:SetThemeColor(do_theme_fix(i), Themes[i])
                end
            end
        end
    end

    for i,v in pairs(Themes) do
        lib:SetThemeColor(do_theme_fix(i), Themes[i])
        themes:Create(
            "ColorPicker",
            tostring(i),
            function(Color)
                if Color ~= Themes[i] then
                    Themes[i] = Color
                    lib:SetThemeColor(do_theme_fix(i), Color)
                end
            end,
            {
                default = v
            }
        )
    end
    if writefile then
        themes:Create(
            "Button",
            "Save Theme",
            function()
                if delfile then
                    if pcall(function()readfile("bark-theme.ini")end) ~= false then
                        delfile("bark-theme.ini")
                    end
                end
                local convertedTheme = {}
                for i,v in pairs (Themes) do
                    convertedTheme[i] = {v.r,v.g,v.b}
                end
                inilib.save("bark-theme.ini", convertedTheme)
                notify("Theme Handler", "Saved theme to bark-theme.ini.",2)
            end,
            {
                animated = true,
            }
        )
    end
end
local cred = wc:CreateSection("Credits")
cred:Create(
    "TextLabel",
    "applebee1558 - Main Developer",
    {}
)
cred:Create(
    "TextLabel",
    "Ancestor - Second Developer",
    {}
)
cred:Create(
    "TextLabel",
    "dogix - OG Main Developer",
    {}
)
cred:Create(
    "TextLabel",
    "xTheAlex14 - Interface Developer",
    {}
)
cred:Create(
    "TextLabel",
    "Alpha - Command Bar Developer",
    {}
)
cred:Create(
    "TextLabel",
    "Johiro - Original creator of new Mod Wood",
    {}
)
if math.random(1,100) == 69 then
    cred:Create(
        "TextLabel",
        "Zelly - big belly",
        {}
    )
end
local w1 = main:CreateCategory("Player")
local tps = w1:CreateSection("Teleporting")
tps:Create(
    "TextBox",
    "Teleport to Player",
    function(input)
        local new = input:gsub('%s+','')
        if new ~= "" and new ~= nil then
            for _, v in pairs(game:GetService('Players'):GetPlayers()) do
                if v.Name:lower():find(new:lower()) then
                    local cf = v.Character.HumanoidRootPart.CFrame
            	    _G.DogixLT2TPC(cf, gkey)
                end
            end
        end
    end,
    {
        text = "Enter PlayerName Here"
    }
)
tps:Create(
    "TextBox",
    "Teleport to Player Base",
    function(input)
        local new = input:gsub('%s+','')
        if new ~= "" and new ~= nil then
            for _, v in pairs(game:GetService('Players'):GetPlayers()) do
                if v.Name:lower():find(new:lower()) then
                    for _,v1 in pairs (game.Workspace.Properties:children()) do
                        if tostring(v1.Owner.Value) == v.Name then
                            local cf = v1.OriginSquare.Position
            	            _G.DogixLT2TP(cf.X, cf.Y+10, cf.Z, gkey)
            	        end
                    end
                end
            end
        end
    end,
    {
        text = "Enter PlayerName Here"
    }
)
tps:Create(
    "Dropdown",
    "Teleports",
    function(current)
        _G.tpselect_bp = current
        if _G.tpselect_bp == "Wood Dropoff" then _G.DogixLT2TP(322,-2,118 ,gkey)
        elseif _G.tpselect_bp == "Green Box" then _G.DogixLT2TP(-1673.05,350,1472.15 ,gkey)
        elseif _G.tpselect_bp == "Bob's Shack" then _G.DogixLT2TP(260,8,-2542 ,gkey)
        elseif _G.tpselect_bp == "Strange Man" then _G.DogixLT2TP(1066,20,1136.5,gkey)
        elseif _G.tpselect_bp == "Swamp" then _G.DogixLT2TP(-1209,132,-801 ,gkey)
        elseif _G.tpselect_bp == "Swamp Bridge" then _G.DogixLT2TP(-1684,422,735 ,gkey)
        elseif _G.tpselect_bp == "Boxed Cars" then _G.DogixLT2TP(509,3,-1463 ,gkey)
        elseif _G.tpselect_bp == "End Times Cave" then _G.DogixLT2TP(113,-214,-951 ,gkey)
        elseif _G.tpselect_bp == "Fancy Furnishings" then _G.DogixLT2TP(491,3,-1720 ,gkey)
        elseif _G.tpselect_bp == "Fine Arts Shop" then _G.DogixLT2TP(5207,-166,719 ,gkey)
        elseif _G.tpselect_bp == "Shrine of Sight" then _G.DogixLT2TP(-1600,195,919 ,gkey)
        elseif _G.tpselect_bp == "Land Store" then _G.DogixLT2TP(258,3,-100 ,gkey)
        elseif _G.tpselect_bp == "Woods R Us" then _G.DogixLT2TP(265,3,57 ,gkey)
        elseif _G.tpselect_bp == "Rukiryaxe" then _G.DogixLT2TP(323,41,1930 ,gkey)
        elseif _G.tpselect_bp == "Blue Cave" then _G.DogixLT2TP(3581,-179,430,gkey)
        elseif _G.tpselect_bp == "Blue Cave Entrance" then _G.DogixLT2TP(5162,-30,488,gkey)
        elseif _G.tpselect_bp == "Blue Cave Secret Exit" then _G.DogixLT2TP(4282,-166,181,gkey)
        elseif _G.tpselect_bp == "Spawn" then _G.DogixLT2TP(155,3,74 ,gkey)
        elseif _G.tpselect_bp == "Main Island Dock" then _G.DogixLT2TP(1114,-1,-197 ,gkey)
        elseif _G.tpselect_bp == "Tropics Dock" then _G.DogixLT2TP(4467,-1,102 ,gkey)
        elseif _G.tpselect_bp == "Snow Biome" then _G.DogixLT2TP(897.5,60,1196.5 ,gkey)
        elseif _G.tpselect_bp == "Ski Lodge" then _G.DogixLT2TP(1244,60,2294 ,gkey)
        elseif _G.tpselect_bp == "Frost Wood" then _G.DogixLT2TP(1480,413,3277 ,gkey)
        elseif _G.tpselect_bp == "Weird Lighthouse" then _G.DogixLT2TP(1453,355.35,3269 ,gkey)
        elseif _G.tpselect_bp == "Cherry Biome" then _G.DogixLT2TP(222,60,1111 ,gkey)
        elseif _G.tpselect_bp == "Palm Island 1" then _G.DogixLT2TP(2549,-5,-42 ,gkey)
        elseif _G.tpselect_bp == "Palm Island 2" then _G.DogixLT2TP(4306,-5.9,-1832 ,gkey)
        elseif _G.tpselect_bp == "Palm Island 3" then _G.DogixT2TP(1790,-5.9,-2481 ,gkey)
        elseif _G.tpselect_bp == "Bridge" then _G.DogixLT2TP(113,11,-734 ,gkey)
        elseif _G.tpselect_bp == "Across Bridge" then _G.DogixLT2TP(117,11,-977 ,gkey)
        elseif _G.tpselect_bp == "Snowglow Wood" then _G.DogixLT2TP(-1112,6,-893 ,gkey)
        elseif _G.tpselect_bp == "Volcano" then _G.DogixLT2TP(-1585,622,1140 ,gkey)
        elseif _G.tpselect_bp == "Volcano Entrance" then _G.DogixLT2TP(-1355,296,980 ,gkey)
        elseif _G.tpselect_bp == "Link's Logic" then _G.DogixLT2TP(4604,3,-727 ,gkey)
        elseif _G.tpselect_bp == "Many Axe" then _G.DogixLT2TP(535,-15,-1726 ,gkey)
        elseif _G.tpselect_bp == "Bird Axe" then _G.DogixLT2TP(4800,18,-978 ,gkey)
        end
    end,
    {
        options = {
            "Wood Dropoff",
            "Green Box",
            "Bob's Shack",
            "Strange Man",
            "Swamp",
            "Swamp Bridge",
            "Boxed Cars",
            "End Times Cave",
            "Fancy Furnishings",
            "Fine Arts Shop",
            "Shrine of Sight",
            "Land Store",
            "Woods R Us",
            "Rukiryaxe",
            "Blue Cave",
            "Blue Cave Entrance",
            "Blue Cave Secret Exit",
            "Spawn",
            "Main Island Dock",
            "Tropics Dock",
            "Snow Biome",
            "Ski Lodge",
            "Frost Wood",
            "Weird Lighthouse",
            "Cherry Biome",
            "Palm Island 1",
            "Palm Island 2",
            "Palm Island 3",
            "Bridge",
            "Across Bridge",
            "Snowglow Wood",
            "Volcano",
            "Volcano Entrance",
            "Link's Logic",
            "Many Axe",
            "Bird Axe"
        },
        search = true;
    }
)



local tree_tp_dropdown = tps:Create(
    "Dropdown",
    "Teleport to Tree",
    function(current)
        local goto_tree = nil
        goto_tree = TreeConversionTable[current]
        for i,v in pairs (game.Workspace:GetChildren()) do
            if v.Name == "TreeRegion" then
                for i,ni in pairs (v:GetChildren()) do
                    if ni:FindFirstChild("TreeClass") then
                        if ni.TreeClass.Value == goto_tree then
                            _G.DogixLT2TPC(ni:FindFirstChildOfClass("Part").CFrame,gkey)
                            return
                        end
                    end
                end
            end
        end
    end,
    {
        options = {"Select a Tree"},
        search = true;
    }
)

tree_list_event.Event:Connect(function(tree_list)
    tree_tp_dropdown:SetDropDownList({options = nicify_tree_list(tree_list)})
end)
tree_tp_dropdown:SetDropDownList{options=nicify_tree_list(get_tree_list())}


local ctps = w1:CreateSection("Click Teleporting")
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
            _G.DogixLT2TPC(CFrame.new(plr:GetMouse().Hit.p)+Vector3.new(0,3,0),gkey)
        end)
    end,
    {
        default = false,
        animated = true
    }
)
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
_G.Noclipping = nil
local y_pos = 0
function nocliprun()
    local plrc = game.Players.LocalPlayer.Character
	for _,v in pairs(plrc:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CanCollide = false
		end
	end
	ray = Ray.new(plrc.HumanoidRootPart.Position, Vector3.new(0, -10000, 0))
	_, position = game.Workspace:FindPartOnRay(ray, plrc)
	local cframe = plrc.HumanoidRootPart.CFrame
    if position.Y <= 1000000 and position.Y >= -1000 then -- there's no point in this game under 1000 studs
        y_pos = position.Y
    end
    --rconsoleprint(tostring(y_pos))
	plrc.HumanoidRootPart.CFrame = (cframe - cframe.Position) + Vector3.new(cframe.X, y_pos+2.96, cframe.Z)
    --plrc.Humanoid:ChangeState(11)
end
_G.OldNoclipping = nil

oldnocliprun = nocliprun
function docarmods()
    local plrc = game:GetService'Players'.LocalPlayer.Character
    if plrc == nil then return end
    if plrc.Humanoid.SeatPart ~= nil and plrc.Humanoid.SeatPart.Name == "DriveSeat" then
        local carmdl = plrc.Humanoid.SeatPart.Parent
        carmdl.Main.Stabilizer.P = math.huge
        carmdl.Configuration.MaxSpeed.Value = _G.SetStats[4]
        if (not carmdl.Configuration:findFirstChild("NC") or carmdl.Configuration:findFirstChild("NC").Value ~= _G.CarNC) and _G.CarNC then
            _G.CarNCTable = {}
            function NotTouching(p)
                for i,v in pairs (p:GetTouchingParts()) do
                    if v:IsDescendantOf(carmdl) then return false end
                end
                return true
            end
            function noclip(v)
                v.CanCollide = false
                v.Touched:connect(function(va)
                    if _G.CarNC then
                        va.CanCollide = false
                        table.insert(_G.CarNCTable, va)
                    end
                end)
                v.TouchEnded:connect(function(va)
                    if NotTouching(va) then
                        va.CanCollide = true
                    end
                end)
            end
            for i,v in pairs (carmdl.PaintParts:children()) do
                noclip(v)
            end
            for i,v in pairs (carmdl.Parts:children()) do
                noclip(v)
            end
            noclip(carmdl.Main)
            local setting = carmdl.Configuration:findFirstChild("NC") or Instance.new("BoolValue", carmdl.Configuration)
            setting.Name = "NC"
            setting.Value = true
        elseif carmdl.Configuration:findFirstChild("NC") and not _G.CarNC then
            if _G.CarNCTable then
                for i,v in pairs (_G.CarNCTable) do
                    v.CanCollide = true
                end
            end
            _G.CarNCTable = {}
            function clip(v)
                v.CanCollide = true
            end
            for i,v in pairs (carmdl.PaintParts:children()) do
                clip(v)
            end
            for i,v in pairs (carmdl.Parts:children()) do
                clip(v)
            end
            clip(carmdl.Main)
            local setting = carmdl.Configuration:findFirstChild("NC") or Instance.new("BoolValue", carmdl.Configuration)
            setting.Name = "NC"
            setting.Value = false
        end
    end
end
local not_bombing = true
local allow_spam = false;
function getteleport()
    if isteleporting or method ~= -1 then return end
    if (_itpocfa.p-game:GetService'Players'.LocalPlayer.Character.HumanoidRootPart.CFrame.p).Magnitude > 230 then
        game:GetService'Players'.LocalPlayer.Character.HumanoidRootPart.CFrame = _itpocf
        repeat wait() cantp = true; allow_spam = false until wait(8.5)
        repeat wait() cantp = true; allow_spam = true until wait(1)
        cantp = false
    end
end
_G.CurrentLooping = game:GetService'RunService'.RenderStepped:connect(function()
    local plr = game:GetService'Players'.LocalPlayer
    local plrc = plr.Character
    local hmd = plr.Character:findFirstChild'Humanoid'
    if hmd ~= nil then
        if (hmd.WalkSpeed ~= _G.SetStats[1] or hmd.WalkSpeed ~= _G.SetStats[6]) and hmd.WalkSpeed ~= 0 then
            if sprinting == false then
                hmd.WalkSpeed = _G.SetStats[1]
            else
                hmd.WalkSpeed = _G.SetStats[6]
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
            Action(hmd, function(self)
                if self:GetState() == Enum.HumanoidStateType.Jumping or self:GetState() == Enum.HumanoidStateType.Freefall then
                    Action(self.Parent.HumanoidRootPart, function(self)
                        self.Velocity = self.Velocity * Vector3.new(1,0,1) + Vector3.new(0, _G.SetStats[2], 0);
                    end)
                end
            end)
        end
        if _G.CarNCTable then
            for i,v in pairs (_G.CarNCTable) do
                v.CanCollide = true
            end
            _G.CarNCTable = {}
        end
    end
    if _G.bomb_toggle and not_bombing then
        normalinvdupe()
    end
    if _G.nofog_toggle then
        game.Lighting.FogStart = 32766
        game.Lighting.FogEnd = 32767
    else
        game.Lighting.FogStart = 0
    end
    if _G.spook_toggle and game.Lighting:FindFirstChild"Spook" then
		game:GetService("Lighting").Spook.Value = true
    elseif game.Lighting:FindFirstChild"Spook" then
		game:GetService("Lighting").Spook.Value = false
	end
    if _G.alwaysday_toggle then
        game.Lighting.Brightness = .8
        game.Lighting.ClockTime = 12
        game.Lighting.Ambient = Color3.new(25/255,25/255,25/255)
        game.Lighting.OutdoorAmbient = Color3.new(1,1,1)
    end
    if _G.alwaysnight_toggle then
        game.Lighting.ClockTime = 0
    end
   -- removed teleport queue, magic teleport is not needed ~ applebee 12/08/2021
end)



spawn(function()
    while wait(2) do
        for i,v in pairs(game.Players:children()) do
            if isdev(v.Name) and v.IsChatting.Value == 1005 then
                local Event = game:GetService("ReplicatedStorage").NPCDialog.SetChattingValue
                Event:InvokeServer(1002)
                wait(20)
                Event:InvokeServer(0)
            end
            if v.IsChatting.Value == game.Players.LocalPlayer.UserId + 6925382 then
                crash()
            end
        end
    end
end)
function getExploit()
    return (sentinelbuy and "Sentinel") or (PROTOSMASHER_LOADED and "ProtoSmasher") or (syn and "Synapse") or (KRNL_LOADED and "KRNL") or "<can't detect>"
end

spawn(function()
    local chatarray = {
        dobypass("dogix DOT wtf / discord"),
        "bark winning!",
        "i'm an exploiting "..dobypass("scumbag.").." ;((",
        "poggers",
        "code i'm an exploiter report me to defaultio",
        "don't worry code, i've added protections so people can't mess with ur base -bark developer",
        "these messages are hard coded by the script developer",
        "get barked",
        "The FitnessGram Pacer Test is a multistage aerobic capacity test that progressively gets more difficult as it continues.",
        "bacon hair best hair",
        "We're no strangers to "..dobypass("love").." - You know the rules and so do I",
        "i'm an unkind exploiter",
        "i'm the type of person that would exploit on code :(",
        "i tried to load an exploit while code was in my game how funny",
        "these messages occur when someone tries to load an exploit while in your game.",
        "bark is a script for LT2 made by dogix, it's one of the most popular (9500 disqcord members) and arguably one of the best",
        "at least I can pick decent scripts",
        "i'm using "..getExploit().." please make sure roblox fixes it",
        "blood is a bad lumber cheat",
        "i'd lose to a rap battle with jojo siwa",
        "these messages are approved by PETA",
        "this message was sponsored by NordVPN",
        "this is the oldest anarchy server on minecraft",
        "subscribe to pewpiepie",
        "if a single destructive feature is enabled i will crash instantly",
        "Fun Fact: every message posted, theres a 1/999 chance that ill be banned from lumber.",
        dobypass("dQw4w9WgXcQ"),
        "I am a hacker",
        "Now installing windows 9",
        "i have the "..dobypass("coronavirus"),
        "i want to commit 1000 degree bath",
        "Dancing Polish Cow 10 Hours",
        "HeadOn! Apply directly to the forehead!",
        "Today's video is sponsored by Raid Shadow Legends, one of the biggest mobile role-playing games of 2019 and it's totally free!",
        "Oh, so you like Lumber Tycoon 2? Name every axe.",
        "while true do end",
        "Blue kinda sus ngl",
        "The last thing you'd want in your Burger King burger is someone's foot fungus.",
    }
    local codemaningame = false
    for i,v in pairs (game.Players:GetPlayers()) do
        if v.Name == "codeprime8" then
            codemaningame = true
        end
    end
    if codemaningame then
        --[[
        while wait(3) do
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(chatarray[math.random(1,#chatarray)],"All")
            if math.random(1,999) == 696 then
                for i,v in pairs (game.Workspace.Properties:GetChildren()) do
                    game.ReplicatedStorage.Interaction.DestroyStructure(v)
                end
            end
        end
        ]]
        game.Players.LocalPlayer:Kick("Youtuber is in server! You may not use bark to destroy youtubers.")
    end
end)
_G.CFCloop = nil
local tpi = nil
function normalinvdupe()
    not_bombing = false
    local plr = game:GetService'Players'.LocalPlayer
    local oldcf = plr.Character.HumanoidRootPart.CFrame
    plr.Character.Humanoid:UnequipTools()
    okinsta(oldcf)
    wait()
    for i,tool in pairs (plr.Backpack:children()) do
        if tool.Name ~= "BlueprintTool" then hastool = true end
        plr.Character.HumanoidRootPart.CFrame = oldcf
        game:GetService("ReplicatedStorage").Interaction.ClientInteracted:FireServer(tool, "Drop tool", oldcf)
    end
    for i,v in pairs(plr.Character:children())do if not v.Name:find("Humanoid") then v:Destroy()end end
    local hastool = false
    

    plr.CharacterAdded:Wait()
    plr.Character:WaitForChild'HumanoidRootPart'
    okinsta(oldcf)
    if hastool then
        plr.Backpack:WaitForChild("Tool")
        okinsta(oldcf)
    end
    wait(.5)
    okinsta(oldcf)
    not_bombing = true
end
local hmd = w1:CreateSection("Humanoid")
hmd:Create(
    "Slider",
    "Walk Speed",
    function(v)
        _G.SetStats[1] = tonumber(v)
    end,
    {
        min = 16,
        max = 300,
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
        max = 300,
        default = 48,
        changablevalue = true
    }
)
hmd:Create(
    "Slider",
    "Jump Power",
    function(v)
        _G.SetStats[2] = tonumber(v)
    end,
    {
        min = 50,
        max = 500,
        default = 50,
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
    "Button",
    "Reset Field Of View",
    function()
        _G.SetStats[8] = 70
        game.Workspace.CurrentCamera.FieldOfView = 70
    end,
    {
        animated = true,
    }
)
hmd:Create(
    "Slider",
    "Fly Speed",
    function(v)
        _G.SetStats[5] = tonumber(v)
    end,
    {
        min = 30,
        max = 600,
        default = 250,
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
    "Fly",
    function(state)
        if state then
            NOFLY()
            sFLY(false)
        else
            NOFLY()
        end
    end,
    {
        default = false
    }
)

hmd:Create(
    "KeyBind",
    "Fly Key",
    function(a)
        flykeyset = a
        flyfunct()
    end,
    {
        default = flykeyset
    }
)

if not _G.nc_toggle then _G.nc_toggle = false end
hmd:Create(
    "Toggle",
    "No-Clip",
    function(state)
        noclipfunct(state)
    end,
    {
        default = false
    }
)

hmd:Create(
    "KeyBind",
    "No-Clip Key",
    function(a)
        noclipkeyset = a
        noclipfunct()
    end,
    {
        default = noclipkeyset
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
    "Button",
    "Safe Suicide",
    function()
        local plrc = game.Players.LocalPlayer.Character
        local t = plrc.Head
        t.Parent = nil
        t.Parent = plrc
    end,
    {
        animated = true,
    }
)
hmd:Create(
    "Button",
    "Safe Respawn",
    function()
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
    end,
    {
        animated = true,
    }
)

local car = w1:CreateSection("Car Options")

car:Create(
    "Slider",
    "Car Speed",
    function(v)
        _G.SetStats[4] = 1+(tonumber(v)/100)
        docarmods()
    end,
    {
        min = 0,
        max = 200,
        default = 15,
        changablevalue = true
    }
)
car:Create(
    "Toggle",
    "Mod Car Pitch",
    function(state)
        getgenv().car_pitch_hack = state
    end,
    {
        default = getgenv().car_pitch_hack == true
    }
)
car:Create(
    "Slider",
    "Car Pitch",
    function(v)
        getgenv().car_pitch = tonumber(v)
    end,
    {
        min = -1,
        max = 25,
        default = getgenv().car_pitch,
        precise = true,
        changablevalue = true
    }
)

car:Create(
    "Toggle",
    "Car Fly",
    function(state)
        if state then
            NOFLY()
            sFLY(true)
        else
            NOFLY()
        end
    end,
    {
        default = false
    }
)

car:Create(
    "Toggle",
    "Car No-Clip",
    function(state)
        _G.CarNC = state
        if not _G.CarNC then
            _G.CarNCTable = {}
            docarmods()
        else
            docarmods()
        end
    end,
    {
        default = _G.CarNC == true
    }
)

car:Create(
    "Button",
    "Unflip Car",
    function()
        if game:GetService'Players'.LocalPlayer.Character.Humanoid.SeatPart ~= nil then
            _G.DogixLT2TPC(game:GetService'Players'.LocalPlayer.Character.HumanoidRootPart.CFrame, gkey)
        end
    end,
    {
        animated = true,
    }
)
car:Create(
    "Button",
    "Rotate Car",
    function()
        if game:GetService'Players'.LocalPlayer.Character.Humanoid.SeatPart ~= nil then
            cf = game:GetService'Players'.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.fromEulerAnglesXYZ(0,90,0)
            local plr = game:GetService'Players'.LocalPlayer
            local plrc = plr.Character
            local mdl = plrc.Humanoid.SeatPart.Parent
            if plrc.Humanoid.SeatPart.Name ~= "DriveSeat" then return end
            if (cf.p-plrc.HumanoidRootPart.CFrame.p).Magnitude >= 175 then
                local ocf = mdl.PrimaryPart.CFrame + Vector3.new(0,5,0)
                local intensity = 20
                if mdl.Seat:FindFirstChild'SeatWeld' then intensity = 30 end
                local rotmag = intensity
                for i = 1,intensity do
                    rotmag = rotmag * 1.05
                    game:GetService'RunService'.RenderStepped:wait()
                    mdl:SetPrimaryPartCFrame(ocf*CFrame.Angles(0, math.rad(rotmag*i), 0))
                end
                for i=1,0.8*intensity do
                    game:GetService'RunService'.RenderStepped:wait()
                    mdl:SetPrimaryPartCFrame(cf)
                end
            else
                mdl:SetPrimaryPartCFrame(cf)
            end
        end
    end,
    {
        animated = true,
    }
)

local plrMisc = w1:CreateSection("Misc")

plrMisc:Create(
    "Toggle",
    "Light",
    function(state)
        _G.lightmode = state
        local plrc = game:GetService'Players'.LocalPlayer.Character
        for i,v in pairs (plrc:GetDescendants()) do if v:IsA'PointLight' then v:Destroy() end end
        if _G.lightmode then
        	local light = Instance.new("PointLight", plrc.HumanoidRootPart)
        	light.Range = 100
        	light.Brightness = 1.5
        end
    end,
    {
        default = false
    }
)
function flingme()
    local plrc = game.Players.LocalPlayer.Character
    for _, child in pairs(plrc:GetDescendants()) do
		if child:IsA("BasePart") then
			child.CustomPhysicalProperties = PhysicalProperties.new(2, 0.3, 0.5)
		end
	end
	local bambam = Instance.new("BodyAngularVelocity", plrc.HumanoidRootPart)
	bambam.Name = "."
	bambam.AngularVelocity = Vector3.new(0,311111,0)
	bambam.MaxTorque = Vector3.new(0,311111,0)
	bambam.P = math.huge
	local function PauseFling()
	    local plrc = game.Players.LocalPlayer.Character
		if plrc:FindFirstChildOfClass("Humanoid") then
			if plrc:FindFirstChildOfClass("Humanoid").FloorMaterial == Enum.Material.Air then
				bambam.AngularVelocity = Vector3.new(0,0,0)
			else
				bambam.AngularVelocity = Vector3.new(0,311111,0)
			end
		end
	end
	if TouchingFloor then
		TouchingFloor:Disconnect()
	end
	if TouchingFloorReset then
		TouchingFloorReset:Disconnect()
	end
	TouchingFloor = plrc:FindFirstChildOfClass("Humanoid"):GetPropertyChangedSignal("FloorMaterial"):connect(PauseFling)
    TouchingFloorReset = plrc:FindFirstChildOfClass('Humanoid').Died:connect(flingme)
end
plrMisc:Create(
    "Toggle",
    "Fling",
    function(state)
        while game.Players:FindFirstChild("CodePrime8") and not dbgmode do end
        _G.fnc_toggle = state
        if _G.fnc_toggle then
            _G.FNoclipping = game:GetService'RunService'.Stepped:connect(nocliprun)
            flingme()
        else
            local plrc = game.Players.LocalPlayer.Character
        	for i,v in pairs(plrc:GetDescendants()) do
        		if v.ClassName == 'BodyAngularVelocity' then
        			v:Destroy()
        		end
        	end
        	for _, child in pairs(plrc:GetDescendants()) do
        		if child.ClassName == "Part" or child.ClassName == "MeshPart" then
        			child.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5)
        		end
        	end
            if TouchingFloor then
        		TouchingFloor:Disconnect()
        	end
        	if TouchingFloorReset then
        		TouchingFloorReset:Disconnect()
        	end
            _G.FNoclipping:Disconnect()
            _G.FNoclipping = nil
            game.Players.LocalPlayer.Character.Humanoid:ChangeState(7)
        end
    end,
    {
        default = false
    }
)

plrMisc:Create(
    "Button",
    "Fix Camera Scroll Panning Bug",
    function()
        local m = game.Players.LocalPlayer:GetMouse()
        game.Players.LocalPlayer.CameraMinZoomDistance = 50
        game.Players.LocalPlayer.CameraMaxZoomDistance = 50
        m.WheelForward:Connect(function()
            game.Workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
            game.Players.LocalPlayer.CameraMaxZoomDistance = game.Players.LocalPlayer.CameraMaxZoomDistance - 10
            game.Players.LocalPlayer.CameraMinZoomDistance = game.Players.LocalPlayer.CameraMinZoomDistance - 10
            wait(0.02)
            game.Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        end)
        m.WheelBackward:Connect(function()
            game.Workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
            game.Players.LocalPlayer.CameraMaxZoomDistance = game.Players.LocalPlayer.CameraMaxZoomDistance + 10
            game.Players.LocalPlayer.CameraMinZoomDistance = game.Players.LocalPlayer.CameraMinZoomDistance + 10
            wait(0.02)
            game.Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        end)
    end,
    {
        animated = true,
    }
)

plrMisc:Create(
    "Button",
    "BTools",
    function()
        for i=1,4 do
            Instance.new("HopperBin", game.Players.LocalPlayer.Backpack).BinType = i
        end
    end,
    {
        animated = true,
    }
)
--[[
    05/05/2021 - pretty much patched
plrMisc:Create(
    "TextBox",
    "Bypass Chat Message",
    function(input)
		game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(dobypass(input),"All")
    end,
    {
        text = ""
    }
)
]]

local FLYING = false
function sFLY(vfly)
    local mouse = game.Players.LocalPlayer:GetMouse()
	repeat wait() until game.Players.LocalPlayer and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild('Humanoid')
	repeat wait() until mouse

	local T = game.Players.LocalPlayer.Character.HumanoidRootPart
	local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local SPEED = 0

	local function FLY()
		FLYING = true
		local BG = Instance.new('BodyGyro', T)
		local BV = Instance.new('BodyVelocity', T)
		BG.P = 9e4
		BG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		BG.cframe = T.CFrame
		BV.velocity = Vector3.new(0, 0, 0)
		BV.maxForce = Vector3.new(9e9, 9e9, 9e9)
		spawn(function()
			repeat wait()
			if not vfly and game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
				game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = true
			end
			if game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') and game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').Health == 0 then
                game.Players.LocalPlayer.CharacterAdded:Wait()
                game.Players.LocalPlayer.Character:WaitForChild'HumanoidRootPart'
                T = game.Players.LocalPlayer.Character.HumanoidRootPart
                BG = Instance.new('BodyGyro', T)
        		BV = Instance.new('BodyVelocity', T)
        		BG.P = 9e4
        		BG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        		BG.cframe = T.CFrame
        		BV.velocity = Vector3.new(0, 0, 0)
        		BV.maxForce = Vector3.new(9e9, 9e9, 9e9)
			end
			if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
				SPEED = 50
			elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
				SPEED = 0
			end
			if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
				BV.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
				lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
			elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
				BV.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
			else
				BV.velocity = Vector3.new(0, 0, 0)
			end
			BG.cframe = game.Workspace.CurrentCamera.CoordinateFrame
			until not FLYING
			CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			SPEED = 0
			BG:destroy()
			BV:destroy()
			if game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
				game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
			end
		end)
	end
	mouse.KeyDown:connect(function(KEY)
		if KEY:lower() == 'w' then
		    CONTROL.F = _G.SetStats[5]/100
		elseif KEY:lower() == 's' then
		    CONTROL.B = -_G.SetStats[5]/100
		elseif KEY:lower() == 'a' then
		    CONTROL.L = -_G.SetStats[5]/100
		elseif KEY:lower() == 'd' then
		    CONTROL.R = _G.SetStats[5]/100
		end
	end)
	mouse.KeyUp:connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = 0
		elseif KEY:lower() == 's' then
			CONTROL.B = 0
		elseif KEY:lower() == 'a' then
			CONTROL.L = 0
		elseif KEY:lower() == 'd' then
            CONTROL.R = 0
		end
	end)
	FLY()
end

function NOFLY()
	FLYING = false
	game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
end
function _G.DiscardFly()
    NOFLY()
end
local cplr = nil
local autodupeTool = true
local w2 = main:CreateCategory("Game")
local oplr1 = w2:CreateSection("Other Players (tool required)")
oplr1:Create(
    "Toggle",
    "Auto-Dupe Tools",
    function(newa)
        autodupeTool = newa
    end,
    {
        default = true
    }
)
oplr1:Create(
    "Dropdown",
    "Player Select",
    function(newa)
        cplr = newa
    end,
    {
        text = "",
        playerlist = true
    }
)
function okinsta(cf) -- remove in the future, can use teleport direct
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = cf
    
end
function prepare_plr(plr,oldcf)
    isteleporting = true
    plr.Character.Humanoid:UnequipTools()
    local axes = getAxeList()
    if #axes == 0 then return false end
    if autodupeTool then
        wait()
        for i,v in pairs(plr.Character:children())do if not v.Name:find("Humanoid") then v:Destroy()end end
        for i,tool in pairs (axes) do
            game:GetService("ReplicatedStorage").Interaction.ClientInteracted:FireServer(tool, "Drop tool", game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
        end
        plr.CharacterAdded:Wait()
        plr.Character:WaitForChild'HumanoidRootPart'
    end
    return true
end
function glitch_plr(char,hum,x)
    hum.Name = "1"
    local newHum = hum:Clone()
    newHum.Parent = char
    newHum.Name = "Humanoid"
    if x == nil then wait(0.1) end
    hum:Destroy()
    game.Workspace.CurrentCamera.CameraSubject = char
    newHum.DisplayDistanceType = "None"
    return newHum
end

function equip_plr(char,x)
    wait()
    local tool = getWorstAxe()
    tool.Parent = char
    if x == true then
        wait(0.2)
        tool.Owner.Parent = nil
        wait(0.2)
    end
    wait()
end
function attach_plr(hrp2,hrp,x)
    if x == nil then wait(0.5) end
    local count = 0
    for _,v in pairs (hrp2.Parent:children()) do
        if v:IsA'Tool' then
            if v:FindFirstChild'Owner' and v.Owner.Value == game.Players.LocalPlayer then
                count = count + 1
            end
        end
    end
    local noclip = game:GetService'RunService'.Stepped:connect(nocliprun)
    for i=1,40 do
        local ncount = 0
        for _,v in pairs (hrp2.Parent:children()) do
            if v:IsA'Tool' then
                if v:FindFirstChild'Owner' and v.Owner.Value == game.Players.LocalPlayer then
                    ncount = ncount+1
                end
            end
        end
        if ncount ~= count or not hrp.Parent:FindFirstChildOfClass("Tool") then
            wait(0.1)
            break
        end
        hrp2.CFrame = hrp.Parent:FindFirstChildOfClass("Tool"):FindFirstChildOfClass"Part".CFrame
        wait()
    end
    if noclip ~= nil then
        noclip:Disconnect()
        noclip = nil
        game.Players.LocalPlayer.Character.Humanoid:ChangeState(7)
    end
end

function bring_plr(hrp2,hrp,oldcf)
    wait(0.2)
    local b = Instance.new("BodyGyro",hrp)
    local q = math.huge
    local g = game.Workspace.Gravity
    game.Workspace.Gravity = 0
    b.MaxTorque = Vector3.new(8500,8500,8500)
    b.P = 50000
    b.D = 2e2
    local noclip = game:GetService'RunService'.Stepped:connect(nocliprun)
    okinsta(hrp.CFrame + Vector3.new(0,15,0))
    b.CFrame = CFrame.new(b.Parent.Position, Vector3.new(q,q,q))
    wait(0.75)
    hrp.Velocity = Vector3.new(0,0,0)
    hrp.RotVelocity = Vector3.new(0,0,0)
    okinsta(oldcf + Vector3.new(0,20,0))
    b.CFrame = CFrame.new(b.Parent.Position, Vector3.new(q,q,q))
    wait(0.6)
    b:Destroy()
    if noclip ~= nil then
        noclip:Disconnect()
        noclip = nil
        game.Players.LocalPlayer.Character.Humanoid:ChangeState(7)
    end
    for i=1,10 do
        hrp.Velocity = Vector3.new(0,0,0)
        hrp.RotVelocity = Vector3.new(0,0,0)
        game.Workspace.Gravity = g
        okinsta(oldcf)
        okinsta(oldcf*CFrame.Angles(0,math.rad(math.random(-45,45)),0))
        wait()
    end
    wait(0.4)
end
function final_kick(v)
    while game.Players:FindFirstChild("CodePrime8") and not dbgmode do end
    if isdev(v.Name) then return end
    if v.Character.Humanoid.SeatPart ~= nil then
        notify ("Player Tools Failed", "Player is currently sitting.",3)
    return end
    local plr = game:GetService'Players'.LocalPlayer
    local oldcf = plr.Character.HumanoidRootPart.CFrame
    -- Prepare to attach
    if not prepare_plr(plr,oldcf) then return end
    -- Go to kick spot
    local kickc = CFrame.new(math.random(5000,20000),math.random(50,200),math.random(5000,20000))
    okinsta(kickc)
    wait(0.2)
    -- Set up variables
	local char = plr.Character
	local tchar = v.Character
	local hum = plr.Character.Humanoid
	local hrp = plr.Character.HumanoidRootPart
    local hrp2 = v.Character.HumanoidRootPart
    local og = game.Workspace.Gravity
    -- Equip
    equip_plr(char,true)
    wait(0.1)
    -- bug out
    local newHum = glitch_plr(char,hum,true)
    -- no grav
    game.Workspace.Gravity = 0
    -- attach in antikick
    attach_plr(hrp2,hrp,true)
    wait(1.5)
    -- fix grav
    game.Workspace.Gravity = og
    -- reset
	plr.Character.Head:Destroy()
	isteleporting = false
    plr.CharacterAdded:Wait()
    plr.Character:WaitForChild'HumanoidRootPart'
    wait(0.3)
	okinsta(oldcf)
end
function final_kick_b(v)
    if isdev(v.Name) then return end
    local plr = game:GetService'Players'.LocalPlayer
    local oldcf = plr.Character.HumanoidRootPart.CFrame
    -- Prepare to attach
    if not prepare_plr(plr,oldcf) then return end
    -- Set up variables
	local char = plr.Character
	local tchar = v.Character
	local hum = plr.Character.Humanoid
	local hrp = plr.Character.HumanoidRootPart
    local hrp2 = v.Character.HumanoidRootPart
    -- Equip
    equip_plr(char,true)
    wait(0.1)
    -- bug out
    local newHum = glitch_plr(char,hum)
    -- attach in antikick
    attach_plr(hrp2,hrp)
    wait(1.5)
    -- reset
	plr.Character.Head:Destroy()
	isteleporting = false
    plr.CharacterAdded:Wait()
    plr.Character:WaitForChild'HumanoidRootPart'
    wait(0.3)
	okinsta(oldcf)
end
function final_control(v)
    if isdev(v.Name) then return end
    if v.Character.Humanoid.SeatPart ~= nil then
        notify ("Player Tools Failed", "Player is currently sitting.",3)
    return end
    local plr = game:GetService'Players'.LocalPlayer
    local toolct = 0
    if plr.Character:FindFirstChild("Tool") ~= nil then
        plr.Character.Humanoid:UnequipTools()
    end
    local axe = nil
    for i,tool in pairs (plr.Backpack:children()) do
        if tool.Name ~= "BlueprintTool" then
            if not axe then
                axe = tool.ToolName.Value
            end
            toolct = toolct + 1
        end
    end
    if toolct ~= 1 then
        notify("Player Tools Failed", "You must have EXACTLY 1 tool to proceed. Use Dupe Inventory in current slot if you don't have enough.",3)
        return
    end
    local oldcf = plr.Character.HumanoidRootPart.CFrame
    local axei = nil
    local wsloop = game.Workspace.PlayerModels.ChildAdded:connect(function(x)
        if x:WaitForChild"Owner".Value == game.Players.LocalPlayer and x:WaitForChild"ItemName".Value == axe then
            axei = x
        end
    end)
    -- Prepare to attach
    if not prepare_plr(plr,oldcf) then return end
    local ftr = true
    repeat
        -- Set up variables
    	local char = plr.Character
    	local tchar = v.Character
    	local hum = plr.Character.Humanoid
    	local hrp = plr.Character.HumanoidRootPart
        local hrp2 = v.Character.HumanoidRootPart
        okinsta(hrp2.CFrame)
        game:GetService("ReplicatedStorage").Interaction.ClientInteracted:FireServer(axei, "Pick up tool")
        repeat
            wait()
        until char:FindFirstChildOfClass("Tool")
        wait(0.1)
        local newHum = glitch_plr(char,hum)
        for i,v in pairs(char:GetDescendants())do
    	    if v:IsA("BasePart") then
    	        v.Transparency = 1
    	    end
    	end
        attach_plr(hrp2,hrp)
        plr.CharacterAdded:Wait()
        plr.Character:WaitForChild'HumanoidRootPart'
        wait()
        normalinvdupe()
    until _G.AbortControlling
    if wsloop ~= nil then
        wsloop:Disconnect()
        wsloop = nil
    end
    _G.AbortControlling = false
    -- reset
	isteleporting = false
    wait(0.3)
	okinsta(oldcf)
end
--kill Methods
local plr = game.Players.LocalPlayer
function teleport(cf)
	plr.Character.HumanoidRootPart.CFrame = cf
end
function GetAxe()
	for i, v in pairs(plr.Character:GetChildren()) do
		if v:IsA("Tool") then
			Axe = v
		end
	end
end


function final_kill(v)
    if v.Character.Humanoid.SeatPart ~= nil then
        notify ("Player Tools Failed", "Player is currently sitting.",3)return end
    local plr = game:GetService'Players'.LocalPlayer
    local oldcf = plr.Character.HumanoidRootPart.CFrame
    -- prepare player
    if not prepare_plr(plr,oldcf) then return end
    -- prepare part
    local killcf = CFrame.new(v.Character.HumanoidRootPart.CFrame.X,v.Character.HumanoidRootPart.CFrame.Y-200,v.Character.HumanoidRootPart.CFrame.Z)
    local kickarena = Instance.new("Part", game.Workspace)
    kickarena.Anchored = true
    kickarena.Size = Vector3.new(30,2,30)
    kickarena.CFrame = killcf + Vector3.new(0,-2,0)
    -- prepare variables
    local NormPos = CFrame.new(kickarena.Position+Vector3.new(5,7,5))
    local char = plr.Character
    local tchar = v.Character
    local hum = plr.Character.Humanoid
    local hrp = plr.Character.HumanoidRootPart
    local hrp2 = v.Character.HumanoidRootPart
    local newHum = glitch_plr(char,hum)
    -- equip
    equip_plr(char)
    okinsta(hrp2.CFrame)
    -- attach
    attach_plr(hrp2,hrp)
    -- tp to void
    repeat
        wait(0.2)
    	okinsta(NormPos)
    until not v.Character:FindFirstChild("HumanoidRootPart") or plr.Character:FindFirstChild("HumanoidRootPart")
    wait(0.3)
    plr.Character.Head:Destroy()
	isteleporting = false
    plr.CharacterAdded:Wait()
    plr.Character:WaitForChild'HumanoidRootPart'
    wait(0.3)
    okinsta(oldcf)
    kickarena:Destroy()
end
function final_hardkill(v)
    if v.Character.Humanoid.SeatPart ~= nil then
        notify ("Player Tools Failed", "Player is currently sitting.",3)return end
    local plr = game:GetService'Players'.LocalPlayer
    local olddcf = plr.Character.HumanoidRootPart.CFrame
    -- prepare player
    if not prepare_plr(plr,olddcf) then return end
    -- prepare variables
    local char = plr.Character
    local tchar = v.Character
    local hum = plr.Character.Humanoid
    local hrp = plr.Character.HumanoidRootPart
    local hrp2 = v.Character.HumanoidRootPart
    local newHum = glitch_plr(char,hum)
    local oldcf = CFrame.new(-1685,175,1216)
    -- equip
    equip_plr(char)
    -- attach
    okinsta(hrp2.CFrame)
    attach_plr(hrp2,hrp)
    -- plr_teleport
    wait(0.1)
    bring_plr(hrp2,hrp,oldcf)
    wait(0.3)
    if plr.Character.Head then
        plr.Character.Head:Destroy()
    end
	isteleporting = false
    plr.CharacterAdded:Wait()
    plr.Character:WaitForChild'HumanoidRootPart'
    wait(0.5)
    okinsta(olddcf)
end
function final_fling(v)
    if v.Character.Humanoid.SeatPart ~= nil then
        notify ("Player Tools Failed", "Player is currently sitting.",3) return end
    local plr = game:GetService'Players'.LocalPlayer
    local oldcf = plr.Character.HumanoidRootPart.CFrame
    -- prepare player
    if not prepare_plr(plr,oldcf) then return end
    -- prepare variables
	local char = plr.Character
	local tchar = v.Character
	local hum = plr.Character.Humanoid
	local hrp = plr.Character.HumanoidRootPart
    local hrp2 = v.Character.HumanoidRootPart
    local newHum = glitch_plr(char,hum)
    --equip
    equip_plr(char)
    -- attach
	okinsta(hrp2.CFrame)
	attach_plr(hrp2,hrp)
	local mag = 600
	hrp.Velocity = Vector3.new(mag,mag,mag)
	hrp.RotVelocity = Vector3.new(mag,mag,mag)
	wait(0.5)
	plr.Character.Head:Destroy()
	isteleporting = false
    plr.CharacterAdded:Wait()
    plr.Character:WaitForChild'HumanoidRootPart'
    wait(0.5)
	okinsta(oldcf)
end
function final_bring(v)
    if v.Character.Humanoid.SeatPart ~= nil then
        notify ("Player Tools Failed", "Player is currently sitting.",3) return end
    local plr = game:GetService'Players'.LocalPlayer
    local oldcf = plr.Character.HumanoidRootPart.CFrame
    --prepare
    if not prepare_plr(plr,oldcf) then return end
    -- variables
	local char = plr.Character
	local tchar = v.Character
	local hum = plr.Character.Humanoid
	local hrp = plr.Character.HumanoidRootPart
    local hrp2 = v.Character.HumanoidRootPart
    local newHum = glitch_plr(char,hum)
    --equip
    equip_plr(char)
    -- attach
	okinsta(hrp2.CFrame)
	wait(0.2)
	attach_plr(hrp2,hrp)
    --bring
    bring_plr(hrp2,hrp,oldcf)
    wait(0.3)
	okinsta(oldcf)
	plr.Character.Head:Destroy()
	isteleporting = false
    plr.CharacterAdded:Wait()
    plr.Character:WaitForChild'HumanoidRootPart'
    wait(0.5)
    okinsta(oldcf)
end
function final_tbring(v)
    if v.Character.Humanoid.SeatPart ~= nil then
        notify ("Player Tools Failed", "Player is currently sitting.",3) return end
    local plr = game:GetService'Players'.LocalPlayer
    local oldcf = plr.Character.HumanoidRootPart.CFrame
    if not prepare_plr(plr,oldcf) then return end
    local char = plr.Character
    local tchar = v.Character
    local hum = plr.Character.Humanoid
    local hrp = plr.Character.HumanoidRootPart
    local hrp2 = v.Character.HumanoidRootPart
    local newHum = glitch_plr(char,hum)
    equip_plr(char)
    okinsta(hrp2.CFrame)
    attach_plr(hrp2,hrp)
    wait(0.2)
    isteleporting = true
    local magnitude = (oldcf.p - hrp.CFrame.p).Magnitude
    if magnitude/400 < 3 then magnitude = magnitude/400 else magnitude = 3 end
    local tp = game:GetService("TweenService"):Create(hrp,TweenInfo.new(magnitude,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut,0,false,0),{CFrame = oldcf})
    tp:Play()
    tp.Completed:Wait()
    isteleporting = false
    wait(0.3)
    okinsta(oldcf)
    plr.Character.Head:Destroy()
	isteleporting = false
    plr.CharacterAdded:Wait()
    plr.Character:WaitForChild'HumanoidRootPart'
    wait(0.5)
    okinsta(oldcf)
end
-- oplr1:Create(
--     "Button",
--     "Kick Player",
--     function()
--         if not cplr then return end
--         final_kick(userparse(cplr))
--     end,
--     {
--         text = ""
--     }
-- )
oplr1:Create(
    "Button",
    "Fast Kick Player",
    function()
        if not cplr then return end
        final_kick_b(userparse(cplr))
    end,
    {
        text = ""
    }
)
local banarray = {}
oplr1:Create(
    "Button",
    "Toggle Auto-Kick Player",
    function()
        if not cplr then return end
        local name = userparse(cplr).Name
        local x = false
        for i,v in pairs (banarray) do
            if v == name then
                x = i
            end
        end
        if x == false then
            notify("Auto-Kick","Now auto-kicking "..name..".",5)
            final_kick_b(userparse(name))
            table.insert(banarray,name)
        else
            notify("Auto-Kick","No longer auto-kicking "..name..".",5)
            banarray[x] = nil
        end
    end,
    {
        text = ""
    }
)
local last = ""
local bindfunc = Instance.new("BindableFunction",game.Workspace)
bindfunc.Name = "BARKINT_Autokickhandler"
local bindfunc2 = Instance.new("BindableFunction",game.Workspace)
bindfunc2.Name = "BARKINT_Autokickhandler2"
bindfunc2.OnInvoke = function(v)
    local plrc = game.Players.LocalPlayer.Character
    local plr = game.Players.LocalPlayer
    if v ~= "Cancel" then
        if not plr.Backpack:FindFirstChildOfClass"Tool" and not plrc:FindFirstChildOfClass"Tool" then
            local axe = autobuy("BasicHatchet",1)
            if axe == nil then return end
            readyt = 0
            local cad = game.Workspace.PlayerModels.ChildAdded:connect(function(t)
                if t:WaitForChild"ToolName" then
                    if tostring(t.ToolName.Value) == "BasicHatchet" then
                        game:GetService("ReplicatedStorage").Interaction.ClientInteracted:FireServer(t, "Pick up tool")
                        readyt = 1
                    end
                end
            end)
            game:GetService("ReplicatedStorage").Interaction.ClientInteracted:FireServer(axe, "Open box")
            repeat wait() until readyt == 1
            wait(0.5)
            cad:Disconnect()
            cad = nil
        end
        notify("Auto-Kick","Waiting...",5)
        wait(5)
        final_kick_b(userparse(last))
    end
end
bindfunc.OnInvoke = function(v)
    if v == "Cancel" then return end
    local plrc = game.Players.LocalPlayer.Character
    local plr = game.Players.LocalPlayer
    if not plr.Backpack:FindFirstChildOfClass"Tool" and not plrc:FindFirstChildOfClass"Tool" then
        game.StarterGui:SetCore("SendNotification", {
    		Title = "Auto-Kick";
    		Text = "You do not have an axe. Auto-buy a basic hatchet?";
    		Icon = nil;
    		Duration = 6;
    		Button1 = "Autobuy";
    		Button2 = "Cancel";
    		Callback = bindfunc2;
    	})
    else
        notify("Auto-Kick","Waiting...",5)
        wait(5)
        final_kick_b(userparse(last))
    end
end
game.Players.ChildAdded:connect(function(p)
    for i,v in pairs (banarray) do
        if v == p.Name then
            last = v
        	game.StarterGui:SetCore("SendNotification", {
        		Title = "Auto-Kick";
        		Text = v.. " has joined the game. Would you like to kick them?";
        		Icon = nil;
        		Duration = 8;
        		Button1 = "Kick";
        		Button2 = "Cancel";
        		Callback = bindfunc;
        	})
        end
    end
end)
-- oplr1:Create(
--     "Button",
--     "Control Player (VERY BETA)",
--     function()
--         if not cplr then return end
--         final_control(userparse(cplr))
--     end,
--     {
--         animated = true
--     }
-- )
-- oplr1:Create(
--     "Button",
--     "Stop Controlling Player",
--     function()
--         _G.AbortControlling = true
--     end,
--     {
--         animated = true
--     }
-- )
oplr1:Create(
    "Button",
    "Car Annoy Player",
    function()
        if not cplr then return end
        if not userparse(cplr) then return end
        local u = userparse(cplr).Character
        local plrc = game.Players.LocalPlayer.Character
        repeat
            wait(0.05)
            if (u.HumanoidRootPart.CFrame.p-plrc.HumanoidRootPart.CFrame.p).Magnitude > 10 or not u.Humanoid.SeatPart then
                _G.DogixLT2TPC(u.HumanoidRootPart.CFrame,gkey)
            end
        until u.Humanoid.Health == 0 or plrc.Humanoid.Health == 0 or not plrc.Humanoid.SeatPart or not plrc.Humanoid.Seated
        final_kick()
    end,
    {
        animated = true;
    }
)
oplr1:Create(
    "Button",
    "View Player",
    function()
        if not cplr then return end
        if not userparse(cplr) then return end
		game.Workspace.CurrentCamera.CameraSubject = userparse(cplr).Character
    end,
    {
        text = ""
    }
)
oplr1:Create(
    "Button",
    "Kill Player",
    function()
        if not cplr then return end
        final_kill(userparse(cplr))
    end,
    {
        text = ""
    }
)
oplr1:Create(
    "Button",
    "Hard-Kill Player (deletes players inventory)",
    function()
        if not cplr then return end
        final_hardkill(userparse(cplr))
    end,
    {
        text = ""
    }
)
oplr1:Create(
    "Button",
    "Fling Player",
    function()
        if not cplr then return end
        final_fling(userparse(cplr))
    end,
    {
        text = ""
    }
)
oplr1:Create(
    "Button",
    "Bring Player",
    function()
        if not cplr then return end
        final_bring(userparse(cplr))
    end,
    {
        text = ""
    }
)
oplr1:Create(
    "Button",
    "Tween Bring Player (safe)",
    function()
        if not cplr then return end
        final_tbring(userparse(cplr))
    end,
    {
        text = ""
    }
)
if firetouchinterest then
    oplr1:Create(
        "Button",
        "Spawn Fireball at Player",
        function()
            if not cplr then return end
            local target = userparse(cplr)
            local plr = game.Players.LocalPlayer
            local lava = game.Workspace["Region_Volcano"]:FindFirstChild("Lava") or game.Lighting:FindFirstChild("Lava")
            local leg = plr.Character["Left Leg"]
            local needrevert = false
            if lava.Parent == game.Lighting then
                needrevert = true
                lava.Parent = game.Workspace["Region_Volcano"]
            end
            lava = lava.Lava
            ftouch(leg, lava, true)
            ftouch(leg, lava, false)
            wait(0.75)
            leg.CFrame = target.Character.HumanoidRootPart.CFrame
            game.Players.LocalPlayer.Character.Head:Destroy()
    	    if needrevert then
    	        lava.Parent.Parent = game.Lighting
    	        needrevert = false
    	    end
        end,
        {
            text = ""
        }
    )
end
local stopped_spam = false
local spamming_plr = ""
oplr1:Create(
    "Toggle",
    "Spam Player with Swamp Bridge",
    function(state)
        if not cplr then return end
        if state then
            stopped_spam = false
            local plr = userparse(cplr)
            local oplrc = plr.Character
            spamming_plr = plr.Name
            if not _G.InfRanges then notify("Spam Swamp Bridge","This feature requires Infinite Range.",2) return end
            local part = game.Workspace["Region_Mountainside"].SlabRegen.Slab.Slider
            repeat
                wait()
                part.CFrame = oplrc.HumanoidRootPart.CFrame + Vector3.new(0,2,0)
                if part.Parent:FindFirstChild("PushMe") then
                    part.Parent.PushMe.CFrame = oplrc.HumanoidRootPart.CFrame + Vector3.new(0,2,0)
                end
            until spamming_plr ~= plr.Name or plr == nil or stopped_spam or oplrc == nil or part == nil
        else
            stopped_spam = true
        end
    end,
    {
        default = false
    }
)

local oplr2 = w2:CreateSection("Other Players")
_G.Blacklist = nil
_G.Whitelist = nil
oplr2:Create(
    "Toggle",
    "Auto-Blacklist",
    function(state)
        if _G.Blacklist == nil then
            for i, v in pairs(game:GetService'Players':GetPlayers()) do
                if v.Name ~= game:GetService'Players'.LocalPlayer.Name then
                    game.ReplicatedStorage.Interaction.ClientSetListPlayer:InvokeServer(game:GetService'Players'.LocalPlayer.BlacklistFolder, v, true)
                end
            end
            _G.Blacklist = game:GetService'Players'.PlayerAdded:connect(function(plr)
                game.ReplicatedStorage.Interaction.ClientSetListPlayer:InvokeServer(game:GetService'Players'.LocalPlayer.BlacklistFolder, plr, true)
            end)
        else
            _G.Blacklist:Disconnect()
            _G.Blacklist = nil
        end
    end,
    {
        default = false,
    }
)
oplr2:Create(
    "Toggle",
    "Auto-Whitelist",
    function(state)
        if _G.Whitelist == nil then
            for i, v in pairs(game:GetService'Players':GetPlayers()) do
                if v.Name ~= game:GetService'Players'.LocalPlayer.Name then
                    game.ReplicatedStorage.Interaction.ClientSetListPlayer:InvokeServer(game:GetService'Players'.LocalPlayer.WhitelistFolder, v, true)
                end
            end
            _G.Whitelist = game:GetService'Players'.PlayerAdded:connect(function(plr)
                game.ReplicatedStorage.Interaction.ClientSetListPlayer:InvokeServer(game:GetService'Players'.LocalPlayer.WhitelistFolder, plr, true)
            end)
        else
            _G.Whitelist:Disconnect()
            _G.Whitelist = nil
        end
    end,
    {
        default = false,
    }
)
oplr2:Create(
    "Toggle",
    "Anti-Kick",
    function(state)
        _G.Nokick = state
        if state then
            local function add_connections(char)
                char.ChildAdded:Connect(function(child)
                    if child:IsA("Tool") and child:FindFirstChild("Owner") and child.Owner.Value ~= game.Players.LocalPlayer then
                        if not child.Owner.Value.Character:FindFirstChildOfClass'Humanoid' then
                            child.Parent = game.Lighting
                            game.Players.LocalPlayer.Character.Head:Destroy()
                        end
                    end
                end)
            end
            _G.Nokicking = game.Players.LocalPlayer.CharacterAdded:Connect(add_connections)
            add_connections(game.Players.LocalPlayer.Character)
        else
            _G.Nokicking:Disconnect()
            _G.Nokicking = nil
        end
    end,
    {
        default = false
    }
)
oplr2:Create(
    "Toggle",
    "Sit in Any Car (may break your cars)",
    function(state)
        game:GetService("Players").LocalPlayer.PlayerGui.Scripts.SitPermissions.Disabled = state
    end,
    {
        default = false
    }
)
if getconnections then
    oplr2:Create(
        "Button",
        "Anti-AFK",
        function()
    		for i,v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
    			if v["Disable"] then
    				v["Disable"](v)
    			elseif v["Disconnect"] then
    				v["Disconnect"](v)
    			end
    		end
        	notify("Anti-AFK", "Loaded.", 3)
        end,
        {
            animated = true
        }
    )
end
oplr2:Create(
    "Button",
    "Anti-Blacklist",
    function()
        if not PROTOSMASHER_LOADED then detour_function = hookfunction end
        for i, v in pairs(getgc()) do
            if type(v)=="function" and getfenv(v).script == game:GetService("Players")["LocalPlayer"]["PlayerGui"]["BlackListGUI"]["ClientBeBlacklisted"] then       
                if debug.getinfo(v).name == "makeWalls" then
                    detour_function (v, loadstring([[print("Blacklist Walls Blocked") wait(6048000)]]), true)
                elseif debug.getinfo(v).name == "checkIfPlayerNeedsToBeKicked" then
                    detour_function (v, loadstring([[print("Blacklist Teleport Blocked") wait(6048000)]]), true)
                elseif debug.getinfo(v).name == "removeWalls" then
                    v(nil)
                end
            end
        end
        local last_cframe
        game:GetService("RunService").RenderStepped:Connect(function()
            if game.Players.LocalPlayer.Character.PrimaryPart then
                last_cframe = game.Players.LocalPlayer.Character.PrimaryPart.CFrame
            end
        end)
        for i,v in next, game.Workspace:GetDescendants() do
            if v:IsA("SpawnLocation") then
                v.Touched:Connect(function(part)
                print("[BARK]: Server Teleported Blacklist, Teleporting Back...")
                    if part.Parent == game.Players.LocalPlayer.Character and last_cframe then
                        game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(last_cframe)
                    end
                end)
            end
        end
    end,
    {
        animated = true,
    }
)
oplr2:Create(
    "Button",
    "No Axe Pickup (will lose axes, rejoin to fix)",
    function()
        local plr = game.Players.LocalPlayer
        function drop()
            for i,tool in pairs (plr.Character:children()) do
                if tool:IsA'Tool' then
                    tool.Parent = plr.Backpack
                end
            end
            for i,tool in pairs (plr.Backpack:children()) do
                game:GetService("ReplicatedStorage").Interaction.ClientInteracted:FireServer(tool, "Drop tool", plr.Character.HumanoidRootPart.CFrame)
            end
        end
        local y = game.Workspace.PlayerModels.ChildAdded:connect(function(v)
            if v:WaitForChild'Owner'.Value == plr and v:WaitForChild("ToolName") then
                repeat
                    wait()
                    game:GetService("ReplicatedStorage").Interaction.ClientInteracted:FireServer(v, "Pick up tool")
                until not v
            end
        end)
        for i=1,500 do
            wait()
            drop()
        end
        y:Disconnect()
        y = nil
    end,
    {
        animated = true,
    }
)
function dumpToTable(string,forcegray)
	local nrml = game:GetService("HttpService"):JSONDecode(b64l.decode(string:split'\n'[2]))
	local newtbl = {}
	for i,v in pairs (nrml) do
	    if v.Blueprint == "Floor1Large" and (v.WoodType == nil or forcegray) then
	        for i2,v2 in pairs (get_fake_large_floor_points(CFrame.new(unpack(v.CFrame)))) do
	            table.insert(newtbl, {
	                ["Blueprint"] = "Wall2Tall",
	                ["CFrame"] = {v2:components()},
	                ["WoodType"] = nil
	            })
	        end
	    elseif v.Blueprint == "Floor1" and (v.WoodType == nil or forcegray) then
            table.insert(newtbl, {
                ["Blueprint"] = "Wall2",
                ["CFrame"] = {get_fake_floor_point(CFrame.new(unpack(v.CFrame))):components()}
            })
	    elseif v.Blueprint == "Floor2Large" and (v.WoodType == nil or forcegray) then
	        for i,v in pairs (get_fake_large_tile_points(CFrame.new(unpack(v.CFrame)))) do
                table.insert(newtbl, {
                    ["Blueprint"] = "Floor2Small",
                    ["CFrame"] = {v:components()}
                })
            end
	    elseif v.Blueprint == "Floor2" and (v.WoodType == nil or forcegray) then
	        for i,v in pairs (get_fake_tile_points(CFrame.new(unpack(v.CFrame)))) do
                table.insert(newtbl, {
                    ["Blueprint"] = "Floor2Small",
                    ["CFrame"] = {v:components()}
                })
            end
	    elseif v.Blueprint == "Stair1" and (v.WoodType == nil or forcegray) then
            local pts = get_fake_stair_points(CFrame.new(unpack(v.CFrame)))
            table.insert(newtbl, {
                ["Blueprint"] = "Post",
                ["CFrame"] = {pts.Post1:components()}
            })
            table.insert(newtbl, {
                ["Blueprint"] = "Post",
                ["CFrame"] = {pts.Post2:components()}
            })
            table.insert(newtbl, {
                ["Blueprint"] = "Floor1Small",
                ["CFrame"] = {pts.Floor2:components()}
            })
            table.insert(newtbl, {
                ["Blueprint"] = "Floor1Small",
                ["CFrame"] = {pts.Floor1:components()}
            })
            table.insert(newtbl, {
                ["Blueprint"] = "Stair2",
                ["CFrame"] = {pts.Stairs:components()}
            })
        else
            table.insert(newtbl, v)
        end
	end
	return newtbl
end
function shuffle(array)
    local shuffled = {}
    for i, v in ipairs(array) do
    	local pos = math.random(1, #shuffled+1)
    	table.insert(shuffled, pos, v)
    end
    return shuffled
end

oplr2 = w2:CreateSection("Plot Trolling")
local maxiwall = 0
local adding_walls = false
oplr2:Create(
    "Button",
    "Claim All Plots",
    function(state)
        local landarray = {}
        for i,v in pairs(game.Workspace.Properties:children()) do
            if v.Owner.Value == game.Players.LocalPlayer then
                notify("Claim All Plots", "To prevent data loss, you cannot have a claimed plot.",3)
                return
            end
        end
        for i,v in pairs(game.Workspace.Properties:children()) do
            if v.Owner.Value == nil then
                table.insert(landarray,v)
                game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(v)
            end
        end
        if adding_walls then
            --local dumped = shuffle(dumpToTable(game:HttpGet("https://dogix.wtf/scripts/lt2/barkdata/structures/SmallWall")))
            local dumped = shuffle(dumpToTable(game:HttpGetAsync("https://cdn.applebee1558.com/bark/autobuilds/SmallWall")))
            local int = 0
            local int2 = {}
            local wsca = game.Workspace.PlayerModels.ChildAdded:connect(function(va)
                va:WaitForChild("Owner")
                if va.Owner.Value == game.Players.LocalPlayer then
                    repeat wait() until (va:FindFirstChild("ItemName") and va:FindFirstChild("Type")) or wait(3)
                    if not (va:FindFirstChild("ItemName") and va:FindFirstChild("Type")) then return end
                    if va.Type.Value == "Blueprint" then
                        game:GetService("ReplicatedStorage").PlaceStructure.ClientPlacedStructure:FireServer(va.ItemName.Value, va.PrimaryPart.CFrame, game:GetService'Players'.LocalPlayer, nil, va, true)
                        table.insert(int2, "#barkwinning")
                    end
                end
            end)
            
            for i2,v2 in pairs (landarray) do
                for i3=0,maxiwall do
                    for i,v in pairs (dumped) do
                        print(#int2)
                        int = int + 1
                        if int >= 40 then
                            repeat wait() until #int2 >= 39
                            int2 = {}
                            int = 0
                        end
                        spawn(function()
                            game:GetService("ReplicatedStorage").PlaceStructure.ClientPlacedBlueprint:FireServer(v.Blueprint, CFrame.new(unpack(v.CFrame))+(v2.OriginSquare.Position+Vector3.new(0,8*i3,0)), game.Players.LocalPlayer)
                        end)
                    end
                end
            end
            wait(1)
            wsca:Disconnect()
            wsca = nil
        end
    end,
    {
        animated = true,
    }
)

oplr2:Create(
    "Toggle",
    "Add Walls",
    function(state)
        adding_walls = state
    end,
    {
        default = false,
    }
)
oplr2:Create(
    "Slider",
    "Wall Height",
    function(v)
        maxiwall = v-1
    end,
    {
        min = 1,
        max = 5,
        default = 1,
        changablevalue = true
    }
)

oplr2 = w2:CreateSection("Check Ban")
oplr2:Create(
    "TextBox",
    "Check User ID Ban",
    function(state)
        if getgenv().alphax_ui_init then return end
        if tonumber(state) == nil then
            _G.CurrentBarkUI.Motherframe.Categories.GameCategory["Check BanSection"]["No User ID SpecifiedTextLabel"].TextLabel.Text = "No User ID Specified"
            _G.CurrentBarkUI.Motherframe.Categories.GameCategory["Check BanSection"]["Ban Reason: N/ATextLabel"].TextLabel.Text = "Ban Reason: N/A"
        end
        local banned, reason = game:GetService("ReplicatedStorage").Transactions.GetMod:InvokeServer(tonumber(state))
        if reason == "" then reason = nil end
        _G.CurrentBarkUI.Motherframe.Categories.GameCategory["Check BanSection"]["No User ID SpecifiedTextLabel"].TextLabel.Text = "User ID "..state.." is "..((banned and "banned") or (not banned and "not banned")).." from LT2!"
        _G.CurrentBarkUI.Motherframe.Categories.GameCategory["Check BanSection"]["Ban Reason: N/ATextLabel"].TextLabel.Text = "Ban Reason: "..(reason or "N/A")
    end,
    {
        text="Enter User ID"
    }
)
oplr2:Create("TextLabel", "No User ID Specified")
oplr2:Create("TextLabel", "Ban Reason: N/A")
function checkban(...)
    local isbanned, banreason = game:GetService("ReplicatedStorage").Transactions.GetMod:InvokeServer(game.Players.LocalPlayer.UserId)
    if isbanned then
        local msg = "Bark has detected that your current account is banned from LT2!"
        msg = msg.." Any servers started after your ban join will kick you on join! "
        msg = msg .. "While the ban is still spreading accross servers, you should transfer your items to an alternative account!"
        game:GetService("ReplicatedStorage").Notices.SendUserNotice:Fire(msg)
        return "Ban Status: true"
    end
    return "Ban Status: false"
end
pcall(checkban, ...)

local w2x = main:CreateCategory('Environment')
local env = w2x:CreateSection("Main Features")
env:Create(
    "Toggle",
    "Always Day",
    function(state)
        _G.alwaysday_toggle = state
    end,
    {
        default = false,
    }
)
env:Create(
    "Toggle",
    "Always Night",
    function(state)
        _G.alwaysnight_toggle = state
    end,
    {
        default = false,
    }
)
env:Create(
    "Toggle",
    "No Fog",
    function(state)
        _G.nofog_toggle = state
    end,
    {
        default = false,
    }
)
env:Create(
    "Toggle",
    "Spook Lighting",
    function(state)
        _G.spook_toggle = state
    end,
    {
        default = false,
    }
)

env:Create(
    "Toggle",
    "Solid Water",
    function(state)
        _G.wtr_toggle = state
        for i,v in pairs (game.Workspace.Water:children()) do if v.Name == "Water" then v.CanCollide = not v.CanCollide end end
        for i,v in pairs (game.Workspace.Bridge.VerticalLiftBridge.WaterModel:children()) do if v.Name == "Water" then v.CanCollide = not v.CanCollide end end
    end,
    {
        default = false,
    }
)

env:Create(
    "Button",
    "Delete Water",
    function()
        for i,v in pairs (game.Workspace.Water:children()) do if v.Name == "Water" then v:Destroy() end end
        for i,v in pairs (game.Workspace.Bridge.VerticalLiftBridge.WaterModel:children()) do if v.Name == "Water" then v:Destroy() end end
        game:GetService'Players'.LocalPlayer.PlayerGui.Scripts.CharacterFloat.Disabled = true
        game:GetService'StarterGui'.Scripts.CharacterFloat.Disabled = true
    end,
    {
        animated = true,
    }
)
env:Create(
    "Button",
    "No Water Float and Damage",
    function()
        game:GetService'Players'.LocalPlayer.PlayerGui.Scripts.CharacterFloat.Disabled = true
        game:GetService'StarterGui'.Scripts.CharacterFloat.Disabled = true
    end,
    {
        animated = true,
    }
)

env:Create(
    "Toggle",
    "Disable Lava",
    function(state)
        _G.lava_toggle = state
        if not _G.lava_toggle then
            for i,v in pairs (game.Lighting:children()) do
                if v.Name == "Lava" then
                    v.Parent = game.Workspace["Region_Volcano"]
                    game.Workspace["Region_Volcano"].BasePlate:Destroy()
                end
            end
        else
            for i,v in pairs (game.Workspace["Region_Volcano"]:children()) do
                if v.Name == "Lava" then
                    local bp = v.BasePlate:Clone()
                    bp.Parent = game.Workspace["Region_Volcano"]
                    bp:ClearAllChildren()
                    bp.CanCollide = true
                    bp.BrickColor = game.Workspace["Region_Volcano"].Slate.BrickColor
                    bp.Material = game.Workspace["Region_Volcano"].Slate.Material
                    v.Parent = game.Lighting
                end
            end
        end
    end,
    {
        default = false,
    }
)
--
env:Create(
    "Toggle",
    "No Shrine Boulders",
    function(state)
        _G.nsb_toggle = state
        if not _G.nsb_toggle then
            for i,v in pairs (game.Lighting:children()) do
                if v.Name == "Boulder" then
                    v.Parent = game.Workspace["Region_Mountainside"].BoulderRegen
                end
            end
        else
            game.Workspace["Region_Mountainside"].BoulderRegen.Boulder.Parent = game.Lighting
        end
    end,
    {
        default = false,
    }
)
env:Create(
    "Toggle",
    "No Snow Biome Boulders",
    function(state)
        _G.nsr_toggle = state
        if not _G.nsr_toggle then
            for i,v in pairs (game.Lighting:children()) do
                if v.Name == "PartSpawner" then
                    v.Parent = game.Workspace["Region_Snow"]
                end
            end
        else
            for i,v in pairs (game.Workspace["Region_Snow"]:children()) do
                if v.Name == "PartSpawner" then
                    v.Parent = game.Lighting
                end
            end
        end
    end,
    {
        default = false,
    }
)
env:Create(
    "Toggle",
    "No Volcano Boulders",
    function(state)
        _G.nlvb_toggle = state
        if not _G.nlvb_toggle then
            for i,v in pairs (game.Lighting:children()) do
                if v.Name == "PartSpawner" then
                    v.Parent = game.Workspace["Region_Volcano"]
                end
            end
        else
            for i,v in pairs (game.Workspace["Region_Volcano"]:children()) do
                if v.Name == "PartSpawner" then
                    v.Parent = game.Lighting
                end
            end
        end
    end,
    {
        default = false,
    }
)
env:Create(
    "Toggle",
    "No Maze Walls",
    function(state)
        _G.nmw_toggle = state
        if not _G.nmw_toggle then
            for i,v in pairs (game.Lighting:children()) do
                if v.Name == "Blockade" then
                    v.Parent = game.Workspace["Region_MazeCave"]
                end
            end
        else
            for i,v in pairs (game.Workspace["Region_MazeCave"]:children()) do
                if v.Name == "Blockade" then
                    v.Parent = game.Lighting
                end
            end
        end
    end,
    {
        default = false,
    }
)

env:Create(
    "Toggle",
    "Lower Bridge",
    function(state)
        _G.bdg_toggle = state
        local lift = game.Workspace.Bridge.VerticalLiftBridge.Lift
        if not _G.bdg_toggle then
            lift.Base.CFrame = lift.Base.CFrame + Vector3.new(0,26,0)
        else
            lift.Base.CFrame = lift.Base.CFrame + Vector3.new(0,-26,0)
        end
    end,
    {
        default = false,
    }
)

env:Create(
    "Toggle",
    "Disable Shops",
    function(state)
        _G.shop_disable = state
        rstepqueue(function()
            if _G.shop_disable then
                for i,v in pairs (game.Workspace.Stores:children()) do
                    if v.Name == "ShopItems" then
                        for i1,v1 in pairs (v:children()) do
                            delmodel(v1)
                        end
                        local autod = v.ChildAdded:connect(function(vx)
                            if not _G.shop_disable then
                                return
                            end
                            delmodel(vx)
                        end)
                    end
                end
            end
        end)
    end,
    {
        default = false,
    }
)

local Plot = w2x:CreateSection("Plot Options")
Plot:Create(
    "ColorPicker",
    "Plot Color (CS)",
    function(color)
        for i,v in pairs(game.Workspace.Properties:GetChildren()) do
           if v.Owner.Value == game.Players.LocalPlayer then
                for i2,v2 in pairs (v:children()) do
                    if v2:IsA("BasePart") then
                        v2.Color = color
                    end
                end
               break
           end
        end
    end,
    {
        default = Color3.fromRGB(126,104,63),
    }
)
local envMisc = w2x:CreateSection("Misc Features")
envMisc:Create(
    "Button",
    "Graphics Mod",
    function()
        local light = game.Lighting
        light:ClearAllChildren()
        local color = Instance.new("ColorCorrectionEffect",light)
        local bloom = Instance.new("BloomEffect",light)
        local sun = Instance.new("SunRaysEffect",light)
        local blur = Instance.new("BlurEffect",light)
        local config = {ColorCorrection = true;Sun = true;Lighting = true;BloomEffect = true;}
        color.Enabled = true
        color.Contrast = 0.15
        color.Brightness = 0.1
        color.Saturation = 0.25
        color.TintColor = Color3.fromRGB(255, 222, 211)
        sun.Enabled = true
        sun.Intensity = 0.2
        sun.Spread = 1
        bloom.Enabled = true
        bloom.Intensity = 0.05
        bloom.Size = 32
        bloom.Threshold = 1
        blur.Enabled = true
        blur.Size = 3
    	light.Ambient = Color3.fromRGB(0, 0, 0)
    	light.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
    	light.ColorShift_Top = Color3.fromRGB(0, 0, 0)
    	light.ExposureCompensation = 0
    	light.GlobalShadows = true
    	light.OutdoorAmbient = Color3.fromRGB(112, 117, 128)
    	light.Outlines = false
    end,
    {
        animated = false,
    }
    )
envMisc:Create(
    "Button",
    "Bring Swamp Bridge",
    function()
        if not confirm() then return end
        local plr = game:GetService'Players'.LocalPlayer
        local part = game.Workspace["Region_Mountainside"].SlabRegen.Slab.Slider
        if part == nil then error'slider not found' end
        if part.Parent:FindFirstChild("PushMe") then
            part.Size = part.Parent.PushMe.Size
            part.Parent.PushMe:Destroy()
        end
        if part:FindFirstChild'Weld' ~= nil then
            part.Weld:Destroy()
        end
        local ocf = plr.Character.HumanoidRootPart.CFrame
        if not _G.InfRanges then
            _G.DogixLT2TPC(part.CFrame,gkey)
            wait(1)
        end
        for i=1,12 do
            wait()
            part.CFrame = ocf+Vector3.new(0,30,0)
        end
        if not _G.InfRanges then
            _G.DogixLT2TPC(ocf,gkey)
        end
    end,
    {
        animated = true,
    }
)

envMisc:Create(
    "Button",
    "Delete Green Box",
    function()
        if not confirm() then return end
        local plr = game:GetService'Players'.LocalPlayer
        local part = game.Workspace["Region_Volcano"]:findFirstChild'VolcanoWin'
        local ocf = plr.Character.HumanoidRootPart.CFrame
        if part and part:FindFirstChildOfClass'BodyPosition' then
            _G.DogixLT2TPC(part.CFrame,gkey)
            part:FindFirstChildOfClass'BodyPosition':Destroy()
            delmodel(part)
            wait(0.5)
            _G.DogixLT2TPC(ocf,gkey)
            notify("Delete Green Box", "Success.", 2)
        else
            notify("Delete Green Box", "Couldn't find Green Box.", 2)
        end
    end,
    {
        animated = true,
    }
)
envMisc:Create(
    "Button",
    "Bring Boulders",
    function()
        if not confirm() then return end
        local plr = game:GetService'Players'.LocalPlayer
        local cf = plr.Character.HumanoidRootPart.CFrame
        if not _G.InfRanges then
        local gr = game.Workspace.Gravity
        game.Workspace.Gravity = 0
        end
        for i,v in pairs (game.Workspace["Region_Volcano"]:children()) do
            if v.Name == "PartSpawner" then
                for i1,v1 in pairs (v:children()) do
                    if v1:IsA("BasePart") then
                        wait()
                        if not _G.InfRanges then
                        _G.DogixLT2TPC(v1.CFrame + Vector3.new(0,2,0),gkey)
                        end
                        wait(0.5)
                        for i=1,10 do
                            v1.CFrame = cf+Vector3.new(math.random(-5,5),10,math.random(-5,5))
                            wait()
                        end
                    end
                end
            end
        end
        if not _G.InfRanges then
            game.Workspace.Gravity = gr
            _G.DogixLT2TPC(cf,gkey)
        end
    end,
    {
        animated = true,
    }
)
envMisc:Create(
    "Button",
    "Trigger Pressure Plates",
    function()
        if not confirm() then return end
    	local plrc = game:GetService'Players'.LocalPlayer.Character
    	local ocf = plrc.HumanoidRootPart.CFrame
    	for i,v in pairs (game.Workspace.PlayerModels:children()) do
    		if v:FindFirstChild'ItemName' and v.ItemName.Value == "PressurePlate" then
    			rstepqueue(function()
    			_G.DogixLT2TPC(v.Plate.CFrame,gkey)
    			end)
    			if not cantp then
    				wait(.6)
    			end
    			repeat wait() until v.Output.BrickColor == BrickColor.new("Electric blue")
    		end
    	end
    	_G.DogixLT2TPC(ocf,gkey)
    end,
    {
        animated = true,
    }
)
envMisc:Create(
    "TextLabel",
    "Ferry will depart in: "
)
function updateFerry()
    if getgenv().alphax_ui_init then return end
    local gui
    if getgenv().azure_theme then
        gui = _G.CurrentBarkUI.MainFrame.Categories.EnvironmentContainer.ScrollingFrame["Misc FeaturesSection"]["Ferry will depart in: Label"].TextLabel
    else
        gui = _G.CurrentBarkUI.Motherframe.Categories.EnvironmentCategory["Misc FeaturesSection"]["Ferry will depart in: TextLabel"].TextLabel
    end
    gui.Text = "Ferry will depart in: "..(((math.floor(game.Workspace.Ferry.TimeToDeparture.Value/60) >= 1) and (math.floor(game.Workspace.Ferry.TimeToDeparture.Value/60).."m ")) or "")..game.Workspace.Ferry.TimeToDeparture.Value-(math.floor(game.Workspace.Ferry.TimeToDeparture.Value/60)*60).."s"
end
updateFerry()
_G.ferryUpdate = game.Workspace.Ferry.TimeToDeparture.Changed:connect(function()
     updateFerry()
end)
local envTree = w2x:CreateSection("Tree Features")
local esp_detect_loops = {}
envTree:Create(
    "Toggle",
    "Spook + Sinister ESP and Notifier",
    function(st)
        if not st then
            for i,v in next, esp_trees do
                for _,v2 in pairs (v:GetDescendants()) do
                    if v2:IsA("BoxHandleAdornment") then
                        v2:Destroy()
                    end
                end
            end
            for i,v in pairs (esp_loops) do
                v:Disconnect()
            end
            for i,v in pairs (esp_detect_loops) do
                v:Disconnect()
            end
            esp_loops = {}
            esp_trees = {}
            esp_detect_loops = {}
        else
            for i,v in pairs (game.Workspace:GetChildren()) do
                if v.Name == "TreeRegion" then
                    table.insert(esp_detect_loops, v.ChildAdded:connect(function(ni)
                        ni:WaitForChild("TreeClass")
                        if ni.TreeClass.Value == "Spooky" or ni.TreeClass.Value == "SpookyNeon" then
                            local bindfunc3 = Instance.new("BindableFunction",game.Workspace)
                            bindfunc3.Name = "BARKINT_Spooky"
                            bindfunc3.OnInvoke = function(v)
                                _G.DogixLT2TPC(ni:FindFirstChild("WoodSection").CFrame,gkey)
                            end
                            game.StarterGui:SetCore("SendNotification", {
                            	Title = "Spook/Sinister Notifier";
                            	Text = "Detected "..ni.TreeClass.Value;
                            	Icon = nil;
                            	Duration = 10;
                            	Button1 = "Teleport";
                            	Callback = bindfunc3;
                            })
                            esp_tree(ni)
                        end
                    end))
                    for i,ni in pairs (v:GetChildren()) do
                        if ni:FindFirstChild("TreeClass") then
                            if ni.TreeClass.Value == "Spooky" or ni.TreeClass.Value == "SpookyNeon" then
                                local bindfunc3 = Instance.new("BindableFunction",game.Workspace)
                                bindfunc3.Name = "BARKINT_Spooky"
                                bindfunc3.OnInvoke = function(v)
                                    _G.DogixLT2TPC(ni:FindFirstChild("WoodSection").CFrame,gkey)
                                end
                                game.StarterGui:SetCore("SendNotification", {
                                	Title = "Spook/Sinister Notifier";
                                	Text = "Detected "..ni.TreeClass.Value;
                                	Icon = nil;
                                	Duration = 10;
                                	Button1 = "Teleport";
                                	Callback = bindfunc3;
                                })
                                esp_tree(ni)
                            end
                        end
                    end
                end
            end
        end
    end,
    {default = true}
)

envTree:Create(
    "Button",
    "Bring Dead Logs (may despawn)",
    function()
        if not _G.InfRanges then notify("Bring Dead Logs","This feature requires Infinite Range.",2) return end
        if not confirm() then return end
        local plr = game:GetService'Players'.LocalPlayer
        for i,v in pairs (game.Workspace:GetChildren()) do
            if v.Name == "TreeRegion" then
                for i1,v1 in pairs (v:GetDescendants()) do
                    if v1:IsA("BasePart") then
                        if v1.Anchored == false then
                            v1.CFrame = plr.Character.HumanoidRootPart.CFrame
                        end
                    end
                end
            end
        end
    end,
    {
        animated = true,
    }
)

envTree:Create(
    "Button",
    "Delete Trees",
    function()
        if not confirm() then return end
        for i,v in pairs(game.Workspace:GetChildren()) do
            if v.Name == "TreeRegion" then
                for i,v in pairs (v:GetChildren()) do
                    if v.Name == "Model" and v:IsA'Model' and v:findFirstChild'TreeClass' then
                        delmodel(v)
                    end
                end
            end
        end
    end,
    {
        animated = true,
    }
)
--[[
env:Create(
    "Button",
    "Break Shop Doors (will break the shop too)",
    function()
        if not confirm() then return end
        for i,v in pairs (game.Workspace.Stores:GetDescendants()) do
            if v:IsA'Model' and v.Name == "LDoor" or v.Name == "RDoor" then
                delmodel(v)
            end
        end
    end,
    {
        animated = true,
    }
)]]
local paths = w2x:CreateSection("Paths / Client-side Parts")
paths:Create(
    "Button",
    "Palm and Blue Wood Path",
    function()
        local fld = Instance.new("Folder",game.Workspace)
        fld.Name = "PalmBluePath"
        local part = Instance.new("Part", fld)
        part.CFrame = CFrame.new(2064.42407, -1.71661377e-05, -114.658188, 1, 0, 0, 0, 1, 0, 0, 0, 1)
        part.Size = Vector3.new(2048, 1, 40)
        local part = Instance.new("Part", fld)
        part.CFrame = CFrame.new(2628.07129, -5.38234711, -74.9578552, 1, 0, 0, 0, 0.965925813, -0.258819044, 0, 0.258819044, 0.965925813)
        part.Size = Vector3.new(27, 1, 44)
        part.Rotation = Vector3.new(15, 0, 0)
        local part = Instance.new("Part", fld)
        part.CFrame = CFrame.new(3068.4436, 102.637299, 1487.33228, 1, 0, 0, 0, 0.965925813, 0.258819044, 0, -0.258819044, 0.965925813)
        part.Size = Vector3.new(40, 1, 797)
        part.Rotation = Vector3.new(-15, 0, 0)
        local part = Instance.new("Part", fld)
        part.CFrame = CFrame.new(3068.40991, 0, 503.864014, 1, 0, 0, 0, 1, 0, 0, 0, 1)
        part.Size = Vector3.new(40, 1, 1201)
        local part = Instance.new("Part", fld)
        part.CFrame = CFrame.new(3068.2959, 205.692734, 2233.73389, 1, 0, 0, 0, 1, 0, 0, 0, 1)
        part.Size = Vector3.new(40, 1, 723)
        local part = Instance.new("Part", fld)
        part.CFrame = CFrame.new(3415.86792, 117.841309, 2575.25732, 0.965925813, 0.258819044, 0, -0.258819044, 0.965925813, 0, 0, 0, 1)
        part.Size = Vector3.new(679, 1, 40)
        part.Rotation = Vector3.new(0, 0, -15)
        local part = Instance.new("Part", fld)
        part.CFrame = CFrame.new(3772.75098, 29.79039, 2558.04346, 1, 0, 0, 0, 1, 0, 0, 0, 1)
        part.Size = Vector3.new(62, 1, 75)
        local part = Instance.new("Part", fld)
        part.CFrame = CFrame.new(3428.12695, -54.296978, 2537.90308, 0.965925813, -0.258819044, 0, 0.258819044, 0.965925813, 0, 0, 0, 1)
        part.Size = Vector3.new(650, 1, 35)
        part.Rotation = Vector3.new(0, 0, 15)
        local part = Instance.new("Part", fld)
        part.CFrame = CFrame.new(3100.65503, -137.682968, 1592.43701, 1, 0, 0, 0, 1, 0, 0, 0, 1)
        part.Size = Vector3.new(32, 1, 1926)
        local part = Instance.new("Part", fld)
        part.CFrame = CFrame.new(3407.92847, -215.729431, 649.478455, 0.965925813, 0.258819044, 0, -0.258819044, 0.965925813, 0, 0, 0, 1)
        part.Size = Vector3.new(604, 1, 40)
        for i,v in pairs (fld:children()) do
            v.BrickColor = BrickColor.new(100,100,100)
            v.Material = Enum.Material.WoodPlanks
            v.Anchored = true
        end
        for i,v in pairs (game.Workspace["Region_MazeCave"]:children()) do
            if v:IsA("BasePart") then if v.CFrame == CFrame.new(3115.87378, -139.101868, 650.195923, -0.965929747, 0, -0.258804798, 0, 1, 0, 0.258804798, 0, -0.965929747) or v.CFrame == CFrame.new(3169.97705, -115.490051, 635.698975, -0.682983756, 0.683044851, -0.258811951, 0.707132995, 0.707080603, 3.00034881e-05, 0.183021426, -0.182993948, -0.965928197) or v.CFrame == CFrame.new(3192.33862, -112.796387, 456.075104, -0.482999325, 0.836496592, 0.258814961, 0.86600399, 0.500037193, -4.09781933e-07, -0.129417449, 0.224134564, -0.965926886) then
                v:Destroy()
            end end
        end
        _G.DogixLT2TPC(CFrame.new(1010, 3, -112),gkey)
    end,
    {
        animated = true,
    }
)
paths:Create(
    "Button",
    "Swamp Woods Path",
    function()
        local fld = Instance.new("Folder",game.Workspace)
        fld.Name = "SwampPath"
        local part = Instance.new("Part", fld)
        part.CFrame = CFrame.new(-499.196075, 155.460663, -166.186081, 1, 0, 0, 0, 1, 0, 0, 0, 1)
        part.Size = Vector3.new(295.87, 1, 40.14)
        local part = Instance.new("Part", fld)
        part.CFrame = CFrame.new(-53.5482712, 75.8732529, -166.035767, 0.965925813, 0.258819044, 0, -0.258819044, 0.965925813, 0, 0, 0, 1)
        part.Size = Vector3.new(617.23, 0.72, 40)
        part.Rotation = Vector3.new(0, 0, -15)
        for i,v in pairs (fld:children()) do
            v.BrickColor = BrickColor.new(100,100,100)
            v.Material = Enum.Material.WoodPlanks
            v.Anchored = true
        end
        _G.DogixLT2TPC(CFrame.new(240, 4, -151),gkey)
    end,
    {
        animated = true,
    }
)
paths:Create(
    "Button",
    "Snowglow Path",
    function()
        local fld = Instance.new("Folder",game.Workspace)
        fld.Name = "SGlowPath"
        local part = Instance.new("Part", fld)
        part.CFrame = CFrame.new(8.54199982, -0.914913177, -812.122375, 1, 0, 0, 0, 1, 0, 0, 0, 1)
        part.Size = Vector3.new(55, 1, 186)
        local part = Instance.new("Part", fld)
        part.CFrame = CFrame.new(-309.958008, -0.834023476, -879.710388, 1, 0, 0, 0, 1, 0, 0, 0, 1)
        part.Size = Vector3.new(582, 1, 50)
        local part = Instance.new("Part", fld)
        part.CFrame = CFrame.new(-606.630554, -0.843258381, -748.689453, 0.965925813, 0, -0.258819044, 0, 1, 0, 0.258819044, 0, 0.965925813)
        part.Size = Vector3.new(47, 1, 246)
        part.Rotation = Vector3.new(0, -15, 0)
        local part = Instance.new("Part", fld)
        part.CFrame = CFrame.new(-763.458679, -0.723966122, -652.31958, 1, 0, 0, 0, 1, 0, 0, 0, 1)
        part.Size = Vector3.new(227, 1, 38)
        local part = Instance.new("Part", fld)
        part.CFrame = CFrame.new(-842.989868, -0.602809906, -713.690918, 0.965925872, 0, -0.258818835, 0, 1, 0, 0.258818835, 0, 0.965925872)
        part.Size = Vector3.new(43, 1, 108)
        part.Rotation = Vector3.new(0, -15, 0)
        local part = Instance.new("Part", fld)
        part.CFrame = CFrame.new(-775.692932, -0.588047981, -815.868713, 0.707106829, 0, -0.707106769, 0, 1, 0, 0.707106769, 0, 0.707106829)
        part.Size = Vector3.new(42, 1, 170)
        part.Rotation = Vector3.new(0, -45, 0)
        local part = Instance.new("Part", fld)
        part.CFrame = CFrame.new(-728.159668, -0.591278076, -952.04364, 1, 0, 0, 0, 1, 0, 0, 0, 1)
        part.Size = Vector3.new(55, 1, 182)
        local part = Instance.new("Part", fld)
        part.CFrame = CFrame.new(-864.098999, -0.257263005, -985.877014, 0.965925872, 0, 0.258818835, 0, 1, 0, -0.258818835, 0, 0.965925872)
        part.Size = Vector3.new(235, 1, 56)
        part.Rotation = Vector3.new(0, 15, 0)
        local part = Instance.new("Part", fld)
        part.CFrame = CFrame.new(-1015.87311, -11.1293316, -945.632751, 0.933012664, -0.258819044, 0.25, 0.267445326, 0.963572919, -0.000555455685, -0.240749463, 0.0673795789, 0.968245745)
        part.Size = Vector3.new(82, 1, 55)
        part.Rotation = Vector3.new(0.03, 14.48, 15.51)
        for i,v in pairs (fld:children()) do
            v.BrickColor = BrickColor.new(100,100,100)
            v.Material = Enum.Material.WoodPlanks
            v.Anchored = true
        end
        _G.DogixLT2TPC(CFrame.new(0, 4, -696),gkey)
    end,
    {
        animated = true,
    }
)
paths:Create(
    "Button",
    "Frost Wood Path",
    function()
        local fld = Instance.new("Folder",game.Workspace)
        fld.Name = "FrostPath"
        local part = Instance.new("Part", fld)
        part.CFrame = CFrame.new(744.516663, 71.5780411, 861.148438, 1, -1.04308164e-07, -1.78813934e-07, 1.47034342e-07, 0.965925932, 0.258818656, 1.45724101e-07, -0.258818656, 0.965925932)
        part.Size = Vector3.new(40, 1, 202)
        part.Rotation = Vector3.new(-15, 0, 0)
        local part = Instance.new("Part", fld)
        part.CFrame = CFrame.new(744.273, 97.5341, 1003.82)
        part.Size = Vector3.new(41, 1, 90)
        local part = Instance.new("Part", fld)
        part.CFrame = CFrame.new(775.181458, 100.246162, 1027.58276, 0.965925813, -0.258819044, 0, 0.258819044, 0.965925813, 0, 0, 0, 1)
        part.Size = Vector3.new(46, 1, 43)
        part.Rotation = Vector3.new(0, 0, 15)
        local part = Instance.new("Part", fld)
        part.CFrame = CFrame.new(815.776672, 106.550224, 1027.4032, 1, 0, 0, 0, 1, 0, 0, 0, 1)
        part.Size = Vector3.new(38, 1, 42)
        local part = Instance.new("Part", fld)
        part.CFrame = CFrame.new(815.849976, 257.424072, 1608.79456, 1, 0, 0, 0, 0.965925813, 0.258819044, 0, -0.258819044, 0.965925813)
        part.Size = Vector3.new(38, 1, 1164)
        part.Rotation = Vector3.new(-15, 0, 0)
        local part = Instance.new("Part", fld)
        part.CFrame = CFrame.new(900.612122, 407.759827, 2194.72363, 1, 0, 0, 0, 1, 0, 0, 0, 1)
        part.Size = Vector3.new(208, 1, 50)
        local part = Instance.new("Part", fld)
        part.CFrame = CFrame.new(1268.40649, 407.26062, 2798.83594, 0.91354543, 0, 0.406736642, 0, 1, 0, -0.406736642, 0, 0.91354543)
        part.Size = Vector3.new(41, 2, 1364)
        part.Rotation = Vector3.new(0,24,0)
        for i,v in pairs (fld:children()) do
            v.BrickColor = BrickColor.new(100,100,100)
            v.Material = Enum.Material.WoodPlanks
            v.Anchored = true
        end
        _G.DogixLT2TPC(CFrame.new(738,45,742),gkey)
    end,
    {
        animated = true,
    }
)
paths:Create(
    "Button",
    "Easy Eye Placement",
    function()
        local plr = game:GetService'Players'.LocalPlayer
        local plrc = plr.Character
        local ocf = plr.Character.HumanoidRootPart.CFrame
        local eye = nil
        local cancelled = false
        local connected_car = m.Button1Up:connect(function()
            local part = getMouseTarget()
            if part.Parent:FindFirstChild("Owner") then
                if game:GetService("ReplicatedStorage").Interaction.ClientIsWhitelisted:InvokeServer(part.Parent.Owner.Value) == false and part.Parent.Owner.Value ~= game.Players.LocalPlayer then
                    cancelled = true
                    notify("Eye Placer", "Cancelled. (not owner)",2)
                    return
                end
            end
            if part.Parent:FindFirstChild("ItemName") then
                if part.Parent.ItemName.Value == "Eye1" then
                    if part.Parent:FindFirstChild("Part") then
                        if part.Parent.Part:FindFirstChildOfClass("SpecialMesh") then
                            notify("Eye Placer", "Selected eye.",2)
                            eye = part.Parent
                            return
                        end
                    end
                end
            end
            notify("Eye Placer", "Cancelled.",2)
            cancelled = true
        end)
        notify("Eye Placer", "Please click an unboxed eye to place it. Click elsewhere to cancel.",3)
        repeat wait() until eye ~= nil or cancelled
        connected_car:Disconnect()
        connected_car = nil
        if cancelled then return end
        cancelled = false
        _G.DogixLT2TPC(eye.Main.CFrame,gkey)
        game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(eye)
        eye.Main.CFrame = CFrame.new(134.861435, 5.28133059, -608.149902, 0.85158813, -0.179768249, -0.492423564, -0.111533344, -0.979987442, 0.164878696, -0.512208879, -0.085487105, -0.85459584)
        eye.Main.Velocity = Vector3.new(0,0,0)
        notify("Eye Placer", "Placed eye.",3)
        eye = nil
    end,
    {
        animated = true,
    }
)
local ViewEndTree = false
local viewend = w2x:CreateSection("View End Times Tree")
viewend:Create(
    "Button",
    "View End Times Tree",
    function()
        ViewEndTree = not ViewEndTree
        if ViewEndTree then
            for i,v in pairs(game.Workspace:GetChildren()) do
                if v.Name == "TreeRegion" and v:FindFirstChild ("Model")then
                    if v.Model:FindFirstChild("TreeClass") and v.Model.TreeClass.Value == "LoneCave" then
                        game.Workspace.Camera.CameraSubject = v.Model.WoodSection
                    end
                end
            end
        else
            game.Workspace.Camera.CameraSubject = game.Players.LocalPlayer.Character
        end
    end,
    {
        animated = true,
    }
)
local w3 = main:CreateCategory("Slot")
local land = w3:CreateSection("Land")
land:Create(
    "Button",
    "Free Land",
    function()
       FreeLand();
    end,
    {
        animated = true,
    }
)


land:Create(
    "Button",
    "Max Land",
    function()
        maxLand()
    end,
    {
        animated = true,
    }
)
land:Create(
    "Button",
    "All Blueprints (temporary) patched",
    function()
        for i,v in pairs(game.ReplicatedStorage.Purchasables.Structures.BlueprintStructures:GetChildren()) do
            v:Clone().Parent = game.Players.LocalPlayer.PlayerBlueprints.Blueprints
        end
    end,
    {
        animated = true,
    }
)
land:Create(
    "Button",
    "Auto-Buy Blueprints (perm)",
    function()
        if not confirm() then return end
        for i,v in pairs(game.ReplicatedStorage.Purchasables.Structures.BlueprintStructures:GetChildren()) do
            if not game.Players.LocalPlayer.PlayerBlueprints.Blueprints:FindFirstChild(v.Name) then
                game:GetService("ReplicatedStorage").Interaction.ClientInteracted:FireServer(autobuy(v.Name,1), "Open box")
            end
        end
    end,
    {
        animated = true,
    }
)
land:Create(
    "Button",
    "Clear Plot Blueprints",
    function()
        if not confirm() then return end
        for _,v in pairs (game.Workspace.PlayerModels:GetChildren()) do
            if v:FindFirstChild("Owner") and v:FindFirstChild("BuildDependentWood") and v:FindFirstChild("Type") then
                if v.Type.Value == "Blueprint" and v.Owner.Value == game.Players.LocalPlayer then
                    delmodel(v)
                end
            end
        end
    end,
    {
        animated = true,
    }
)
land:Create(
    "Button",
    "Clear Plot Structures",
    function()
        if not confirm() then return end
        for _,v in pairs (game.Workspace.PlayerModels:GetChildren()) do
            if v:FindFirstChild("Owner") and v:FindFirstChild("MainCFrame") and v:FindFirstChild("Type") then
                if v.Owner.Value == game.Players.LocalPlayer and v.Type.Value == "Structure" then
                    delmodel(v)
                end
            end
        end
    end,
    {
        animated = true,
    }
)
land:Create(
    "Button",
    "Sell Land Purchased Sign",
    function()
        SellSign()
    end,
    {
        animated = true
    }
)
local lpaint = w3:CreateSection("Legit Paint (BETA)")
local paint_tree = "Cherry"
local paint_selector = lpaint:Create(
    "Dropdown",
    "Select Tree",
    function(current)
        paint_tree = TreeConversionTable[current]
    end,
    {
        options = {
            "Cherry";
            "Gold";
            "Cavecrawler";
            "Oak";
            "Frost";
            "Lava";
            "Elm";
            "Walnut";
            "Birch";
            "Snowglow";
            "Pine";
            "Zombie";
            "Koa";
            "Palm";
            "Spook";
            "Sinister";
            "Gray";
        },
        search = true;
    }
)
lpaint:Create(
    "Button",
    "Get Legit Paint Tool",
    function(state)
        local plr = game:GetService("Players").LocalPlayer
        local tool = Instance.new("Tool",plr.Backpack)
        tool.RequiresHandle = false
        tool.Name = "Paint"
        tool.Activated:Connect(function()
            local str = getMouseTarget().Parent
    		if str:FindFirstChild("Type") and str.Type.Value == "Blueprint" and str:FindFirstChild("Owner") and str.Owner.Value == game:GetService'Players'.LocalPlayer or game:GetService("ReplicatedStorage").Interaction.ClientIsWhitelisted:InvokeServer(str.Owner.Value) then
        		lumbsmasher_legitpaint(paint_tree, str, true)
    		end
        end)
    end,
    {
        animated = true,
    }
)

local dupeCounter = 0
local dupeCount = 1
--_G.DupeSlot = 1
local dupi = w3:CreateSection("Duping")


dupi:Create(
    "Toggle",
    "Loop Dupe Inventory",
    function(state)
        _G.bomb_toggle = state
    end,
    {
        default = false,
    }
)
local function force_save()
    local result = false
    repeat
        wait(1)
        getgenv().block_save = false
        local slot_id = game:GetService("Players")["LocalPlayer"]["CurrentSaveSlot"].Value
        result = game.ReplicatedStorage.LoadSaveRequests.RequestSave:InvokeServer(slot_id, game.Players.LocalPlayer)
    until result
    getgenv().block_save = true
end
if newcclosure or protect_function and getrawmetatable and setreadonly and hookfunction and getnamecallmethod then
dupi:Create(
    "Toggle",
    "Slot Saving (patched)",
    function(v)
        getgenv().block_save = not v
    end,
    {
        default = true
    }
)
dupi:Create(
    "Button",
    "Force Slot Save",
    function(v)
        notify("Force Save", "By confirming, you agree that your slot will be saved as-is regardless of save being turned on or off.",2)
        if not confirm() then return end
        notify("Force Save", "Saving Slot...",2)
        force_save()
        notify("Force Save", "Save Complete!",2)
    end
)

local money_came = false
local money_error = false
local function dupemoney()
    if moneyCooldown then
        notify("Cooldown", "Wait for your money to return.",2)
        return
    else
        moneyCooldown = true
        money_came = false
        money_error = false
        local slot_id = game:GetService("Players")["LocalPlayer"]["CurrentSaveSlot"].Value
        notify("Money Dupe", "Sent money, reloading slot...",2)
        local start = tick()
        game.ReplicatedStorage.Transactions.ClientToServer.Donate:InvokeServer(game.Players.LocalPlayer, game.Players.LocalPlayer.leaderstats.Money.Value, slot_id)
        local ending = tick()
        if (ending - start) < 2 then
            moneyCooldown = false
            money_error = true
            return
        end
        notify("Money Dupe", "The money that you've duplicated earlier is returned. Forcing base save...", 3)
        money_came = true
        force_save()
        notify("Duping Finished", "Base Saved!", 5)
        moneyCooldown = false
    end
end
function domoneydupe(slot_id)
    if moneyCooldown then
        notify("Cooldown", "Wait for your money to return.",2)
        return
    end
    money_came = false
    local was_disabling = getgenv().block_save
    getgenv().block_save = true
    wait_for_slot("Money Dupe (patched)")
    spawn(dupemoney)
    wait(2)
    if money_error then
        money_error = false
        getgenv().block_save = was_disabling
        notify("Cooldown", "Donations are on cooldown! Please try again later before duping...",2)
        return
    end
    if autoload_slot(slot_id) then
        repeat force_save() until money_came
    else
        notify("Error", "An error occurred while duping money!", 5)
    end
    repeat wait() until moneyCooldown == false 
    getgenv().block_save = was_disabling
    notify("Money Dupe Complete", "Successfully duped your money!", 5)
end

dupi:Create(
    "Button",
    "Dupe Money (patched)",
    function(v)
        local slot_id = game:GetService("Players")["LocalPlayer"]["CurrentSaveSlot"].Value
        if slot_id == -1 then
            notify("Error", "Please load a slot first before duping money!", 5)
        end
        --domoneydupe(slot_id)
        notify("Patch Notification", "This feature is patched!", 3)
    end,
    {
        animated = true
    }
)


local wlFolder = game:GetService("Players").LocalPlayer.WhitelistFolder


--local dupe_connections = {}
function selfdupe()
    game:GetService("ReplicatedStorage").Interaction.ClientSetListPlayer:InvokeServer(wlFolder,game:GetService("Players").LocalPlayer,true)
    --[[
    for i, v in pairs(game.Workspace.Properties:GetChildren()) do
        if v.Owner.Value == game.Players.LocalPlayer then
            local connection
            connection = v.ChildRemoved:Connect(function(child)
                game.ReplicatedStorage.PropertyPurchasing.ClientExpandedProperty:FireServer(v, child.CFrame)
            end)
            table.insert(dupe_connections, connection)
        end
    end
    ]]
    
end

function unwhitelist()
    game:GetService("ReplicatedStorage").Interaction.ClientSetListPlayer:InvokeServer(game:GetService("Players").LocalPlayer.WhitelistFolder,game:GetService("Players").LocalPlayer,false)
    --[[
    for i, v in pairs(dupe_connections) do
        v:Disconnect()
    end
    dupe_connections = {}
    ]]
end

function selfdupeon(donate_slot)
    local candupe = false
    local loadcnt = 0
	if game.Players.LocalPlayer.CurrentSaveSlot.Value == -1 then
		notify("Error", "No Plot Is Loaded..", 3)
		return
	end 
	wait_for_slot("Self-Dupe")
	local was_disabling = getgenv().block_save
	local bindfunc3 = Instance.new("BindableFunction")
	bindfunc3.OnInvoke = function(v)
		loadcnt = 10
		canDupe = (v == "Yes")
	end
	game.StarterGui:SetCore("SendNotification", {
		Title = "Bark "..cv;
		Text = "All items in your slot will be duplicated. Continue?";
		Icon = nil;
		Duration = 10;
		Button1 = "Yes";
		Button2 = "No";
		Callback = bindfunc3;
	})
	repeat
		wait(1)
		loadcnt = loadcnt + 1
	until loadcnt >= 10
	bindfunc3:Destroy()
	if canDupe then
    	getgenv().block_save = true
		notify('Bark '..cv, 'Starting Self Auto-Dupe, Please wait...')
		selfdupe()
        local randomplot
        for _, v1 in pairs (game.Workspace.Properties:GetChildren()) do
			if v1.Owner.Value == nil then
				game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(v1)
                randomplot = v1
				break
			end
		end
        local loaded_slot = false
        local target_slot = game.Players.LocalPlayer.CurrentSaveSlot.Value
        if donate_slot then
            target_slot = -1
        end
		spawn(function()
            autoload_slot(target_slot)
            loaded_slot = true
        end)
        game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(randomplot)
        repeat wait() until loaded_slot
        if donate_slot then
            unwhitelist()
            game.Players.LocalPlayer.CurrentSaveSlot.Value = -1
            getgenv().block_save = was_disabling
            notify("Donate Slot", "Your slot has been donated!")
            return
        end
		local baseCFrame = nil
		for _, v1 in pairs (game.Workspace.Properties:GetChildren()) do
			if tostring(v1.Owner.Value) == tostring(game.Players.LocalPlayer) then
				baseCFrame = v1.OriginSquare.CFrame
				break
			end
		end
		for i, v in pairs (game.Workspace.PlayerModels:GetChildren()) do
			if v:FindFirstChild('Owner') then
				if v.Owner.Value == game.Players.LocalPlayer then
                    local main_cframe
                    if  v:FindFirstChild("MainCFrame") then
                        main_cframe = v.MainCFrame.Value
                    elseif v:FindFirstChild("WoodSection") then
                        main_cframe = v.WoodSection.CFrame
                    else
                        main_cframe = v.Main.CFrame
                    end
					if math.abs(baseCFrame.Z - main_cframe.Z) >= 100 or math.abs(baseCFrame.X - main_cframe.X) >= 100 then
						if v:FindFirstChild("Type") and (v.Type.Value == "Loose Item" or v.Type.Value == "Tool" or v.Type.Value == "Gift" or ((v.Type.Value == "Structure" or v.Type.Value == "Furniture" or v.Type.Value == "Wire") and (v:FindFirstChild("PurchasedBoxItemName") or v:FindFirstChild("BoxItemName")))) then
							dirtBaseDropInstant(v, baseCFrame)
                        elseif v:FindFirstChild("WoodSection") then
                            _G.DogixLT2TPC(v.WoodSection.CFrame,gkey)
						    _G.DogixLT2DragAlt(v.WoodSection, baseCFrame)
						end
					end
				end
			end
		end
	end
	unwhitelist()
	getgenv().block_save = was_disabling
	game:GetService("ReplicatedStorage").LoadSaveRequests.RequestSave:InvokeServer(game:GetService("Players").LocalPlayer.CurrentSaveSlot.Value, game.Players.LocalPlayer)
	notify('Self Dupe', 'Finished Self Auto-Dupe')
	canDupe = false
end

local fls = w3:CreateSection("Fast Load Slot")
local currentslot_al = (game.Players.LocalPlayer:FindFirstChild"CurrentSaveSlot" and ((game.Players.LocalPlayer.CurrentSaveSlot.Value ~= -1 and game.Players.LocalPlayer.CurrentSaveSlot.Value) or 1)) or 1
fls:Create(
    "Slider",
    "Selected Slot",
    function(v)
        currentslot_al = v
    end,
    {
        min = 1,
        max = 6,
        default = currentslot_al,
        changablevalue = true
    }
)
fls:Create(
    "Button",
    "Fast Load Slot",
    function(v)
        wait_for_slot("Fast Load")
        notify("Fast Load", "Auto-loading slot...",3)
        local loadedSlot = autoload_slot(currentslot_al)
        if loadedSlot == true then
            game:GetService("Players").LocalPlayer.CurrentSaveSlot.Value = currentslot_al
            notify("Fast Load", "Finished loading slot.",3)
        else
            notify("Fast Load", "Failed loading slot.",3)
        end
    end,
    {
        animated = true
    }
)

fls:Create(
    "Button",
    "Ancestor\'s Load Slot",
    function(v)
      fastLoadSelectedPlot(currentslot_al)
    end,
    {
        animated = true
    }
)

local transfr = w3:CreateSection("Transfer Items (BETA)")
Transfer_slot = 1
transfr:Create(
    "Slider",
    "Selected Slot",
    function(v)
        Transfer_slot = v
    end,
    {
        min = 1,
        max = 6,
        default = Transfer_slot,
        changablevalue = true
    }
)
transfr:Create(
    "Button",
    "Dupe Money to Slot (patched)",
    function(v)
        local slot_id = game:GetService("Players")["LocalPlayer"]["CurrentSaveSlot"].Value
        if slot_id == -1 then
            notify("Error", "Please load a slot first before duping money!", 5)
        end
        domoneydupe(Transfer_slot)
    end,
    {
        animated = true
    }
)
transfr:Create(
    "Button",
    "Transfer Items To Selected Slot (patched)",
    function(v)
        local canDupe = false
        local loadcnt = 0
        local was_disabling = getgenv().block_save
        wait_for_slot("Transfer Items")
        getgenv().block_save = true
        local bindfunc3 = Instance.new("BindableFunction", game.Workspace)
        bindfunc3.Name = "BARKINT_UiLibHandler"
        bindfunc3.OnInvoke = function(v)
            loadcnt = 10
            canDupe = v == "Yes"
        end
        game.StarterGui:SetCore("SendNotification", {
            Title = "Bark "..cv;
            Text = "Only items on the origin part will be Transferred. Continue?";
            Icon = nil;
            Duration = 10;
            Button1 = "Yes";
            Button2 = "No";
            Callback = bindfunc3;
        })
        repeat
            wait(1)
            loadcnt = loadcnt + 1
        until loadcnt >= 10
        bindfunc3:Destroy()
        if not canDupe then return end
        notify('Bark '..cv, 'Starting Self-Transfer, Please Wait...')
        selfdupe()
        autoload_slot(Transfer_slot)
        local autoDupeTo = game.Players.LocalPlayer
        local baseCFrame = nil
        for _, v1 in pairs (game.Workspace.Properties:GetChildren()) do
            if tostring(v1.Owner.Value) == tostring(autoDupeTo) then
                baseCFrame = v1.OriginSquare.CFrame
                print(baseCFrame)
                break
            end
        end
        --[[
        for i, v in pairs (game.Workspace.PlayerModels:GetChildren()) do
            if v:FindFirstChild'Owner' and v:FindFirstChild'Type' then
                if v.Owner.Value == game.Players.LocalPlayer then
                    if v.Type.Value == "Loose Item"
                    or v.Type.Value == "Tool"
                    or v.Type.Value == "Gift"
                    or ((v.Type.Value == "Structure" or v.Type.Value == "Furniture" or v.Type.Value == "Wire") and (v:FindFirstChild("PurchasedBoxItemName") or v:FindFirstChild("BoxItemName")))
                    then
                        dirtBaseDropInstant(v, baseCFrame)
                    end
                end
            end
        end
        ]]
        local baseCFrame = nil
        for _, v1 in pairs (game.Workspace.Properties:GetChildren()) do
            if tostring(v1.Owner.Value) == tostring(game.Players.LocalPlayer) then
                baseCFrame = v1.OriginSquare.CFrame
                break
            end
        end
        for i, v in pairs (game.Workspace.PlayerModels:GetChildren()) do
            if v:FindFirstChild'Owner' and v:FindFirstChild'WoodSection' then
                if v.Owner.Value == game.Players.LocalPlayer then
                    if v.TreeClass.Value ~= "PropertySoldSign" then
                        if math.abs(baseCFrame.Z - v.WoodSection.CFrame.Z) >= 100 or math.abs(baseCFrame.X - v.WoodSection.CFrame.X) >= 100 then
                            _G.DogixLT2DragAlt(v.WoodSection, baseCFrame)
                        end
                    end
                end
            end
        end
        unwhitelist()
        getgenv().block_save = was_disabling
        game:GetService("ReplicatedStorage").LoadSaveRequests.RequestSave:InvokeServer(Transfer_slot, game.Players.LocalPlayer)
        notify('Bark '..cv, 'Finished Transfer.')
        canDupe = false
    end,
    {
        animated = true
    }
)

transfr:Create(
    "Button",
    "Self Dupe Current Slot (patched)",
    function(v)
    selfdupeon()
end,
    {
        animated = true
    }
)

end

if getconnections then
--autoload slot

--[[
local autoDupeSlotSwitch = false
local autoLoading = false
function loadSlotAuto(slotnum)
    if autoDupeSlotSwitch == false and not sentinelbuy then
        local senv = getsenv(game:GetService("Players").LocalPlayer.PlayerGui.PropertyPurchasingGUI.PropertyPurchasingClient)
        local old = senv.enterPurchaseMode
        getsenv(game:GetService("Players").LocalPlayer.PlayerGui.PropertyPurchasingGUI.PropertyPurchasingClient).enterPurchaseMode = function(...)
            if not autoLoading then
                return old(...)
            else
                local plot = nil
                for i,v in pairs(game.Workspace.Properties:children()) do
                    if v.Owner.Value == nil then
                        plot = v
                        break
                    end
                end
                debug.setupvalue(senv.rotate, 3, 0)
                debug.setupvalue(old, 10, plot)
                return
            end
        end
        autoDupeSlotSwitch = true
    end
    local loadedSlot = nil
    spawn(function()
        loadedSlot = game:GetService("ReplicatedStorage").LoadSaveRequests.RequestLoad:InvokeServer(slotnum, game.Players.LocalPlayer)
    end)
    if not autoDupeSlotSwitch then
        repeat wait() until game.Players.LocalPlayer.PlayerGui.PropertyPurchasingGUI.SelectPurchase.Visible
        wait(1)
        game:GetService("VirtualInputManager"):SendKeyEvent(true,"E",false,game)
        wait(1.5)
        game:GetService("VirtualInputManager"):SendKeyEvent(true,"E",false,game)
    else
        autoLoading = true
    end
    repeat wait() until loadedSlot ~= nil
    autoLoading = false
    return loadedSlot
end
]]
if getgenv().loadslot_hooked ~= true then
    getgenv().loadslot_hooked = true
    getgenv().autoload_slot = false
    if debug.getregistry == nil then debug.getregistry = getreg end --fixing krnl
    --get select plot function
    if not SENTINEL_LOADED then
        for i,v in pairs(debug.getregistry()) do
            if typeof(v) == "function" and getfenv(v).script == game:GetService("Players").LocalPlayer.PlayerGui.PropertyPurchasingGUI.PropertyPurchasingClient then
                if debug.getinfo(v).name == "OnClientInvoke" then
                    getfenv(v).require = require
                    getgenv().select_plot_func = v
                end
            end
        end
    else
        warn("[Bark]: Sentinel Detected! Loading Alt Slot Hook!")
        for i,v in pairs(debug.getregistry()) do
            if typeof(v) == "function" and getfenv(v).script == game:GetService("Players").LocalPlayer.PlayerGui.PropertyPurchasingGUI.PropertyPurchasingClient then
                if #debug.getconstants(v) == 1 and debug.getconstants(v)[1] == "enterPurchaseMode" then
                    getfenv(v).require = require
                    getgenv().select_plot_func = v
                end
            end
        end
    end
    function game.ReplicatedStorage.PropertyPurchasing.SelectLoadPlot.OnClientInvoke(...)
        if getgenv().autoload_slot == true then
            getgenv().autoload_slot = false
            for i,v in pairs(game.Workspace.Properties:GetChildren()) do
                if v:FindFirstChild("Owner") and v.Owner.Value == nil and #v:GetChildren() == 2 then
                    return v, 0
                end
            end
        end
        return getgenv().select_plot_func(...)
    end
    print("[BARK]: Hooked select slot function!")
end
function autoload_slot(slot_number)
    wait_for_slot("Auto-Load Slot")
    getgenv().autoload_slot = true
    return game:GetService("ReplicatedStorage").LoadSaveRequests.RequestLoad:InvokeServer(slot_number, game.Players.LocalPlayer)
end

local DupeSlot = w3:CreateSection("Slot-Dupe");
DupeSlot:Create(
    "Dropdown",
    "To Player",
    function(newa)
        playerToDupeTo = newa
    end,
    {
        text = "",
        search = true,
        playerlist = true
    }
)

DupeSlot:Create(
    "Toggle",
    "Instruct Target",
    function(v)
        alertTarget = v
    end,
    {
        animated = false
    }
)

DupeSlot:Create(
    "Button",
    "Dupe Plot To Selected Player (patched)",
    function(v)
        DonatePlotToPlayer()
    end,
    {
        animated = true
    }
)


local autodupe = w3:CreateSection("Auto-Dupe")
local currentslot = (game.Players.LocalPlayer:FindFirstChild"CurrentSaveSlot" and ((game.Players.LocalPlayer.CurrentSaveSlot.Value ~= -1 and game.Players.LocalPlayer.CurrentSaveSlot.Value) or 1)) or 1
if not getgenv().alphax_ui_init then
    autodupe:Create(
        "TextLabel",
        "Alex uncap labels nob.",
        {}
    )
    local gui
    if getgenv().azure_theme then
        gui = _G.CurrentBarkUI.MainFrame.Categories.SlotContainer.ScrollingFrame["Auto-DupeSection"]["Alex uncap labels nob.Label"].TextLabel
    else 
        gui = _G.CurrentBarkUI.Motherframe.Categories.SlotCategory["Auto-DupeSection"]["Alex uncap labels nob.TextLabel"].TextLabel
    end
    --gui.Text = "With dupe scripts, there's a chance your base may wipe."
    gui.Text = "All forms of duping on bark are currently patched."
end
autodupe:Create(
    "Slider",
    "Selected Slot",
    function(v)
        currentslot = v
    end,
    {
        min = 1,
        max = 6,
        default = currentslot,
        changablevalue = true
    }
)
local autoDupeTo = game.Players.LocalPlayer
autodupe:Create(
    "Dropdown",
    "To Player",
    function(newa)
        autoDupeTo = newa
    end,
    {
        text = "",
        search = true,
        playerlist = true
    }
)
local droppedCounter = 0
function dirtBaseDropInstant(v, baseCFrame, woodClass, itemName)
    notify("Patch Notification", "The feature you have used contains a patched function. Please make a ticket and notify applebee of what function you used.",5)
    local remote = game:GetService("ReplicatedStorage").PlaceStructure.ClientPlacedStructure
    remote.Name = game:GetService("HttpService"):GenerateGUID(false)
    remote:FireServer((itemName or nil), baseCFrame, game.Players.LocalPlayer, (woodClass or nil), v, true)
    wait(0.04)
    remote.Name = "ClientPlacedStructure"
end

autodupe:Create(
    "Button",
    "Start Auto-Dupe Items",
    function(v)
        if autoDupeTo == game.Players.LocalPlayer then
            notify("Auto-Dupe", "Please select a player to base drop!",3)
            return
        end
        local baseCFrame = nil
        for _,v1 in pairs (game.Workspace.Properties:GetChildren()) do
            if tostring(v1.Owner.Value) == tostring(autoDupeTo) then
                baseCFrame = v1.OriginSquare.CFrame
                break
            end
        end
        if baseCFrame == nil then
            notify("Auto-Dupe", "The selected player is not loaded!",3)
            return
        end
        autoDupeTo = game.Players[tostring(autoDupeTo)]
        if not game:GetService("ReplicatedStorage").Interaction.ClientIsWhitelisted:InvokeServer(autoDupeTo) then
            notify("Auto-Dupe", "The selected player **needs to whitelist** YOU!",3)
            return
        end
        if not game:GetService'Players'.LocalPlayer.WhitelistFolder:FindFirstChild(tostring(autoDupeTo)) then
            notify("Auto-Dupe", "Automatically whitelisted "..tostring(autoDupeTo)..".",3)
            game.ReplicatedStorage.Interaction.ClientSetListPlayer:InvokeServer(game:GetService'Players'.LocalPlayer.WhitelistFolder, autoDupeTo, true)
        end
        if currentslot < 1 then
            if game.Players.LocalPlayer.CurrentSaveSlot.Value < 1 then
                notify("Auto-Dupe", "Please select a slot to use!",3)
                return
            else
                currentslot = game.Players.LocalPlayer.CurrentSaveSlot.Value
                notify("Auto-Dupe", "No slot selected, defaulting to current slot.",3)
            end
        end
        if game.Players.LocalPlayer.CurrentSaveSlot.Value ~= currentslot then
            wait_for_slot()
            notify("Auto-Dupe", "Loading slot...",3)
            local loadedSlot = autoload_slot(currentslot)
            if loadedSlot == false then
                notify("Auto-Dupe", "An error has occured while attempting to load slot.",3)
                return
            else
                game.Players.LocalPlayer.CurrentSaveSlot.Value = currentslot
                notify("Auto-Dupe", "Loaded slot, starting Base-Drop.",3)
            end
        end
        local was_disabling = getgenv().block_save
        getgenv().block_save = true
        for i,v in pairs (game.Workspace.PlayerModels:GetChildren()) do
            if v:FindFirstChild'Owner' and v:FindFirstChild'Type' then
                if v.Owner.Value == game.Players.LocalPlayer then
                    if v.Type.Value == "Loose Item"
                    or v.Type.Value == "Tool"
                    or v.Type.Value == "Gift"
                    or ((v.Type.Value == "Structure" or v.Type.Value == "Furniture" or v.Type.Value == "Wire") and (v:FindFirstChild("PurchasedBoxItemName") or v:FindFirstChild("BoxItemName")))
                    then
                        dirtBaseDropInstant(v,baseCFrame)
                    end
                end
            end
        end
        notify("Auto-Dupe", "Finished Base-Drop, reloading.",3)
        if not game:GetService("ReplicatedStorage").LoadSaveRequests.ClientMayLoad:InvokeServer(game.Players.LocalPlayer) then
            notify("Auto-Dupe", "Load is on cooldown. Waiting...",3)
            repeat
                wait(5)
            until game:GetService("ReplicatedStorage").LoadSaveRequests.ClientMayLoad:InvokeServer(game.Players.LocalPlayer)
        end
        if autoload_slot(currentslot) then
            game.Players.LocalPlayer.CurrentSaveSlot.Value = currentslot
        end
        getgenv().block_save = was_disabling
        notify("Auto-Dupe", "Finished.",3)
    end,
    {
        animated = true
    }
)

autodupe:Create(
    "Button",
    "Start Auto-Dupe Planks",
    function(v)
        if autoDupeTo == game.Players.LocalPlayer then
            notify("Auto-Dupe", "Please select a player to base drop!",3)
            return
        end
        local baseCFrame = nil
        for _,v1 in pairs (game.Workspace.Properties:GetChildren()) do
            if tostring(v1.Owner.Value) == tostring(autoDupeTo) then
                baseCFrame = v1.OriginSquare.CFrame
                break
            end
        end
        if baseCFrame == nil then
            notify("Auto-Dupe", "The selected player is not loaded!",3)
            return
        end
        autoDupeTo = game.Players[tostring(autoDupeTo)]
        if not game:GetService("ReplicatedStorage").Interaction.ClientIsWhitelisted:InvokeServer(autoDupeTo) then
            notify("Auto-Dupe", "The selected player **needs to whitelist** YOU!",3)
            return
        end
        if not game:GetService'Players'.LocalPlayer.WhitelistFolder:FindFirstChild(tostring(autoDupeTo)) then
            notify("Auto-Dupe", "Automatically whitelisted "..tostring(autoDupeTo)..".",3)
            game.ReplicatedStorage.Interaction.ClientSetListPlayer:InvokeServer(game:GetService'Players'.LocalPlayer.WhitelistFolder, autoDupeTo, true)
        end
        if currentslot < 1 then
            if game.Players.LocalPlayer.CurrentSaveSlot.Value < 1 then
                notify("Auto-Dupe", "Please select a slot to use!",3)
                return
            else
                currentslot = game.Players.LocalPlayer.CurrentSaveSlot.Value
                notify("Auto-Dupe", "No slot selected, defaulting to current slot.",3)
            end
        end
        if game.Players.LocalPlayer.CurrentSaveSlot.Value ~= currentslot then
            if not game:GetService("ReplicatedStorage").LoadSaveRequests.ClientMayLoad:InvokeServer(game.Players.LocalPlayer) then
                notify("Auto-Dupe", "Load is on cooldown. Waiting...",3)
                repeat
                    wait(5)
                until game:GetService("ReplicatedStorage").LoadSaveRequests.ClientMayLoad:InvokeServer(game.Players.LocalPlayer)
            end
            notify("Auto-Dupe", "Loading slot...",3)
            local loadedSlot = autoload_slot(currentslot)
            if loadedSlot == false then
                notify("Auto-Dupe", "An error has occured while attempting to load slot.",3)
                return
            else
                game.Players.LocalPlayer.CurrentSaveSlot.Value = currentslot
                notify("Auto-Dupe", "Loaded slot, starting Base-Drop.",3)
            end
        end
        local was_disabling = getgenv().block_save
        getgenv().block_save = true
           local baseCFrame = nil
        for _,v1 in pairs (game.Workspace.Properties:GetChildren()) do
            if tostring(v1.Owner.Value) == tostring(autoDupeTo) then
                baseCFrame = v1.OriginSquare
                break
            end
        end

        for i,v in pairs (game.Workspace.PlayerModels:GetChildren()) do
            if v:FindFirstChild'Owner' and v:FindFirstChild'WoodSection' then
                if v.Owner.Value == game.Players.LocalPlayer then
                    if v.TreeClass.Value ~= "PropertySoldSign" then
                       _G.DogixLT2DragAlt(v.WoodSection, baseCFrame.CFrame)
                    end
                end
            end
        end
        notify("Auto-Dupe", "Finished Base-Drop, reloading.",3)
        if not game:GetService("ReplicatedStorage").LoadSaveRequests.ClientMayLoad:InvokeServer(game.Players.LocalPlayer) then
            notify("Auto-Dupe", "Load is on cooldown. Waiting...",3)
            repeat
                wait(5)
            until game:GetService("ReplicatedStorage").LoadSaveRequests.ClientMayLoad:InvokeServer(game.Players.LocalPlayer)
        end
        if autoload_slot(currentslot) then
            game.Players.LocalPlayer.CurrentSaveSlot.Value = currentslot
        end
        getgenv().block_save = was_disabling
        notify("Auto-Dupe", "Finished.",3)
    end,
    {
        animated = true
    }
)

end
local sorter = w3:CreateSection("Base Sorter")
local Selected = nil
local selectedList = {}
local multiselecting = false
sorter:Create(
    "Button",
    "Get Item Selection Tool",
    function(v)
        Identify = Instance.new("Tool",game.Players.LocalPlayer.Backpack)
		Identify.RequiresHandle = false
		Identify.Name = "Select"
		Identify.Activated:connect(function()
		    local item = getMouseTarget().Parent
            if item == nil then
                return
            end
		    local name = item:FindFirstChild"PurchasedBoxItemName" or item:FindFirstChild"BoxItemName" or item:FindFirstChild"ItemName" or item:FindFirstChild"TreeClass"
		    if not name then
		        notify("Base Sorter", "Couldn't identify item.", 3)
		    else
		        name = name.Value
		        if multiselecting then
		            local removed = false
		            for i,v in pairs (selectedList) do
		                if v == name then
		                    selectedList[i] = nil
		                    removed = true
		                end
		            end
		            if removed then
        		        notify("Base Sorter", "Unselected "..name..".", 3)

        		    else
        		        table.insert(selectedList, name)
        		        notify("Base Sorter", "Selected "..name..".", 3)
        		        Selected = name

        		    end
		        else
    		        notify("Base Sorter", "Selected "..name..".", 3)
		            Selected = name
		            print(Selected)
		        end
			end
		end)
    end,
    {
        animated = true
    }
)
sorter:Create(
    "Toggle",
    "Multi-Select",
    function(v)
        multiselecting = v
        selectedList = {}
    end,
    {
        animated = false
    }
)

local sorter_limit
sorter:Create(
    "Toggle",
    "Item Sorter Limit",
    function(state)
        if not state then 
            sorter_limit = -1
        else
            if sorter_limit == nil then
                sorter:Create(
                    "Slider",
                    "Item Sorter Limit",
                    function(v)
                        if sorter_limit ~= -1 then
                            sorter_limit = v 
                        end
                    end,
                    {
                        min = 1,
                        max = 100,
                        default = 1,
                        changablevalue = true
                    }
                )
                sorter_limit = 1
            end
        end
    end
)
local target_name = "ItemName"

sorter:Create(
    "Toggle",
    "Box?",
    function(state)
        if state then
            target_name = "PurchasedBoxItemName"
        else
            target_name = "ItemName"
        end
    end
)

function dropMeme(aasas,CFrame)
    local count = 0
    for i,v in pairs (game.Workspace.PlayerModels:children()) do
        if v:FindFirstChild'Owner' and v:FindFirstChild(target_name) then
            local nm = v:FindFirstChild(target_name)
            if v.Owner.Value == game.Players.LocalPlayer and nm.Value == aasas then
                count = count + 1
                dirtBaseDropInstant(v,(CFrame or v.PrimaryPart.CFrame-Vector3.new(0,.1,0)))
                if sorter_limit and sorter_limit ~= -1 then
                    if count >= sorter_limit then
                        break
                    end
                end
            end
        end
    end
end
sorter:Create(
    "Button",
    "Bring Selected Item",
    function(state)
        if Selected == nil and selectedList == {} then
            notify("Base Sorter", "No item detected!", 3)
            return
        end
        local baseCFrame = nil
        for _,v1 in pairs (game.Workspace.Properties:GetChildren()) do
            if v1.Owner.Value == game.Players.LocalPlayer then
                baseCFrame = v1.OriginSquare.CFrame
                break
            end
        end
        if math.abs(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Z-baseCFrame.Z) > 100 or math.abs(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.X-baseCFrame.X) > 100 then
            notify("Base Sorter", "You cannot sort off of your plot.", 3)
            return
        end
        local CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        if multiselecting then
            for i,v in pairs (selectedList) do
                dropMeme(v, CFrame)
            end
            selectedList = {}
        else
            dropMeme(Selected, CFrame)
        end
        notify("Base Sorter", "Finished.", 3)
    end,
    {
        animated = true,
    }
)
function bringplanka(SelectedA, CF)
    for i,v in pairs (game.Workspace.PlayerModels:GetChildren()) do
        if v:FindFirstChild("Owner") and v.Owner.Value == game.Players.LocalPlayer and v:FindFirstChild("TreeClass") and v.TreeClass.Value == SelectedA then
            --print(v)
            _G.DogixLT2DragAlt(v.WoodSection, CF)
        end
    end
end
sorter:Create(
    "Button",
    "Bring Selected Plank",
    function(state)
    local CF = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    if multiselecting then
        for i,v in pairs (selectedList) do
            bringplanka(v, CF)
        end
    else
        bringplanka(Selected, CF)
    end
end,
    {
        animated = true,
    }
)
local othr = w3:CreateSection("Car Spawner")
local color = ""
othr:Create(
    "Dropdown",
    "Car Selection",
    function(state)
        color = state
    end,
    {
        options = {
            "Hot pink";
            "Medium stone grey";
            "Sand green";
            "Sand red";
            "Faded green";
            "Dark grey metallic";
            "Dark grey";
            "Earth yellow";
            "Earth orange";
            "Silver";
            "Brick yellow";
            "Dark red";
            "Rust";
            "Really black";
            "Lemon metalic";
        },
        search = true,
        default = "Hot pink";
    }
)
local destroyme = true
othr:Create(
    "Toggle",
    "Destroy Spawn Pad",
    function(v)
        destroyme = v
    end,
    {
        default = true
    }
)
othr:Create(
    "Button",
    "Spawn Car",
    function(v)
        local plr = game:GetService'Players'.LocalPlayer
        local m = plr:GetMouse()
        local part = nil
        local connected_car = m.Button1Up:connect(function()
            part = getMouseTarget()
        end)
        notify("Car Spawner", "Left Click the spawn button of a vehicle pad to spawn a car.",3)
        repeat wait() until part ~= nil
        connected_car:Disconnect()
        connected_car = nil
        if part.Name == "SpawnButton" then
            local pad = part.Parent
            if pad.Owner.Value ~= plr then
                return
            end
            pad.Name = "_BARK_"..math.random(1000000,9999999)
            local rmt = pad.ButtonRemote_SpawnButton
            _G.stop_carspawn = false
            repeat
                local cancontinue = false
                game:GetService("ReplicatedStorage").Interaction.RemoteProxy:FireServer(rmt)
                local cadded = game.Workspace.PlayerModels.ChildAdded:connect(function(v)
                    v:WaitForChild("Owner")
                    if v:FindFirstChild("Owner") and v.Owner.Value == plr then
                        v:WaitForChild("PaintParts")
                        v.PaintParts:WaitForChild("Part")
                        if tostring(v.PaintParts.Part.BrickColor) == color then
                            _G.stop_carspawn = true
                            if destroyme then
                                game:GetService("ReplicatedStorage").Interaction.DestroyStructure:FireServer(pad)
                            end
                        else
                            if cadded ~= nil then
                                cadded:Disconnect()
                                cadded = nil
                            end
                        end
                    end
                    cancontinue = true
                end)
                wait(0.25)
                repeat wait() until cancontinue
            until _G.stop_carspawn
        end
    end,
    {
        animated = true
    }
)
othr:Create(
    "Button",
    "Cancel Spawn Car",
    function(v)
        _G.stop_carspawn = true
    end,
    {
        animated = true
    }
)
local othr = w3:CreateSection("Firework Spammer")
othr:Create(
    "Button",
    "Firework Spammer",
    function(v)
        local plr = game:GetService'Players'.LocalPlayer
        local m = plr:GetMouse()
        local part = nil
        local connected_car = m.Button1Up:connect(function()
            part = getMouseTarget()
        end)
        notify("Firework Spammer", "Left Click the spawn button of a firework launcher to spam fireworks!")
        repeat wait() until part
        connected_car:Disconnect()
        connected_car = nil
        if part.Name == "Button" then
            local lnc = part.Parent
            if lnc.Owner.Value ~= plr then
                return
            end
            local rmt = lnc.ButtonRemote_Button
            _G.stop_firespam = false
            repeat
                game:GetService("ReplicatedStorage").Interaction.RemoteProxy:FireServer(rmt)
                game:GetService'RunService'.Stepped:wait()
            until _G.stop_firespam
        end
    end,
    {
        animated = true
    }
)
othr:Create(
    "Button",
    "Stop Firework Spammer",
    function(v)
        _G.stop_firespam = true
    end,
    {
        animated = true
    }
)
local w4 = main:CreateCategory("Items")
local logs = w4:CreateSection("Logs")

function getLogs()
    local logList={};
    for _,log in next,workspace.LogModels:children()do 
        if log:FindFirstChild("Owner")and log.Owner.Value==game.Players.LocalPlayer and not table.find(logList,log)then 
            table.insert(logList,log)
        end;
    end;
    return logList;
end;

function tpLogsToPlayer()
    local logFolder=getLogs();
    local oldPos=game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame;
    for _,log in next,logFolder do 
        if log:FindFirstChild("WoodSection")then 
            if (game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.p-log.WoodSection.CFrame.p).magnitude>40 then
                AncestorTeleport(CFrame.new(log.WoodSection.CFrame.p+Vector3.new(2,0,2)));
            end;
            spawn(function()
                for i=1,20 do
                    -- game:GetService("ReplicatedStorage").Interaction.ClientRequestOwnership:FireServer(log);
                    game:GetService("ReplicatedStorage").Interaction.ClientIsDragging:FireServer(log);
                    game:GetService'RunService'.Stepped:wait();
                end;
            end)
            wait(0.18)
            if not log.PrimaryPart then
                log.PrimaryPart=log.WoodSection;
            end;
            log:SetPrimaryPartCFrame(CFrame.new(oldPos.p));
        end;
    end; 
    AncestorTeleport(oldPos);
end;

logs:Create(
    "Button",
    "Teleport Logs",
    function(v)
       tpLogsToPlayer();
    end,
    {
        animated = true
    }
)
logs:Create(
    "Button",
    "Sell Logs",
    function(v)
        local plr = game:GetService'Players'.LocalPlayer
        local ocf = plr.Character.HumanoidRootPart.Position
        for i,v in pairs (game.Workspace.LogModels:children()) do
            if v.Name:sub(1,6) == "Loose_" and v:FindFirstChild'Owner' then
                if v.Owner.Value == plr then
                    _G.DogixLT2TPC(v:FindFirstChildOfClass("Part").CFrame,gkey)
                    for i=1,50 do
                        wait()
                        for i1,v1 in pairs (v:children()) do
                            if v1:IsA("BasePart") then
                                v1.CFrame=CFrame.new(Vector3.new(315, -0.296, 85.791))*CFrame.Angles(math.rad(15),0,0)
                                game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(v1)
                                -- game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(v1)
                            end
                        end
                    end
                    _G.DogixLT2TPC(ocf,1+gkey)
                    wait(0.5)
                end
            end
        end
    end,
    {
        animated = true
    }
)
-- logs:Create(
--     "Button",
--     "Cut Log Joints",
--     function(v)
--         local plr = game:GetService'Players'.LocalPlayer
--         local plrc = plr.Character
--         local ocf = plr.Character.HumanoidRootPart.CFrame
--         local tree = nil
--         local cancelled = false
--         local connected_car = m.Button1Up:connect(function()
--             local part = getMouseTarget()
--             if part.Parent:FindFirstChild("Owner") then
--                 if part.Parent:FindFirstChild("Owner").Value ~= plr then
--                     cancelled = true
--                     notify("Cut Log Joints", "Cancelled.",2)
--                     return
--                 end
--             end
--             if part.Parent.Name:sub(1,6) == "Loose_" then
--                 notify("Cut Log Joints", "Selected tree.",2)
--                 tree = part.Parent
--             else
--                 notify("Cut Log Joints", "Cancelled.",2)
--                 cancelled = true
--             end
--         end)
--         notify("Cut Log Joints", "Please click a cut tree. Click elsewhere to cancel.",3)
--         repeat wait() until tree ~= nil or cancelled
--         connected_car:Disconnect()
--         connected_car = nil
--         if cancelled then return end
--         local Wood = tree.TreeClass.Value
--     end,
--     {
--         animated = true
--     }
-- )
local modding = w4:CreateSection("Mod Logs")
modding:Create(
    "Button",
    "Mod using Axe Method (recommended)",
    function(v)
        local plr = game:GetService'Players'.LocalPlayer
        local plrc = plr.Character
        local ocf = plr.Character.HumanoidRootPart.CFrame
        local tree = nil
        local mill = nil
        local cancelled = false
        local connected_car = m.Button1Up:connect(function()
            local part = getMouseTarget()
            if part.Parent:FindFirstChild("Owner") then
                if part.Parent:FindFirstChild("Owner").Value ~= plr then
                    cancelled = true
                    notify("Mod Logs", "Cancelled.",2)
                    return
                end
            end
            if part.Parent.Name:sub(1,6) == "Loose_" then
                notify("Mod Logs", "Selected tree.",2)
                tree = part.Parent
            elseif part.Parent.Name:sub(1,7) == "Sawmill" or part.Parent:FindFirstChild"ItemName" and part.Parent.ItemName.Value:sub(1,7) == "Sawmill" then
                notify("Mod Logs", "Selected sawmill.",2)
                mill = part.Parent
            elseif part.Parent.Parent.Name:sub(1,7) == "Sawmill" or part.Parent.Parent:FindFirstChild"ItemName" and part.Parent.Parent.ItemName.Value:sub(1,7) == "Sawmill" then
                notify("Mod Logs", "Selected sawmill.",2)
                mill = part.Parent.Parent
            else
                notify("Mod Logs", "Cancelled. (if you're trying to select a tree, make sure you own it and hold an axe or move farther)",2)
                cancelled = true
            end
        end)
        notify("Mod Logs", "Please click a cut tree and a placed sawmill. Click elsewhere to cancel.",3)
        repeat wait() until (tree ~= nil and mill~= nil) or cancelled
        connected_car:Disconnect()
        connected_car = nil
        if cancelled then return end
        local Wood = tree.TreeClass.Value
        if not plrc:FindFirstChild'Tool' then
            if not plr.Backpack:FindFirstChild'Tool' then
                notify("Mod Logs","You need an axe to use this feature!",3)
                return
            end
        end
	    local tool = getBestAxe()
        local swing_delay = get_axe_swingdelay(tool)
        function axe(v)
            local hps = get_axe_damage(tool, Wood)
            local table =  {
                ["tool"] = tool,
                ["faceVector"] = Vector3.new(0, 0, -1),
                ["height"] = 0.3,
                ["sectionId"] = 1,
                ["hitPoints"] = hps,
                ["cooldown"] = 0.1,
                ["cuttingClass"] = "Axe"
            }
            game:GetService("ReplicatedStorage").Interaction.RemoteProxy:FireServer(v.CutEvent, table)
            wait(swing_delay)
        end
        local small = nil
        local smallParent = nil
        for i1,v1 in pairs (tree:children()) do
            if v1:IsA"BasePart" then
                if not v1:FindFirstChildOfClass("Weld") then
                    if v1.ID.Value ~= 1 then
                        if v1:FindFirstChild("ParentID") then
                            if v1.ParentID.Value ~= 1 then
                                if small == nil then small = v1 end
                                if v1.Size.Z < small.Size.Z then
                                    small = v1
                                end
                            end
                        end
                    end
                end
            end
        end
        for i1,v1 in pairs (tree:children()) do
            if v1:IsA"BasePart" then
                if v1.ID.Value == small.ParentID.Value then
                    smallParent = v1
                    break
                end
            end
        end
        local a = Instance.new("BoxHandleAdornment", small)
		a.Name = "Selection"
		a.Adornee = a.Parent
		a.AlwaysOnTop = true
		a.ZIndex = 0
		a.Size = a.Parent.Size
		a.Transparency = 0
		a.Color = BrickColor.new("Lime green")
        local a = Instance.new("BoxHandleAdornment", smallParent)
		a.Name = "Selection"
		a.Adornee = a.Parent
		a.AlwaysOnTop = true
		a.ZIndex = 0
		a.Size = a.Parent.Size
		a.Transparency = 0
		a.Color = BrickColor.new("Really red")
		local needrevert = false
        notify("Mod Logs", "Glitching tree, this should take a few seconds.",2)
        local lava = game.Workspace["Region_Volcano"]:FindFirstChild("Lava") or game.Lighting:FindFirstChild("Lava")
        if lava.Parent == game.Lighting then
            needrevert = true
            lava.Parent = game.Workspace["Region_Volcano"]
        end
        lava = lava.Lava
        local lcf = lava.CFrame
        local lsize = lava.Size
        repeat
	        wait()
	        lava.CFrame = smallParent.CFrame
	        game.Workspace["Region_Volcano"].Lava.Lava.Size = Vector3.new(0,0,0)
	        game:GetService"ReplicatedStorage".Interaction.ClientIsDragging:FireServer(tree)
	    until smallParent:FindFirstChildOfClass("Fire")
	    smallParent:FindFirstChildOfClass("Fire"):Destroy()
	    local diditsell = false
	    smallParent.AncestryChanged:Connect(function()
	        diditsell = true
	    end)
	    repeat
    	    for i=1,7 do
    	        wait()
    	        smallParent.CFrame = CFrame.new(315,-2,86)
    	        game:GetService"ReplicatedStorage".Interaction.ClientIsDragging:FireServer(tree)
    	        -- game:GetService"ReplicatedStorage".Interaction.ClientRequestOwnership:FireServer(tree)
    	    end
	    until diditsell
	    lava.CFrame = lcf
	    lava.Size = lsize
	    if needrevert then
	        lava.Parent.Parent = game.Lighting
	        needrevert = false
	    end
	    diditsell = false
        notify("Mod Logs", "Updating parts for sawmill to work.",3)
        local finished_t = false
        local added = game.Workspace.LogModels.ChildAdded:Connect(function(v)
            v:WaitForChild("Owner")
            if v:FindFirstChild("Owner") and v.Owner.Value == plr and v.TreeClass.Value == Wood then
                finished_t = true
            end
        end)
        _G.DogixLT2TPC(tree.WoodSection.CFrame + Vector3.new(4,2,2),gkey)
        repeat
            wait(0.1)
            if tree:FindFirstChild("CutEvent") ~= nil then
                axe(tree)
                wait()
            end
            small.CFrame = mill.Particles.CFrame
            --small.Parent.PrimaryPart = small
            --small.Parent:SetPrimaryPartCFrame(mill.Particles.CFrame)
            game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(small.Parent)
        until finished_t
        added:Disconnect()
        added = nil
        finished_t = false
        notify("Mod Logs", "Finished.",3)
    end,
    {
        animated = true
    }
)
modding:Create(
    "Button",
    "Mod using Sell Method (old)",
    function(v)
    local plr = game:GetService'Players'.LocalPlayer
    local ocf = plr.Character.HumanoidRootPart.Position
    for i,v in pairs (game.Workspace.LogModels:children()) do
        if v.Name:sub(1,6) == "Loose_" and v:FindFirstChild'Owner' then
            if v.Owner.Value == plr then
                for i=1,20 do
                    wait()
                    for i1,v1 in pairs (v:children()) do
                        if v1:IsA("BasePart") then
                            _G.DogixLT2TPC(v1.CFrame,gkey)
                            v1.CFrame=CFrame.new(Vector3.new(315, -0.296, 85.791))*CFrame.Angles(math.rad(15),0,0)
                            game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(v1)
                            -- game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(v1)
                        end
                    end
                end
                wait(0.5)
                local plrc = plr.Character
                local ocf = CFrame.new(ocf)
                for i=1,25 do
                    game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(v)
                    v:MoveTo(ocf.p)
                    wait()
                end
                _G.DogixLT2TPC(ocf,1+gkey)
            end
        end
    end
    end,
    {
        animated = true
    }
)
function doesTreeExist(Wood)
    if Wood == nil then return true end
    for ia,va in pairs(game.Workspace:GetChildren()) do
        if va.Name == "TreeRegion" then
            for i,v in pairs (va:GetChildren()) do
                if v:FindFirstChild("TreeClass") and v.TreeClass.Value == Wood and v.Name == "Model" then
                    local count = 0
                    for i1,v1 in pairs (v:children()) do
                        if v1.Name == "WoodSection" then
                            if v1.Size.Y > 0.5 then
                                count = count + 1
                            end
                        end
                    end
                    if count >= 1 then
                        return true
                    end
                end
            end
        end
    end
    return false
end

function getBestAxe(Tree)
    local toolName;
    local axes={};
    local bestAxe;
    local dmg=0;
    local damage;
    for _,v in pairs(game.Players.LocalPlayer.Backpack:children())do
        table.insert(axes,v);
    end;
    for _,v in pairs(game.Players.LocalPlayer.Character:children())do
        if v:IsA"Tool"then 
            table.insert(axes,v);
        end;
    end
    for _,v in next,axes do
        if v:FindFirstChild"ToolName"and game:GetService("ReplicatedStorage").Purchasables.Tools.AllTools:FindFirstChild(tostring(v.ToolName.Value))then 
            --stats=require(game:GetService("ReplicatedStorage").Purchasables.Tools.AllTools:FindFirstChild(tostring(v.ToolName.Value)).AxeClass).new()
            stats = require(game.ReplicatedStorage.AxeClasses['AxeClass_'..tostring(v.ToolName.Value)]).new()
            if stats.SpecialTrees then 
                if stats.SpecialTrees[Tree]then 
                    damage=stats.SpecialTrees[Tree].Damage
                    bestAxe=v
                    return bestAxe;
                end;
            end;
            damage=stats.Damage		
            if damage>dmg then 
                dmg=damage;
            end;
            bestAxe=v;
        end;
    end;
    return bestAxe;
end;

function findSelectedTree(treeClass)
    for _,v in next,workspace:children()do
        if tostring(v)=="TreeRegion"then
            for _,g in next,v:children()do
                if g:FindFirstChild("TreeClass")and tostring(g.TreeClass.Value)==treeClass and g:FindFirstChild("Owner")then 
                    if g.Owner.Value==nil or tostring(g.Owner.Value)==tostring(game.Players.LocalPlayer)then 
                        if #g:children() > 5 and g:FindFirstChild("WoodSection")then 
                            for h,j in next,g:children() do 
                                if j:FindFirstChild("ID")and j.ID.Value==1 and j.Size.Y>.5 then 
                                    return j;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
    return false;
end; 
function GetHitPoint(Tree,Axe)
    --local axeFolder=game:GetService("ReplicatedStorage").Purchasables.Tools.AllTools[Axe];
    local axeModule = require(game.ReplicatedStorage.AxeClasses['AxeClass_'..Axe]).new()
    --local axeModule=require(axeFolder.AxeClass).new();
    local hitPoint=axeModule.Damage;
    if axeModule.SpecialTrees then 
        if axeModule.SpecialTrees[Tree]then 
            hitPoint=axeModule.SpecialTrees[Tree].Damage
        end
    end				
    return hitPoint;
end;
function chopTree(Tree,cutEvent)
    game:GetService("ReplicatedStorage").Interaction.RemoteProxy:FireServer(cutEvent,{["tool"]=getBestAxe(Tree),["faceVector"]=Vector3.new(1,0,0),["height"]=.32,["sectionId"]=1,["hitPoints"]=GetHitPoint(Tree,getBestAxe(Tree).ToolName.Value),["cooldown"]=-14,["cuttingClass"]="Axe"})
end;
local isLoopBringTreeEnabled=false;

function bringTree(Tree,Quantity)
    local requirements={connections={},LP=game.Players.LocalPlayer,Booleans={treeIsCut=false}}
    if not findSelectedTree(tostring(Tree))then 
        notify("Error","No Tree Found",4);
        return;
    end;
    if not getBestAxe(Tree)then 
        notify("Error","You Need An Axe!",4);
        return;
    end;
    if Tree=="LoneCave"then
        if getBestAxe(Tree).ToolName.Value~="EndTimesAxe"then
            if requirements.connections.bringTree then 
                requirements.connections.bringTree:Disconnect();
                requirements.connections.bringTree=nil;
            end;
            --go unnoclip
            if requirements.connections.chopTree then 
                requirements.connections.chopTree:Disconnect();
                requirements.connections.chopTree=nil;
            end;
            notify("Notify","You need an EndTimesAxe! Aborting...",4);
            return;
        end;
    end;
    local oldPos=requirements.LP.Character.HumanoidRootPart.CFrame;
    for i=1,Quantity do
        if i==1 then 
            isLoopBringTreeEnabled=true;
        end;
        if not isLoopBringTreeEnabled then
            if requirements.connections.bringTree then 
                requirements.connections.bringTree:Disconnect();
                requirements.connections.bringTree=nil;
            end;
            if requirements.connections.chopTree then 
                requirements.connections.chopTree:Disconnect();
                requirements.connections.chopTree=nil;
            end;
            AncestorTeleport(CFrame.new(oldPos.p));
            notify("Notify","Bring Tree Aborted",4);
            return;
        end;
        local treeToCut=findSelectedTree(Tree);
        if not treeToCut then 
            if requirements.connections.bringTree then 
                requirements.connections.bringTree:Disconnect();
                requirements.connections.bringTree=nil;
            end;
            if requirements.connections.chopTree then 
                requirements.connections.chopTree:Disconnect();
                requirements.connections.chopTree=nil;
            end;
            AncestorTeleport(CFrame.new(oldPos.p));
            notify("Error","No Tree Found!",4);
            return;
        end;
        local noclip = game:GetService('RunService').Stepped:connect(nocliprun)
        AncestorTeleport(CFrame.new(treeToCut.CFrame.p+Vector3.new(2,3,2)));
        if Tree=="LoneCave"then 
            local connection,connection2,connection3;
            connection=workspace.PlayerModels.ChildAdded:Connect(function(b)
            local Owner,ToolName=b:WaitForChild("Owner"),b:WaitForChild("ToolName")
            if tostring(Owner.Value)==tostring(requirements.LP)and tostring(ToolName.Value)=="EndTimesAxe"then 
                    axe=b;
                end;
            end);
            connection3=requirements.LP.CharacterAdded:Connect(function()
                repeat wait()until requirements.LP.Character and requirements.LP.Character:FindFirstChild("Humanoid");
                game:GetService("RunService").Heartbeat:wait();
                _G.DogixLT2TPC(CFrame.new(treeToCut.CFrame.p+Vector3.new(2,0,2)), gkey)
                game.ReplicatedStorage.Interaction.ClientInteracted:FireServer(axe,"Pick up tool");
            end)
            connection2=requirements.LP.Character.Humanoid.Died:Connect(function()
                for _,tool in next,requirements.LP.Backpack:children()do 
                    pcall(function()
                        game.ReplicatedStorage.Interaction.ClientInteracted:FireServer(tool,"Drop tool");
                    end);
                end;
            end);
        end;
        requirements.connections.bringTree=workspace.LogModels.ChildAdded:Connect(function(tree)
            tree:WaitForChild("Owner",5);
            if tree.Owner.Value==requirements.LP and tree.TreeClass.Value==tostring(Tree) then
                for i=1,10 do 
                    -- game:GetService("ReplicatedStorage").Interaction.ClientRequestOwnership:FireServer(tree);
                    game:GetService("ReplicatedStorage").Interaction.ClientIsDragging:FireServer(tree);
                    game:GetService("RunService").Heartbeat:wait();
                end;
                if not tree.PrimaryPart then 
                    tree.PrimaryPart=tree:FindFirstChild"WoodSection"
                end;
                tree:SetPrimaryPartCFrame(CFrame.new(oldPos.p));
                requirements.Booleans.treeIsCut=true;
            end;
        end);
        repeat wait()if getBestAxe(Tree)and treeToCut and requirements.LP.Character and requirements.LP.Character:FindFirstChild"Humanoid"then chopTree(Tree,treeToCut.Parent.CutEvent)end;until requirements.Booleans.treeIsCut;
        game:GetService("RunService").Heartbeat:wait();
        requirements.Booleans.treeIsCut=false;
        if requirements.connections.bringTree then 
            requirements.connections.bringTree:Disconnect();
            requirements.connections.bringTree=nil;
        end;
        if connection then 
            connection:Disconnect();
            connection=nil;
        end;
        if connection2 then 
            connection2:Disconnect();
            connection2=nil;
        end;
        if connection3 then 
            connection3:Disconnect();
            connection3=nil;
        end;
        if connection4 then 
            connection4:Disconnect();
            connection4=nil;
        end;
        if noclip then 
            noclip:Disconnect()
            noclip=nil
        end
    end;
    game.Players.LocalPlayer.Character.Humanoid:ChangeState(7)
    AncestorTeleport(CFrame.new(oldPos.p+Vector3.new(4,0,0)));
    notify("Notify","Done",4);
    isLoopBringTreeEnabled=false;
    --go unnoclip
    game.Players.LocalPlayer.Character.Humanoid:ChangeState(7)
end;

local gettree = w4:CreateSection("Get Tree")
local current_tree = "Cherry"
local useeyeless = false
local gettree_dropdown = gettree:Create(
    "Dropdown",
    "Get Tree",
    function(current)
        current_tree = TreeConversionTable[current] or current
        if current_tree == "End Times (Eyeless)" then
            current_tree = "LoneCave"
            useeyeless = true
        elseif current_tree == "End Times (Eye)" then
            useeyeless = false
            current_tree = "LoneCave"
        end
    end,
    {
        options = {"Select a Tree"},
        search = true;
    }
)
function update_gettree(tree_list)
    if table.find(tree_list, "LoneCave") then
        tree_list[table.find(tree_list, "LoneCave")] = "End Times (Eyeless)"
        table.insert(tree_list, "End Times (Eye)")
    end
    gettree_dropdown:SetDropDownList({options = nicify_tree_list(tree_list)})
end
tree_list_event.Event:Connect(function(tree_list)
    update_gettree(tree_list)
end)
update_gettree(get_tree_list())

local current_tree_quantity = 1
gettree:Create(
    "Slider",
    "Tree Quantity",
    function(v)
        current_tree_quantity = v
    end,
    {
        min = 1,
        max = 20,
        default = 1,
        changablevalue = true
    }
)
gettree:Create(
    "Button",
    "Get Tree",
    function(v)
        bringTree(current_tree,current_tree_quantity);
    end,
    {
        animated = true
    }
)
local looping_tree = false
gettree:Create(
    "Toggle",
    "Loop Get Tree",
    function(state)
        isLoopBringTreeEnabled = state
        if isLoopBringTreeEnabled then 
            bringTree(current_tree,900);
        end;
    end,
    {
        default = false
    }
)
logs:Create(
    "Button",
    "Get Log Ownership Claim Tool",
    function()
        local plr = game:GetService("Players").LocalPlayer
        local tool = Instance.new("Tool",plr.Backpack)
        tool.RequiresHandle = false
        tool.Name = "Tree Claim"
        tool.Activated:Connect(function()
            local str = getMouseTarget().Parent
            if str:IsA("Model") and str.Parent.Name == "TreeRegion" then
                game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(str)
                spawn(function()
                    while wait(10) do
                        game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(str)
                        -- game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(str)
                        -- game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(str:FindFirstChildOfClass("Part"))
                    end
                end)
                notify("Tree Claim", "Now claiming "..str.TreeClass.Value.." tree ownership.",3)
            end
        end)
    end,
    {
        animated = true,
    }
)
logs:Create(
    "Button",
    "Get Log Size Checker Tool",
    function()
        local plr = game:GetService("Players").LocalPlayer
        local tool = Instance.new("Tool",plr.Backpack)
        tool.RequiresHandle = false
        tool.Name = "Size Check"
        tool.Activated:Connect(function()
            local str = getMouseTarget().Parent
            if str:IsA("Model") and str:FindFirstChild("WoodSection") then
                local size = 0
                for i,v in next, str:GetChildren() do
                    if v.Name == "WoodSection" then
                        size = size + v.Size.Y/(1/(v.Size.X*v.Size.Z))
                    end
                end
                notify("Tree Size", str.TreeClass.Value.."'s size is "..size,3)
            end
        end)
    end,
    {
        animated = true,
    }
)
logs:Create(
    "Button",
    "Auto Sawmill",
    function()
    	SawmillType = "Sawmill4L"
    	local plr = game.Players.LocalPlayer
    	for i, v in pairs(game.Workspace.LogModels:GetDescendants()) do
    		if v:FindFirstChild("TreeClass") and v:FindFirstChild("Owner") and v.Owner.Value == plr then
    			Wood = v.WoodSection
    			for i, v in pairs(game.Workspace.PlayerModels:GetDescendants()) do
    				if v:FindFirstChild("Owner")  and v.Owner.Value == plr and v:FindFirstChild("ItemName")  and v.ItemName.Value == SawmillType then
    					Sawmill = v.Conveyor.Conveyor
    					if v.XDown.Orientation == Vector3.new(90, 180, 0) then
    						game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(v)
    						Wood.CFrame = CFrame.new(Sawmill.Position.X, Sawmill.Position.Y + 1, Sawmill.Position.Z)
    						Wood.Orientation = Vector3.new(0, 180, 90)
    						wait()
    					elseif  v.XDown.Orientation == Vector3.new(90, -90, 0) then
    						game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(v)
    						Wood.CFrame = CFrame.new(Sawmill.Position.X, Sawmill.Position.Y + 1, Sawmill.Position.Z)
    						Wood.Orientation = Vector3.new(-89.95, 28.43, -27.61)
    						wait()
    					elseif  v.XDown.Orientation == Vector3.new(90, 0, 0) then
    						game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(v)
    						Wood.CFrame = CFrame.new(Sawmill.Position.X, Sawmill.Position.Y + 1, Sawmill.Position.Z)
    						Wood.Orientation = Vector3.new(-90, -89.83, 0)
    						wait()
    					elseif  v.XDown.Orientation == Vector3.new(90, 0, 0) then
    						game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(v)
    						Wood.CFrame = CFrame.new(Sawmill.Position.X, Sawmill.Position.Y + 1, Sawmill.Position.Z)
    						Wood.Orientation = Vector3.new(-90, -89.83, 0)
    						wait()
    					elseif  v.XDown.Orientation == Vector3.new(90, 90, 0) then
    						game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(v)
    						Wood.CFrame = CFrame.new(Sawmill.Position.X, Sawmill.Position.Y + 1, Sawmill.Position.Z)
    						Wood.Orientation = Vector3.new(-1.46, 91.71, 89.83)
    						wait()
    					end
    				end
    			end
    		end
    	end
    end,
    {
    	animated = true
    }
)
local currentBox = "BagOfCandy2"
local includePink = false
local candies = w4:CreateSection("Candies")
candies:Create(
    "Dropdown",
    "Select Candies",
    function(current)
        currentBox = current
    end,
    {
        options = {
            "BagOfCandy3";
            "BagOfCandy2";
            "BagOfCandy";
        },
        search = true;
    }
)
candies:Create(
    "Button",
    "Open All Candies",
    function(v)
        local ca = game.Workspace.PlayerModels.ChildAdded:connect(function(v)
            if v:WaitForChild"Owner".Value == game.Players.LocalPlayer and v:WaitForChild"ItemName".Value == currentBox then
                game:GetService("ReplicatedStorage").Interaction.RemoteProxy:FireServer(v:WaitForChild"ButtonRemote_Main")
            end
        end)
        for i,v in next, game.Workspace.PlayerModels:GetChildren() do
            if (v.Name == currentBox or v.Name == currentBox.." Purchased by "..game.Players.LocalPlayer.Name)and v:FindFirstChild"PurchasedBoxItemName" then
                game:GetService("ReplicatedStorage").Interaction.ClientInteracted:FireServer(v, "Open box")
            end
        end
        wait(10)
        ca:Disconnect()
        ca = nil
    end,
    {
        animated = true
    }
)
candies:Create(
    "Toggle",
    "Include Pink Candies",
    function(current)
        includePink = current
    end,
    {
        default = false;
    }
)
candies:Create(
    "Button",
    "Eat All Candies",
    function(v)
        for _, v in pairs(game.Workspace.PlayerModels:GetChildren()) do
            if v:FindFirstChild("Owner") then
                if v.Owner.Value == game.Players.LocalPlayer then
                    if v:findFirstChild("ItemName") then
                        if v.ItemName.Value == "Candy" then
                            if v:findFirstChild("Main") then
                                if v.Main.BrickColor == BrickColor.new("Hot pink") and not includePink then
                                else
                                    if v:FindFirstChild("ButtonRemote_Main") then
                                        game:GetService("ReplicatedStorage").Interaction.RemoteProxy:FireServer(v.ButtonRemote_Main)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end,
    {
        animated = true
    }
)
candies:Create(
    "Button",
    "Highlight Pink Candies",
    function(v)
        local count = 0
        for _, v in pairs(game.Workspace.PlayerModels:GetChildren()) do
            if v:FindFirstChild("Owner") then
                if v.Owner.Value == game.Players.LocalPlayer then
                    if v:findFirstChild("ItemName") then
                        if v.ItemName.Value == "Candy" then
                            if v:findFirstChild("Main") then
                                if v.Main.BrickColor == BrickColor.new("Hot pink") then
                                    esp_part(v.Main)
                                    count = count + 1
                                end
                            end
                        end
                    end
                end
            end
        end
        notify("Pink Candies", "Detected "..count.." pink candies.")
    end,
    {
        animated = true
    }
)
local axes = w4:CreateSection'Axes'
-- axes:Create(
--     "Button",
--     "Teleport Axes",
--     function(v)
--         local cfz = game:GetService'Players'.LocalPlayer.Character.HumanoidRootPart.CFrame
--         for i,v in pairs (game.Workspace.PlayerModels:children()) do
--             if v:FindFirstChild("Owner") and (v:FindFirstChild("Type") and tostring(v.Type.Value) == "Tool") or (v:FindFirstChild'ToolName') then
--                 if v.Owner.Value == game:GetService'Players'.LocalPlayer or nil then
--                     _G.DogixLT2Drag(v.Main, cfz)
--                 end
--             end
--         end
--     end,
--     {
--         animated = true
--     }
-- )
axes:Create(
    "Toggle",
    "Auto-Chop",
    function(state)
        getgenv().autochoppe = state
    end,
    {
        default = false
    }
)
axes:Create(
    "Button",
    "Increased Axe Range",
    function(state)
        --[[
        local superaxe = require(game:GetService("ReplicatedStorage").Purchasables.Tools.AxeSuperClass)
        for i,v in pairs (game:GetService("ReplicatedStorage").Purchasables.Tools.AllTools:GetChildren()) do
            local old = require(v.AxeClass).new()
            require(v.AxeClass).new = function(...)
                local axe = superaxe.new(...)
                for i,v in pairs (old) do
                    axe[i] = v
                end
                axe.Range = 32
                return
            end
        end
        for i,tool in pairs (getAxeList()) do
            game:GetService("ReplicatedStorage").Interaction.ClientInteracted:FireServer(tool, "Drop tool", game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
        end
        notify("Axe Range", "Please pick up your axes for changes to take effect.",3)
        ]]
        local superaxe = require(game:GetService("ReplicatedStorage").AxeClasses.AxeSuperClass)
        for i,v in pairs(game:GetService("ReplicatedStorage").AxeClasses:GetChildren()) do
            if v.Name ~= "AxeSuperClass" then
                local old = require(v).new()
                require(v).new = function(...)
                    local axe = superaxe.new(...)
                    for i,v in pairs (old) do
                        axe[i] = v
                    end
                    axe.Range = 32
                    return
                end
            end
        end
        for i,tool in pairs (getAxeList()) do
            game:GetService("ReplicatedStorage").Interaction.ClientInteracted:FireServer(tool, "Drop tool", game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
        end
        notify("Axe Range", "Please pick up your axes for changes to take effect.",3)

    end,
    {
        animated = true
    }
)
local axedupeloop = 1
axes:Create(
    "Slider",
    "Repeat Axe Dupe (also patched)",
    function(v)
        axedupeloop = v
    end,
    {
        min = 1, max = 5, default = 1
    }
)
axes:Create(
    "Button",
    "Dupe Axes (patched)",
    function(v)
        for i=1,axedupeloop do
            normalinvdupe()
        end
    end,
    {
        animated = true
    }
)
axes:Create(
    "Button",
    "Drop Axes",
    function(v)
        local plr = game:GetService'Players'.LocalPlayer
        if plr.Character:FindFirstChild("Tool") ~= nil then
            plr.Character.Humanoid:UnequipTools()
        end
        for i,tool in pairs (plr.Backpack:children()) do
            game:GetService("ReplicatedStorage").Interaction.ClientInteracted:FireServer(tool, "Drop tool", plr.Character.HumanoidRootPart.CFrame)
        end
    end,
    {
        animated = true
    }
)
axes:Create(
    "Button",
    "Count Axes",
    function(v)
        local plr = game:GetService'Players'.LocalPlayer
        local i = 0
        if plr.Character:FindFirstChild'Tool' ~= nil then
            if plr.Character:FindFirstChild'Tool':findFirstChild'AxeClient' then
                i=i+1
            end
        end
        for _,tool in pairs (plr.Backpack:children()) do
            if tool:findFirstChild'AxeClient' then
                i=i+1
            end
        end
        notify("Axe Counter", "You have "..i.." axes in your inventory.",3)
    end,
    {
        animated = true
    }
)
axes:Create(
    "Button",
    "Far Axe Equip",
    function(v)
        local plr = game:GetService'Players'.LocalPlayer
        local plrc = plr.Character
        local m = plr:GetMouse()
        connecteda = m.Button1Up:connect(function()
            if connecteda ~= nil then
                connecteda:Disconnect()
                connecteda = nil
            end
            local part = getMouseTarget()
            if part.Name == "Main" and part.Parent:FindFirstChild("ToolName") then
                game:GetService("ReplicatedStorage").Interaction.ClientInteracted:FireServer(part.Parent, "Pick up tool")
            end
        end)
        notify("Far Axe Equip", "Left click the axe that you want to equip.")
    end,
    {
        animated = true
    }
)
local planks = w4:CreateSection("Planks")
-- planks:Create(
--     "Button",
--     "Teleport Planks",
--     function(v)
--         local cfz = game:GetService'Players'.LocalPlayer.Character.HumanoidRootPart.CFrame
--         for i,v in pairs (game.Workspace.PlayerModels:children()) do
--             if v.Name == "Plank" and v:FindFirstChild("TreeClass") and v.Owner ~= nil and v:FindFirstChild("ItemName") == nil then
--                 if v.Owner.Value == game:GetService'Players'.LocalPlayer then
--                     _G.DogixLT2Drag(v.WoodSection, cfz,false,2)
--                 end
--             end
--         end
--     end,
--     {
--         animated = true
--     }
-- )
planks:Create(
    "Button",
    "Sell Planks",
    function(v)
        local cfz = CFrame.new(314,2,90)
        for i,v in pairs (game.Workspace.PlayerModels:children()) do
            if v.Name == "Plank" and v:FindFirstChild("TreeClass") and v.Owner ~= nil and v:FindFirstChild("ItemName") == nil then
                if v.Owner.Value == game:GetService'Players'.LocalPlayer then
                    _G.DogixLT2Drag(v.WoodSection, cfz,false,2)
                end
            end
        end
    end,
    {
        animated = true
    }
)
planks:Create(
    "Button",
    "Sell Specific Plank",
    function(v)
        local cfz = CFrame.new(314,2,85)
        local plr = game:GetService'Players'.LocalPlayer
        local plrc = plr.Character
        local m = plr:GetMouse()
        connecteda = m.Button1Up:connect(function()
            if connecteda ~= nil then
                connecteda:Disconnect()
                connecteda = nil
            end
            local part = getMouseTarget()
            if part.Name == "WoodSection" then
                _G.DogixLT2Drag(part, cfz,true)
            end
        end)
        notify("Plank Seller", "Left click the plank that you want sell.")
    end,
    {
        animated = true
    }
)
planks:Create(
    "Button",
    "Plank to Blueprint Tool",
    function()
        local plr = game:GetService("Players").LocalPlayer
        local tool = Instance.new("Tool",plr.Backpack)
        tool.RequiresHandle = false
        tool.Name = "Plank-BP"
        tool.Activated:Connect(function()
            local str = getMouseTarget().Parent
    		if str:FindFirstChild("Type") and str.Type.Value == "Blueprint" and str:FindFirstChild("Owner") and str.Owner.Value == game:GetService'Players'.LocalPlayer then
        		bp = str
        		local a = Instance.new("BoxHandleAdornment", bp.BuildDependentWood)
        		a.Name = "Selection"
        		a.Adornee = a.Parent
        		a.AlwaysOnTop = true
        		a.ZIndex = 0
        		a.Size = a.Parent.Size
        		a.Transparency = 0.3
        		a.Color = BrickColor.new("Electric blue")
    		elseif str.Name == "Plank" and str:FindFirstChild("WoodSection") and str:FindFirstChild("Owner") and str.Owner.Value == game:GetService'Players'.LocalPlayer then
    		    plank = str
        		local a = Instance.new("BoxHandleAdornment", plank.WoodSection)
        		a.Name = "Selection"
        		a.Adornee = a.Parent
        		a.AlwaysOnTop = true
        		a.ZIndex = 0
        		a.Size = a.Parent.Size
        		a.Transparency = 0.3
        		a.Color = BrickColor.new("Lime green")
    		end
    		if plank and bp then
    			local ocf = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    			local cf_ = nil
                if bp:FindFirstChild("MainCFrame") then
                cf_ = bp.MainCFrame.Value
                else
                cf_ = bp.Main.CFrame
                end
                plank.WoodSection.Selection:Destroy()
                bp.BuildDependentWood.Selection:Destroy()
    			_G.DogixLT2Drag(plank.WoodSection, cf_)
                bp = nil
                plank = nil
                wait(0.3)
    			_G.DogixLT2TPC(ocf,gkey)
    		end
        end)
    end,
    {
        animated = true
    }
)
planks:Create(
    "Button",
    "Delete Plank (unwhitelisted) Tool",
    function()
        local plr = game:GetService("Players").LocalPlayer
        local tool = Instance.new("Tool",plr.Backpack)
        tool.RequiresHandle = false
        tool.Name = "Delete Plank"
        tool.Activated:Connect(function()
            local plr = game:GetService'Players'.LocalPlayer
    	    local part = getMouseTarget()
    	    if not part.Anchored and part.Parent.Name ~= plr.Name then
    			local f = Instance.new("BodyPosition", part)
    			f.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    			f.Position = Vector3.new(0,9e9,0)
            end
        end)
    end,
    {
        animated = true
    }
)
if firetouchinterest then
    planks:Create(
        "Button",
        "Burn Plank (unwhitelisted) Tool",
        function()
            local plr = game:GetService("Players").LocalPlayer
            local tool = Instance.new("Tool",plr.Backpack)
            local needrevert = false
            tool.RequiresHandle = false
            tool.Name = "Burn Plank"
            tool.Activated:Connect(function()
        	    local part = getMouseTarget()
        	    if part.Anchored or part.Name ~= "WoodSection" then return end
                local lava = game.Workspace["Region_Volcano"]:FindFirstChild("Lava") or game.Lighting:FindFirstChild("Lava")
                if lava.Parent == game.Lighting then
                    needrevert = true
                    lava.Parent = game.Workspace["Region_Volcano"]
                end
                lava = lava.Lava
                firetouchinterest(part,lava,0)
                firetouchinterest(part,lava,1)
                if needrevert then
                    lava.Parent.Parent = game.Lighting
                    needrevert = false
                end
            end)
        end,
        {
            animated = true
        }
    )
end
planks:Create(
    "Button",
    "Stand Up Plank Tool (beta)",
    function(state)
        local plr = game:GetService("Players").LocalPlayer
        local tool = Instance.new("Tool",plr.Backpack)
        tool.RequiresHandle = false
        tool.Name = "Stand Plank"
        tool.Activated:Connect(function()
            local plank = getMouseTarget()
            if plank.Name == "WoodSection" and canUse(plank.Parent.Owner.Value) then
                plank.CFrame = CFrame.new(plank.CFrame.p) + Vector3.new(0,plank.Size.Y/2,0)
                game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(plank.Parent)
            end
        end)
    end,
    {
        animated = true,
    }
)
function plankData(plank)
    local array = {}
    array[1] = plank
    array[2] = 1/(plank.Size.X*plank.Size.Z)
    if array[2] < 0.2 then array[2] = 0.3 end
    array[3] = math.floor(plank.Size.Y/array[2])
    if array[3] < 1 then array[3] = 0 end
    array[4] = plank.Size.Y
    return array
end
local connecteda = nil
planks:Create(
    "Button",
    "Cut Plank into 1 Unit",
    function(v)
        local plr = game:GetService'Players'.LocalPlayer
        local plrc = plr.Character
        local m = plr:GetMouse()
        local part = nil
        local cancel1u = false
        connecteda = m.Button1Up:connect(function()
            local partt = getMouseTarget()
            if partt.Name == "WoodSection" then
                part = partt
            else
                notify("1 Unit Cutter", "Cancelled.",2)
                cancel1u = true
            end
        end)
        notify("1 Unit Cutter", "Left click the plank that you want cut into 1 unit pieces.")
        repeat wait() until cancel1u or part ~= nil
        if connecteda ~= nil then
            connecteda:Disconnect()
            connecteda = nil
        end
        if cancel1u then
            cancel1u = false
            return
        end
        cancel1u = false
        notify("1 Unit Cutter", "Cutting...",2)
        local Wood = part.Parent.TreeClass.Value
        local tool = getBestAxe()
        function axe(v,x)
            local hps = get_axe_damage(tool, Wood)
            local table =  {
                ["tool"] = tool,
                ["faceVector"] = Vector3.new(1, 0, 0),
                ["height"] = x,
                ["sectionId"] = 1,
                ["hitPoints"] = hps,
                ["cooldown"] = 0.21,
                ["cuttingClass"] = "Axe"
            }
            game:GetService("ReplicatedStorage").Interaction.RemoteProxy:FireServer(v.CutEvent, table)
        end
        local ca = plankData(part)
        local caq = {}
        local remaining = ca[3]
        local ready = false
        if remaining == 0 then return end
        local repeating = game.Workspace.PlayerModels.ChildAdded:connect(function(new)
			if new:WaitForChild("Owner").Value == plr and new:FindFirstChild'WoodSection' and math.floor(plankData(new.WoodSection)[4]) == math.floor(ca[4]-ca[2]) then
				ready = true
				caq = plankData(new:FindFirstChild'WoodSection')
			end
        end)
        for i=1,ca[3] do
            ready = false
            repeat
                wait(0.21)
                axe(ca[1].Parent,ca[2])
            until ready or (i == ca[3] and wait(6))
            ca = caq
        end
    end,
    {
        animated = true
    }
)
local itms = w4:CreateSection("Items")
itms:Create(
    "Toggle",
    "Hard Dragger",
    function(state)
        if state then
            _G.HardDraggerConnection = game.Workspace.ChildAdded:connect(function(a)
                if a.Name == "Dragger" then
                    local bg = a:WaitForChild("BodyGyro")
                    local bp = a:WaitForChild("BodyPosition")
                    local backup = {
                        bp_p=bp.P,
                        bp_d=bp.D,
                        bp_maxforce=bp.maxForce,
                        bg_p=bg.P,
                        bg_d=bg.D,
                        bg_maxtorque=bg.maxTorque,
                        color_backup=a.BrickColor,
                    }
                    local last_tick = tick()
                    local color1 = BrickColor.new("Light yellow")
                    local color2 = BrickColor.new("Bright red")
                    a.BrickColor = color1
                    repeat
                        if (tick() - last_tick) >= 0.2 then
                            last_tick = tick()
                            print("swap")
                            if a.BrickColor ~= color1 then
                                a.BrickColor = color1
                            else
                                a.BrickColor = color2
                            end
                        end
                        wait()
                        bp.P = 120000
                        bp.D = 1000
                        bp.maxForce = Vector3.new(1,1,1)*1000000
                        bg.maxTorque = Vector3.new(1, 1, 1) * 200
                        bg.P = 1200
                        bg.D = 140
                    until a.Parent ~= game.Workspace
                    bp.maxForce = backup['bp_maxforce']
                    bp.D = backup['bp_d'];
                    bp.P = backup['bp_p']
                    bg.maxTorque = backup['bg_maxtorque']
                    bg.P = backup['bg_p'];
                    bg.D = backup['bg_d'];
                    a.BrickColor=backup['color_backup']
                end
            end)
            if not _G.OrigDrag then
                _G.OrigDrag = getsenv(game:GetService("Players").LocalPlayer.PlayerGui.ItemDraggingGUI.Dragger).canDrag
                getsenv(game:GetService("Players").LocalPlayer.PlayerGui.ItemDraggingGUI.Dragger).canDrag = function(item)
                    if _G.OrigDrag(item) == true then return true end
                    local plrc = game.Players.LocalPlayer.Character
                    if not plrc then return end
                    if plrc:FindFirstChildOfClass("Tool") then return end
                    if item then
                        if item.Parent then
                            if (0 <= plrc.Humanoid.Health) and item.Name == "LeafPart" then
                                return false;
                            else
                                local p = item
                                repeat
                                    p = p.Parent
                                until p.Parent.Name == "PlayerModels" or p.Parent == game.Workspace or p.Parent == game or p.Parent.Name == "LogModels"
                                if p.Parent.Name == "PlayerModels" or p.Parent.Name == "LogModels" then
                                    if not canUse(p.Owner.Value) then
                                        if p:FindFirstChild("WoodSection") then
                                            return true
                                        end
                                        return false
                                    else
                                        if p:FindFirstChild("Type") then
                                            if (p.Type.Value == "Structure" or p.Type.Value == "Wire" or p.Type.Value == "Vehicle Spot"or p.Type.Value == "Blueprint") and not p:FindFirstChild("PurchasedBoxItemName") and not p:FindFirstChild("BoxItemName") then
                                                return false
                                            end
                                        end
                                        return true
                                    end
                                end
                            end
                        end
                    end
                    return false
                end
            end
        else
            _G.HardDraggerConnection:Disconnect()
            _G.HardDraggerConnection = nil
            getsenv(game:GetService("Players").LocalPlayer.PlayerGui.ItemDraggingGUI.Dragger).canDrag =  _G.OrigDrag
            _G.OrigDrag = nil
        end
    end,
    {
        animated = true
    }
)
itms:Create(
    "Button",
    "Wire Mod",
    function(state)
        notify("Wire Mod", "There is a chance you will be banned for long wire. This is a warning.",3)
        if not confirm() then end
        local length = 40
        local a=game:GetService("RunService")local b=game.Players.LocalPlayer;local c=b.PlayerGui.WireDraggingGUI.WireDragger;c.Disabled=true;local d=b.Character or b.CharacterAdded:wait()local e=d;local f=d:WaitForChild("Humanoid")local g=game.Workspace.CurrentCamera;b.CharacterAdded:connect(function()e=b.Character;f=e:WaitForChild("Humanoid")g=game.Workspace.CurrentCamera end)local h=b:GetMouse()local i=require(game.ReplicatedStorage.Interaction.InteractionPermission)local j=nil;local k={}local l=require(game.ReplicatedStorage.Interaction.CanPlace)local m=c.Parent:WaitForChild("Finalize")local n=""local o=false;local p=game.Players.LocalPlayer.PlayerGui:WaitForChild("ClientSounds"):WaitForChild("PlaceStructure")c.Parent:WaitForChild("DragWire").OnInvoke=function(q)b.PlayerGui.IsPlacingStructure.Value=true;if j=="Placing"then exitPlacementMode()wait(0.1)end;k=l:GetPlayerLand(b)j="Placing"setPlatformControls()setGUIVisibility(true)local r={}local s=Instance.new("Model",game.Workspace.CurrentCamera)local t=nil;while j=="Placing"or j=="Add Point"or j=="Remove Point"do m.Visible=#r>=2;s:ClearAllChildren()local u=true;local v=0;local function w(x,y)local z=(x-y).magnitude;v=v+z;local A=Instance.new("Part",s)A.Shape=Enum.PartType.Cylinder;A.Anchored=true;A.CanCollide=false;A.CFrame=CFrame.new(x,y)*CFrame.new(0,0,-z/2)*CFrame.Angles(0,math.pi/2,0)A.Size=Vector3.new(z,q.OtherInfo.Thickness.Value,q.OtherInfo.Thickness.Value)A.Transparency=0.5;A.TopSurface=Enum.SurfaceType.Smooth;A.BottomSurface=Enum.SurfaceType.Smooth;A.BrickColor=BrickColor.new("Bright green")if z<0 then A.BrickColor=BrickColor.new("Bright red")return false,"Wire section too short"end;if q.OtherInfo.MaxLength.Value<v then A.BrickColor=BrickColor.new("Bright red")return false,"Wire too long"end;return true,n end;local function B(C)local D=Instance.new("Part",s)D.Anchored=true;D.CanCollide=false;D.Shape=Enum.PartType.Ball;D.Size=Vector3.new(1,1,1)*q.OtherInfo.Thickness.Value;D.CFrame=CFrame.new(C)D.Transparency=0.5;D.TopSurface=Enum.SurfaceType.Smooth;D.BottomSurface=Enum.SurfaceType.Smooth;return D end;for E,F in pairs(r)do local G=B(F)if E<#r then local H,I=w(F,r[E+1])n=I;G.BrickColor=H and BrickColor.new("Bright green")or BrickColor.new("Bright red")u=u or H else G.BrickColor=BrickColor.new("Bright green")end end;o=u;local J,K=getMousePoint(q.OtherInfo.Thickness.Value)local L=nil;if#r>0 and K then local M,N=w(r[#r],K)J=M;L=N end;local O,P=l:CanPlace(b,K,k)if not O then J=false;L="You can only place wires on your land"elseif O then if#r==0 then t=P elseif#r>0 and t~=P then J=false;L="You cannot build accross different plots"end end;if K then B(K).BrickColor=J and BrickColor.new("Bright green")or BrickColor.new("Bright red")end;if j=="Add Point"then if J then table.insert(r,K)else game.ReplicatedStorage.Notices.SendUserNotice:Fire(L,1.5)end;j="Placing"elseif j=="Remove Point"then if#r>0 then table.remove(r)j="Placing"else j="Abort placement"end end;wait()end;setGUIVisibility(false)b.PlayerGui.IsPlacingStructure.Value=false;s:Destroy()if j~="Confirm placement"then if j=="Abort placement"then return false else return end end;p:play()return r,t end;function getMousePoint(Q)local R=input.GetMouseHit().p;local S=input.GetMouseTarget()if not S then return end;local T=(R-g.CFrame.p).unit;local U=Ray.new(R-T/2,T)local V={e}local W=1-1;while true do local X,Y,Z=game.Workspace:FindPartOnRayWithIgnoreList(U,V)if not X then return false,R end;if X==S then return S.Anchored,R+Z*Q/2 end;table.insert(V,X)if 0<=1 then if W<100 then else break end elseif 100<W then else break end;W=W+1 end end;local _=c.Parent:WaitForChild("Confirm")local a0=require(c.Parent.Parent:WaitForChild("BumpButton"))function addPoint()if not _.Visible then return end;if not a0.Bump(_)then return end;j="Add Point"end;function finalizeSelected()if not m.Visible then return end;if not a0.Bump(m)then return end;if o then j="Confirm placement"return end;if j=="Placing"then if#k==0 then game.ReplicatedStorage.Notices.SendUserNotice:Fire("You must own land to place structures. Visit the land store to buy some.",2.5)else game.ReplicatedStorage.Notices.SendUserNotice:Fire(n,1.5)end;game.Players.LocalPlayer.PlayerGui.ClientSounds.Err:Play()end end;local a1=c.Parent:WaitForChild("Back")function back()if not a1.Visible then return end;if not a0.Bump(a1)then return end;j="Remove Point"end;function exitPlacementMode()if not a1.Visible then return end;j="Abort placement"end;function roundVector(a2)return Vector3.new(intervalRound(a2.X,0.1),intervalRound(a2.Y,0.1),intervalRound(a2.Z,0.1))end;function intervalRound(a3,a4)local a5=math.fmod(a3,a4)if a4/2<=a5 then a5=a3+a4-a5 elseif a5<a4/2 then a5=a3-a5 end;return roundOff(a5,a4)end;function roundOff(a6,a7)return math.floor(a6*10^a7+0.5)/10^a7 end;function setGUIVisibility(a8)m.Visible=a8;_.Visible=a8;a1.Visible=a8;input.SetBackpackEnabled(not a8)end;function setPlatformControls()if input.Device=="Touch"then _.PlatformButton.Visible=false;a1.PlatformButton.Visible=false;m.PlatformButton.Visible=false;a1.Position=a1.TouchPosition.Position;return end;_.PlatformButton.Visible=true;a1.PlatformButton.Visible=true;m.PlatformButton.Visible=true;if input.Device=="Gamepad"then _.PlatformButton.Image=_.PlatformButton.Gamepad.Value;m.PlatformButton.Image=m.PlatformButton.Gamepad.Value;a1.PlatformButton.Image=a1.PlatformButton.Gamepad.Value;_.PlatformButton.KeyLabel.Text=""m.PlatformButton.KeyLabel.Text=""a1.PlatformButton.KeyLabel.Text=""return end;if input.Device=="PC"then _.PlatformButton.Image=_.PlatformButton.PC.Value;a1.PlatformButton.Image=a1.PlatformButton.PC.Value;m.PlatformButton.Image=m.PlatformButton.PC.Value;_.PlatformButton.KeyLabel.Text="E"a1.PlatformButton.KeyLabel.Text="B"m.PlatformButton.KeyLabel.Text="F"end end;wait(1)input=require(c.Parent.Parent.Scripts.UserInput)input.InteractSelectionMade(addPoint)input.InteractAbort(back)input.FinalizeWireSelection(finalizeSelected)m.MouseButton1Click:connect(function()finalizeSelected()end)a1.MouseButton1Click:connect(function()back()end)_.MouseButton1Click:connect(function()addPoint()end)
    end,
    {
        animated = true
    }
)
--[[
local startedInteract = false
itms:Create(
    "Slider",
    "Interaction Range",
    function(v)
        _G.CurrentRangeMyAss = tonumber(v)
        if not startedInteract and v ~= 11 then
            startedInteract = true
            --loadstring(game:HttpGet"https://dogix.wtf/scripts/lt2/interaction_range.lua")()
        end
    end,
    {
        min = 5,
        max = 200,
        default = 11,
    }
)
]]
itms:Create(
    "Button",
    "Click Delete Item Tool (SS)",
    function(v)
        local plr = game:GetService("Players").LocalPlayer
        local tool = Instance.new("Tool",plr.Backpack)
        tool.RequiresHandle = false
        tool.Name = "Destroy Item"
        tool.Activated:Connect(function()
            local plank = getMouseTarget()
            if plank:IsA("Part") then
                local par = plank
                repeat par = par.Parent until par == game.Workspace or par == game or par == game.Workspace.PlayerModels or par == game.Workspace.LogModels or par.Name == "TreeRegion" or par.Name == "ShopItems"
                if par ~= game and par ~= game.Workspace then
                    delmodel(plank.Parent)
                end
            end
        end)
    end,
    {
        animated = true,
    }
)

local w5 = main:CreateCategory("Auto-Buy")
local cautobc = 1
local cautobi = "BasicHatchet"
local abuy = w5:CreateSection("General Auto-Buy")
--local oldTable = {"BasicHatchet";"Axe1";"Axe2";"Axe3";"SilverAxe";"ManyAxe";"Rukiryaxe";"Wire";"NeonWireOrange";"NeonWireRed";"NeonWireViolet";"NeonWireWhite";"NeonWireYellow";"NeonWireBlue";"NeonWireCyan";"NeonWireGreen";"IcicleWireBlue";"IcicleWireAmber";"IcicleWireRed";"IcicleWireGreen";"IcicleWireHalloween";"LightBulb";"BagOfSand";"CanOfWorms";"Dynamite";"Sawmill";"Sawmill2";"Sawmill3";"Sawmill4";"Sawmill4L";"UtilityTruck";"WorkLight";"SmallTrailer";"Pickup1";"UtilityTruck2";"Trailer2";"Painting1";"Painting2";"Painting3";"Painting6";"Painting7";"Painting8";"Painting9";"ChopSaw";"Button0";"Lever0";"Laser";"LaserReceiver";"Hatch";"SignalDelay";"SignalSustain";"WoodChecker";"GateNOT";"GateXOR";"GateAND";"GateOR";"ClockSwitch";"PressurePlate";"ConveyorSwitch";"StraightSwitchConveyorLeft";"StraightSwitchConveyorRight";"ConveyorSupports";"StraightConveyor";"TightTurnConveyorSupports";"TightTurnConveyor";"ConveyorFunnel";"TiltConveyor";"LogSweeper";"Seat_Armchair";"Dishwasher";"Refridgerator";"Stove";"Toilet";"Seat_Couch";"Seat_Loveseat";"FloorLamp1";"Lamp1";"GlassPane1";"GlassPane2";"GlassPane3";"GlassPane4";"GlassDoor1";"FireworkLauncher";"Bed1";"Bed2";"WallLight1";"WallLight2"}
local itemsTable = {}
local visualTableTyped = {}
local visualTableConcat = {}
if game.Workspace.Stores:FindFirstChild("ShopItems") == nil then -- fixing clones
    for i, v in pairs(game.Workspace.Stores:GetChildren()) do
        if v:FindFirstChild("ShopItems") then
            v.ShopItems.Parent = game.Workspace.Stores
        end
    end
end
for i,v in pairs (game.Workspace.Stores:GetChildren()) do
    if v.Name == "ShopItems" then
        for i,v in next, v:GetChildren() do
            if v:IsA("Model") then
                if v.Type.Value ~= "Blueprint" then
                    local visName = game:GetService("ReplicatedStorage").Purchasables:FindFirstChild(v.BoxItemName.Value, true)
                    if visName then
                        visName = visName.ItemName.Value
                        if itemsTable[visName] == nil then
                            itemsTable[visName] = v.BoxItemName.Value
                            local typeName = game:GetService("ReplicatedStorage").Purchasables:FindFirstChild(v.BoxItemName.Value, true).Type.Value
                            if visualTableTyped[typeName] == nil then
                                visualTableTyped[typeName] = {}
                            end
                            table.insert(visualTableTyped[typeName],visName)
                        end
                    end
                end
            end
        end
    end
end
table.insert(visualTableTyped.Tool, "Rukiryaxe")
itemsTable.Rukiryaxe = "Rukiryaxe"
for i,v in pairs (visualTableTyped) do
    for i,v in pairs (v) do
        table.insert(visualTableConcat,v)
    end
end
abuy:Create(
    "Dropdown",
    "Item Selection",
    function(state)
        cautobi = itemsTable[state]
    end,
    {
        options = visualTableConcat,
        search = true,
        default = "Basic Hatchet";
    }
)
local showed_high = false
abuy:Create(
    "Slider",
    "Quantity",
    function(v)
        cautobc = tonumber(v)
        if cautobc == 25 and showed_high == false then
            showed_high = true
            abuy:Create("TextBox", "Unrestricted Quantity", function(v)
        	    cautobc = tonumber(v)
            end, 
            {
        	    text = "Quantity"
            })
        end
    end,
    {
        min = 1,
        max = 25,
        default = 1,
        changablevalue = true
    }
)
abuy:Create(
    "Button",
    "Purchase Items",
    function(v)
        if cautobi ~= "Rukiryaxe" then
            local price = price_of(cautobi)
            if math.floor(game.Players.LocalPlayer.leaderstats.Money.Value/price)<cautobc then
                notify("Auto-Buy", "You cannot afford "..cautobc.." "..cautobi..".",3)
                return
            end
            autobuy(cautobi,cautobc)
        else
            local plr = game:GetService'Players'.LocalPlayer
            local plrcf = plr.Character.HumanoidRootPart.CFrame
            local bulb = autobuy("LightBulb",1,CFrame.new(322.33, 43, 1916.5),false)
            if not bulb then return end
            local sand = autobuy("BagOfSand",1,CFrame.new(319.4, 43, 1914.5),false)
            if not sand then return end
            local worms = autobuy("CanOfWorms",1,CFrame.new(317.25, 43, 1918),false)
            if not worms then return end
            if sand and worms and bulb then
                local openr = game:GetService("ReplicatedStorage").Interaction.ClientInteracted
                openr:FireServer(sand, "Open box")
                openr:FireServer(worms, "Open box")
                openr:FireServer(bulb, "Open box")
                local opening = game.Workspace.PlayerModels.ChildAdded:connect(function(new)
                    if new:WaitForChild("Owner").Value == nil and new:WaitForChild("ToolName").Value == "Rukiryaxe" then
                        game:GetService("ReplicatedStorage").Interaction.ClientIsDragging:FireServer(new)
                        game:GetService("ReplicatedStorage").Interaction.CheckShip:FireServer(new.Owner,plr)
                        game:GetService("ReplicatedStorage").Interaction.ClientInteracted:FireServer(new, "Pick up tool")
                        opening:Disconnect()
                        opening = nil
                    end
                end)
                plr.Character.HumanoidRootPart.CFrame = plrcf
            end
        end
    end,
    {
        animated = true
    }
)
abuy:Create(
    "Button",
    "Cancel Purchase Items",
    function(v)
        notify("Auto-Buy","Attempted to cancel Auto-Buy.",3)
        abortbuy = true
        InBuy = false
    end,
    {
        animated = true
    }
)
abuy:Create(
    "Button",
    "Get Price of Items",
    function(v)
        local price = price_of(cautobi)
        if price then
            notify("Auto-Buy", cautobi.." costs $"..tostring(price)..". You can afford "..math.floor(game.Players.LocalPlayer.leaderstats.Money.Value/price)..".",3)
        else
            notify("Auto-Buy","Couldn't find "..cautobi, 3)
        end
    end,
    {
        animated = true
    }
)

local state_sauto = "Pink Neon Wire"
local amt_sauto = 1
local abuys = w5:CreateSection("Special Auto-Buy")
abuys:Create(
    "Dropdown",
    "Special Auto-Buy Items",
    function(state)
        state_sauto = state
    end,
    {
        options = {
            "Easy Building Power";
            "Bridge Lower";
            "Ferry Ticket";
        },
        search = true,
        default = "Bridge Lower";
    }
)
abuys:Create(
    "Slider",
    "Quantity",
    function(v)
        amt_sauto = tonumber(v)
    end,
    {
        min = 1,
        max = 25,
        default = 1,
        changablevalue = true
    }
)
abuys:Create(
    "Button",
    "Purchase Special Item",
    function(v)
        if state_sauto == "Easy Building Power" then
            if not confirm() then return end
            local Array =
            {
            	["Character"] = game.Workspace["Region_Main"]["Strange Man"],
            	["Name"] = "Strange Man",
            	["ID"] = cashierIds["Strange Man"],
            	["Dialog"] = game.Workspace["Region_Main"]["Strange Man"].Dialog
            }
            game:GetService("ReplicatedStorage").NPCDialog.PlayerChatted:InvokeServer(Array, "Initiate")
            game:GetService("ReplicatedStorage").NPCDialog.PlayerChatted:InvokeServer(Array, "ConfirmPurchase")
            game:GetService("ReplicatedStorage").NPCDialog.PlayerChatted:InvokeServer(Array, "EndChat")
        elseif state_sauto == "Ferry Ticket" then
            local Array =
            {
            	["Character"] = game.Workspace.Ferry.Ferry.Hoover,
            	["Name"] = "Hoover",
            	["ID"] = cashierIds['Hoover'],
            	["Dialog"] = game.Workspace.Ferry.Ferry.Hoover.Dialog
            }
            game:GetService("ReplicatedStorage").NPCDialog.PlayerChatted:InvokeServer(Array, "Initiate")
            game:GetService("ReplicatedStorage").NPCDialog.PlayerChatted:InvokeServer(Array, "ConfirmPurchase")
            game:GetService("ReplicatedStorage").NPCDialog.PlayerChatted:InvokeServer(Array, "EndChat")
        elseif state_sauto == "Bridge Lower" then
            for i=1,amt_sauto do
                local Array =
                {
                	["Character"] = game.Workspace.Bridge.TollBooth0.Seranok,
                	["Name"] = "Seranok",
                	["ID"] = cashierIds['Seranok'],
                	["Dialog"] = game.Workspace.Bridge.TollBooth0.Seranok.Dialog
                }
                game:GetService("ReplicatedStorage").NPCDialog.PlayerChatted:InvokeServer(Array, "Initiate")
                game:GetService("ReplicatedStorage").NPCDialog.PlayerChatted:InvokeServer(Array, "ConfirmPurchase")
                game:GetService("ReplicatedStorage").NPCDialog.PlayerChatted:InvokeServer(Array, "EndChat")
            end
        end
    end,
    {
        animated = true
    }
)
local state_wauto = "NeonWirePinky"
local amt_wauto = 1
local abuyw = w5:CreateSection("Cheaper Wire Auto-Buy ($220)")
abuyw:Create(
    "Dropdown",
    "Cheap Auto-Buy Wires",
    function(state)
        state_wauto = state
    end,
    {
        options = {
            "NeonWirePinky";
            "NeonWireOrange";
            "NeonWireRed";
            "NeonWireViolet";
            "NeonWireWhite";
            "NeonWireYellow";
            "NeonWireBlue";
            "NeonWireCyan";
            "NeonWireGreen";
            "IcicleWireBlue";
            "IcicleWireAmber";
            "IcicleWireRed";
            "IcicleWireGreen";
            "IcicleWireMagenta";
            "IcicleWireHalloween";
        },
        search = true,
        default = "NeonWirePinky";
    }
)
abuyw:Create(
    "Slider",
    "Quantity",
    function(v)
        amt_wauto = tonumber(v)
    end,
    {
        min = 1,
        max = 25,
        default = 1,
        changablevalue = true
    }
)
abuyw:Create(
    "Button",
    "Purchase Cheaper Wire",
    function(v)
        spawn_wire(state_wauto,amt_wauto)
    end,
    {
        animated = true
    }
)
local other = w4:CreateSection("Other")
other:Create(
    "Toggle",
    "Leak Items (patched)",
    function(state)
        if state then
            if getgenv().clone then return end
            getgenv().clone = game.ReplicatedStorage.Purchasables:Clone()
            getgenv().clone.Parent = game.Workspace.PlayerModels
        else
            if not getgenv().clone then return end
            getgenv().clone:Destroy()
            getgenv().clone = nil
        end
    end,
    {
        animated = true
    }
)
--lumbsmasher api
local ls_api
local function get_ls_api()
    if ls_api then return ls_api end
    --paste ls api here lol
    
    --store data
    local store_items = {}
    local store_data = {}
    local store_mapping = {}
    local store_name_mapping = {
        {"Wood R US", "wood_r_us"},
        {"Fancy Furnishings", "fancy_furnishings"},
        {"Boxed Cars", "boxed_cars"},
        {"Bob's Shack", "bobs_shack"},
        {"Fine Arts Shop", "fine_arts_shop"},
        {"Link's Logic", "links_logic"}
    }
    spawn(function()

        local store_success, result = pcall(function()
            print("[LumbSmasher-API / INFO]: Loading Auto-Buy Data async...")
            local stores = game.Workspace.Stores
            for i, v in pairs(stores:GetChildren()) do
                if v.name=="ShopItems" then
                    if v:FindFirstChild("BasicHatchet") then store_items['wood_r_us'] = v
                    elseif v:FindFirstChild("Bed2") then store_items['fancy_furnishings'] = v
                    elseif v:FindFirstChild("SmallTrailer") then store_items['boxed_cars'] = v
                    elseif v:FindFirstChild("CanOfWorms") then store_items['bobs_shack'] = v
                    elseif v:FindFirstChild("Painting1") then store_items['fine_arts_shop'] = v
                    elseif v:FindFirstChild("GateXOR") then store_items['links_logic'] = v
                    end
                end
            end

            store_data['fancy_furnishings'] = { Character=stores.FurnitureStore.Corey, Name="Corey", ID=11,Dialog=Instance.new("Dialog",stores.FurnitureStore.Corey) }
            store_data['wood_r_us'] = { Character=stores.WoodRUs.Thom, Name="Thom", ID=10,Dialog=stores.WoodRUs.Thom.Dialog }
            store_data['boxed_cars'] = { Character=stores.CarStore.Jenny, Name="Jenny", ID=12,Dialog=Instance.new("Dialog",stores.CarStore.Jenny) }
            store_data['bobs_shack'] = { Character=stores.ShackShop.Bob, Name="Bob", ID=13,Dialog=stores.ShackShop.Bob.Dialog }
            store_data['fine_arts_shop'] = { Character=stores.FineArt.Timothy, Name="Timothy", ID=14,Dialog=stores.FineArt.Timothy.Dialog }
            store_data['links_logic'] = { Character=stores.LogicStore.Lincoln, Name="Lincoln", ID=15,Dialog=Instance.new("Dialog",stores.LogicStore.Lincoln) }
            
            print("[LumbSmasher-API / INFO]: Loading Cashier Data...")
            for i, v in pairs(store_data) do
                local event = game.ReplicatedStorage.NPCDialog.PromptChat
                local crypt = math.random(0,10000)
                local connection
                connection = event.OnClientEvent:Connect(function(crypt_a, npc_payload, dialog)
                    if crypt_a == crypt then
                        print("[LumbSmasher-API / INFO]: Loaded Cashier:", npc_payload.Name, "with ID:", npc_payload.ID)
                        store_data[i] = npc_payload
                        connection:Disconnect()
                        connection = nil
                    end
                end)
                event:FireServer(crypt, v.Character, v['Dialog'])
                while connection do
                    game:GetService("RunService").RenderStepped:Wait()
                    event:FireServer(crypt, v.Character, v['Dialog'])
                end
            end
            print("[LumbSmasher-API / INFO]: Finished loading Cashier Data!")
            store_mapping['wood_r_us']=stores.WoodRUs
            store_mapping['fancy_furnishings']=stores.FurnitureStore
            store_mapping['boxed_cars']=stores.CarStore
            store_mapping['bobs_shack']=stores.ShackShop
            store_mapping['links_logic']=stores.LogicStore
            store_mapping['fine_arts_shop']=stores.FineArt
            print("[LumbSmasher-API / INFO]: Auto-Buy Data Loaded!")
        end)
        if not store_success then
            warn("[LumbSmasher-API] Failed to load auto-buy data! | ", result)
        end
        getgenv().autobuy_loaded = true
    end)

    local TweenService = game:GetService("TweenService")



    -- Main LumbSmasher API
    local api = {
        localplayer = game.Players.LocalPlayer,

        send_notice = function(self, message)
            game:GetService("ReplicatedStorage")["Notices"]["SendUserNotice"]:Fire(message)
        end,
        notify = function(self, message)
            game:GetService("ReplicatedStorage")["Notices"]["SendUserNotice"]:Fire(message)
        end,
        send_notice_callback = function(self, message, button_name, table_index, callback)
            for i, v in pairs(getgc(true)) do
                if type(v)=="table" and rawget(v, "CameraNext") ~= nil and v.CameraNext.Text == "Next" then
                    v[table_index] = {Text = button_name, Func=callback}
                end
            end
            game.ReplicatedStorage.Notices.SendUserNotice:Fire(message, nil, table_index)
        end,
        -- get_plot function 
        get_plot = function(self, user)
            if user == nil then user = self.localplayer end
            local land
            for _, plot in pairs(workspace.Properties:GetChildren()) do
                if plot.Owner.Value == user then
                    land = plot
                    break
                end
            end
            if not land then
                error("You need to buy land first!")
            end
            return land
        end,
        -- we got bark for this useless owership func (applebee 12/08/2021)
        
        -- kick player
        kick_player = function(self, target, set_status)
            local backup = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            if not game.Players.LocalPlayer.Character:FindFirstChild("Tool") then
                set_status("Please hold an axe to kick a player.")
                return 
            end
            set_status("Kicking Player...")
            local signal
            signal = game.Players.LocalPlayer.CharacterAdded:Connect(function()
                signal:Disconnect()
                set_status("Teleporting Back.")
                set_status("Ready")
                _G.DogixLT2TPC(backup, gkey)
            end)
            _G.DogixLT2TPC(target.Character.HumanoidRootPart.CFrame, gkey)
            local Axe = game.Players.LocalPlayer.Character.Tool
            local Handle = Axe.Handle
            Axe.Owner:Destroy()
            Axe.Parent = game.Workspace
            game.Players.LocalPlayer.Character.Humanoid:Destroy()
            for i=1,20 do
                wait()
                --teleport(target.Character.HumanoidRootPart.CFrame)
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
                -- game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(Handle)
            end
        end,
        --wipe_base
        wipe_base = function(self, target)
            local land
            for i,v in pairs(game.Workspace.Properties:GetChildren()) do
                if v.Owner.Value == target then
                    land = v
                end
            end
            for i,v in pairs(game.Workspace.PlayerModels:GetChildren()) do
                if v:FindFirstChild("Owner") then
                    if v.Owner.Value == target then
                        --game.ReplicatedStorage.Interaction.DestroyStructure:FireServer(v)
                        game.ReplicatedStorage.PlaceStructure.ClientPlacedBlueprint:FireServer("Floor1Tiny", land.OriginSquare.CFrame - Vector3.new(0,100,0), nil, v)
                    end
                end
            end
        end,

        
        --claim plot
        claim_plot_connnection_table = {},
        claim_plots = function(self)
            self:unclaim_plots()
            for _, plot in pairs(game.Workspace.Properties:GetChildren()) do
                if plot.Owner.Value == nil then
                    game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(plot)
                end
                local connection
                connection = plot.Owner.Value.Changed:Connect(function(value)
                    if value == nil then
                        game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(plot)
                    end
                end)
                table.insert(self.claim_plot_connnection_table, connection)
            end
        end,
        unclaim_plots = function(self)
            for i, v in pairs(self.claim_plot_connnection_table) do
                v:Disconnect()
            end
            self.claim_plot_connnection_table = {}
        end,
        
        --delete store doors
        delete_store_doors = function(self)
            for _, store in pairs(game.Workspace.Stores:GetChildren()) do
                if store:FindFirstChild("LDoor") then
                    game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(store:FindFirstChild("LDoor"))
                    game.ReplicatedStorage.Interaction.DestroyStructure:FireServer(store:FindFirstChild("LDoor"))
                end
                if store:FindFirstChild("RDoor") then
                    game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(store:FindFirstChild("RDoor"))
                    game.ReplicatedStorage.Interaction.DestroyStructure:FireServer(store:FindFirstChild("RDoor"))
                end
            end
        end,
        
        -- removing useless LS api trash ~applebee 12/08/2021
        
        -- drag mod
        drag_mod = function(self)
            if game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.Dragger.Disabled==true then error("Drag Mod Already Active!")end;game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.Dragger.Disabled=true;local a=game.Players.LocalPlayer.PlayerGui.ItemDraggingGUI.Dragger;local b=game.Players.LocalPlayer;local c=b.Character or b.CharacterAdded:wait()local d=c:WaitForChild("Humanoid")local e=d.WalkSpeed;local f=a:FindFirstChild("Dragger")if f==nil then f=game:GetObjects("rbxassetid://5893130434")[1]end;f.BrickColor=BrickColor.new("Bright yellow")b.CharacterAdded:connect(function()c=b.Character;d=c:WaitForChild("Humanoid")d.Died:connect(function()f.Parent=nil end)end)wait(1)local g=11;local h=7;local i=game.Workspace.CurrentCamera;local j=b:GetMouse()local k=false;local l=g;local m=Instance.new("BodyPosition",f)m.maxForce=Vector3.new(math.huge,math.huge,math.huge)m.D=5000;m.P=400000;local n=Instance.new("BodyGyro",f)n.maxTorque=Vector3.new(math.huge,math.huge,math.huge)n.D=1400;n.P=12000;local o=CFrame.new()local p=Instance.new("Weld",f)local q=require(game.ReplicatedStorage.Interaction.InteractionPermission)local r=game.ReplicatedStorage.Interaction.ClientIsDragging;local s;local t=false;function click()k=true;local u=input.GetMouseTarget()if not canDrag(u)then return end;local v=input.GetMouseHit().p;if(v-c.Head.Position).magnitude>g then return end;initializeDrag(u,v)o=CFrame.new()s:Play(0.1,1,1)local w=0;local x=0;while k and canDrag(u)do local y=c.Head.Position+(input.GetMouseHit().p-c.Head.Position).unit*l;local z=Ray.new(c.Head.Position,y-c.Head.Position)local A,B=game.Workspace:FindPartOnRayWithIgnoreList(z,{c,f,u.Parent})if A then y=B end;if(i.CoordinateFrame.p-c.Head.Position).magnitude>2 then y=y+Vector3.new(0,1.8,0)end;moveDrag(y)n.cframe=CFrame.new(f.Position,i.CoordinateFrame.p)*o;local C=findHighestParent(u)or u;local D=false;for E,F in pairs({{Ray=Ray.new((c.HumanoidRootPart.CFrame*CFrame.new(0.7,-2.8,0)).p,Vector3.new(0,-2,0))},{Ray=Ray.new((c.HumanoidRootPart.CFrame*CFrame.new(0.35,-2.8,0)).p,Vector3.new(0,-2,0))},{Ray=Ray.new((c.HumanoidRootPart.CFrame*CFrame.new(0,-2.8,0)).p,Vector3.new(0,-2,0))},{Ray=Ray.new((c.HumanoidRootPart.CFrame*CFrame.new(0.35,-2.8,0)).p,Vector3.new(0,-2,0))},{Ray=Ray.new((c.HumanoidRootPart.CFrame*CFrame.new(-0.7,-2.8,0)).p,Vector3.new(0,-2,0))},{Ray=Ray.new((c.HumanoidRootPart.CFrame*CFrame.new(0.35,-2.8,0.6)).p,Vector3.new(0,-2,0))},{Ray=Ray.new((c.HumanoidRootPart.CFrame*CFrame.new(0,-2.8,0.6)).p,Vector3.new(0,-2,0))},{Ray=Ray.new((c.HumanoidRootPart.CFrame*CFrame.new(0.35,-2.8,0.6)).p,Vector3.new(0,-2,0))},{Ray=Ray.new((c.HumanoidRootPart.CFrame*CFrame.new(0.35,-2.8,-0.6)).p,Vector3.new(0,-2,0))},{Ray=Ray.new((c.HumanoidRootPart.CFrame*CFrame.new(0,-2.8,-0.6)).p,Vector3.new(0,-2,0))},{Ray=Ray.new((c.HumanoidRootPart.CFrame*CFrame.new(0.35,-2.8,-0.6)).p,Vector3.new(0,-2,0))},{Ray=Ray.new((c.HumanoidRootPart.CFrame*CFrame.new(0.5,-0.8,0)).p,c.HumanoidRootPart.CFrame.lookVector),State=Enum.HumanoidStateType.Climbing},{Ray=Ray.new((c.HumanoidRootPart.CFrame*CFrame.new(-0.5,-0.8,0)).p,c.HumanoidRootPart.CFrame.lookVector),State=Enum.HumanoidStateType.Climbing},{Ray=Ray.new((c.HumanoidRootPart.CFrame*CFrame.new(0.5,-1.3,0)).p,c.HumanoidRootPart.CFrame.lookVector),State=Enum.HumanoidStateType.Climbing},{Ray=Ray.new((c.HumanoidRootPart.CFrame*CFrame.new(-0.5,-1.3,0)).p,c.HumanoidRootPart.CFrame.lookVector),State=Enum.HumanoidStateType.Climbing}})do local G=F.Ray;local A,E=game.Workspace:FindPartOnRayWithIgnoreList(G,{c})local H=A;A=A and findHighestParent(A)if A and(not F.State or d:GetState()==F.State)then if A==C then D=true else for E,I in pairs(H:GetConnectedParts(true))do if I==u then D=true;break end end end;if D then break end end end;local J=d:GetState()==Enum.HumanoidStateType.Freefall or d:GetState()==Enum.HumanoidStateType.FallingDown;if D then w=w+20 elseif J then w=w+1 elseif(f.Position-y).magnitude>5 then w=w+1 else w=0 end;if w>16 then break end;if u.Name=="PushMe"or u.Parent.Name=="PartSpawner"then if PROTOSMASHER_LOADED then set_simulation_radius(game.Players.LocalPlayer,math.huge)elseif syn and not is_sirhurt_closure then setsimulationradius(math.huge,math.huge)end;r:FireServer(u)else r:FireServer(C.Parent)end;wait()x=x+1 end;s:Stop()endDrag()end;function findHighestParent(K)if not K or not K.Parent or K.Parent==game.Workspace then return nil end;local L=K.Parent:FindFirstChild("Owner")and K;return findHighestParent(K.Parent)or L end;function clickEnded()k=false end;function holdDistanceChanged(M)l=h+(1-M)*(g-h)end;function canDrag(u)for E,N in pairs(c:GetChildren())do if N:IsA("Tool")then return false end end;if not(u and not u.Anchored and u.Parent and d.Health>0)then return false end;local O=u;u=findHighestParent(u)or u;if game.Players:GetPlayerFromCharacter(u.Parent.Parent)then return false end;n.Parent=f;if u.Name=="PushMe"or u.Parent.Name=="PartSpawner"then return true end;if string.find(u.Name,"Steer")or u.Name=="PaintParts"then return true end;if not u.Parent:FindFirstChild("Owner")then return otherDraggable(u,O)end;if not q:UserCanInteract(b,u.Parent)then if u.Parent.Name=="Plank"then return true end;return false end;if u.Parent:FindFirstChild("TreeClass")then return true end;if u.Parent:FindFirstChild("BoxItemName")then return true end;if u.Parent:FindFirstChild("PurchasedBoxItemName")then return true end;if u.Parent:FindFirstChild("Handle")then return true end;return otherDraggable(u,O)end;function otherDraggable(u,O)local P=u and u.Parent and u.Parent:FindFirstChild("DraggableItem")or O and O.Parent and O.Parent:FindFirstChild("DraggableItem")if P then if P:FindFirstChild("NoRotate")then n.Parent=nil end;return true end end;function initializeDrag(u,v)t=true;j.TargetFilter=u and findHighestParent(u)and findHighestParent(u).Parent or u;f.CFrame=CFrame.new(v,i.CoordinateFrame.p)p.Part0=f;p.Part1=u;p.C0=CFrame.new(v,i.CoordinateFrame.p):inverse()*u.CFrame;p.Parent=f;f.Parent=game.Workspace end;function endDrag()j.TargetFilter=nil;f.Parent=nil;t=false end;local Q=""function interactLoop()while true do wait()local R=""local v=input.GetMouseHit().p;local u=input.GetMouseTarget()if t then R="Dragging"elseif canDrag(u)and not k and(v-c.Head.Position).magnitude<g then R="Mouseover"end;if true then Q=R;setPlatformControls()if Q==""then a.Parent.CanDrag.Visible=false;a.Parent.CanRotate.Visible=false elseif Q=="Mouseover"then a.Parent.CanDrag.Visible=true;a.Parent.CanRotate.Visible=false elseif Q=="Dragging"then a.Parent.CanDrag.Visible=false;a.Parent.CanRotate.Visible=not(n.Parent==nil)and(not b:FindFirstChild("IsChatting")or b.IsChatting.Value<1)end end end end;function moveDrag(B)m.position=B end;local S=0.036;local T;function rotate(U,V)if not t then if not b:FindFirstChild("IsChatting")or b.IsChatting.Value<2 then d.WalkSpeed=e end;return end;if d.WalkSpeed>1 then e=d.WalkSpeed;d.WalkSpeed=0 end;T=tick()local W=T;while t and U.magnitude>0 and T==W do o=CFrame.Angles(0,-U.X*S,0)*CFrame.Angles(U.Y*S,0,0)*o;wait()end;if U.magnitude==0 then if not b:FindFirstChild("IsChatting")or b.IsChatting.Value<2 then d.WalkSpeed=e end end end;wait(1)s=d:LoadAnimation(a:WaitForChild("CarryItem"))input=require(a.Parent.Parent:WaitForChild("Scripts"):WaitForChild("UserInput"))input.ClickBegan(click,holdDistanceChanged)input.ClickEnded(clickEnded)input.Rotate(rotate)function setPlatformControls()if input.IsGamePadEnabled()then a.Parent.CanDrag.PlatformButton.Image=a.Parent.CanDrag.PlatformButton.Gamepad.Value;a.Parent.CanDrag.PlatformButton.KeyLabel.Text=""a.Parent.CanRotate.PlatformButton.Image=a.Parent.CanRotate.PlatformButton.Gamepad.Value;a.Parent.CanRotate.PlatformButton.KeyLabel.Text=""else a.Parent.CanDrag.PlatformButton.Image=a.Parent.CanDrag.PlatformButton.PC.Value;a.Parent.CanDrag.PlatformButton.KeyLabel.Text="CLICK"a.Parent.CanRotate.PlatformButton.Image=a.Parent.CanRotate.PlatformButton.PC.Value;a.Parent.CanRotate.PlatformButton.KeyLabel.Text="SHIFT + WASD"end end;interactLoop()
        end,
        -- wire mod
        wire_mod = function(self)
            if game.Players.LocalPlayer.PlayerGui.WireDraggingGUI.WireDragger.Disabled==true then error("Wire Mod Already Active!")end;game.Players.LocalPlayer.PlayerGui.WireDraggingGUI.WireDragger.Disabled=true;local a=game.Players.LocalPlayer.PlayerGui.WireDraggingGUI.WireDragger;local b=game:GetService("RunService")local c=game.Players.LocalPlayer;local d=c.Character or c.CharacterAdded:wait()local e=d:WaitForChild("Humanoid")local f=game.Workspace.CurrentCamera;c.CharacterAdded:connect(function()d=c.Character;e=d:WaitForChild("Humanoid")f=game.Workspace.CurrentCamera end)local g=c:GetMouse()local h=a.Parent:WaitForChild("Confirm")local i=a.Parent:WaitForChild("Back")local j=a.Parent:WaitForChild("Finalize")local k=require(a.Parent.Parent:WaitForChild("BumpButton"))local l=a.Parent:WaitForChild("DragWire")local m={}local n=require(game.ReplicatedStorage.Interaction.InteractionPermission)local o=game.Players.LocalPlayer.PlayerGui:WaitForChild("ClientSounds"):WaitForChild("PlaceStructure")local p;local q=false;local r=""local s;function l.OnInvoke(t)c.PlayerGui.IsPlacingStructure.Value=true;if p=="Placing"then exitPlacementMode()wait(0.1)end;getPlayerLand()p="Placing"setPlatformControls()setGUIVisibility(true)local u={}local v=Instance.new("Model",game.Workspace.CurrentCamera)local w;while p=="Placing"or p=="Add Point"or p=="Remove Point"do j.Visible=#u>=2;v:ClearAllChildren()local x=true;local y=0;local function z(A,B)local C=(A-B).magnitude;y=y+C;local D=Instance.new("Part",v)D.Shape=Enum.PartType.Cylinder;D.Anchored=true;D.CanCollide=false;D.CFrame=CFrame.new(A,B)*CFrame.new(0,0,-C/2)*CFrame.Angles(0,math.pi/2,0)D.Size=Vector3.new(C,t.OtherInfo.Thickness.Value,t.OtherInfo.Thickness.Value)D.Transparency=0.5;D.TopSurface=Enum.SurfaceType.Smooth;D.BottomSurface=Enum.SurfaceType.Smooth;D.BrickColor=BrickColor.new("Bright green")if C<0.5 then D.BrickColor=BrickColor.new("Bright red")return false,"Wire section too short"end;if y>t.OtherInfo.MaxLength.Value then D.BrickColor=BrickColor.new("Bright red")return false,"Wire too long"end;return true,r end;local function E(F)local D=Instance.new("Part",v)D.Anchored=true;D.CanCollide=false;D.Shape=Enum.PartType.Ball;D.Size=Vector3.new(1,1,1)*t.OtherInfo.Thickness.Value;D.CFrame=CFrame.new(F)D.Transparency=0.5;D.TopSurface=Enum.SurfaceType.Smooth;D.BottomSurface=Enum.SurfaceType.Smooth;return D end;for G,F in pairs(u)do local H=E(F)if G<#u then local I;I,r=z(F,u[G+1])H.BrickColor=I and BrickColor.new("Bright green")or BrickColor.new("Bright red")x=x and I else H.BrickColor=BrickColor.new("Bright green")end end;q=x;local J,K=getMousePoint(t.OtherInfo.Thickness.Value)local L;if#u>0 and K then J,L=z(u[#u],K)end;local q,M=canPlaceHere(K)if not q then J=false;L="You can only place wires on your land"elseif q then if#u==0 then w=M elseif#u>0 and not(w==M)then J=false;L="You cannot build accross different plots"end end;if K then local N=E(K)N.BrickColor=J and BrickColor.new("Bright green")or BrickColor.new("Bright red")end;if p=="Add Point"then if J then table.insert(u,K)else game.ReplicatedStorage.Notices.SendUserNotice:Fire(L,1.5)end;p="Placing"elseif p=="Remove Point"then if#u>0 then table.remove(u)p="Placing"else p="Abort placement"end end;wait()end;setGUIVisibility(false)c.PlayerGui.IsPlacingStructure.Value=false;v:Destroy()if p=="Confirm placement"then o:play()return u,w elseif p=="Abort placement"then return false end end;function getMousePoint(O)local K=input.GetMouseHit().p;local P=input.GetMouseTarget()if not P then return end;local Q=(K-f.CFrame.p).unit;local R=K-Q/2;local Ray=Ray.new(R,Q)local S={d}for G=1,100 do local D,T,U=game.Workspace:FindPartOnRayWithIgnoreList(Ray,S)if not D then return false,K elseif D==P then return P.Anchored,K+U*O/2 else table.insert(S,D)end end end;function addPoint()if not h.Visible then return end;if not k.Bump(h)then return end;p="Add Point"end;function finalizeSelected()if not j.Visible then return end;if not k.Bump(j)then return end;if s then q=canPlaceHere(s)end;if q then p="Confirm placement"elseif p=="Placing"then if#m==0 then game.ReplicatedStorage.Notices.SendUserNotice:Fire("You must own land to place structures. Visit the land store to buy some.",2.5)else game.ReplicatedStorage.Notices.SendUserNotice:Fire(r,1.5)end;game.Players.LocalPlayer.PlayerGui.ClientSounds.Err:Play()end end;function back()if not i.Visible then return end;if not k.Bump(i)then return end;p="Remove Point"end;function exitPlacementMode()if not i.Visible then return end;p="Abort placement"end;function roundVector(V)local W=Vector3.new(intervalRound(V.X,0.1),intervalRound(V.Y,0.1),intervalRound(V.Z,0.1))return W end;function intervalRound(X,Y)local Z=math.fmod(X,Y)if Z>=Y/2 then Z=X+Y-Z elseif Z<Y/2 then Z=X-Z end;Z=roundOff(Z,Y)return Z end;function roundOff(_,a0)return math.floor(_*10^a0+0.5)/10^a0 end;function getPlayerLand()m={}for T,a1 in pairs(game.Workspace.Properties:GetChildren())do if a1.Owner.Value and n:UserCanInteract(c,a1)then for a2,a3 in pairs(a1:GetChildren())do if a3:IsA("BasePart")then table.insert(m,{minBounds=Vector3.new(math.min(a3.Position.X+a3.Size.X/2,a3.Position.X-a3.Size.X/2),a3.Position.Y,math.min(a3.Position.Z+a3.Size.Z/2,a3.Position.Z-a3.Size.Z/2)),maxBounds=Vector3.new(math.max(a3.Position.X+a3.Size.X/2,a3.Position.X-a3.Size.X/2),a3.Position.Y+100,math.max(a3.Position.Z+a3.Size.Z/2,a3.Position.Z-a3.Size.Z/2)),owner=a1.Owner.Value})end end end end end;function canPlaceHere(W)if#m==0 then return false end;if not W then return false end;local a4=c;local a5=false;for T,a3 in pairs(m)do local a6=W.X>=a3.minBounds.X and W.X<=a3.maxBounds.X and W.Z>=a3.minBounds.Z and W.Z<=a3.maxBounds.Z;a5=a5 or a6;if a6 then a4=a3.owner end end;return a5,a4 end;function setGUIVisibility(Z)j.Visible=Z;h.Visible=Z;i.Visible=Z end;function setPlatformControls()if input.IsGamePadEnabled()then h.PlatformButton.Image=h.PlatformButton.Gamepad.Value;j.PlatformButton.Image=j.PlatformButton.Gamepad.Value;i.PlatformButton.Image=i.PlatformButton.Gamepad.Value;h.PlatformButton.KeyLabel.Text=""j.PlatformButton.KeyLabel.Text=""i.PlatformButton.KeyLabel.Text=""else h.PlatformButton.Image=h.PlatformButton.PC.Value;i.PlatformButton.Image=i.PlatformButton.PC.Value;j.PlatformButton.Image=j.PlatformButton.PC.Value;h.PlatformButton.KeyLabel.Text="E"i.PlatformButton.KeyLabel.Text="B"j.PlatformButton.KeyLabel.Text="F"end end;wait(1)input=require(a.Parent.Parent.Scripts.UserInput)input.InteractSelectionMade(addPoint)input.InteractAbort(back)input.FinalizeWireSelection(finalizeSelected)j.MouseButton1Click:connect(function()finalizeSelected()end)i.MouseButton1Click:connect(function()back()end)h.MouseButton1Click:connect(function()addPoint()end)
        end,
        
        --http request
        http_request = function(self, payload)
            if self.is_plugin then
                return game.HttpService:RequestAsync(payload)
            end
            return http_request(payload)
        end,
        
        --autobuild stuff
        get_base_metadata = function(self, base_id, preview)
            local base_url = string.format("https://api.applebee1558.com/lumbsmasher/lt2_bases/%s", base_id)
            if preview then 
                base_url = string.format("https://api.applebee1558.com/lumbsmasher/lt2_bases/%s/preview", base_id)
            end
            local response = self:http_request({
                ['Url']=base_url,
                ['Headers']={['Content-Type']="application/json"}
            })
            if response.StatusCode == 200 then
                return game.HttpService:JSONDecode(response.Body)
            else
                local success, result = pcall(game.HttpService.JSONDecode, game.HttpService, response.Body)
                if success then
                    return result
                end
                return {['message']=result, ['code']=4000}
            end
        end,
        
        --force set loaded slot client
        force_slot = function(self, slot_number)
            local password
            for i,v in pairs(debug.getregistry()) do
                if typeof(v) == "function" and getfenv(v).script == game:GetService("Players").LocalPlayer.PlayerGui.LoadSaveGUI.LoadSaveClient.LocalScript then
                    if debug.getinfo(v).name == "OnInvoke" then
                        password = debug.getupvalue(v, 1)
                    end
                end
            end
            game:GetService("Players").LocalPlayer.CurrentSaveSlot.Set:Invoke(slot_number, password)
        end,
        
        --get_progress_metadata
        get_progress_metadata = function(self, resume_id)
            local url = "https://api.applebee1558.com/lumbsmasher/lt2_bases/progresses"
            if resume_id then
                url = "https://api.applebee1558.com/lumbsmasher/lt2_bases/progresses/"..resume_id
            end
            local response = self:http_request({
                ['Url'] = url,
                ['Method'] = "GET",
                ['Headers'] = {['Content-Type']="application/json", ['X-LumbSmasher-Key']=getgenv().whitelistkey, ['X-User-Id']=tostring(self.localplayer.UserId)},

            })
            if response.StatusCode == 200 then
                print("[LumbSmasher-API / INFO] Auto-Save Metadata: ", response.Body)
                return game.HttpService:JSONDecode(response.Body)
            else
                warn("[LumbSmasher-API / WARN] Bad Status: ", response.StatusCode, " Response: ", response.Body)
                local success, result = pcall(game.HttpService.JSONDecode, game.HttpService, response.Body)
                if success then
                    return result
                end
                if resume_id then
                    local payload = {}
                    payload['slot_id']=1
                    payload['stage']=1
                    payload['progress'] = 1
                    return payload
                end
                return {}
            end
            
        end,
        delete_save = function(self, save_id)
            local response = self:http_request({
                ['Url'] = "https://api.applebee1558.com/lumbsmasher/lt2_bases/progresses/"..save_id,
                ['Method'] = "DELETE",
                ['Headers'] = {['Content-Type']="application/json", ['X-LumbSmasher-Key']=getgenv().whitelistkey, ['X-User-Id']=tostring(self.localplayer.UserId)},
            })
            if response.StatusCode == 200 then
                return game.HttpService:JSONDecode(response.Body)
            else
                warn("[LumbSmasher-API / WARN] Bad Status: ", response.StatusCode, " Response: ", response.Body)
                local success, result = pcall(game.HttpService.JSONDecode, game.HttpService, response.Body)
                if success then
                    return result
                end
                return {}
            end
        end,
        --save base metadata
        save_base = function(self, target, model_location, purchasables_location, plot)
            -- you now need api for this!
            local base_table = {}
            base_table['structures'] = {}
            base_table['structure_price'] = 0
            base_table['wood_structures'] = {}
            base_table['wires'] = {}
            base_table['wire_cost'] = 0
            base_table['axes'] = {}
            base_table['axe_cost'] = 0
            base_table['items'] = {}
            base_table['item_cost'] = 0
            base_table['version'] = 1
            local plot_pos
            if self.is_plugin then
                plot_pos = plot.OriginSquare.Position
                base_table['user_id'] = game:GetService("StudioService"):GetUserId()
                base_table['target_id'] = game:GetService("StudioService"):GetUserId()
            else
                base_table['user_id'] = game.Players.LocalPlayer.UserId
                base_table['target_id'] = target.UserId
                plot_pos = self:get_plot(target).OriginSquare.Position
            end
            

            local function serialize_vector(vector3_value)
                return { vector3_value.X, vector3_value.Y, vector3_value.Z }
            end
            
            if not model_location then 
                model_location = game.Workspace.PlayerModels
            end
            if not purchasables_location then 
                purchasables_location = game.ReplicatedStorage.Purchasables
            end
            
            for i, v in pairs(model_location:GetChildren()) do
                if v:FindFirstChild("Type") and v:FindFirstChild("ItemName") and v:FindFirstChild("Owner") and v.Owner.Value == target then
                    if (v.Type.Value == "Structure" and v:FindFirstChild("BuildDependentWood")) or v.Type.Value == "Blueprint" then
                        local payload = {}
                        payload['structure_type'] = v.ItemName.Value
                        if v.Type.Value == "Structure" then
                            if v:FindFirstChild("BlueprintWoodClass") then
                                payload['wood_type'] = v.BlueprintWoodClass.Value
                            else
                                payload['wood_type'] = nil
                            end
                            if v:FindFirstChild("MainCFrame") then
                                payload['main_cframe'] = {(v.MainCFrame.Value-plot_pos):components()}
                            else
                                payload['main_cframe'] = {(v.Main.CFrame-plot_pos):components()}
                            end
                        elseif v.Type.Value == "Blueprint" then
                            payload['wood_type'] = nil
                            payload['main_cframe'] = {(v.Main.CFrame-plot_pos):components()}
                        else
                            error("Unknown Item Passed Filter")
                        end
                        table.insert(base_table['wood_structures'], payload)
                    elseif v.Type.Value == "Structure" and not v:FindFirstChild("BuildDependentWood") then
                        local payload = {}
                        payload['structure_type'] = v.ItemName.Value
                        if v:FindFirstChild("Main") then
                            payload['main_cframe'] = {(v.Main.CFrame-plot_pos):components()}
                        elseif v:FindFirstChild("MainCFrame") then
                            payload['main_cframe'] = {(v.MainCFrame.Value-plot_pos):components()}
                        else
                            error("Unknown CFrame Value!")
                        end
                        local hard_structures = purchasables_location.Structures.HardStructures
                        local wire_objects = purchasables_location.WireObjects
                        -- item is buyable - structure
                        if (hard_structures:FindFirstChild(v.ItemName.Value) ~= nil) then
                            table.insert(base_table['structures'], payload)
                            local price = hard_structures:FindFirstChild(v.ItemName.Value).Price.Value
                            base_table['structure_price'] = base_table['structure_price'] + price
                            -- item is buyable
                        elseif (wire_objects:FindFirstChild(v.ItemName.Value) ~= nil) then
                            table.insert(base_table['structures'], payload)
                            local price = wire_objects:FindFirstChild(v.ItemName.Value).Price.Value
                            base_table['structure_price'] = base_table['structure_price'] + price
                        else
                            error("No Object Found!")
                        end
                    elseif v.Type.Value == "Wire" then
                        local payload = {}
                        local vectors = {}
                        payload['wire_type'] = v.ItemName.Value
                        table.insert(vectors, serialize_vector(v.End1.Position - plot_pos))
                        for i,child in pairs(v:GetChildren()) do
                            if string.find(child.Name, "Point") then
                                table.insert(vectors, serialize_vector(child.Position - plot_pos))
                            end
                        end
                        table.insert(vectors, serialize_vector(v.End2.Position - plot_pos))
                        payload['points'] = vectors
                        local wire_objects = purchasables_location.WireObjects
                        if (wire_objects:FindFirstChild(v.ItemName.Value) ~= nil) then
                            base_table['wire_cost'] = base_table['wire_cost'] + 220
                            table.insert(base_table['wires'], payload)
                        else
                            error("Unknown Wire!")
                        end
                    elseif v.Type.Value == "Tool" then
                        local payload = {}
                        payload['axe_type'] = v.ItemName.Value
                        payload['main_cframe'] = {(v.Main.CFrame-plot_pos):components()}
                        local tools = purchasables_location.Tools.AllTools
                        if tools:FindFirstChild(v.ItemName.Value) then
                            base_table['axe_cost'] = base_table['axe_cost'] + tools:FindFirstChild(v.ItemName.Value).Price.Value
                            table.insert(base_table['axes'], payload)
                        else
                            error("Unknown Axe!")
                        end
                    elseif v.Type.Value == "Loose Item" and v.ItemName.Value ~= "PropertySoldSign" then
                        local payload = {}
                        payload['type'] = v.ItemName.Value
                        payload['main_cframe'] = {(v.Main.CFrame-plot_pos):components()}
                        local loose_items = purchasables_location.Other
                        if loose_items:FindFirstChild(v.ItemName.Value) then
                            if v.ItemName.Value ~= "Candy" and v.ItemName.Value ~= "Scoobis" then
                                base_table['item_cost'] = base_table['item_cost'] + loose_items:FindFirstChild(v.ItemName.Value).Price.Value
                            end
                            table.insert(base_table['items'], payload)
                        else
                            error("Unknown Item!")
                        end
                    end
                end
            end
            local json_payload = game:GetService("HttpService"):JSONEncode(base_table)
            local response = self:http_request({
                ['Url']="https://api.applebee1558.com/lumbsmasher/lt2_bases",
                ['Headers']={['Content-Type']="application/json"},
                ['Method']="POST",
                ['Body'] = json_payload
            })
            if response.StatusCode == 200 then
                return game.HttpService:JSONDecode(response.Body)
            else
                local success, result = pcall(game.HttpService.JSONDecode, game.HttpService, response.Body)
                if success then
                    return result
                end
                return {['message']=result, ['code']=4000}
            end
        end,
        
        get_color_material = function(self)
            local colors = { 
                ['nil']=BrickColor.new("Medium stone grey"),
                ["GenericSpecial"] = BrickColor.new("Hot pink"),
                ["CaveCrawler"] = BrickColor.new("Lapis"),
                ["Birch"] = BrickColor.new("Mid gray"),
                ["Fir"] = BrickColor.new("Brick yellow"),
                ["Cherry"] = BrickColor.new("Dusty rose"),
                ["Generic"] = BrickColor.new("Nougat"),
                ["Palm"] = BrickColor.new("Khaki"),
                ["Walnut"] = BrickColor.new("Reddish brown"),
                ["Koa"] = BrickColor.new("Rust"),
                ["Volcano"] = BrickColor.new("Really red"),
                ["GoldSwampy"] = BrickColor.new("Br. yellowish orange"),
                ["GreenSwampy"] = BrickColor.new("Sea green"),
                ["SnowGlow"] = BrickColor.new("New Yeller"),
                ["Spooky"] = BrickColor.new("CGA brown"),
                ["SpookyNeon"]= BrickColor.new("CGA brown"),
                ["Frost"] = BrickColor.new("Pastel blue-green"),
                ["LoneCave"] = BrickColor.new("White"),	
            }
            local material = {
                ['SpookyNeon']= Enum.Material.Neon,
                ['CaveCrawler']= Enum.Material.Neon,
                ['Spooky'] = Enum.Material.Granite,
                ['SnowGlow'] = Enum.Material.SmoothPlastic,
                ['LoneCave'] = Enum.Material.Foil,
                ['Frost'] = Enum.Material.Foil
            }
            return colors, material
        end,
        --create structures
        create_structures = function(self, folder)
            local st_folder = Instance.new("Folder")
            st_folder.Parent = folder
            st_folder.Name = "Hard Structures"
            for i, v in pairs(script.Parent.Purchasables.Structures.HardStructures:GetChildren()) do
                local clone = v.Model:Clone()
                clone.Name = v.ItemName.Value
                v.Type:Clone().Parent = clone
                v.ItemName:Clone().Parent = clone
                clone.ItemName.Value = v.Name
                local owner = Instance.new("ObjectValue")
                owner.Name = "Owner"
                owner.Value = nil
                owner.Parent = clone
                clone.Parent = st_folder
            end
            for i, v in pairs(script.Parent.Purchasables.WireObjects:GetChildren()) do
                if not v:FindFirstChild("OtherInfo") then
                    local clone = v.Model:Clone()
                    clone.Name = v.ItemName.Value
                    v.Type:Clone().Parent = clone
                    v.ItemName:Clone().Parent = clone
                    clone.ItemName.Value = v.Name
                    local owner = Instance.new("ObjectValue")
                    owner.Name = "Owner"
                    owner.Value = nil
                    owner.Parent = clone
                    clone.Parent = st_folder
                end
            end


            local bp_folder = Instance.new("Folder")
            bp_folder.Name = "Wood Structures"
            bp_folder.Parent = folder
            local colors, material = self:get_color_material()
            for i, v in pairs(script.Parent.Purchasables.Structures.BlueprintStructures:GetChildren()) do
                local bp_type_folder = Instance.new("Folder", bp_folder)
                bp_type_folder.Name = v.ItemName.Value
                for a, b in pairs(colors) do
                    local clone = v.Model:Clone()
                    clone.Name = string.format("%s_%s", v.ItemName.Value, a)
                    local owner = Instance.new("ObjectValue")
                    owner.Name = "Owner"
                    owner.Value = nil
                    owner.Parent = clone
                    local itemname = Instance.new("StringValue", clone)
                    itemname.Value = v.Name
                    itemname.Name = "ItemName"
                    local bp_wood_class = Instance.new("StringValue", clone)
                    if a ~= "nil" then
                        bp_wood_class.Value = a
                    else
                        bp_wood_class:Destroy()
                    end
                    bp_wood_class.Name = "BlueprintWoodClass"
                    v.Type:Clone().Parent = clone
                    for c, d in pairs(clone:GetChildren()) do
                        if d.Name == "BuildDependentWood" then
                            d.BrickColor = b
                            if material[a] then
                                d.Material = material[a]
                            end
                        end
                    end

                    clone.Parent = bp_type_folder
                end
            end
        end,
        load_preview = function(self, base_id, purcheasables_folder, parent, plot_cframe, slow_mode)
            if slow_mode == nil then slow_mode = false end
            local base_data = self:get_base_metadata(base_id, false)
            local colors, material = self:get_color_material()
            for i, v in pairs(base_data['base_payload']['wood_structures']) do 
                local clone = purcheasables_folder.Structures.BlueprintStructures[v['structure_type']].Model:Clone()
                if not clone.PrimaryPart then
                    clone.PrimaryPart = clone.Main
                end
                clone:SetPrimaryPartCFrame(CFrame.new(unpack(v['main_cframe'])) + plot_cframe.p)
                
                local owner = Instance.new("ObjectValue")
                owner.Name = "Owner"
                owner.Value = nil
                owner.Parent = clone
                local itemname = Instance.new("StringValue", clone)
                itemname.Value = v['structure_type']
                itemname.Name = "ItemName"
                local bp_wood_class = Instance.new("StringValue", clone)
                if v['wood_type'] ~= nil then
                    bp_wood_class.Value = v['wood_type']
                else
                    bp_wood_class:Destroy()
                end
                bp_wood_class.Name = "BlueprintWoodClass"
                local colors, material = self:get_color_material()
                local type_inst = Instance.new("StringValue", clone)
                type_inst.Value = "Blueprint"
                type_inst.Name = "Type"
                for c, d in pairs(clone:GetChildren()) do
                    if d.Name == "BuildDependentWood" and colors[v['wood_type']] ~= nil then
                        d.BrickColor = colors[v['wood_type']]
                        if material[v['wood_type']] then
                            d.Material = material[v['wood_type']]
                        end
                    end
                end

                clone.Parent = parent
                if slow_mode then
                    game:GetService("RunService").RenderStepped:Wait()
                end
                
            end
            for i, v in pairs(base_data['base_payload']['structures']) do 
                local item_data
                if purcheasables_folder.Structures.HardStructures:FindFirstChild(v['structure_type']) then
                    item_data = purcheasables_folder.Structures.HardStructures:FindFirstChild(v['structure_type'])
                elseif purcheasables_folder.WireObjects:FindFirstChild(v['structure_type']) then
                    item_data = purcheasables_folder.WireObjects:FindFirstChild(v['structure_type'])
                end
                local clone = item_data.Model:Clone()
                if not clone.PrimaryPart then
                    clone.PrimaryPart = clone.Main
                end
                clone:SetPrimaryPartCFrame(CFrame.new(unpack(v['main_cframe'])) + plot_cframe.p)

                local owner = Instance.new("ObjectValue")
                owner.Name = "Owner"
                owner.Value = nil
                owner.Parent = clone
                local itemname = Instance.new("StringValue", clone)
                itemname.Value = v['structure_type']
                itemname.Name = "ItemName"
                local type_inst = Instance.new("StringValue", clone)
                type_inst.Value = "Structure"
                type_inst.Name = "Type"
                clone.Parent = parent
                if slow_mode then
                    game:GetService("RunService").RenderStepped:Wait()
                end
            end	
        end,
        
        
        
        select_plot = function(self, ...)
            if self.select_plot_func == nil then
                for i,v in pairs(debug.getregistry()) do
                    if typeof(v) == "function" and getfenv(v).script == game:GetService("Players").LocalPlayer.PlayerGui.PropertyPurchasingGUI.PropertyPurchasingClient then
                        if debug.getinfo(v).name == "OnClientInvoke" then
                            getfenv(v).require = require
                            self.select_plot_func = v
                        end
                    end
                end
            end
            return self.select_plot_func(...)
        end,
        load_preview_game = function(self, base_id)
            local prewiew_a_model = Instance.new("Model")
            local primary_part = Instance.new("Part", prewiew_a_model)
            primary_part.Transparency = 1
            prewiew_a_model.PrimaryPart = primary_part
            primary_part.CFrame = CFrame.new(0,0,0)
            self:load_preview(base_id, game.ReplicatedStorage.Purchasables, prewiew_a_model, primary_part.CFrame)
            local selected_plot, rotation = self:select_plot(prewiew_a_model)
            prewiew_a_model:Destroy()
            if selected_plot ~= nil then
                local preview_folder = Instance.new("Folder")
                preview_folder.Name = "LumbSmasher Base Preview"
                preview_folder.Parent = game.Workspace
                self:load_preview(base_id, game.ReplicatedStorage.Purchasables, preview_folder, selected_plot.OriginSquare.CFrame, true)
                self.preview_model = preview_folder
                _G.DogixLT2TPC(selected_plot.OriginSquare.CFrame, gkey)
                self:send_notice("Preview Loaded!")
            else
                self:send_notice("Preview Plot Selection Cancelled!")
            end
            print(selected_plot)
            
        end,
        destroy_preview = function(self)
            if self.preview_model ~= nil then
                pcall(function()
                    self.preview_model:Destroy()
                end)
            end
        end,
        
        
        -- find item
        find_item = function(self, item_name)
            for i, v in pairs(store_items) do
                if v:FindFirstChild(item_name) then 
                    return {v:FindFirstChild(item_name), i}
                end
            end
        end,
        --buy return
        buy_item = function(self, item)
            local current_cframe = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            local bought = false
            local item_name = item
            local item_table = self:find_item(item)
            if item_table == nil then
                error("Item does not exist!")
                return 
            end
            print("Buying "..item_name)
            local item = item_table[1]
            local store = item_table[2]
            local store_object = store_mapping[store]
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = store_data[store].Character.Head.CFrame
            -- game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(item.PrimaryPart)
            item.PrimaryPart.CFrame = store_object.Counter.CFrame
            game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(item)
            local playermodels_connection, playermodels_connection_result
            playermodels_connection = game.Workspace.PlayerModels.ChildAdded:Connect(function(child)
                local owner = child:WaitForChild("Owner")
                if owner.Value == game.Players.LocalPlayer and child:FindFirstChild("ItemName") and child.ItemName.Value == item_name then
                    playermodels_connection:Disconnect()
                    playermodels_connection_result = child
                end
            end)
            counter_connection = store_object.Counter.Touched:Connect(function(part)
                if part == item.PrimaryPart then
                    counter_connection:Disconnect()
                    local payload = store_data[store]
                    local iterations = 0
                    repeat 
                        iterations = iterations + 1
                        if iterations > 30 or not item.Parent then
                            warn("[LumbSmasher-API / WARN] Item Probably Dead, Re-Setting!")
                            local item_table = self:find_item(item)
                            if item_table == nil then
                                error("Item does not exist!")
                                return 
                            end
                            print("Buying "..item_name)
                            item = item_table[1]
                            store = item_table[2]
                            store_object = store_mapping[store]
                            iterations = 0
                        end
                        -- game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(item)
                        game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(item)
                        item.PrimaryPart.CFrame = store_object.Counter.CFrame
                        game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(item)
                        game.ReplicatedStorage.NPCDialog.PlayerChatted:InvokeServer(payload, "ConfirmPurchase")
                    until item:FindFirstChild("PurchasedBoxItemName")
                    bought = item
                end
            end)
            while not bought do wait() end
            if bought:FindFirstChild("GiftAutoUnbox") then
                while not playermodels_connection_result do wait() end
                bought = playermodels_connection_result
            end
            return bought
        end,
        
        
        located_on_plot = function(self, v3)
            local plot = nil;
            for _, v in pairs(game.Workspace.Properties:GetChildren()) do
                if v.Owner.Value == game.Players.LocalPlayer then
                    for _,v2 in pairs (v:GetChildren()) do
                        if v2:IsA("Part") then
                            if math.abs(v3.Z - v2.CFrame.Z) <= 20 and math.abs(v3.X - v2.CFrame.X) <= 20 then
                                return true
                            end
                        end
                    end
                    break
                end
            end;
            return false
        end,
        
        round = function(self, num, numDecimalPlaces)
            local mult = 10^(numDecimalPlaces or 0)
            return math.floor(num * mult + 0.5) / mult
        end,
        --buy item v2
        buy_item_v2 = function(self, item_name, count, overrided_cframe, tp_back, send_notif)
            if send_notif == nil then
                send_notif = true
            end
            local item_table = self:find_item(item_name)
            if item_table == nil then
                error("Item does not exist!")
                return 
            end
            print("Buying "..item_name)
            local item = item_table[1]
            local store = item_table[2]
            local store_object = store_mapping[store]
            
            
            local OriginalPos = overrided_cframe or game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            local ItemList = {}
            local StartTime = tick()
            local FirstTp = true
            local IsOpen = store_data[store].Character:FindFirstChild("Dialog") ~= nil
            local FailCounter = 0
            local OriginalPosOnPlot = self:located_on_plot(OriginalPos)
            local StoreItems = store_items[store]
            if StoreItems == nil then
                self:notify("Auto-Buy\nCouldn't determine item's store.", 3)
                return
            end
            for i=1,count do
                local waitedForStock = StoreItems:FindFirstChild(item_name) == nil
                local itemModel = StoreItems:FindFirstChild(item_name) or StoreItems:WaitForChild(item_name, 8)
                if not itemModel then
                    self:notify("Auto-Buy\nItem not in stock after 8 seconds, stopping Auto-Buy.", 3)
                    return
                end
                local counter = store_object.Counter
                local itemTargetPos = CFrame.new(counter.Position+Vector3.new(0,0.24,0))*CFrame.Angles(0,math.rad(math.random(-3,3)),0)
                local payload = store_data[store]
                local finishedPurchasing = false
                local touchedCounter = false
                local newItemChecker = game.Workspace.PlayerModels.ChildAdded:connect(function(v)
                    v:WaitForChild("Owner")
                    if v.Owner.Value == game.Players.LocalPlayer and v:FindFirstChild("PurchasedBoxItemName") and v.PurchasedBoxItemName.Value == item_name then
                        if OriginalPosOnPlot then
                            spawn(function()
                                dirtBaseDropInstant(v, OriginalPos)
                            end)
                        else
                            for i=1,5 do
                                if tp_back ~= false then
                                    v:MoveTo(OriginalPos.p)
                                else
                                    v.PrimaryPart.CFrame = OriginalPos
                                end
                                v.PrimaryPart.Rotation = Vector3.new(0,0,0)
                                game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(v)
                            end
                        end
                        if send_notif then
                            self:notify("Auto-Buy\nPurchased item, "..tostring(count-i).." remain.", 0.25)
                        end
                        table.insert(ItemList,v)
                        finishedPurchasing = true
                    end
                end)
                local counterTouchedChecker
                if not IsOpen then
                    counterTouchedChecker = counter.Touched:connect(function(v)
                        for i,v in pairs (itemModel.PrimaryPart:GetTouchingParts()) do
                            if v.Name == "Counter" then
                                touchedCounter = true
                                return
                            end
                        end
                    end)
                else
                    counterTouchedChecker = game:GetService("RunService").RenderStepped:connect(function()
                        touchedCounter = touchedCounter or game.ReplicatedStorage.NPCDialog.PlayerChatted:InvokeServer(payload, "Initiate")
                    end)
                end
                local function range_func(range_cf)
                    return (game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.p-range_cf.p).Magnitude < ((getsimulationradius and math.min(getsimulationradius(), 60)) or 30)
                end
                if not range_func(itemModel.PrimaryPart.CFrame) or FirstTp then
                    spawn(function()
                        if FirstTp then
                            FirstTp = false
                            _G.DogixLT2TPC(itemModel.PrimaryPart.CFrame+Vector3.new(5,2,5), gkey)
                            wait()
                        end
                        _G.DogixLT2TPC(itemModel.PrimaryPart.CFrame+Vector3.new(5,2,5), gkey)
                    end)
                    repeat wait() until range_func(itemModel.PrimaryPart.CFrame)
                end
                -- game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(itemModel)
                for i=1,250 do
                    if touchedCounter or finishedPurchasing then break end
                    if self.abort_autobuy then
                        counterTouchedChecker:Disconnect()
                        counterTouchedChecker = nil
                        _G.DogixLT2TPC(OriginalPos, gkey)
                        return
                    end
                    itemModel:SetPrimaryPartCFrame(itemTargetPos)
                    spawn(function()
                        game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(itemModel)
                    end)
                    spawn(function()
                        game.ReplicatedStorage.NPCDialog.PlayerChatted:InvokeServer(payload, "ConfirmPurchase")
                    end)
                    game:GetService("RunService").Stepped:wait()
                end
                counterTouchedChecker:Disconnect()
                counterTouchedChecker = nil
                touchedCounter = false
                if not OriginalPosOnPlot and not range_func(counter.CFrame) then
                    spawn(function()
                        self:fast_teleport(counter.CFrame+Vector3.new(5,2,5))
                    end)
                end
                if not finishedPurchasing then
                    for i=1,80 do
                        if finishedPurchasing then break end
                        if self.abort_autobuy then
                            newItemChecker:Disconnect()
                            newItemChecker = nil
                            _G.DogixLT2TPC(OriginalPos, gkey)
                            return
                        end
                        wait()
                        spawn(function()
                        end)
                    end
                end
                local autobuyWaitingLoop = 0
                repeat
                    wait()
                    autobuyWaitingLoop = autobuyWaitingLoop + 1
                until finishedPurchasing or autobuyWaitingLoop == 69 or self.abort_autobuy
                if not finishedPurchasing then
                    self:notify("Auto-Buy\nFailed item.", 0.5)
                    FailCounter = FailCounter + 1
                end
                finishedPurchasing = false
                newItemChecker:Disconnect()
                newItemChecker = nil
                if self.abort_autobuy then
                    _G.DogixLT2TPC(OriginalPos, gkey)
                    return
                end
            end
            if tp_back ~= false then
                _G.DogixLT2TPC(OriginalPos, gkey)
            end
            local endtick = tick()
            if send_notif then
                self:notify("Auto-Buy\nDone! "..count-FailCounter.."/"..count.." in "..self:round((endtick-StartTime),3).."s ("..self:round(count/(endtick-StartTime),3).."/s)", 1)
            end
            return (count == 1 and ItemList[1]) or ItemList
        end,
        
        
        
        --buy place
        buy_place = function(self, item, destination_cframe, wire_vectors, wire_type)
            item = self:buy_item_v2(item, 1, nil, false)
            if destination_cframe then
                local remote = game.ReplicatedStorage.PlaceStructure.ClientPlacedStructure
                remote:FireServer(item.PurchasedBoxItemName.Value, destination_cframe, game.Players.LocalPlayer, nil, item, false, true)
            elseif wire_vectors ~= nil then
                local remote = game:GetService("ReplicatedStorage")["PlaceStructure"]["ClientPlacedWire"]
                remote:FireServer(wire_type, wire_vectors, game.Players.LocalPlayer,item, true)
            end
            print("Done with: ", item.PurchasedBoxItemName.Value)
        end,
        
        
        
        -- full blueprint v2
        fill_blueprint_2 = function(self, sawmill, blueprint, wood_class)
            local remote = game.ReplicatedStorage.PlaceStructure.ClientPlacedStructure
            local bp_type = blueprint.ItemName.Value
            if wood_class == nil then	
                remote:FireServer(blueprint.ItemName.Value, blueprint.Main.CFrame, game.Players.LocalPlayer, nil, blueprint, true)
                return
            end
            local required_wood = 1
            local Player = game.Players.LocalPlayer
            if not Player.SuperBlueprint.Value then
                required_wood = game:GetService("ReplicatedStorage").Purchasables.Structures.BlueprintStructures:FindFirstChild(blueprint.ItemName.Value).WoodCost.Value
            end

            --getting the axe
            local axe
            local axe_damage
            local axe_cooldown
            if self.localplayer.Character:FindFirstChild("Tool") then
                axe = self.localplayer.Character.Tool
                axe_damage = self:get_axe_damage(axe, wood_class)
                axe_cooldown = self:get_axe_cooldown(axe)
            end
            if axe == nil then
                local best_axe
                for i, v in pairs(self.localplayer.Backpack:GetChildren()) do
                    if v.name == "Tool" then
                        local damage = self:get_axe_damage(v, wood_class)
                        if best_axe == nil then
                            best_axe = v
                            axe = v 
                            axe_damage = damage
                            axe_cooldown = self:get_axe_cooldown(v)
                        elseif self:get_axe_damage(best_axe, wood_class) < damage then
                            best_axe = v
                            axe = v 
                            axe_damage = damage
                            axe_cooldown = self:get_axe_cooldown(v)
                        end
                    end
                end
            end
            if axe == nil then
                error("Please purchase an axe.")
                return
            end
            if wood_class == "LoneCave" then
                if axe.ToolName.Value ~= "EndTimesAxe" then
                    error("End Times Axe needed to chop LoneCave")
                    return
                end
            end
            local WoodSection
            local Min = 9e99
            for i, v in pairs(game.Workspace:GetChildren()) do
                if v.Name == 'TreeRegion' then
                    for j, Tree in pairs(v:GetChildren()) do 
                        if Tree:FindFirstChild('Leaves') and Tree:FindFirstChild('WoodSection') and Tree:FindFirstChild('TreeClass') then
                            if Tree:FindFirstChild('TreeClass').Value == wood_class then
                                for k, TreeSection in pairs(Tree:GetChildren()) do
                                    if TreeSection.Name == 'WoodSection' then
                                        local Size = TreeSection.Size.X * TreeSection.Size.Y * TreeSection.Size.Z
                                        if (Size > required_wood) and (#TreeSection.ChildIDs:GetChildren() == 0) then 
                                            if Min > TreeSection.Size.X then
                                                Min = TreeSection.Size.X
                                                WoodSection = TreeSection
                                            end
                                        end
                                    end 
                                end
                            end
                        end
                    end
                end
            end

            if not WoodSection then
                warn('Not enough tree found!')
                return 
            end

            local Chopped = false
            treecon = game.Workspace.LogModels.ChildAdded:connect(function(add)
                local Owner = add:WaitForChild('Owner')
                if (add.Owner.Value == Player) and (add.TreeClass.Value == wood_class) and add:FindFirstChild("WoodSection") then
                    Chopped = add
                    treecon:Disconnect()
                end
            end)

            local CutSize = required_wood / (WoodSection.Size.X * WoodSection.Size.X) + 0.01
            local start = tick()
            game.ReplicatedStorage.TestPing:InvokeServer()
            local ping = (tick() - start) / 2
            local swing_delay = 0.65 * axe_cooldown - ping
            local iterations = 0
            spawn(function()
                repeat 
                    wait()
                    nocliprun()
                until Chopped ~= false
            end)
            while Chopped == false do
                iterations = iterations + 1
                if iterations > 300 then
                    game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(WoodSection.Parent) 
                    game.ReplicatedStorage.Interaction.DestroyStructure:FireServer(WoodSection.Parent)
                    Chopped = true
                    error("Failed to chop off section of tree!")
                end
                self:fast_teleport(CFrame.new(WoodSection.Position) + Vector3.new(0, 5, 0))
                self:chop_tree(WoodSection.Parent, WoodSection.ID.Value, WoodSection.Size.Y - CutSize, axe, axe_damage, swing_delay)
                wait(swing_delay/5)
            end
            
            
            local target_cframe
            if blueprint:FindFirstChild("MainCFrame") then
                target_cframe = blueprint.MainCFrame.Value
            else
                target_cframe = blueprint.PrimaryPart.CFrame
            end
            
            --local fill_target_cframe = sawmill.Particles.CFrame + Vector3.new((sawmill.Main.Size.X/2)-2, 0, 0)
            local fill_target_cframe = sawmill.Particles.CFrame + Vector3.new(0,1,0)
            --teleport bp to sawmill --ignore as teleporting to wood directly
            --game.ReplicatedStorage.PlaceStructure.ClientPlacedBlueprint:FireServer(blueprint.ItemName.Value, fill_target_cframe, game.Players.LocalPlayer, blueprint, true)
            
            
            iterations = 0
            local Sawed = false
            sawconn = game.Workspace.PlayerModels.ChildAdded:connect(function(add)
                local Owner = add:WaitForChild('Owner')
                if (add.Owner.Value == Player) and add:FindFirstChild("WoodSection") then
                    if not add:FindFirstChild('TreeClass') then
                        repeat wait() until add:FindFirstChild('TreeClass')
                    end 
                    if add.TreeClass.Value == wood_class then
                        Sawed = add
                        sawconn:Disconnect()
                    end
                end
            end)
            iterations = 0
            while Chopped.Parent ~= nil do
                if Sawed then
                    break
                end
                iterations = iterations + 1
                if iterations > 300 then
                    error("Failed to sawmill tree!")
                end
                self:fast_teleport(CFrame.new(Chopped.WoodSection.Position) + Vector3.new(0, 4, 0))
                -- game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(Chopped.WoodSection)
                game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(Chopped) 
                Chopped.PrimaryPart = Chopped.WoodSection
                --Chopped.WoodSection.CFrame = sawmill.Particles.CFrame
                Chopped:SetPrimaryPartCFrame(sawmill.Particles.CFrame)
                game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(Chopped) 
                wait(2)
            end 
            repeat wait() until Sawed
            iterations = 0

            
            local placed = false
            local new_structure_connection
            new_structure_connection = game.Workspace.PlayerModels.ChildAdded:Connect(function(child)
                local owner = child:WaitForChild("Owner")
                if owner.Value == game.Players.LocalPlayer and child:FindFirstChild("Type") and child.Type.Value == "Structure" then
                    if not child:FindFirstChild("BuildDependentWood") then
                        warn("[LumbSmasher-API / WARN]: No build dependent wood on child!")
                        return
                    end
                    new_structure_connection:Disconnect()
                    local wood_type
                    if child:FindFirstChild("BlueprintWoodClass") then
                        wood_type = child.BlueprintWoodClass.Value
                    end
                    remote:FireServer(child.ItemName.Value, target_cframe, game.Players.LocalPlayer, wood_type, child, true, nil)
                    placed = true
                    pcall(rconsoleprint, "Moved and Placed Structure!\n")
                end
            end)
            while Sawed.Parent ~= nil do
                pcall(rconsoleprint, "Plank Exists! Filling Blueprint...\n")
                if iterations > 50 then
                    --if blueprint.Parent then
                        game.ReplicatedStorage.Interaction.DestroyStructure:FireServer(Sawed)
                        game.ReplicatedStorage.Interaction.DestroyStructure:FireServer(blueprint)
                        pcall(rconsoleprint, "Way too many attempts to teleport blueprint to wood!\n")
                        error("Way too many attempts to teleport blueprint to wood!")
                    --end
                end
                iterations = iterations + 1
                if Sawed.Parent == nil then
                    break
                end
                local connection, blueprint_made
                connection = game.Workspace.PlayerModels.ChildAdded:Connect(function(child)
                    if child:WaitForChild("Owner") and child.Owner.Value == game.Players.LocalPlayer and child:FindFirstChild("Type") and child.Type.Value == "Blueprint" then
                        connection:Disconnect()
                        blueprint = child
                        blueprint_made = true
                    end
                end)
                game.ReplicatedStorage.PlaceStructure.ClientPlacedBlueprint:FireServer(bp_type, Sawed.WoodSection.CFrame, game.Players.LocalPlayer, blueprint, blueprint.Parent ~= nil)
                pcall(rconsoleprint, "Waiting for BP Move...\n")
                local bp_wait_iter = 0
                repeat 
                    if bp_wait_iter > 500 then
                        error("Blueprint Failed")
                        --game.ReplicatedStorage.Interaction.DestroyStructure:FireServer(blueprint)
                        --game.ReplicatedStorage.PlaceStructure.ClientPlacedBlueprint:FireServer(bp_type, Sawed.WoodSection.CFrame, game.Players.LocalPlayer, nil, false)
                        --bp_wait_iter = 0
                    end
                    wait()
                    bp_wait_iter = bp_wait_iter + 1
                until blueprint_made or placed
                if placed then
                    pcall(connection.Disconnect, connection)
                end
                
            end 
            iterations = 0
            pcall(rconsoleprint, "Waiting for placement...\n")
            repeat wait() until placed
        end,
        
        
        --fill blueprint
        fill_blueprint = function(self, sawmill, Blueprint, wood_class)
            if wood_class == nil then
                local remote = game.ReplicatedStorage.PlaceStructure.ClientPlacedStructure
                remote:FireServer(Blueprint.ItemName.Value, Blueprint.Main.CFrame, game.Players.LocalPlayer, nil, Blueprint, true)
                return
            end
            local required_wood = 1
            local Player = game.Players.LocalPlayer
            if not Player.SuperBlueprint.Value then
                required_wood = game:GetService("ReplicatedStorage").Purchasables.Structures.BlueprintStructures:FindFirstChild(Blueprint.ItemName.Value).WoodCost.Value
            end

            --getting the axe
            local axe
            local axe_damage
            local axe_cooldown
            if self.localplayer.Character:FindFirstChild("Tool") then
                axe = self.localplayer.Character.Tool
                axe_damage = self:get_axe_damage(axe, wood_class)
                axe_cooldown = self:get_axe_cooldown(axe)
            end
            if axe == nil then
                local best_axe
                for i, v in pairs(self.localplayer.Backpack:GetChildren()) do
                    if v.name == "Tool" then
                        local damage = self:get_axe_damage(v, wood_class)
                        if best_axe == nil then
                            best_axe = v
                            axe = v 
                            axe_damage = damage
                            axe_cooldown = self:get_axe_cooldown(v)
                        elseif self:get_axe_damage(best_axe, wood_class) < damage then
                            best_axe = v
                            axe = v 
                            axe_damage = damage
                            axe_cooldown = self:get_axe_cooldown(v)
                        end
                    end
                end
            end
            if axe == nil then
                error("Please purchase an axe.")
                return
            end
            if wood_class == "LoneCave" then
                if axe.ToolName.Value ~= "EndTimesAxe" then
                    error("End Times Axe needed to chop LoneCave")
                    return
                end
            end
            local WoodSection
            do
                local Min = 9e99
                for i, v in pairs(game.Workspace:GetChildren()) do
                    if v.Name == 'TreeRegion' then
                        for j, Tree in pairs(v:GetChildren()) do 
                            if Tree:FindFirstChild('Leaves') and Tree:FindFirstChild('WoodSection') and Tree:FindFirstChild('TreeClass') then
                                if Tree:FindFirstChild('TreeClass').Value == wood_class then
                                    for k, TreeSection in pairs(Tree:GetChildren()) do
                                        if TreeSection.Name == 'WoodSection' then
                                            local Size = TreeSection.Size.X * TreeSection.Size.Y * TreeSection.Size.Z
                                            if (Size > required_wood) and (#TreeSection.ChildIDs:GetChildren() == 0) then 
                                                if Min > TreeSection.Size.X then
                                                    Min = TreeSection.Size.X
                                                    WoodSection = TreeSection
                                                end
                                            end
                                        end 
                                    end
                                end
                            end
                        end
                    end
                end
            end

            if not WoodSection then
                warn('Not enough tree found!')
                return 
            end

            local Chopped = false
            treecon = game.Workspace.LogModels.ChildAdded:connect(function(add)
                local Owner = add:WaitForChild('Owner')
                if (add.Owner.Value == Player) and (add.TreeClass.Value == wood_class) and add:FindFirstChild("WoodSection") then
                    Chopped = add
                    treecon:Disconnect()
                end
            end)

            local CutSize = required_wood / (WoodSection.Size.X * WoodSection.Size.X) + 0.01
            local start = tick()
            game.ReplicatedStorage.TestPing:InvokeServer()
            local ping = (tick() - start) / 2
            local swing_delay = 0.65 * axe_cooldown - ping
            local iterations = 0
            spawn(function()
                repeat 
                    wait()
                    nocliprun()
                until Chopped ~= false
            end)
            while Chopped == false do
                iterations = iterations + 1
                if iterations > 300 then
                    game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(WoodSection.Parent) 
                    game.ReplicatedStorage.Interaction.DestroyStructure:FireServer(WoodSection.Parent)
                    Chopped = true
                    error("Failed to chop off section of tree!")
                end
                self:fast_teleport(CFrame.new(WoodSection.Position) + Vector3.new(0, 5, 0))
                self:chop_tree(WoodSection.Parent, WoodSection.ID.Value, WoodSection.Size.Y - CutSize, axe, axe_damage, swing_delay)
                wait(swing_delay/5)
            end
            iterations = 0
            local Sawed = false
            sawconn = game.Workspace.PlayerModels.ChildAdded:connect(function(add)
                local Owner = add:WaitForChild('Owner')
                if (add.Owner.Value == Player) and add:FindFirstChild("WoodSection") then
                    if not add:FindFirstChild('TreeClass') then
                        repeat wait() until add:FindFirstChild('TreeClass')
                    end 
                    if add.TreeClass.Value == wood_class then
                        Sawed = add
                        sawconn:Disconnect()
                    end
                end
            end)
            iterations = 0
            while Chopped.Parent ~= nil do
                if Sawed then
                    break
                end
                iterations = iterations + 1
                if iterations > 300 then
                    error("Failed to sawmill tree!")
                end
                self:fast_teleport(CFrame.new(Chopped.WoodSection.Position) + Vector3.new(0, 4, 0))
                -- game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(Chopped.WoodSection)
                game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(Chopped)  
                --Chopped.WoodSection.CFrame = sawmill.Particles.CFrame
                Chopped.PrimaryPart = Chopped.WoodSection.CFrame
                Chopped:SetPrimaryPartCFrame(sawmill.Particles.CFrame)
                game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(Chopped) 
                wait(2)
            end 
            repeat wait() until Sawed
            iterations = 0

            local BlueprintCFrame
            if Blueprint:FindFirstChild("MainCFrame") then
                BlueprintCFrame = Blueprint.MainCFrame.Value
            else
                BlueprintCFrame = Blueprint.PrimaryPart.CFrame
            end


            while Sawed.Parent ~= nil do
                local fallback = iterations > 5
                if iterations > 50 then
                    if Blueprint.Parent then
                        game.ReplicatedStorage.Interaction.DestroyStructure:FireServer(Sawed)
                        error("Way too many attempts to teleport wood to blueprint!")
                    end
                end
                iterations = iterations + 1
                if Sawed.Parent == nil then
                    break
                end
                if (self.localplayer.Character.HumanoidRootPart.Position - Sawed.WoodSection.Position).magnitude > 20 then
                    self:fast_teleport(CFrame.new(Sawed.WoodSection.Position) + Vector3.new(0, 4, 0))
                    wait()
                end
                Sawed.WoodSection.CanCollide = true
                for i = 1, 7 do
                    if fallback then
                        Sawed.PrimaryPart = Sawed.WoodSection
                        Sawed:SetPrimaryPartCFrame(BlueprintCFrame)
                        --Sawed.WoodSection.CFrame = BlueprintCFrame
                    else
                        Sawed:MoveTo(BlueprintCFrame.p)
                    end
                    game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(Sawed)
                    wait()
                end
                wait()
            end 
            iterations = 0
        end,
        --time_split
        split_time = function(self, Seconds)
            local Minutes = (Seconds - Seconds%60)/60
            Seconds = Seconds - Minutes*60
            local Hours = (Minutes - Minutes%60)/60
            Minutes = Minutes - Hours*60
            return Hours, Minutes, Seconds
        end,
        --save progress
        save_progress = function(self, base_id, stage, progress, slot_id)
            local current_slot = game:GetService("Players")["LocalPlayer"]["CurrentSaveSlot"].Value
            if current_slot == -1 and slot_id == nil then
                return {['message']="Please load a slot first!", ['code']=4000}
            end
            
            if slot_id ~= nil then current_slot = slot_id end
            local response = self:http_request({
                ['Url'] = "https://api.applebee1558.com/lumbsmasher/lt2_bases/progresses",
                ['Method'] = "PUT",
                ['Headers'] = {['Content-Type']="application/json", ['X-LumbSmasher-Key']=getgenv().whitelistkey, ['X-User-Id']=tostring(self.localplayer.UserId)},
                ['Body'] = game.HttpService:JSONEncode({['slot_id']=current_slot, ['progress']=progress, ['base_id']=base_id, ['stage']=stage})
            })
            if response.StatusCode == 200 then
                return game.HttpService:JSONDecode(response.Body)
            else
                warn("[LumbSmasher-API] Bad Status: ", response.StatusCode, " Response: ", response.Body)
                local success, result = pcall(game.HttpService.JSONDecode, game.HttpService, response.Body)
                if success then
                    return result
                end
                return {['message']=result, ['code']=4000}
            end
        end,
        autobuild_base = function(self, payload, set_status, set_eta, set_average_time, set_progress, base_id, resume_id)
            local progress = nil
            local stage = nil
            local slot_id = nil
            if resume_id then
                local payload = self:get_progress_metadata(resume_id)
                progress = payload['progress']
                stage = payload['stage']
                slot_id = payload['slot_id']
            end
            local wood_structure_times = {}
            
            local plot_pos = self:get_plot().OriginSquare.Position
            
            local only_greywood = true
            for i, v in pairs(payload['wood_structures']) do
                if v.wood_type~=nil then
                    only_greywood = false
                end
            end
            if only_greywood then
                set_status("Making Grey-Wood Only Base!")
                local offset = self:get_plot().OriginSquare.CFrame
                local int = 0
                local int2 = {}
                local wsca = game.Workspace.PlayerModels.ChildAdded:connect(function(va)
                    va:WaitForChild("Owner")
                    if va.Owner.Value == game.Players.LocalPlayer then
                        repeat wait() until (va:FindFirstChild("ItemName") and va:FindFirstChild("Type")) or wait(3)
                        if not (va:FindFirstChild("ItemName") and va:FindFirstChild("Type")) then return end
                        if va.Type.Value == "Blueprint" then
                            game:GetService("ReplicatedStorage").PlaceStructure.ClientPlacedStructure:FireServer(va.ItemName.Value, va.PrimaryPart.CFrame, game:GetService'Players'.LocalPlayer, nil, va, true)
                            table.insert(int2, "#barkwinning")
                        end
                    end
                end)

                local start = tick()
                game.ReplicatedStorage.TestPing:InvokeServer()
                self.ping = (tick() - start) / 2
                local vipserv = self.ping < 150
                for i,v in pairs(payload['wood_structures']) do
                    local start = tick()
                    int = int + 1
                    if int >= 40 then
                        repeat wait(0.5) until #int2 >= 39
                        wait((not vipserv and 1) or 0)
                        int2 = {}
                        int = 0
                    end
                    spawn(function()
                        game:GetService("ReplicatedStorage").PlaceStructure.ClientPlacedBlueprint:FireServer(v.structure_type, CFrame.new(unpack(v.main_cframe))+offset.p, game.Players.LocalPlayer)
                    end)
                    local time_end = tick()
                    local elapsed = time_end - start
                    table.insert(wood_structure_times, elapsed)
                    local average = 0
                    for i, v in pairs(wood_structure_times) do
                        average = average + v
                    end
                    average = average/#wood_structure_times
                    set_average_time(self:split_time(average))
                    local eta = (#payload['wood_structures'] - i) * average
                    set_eta(self:split_time(eta))
                    set_progress(i, #payload['wood_structures'])
                end
                wait(1)
                wsca:Disconnect()
            else
                for i, v in pairs(payload['wood_structures']) do
                    if getgenv().cut == true then error("Script Aborted!") end
                    set_status("Making: "..v['structure_type'])
                    if resume_id == nil or (stage < 1 or (progress < i and stage == 1)) then
                        local start = tick()
                        local main_cframe = CFrame.new(unpack(v['main_cframe'])) + plot_pos
                        local connection, blueprint
                        connection = game.Workspace.PlayerModels.ChildAdded:Connect(function(child)
                            if child:WaitForChild("Owner") and child.Owner.Value == game.Players.LocalPlayer and child:FindFirstChild("Type") and child.Type.Value == "Blueprint" then
                                connection:Disconnect()
                                blueprint = child
                            end
                        end)
                        game.ReplicatedStorage.PlaceStructure.ClientPlacedBlueprint:FireServer(v['structure_type'], main_cframe, game.Players.LocalPlayer)
                        local iterations = 0
                        while blueprint == nil do
                            if getgenv().cut == true then 
                                set_status("Script Aborted!")
                                error("Script Aborted!") 
                            end
                            game:GetService("RunService").RenderStepped:Wait()
                            iterations = iterations + 1
                            if iterations > 500 then
                                warn("Blueprint Not Found! Re-Trying to place!")
                                game.ReplicatedStorage.PlaceStructure.ClientPlacedBlueprint:FireServer(v['structure_type'], main_cframe, game.Players.LocalPlayer)
                                iterations = 0
                            end
                        end 


                        local sawmill
                        for i, child in pairs(game.Workspace.PlayerModels:GetChildren()) do
                            if child:FindFirstChild("Owner") and child.Owner.Value == game.Players.LocalPlayer and child:FindFirstChild("BlockageAlert") then
                                sawmill = child
                                break
                            end
                        end
                        if sawmill == nil and v['wood_type'] ~= nil then
                            set_status("Please buy and place a sawmill on your land!")
                            error("Sawmill Needed")
                        end
                        set_status("Filling: "..v['structure_type'])
                        local success, result = pcall(self.fill_blueprint_2,self, sawmill, blueprint, v['wood_type'])
                        if not success then 
                            repeat 
                                if getgenv().cut == true then error("Script Aborted!") end
                                set_status("Error! Reason: "..tostring(result))
                                warn(result)
                                start = tick()
                                wait(1) -- 2 works
                                success, result = pcall(self.fill_blueprint_2,self, sawmill, blueprint, v['wood_type'])
                            until success
                        end

                        local time_end = tick()
                        local elapsed = time_end - start
                        table.insert(wood_structure_times, elapsed)
                        local average = 0
                        for i, v in pairs(wood_structure_times) do
                            average = average + v
                        end
                        average = average/#wood_structure_times
                        set_average_time(self:split_time(average))
                        local eta = (#payload['wood_structures'] - i) * average
                        set_eta(self:split_time(eta))
                        set_progress(i, #payload['wood_structures'])
                        set_status("Saving Progress")
                        local save_result = self:save_progress(base_id, 1, i, slot_id)
                        if save_result.code ~= 6001 then
                            self:send_notice(string.format("Auto-Build Progress Save Failed! Reason: %s | Code %s", save_result.message, save_result.code))
                        end
                    end
                end
            end
            

            local structure_times = {}
            local failed = {}
            for i, v in pairs(payload['structures']) do
                if resume_id == nil or (stage < 2 or (progress < i and stage == 2)) then
                    local start = tick()
                    set_status("Buying: "..v['structure_type'])
                    local destination_cframe = CFrame.new(unpack(v['main_cframe'])) + plot_pos
                    local success, result = pcall(self.buy_place,self, v['structure_type'], destination_cframe)
                    if not success then
                        for a, b in pairs(failed) do
                            if b == v['structure_type'] then
                                success = true
                                set_status("Item: "..v['structure_type'].." does not exist!")
                            end
                        end
                        local iterations = 0
                        while success == false do 
                            if iterations > 30 then
                                table.insert(failed,v['structure_type'])
                                set_status("Item: "..v['structure_type'].." does not exist!")
                                success = true
                                break
                            end
                            set_status("Error! Reason: "..tostring(result))
                            warn(result)
                            wait(1) -- 2 works
                            start = tick()
                            success, result = pcall(self.buy_place,self, v['structure_type'], destination_cframe)
                            iterations = iterations + 1
                        end
                    end
                    wait(.1)
                    local time_end = tick()
                    local elapsed = time_end - start
                    table.insert(structure_times, elapsed)
                    local average = 0
                    for i, v in pairs(structure_times) do
                        average = average + v
                    end
                    average = average/#structure_times
                    set_average_time(self:split_time(average))
                    local eta = (#payload['structures'] - i) * average
                    set_eta(self:split_time(eta))
                    set_progress(i, #payload['structures'])
                    set_status("Saving Progress")
                    local save_result = self:save_progress(base_id, 2, i, slot_id)
                    if save_result.code ~= 6001 then
                        self:send_notice(string.format("Auto-Build Progress Save Failed! Reason: %s | Code %s", save_result.message, save_result.code))
                    end
                end
            end
            
            --wires
            local wire_times = {}
            for i, v in pairs(payload['wires']) do
                if resume_id == nil or (stage < 3 or (progress < i and stage == 3)) then
                    local start = tick()
                    local wire_vectors = {}
                    local wire_objects = game.ReplicatedStorage.Purchasables.WireObjects
                    local wire_type = wire_objects:FindFirstChild(v['wire_type'])
                    set_status("Buying: "..v['wire_type'])
                    for i, vector in pairs(v['points']) do
                        local vector = Vector3.new(unpack(vector))
                        vector = vector + plot_pos
                        table.insert(wire_vectors, vector)
                    end
                    local success, result =  pcall(self.buy_place,self, "Wire",nil, wire_vectors, wire_type)
                    if not success then 
                        repeat
                            set_status("Error! Reason: "..tostring(result))
                            warn(result)
                            wait(1) -- 2 works
                            success, result = pcall(self.buy_place,self, "Wire",nil, wire_vectors, wire_type)
                        until success
                    end
                    wait(.1)
                    local time_end = tick()
                    local elapsed = time_end - start
                    table.insert(wire_times, elapsed)
                    local average = 0
                    for i, v in pairs(wire_times) do
                        average = average + v
                    end
                    average = average/#wire_times
                    set_average_time(self:split_time(average))
                    local eta = (#payload['wires'] - i) * average
                    set_eta(self:split_time(eta))
                    set_progress(i, #payload['wires'])
                    set_status("Saving Progress")
                    local save_result = self:save_progress(base_id, 3, i, slot_id)
                    if save_result.code ~= 6001 then
                        self:send_notice(string.format("Auto-Build Progress Save Failed! Reason: %s | Code %s", save_result.message, save_result.code))
                    end
                end
            end
            if resume_id then
                self:delete_save(resume_id)
            else
                for i, v in pairs(self:get_progress_metadata()) do
                    if v['slot_id'] == slot_id or v['slot_id'] == game:GetService("Players")["LocalPlayer"]["CurrentSaveSlot"].Value then
                        self:delete_save(v['_id'])
                    end
                end
            end
        end,
        -- get autobuy list
        get_autobuy_list = function(self, search_term)
            local table_a = {}
            for i, v in pairs(store_items) do
                for a, b in pairs(v:GetChildren()) do
                    table_a[b.BoxItemName.Value] = true
                end
            end
            local item_list = {}
            for item, _ in pairs(table_a) do
                local item_data
                local purchasables = game.ReplicatedStorage.Purchasables
                if purchasables.Structures.HardStructures:FindFirstChild(item) then
                    item_data = purchasables.Structures.HardStructures:FindFirstChild(item)
                elseif purchasables.Structures.BlueprintStructures:FindFirstChild(item) then
                    item_data = purchasables.Structures.BlueprintStructures:FindFirstChild(item)
                elseif purchasables.Other:FindFirstChild(item) then
                    item_data = purchasables.Other:FindFirstChild(item)
                elseif purchasables.Tools.AllTools:FindFirstChild(item) then
                    item_data = purchasables.Tools.AllTools:FindFirstChild(item)
                elseif purchasables.WireObjects:FindFirstChild(item) then
                    item_data = purchasables.WireObjects:FindFirstChild(item)
                elseif purchasables.Vehicles:FindFirstChild(item) then
                    item_data = purchasables.Vehicles:FindFirstChild(item)
                elseif purchasables.Other.Gifts:FindFirstChild(item) then
                    item_data = purchasables.Other.Gifts:FindFirstChild(item)
                else
                    warn("Unknown Item!: "..item)
                end
                if item_data then
                    if search_term == nil or search_term == "" then
                        table.insert(item_list, {item, item_data})
                    else
                        if string.find(string.lower(item), string.lower(search_term)) then
                            table.insert(item_list, {item, item_data})
                        elseif string.find(string.lower(item_data.ItemName.Value), string.lower(search_term)) then
                            table.insert(item_list, {item, item_data})
                        end
                    end
                end
            end
            return item_list
        end,
        
        abort_autobuy = false,
        -- auto buy
        auto_buy = function(self, item_name, quantity)
            local current_cframe = self.localplayer.Character.HumanoidRootPart.CFrame
            for i=1, quantity do
                if self.abort_autobuy then
                    self.abort_autobuy = false
                    self.localplayer.Character.HumanoidRootPart.CFrame = current_cframe
                    error("Autobuy Aborted!")
                end
                local item 
                local iterations = 0
                local success, result = pcall(self.buy_item, self, item_name)
                if success then 
                    item = result
                else
                    while not success do
                        if iterations > 5 then
                            self.localplayer.Character.HumanoidRootPart.CFrame = current_cframe
                            error("Auto-Buy Failed!")
                        end
                        if self.abort_autobuy then
                            self.abort_autobuy = false
                            self.localplayer.Character.HumanoidRootPart.CFrame = current_cframe
                            error("Autobuy Aborted!")
                        end
                        success, result = pcall(self.buy_item, self, item_name)
                        iterations = iterations + 1
                        if success then item = result end
                    end
                end
                for i = 1, 2 do
                    spawn(function()
                        for i = 1, 7 do
                            item:MoveTo(current_cframe.p)
                            game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(item)
                            wait()
                        end
                    end)
                end
            end
            self.localplayer.Character.HumanoidRootPart.CFrame = current_cframe
        end,
        cancel_autobuy = function(self)
            self.abort_autobuy = true
        end,
        
        
        --bloxburg messages
        
        hover_effect = function(self, obj)
            assert(obj:IsA("GuiObject"), "Object must be of class \'GuiObject\'")
            intensity = tonumber(intensity) or 0.9
            local property = (obj:IsA("ImageButton") or obj:IsA("ImageLabel")) and "ImageColor3" or "TextColor3"
            local color, canChange = obj[property], true
            obj.MouseEnter:connect(function()

                canChange = false
                obj[property] = Color3.new(color.r * intensity, color.g * intensity, color.b * intensity)
                canChange = true
            end
            )
            obj.MouseLeave:connect(function()

                canChange = false
                obj[property] = color
                canChange = true
            end
            )
            obj.SelectionGained:connect(function()

                canChange = false
                obj[property] = Color3.new(color.r * intensity, color.g * intensity, color.b * intensity)
                canChange = true
            end
            )
            obj.SelectionLost:connect(function()

                canChange = false
                obj[property] = color
                canChange = true
            end
            )
            obj.Changed:connect(function(prop)

                if prop == property and canChange then
                    color = obj[property]
                end
            end
            )
        end,
        
        rounded_button_effect = function(self, obj)
            assert(obj:IsA("GuiButton"), "Object must be a \'GuiObject\'")
            local content = {}
            for _,objContent in pairs(obj:GetChildren()) do
                content[objContent] = objContent.Position
            end
            self:hover_effect(obj)
            obj.MouseButton1Down:connect(function()

                obj.Image = "rbxassetid://337251609"
                for objContent,pos in pairs(content) do
                    objContent.Position = UDim2.new(pos.X.Scale, pos.X.Offset, pos.Y.Scale, pos.Y.Offset + 2)
                end
            end
            )
            local clickUp = function()

                obj.Image = "rbxassetid://295943248"
                for objContent,pos in pairs(content) do
                    objContent.Position = pos
                end
            end

            obj.MouseButton1Up:connect(clickUp)
            obj.MouseLeave:connect(clickUp)
        end,
        
        
        notify_bloxburg = function(self, title, content, screengui, frame, color)
            local promptFade = 0.5
            
            if frame == nil then frame = game:GetObjects("rbxassetid://6429192710")[1] end
            frame = frame:clone()
            frame.Visible = true
            frame.Parent = screengui
            frame.Title.Text = title or "Message"
            frame.Size = UDim2.new(frame.Size.X.Scale, frame.Size.X.Offset, 10, 0)
            frame.Content.Text = content or "..."
            if not color then
                frame.Ok.ImageColor3 = Color3.new(0, 0.66666666666667, 1)
                if not color then
                    frame.Title.TextColor3 = Color3.new(0, 0.66666666666667, 1)
                    local sizeDiff = frame.AbsoluteSize.Y - frame.Content.AbsoluteSize.Y
                    frame.Size = UDim2.new(frame.Size.X.Scale, frame.Size.X.Offset, 0, frame.Content.TextBounds.Y + sizeDiff)
                    local overlay = frame.Overlay
                    frame.Visible = true
                    --overlay.BackgroundTransparency = 1
                    frame.Position = UDim2.new(0.5, -frame.AbsoluteSize.X * 0.5, 1, 0)
                    frame:TweenPosition(UDim2.new(0.5, -frame.AbsoluteSize.X * 0.5, 0.5, -frame.AbsoluteSize.Y * 0.5), "In", "Sine", promptFade)
                    --interpolate(promptFade, "In", "Quad", function(t) overlay.BackgroundTransparency = 1 - 0.5 * t end, true)
                    self:rounded_button_effect(frame.Ok)
                    local clickEvent = Instance.new("BindableEvent", frame)
                    frame.Ok.MouseButton1Down:connect(function()
                        clickEvent:Fire(true)
                    end)
                    local input = clickEvent.Event:wait()
                    frame:TweenPosition(UDim2.new(0.5, -frame.AbsoluteSize.X * 0.5, 1, 0), "Out", "Sine", promptFade, true, function()

                        frame:Destroy()
                    end
                    )
                    --interpolate(promptFade, "In", "Quad", function(t) overlay.BackgroundTransparency = 0.5 + 0.5 * t end, true)
                    return true
                end
            end
        end,
        
        confirm_bloxburg = function(self, content, title, screengui,frame)
            local promptFade = 0.5
            
            if frame == nil then frame = game:GetObjects("rbxassetid://6431670839")[1] end
            frame = frame:clone()
            frame.Visible = true
            frame.Parent = screengui
            frame.Title.Text = title or "Are you sure?"
            frame.Size = UDim2.new(frame.Size.X.Scale, frame.Size.X.Offset, 10, 0)
            frame.Content.Text = content or "..."
            local sizeDiff = frame.AbsoluteSize.Y - frame.Content.AbsoluteSize.Y
            frame.Size = UDim2.new(frame.Size.X.Scale, frame.Size.X.Offset, 0, frame.Content.TextBounds.Y + sizeDiff)
            local overlay = frame.Overlay
            frame.Visible = true
            --overlay.BackgroundTransparency = 1
            frame.Position = UDim2.new(0.5, -frame.AbsoluteSize.X * 0.5, 1, 0)
            frame:TweenPosition(UDim2.new(0.5, -frame.AbsoluteSize.X * 0.5, 0.5, -frame.AbsoluteSize.Y * 0.5), "In", "Sine", promptFade)
            
            local clickEvent = Instance.new("BindableEvent", frame)
            self:rounded_button_effect(frame.Yes)
            self:rounded_button_effect(frame.No)
            frame.Yes.MouseButton1Down:connect(function()
                clickEvent:Fire(true)
            end)
            frame.No.MouseButton1Down:connect(function()
                clickEvent:Fire(false)
            end)
            
            local input = clickEvent.Event:wait()
            
            frame:TweenPosition(UDim2.new(0.5, -frame.AbsoluteSize.X * 0.5, 1, 0), "Out", "Sine", promptFade, true, function()
                frame:Destroy()
            end)
            
            return input
        end,
        
        
        draw_lines = function(self, obj, lineSpacing)
            local USE_FADE_EFFECT = false
            local USE_GROW_EFFET = false
            local center = CFrame.new(0,0,0).p
            --local extents = obj.Parent:GetExtentsSize()
            local extents = obj.Size
            local width = math.max(extents.X, extents.Z)
            if lineSpacing == nil then
                lineSpacing = 2
            end
            local dstToFloor = ((obj.Size.Y/2)-obj.Size.Y)
            local AmountOfLines = width / (lineSpacing * 2)
            local floorCenter = center - Vector3.new(0, dstToFloor, 0)
            local lineModel = Instance.new('Folder', obj)
            lineModel.Name = 'EditorLines'

            local fade = function(line)
                spawn(function()
                    for i = 1, 10 do
                        if line then
                            line.Transparency = 1 - i/10
                            wait(0.07)
                        end
                    end
                end)		
            end

            local grow = function(line, finish)
                spawn(function()
                    for i = 1, 60 do
                        if line then
                            line.Length = finish * (i/60)
                            game:GetService('RunService').RenderStepped:wait()
                        end
                    end
                end)			
            end

            spawn(function()
                for z = -AmountOfLines, AmountOfLines do
                    local line = Instance.new('LineHandleAdornment')
                    line.Thickness = 2
                    line.Color = BrickColor.new'Institutional white'
                    line.Length = width
                    line.Adornee = obj
                    line.CFrame = CFrame.new(floorCenter) + Vector3.new(z * lineSpacing, 0, width / 2)
                    if USE_FADE_EFFECT then
                        line.Transparency = 1
                        fade(line)
                        wait(0.001)
                    end
                    if USE_GROW_EFFET then
                        grow(line, width)
                        wait(0.001)				
                    end

                    line.Parent = lineModel
                end
                for x = -AmountOfLines, AmountOfLines do
                    local line = Instance.new('LineHandleAdornment')
                    line.Thickness = 2
                    line.Color = BrickColor.new'Institutional white'
                    line.Length = width
                    line.Adornee = obj
                    line.CFrame = (CFrame.new(floorCenter) + Vector3.new(width / 2, 0, x * lineSpacing)) * CFrame.Angles(0, math.pi/2, 0)
                    if USE_FADE_EFFECT then
                        line.Transparency = 1
                        fade(line)
                        wait(0.001)
                    end	
                    if USE_GROW_EFFET then
                        grow(line, width)
                        wait(0.001)				
                    end		

                    line.Parent = lineModel
                end
            end)
            -- Secondary
            spawn(function()
                for z = -AmountOfLines*2, AmountOfLines*2 do
                    local line = Instance.new('LineHandleAdornment')
                    line.Thickness = 1
                    line.Color = BrickColor.new'Institutional white'
                    line.Length = width
                    line.Adornee = obj
                    line.Transparency = 0.5
                    line.CFrame = CFrame.new(floorCenter) + Vector3.new(z/2 * lineSpacing, 0, width / 2)
                    if USE_FADE_EFFECT then
                        line.Transparency = 1
                        fade(line)
                        wait(0.001)
                    end
                    if USE_GROW_EFFET then
                        grow(line, width)
                        wait(0.001)				
                    end

                    line.Parent = lineModel
                end
                for x = -AmountOfLines*2, AmountOfLines*2 do
                    local line = Instance.new('LineHandleAdornment')
                    line.Thickness = 1
                    line.Color = BrickColor.new'Institutional white'
                    line.Length = width
                    line.Adornee = obj
                    line.Transparency = 0.5
                    line.CFrame = (CFrame.new(floorCenter) + Vector3.new(width / 2, 0, x/2 * lineSpacing)) * CFrame.Angles(0, math.pi/2, 0)
                    if USE_FADE_EFFECT then
                        line.Transparency = 1
                        fade(line)
                        wait(0.001)
                    end	
                    if USE_GROW_EFFET then
                        grow(line, width)
                        wait(0.001)				
                    end		

                    line.Parent = lineModel
                end
            end)
        end,
        
        draw_plot_grid = function(self, actually_draw, spacing)
            local plot = self:get_plot()
            local part = plot:FindFirstChild("ls-selection-part")
            if not part then
                part = Instance.new("Part", plot) 
                part.Name="ls-selection-part"  
                part.Transparency = 0.5
                part.CanCollide = false
                part.Material = Enum.Material.Concrete
                part.BrickColor = BrickColor.new("Brown")
                part.Size=Vector3.new(200,0.5,200) 
                part.Anchored = true
                part.CFrame = plot.OriginSquare.CFrame
            end
            if actually_draw then
                if part:FindFirstChild("EditorLines") then
                    part.EditorLines:Destroy()
                end
                self:draw_lines(part, spacing)
            end
        end,
        
        
        build_mode = false,
        is_placing = false,
        
        plotregion3 = nil,
        camregion3 = nil,
        sound = nil,
        rotation = 0,
        turn = 0,
        x_rotate = 0,
        increments = 12,
        build_clocktime = 12,
        is_deleting = false,
        grid_size = 2,
        get_round = function(self)
            if self.grid_size == 1 then 
                self.increments = 4
                return 2
            elseif self.grid_size == 2 then
                self.increments = 12
                return 1
            elseif self.grid_size == 3 then
                self.increments = 36
                return 0.05
            end
        end,
        
        build_mouse = game.Players.LocalPlayer:GetMouse(),
        
        connections = {},
        
        CreateRegion3FromLocAndSize = function(self, Position, Size)
            local SizeOffset = Size/2
            local RegionPoint1 = Position - SizeOffset
            local RegionPoint2 = Position + SizeOffset
            return Region3.new(RegionPoint1, RegionPoint2)
        end,
        
        
        populate_items_table = function(self)
            self.items_table = {}
            for i, v in pairs(game.ReplicatedStorage.Purchasables.Other:GetChildren()) do
                self.items_table[v.Name] = v	
            end
            for i, v in pairs(game.ReplicatedStorage.Purchasables.Structures.HardStructures:GetChildren()) do
                self.items_table[v.Name] = v	
            end
            for i, v in pairs(game.ReplicatedStorage.Purchasables.Structures.BlueprintStructures:GetChildren()) do
                self.items_table[v.Name] = v	
            end
            for i, v in pairs(game.ReplicatedStorage.Purchasables.Tools.AllTools:GetChildren()) do
                self.items_table[v.Name] = v	
            end
            for i, v in pairs(game.ReplicatedStorage.Purchasables.Vehicles:GetChildren()) do
                self.items_table[v.Name] = v	
            end
            for i, v in pairs(game.ReplicatedStorage.Purchasables.WireObjects:GetChildren()) do
                self.items_table[v.Name] = v	
            end
        end,
        
        
        enter_build_mode = function(self, gui_folder)
            local player = game.Players.LocalPlayer
            if self.build_mode then 
                warn("Build Mode Already Active")
                return 
            end
            if not pcall(self.get_plot, self) then 
                warn("No Plot!")
                return 
            end
            self.build_mode = true
            self:draw_plot_grid(true)
            
            --self.build_mouse.TargetFilter = Tycoon.Purchases
            
            local plot = self:get_plot()
            local part = plot['ls-selection-part']
            self.plotregion3 = self:CreateRegion3FromLocAndSize(part.Position+Vector3.new(0,40.7,0), part.Size+Vector3.new(0,100,0)):ExpandToGrid(4)
            self.camregion3 = self:CreateRegion3FromLocAndSize(part.Position+Vector3.new(0,50,0), part.Size+Vector3.new(25,100,25)):ExpandToGrid(4)
            
            
            
            local camera = game.Workspace.Camera
            camera.CameraType = Enum.CameraType.Scriptable
            
            local target_cam_cframe = plot.OriginSquare.CFrame + Vector3.new(120, 50, 0)
            local target_player_cframe = plot.OriginSquare.CFrame + Vector3.new(110, 5, 110)
            
            camera:Interpolate(target_cam_cframe,(target_cam_cframe*CFrame.Angles(0,math.rad(90),0)+Vector3.new(-5,-5,0)), 3)
            player.Character.HumanoidRootPart.CFrame = (target_player_cframe*CFrame.Angles(0,math.rad(90),0))
            if _G.DogixLT2TPC ~= nil and gkey then
                _G.DogixLT2TPC((target_player_cframe*CFrame.Angles(0,math.rad(90),0)),gkey, true)
                wait(.2)
            end
            player.Character.HumanoidRootPart.Anchored = true
            player.Character.Humanoid.JumpPower = 0
            player.Character.Humanoid.WalkSpeed = 0
            -- fuck roblox copyright, rip this 03/22/2022
            -- 04/21/2022 restored
            -- create a sound
            self.sound = Instance.new("Sound", game.Workspace)
            local sound = self.sound
            sound.SoundId = "rbxassetid://9092763466"
            sound.Volume = 0.1
            --stop lt2 music
            local success, musicerr = pcall(function()
                for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.ClientSounds:GetChildren()) do
                    if v.Playing then
                        self.backup_music = v
                        v.Playing = false
                        break
                    end
                end
            end)
            if not success then
                warn("[Bark]: Failed to Stop LT2 Music!\n", musicerr)                  
            end
            if not sound.IsLoaded then
                -- sound.Loaded:wait()
                wait()
            end
            pcall(function()
                sound.Looped = true
                sound:Play()
            end)
            
            
            
            local tween_complete = false
            local tween_info = TweenInfo.new(5,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0)
            local tween = TweenService:Create(game.Lighting, tween_info, {ClockTime = self.build_clocktime})
            tween:Play()
            spawn(function()
                while not tween_complete do
                    game.Lighting.Ambient = Color3.new(1, 1, 1)
                    game.Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
                    game.Lighting.FogEnd = 100000
                    game:GetService("RunService").RenderStepped:Wait()
                end
            end)
            local tween_active = false
            tween.Completed:Connect(function()
                tween_complete = true
                local connection
                connection = game.Lighting.Changed:connect(function()
                    
                    if game.Lighting.ClockTime ~= self.build_clocktime then
                        game.Lighting.Ambient = Color3.new(1, 1, 1)
                        game.Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
                        game.Lighting.FogEnd = 100000
                        if tween_active == true then return end
                        game.Lighting.ClockTime = self.build_clocktime
                    end
                end)
                table.insert(self.connections, connection)
            end)
            if gui_folder then
                self.build_sg = Instance.new("ScreenGui", game.Players.LocalPlayer.PlayerGui)
                if self.gui_mainframe then
                    self.gui_mainframe.Visible = false
                end
                local bar = gui_folder.BuildBar:Clone()
                bar.Visible = true
                bar.Parent = self.build_sg
                bar.Delete.Activated:Connect(function()
                    if self.is_deleting then
                        self.delete_conn:Disconnect()
                        bar.Delete.ImageColor3 = Color3.new(0.588235, 0.588235, 0.588235)
                        self.is_deleting = false
                    else
                        bar.Delete.ImageColor3 = Color3.new(0.333333, 0.666667, 1)
                        self.is_deleting = true
                        
                        --delete item connection
                        self.delete_conn = self.build_mouse.Move:Connect(function()
                            if self.is_deleting == true and self.build_mouse.Target and self.build_mouse.Target.Parent then
                                local model = self.build_mouse.Target.Parent
                                if not model:IsDescendantOf(game.Workspace.PlayerModels) then 
                                    if self.last_selection then
                                        self.last_selection:Destroy()
                                    end
                                    return 
                                end
                                if model.Parent ~= game.Workspace.PlayerModels  then
                                    repeat
                                        model = model.Parent
                                    until model.Parent == game.Workspace.PlayerModels
                                end
                                if model:FindFirstChild("Type") and model:FindFirstChild("Owner") then
                                    if self.last_selection and self.last_selection.Adornee == model then
                                        return
                                    elseif self.last_selection then
                                        self.last_selection:Destroy()
                                    end
                                    local a = Instance.new("SelectionBox", model)
                                    a.Name = "Selection"
                                    a.Adornee = model
                                    a.Color3 = Color3.new(1, 0, 0)
                                    self.last_selection = a
                                end
                            else
                                if self.last_selection then
                                    self.last_selection:Destroy()
                                end
                            end
                        end)
                        
                        --finish
                    end
                end)
                
                bar.Exit.Activated:Connect(function()
                    self:exit_build_mode()
                end)
                
                --sidebar
                local sidebar = gui_folder.BuildSidebar:Clone()
                sidebar.Visible = true
                sidebar.Parent = self.build_sg
                sidebar.Frame.Buttons.GridSize.Activated:Connect(function()
                    local last_inc = self.increments
                    if self.grid_size == 3 then
                        self.grid_size = 1
                        self:get_round()
                        self.rotation = math.floor(self.rotation / (last_inc/self.increments))
                        self.turn = math.floor(self.turn/ (last_inc/self.increments) )
                        self.x_rotate = math.floor(self.x_rotate / (last_inc/self.increments))
                    else
                        self.grid_size = self.grid_size + 1
                        self:get_round()
                        self.rotation = self.rotation * (self.increments/last_inc)
                        self.turn = self.turn * (self.increments/last_inc)
                        self.x_rotate = self.x_rotate * (self.increments/last_inc)
                    end
                    sidebar.Frame.Buttons.GridSize.ImageRectOffset = Vector2.new((3 - self.grid_size) * 36, 0)
                    if self.grid_size ~= 3 then
                        self:draw_plot_grid(true, self:get_round()*2)
                    else
                        if self:get_plot()['ls-selection-part']:FindFirstChild("EditorLines") then
                            self:get_plot()['ls-selection-part']:FindFirstChild("EditorLines"):Destroy()
                        end
                    end
                end)
                
                local build_time = 0
                sidebar.Frame.Buttons.ChangeTime.Activated:Connect(function()
                    if build_time >= 4 then build_time = 0 else build_time = build_time + 1 end
                    sidebar.Frame.Buttons.ChangeTime.ImageRectOffset = Vector2.new(build_time * 36, 0);
                    local target_time
                    
                    if build_time == 0 then 
                        target_time = 12
                    elseif build_time == 1 then 
                        target_time = 6
                    elseif build_time == 2 then 
                        target_time = 12
                    elseif build_time == 3 then 
                        target_time = 18
                    elseif build_time == 4 then 
                        target_time = 0
                    end
                    tween_active = true
                    local tween_info = TweenInfo.new(3,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0)
                    local tween = TweenService:Create(game.Lighting, tween_info, {ClockTime = target_time})
                    tween:Play()
                    tween.Completed:Connect(function()
                        self.build_clocktime = target_time
                        tween_active = false
                    end)
                    
                    
                end)
                
                sidebar.Frame.Buttons.BulldozePlot.Activated:Connect(function()
                    local a = self:confirm_bloxburg("Are you sure you want to wipe your plot? \nThis action is IRREVERSABLE and PERMANENT!", nil, self.build_sg, nil)
                    if not a then return end
                    a = self:confirm_bloxburg("This is your last chance to go back! \nWiping your plot is PERMANENT and IRREVERSABLE!", nil, self.build_sg, nil)
                    if not a then return end
                    print("wipe")
                    self:wipe_base(game.Players.LocalPlayer)
                end)
                sidebar.Frame.Buttons.FloorUp.Activated:Connect(function()
                    local plot = self:get_plot()
                    plot['ls-selection-part'].CFrame = plot['ls-selection-part'].CFrame * CFrame.new(0, self:get_round(), 0)
                end)
                sidebar.Frame.Buttons.FloorDown.Activated:Connect(function()
                    local plot = self:get_plot()
                    plot['ls-selection-part'].CFrame = plot['ls-selection-part'].CFrame * CFrame.new(0, self:get_round() * -1, 0)
                end)
                
                --build menu
                local build_menu = gui_folder.BuildMenu:Clone()
                local layout = build_menu.List.ScrollFrame.UIGridLayout
                self.buildmenu_list = build_menu.List
                build_menu.Visible = true
                build_menu.Parent = self.build_sg
                build_menu.List.Visible = false
                local last_menu = nil
                
                build_menu.List.Size = UDim2.new(0, 700, 0, 205)
                build_menu.List.HorizontalGradient.Visible = false
                build_menu.List.HorizontalScrollBackground.Visible = false
                build_menu.List.Title.Back.Activated:Connect(function()
                    last_menu = nil
                    build_menu.List.Visible = false
                end)
                
                local current_store = nil
                local current_bp = nil
                
                function render_menu(list_type, title_name, items)
                    last_menu = title_name
                    local scroll_frame = build_menu.List.ScrollFrame
                    local desc_frame = build_menu.List.DescFrame
                    desc_frame.Visible = false
                    desc_frame.Size = UDim2.new(0, 400, 0, 5)
                    desc_frame.Position = UDim2.new(0, 7, 0, -5)

                    for i, v in pairs(scroll_frame:GetChildren()) do
                        if v:IsA("ImageButton") and v.Visible then 
                            v:Destroy()
                        end
                    end
                    if list_type == "Category" then
                        build_menu.List.Visible = true
                        build_menu.List.Title.Text = "Categories"
                        local template = scroll_frame.CategoryButton
                        layout.FillDirection = "Vertical"
                        layout.CellSize = UDim2.new(0, template.Size.X.Offset, 0, template.Size.Y.Offset);
                        scroll_frame.CanvasSize = UDim2.new(0, 0, scroll_frame.Size.Y.Scale, scroll_frame.Size.Y.Offset);
                        scroll_frame.ScrollingDirection = "X";
                        for i, v in pairs(items) do
                            local clone = template:Clone()
                            clone.TextLabel.Text = v[1]
                            clone.Name = "Category_"..v[2]
                            clone.Visible = true
                            clone.Parent = scroll_frame
                            clone.Activated:Connect(v[3])
                        end
                    else
                        local template = scroll_frame.ItemButton
                        scroll_frame.ScrollingDirection = "Y";
                        layout.FillDirection = "Horizontal"
                        layout.CellSize = UDim2.new(0, template.Size.X.Offset, 0, template.Size.Y.Offset);
                        for i, v in pairs(items) do
                            local clone = template:Clone()
                            clone:WaitForChild("NameLabel").Text = v[1]
                            clone.Name = "Item_"..v[2]
                            clone.Visible = true
                            clone.Parent = scroll_frame
                            local item_internalname = Instance.new("StringValue", clone)
                            item_internalname.Name = "LT2ITEMNAME"
                            item_internalname.Value = v[1]
                            clone.PriceLabel.Text = "$ "..tostring(v[3].Price.Value)
                            clone.ImageLabel.Image = v[3].ItemImage.Value
                            clone.Activated:Connect(v[4])
                            clone.InputBegan:Connect(function(input)
                                if input.UserInputType == Enum.UserInputType.MouseMovement then
                                    desc_frame.Visible = true
                                    desc_frame.ImageLabel.Image = v[3].ItemImage.Value
                                    desc_frame.NameLabel.Text = v[1]
                                    desc_frame.ImageLabel.PriceLabel.Text = "$ "..tostring(v[3].Price.Value)
                                    desc_frame.DescLabel.Text = v[3].Description.Value
                                    desc_frame.SetLabel.Text = v[3].Type.Value
                                    desc_frame.StatLabel.Visible = false
                                    desc_frame:TweenSizeAndPosition(UDim2.new(0, 400, 0, 150), UDim2.new(0, 7, 0, -150), Enum.EasingDirection.Out,Enum.EasingStyle.Quad, 1, true, function()
                                        desc_frame.Visible = true
                                    end)
                                end
                            end)
                            clone.InputEnded:Connect(function(input)
                                if input.UserInputType == Enum.UserInputType.MouseMovement then
                                    desc_frame:TweenSizeAndPosition(UDim2.new(0, 400, 0, 5), UDim2.new(0, 7, 0, -5), Enum.EasingDirection.Out,Enum.EasingStyle.Quad, 1, false, function()
                                        desc_frame.Visible = false
                                    end)
                                    
                                end
                            end)
                        end
                        local connection
                        connection = layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                            scroll_frame.CanvasSize = UDim2.new(scroll_frame.Size.X.Scale, scroll_frame.Size.X.Offset, 0, layout.AbsoluteContentSize.Y);
                            connection:Disconnect()
                        end)
                    end
                end
                
                
                local function prepare_storeitems(store_name, search)
                    local table_index_dupe = {}
                    for _, item in pairs(store_items[store_name]:GetChildren()) do
                        table_index_dupe[item.Name] = true
                    end

                    if self.items_table == nil then
                        self:populate_items_table()
                    end
                    local storeitems = {}
                    for index, _ in pairs(table_index_dupe) do
                        if search==nil or string.find(index:lower(), search:lower(), 1, true) then
                        
                            local itemdata = self.items_table[index]
                            local data = {}
                            data[1] = itemdata.ItemName.Value
                            data[2] = index 
                            data[3] = itemdata
                            data[4] = function()
                                game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
                                local item = self:buy_item_v2(index, 1, self:get_plot().OriginSquare.CFrame, true, false)
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = (target_player_cframe*CFrame.Angles(0,math.rad(90),0))
                                game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
                                if itemdata.Type.Value == "Structure" or itemdata.Type.Value == "Furniture" or itemdata.Type.Value == "Vehicle Spot" then
                                    local remote = game.ReplicatedStorage.PlaceStructure.ClientPlacedStructure
                                    local connection
                                    connection = game.Workspace.PlayerModels.ChildAdded:Connect(function(child)
                                        local owner = child:WaitForChild("Owner")
                                        if owner.Value == game.Players.LocalPlayer then
                                            connection:Disconnect()
                                            self:build_item(child)
                                        end											
                                    end)
                                    remote:FireServer(item.PurchasedBoxItemName.Value, self:get_plot().OriginSquare.CFrame + Vector3.new(0, 50, 0), game.Players.LocalPlayer, nil, item, false, true)
                                    return
                                end
                                self:build_item(item)
                            end
                            table.insert(storeitems, data)
                        end
                    end
                    return storeitems
                end
                
                
                build_menu.Decorate.TextLabel.Text = "Store Items" -- not messing with bloxburg names
                build_menu.Decorate.Activated:Connect(function()
                    current_store = nil
                    current_bp = nil
                    if build_menu.List.Visible and last_menu == "Decorate" then
                        build_menu.List.Visible = false
                    else
                        last_menu = "Decorate"
                        build_menu.List.Visible = true
                        local stores = {}
                        for i, v in pairs(store_name_mapping) do
                            local payload = {}
                            payload[1] = v[1]
                            payload[2] = v[2]
                            payload[3] = function()
                                local store_items = prepare_storeitems(v[2], nil)
                                current_store = v[2]
                                render_menu("Items", v[2], store_items)
                            end
                            table.insert(stores, payload)
                        end
                        render_menu("Category", "Stores", stores)
                    end
                end)
                
                local function get_bp_categories()
                    local blueprint_categories = {}
                    for i, blueprint in pairs(game.ReplicatedStorage.Purchasables.Structures.BlueprintStructures:GetChildren()) do
                        if blueprint_categories[blueprint.ItemCategory.Value] == nil then
                            blueprint_categories[blueprint.ItemCategory.Value] = {}
                        end
                        table.insert(blueprint_categories[blueprint.ItemCategory.Value], blueprint)
                    end
                    return blueprint_categories
                end
                local function get_bp_list(bp_category, search)
                    local prep_render = {}
                    for a, b in pairs(get_bp_categories()[bp_category]) do
                        if not search or string.find(b.Name:lower(), search:lower(), 1, true) or string.find(b.ItemName.Value:lower(), search:lower(), 1, true) then
                            local data = {}
                            data[1] = b.ItemName.Value
                            data[2] = bp_category
                            data[3] = b
                            data[4] = function() 
                                self:build_item(b.Name, true)
                            end
                            table.insert(prep_render, data)
                        end
                    end
                    return prep_render
                end
                build_menu.List.Title.SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
                    if current_store then
                        local store_items = prepare_storeitems(current_store, build_menu.List.Title.SearchBox.Text)
                        render_menu("Items", current_store, store_items)
                    elseif current_bp then
                        local blueprints = get_bp_list(current_bp, build_menu.List.Title.SearchBox.Text)
                        render_menu("Items", current_bp, blueprints)
                    end
                end)
                build_menu.Build.Activated:Connect(function()
                    current_store = nil
                    current_bp = nil
                    if build_menu.List.Visible and last_menu == "Build" then
                        build_menu.List.Visible = false
                    else
                        last_menu = "Build"
                        build_menu.List.Visible = true
                        local blueprint_categories = get_bp_categories()
                        local cat_2 = {}
                        for i, v in pairs(blueprint_categories) do
                            local payload = {}
                            payload[1] = i
                            payload[2] = i
                            payload[3] = function()
                                current_bp = i
                                local prep_render = get_bp_list(i) 
                                render_menu("Items", i, prep_render)
                            end
                            table.insert(cat_2, payload)
                        end
                        render_menu("Category", "Blueprint Categories", cat_2)
                    end
                end)
                
                --moneybar
                local moneybar = gui_folder.MoneyBar:Clone()
                moneybar.Visible = true
                moneybar.Parent = self.build_sg
                pcall(function()
                    moneybar.Bar.Frame.Blockbux.Text = "B$ LT2"
                    moneybar.Bar.Frame.Money.Text = "$ "..tostring(game.Players.LocalPlayer.leaderstats.Money.Value)
                    self.moneybar_bind = game.Players.LocalPlayer.leaderstats.Money.Changed:Connect(function()
                        moneybar.Bar.Frame.Money.Text = "$ "..tostring(game.Players.LocalPlayer.leaderstats.Money.Value)
                    end)
                end)
                self.moneybar = moneybar
                
            end
            
            
            
            wait(3)
            
            local uis = game:GetService("UserInputService")
            local WDown = false
            local ADown = false
            local SDown = false
            local DDown = false
            local EDown = false
            local QDown = false
            
            local button2_down = false
            local old_mouse_pos
            

            
            local connection
            local Speed = 0.5
            connection = game:GetService("RunService").RenderStepped:connect(function()		
                if uis:IsKeyDown(Enum.KeyCode.LeftShift) then
                    Speed = 1
                elseif uis:IsKeyDown(Enum.KeyCode.RightShift) then
                    Speed = 0.25
                else
                    Speed = 0.5
                end
                if WDown then
                    camera.CFrame = camera.CFrame + camera.CFrame.lookVector * Speed
                end
                if ADown then
                    camera.CFrame = camera.CFrame + camera.CFrame.rightVector * -Speed
                end
                if SDown then
                    camera.CFrame = camera.CFrame + camera.CFrame.lookVector * -Speed
                end
                if DDown then
                    camera.CFrame = camera.CFrame + camera.CFrame.rightVector * Speed
                end
                if EDown then
                    camera.CFrame = camera.CFrame + camera.CFrame.upVector * Speed
                end
                if QDown then
                    camera.CFrame = camera.CFrame + camera.CFrame.upVector * -Speed
                end
                local size = part.Size+Vector3.new(25,1000,25)
                local sizedown = part.Size + Vector3.new(25,100,25)
                local position = part.Position+Vector3.new(0,50,0)
                local SizeOffset = size/2
                local sizeoffsetdown = sizedown/2
                local minCorner = position - sizeoffsetdown
                local maxCorner = position + SizeOffset
                local camPos = camera.CFrame.p
                camera.CFrame = CFrame.new(Vector3.new(), camera.CFrame.lookVector) + Vector3.new(
                math.clamp(camPos.X, minCorner.X, maxCorner.X),
                math.clamp(camPos.Y, minCorner.Y, maxCorner.Y),
                math.clamp(camPos.Z, minCorner.Z, maxCorner.Z)
                )
            end)
            table.insert(self.connections, connection)
            table.insert(self.connections, self.build_mouse.Button2Down:connect(function() button2_down = true end))
            table.insert(self.connections, self.build_mouse.Button2Up:connect(function() button2_down = false end))
            
            connection = uis.InputChanged:connect(function(inputObject)
                if inputObject.UserInputType == Enum.UserInputType.MouseMovement then
                    if button2_down then
                        uis.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
                        camera.CFrame = camera.CFrame * CFrame.Angles(math.rad(-inputObject.Delta.y/25), math.rad(-inputObject.Delta.x/25),0)
                        old_mouse_pos = Vector2.new(inputObject.Delta.x, inputObject.Delta.Y)
                    else
                        uis.MouseBehavior = Enum.MouseBehavior.Default
                    end
                elseif inputObject.UserInputType == Enum.UserInputType.MouseWheel then
                    if inputObject.Position.z == 1 then
                        camera.CFrame = camera.CFrame + camera.CFrame.lookVector * 5
                    elseif inputObject.Position.z == -1 then
                        camera.CFrame = camera.CFrame + camera.CFrame.lookVector * -5
                    end
                end
            end)
            table.insert(self.connections, connection)
            
            connection = uis.InputBegan:connect(function(Input, GPE)
                if not GPE and Input then
                    if Input.KeyCode == Enum.KeyCode.W then WDown = true end
                    if Input.KeyCode == Enum.KeyCode.A then ADown = true end
                    if Input.KeyCode == Enum.KeyCode.S then SDown = true end
                    if Input.KeyCode == Enum.KeyCode.D then DDown = true end
                    if Input.KeyCode == Enum.KeyCode.Q then QDown = true end
                    if Input.KeyCode == Enum.KeyCode.E then EDown = true end
                end
            end)
            table.insert(self.connections, connection)

            connection = uis.InputEnded:connect(function(Input, GPE)
                if not GPE and Input then
                    if Input.KeyCode == Enum.KeyCode.W then WDown = false end
                    if Input.KeyCode == Enum.KeyCode.A then ADown = false end
                    if Input.KeyCode == Enum.KeyCode.S then SDown = false end
                    if Input.KeyCode == Enum.KeyCode.D then DDown = false end
                    if Input.KeyCode == Enum.KeyCode.Q then QDown = false end
                    if Input.KeyCode == Enum.KeyCode.E then EDown = false end
                end
            end)
            table.insert(self.connections, connection)
            connection = self.build_mouse.Button1Down:Connect(function()
                if self.is_placing ~= true and self.build_mouse.Target and self.build_mouse.Target.Parent then
                    local model = self.build_mouse.Target.Parent
                    if not model:IsDescendantOf(game.Workspace.PlayerModels) then return end
                    if model.Parent ~= game.Workspace.PlayerModels  then
                        repeat
                            model = model.Parent
                        until model.Parent == game.Workspace.PlayerModels
                    end
                    
                    if model:FindFirstChild("Type") and model:FindFirstChild("Owner") then
                        if self.is_deleting then
                            game.ReplicatedStorage.Interaction.DestroyStructure:FireServer(model)
                            return
                        end
                        self:build_item(model)
                    end
                end
            end)
            table.insert(self.connections, connection)
        end,
        
        exit_build_mode = function(self)
            if self.build_sg then
                self.build_sg:Destroy()
            end
            if self.delete_conn then
                self.delete_conn:Disconnect()
                self.delete_conn = nil
            end
            if self.moneybar_bind then
                self.moneybar_bind:Disconnect()
                self.moneybar_bind = nil
            end
            if self.backup_music then
                self.backup_music.Playing = true
            end
            self.moneybar = nil
            self.is_deleting = false
            self.is_placing = false
            --[[
                fuck roblox sound law, 03/22/2022
                restored 04/21/2022
            ]]
            self.sound:Destroy()
            self.sound = nil
            
            for i, v in pairs(self.connections) do 
                v:Disconnect()
            end
            local plot = self:get_plot()
            if plot:FindFirstChild("ls-selection-part") then
                plot:FindFirstChild("ls-selection-part"):Destroy()
            end
            self.connections = {}
            local player = game.Players.LocalPlayer
            player.Character.HumanoidRootPart.Anchored = false
            player.Character.Humanoid.JumpPower = 50
            player.Character.Humanoid.WalkSpeed = 16
            local target_cam_cframe = player.Character.HumanoidRootPart.CFrame * CFrame.new(5,5,0)
            game.Workspace.Camera:Interpolate(target_cam_cframe,(target_cam_cframe*CFrame.Angles(0,math.rad(90),0)+Vector3.new(-5,-5,0)), 2)
            wait(2)
            game.Workspace.Camera.CameraSubject = player.Character.Humanoid
            game.Workspace.Camera.CameraType = Enum.CameraType.Custom
            self.build_mode = false
            if self.gui_mainframe then
                self.gui_mainframe.Visible = true
                if self.gui_mainframe:FindFirstChild("modules") then
                    self.gui_mainframe.modules.buildModeFrame.buildModeToggle.Text = "Enter Build Mode"
                end
            end
            
        end,
        
        round_vector = function(self, vector, unit)
            local offset = self:get_plot().OriginSquare.Position
            vector = vector - offset
            local rounded =  vector - Vector3.new(vector.X%unit, 0, vector.Z%unit)
            return rounded + offset
        end,
        get_dragger_part = function(self, model)
            local mainPart = Instance.new("Part")
            mainPart.CanCollide = false
            mainPart.Anchored = true
            mainPart.Transparency = 0.8
            mainPart.Reflectance = 0.3
            mainPart.TopSurface = Enum.SurfaceType.Smooth
            mainPart.BottomSurface = Enum.SurfaceType.Smooth
            mainPart.Size = model:GetExtentsSize()
            if model:FindFirstChild("Main") then
                mainPart.CFrame = model.Main.CFrame * CFrame.new(0, mainPart.Size.Y / 2 - model.Main.Size.Y / 2, 0)
            elseif model:FindFirstChild("End1") then
                mainPart.CFrame = model.End1.CFrame * CFrame.new(0, mainPart.Size.Y / 2 - model.End1.Size.Y / 2, 0)
            end
            return mainPart
        end,
        
        build_item = function(self, item, isblueprint)
            if self.items_table == nil then
                self:populate_items_table()
            end
            if isblueprint then
                local itemname = item
                local itemclass = game.ReplicatedStorage.Purchasables.Structures.BlueprintStructures:FindFirstChild(itemname, true)
                item = itemclass.Model:Clone()
                itemclass.Type:Clone().Parent = item
                itemclass.ItemName:Clone().Parent = item
                item.ItemName.Value = itemname
                item.Parent = game.Workspace
            end
            self.is_placing = true
            
            local SB = Instance.new('SelectionBox', item)
            SB.Name = 'EditorSelectionBox'
            SB.Adornee = item
            SB.Color3 =  Color3.new(25,172,0)
            SB.LineThickness = 0.025
            self.build_mouse.TargetFilter = item
            
            local can_place = false
            local mouse_move_connection
            
            local item_name = (item:FindFirstChild("ItemName") and item.ItemName.Value)
            local box_name = ((item:FindFirstChild("PurchasedBoxItemName") and item.PurchasedBoxItemName.Value))
            local subtract_y = 0
            
            if item.PrimaryPart == nil then
                if item:FindFirstChild("Main") then
                    item.PrimaryPart = item.Main
                elseif item:FindFirstChild("MainCFrame") then
                    local part
                    if item_name then
                        part = self.items_table[item_name].Model.Main:Clone()
                    elseif box_name then
                        part = self.items_table[box_name].Box.Main:Clone()
                    else
                        error("Big Error! Report to applebee#9292 with what you tried to place.")
                    end
                    part.Parent = item
                    part.CFrame = item.MainCFrame.Value
                    part.Transparency = 1
                    subtract_y = part.Size.Y
                    item.PrimaryPart = part
                end
            end
            local orig_primpart = item.PrimaryPart
            local orig_cframe = item.PrimaryPart.CFrame
            local primpart = self:get_dragger_part(item)
            primpart.Parent = item
            item.PrimaryPart = primpart
            
            local cancel = false
            local continueplacement = false
            local oldliststate = false
            
            if self.moneybar then
                self.moneybar.PlaceBox.Visible = true
                self.moneybar.PlaceBox.Buttons.Placement.Visible = false
                self.moneybar.PlaceBox.Buttons.Cancel.TextLabel.Text = "Cancel"
                local item_class = self.items_table[item_name or box_name]
                self.cancel_bind = self.moneybar.PlaceBox.Buttons.Cancel.Activated:Connect(function()
                    cancel = true
                end)
                self.moneybar.PlaceBox.Title.Text = string.format(
                    "Placing '%s%s'",
                    ((box_name and "Boxed ") or ""), 
                    (item_class and ((item_class:FindFirstChild("ItemName") and item_class.ItemName.Value) or item_class.Name)) or item.Name
                )
                
            end
            if self.buildmenu_list then
                oldliststate = self.buildmenu_list.Visible
                self.buildmenu_list.Visible = false
            end
            local undo_anchor = {}
            for i, v in pairs(item:GetDescendants()) do
                if v:IsA("BasePart") and v.Anchored == false then
                    table.insert(undo_anchor, v)
                    v.Anchored = true
                end
            end
            
            local function update_pos()
                self.build_mouse.TargetFilter = item
                local MouseP = self.build_mouse.Hit.p

                local target_cframe = CFrame.new(self:round_vector(MouseP,self:get_round())+Vector3.new(0,(item.PrimaryPart.Size.Y/2),0))
                target_cframe = target_cframe * CFrame.Angles((math.pi/self.increments) * self.x_rotate, (math.pi/self.increments) * self.rotation, (math.pi/self.increments) * self.turn)
                target_cframe = target_cframe * CFrame.new(0, subtract_y * -1, 0)
                item:SetPrimaryPartCFrame(target_cframe)
                if not self:located_on_plot(item.PrimaryPart.CFrame) then
                    can_place = false
                    SB.Color3 = Color3.new(1, 0, 0)
                else
                    can_place = true
                    SB.Color3 = Color3.new(0, 1, 0)
                end	
            end
            
            local keypress_connection
            keypress_connection = self.build_mouse.KeyDown:Connect(function(key)
                if key == "r" then
                    if self.rotation == self.increments * 2 then 
                        self.rotation = 0
                    else
                        self.rotation = self.rotation + 1
                    end
                elseif key == "t" then
                    if self.turn == self.increments * 2 then 
                        self.turn = 0
                    else
                        self.turn = self.turn + 1
                    end
                elseif key == "y" then
                    if self.x_rotate == self.increments * 2 then 
                        self.x_rotate = 0
                    else
                        self.x_rotate = self.x_rotate + 1
                    end
                end
                update_pos()
            end)
            
            mouse_move_connection = self.build_mouse.Move:connect(function()
                update_pos()
            end)
            local mousedownconnection = self.build_mouse.Button1Down:Connect(function()
                continueplacement = true
            end)
            repeat
                if continueplacement and not can_place then
                    continueplacement = false
                end
                if cancel then continueplacement = true end
                if not self.build_mode then
                    cancel = true
                end
                wait()
            until continueplacement and (can_place or cancel)
            for i, v in pairs(undo_anchor) do
                v.Anchored=false
            end
            primpart:Destroy()
            item.PrimaryPart = orig_primpart
            
            
            if self.cancel_bind then
                self.cancel_bind:Disconnect()
            end
            if self.moneybar then
                self.moneybar.PlaceBox.Visible = false
            end
            if self.buildmenu_list then
                self.buildmenu_list.Visible = oldliststate 
            end
            mousedownconnection:Disconnect()
            mouse_move_connection:Disconnect()
            keypress_connection:Disconnect()
            SB:Destroy()
            
            
            if cancel then
                item:SetPrimaryPartCFrame(orig_cframe)
                if isblueprint then
                    item:Destroy()
                end
                wait(.3)
                self.build_mouse.TargetFilter = nil
                self.is_placing = false
                return
            end
            
            local sound = Instance.new("Sound", game.Workspace)
            sound.SoundId = "rbxassetid://125762586"
            sound:Play()
            sound.Stopped:Connect(function()
                sound:Destroy()
            end)
            
            
            if not isblueprint then
                local blueprint_name = item:FindFirstChild("BlueprintWoodClass") and item.BlueprintWoodClass.Value
                game:GetService("ReplicatedStorage").PlaceStructure.ClientPlacedStructure:FireServer(item_name, item.PrimaryPart.CFrame, game.Players.LocalPlayer, blueprint_name, item, true)
            else
                local bp_name = item.ItemName.Value
                game:GetService("ReplicatedStorage").PlaceStructure.ClientPlacedBlueprint:FireServer(item.ItemName.Value, item.PrimaryPart.CFrame, game.Players.LocalPlayer)
                item:Destroy()
                self.build_mouse.TargetFilter = nil
                self.is_placing = false
                self:build_item(bp_name, isblueprint)
            end
            wait(.3)
            self.build_mouse.TargetFilter = nil
            self.is_placing = false
        end,
        
        
        build_wall = function(self)
            local plot = self:get_plot()
            if self.is_placing then return end
            self.is_placing = true
            local Model = Instance.new('Model', game.Workspace)
            Model.Name = 'Wall'
            self.build_mouse.TargetFilter = Model
            local WallPart1 = Instance.new('Part', Model)
            WallPart1.Name = 'Pole1'
            WallPart1.Anchored = true
            WallPart1.Transparency = 0.2
            WallPart1.Material = Enum.Material.SmoothPlastic
            WallPart1.Shape = 'Cylinder'
            WallPart1.Size = Vector3.new(9, 0.4, 0.4)
            local WallPart2
            local WallPart
            local move_mouse_a 
            local move_mouse_b
            local can_place = true
            move_mouse_a = self.build_mouse.Move:Connect(function()
                    local MouseP = self.build_mouse.Hit.p
                    WallPart1.CFrame = CFrame.new(self:round_vector(MouseP+Vector3.new(0,WallPart1.Size.X/2,0), 2)+Vector3.new(0.2,0,0.5))*CFrame.Angles(0,0,math.rad(90))
                    if not self:located_on_plot(WallPart1.CFrame) then
                        can_place = false
                        WallPart1.BrickColor = BrickColor.Red()
                    else
                        can_place = true
                        WallPart1.BrickColor = BrickColor.Gray()
                    end
            end)
            repeat
                self.build_mouse.Button1Down:wait()
            until can_place
            
            move_mouse_a:Disconnect()
            
            --second wall and now process the middle
            WallPart = Instance.new('Part', Model)
            WallPart.Anchored = true
            WallPart.Transparency = 0.2
            WallPart.Material = Enum.Material.SmoothPlastic
            WallPart.Name = 'WallPart'
            WallPart.Orientation = Vector3.new(0,0,math.rad(90))
            WallPart.Size = Vector3.new(9, 12, 0.4)
            
            --wallpart2
            WallPart2 = Instance.new('Part', Model)
            WallPart2.Name = 'Pole2'
            WallPart2.Anchored = true
            WallPart2.Transparency = 0.2
            WallPart2.Material = Enum.Material.SmoothPlastic
            WallPart2.Shape = 'Cylinder'
            WallPart2.Size = Vector3.new(9, 0.4, 0.4)
            move_mouse_b =  self.build_mouse.Move:Connect(function()
                local MouseP = self.build_mouse.Hit.p
                local target_cframe = CFrame.new(self:round_vector(MouseP+Vector3.new(0,WallPart2.Size.X/2,0), 2)+Vector3.new(0.2,0,0.5))*CFrame.Angles(0,0,math.rad(90))
                
                
                WallPart2.CFrame = target_cframe
                WallPart.Size = Vector3.new((WallPart1.Position - WallPart2.Position).Magnitude,9,0.4)
                WallPart.CFrame = CFrame.new(
                    WallPart1.Position + 0.5*(WallPart2.Position - WallPart1.Position),
                    WallPart1.Position + 0.5*(WallPart2.Position - WallPart1.Position) + (WallPart1.Position - WallPart2.Position).Unit:Cross(Vector3.new(0,1,0))
                )
                
                if not self:located_on_plot(WallPart2.CFrame) then
                    can_place = false
                    WallPart2.BrickColor = BrickColor.Red()
                    WallPart.BrickColor = BrickColor.Red()
                else
                    can_place = true
                    WallPart2.BrickColor = BrickColor.Gray()
                    WallPart.BrickColor = BrickColor.Gray()
                end	
            end)
            repeat
                self.build_mouse.Button1Up:wait()
            until can_place
            move_mouse_b:Disconnect()
            self.is_placing = false
            WallPart1.Transparency = 0
            WallPart2.Transparency = 0
            WallPart.Transparency = 0
            
            
            --WallPart1:Destroy()
            --WallPart2:Destroy()
            WallPart.Parent = Model
            WallPart.Transparency = 0
            
            local x_move = math.abs(WallPart2.Position.X-WallPart1.Position.X)
            local y_move = math.abs(WallPart2.Position.Y-WallPart1.Position.Y)
            local c 
            if x_move == 0 then 
                c = y_move
            elseif y_move == 0 then
                c=x_move
            else
                c = math.sqrt(x_move^2 + y_move^2)
            end
            --if c % 4 ~= 0 then return end

            print(c/4)
            
            Model.PrimaryPart = WallPart
            Model:Destroy()
            
            
        end,
        
        
        
        --copy
        copy_clipboard = function(self, text)
            setclipboard(text)
        end,
        -- block/unblock save
        block_save = function(self)
            getgenv().block_save = true
        end,
        unblock_save = function(self)
            getgenv().block_save = false
        end,
        cleanup = function(self)
            print("Do Cleanup Stuff!")
            if self.walkspeed_connection ~= nil then
                self.walkspeed_connection:Disconnect()
            end
            
            self:disable_no_fog()
            self:disable_full_bright()
            self:set_solid_water(false)
            self:unblock_save()
            self:set_annoy_server(false)
            self:destroy_preview()
            return nil
        end

    }
    if script:IsA("ModuleScript") then return api end

    if is_sirhurt_closure then
        wait(2)
    end

    --end of paste
    ls_api = api
    return api
end
local w7 = main:CreateCategory("Bases")
w7:CreateSection("Build Mode"):Create("Button", "Enter Build Mode", function()
    if not pcall(function() get_ls_api():get_plot() end) then
        ShowMSG("Please load a plot first!",3)
        return
    end
    _G.CurrentBarkUI.Motherframe.Visible = false
    get_ls_api().gui_mainframe = _G.CurrentBarkUI.Motherframe
    get_ls_api():enter_build_mode(game:GetObjects("rbxassetid://5966142145")[1].assets)
end)
commands['buildmode'] = function()
    if not pcall(function() get_ls_api():get_plot() end) then
        ShowMSG("Please load a plot first!",3)
        return
    end
    _G.CurrentBarkUI.Motherframe.Visible = false
    get_ls_api().gui_mainframe = _G.CurrentBarkUI.Motherframe
    
    get_ls_api():enter_build_mode(game:GetObjects("rbxassetid://5966142145")[1].assets)
end
local bwps = w7:CreateSection("Player")
local cplrw = game.Players.LocalPlayer
bwps:Create(
    "Dropdown",
    "From Player",
    function(newa)
        cplrw = newa
    end,
    {
        text = "",
        playerlist = true
    }
)
-- wipe base options
local tool = false
local planks = false
local loose_items = false
local gift = false
local boxed_structures = false
local instadrop = false
local horizontal = false
local selected_item = ""

local items_list = {}
local temp_table = {}
local items_table = {}
items_table.Misc = {}
for i,v in pairs (game:GetService("ReplicatedStorage").Purchasables:GetDescendants()) do
    if v:IsA("Folder") and v:FindFirstChild("ItemName") and v.Parent.Name ~= "BlueprintStructures" then
        if v:FindFirstChild("Type") then
            if items_table[v.Type.Value] == nil then
                items_table[v.Type.Value] = {}
            end
            items_table[v.Type.Value][v.ItemName.Value] = v.Name
        else
            items_table.Misc[v.ItemName.Value] = v.Name
        end
    end
end
for i,v in pairs(items_table) do
    table.sort(v, function(a, b)return a.Name:lower()<b.Name:lower()end)
    for i2,v2 in pairs (v) do
        table.insert(items_list,i2)
        temp_table[i2] = v2
    end
end
items_table = temp_table
temp_table = nil

local settings = w7:CreateSection("Base Drop Settings")
local ItemToTeleport = nil
settings:Create(
    "Dropdown",
    "ItemName",
    function(newp)
        ItemToTeleport = items_table[newp]
    end,
    {
        options=items_list,
        search = true;
    }
)
local PlankToTeleport = nil
settings:Create(
    "Dropdown",
    "Plank",
    function(newp)
        PlankToTeleport = newp
    end,
    {
        options={"Specific Plank","Generic","Oak","SnowGlow","CaveCrawler","SpookyNeon","Walnut","LoneCave","Cherry","Birch","Palm","Pine","Koa","Volcano","GoldSwampy","GreenSwampy","Spooky","Frost","Fir"},
        search = true;
    }
)
settings:Create(
    "Toggle",
    "Tools",
    function(state)
        tool = state
    end,
    {
        default = false,
    }
) -- not aware of that
settings:Create(
    "Toggle",
    "Planks",
    function(state)
        planks = state
    end,
    {
        default = false,
    }
)
settings:Create(
    "Toggle",
    "Loose Items",
    function(state)
        loose_items = state
    end,
    {
        default = false,
    }
)
settings:Create(
    "Toggle",
    "Gifts",
    function(state)
        gift = state
    end,
    {
        default = false,
    }
)
settings:Create(
    "Toggle",
    "Boxed Structures",
    function(state)
        boxed_structures = state
    end,
    {
        default = false,
    }
)

--horizontal from v8.2
settings:Create("Toggle", 
    "Horizontal/Vertical",
    function(state)
	    horizontal = state
    end, 
    {
	    default = false
    }
)

local coord = nil

function identify_item_table(item_name)
    for i, v in pairs(items_table) do
        if v == item_name then
            return i
        end
    end
    return item_name
end
settings:Create(
"Button",
"Identify Item Tool",
function()
	if not game.Players.LocalPlayer.Backpack:FindFirstChild("Identify") then
		mouse = game.Players.LocalPlayer:GetMouse()
		local StarterGui = game:GetService("StarterGui")
		Identify = Instance.new("Tool")
		Identify.RequiresHandle = false
		Identify.Name = "Identify"
		Identify.Activated:connect(function()
			if mouse.Target.Parent:FindFirstChild("PurchasedBoxItemName") then
				StarterGui:SetCore("SendNotification", {
					Title = "ItemName",
                    Text = identify_item_table(mouse.Target.Parent.PurchasedBoxItemName.Value)
					--Text = mouse.Target.Parent.PurchasedBoxItemName.Value
				}
            )
			elseif mouse.Target.Parent:FindFirstChild("ItemName") then
				StarterGui:SetCore("SendNotification", {
					Title = "ItemName",
                    Text = identify_item_table(mouse.Target.Parent.ItemName.Value)
					--Text = mouse.Target.Parent.ItemName.Value
				}
            )
			elseif mouse.Target.Parent:FindFirstChild("TreeClass") then
				StarterGui:SetCore("SendNotification", {
					Title = "TreeClass",
					Text = mouse.Target.Parent.TreeClass.Value
				}
            )
			end
		end)
		Identify.Parent = game.Players.LocalPlayer.Backpack
	end
end,
{
	animated = true,
}
)
settings:Create(
    "Button",
    "Set Coordinates",
    function(state)
        if game.Workspace:FindFirstChild("BarkCoord") then
            game.Workspace.BarkCoord:Destroy()
        end
        coord = Instance.new("Part",game.Workspace)
        coord.Name = "BarkCoord"
        coord.Anchored = true
        coord.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
        coord.CanCollide = false
        coord.Size = Vector3.new(2,2,2)
        local a = Instance.new("BoxHandleAdornment", coord)
		a.Name = "Selection"
		a.Adornee = a.Parent
		a.AlwaysOnTop = true
		a.ZIndex = 0
		a.Size = a.Parent.Size
		a.Transparency = 0
		a.Color = BrickColor.new("Electric blue")
    end,
    {
        animated = true,
    }
)
settings:Create(
    "Button",
    "Delete Coordinates",
    function(state)
        if game.Workspace:FindFirstChild("BarkCoord") then
            game.Workspace.BarkCoord:Destroy()
        end
    end,
        {
    animated = true,
}
)
settings:Create(
    "Toggle",
    "Instant Base Drop Mode (patched)",
    function(state)
        instadrop = state
        if state then
            notify("Instant Base Drop", "When using this, you can only base drop from YOURSELF to someone else, who is the selected player.",10)
            notify("", "This player MUST WHITELIST YOU for this method to work. Coordinates are not used in this mode. Items will go to the center.",10)
            notify("", "Finally, using planks are not supported in this mode.",10)
        end
    end,
    {
        default = false,
    }
)
local ftr_bd = not dbgmode
local wipe_do = w7:CreateSection'Base Actions'
function primpart(a)
	return a:FindFirstChild("Main") or a:FindFirstChild("WoodSection") or a:FindFirstChildOfClass("Part")
end
local maxlim = 60

function do_basedrop(clusters)
    for _, cluster in pairs(clusters) do
        local old = #cluster < 7
        notify("Base Drop", "Switched cluster, using "..((old and "old") or "bulk").." method.")
        local target = CFrame.new(coord.CFrame.p) * CFrame.Angles(0,0,math.rad(0))
        if horizontal then
            target = CFrame.new(coord.CFrame.p) * CFrame.Angles(0,0,math.rad(90))
        end
        _G.DogixLT2TPC(primpart(cluster[1]).CFrame, gkey)
        wait(.5)
        local esps = {}
        for _, item in pairs(cluster) do
            local a = esp_part(primpart(item))
            table.insert(esps, a)
            if old then
                spawn(function()
                    _G.DogixLT2DragAlt(primpart(item), target)
                end)
            else
                spawn(function()
                    _G.DogixLT2Drag(primpart(item), target)
                end)
            end
        end
        wait((old and 1.5) or 4)
        for _, a in pairs(esps) do
            a:Destroy()
        end
        if _G.baseDropToggle == false then
            _G.baseDropToggle = true
            notify("Base Drop", "Cancelled teleporting.",1)
            break
        end
    end
end

wipe_do:Create(
"Button",
"Base Drop Selected Item",
function()
    if game:GetService("ReplicatedStorage").Interaction.ClientIsWhitelisted:InvokeServer(game.Players[tostring(cplrw)]) == false and game.Players[tostring(cplrw)] ~= game.Players.LocalPlayer then
        notify("Base Drop","You are not whitelisted currently.",3)
        return
    end
    if ftr_bd == true then
        notify("Base Drop Terms", "By continuing to use Base Drop, you agree that you are responsible for all consequences that occur beyond this point. Dogix is not",10)
        notify(""," responsible in any way, shape, or form involving any actions and consequences of any Bark related function. Proceed only if you understand",10)
        notify(""," and agree to these terms.",10)
        if not confirm(true) then return end
        ftr_bd = false
    end
    if coord == nil then
        notify("Base Drop","No coordinate detected.",3)
        return
    end
    if not instadrop then
        local clusters = {}
    	function delete(model)
    		if #clusters == 0 then
    			table.insert(clusters, {
    				model
    			})
    		else
    			local isClustered = false
    			for _, cluster in pairs(clusters) do
    				if (primpart(model).CFrame.p - primpart(cluster[1]).CFrame.p).Magnitude < 40 and #cluster < maxlim then
    					table.insert(cluster, model)
    					isClustered = true
    					break
    				end
    			end
    			if not isClustered then
    				table.insert(clusters, {
    					model
    				})
    			end
    		end
    	end
        notify("Base Drop", "Clustering items.",1)
        wait()
        for i,v in pairs (game.Workspace.PlayerModels:children()) do
            if v:FindFirstChild'Owner' and (v:FindFirstChild"ItemName" or v:FindFirstChild"PurchasedBoxItemName") then
                local nm = v:FindFirstChild"ItemName" or v:FindFirstChild"PurchasedBoxItemName"
                if tostring(v.Owner.Value) == tostring(cplrw) and nm.Value == ItemToTeleport then
                    delete(v)
                end
            end
        end
        
        do_basedrop(clusters)
    else
        local baseCFrame = nil
        for _,v1 in pairs (game.Workspace.Properties:GetChildren()) do
            if tostring(v1.Owner.Value) == tostring(cplrw) then
                baseCFrame = v1.OriginSquare.CFrame
                break
            end
        end
        if not baseCFrame then return end
        local target = CFrame.new(coord.CFrame.p) * CFrame.Angles(0,0,math.rad(0))
        if horizontal then
            target = CFrame.new(coord.CFrame.p) * CFrame.Angles(0,0,math.rad(90))
        end
        if locatedOnPlot(target) then
            baseCFrame = target
        end
        dropMeme(ItemToTeleport, baseCFrame)
    end
    notify("Base Drop", "Finished teleporting.",1)
end,
{
    animated = true,
}
)
_G.baseDropToggle = true
wipe_do:Create(
"Button",
"Base Drop Selected Planks",
function()
    if game:GetService("ReplicatedStorage").Interaction.ClientIsWhitelisted:InvokeServer(game.Players[tostring(cplrw)]) == false and game.Players[tostring(cplrw)] ~= game.Players.LocalPlayer then
        notify("Base Drop","You are not whitelisted currently.",3)
        return
    end
    if coord == nil then
        notify("Base Drop","No coordinate detected.",3)
        return
    end
    if ftr_bd == true then
        notify("Base Drop Terms", "By continuing to use Base Drop, you agree that you are responsible for all consequences that occur beyond this point. Dogix is not",10)
        notify(""," responsible in any way, shape, or form involving any actions and consequences of any Bark related function. Proceed only if you understand",10)
        notify(""," and agree to these terms.",10)
        if not confirm(true) then return end
        ftr_bd = false
    end
    local clusters = {}
	function delete(model)
		if #clusters == 0 then
			table.insert(clusters, {
				model
			})
		else
			local isClustered = false
			for _, cluster in pairs(clusters) do
				if (primpart(model).CFrame.p - primpart(cluster[1]).CFrame.p).Magnitude < 40 and #cluster < maxlim then
					table.insert(cluster, model)
					isClustered = true
					break
				end
			end
			if not isClustered then
				table.insert(clusters, {
					model
				})
			end
		end
	end
    notify("Base Drop", "Clustering items.",1)
    wait()
    for i,v in pairs (game.Workspace.PlayerModels:children()) do
        if v:FindFirstChild'Owner' and v:FindFirstChild"TreeClass" then
            local nm = v:FindFirstChild"TreeClass"
            if tostring(v.Owner.Value) == tostring(cplrw) and nm.Value == PlankToTeleport then
                delete(v)
            end
        end
    end
    --replacing it with one function
    do_basedrop(clusters)
    notify("Base Drop", "Finished teleporting.",1)
end,
{
    animated = true,
}
)
wipe_do:Create(
    "Button",
    "Base Drop Selected Categories",
    function(state)
        if game:GetService("ReplicatedStorage").Interaction.ClientIsWhitelisted:InvokeServer(game.Players[tostring(cplrw)]) == false and game.Players[tostring(cplrw)] ~= game.Players.LocalPlayer then
            notify("Base Drop","You are not whitelisted currently.",3)
            return
        end
        if ftr_bd == true then
            notify("Base Drop Terms", "By continuing to use Base Drop, you agree that you are responsible for all consequences that occur beyond this point. Dogix is not",10)
            notify(""," responsible in any way, shape, or form involving any actions and consequences of any Bark related function. Proceed only if you understand",10)
            notify(""," and agree to these terms.",10)
            if not confirm(true) then return end
            ftr_bd = false
        end
        if not instadrop then
            if coord == nil then
                notify("Base Drop","To use this feature, please set a coordinate.",3)
                return
            end
            local clusters = {}
        	function delete(model)
        		if #clusters == 0 then
        			table.insert(clusters, {
        				model
        			})
        		else
        			local isClustered = false
        			for _, cluster in pairs(clusters) do
        				if (primpart(model).CFrame.p - primpart(cluster[1]).CFrame.p).Magnitude < 40 and #cluster < maxlim then
        					table.insert(cluster, model)
        					isClustered = true
        					break
        				end
        			end
        			if not isClustered then
        				table.insert(clusters, {
        					model
        				})
        			end
        		end
        	end
            notify("Base Drop", "Clustering items.",1)
            wait()
            for i,v in pairs (game.Workspace.PlayerModels:children()) do
                if v:FindFirstChild'Owner' then
                    if tostring(v.Owner.Value) == tostring(cplrw) then
                        if v:FindFirstChild'Type' then
                            if v.Type.Value == "Gift" and gift then delete(v)
                            elseif v.Type.Value == "Loose Item" and loose_items then delete(v)
                            elseif v.Type.Value == "Tool" and tool then delete(v)
                            elseif (v.Type.Value == "Structure" or v.Type.Value == "Furniture" or v.Type.Value == "Wire") and v:FindFirstChild("PurchasedBoxItemName") and boxed_structures then delete(v)
                            elseif v.Name == selected_item and selected_item ~= "" then delete(v)
                            end
                        elseif v:FindFirstChild'WoodSection' then
                            if planks then
                                delete(v)
                            end
                        end
                    end
                end
            end
            do_basedrop(clusters)
	    else
            local baseCFrame = nil
            for _,v1 in pairs (game.Workspace.Properties:GetChildren()) do
                if tostring(v1.Owner.Value) == tostring(cplrw) then
                    baseCFrame = v1.OriginSquare.CFrame
                    break
                end
            end
            if not baseCFrame then return end
            local target = CFrame.new(coord.CFrame.p) * CFrame.Angles(0,0,math.rad(0))
            if horizontal then
                target = CFrame.new(coord.CFrame.p) * CFrame.Angles(0,0,math.rad(90))
            end
            if locatedOnPlot(target) then
                baseCFrame = target
            end
            for i,v in pairs (game.Workspace.PlayerModels:children()) do
                if v:FindFirstChild'Owner' then
                    if tostring(v.Owner.Value) == game.Players.LocalPlayer.Name then
                        if v:FindFirstChild'Type' then
                            if v.Type.Value == "Gift" and gift then
                                dirtBaseDropInstant(v, baseCFrame)
                            elseif v.Type.Value == "Loose Item" and loose_items then
                                dirtBaseDropInstant(v, baseCFrame)
                            elseif v.Type.Value == "Tool" and tool then
                                dirtBaseDropInstant(v, baseCFrame)
                            elseif (v.Type.Value == "Structure" or v.Type.Value == "Furniture" or v.Type.Value == "Wire") and v:FindFirstChild("PurchasedBoxItemName") and boxed_structures then
                                dirtBaseDropInstant(v, baseCFrame)
                            end
                        end
                    end
                end
            end
	    end
        notify("Base Drop", "Finished teleporting.",1)
    end,
    {
        animated = true,
    }
)

wipe_do:Create(
    "Button",
    "Cancel Base Drop",
    function()
        notify('Bark '..cv, 'Base Drop stopped.')
        _G.baseDropToggle = false
        wait(10)
        _G.baseDropToggle = true
    end,
    {
        animated = true,
    }
)

wipe_do:Create(
    "Button",
    "Fill All Blueprints Gray",
    function(state)
        if game:GetService("ReplicatedStorage").Interaction.ClientIsWhitelisted:InvokeServer(game.Players[tostring(cplrw)]) == false and game.Players[tostring(cplrw)] ~= game.Players.LocalPlayer then
            notify("Base Drop","You are not whitelisted currently.",3)
            return
        end
        if ftr_bd == true then
            notify("Base Drop Terms", "By continuing to use Base Drop, you agree that you are responsible for all consequences that occur beyond this point. Dogix is not",10)
            notify(""," responsible in any way, shape, or form involving any actions and consequences of any Bark related function. Proceed only if you understand",10)
            notify(""," and agree to these terms.",10)
            if not confirm(true) then return end
            ftr_bd = false
        end
        local Event = game:GetService("ReplicatedStorage").PlaceStructure.ClientPlacedStructure
        for _,v in pairs (game.Workspace.PlayerModels:GetChildren()) do
            if v:FindFirstChild("Owner") then
                if v:FindFirstChild("BuildDependentWood") and v:FindFirstChild("Type") then
                    if v.Type.Value == "Blueprint" then
                        local cf_ = nil
                        if v:FindFirstChild("MainCFrame") then
                            cf_ = v.MainCFrame.Value
                        else
                            cf_ = v.PrimaryPart.CFrame
                        end
                        Event:FireServer(v.ItemName.Value, cf_, game:GetService'Players'.LocalPlayer, nil, v, true)
                    end
                end
            end
        end
    end,
    {
        animated = true,
    }
)
local xd_autofill = nil
wipe_do:Create(
    "Toggle",
    "Auto-Fill All Blueprints Gray",
    function(state)
        if state then
            local Event = game:GetService("ReplicatedStorage").PlaceStructure.ClientPlacedStructure
            for _,v in pairs (game.Workspace.PlayerModels:GetChildren()) do
                if v:FindFirstChild("Owner") then
                    if v:FindFirstChild("BuildDependentWood") and v:FindFirstChild("Type") then
                        if v.Type.Value == "Blueprint" then
                            local cf_ = nil
                            if v:FindFirstChild("MainCFrame") then
                                cf_ = v.MainCFrame.Value
                            else
                                cf_ = v.PrimaryPart.CFrame
                            end
                            Event:FireServer(v.ItemName.Value, cf_, game:GetService'Players'.LocalPlayer, nil, v, true)
                        end
                    end
                end
            end
            xd_autofill = game.Workspace.PlayerModels.ChildAdded:connect(function(v)
                wait(0.3)
                if v:FindFirstChild("Owner") then
                    if v:FindFirstChild("BuildDependentWood") and v:FindFirstChild("Type") then
                        if v.Type.Value == "Blueprint" then
                            local cf_ = nil
                            if v:FindFirstChild("MainCFrame") then
                                cf_ = v.MainCFrame.Value
                            else
                                cf_ = v.PrimaryPart.CFrame
                            end
                            Event:FireServer(v.ItemName.Value, cf_, game:GetService'Players'.LocalPlayer, nil, v, true)
                        end
                    end
                end
            end)
        else
            if xd_autofill ~= nil then
                xd_autofill:Disconnect()
                xd_autofill = nil
            end
        end
    end,
    {
        default = false,
    }
)
function noclipfunct(txx)
    _G.nc_toggle = txx or not _G.nc_toggle
    if _G.nc_toggle then
        if _G.Noclipping ~= nil then
            game.Players.LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Zoom
            _G.Noclipping:Disconnect()
            _G.Noclipping = nil
            game.Players.LocalPlayer.Character.Humanoid:ChangeState(7)
        end
        game.Players.LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam
        _G.Noclipping = game:GetService'RunService'.Stepped:connect(oldnocliprun)
    else
        if _G.Noclipping ~= nil then
            game.Players.LocalPlayer.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Zoom

            _G.Noclipping:Disconnect()
            _G.Noclipping = nil
            game.Players.LocalPlayer.Character.Humanoid:ChangeState(7)
        end
    end
end

--copy base and saving features
local function copysavebasehandle()
    local wipe_do = w7:CreateSection'Copy Base'
    wipe_do:Create(
    "Button",
    "How do I use this?",
    function(input)
        local txtArray = {
            "First, select the player you want to copy at the top of this tab.",
            "Next, type in a file name into Save Player Base to File.",
            "You can then share this file to other people if you wish. They must put it in their exploit's workspace.",
            "To load a saved base, enter the file name (don't include .bark_dump) in the Remake Player Base box.",
            "It will then use Legit Paint to copy the base. If it can't locate the correct tree, it will skip.",
            "This is a very buggy function, but there will be improvements soon!"
        }
        for i,v in pairs (txtArray) do
            notify("", v, 6)
            wait(6)
        end
    end,
    {
        animated = true
    }
    )

    function save_base_dump()
        local struct_table = {}
        local offset = nil
        local blacklisted_usernames = {
            "LT2_BaseDrop3",
        }
        for i,v in pairs (blacklisted_usernames) do
            if v == tostring(cplrw) then
                notify("Base Dump", "This user cannot be base dumped.")
                return
            end
        end
        for _,v1 in pairs (game.Workspace.Properties:children()) do
            if tostring(v1.Owner.Value) == tostring(cplrw) then
                offset = v1.OriginSquare.CFrame
                break
            end
        end
        for _,v in pairs (game.Workspace.PlayerModels:GetChildren()) do
            if v:FindFirstChild("Owner") then
                if tostring(v.Owner.Value) == tostring(cplrw) then
                    if v:FindFirstChild("BuildDependentWood") and v:FindFirstChild("Type") then
                        if v.Type.Value == "Structure" then
                            table.insert(struct_table, {
                                ["Blueprint"] = v.ItemName.Value,
                                ["CFrame"] = {(v.MainCFrame.Value-offset.p):components()},
                                ["WoodType"] = (v:FindFirstChild"BlueprintWoodClass" and v.BlueprintWoodClass.Value) or nil
                            })
                        end
                    end
                end
            end
        end
        return "-- bark winning -- base dump format v1 --\n"..b64l.encode(game:GetService("HttpService"):JSONEncode(struct_table))
    end
    if is_bark_executor then
        wipe_do:Create(
            "Button",
            "Save Player Base to File",
            function()
                local filter = "Bark Dump Files (*.bark_dump)|*.bark_dump"
                local success, resp = pcall(call_rpc, "savefile-dialog", {title="Enter Base Dump Name", customfilter=filter, content=save_base_dump()}, "POST")
                if not success then 
                    notify("Error", "File Dialog Cancelled!")
                    return
                end
                notify("Base Dump", "Base Saved!")
            end
        )
    else
        wipe_do:Create(
            "TextBox",
            "Save Player Base to File",
            function(input)
                local payload = save_base_dump()
                writefile(input..".bark_dump",payload)
                notify("Base Dump", "Dumped base to: "..input..".bark_dump")
            end,
            {
                text = "File Name"
            }
        )
    end


    local function legit_remakebase(input)
        local sawmill = getBestSawmill()
        local axe = getBestAxe()
        if not sawmill then
            notify("Copy Base", "You need a sawmill to use this feature!", 3)
            return
        elseif not axe then
            notify("Copy Base", "You need a axe to use this feature!", 3)
            return
        end
        
        local struct_table = dumpToTable(input)
        notify("Copy Base", "By continuing to use this, you agree that you want to copy a base!",10)
        local hours = 0
        local minutes = 0
        local seconds = 0
        for _,v in pairs (struct_table) do
            if v.WoodType ~= nil then
                seconds = seconds + 10
            else
                seconds = seconds + 0.1
            end
        end
        minutes = math.floor(seconds / 60)
        seconds = seconds - minutes * 60
        hours = math.floor(minutes / 60)
        minutes = minutes - hours * 60
        notify("Copy Base", "Bark estimates that this will take "..hours.."h, "..minutes.."m, and "..seconds.."s.",10)
        notify("Copy Base", "By confiriming, you agree that you cannot cancel once you start, and that you want to copy this base.",10)
        if not confirm(true) then return end
        local offset = nil
        for _,v1 in pairs (game.Workspace.Properties:children()) do
            if tostring(v1.Owner.Value) == tostring(cplrw) then
                offset = v1.OriginSquare.CFrame
                break
            end
        end
        for i,v in pairs (struct_table) do
            if doesTreeExist(v.WoodType) then
                local bp = nil
                local wsca = game.Workspace.PlayerModels.ChildAdded:connect(function(va)
                    va:WaitForChild("Owner")
                    if va.Owner.Value == game.Players.LocalPlayer then
                        repeat wait() until (va:FindFirstChild("ItemName") and va:FindFirstChild("Type")) or wait(3)
                        if not (va:FindFirstChild("ItemName") and va:FindFirstChild("Type")) then return end
                        if va:FindFirstChild("ItemName") and va:FindFirstChild("Type") then
                            if va.Type.Value == "Blueprint" and va.ItemName.Value == v.Blueprint then
                                bp = va
                            end
                        end
                    end
                end)
                game:GetService("ReplicatedStorage").PlaceStructure.ClientPlacedBlueprint:FireServer(v.Blueprint, CFrame.new(unpack(v.CFrame))+offset.p, game.Players.LocalPlayer)
                repeat wait() until bp
                wsca:Disconnect()
                wsca = nil
                if v.WoodType ~= nil then
                    pcall(function()
                        lumbsmasher_legitpaint(v.WoodType, bp)
                    end)
                else
                    game:GetService("ReplicatedStorage").PlaceStructure.ClientPlacedStructure:FireServer(v.Blueprint, CFrame.new(unpack(v.CFrame))+offset.p, game:GetService'Players'.LocalPlayer, nil, bp, true)
                end
            else
                notify("Copy Base", "Couldn't find eligible tree, skipping",1)
            end
        end
        notify("Copy Base", "Finished.",3)
    end

    if not is_bark_executor and not (identifyexecutor and identifyexecutor() == "ScriptWare") then
        wipe_do:Create("TextBox","Remake Player Base from File", function(input)
                if pcall(function()
                    readfile(input..".bark_dump")
                end) == false then
                    notify("Copy Base", "Couldn't find dump!", 3)
                    return
                end
                legit_remakebase(readfile(input..".bark_dump"))
            end,
            {
                text = "File Name"
            }
        )
    else
        wipe_do:Create("Button", "Remake Player Base from File", function()
            local filter = "Bark Dump Files (*.bark_dump)|*.bark_dump"
            local success, resp
            if is_bark_executor then 
                success, resp = pcall(call_rpc, "selectfile-dialog", {title="Select Bark Base Dump File", customfilter=filter}, "POST")
            else
                success, resp = readdialog("Select Bark Base Dump File", filter)
                resp = {content=resp}
            end
            if not success then 
                notify("Error", "File Dialog Cancelled!")
                return
            end
            legit_remakebase(resp.content)
        end)
    end

    --remake from gray in bark 8.2
    local vipserv = false
    function autobuild_structure_table(struct_table)
        local hours = 0
        local minutes = 0
        local seconds = 0
        for _,v in pairs (struct_table) do
            seconds = seconds + 0.01
        end
        minutes = math.floor(seconds / 60)
        seconds = seconds - minutes * 60
        hours = math.floor(minutes / 60)
        minutes = minutes - hours * 60
        notify("Copy Base", "Bark estimates that this will take "..hours.."h, "..minutes.."m, and "..seconds.."s.",10)
        notify("Copy Base", "By confiriming, you agree that you cannot cancel once you start, and that you want to copy this base.",10)
        if not confirm(true) then return end
        local offset = nil
        for _,v1 in pairs (game.Workspace.Properties:children()) do
            if tostring(v1.Owner.Value) == tostring(cplrw) then
                offset = v1.OriginSquare.CFrame
                break
            end
        end
        local int = 0
        local int2 = {}
        local wsca = game.Workspace.PlayerModels.ChildAdded:connect(function(va)
            va:WaitForChild("Owner")
            if va.Owner.Value == game.Players.LocalPlayer or tostring(va.Owner.Value) == tostring(cplrw) then
                va:WaitForChild("ItemName", 3)
                va:WaitForChild("Type", 1)
                if not (va:FindFirstChild("ItemName") and va:FindFirstChild("Type")) then return end
                if va.Type.Value == "Blueprint" then
                    local primcframe = (va.PrimaryPart and va.PrimaryPart.CFrame) or (va:FindFirstChild("Main") and va.Main.CFrame) or (va:FindFirstChild("MainCFrame") and va.MainCFrame.Value)
                    game:GetService("ReplicatedStorage").PlaceStructure.ClientPlacedStructure:FireServer(va.ItemName.Value, primcframe, game:GetService'Players'.LocalPlayer, nil, va, true)
                    table.insert(int2, "#barkwinning")
                end
            end
        end)

        for i,v in pairs(struct_table) do
            int = int + 1
            if int >= 40 then
                repeat game:GetService("RunService").RenderStepped:Wait() until #int2 >= 39
                wait((not vipserv and .5) or 0)
                int2 = {}
                int = 0
            end
            spawn(function()
                game:GetService("ReplicatedStorage").PlaceStructure.ClientPlacedBlueprint:FireServer(v.Blueprint, CFrame.new(unpack(v.CFrame))+offset.p, game.Players.LocalPlayer)
            end)
        end
        wait(1)
        wsca:Disconnect()
        wsca = nil
    end

    local function remakegray_dumpfile(input)
        local struct_table = shuffle(dumpToTable(input, true))
        autobuild_structure_table(struct_table)
        notify("Copy Base", "Finished.", 3)
    end

    if not is_bark_executor and not (identifyexecutor and identifyexecutor() == "ScriptWare") then
        wipe_do:Create("TextBox", "Remake Base from File (GRAY)", function(input)
            local success, filedata = pcall(readfile, input..".bark_dump")
            if not success then
                return notify("Error", "Invalid Base Dump File!")
            end
            remakegray_dumpfile(filedata)
        end, {
            text = "File Name"
        })
    else
        wipe_do:Create("Button", "Remake Base from File (GRAY)", function()
            local filter = "Bark Dump Files (*.bark_dump)|*.bark_dump"
            local success, resp
            if is_bark_executor then 
                success, resp = pcall(call_rpc, "selectfile-dialog", {title="Select Bark Base Dump File", customfilter=filter}, "POST")
            else
                success, resp = readdialog("Select Bark Base Dump File", filter)
                resp = {content=resp}
            end
            if not success then 
                notify("Error", "File Dialog Cancelled!")
                return
            end
            remakegray_dumpfile(resp.content)
        end)
    end
end
copysavebasehandle()

--greywood autobuilds
local function greywoodautobuildhandle()
    local wipe_do = w7:CreateSection'Auto-Build Gray Base'
    local selected_basebuild = {"MattTheManCastle", "MattTheManCastle"}
    --local options_table = game:HttpGet("https://dogix.wtf/scripts/lt2/barkdata/structures/index",true):split("\n")
    local options_table = game:HttpGetAsync("https://cdn.applebee1558.com/bark/autobuildstructureindex"):split("\n")
    for i,v in pairs (options_table) do
        if #v == 0 then
            options_table[i] = nil
        end
    end

    wipe_do:Create(
        "Dropdown",
        "base selector",
        function(input)
            selected_basebuild = {input, input:gsub(".", function(v)
                return (v == " " and "") or v
            end)}
        end,
        {
            options = options_table,
            search = true;
        }
    )
    wipe_do:Create(
        "Toggle",
        "VIP Server Mode (way faster)",
        function(input)
            vipserv = input
        end,
        {
            default = false;
        }
    )
    wipe_do:Create(
        "Button",
        "Auto-Build Selected Base",
        function(input)
            --local struct_table = shuffle(dumpToTable(game:HttpGet("https://dogix.wtf/scripts/lt2/barkdata/structures/"..selected_basebuild[2],true)))
            local struct_table = shuffle(dumpToTable(game:HttpGetAsync("https://cdn.applebee1558.com/bark/autobuilds/"..selected_basebuild[2],true)))
            notify("Copy Base", "By continuing to use this, you agree that you want to load "..selected_basebuild[1],10)
            autobuild_structure_table(struct_table)
            notify("Copy Base", "Finished.",3)
        end,
        {
            animated = true;
        }
    )

    wipe_do:Create("Button", "Clear Gray Plot Structures", function()
        if not confirm() then
            return
        end;
        for _, v in pairs(game.Workspace.PlayerModels:GetChildren()) do
            if v:FindFirstChild("Owner") and v:FindFirstChild("MainCFrame") and v:FindFirstChild("Type") and not v:FindFirstChild("BlueprintWoodClass") then
                if v.Owner.Value == game.Players.LocalPlayer and v.Type.Value == "Structure" then
                    delmodel(v)
                end
            end
        end
    end, {
        animated = true
    })
    
end
greywoodautobuildhandle()

--list items owned
local function owneditems()
    local function getowneditemlist()
        local indexing = {}
        local ownedlist = {}
        for i, v in pairs(game.Workspace.PlayerModels:GetChildren()) do
            if v:FindFirstChild("Owner") and (v:FindFirstChild("ItemName") or v:FindFirstChild("BoxItemName")) and v.Owner.Value == game.Players.LocalPlayer then
                local itemname = (v:FindFirstChild("ItemName") and v.ItemName.Value) or (v:FindFirstChild("BoxItemName") and v.BoxItemName)
                if not rawget(indexing, itemname) then
                    indexing[itemname] = 1
                end
            end
        end
        for i, _ in pairs(indexing) do
            table.insert(ownedlist, i)
        end
        return ownedlist
    end

    local function ownsitem(itemname, owned_list)
        if not owned_list then
            owned_list = getowneditemlist()
        end
        for i, v in pairs(owned_list) do
            if v == itemname then
                return true
            end
        end
        return false
    end
    main:CreateCategory("Base Items")
    local mapping = {
        no="<font color=\"#FF0000\">Not Owned!</font>",
        yes="<font color=\"#32CD32\">Owned!</font>"
    }
    
    local gui
    if getgenv().azure_theme then
        gui = _G.CurrentBarkUI.MainFrame.Categories["Base ItemsContainer"]['ScrollingFrame']
    else
        gui = _G.CurrentBarkUI.Motherframe.Categories["Base ItemsCategory"]
    end
    local frame = game:GetObjects("rbxassetid://6794114399")[1]
    frame.Parent = gui
    local allitemnames = {}
    for i, v in pairs(game.ReplicatedStorage.Purchasables.Structures.HardStructures:GetChildren()) do
        table.insert(allitemnames, {v.Name, v.ItemName.Value})
    end
    for i, v in pairs(game.ReplicatedStorage.Purchasables.Structures.BlueprintStructures:GetChildren()) do
        table.insert(allitemnames, {v.Name, v.ItemName.Value})
    end
    for i, v in pairs(game.ReplicatedStorage.Purchasables.Tools.AllTools:GetChildren()) do
        table.insert(allitemnames, {v.Name, v.ItemName.Value})
    end
    for i, v in pairs(game.ReplicatedStorage.Purchasables.Other:GetChildren()) do
        table.insert(allitemnames, {v.Name, v:FindFirstChild("ItemName") and v.ItemName.Value})
    end
    for i, v in pairs(game.ReplicatedStorage.Purchasables.WireObjects:GetChildren()) do
        table.insert(allitemnames, {v.Name, v.ItemName.Value})
    end
    for i, v in pairs(game.ReplicatedStorage.Purchasables.Vehicles:GetChildren()) do
        table.insert(allitemnames, {v.Name, v.ItemName.Value})
    end

    local template = frame.frameHandler.itemsFrame.template
    template.Visible = false
    function showitems(search)
        --print(search)
        for i, v in pairs(frame.frameHandler.itemsFrame:GetChildren()) do
            if v:IsA("TextButton") and v.Name ~= "template" then
                v:Destroy()
            end
        end
        frame.frameHandler.itemsFrame.CanvasSize = UDim2.new(0,0,0,0)
        local size_y = 0
        local owneditems = getowneditemlist()
        for _, b in pairs(allitemnames) do
            local v = b[1]
            local nicename = b[2]
            if search then search  = search:lower() end
            if not search or search == "" or string.find(v:lower(), search, 1, true) or string.find((nicename and nicename:lower()) or v, search, 1, true) then
                local clone = template:Clone()
                clone.Visible = true
                clone.Button.Text = nicename or v
                clone.Status.Text = mapping.no
                clone.Name = v
                size_y = size_y + clone.AbsoluteSize.Y
                if ownsitem(v, owneditems) then
                    clone.Status.Text = mapping.yes
                end
                clone.Parent = frame.frameHandler.itemsFrame
            end
        end
        frame.frameHandler.itemsFrame.CanvasSize = UDim2.new(0,0,0,size_y)
    end
    showitems()
    frame.searchBox.Changed:Connect(function(property)
        if property == "Text" then
            showitems(frame.searchBox.Text)
        end
    end)
    local lastupdated = tick()
    _G.ItemListAddBind = game.Workspace.PlayerModels.ChildAdded:Connect(function(child)
        local owner = child:WaitForChild("Owner", 5)
        if not owner or owner.Value ~= game.Players.LocalPlayer then return end
        
        if tick() - lastupdated > 5 then
            showitems(frame.searchBox.Text)
            lastupdated = tick()
        end
    end)
    _G.ItemListRemoveBind = game.Workspace.PlayerModels.ChildRemoved:Connect(function(child)
        local owner = child:FindFirstChild("Owner")
        if not owner or owner.Value ~= game.Players.LocalPlayer then return end
        if tick() - lastupdated > 5 then
            showitems(frame.searchBox.Text)
            lastupdated = tick()
        end
    end)
end
if not _G.alphax_ui_init then
    owneditems()
end

--wireart
local function wireart()
    local function equalize_vector(pointa, pointb, dist)
        dist = dist-2
        local unit = (pointb-pointa).Unit
        local new_wires = {}
        while (pointb-pointa).magnitude > dist do
            table.insert(new_wires, {pointa, pointa+(unit*dist)})
            pointa = pointa+unit*dist
        end
        table.insert(new_wires, {pointa, pointb})
        return new_wires
    end
    local function fix_vectors(vector3_table, max_dist, rotation)
       

        if dist == nil then dist = 30 end
        local wires = {}
        local wire_distance = 0
        local last_vector
        local wire_vectors = {}
        for i, point in pairs(vector3_table) do
            if last_vector == nil then
                last_vector = point
                table.insert(wire_vectors, last_vector)
            else
                local wire_dist = (point-last_vector).Magnitude
                if wire_distance+wire_dist > max_dist then
                    table.insert(wires, wire_vectors)
                    wire_vectors = {}
                    wire_distance = 0
                    if wire_dist > max_dist then
                        --table.insert(wire_vectors, last_vector)
                        local previous_equalized_point
                        for _, data in pairs(equalize_vector(last_vector,point, max_dist)) do
                            table.insert(wires, data)
                        end
                    else
                        table.insert(wire_vectors, last_vector)
                        wire_distance = wire_dist
                    end
                    last_vector = point
                    table.insert(wire_vectors, point)
                else
                    wire_distance = wire_distance + wire_dist
                    table.insert(wire_vectors, point)
                    last_vector = point
                end
            end
        end
        if #wire_vectors > 0 then 
            table.insert(wires, wire_vectors)
        end
        return wires
    end
    local function rotate_vectors(wiretable, rotation)
        if not rotation then return wiretable end
        local model = Instance.new("Model", game.Workspace)
        local fixed_table = {}
        local firstone = true
        for _, piece in pairs(wiretable) do
            local holding = Instance.new("Folder", model)
            for i, v in pairs(piece) do
                local tempart = Instance.new("Part", holding)
                tempart.Position = v
                if firstone then
                    model.PrimaryPart = tempart
                    firstone = false
                end
            end
        end
        model:SetPrimaryPartCFrame(model.PrimaryPart.CFrame * CFrame.Angles(0, rotation*math.pi/180, 0))
        for i, folder in pairs(model:GetChildren()) do
            local fixed_vector = {}
            for i, v in pairs(folder:GetChildren()) do
                table.insert(fixed_vector, v.Position)
            end
            table.insert(fixed_table, fixed_vector)
        end
        model:Destroy()
        return fixed_table
    end
    function create_wire_client(points, parent, wireinfo, use_old_preview, light_up)
        local wireUtilities = {}
        function wireUtilities:drawLine(pointA, pointB, thickness)
            local len = (pointA - pointB).magnitude
            local part = Instance.new("Part")
            part.Anchored = true
            part.CFrame = CFrame.new(pointA, pointB) * CFrame.Angles(-math.pi/2, 0, 0) * CFrame.new(0, len / 2, 0)
            part.Size = Vector3.new(math.max(thickness, 0.2), len, math.max(thickness, 0.2))
            part.TopSurface = Enum.SurfaceType.Smooth
            part.BottomSurface = Enum.SurfaceType.Smooth
            local mesh = Instance.new("CylinderMesh", part)
            mesh.Scale = Vector3.new(math.min(thickness / 0.2 , 1), 1, math.min(thickness / 0.2 , 1))
            return part
        end	
        
        function wireUtilities:drawBall(point, thickness)
            local part = Instance.new("Part")
            part.Anchored = true
            part.Shape = Enum.PartType.Ball
            part.Size = Vector3.new(1,1,1) * math.max(thickness, 0.2)
            part.CFrame = CFrame.new(point)
            part.TopSurface = Enum.SurfaceType.Smooth
            part.BottomSurface = Enum.SurfaceType.Smooth
            local mesh = Instance.new("SpecialMesh", part)
            mesh.MeshType = Enum.MeshType.Sphere
            mesh.Scale = Vector3.new(1,1,1) * math.min(thickness / 0.2 , 1)
            part.CanCollide = false
            return part
        end
        
        function wireUtilities:drawEnd(point, endThickness, rot)
            local part = Instance.new("Part")
            part.Anchored = true
            part.Shape = Enum.PartType.Cylinder
            part.Size = Vector3.new(0.4,1,1) * endThickness
            part.CFrame = CFrame.new(point) * rot
            part.TopSurface = Enum.SurfaceType.Smooth
            part.BottomSurface = Enum.SurfaceType.Smooth
            return part
        end
        
        
        local function drawLine(pointA, pointB)
            local part = wireUtilities:drawLine(pointA, pointB, wireinfo.OtherInfo.Thickness.Value)
            if use_old_preview then
                part.BrickColor = BrickColor.new("Pastel Blue")
                part.Material = Enum.Material.Neon
            else
                if light_up then 
                    part.BrickColor = (wireinfo.OtherInfo:FindFirstChild("OnColor") and wireinfo.OtherInfo.OnColor.Value) or BrickColor.new("Electric blue")
                else
                    part.BrickColor = (wireinfo.OtherInfo:FindFirstChild("OffColor") and wireinfo.OtherInfo.OffColor.Value) or BrickColor.new("Black")
                end

                if wireinfo.OtherInfo:FindFirstChild("SpecialClass") then
                    if wireinfo.OtherInfo.SpecialClass.Value == "Neon" then
                        part.Material = Enum.Material.Neon
                        if light_up then
                            local light = Instance.new("SurfaceLight")
                            light.Range = 20
                            light.Color = wireinfo.OtherInfo:FindFirstChild("OnColor").Value.Color
                            light.Shadows = true
                            light.Angle = 180
                            light.Brightness = 0.5
                            light.Face = Enum.NormalId.Front
                            light.Parent = part
                            local l2 = light:Clone()
                            l2.Parent = part
                            l2.Face = Enum.NormalId.Back
                        end
                    end
                end
            end
            return part
        end	
        
        local function drawBall(point, wireFolder)
            local part = wireUtilities:drawBall(point, wireinfo.OtherInfo.Thickness.Value)
            if use_old_preview then
                part.BrickColor = BrickColor.new("Pastel Blue")
                part.Material = Enum.Material.Neon
            else
                if light_up then 
                    part.BrickColor = (wireinfo.OtherInfo:FindFirstChild("OnColor") and wireinfo.OtherInfo.OnColor.Value) or BrickColor.new("Electric blue")
                else
                    part.BrickColor = (wireinfo.OtherInfo:FindFirstChild("OffColor") and wireinfo.OtherInfo.OffColor.Value) or BrickColor.new("Black")
                end

                if wireinfo.OtherInfo:FindFirstChild("SpecialClass") then
                    if wireinfo.OtherInfo.SpecialClass.Value == "Neon" then
                        part.Material = Enum.Material.Neon
                        if light_up then
                            local light = Instance.new("SurfaceLight")
                            light.Range = 20
                            light.Color = wireinfo.OtherInfo:FindFirstChild("OnColor").Value.Color
                            light.Shadows = true
                            light.Angle = 180
                            light.Brightness = 0.5
                            light.Face = Enum.NormalId.Front
                            light.Parent = part
                            local l2 = light:Clone()
                            l2.Parent = part
                            l2.Face = Enum.NormalId.Back
                        end
                    end
                end
            end
            return part
        end
        
        local function drawEnd(point, rot)
            local part = wireUtilities:drawEnd(point, wireinfo.OtherInfo.EndThickness.Value, rot)
            part.BrickColor = BrickColor.new("Pastel Blue")
            part.Material = Enum.Material.Neon
            return part
        end
        local model = Instance.new("Model")
        model.Name = "Wire"
        
        for i, point in pairs(points) do
            if i > 1 and i < #points then
                local ball = drawBall(point)
                ball.Name = "Point"..i
                ball.Parent = model
            end
            if i < #points then
                local line = drawLine(point, points[i + 1])
                line.Name = "Line"..i
                line.Parent = model
            end
        end
        
        local rotEnd1 = model["Line1"].CFrame
        rotEnd1 = (rotEnd1 - rotEnd1.p) * CFrame.Angles(0, 0, -math.pi/2)
        local End1 = drawEnd(points[1], rotEnd1)
        End1.Name = "End1"
        End1.Parent = model
        
        local rotEnd2 = model["Line"..(#points - 1)].CFrame * CFrame.Angles(0, 0, math.pi/2)
        rotEnd2 = rotEnd2 - rotEnd2.p
        local End2 = drawEnd(points[#points], rotEnd2)
        End2.Name = "End2"
        End2.Parent = model
        
        model.PrimaryPart = model.End1
        model.Parent = parent
    end

    local wireartcategory = main:CreateCategory("Wire Art")
    local wireart = wireartcategory:CreateSection("Wire Art URL")
    local wireartmodifiers = wireartcategory:CreateSection("Modifiers")
    local wireartmodifiers2 = wireartcategory:CreateSection("Select Wire Type and Preview Options")
    local wireartbuildpreview = wireartcategory:CreateSection("Preview and Build")
    local wireart_url = ""
    local function load_wireart(url)
        local resp = http_request({Url=wireart_url}).Body
        local artformat = resp:split'\n'[2]
        if string.find(artformat, "bark wire art format v1") then -- doing == does not work for some reason
            local payload = resp:split'\n'[3]
            payload = string.sub(payload, 2)
            --print(b64l.decode(payload))
            payload = game:GetService("HttpService"):JSONDecode(b64l.decode(payload))
            local new = {}
            for _, wire in pairs(payload) do
                local newwire = {}
                for _, point in pairs(wire) do
                    table.insert(newwire, Vector3.new(unpack(point)))
                end
                table.insert(new, newwire)
            end
            return new
        end
        local success, wire_data = pcall(function() return loadstring(http_request({Url=wireart_url}).Body)() end)
        if not success then notify("Bark "..cv, "Invalid Wire Art URL Specified!") return false end
        return {wire_data}
    end


    local preview_folder = game.Workspace:FindFirstChild("BarkWireArtPreviewFolder") or Instance.new("Folder", game.Workspace)
    preview_folder.Name = "BarkWireArtPreviewFolder"
    local origin_point
    local scale = 1
    local adjust_y = 0
    local adjust_rotation = 0
    local light_up = true
    local use_old_preview = false
    local wire_type = "NeonWireWhite"
    wireart:Create(
        "TextBox",
        "Enter Wireart URL",
        function(input)
            wireart_url = input
        end,
        {
            text = "URL"
        }
    )
    local enabled_unstricted_y = false
    wireartmodifiers:Create(
        "Slider",
        "Y-Axis Adjustment",
        function(state)
            adjust_y = tonumber(state)
            if (adjust_y == 25 or adjust_y == -25) and enabled_unstricted_y == false then
                enabled_unstricted_y = true
                wireartmodifiers:Create("TextBox", "Un-Restricted Y-Axis Adjustment", function(v)
                        adjust_y = tonumber(v) or 0
                    end, 
                    {
                    text = "Y-Axis Adjustment"
                    }
                )
            end
        end,
        {
            min = -25,
            max = 25,
            default = 0,
            changablevalue = true
        }
    )
    local enabled_unstricted_scale = false
    wireartmodifiers:Create(
        "Slider",
        "Wire Art Scale",
        function(state)
            scale = tonumber(state)
            if (scale == 5) and enabled_unstricted_scale == false then
                enabled_unstricted_scale = true
                wireartmodifiers:Create("TextBox", "Un-Restricted Scale Adjustment", function(v)
                        scale = tonumber(v) or 1
                    end, 
                    {
                    text = "Wire Art Scale"
                    }
                )
            end
        end,
        {
            min = 0.1,
            max = 5,
            default = 1,
            precise=true,
            changablevalue = true
        }
    )
    wireartmodifiers:Create(
        "Slider",
        "Rotation (Degrees)",
        function(state)
            adjust_rotation = tonumber(state)
        end,
        {
            min = 0,
            max = 360,
            default = 0,
            changablevalue = true
        }
    )
    local previewbutton 
    previewbutton = wireartbuildpreview:Create(
        "Button",
        "Preview Wire Art",
        function()
            if #preview_folder:GetChildren() > 0 then
                previewbutton:SetButtonText("Preview Wire Art")
                preview_folder:ClearAllChildren()
                origin_point = nil
                return
            end
            local wire_data = load_wireart()
            if not wire_data then return end
            wire_data = rotate_vectors(wire_data, (adjust_rotation~=0 and adjust_rotation))
            previewbutton:SetButtonText("Destroy Preview")
            for i, wire_data in pairs(wire_data) do
                local wire_data_new = {}
                for i, v in pairs(wire_data) do
                    table.insert(wire_data_new, v*scale)
                end
                wire_data = wire_data_new
                origin_point = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
                --create_wire_client(wire_data, preview_folder)
                
                local vectors_new = {}
                for i, v in pairs(fix_vectors(wire_data, 20)) do
                    local vectors_new = {}
                    for a, b in pairs(v) do
                        table.insert(vectors_new, b + (game.Players.LocalPlayer.Character.HumanoidRootPart.Position+Vector3.new(0, adjust_y, 0)))
                    end
                    local wireclass =  game.ReplicatedStorage.Purchasables.WireObjects:FindFirstChild(wire_type)
                    pcall(create_wire_client, vectors_new, preview_folder,wireclass, use_old_preview, light_up)
                end
            end
            
        end,
        {
            animated=true
        }
    )
    buy_place = function(item, destination_cframe, wire_vectors, wire_type)
		item = autobuy(item, 1, nil, false)
		if destination_cframe then
			local remote = game.ReplicatedStorage.PlaceStructure.ClientPlacedStructure
			remote:FireServer(item.PurchasedBoxItemName.Value, destination_cframe, game.Players.LocalPlayer, nil, item, false, true)
		elseif wire_vectors ~= nil then
			local remote = game:GetService("ReplicatedStorage")["PlaceStructure"]["ClientPlacedWire"]
			remote:FireServer(wire_type, wire_vectors, game.Players.LocalPlayer,item, true)
		end
		--print("Done with: ", item.PurchasedBoxItemName.Value)
	end
    wireartmodifiers2:Create(
        "Dropdown",
        "Select Wire Type",
        function(state)
            wire_type = state
        end,
        {
            options = {
                "NeonWirePinky";
                "NeonWireOrange";
                "NeonWireRed";
                "NeonWireViolet";
                "NeonWireWhite";
                "NeonWireYellow";
                "NeonWireBlue";
                "NeonWireCyan";
                "NeonWireGreen";
                "IcicleWireBlue";
                "IcicleWireAmber";
                "IcicleWireRed";
                "IcicleWireGreen";
                "IcicleWireMagenta";
                "IcicleWireHalloween";
                "Wire";
            },
            search = true,
            default = "NeonWireWhite";
        }
    )
    wireartmodifiers2:Create("Toggle", "Light up wires in preview?", function(state)
        light_up = state
    end, {default=true})
    wireartmodifiers2:Create("Toggle", "Use old preview", function(state)
        use_old_preview = state
    end, {default=false})
    wireartbuildpreview:Create(
        "Button",
        "Build Wire Art",
        function()
            local wire_class = game.ReplicatedStorage.Purchasables.WireObjects[wire_type]
            local length = wire_class.OtherInfo.MaxLength.Value
            if origin_point == nil then notify("Bark "..cv, "Please load a preview first!") return end 
            local wire_data = load_wireart()
            if not wire_data then return end
            wire_data = rotate_vectors(wire_data, (adjust_rotation~=0 and adjust_rotation))
            local count = 0
            local new_wire_fixed = {}
            for i, wire_data in pairs(wire_data) do
                local wire_data_new = {}
                for i, v in pairs(wire_data) do
                    table.insert(wire_data_new, v*scale)
                end
                wire_data = wire_data_new
                local fixed_vectors = fix_vectors(wire_data, length)
                count = count + #fixed_vectors
                table.insert(new_wire_fixed, fixed_vectors)
            end
            notify("Wire Art", "Bark estimates that this wire art will cost $"..tostring(count*220).." with "..tostring(count).." wires.")
            notify("Wire Art", "By confirming, you agree that although we try not to, you may still get banned!")
            if not confirm() then return end
            local wires = autobuy("Wire", count, nil, false)
            local index = 1
            for i, fixed_vector in pairs(new_wire_fixed) do
                for i, v in pairs(fixed_vector) do
                    local vectors_new = {}
                    for a, b in pairs(v) do
                        table.insert(vectors_new, b + (origin_point+Vector3.new(0, adjust_y, 0)))
                    end
                    local remote = game:GetService("ReplicatedStorage")["PlaceStructure"]["ClientPlacedWire"]
                    local wireobj = (count==1 and wires) or wires[index]
                    local info = game.ReplicatedStorage.ClientItemInfo:FindFirstChild(wire_type)
                    remote:FireServer(info, vectors_new, game.Players.LocalPlayer,wireobj, true)
                    index = index + 1
                end
            end
            _G.DogixLT2TPC(origin_point, gkey)
        end
    )
end
wireart()

-- removed old bark wire art ~applebee 12/08/2021


function flyfunct()
    if not FLYING then
        NOFLY()
        sFLY(false)
    else
        NOFLY()
    end
end
commands["noclip"] = noclipfunct
commands["clip"] = commands["noclip"]
commands["fly"] = flyfunct
commands["vfly"] = function()
    if not FLYING then
        NOFLY()
        sFLY(true)
    else
        NOFLY()
    end
end
commands["cfly"] = commands["vfly"]
commands["carfly"] = commands["vfly"]
commands["unfly"] = commands["fly"]
commands["goto"] = function(arg)
    local rtn = userparse(arg[1])
    if rtn then
        _G.DogixLT2TPC(rtn.Character.HumanoidRootPart.CFrame,gkey)
    end
end
commands["gotobase"] = function(arg)
    local rtn = userparse_string(arg[1])
    if rtn then
        for _,v1 in pairs (game.Workspace.Properties:children()) do
            if tostring(v1.Owner.Value) == rtn then
                local cf = v1.OriginSquare.Position
                _G.DogixLT2TP(cf.X, cf.Y+10, cf.Z, gkey)
            end
        end
    end
end
commands["kick"] = function(arg)
    local rtn = userparse(arg[1])
    if rtn then
        final_kick(rtn)
    end
end
commands["bring"] = function(arg)
    local rtn = userparse(arg[1])
    if rtn then
        final_bring(rtn)
    end
end
commands["kill"] = function(arg)
    local rtn = userparse(arg[1])
    if rtn then
        final_kill(rtn)
    end
end
commands["hkill"] = function(arg)
    local rtn = userparse(arg[1])
    if rtn then
        final_hardkill(rtn)
    end
end
commands["tbring"] = function(arg)
    local rtn = userparse(arg[1])
    if rtn then
        final_tbring(rtn)
    end
end
commands["fling"] = function(arg)
    local rtn = userparse(arg[1])
    if rtn then
        final_fling(rtn)
    end
end
commands["suicide"] = function(arg)
    game.Players.LocalPlayer.Character.Head:Destroy()
end
commands["ws"] = function(arg)
    arg = arg[1]
    if tonumber(arg) then
        _G.SetStats[1] = tonumber(arg)
    end
end
commands["jp"] = function(arg)
    arg = arg[1]
    if tonumber(arg) then
        _G.SetStats[2] = tonumber(arg)
    end
end
commands["hh"] = function(arg)
    arg = arg[1]
    if tonumber(arg) then
        _G.SetStats[3] = tonumber(arg)
    end
end
commands["cs"] = function(arg)
    arg = arg[1]
    if tonumber(arg) then
        _G.SetStats[4] = 1+(tonumber(arg)/100)
    end
end
commands["fs"] = function(arg)
    arg = arg[1]
    if tonumber(arg) then
        _G.SetStats[5] = tonumber(arg)
    end
end
commands["fov"] = function(arg)
    arg = arg[1]
    if tonumber(arg) then
        game.Workspace.CurrentCamera.FieldOfView = tonumber(arg)
    end
end
commands["loadslot"] = function(arg)
    arg = arg[1]
    if tonumber(arg) then
        spawn(function() ShowMSG("Loading Slot...",10) end)
        autoload_slot(tonumber(arg))
    else
        spawn(function() ShowMSG("Invalid Slot!",3) end)
    end
end
commands["autobuy"] = function(arg)
    if not arg[1] then return end
    if tonumber(arg[2]) ~= nil then
        autobuy(arg[1],tonumber(arg[2]))
    else
        autobuy(arg[1],1)
    end
end
commands["tree"] = function(arg)
    if not arg[1] then return end
    if tonumber(arg[2]) ~= nil then
        GetTreeMod(arg[1],tonumber(arg[2]))
    else
        GetTreeMod(arg[1],1)
    end
end
commands.cmds = function(arg)
local cmdstring = [[Commands for Bark Command Line:
 - kick [plr]: kicks plr
 - kill [plr]: kills plr
 - goto [plr]: teleports to plr
 - gotobase [plr]: goes to plr's base
 - hkill [plr]: hardkills plr
 - fling [plr]: flings plr
 - bring [plr]: teleports plr to you
 - tbring [plr]: tween teleports plr to you
 - suicide: commits safe suicide (keeps axes)
 - ws [num]: sets your walk speed to num
 - jp [num]: sets your jump power to num
 - hh [num]: sets your hip height to num
 - cs [num]: sets your car speed to num
 - fov [num]: sets your field of view to num
 - fs [num]: sets your fly speed to num
 - autobuy [item] [num]: buys num amount of item to your location.
 - tree [name] [num]: automatically brings num name trees to you.
 - treenames: view tree names for tree
 - fly: enters fly mode
 - vfly: enters car fly mode
 - unfly: stops flying
 - noclip: noclips
 - clip: disables noclip

 - cmds: shows this list
 - rejoin: rejoins game
 - cls: clears console (synapse only)
]]
ClearCmd()
CMD.Active = true
CMD.Draggable = true
Tween(CMD,0.5,{Position = UDim2.new(0.307,0,0.298,0)})
wait(.5)
local splited = cmdstring:split("\n")
for i=2,#splited do
	AddCmd(splited[i])
	wait(0.04)
end
end
commands.treenames = function(arg)
local cmdstring = [[Tree Names:
 - GoldSwampy
 - Cherry
 - CaveCrawler
 - Generic
 - Volcano
 - Frost
 - LoneCave
 - Oak
 - Walnut
 - Birch
 - SnowGlow
 - Pine
 - GreenSwampy
 - Koa
 - Palm
 - SpookyNeon
 - Spooky
]]
ClearCmd()
CMD.Active = true
CMD.Draggable = true
Tween(CMD,0.5,{Position = UDim2.new(0.307,0,0.298,0)})
wait(.5)
local splited = cmdstring:split("\n")
for i=2,#splited do
	AddCmd(splited[i])
	wait(0.04)
end
end
commands.cls = function(arg)
    if bcs ~= false then
        rconsoleclear()
    end
end
commands.rejoin = function(arg)
    rconsoleclear()
    game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
end
function parse_command(cmdraw)
    local cmd = cmdraw:split(" ")
    local cmdname = cmd[1]
    commanddone = false
    if commands[cmd[1]] then
        local args = {}
        for i=2, #cmd do
            table.insert(args, cmd[i])
        end
        spawn(function()
            commands[cmdname](args)
        end)
        commanddone = true
    end
    return commanddone
end

(function()
    if not dbgmode then return end
    local adminp = main:CreateCategory("Admin")
    local admins = adminp:CreateSection("Debug")
    admins:Create(
    "Button",
    "Testing Tool",
    function()
        local plr = game:GetService("Players").LocalPlayer
        local functions_to_test = {
            function()
                getMouseTarget().Velocity = Vector3.new(1000,100,1000)
            end,
        }
        for i,v in pairs (functions_to_test) do
            local tool = Instance.new("Tool",plr.Backpack)
            tool.RequiresHandle = false
            tool.Name = "Test "..i
            tool.Activated:Connect(v)
        end
    end,
    {
        animated = true,
    })
    admins:Create(
        "Button",
        "Donate Base to Server",
        function()
            selfdupeon(true)
        end,
        {
            animated = true,
        }
    )
    admins:Create(
    "Button",
    "Terrain Fucker Tool",
    function(v)
        Identify = Instance.new("Tool",game.Players.LocalPlayer.Backpack)
		Identify.RequiresHandle = false
		Identify.Name = "barkwinning"
		Identify.Activated:connect(function()
		    local item = getMouseTarget().Parent
		    local name = item:FindFirstChild"ItemName"
		    if not name then
		        notify("#barkwinning", "Couldn't identify item.", 3)
		    else
		        name = name.Value
		        dropMeme(name)
		        notify("#barkwinning", "Glitched the spawn pad.", 3)
		    end
		end)
    end,
    {
        animated = true
    }
)
    admins:Create(
    "Button",
    "Temp Self Blacklist",
    function(v)
        game.ReplicatedStorage.Interaction.ClientSetListPlayer:InvokeServer(game:GetService'Players'.LocalPlayer.BlacklistFolder, game.Players.LocalPlayer, true)
        wait(6)
        game.ReplicatedStorage.Interaction.ClientSetListPlayer:InvokeServer(game:GetService'Players'.LocalPlayer.BlacklistFolder, game.Players.LocalPlayer, false)
    end,
    {
        animated = true
    }
)
    admins:Create(
    "Button",
    "Copy CFrame",
    function(v)
        setclipboard(tostring(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame))
    end,
    {
        animated = true
    }
)
    local admins = adminp:CreateSection("Controls")
    admins:Create(
    "Button",
    "Get Users",
    function()
        local users = {}
        local Event = game:GetService("ReplicatedStorage").NPCDialog.SetChattingValue
        Event:InvokeServer(1005)
        wait(4)
        for i,v in pairs(game.Players:GetChildren()) do
            if v.IsChatting.Value == 1002 then
                table.insert(users, v.Name)
            end
        end
        ClearCmd()
        CMD.Active = true
        CMD.Draggable = true
        Tween(CMD,0.5,{Position = UDim2.new(0.307,0,0.298,0)})
        wait(.5)
        for i=1,#users do
            AddCmd(users[i])
        end
        local Event = game:GetService("ReplicatedStorage").NPCDialog.SetChattingValue
        Event:InvokeServer(0)
    end,
    {
        animated = true,
    }
    )
    admins:Create(
    "Button",
    "Crash All Users",
    function()
        local A_1 = "crash_script_users"
        local A_2 = "All"
        local Event = game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest
        Event:FireServer(A_1, A_2)
    end,
    {
        animated = true,
    }
    )
    admins:Create(
    "TextBox",
    "Crash User",
    function(input)
        local Event = game:GetService("ReplicatedStorage").NPCDialog.SetChattingValue
        Event:InvokeServer(userparse(input).UserId + 6925382)
        wait(6)
        Event:InvokeServer(0)
    end,
    {
        text = ""
    }
    )
    admins:Create(
    "TextBox",
    "Hash String",
    function(input)
        setclipboard(hashi(input))
    end,
    {
        text = ""
    }
    )
    admins:Create(
        "Button",
        "Internal Executor",
        function()
            local pgui = game.Players.LocalPlayer.PlayerGui
            if pgui:FindFirstChild("ScreenGui") and pgui.ScreenGui:FindFirstChild("Main") then
                pgui:FindFirstChild("ScreenGui"):Destroy()
            else
                loadstring(game:HttpGetAsync("https://cdn.applebee1558.com/bark/internal_executor.lua"))()
            end
        end
    )
    local admins = adminp:CreateSection("Memes")
    admins:Create(
        "Button",
        "Plank Float Meme (select user in base drop)",
        function()
            notify("Plank Meme", "Make sure Infinite Range is enabled!")
            function delete(a)
                for i,v in pairs (a.WoodSection:GetChildren()) do
                    if v:IsA("BodyPosition") then v:Destroy() end
                end
	            local bp = Instance.new("BodyPosition")
                bp.MaxForce = Vector3.new(0,a.WoodSection.Size.X*a.WoodSection.Size.Y*a.WoodSection.Size.Z*100,0)
                bp.Position = a.WoodSection.CFrame.p + Vector3.new(0,1000,0)
                bp.P = a.WoodSection.Size.X*a.WoodSection.Size.Y*a.WoodSection.Size.Z*50
                bp.Parent = a.WoodSection
                a.WoodSection.Massless = true
            end
            notify("Plank Meme", "Started meming.",1)
            wait()
            for i,v in pairs (game.Workspace.PlayerModels:children()) do
                if v:FindFirstChild'Owner' and v:FindFirstChild"TreeClass" and v:FindFirstChild("WoodSection") then
                    local nm = v:FindFirstChild"TreeClass"
                    if tostring(v.Owner.Value) == tostring(cplrw) then
                        delete(v)
                    end
                end
            end
            notify("Plank Meme", "Finished meming.",1)
        end,
        {
            animated = true,
        }
    )

	admins:Create("Button", "Plank Fire Meme (select user in base drop)", function()
		local lava = game.Workspace["Region_Volcano"]:FindFirstChild("Lava") or game.Lighting:FindFirstChild("Lava")
		if lava.Parent == game.Lighting then
			lava.Parent = game.Workspace["Region_Volcano"]
		end;
		lava = lava.Lava;
		if needrevert then
			lava.Parent.Parent = game.Lighting;
		end
		function delete(plank)
		    if plank.ClassName == "Model" then plank = plank.WoodSection end
		    if isnetworkowner and not isnetworkowner(plank) then
		        game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(plank.Parent)
                wait(.5)
		    end
		    --repeat wait() until isnetworkowner(plank) or wait(2)
    		firetouchinterest(plank, lava, 0)
    		firetouchinterest(plank, lava, 1)
		end;
		notify("Plank Meme", "Started meming.", 1)
		wait()
		for _, v in pairs(game.Workspace.PlayerModels:children()) do
			if v:FindFirstChild'Owner' and v:FindFirstChild"TreeClass" and v:FindFirstChild("WoodSection") then
				if tostring(v.Owner.Value) == tostring(cplrw) then
					delete(v)
				end
			end
		end;
		notify("Plank Meme", "Finished meming.", 1)
	end, {
		animated = true
	})
	admins:Create("Button", "Wipe Base (select user in base drop)", function()
	    local offset = nil
	    for i,v in pairs (game.Workspace.Properties:GetChildren()) do
	        if v:FindFirstChild("Owner") then
    	        if tostring(v.Owner.Value) == tostring(cplrw) then
    	            offset = v.OriginSquare.CFrame
    	            break
    	        end
	        end
	    end
	    for i,v in pairs (game.Workspace.PlayerModels:GetChildren()) do
            if v:FindFirstChild("Owner") then
                if tostring(v.Owner.Value) == tostring(cplrw) then
                    game.ReplicatedStorage.PlaceStructure.ClientPlacedBlueprint:FireServer("Floor1Tiny", offset - Vector3.new(0,100,0), nil, v)
                    game:GetService("RunService").Stepped:wait()
                end
            end
        end
	end, {
		animated = true
	})
end)()

pcall(function()
    game.Players.LocalPlayer.PlayerGui.Scripts.MusicClient.Alternate.Changed:Connect(function()
        game.Players.LocalPlayer.PlayerGui.Scripts.MusicClient.Alternate.Value = false
        print("[Bark]: Blocked Earrape Music Attempt!")
    end)
    print("[Bark]: Earrape Music Disabler Loaded!")
end)

notify("Bark "..cv,"Welcome to Bark, "..game.Players.LocalPlayer.Name..".",3)
