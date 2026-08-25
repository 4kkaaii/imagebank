local player = game.Players.LocalPlayer

if not player then return end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MinesweeperTroll"
screenGui.Parent = player.PlayerGui


local GRID_SIZE = 10
local NUM_MINES = 15
local CELL_SIZE = 35
local PADDING = 3


local grid = {}
local minePositions = {}
local gameOver = false
local firstClick = true
local flagsPlaced = 0


local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, GRID_SIZE * (CELL_SIZE + PADDING) + PADDING + 20, 0, GRID_SIZE * (CELL_SIZE + PADDING) + PADDING + 80)
mainFrame.Position = UDim2.new(0.5, -mainFrame.Size.X.Offset/2, 0.5, -mainFrame.Size.Y.Offset/2)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 3
mainFrame.BorderColor3 = Color3.fromRGB(255, 50, 50)
mainFrame.Parent = screenGui


local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, -45)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "💀 TRY NOT TO EXPLODE 💀"
titleLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 20)
subtitle.Position = UDim2.new(0, 0, 0, -25)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Right click to flag | Find all mines to win!"
subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
subtitle.TextScaled = true
subtitle.Font = Enum.Font.Gotham
subtitle.Parent = mainFrame


local statsFrame = Instance.new("Frame")
statsFrame.Size = UDim2.new(1, 0, 0, 30)
statsFrame.Position = UDim2.new(0, 0, 1, -30)
statsFrame.BackgroundTransparency = 1
statsFrame.Parent = mainFrame


local mineCounter = Instance.new("TextLabel")
mineCounter.Size = UDim2.new(0.5, 0, 1, 0)
mineCounter.Position = UDim2.new(0, 5, 0, 0)
mineCounter.BackgroundTransparency = 1
mineCounter.Text = "💣 " .. NUM_MINES
mineCounter.TextColor3 = Color3.fromRGB(255, 100, 100)
mineCounter.TextScaled = true
mineCounter.Font = Enum.Font.GothamBold
mineCounter.TextXAlignment = Enum.TextXAlignment.Left
mineCounter.Parent = statsFrame


local flagCounter = Instance.new("TextLabel")
flagCounter.Size = UDim2.new(0.5, 0, 1, 0)
flagCounter.Position = UDim2.new(0.5, 0, 0, 0)
flagCounter.BackgroundTransparency = 1
flagCounter.Text = "🚩 0"
flagCounter.TextColor3 = Color3.fromRGB(100, 255, 100)
flagCounter.TextScaled = true
flagCounter.Font = Enum.Font.GothamBold
flagCounter.TextXAlignment = Enum.TextXAlignment.Right
flagCounter.Parent = statsFrame


local function generateMines(excludeX, excludeY)
    minePositions = {}
    local mineCount = 0
    
    while mineCount < NUM_MINES do
        local x = math.random(1, GRID_SIZE)
        local y = math.random(1, GRID_SIZE)
        
        local isExcluded = false
        for dx = -1, 1 do
            for dy = -1, 1 do
                if x == excludeX + dx and y == excludeY + dy then
                    isExcluded = true
                end
            end
        end
        
        if not isExcluded and not minePositions[x .. "," .. y] then
            minePositions[x .. "," .. y] = true
            mineCount = mineCount + 1
        end
    end
end


local function countAdjacentMines(x, y)
    local count = 0
    for dx = -1, 1 do
        for dy = -1, 1 do
            if dx ~= 0 or dy ~= 0 then
                local checkX = x + dx
                local checkY = y + dy
                if checkX >= 1 and checkX <= GRID_SIZE and checkY >= 1 and checkY <= GRID_SIZE then
                    if minePositions[checkX .. "," .. checkY] then
                        count = count + 1
                    end
                end
            end
        end
    end
    return count
end


local function revealAdjacent(x, y)
    for dx = -1, 1 do
        for dy = -1, 1 do
            if dx ~= 0 or dy ~= 0 then
                local checkX = x + dx
                local checkY = y + dy
                if checkX >= 1 and checkX <= GRID_SIZE and checkY >= 1 and checkY <= GRID_SIZE then
                    local cell = grid[checkX][checkY]
                    if not cell.Revealed and not cell.Flagged then
                        local adjacentMines = countAdjacentMines(checkX, checkY)
                        if adjacentMines == 0 then
                            cell.Revealed = true
                            cell.Button.BackgroundColor3 = Color3.fromRGB(180, 180, 200)
                            cell.Button.Text = ""
                            revealAdjacent(checkX, checkY)
                        else
                            cell.Revealed = true
                            cell.Button.BackgroundColor3 = Color3.fromRGB(180, 180, 200)
                            cell.Button.Text = tostring(adjacentMines)
                            cell.Button.TextColor3 = Color3.fromRGB(0, 0, 255)
                        end
                    end
                end
            end
        end
    end
