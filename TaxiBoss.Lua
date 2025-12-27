--!strict
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- UI SETTINGS
local UI_SETTINGS = {
    MainColor = Color3.fromRGB(5,5,5),
    BorderColor = Color3.fromRGB(178,132,255),
    TextColor = Color3.fromRGB(255,255,255),
    WindowWidth = 400,
    WindowHeight = 200,
    CornerRadius = 15,
    Font = Enum.Font.SourceSansBold,
    ScriptName = "Garcia's Scripts",
    GameName = "Taxi Boss [WINTER EVENT]",
    ToggleColor = Color3.fromRGB(40,40,40),
    ToggleActiveColor = Color3.fromRGB(178,132,255),
    ToggleSize = UDim2.new(0,40,0,20),
    ToggleCorner = 8,
}

-- TWEEN HELPER
local function Tween(inst, props, time)
    TweenService:Create(inst, TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), props):Play()
end

-- GUI SETUP
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StandaloneFunctionUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, UI_SETTINGS.WindowWidth, 0, UI_SETTINGS.WindowHeight)
MainFrame.Position = UDim2.new(0.5, -UI_SETTINGS.WindowWidth/2, 0.5, -UI_SETTINGS.WindowHeight/2)
MainFrame.BackgroundColor3 = UI_SETTINGS.MainColor
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, UI_SETTINGS.CornerRadius)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = UI_SETTINGS.BorderColor
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Script Name Label
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -20, 0, 25)
TitleLabel.Position = UDim2.new(0, 10, 0, 5)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = UI_SETTINGS.ScriptName
TitleLabel.Font = UI_SETTINGS.Font
TitleLabel.TextSize = 18
TitleLabel.TextColor3 = UI_SETTINGS.TextColor
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainFrame
Tween(TitleLabel, {TextTransparency = 0}, 0.5)

-- Manual Game Name Label (grey)
local GameLabel = Instance.new("TextLabel")
GameLabel.Size = UDim2.new(1, -20, 0, 20)
GameLabel.Position = UDim2.new(0, 10, 0, 30)
GameLabel.BackgroundTransparency = 1
GameLabel.Text = UI_SETTINGS.GameName
GameLabel.Font = UI_SETTINGS.Font
GameLabel.TextSize = 14
GameLabel.TextColor3 = Color3.fromRGB(150, 150, 150) -- grey
GameLabel.TextXAlignment = Enum.TextXAlignment.Left
GameLabel.TextTransparency = 1
GameLabel.Parent = MainFrame
Tween(GameLabel, {TextTransparency = 0}, 0.5)

-- TOGGLE CREATOR
local function createToggle(name, y, callback)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.6,0,0,20)
    lbl.Position = UDim2.new(0,10,0,y)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.Font = UI_SETTINGS.Font
    lbl.TextSize = 16
    lbl.TextColor3 = UI_SETTINGS.TextColor
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextTransparency = 1
    lbl.Parent = MainFrame

    local toggle = Instance.new("TextButton")
    toggle.Size = UI_SETTINGS.ToggleSize
    toggle.Position = UDim2.new(0.7,0,0,y)
    toggle.BackgroundColor3 = UI_SETTINGS.ToggleColor
    toggle.BorderSizePixel = 0
    toggle.Text = ""
    toggle.Parent = MainFrame

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, UI_SETTINGS.ToggleCorner)
    toggleCorner.Parent = toggle

    local active = false
    toggle.MouseButton1Click:Connect(function()
        active = not active
        Tween(toggle, {BackgroundColor3 = active and UI_SETTINGS.ToggleActiveColor or UI_SETTINGS.ToggleColor}, 0.3)
        callback(active)
    end)

    Tween(lbl, {TextTransparency = 0}, 0.5)
    Tween(toggle, {BackgroundTransparency = 0}, 0.5)
end

-- ==================== FLAGS ====================
local AutoMoneyEnabled = false
local AutoFarmEnabled = false
local AuroraEnabled = false
local WinterEnabled = false
local TWEEN_SPEED = 0.25
local INTERVAL = 0.5
local BASE_POSITION = CFrame.new(-221, 87, -80) -- permanent base

