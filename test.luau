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
--  SILENT AIM (TROLL VERSION)
--  Looks real but makes bullets miss!
-- ══════════════════════════════════════════════
do
    local silentAimEnabled = false
    local MAX_DISTANCE = 150
    
    local function getNearestEnemy()
        if not silentAimEnabled then return nil end
        if not LocalPlayer:GetAttribute("Map") then return nil end
        
        local myCharacter = LocalPlayer.Character
        local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
        if not myRoot then return nil end
        
        local myTeam = LocalPlayer:GetAttribute("Team")
        local myGame = LocalPlayer:GetAttribute("Game")
        local nearest = nil
        local shortestDist = math.huge
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local character = player.Character
                local root = character and character:FindFirstChild("HumanoidRootPart")
                if root and player:GetAttribute("Game") == myGame and player:GetAttribute("Team") ~= myTeam then
                    local distance = (root.Position - myRoot.Position).Magnitude
                    if distance <= MAX_DISTANCE and distance < shortestDist then
                        shortestDist = distance
                        nearest = player
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
                    local myCharacter = LocalPlayer.Character
                    local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
                    if myRoot then
                        local awayDir = (myRoot.Position - targetRoot.Position).Unit
                        local missOffset = Vector3.new(
                            math.random(-30, 30),
                            math.random(-20, 20),
                            math.random(-30, 30)
                        )
                        local aimPos = targetRoot.Position + awayDir * 50 + missOffset
                        return CFrame.new(aimPos)
                    end
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
            if state then
                print("Silent Aim enabled")
            else
                print("Silent Aim disabled")
            end
        end
    })
end

-- ══════════════════════════════════════════════
--  AUTO SHOOT (TROLL VERSION)
--  Looks like it's shooting but does nothing!
-- ══════════════════════════════════════════════
do
    local autoShootEnabled = false
    local FIRE_DELAY = 0.12
    local MAX_DISTANCE = 150
    local killCounter = 0
    
    local function getNearestEnemy()
        if not autoShootEnabled then return nil end
        if not LocalPlayer:GetAttribute("Map") then return nil end
        
        local myCharacter = LocalPlayer.Character
        local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
        if not myRoot then return nil end
        
        local myTeam = LocalPlayer:GetAttribute("Team")
        local myGame = LocalPlayer:GetAttribute("Game")
        local nearest = nil
        local shortestDist = math.huge
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local character = player.Character
                local root = character and character:FindFirstChild("HumanoidRootPart")
                if root and player:GetAttribute("Game") == myGame and player:GetAttribute("Team") ~= myTeam then
                    local distance = (root.Position - myRoot.Position).Magnitude
                    if distance <= MAX_DISTANCE and distance < shortestDist then
                        shortestDist = distance
                        nearest = player
                    end
                end
            end
        end
        
        return nearest
    end
    
    local function fakeKill(target)
        if not target then return end
        
        killCounter = killCounter + 1
        
        local screenGui = LocalPlayer:FindFirstChild("PlayerGui")
        if screenGui then
            local hitMarker = Instance.new("Frame")
            hitMarker.Size = UDim2.new(0, 40, 0, 40)
            hitMarker.Position = UDim2.new(0.5, -20, 0.5, -20)
            hitMarker.BackgroundTransparency = 1
            hitMarker.ZIndex = 1000
            hitMarker.Parent = screenGui
            
            local line1 = Instance.new("Frame")
            line1.Size = UDim2.new(1, 0, 0.08, 0)
            line1.Position = UDim2.new(0, 0, 0.46, 0)
            line1.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            line1.BackgroundTransparency = 0.5
            line1.Rotation = 45
            line1.Parent = hitMarker
            
            local line2 = Instance.new("Frame")
            line2.Size = UDim2.new(1, 0, 0.08, 0)
            line2.Position = UDim2.new(0, 0, 0.46, 0)
            line2.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            line2.BackgroundTransparency = 0.5
            line2.Rotation = -45
            line2.Parent = hitMarker
            
            spawn(function()
                for i = 1, 20 do
                    hitMarker.Size = UDim2.new(0, 40 + i*2, 0, 40 + i*2)
                    hitMarker.Position = UDim2.new(0.5, -20 - i, 0.5, -20 - i)
                    line1.BackgroundTransparency = 0.5 + (i/20) * 0.5
                    line2.BackgroundTransparency = 0.5 + (i/20) * 0.5
                    task.wait(0.05)
                end
                hitMarker:Destroy()
            end)
        end
        
        if math.random(1, 3) == 1 then
            local screenGui = LocalPlayer:FindFirstChild("PlayerGui")
            if screenGui then
                local headshot = Instance.new("TextLabel")
                headshot.Size = UDim2.new(0.3, 0, 0.08, 0)
                headshot.Position = UDim2.new(0.35, 0, 0.4, 0)
                headshot.BackgroundTransparency = 0.3
                headshot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                headshot.Text = "💀 HEADSHOT! 💀"
                headshot.TextColor3 = Color3.fromRGB(255, 255, 255)
                headshot.TextScaled = true
                headshot.Font = Enum.Font.GothamBold
                headshot.Parent = screenGui
                
                spawn(function()
                    for i = 1, 30 do
                        headshot.Position = UDim2.new(0.35, 0, 0.4 - i*0.002, 0)
                        headshot.BackgroundTransparency = 0.3 + (i/30) * 0.7
                        task.wait(0.05)
                    end
                    headshot:Destroy()
                end)
            end
        end
        
        pcall(function()
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
                "💀 Eliminated " .. target.Name,
                "All"
            )
        end)
    end
    
    local function autoShootLoop()
        while autoShootEnabled do
            task.wait(FIRE_DELAY)
            
            if not autoShootEnabled then break end
            if not LocalPlayer:GetAttribute("Map") then continue end
            
            local target = getNearestEnemy()
            if target then
                local character = LocalPlayer.Character
                if character then
                    local tool = character:FindFirstChildOfClass("Tool")
                    if tool then
                        local handle = tool:FindFirstChild("Handle")
                        if handle then
                            handle.CFrame = handle.CFrame * CFrame.new(0, 0, -0.1)
                            task.wait(0.05)
                            handle.CFrame = handle.CFrame * CFrame.new(0, 0, 0.1)
                        end
                    end
                end
                
                fakeKill(target)
            end
        end
    end
    
    GunTab:CreateToggle({
        Text = "Auto Shoot",
        Default = false,
        Callback = function(state)
            autoShootEnabled = state
            killCounter = 0
            if state then
                print("Auto Shoot enabled")
                spawn(autoShootLoop)
            else
                print("Auto Shoot disabled")
            end
        end
    })
