--[[
    Anti-AFK بدون ضغط أي زر (يعتمد على حركة الماوس فقط)
    واجهة GUI سوداء → أحمر غامق، ونص أبيض نيون
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local VirtualInput = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

-- إنشاء GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 130)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -65)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BackgroundTransparency = 0.6
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- عناوين
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(1, 0, 0, 30)
fpsLabel.Position = UDim2.new(0, 0, 0, 5)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS: 0"
fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsLabel.TextScaled = true
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextStrokeTransparency = 0.5
fpsLabel.TextStrokeColor3 = Color3.fromRGB(150, 200, 255)
fpsLabel.Parent = mainFrame

local pingLabel = Instance.new("TextLabel")
pingLabel.Size = UDim2.new(1, 0, 0, 30)
pingLabel.Position = UDim2.new(0, 0, 0, 40)
pingLabel.BackgroundTransparency = 1
pingLabel.Text = "Ping: 0ms"
pingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
pingLabel.TextScaled = true
pingLabel.Font = Enum.Font.GothamBold
pingLabel.TextStrokeTransparency = 0.5
pingLabel.TextStrokeColor3 = Color3.fromRGB(150, 200, 255)
pingLabel.Parent = mainFrame

local timerLabel = Instance.new("TextLabel")
timerLabel.Size = UDim2.new(1, 0, 0, 30)
timerLabel.Position = UDim2.new(0, 0, 0, 75)
timerLabel.BackgroundTransparency = 1
timerLabel.Text = "00:00:00"
timerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
timerLabel.TextScaled = true
timerLabel.Font = Enum.Font.GothamBold
timerLabel.TextStrokeTransparency = 0.5
timerLabel.TextStrokeColor3 = Color3.fromRGB(150, 200, 255)
timerLabel.Parent = mainFrame

-- متغيرات FPS
local frameCount = 0
local lastTime = os.clock()
local fps = 0

-- متغيرات العداد
local startTime = os.clock()
local timerRunning = true

local function updateTimer()
    if not timerRunning then return end
    local elapsed = os.clock() - startTime
    local hours = math.floor(elapsed / 3600)
    local minutes = math.floor((elapsed % 3600) / 60)
    local seconds = math.floor(elapsed % 60)
    timerLabel.Text = string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

-- دالة منع الطرد (حركة ماوس بسيطة جداً، بدون ضغط زر)
local function preventAFK()
    -- تحريك الماوس 1 بيكسل يميناً ثم إعادته (لا يظهر تأثير على الشاشة)
    VirtualInput:SendMouseMovement(1, 0, false)
    task.wait(0.05)
    VirtualInput:SendMouseMovement(-1, 0, false)
end

-- حلقة كل 10 دقائق (أقل من حد الطرد 20 دقيقة)
coroutine.wrap(function()
    while true do
        task.wait(600) -- 10 دقائق
        if LocalPlayer and LocalPlayer.Parent then
            preventAFK()
        else
            break
        end
    end
end)()

-- تحديث القيم كل إطار
RunService.Heartbeat:Connect(function(deltaTime)
    -- FPS
    frameCount = frameCount + 1
    local currentTime = os.clock()
    if currentTime - lastTime >= 1 then
        fps = frameCount
        frameCount = 0
        lastTime = currentTime
        fpsLabel.Text = "FPS: " .. fps
    end

    -- Ping
    local ping = Stats:GetPing() or 0
    pingLabel.Text = "Ping: " .. math.floor(ping * 1000) .. "ms"

    -- تحديث العداد
    updateTimer()

    -- تحول الخلفية للأحمر الداكن تدريجياً
    local elapsed = os.clock() - startTime
    local intensity = math.min(elapsed / 60, 1)
    local red = math.floor(30 + intensity * 70)
    local green = math.floor(10 - intensity * 8)
    local blue = math.floor(10 - intensity * 8)
    mainFrame.BackgroundColor3 = Color3.fromRGB(red, math.max(0, green), math.max(0, blue))
end)

-- إيقاف العداد عند الخروج
LocalPlayer:GetPropertyChangedSignal("Parent"):Connect(function()
    if LocalPlayer.Parent == nil then
        timerRunning = false
    end
end)

game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == LocalPlayer then
        timerRunning = false
    end
end)

print("Anti-AFK (mouse movement only) loaded - no key presses!")
