--══════════════════════════════════════════════════════════════
--  REDZ HUB · v6.2  (Intro + Tabs + Infinite Commands)
--══════════════════════════════════════════════════════════════
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace        = game:GetService("Workspace")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--══════════════════════════════════════════════════════════════
--  ★★★ ASSET IDs — كل IDs الصور هنا ★★★
--══════════════════════════════════════════════════════════════
local A = {
    -- صور الانترو (تظهر بالتتابع كل ثانيتين)
    intro1     = "rbxassetid://128405788519714",
    intro2     = "rbxassetid://133456528236109",
    intro3     = "rbxassetid://92480531337183",
    intro4     = "rbxassetid://122082194057129",
    intro5     = "rbxassetid://96392873626158",
    introFinal = "rbxassetid://121408431763185",  -- الصورة الأخيرة (تطلع ثانيتين)

    -- ★ خلفية الواجهة الرئيسية
    uiBg       = "rbxassetid://96392873626158",
    -- ★ صورة الزر الدائري (التوجل)
    toggle     = "rbxassetid://128405788519714",
}
--══════════════════════════════════════════════════════════════

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

--══════════════ INFINITE CONFIG ══════════════
local INFINITE_URL = ""   -- ← رابط سكربت infinite
local CMD_PREFIX   = "/"  -- ← بادئة الأوامر

local _infiniteReady = false
local function ensureInfinite()
    if _infiniteReady then return true end
    if INFINITE_URL ~= "" and not INFINITE_URL:find("PUT_") then
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
    "2022materials",
    "clearerror",
    "backtrack nan",
    "antiafk",
    "antikick",
    "datalimit 660",
    "backtrack 999",
    "xray",
    "antilag",
    "autokeypress nan",
    "autokeypress",
    "nofog",
}

--══════════════ COLORS / FONTS ══════════════
local C = {
    bg     = Color3.fromRGB(15, 15, 15),
    panel  = Color3.fromRGB(26, 26, 28),
    btn    = Color3.fromRGB(36, 36, 40),
    accent = Color3.fromRGB(220, 40, 60),
    text   = Color3.fromRGB(240, 240, 245),
    sub    = Color3.fromRGB(150, 150, 160),
    ok     = Color3.fromRGB(50, 220, 130),
    err    = Color3.fromRGB(255, 70, 70),
    warn   = Color3.fromRGB(255, 180, 50),
}
local FONT_B = Enum.Font.GothamBold
local FONT_R = Enum.Font.Gotham

--══════════════ HELPERS ══════════════
local function corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = p
    return c
end

local function stroke(p, col, th)
    local s = Instance.new("UIStroke", p)
    s.Color = col or C.accent
    s.Thickness = th or 1.5
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return s
end

local function label(parent, text, size, pos, col, bold, align)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.Size, l.Position = size, pos
    l.Text = text
    l.TextColor3 = col or C.text
    l.Font = bold and FONT_B or FONT_R
    l.TextSize = 15
    l.TextXAlignment = align or Enum.TextXAlignment.Right
    l.TextWrapped = true
    l.ZIndex = 4
    l.Parent = parent
    return l
end

