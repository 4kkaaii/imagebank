local UILibrary = loadstring(game:HttpGet("https://pastebin.com/raw/aB72ENPP"))()

local Window = UILibrary:CreateWindow({
    Title      = "[DUELS] Murderers VS Sheriffs",
    Subtitle   = "by Wounds",
    Size       = UDim2.new(0, 550, 0, 450),
    ToggleKey  = Enum.KeyCode.P,
    Theme      = "Purple",
    Image      = "rbxassetid://92882092628695",
})

-- Main Tabs
local GunTab = Window:CreateTab("Gun", "target")
local ESPTab = Window:CreateTab("ESP", "eye")
local SettingsTab = Window:CreateTab("UI Settings", "paint")

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Workspace = game:GetService("Workspace")
local mouse = LocalPlayer:GetMouse()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- Global Settings
local Settings = {
    -- Aim Settings
    SilentAimEnabled = false,
    FOVRadius = 200,
    FOVVisible = true,
    AutoShootEnabled = false,
    AutoShootFOVOnly = true,
    FireDelay = 0.12,
    Humanization = true,
    Smoothness = 0.3,
    
    -- Anti-Cheat
    AntiCheatBypass = true,
    Randomization = true,
    JitterAmount = 2,
    
    -- ESP Settings
    ESPEnabled = false,
    ESPBoxes = true,
    ESPHealth = true,
    ESPDistance = true,
    ESPTracers = true,
    ESPTeamColor = true,
    
    -- Colors
    ESPBoxColor = Color3.fromRGB(255, 255, 255),
    ESPTracerColor = Color3.fromRGB(255, 100, 100),
}

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Radius = Settings.FOVRadius
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Transparency = 0.7
FOVCircle.Visible = false
FOVCircle.Filled = false

-- ESP Storage
local ESPObjects = {}
local function clearESP()
    for _, obj in pairs(ESPObjects) do
        if obj then
            obj:Remove()
        end
    end
    ESPObjects = {}
end

-- Helper Functions
local function isInMatch()
    return LocalPlayer:GetAttribute("Map") ~= nil
end

local function getTeam(player)
    return player:GetAttribute("Team")
end

local function getGame(player)
    return player:GetAttribute("Game")
end

local function isEnemy(player)
    return player ~= LocalPlayer 
        and getTeam(player) ~= getTeam(LocalPlayer)
        and getGame(player) == getGame(LocalPlayer)
end

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
    if not humanoid or not isInMatch() then return nil end
    
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
    params.FilterDescendantsInstances = {myCharacter, targetCharacter}
    
    local result = Workspace:Raycast(myRoot.Position, targetRoot.Position - myRoot.Position, params)
    return result == nil
end

local function getClosestPlayerToCursor(useFOV)
    if not isInMatch() then return nil end
    
    local myCharacter = LocalPlayer.Character
    local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    
    local mousePos = Vector2.new(mouse.X, mouse.Y)
    local closestPlayer = nil
    local shortestDistance = useFOV and Settings.FOVRadius or math.huge
    
    for _, player in ipairs(Players:GetPlayers()) do
        if isEnemy(player) then
            local character = player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local root = character and character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and humanoid.Health > 0 and root and canSeeTarget(character) then
                local worldDistance = (root.Position - myRoot.Position).Magnitude
                if worldDistance <= 150 then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                    if onScreen then
                        local screenDistance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if (not useFOV or screenDistance <= Settings.FOVRadius) and screenDistance < shortestDistance then
                            shortestDistance = screenDistance
                            closestPlayer = player
                        end
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

-- Humanization Functions
local function getHumanizedPosition(targetRoot)
    if not Settings.Humanization then
        return targetRoot.Position
    end
    
    local randomOffset = Vector3.new(
        math.random(-100, 100) / 100 * 0.5,
        math.random(-100, 100) / 100 * 0.5,
        math.random(-100, 100) / 100 * 0.5
    )
    
    return targetRoot.Position + randomOffset
end

local function getRandomizedDelay()
    if not Settings.Randomization then
        return Settings.FireDelay
    end
    
    local randomFactor = math.random(70, 130) / 100
    return Settings.FireDelay * randomFactor
end

