--[[
    MODERN FAKE SILENT AIM
    Premium-looking silent aim GUI
    Actually makes bullets miss
    J to toggle GUI visibility
    Switch inside GUI to toggle aimbot
    Persists through respawns
--]]

local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

-- Settings
local isEnabled = false
local isGUIVisible = true
local GUI_TOGGLE_KEY = Enum.KeyCode.J
local aimbotSwitch = nil

-- Create modern GUI
local function createModernGUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SilentAimPremium"
    screenGui.ResetOnSpawn = false -- Persists through respawns!
    screenGui.Parent = player.PlayerGui
    
    -- Main container
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 340, 0, 460)
    mainFrame.Position = UDim2.new(0.5, -170, 0.5, -230)
    mainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
    mainFrame.BackgroundTransparency = 0.05
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    
    -- Modern glass effect (border glow)
    local glowBorder = Instance.new("Frame")
    glowBorder.Size = UDim2.new(1, 4, 1, 4)
    glowBorder.Position = UDim2.new(0, -2, 0, -2)
    glowBorder.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    glowBorder.BackgroundTransparency = 0.8
    glowBorder.BorderSizePixel = 0
    glowBorder.Parent = mainFrame
    
    -- Shadow
    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.Position = UDim2.new(0, -15, 0, -15)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.6
    shadow.BorderSizePixel = 0
    shadow.Parent = mainFrame
    
    -- Gradient header with accent
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 65)
    header.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    
    -- Accent line
    local accentLine = Instance.new("Frame")
    accentLine.Size = UDim2.new(0.3, 0, 0, 2)
    accentLine.Position = UDim2.new(0.35, 0, 1, -2)
    accentLine.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    accentLine.BorderSizePixel = 0
    accentLine.Parent = header
    
    -- Title with icon
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 8)
    title.BackgroundTransparency = 1
    title.Text = "◈ SILENT AIM ◈"
    title.TextColor3 = Color3.fromRGB(0, 200, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = header
    
    -- Subtitle
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, 0, 0, 20)
    subtitle.Position = UDim2.new(0, 0, 0, 40)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Premium Aimbot System v4.2"
    subtitle.TextColor3 = Color3.fromRGB(140, 140, 170)
    subtitle.TextScaled = true
    subtitle.Font = Enum.Font.Gotham
    subtitle.Parent = header
    
    -- Status section
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0.4, 0, 0, 20)
    statusLabel.Position = UDim2.new(0.05, 0, 0, 75)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "STATUS"
    statusLabel.TextColor3 = Color3.fromRGB(140, 140, 170)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = mainFrame
    
    -- Status indicator (modern pill)
    local statusFrame = Instance.new("Frame")
    statusFrame.Size = UDim2.new(0.4, 0, 0, 35)
    statusFrame.Position = UDim2.new(0.05, 0, 0, 95)
    statusFrame.BackgroundColor3 = Color3.fromRGB(40, 10, 10)
    statusFrame.BackgroundTransparency = 0.3
    statusFrame.BorderSizePixel = 1
    statusFrame.BorderColor3 = Color3.fromRGB(200, 50, 50)
    statusFrame.Parent = mainFrame
    
    -- Status dot
    local statusDot = Instance.new("Frame")
    statusDot.Size = UDim2.new(0, 12, 0, 12)
    statusDot.Position = UDim2.new(0.1, 0, 0.5, -6)
    statusDot.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    statusDot.BorderSizePixel = 0
    statusDot.Parent = statusFrame
    
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(0.8, 0, 1, 0)
    statusText.Position = UDim2.new(0.25, 0, 0, 0)
    statusText.BackgroundTransparency = 1
    statusText.Text = "DISABLED"
    statusText.TextColor3 = Color3.fromRGB(255, 80, 80)
    statusText.TextScaled = true
    statusText.Font = Enum.Font.GothamBold
    statusText.TextXAlignment = Enum.TextXAlignment.Left
    statusText.Parent = statusFrame
    
    -- AIMBOT TOGGLE SWITCH (Main switch)
    local switchLabel = Instance.new("TextLabel")
    switchLabel.Size = UDim2.new(0.4, 0, 0, 20)
    switchLabel.Position = UDim2.new(0.55, 0, 0, 75)
    switchLabel.BackgroundTransparency = 1
    switchLabel.Text = "AIMBOT"
    switchLabel.TextColor3 = Color3.fromRGB(140, 140, 170)
    switchLabel.TextScaled = true
    switchLabel.Font = Enum.Font.GothamBold
    switchLabel.TextXAlignment = Enum.TextXAlignment.Right
    switchLabel.Parent = mainFrame
    
    -- Main toggle switch (modern design)
    local switchFrame = Instance.new("Frame")
    switchFrame.Size = UDim2.new(0, 60, 0, 30)
    switchFrame.Position = UDim2.new(0.85, -30, 0, 100)
    switchFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    switchFrame.BackgroundTransparency = 0.3
    switchFrame.BorderSizePixel = 2
    switchFrame.BorderColor3 = Color3.fromRGB(60, 60, 80)
    switchFrame.Parent = mainFrame
    
    local switchBtn = Instance.new("TextButton")
    switchBtn.Size = UDim2.new(0.45, 0, 0.8, 0)
    switchBtn.Position = UDim2.new(0.03, 0, 0.1, 0)
    switchBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    switchBtn.BackgroundTransparency = 0.1
    switchBtn.Text = ""
    switchBtn.BorderSizePixel = 0
    switchBtn.Parent = switchFrame
    
    -- Switch text (ON/OFF)
    local switchText = Instance.new("TextLabel")
    switchText.Size = UDim2.new(0.5, 0, 1, 0)
    switchText.Position = UDim2.new(0.55, 0, 0, 0)
    switchText.BackgroundTransparency = 1
    switchText.Text = "OFF"
    switchText.TextColor3 = Color3.fromRGB(200, 100, 100)
    switchText.TextScaled = true
    switchText.Font = Enum.Font.GothamBold
    switchText.TextXAlignment = Enum.TextXAlignment.Right
    switchText.Parent = switchFrame
    
    -- Settings section title
    local settingsTitle = Instance.new("TextLabel")
    settingsTitle.Size = UDim2.new(1, 0, 0, 25)
    settingsTitle.Position = UDim2.new(0, 0, 0, 145)
    settingsTitle.BackgroundTransparency = 1
    settingsTitle.Text = "⚙ SETTINGS"
    settingsTitle.TextColor3 = Color3.fromRGB(140, 140, 170)
    settingsTitle.TextScaled = true
    settingsTitle.Font = Enum.Font.GothamBold
    settingsTitle.Parent = mainFrame
    
    -- Setting items with toggle switches
    local settings = {
        {"Smoothness", "95%", true},
        {"FOV Radius", "120°", true},
        {"Hit Chance", "99%", true},
        {"Auto Shoot", "ON", true},
        {"Visible Check", "ON", true},
        {"Prediction", "ON", true}
    }
    
    local settingFrames = {}
    for i, setting in ipairs(settings) do
        local yPos = 175 + (i-1) * 32
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0.9, 0, 0, 27)
        frame.Position = UDim2.new(0.05, 0, 0, yPos)
        frame.BackgroundTransparency = 0.5
        frame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
        frame.BorderSizePixel = 1
        frame.BorderColor3 = Color3.fromRGB(40, 40, 70)
        frame.Parent = mainFrame
        settingFrames[i] = frame
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.5, 0, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = setting[1]
        label.TextColor3 = Color3.fromRGB(200, 200, 220)
        label.TextScaled = true
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0.25, 0, 1, 0)
        valueLabel.Position = UDim2.new(0.55, 0, 0, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = setting[2]
        valueLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
        valueLabel.TextScaled = true
        valueLabel.Font = Enum.Font.Gotham
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Parent = frame
        
        -- Small toggle switch
        local smallSwitch = Instance.new("TextButton")
        smallSwitch.Size = UDim2.new(0, 35, 0, 18)
        smallSwitch.Position = UDim2.new(0.9, -40, 0.5, -9)
        smallSwitch.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        smallSwitch.BackgroundTransparency = 0.2
        smallSwitch.Text = "ON"
        smallSwitch.TextColor3 = Color3.fromRGB(255, 255, 255)
        smallSwitch.TextScaled = true
        smallSwitch.Font = Enum.Font.GothamBold
        smallSwitch.BorderSizePixel = 0
        smallSwitch.Parent = frame
        
        local isOn = true
        smallSwitch.MouseButton1Click:Connect(function()
            isOn = not isOn
            if isOn then
                smallSwitch.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
                smallSwitch.Text = "ON"
                valueLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
            else
                smallSwitch.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                smallSwitch.Text = "OFF"
                valueLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
            end
        end)
    end
    
    -- Keybind indicator
    local keybindFrame = Instance.new("Frame")
    keybindFrame.Size = UDim2.new(0.9, 0, 0, 30)
    keybindFrame.Position = UDim2.new(0.05, 0, 0, 425)
    keybindFrame.BackgroundTransparency = 0.5
    keybindFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
    keybindFrame.BorderSizePixel = 1
    keybindFrame.BorderColor3 = Color3.fromRGB(40, 40, 70)
    keybindFrame.Parent = mainFrame
    
    local keybindLabel = Instance.new("TextLabel")
    keybindLabel.Size = UDim2.new(1, 0, 1, 0)
    keybindLabel.BackgroundTransparency = 1
    keybindLabel.Text = "⌨ Press J to toggle GUI"
    keybindLabel.TextColor3 = Color3.fromRGB(150, 150, 180)
    keybindLabel.TextScaled = true
    keybindLabel.Font = Enum.Font.Gotham
    keybindLabel.Parent = keybindFrame
    
    -- FOV Circle (modern)
    local fovCircle = Instance.new("ImageLabel")
    fovCircle.Size = UDim2.new(0, 200, 0, 200)
    fovCircle.Position = UDim2.new(0.5, -100, 0.5, -100)
    fovCircle.BackgroundTransparency = 1
    fovCircle.Image = "rbxassetid://6022854806"
    fovCircle.ImageColor3 = Color3.fromRGB(0, 200, 255)
    fovCircle.ImageTransparency = 0.8
    fovCircle.Visible = false
    fovCircle.ZIndex = 999
    fovCircle.Parent = screenGui
    
    -- Modern crosshair
    local crosshairGroup = Instance.new("Frame")
    crosshairGroup.Size = UDim2.new(0, 30, 0, 30)
    crosshairGroup.Position = UDim2.new(0.5, -15, 0.5, -15)
    crosshairGroup.BackgroundTransparency = 1
    crosshairGroup.Parent = screenGui
    
    local function createCrosshairPart(size, position, color)
        local part = Instance.new("Frame")
        part.Size = UDim2.new(0, size, 0, 2)
        part.Position = UDim2.new(0.5, position, 0.5, -1)
        part.BackgroundColor3 = color
        part.BackgroundTransparency = 0.5
        part.Parent = crosshairGroup
        return part
    end
    
    -- Crosshair lines
    local crosshairParts = {}
    local colors = {
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 255, 0)
    }
    
    -- Top, Bottom, Left, Right
    local positions = {
        {0, 0, 0, -10}, -- Top
        {0, 0, 0, 8},   -- Bottom
        {0, -10, 0, 0}, -- Left
        {0, 8, 0, 0}    -- Right
    }
    
    for i, pos in ipairs(positions) do
        local part = Instance.new("Frame")
        if i <= 2 then
            part.Size = UDim2.new(0, 15, 0, 2)
            part.Position = UDim2.new(0.5, -7, 0.5, pos[4])
        else
            part.Size = UDim2.new(0, 2, 0, 15)
            part.Position = UDim2.new(0.5, pos[3], 0.5, -7)
        end
        part.BackgroundColor3 = colors[i]
        part.BackgroundTransparency = 0.5
        part.Parent = crosshairGroup
        table.insert(crosshairParts, part)
    end
    
    -- Center dot
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 4, 0, 4)
    dot.Position = UDim2.new(0.5, -2, 0.5, -2)
    dot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    dot.BackgroundTransparency = 0.3
    dot.Parent = crosshairGroup
    
    -- Main switch toggle function
    local function toggleAimbot()
        isEnabled = not isEnabled
        
        if isEnabled then
            -- Update main switch
            switchBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            switchBtn.Position = UDim2.new(0.52, 0, 0.1, 0)
            switchText.Text = "ON"
            switchText.TextColor3 = Color3.fromRGB(100, 255, 100)
            switchFrame.BorderColor3 = Color3.fromRGB(50, 200, 50)
            
            -- Update status
            statusText.Text = "ENABLED"
            statusText.TextColor3 = Color3.fromRGB(50, 255, 50)
            statusFrame.BackgroundColor3 = Color3.fromRGB(10, 50, 10)
            statusFrame.BorderColor3 = Color3.fromRGB(50, 200, 50)
            statusDot.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
            
            -- Show FOV circle
            fovCircle.Visible = true
            fovCircle.ImageTransparency = 0.6
            
            -- Change crosshair to red (aimbot mode)
            for _, part in pairs(crosshairParts) do
                part.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            end
            dot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            
            print("🎯 Silent Aim ENABLED - Prepare to miss everything!")
        else
            -- Update main switch
            switchBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            switchBtn.Position = UDim2.new(0.03, 0, 0.1, 0)
            switchText.Text = "OFF"
            switchText.TextColor3 = Color3.fromRGB(200, 100, 100)
            switchFrame.BorderColor3 = Color3.fromRGB(60, 60, 80)
            
            -- Update status
            statusText.Text = "DISABLED"
            statusText.TextColor3 = Color3.fromRGB(255, 80, 80)
            statusFrame.BackgroundColor3 = Color3.fromRGB(40, 10, 10)
            statusFrame.BorderColor3 = Color3.fromRGB(200, 50, 50)
            statusDot.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            
            -- Hide FOV circle
            fovCircle.Visible = false
            
            -- Change crosshair back to green
            for _, part in pairs(crosshairParts) do
                part.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            end
            dot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            
            print("🎯 Silent Aim DISABLED")
        end
    end
    
    -- Connect main switch click
    switchBtn.MouseButton1Click:Connect(toggleAimbot)
    
    -- Also click on the switch frame to toggle
    switchFrame.MouseButton1Click:Connect(toggleAimbot)
    
    -- J key to toggle GUI visibility
    userInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == GUI_TOGGLE_KEY then
            isGUIVisible = not isGUIVisible
            mainFrame.Visible = isGUIVisible
            if isGUIVisible then
                print("🎯 GUI Visible")
            else
                print("🎯 GUI Hidden (Press J to show)")
            end
        end
    end)
    
    return screenGui, mainFrame, fovCircle, toggleAimbot
