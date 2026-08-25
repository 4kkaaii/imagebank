--[[
    FAKE SILENT AIM
    Makes bullets miss every target
    Looks like a real silent aim GUI
    Actually makes you worse at aiming!
--]]

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

-- Variables
local isFakeAimEnabled = false
local target = nil
local lastHitTime = 0

-- Create GUI
local function createGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FakeSilentAim"
    screenGui.Parent = player.PlayerGui
    
    -- Main frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 300, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = Color3.fromRGB(0, 200, 255)
    mainFrame.Parent = screenGui
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, -40)
    title.BackgroundTransparency = 1
    title.Text = "🎯 SILENT AIM v3.0 🎯"
    title.TextColor3 = Color3.fromRGB(0, 200, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    -- Status
    local statusFrame = Instance.new("Frame")
    statusFrame.Size = UDim2.new(0.9, 0, 0, 30)
    statusFrame.Position = UDim2.new(0.05, 0, 0, 10)
    statusFrame.BackgroundColor3 = Color3.fromRGB(0, 50, 0)
    statusFrame.BorderSizePixel = 1
    statusFrame.BorderColor3 = Color3.fromRGB(0, 255, 0)
    statusFrame.Parent = mainFrame
    
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(1, 0, 1, 0)
    statusText.BackgroundTransparency = 1
    statusText.Text = "⛔ DISABLED"
    statusText.TextColor3 = Color3.fromRGB(255, 0, 0)
    statusText.TextScaled = true
    statusText.Font = Enum.Font.GothamBold
    statusText.Parent = statusFrame
    
    -- Toggle button
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0.8, 0, 0, 40)
    toggleBtn.Position = UDim2.new(0.1, 0, 0.15, 0)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    toggleBtn.Text = "🔴 ENABLE AIMBOT"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextScaled = true
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.BorderSizePixel = 2
    toggleBtn.BorderColor3 = Color3.fromRGB(200, 0, 0)
    toggleBtn.Parent = mainFrame
    
    -- Settings
    local settings = {
        {"🎯 Smoothness", "90%"},
        {"📏 FOV", "120°"},
        {"🎯 Hit Chance", "99%"},
        {"🔫 Auto Shoot", "ON"},
        {"👀 Visible Check", "ON"},
        {"📊 Prediction", "ON"}
    }
    
    for i, setting in ipairs(settings) do
        local yPos = 70 + (i-1) * 35
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0.9, 0, 0, 25)
        frame.Position = UDim2.new(0.05, 0, 0, yPos)
        frame.BackgroundTransparency = 0.5
        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        frame.BorderSizePixel = 1
        frame.BorderColor3 = Color3.fromRGB(100, 100, 150)
        frame.Parent = mainFrame
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.6, 0, 1, 0)
        label.Position = UDim2.new(0, 5, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = setting[1]
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.TextScaled = true
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame
        
        local value = Instance.new("TextLabel")
        value.Size = UDim2.new(0.4, 0, 1, 0)
        value.Position = UDim2.new(0.6, 0, 0, 0)
        value.BackgroundTransparency = 1
        value.Text = setting[2]
        value.TextColor3 = Color3.fromRGB(0, 200, 255)
        value.TextScaled = true
        value.Font = Enum.Font.Gotham
        value.TextXAlignment = Enum.TextXAlignment.Right
        value.Parent = frame
    end
    
    -- FOV circle (fake aim indicator)
    local fovCircle = Instance.new("ImageLabel")
    fovCircle.Size = UDim2.new(0, 200, 0, 200)
    fovCircle.Position = UDim2.new(0.5, -100, 0.5, -100)
    fovCircle.BackgroundTransparency = 1
    fovCircle.Image = "rbxassetid://6022854806" -- Circle image
    fovCircle.ImageColor3 = Color3.fromRGB(0, 200, 255)
    fovCircle.ImageTransparency = 0.7
    fovCircle.Visible = false
    fovCircle.ZIndex = 999
    fovCircle.Parent = screenGui
    
    -- Crosshair
    local crosshair = Instance.new("Frame")
    crosshair.Size = UDim2.new(0, 20, 0, 2)
    crosshair.Position = UDim2.new(0.5, -10, 0.5, -1)
    crosshair.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    crosshair.BackgroundTransparency = 0.5
    crosshair.Parent = screenGui
    
    local crosshair2 = Instance.new("Frame")
    crosshair2.Size = UDim2.new(0, 2, 0, 20)
    crosshair2.Position = UDim2.new(0.5, -1, 0.5, -10)
    crosshair2.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    crosshair2.BackgroundTransparency = 0.5
    crosshair2.Parent = screenGui
    
    -- Toggle functionality
    toggleBtn.MouseButton1Click:Connect(function()
        isFakeAimEnabled = not isFakeAimEnabled
        
        if isFakeAimEnabled then
            toggleBtn.Text = "🟢 DISABLE AIMBOT"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            toggleBtn.BorderColor3 = Color3.fromRGB(0, 200, 0)
            statusText.Text = "✅ ENABLED"
            statusText.TextColor3 = Color3.fromRGB(0, 255, 0)
            statusFrame.BackgroundColor3 = Color3.fromRGB(0, 50, 0)
            fovCircle.Visible = true
            crosshair.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            crosshair2.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            print("🎯 Silent Aim ENABLED - Watch them miss!")
        else
            toggleBtn.Text = "🔴 ENABLE AIMBOT"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            toggleBtn.BorderColor3 = Color3.fromRGB(200, 0, 0)
            statusText.Text = "⛔ DISABLED"
            statusText.TextColor3 = Color3.fromRGB(255, 0, 0)
            statusFrame.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
            fovCircle.Visible = false
            crosshair.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            crosshair2.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            print("🎯 Silent Aim DISABLED")
        end
    end)
    
    return screenGui
end

-- Function to get nearest player (but we'll make it miss)
local function getNearestPlayer()
    local nearest = nil
    local shortestDist = math.huge
    
    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if otherRoot then
                local distance = (otherRoot.Position - mouse.Hit.Position).Magnitude
                if distance < shortestDist then
                    shortestDist = distance
                    nearest = otherPlayer
                end
            end
        end
    end
    
    return nearest
end

-- Function that makes bullets miss (REVERSE AIMBOT)
local function makeBulletsMiss()
    if not isFakeAimEnabled then return end
    
    -- Get a target
    local targetPlayer = getNearestPlayer()
    if not targetPlayer or not targetPlayer.Character then return end
    
    local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    
    -- Calculate where the bullet WOULD go (away from target)
    local targetPos = targetRoot.Position
    local myPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    
    if myPos then
        -- Calculate direction AWAY from target
        local awayDirection = (myPos.Position - targetPos).Unit
        
        -- Random offset to make it look natural
        local randomOffset = Vector3.new(
            math.random(-20, 20),
            math.random(-10, 10),
            math.random(-20, 20)
        )
        
        -- Set mouse to look AWAY from target
        local aimPos = targetPos + awayDirection * 50 + randomOffset
        
        -- Update mouse position (silently)
        -- Note: We can't actually move the mouse, but we can affect where bullets go
        -- This is done by intercepting the mouse hit
        
        -- Make the bullet trajectory miss
        local fakeHit = {
            Position = aimPos,
            Unit = awayDirection
        }
        
        return fakeHit
    end
    
    return nil
end

-- Intercept bullet creation and make it miss
local function interceptBullet()
    local replicatedStorage = game:GetService("ReplicatedStorage")
    
    -- Find bullet remote events (common names)
    local remoteEvents = {
        replicatedStorage:FindFirstChild("FireBullet"),
        replicatedStorage:FindFirstChild("Shoot"),
        replicatedStorage:FindFirstChild("WeaponShoot"),
        replicatedStorage:FindFirstChild("BulletFired"),
        game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvent")
    }
    
    for _, remote in pairs(remoteEvents) do
        if remote then
            -- Hook the remote to modify bullet data
            local oldFire = remote.FireServer
            remote.FireServer = function(...)
                local args = {...}
                
                if isFakeAimEnabled then
                    -- Modify bullet direction to miss
                    local target = getNearestPlayer()
                    if target and target.Character then
                        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
                        if targetRoot then
                            -- Calculate a position BEHIND the target (always miss)
                            local behindPos = targetRoot.Position - (targetRoot.CFrame.LookVector * 5)
                            local offset = Vector3.new(
                                math.random(-15, 15),
                                math.random(-10, 10),
                                math.random(-15, 15)
                            )
                            -- Replace the aim position with a miss
                            if args[1] and type(args[1]) == "Vector3" then
                                args[1] = behindPos + offset
                            elseif args[2] and type(args[2]) == "Vector3" then
                                args[2] = behindPos + offset
                            end
                        end
                    end
                end
                
                return oldFire(unpack(args))
            end
        end
    end
end

-- Function to show fake "hit markers" (even though they miss)
local function createFakeHitMarker()
    local hitMarker = Instance.new("Frame")
    hitMarker.Size = UDim2.new(0, 50, 0, 50)
    hitMarker.Position = UDim2.new(0.5, -25, 0.5, -25)
    hitMarker.BackgroundTransparency = 1
    hitMarker.ZIndex = 1000
    hitMarker.Parent = player.PlayerGui
    
    local hitX = Instance.new("Frame")
    hitX.Size = UDim2.new(1, 0, 0.05, 0)
    hitX.Position = UDim2.new(0, 0, 0.475, 0)
    hitX.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    hitX.BackgroundTransparency = 0.5
    hitX.Parent = hitMarker
    
    local hitY = Instance.new("Frame")
    hitY.Size = UDim2.new(0.05, 0, 1, 0)
    hitY.Position = UDim2.new(0.475, 0, 0, 0)
    hitY.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    hitY.BackgroundTransparency = 0.5
    hitY.Parent = hitMarker
    
    -- Animate and destroy
    spawn(function()
        for i = 1, 20 do
            hitMarker.Size = UDim2.new(0, 50 + i*2, 0, 50 + i*2)
            hitMarker.Position = UDim2.new(0.5, -25 - i, 0.5, -25 - i)
            hitX.BackgroundTransparency = 0.5 + (i/20) * 0.5
            hitY.BackgroundTransparency = 0.5 + (i/20) * 0.5
            task.wait(0.05)
        end
        hitMarker:Destroy()
    end)
end

-- Create fake "headshot" popups
local function createFakeHeadshot()
    local headshot = Instance.new("TextLabel")
    headshot.Size = UDim2.new(0.3, 0, 0.1, 0)
    headshot.Position = UDim2.new(0.35, 0, 0.5, -50)
    headshot.BackgroundTransparency = 0.3
    headshot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    headshot.Text = "💀 HEADSHOT! 💀"
    headshot.TextColor3 = Color3.fromRGB(255, 255, 255)
    headshot.TextScaled = true
    headshot.Font = Enum.Font.GothamBold
    headshot.Parent = player.PlayerGui
    
    spawn(function()
        for i = 1, 30 do
            headshot.Position = UDim2.new(0.35, 0, 0.5 - i*0.002, -50)
            headshot.BackgroundTransparency = 0.3 + (i/30) * 0.7
            task.wait(0.05)
        end
        headshot:Destroy()
    end)
end

-- Hook into damage system to create fake hits
local function hookDamageEvents()
    -- Watch for any damage events and create fake hit markers
    local players = game:GetService("Players")
    
    -- Monitor humanoids for damage
    for _, otherPlayer in pairs(players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local humanoid = otherPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.HealthChanged:Connect(function(health)
                    if isFakeAimEnabled and health < humanoid.MaxHealth then
                        -- This gives the illusion that they're hitting
                        createFakeHitMarker()
                        if math.random(1, 4) == 1 then
                            createFakeHeadshot()
                        end
                    end
                end)
            end
        end
    end
end

-- Create fake kill counter
local killCounter = 0
local function createKillCounter()
    local killFrame = Instance.new("Frame")
    killFrame.Size = UDim2.new(0, 150, 0, 50)
    killFrame.Position = UDim2.new(0.01, 0, 0.05, 0)
    killFrame.BackgroundTransparency = 0.3
    killFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    killFrame.BorderSizePixel = 2
    killFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
    killFrame.Parent = player.PlayerGui
    
    local killText = Instance.new("TextLabel")
    killText.Size = UDim2.new(1, 0, 1, 0)
    killText.BackgroundTransparency = 1
    killText.Text = "KILLS: 0"
    killText.TextColor3 = Color3.fromRGB(255, 0, 0)
    killText.TextScaled = true
    killText.Font = Enum.Font.GothamBold
    killText.Parent = killFrame
    
    -- Increment kills randomly (fake)
    spawn(function()
        while true do
            if isFakeAimEnabled and math.random(1, 3) == 1 then
                killCounter = killCounter + math.random(1, 3)
                killText.Text = "KILLS: " .. killCounter
                killText.TextColor3 = Color3.fromRGB(0, 255, 0)
                task.wait(0.1)
                killText.TextColor3 = Color3.fromRGB(255, 0, 0)
                print("🎯 Fake kill count: " .. killCounter)
            end
            task.wait(2)
        end
    end)
end

-- Initialize
print("🎯 FAKE SILENT AIM LOADED!")
print("🎯 This will make every bullet miss!")
print("🎯 They'll think they're getting kills but they're not!")

-- Create GUI
createGUI()

-- Setup interceptors
task.wait(1)
interceptBullet()
hookDamageEvents()
createKillCounter()

-- Fake "perfect aim" notification that does nothing
local function showFakeNotification()
    local notification = Instance.new("TextLabel")
    notification.Size = UDim2.new(0.4, 0, 0.1, 0)
    notification.Position = UDim2.new(0.3, 0, 0.85, 0)
    notification.BackgroundTransparency = 0.3
    notification.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    notification.Text = "🎯 AIMBOT CALIBRATED 100%"
    notification.TextColor3 = Color3.fromRGB(255, 255, 255)
    notification.TextScaled = true
    notification.Font = Enum.Font.GothamBold
    notification.Parent = player.PlayerGui
    
    task.wait(3)
    notification:Destroy()
end

showFakeNotification()

print("🎯 Fake Silent Aim ready!")
print("🎯 Every shot will miss the target!")
print("🎯 They'll never know what hit them... because nothing will!")