-- ESP Functions
local function createESP(player)
    if ESPObjects[player.UserId] then
        return
    end
    
    local espObjects = {}
    
    -- Box ESP
    if Settings.ESPBoxes then
        local box = Drawing.new("Square")
        box.Thickness = 2
        box.Color = Settings.ESPBoxColor
        box.Transparency = 0.8
        box.Filled = false
        box.Visible = false
        espObjects.Box = box
    end
    
    -- Health Bar
    if Settings.ESPHealth then
        local healthBar = Drawing.new("Line")
        healthBar.Thickness = 3
        healthBar.Color = Color3.fromRGB(0, 255, 0)
        healthBar.Visible = false
        espObjects.HealthBar = healthBar
    end
    
    -- Distance Text
    if Settings.ESPDistance then
        local distanceText = Drawing.new("Text")
        distanceText.Size = 14
        distanceText.Color = Color3.fromRGB(255, 255, 255)
        distanceText.Center = true
        distanceText.Outline = true
        distanceText.Visible = false
        espObjects.DistanceText = distanceText
    end
    
    -- Tracer
    if Settings.ESPTracers then
        local tracer = Drawing.new("Line")
        tracer.Thickness = 1
        tracer.Color = Settings.ESPTracerColor
        tracer.Transparency = 0.7
        tracer.Visible = false
        espObjects.Tracer = tracer
    end
    
    ESPObjects[player.UserId] = espObjects
end

local function updateESP()
    if not Settings.ESPEnabled then
        for _, espObj in pairs(ESPObjects) do
            for _, drawing in pairs(espObj) do
                drawing.Visible = false
            end
        end
        return
    end
    
    local myCharacter = LocalPlayer.Character
    local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
    
    for _, player in ipairs(Players:GetPlayers()) do
        if isEnemy(player) then
            local character = player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local root = character and character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and humanoid.Health > 0 and root then
                createESP(player)
                local espObj = ESPObjects[player.UserId]
                
                local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                
                if onScreen and myRoot then
                    local distance = (root.Position - myRoot.Position).Magnitude
                    
                    -- Update Box
                    if espObj.Box then
                        local scale = 2000 / (Camera.CFrame.Position - root.Position).Magnitude
                        local boxSize = Vector2.new(50 * scale, 70 * scale)
                        espObj.Box.Size = boxSize
                        espObj.Box.Position = Vector2.new(screenPos.X - boxSize.X/2, screenPos.Y - boxSize.Y/2)
                        espObj.Box.Visible = true
                        
                        if Settings.ESPTeamColor and player:GetAttribute("Team") then
                            espObj.Box.Color = player:GetAttribute("Team") == "Sheriff" 
                                and Color3.fromRGB(100, 150, 255) 
                                or Color3.fromRGB(255, 100, 100)
                        end
                    end
                    
                    -- Update Health Bar
                    if espObj.HealthBar then
                        local healthPercent = humanoid.Health / humanoid.MaxHealth
                        local barWidth = 50
                        local barHeight = 4
                        local barX = screenPos.X - barWidth/2
                        local barY = screenPos.Y - 40
                        
                        espObj.HealthBar.From = Vector2.new(barX, barY)
                        espObj.HealthBar.To = Vector2.new(barX + barWidth * healthPercent, barY)
                        espObj.HealthBar.Color = healthPercent > 0.5 
                            and Color3.fromRGB(0, 255, 0) 
                            or (healthPercent > 0.25 
                                and Color3.fromRGB(255, 255, 0) 
                                or Color3.fromRGB(255, 0, 0))
                        espObj.HealthBar.Visible = true
                    end
                    
                    -- Update Distance Text
                    if espObj.DistanceText then
                        espObj.DistanceText.Text = string.format("%.0fm", distance)
                        espObj.DistanceText.Position = Vector2.new(screenPos.X, screenPos.Y + 40)
                        espObj.DistanceText.Visible = true
                    end
                    
                    -- Update Tracer
                    if espObj.Tracer and myRoot then
                        local myScreenPos = Camera:WorldToViewportPoint(myRoot.Position)
                        espObj.Tracer.From = Vector2.new(myScreenPos.X, myScreenPos.Y)
                        espObj.Tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                        espObj.Tracer.Visible = true
                    end
                else
                    for _, drawing in pairs(espObj) do
                        drawing.Visible = false
                    end
                end
            end
        end
    end
