local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- ตำแหน่งเดิม
local originalPosition = rootPart.Position
local isSinking = false
local sinkDepth = 40 -- จมลง 40 studs
local rotationSpeed = math.rad(300)
local angle = 0

-- วงกลม FOV (GUI)
local fovCircle = Instance.new("Frame")
fovCircle.Parent = player:WaitForChild("PlayerGui")
fovCircle.Size = UDim2.new(0,100,0,100)
fovCircle.Position = UDim2.new(0.5,-50,0.5,-50)
fovCircle.BackgroundColor3 = Color3.fromHSV(0,1,1)
fovCircle.BorderSizePixel = 2
fovCircle.Visible = false

-- ฟังก์ชัน RenderStepped
RunService.RenderStepped:Connect(function(delta)
    -- จมลงใต้ดิน
    if humanoid.Health <= 30 then
        if not isSinking then
            isSinking = true
            angle = 0
            fovCircle.Visible = true -- แสดงวงกลม FOV
        end
        angle = angle + rotationSpeed * delta
        rootPart.CFrame = CFrame.new(originalPosition - Vector3.new(0, sinkDepth, 0)) * CFrame.Angles(0, angle, 0)
    elseif isSinking and humanoid.Health >= 31 then
        isSinking = false
        rootPart.CFrame = CFrame.new(originalPosition)
        fovCircle.Visible = false
    end
end)