end

-- Initialize GUI
local gui, mainFrame, fovCircle, toggleAimbot = createModernGUI()

-- Function to get nearest player (for fake targeting)
local function getNearestPlayer()
    local nearest = nil
    local shortestDist = math.huge
    
    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if otherRoot then
                local mouse = player:GetMouse()
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

-- Hook into bullet remote events to make them miss
local function interceptBullets()
    local replicatedStorage = game:GetService("ReplicatedStorage")
    
    -- Common remote event names for weapons
    local remoteNames = {
        "FireBullet", "Shoot", "WeaponShoot", "BulletFired",
        "RemoteEvent", "ToolEvent", "WeaponRemote", "GunFire",
        "Fire", "ShootEvent", "FireWeapon", "GunRemote"
    }
    
    for _, name in pairs(remoteNames) do
        local remote = replicatedStorage:FindFirstChild(name)
        if remote then
            local oldFire = remote.FireServer
            remote.FireServer = function(...)
                local args = {...}
                
                if isEnabled then
                    local target = getNearestPlayer()
                    if target and target.Character then
                        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
                        if targetRoot then
                            -- Calculate position AWAY from target
                            local myPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                            if myPos then
                                local awayDir = (myPos.Position - targetRoot.Position).Unit
                                local missOffset = Vector3.new(
                                    math.random(-30, 30),
                                    math.random(-20, 20),
                                    math.random(-30, 30)
                                )
                                local aimPos = targetRoot.Position + awayDir * 50 + missOffset
                                
                                -- Replace the aim position with a miss
                                if args[1] and type(args[1]) == "Vector3" then
                                    args[1] = aimPos
                                elseif args[2] and type(args[2]) == "Vector3" then
                                    args[2] = aimPos
                                end
                            end
                        end
                    end
                end
                
                return oldFire(unpack(args))
            end
        end
    end
end

-- Make FOV circle pulse when enabled
local function animateFOV()
    while true do
        if isEnabled and fovCircle then
            local pulse = math.sin(tick() * 3) * 0.1 + 0.6
            fovCircle.ImageTransparency = pulse
            fovCircle.ImageColor3 = Color3.fromRGB(
                0,
                math.floor(200 + math.sin(tick() * 2) * 55),
                math.floor(255 + math.sin(tick() * 2.5) * 55)
            )
        end
        task.wait(0.05)
    end
end

-- Initialize
print("🎯 MODERN FAKE SILENT AIM LOADED")
print("🎯 Premium Edition v4.2")
print("🎯 Press J to toggle GUI visibility")
print("🎯 Use the switch inside the GUI to toggle aimbot")
print("🎯 Every shot will miss the target!")

-- Setup interceptors
task.wait(1)
interceptBullets()

-- Start animations
s
