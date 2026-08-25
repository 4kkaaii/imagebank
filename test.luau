--[[
    FAKE "HACK" THAT DOES THE OPPOSITE
    Looks like a hack but actually makes you worse!
--]]

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Create fake hack GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HackTools"
screenGui.Parent = player.PlayerGui

local hackFrame = Instance.new("Frame")
hackFrame.Size = UDim2.new(0, 250, 0, 300)
hackFrame.Position = UDim2.new(0.8, -260, 0.5, -150)
hackFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
hackFrame.BackgroundTransparency = 0.15
hackFrame.BorderSizePixel = 2
hackFrame.BorderColor3 = Color3.fromRGB(255, 0, 255)
hackFrame.Parent = screenGui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, -30)
title.BackgroundTransparency = 1
title.Text = "💜 HACK TOOLS v2.0 💜"
title.TextColor3 = Color3.fromRGB(255, 0, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = hackFrame

-- Hack buttons that do the opposite
local hacks = {
    {"🤸 SUPER JUMP", "Makes you jump really high!"},
    {"🏃 SPEED HACK", "Makes you super fast!"},
    {"🛡️ GOD MODE", "Makes you invincible!"},
    {"👻 INVISIBLE", "Makes you invisible!"},
    {"💀 KILL ALL", "Kills everyone!"},
    {"💰 INF MONEY", "Gives infinite money!"}
}

local function createHackButton(text, desc, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(255, 0, 255)
    btn.Parent = hackFrame
    
    -- Tooltip
    local tooltip = Instance.new("TextLabel")
    tooltip.Size = UDim2.new(1, 0, 0, 15)
    tooltip.Position = UDim2.new(0, 0, 1, 0)
    tooltip.BackgroundTransparency = 1
    tooltip.Text = desc
    tooltip.TextColor3 = Color3.fromRGB(150, 150, 150)
    tooltip.TextScaled = true
    tooltip.Font = Enum.Font.Gotham
    tooltip.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
        task.wait(0.1)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        
        if text:find("JUMP") then
            -- Actually makes you jump lower
            humanoid.JumpPower = 30
            print("😂 Jump hack: Jump power reduced to 30!")
            task.wait(10)
            humanoid.JumpPower = 50
            
        elseif text:find("SPEED") then
            -- Actually slows you down
            humanoid.WalkSpeed = 8
            print("😂 Speed hack: Walk speed reduced to 8!")
            task.wait(10)
            humanoid.WalkSpeed = 16
            
        elseif text:find("GOD") then
            -- Makes you take MORE damage
            humanoid.MaxHealth = 50
            humanoid.Health = 50
            print("😂 God mode: Max health reduced to 50!")
            task.wait(10)
            humanoid.MaxHealth = 100
            humanoid.Health = 100
            
        elseif text:find("INVISIBLE") then
            -- Makes you MORE visible
            character.Head.Transparency = 1
            character.Torso.Transparency = 1
            print("😂 Invisibility: You're now more visible!")
            task.wait(5)
            character.Head.Transparency = 0
            character.Torso.Transparency = 0
            
        elseif text:find("KILL") then
            -- Makes you take damage
            humanoid.Health = humanoid.Health - 50
            print("😂 Kill all: You took damage instead!")
            
        elseif text:find("MONEY") then
            -- Fake money hack
            local fakeMoney = Instance.new("TextLabel")
            fakeMoney.Size = UDim2.new(0.8, 0, 0, 30)
            fakeMoney.Position = UDim2.new(0.1, 0, 0.8, 0)
            fakeMoney.BackgroundTransparency = 0.3
            fakeMoney.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            fakeMoney.Text = "💰 INFINITE MONEY ACTIVATED! (not really)"
            fakeMoney.TextColor3 = Color3.fromRGB(255, 255, 255)
            fakeMoney.TextScaled = true
            fakeMoney.Font = Enum.Font.Gotham
            fakeMoney.Parent = hackFrame
            
            print("😂 Infinite money hack: It's fake!")
            task.wait(3)
            fakeMoney:Destroy()
        end
    end)
end

-- Create all hack buttons
for i, hack in ipairs(hacks) do
    createHackButton(hack[1], hack[2], 35 + (i-1) * 40)
end

print("💜 Fake hack tools loaded!")
print("💀 These hacks actually make you worse!")
