--[[
    FAKE ESP TROLL SCRIPT
    Looks like a real ESP to exploiters
    Actually does nothing useful but looks convincing
    Perfect for trolling hackers!
--]]

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Create a GUI that looks like a real ESP menu
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ESP_Troll"
screenGui.Parent = player.PlayerGui

-- Main ESP frame
local espFrame = Instance.new("Frame")
espFrame.Size = UDim2.new(0, 200, 0, 250)
espFrame.Position = UDim2.new(0.8, -10, 0.5, -125)
espFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
espFrame.BackgroundTransparency = 0.15
espFrame.BorderSizePixel = 2
espFrame.BorderColor3 = Color3.fromRGB(0, 255, 0)
espFrame.Parent = screenGui

-- Title with "hacker" aesthetic
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, -30)
title.BackgroundTransparency = 1
title.Text = "🔮 ESP v2.0 🔮"
title.TextColor3 = Color3.fromRGB(0, 255, 0)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = espFrame

-- Fake status
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 20)
status.Position = UDim2.new(0, 0, 0, 5)
status.BackgroundTransparency = 1
status.Text = "● ACTIVE"
status.TextColor3 = Color3.fromRGB(0, 255, 0)
status.TextScaled = true
status.Font = Enum.Font.Gotham
status.Parent = espFrame

-- Create toggle buttons that do nothing
local function createToggle(text, yPos, defaultColor)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.9, 0, 0, 25)
    frame.Position = UDim2.new(0.05, 0, 0, yPos)
    frame.BackgroundTransparency = 0.5
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Color3.fromRGB(0, 255, 0)
    frame.Parent = espFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0.2, 0, 0.7, 0)
    toggle.Position = UDim2.new(0.78, 0, 0.15, 0)
    toggle.BackgroundColor3 = defaultColor or Color3.fromRGB(0, 255, 0)
    toggle.Text = "ON"
    toggle.TextColor3 = Color3.fromRGB(0, 0, 0)
    toggle.TextScaled = true
    toggle.Font = Enum.Font.GothamBold
    toggle.BorderSizePixel = 0
    toggle.Parent = frame
    
    local isOn = true
    toggle.MouseButton1Click:Connect(function()
        isOn = not isOn
        if isOn then
            toggle.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            toggle.Text = "ON"
            -- Fake console message
            print("✅ " .. text .. " enabled!")
        else
            toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            toggle.Text = "OFF"
            print("❌ " .. text .. " disabled!")
        end
    end)
end

-- Create fake ESP options
createToggle("📦 Box ESP", 40, Color3.fromRGB(0, 255, 0))
createToggle("📝 Name ESP", 70, Color3.fromRGB(0, 200, 255))
createToggle("📊 Health Bar", 100, Color3.fromRGB(255, 0, 0))
createToggle("🔴 Tracers", 130, Color3.fromRGB(255, 200, 0))
createToggle("🎯 Aim Assist", 160, Color3.fromRGB(255, 0, 255))
createToggle("👻 Chams", 190, Color3.fromRGB(0, 255, 255))

-- Player count display (fake data)
local playerCount = Instance.new("TextLabel")
playerCount.Size = UDim2.new(1, 0, 0, 20)
playerCount.Position = UDim2.new(0, 0, 1, -25)
playerCount.BackgroundTransparency = 1
playerCount.Text = "Players: " .. #game.Players:GetPlayers()
playerCount.TextColor3 = Color3.fromRGB(150, 150, 150)
playerCount.TextScaled = true
playerCount.Font = Enum.Font.Gotham
playerCount.Parent = espFrame