--══════════════ NOTIFICATIONS ══════════════
local notifGui
local function Notify(title, text, kind)
    if not notifGui then
        notifGui = Instance.new("ScreenGui")
        notifGui.Name = "RedzNotifs"
        notifGui.ResetOnSpawn = false
        notifGui.DisplayOrder = 999
        notifGui.IgnoreGuiInset = true
        notifGui.Parent = playerGui
        local f = Instance.new("Frame")
        f.Size = UDim2.new(0, 280, 1, -20)
        f.Position = UDim2.new(1, -290, 0, 10)
        f.BackgroundTransparency = 1
        f.Parent = notifGui
        local lay = Instance.new("UIListLayout")
        lay.Padding = UDim.new(0, 6)
        lay.VerticalAlignment = Enum.VerticalAlignment.Bottom
        lay.Parent = f
    end
    local container = notifGui:FindFirstChildOfClass("Frame")
    local cols = { info = C.accent, success = C.ok, warn = C.warn, error = C.err }
    local col = cols[kind] or C.accent

    local n = Instance.new("Frame")
    n.Size = UDim2.new(1, 0, 0, 58)
    n.BackgroundColor3 = C.bg
    n.BorderSizePixel = 0
    n.Parent = container
    corner(n, 8)
    stroke(n, col, 1)

    local acc = Instance.new("Frame")
    acc.Size = UDim2.new(0, 4, 1, 0)
    acc.BackgroundColor3 = col
    acc.BorderSizePixel = 0
    acc.Parent = n
    corner(acc, 999)

    label(n, title, UDim2.new(1, -20, 0, 20), UDim2.new(0, 10, 0, 6), C.text, true, Enum.TextXAlignment.Left).TextSize = 13
    local d = label(n, text, UDim2.new(1, -20, 0, 28), UDim2.new(0, 10, 0, 26), col, false, Enum.TextXAlignment.Left)
    d.TextSize = 11

    task.delay(3, function()
        TweenService:Create(n, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()
        TweenService:Create(d, TweenInfo.new(0.3), { TextTransparency = 1 }):Play()
        task.wait(0.35)
        n:Destroy()
    end)
end

--══════════════ SCRIPT RUNNER ══════════════
local function runURL(btn, url, originalText)
    if not url or url == "" then
        btn.Text = "— الرابط غير متوفر —"
        btn.BackgroundColor3 = C.warn
        task.wait(1.5)
        btn.Text = originalText
        btn.BackgroundColor3 = C.btn
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
        btn.BackgroundColor3 = C.ok
        Notify("Redz", originalText .. " اشتغل", "success")
    else
        btn.Text = "✗ " .. tostring(err):sub(1, 25)
        btn.BackgroundColor3 = C.err
        Notify("خطأ", tostring(err):sub(1, 60), "error")
    end
    task.wait(1.6)
    btn.Text = originalText
    btn.BackgroundColor3 = C.btn
end

--══════════════ INTRO ══════════════
local SEQ  = { A.intro1, A.intro2, A.intro3, A.intro4, A.intro5 }
local HOLD, FADE = 2.0, 0.35

local introGui = Instance.new("ScreenGui")
introGui.Name = "RedzIntro"
introGui.IgnoreGuiInset = true
introGui.ResetOnSpawn = false
introGui.DisplayOrder = 999
introGui.Parent = playerGui

local introFrame = Instance.new("Frame")
introFrame.Size = UDim2.fromScale(1, 1)
introFrame.BackgroundColor3 = Color3.new(0, 0, 0)
introFrame.BorderSizePixel = 0
introFrame.Parent = introGui

local introImg = Instance.new("ImageLabel")
introImg.Size = UDim2.fromScale(1, 1)
introImg.BackgroundTransparency = 1
introImg.ScaleType = Enum.ScaleType.Fit
introImg.Parent = introFrame

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
    introImg.Image = A.introFinal
    introImg.ImageTransparency = 0
    task.wait(HOLD)
    tw(introImg, FADE, { ImageTransparency = 1 })
    task.wait(FADE)
    tw(introFrame, 0.4, { BackgroundTransparency = 1 })
    task.wait(0.4)
    introGui:Destroy()
end

--══════════════ MAIN GUI ══════════════
local gui = Instance.new("ScreenGui")
gui.Name = "RedzHubGui"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.DisplayOrder = 100
gui.Parent = playerGui

local win = Instance.new("Frame")
win.Size = UDim2.fromOffset(760, 500)
win.Position = UDim2.new(0.5, -380, 0.5, -250)
win.BackgroundColor3 = C.bg
win.BorderSizePixel = 0
win.ClipsDescendants = true
win.Visible = false
win.Active = true
win.Parent = gui
corner(win, 12)
stroke(win, C.accent, 2)

-- خلفية الواجهة (من A.uiBg)
local bgImg = Instance.new("ImageLabel")
bgImg.Size = UDim2.fromScale(1, 1)
bgImg.BackgroundTransparency = 1
bgImg.ScaleType = Enum.ScaleType.Stretch
bgImg.Image = A.uiBg
bgImg.ImageTransparency = 0.35
bgImg.ZIndex = 1
bgImg.Parent = win
corner(bgImg, 12)

-- عنوان Redz Hub
local titleBar = Instance.new("TextLabel")
titleBar.Size = UDim2.new(1, -20, 0, 26)
titleBar.Position = UDim2.new(0, 10, 0, 4)
titleBar.BackgroundTransparency = 1
titleBar.Text = "REDZ HUB  ·  v6.2"
titleBar.TextColor3 = C.accent
titleBar.Font = FONT_B
titleBar.TextSize = 16
titleBar.TextXAlignment = Enum.TextXAlignment.Left
titleBar.ZIndex = 6
titleBar.Parent = win

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 175, 1, -30)
sidebar.Position = UDim2.new(0, 0, 0, 30)
sidebar.BackgroundColor3 = C.panel
sidebar.BackgroundTransparency = 0.15
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 2
sidebar.Parent = win
corner(sidebar, 12)

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -175, 1, -30)
content.Position = UDim2.new(0, 175, 0, 30)
content.BackgroundTransparency = 1
content.ZIndex = 2
content.Parent = win

