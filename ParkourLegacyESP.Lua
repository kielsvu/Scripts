local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")

local MAX_DISTANCE = 5000
local ESP_COLOR = Color3.fromRGB(255, 200, 50)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BagESP_UI"
ScreenGui.Parent = LP:WaitForChild("PlayerGui")

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0, 150, 0, 25)
TextBox.Position = UDim2.new(0, 10, 0, 10)
TextBox.PlaceholderText = "Max ESP Distance"
TextBox.Text = tostring(MAX_DISTANCE)
TextBox.ClearTextOnFocus = false
TextBox.Parent = ScreenGui

TextBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local value = tonumber(TextBox.Text)
		if value and value > 0 then
			MAX_DISTANCE = value
		else
			TextBox.Text = tostring(MAX_DISTANCE)
		end
	end
end)

local function findBagValues(bag)
    return bag:FindFirstChild("RealBagValues")
end

local function findBagPart(bag)
    local preferredParts = {"Main", "Union", "Side"}
    for _, name in ipairs(preferredParts) do
        local part = bag:FindFirstChild(name)
        if part and part:IsA("BasePart") then
            return part
        end
    end
    for _, v in ipairs(bag:GetChildren()) do
        if v:IsA("BasePart") and v.Name ~= "DropT" and v.Name ~= "TouchInterest" then
            return v
        end
    end
    return nil
end

local function isBag(obj)
    if not (obj:IsA("Model") or obj:IsA("Folder")) then return false end
    if not findBagValues(obj) then return false end
    if not findBagPart(obj) then return false end
    return true
end

local function createESP(bag)
    if bag:FindFirstChild("BagESP") then return end
    local part = findBagPart(bag)
    if not part then return end

    local gui = Instance.new("BillboardGui")
    gui.Name = "BagESP"
    gui.Adornee = part
    gui.Size = UDim2.new(0, 120, 0, 20)
    gui.AlwaysOnTop = true

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextScaled = true
    label.TextColor3 = ESP_COLOR
    label.TextStrokeTransparency = 0.3
    label.Parent = gui

    gui.Parent = bag
end

RunService.RenderStepped:Connect(function()
    local camPos = Camera.CFrame.Position
    local mapFolder = Workspace:FindFirstChild("Map")
    if not mapFolder then return end

    for _, bag in ipairs(mapFolder:GetChildren()) do
        if isBag(bag) then
            createESP(bag)
            local esp = bag:FindFirstChild("BagESP")
            if esp then
                local part = findBagPart(bag)
                local values = findBagValues(bag)
                local distance = (camPos - part.Position).Magnitude

                esp.Enabled = distance <= MAX_DISTANCE

                local label = esp:FindFirstChildOfClass("TextLabel")
                if label then
                    local totalValue = 0
                    for _, v in ipairs(values:GetChildren()) do
                        if v:IsA("NumberValue") then
                            totalValue += v.Value
                        end
                    end
                    label.Text = "BAG ["..math.floor(distance).."m] - "..totalValue
                end
            end
        end
    end
end)

local mapFolder = Workspace:FindFirstChild("Map")
if mapFolder then
    mapFolder.ChildAdded:Connect(function(obj)
        if isBag(obj) then
            createESP(obj)
        end
    end)
end