-- Create fake ESP boxes (randomly placed around screen)
local function createFakeESPBox(targetPlayer)
    local box = Instance.new("Frame")
    box.Size = UDim2.new(0, math.random(30, 80), 0, math.random(60, 120))
    box.Position = UDim2.new(math.random(5, 80)/100, 0, math.random(5, 80)/100, 0)
    box.BackgroundTransparency = 0.7
    box.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    box.BorderSizePixel = 2
    box.BorderColor3 = Color3.fromRGB(0, 255, 0)
    box.Parent = screenGui
    
    -- Name label
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 20)
    nameLabel.Position = UDim2.new(0, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = targetPlayer.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = box
    
    -- Health bar (fake)
    local healthBg = Instance.new("Frame")
    healthBg.Size = UDim2.new(1, 0, 0, 5)
    healthBg.Position = UDim2.new(0, 0, 1, 20)
    healthBg.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
    healthBg.BackgroundTransparency = 0.3
    healthBg.Parent = box
    
    local health = Instance.new("Frame")
    health.Size = UDim2.new(math.random(30, 90)/100, 0, 1, 0)
    health.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    health.Parent = healthBg
    
    -- Distance (fake)
    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(0.5, 0, 0, 15)
    distLabel.Position = UDim2.new(0, 0, 1, 27)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = math.random(10, 200) .. "m"
    distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distLabel.TextScaled = true
    distLabel.Font = Enum.Font.Gotham
    distLabel.Parent = box
    
    -- Make box move randomly (looks like it's tracking)
    local speed = math.random(1, 3)
    local direction = math.random(1, 4)
    local counter = 0
    
    game:GetService("RunService").RenderStepped:Connect(function()
        if not box.Parent then return end
        
        counter = counter + 0.1
        local offsetX = math.sin(counter * speed) * 2
        local offsetY = math.cos(counter * speed * 0.7) * 2
        
        box.Position = box.Position + UDim2.new(0, offsetX, 0, offsetY)
        
        -- Randomly change colors (looks like advanced ESP)
        if math.random(1, 100) == 1 then
            box.BackgroundColor3 = Color3.fromRGB(
                math.random(0, 255),
                math.random(0, 255),
                math.random(0, 255)
            )
            box.BorderColor3 = box.BackgroundColor3
        end
    end)
    
    return box
end

-- Generate fake ESP for all players (except yourself)
local espBoxes = {}
for _, targetPlayer in pairs(game.Players:GetPlayers()) do
    if targetPlayer ~= player then
        local box = createFakeESPBox(targetPlayer)
        espBoxes[targetPlayer.Name] = box
    end
end

-- Watch for new players joining
game.Players.PlayerAdded:Connect(function(newPlayer)
    if newPlayer ~= player then
        task.wait(math.random(1, 3))
        local box = createFakeESPBox(newPlayer)
        espBoxes[newPlayer.Name] = box
        print("🆕 New player detected: " .. newPlayer.Name)
        
        -- Update player count
        playerCount.Text = "Players: " .. #game.Players:GetPlayers()
    end
end)

-- Watch for players leaving
game.Players.PlayerRemoving:Connect(function(leavingPlayer)
    if espBoxes[leavingPlayer.Name] then
        espBoxes[leavingPlayer.Name]:Destroy()
        espBoxes[leavingPlayer.Name] = nil
        print("👋 Player left: " .. leavingPlayer.Name)
        
        -- Update player count
        playerCount.Text = "Players: " .. #game.Players:GetPlayers()
    end
end)

-- Add a fake console log (makes it look professional)
print("🔮 ESP v2.0 loaded successfully!")
print("✅ 3D Box ESP: ACTIVE")
print("✅ Name ESP: ACTIVE")
print("✅ Health Bar: ACTIVE")
print("✅ Tracers: ACTIVE")
print("✅ Aim Assist: CALIBRATING...")
task.wait(2)
print("✅ Aim Assist: ACTIVE")
print("🎯 All systems ready!")

-- Fake "injecting" animation
for i = 1, 10 do
    status.Text = "● INJECTING" .. string.rep(".", i % 4)
    task.wait(0.1)
end
status.Text = "● ACTIVE"

-- Add a fake error message that looks like an update
task.wait(math.random(30, 60))
local fakeUpdate = Instance.new("TextLabel")
fakeUpdate.Size = UDim2.new(0.8, 0, 0, 30)
fakeUpdate.Position = UDim2.new(0.1, 0, 1, -60)
fakeUpdate.BackgroundTransparency = 0.3
fakeUpdate.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
fakeUpdate.Text = "⚠️ New update available! (Click to ignore)"
fakeUpdate.TextColor3 = Color3.fromRGB(0, 0, 0)
fakeUpdate.TextScaled = true
fakeUpdate.Font = Enum.Font.Gotham
fakeUpdate.BorderSizePixel = 1
fakeUpdate.BorderColor3 = Color3.fromRGB(255, 200, 0)
fakeUpdate.Parent = espFrame

fakeUpdate.MouseButton1Click:Connect(function()
    fakeUpdate:Destroy()
    print("⏭️ Update ignored")
end)

-- Tracers (fake lines that follow players)
local function createFakeTracer(player)
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0, 2, 0, 100)
    line.Position = UDim2.new(0.5, -1, 0.5, -50)
    line.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
    line.BackgroundTransparency = 0.5
    line.Rotation = math.random(-30, 30)
    line.Parent = screenGui
    
    -- Make it point toward a fake target
    game:GetService("RunService").RenderStepped:Connect(function()
        if not line.Parent then return end
        line.Rotation = line.Rotation + math.sin(tick() * 0.5) * 0.5
    end)
    
    return line
end

-- Create a couple fake tracers
for i = 1, 3 do
    createFakeTracer(player)
end

-- Fake aim assist circle
local aimCircle = Instance.new("Frame")
aimCircle.Size = UDim2.new(0, 100, 0, 100)
aimCircle.Position = UDim2.new(0.5, -50, 0.5, -50)
aimCircle.BackgroundTransparency = 0.8
aimCircle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
aimCircle.BorderSizePixel = 2
aimCircle.BorderColor3 = Color3.fromRGB(255, 0, 0)
aimCircle.ZIndex = 999
aimCircle.Parent = screenGui

-- Make aim circle pulse
local aimPulse = Instance.new("Frame")
aimPulse.Size = UDim2.new(0, 150, 0, 150)
aimPulse.Position = UDim2.new(0.5, -75, 0.5, -75)
aimPulse.BackgroundTransparency = 0.9
aimPulse.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
aimPulse.BorderSizePixel = 0
aimPulse.ZIndex = 998
aimPulse.Parent = screenGui

-- Pulse effect
local pulseValue = 0
game:GetService("RunService").RenderStepped:Connect(function()
    pulseValue = pulseValue + 0.02
    local size = 100 + math.sin(pulseValue) * 20
    aimCircle.Size = UDim2.new(0, size, 0, size)
    aimCircle.Position = UDim2.new(0.5, -size/2, 0.5, -size/2)
    
    aimPulse.Size = UDim2.new(0, size * 1.5, 0, size * 1.5)
    aimPulse.Position = UDim2.new(0.5, -(size * 1.5)/2, 0.5, -(size * 1.5)/2)
end)

-- Add a fake notification that the ESP is working
local notification = Instance.new("TextLabel")
notification.Size = UDim2.new(0.3, 0, 0, 40)
notification.Position = UDim2.new(0.35, 0, 0.8, 0)
notification.BackgroundTransparency = 0.3
notification.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
notification.Text = "🔍 12 players detected nearby"
notification.TextColor3 = Color3.fromRGB(255, 255, 255)
notification.TextScaled = true
notification.Font = Enum.Font.GothamBold
notification.BorderSizePixel = 1
notification.BorderColor3 = Color3.fromRGB(0, 200, 0)
notification.Parent = screenGui

-- Fake notification messages that pop up randomly
local fakeMessages = {
    "🎯 Locked onto target: ",
    "📡 Signal strength: " .. math.random(80, 100) .. "%",
    "🔄 Updating target positions...",
    "⚡ ESP optimized!",
    "🔍 Scanning for new players...",
    "📍 Target acquired!",
    "🎮 Player aimbot calibrated"
}

task.wait(5)
while true do
    task.wait(math.random(15, 45))
    if math.random(1, 3) == 1 then
        local msg = fakeMessages[math.random(1, #fakeMessages)]
        notification.Text = msg
        notification.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        
        -- Flash effect
        notification.BackgroundTransparency = 0.1
        task.wait(0.1)
        notification.BackgroundTransparency = 0.3
        
        print("🔔 " .. msg)
        
        -- Reset after a few seconds
        task.wait(3)
        notification.Text = "🔍 " .. #game.Players:GetPlayers() .. " players detected nearby"
    end
end

print("🎯 Fake ESP troll loaded successfully!")
print("💀 The exploiter thinks they have ESP now... but it's FAKE!")