-- ==================== AUTO MONEY ====================
local function AutoMoney(state)
    task.spawn(function()
        while state do
            local plr = LocalPlayer
            local activeQuest = plr.ActiveQuests:FindFirstChildOfClass("StringValue")
            
            if activeQuest and activeQuest.Name ~= "contractBuildMaterial" then
                pcall(function()
                    ReplicatedStorage.Quests.Contracts.CancelContract:InvokeServer(activeQuest.Name)
                end)
            end

            if not plr.ActiveQuests:FindFirstChild("contractBuildMaterial") then
                pcall(function()
                    ReplicatedStorage.Quests.Contracts.StartContract:InvokeServer("contractBuildMaterial")
                end)
                repeat task.wait() until plr.ActiveQuests:FindFirstChild("contractBuildMaterial")
            end

            task.spawn(function()
                pcall(function()
                    ReplicatedStorage.Quests.DeliveryComplete:InvokeServer("contractMaterial")
                end)
            end)

            local contract = plr.ActiveQuests:FindFirstChild("contractBuildMaterial")
            if contract and contract.Value == "!pw5pi3ps2" then
                pcall(function()
                    ReplicatedStorage.Quests.Contracts.CompleteContract:InvokeServer()
                end)
            end

            task.wait(0.5)
        end
    end)
end

-- ==================== AUTO FARM ====================
local function TweenTo(cf)
    local HRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not HRP or not cf then return end
    local t = TweenService:Create(HRP, TweenInfo.new(TWEEN_SPEED, Enum.EasingStyle.Linear), {CFrame = cf})
    t:Play()
    t.Completed:Wait()
end

local function FarmPath(path)
    if not path then return end
    local HRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not HRP then return end
    for _, item in ipairs(path:GetChildren()) do
        if item.Name == "BaseCrate" then
            local cf = item:IsA("BasePart") and item.CFrame or (item:IsA("Model") and item:GetPivot())
            if cf then
                TweenTo(cf * CFrame.new(0,3,0))
                task.wait(0.1)
                TweenTo(BASE_POSITION)
                task.wait(0.15)
            end
        end
    end
end

task.spawn(function()
    while task.wait(0.25) do
        if AutoFarmEnabled then
            local HRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if HRP then
                TweenTo(BASE_POSITION)
                task.wait(0.25)

                local spawned = workspace:FindFirstChild("SpawnedItems")
                if spawned then
                    local path2 = spawned:FindFirstChild("ItemSpawnArea2_Items")
                    local path1 = spawned:FindFirstChild("ItemSpawnArea1_Items")
                    FarmPath(path2)
                    FarmPath(path1)
                end

                TweenTo(BASE_POSITION)
            end
        end
    end
end)

-- ==================== AUTO GIFTS ====================
task.spawn(function()
    while task.wait(0.5) do
        if AuroraEnabled then
            pcall(function()
                local args = {"aurora"}
                ReplicatedStorage:WaitForChild("Christmas"):WaitForChild("OpenPresent"):InvokeServer(unpack(args))
            end)
        end
        if WinterEnabled then
            pcall(function()
                local args = {"winter"}
                ReplicatedStorage:WaitForChild("Christmas"):WaitForChild("OpenPresent"):InvokeServer(unpack(args))
            end)
        end
    end
end)

-- ==================== CREATE TOGGLES ====================
createToggle("Auto Money", 50, function(state)
    AutoMoneyEnabled = state
    AutoMoney(state)
end)

createToggle("Auto Farm", 90, function(state)
    AutoFarmEnabled = state
end)

createToggle("Aurora Gift Open", 130, function(state)
    AuroraEnabled = state
end)

createToggle("Winter Gift Open", 170, function(state)
    WinterEnabled = state
end)

-- ==================== DRAGGING SYSTEM ====================
local dragging, dragInput, mousePos, framePos = false, nil, nil, nil
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        MainFrame.Position = UDim2.new(
            framePos.X.Scale,
            framePos.X.Offset + delta.X,
            framePos.Y.Scale,
            framePos.Y.Offset + delta.Y
        )
    end
end)
