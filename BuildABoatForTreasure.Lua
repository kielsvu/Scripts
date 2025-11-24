-- Kinda buggy
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer
local Character = LP.Character or LP.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

local AUTO_FARM = false
local PLATFORM_SIZE = Vector3.new(6,1,6)
local TELEPORT_HEIGHT = 5
local WATER_HEIGHT = 0
local DELAY_BETWEEN = 1
local RESPAWN_DELAY = 7
local waitingAfterDeath = false

LP.CharacterAdded:Connect(function(char)
    Character = char
    HRP = char:WaitForChild("HumanoidRootPart")
    Humanoid = char:WaitForChild("Humanoid")
end)

hookfunction(LP.Kick, newcclosure(function() end))

local ScreenGui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
ScreenGui.Name = "AutoFarmGUI"

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0,250,0,100)
Frame.Position = UDim2.new(0,10,0,10)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,25)
Title.Position = UDim2.new(0,0,0,0)
Title.Text = "Build A Boat AutoFarm"
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.Parent = Frame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(1, -10,0,25)
ToggleButton.Position = UDim2.new(0,5,0,35)
ToggleButton.Text = "Start AutoFarm"
ToggleButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
ToggleButton.TextColor3 = Color3.fromRGB(255,255,255)
ToggleButton.Font = Enum.Font.Gotham
ToggleButton.TextScaled = true
ToggleButton.Parent = Frame

ToggleButton.MouseButton1Click:Connect(function()
    AUTO_FARM = not AUTO_FARM
    ToggleButton.Text = AUTO_FARM and "Stop AutoFarm" or "Start AutoFarm"
end)

local function spawnPlatform(pos)
    local platform = Instance.new("Part")
    platform.Size = PLATFORM_SIZE
    platform.Anchored = true
    platform.CanCollide = true
    platform.Transparency = 0.5
    platform.CFrame = CFrame.new(pos)
    platform.Parent = Workspace
    task.delay(3,function()
        if platform then platform:Destroy() end
    end)
end

local function safeTP(stageModel)
    if not HRP then return end
    local tpPos = Vector3.new(
        stageModel.PrimaryPart and stageModel.PrimaryPart.Position.X or HRP.Position.X,
        WATER_HEIGHT + TELEPORT_HEIGHT,
        stageModel.PrimaryPart and stageModel.PrimaryPart.Position.Z or HRP.Position.Z
    )
    spawnPlatform(tpPos)
    HRP.CFrame = CFrame.new(tpPos)
end

local function claimGold()
    if Workspace:FindFirstChild("ClaimRiverResultsGold") then
        Workspace.ClaimRiverResultsGold:FireServer()
    end
end

local function autoFarmLoop()
    while AUTO_FARM do
        if Humanoid.Health <= 0 and not waitingAfterDeath then
            waitingAfterDeath = true
            claimGold()
            task.wait(RESPAWN_DELAY)
            Character = LP.Character or LP.CharacterAdded:Wait()
            HRP = Character:WaitForChild("HumanoidRootPart")
            Humanoid = Character:WaitForChild("Humanoid")
            waitingAfterDeath = false
        end

        local stagesFolder = Workspace:FindFirstChild("BoatStages")
        if stagesFolder then
            local allStages = {}

            if stagesFolder:FindFirstChild("OtherStages") then
                for _, stage in ipairs(stagesFolder.OtherStages:GetChildren()) do
                    table.insert(allStages, stage)
                end
            end

            if stagesFolder:FindFirstChild("NormalStages") then
                for _, stage in ipairs(stagesFolder.NormalStages:GetChildren()) do
                    table.insert(allStages, stage)
                end
            end

            for _, stage in ipairs(allStages) do
                if not AUTO_FARM then break end
                if Humanoid.Health <= 0 then break end

                if stage:IsA("Model") then
                    safeTP(stage)
                    task.wait(DELAY_BETWEEN)
                end
            end

            if stagesFolder.NormalStages:FindFirstChild("TheEnd") then
                safeTP(stagesFolder.NormalStages.TheEnd)
                task.wait(DELAY_BETWEEN)
            end

            if AUTO_FARM then
                Character:BreakJoints()
                task.wait(1)
            end
        end

        claimGold()
        task.wait(1)
    end
end

task.spawn(function()
    while true do
        if AUTO_FARM then
            autoFarmLoop()
        else
            task.wait(1)
        end
    end
end)
