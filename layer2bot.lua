-- heeelllppp

--localized vars
local plr = game.Players.LocalPlayer
local chr = plr.Character
local VIM = game:GetService("VirtualInputManager")
local galetrap = game.Players.LocalPlayer.Backpack:FindFirstChild("Mantra:TrapWind{{Galetrap}}")
local cast_remote = game.Players.LocalPlayer.Character.CharacterHandler.Requests.ActivateMantra

local positions = {
    Vector3.new(-5460.83740234375, 425.9949951171875, -5136.78857421875),
    Vector3.new(-5408.3291015625, 279.205322265625, -4993.06640625),
    Vector3.new(-5365.28369140625, 277.34478759765625, -4763.12451171875),
    Vector3.new(-5232.18115234375, 203.39727783203125, -4642.83349609375),
    Vector3.new(-4804.396484375, 293.2510986328125, -4554.693359375),
    Vector3.new(-4653.1484375, 475.3758850097656, -4986.79833984375),
    Vector3.new(-4595.3955078125, 644.717529296875, -5156.9619140625)
}

local mouse = game.Players.LocalPlayer:GetMouse()
local function mb_1()
    VIM:SendMouseButtonEvent(mouse.X, mouse.Y, 0, true, game, 1)
    task.wait(0.05)
    VIM:SendMouseButtonEvent(mouse.X, mouse.Y, 0, false, game, 1)
end


-- get an array of items
local function get_items_from_chest()
    local items = {}
    --path: PlayerGui/ChoicePrompt/ChoiceFrame/Options
    for child in plr.PlayerGui.ChoicePrompt.ChoiceFrame.Options do
        table.insert(child.Name)
    end
    return items
end


--loot specified
local function loot_specific_item(item_name)
    local remote = game:GetService("Players").LocalPlayer.PlayerGui.ChoicePrompt.Choice
    for child in plr.PlayerGui.ChoicePrompt.ChoiceFrame.Options do
        if string.find(child.Name, item_name) then
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
    wait(0.5)
    cast_remote:FireServer(galetrap)
    wait(1.5)
    keypress(0x38)
    wait(0.05)
    keyrelease(0x38)
end

--delete bonekeeper
local function delete_bonekeeper()
    local live = game.Workspace.Live
    local bonekeeper 
    local tween
    local y_start 
    game.Workspace.Gravity = 0
    for _, part in pairs(live:GetChildren()) do
        if string.find(part.Name, "boneboy") then
            bonekeeper = part
            break
        end 
    end
    local thread = task.spawn(function()
        while bonekeeper.Head do 
            local pos = bonekeeper.Head.Position + bonekeeper.Head.CFrame.UpVector * 40
            chr.Torso.Anchored = false
            tween = fly_to(pos, 200)
            wait(tween.TweenInfo.Time)
            chr.Torso.Anchored = true
            wait(4)
            chr.Torso.Anchored = false
            fly_to(Vector3.new(-5573.736328125, 460.28863525390625, -6449.4453125), 100)
            wait(3)
        end
    end)
    while true do
        if game.Workspace.Thrown:FindFirstChild("BoneSpear") then
            if thread then
                task.cancel(thread)
            end
            chr.Torso.Anchored = false
            keypress(0x38)
            wait(0.05)
            keyrelease(0x38)
            wait(0.5)
            keypress(0x38)
            wait(0.05)
            keyrelease(0x38)
            tween:Cancel()
            local tween = fly_to(Vector3.new(-5798.708984375, 459.4010925292969, -6341.38037109375), 200)
            wait(tween.TweenInfo.Time)
            game.Workspace.Gravity = 196.2
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

local chaser = game.Workspace.Live:FindFirstChild(".chaser")
noclip(true)
destroy_jars()
repeat wait() until chaser.Torso.Position.Y <= 645
delete_chaser()