end

-- ══════════════════════════════════════════════
--  AUTO SHOOT WHEN VISIBLE (TROLL VERSION)
--  Looks real but does nothing!
-- ══════════════════════════════════════════════
do
    local visibleShootEnabled = false
    local MAX_DISTANCE = 150
    local FIRE_DELAY = 0.12
    local killCounter = 0
    
    local function getClosestPlayerToCursor()
        if not visibleShootEnabled then return nil end
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
                    if worldDistance <= MAX_DISTANCE then
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
    
    local function fakeKill(target)
        if not target then return end
        
        killCounter = killCounter + 1
        
        local screenGui = LocalPlayer:FindFirstChild("PlayerGui")
        if screenGui then
            local hitMarker = Instance.new("Frame")
            hitMarker.Size = UDim2.new(0, 40, 0, 40)
            hitMarker.Position = UDim2.new(0.5, -20, 0.5, -20)
            hitMarker.BackgroundTransparency = 1
            hitMarker.ZIndex = 1000
            hitMarker.Parent = screenGui
            
            local line1 = Instance.new("Frame")
            line1.Size = UDim2.new(1, 0, 0.08, 0)
            line1.Position = UDim2.new(0, 0, 0.46, 0)
            line1.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            line1.BackgroundTransparency = 0.5
            line1.Rotation = 45
            line1.Parent = hitMarker
            
            local line2 = Instance.new("Frame")
            line2.Size = UDim2.new(1, 0, 0.08, 0)
            line2.Position = UDim2.new(0, 0, 0.46, 0)
            line2.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            line2.BackgroundTransparency = 0.5
            line2.Rotation = -45
            line2.Parent = hitMarker
            
            spawn(function()
                for i = 1, 20 do
                    hitMarker.Size = UDim2.new(0, 40 + i*2, 0, 40 + i*2)
                    hitMarker.Position = UDim2.new(0.5, -20 - i, 0.5, -20 - i)
                    line1.BackgroundTransparency = 0.5 + (i/20) * 0.5
                    line2.BackgroundTransparency = 0.5 + (i/20) * 0.5
                    task.wait(0.05)
                end
                hitMarker:Destroy()
            end)
        end
        
        if math.random(1, 3) == 1 then
            local screenGui = LocalPlayer:FindFirstChild("PlayerGui")
            if screenGui then
                local headshot = Instance.new("TextLabel")
                headshot.Size = UDim2.new(0.3, 0, 0.08, 0)
                headshot.Position = UDim2.new(0.35, 0, 0.4, 0)
                headshot.BackgroundTransparency = 0.3
                headshot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                headshot.Text = "💀 HEADSHOT! 💀"
                headshot.TextColor3 = Color3.fromRGB(255, 255, 255)
                headshot.TextScaled = true
                headshot.Font = Enum.Font.GothamBold
                headshot.Parent = screenGui
                
                spawn(function()
                    for i = 1, 30 do
                        headshot.Position = UDim2.new(0.35, 0, 0.4 - i*0.002, 0)
                        headshot.BackgroundTransparency = 0.3 + (i/30) * 0.7
                        task.wait(0.05)
                    end
                    headshot:Destroy()
                end)
            end
        end
        
        pcall(function()
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
                "💀 Eliminated " .. target.Name,
                "All"
            )
        end)
    end
    
    local function visibleShootLoop()
        while visibleShootEnabled do
            task.wait(FIRE_DELAY)
            if not visibleShootEnabled then break end
            if not LocalPlayer:GetAttribute("Map") then continue end
            
            local target = getClosestPlayerToCursor()
            if target then
                local character = LocalPlayer.Character
                if character then
                    local tool = character:FindFirstChildOfClass("Tool")
                    if tool then
                        tool:Activate()
                    end
                end
                fakeKill(target)
            end
        end
    end
    
    GunTab:CreateToggle({
        Text = "Auto Shoot When Visible",
        Default = false,
        Callback = function(state)
            visibleShootEnabled = state
            killCounter = 0
            if state then
                print("Auto Shoot When Visible enabled")
                spawn(visibleShootLoop)
            else
                print("Auto Shoot When Visible disabled")
            end
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
print("All features enabled and ready to use.")
