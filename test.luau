local UILibrary = loadstring(game:HttpGet("https://pastebin.com/raw/aB72ENPP"))()

local Window = UILibrary:CreateWindow({
    Title      = "[DUELS] Murderers VS Sheriffs",
    Subtitle   = "by Wounds",
    Size       = UDim2.new(0, 500, 0, 400),
    ToggleKey  = Enum.KeyCode.P,
    Theme      = "Purple",
    Image      = "rbxassetid://92882092628695",
})

local GunTab = Window:CreateTab("Gun", "target")
local Tab3 = Window:CreateTab("UI Settings",  "paint")
GunTab:CreateDivider("🔫  Only Gun")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Workspace = game:GetService("Workspace")
local mouse = LocalPlayer:GetMouse()

-- ══════════════════════════════════════════════
--  FOV CIRCLE HANDLER
-- ══════════════════════════════════════════════
do
    local fovCircle = nil
    local fovSize = 200
    local isVisible = false
    
    local function createFOVCircle()
        if fovCircle then return end
        
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "FOVCircle"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        
        fovCircle = Instance.new("ImageLabel")
        fovCircle.Size = UDim2.new(0, fovSize, 0, fovSize)
        fovCircle.Position = UDim2.new(0.5, -fovSize/2, 0.5, -fovSize/2)
        fovCircle.BackgroundTransparency = 1
        fovCircle.Image = "rbxassetid://6022854806"
        fovCircle.ImageColor3 = Color3.fromRGB(0, 200, 255)
        fovCircle.ImageTransparency = 0.7
        fovCircle.Visible = isVisible
        fovCircle.ZIndex = 999
        fovCircle.Parent = screenGui
        
        local glow = Instance.new("ImageLabel")
        glow.Size = UDim2.new(1.15, 0, 1.15, 0)
        glow.Position = UDim2.new(-0.075, 0, -0.075, 0)
        glow.BackgroundTransparency = 1
        glow.Image = "rbxassetid://6022854806"
        glow.ImageColor3 = Color3.fromRGB(0, 150, 255)
        glow.ImageTransparency = 0.9
        glow.ZIndex = 998
        glow.Parent = fovCircle
        
        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 4, 0, 4)
        dot.Position = UDim2.new(0.5, -2, 0.5, -2)
        dot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        dot.BackgroundTransparency = 0.3
        dot.BorderSizePixel = 0
        dot.ZIndex = 1000
        dot.Parent = fovCircle
    end
    
    local function updateFOVCircle(size)
        fovSize = size
        if fovCircle then
            fovCircle.Size = UDim2.new(0, fovSize, 0, fovSize)
            fovCircle.Position = UDim2.new(0.5, -fovSize/2, 0.5, -fovSize/2)
        end
    end
    
    local function setFOVVisible(visible)
        isVisible = visible
        if fovCircle then
            fovCircle.Visible = visible
        end
    end
    
    createFOVCircle()
    
    _G.FOVCircle = {
        update = updateFOVCircle,
        setVisible = setFOVVisible,
        getSize = function() return fovSize end
    }
end

