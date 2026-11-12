--════════════════════════════════════════════════════════════════════
--  LANSHER~HUB · v8.0
--  نفس هيكل الـ UI SHELL اللي أرسلته + صور جديدة + تابات
--════════════════════════════════════════════════════════════════════

--══════════════════════════════════════════════════════════════════
-- SERVICES
--══════════════════════════════════════════════════════════════════
local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")
local CoreGui          = game:GetService("CoreGui")
local SoundService     = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer

local RGB = Color3.fromRGB
local U2  = UDim2.new
local UD  = UDim.new
local V2  = Vector2.new
local New = Instance.new
local TI  = TweenInfo.new
local KC  = Enum.KeyCode
local ES  = Enum.EasingStyle
local ED  = Enum.EasingDirection

--══════════════════════════════════════════════════════════════════
--  ★ الصور الجديدة ★
--══════════════════════════════════════════════════════════════════
local A = {
    intro1 = "rbxassetid://138270086550975",
    intro2 = "rbxassetid://106762064444203",
    intro3 = "rbxassetid://117909885869841",
    intro4 = "rbxassetid://123598571664419",
    intro5 = "rbxassetid://93820894136588",

    uiBg   = "rbxassetid://123598571664419",
    toggle = "rbxassetid://117909885869841",
}

--══════════════════════════════════════════════════════════════════
-- CONFIG (نفس الأصل)
--══════════════════════════════════════════════════════════════════
local CFG = {
    Hub_Name   = "Lansher~Hub",
    Version    = "v8.0",
    Toggle_Key = KC.RightShift,

    Cor_Hub     = RGB(15, 15, 15),
    Cor_Options = RGB(28, 28, 28),
    Cor_Stroke  = RGB(255, 50, 50),
    Cor_Text    = RGB(255, 255, 255),
    Cor_Dark    = RGB(150, 150, 150),
    Cor_Success = RGB(50, 220, 130),
    Cor_Warn    = RGB(255, 180, 50),
    Cor_Error   = RGB(255, 70, 70),

    Font   = Enum.Font.FredokaOne,
    Corner = UD(0, 12),

    Width  = 500,
    Height = 400,
}

--══════════════════════════════════════════════════════════════════
-- SOUND
--══════════════════════════════════════════════════════════════════
local ClickSound = New("Sound")
ClickSound.SoundId = "rbxassetid://6895079853"
ClickSound.Volume = 1.5
ClickSound.Parent = SoundService

--══════════════════════════════════════════════════════════════════
-- HELPERS (نفس الأصل)
--══════════════════════════════════════════════════════════════════
local function Create(cls, parent, props)
    local o = Instance.new(cls, parent)
    if props then for k, v in pairs(props) do o[k] = v end end
    return o
end

local function Corner(parent, radius)
    local c = New("UICorner", parent)
    c.CornerRadius = radius or CFG.Corner
    return c
end

local function Stroke(parent)
    local s = New("UIStroke", parent)
    s.Color = CFG.Cor_Stroke
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Thickness = 2
    local g = New("UIGradient", s)
    g.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, RGB(255, 50, 50)),
        ColorSequenceKeypoint.new(0.5, RGB(180, 20, 20)),
        ColorSequenceKeypoint.new(1, RGB(255, 50, 50))
    }
    coroutine.wrap(function()
        while s.Parent do
            g.Rotation = (g.Rotation + 2) % 360
            RunService.RenderStepped:Wait()
        end
    end)()
    return s
end

local function Tween(obj, prop, value, time, wait)
    local t = TweenService:Create(obj, TI(time or 0.2, ES.Linear), {[prop] = value})
    t:Play()
    if wait then t.Completed:Wait() end
    return t
end

