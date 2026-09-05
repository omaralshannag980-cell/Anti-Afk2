--[[
    سكربت واجهة GUI متحركة:
    - خلفية متدرجة من الأسود إلى الأحمر (تتحرك باستمرار)
    - عرض FPS حي
    - عرض البنغ (Ping) حي
    - عرض الوقت المنقضي (يبدأ من 0)
    - حماية من الطرد Anti-AFK
    - قابل للسحب على الجوال
]]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")

-- إنشاء الواجهة
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- الإطار الرئيسي
local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 180, 0, 110)
Frame.Position = UDim2.new(0.7, 0, 0.1, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.ClipsDescendants = true

-- التدرج اللوني
local Gradient = Instance.new("UIGradient")
Gradient.Parent = Frame
Gradient.Rotation = 90

-- زوايا دائرية
local Corner = Instance.new("UICorner")
Corner.Parent = Frame
Corner.CornerRadius = UDim.new(0, 8)

-- عناصر النص
local FPS_Label = Instance.new("TextLabel")
FPS_Label.Parent = Frame
FPS_Label.Size = UDim2.new(1, 0, 0, 30)
FPS_Label.Position = UDim2.new(0, 0, 0, 5)
FPS_Label.BackgroundTransparency = 1
FPS_Label.Font = Enum.Font.GothamBold
FPS_Label.TextSize = 22
FPS_Label.TextColor3 = Color3.fromRGB(255, 255, 255)
FPS_Label.TextStrokeTransparency = 0
FPS_Label.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
FPS_Label.TextStroke = 1
FPS_Label.Text = "FPS: 0"

local Ping_Label = Instance.new("TextLabel")
Ping_Label.Parent = Frame
Ping_Label.Size = UDim2.new(1, 0, 0, 30)
Ping_Label.Position = UDim2.new(0, 0, 0, 35)
Ping_Label.BackgroundTransparency = 1
Ping_Label.Font = Enum.Font.GothamBold
Ping_Label.TextSize = 22
Ping_Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Ping_Label.TextStrokeTransparency = 0
Ping_Label.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
Ping_Label.TextStroke = 1
Ping_Label.Text = "Ping: 0ms"

local Time_Label = Instance.new("TextLabel")
Time_Label.Parent = Frame
Time_Label.Size = UDim2.new(1, 0, 0, 30)
Time_Label.Position = UDim2.new(0, 0, 0, 65)
Time_Label.BackgroundTransparency = 1
Time_Label.Font = Enum.Font.GothamBold
Time_Label.TextSize = 22
Time_Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Time_Label.TextStrokeTransparency = 0
Time_Label.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
Time_Label.TextStroke = 1
Time_Label.Text = "Time: 00:00:00"

-- نظام السحب
local dragging = false
local dragStart = nil
local startPos = nil

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- حساب FPS
local fps = 0
local frameCount = 0
local fpsTimer = tick()

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    if tick() - fpsTimer >= 0.5 then
        fps = math.floor(frameCount / (tick() - fpsTimer))
        frameCount = 0
        fpsTimer = tick()
        FPS_Label.Text = "FPS: " .. fps
    end
end)

-- تحديث البنغ والوقت
local startTime = tick()

task.spawn(function()
    while true do
        local ping = LocalPlayer:GetNetworkPing()
        Ping_Label.Text = "Ping: " .. math.floor(ping) .. "ms"

        local elapsed = tick() - startTime
        local hours = math.floor(elapsed / 3600)
        local minutes = math.floor((elapsed % 3600) / 60)
        local seconds = math.floor(elapsed % 60)
        Time_Label.Text = string.format("Time: %02d:%02d:%02d", hours, minutes, seconds)

        task.wait(1)
    end
end)

-- تحريك التدرج اللوني من الأسود إلى الأحمر
task.spawn(function()
    while true do
        local t = (math.sin(tick() * 0.8) + 1) / 2  -- قيمة بين 0 و 1
        local redValue = 10 + 140 * t               -- من 10 إلى 150
        Gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 0, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(redValue / 2, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(redValue, 0, 0))
        })
        task.wait(0.05)
    end
end)

-- نظام منع الطرد
local lastAntiAFK = tick()
local ANTI_AFK_INTERVAL = 5 * 60  -- كل 5 دقائق

RunService.Heartbeat:Connect(function()
    if tick() - lastAntiAFK >= ANTI_AFK_INTERVAL then
        lastAntiAFK = tick()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character:Move(Vector3.new(0.1, 0, 0.1), true)
            task.wait(0.1)
            character:Move(Vector3.new(-0.1, 0, -0.1), true)
        end
    end
end)
