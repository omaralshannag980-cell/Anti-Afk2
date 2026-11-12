--══════════════════════════════════════════════════════════════
--  LANSHER~HUB · v7.0
--  هيكل Lansher Hub v5.1 + صور جديدة + انترو fullscreen
--══════════════════════════════════════════════════════════════
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")
local Workspace        = game:GetService("Workspace")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--══════════════════════════════════════════════════════════════
--  ★ ASSET IDs ★
--══════════════════════════════════════════════════════════════
local A = {
    intro1 = "rbxassetid://138270086550975",
    intro2 = "rbxassetid://106762064444203",
    intro3 = "rbxassetid://117909885869841",
    intro4 = "rbxassetid://123598571664419",
    intro5 = "rbxassetid://93820894136588",   -- الأخيرة

    uiBg   = "rbxassetid://123598571664419",
    toggle = "rbxassetid://117909885869841",
}

--══════════════ SCRIPTS ══════════════
local S = {
    zeco   = "https://pastefy.app/mXMaE9fC/raw",
    askar  = "https://rawscripts.net/raw/Brookhaven-RP-3skr-hub-240894",
    jaheem = "https://gist.githubusercontent.com/adamoalihossen-lang/1fcc9f47858217b73c7d21396347ee41/raw",
    hokoma = "https://pastebin.com/raw/FMC7ZWsw",
    ansari = "https://gist.githubusercontent.com/Yemenx/e976b6c7c681e67ebe0f31f88ebb6ac6/raw/536a222c673c23ba43ebe29dfcc29a53c8808eea/ANSRY.YAMEN.VAMPAIRE.lua",
    abuOtb = "https://gist.githubusercontent.com/yhmwd406-boop/2dd250fe58d63fabee981b085afc10c5/raw/8bf78e204f3f04cac8bea68e887a95f41c8b81c4/%25D8%25B3%25D9%2583%25D8%25B1%25D8%25A8%25D8%25AA%2520%25D8%25B9%25D8%25AF%25D8%25A7%25D8%25A7%25D8%25AA",
    darko  = "https://rawscripts.net/raw/Universal-Script-Zenix-all-on-one-240296",
    no9    = "https://rawscripts.net/raw/Universal-Script-NO9AT-SAMLAT-47637",
    azzam  = "https://rawscripts.net/raw/Brookhaven-RP-3azaam-hub-224262",
    mickey = "https://rawscripts.net/raw/Brookhaven-RP-Mickey-Chat-85762",
    rexm   = "https://rawscripts.net/raw/Brookhaven-RP-REXM-206004",
    abd    = "https://rawscripts.net/raw/Universal-Script-ABD-HUB-PRO-238979",
    flying = "https://rawscripts.net/raw/Universal-Script-Flying-55336",
    jg     = "https://rawscripts.net/raw/Brookhaven-RP-New-Update-Script-JG-Brookhaven-93130",
    ravex  = "https://rawscripts.net/raw/Brookhaven-RP-RAVEX-HUB-ARAB-NOW-86210",
}

--══════════════ INFINITE ══════════════
local INFINITE_URL = ""
local CMD_PREFIX   = "/"

local _infiniteReady = false
local function ensureInfinite()
    if _infiniteReady then return true end
    if INFINITE_URL ~= "" then
        local ok = pcall(function()
            loadstring(game:HttpGet(INFINITE_URL))()
        end)
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

--══════════════ COLORS (من Lansher Hub الأصلي) ══════════════
local CFG = {
    Hub_Name    = "Lansher~Hub",
    Hub_Version = "v7.0",
    Toggle_Key  = Enum.KeyCode.RightShift,

    Cor_Hub     = Color3.fromRGB(15, 15, 15),
    Cor_Options = Color3.fromRGB(28, 28, 28),
    Cor_Stroke  = Color3.fromRGB(255, 50, 50),
    Cor_Text    = Color3.fromRGB(255, 255, 255),
    Cor_Dark    = Color3.fromRGB(150, 150, 150),
    Cor_Success = Color3.fromRGB(50, 220, 130),
    Cor_Warn    = Color3.fromRGB(255, 180, 50),
    Cor_Error   = Color3.fromRGB(255, 70, 70),

    Font   = Enum.Font.FredokaOne,
    Corner = UDim.new(0, 12),
}
local C = CFG