end


local function checkWin()
    local revealedCount = 0
    for x = 1, GRID_SIZE do
        for y = 1, GRID_SIZE do
            if grid[x][y].Revealed then
                revealedCount = revealedCount + 1
            end
        end
    end
    
    if revealedCount == (GRID_SIZE * GRID_SIZE) - NUM_MINES then
        gameOver = true
        

        local winLabel = Instance.new("TextLabel")
        winLabel.Size = UDim2.new(1, 0, 1, 0)
        winLabel.BackgroundTransparency = 0.6
        winLabel.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        winLabel.Text = "😂 YOU WON?! IMPOSSIBLE! 😂"
        winLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        winLabel.TextScaled = true
        winLabel.Font = Enum.Font.GothamBold
        winLabel.Parent = mainFrame
        

        task.wait(1)
        local resetBtn = Instance.new("TextButton")
        resetBtn.Size = UDim2.new(0.4, 0, 0.1, 0)
        resetBtn.Position = UDim2.new(0.3, 0, 0.8, 0)
        resetBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        resetBtn.Text = "🔁 PLAY AGAIN (YOU WON'T WIN)"
        resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        resetBtn.TextScaled = true
        resetBtn.Font = Enum.Font.GothamBold
        resetBtn.Parent = mainFrame
        
        resetBtn.MouseButton1Click:Connect(function()

            for x = 1, GRID_SIZE do
                for y = 1, GRID_SIZE do
                    grid[x][y].Button:Destroy()
                end
            end
            winLabel:Destroy()
            resetBtn:Destroy()

            screenGui:Destroy()
            loadstring(game:HttpGet("raw script url here"))()
        end)
    end
end