end

-- Anti-Cheat Bypass
local function fireWithAntiCheat(tool, target, direction)
    if not Settings.AntiCheatBypass then
        tool:Activate()
        return
    end
    
    -- Add slight delay randomization
    task.wait(math.random(1, 5) / 100)
    
    -- Add slight aim jitter
    if Settings.JitterAmount > 0 then
        local jitter = Settings.JitterAmount / 100
        direction = direction + Vector3.new(
            math.random(-jitter, jitter),
            math.random(-jitter, jitter),
            math.random(-jitter, jitter)
        )
    end
    
    -- Fire the weapon
    tool:Activate()
end

-- ──────────────────────────────────────────────
-- GUN TAB
-- ──────────────────────────────────────────────
GunTab:CreateDivider("🔫 Gun Features")

-- Auto Kill
do
local running = false
local MAX_DISTANCE = 150

local function autoKillLoop()
    while running do
        task.wait(0.1)
        if not isInMatch() then continue end
        
        local character = LocalPlayer.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not rootPart then continue end
        
        local equippedTool = character:FindFirstChildOfClass("Tool")
        if not equippedTool or not equippedTool:FindFirstChild("showBeam") then
            equipGun()
        end
        
        local myTeam = getTeam(LocalPlayer)
        local closestPlayer = nil
        local shortestDistance = MAX_DISTANCE
        
        for _, player in ipairs(Players:GetPlayers()) do
            if isEnemy(player) then
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
        
        local tool = character:FindFirstChildOfClass("Tool")
        if closestPlayer and tool then
            local killEvent = tool:FindFirstChild("kill")
            if killEvent and killEvent:IsA("RemoteEvent") then
                killEvent:FireServer(closestPlayer, Vector3.new(0.149008110165596, 0.019326409325003624, 0.9886471033096313))
            end
        end
    end
end

GunTab:CreateToggle({
    Text = "Auto Kill All Players",
    Default = false,
    Callback = function(state)
        running = state
        if running then
            task.spawn(autoKillLoop)
        end
    end
})
end

-- Auto Shoot
do
local enabled = false
local lastFire = 0

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

GunTab:CreateToggle({
    Text = "Auto Shoot FOV Only",
    Default = true,
    Callback = function(state)
        Settings.AutoShootFOVOnly = state
    end
})

GunTab:CreateSlider({
    Text = "Fire Delay",
    Min = 0.05,
    Max = 0.5,
    Default = 0.12,
    Callback = function(value)
        Settings.FireDelay = value
    end
})

task.spawn(function()
    while true do
        task.wait(0.01)
        if not enabled or not isInMatch() then continue end
        
        local currentTime = tick()
        if currentTime - lastFire < getRandomizedDelay() then continue end
        
        local target = getClosestPlayerToCursor(Settings.AutoShootFOVOnly)
        if target then
            local tool = equipGun()
            if tool and tool.Parent == LocalPlayer.Character then
                fireWithAntiCheat(tool, target, Vector3.new(0, 0, 0))
                lastFire = currentTime
            end
        end
    end
end)
end

-- Silent Aim
do
local enabled = false

GunTab:CreateDivider("🎯 Silent Aim")

GunTab:CreateToggle({
    Text = "Silent Aim",
    Default = false,
    Callback = function(state)
        enabled = state
    end
})

GunTab:CreateToggle({
    Text = "Show FOV Circle",
    Default = true,
    Callback = function(state)
        Settings.FOVVisible = state
    end
})

GunTab:CreateSlider({
    Text = "Silent Aim FOV",
    Min = 10,
    Max = 500,
    Default = 200,
    Callback = function(value)
        Settings.FOVRadius = value
        FOVCircle.Radius = value
    end
})

GunTab:CreateDivider("🎯 Humanization")

GunTab:CreateToggle({
    Text = "Humanization",
    Default = true,
    Callback = function(state)
        Settings.Humanization = state
    end
})

GunTab:CreateSlider({
    Text = "Smoothness",
    Min = 0.1,
    Max = 1,
    Default = 0.3,
    Callback = function(value)
        Settings.Smoothness = value
    end
})

