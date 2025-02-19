-- heeelllppp

--localized vars
local plr = game.Players.LocalPlayer
local chr = plr.Character
local VIM = game:GetService("VirtualInputManager")
local galetrap = game.Players.LocalPlayer.Backpack:FindFirstChild("Mantra:TrapWind{{Galetrap}}")
local cast_remote = game.Players.LocalPlayer.Character.CharacterHandler.Requests.ActivateMantra

local positions = {
    Vector3.new(-4508.375, 465.4999694824219, -5937.01904296875), -- orb
    Vector3.new(-4995.33203125, 376.4448547363281, -5826.1708984375), -- door
    Vector3.new(-5341.36962890625, 354.25225830078125, -5802.22412109375),
    Vector3.new(-5493.36669921875, 383.2544250488281, -5819.6513671875),
    Vector3.new(-5698.533203125, 402.0506286621094, -6069.64013671875),
    Vector3.new(-5983.35693359375, 443.8338623046875, -6298.9658203125),
    Vector3.new(-5746.16064453125, 459.4011535644531, -6364.5498046875), -- bonekeeper
    Vector3.new(-5557.0380859375, 529.257568359375, -6477.33984375),-- generator
    Vector3.new(-5698.533203125, 402.0506286621094, -6069.64013671875),
    Vector3.new(-5452.01025390625, 353.6543884277344, -5654.0517578125),
    Vector3.new(-5460.83740234375, 425.9949951171875, -5136.78857421875), --firfire
    Vector3.new(-5408.3291015625, 279.205322265625, -4993.06640625),
    Vector3.new(-5365.28369140625, 277.34478759765625, -4763.12451171875),
    Vector3.new(-5232.18115234375, 203.39727783203125, -4642.83349609375),
    Vector3.new(-4804.396484375, 293.2510986328125, -4554.693359375),
    Vector3.new(-4653.1484375, 475.3758850097656, -4986.79833984375),
    Vector3.new(-4595.3955078125, 644.717529296875, -5156.9619140625) -- chaser
}

local items = {
    "Weathered Timepiece",
    "Bloodforged Crown",
    "Bloodfouler",
    "Bloodless Gem"
}


local function mb_1()
    VIM:SendMouseButtonEvent(game.Workspace.CurrentCamera.ViewportSize.X/2, game.Workspace.CurrentCamera.ViewportSize.Y/2, 0, true, game, 1)
    task.wait(0.05)
    VIM:SendMouseButtonEvent(game.Workspace.CurrentCamera.ViewportSize.X/2, game.Workspace.CurrentCamera.ViewportSize.Y/2, 0, false, game, 1)
end


-- get an array of items
local function get_items_from_chest()
    local items = {}
    --path: PlayerGui/ChoicePrompt/ChoiceFrame/Options
    print("Chest debug:", unpack(plr.PlayerGui.ChoicePrompt.ChoiceFrame.Options:GetChildren()))
    for _, child in pairs(plr.PlayerGui.ChoicePrompt.ChoiceFrame.Options:GetChildren()) do
        print("checking child:", child)
        if type(child) ~= "number" and child:IsA("TextButton") then
            table.insert(items, child.Name)
        end
    end
    return items
end


--loot specified
local function loot_specific_item(item_name)
    local remote = game:GetService("Players").LocalPlayer.PlayerGui.ChoicePrompt.Choice
    for _, child in pairs(plr.PlayerGui.ChoicePrompt.ChoiceFrame.Options:GetChildren()) do
        if string.find(child.Name, item_name) then
            print("looting:", child.Name)
            remote:FireServer(child.Name)
            return
        end
    end
end


--noclip stuff
local connection
local function noclip(bool)
    local head, torso = chr:FindFirstChild("Head"), chr:FindFirstChild("Torso")
    if bool then
        connection = game:GetService("RunService").RenderStepped:Connect(function()
            head.CanCollide = false
            torso.CanCollide = false 
        end)
    else 
        if connection then 
            connection:Disconnect()
        end
    end
end




--
local function fly_to(goal, speed, look)
    local ts = game:GetService("TweenService")
    local distance = (goal-chr.HumanoidRootPart.Position).Magnitude
    local time = distance/speed
    local ts_config = TweenInfo.new(
        time, 
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out
    )
    if look then goal = CFrame.new(goal, look) else goal = CFrame.new(goal) end
    local tween = ts:Create(chr.HumanoidRootPart, ts_config, {CFrame = goal})
    tween:Play()
    return tween
end

--delete chaser
local function delete_chaser()
    local chaser = game.Workspace.Live:FindFirstChild(".chaser")
    local torso = chaser.Torso
    local tween = fly_to(chaser.Torso.Position + Vector3.new(5,0,5), 100, chaser.Torso.Position)
    wait(tween.TweenInfo.Time)
    game.Workspace.CurrentCamera.CFrame = CFrame.lookAt(game.Workspace.CurrentCamera.CFrame.Position, chaser.Torso.Position)
    wait(0.5)
    local mouse_pos = game.Workspace.CurrentCamera:WorldToViewportPoint(torso.Position)
    wait(0.1)
    VIM:SendMouseMoveEvent(mouse_pos.X, mouse_pos.Y, game)
    wait(0.05)
    cast_remote:FireServer(galetrap)
    wait(1.5)
end

