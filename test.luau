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
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- FOV Circle Setup
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Radius = 200
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Transparency = 0.7
FOVCircle.Visible = false
FOVCircle.Filled = false

-- Update FOV circle position
local function updateFOVCircle()
    if FOVCircle.Visible then
        FOVCircle.Position = Vector2.new(mouse.X, mouse.Y + 36) -- Adjust for GUI inset
    end
end

-- Update FOV circle on mouse move
game:GetService("RunService").RenderStepped:Connect(function()
    updateFOVCircle()
end)

-- Auto Shoot Settings
local AutoShootSettings = {
    Enabled = false,
    FOVOnly = true,
    FireDelay = 0.12,
    MaxDistance = 150,
    RequireVisible = true,
    UsePrediction = false,
    PredictionAmount = 0.5,
}

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
    if not inMatch() then
        return
    end
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        return
    end
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
local AKgun = GunTab:CreateToggle({
    Text = "Auto Kill All Players",
    Default = false,
    Callback = function(state)
        running = state
        if running then
            task.spawn(function()
                while running do
                    task.wait(0.1)
                    if not inMatch() then
                        continue
                    end
                    local character = LocalPlayer.Character
                    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                    if not rootPart then
                        continue
                    end
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

do
local enabled = false
local MAX_DISTANCE = 150
local FIRE_DELAY = 0.12
local function getGunTool()
    local character = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if character then
        for _, tool in ipairs(character:GetChildren()) do
            if tool:IsA("Tool")
                and tool:FindFirstChild("showBeam")
                and tool:FindFirstChild("kill") then
                return tool
            end
        end
    end
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool")
                and tool:FindFirstChild("showBeam")
                and tool:FindFirstChild("kill") then
                return tool
            end
        end
    end
    return nil
end
local function equipGun()
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        return nil
    end
    local tool = getGunTool()
    if tool and tool.Parent ~= character then
        humanoid:EquipTool(tool)
        task.wait(0.05)
    end
    return tool
end
local function canSeeTarget(targetCharacter)
    local myCharacter = LocalPlayer.Character
    if not myCharacter then
        return false
    end
    local myRoot = myCharacter:FindFirstChild("HumanoidRootPart")
    local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
    if not myRoot or not targetRoot then
        return false
    end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {
        myCharacter,
        targetCharacter
    }
    local result = Workspace:Raycast(
        myRoot.Position,
        targetRoot.Position - myRoot.Position,
        params
    )
    return result == nil
end
local function getClosestPlayerToCursor()
    if not AutoShootSettings.Enabled then
        return nil
    end
    if not LocalPlayer:GetAttribute("Map") then
        return nil
    end
    local myCharacter = LocalPlayer.Character
    local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
    if not myRoot then
        return nil
    end
    local myTeam = LocalPlayer:GetAttribute("Team")
    local myGame = LocalPlayer:GetAttribute("Game")
    local mousePos = Vector2.new(mouse.X, mouse.Y)
    local closestPlayer = nil
    local shortestDistance = AutoShootSettings.FOVOnly and 200 or math.huge
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if humanoid
                and humanoid.Health > 0
                and root
                and player:GetAttribute("Game") == myGame
                and player:GetAttribute("Team") ~= myTeam then
                local worldDistance = (root.Position - myRoot.Position).Magnitude
                if worldDistance <= AutoShootSettings.MaxDistance
                    and (not AutoShootSettings.RequireVisible or canSeeTarget(character)) then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                    if onScreen then
                        local cursorDistance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if (not AutoShootSettings.FOVOnly or cursorDistance <= 200) 
                            and cursorDistance < shortestDistance then
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
    if AutoShootSettings.Enabled
        and not checkcaller()
        and self == mouse
        and key == "Hit" then
        local target = getClosestPlayerToCursor()
        if target then
            local root = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local targetPos = root.Position
                
                -- Add prediction if enabled
                if AutoShootSettings.UsePrediction and target.Character:FindFirstChildOfClass("Humanoid") then
                    local velocity = target.Character:FindFirstChildOfClass("Humanoid").MoveDirection
                    targetPos = targetPos + velocity * AutoShootSettings.PredictionAmount
                end
                
                return CFrame.new(targetPos)
            end
        end
    end
    return oldIndex(self, key)
end))
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if AutoShootSettings.Enabled then
        equipGun()
    end
end)
local backpack = LocalPlayer:WaitForChild("Backpack")
backpack.ChildAdded:Connect(function(child)
    if AutoShootSettings.Enabled and child:IsA("Tool") then
        task.wait(0.1)
        equipGun()
    end
end)
task.spawn(function()
    while true do
        task.wait(AutoShootSettings.FireDelay)
        if not AutoShootSettings.Enabled then
            continue
        end
        if not LocalPlayer:GetAttribute("Map") then
            continue
        end
        local target = getClosestPlayerToCursor()
        if target then
            local tool = equipGun()
            if tool and tool.Parent == LocalPlayer.Character then
                tool:Activate()
            end
        end
    end
end)

