--[[
    ULTIMATE EXPLOSION TROLL
    Maximum chaos! Multiple explosion types!
    Makes the exploiter's screen go crazy!
--]]

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Create particle effects
local function createParticles(position, color, count)
    for i = 1, count do
        local part = Instance.new("Part")
        part.Size = Vector3.new(0.5, 0.5, 0.5)
        part.Position = position + Vector3.new(
            math.random(-5, 5),
            math.random(-5, 5),
            math.random(-5, 5)
        )
        part.Anchored = false
        part.CanCollide = false
        part.BrickColor = BrickColor.new(color)
        part.Shape = Enum.PartType.Ball
        part.Material = Enum.Material.Neon
        part.Parent = workspace
        
        -- Launch the particle
        part.Velocity = Vector3.new(
            math.random(-100, 100),
            math.random(50, 150),
            math.random(-100, 100)
        )
        
        -- Fade out and destroy
        spawn(function()
            for i = 1, 20 do
                part.Transparency = i / 20
                part.Size = part.Size * 0.9
                task.wait(0.05)
            end
            part:Destroy()
        end)
    end
end

-- Create shockwave ring
local function createShockwave(position)
    local ring = Instance.new("Part")
    ring.Size = Vector3.new(1, 0.5, 1)
    ring.Position = position
    ring.Anchored = true
    ring.CanCollide = false
    ring.BrickColor = BrickColor.new("White")
    ring.Shape = Enum.PartType.Cylinder
    ring.Material = Enum.Material.Neon
    ring.Transparency = 0.5
    ring.Parent = workspace
    
    -- Expand ring
    spawn(function()
        for i = 1, 30 do
            local size = 1 + i * 2
            ring.Size = Vector3.new(size, 0.5, size)
            ring.Transparency = 0.5 + (i / 30) * 0.5
            task.wait(0.02)
        end
        ring:Destroy()
    end)
end

-- The main explosion function
local function megaExplosion()
    if not character or not humanoid then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local pos = rootPart.Position
    
    -- 1. Screen shake
    local camera = workspace.CurrentCamera
    if camera then
        spawn(function()
            for i = 1, 20 do
                camera.CFrame = camera.CFrame + Vector3.new(
                    math.random(-10, 10),
                    math.random(-5, 5),
                    math.random(-5, 5)
                )
                task.wait(0.01)
            end
        end)
    end
    
    -- 2. Multiple explosions
    for i = 1, 10 do
        local offset = Vector3.new(
            math.random(-10, 10),
            math.random(-5, 10),
            math.random(-10, 10)
        )
        createEpicExplosion(pos + offset)
        createShockwave(pos + offset)
        
        -- Different colored particles
        local colors = {"Bright red", "Bright orange", "Yellow", "White", "Neon orange"}
        createParticles(pos + offset, colors[math.random(1, #colors)], 30)
        
        task.wait(0.1)
    end
    
    -- 3. Launch character
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") and part ~= rootPart then
            part.Anchored = false
            part.CanCollide = true
            part.Velocity = Vector3.new(
                math.random(-80, 80),
                math.random(30, 120),
                math.random(-80, 80)
            )
            part:BreakJoints()
        end
    end
    
    -- 4. Root part goes flying
    rootPart.Anchored = false
    rootPart.Velocity = Vector3.new(
        math.random(-50, 50),
        math.random(50, 150),
        math.random(-50, 50)
    )
    
    -- 5. Kill
    humanoid.Health = 0
    
    -- 6. Explosion sounds
    local explosionSounds = {
        "rbxassetid://9120379511",
        "rbxassetid://9120381211",
        "rbxassetid://9120382156"
    }
    
    for i = 1, 3 do
        local sound = Instance.new("Sound")
        sound.SoundId = explosionSounds[math.random(1, #explosionSounds)]
        sound.Volume = 2
        sound.Parent = character
        sound:Play()
        task.wait(0.1)
    end
    
    -- 7. Flash screen
    local flash = Instance.new("Frame")
    flash.Size = UDim2.new(1, 0, 1, 0)
    flash.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    flash.BackgroundTransparency = 0.3
    flash.Parent = player.PlayerGui
    
    spawn(function()
        for i = 1, 10 do
            flash.BackgroundTransparency = 0.1 + math.random() * 0.4
            flash.BackgroundColor3 = Color3.fromRGB(
                math.random(0, 255),
                math.random(0, 255),
                math.random(0, 255)
            )
            task.wait(0.05)
        end
        flash:Destroy()
    end)
end

-- Keep exploding them
local function onRespawn(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    
    task.wait(1)
    megaExplosion()
    
    -- Keep exploding every few seconds
    while true do
        task.wait(math.random(3, 7))
        if character and humanoid and humanoid.Health > 0 then
            megaExplosion()
        end
    end
end

-- Start the chaos
task.wait(1)
megaExplosion()

-- Connect respawn
player.CharacterAdded:Connect(onRespawn)

-- Fun messages
local chatMessages = {
    "💥 EXPLOITER DETECTED! INITIATING SELF-DESTRUCT!",
    "🔥 YOU HAVE BEEN TERMINATED!",
    "💀 GET REKT HACKER!",
    "😂 BOOM! HEADSHOT!",
    "🎯 TARGET ELIMINATED WITH EXTREME PREJUDICE!",
    "🤡 LOL! YOU EXPLODED!",
    "💣 KABOOM! SAY GOODBYE!",
    "😭 AWWW DID YOU EXPLODE?",
    "⚡ YOU'VE BEEN STRIKED!",
    "🔥 YOUR HACKS CAN'T SAVE YOU NOW!",
    "💀 RIP BOZO! YOU GOT TROLLED!",
    "🎉 CELEBRATION! EXPLOITER DESTROYED!"
}

spawn(function()
    while true do
        task.wait(math.random(2, 4))
        local msg = chatMessages[math.random(1, #chatMessages)]
        pcall(function()
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
        end)
        print("💥 " .. msg)
    end
end)

-- Create funny overlay
local gui = Instance.new("ScreenGui")
gui.Name = "ExplosionOverlay"
gui.Parent = player.PlayerGui

-- Big text
local bigText = Instance.new("TextLabel")
bigText.Size = UDim2.new(1, 0, 1, 0)
bigText.BackgroundTransparency = 1
bigText.Text = ""
bigText.TextColor3 = Color3.fromRGB(255, 255, 255)
bigText.TextScaled = true
bigText.Font = Enum.Font.GothamBold
bigText.Parent = gui

-- Cycle through funny text
local texts = {
    "💥 YOU EXPLODED!",
    "🔥 GET REKT!",
    "💀 RIP!",
    "😂 LMAO!",
    "🎯 OWNED!",
    "🤡 SKILL ISSUE!",
    "💣 KABOOM!",
    "😭 SO SAD!",
    "⚡ STRIKE!",
    "🔥 TROLLED!"
}

spawn(function()
    while true do
        for _, text in ipairs(texts) do
            bigText.Text = text
            bigText.TextColor3 = Color3.fromRGB(
                math.random(0, 255),
                math.random(0, 255),
                math.random(0, 255)
            )
            bigText.TextScaled = true
            bigText.BackgroundTransparency = 0.3
            bigText.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            
            task.wait(0.5)
        end
    end
end)

print("💥 ULTIMATE EXPLOSION TROLL LOADED!")
print("🔥 THE EXPLOITER WILL KEEP EXPLODING!")
print("😂 THIS IS GOING TO BE HILARIOUS!")