GunTab:CreateDivider("🛡️ Anti-Cheat")

GunTab:CreateToggle({
    Text = "Anti-Cheat Bypass",
    Default = true,
    Callback = function(state)
        Settings.AntiCheatBypass = state
    end
})

GunTab:CreateToggle({
    Text = "Randomization",
    Default = true,
    Callback = function(state)
        Settings.Randomization = state
    end
})

GunTab:CreateSlider({
    Text = "Jitter Amount",
    Min = 0,
    Max = 10,
    Default = 2,
    Callback = function(value)
        Settings.JitterAmount = value
    end
})

local oldIndex
oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
    if enabled and not checkcaller() and self == mouse and key == "Hit" then
        local target = getClosestPlayerToCursor(true)
        if target then
            local root = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local targetPos = getHumanizedPosition(root)
                return CFrame.new(targetPos)
            end
        end
    end
    return oldIndex(self, key)
end))
end

-- ──────────────────────────────────────────────
-- ESP TAB
-- ──────────────────────────────────────────────
ESPTab:CreateDivider("👁️ ESP Features")

ESPTab:CreateToggle({
    Text = "Enable ESP",
    Default = false,
    Callback = function(state)
        Settings.ESPEnabled = state
        if not state then
            clearESP()
        end
    end
})

ESPTab:CreateToggle({
    Text = "Box ESP",
    Default = true,
    Callback = function(state)
        Settings.ESPBoxes = state
        clearESP()
    end
})

ESPTab:CreateToggle({
    Text = "Health Bars",
    Default = true,
    Callback = function(state)
        Settings.ESPHealth = state
        clearESP()
    end
})

ESPTab:CreateToggle({
    Text = "Distance",
    Default = true,
    Callback = function(state)
        Settings.ESPDistance = state
        clearESP()
    end
})

ESPTab:CreateToggle({
    Text = "Tracers",
    Default = true,
    Callback = function(state)
        Settings.ESPTracers = state
        clearESP()
    end
})

ESPTab:CreateToggle({
    Text = "Team Colors",
    Default = true,
    Callback = function(state)
        Settings.ESPTeamColor = state
    end
})

-- ──────────────────────────────────────────────
-- UI SETTINGS TAB
-- ──────────────────────────────────────────────
SettingsTab:CreateDivider("🎨 Theme")

SettingsTab:CreateDropdown({
    Text     = "UI Theme",
    Options  = { "Default", "Red", "Green", "Purple", "Cyan", "Blue", "Pink", "Yellow", "Teal", "Magenta", "Orange", "Rose", "Gold" },
    Default  = "Purple",
    Callback = function(theme) Window:SetTheme(theme) end,
})

SettingsTab:CreateDivider("⌨️ Keybinds")

SettingsTab:CreateKeybind({
    Text     = "Toggle UI",
    Default  = Enum.KeyCode.P,
    Callback = function(key) Window:SetToggleKey(key) end,
})

SettingsTab:CreateKeybind({
    Text     = "Panic Key (Disable All)",
    Default  = Enum.KeyCode.RightShift,
    Callback = function(key)
        -- Disable all features
        enabled = false
        Settings.SilentAimEnabled = false
        Settings.ESPEnabled = false
        FOVCircle.Visible = false
        clearESP()
    end,
})

-- ──────────────────────────────────────────────
-- MAIN LOOPS
-- ──────────────────────────────────────────────

-- Update FOV Circle
RunService.RenderStepped:Connect(function()
    if Settings.FOVVisible and Settings.SilentAimEnabled then
        FOVCircle.Position = Vector2.new(mouse.X, mouse.Y + 36)
        FOVCircle.Visible = true
    else
        FOVCircle.Visible = false
    end
end)

-- Update ESP
RunService.RenderStepped:Connect(function()
    if Settings.ESPEnabled then
        updateESP()
    end
end)

-- Clean up on character added
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if Settings.AutoShootEnabled then
        equipGun()
    end
end)

-- Initial notification
task.spawn(function()
    task.wait(2)
    print("[DUELS] Script loaded successfully!")
    print("[DUELS] Press P to toggle UI")
    print("[DUELS] Press RightShift for panic mode")
end)