--══════════════ HELPERS (من Lansher Hub) ══════════════
local function Create(cls, parent, props)
    local o = Instance.new(cls, parent)
    if props then for k, v in pairs(props) do o[k] = v end end
    return o
end

local function Corner(parent, radius)
    local c = Instance.new("UICorner", parent)
    c.CornerRadius = radius or CFG.Corner
    return c
end

local function Stroke(parent)
    local s = Instance.new("UIStroke", parent)
    s.Color = CFG.Cor_Stroke
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Thickness = 2
    return s
end

local function Tween(obj, prop, value, time, wait)
    local t = TweenService:Create(obj, TweenInfo.new(time or 0.2), {[prop] = value})
    t:Play()
    if wait then t.Completed:Wait() end
    return t
end

--══════════════ NOTIFICATIONS (من Lansher Hub) ══════════════
local function Notify(title, text, kind, dur)
    local gui = CoreGui:FindFirstChild("LansherNotifs")
    if not gui then
        gui = Create("ScreenGui", CoreGui, {Name = "LansherNotifs", ResetOnSpawn = false, DisplayOrder = 999})
        local frame = Create("Frame", gui, {
            Size = UDim2.new(0, 260, 1, -20),
            Position = UDim2.new(1, -270, 0, 10),
            BackgroundTransparency = 1,
        })
        Create("UIListLayout", frame, {Padding = UDim.new(0, 6), VerticalAlignment = Enum.VerticalAlignment.Bottom})
    end
    local container = gui:FindFirstChildOfClass("Frame")
    local colors = {info = CFG.Cor_Stroke, success = CFG.Cor_Success, warn = CFG.Cor_Warn, error = CFG.Cor_Error}
    local col = colors[kind] or colors.info

    local n = Create("Frame", container, {
        Size = UDim2.new(1, 0, 0, 56),
        BackgroundColor3 = CFG.Cor_Hub,
        BorderSizePixel = 0,
    })
    Corner(n)
    local accent = Create("Frame", n, {Size = UDim2.new(0, 4, 1, 0), BackgroundColor3 = col, BorderSizePixel = 0})
    Corner(accent, UDim.new(1, 0))
    Create("TextLabel", n, {
        Size = UDim2.new(1, -20, 0, 20), Position = UDim2.new(0, 10, 0, 6),
        BackgroundTransparency = 1, Text = title, TextColor3 = CFG.Cor_Text,
        Font = CFG.Font, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
    })
    Create("TextLabel", n, {
        Size = UDim2.new(1, -20, 0, 26), Position = UDim2.new(0, 10, 0, 26),
        BackgroundTransparency = 1, Text = text, TextColor3 = col,
        Font = CFG.Font, TextSize = 11, TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    task.delay(dur or 3, function()
        Tween(n, "BackgroundTransparency", 1, 0.3)
        for _, c in ipairs(n:GetChildren()) do
            if c:IsA("TextLabel") then Tween(c, "TextTransparency", 1, 0.3) end
        end
        task.wait(0.35)
        n:Destroy()
    end)
end

local function safeNotify(t, txt, k, d) pcall(Notify, t, txt, k, d) end

--══════════════ SCRIPT RUNNER ══════════════
local function runURL(btn, url, originalText)
    if not url or url == "" then
        btn.Text = "— الرابط غير متوفر —"
        btn.BackgroundColor3 = CFG.Cor_Warn
        task.wait(1.5)
        btn.Text = originalText
        btn.BackgroundColor3 = CFG.Cor_Options
        return
    end
    btn.Text = "جارٍ التحميل..."
    local ok, err = pcall(function()
        local src = game:HttpGet(url)
        local fn = loadstring(src)
        if not fn then error("loadstring فشل") end
        fn()
    end)
    if ok then
        btn.Text = "✓ تم التشغيل"
        btn.BackgroundColor3 = CFG.Cor_Success
        safeNotify("Lansher", originalText .. " اشتغل", "success", 2)
    else
        btn.Text = "✗ " .. tostring(err):sub(1, 25)
        btn.BackgroundColor3 = CFG.Cor_Error
        safeNotify("خطأ", tostring(err):sub(1, 60), "error", 3)
    end
    task.wait(1.6)
    btn.Text = originalText
    btn.BackgroundColor3 = CFG.Cor_Options
end

--══════════════ INTRO (fullscreen) ══════════════
local SEQ  = { A.intro1, A.intro2, A.intro3, A.intro4 }
local FINAL_IMG = A.intro5
local HOLD, FADE = 2.0, 0.35

local introGui = Create("ScreenGui", CoreGui, {
    Name = "LansherIntro",
    IgnoreGuiInset = true,
    ResetOnSpawn = false,
    DisplayOrder = 9999,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})

-- خلفية سوداء كاملة تغطي كل الشاشة
local introBg = Create("Frame", introGui, {
    Size = UDim2.fromScale(1, 1),
    Position = UDim2.fromScale(0, 0),
    BackgroundColor3 = Color3.new(0, 0, 0),
    BorderSizePixel = 0,
    ZIndex = 1,
})

-- الصورة على كامل الشاشة (Crop = تعبي كل الشاشة بدون حدود)
local introImg = Create("ImageLabel", introGui, {
    Size = UDim2.fromScale(1, 1),
    Position = UDim2.fromScale(0, 0),
    BackgroundTransparency = 1,
    ScaleType = Enum.ScaleType.Crop,
    ZIndex = 2,
})

local function tw(o, t, p)
    local t1 = TweenService:Create(o, TweenInfo.new(t), p)
    t1:Play(); return t1
end

local function playIntro()
    for i, id in ipairs(SEQ) do
        introImg.Image = id
        introImg.ImageTransparency = 0
        task.wait(HOLD)
        if i < #SEQ then
            tw(introImg, FADE, { ImageTransparency = 1 })
            task.wait(FADE)
        end
    end
    introImg.Image = FINAL_IMG
    introImg.ImageTransparency = 0
    task.wait(HOLD)
    tw(introImg, FADE, { ImageTransparency = 1 })
    task.wait(FADE)
    tw(introBg, 0.4, { BackgroundTransparency = 1 })
    task.wait(0.4)
    introGui:Destroy()
end

--══════════════ MAIN GUI (نفس هيكل Lansher Hub) ══════════════
local oldGui = CoreGui:FindFirstChild("LansherHubXR7")
if oldGui then oldGui:Destroy() end

local ScreenGui = Create("ScreenGui", CoreGui, {
    Name = "LansherHubXR7",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})

-- زر الفتح (يستخدم صورة التوجل الجديدة)
local OpenBtn = Create("ImageButton", ScreenGui, {
    Size = UDim2.fromOffset(55, 55),
    Position = UDim2.new(0, 30, 0.5, -27),
    BackgroundColor3 = CFG.Cor_Options,
    Image = A.toggle,
    AutoButtonColor = false,
})
Corner(OpenBtn, UDim.new(1, 0))
Stroke(OpenBtn)

-- النافذة الرئيسية
local Menu = Create("Frame", ScreenGui, {
    Size = UDim2.fromOffset(560, 460),
    Position = UDim2.new(0.5, -280, 0.5, -230),
    BackgroundColor3 = CFG.Cor_Hub,
    Visible = false,
    Active = true,
    Draggable = true,
})
Corner(Menu)
Stroke(Menu)

-- صورة الخلفية تحت التابات
local bgImg = Create("ImageLabel", Menu, {
    Size = UDim2.fromScale(1, 1),
    Position = UDim2.fromScale(0, 0),
    BackgroundTransparency = 1,
    ScaleType = Enum.ScaleType.Crop,
    Image = A.uiBg,
    ImageTransparency = 0.5,
    ZIndex = 1,
})
Corner(bgImg)

local bgOverlay = Create("Frame", Menu, {
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.new(0, 0, 0),
    BackgroundTransparency = 0.5,
    BorderSizePixel = 0,
    ZIndex = 1,
})
Corner(bgOverlay)

-- شريط العنوان
local TopBar = Create("Frame", Menu, {Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, ZIndex = 5})
Create("TextLabel", TopBar, {
    Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 10, 0, 0),
    BackgroundTransparency = 1, Text = CFG.Hub_Name .. "  " .. CFG.Hub_Version,
    TextColor3 = CFG.Cor_Stroke, Font = CFG.Font, TextSize = 17,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5,
})
local CloseBtn = Create("TextButton", TopBar, {
    Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(1, -35, 0, 0),
    BackgroundTransparency = 1, Text = "×", TextColor3 = CFG.Cor_Text,
    Font = CFG.Font, TextSize = 22, ZIndex = 5,
})
CloseBtn.MouseButton1Click:Connect(function() Menu.Visible = false end)
OpenBtn.MouseButton1Click:Connect(function() Menu.Visible = not Menu.Visible end)

-- التابات (عمود يسار مثل Lansher Hub الأصلي)
local TabFrame = Create("Frame", Menu, {
    Size = UDim2.new(0, 150, 1, -30), Position = UDim2.new(0, 0, 0, 30),
    BackgroundColor3 = CFG.Cor_Options,
    BackgroundTransparency = 0.15,
    ZIndex = 2,
})
Corner(TabFrame)
Create("UIListLayout", TabFrame, {Padding = UDim.new(0, 4)})
Create("UIPadding", TabFrame, {
    PaddingTop = UDim.new(0, 8),
    PaddingLeft = UDim.new(0, 8),
    PaddingRight = UDim.new(0, 8),
})

local Content = Create("Frame", Menu, {
    Size = UDim2.new(1, -150, 1, -30), Position = UDim2.new(0, 150, 0, 30),
    BackgroundTransparency = 1,
    ZIndex = 3,
})

local tabs = {}
local function MakeTab(name)
    local btn = Create("TextButton", TabFrame, {
        Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = CFG.Cor_Hub,
        Text = name, TextColor3 = CFG.Cor_Text, Font = CFG.Font, TextSize = 13,
        AutoButtonColor = false, ZIndex = 4,
    })
    Corner(btn)
    local frame = Create("ScrollingFrame", Content, {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
        ScrollBarThickness = 4, CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false,
        ZIndex = 4,
    })
    Create("UIPadding", frame, {
        PaddingTop = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 8),
    })
    Create("UIListLayout", frame, {Padding = UDim.new(0, 5)})
    btn.MouseButton1Click:Connect(function()
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

--══════════════ WIDGETS (من Lansher Hub) ══════════════
local function AddButton(parent, name, callback)
    local btn = Create("TextButton", parent, {
        Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = CFG.Cor_Options,
        Text = "  " .. name, TextColor3 = CFG.Cor_Text, Font = CFG.Font,
        TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right, AutoButtonColor = false,
        ZIndex = 5,
    })
    Corner(btn)
    Stroke(btn)
    local pad = Create("UIPadding", btn, {PaddingRight = UDim.new(0, 10)})
    btn.MouseButton1Click:Connect(function() pcall(callback) end)
    return btn
end

local function AddLabel(parent, text)
    return Create("TextLabel", parent, {
        Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1,
        Text = "  ◆ " .. text, TextColor3 = CFG.Cor_Stroke,
        Font = CFG.Font, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right,
        ZIndex = 5,
    })
end

--══════════════ TAB 1: الحقوق ══════════════
AddLabel(TabRights, "هذا السكربت خاص بـ Lansher~Hub")

local copyBtn = AddButton(TabRights, "w_.0.10    (اضغط للنسخ)", function()
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

--══════════════ TAB 2: سكربتاتي ══════════════
AddLabel(TabScripts, "السكربتات العربية")
AddButton(TabScripts, "سكربت زيكو",         function() loadstring(game:HttpGet(S.zeco))() end)
AddButton(TabScripts, "سكربت عسكر",         function() loadstring(game:HttpGet(S.askar))() end)
AddButton(TabScripts, "سكربت جحيم الأساسي", function() loadstring(game:HttpGet(S.jaheem))() end)
AddButton(TabScripts, "سكربت حكومة",        function() loadstring(game:HttpGet(S.hokoma))() end)
AddButton(TabScripts, "سكربت انصاري",       function() loadstring(game:HttpGet(S.ansari))() end)
AddButton(TabScripts, "سكربت أبو عتب",      function() loadstring(game:HttpGet(S.abuOtb))() end)
AddButton(TabScripts, "سكربت داركو",        function() loadstring(game:HttpGet(S.darko))() end)
AddButton(TabScripts, "سكربت نقاط مراد",    function() loadstring(game:HttpGet(S.no9))() end)

AddLabel(TabScripts, "سكربتات بروك هافن")
AddButton(TabScripts, "عزام",         function() loadstring(game:HttpGet(S.azzam))() end)
AddButton(TabScripts, "ميكي شات",     function() loadstring(game:HttpGet(S.mickey))() end)
AddButton(TabScripts, "REXM",         function() loadstring(game:HttpGet(S.rexm))() end)
AddButton(TabScripts, "ABD HUB",      function() loadstring(game:HttpGet(S.abd))() end)
AddButton(TabScripts, "طيران عدنان",  function() loadstring(game:HttpGet(S.flying))() end)
AddButton(TabScripts, "JG",           function() loadstring(game:HttpGet(S.jg))() end)
AddButton(TabScripts, "رافكس",        function() loadstring(game:HttpGet(S.ravex))() end)

--══════════════ TAB 3: أوامر ══════════════
AddLabel(TabCommands, "الأوامر الـ" .. #ALL_COMMANDS .. " (عبر infinite)")

local cmdListLabel = AddLabel(TabCommands, table.concat(ALL_COMMANDS, "  •  "))

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

--══════════════ TAB 4: تقليل لاج ══════════════
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

--══════════════ TAB 5: استهداف ══════════════
AddLabel(TabTarget, "سكربتات استهداف")
AddButton(TabTarget, "NO9AT SAMLAT", function() loadstring(game:HttpGet(S.no9))() end)
AddButton(TabTarget, "Samlat",       function() loadstring(game:HttpGet(S.no9))() end)
AddButton(TabTarget, "تسجيل سلندر",  function() safeNotify("تنبيه", "الرابط غير مضاف", "warn", 2) end)
AddButton(TabTarget, "تسجيل نووي",   function() safeNotify("تنبيه", "الرابط غير مضاف", "warn", 2) end)

--══════════════ KEYBIND ══════════════
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == CFG.Toggle_Key then
        Menu.Visible = not Menu.Visible
    end
end)

--══════════════ INIT ══════════════
task.spawn(function()
    playIntro()
    OpenBtn.Visible = true
    Menu.Visible = true
    safeNotify("Lansher~Hub", "v7.0 جاهز 🛡️", "success", 3)
    task.wait(0.7)
    safeNotify("الأوامر", #ALL_COMMANDS .. " أمر جاهز", "info", 2)
    task.wait(0.7)
    safeNotify("Toggle", "RightShift أو الزر الدائري", "info", 2)
end)

print("[Lansher~Hub v7.0] Loaded.")
