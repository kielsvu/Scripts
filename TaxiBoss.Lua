--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TaxiBossUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

-- Main Window
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "Taxi Boss"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 24
title.Parent = mainFrame

-- Function to create toggles
local function CreateToggle(text, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -20, 0, 50)
    toggleFrame.Position = UDim2.new(0, 10, 0, (#mainFrame:GetChildren()-1)*55)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = mainFrame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.3, -5, 0.8, 0)
    button.Position = UDim2.new(0.7, 5, 0.1, 0)
    button.Text = "OFF"
    button.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 18
    button.Parent = toggleFrame

    local state = false
    button.MouseButton1Click:Connect(function()
        state = not state
        button.Text = state and "ON" or "OFF"
        button.BackgroundColor3 = state and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
        callback(state)
    end)
end

-- Auto Money function
local function AutoMoney(state)
    spawn(function()
        while state do
            task.wait(0.5)
            local plr = LocalPlayer
            if not plr.ActiveQuests:FindFirstChild("contractBuildMaterial") then
                pcall(function()
                    ReplicatedStorage.Quests.Contracts.StartContract:InvokeServer("contractBuildMaterial")
                end)
                repeat task.wait() until plr.ActiveQuests:FindFirstChild("contractBuildMaterial")
            end
            pcall(function()
                ReplicatedStorage.Quests.DeliveryComplete:InvokeServer("contractMaterial")
            end)
            if plr.ActiveQuests.contractBuildMaterial.Value == "!pw5pi3ps2" then
                pcall(function()
                    ReplicatedStorage.Quests.Contracts.CompleteContract:InvokeServer()
                end)
            end
        end
    end)
end

-- Add the Auto Money toggle
CreateToggle("Auto Money", AutoMoney)