--══════════════ WIDGETS ══════════════
local function makeBtn(parent, text, y, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -16, 0, 34)
    b.Position = UDim2.new(0, 8, 0, y)
    b.BackgroundColor3 = C.btn
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = C.text
    b.Font = FONT_B
    b.TextSize = 13
    b.TextXAlignment = Enum.TextXAlignment.Right
    b.AutoButtonColor = false
    b.ZIndex = 4
    b.Parent = parent
    corner(b, 7)
    stroke(b, C.accent, 1)
    local pad = Instance.new("UIPadding")
    pad.PaddingRight = UDim.new(0, 10)
    pad.Parent = b
    b.MouseButton1Click:Connect(cb)
    return b
end

--══════════════ TAB 1: الحقوق ══════════════
local function buildRights(p)
    local t = label(p, "~ الحقوق ~", UDim2.new(1, -20, 0, 32), UDim2.new(0, 10, 0, 12), C.accent, true)
    t.TextSize = 22

    label(p, "هذا السكربت خاص بـ Redz Hub", UDim2.new(1, -20, 0, 24), UDim2.new(0, 10, 0, 52), C.sub, false)

    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(260, 50)
    b.Position = UDim2.new(0, 10, 0, 90)
    b.BackgroundColor3 = C.btn
    b.BorderSizePixel = 0
    b.Text = "w_.0.10    (اضغط للنسخ)"
    b.TextColor3 = C.text
    b.Font = FONT_B
    b.TextSize = 16
    b.AutoButtonColor = false
    b.ZIndex = 4
    b.Parent = p
    corner(b, 10)
    stroke(b, C.accent, 1.5)

    b.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard("w_.0.10")
            b.Text = "✓ تم النسخ للحافظة"
            b.BackgroundColor3 = C.ok
            Notify("نسخ", "w_.0.10 تم نسخه", "success")
            task.wait(1.4)
            b.Text = "w_.0.10    (اضغط للنسخ)"
            b.BackgroundColor3 = C.btn
        else
            b.Text = "setclipboard غير متاح"
            task.wait(1.4)
            b.Text = "w_.0.10    (اضغط للنسخ)"
        end
    end)
end

--══════════════ TAB 2: سكربتاتي ══════════════
local function buildMyScripts(p)
    local t = label(p, "~ سكربتاتي ~", UDim2.new(1, -20, 0, 32), UDim2.new(0, 10, 0, 12), C.accent, true)
    t.TextSize = 22

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -20, 1, -60)
    scroll.Position = UDim2.new(0, 10, 0, 52)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.CanvasSize = UDim2.new()
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.ZIndex = 4
    scroll.Parent = p
    local lay = Instance.new("UIListLayout")
    lay.Padding = UDim.new(0, 6)
    lay.Parent = scroll

    local list = {
        { "سكربت زيكو",         S.zeco },
        { "سكربت عسكر",         S.askar },
        { "سكربت جحيم الأساسي", S.jaheem },
        { "سكربت حكومة",        S.hokoma },
        { "سكربت انصاري",       S.ansari },
        { "سكربت أبو عتب",      S.abuOtb },
        { "سكربت داركو",        S.darko },
        { "سكربت نقاط مراد",    S.no9 },
        { "— بروك: عزام",       S.azzam },
        { "— بروك: ميكي شات",   S.mickey },
        { "— بروك: REXM",       S.rexm },
        { "— بروك: ABD HUB",    S.abd },
        { "— بروك: طيران عدنان", S.flying },
        { "— بروك: JG",         S.jg },
        { "— بروك: رافكس",      S.ravex },
    }

    for _, item in ipairs(list) do
        local name, url = item[1], item[2]
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, -6, 0, 34)
        b.BackgroundColor3 = C.btn
        b.BorderSizePixel = 0
        b.Text = name
        b.TextColor3 = C.text
        b.Font = FONT_B
        b.TextSize = 13
        b.TextXAlignment = Enum.TextXAlignment.Right
        b.AutoButtonColor = false
        b.ZIndex = 4
        b.Parent = scroll
        corner(b, 7)
        stroke(b, C.accent, 1)
        local pad = Instance.new("UIPadding")
        pad.PaddingRight = UDim.new(0, 10)
        pad.Parent = b
        b.MouseButton1Click:Connect(function() runURL(b, url, name) end)
    end
end

