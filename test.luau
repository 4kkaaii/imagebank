--[[
    MOON LAUNCH FLING
    Flings the exploiter SUPER high!
    Like they're going to the moon!
--]]

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local function moonLaunch()
    if not character or not humanoid or not rootPart then return end
    
    -- Remove gravity effects temporarily
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.Anchored = false
            part.CanCollide = true
        end
    end
    
    -- MEGA FLING STRAIGHT UP
    local megaPower = 1000
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.Velocity = Vector3.new(0, megaPower, 0)
            part.RotVelocity = Vector3.new(
                math.random(-200, 200),
                math.random(-200, 200),
                math.random(-200, 200)
            )
        end
    end
    
    -- Disable platform stand so they actually fly
    humanoid.PlatformStand = false
    
    print("🌙 Exploiter launched to the moon!")
end

-- Execute
moonLaunch()

-- Keep launching on respawn
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    task.wait(1)
    moonLaunch()
end)

print("✅ Moon launch loaded!")
print("🌙 Exploiter is going to space!")
