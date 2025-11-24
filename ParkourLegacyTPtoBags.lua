-RISK OF GETTING BANNEDD I RECOMMEND YOU USE THE ESP ONLY
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LP = Players.LocalPlayer
local Character = LP.Character or LP.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")
local TELEPORT_DELAY = 5

hookfunction(LP.Kick, newcclosure(function() end))

LP.CharacterAdded:Connect(function(char)
    Character = char
    HRP = char:WaitForChild("HumanoidRootPart")
    Humanoid = char:WaitForChild("Humanoid")
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LP:WaitForChild("PlayerGui")
ScreenGui.Name = "BagViewerUI"

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 400)
Frame.Position = UDim2.new(0, 50, 0, 50)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 1
Frame.Parent = ScreenGui
Frame.Active = true
Frame.Draggable = true

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Frame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
ScrollingFrame.CanvasSize = UDim2.new(0,0,0,0)
ScrollingFrame.ScrollBarThickness = 6
ScrollingFrame.Parent = Frame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Parent = ScrollingFrame
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0,5)

local function findBags()
    local bags = {}
    local mapFolder = Workspace:FindFirstChild("Map")
    if not mapFolder then return bags end
    for _, bag in ipairs(mapFolder:GetChildren()) do
        if (bag:IsA("Model") or bag:IsA("Folder")) and bag:FindFirstChild("RealBagValues") then
            table.insert(bags, bag)
        end
    end
    return bags
end

local function floatPlayer(targetPos)
    local stop = false
    local connection
    connection = RunService.Stepped:Connect(function()
        if stop or not HRP then
            connection:Disconnect()
            return
        end
        HRP.Velocity = Vector3.new(0,0,0)
        HRP.Anchored = true
        HRP.CFrame = CFrame.new(targetPos)
    end)
    return function() stop = true HRP.Anchored = false end
end

local function createBagButton(bag)
    local part = bag:FindFirstChild("Main") or bag:FindFirstChild("Union") or bag:FindFirstChild("Side") or bag:FindFirstChildWhichIsA("BasePart")
    if not part then return end

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.Text = bag.Name
    btn.Parent = ScrollingFrame

    local viewing = false
    local originalCFrame
    btn.MouseButton1Click:Connect(function()
        viewing = not viewing
        if viewing then
            originalCFrame = Workspace.CurrentCamera.CFrame
            Workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
            Workspace.CurrentCamera.CFrame = CFrame.new(part.Position + Vector3.new(0,3,0), part.Position)
            btn.Text = "Viewing: "..bag.Name.." (Click to stop)"
        else
            Workspace.CurrentCamera.CFrame = originalCFrame
            Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
            btn.Text = bag.Name
        end
    end)

    local tpBtn = Instance.new("TextButton")
    tpBtn.Size = UDim2.new(1, -10, 0, 25)
    tpBtn.Position = UDim2.new(0,0,0,35)
    tpBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    tpBtn.TextColor3 = Color3.fromRGB(255,255,255)
    tpBtn.Font = Enum.Font.Gotham
    tpBtn.TextSize = 14
    tpBtn.Text = "Teleport to "..bag.Name
    tpBtn.Parent = btn

    tpBtn.MouseButton1Click:Connect(function()
        if not HRP then return end
        local finalPos = part.Position
        local stopFloat = floatPlayer(finalPos)
        task.wait(TELEPORT_DELAY)
        HRP.CFrame = CFrame.new(finalPos)
        stopFloat()
    end)
end

local function populateBags()
    ScrollingFrame:ClearAllChildren()
    for _, bag in ipairs(findBags()) do
        createBagButton(bag)
    end
end

RunService.RenderStepped:Connect(function()
    local layout = ScrollingFrame:FindFirstChildOfClass("UIListLayout")
    if layout then
        local contentSize = layout.AbsoluteContentSize.Y
        ScrollingFrame.CanvasSize = UDim2.new(0,0,0,contentSize)
    end
end)

populateBags()
Workspace.Map.ChildAdded:Connect(function()
    task.wait(0.5)
    populateBags()
end)