--══════════════════════════════════════════════════════════════════
-- NOTIFICATIONS
--══════════════════════════════════════════════════════════════════
local function Notify(title, text, kind, dur)
    local gui = CoreGui:FindFirstChild("LansherNotifs")
    if not gui then
        gui = Create("ScreenGui", CoreGui, {Name = "LansherNotifs", ResetOnSpawn = false, DisplayOrder = 999})
        local frame = Create("Frame", gui, {
            Size = U2(0, 280, 1, -20), Position = U2(1, -290, 0, 10), BackgroundTransparency = 1,
        })
        Create("UIListLayout", frame, {Padding = UDim.new(0, 6), VerticalAlignment = Enum.VerticalAlignment.Bottom})
    end
    local container = gui:FindFirstChildOfClass("Frame")
    local colors = {info = CFG.Cor_Stroke, success = CFG.Cor_Success, warn = CFG.Cor_Warn, error = CFG.Cor_Error}
    local col = colors[kind] or colors.info

    local n = Create("Frame", container, {Size = U2(1, 0, 0, 60), BackgroundColor3 = CFG.Cor_Hub, BorderSizePixel = 0})
    Corner(n)
    local accent = Create("Frame", n, {Size = U2(0, 4, 1, 0), BackgroundColor3 = col, BorderSizePixel = 0})
    Corner(accent, UD(1, 0))
    Create("TextLabel", n, {
        Size = U2(1, -20, 0, 20), Position = U2(0, 10, 0, 6),
        BackgroundTransparency = 1, Text = title, TextColor3 = CFG.Cor_Text,
        Font = CFG.Font, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
    })
    Create("TextLabel", n, {
        Size = U2(1, -20, 0, 30), Position = U2(0, 10, 0, 26),
        BackgroundTransparency = 1, Text = text, TextColor3 = col,
        Font = CFG.Font, TextSize = 11, TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    task.delay(dur or 3, function()
        Tween(n, "BackgroundTransparency", 1, 0.3)
        for _, c in ipairs(n:GetChildren()) do
            if c:IsA("TextLabel") then Tween(c, "TextTransparency", 1, 0.3) end
        end
        task.wait(0.35); n:Destroy()
    end)
end
local function safeNotify(t, txt, k, d) pcall(Notify, t, txt, k, d) end

--══════════════════════════════════════════════════════════════════
-- INTRO (fullscreen + fade + Welcome + Start)
--══════════════════════════════════════════════════════════════════
local IntroGui = Create("ScreenGui", CoreGui, {
    Name = "LansherIntro", IgnoreGuiInset = true, ResetOnSpawn = false,
    DisplayOrder = 9999, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})

local IntroBg = Create("Frame", IntroGui, {
    Size = U2(1, 1), BackgroundColor3 = RGB(0, 0, 0), BorderSizePixel = 0, ZIndex = 1,
})

local IntroImg = Create("ImageLabel", IntroGui, {
    Size = U2(1, 1), BackgroundTransparency = 1,
    ScaleType = Enum.ScaleType.Crop, ZIndex = 2,
})

local IntroImgNext = Create("ImageLabel", IntroGui, {
    Size = U2(1, 1), BackgroundTransparency = 1,
    ScaleType = Enum.ScaleType.Crop, ImageTransparency = 1, ZIndex = 2,
})

local FinalOverlay = Create("Frame", IntroGui, {
    Size = U2(1, 1), BackgroundColor3 = RGB(0, 0, 0),
    BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false, ZIndex = 10,
})

local WelcomeLbl = Create("TextLabel", FinalOverlay, {
    Size = U2(1, 0, 0, 80), Position = U2(0.5, 0, 0.42, -60), AnchorPoint = V2(0.5, 0.5),
    BackgroundTransparency = 1, Text = "Welcome",
    TextColor3 = CFG.Cor_Text, Font = Enum.Font.FredokaOne, TextSize = 54,
    TextTransparency = 1, ZIndex = 11,
})
Create("UIStroke", WelcomeLbl, {
    Color = CFG.Cor_Stroke, Thickness = 3,
    ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual, Transparency = 1,
})

local StartBtn = Create("TextButton", FinalOverlay, {
    Size = U2(0, 220, 0, 56), Position = U2(0.5, 0, 0.62, 0), AnchorPoint = V2(0.5, 0.5),
    BackgroundColor3 = CFG.Cor_Stroke, BorderSizePixel = 0,
    Text = "Start  /  أبدأ", TextColor3 = CFG.Cor_Text,
    Font = Enum.Font.FredokaOne, TextSize = 22, AutoButtonColor = false,
    BackgroundTransparency = 1, TextTransparency = 1, ZIndex = 12,
})
Corner(StartBtn, UD(0, 30))
local StartStroke = Create("UIStroke", StartBtn, {
    Color = CFG.Cor_Text, Thickness = 2,
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Transparency = 1,
})

local function crossfadeTo(nextImage)
    IntroImgNext.Image = nextImage
    IntroImgNext.ImageTransparency = 1
    IntroImgNext.Size = U2(1.06, 1.06)
    IntroImgNext.Position = U2(-0.03, -0.03)
    local t = TweenService:Create(IntroImgNext, TI(0.8, ES.Quad, ED.Out),
        {ImageTransparency = 0, Size = U2(1, 1), Position = U2(0, 0)})
    t:Play(); t.Completed:Wait()
    IntroImg.Image = IntroImgNext.Image
    IntroImg.ImageTransparency = 0
    IntroImgNext.ImageTransparency = 1
end

local function playIntro()
    IntroImg.Image = A.intro1
    IntroImg.ImageTransparency = 0
    task.wait(2.0)
    crossfadeTo(A.intro2); task.wait(2.0)
    crossfadeTo(A.intro3); task.wait(2.0)
    crossfadeTo(A.intro4); task.wait(2.0)
    crossfadeTo(A.intro5)
    FinalOverlay.Visible = true
    Tween(FinalOverlay, "BackgroundTransparency", 0.45, 0.5)
    Tween(WelcomeLbl, "TextTransparency", 0, 0.6)
    task.wait(0.35)
    Tween(StartBtn, "BackgroundTransparency", 0, 0.5)
    Tween(StartBtn, "TextTransparency", 0, 0.5)
    Tween(StartStroke, "Transparency", 0, 0.5)
end

--══════════════════════════════════════════════════════════════════
-- CLEANUP
--══════════════════════════════════════════════════════════════════
local old = CoreGui:FindFirstChild("LansherUI")
if old then old:Destroy() end

--══════════════════════════════════════════════════════════════════
-- SCREEN GUI
--══════════════════════════════════════════════════════════════════
local ScreenGui = Create("ScreenGui", CoreGui, {
    Name = "LansherUI", ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})

--══════════════════════════════════════════════════════════════════
-- زر الفتح (مع سحب يدوي للجوال)
--══════════════════════════════════════════════════════════════════
local OpenBtn = Create("ImageButton", ScreenGui, {
    Size = U2(0, 60, 0, 60),
    Position = U2(0, 30, 0.5, -30),
    BackgroundColor3 = CFG.Cor_Options,
    Image = A.toggle,
    AutoButtonColor = false,
    Active = true,
    Visible = false,
})
Corner(OpenBtn, UD(1, 0))
Stroke(OpenBtn)

-- دوران الزر (نفس الأصل)
task.spawn(function()
    while OpenBtn.Parent do
        Tween(OpenBtn, "Rotation", OpenBtn.Rotation + 360, 4)
        task.wait(4)
        OpenBtn.Rotation = 0
    end
end)

--══════════════════════════════════════════════════════════════════
-- النافذة الرئيسية (نفس المقاس 500x400)
--══════════════════════════════════════════════════════════════════
local Menu = Create("Frame", ScreenGui, {
    Size = U2(0, CFG.Width, 0, CFG.Height),
    Position = U2(0.5, -CFG.Width/2, 0.5, -CFG.Height/2),
    BackgroundColor3 = CFG.Cor_Hub,
    Visible = false,
    Active = true,
    Draggable = true,
})
Corner(Menu)
Stroke(Menu)

-- ★ خلفية (ID جديد) تحت التابات
local BGImage = Create("ImageLabel", Menu, {
    Size = U2(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Image = A.uiBg,
    ImageTransparency = 0.55,
    ScaleType = Enum.ScaleType.Crop,
    ZIndex = 0,
})
Corner(BGImage)

local BGOverlay = Create("Frame", Menu, {
    Size = U2(1, 0, 1, 0),
    BackgroundColor3 = RGB(0, 0, 0),
    BackgroundTransparency = 0.5,
    BorderSizePixel = 0,
    ZIndex = 0,
})
Corner(BGOverlay)

--══════════════════════════════════════════════════════════════════
-- شريط العنوان (نفس الأصل)
--══════════════════════════════════════════════════════════════════
local TopBar = Create("Frame", Menu, {Size = U2(1, 0, 0, 30), BackgroundTransparency = 1, ZIndex = 2})

local Logo = Create("ImageLabel", TopBar, {
    Size = U2(0, 20, 0, 20),
    Position = U2(0, 6, 0.5, 0),
    AnchorPoint = V2(0, 0.5),
    BackgroundTransparency = 1,
    Image = A.toggle,
    ZIndex = 3,
})
Corner(Logo, UD(1, 0))

task.spawn(function()
    local r = 0
    while Logo.Parent do
        r = (r + 1) % 360
        Logo.Rotation = r
        task.wait(0.016)
    end
end)

local Title = Create("TextLabel", TopBar, {
    Size = U2(1, -80, 1, 0),
    Position = U2(0, 30, 0, 0),
    BackgroundTransparency = 1,
    Text = CFG.Hub_Name .. " " .. CFG.Version,
    TextColor3 = RGB(255, 40, 40),
    Font = CFG.Font,
    TextSize = 18,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 3,
})

task.spawn(function()
    while Title.Parent do
        Tween(Title, "TextColor3", RGB(35, 0, 0), 0.8, true)
        Tween(Title, "TextColor3", RGB(255, 40, 40), 0.8, true)
    end
end)

-- أزرار التصغير + الإغلاق
local ButtonsFrame = Create("Frame", TopBar, {
    Size = U2(0, 60, 0, 30),
    Position = U2(1, -10, 0, 0),
    AnchorPoint = V2(1, 0),
    BackgroundTransparency = 1,
    ZIndex = 3,
})

local MinimizeBtn = Create("TextButton", ButtonsFrame, {
    Size = U2(0, 30, 1, 0),
    Position = U2(0, 0, 0, 0),
    BackgroundTransparency = 1, Text = "−",
    TextColor3 = CFG.Cor_Text, Font = CFG.Font, TextSize = 22,
})

local CloseBtn = Create("TextButton", ButtonsFrame, {
    Size = U2(0, 30, 1, 0),
    Position = U2(1, -30, 0, 0),
    BackgroundTransparency = 1, Text = "×",
    TextColor3 = CFG.Cor_Text, Font = CFG.Font, TextSize = 22,
})

Create("Frame", Menu, {
    Size = U2(1, 0, 0, 1),
    Position = U2(0, 0, 0, 30),
    BackgroundColor3 = CFG.Cor_Stroke,
    BorderSizePixel = 0,
    ZIndex = 2,
})

--══════════════════════════════════════════════════════════════════
-- المحتوى + التابات
--══════════════════════════════════════════════════════════════════
local Content = Create("Frame", Menu, {
    Size = U2(1, 0, 1, -31),
    Position = U2(0, 0, 0, 31),
    BackgroundTransparency = 1,
    ZIndex = 2,
})

-- شريط التابات عمودي (نفس ستايل الأصل — 130px يسار)
local TabBar = Create("Frame", Content, {
    Size = U2(0, 130, 1, 0),
    BackgroundColor3 = CFG.Cor_Options,
    BackgroundTransparency = 0.15,
    BorderSizePixel = 0,
    ZIndex = 3,
})
Corner(TabBar)
Create("UIListLayout", TabBar, {Padding = UDim.new(0, 4)})
Create("UIPadding", TabBar, {
    PaddingTop = UDim.new(0, 8),
    PaddingLeft = UDim.new(0, 8),
    PaddingRight = UDim.new(0, 8),
})

-- منطقة محتوى التابات (على اليمين)
local TabContent = Create("Frame", Content, {
    Size = U2(1, -130, 1, 0),
    Position = U2(0, 130, 0, 0),
    BackgroundTransparency = 1,
    ZIndex = 3,
})

--══════════════════════════════════════════════════════════════════
-- WIDGETS (نفس ستايل الأصل)
--══════════════════════════════════════════════════════════════════
local function AddButton(parent, name, callback)
    local btn = Create("TextButton", parent, {
        Size = U2(1, 0, 0, 30), BackgroundColor3 = CFG.Cor_Options,
        Text = "  " .. name, TextColor3 = CFG.Cor_Text, Font = CFG.Font,
        TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, AutoButtonColor = false,
        ZIndex = 5,
    })
    Corner(btn)
    Stroke(btn)
    Create("UIPadding", btn, {PaddingRight = UDim.new(0, 10)})
    btn.MouseButton1Click:Connect(function() pcall(callback) end)
    return btn
end

local function AddLabel(parent, text)
    return Create("TextLabel", parent, {
        Size = U2(1, 0, 0, 22), BackgroundTransparency = 1,
        Text = "  ◆ " .. text, TextColor3 = CFG.Cor_Stroke,
        Font = CFG.Font, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Right,
        ZIndex = 5,
    })
end

local tabs = {}
local function MakeTab(name)
    local btn = Create("TextButton", TabBar, {
        Size = U2(1, 0, 0, 28), BackgroundColor3 = CFG.Cor_Hub,
        Text = name, TextColor3 = CFG.Cor_Text, Font = CFG.Font, TextSize = 12,
        AutoButtonColor = false, ZIndex = 4,
    })
    Corner(btn)
    local frame = Create("ScrollingFrame", TabContent, {
        Size = U2(1, 0, 1, 0), BackgroundTransparency = 1,
        ScrollBarThickness = 4, CanvasSize = U2(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false, ZIndex = 4,
    })
    Create("UIPadding", frame, {
        PaddingTop = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 8),
    })
    Create("UIListLayout", frame, {Padding = UDim.new(0, 4)})
    btn.MouseButton1Click:Connect(function()
        ClickSound:Play()
        for _, t in pairs(tabs) do
            t.frame.Visible = false
            t.btn.BackgroundColor3 = CFG.Cor_Hub
        end
        frame.Visible = true
        btn.BackgroundColor3 = CFG.Cor_Stroke
    end)
    table.insert(tabs, {btn = btn, frame = frame})
    return frame
end

-- التابات الخمسة
local TabRights   = MakeTab("~ الحقوق ~")
local TabScripts  = MakeTab("~ سكربتاتي ~")
local TabCommands = MakeTab("~ أوامر ~")
local TabAntiLag  = MakeTab("~ تقليل لاج ~")
local TabTarget   = MakeTab("~ استهداف ~")

TabRights.Visible = true
tabs[1].btn.BackgroundColor3 = CFG.Cor_Stroke

--══════════════════════════════════════════════════════════════════
-- TAB 1: الحقوق
--══════════════════════════════════════════════════════════════════
AddLabel(TabRights, "هذا السكربت خاص بـ Lansher~Hub")

local copyBtn = AddButton(TabRights, "w_.0.10    (اضغط للنسخ)", function()
    ClickSound:Play()
    if setclipboard then
        setclipboard("w_.0.10")
        copyBtn.Text = "  ✓ تم النسخ"
        copyBtn.BackgroundColor3 = CFG.Cor_Success
        safeNotify("نسخ", "w_.0.10 تم نسخه", "success", 2)
        task.wait(1.4)
        copyBtn.Text = "  w_.0.10    (اضغط للنسخ)"
        copyBtn.BackgroundColor3 = CFG.Cor_Options
    else
        copyBtn.Text = "  setclipboard غير متاح"
        task.wait(1.4)
        copyBtn.Text = "  w_.0.10    (اضغط للنسخ)"
    end
end)

--══════════════════════════════════════════════════════════════════
-- TAB 2: سكربتاتي
--══════════════════════════════════════════════════════════════════
AddLabel(TabScripts, "السكربتات العربية")
AddButton(TabScripts, "سكربت زيكو",         function() loadstring(game:HttpGet("https://pastefy.app/mXMaE9fC/raw"))() end)
AddButton(TabScripts, "سكربت عسكر",         function() loadstring(game:HttpGet("https://rawscripts.net/raw/Brookhaven-RP-3skr-hub-240894"))() end)
AddButton(TabScripts, "سكربت جحيم الأساسي", function() loadstring(game:HttpGet("https://gist.githubusercontent.com/adamoalihossen-lang/1fcc9f47858217b73c7d21396347ee41/raw"))() end)
AddButton(TabScripts, "سكربت حكومة",        function() loadstring(game:HttpGet("https://pastebin.com/raw/FMC7ZWsw"))() end)
AddButton(TabScripts, "سكربت انصاري",       function() loadstring(game:HttpGet("https://gist.githubusercontent.com/Yemenx/e976b6c7c681e67ebe0f31f88ebb6ac6/raw/536a222c673c23ba43ebe29dfcc29a53c8808eea/ANSRY.YAMEN.VAMPAIRE.lua"))() end)
AddButton(TabScripts, "سكربت أبو عتب",      function() loadstring(game:HttpGet("https://gist.githubusercontent.com/yhmwd406-boop/2dd250fe58d63fabee981b085afc10c5/raw/8bf78e204f3f04cac8bea68e887a95f41c8b81c4/%25D8%25B3%25D9%2583%25D8%25B1%25D8%25A8%25D8%25AA%2520%25D8%25B9%25D8%25AF%25D8%25A7%25D8%25A7%25D8%25AA"))() end)
AddButton(TabScripts, "سكربت داركو",        function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Zenix-all-on-one-240296"))() end)
AddButton(TabScripts, "سكربت نقاط مراد",    function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-NO9AT-SAMLAT-47637"))() end)

AddLabel(TabScripts, "سكربتات بروك هافن")
AddButton(TabScripts, "عزام",         function() loadstring(game:HttpGet("https://rawscripts.net/raw/Brookhaven-RP-3azaam-hub-224262"))() end)
AddButton(TabScripts, "ميكي شات",     function() loadstring(game:HttpGet("https://rawscripts.net/raw/Brookhaven-RP-Mickey-Chat-85762"))() end)
AddButton(TabScripts, "REXM",         function() loadstring(game:HttpGet("https://rawscripts.net/raw/Brookhaven-RP-REXM-206004"))() end)
AddButton(TabScripts, "ABD HUB",      function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-ABD-HUB-PRO-238979"))() end)
AddButton(TabScripts, "طيران عدنان",  function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Flying-55336"))() end)
AddButton(TabScripts, "JG",           function() loadstring(game:HttpGet("https://rawscripts.net/raw/Brookhaven-RP-New-Update-Script-JG-Brookhaven-93130"))() end)
AddButton(TabScripts, "رافكس",        function() loadstring(game:HttpGet("https://rawscripts.net/raw/Brookhaven-RP-RAVEX-HUB-ARAB-NOW-86210"))() end)

--══════════════════════════════════════════════════════════════════
-- TAB 3: أوامر (12 أمر infinite)
--══════════════════════════════════════════════════════════════════
local INFINITE_URL = ""
local CMD_PREFIX   = "/"
local _infiniteReady = false
local function ensureInfinite()
    if _infiniteReady then return true end
    if INFINITE_URL ~= "" then
        local ok = pcall(function() loadstring(game:HttpGet(INFINITE_URL))() end)
        if ok then _infiniteReady = true; task.wait(2) end
    end
    return true
end
local function fireCmd(cmd)
    return pcall(function()
        game:GetService("ReplicatedStorage")
            .DefaultChatSystemChatEvents
            .SayMessageRequest:FireServer(CMD_PREFIX .. cmd, "All")
    end)
end

local ALL_COMMANDS = {
    "2022materials", "clearerror", "backtrack nan",
    "antiafk", "antikick", "datalimit 660",
    "backtrack 999", "xray", "antilag",
    "autokeypress nan", "autokeypress", "nofog",
}

AddLabel(TabCommands, "الأوامر الـ" .. #ALL_COMMANDS .. " (عبر infinite)")

Create("TextLabel", TabCommands, {
    Size = U2(1, 0, 0, 46), BackgroundTransparency = 1,
    Text = table.concat(ALL_COMMANDS, " • "),
    TextColor3 = CFG.Cor_Dark, Font = CFG.Font, TextSize = 9,
    TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 5,
})

local activateCmdBtn = AddButton(TabCommands, "تفعيل الاوامر", function()
    ensureInfinite()
    activateCmdBtn.Text = "  جارٍ..."
    activateCmdBtn.BackgroundColor3 = CFG.Cor_Warn
    task.spawn(function()
        for i, cmd in ipairs(ALL_COMMANDS) do
            fireCmd(cmd)
            activateCmdBtn.Text = "  تنفيذ " .. i .. "/" .. #ALL_COMMANDS .. " • " .. cmd
            task.wait(0.4)
        end
        activateCmdBtn.Text = "  ✓ تم تفعيل " .. #ALL_COMMANDS .. " أمر"
        activateCmdBtn.BackgroundColor3 = CFG.Cor_Success
        safeNotify("Lansher", "تم إرسال جميع الأوامر", "success", 3)
        task.wait(2.5)
        activateCmdBtn.Text = "  تفعيل الاوامر"
        activateCmdBtn.BackgroundColor3 = CFG.Cor_Options
    end)
end)

--══════════════════════════════════════════════════════════════════
-- TAB 4: تقليل لاج
--══════════════════════════════════════════════════════════════════
AddLabel(TabAntiLag, "يُنفَّذ عبر infinite:")
AddLabel(TabAntiLag, "▸ xray     ▸ antilag")

local antiBtn = AddButton(TabAntiLag, "تفعيل تقليل اللاج", function()
    ensureInfinite()
    antiBtn.Text = "  جارٍ..."
    antiBtn.BackgroundColor3 = CFG.Cor_Warn
    task.spawn(function()
        fireCmd("xray")
        task.wait(0.5)
        fireCmd("antilag")
        task.wait(0.5)
        antiBtn.Text = "  ✓ Xray + AntiLag مفعّل"
        antiBtn.BackgroundColor3 = CFG.Cor_Success
        safeNotify("Lansher", "تم إرسال xray + antilag", "success", 3)
        task.wait(1.8)
        antiBtn.Text = "  تفعيل تقليل اللاج"
        antiBtn.BackgroundColor3 = CFG.Cor_Options
    end)
end)

--══════════════════════════════════════════════════════════════════
-- TAB 5: استهداف
--══════════════════════════════════════════════════════════════════
AddLabel(TabTarget, "سكربتات استهداف")
AddButton(TabTarget, "NO9AT SAMLAT", function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-NO9AT-SAMLAT-47637"))() end)
AddButton(TabTarget, "Samlat",       function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-NO9AT-SAMLAT-47637"))() end)
AddButton(TabTarget, "تسجيل سلندر",  function() safeNotify("تنبيه", "الرابط غير مضاف", "warn", 2) end)
AddButton(TabTarget, "تسجيل نووي",   function() safeNotify("تنبيه", "الرابط غير مضاف", "warn", 2) end)

--══════════════════════════════════════════════════════════════════
-- الوظائف (نفس الأصل + سحب يدوي للزر)
--══════════════════════════════════════════════════════════════════
local isMinimized = false
local btnDrag, btnMoved, btnStart, btnPos = false, false, nil, nil

OpenBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        btnDrag = true
        btnMoved = false
        btnStart = input.Position
        btnPos = OpenBtn.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not btnDrag then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        local d = input.Position - btnStart
        if d.Magnitude > 4 then btnMoved = true end
        OpenBtn.Position = U2(
            btnPos.X.Scale, btnPos.X.Offset + d.X,
            btnPos.Y.Scale, btnPos.Y.Offset + d.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        if btnDrag and not btnMoved then
            ClickSound:Play()
            Menu.Visible = not Menu.Visible
        end
        btnDrag = false
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    ClickSound:Play()
    Menu.Visible = false
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    ClickSound:Play()
    isMinimized = not isMinimized
    MinimizeBtn.Text = isMinimized and "+" or "−"
    local target = isMinimized and 35 or CFG.Height
    Tween(Menu, "Size", U2(0, CFG.Width, 0, target), 0.15)
    Content.Visible = not isMinimized
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == CFG.Toggle_Key then
        ClickSound:Play()
        Menu.Visible = not Menu.Visible
    end
end)

--══════════════════════════════════════════════════════════════════
-- StartBtn → يفتح الواجهة ويغلق الانترو
--══════════════════════════════════════════════════════════════════
StartBtn.MouseButton1Click:Connect(function()
    StartBtn.Text = "Loading..."
    task.wait(0.3)
    Tween(IntroBg, "BackgroundTransparency", 1, 0.4)
    Tween(IntroImg, "ImageTransparency", 1, 0.4)
    Tween(FinalOverlay, "BackgroundTransparency", 1, 0.4)
    Tween(WelcomeLbl, "TextTransparency", 1, 0.4)
    Tween(StartBtn, "BackgroundTransparency", 1, 0.4)
    Tween(StartBtn, "TextTransparency", 1, 0.4)
    Tween(StartStroke, "Transparency", 1, 0.4)
    task.wait(0.5)
    IntroGui:Destroy()
    OpenBtn.Visible = true
    Menu.Visible = true
    safeNotify("Lansher~Hub", "v8.0 جاهز 🛡️", "success", 3)
    task.wait(0.7)
    safeNotify("الأوامر", #ALL_COMMANDS .. " أمر جاهز", "info", 2)
end)

--══════════════════════════════════════════════════════════════════
-- INIT
--══════════════════════════════════════════════════════════════════
task.spawn(function()
    playIntro()
end)

print("[Lansher~Hub v8.0] Loaded.")