-- Auto Shoot UI
GunTab:CreateDivider("🎯 Auto Shoot Settings")

local AKWVgun = GunTab:CreateToggle({
    Text = "Auto Shoot When Visible",
    Default = false,
    Callback = function(state)
        AutoShootSettings.Enabled = state
        if state then
            equipGun()
        end
    end
})

GunTab:CreateToggle({
    Text = "FOV Only Mode",
    Default = true,
    Callback = function(state)
        AutoShootSettings.FOVOnly = state
    end
})

GunTab:CreateToggle({
    Text = "Require Line of Sight",
    Default = true,
    Callback = function(state)
        AutoShootSettings.RequireVisible = state
    end
})

GunTab:CreateToggle({
    Text = "Use Prediction",
    Default = false,
    Callback = function(state)
        AutoShootSettings.UsePrediction = state
    end
})

GunTab:CreateSlider({
    Text = "Fire Delay",
    Min = 0.05,
    Max = 0.5,
    Default = 0.12,
    Callback = function(value)
        AutoShootSettings.FireDelay = value
    end
})

GunTab:CreateSlider({
    Text = "Max Distance",
    Min = 50,
    Max = 500,
    Default = 150,
    Callback = function(value)
        AutoShootSettings.MaxDistance = value
    end
})

GunTab:CreateSlider({
    Text = "Prediction Amount",
    Min = 0,
    Max = 2,
    Default = 0.5,
    Callback = function(value)
        AutoShootSettings.PredictionAmount = value
    end
})
end

do
local MAX_DISTANCE = 150
local enabled = false
local FOV_RADIUS = 200
local FOVVisible = false

local function getClosestPlayerToCursor()
    if not enabled then
        return nil
    end
    if not LocalPlayer:GetAttribute("Map") then
        return nil
    end
    local myCharacter = LocalPlayer.Character
    local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
    if not myRoot then
        return nil
    end
    local mousePos = Vector2.new(mouse.X, mouse.Y)
    local myTeam = LocalPlayer:GetAttribute("Team")
    local myGame = LocalPlayer:GetAttribute("Game")
    local closestPlayer = nil
    local shortestDistance = FOV_RADIUS
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if root
            and player:GetAttribute("Game") == myGame
            and player:GetAttribute("Team") ~= myTeam then
                local worldDistance = (root.Position - myRoot.Position).Magnitude
                if worldDistance <= MAX_DISTANCE then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                    if onScreen then
                        local screenDistance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if screenDistance <= FOV_RADIUS and screenDistance < shortestDistance then
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

local oldIndex
oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
    if enabled
    and not checkcaller()
    and self == mouse
    and key == "Hit" then
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

GunTab:CreateDivider("🎯 Silent Aim Settings")

local SAgun = GunTab:CreateToggle({
    Text = "Silent Aim",
    Default = false,
    Callback = function(state)
        enabled = state
    end
})

GunTab:CreateToggle({
    Text = "Show FOV Circle",
    Default = false,
    Callback = function(state)
        FOVVisible = state
        FOVCircle.Visible = state and enabled
    end
})

GunTab:CreateSlider({
    Text = "Silent Aim FOV",
    Min = 10,
    Max = 500,
    Default = 200,
    Callback = function(value)
        FOV_RADIUS = value
        FOVCircle.Radius = value
    end
})

-- FOV Circle Customization
GunTab:CreateDivider("🎨 FOV Circle Customization")

GunTab:CreateColorPicker({
    Text = "FOV Circle Color",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(color)
        FOVCircle.Color = color
    end
})

GunTab:CreateSlider({
    Text = "FOV Circle Thickness",
    Min = 1,
    Max = 10,
    Default = 2,
    Callback = function(value)
        FOVCircle.Thickness = value
    end
})

GunTab:CreateSlider({
    Text = "FOV Circle Transparency",
    Min = 0,
    Max = 1,
    Default = 0.7,
    Callback = function(value)
        FOVCircle.Transparency = value
    end
})

GunTab:CreateToggle({
    Text = "Filled Circle",
    Default = false,
    Callback = function(state)
        FOVCircle.Filled = state
    end
})

-- Update FOV circle position and visibility
RunService.RenderStepped:Connect(function()
    if FOVVisible and enabled then
        FOVCircle.Position = Vector2.new(mouse.X, mouse.Y + 36)
        FOVCircle.Visible = true
    else
        FOVCircle.Visible = false
    end
end)
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
