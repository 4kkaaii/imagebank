--[[
    FAKE KEY SYSTEM
    Makes the exploiter think they need a key to use scripts
    Wastes their time with fake key generation!
--]]

local player = game.Players.LocalPlayer

-- Create key system GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KeySystem"
screenGui.Parent = player.PlayerGui

local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.new(0, 400, 0, 300)
keyFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
keyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
keyFrame.BackgroundTransparency = 0.1
keyFrame.BorderSizePixel = 2
keyFrame.BorderColor3 = Color3.fromRGB(0, 200, 255)
keyFrame.Parent = screenGui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, -40)
title.BackgroundTransparency = 1
title.Text = "🔑 SCRIPT KEY REQUIRED 🔑"
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = keyFrame

-- Info text
local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -20, 0, 60)
info.Position = UDim2.new(0, 10, 0, 20)
info.BackgroundTransparency = 1
info.Text = "This script requires a valid key.\nVisit our website to get one!\n\nfake-key-generator.com"
info.TextColor3 = Color3.fromRGB(200, 200, 200)
info.TextScaled = true
info.Font = Enum.Font.Gotham
info.Parent = keyFrame

-- Key input
local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(0.8, 0, 0, 40)
keyInput.Position = UDim2.new(0.1, 0, 0.4, 0)
keyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
keyInput.Text = "Enter your key here..."
keyInput.TextColor3 = Color3.fromRGB(200, 200, 200)
keyInput.TextScaled = true
keyInput.Font = Enum.Font.Gotham
keyInput.ClearTextOnFocus = true
keyInput.Parent = keyFrame

-- Submit button
local submitBtn = Instance.new("TextButton")
submitBtn.Size = UDim2.new(0.3, 0, 0, 40)
submitBtn.Position = UDim2.new(0.35, 0, 0.6, 0)
submitBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
submitBtn.Text = "ACTIVATE KEY"
submitBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
submitBtn.TextScaled = true
submitBtn.Font = Enum.Font.GothamBold
submitBtn.Parent = keyFrame

-- Fake key validation
submitBtn.MouseButton1Click:Connect(function()
    local key = keyInput.Text
    
    if #key < 5 then
        -- Fake error
        local error = Instance.new("TextLabel")
        error.Size = UDim2.new(0.8, 0, 0, 30)
        error.Position = UDim2.new(0.1, 0, 0.75, 0)
        error.BackgroundTransparency = 0.3
        error.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        error.Text = "❌ Invalid key! Try again!"
        error.TextColor3 = Color3.fromRGB(255, 255, 255)
        error.TextScaled = true
        error.Font = Enum.Font.Gotham
        error.Parent = keyFrame
        
        task.wait(2)
        error:Destroy()
        return
    end
    
    -- Fake loading
    submitBtn.Text = "⏳ VERIFYING..."
    submitBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
    
    -- Fake verification process
    local messages = {
        "Checking key validity...",
        "Key found in database!",
        "Verifying key signature...",
        "Key is valid!",
        "Loading script..."
    }
    
    for i, msg in ipairs(messages) do
        info.Text = "🔍 " .. msg
        task.wait(math.random(1, 3))
    end
    
    -- Troll them with fake key requirement
    local fakeKeys = {
        "Your key is valid but requires a subscription!",
        "Free keys are limited! Pay $5 for full access!",
        "This key has been revoked! Please contact support!",
        "Key system is under maintenance! Try again later!",
        "You need to complete a survey to use this key!",
        "Click on the hidden button to activate!",
        "This key is for VIP members only!"
    }
    
    info.Text = "❌ " .. fakeKeys[math.random(1, #fakeKeys)]
    info.TextColor3 = Color3.fromRGB(255, 200, 0)
    submitBtn.Text = "TRY AGAIN"
    submitBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    
    print("😂 Exploiter wasted time on fake key system!")
end)

print("🔑 Fake key system loaded!")
print("💀 Exploiter will be confused forever!")
