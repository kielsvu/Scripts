-- STANDALONE DRAGGABLE FUNCTION TAB UI WITH SMOOTH TOGGLES

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
    ScriptName = "Standalone Functions UI",
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

-- MAIN FUNCTION WINDOW
local FunctionWindow = Instance.new("ScrollingFrame")
FunctionWindow.Size = UDim2.new(1, -20, 1, -40)
FunctionWindow.Position = UDim2.new(0, 10, 0, 35)
FunctionWindow.BackgroundColor3 = UI_SETTINGS.MainColor
FunctionWindow.BorderSizePixel = 0
FunctionWindow.ScrollBarThickness = 0
FunctionWindow.Parent = MainFrame
FunctionWindow.ClipsDescendants = true
FunctionWindow.CanvasSize = UDim2.new(0, 0, 0, 300)

local FunctionCorner = Instance.new("UICorner")
FunctionCorner.CornerRadius = UDim.new(0, UI_SETTINGS.CornerRadius)
FunctionCorner.Parent = FunctionWindow

local FunctionStroke = Instance.new("UIStroke")
FunctionStroke.Color = UI_SETTINGS.BorderColor
FunctionStroke.Thickness = 2
FunctionStroke.Parent = FunctionWindow

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
    lbl.Parent = FunctionWindow

    local toggle = Instance.new("TextButton")
    toggle.Size = UI_SETTINGS.ToggleSize
    toggle.Position = UDim2.new(0.7,0,0,y)
    toggle.BackgroundColor3 = UI_SETTINGS.ToggleColor
    toggle.BorderSizePixel = 0
    toggle.Text = ""
    toggle.Parent = FunctionWindow

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

-- AUTO ROB SCRIPT TOGGLE (replaces placeholder 1)
createToggle("Auto Rob Script", 10, function(state)
    if state then
        game.StarterGui:SetCore("SendNotification",{Title="Script Activated!",Text="Credits: GarciaScripts!",Duration=5})
        local v0=game.Players.LocalPlayer
        local v1=workspace.CurrentCamera
        local v2,v3=v1.CFrame,v0.Character
        local v4=v3:FindFirstChildWhichIsA("Humanoid")
        if v4 then
            local v22=v4:Clone()
            v22.Parent=v3
            v0.Character=nil
            v22:SetStateEnabled(Enum.HumanoidStateType.Dead,false)
            v22:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
            v22:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
            v4:Destroy()
            v0.Character=v3
            v1.CameraSubject=v22
            v1.CFrame=v2
            v22.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None
            local v29=v3:FindFirstChild("Animate")
            if v29 then v29.Disabled=true;wait();v29.Disabled=false; end
            v22.Health=v22.MaxHealth
        end
        task.wait(2)
        local v5=game:GetService("Workspace")
        local v6=game:GetService("ReplicatedStorage")
        local v7=game:GetService("Players")
        local v8=game:GetService("RunService")
        local v9=v7.LocalPlayer
        local v10=v9.Character
        local v11=v10.HumanoidRootPart
        local v12=v9:FindFirstChild("States")
        local v13=v9:FindFirstChild("Stats")
        local v14=v6:FindFirstChild("GeneralEvents"):FindFirstChild("Rob")
        local v15=v13:FindFirstChild("BagSizeLevel"):FindFirstChild("CurrentAmount")
        local v16=v12:FindFirstChild("Bag")
        local v17=CFrame.new(1636.62537,104.349976, -1736.184)
        local function v18() v11.CFrame=v17 end
        local function v19()
            for _, v33 in ipairs(v5:GetChildren()) do
                if (v16.Value==v15.Value) then
                    v18()
                    break
                elseif (v33:IsA("Model") and v33.Name=="CashRegister") then
                    local v37=v33:FindFirstChild("Open")
                    if v37 then
                        v11.CFrame=v37.CFrame
                        v14:FireServer("Register",{Part=v33:FindFirstChild("Union"),OpenPart=v37,ActiveValue=v33:FindFirstChild("Active"),Active=true})
                    end
                end
            end
        end
        local function v20()
            for _, v35 in ipairs(v5:GetChildren()) do
                if (v16.Value==v15.Value) then
                    v18()
                    break
                elseif (v35:IsA("Model") and v35.Name=="Safe" and (v35:FindFirstChild("Amount").Value>0)) then
                    local v38=v35:FindFirstChild("Safe")
                    if v38 then
                        v11.CFrame=v38.CFrame
                        if v35:FindFirstChild("Open").Value then
                            v14:FireServer("Safe",v35)
                        else
                            v35:FindFirstChild("OpenSafe"):FireServer("Completed")
                            v14:FireServer("Safe",v35)
                        end
                    end
                end
            end
        end
        v8.RenderStepped:Connect(function()
            v19()
            v20()
        end)
    end
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
