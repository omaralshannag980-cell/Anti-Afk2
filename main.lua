-- سكربت Anti-AFK كامل مع Ping متحرك وسحب وعداد

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local VirtualInput = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- واجهة
local gui = Instance.new("ScreenGui")
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 130)
frame.Position = UDim2.new(0.5, -110, 0.5, -65)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BackgroundTransparency = 0.6
frame.BorderSizePixel = 0
frame.Parent = gui

Instance.new("UICorner").Parent = frame -- زوايا مدورة

-- Labels
local fpsLbl = Instance.new("TextLabel", frame)
fpsLbl.Size = UDim2.new(1, 0, 0, 30)
fpsLbl.Position = UDim2.new(0, 0, 0, 5)
fpsLbl.BackgroundTransparency = 1
fpsLbl.Text = "FPS: 0"
fpsLbl.TextColor3 = Color3.new(1, 1, 1)
fpsLbl.TextScaled = true
fpsLbl.Font = Enum.Font.GothamBold
fpsLbl.TextStrokeTransparency = 0.5
fpsLbl.TextStrokeColor3 = Color3.fromRGB(150, 200, 255)

local pingLbl = Instance.new("TextLabel", frame)
pingLbl.Size = UDim2.new(1, 0, 0, 30)
pingLbl.Position = UDim2.new(0, 0, 0, 40)
pingLbl.BackgroundTransparency = 1
pingLbl.Text = "Ping: 0ms"
pingLbl.TextColor3 = Color3.new(1, 1, 1)
pingLbl.TextScaled = true
pingLbl.Font = Enum.Font.GothamBold
pingLbl.TextStrokeTransparency = 0.5
pingLbl.TextStrokeColor3 = Color3.fromRGB(150, 200, 255)

local timerLbl = Instance.new("TextLabel", frame)
timerLbl.Size = UDim2.new(1, 0, 0, 30)
timerLbl.Position = UDim2.new(0, 0, 0, 75)
timerLbl.BackgroundTransparency = 1
timerLbl.Text = "00:00:00"
timerLbl.TextColor3 = Color3.new(1, 1, 1)
timerLbl.TextScaled = true
timerLbl.Font = Enum.Font.GothamBold
timerLbl.TextStrokeTransparency = 0.5
timerLbl.TextStrokeColor3 = Color3.fromRGB(150, 200, 255)

-- سحب الإطار
local drag = false
local startPos, frameStart

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = true
        startPos = input.Position
        frameStart = frame.Position
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if drag and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - startPos
        frame.Position = UDim2.new(frameStart.X.Scale, frameStart.X.Offset + delta.X,
                                   frameStart.Y.Scale, frameStart.Y.Offset + delta.Y)
    end
end)

-- متغيرات FPS والعداد
local fpsCount = 0
local lastFpsTime = os.clock()
local fps = 0

local startTime = os.clock()
local timerRunning = true

local function updateTimer()
    if not timerRunning then return end
    local t = os.clock() - startTime
    local h = math.floor(t / 3600)
    local m = math.floor((t % 3600) / 60)
    local s = math.floor(t % 60)
    timerLbl.Text = string.format("%02d:%02d:%02d", h, m, s)
end

-- منع الطرد (حركة ماوس خفيفة)
local function antiAFK()
    VirtualInput:SendMouseMovement(1, 0, false)
    task.wait(0.05)
    VirtualInput:SendMouseMovement(-1, 0, false)
end

coroutine.wrap(function()
    while true do
        task.wait(600) -- كل 10 دقائق
        if LocalPlayer and LocalPlayer.Parent then antiAFK() end
    end
end)()

-- التحديث كل إطار + تحديث Ping بشكل منفصل كل 0.3 ثانية
RunService.Heartbeat:Connect(function(dt)
    -- FPS
    fpsCount = fpsCount + 1
    if os.clock() - lastFpsTime >= 1 then
        fps = fpsCount
        fpsCount = 0
        lastFpsTime = os.clock()
        fpsLbl.Text = "FPS: " .. fps
    end

    -- العداد
    updateTimer()

    -- تغيير اللون تدريجياً
    local elapsed = os.clock() - startTime
    local intensity = math.min(elapsed / 60, 1)
    frame.BackgroundColor3 = Color3.fromRGB(
        30 + intensity * 70,
        math.max(0, 10 - intensity * 8),
        math.max(0, 10 - intensity * 8)
    )
end)

-- تحديث Ping بشكل مستقل (كل 0.3 ثانية عشان يشوف الحركة)
coroutine.wrap(function()
    while timerRunning do
        -- الطريقة الأولى: Stats:GetPing() (بالثواني)
        local pingSec = Stats:GetPing() or 0
        local pingMs = math.floor(pingSec * 1000)

        -- الطريقة الثانية (اختياري) لو الأولى ما اشتغلت:
        local ping2 = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() or 0
        if ping2 > 0 then pingMs = math.floor(ping2) end

        pingLbl.Text = "Ping: " .. pingMs .. "ms"
        task.wait(0.3)
    end
end)()

-- عند الخروج
LocalPlayer:GetPropertyChangedSignal("Parent"):Connect(function()
    if LocalPlayer.Parent == nil then timerRunning = false end
end)

Players.PlayerRemoving:Connect(function(p)
    if p == LocalPlayer then timerRunning = false end
end)

print("✅ Anti-AFK شغال – اسحب الواجهة، Ping يتغير، عداد يشتغل")
