--[[
    INFINITE RICKROLL
    They can never escape the Rickroll!
    It follows them everywhere!
--]]

local player = game.Players.LocalPlayer

-- Create persistent Rickroll GUI
local function createPersistentRickroll()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "InfiniteRickroll"
    screenGui.Parent = player.PlayerGui
    
    -- Full screen overlay
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundTransparency = 0.85
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.Parent = screenGui
    
    -- Animated Rickroll text
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 0.2, 0)
    text.Position = UDim2.new(0, 0, 0.4, 0)
    text.BackgroundTransparency = 1
    text.Text = "🎵 RICKROLLED! 🎵"
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.TextScaled = true
    text.Font = Enum.Font.GothamBold
    text.Parent = overlay
    
    -- Lyrics that scroll
    local lyrics = Instance.new("TextLabel")
    lyrics.Size = UDim2.new(0.8, 0, 0.3, 0)
    lyrics.Position = UDim2.new(0.1, 0, 0.65, 0)
    lyrics.BackgroundTransparency = 1
    lyrics.Text = "Never gonna give you up\nNever gonna let you down\nNever gonna run around and desert you\nNever gonna make you cry\nNever gonna say goodbye\nNever gonna tell a lie and hurt you"
    lyrics.TextColor3 = Color3.fromRGB(255, 255, 255)
    lyrics.TextScaled = true
    lyrics.Font = Enum.Font.Gotham
    lyrics.Parent = overlay
    
    -- Animate text
    spawn(function()
        local colors = {
            Color3.fromRGB(255, 0, 0),
            Color3.fromRGB(0, 255, 0),
            Color3.fromRGB(0, 0, 255),
            Color3.fromRGB(255, 255, 0),
            Color3.fromRGB(255, 0, 255),
            Color3.fromRGB(0, 255, 255)
        }
        local i = 1
        while true do
            text.TextColor3 = colors[i % #colors + 1]
            text.Rotation = math.sin(tick() * 2) * 5
            i = i + 1
            task.wait(0.1)
        end
    end)
    
    return screenGui
end

-- Play music that never stops
local function playEternalRickroll()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://1837799086"
    sound.Volume = 1
    sound.Looped = true
    sound.Parent = player.PlayerGui
    
    -- Keep restarting if it stops
    spawn(function()
        while true do
            if not sound.IsPlaying then
                sound:Play()
            end
            task.wait(5)
        end
    end)
    
    sound:Play()
    return sound
end

-- Execute
print("🎵 INFINITE RICKROLL ACTIVATED!")
print("🎵 There is no escape!")

createPersistentRickroll()
playEternalRickroll()

-- Spam with variations
spawn(function()
    local variations = {
        "🎵 You've been RICKROLLED!",
        "🎵 Never gonna give you up!",
        "🎵 Never gonna let you down!",
        "🎵 Rick Astley approves!",
        "🎵 This is the best day ever!",
        "🎵 Dance to the music!",
        "🎵 Can you feel the Rickroll?",
        "🎵 It's happening!",
        "🎵 Embrace the Rickroll!",
        "🎵 You can't escape!"
    }
    
    while true do
        task.wait(math.random(5, 10))
        local msg = variations[math.random(1, #variations)]
        pcall(function()
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
        end)
        print("💬 " .. msg)
    end
end)

-- Make them dance repeatedly
player.CharacterAdded:Connect(function(character)
    task.wait(1)
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        local danceAnim = Instance.new("Animation")
        danceAnim.AnimationId = "rbxassetid://507770545"
        local danceTrack = humanoid:LoadAnimation(danceAnim)
        danceTrack:Play()
        danceTrack.Looped = true
    end
end)

print("🎵 The Rickroll is eternal!")
print("🎵 They will never escape!")
