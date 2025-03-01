local vim = game:GetService("VirtualInputManager")
local galetrap = game.Players.LocalPlayer.Backpack:WaitForChild("Mantra:TrapWind{{Galetrap}}")
local requests = game.Players.LocalPlayer.Character.CharacterHandler:WaitForChild("Requests")
local cast_remote = requests:WaitForChild("ActivateMantra")
local chr = game.Players.LocalPlayer.Character
local c_thread


--void mobs
local function void_mobs()
    local live = game.Workspace.Live
    for _, c in live:GetChildren() do
        if c.Name ~= chr.Name then 
            repeat wait() until c:FindFirstChild("HumanoidRootPart")
            firetouchinterest(chr.HumanoidRootPart, c.HumanoidRootPart, 0)
            spawn(function()
                repeat 
                    for _, part in pairs(c:GetChildren()) do 
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                    local bp = Instance.new("BodyVelocity")
                    bp.MaxForce = Vector3.new(0, math.huge, 0)
                    bp.P = math.huge
                    bp.Parent = c.HumanoidRootPart
                    bp.Velocity = Vector3.new(0, -20000, 0)
                    game:GetService("Debris"):AddItem(bp, 0.001)
                    wait()
                until not c
            end)
        end
    end
    
    live.ChildAdded:Connect(function(c)
        repeat wait() until c:FindFirstChild("HumanoidRootPart")
        firetouchinterest(chr.HumanoidRootPart, c.HumanoidRootPart, 0)
        spawn(function()
            repeat 
                for _, part in pairs(c:GetChildren()) do 
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
                local bp = Instance.new("BodyVelocity")
                bp.MaxForce = Vector3.new(0, math.huge, 0)
                bp.P = math.huge
                bp.Parent = c.HumanoidRootPart
                bp.Velocity = Vector3.new(0, -20000, 0)
                game:GetService("Debris"):AddItem(bp, 0.001)
                wait()
            until not c
        end)    
    end)
end

--noclip
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

--nofall
local function nofall()
    local oldfs 
    oldfs = hookmetamethod(game, "__namecall", newcclosure(function(...)
        local args = {...}
        if not checkcaller() and getnamecallmethod() == "FireServer" and type(args[2]) == "number" and args[2] >= 10 and args[3] == false then
            return 
        else
            return oldfs(...)
        end
    end))
end

--tween func
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

--diluvian bot
local function auto_diluvian()
    local old_pos = chr.HumanoidRootPart.Position
    void_mobs()
    noclip(true)
    nofall()
    local points = {
        Vector3.new(-6184.84228515625, 512.000732421875, -5080.306640625),
        Vector3.new(-5800.9912109375, 512.000732421875, -5080.77294921875),
        Vector3.new(-5800.56298828125, 512.000732421875, -4706.18017578125),
        Vector3.new(-6186.77099609375, 512.000732421875, -4706.01708984375)
    }
    local index = 1
    repeat
        local live = game.Workspace.Live:GetChildren()
        local old_pos = chr.HumanoidRootPart.Position
        for _, mob in pairs(live) do 
            if mob.Name ~= chr.Name then
                print("Attempting to kill:", mob.Name) 
                c_thread = task.spawn(function()
                    repeat 
                        pcall(function()
                            game.Workspace.CurrentCamera.CFrame = CFrame.new(game.Workspace.CurrentCamera.CFrame.Position, mob.HumanoidRootPart.Position) 
                            vim:SendMouseMoveEvent(game.Workspace.CurrentCamera.ViewportSize.X/2, game.Workspace.CurrentCamera.ViewportSize.Y/2, game)
                        end) 
                        wait()
                    until false
                end)
                if string.find(mob.Name, "megalodaunt") then 
                    repeat 
                        if mob and mob:FindFirstChild("HumanoidRootPart") then 
                            pcall(function()
                                cast_remote:FireServer(galetrap)
                                wait(0.56)
                                chr.HumanoidRootPart.CFrame = CFrame.new(mob.HumanoidRootPart.Position + mob.HumanoidRootPart.CFrame.LookVector * Vector3.new(-6, 0, -6))
                                game.Workspace.CurrentCamera.CFrame = CFrame.new(game.Workspace.CurrentCamera.CFrame.Position, mob.HumanoidRootPart.Position)
                                wait(0.1)
                                chr.HumanoidRootPart.CFrame = CFrame.new(old_pos)
                                wait(12)
                            end)
                        end
                        wait()
                    until not mob or not mob:FindFirstChild("HumanoidRootPart")
                else
                    repeat 
                        if mob and mob:FindFirstChild("HumanoidRootPart") then 
                            pcall(function()    
                                vim:SendKeyEvent(true, 114, false, game)
                                wait(0.05)
                                vim:SendKeyEvent(false, 114, false, game)
                                wait(0.4)
                                chr.HumanoidRootPart.CFrame = CFrame.new(mob.HumanoidRootPart.Position + mob.HumanoidRootPart.CFrame.LookVector * Vector3.new(-6,0,-6), mob.HumanoidRootPart.Position)
                                wait(0.1)
                                chr.HumanoidRootPart.CFrame = CFrame.new(old_pos)
                                wait()
                                fly_to(points[index])
                                if index == 4 then index = 1 else index = index + 1 end
                                wait(6)
                            end)
                        end
                        wait()
                    until not mob or not mob:FindFirstChild("HumanoidRootPart")
                end
                if c_thread then
                    task.cancel(c_thread)
                end
            end
        end
        repeat wait() until game.Players.LocalPlayer.PlayerGui:FindFirstChild("SimplePrompt")
    until false
end


local thread = task.spawn(auto_diluvian)

repeat wait() until game:GetService("UserInputService"):IsKeyDown("L")
task.cancel(c_thread) 
task.cancel(thread)