--══════════════ TAB 3: أوامر ══════════════
local function buildCommands(p)
    local t = label(p, "~ أوامر ~", UDim2.new(1, -20, 0, 32), UDim2.new(0, 10, 0, 12), C.accent, true)
    t.TextSize = 22

    local sub = label(p, "الأوامر اللي راح تنفعل عبر infinite:", UDim2.new(1, -20, 0, 22), UDim2.new(0, 10, 0, 52), C.sub, false)
    sub.TextSize = 13

    local listScroll = Instance.new("ScrollingFrame")
    listScroll.Size = UDim2.new(1, -20, 0, 200)
    listScroll.Position = UDim2.new(0, 10, 0, 78)
    listScroll.BackgroundColor3 = C.panel
    listScroll.BackgroundTransparency = 0.3
    listScroll.BorderSizePixel = 0
    listScroll.ScrollBarThickness = 4
    listScroll.CanvasSize = UDim2.new()
    listScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    listScroll.ZIndex = 4
    listScroll.Parent = p
    corner(listScroll, 8)
    stroke(listScroll, C.accent, 1)

    local lp = Instance.new("UIPadding")
    lp.PaddingTop = UDim.new(0, 6)
    lp.PaddingLeft = UDim.new(0, 10)
    lp.PaddingRight = UDim.new(0, 10)
    lp.PaddingBottom = UDim.new(0, 6)
    lp.Parent = listScroll

    local lay = Instance.new("UIListLayout")
    lay.Padding = UDim.new(0, 4)
    lay.Parent = listScroll

    for _, cmd in ipairs(ALL_COMMANDS) do
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, 0, 0, 22)
        l.BackgroundTransparency = 1
        l.Text = "▸ " .. cmd
        l.TextColor3 = C.text
        l.Font = FONT_R
        l.TextSize = 13
        l.TextXAlignment = Enum.TextXAlignment.Right
        l.ZIndex = 4
        l.Parent = listScroll
    end

    local activateBtn = makeBtn(p, "تفعيل الاوامر", 290, function()
        ensureInfinite()
        activateBtn.Text = "جارٍ..."
        activateBtn.BackgroundColor3 = C.warn
        task.spawn(function()
            for i, cmd in ipairs(ALL_COMMANDS) do
                fireCmd(cmd)
                activateBtn.Text = "تنفيذ " .. i .. "/" .. #ALL_COMMANDS .. " • " .. cmd
                task.wait(0.4)
            end
            activateBtn.Text = "✓ تم تفعيل " .. #ALL_COMMANDS .. " أمر"
            activateBtn.BackgroundColor3 = C.ok
            Notify("Redz", "تم إرسال جميع الأوامر", "success")
            task.wait(2.5)
            activateBtn.Text = "تفعيل الاوامر"
            activateBtn.BackgroundColor3 = C.btn
        end)
    end)
    activateBtn.Size = UDim2.new(1, -20, 0, 44)
    activateBtn.Position = UDim2.new(0, 10, 0, 290)
end

--══════════════ TAB 4: تقليل لاج ══════════════
local function buildAntiLag(p)
    local t = label(p, "~ تقليل لاج ~", UDim2.new(1, -20, 0, 32), UDim2.new(0, 10, 0, 12), C.accent, true)
    t.TextSize = 22

    local sub = label(p, "ينفعل عبر سكربت infinite:", UDim2.new(1, -20, 0, 22), UDim2.new(0, 10, 0, 52), C.sub, false)
    sub.TextSize = 13

    local cmds = label(p, "▸ xray     ▸ antilag", UDim2.new(1, -20, 0, 24), UDim2.new(0, 10, 0, 78), C.text, true)
    cmds.TextSize = 14

    local b = makeBtn(p, "تفعيل تقليل اللاج", 110, function()
        ensureInfinite()
        b.Text = "جارٍ..."
        b.BackgroundColor3 = C.warn
        task.spawn(function()
            fireCmd("xray")
            task.wait(0.5)
            fireCmd("antilag")
            task.wait(0.5)
            b.Text = "✓ Xray + AntiLag مفعّل"
            b.BackgroundColor3 = C.ok
            Notify("Redz", "تم إرسال xray + antilag", "success")
            task.wait(1.8)
            b.Text = "تفعيل تقليل اللاج"
            b.BackgroundColor3 = C.btn
        end)
    end)
    b.Size = UDim2.new(1, -20, 0, 44)
    b.Position = UDim2.new(0, 10, 0, 110)
end

