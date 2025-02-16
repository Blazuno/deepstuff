-- heeelllppp

--localized vars
local plr = game.Players.LocalPlayer
local chr = plr.Character
local positions = {
    Vector3.new(-5460.83740234375, 425.9949951171875, -5136.78857421875),
    Vector3.new(-5408.3291015625, 279.205322265625, -4993.06640625),
    Vector3.new(-5365.28369140625, 277.34478759765625, -4763.12451171875),
    Vector3.new(-5232.18115234375, 203.39727783203125, -4642.83349609375),
    Vector3.new(-4804.396484375, 293.2510986328125, -4554.693359375),
    Vector3.new(-4653.1484375, 475.3758850097656, -4986.79833984375),
    Vector3.new(-4595.3955078125, 644.717529296875, -5156.9619140625)
}

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
local function noclip(bool)
    local head, torso = chr:FindFirstChild("Head"), chr:FindFirstChild("Torso")
    if bool then
        local connection = game:GetService("RunService").RenderStepped:Connect(function()
            head.CanCollide = false
            torso.CanCollide = false 
        end)
    else 
        if connection then 
            connection:Disconnect()
        end
    end
end


local function delete_chaser()
    --wip
    wait(1)
end

--
local function fly_to(goal, speed)
    local ts = game:GetService("TweenService")
    local distance = (goal-chr.HumanoidRootPart.Position).Magnitude
    local time = distance/speed
    local ts_config = TweenInfo.new(
        time, 
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out
    )
    local tween = ts:Create(chr.HumanoidRootPart, ts_config, {CFrame = CFrame.new(goal)})
    tween:Play()
    return tween
end


--delete bonekeeper
local function delete_bonekeeper()
    local live = game.Workspace.Live
    local bonekeeper 
    local tween
    game.Workspace.Gravity = 0
    local y_start = chr.HumanoidRootPart.Position.Y 
    for _, part in pairs(live:GetChildren()) do
        if string.find(part.Name, "boneboy") then
            bonekeeper = part
            break
        end 
    end
    spawn(function()
        while true do
            if game.Workspace.Thrown:FindFirstChild("BoneSpear") then
                keypress(0x38)
                wait(0.05)
                keyrelease(0x38)
                tween:Cancel()
                local tween = fly_to(Vector3.new(-5798.708984375, 459.4010925292969, -6341.38037109375), 300)
                wait(tween.TweenInfo.Time)
                game.Workspace.Gravity = 196.2
                return
            end
            wait(0.01)
        end
    end)
    while bonekeeper do
        local pos = bonekeeper.Head.Position + bonekeeper.Head.CFrame.RightVector * 40
        pos = Vector3.new(pos.X, y_start, pos.Y)
        tween = fly_to(pos, 300)
        wait(tween.TweenInfo.Time)
    end
end

delete_bonekeeper()
