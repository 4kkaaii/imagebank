--[[
    💥 EXPLODE THE EXPLOITER 💥
    When injected, the exploiter's character explodes!
    Multiple explosion effects for maximum trolling!
--]]

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Function to create epic explosion
local function createEpicExplosion(position)
    -- Create explosion part
    local explosion = Instance.new("Part")
    explosion.Size = Vector3.new(10, 10, 10)
    explosion.Position = position
    explosion.Anchored = true
    explosion.CanCollide = false
    explosion.Transparency = 0.5
    explosion.BrickColor = BrickColor.new("Bright red")
    explosion.Shape = Enum.PartType.Ball
    explosion.Material = Enum.Material.Neon
    explosion.Parent = workspace
    
    -- Glow effect
    local glow = Instance.new("PointLight")
    glow.Color = Color3.fromRGB(255, 100, 0)
    glow.Range = 25
    glow.Brightness = 5
    glow.Parent = explosion
    
    -- Grow animation
    local startSize = 1
    local endSize = 15
    local duration = 0.5
    
    for i = 0, 1, 0.02 do
        local currentSize = startSize + (endSize - startSize) * i
        explosion.Size = Vector3.new(currentSize, currentSize, currentSize)
        explosion.Transparency = 0.5 * i
        task.wait(0.01)
    end
    
    -- Destroy after animation
    task.wait(0.3)
    explosion:Destroy()
end

-- Function to kill the character in funny ways
local function killExploiter()
    if not character or not humanoid then return end
    
    -- Method 1: Classic explosion
    print("💥 EXPLODING THE EXPLOITER!")
    
    -- Make character explode
    local explosionPos = character.HumanoidRootPart.Position
    
    -- Create multiple explosions
    for i = 1, 5 do
        local offset = Vector3.new(
            math.random(-5, 5),
            math.random(-5, 5),
            math.random(-5, 5)
        )
        createEpicExplosion(explosionPos + offset)
        task.wait(0.1)
    end
    
    -- Big final explosion
    createEpicExplosion(explosionPos)
    
    -- Launch body parts everywhere
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.Anchored = false
            part.CanCollide = true
            part.Velocity = Vector3.new(
                math.random(-50, 50),
                math.random(20, 80),
                math.random(-50, 50)
            )
            part:BreakJoints()
        end
    end
    
    -- Kill the humanoid
    humanoid.Health = 0
    
    -- Create explosion sound
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://9120379511" -- Explosion sound
    sound.Volume = 2
    sound.Parent = character
    sound:Play()
    
    -- Screen shake effect
    local camera = workspace.CurrentCamera
    if camera then
        for i = 1, 10 do
            camera.CFrame = camera.CFrame + Vector3.new(
                math.random(-5, 5),
                math.random(-5, 5),
                0
            )
            task.wait(0.01)
        end
    end
end

-- Watch for character respawn and explode again
local function onCharacterAdded(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    
    -- Wait a moment then explode again
    task.wait(2)
    killExploiter()
    
    -- Keep exploding them on respawn
    while true do
        task.wait(3)
        if character and humanoid and humanoid.Health > 0 then
            killExploiter()
        end
    end
end

-- Initial explosion
task.wait(1)
killExploiter()

-- Connect to respawn
player.CharacterAdded:Connect(onCharacterAdded)

-- Spam funny messages
local messages = {
    "💥 BOOM! Exploiter detected!",
    "😂 Get rekt hacker!",
    "🔥 You just exploded!",
    "💀 RIP exploiter!",
    "🎯 Target eliminated!",
    "🤡 Skill issue!",
    "💣 KABOOM!",
    "😭 Aww, did you explode?",
    "⭐ Explosion success!",
    "🚀 You've been launched!",
    "💥 Exploiter.exe has stopped working",
    "🔥 Your hacks can't save you now!"
}

-- Spam messages to chat
spawn(function()
    while true do
        task.wait(math.random(2, 5))
        local msg = messages[math.random(1, #messages)]
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
        print(msg)
    end
end)

-- Create a "You Exploded" GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ExplosionTroll"
screenGui.Parent = player.PlayerGui

local explosionText = Instance.new("TextLabel")
explosionText.Size = UDim2.new(1, 0, 0.3, 0)
explosionText.Position = UDim2.new(0, 0, 0.35, 0)
explosionText.BackgroundTransparency = 0.3
explosionText.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
explosionText.Text = "💥 YOU EXPLODED! 💥"
explosionText.TextColor3 = Color3.fromRGB(255, 255, 255)
explosionText.TextScaled = true
explosionText.Font = Enum.Font.GothamBold
explosionText.BorderSizePixel = 3
explosionText.BorderColor3 = Color3.fromRGB(255, 200, 0)
explosionText.Parent = screenGui

-- Subtle flashing effect
spawn(function()
    while true do
        explosionText.BackgroundTransparency = 0.2
        task.wait(0.2)
        explosionText.BackgroundTransparency = 0.5
        task.wait(0.2)
    end
end)

print("💥 Explode script loaded!")
print("🔥 The exploiter will keep exploding!")