--══════════════ TAB 5: سكربتات استهداف ══════════════
local function buildTargeting(p)
    local t = label(p, "~ سكربتات استهداف ~", UDim2.new(1, -20, 0, 32), UDim2.new(0, 10, 0, 12), C.accent, true)
    t.TextSize = 22

    local list = {
        { "NO9AT SAMLAT", S.no9 },
        { "Samlat",       S.no9 },
        { "تسجيل سلندر",  "" },
        { "تسجيل نووي",   "" },
    }

    local y = 52
    for _, item in ipairs(list) do
        local name, url = item[1], item[2]
        local b = makeBtn(p, name, y, function() runURL(b, url, name) end)
        b.Size = UDim2.new(1, -20, 0, 42)
        y = y + 48
    end

    label(p, "* سلندر ونووي: أرسل روابطهم وأدمجها فوراً",
          UDim2.new(1, -20, 0, 30), UDim2.new(0, 10, 0, y + 6), C.sub, false)
end

--══════════════ TABS BUILD ══════════════
local TABS = {
    { name = "~الحقوق~",          build = buildRights },
    { name = "~سكربتاتي~",        build = buildMyScripts },
    { name = "~أوامر~",           build = buildCommands },
    { name = "~تقليل لاج~",       build = buildAntiLag },
    { name = "~سكربتات استهداف~", build = buildTargeting },
}

local tabBtns, tabFrames = {}, {}
for i, tab in ipairs(TABS) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -12, 0, 40)
    b.Position = UDim2.new(0, 6, 0, 8 + (i - 1) * 46)
    b.BackgroundColor3 = C.btn
    b.BackgroundTransparency = 0.35
    b.BorderSizePixel = 0
    b.Text = tab.name
    b.TextColor3 = C.text
    b.Font = FONT_B
    b.TextSize = 13
    b.AutoButtonColor = false
    b.ZIndex = 4
    b.Parent = sidebar
    corner(b, 8)
    stroke(b, C.accent, 1)
    tabBtns[i] = b

    local f = Instance.new("Frame")
    f.Size = UDim2.fromScale(1, 1)
    f.BackgroundTransparency = 1
    f.Visible = (i == 1)
    f.ZIndex = 3
    f.Parent = content
    tabFrames[i] = f
    tab.build(f)
end

local current = 1
tabBtns[1].BackgroundTransparency = 0.05
tabBtns[1].BackgroundColor3 = C.accent

local function switchTab(idx)
    if idx == current then return end
    tabFrames[current].Visible = false
    tabBtns[current].BackgroundTransparency = 0.35
    tabBtns[current].BackgroundColor3 = C.btn
    current = idx
    tabFrames[current].Visible = true
    tabBtns[current].BackgroundTransparency = 0.05
    tabBtns[current].BackgroundColor3 = C.accent
end
for i, b in ipairs(tabBtns) do
    b.MouseButton1Click:Connect(function() switchTab(i) end)
end

--══════════════ DRAGGABLE WINDOW ══════════════
do
    local dragging, dragStart, startPos = false, nil, nil
    local dragArea = Instance.new("Frame")
    dragArea.Size = UDim2.new(1, 0, 0, 28)
    dragArea.BackgroundTransparency = 1
    dragArea.ZIndex = 5
    dragArea.Parent = win

    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = win.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            local d = input.Position - dragStart
            win.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

--══════════════ TOGGLE ══════════════
local toggle = Instance.new("ImageButton")
toggle.Size = UDim2.fromOffset(60, 60)
toggle.Position = UDim2.new(1, -90, 1, -90)
toggle.BackgroundColor3 = C.panel
toggle.BackgroundTransparency = 0.15
toggle.Image = A.toggle
toggle.ScaleType = Enum.ScaleType.Fit
toggle.Visible = false
toggle.ZIndex = 10
toggle.Parent = gui
corner(toggle, 999)
stroke(toggle, C.accent, 2)

local tDrag, tMoved, tStart, tPos = false, false, nil, nil

toggle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        tDrag = true
        tMoved = false
        tStart = input.Position
        tPos = toggle.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not tDrag then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        local d = input.Position - tStart
        if d.Magnitude > 4 then tMoved = true end
        toggle.Position = UDim2.new(
            tPos.X.Scale, tPos.X.Offset + d.X,
            tPos.Y.Scale, tPos.Y.Offset + d.Y
        )
    end
end)

toggle.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        tDrag = false
        if not tMoved then
            win.Visible = not win.Visible
        end
    end
end)

--══════════════ INIT ══════════════
task.spawn(function()
    playIntro()
    toggle.Visible = true
    win.Visible = true
    Notify("REDZ HUB", "v6.2 جاهز 🛡️", "success")
    task.wait(0.8)
    Notify("الأوامر", "12 أمر جاهز عبر infinite", "info")
end)

print("[REDZ HUB v6.2] Loaded.")