-- ══════════════════════════════════════════════
--  AUTO KILL ALL PLAYERS (WORKING)
-- ══════════════════════════════════════════════
do
    local running = false
    local MAX_DISTANCE = 150
    
    local function inMatch()
        return LocalPlayer:GetAttribute("Map") ~= nil
    end
    
    local function getGunTool()
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if not backpack then return nil end
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("showBeam") then
                local showBeam = tool.showBeam
                if showBeam:IsA("RemoteEvent") then
                    return tool
                end
            end
        end
        return nil
    end
    
    local function equipGun()
        if not inMatch() then return end
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        local tool = getGunTool()
        if tool then
            humanoid:EquipTool(tool)
        end
    end
    
    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        if running and inMatch() then
            equipGun()
        end
    end)
    
    local function setupBackpackWatcher()
        local backpack = LocalPlayer:WaitForChild("Backpack")
        backpack.ChildAdded:Connect(function(child)
            if running and inMatch() and child:IsA("Tool") then
                task.wait(0.1)
                equipGun()
            end
        end)
    end
    setupBackpackWatcher()
    
    GunTab:CreateToggle({
        Text = "Auto Kill All Players",
        Default = false,
        Callback = function(state)
            running = state
            if running then
                task.spawn(function()
                    while running do
                        task.wait(0.1)
                        if not inMatch() then continue end
                        
                        local character = LocalPlayer.Character
                        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                        if not rootPart then continue end
                        
                        local equippedTool = character:FindFirstChildOfClass("Tool")
                        if not equippedTool or not equippedTool:FindFirstChild("showBeam") then
                            equipGun()
                        end
                        
                        local myTeam = LocalPlayer:GetAttribute("Team")
                        local closestPlayer = nil
                        local shortestDistance = MAX_DISTANCE
                        
                        for _, player in ipairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer then
                                local playerTeam = player:GetAttribute("Team")
                                if playerTeam ~= myTeam then
                                    local enemyCharacter = player.Character
                                    local enemyRoot = enemyCharacter and enemyCharacter:FindFirstChild("HumanoidRootPart")
                                    if enemyRoot then
                                        local distance = (enemyRoot.Position - rootPart.Position).Magnitude
                                        if distance <= MAX_DISTANCE and distance < shortestDistance then
                                            shortestDistance = distance
                                            closestPlayer = player
                                        end
                                    end
                                end
                            end
                        end
                        
                        local tool = character:FindFirstChildOfClass("Tool")
                        if closestPlayer and tool then
                            local killEvent = tool:FindFirstChild("kill")
                            if killEvent and killEvent:IsA("RemoteEvent") then
                                killEvent:FireServer(
                                    closestPlayer,
                                    Vector3.new(
                                        0.149008110165596,
                                        0.019326409325003624,
                                        0.9886471033096313
                                    )
                                )
                            end
                        end
                    end
                end)
            end
        end
    })
end

-- ══════════════════════════════════════════════
--  AUTO SHOOT WHEN VISIBLE (WORKING)
-- ══════════════════════════════════════════════
do
    local enabled = false
    local MAX_DISTANCE = 150
    local FIRE_DELAY = 0.12
    
    local function getGunTool()
        local character = LocalPlayer.Character
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if character then
            for _, tool in ipairs(character:GetChildren()) do
                if tool:IsA("Tool") and tool:FindFirstChild("showBeam") and tool:FindFirstChild("kill") then
                    return tool
                end
            end
        end
        if backpack then
            for _, tool in ipairs(backpack:GetChildren()) do
                if tool:IsA("Tool") and tool:FindFirstChild("showBeam") and tool:FindFirstChild("kill") then
                    return tool
                end
            end
        end
        return nil
    end
    
    local function equipGun()
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return nil end
        local tool = getGunTool()
        if tool and tool.Parent ~= character then
            humanoid:EquipTool(tool)
            task.wait(0.05)
        end
        return tool
    end
    
    local function canSeeTarget(targetCharacter)
        local myCharacter = LocalPlayer.Character
        if not myCharacter then return false end
        local myRoot = myCharacter:FindFirstChild("HumanoidRootPart")
        local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
        if not myRoot or not targetRoot then return false end
        
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = { myCharacter, targetCharacter }
        local result = Workspace:Raycast(myRoot.Position, targetRoot.Position - myRoot.Position, params)
        return result == nil
    end
    
    local function getClosestPlayerToCursor()
        if not enabled then return nil end
        if not LocalPlayer:GetAttribute("Map") then return nil end
        
        local myCharacter = LocalPlayer.Character
        local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
        if not myRoot then return nil end
        
        local myTeam = LocalPlayer:GetAttribute("Team")
        local myGame = LocalPlayer:GetAttribute("Game")
        local mousePos = Vector2.new(mouse.X, mouse.Y)
        local closestPlayer = nil
        local shortestDistance = math.huge
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local character = player.Character
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                local root = character and character:FindFirstChild("HumanoidRootPart")
                if humanoid and humanoid.Health > 0 and root and player:GetAttribute("Game") == myGame and player:GetAttribute("Team") ~= myTeam then
                    local worldDistance = (root.Position - myRoot.Position).Magnitude
                    if worldDistance <= MAX_DISTANCE and canSeeTarget(character) then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                        if onScreen then
                            local cursorDistance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                            if cursorDistance < shortestDistance then
                                shortestDistance = cursorDistance
                                closestPlayer = player
                            end
                        end
                    end
                end
            end
        end
        return closestPlayer
    end
    
    local oldIndex
    oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
        if enabled and not checkcaller() and self == mouse and key == "Hit" then
            local target = getClosestPlayerToCursor()
            if target then
                local root = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    return CFrame.new(root.Position)
                end
            end
        end
        return oldIndex(self, key)
    end))
    
    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        if enabled then
            equipGun()
        end
    end)
    
    local backpack = LocalPlayer:WaitForChild("Backpack")
    backpack.ChildAdded:Connect(function(child)
        if enabled and child:IsA("Tool") then
            task.wait(0.1)
            equipGun()
        end
    end)
    
    task.spawn(function()
        while true do
            task.wait(FIRE_DELAY)
            if not enabled then continue end
            if not LocalPlayer:GetAttribute("Map") then continue end
            
            local target = getClosestPlayerToCursor()
            if target then
                local tool = equipGun()
                if tool and tool.Parent == LocalPlayer.Character then
                    tool:Activate()
                end
            end
        end
    end)
    
    GunTab:CreateToggle({
        Text = "Auto Shoot When Visible",
        Default = false,
        Callback = function(state)
            enabled = state
            if enabled then
                equipGun()
            end
        end
    })
