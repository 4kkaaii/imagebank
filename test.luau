--[[
    FLING THE EXPLOITER
    Simple script that just flings the player
    No explosions, no effects, just pure flinging!
--]]

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Function to fling the character
local function flingCharacter()
    if not character or not humanoid or not rootPart then return end
    
    -- Make sure parts can move
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.Anchored = false
            part.CanCollide = true
        end
    end
    
    -- Fling them in a random direction with random power
    local flingPower = math.random(200, 500)
    local direction = Vector3.new(
        math.random(-1, 1),
        math.random(0.5, 1.5),
        math.random(-1, 1)
    ).Unit
    
    -- Apply velocity to all parts
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.Velocity = direction * flingPower
            part.RotVelocity = Vector3.new(
                math.random(-100, 100),
                math.random(-100, 100),
                math.random(-100, 100)
            )
        end
    end
    
    print("🚀 Exploiter has been flung!")
end

-- Execute fling
flingCharacter()

-- Keep flinging them if they respawn
local function onRespawn(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Wait a moment then fling again
    task.wait(1)
    flingCharacter()
    
    -- Keep flinging them every few seconds
    while true do
        task.wait(math.random(2, 5))
        if character and humanoid and humanoid.Health > 0 then
            flingCharacter()
        end
    end
end

player.CharacterAdded:Connect(onRespawn)

print("✅ Fling script loaded!")
print("🚀 Exploiter will keep getting flung!")
