-- STANDALONE DRAGGABLE FUNCTION TAB UI WITHOUT FUNCTIONS

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local UI_SETTINGS = {
    MainColor = Color3.fromRGB(5,5,5),
    BorderColor = Color3.fromRGB(178,132,255),
    TextColor = Color3.fromRGB(255,255,255),
    WindowWidth = 400,
    WindowHeight = 200,
    CornerRadius = 15,
    Font = Enum.Font.SourceSansBold,
    ScriptName = "GarciaScripts",
    ToggleColor = Color3.fromRGB(40,40,40),
    ToggleActiveColor = Color3.fromRGB(178,132,255),
    ToggleSize = UDim2.new(0,40,0,20),
    ToggleCorner = 8,
}

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

-- Example placeholder toggle (no function attached)
createToggle("Example Toggle", 50, function(state)
    -- Placeholder: function code goes here
end)

-- DRAGGING SYSTEM
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
