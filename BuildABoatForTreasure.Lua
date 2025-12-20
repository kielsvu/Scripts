-- W.I.P
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local Pos1 = Vector3.new(-55, -5, -225)
local Pos2 = Vector3.new(-20, 65, 8819)
local Pos3 = Vector3.new(-55, -358, 9492)

local tweenDuration = 25
local safeMinY = -40
local bufferY = 2

local AutoFarm = {}
AutoFarm.Enabled = false
AutoFarm.Task = nil

local function getRoot(char)
	return char and (char:FindFirstChild("HumanoidRootPart")
		or char:FindFirstChild("LowerTorso")
		or char:FindFirstChild("UpperTorso")
		or char:FindFirstChild("Torso"))
end

local function noClip(char, state)
	if not char then return end
	pcall(function()
		for _, v in ipairs(char:GetDescendants()) do
			if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
				v.CanCollide = not state
			end
		end
	end)
	local hum = char:FindFirstChildWhichIsA("Humanoid")
	if hum then hum.PlatformStand = state end
end

local function tweenTo(root, target, duration)
	if not root or not root.Parent then return end
	noClip(root.Parent, true)
	local startPos = root.Position
	local elapsed = 0
	local look = root.CFrame.LookVector

	while elapsed < duration and AutoFarm.Enabled and root and root.Parent do
		local dt = RunService.Heartbeat:Wait()
		elapsed = elapsed + dt

		local alpha = math.clamp(elapsed / duration, 0, 1)
		local newPos = startPos:Lerp(target, alpha)

		local y = math.max(newPos.Y, safeMinY)
		newPos = Vector3.new(newPos.X, y + bufferY, newPos.Z)

		root.CFrame = CFrame.new(newPos, newPos + look)
		root.Velocity = Vector3.zero
		root.RotVelocity = Vector3.zero
	end

	if AutoFarm.Enabled and root and root.Parent then
		root.CFrame = CFrame.new(target + Vector3.new(0, bufferY, 0))
	end

	if root and root.Parent then
		noClip(root.Parent, false)
	end
end

local function startPersistentLoop()
	if AutoFarm.Task then return end
	AutoFarm.Task = task.spawn(function()
		while AutoFarm.Enabled do
			local char = player.Character
			if not char or not char.Parent then
				player.CharacterAdded:Wait()
				task.wait(0.4)
				if not AutoFarm.Enabled then break end
				char = player.Character
			end

			local root = getRoot(char)
			if not root then
				task.wait(0.25)
				continue
			end

			-- step 1: move to Pos1
			if not AutoFarm.Enabled then break end
			if root and root.Parent then
				root.CFrame = CFrame.new(Pos1)
			end
			task.wait(0.25)

			-- step 2: tween to Pos2
			if not AutoFarm.Enabled then break end
			root = getRoot(player.Character)
			if root and root.Parent then
				tweenTo(root, Pos2, tweenDuration)
			end
			if not AutoFarm.Enabled then break end
			task.wait(0.25)

			-- step 3: go to Pos3
			root = getRoot(player.Character)
			if not root or not root.Parent then
				continue
			end
			root.CFrame = CFrame.new(Pos3)
			task.wait(1.5)

			-- finish: force respawn to collect gold then continue
			local hum = player.Character and player.Character:FindFirstChildWhichIsA("Humanoid")
			if hum then
				pcall(function()
					if hum and hum.Parent then
						hum:BreakJoints()
					end
				end)
			end

			player.CharacterAdded:Wait()
			task.wait(0.5)
		end
		AutoFarm.Task = nil
	end)
end

function AutoFarm.Toggle(state)
	AutoFarm.Enabled = state
	if state then
		startPersistentLoop()
	else
		AutoFarm.Task = nil
	end
end

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

-- Toggle directly on MainFrame
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

createToggle("Build A Boat AutoFarm", 50, function(state)
	AutoFarm.Toggle(state)
end)

-- Dragging functionality
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
