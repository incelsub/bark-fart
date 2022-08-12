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