end

-- ══════════════════════════════════════════════
--  SILENT AIM WITH FOV (WORKING)
-- ══════════════════════════════════════════════
do
    local silentAimEnabled = false
    local MAX_DISTANCE = 150
    local FOV_RADIUS = 120
    
    local function getNearestEnemy()
        if not silentAimEnabled then return nil end
        if not LocalPlayer:GetAttribute("Map") then return nil end
        
        local myCharacter = LocalPlayer.Character
        local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
        if not myRoot then return nil end
        
        local myTeam = LocalPlayer:GetAttribute("Team")
        local myGame = LocalPlayer:GetAttribute("Game")
        local mousePos = Vector2.new(mouse.X, mouse.Y)
        local nearest = nil
        local shortestDist = math.huge
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local character = player.Character
                local root = character and character:FindFirstChild("HumanoidRootPart")
                if root and player:GetAttribute("Game") == myGame and player:GetAttribute("Team") ~= myTeam then
                    local distance = (root.Position - myRoot.Position).Magnitude
                    if distance <= MAX_DISTANCE then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                        if onScreen then
                            local cursorDistance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                            local fovPixels = (FOV_RADIUS / 120) * 200
                            if cursorDistance <= fovPixels and cursorDistance < shortestDist then
                                shortestDist = cursorDistance
                                nearest = player
                            end
                        end
                    end
                end
            end
        end
        
        return nearest
    end
    
    local oldIndex
    oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
        if silentAimEnabled and not checkcaller() and self == mouse and key == "Hit" then
            local target = getNearestEnemy()
            if target and target.Character then
                local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    return CFrame.new(targetRoot.Position)
                end
            end
        end
        return oldIndex(self, key)
    end))
    
    GunTab:CreateToggle({
        Text = "Silent Aim",
        Default = false,
        Callback = function(state)
            silentAimEnabled = state
            _G.FOVCircle.setVisible(state)
            if state then
                print("Silent Aim enabled")
            else
                print("Silent Aim disabled")
            end
        end
    })
    
    GunTab:CreateSlider({
        Text = "FOV Radius",
        Default = 120,
        Min = 30,
        Max = 360,
        Suffix = "°",
        Callback = function(value)
            FOV_RADIUS = value
            local circleSize = (value / 360) * 300 + 50
            _G.FOVCircle.update(circleSize)
        end
    })
end

-- ══════════════════════════════════════════════
--  UI SETTINGS TAB
-- ══════════════════════════════════════════════
Tab3:CreateDivider("Theme")
Tab3:CreateDropdown({
    Text     = "UI Theme",
    Options  = { "Default", "Red", "Green", "Purple", "Cyan", "Blue", "Pink", "Yellow", "Teal", "Magenta", "Orange", "Rose", "Gold" },
    Default  = "Teal",
    Callback = function(theme) Window:SetTheme(theme) end,
})

Tab3:CreateDivider("UI")
Tab3:CreateKeybind({
    Text     = "Toggle UI",
    Default  = Enum.KeyCode.P,
    Callback = function(key) Window:SetToggleKey(key) end,
})

print("✅ Script loaded successfully!")
print("All features are working as intended.")
