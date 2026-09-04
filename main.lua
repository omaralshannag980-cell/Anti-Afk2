local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 180, 0, 110)
Frame.Position = UDim2.new(0.7, 0, 0.1, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = false
Frame.ClipsDescendants = true

local Gradient = Instance.new("UIGradient")
Gradient.Parent = Frame
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 0, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 0, 0))
})
Gradient.Rotation = 90

local Corner = Instance.new("UICorner")
Corner.Parent = Frame
Corner.CornerRadius = UDim.new(0, 8)

local FPS_Label = Instance.new("TextLabel")
FPS_Label.Parent = Frame
FPS_Label.Size = UDim2.new(1, 0, 0, 30)
FPS_Label.Position = UDim2.new(0, 0, 0, 5)
FPS_Label.BackgroundTransparency = 1
FPS_Label.Font = Enum.Font.GothamBold
FPS_Label.TextSize = 22
FPS_Label.TextColor3 = Color3.fromRGB(255, 255, 255)
FPS_Label.TextStrokeTransparency = 0.3
FPS_Label.TextStrokeColor3 = Color3.fromRGB(0, 255, 255)
FPS_Label.Text = "FPS: 0"

local Ping_Label = Instance.new("TextLabel")
Ping_Label.Parent = Frame
Ping_Label.Size = UDim2.new(1, 0, 0, 30)
Ping_Label.Position = UDim2.new(0, 0, 0, 35)
Ping_Label.BackgroundTransparency = 1
Ping_Label.Font = Enum.Font.GothamBold
Ping_Label.TextSize = 22
Ping_Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Ping_Label.TextStrokeTransparency = 0.3
Ping_Label.TextStrokeColor3 = Color3.fromRGB(0, 255, 255)
Ping_Label.Text = "Ping: 0ms"

local Time_Label = Instance.new("TextLabel")
Time_Label.Parent = Frame
Time_Label.Size = UDim2.new(1, 0, 0, 30)
Time_Label.Position = UDim2.new(0, 0, 0, 65)
Time_Label.BackgroundTransparency = 1
Time_Label.Font = Enum.Font.GothamBold
Time_Label.TextSize = 22
Time_Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Time_Label.TextStrokeTransparency = 0.3
Time_Label.TextStrokeColor3 = Color3.fromRGB(0, 255, 255)
Time_Label.Text = "Time: 00:00:00"

for _, label in ipairs({FPS_Label, Ping_Label, Time_Label}) do
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStroke = 1
end

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

local fps = 0
local lastTime = tick()
local frameCount = 0

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    local currentTime = tick()
    if currentTime - lastTime >= 1 then
        fps = frameCount
        frameCount = 0
        lastTime = currentTime
        FPS_Label.Text = "FPS: " .. fps
    end
end)

spawn(function()
    while true do
        local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
        Ping_Label.Text = "Ping: " .. math.floor(ping) .. "ms"

        local date = os.date("*t")
        local timeString = string.format("%02d:%02d:%02d", date.hour, date.min, date.sec)
        Time_Label.Text = "Time: " .. timeString

        wait(1)
    end
end)

local VirtualUser = game:GetService("VirtualUser")
local lastAntiAFK = tick()
local ANTI_AFK_INTERVAL = 19 * 60

RunService.Heartbeat:Connect(function()
    if tick() - lastAntiAFK >= ANTI_AFK_INTERVAL then
        lastAntiAFK = tick()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character:Move(Vector3.new(0.1, 0, 0.1), true)
            wait(0.1)
            character:Move(Vector3.new(-0.1, 0, -0.1), true)
        end
    end
end)
