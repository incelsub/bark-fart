local api = {
    http_request = function(self, payload)
        return (request or http_request or (syn and syn.request) or (http and http.request))(payload)
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


    --save base metadata
    save_base = function(self, target, model_location, purchasables_location, plot)
        -- you now need api for this!
        local base_table = {}
        local metadata = {}
        base_table['structures'] = {}
        metadata['structure_cost'] = 0
        base_table['wood_structures'] = {}
        base_table['wires'] = {}
        metadata['wire_cost'] = 0
        base_table['axes'] = {}
        metadata['axe_cost'] = 0
        base_table['items'] = {}
        metadata['item_cost'] = 0
        metadata['version'] = 1

        base_table['metadata'] = metadata
        local plot_pos
        if self.is_plugin then
            plot_pos = plot.OriginSquare.Position
            metadata['uploader_id'] = game:GetService("StudioService"):GetUserId()
            metadata['user_id'] = game:GetService("StudioService"):GetUserId()
        else
            metadata['uploader_id'] = game.Players.LocalPlayer.UserId
            metadata['user_id'] = target.UserId
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
                            payload['wood_type'] = 'Gray'
                        end
                        if v:FindFirstChild("MainCFrame") then
                            payload['main_cframe'] = {(v.MainCFrame.Value-plot_pos):components()}
                        else
                            payload['main_cframe'] = {(v.Main.CFrame-plot_pos):components()}
                        end
                    elseif v.Type.Value == "Blueprint" then
                        payload['wood_type'] = 'Blueprint'
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
                        metadata['structure_cost'] = metadata['structure_cost'] + price
                        -- item is buyable
                    elseif (wire_objects:FindFirstChild(v.ItemName.Value) ~= nil) then
                        table.insert(base_table['structures'], payload)
                        local price = wire_objects:FindFirstChild(v.ItemName.Value).Price.Value
                        metadata['structure_cost'] = metadata['structure_cost'] + price
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
                        metadata['wire_cost'] = metadata['wire_cost'] + 220
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
                        metadata['axe_cost'] = metadata['axe_cost'] + tools:FindFirstChild(v.ItemName.Value).Price.Value
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
                            metadata['item_cost'] = metadata['item_cost'] + loose_items:FindFirstChild(v.ItemName.Value).Price.Value
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
            ['Url']="http://localhost:8000/autobuild-structures",
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
    end
}