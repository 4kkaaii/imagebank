--[[
    RAGDOLL THE EXPLOITER
    Simple script that just ragdolls the player
    No explosions, no effects, just pure ragdoll!
--]]

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Function to ragdoll the character
local function ragdollCharacter()
    if not character or not humanoid then return end
    
    -- Method 1: Break joints (quick ragdoll)
    humanoid:BreakJoints()
    
    -- Method 2: Set platform stand (makes them flop)
    humanoid.PlatformStand = true
    
    -- Method 3: Disable auto-rotate for floppy effect
    humanoid.AutoRotate = false
    
    -- Method 4: Set all parts to not anchored and allow physics
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.Anchored = false
            part.CanCollide = true
            -- Give them a little push so they fall over
            part.Velocity = Vector3.new(
                math.random(-5, 5),
                math.random(-2, 2),
                math.random(-5, 5)
            )
        end
    end
    
    -- Method 5: Break all motor joints (disconnects limbs)
    if character:FindFirstChild("HumanoidRootPart") then
        for _, joint in pairs(character.HumanoidRootPart:GetChildren()) do
            if joint:IsA("Motor6D") or joint:IsA("MotorFeature") then
                joint:Destroy()
            end
        end
    end
    
    print("🦴 Exploiter has been ragdolled!")
end

-- Execute ragdoll
ragdollCharacter()

-- Keep them ragdolled if they respawn
local function onRespawn(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    
    -- Wait a moment then ragdoll again
    task.wait(1)
    ragdollCharacter()
    
    -- Keep ragdolling them every few seconds
    while true do
        task.wait(2)
        if character and humanoid and humanoid.Health > 0 then
            ragdollCharacter()
        end
    end
end

player.CharacterAdded:Connect(onRespawn)

print("✅ Ragdoll script loaded!")
print("🦴 Exploiter will keep ragdolling!")