local function triggerLoss()
    if gameOver then return end
    gameOver = true
    

    for x = 1, GRID_SIZE do
        for y = 1, GRID_SIZE do
            local cell = grid[x][y]
            if minePositions[x .. "," .. y] then
                cell.Button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                cell.Button.Text = "💥"
                cell.Button.TextScaled = true
                -- Shake effect
                cell.Button.Position = cell.Button.Position + UDim2.new(0, math.random(-5, 5), 0, math.random(-5, 5))
            end
        end
    end
    

    local lossFrame = Instance.new("Frame")
    lossFrame.Size = UDim2.new(1, 0, 1, 0)
    lossFrame.BackgroundTransparency = 0.5
    lossFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    lossFrame.ZIndex = 100
    lossFrame.Parent = mainFrame
    
    local lossLabel = Instance.new("TextLabel")
    lossLabel.Size = UDim2.new(1, 0, 0.5, 0)
    lossLabel.Position = UDim2.new(0, 0, 0.2, 0)
    lossLabel.BackgroundTransparency = 1
    lossLabel.Text = "💀 KABOOM! 💀\nYOU EXPLODED!\nGET REKT EXPLOITER!"
    lossLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    lossLabel.TextScaled = true
    lossLabel.Font = Enum.Font.GothamBold
    lossLabel.ZIndex = 101
    lossLabel.Parent = lossFrame
    

    local subText = Instance.new("TextLabel")
    subText.Size = UDim2.new(1, 0, 0.2, 0)
    subText.Position = UDim2.new(0, 0, 0.7, 0)
    subText.BackgroundTransparency = 1
    subText.Text = "😂 Skill issue! 😂\nBANNED FROM MINESWEEPER"
    subText.TextColor3 = Color3.fromRGB(255, 255, 0)
    subText.TextScaled = true
    subText.Font = Enum.Font.Gotham
    subText.ZIndex = 101
    subText.Parent = lossFrame
    

    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://9120379511" -- Generic explosion sound
    sound.Volume = 1
    sound.Parent = mainFrame
    sound:Play()
    

    task.wait(5)
    
    local kickMessages = {
        "ronaldola ninja",
        "ronaldola ninja",
        "ronaldola ninja",
        "ronaldola ninja",
        "ronaldola ninja",
        "ronaldola ninja",
        "ronaldola ninja",
        "ronaldola ninja"
    }
    
    local kickMsg = kickMessages[math.random(1, #kickMessages)]
    player:Kick(kickMsg)
end


local function onCellClick(x, y, button)
    if gameOver then return end
    local cell = grid[x][y]
    
    if button == Enum.MouseButton.Button1 then -- Left click
        if cell.Flagged then return end
        if cell.Revealed then return end
        

        if firstClick then
            firstClick = false
            generateMines(x, y)
        end
        

        if minePositions[x .. "," .. y] then
            triggerLoss()
            return
        end
        

        cell.Revealed = true
        local adjacentMines = countAdjacentMines(x, y)
        
        if adjacentMines == 0 then
            cell.Button.BackgroundColor3 = Color3.fromRGB(180, 180, 200)
            cell.Button.Text = ""
            revealAdjacent(x, y)
        else
            cell.Button.BackgroundColor3 = Color3.fromRGB(180, 180, 200)
            cell.Button.Text = tostring(adjacentMines)
            
            local colors = {
                [1] = Color3.fromRGB(0, 0, 255),
                [2] = Color3.fromRGB(0, 128, 0),
                [3] = Color3.fromRGB(255, 0, 0),
                [4] = Color3.fromRGB(0, 0, 128),
                [5] = Color3.fromRGB(128, 0, 0),
                [6] = Color3.fromRGB(0, 128, 128),
                [7] = Color3.fromRGB(0, 0, 0),
                [8] = Color3.fromRGB(128, 128, 128)
            }
            cell.Button.TextColor3 = colors[adjacentMines] or Color3.fromRGB(0, 0, 0)
        end
        
        checkWin()
        
    elseif button == Enum.MouseButton.Button2 then 
        if cell.Revealed then return end
        cell.Flagged = not cell.Flagged
        if cell.Flagged then
            cell.Button.Text = "🚩"
            cell.Button.TextScaled = true
            flagsPlaced = flagsPlaced + 1
        else
            cell.Button.Text = ""
            flagsPlaced = flagsPlaced - 1
        end
        flagCounter.Text = "🚩 " .. flagsPlaced
    end
end


for x = 1, GRID_SIZE do
    grid[x] = {}
    for y = 1, GRID_SIZE do
        local cell = {}
        cell.Revealed = false
        cell.Flagged = false
        
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0, CELL_SIZE, 0, CELL_SIZE)
        button.Position = UDim2.new(0, (x-1) * (CELL_SIZE + PADDING) + PADDING + 10, 0, (y-1) * (CELL_SIZE + PADDING) + PADDING + 5)
        button.BackgroundColor3 = Color3.fromRGB(100, 100, 130)
        button.BorderSizePixel = 1
        button.BorderColor3 = Color3.fromRGB(50, 50, 80)
        button.Text = ""
        button.Font = Enum.Font.GothamBold
        button.TextScaled = true
        button.Parent = mainFrame
        

        button.MouseEnter:Connect(function()
            if not button.BackgroundColor3 == Color3.fromRGB(180, 180, 200) then
                button.BackgroundColor3 = Color3.fromRGB(130, 130, 160)
            end
        end)
        
        button.MouseLeave:Connect(function()
            if not button.BackgroundColor3 == Color3.fromRGB(180, 180, 200) then
                button.BackgroundColor3 = Color3.fromRGB(100, 100, 130)
            end
        end)
        
        button.MouseButton1Click:Connect(function()
            onCellClick(x, y, Enum.MouseButton.Button1)
        end)
        
        button.MouseButton2Click:Connect(function()
            onCellClick(x, y, Enum.MouseButton.Button2)
        end)
        
        cell.Button = button
        grid[x][y] = cell
    end
end

print("🎯 Minesweeper Troll Loaded!")
print("💀 Try not to explode... or else you get kicked!")
print("😂 Good luck, exploiter!")


local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, -40)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = mainFrame


closeBtn.MouseButton1Click:Connect(function()
    closeBtn.Text = "😂"
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
    task.wait(0.5)
    closeBtn.Text = "X"
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    print("😂 Nice try! You can't close this!")
end)
