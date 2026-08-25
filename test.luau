--[[
    SIMPLE KEY SWAP
    Just swaps WASD keys randomly
    Clean and effective!
--]]

local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")

-- Randomly swap WASD
local function randomizeWASD()
    local keys = {
        Enum.KeyCode.W,
        Enum.KeyCode.A,
        Enum.KeyCode.S,
        Enum.KeyCode.D
    }
    
    -- Shuffle
    for i = #keys, 2, -1 do
        local j = math.random(1, i)
        keys[i], keys[j] = keys[j], keys[i]
    end
    
    local mapping = {}
    mapping[Enum.KeyCode.W] = keys[1]
    mapping[Enum.KeyCode.A] = keys[2]
    mapping[Enum.KeyCode.S] = keys[3]
    mapping[Enum.KeyCode.D] = keys[4]
    
    return mapping
end

controlMappings = randomizeWASD()

-- Intercept keys
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.IsMouse then return end
    
    if controlMappings[input.KeyCode] then
        return false
    end
end)

print("🎮 WASD randomized!")
print("🎮 Good luck moving!")