--delete bonekeeper
local function delete_bonekeeper()
    local live = game.Workspace.Live
    local bonekeeper 
    local tween
    repeat
        for _, part in pairs(live:GetChildren()) do
            if string.find(part.Name, "boneboy") then
                bonekeeper = part
                break
            end 
        end
        wait()
    until bonekeeper 
    wait(2)
    local thread = task.spawn(function()
        while bonekeeper.Head do 
            local pos = bonekeeper.Head.Position + Vector3.new(0, 40, 0)
            chr.Torso.Anchored = false
            local tween = fly_to(pos, 200)
            wait(tween.TweenInfo.Time)
            chr.Torso.Anchored = true
            wait(4)
            chr.Torso.Anchored = false
            local tween = fly_to(Vector3.new(-5698.673828125, 496.2106628417969, -6404.46630859375), 100)
            wait(tween.TweenInfo.Time)
            wait(10)
        end
    end)
    while true do
        if game.Workspace.Thrown:FindFirstChild("BoneSpear") then
            if thread then
                task.cancel(thread)
            end
            chr.Torso.Anchored = false
            if tween then 
                tween:Cancel()
            end
            local tween = fly_to(Vector3.new(-5798.708984375, 459.4010925292969, -6341.38037109375), 200)
            wait(tween.TweenInfo.Time)
            wait(5)
            return
        end
        wait(0.01)
    end
end


local function destroy_jars()
    local destructibles = game.Workspace.Destructibles:GetChildren()
    for _, jar in pairs(destructibles) do
        if jar.Name == "BloodJar" and jar:FindFirstChild("AttachmentPart"):FindFirstChild("Attachment") and jar:FindFirstChild("AttachmentPart"):FindFirstChild("Attachment"):FindFirstChild("JarLight") then
            local look = Vector3.new(jar.Part.Position.X, chr.HumanoidRootPart.Position.Y, jar.Part.Position.Z)
            local next = false
            spawn(function()
                while not next do
                    local tween = fly_to(jar.Part.Position + Vector3.new(7,0,7), 200, look)
                    wait(tween.TweenInfo.Time)
                end
            end)
            local connection = jar.ChildRemoved:Connect(function()
                next = true
            end)
            repeat mb_1() wait(0.05) until next 
            connection:Disconnect()
            print("finished breaking jar")
        end
    end
end

--main product
local function layer2bot()
    repeat wait() until game:IsLoaded()
    if game.PlaceId == 4111023553 then
        game.ReplicatedStorage.Requests.StartMenu.Start:FireServer("A", {})
    elseif game.PlaceId == 8668476218 then
        mb_1()
        wait(15)
        noclip(true)
        chr.HumanoidRootPart.Anchored = true
        for _, point in pairs(positions) do
            repeat 
                local tween = fly_to(point, 250)
                wait(tween.TweenInfo.Time)
                if (chr.HumanoidRootPart.Position - point).Magnitude <= 5 then
                    wait(1.5)
                end
            until (chr.HumanoidRootPart.Position - point).Magnitude <= 5 
            if _ == 1 or _ == 2 or _ == 11  then
                if _ == 2 then 
                    game.Workspace.CurrentCamera.CFrame = CFrame.lookAt(game.Workspace.CurrentCamera.CFrame.Position, Vector3.new(-5002.71533203125, 376.4448547363281, -5825.50927734375))
                end
                wait(1)
                VIM:SendKeyEvent(true, 101, false, game)
                wait(0.05)
                VIM:SendKeyEvent(false, 101, false, game)
                wait(0.5)
                VIM:SendKeyEvent(true, 49, false, game)
                wait(0.05)
                VIM:SendKeyEvent(false, 49, false, game)

            elseif _ == 8 then
                wait(1)
                VIM:SendKeyEvent(true, 101, false, game)
                wait(0.05)
                VIM:SendKeyEvent(false, 101, false, game)
                wait(0.5)
                VIM:SendKeyEvent(true, 49, false, game)
                wait(0.05)
                VIM:SendKeyEvent(false, 49, false, game)
                wait(0.5)
                VIM:SendKeyEvent(true, 49, false, game)
                wait(0.05)
                VIM:SendKeyEvent(false, 49, false, game)
            elseif _ == 7 then
                wait(1) 
                delete_bonekeeper()
            elseif _ == 15 then 
                wait(6)
            end
        end
        wait(1.5)
        VIM:SendKeyEvent(true, 49, false, game)
        wait(0.05)
        VIM:SendKeyEvent(false, 49, false, game)
        wait(0.5)
        VIM:SendKeyEvent(true, 101, false, game)
        wait(0.05)
        VIM:SendKeyEvent(false, 101, false, game)
        wait(0.5)
        VIM:SendKeyEvent(true, 49, false, game)
        wait(0.05)
        VIM:SendKeyEvent(false, 49, false, game)
        chr.HumanoidRootPart.Anchored = false
        local chaser = game.Workspace.Live:FindFirstChild(".chaser")
        repeat wait() until chaser.Torso.Position.Y >= 655
        wait(1)
        destroy_jars()
        repeat wait() until chaser.Torso.Position.Y <= 645
        delete_chaser()
        local tween = fly_to(Vector3.new(-4593.341796875, 644.6943359375, -5185.8837890625), 225)
        wait(tween.TweenInfo.Time)
        wait(1.5)
        VIM:SendKeyEvent(true, 101, false, game)
        wait(0.05)
        VIM:SendKeyEvent(false, 101, false, game)
        wait(0.5)
        local chest_loot = get_items_from_chest()
        print("Chest loot:", chest_loot)
        for _, item in pairs(chest_loot) do
            for i, wl_item in pairs(items) do 
                if string.find(item, wl_item) then
                    print("trying to loot:", item)
                    loot_specific_item(item)
                    wait(1)
                end
            end
        end
        wait(5)
        queue_on_teleport(game:HttpGet("https://raw.githubusercontent.com/Blazuno/deepstuff/refs/heads/main/layer2bot.lua"))
        game.ReplicatedStorage.Requests.ReturnToMenu:FireServer(nil)
    end
end

layer2bot()
