local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local MarketplaceService = game:GetService("MarketplaceService")

local Player = Players.LocalPlayer
if not Player then return end

local function getParent()
    if type(gethui) == "function" then
        local ok, result = pcall(gethui)
        if ok and result then return result end
    end

    local ok, result = pcall(function() return CoreGui end)
    if ok and result then return result end
    return Player:WaitForChild("PlayerGui")
end

local Parent = getParent()

local Env = (type(getgenv) == "function" and getgenv()) or _G
if type(Env.SEVEREUnload) == "function" then
    pcall(Env.SEVEREUnload)
end

local Connections = {}

local function Connect(signal, fn)
    local connection = signal:Connect(fn)
    table.insert(Connections, connection)
    return connection
end

for _, name in ipairs({"SEVEREUI", "SEVEREOverlay", "SEVEREParticles", "SEVEREWatermark", "SEVEREKeybindList", "ModernMobileControls"}) do
    local old = Parent:FindFirstChild(name)
    if old then old:Destroy() end
end

local Palettes = {
    Dark = {
        Background = Color3.fromRGB(12, 12, 16),
        Header = Color3.fromRGB(14, 14, 18),
        Panel = Color3.fromRGB(19, 19, 24),
        Element = Color3.fromRGB(28, 29, 36),
        Hover = Color3.fromRGB(38, 39, 49),
        Border = Color3.fromRGB(36, 37, 47),
        Blue = Color3.fromRGB(30, 125, 255),
        BlueDark = Color3.fromRGB(22, 58, 104),
        White = Color3.fromRGB(242, 243, 248),
        Muted = Color3.fromRGB(150, 153, 170),
        Dim = Color3.fromRGB(78, 80, 94),
        Off = Color3.fromRGB(36, 37, 46)
    },
    Light = {
        Background = Color3.fromRGB(240, 241, 246),
        Header = Color3.fromRGB(236, 237, 243),
        Panel = Color3.fromRGB(250, 250, 253),
        Element = Color3.fromRGB(230, 232, 239),
        Hover = Color3.fromRGB(219, 222, 232),
        Border = Color3.fromRGB(208, 211, 222),
        Blue = Color3.fromRGB(30, 125, 255),
        BlueDark = Color3.fromRGB(178, 210, 252),
        White = Color3.fromRGB(22, 24, 32),
        Muted = Color3.fromRGB(64, 68, 86),
        Dim = Color3.fromRGB(98, 102, 120),
        Off = Color3.fromRGB(206, 209, 220)
    },
    Midnight = {
        Background = Color3.fromRGB(10, 12, 24),
        Header = Color3.fromRGB(12, 14, 30),
        Panel = Color3.fromRGB(17, 20, 38),
        Element = Color3.fromRGB(26, 30, 54),
        Hover = Color3.fromRGB(36, 41, 70),
        Border = Color3.fromRGB(38, 44, 74),
        Blue = Color3.fromRGB(60, 120, 255),
        BlueDark = Color3.fromRGB(30, 50, 110),
        White = Color3.fromRGB(235, 238, 250),
        Muted = Color3.fromRGB(140, 148, 180),
        Dim = Color3.fromRGB(80, 88, 120),
        Off = Color3.fromRGB(30, 34, 58)
    },
    Ocean = {
        Background = Color3.fromRGB(8, 20, 26),
        Header = Color3.fromRGB(10, 26, 33),
        Panel = Color3.fromRGB(14, 33, 42),
        Element = Color3.fromRGB(22, 48, 60),
        Hover = Color3.fromRGB(30, 64, 78),
        Border = Color3.fromRGB(30, 70, 84),
        Blue = Color3.fromRGB(0, 180, 220),
        BlueDark = Color3.fromRGB(0, 80, 100),
        White = Color3.fromRGB(232, 248, 252),
        Muted = Color3.fromRGB(140, 180, 190),
        Dim = Color3.fromRGB(76, 110, 120),
        Off = Color3.fromRGB(26, 50, 60)
    },
    Rose = {
        Background = Color3.fromRGB(22, 12, 18),
        Header = Color3.fromRGB(26, 14, 22),
        Panel = Color3.fromRGB(34, 18, 28),
        Element = Color3.fromRGB(46, 25, 38),
        Hover = Color3.fromRGB(60, 33, 50),
        Border = Color3.fromRGB(62, 36, 52),
        Blue = Color3.fromRGB(255, 96, 160),
        BlueDark = Color3.fromRGB(120, 30, 70),
        White = Color3.fromRGB(252, 240, 246),
        Muted = Color3.fromRGB(190, 140, 160),
        Dim = Color3.fromRGB(120, 80, 100),
        Off = Color3.fromRGB(50, 28, 42)
    },
    Forest = {
        Background = Color3.fromRGB(10, 18, 12),
        Header = Color3.fromRGB(12, 24, 15),
        Panel = Color3.fromRGB(17, 32, 21),
        Element = Color3.fromRGB(26, 46, 32),
        Hover = Color3.fromRGB(36, 62, 44),
        Border = Color3.fromRGB(38, 62, 46),
        Blue = Color3.fromRGB(80, 210, 120),
        BlueDark = Color3.fromRGB(24, 80, 44),
        White = Color3.fromRGB(238, 248, 240),
        Muted = Color3.fromRGB(150, 180, 158),
        Dim = Color3.fromRGB(84, 110, 92),
        Off = Color3.fromRGB(30, 50, 36)
    },
    ["iOS 27 Glass"] = {
        Background = Color3.fromRGB(232, 238, 247),
        Header = Color3.fromRGB(240, 244, 251),
        Panel = Color3.fromRGB(255, 255, 255),
        Element = Color3.fromRGB(243, 246, 252),
        Hover = Color3.fromRGB(226, 234, 247),
        Border = Color3.fromRGB(255, 255, 255),
        Blue = Color3.fromRGB(0, 122, 255),
        BlueDark = Color3.fromRGB(160, 205, 255),
        White = Color3.fromRGB(20, 24, 34),
        Muted = Color3.fromRGB(84, 92, 110),
        Dim = Color3.fromRGB(128, 136, 156),
        Off = Color3.fromRGB(210, 218, 232)
    }
}

local PresetOrder = {"Dark", "Light", "Midnight", "Ocean", "Rose", "Forest", "iOS 27 Glass"}

local Theme = {}
local ThemeName = "Dark"
local AccentOverride = nil
local Binds = {}
local ThemeOverrides = {}
local MenuStyle = {Alpha = 0, Radius = 18}
local applyGlassFx

local function buildTheme(name, accent)
    local source = Palettes[name] or Palettes.Dark
    local built = {}

    for key, color in pairs(source) do
        built[key] = color
    end

    for key, color in pairs(ThemeOverrides) do
        built[key] = color
    end

    if accent then
        local bright = source.Background.R + source.Background.G + source.Background.B > 1.5

        built.Blue = accent
        built.BlueDark = bright
            and accent:Lerp(Color3.new(1, 1, 1), 0.7)
            or Color3.new(accent.R * 0.45, accent.G * 0.45, accent.B * 0.45)
    end

    built.Alpha = MenuStyle.Alpha
    return built
end

local function refreshTheme()
    for index = #Binds, 1, -1 do
        local bind = Binds[index]

        if bind.obj:IsDescendantOf(Parent) then
            bind.fn()
        else
            table.remove(Binds, index)
        end
    end
end

local function SetTheme(name, accent)
    ThemeName = Palettes[name] and name or "Dark"
    AccentOverride = accent
    Theme = buildTheme(ThemeName, accent)
    refreshTheme()

    if applyGlassFx then
        applyGlassFx()
    end
end

local function Dyn(obj, fn)
    table.insert(Binds, {obj = obj, fn = fn})
    fn()
    return obj
end

local SURFACE_KEYS = {Background = true, Header = true, Panel = true}

local function Paint(obj, prop, key)
    return Dyn(obj, function()
        obj[prop] = Theme[key]

        if prop == "BackgroundColor3" and SURFACE_KEYS[key] then
            obj.BackgroundTransparency = Theme.Alpha or 0
        end
    end)
end

SetTheme("Dark")

local function New(class, props, parent)
    local object = Instance.new(class)

    for key, value in pairs(props or {}) do
        object[key] = value
    end

    object.Parent = parent
    return object
end

local ScaledCorners = {}

local function Corner(object, radius, scalable)
    local corner = New("UICorner", {CornerRadius = UDim.new(0, radius or 10)}, object)

    if scalable then
        table.insert(ScaledCorners, {Corner = corner, Base = radius or 10})
    end

    return corner
end

local function applyRadius()
    for index = #ScaledCorners, 1, -1 do
        local item = ScaledCorners[index]

        if item.Corner.Parent then
            item.Corner.CornerRadius = UDim.new(0, math.floor(item.Base * MenuStyle.Radius / 18 + 0.5))
        else
            table.remove(ScaledCorners, index)
        end
    end
end

local function Stroke(object, key, transparency)
    local stroke = New("UIStroke", {
        Transparency = transparency or 0,
        Thickness = 1
    }, object)

    Paint(stroke, "Color", key or "Border")
    return stroke
end

local function Label(parent, text, size, colorKey, font)
    local label = New("TextLabel", {
        BackgroundTransparency = 1,
        Text = text,
        TextSize = size or 12,
        Font = font or Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center
    }, parent)

    Paint(label, "TextColor3", colorKey or "White")
    return label
end

local ICON_CONFIG = {
    Toolbar = {
        Home = "house",
        Controls = "terminal",
        Settings = "settings",
        Dark = "moon",
        Light = "sun"
    },
    Tabs = {
        Main = "crosshair",
        Visuals = "eye",
        World = "globe",
        Misc = "list",
        Settings = "folder"
    },
    UI = {
        Dropdown = "chevron-down",
        DropdownOpen = "chevron-up",
        Check = "check",
        Gear = "settings",
        Close = "x",
        Resize = "maximize-2",
        Palette = "pipette"
    }
}

local MakeIcon
do
local LUCIDE_URL = "https://raw.githubusercontent.com/notpoiu/lucide-roblox-direct/refs/heads/main/source.lua"
local Lucide = nil

do
    local ok, result = pcall(function()
        return loadstring(game:HttpGet(LUCIDE_URL))()
    end)

    if ok and type(result) == "table" then
        Lucide = result
    else
        warn("[SEVERE] Lucide icons failed to load, using text fallbacks")
    end
end

local function normalizeAssetId(value)
    value = tostring(value or "")

    if value == "" then
        return ""
    end

    if value:match("^rbxassetid://") then
        return value
    end

    local id = value:match("(%d+)")
    return id and ("rbxassetid://" .. id) or ""
end

local function isAssetIcon(value)
    value = tostring(value or "")
    return value:match("^rbxassetid://%d+$") ~= nil or value:match("^%d+$") ~= nil
end

local Provider = {}

function Provider.Create(parent, iconName, size, color, instName)
    if not Lucide then
        return nil
    end

    if type(Lucide.GetFontAsset) == "function" then
        local ok, asset = pcall(Lucide.GetFontAsset, iconName)

        if ok and type(asset) == "table" and asset.FontFace and asset.Text then
            return New("TextLabel", {
                Name = instName,
                BackgroundTransparency = 1,
                FontFace = asset.FontFace,
                Text = asset.Text,
                TextSize = size,
                TextColor3 = color,
                RichText = false,
                TextWrapped = false,
                TextXAlignment = Enum.TextXAlignment.Center,
                TextYAlignment = Enum.TextYAlignment.Center,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromOffset(size + 8, size + 8)
            }, parent)
        end
    end

    if type(Lucide.GetAsset) == "function" then
        local ok, asset = pcall(Lucide.GetAsset, iconName, size)

        if ok and type(asset) == "table" then
            local image = ""

            for _, key in ipairs({"Url", "Image", "Id", "Asset"}) do
                if type(asset[key]) == "string" then
                    image = asset[key]
                    break
                end
            end

            if image ~= "" then
                local label = New("ImageLabel", {
                    Name = instName,
                    BackgroundTransparency = 1,
                    Image = image,
                    ImageColor3 = color,
                    ScaleType = Enum.ScaleType.Fit,
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromOffset(size, size)
                }, parent)

                if typeof(asset.ImageRectSize) == "Vector2" then
                    label.ImageRectSize = asset.ImageRectSize
                end

                if typeof(asset.ImageRectOffset) == "Vector2" then
                    label.ImageRectOffset = asset.ImageRectOffset
                end

                return label
            end
        end
    end

    return nil
end

local function setIconColor(icon, color)
    if not icon then return end

    if icon:IsA("ImageLabel") then
        icon.ImageColor3 = color
    elseif icon:IsA("TextLabel") then
        icon.TextColor3 = color
    end
end

local function resolveColor(source)
    if type(source) == "function" then
        return source()
    end

    return Theme[source] or Theme.White
end

MakeIcon = function(parent, value, size, colorSource, instName)
    value = tostring(value or "")
    instName = instName or "Icon"

    local icon

    if isAssetIcon(value) then
        icon = New("ImageLabel", {
            Name = instName,
            BackgroundTransparency = 1,
            Image = normalizeAssetId(value),
            ScaleType = Enum.ScaleType.Fit,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(size, size)
        }, parent)
    else
        local lucideName = (value:gsub("^lucide:", ""))
        icon = Provider.Create(parent, lucideName, size, resolveColor(colorSource), instName)

        if not icon then
            local text = value

            if #text > 2 then
                text = text:sub(1, 1):upper()
            end

            icon = New("TextLabel", {
                Name = instName,
                BackgroundTransparency = 1,
                Text = text,
                Font = Enum.Font.GothamBold,
                TextSize = size,
                TextXAlignment = Enum.TextXAlignment.Center,
                TextYAlignment = Enum.TextYAlignment.Center,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromOffset(size + 8, size + 8)
            }, parent)
        end
    end

    Dyn(icon, function()
        setIconColor(icon, resolveColor(colorSource))
    end)

    return icon
end

end

local ActiveDrag = nil

local function beginDrag(input, onMove, onEnd)
    local mouse = UIS:GetMouseLocation()

    ActiveDrag = {
        Kind = input.UserInputType,
        Move = onMove,
        End = onEnd,
        OffsetX = input.Position.X - mouse.X,
        OffsetY = input.Position.Y - mouse.Y
    }

    onMove(input.Position)
end

Connect(UIS.InputChanged, function(input)
    if ActiveDrag and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        ActiveDrag.Move(input.Position)
    end
end)

Connect(UIS.InputEnded, function(input)
    if ActiveDrag and input.UserInputType == ActiveDrag.Kind then
        local finished = ActiveDrag
        ActiveDrag = nil

        if finished.End then
            finished.End()
        end
    end
end)

Connect(RunService.RenderStepped, function()
    local drag = ActiveDrag

    if not drag or drag.Kind ~= Enum.UserInputType.MouseButton1 then
        return
    end

    if UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
        local mouse = UIS:GetMouseLocation()
        drag.Move(Vector2.new(mouse.X + drag.OffsetX, mouse.Y + drag.OffsetY))
    else
        ActiveDrag = nil

        if drag.End then
            drag.End()
        end
    end
end)

local function BarThickness()
    return UIS.TouchEnabled and 4 or 2
end

local ShowScrollbars = true

local function isPress(input)
    return input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch
end

local WIN_MIN_W, WIN_MIN_H = 560, 540
local WIN_MAX_W, WIN_MAX_H = 1200, 1000
local CORNER_MAIN = 18

local WinW, WinH = 700, 680
local AutoResize = true
local UserScale = 1
local Compact = false
local MenuOpen = true

local MenuKeyPicker = nil
local ParticleState = {
    Enabled = false,
    Preset = "Snow",
    CustomDecal = nil,
    Image = nil,
    Mode = "Fall",
    Speed = 35,
    Size = 4,
    Rate = 18,
    Spread = 30,
    Color = Color3.fromRGB(235, 242, 255),
    Accumulator = 0,
    Active = {}
}
local Settings = {}
local Cards = {}
local Pages = {}
local BodyUpdaters = {}
local Sized = {}
local Layouts = {}
local DepGates = setmetatable({}, {__mode = "k"})
local Windows = {}
local KeyPickerList = {}
local ListeningKey = nil

local SettingsPageKeys = {Interface = "Settings/Interface", Configs = "Settings/Configs", Theme = "Settings/Theme"}
local ActiveTab = "Main"
local ActiveSub = "Interface"

local refreshKeybindList
local saveWindowState
local setMenuOpen
local applyParticlePreset
local switchPage
local Notify

local GUI = New("ScreenGui", {
    Name = "SEVEREUI",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 999999,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, Parent)

local Overlay = New("ScreenGui", {
    Name = "SEVEREOverlay",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 999990,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, Parent)

local Main = New("Frame", {
    Name = "Main",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(WinW, WinH),
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Active = true
}, GUI)

Paint(Main, "BackgroundColor3", "Background")
Corner(Main, CORNER_MAIN, true)
Stroke(Main, "Border", 0.15)

local Scale = New("UIScale", {Scale = 1}, Main)

do
local GlassBlur = New("BlurEffect", {Name = "SEVEREGlassBlur", Size = 14, Enabled = false}, workspace.CurrentCamera)

local GlassGloss = New("UIGradient", {
    Rotation = 90,
    Enabled = false,
    Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(214, 224, 240))
}, Main)

applyGlassFx = function()
    local on = ThemeName == "iOS 27 Glass"
    GlassBlur.Enabled = on
    GlassGloss.Enabled = on
end
end

local function refreshBodies()
    for _, update in ipairs(BodyUpdaters) do
        update()
    end
end

local function refreshScale()
    local camera = workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
    local scale = UserScale

    if AutoResize then
        scale = math.min(1, viewport.X / (WinW + 40), viewport.Y / (WinH + 50))
    end

    Scale.Scale = math.max(0.4, scale)
    Main.Size = UDim2.fromOffset(WinW, WinH)
    refreshBodies()
end

local function watchCamera()
    local camera = workspace.CurrentCamera

    if camera then
        Connect(camera:GetPropertyChangedSignal("ViewportSize"), refreshScale)
    end
end

watchCamera()
Connect(workspace:GetPropertyChangedSignal("CurrentCamera"), function()
    watchCamera()
    refreshScale()
end)

refreshScale()

local HeaderCfg = {
    Name = "SEVERE",
    Version = ": 1.0.0",
    Title = "Left",
    LogoId = "",
    LogoSide = "Left",
    LogoSize = 24
}

local applyHeader

local Header = New("Frame", {
    Size = UDim2.new(1, 0, 0, 52),
    BorderSizePixel = 0,
    Active = true
}, Main)

Paint(Header, "BackgroundColor3", "Header")
Corner(Header, CORNER_MAIN, true)

do
local HeaderPatch = New("Frame", {
    Name = "HeaderBottomPatch",
    Position = UDim2.new(0, 0, 1, -CORNER_MAIN),
    Size = UDim2.new(1, 0, 0, CORNER_MAIN),
    BorderSizePixel = 0
}, Header)

Paint(HeaderPatch, "BackgroundColor3", "Header")

local TitleGroup = New("Frame", {
    Name = "TitleGroup",
    Position = UDim2.fromOffset(22, 0),
    Size = UDim2.new(0, 0, 1, 0),
    AutomaticSize = Enum.AutomaticSize.X,
    BackgroundTransparency = 1
}, Header)

New("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    Padding = UDim.new(0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder
}, TitleGroup)

local LogoImage = New("ImageLabel", {
    Name = "Logo",
    BackgroundTransparency = 1,
    ScaleType = Enum.ScaleType.Fit,
    Size = UDim2.fromOffset(24, 24),
    Visible = false,
    LayoutOrder = 0
}, TitleGroup)

local Brand = Label(TitleGroup, HeaderCfg.Name, 15, "White", Enum.Font.GothamBold)
Brand.Size = UDim2.new(0, 0, 1, 0)
Brand.AutomaticSize = Enum.AutomaticSize.X
Brand.LayoutOrder = 1

local Version = Label(TitleGroup, HeaderCfg.Version, 12, "Blue", Enum.Font.GothamBold)
Version.Size = UDim2.new(0, 0, 1, 0)
Version.AutomaticSize = Enum.AutomaticSize.X
Version.LayoutOrder = 2

applyHeader = function()
    local title = HeaderCfg.Title

    if title == "Center" then
        TitleGroup.AnchorPoint = Vector2.new(0.5, 0)
        TitleGroup.Position = UDim2.new(0.5, 0, 0, 0)
    elseif title == "Right" then
        TitleGroup.AnchorPoint = Vector2.new(1, 0)
        TitleGroup.Position = UDim2.new(1, -22, 0, 0)
    else
        TitleGroup.AnchorPoint = Vector2.new(0, 0)
        TitleGroup.Position = UDim2.fromOffset(22, 0)
    end

    LogoImage.Visible = HeaderCfg.LogoId ~= ""
    LogoImage.Image = HeaderCfg.LogoId ~= "" and ("rbxassetid://" .. HeaderCfg.LogoId) or ""
    LogoImage.Size = UDim2.fromOffset(HeaderCfg.LogoSize, HeaderCfg.LogoSize)
    LogoImage.LayoutOrder = HeaderCfg.LogoSide == "Right" and 3 or 0
end

applyHeader()

local HeaderLine = New("Frame", {
    Position = UDim2.new(0, 0, 1, -1),
    Size = UDim2.new(1, 0, 0, 1),
    BorderSizePixel = 0
}, Header)

Paint(HeaderLine, "BackgroundColor3", "Border")

end

local ToolButton, ThemeButton, SearchBox
do
local Toolbar = New("Frame", {
    Position = UDim2.fromOffset(14, 65),
    Size = UDim2.new(1, -28, 0, 48),
    BackgroundTransparency = 1
}, Main)

local ToolGroup = New("Frame", {
    Size = UDim2.fromOffset(98, 48),
    BorderSizePixel = 0
}, Toolbar)

Paint(ToolGroup, "BackgroundColor3", "Panel")
Corner(ToolGroup, 12, true)

ToolButton = function(iconValue, x, callback)
    local button = New("TextButton", {
        Position = UDim2.fromOffset(x, 4),
        Size = UDim2.fromOffset(44, 40),
        Text = "",
        AutoButtonColor = false,
        BorderSizePixel = 0
    }, ToolGroup)

    Paint(button, "BackgroundColor3", "Panel")
    Corner(button, 9)
    MakeIcon(button, iconValue, 16, "Dim", "ToolIcon")
    button.Activated:Connect(callback)

    return button
end

local ThemeGroup = New("Frame", {
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, 0, 0, 0),
    Size = UDim2.fromOffset(118, 48),
    BorderSizePixel = 0
}, Toolbar)

Paint(ThemeGroup, "BackgroundColor3", "Panel")
Corner(ThemeGroup, 12, true)

local ThemeButtons = {}

ThemeButton = function(mode, iconValue, x)
    local button = New("TextButton", {
        Position = UDim2.fromOffset(x, 4),
        Size = UDim2.fromOffset(54, 40),
        Text = "",
        AutoButtonColor = false,
        BorderSizePixel = 0
    }, ThemeGroup)

    Corner(button, 9)

    local active = function() return ThemeName == mode end

    Dyn(button, function()
        button.BackgroundColor3 = active() and Theme.Element or Theme.Panel
    end)

    local icon = MakeIcon(button, iconValue, 16, function()
        return active() and Theme.Blue or Theme.Dim
    end, "ToolIcon")

    ThemeButtons[mode] = {Button = button, Icon = icon}

    button.Activated:Connect(function()
        -- "Theme Preset" is registered by the ThemeManager addon; fall back to SetTheme without it.
        local entry = Settings["Theme Preset"]
        if entry then
            entry.Set(mode, true)
        else
            SetTheme(mode, AccentOverride)
        end
    end)
end

SearchBox = New("TextBox", {
    Name = "SettingsSearch",
    Position = UDim2.fromOffset(166, 7),
    Size = UDim2.new(1, -296, 0, 34),
    BorderSizePixel = 0,
    Text = "",
    PlaceholderText = "Search settings...",
    TextSize = 12,
    Font = Enum.Font.GothamMedium,
    ClearTextOnFocus = false,
    TextXAlignment = Enum.TextXAlignment.Left
}, Toolbar)

Paint(SearchBox, "BackgroundColor3", "Panel")
Paint(SearchBox, "TextColor3", "White")
Paint(SearchBox, "PlaceholderColor3", "Dim")
Corner(SearchBox, 10)

New("UIPadding", {
    PaddingLeft = UDim.new(0, 14),
    PaddingRight = UDim.new(0, 10)
}, SearchBox)

end

local Content = New("Frame", {
    Position = UDim2.fromOffset(14, 128),
    Size = UDim2.new(1, -28, 1, -208),
    BackgroundTransparency = 1
}, Main)

local ContentScale = New("UIScale", {Scale = 1}, Content)

local ParticleGui = New("ScreenGui", {
    Name = "SEVEREParticles",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 999980,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Enabled = false
}, Parent)

local ParticleLayer = New("Frame", {
    Name = "Particles",
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    ZIndex = 60
}, ParticleGui)

local PopupLayer = New("Frame", {
    Name = "PopupLayer",
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ZIndex = 200
}, Main)

local DimLayer = New("TextButton", {
    Name = "DimLayer",
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.new(0, 0, 0),
    BackgroundTransparency = 0.45,
    BorderSizePixel = 0,
    Text = "",
    AutoButtonColor = false,
    Visible = false,
    ZIndex = 150
}, Main)

Corner(DimLayer, CORNER_MAIN)

local Tooltip = New("TextLabel", {
    Name = "Tooltip",
    BorderSizePixel = 0,
    Text = "",
    TextSize = 12,
    Font = Enum.Font.GothamMedium,
    AutomaticSize = Enum.AutomaticSize.XY,
    Size = UDim2.fromOffset(0, 0),
    Visible = false,
    ZIndex = 500
}, Main)

Paint(Tooltip, "BackgroundColor3", "Element")
Paint(Tooltip, "TextColor3", "White")
Corner(Tooltip, 8)
Stroke(Tooltip, "Border", 0)

New("UIPadding", {
    PaddingLeft = UDim.new(0, 10),
    PaddingRight = UDim.new(0, 10),
    PaddingTop = UDim.new(0, 6),
    PaddingBottom = UDim.new(0, 6)
}, Tooltip)

local function placeTooltip()
    local mouse = UIS:GetMouseLocation()
    local s = Scale.Scale

    Tooltip.Position = UDim2.fromOffset(
        (mouse.X - Main.AbsolutePosition.X) / s + 14,
        (mouse.Y - Main.AbsolutePosition.Y) / s + 14
    )
end

local tipToken = 0

local function showTip(text, sticky)
    tipToken += 1
    local token = tipToken

    Tooltip.Text = text
    placeTooltip()
    Tooltip.Visible = true

    if not sticky then
        return
    end

    task.delay(2.5, function()
        if token == tipToken then
            Tooltip.Visible = false
        end
    end)
end

local function tipsEnabled()
    local setting = Settings["Show Tooltips"]
    return setting == nil or setting.Get()
end

Hint = function(container, text)
    local hint = New("TextLabel", {
        Name = "Hint",
        BackgroundTransparency = 1,
        Text = "(?)",
        TextSize = 11,
        Font = Enum.Font.GothamMedium,
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.new(0, 0, 1, 0),
        Active = true
    }, container)

    Paint(hint, "TextColor3", "Dim")

    hint.MouseEnter:Connect(function()
        if tipsEnabled() then
            showTip(text, false)
        end
    end)

    hint.MouseMoved:Connect(placeTooltip)

    hint.MouseLeave:Connect(function()
        tipToken += 1
        Tooltip.Visible = false
    end)

    hint.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch and tipsEnabled() then
            showTip(text, true)
        end
    end)

    return hint
end

local NotifyHolder = New("Frame", {
    Name = "Notifications",
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -16, 0, 16),
    Size = UDim2.fromOffset(300, 0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1,
    ZIndex = 400
}, Overlay)

New("UIListLayout", {
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder,
    HorizontalAlignment = Enum.HorizontalAlignment.Right
}, NotifyHolder)

do
local notifyCount = 0
local TOAST_H = 64
local TOAST_LIFETIME = 3

Notify = function(message, title)
    local setting = Settings["Show Notifications"]

    if setting and not setting.Get() then
        return
    end

    notifyCount += 1

    local slot = New("Frame", {
        Name = "Toast",
        Size = UDim2.new(1, 0, 0, TOAST_H),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        LayoutOrder = -notifyCount,
        ZIndex = 400
    }, NotifyHolder)

    local card = New("CanvasGroup", {
        Name = "Card",
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        GroupTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 400
    }, slot)

    Paint(card, "BackgroundColor3", "Panel")
    Corner(card, 12, true)
    Stroke(card, "Border", 0.2)

    local bar = New("Frame", {
        Position = UDim2.fromOffset(0, 12),
        Size = UDim2.new(0, 3, 1, -24),
        BorderSizePixel = 0,
        ZIndex = 401
    }, card)

    Paint(bar, "BackgroundColor3", "Blue")
    Corner(bar, 2)

    local heading = Label(card, title or "SEVERE", 12, "White", Enum.Font.GothamBold)
    heading.Position = UDim2.fromOffset(16, 10)
    heading.Size = UDim2.new(1, -32, 0, 16)
    heading.ZIndex = 401

    local body = Label(card, tostring(message), 11, "Muted", Enum.Font.GothamMedium)
    body.Position = UDim2.fromOffset(16, 28)
    body.Size = UDim2.new(1, -32, 0, 18)
    body.TextTruncate = Enum.TextTruncate.AtEnd
    body.ZIndex = 401

    local track = New("Frame", {
        Position = UDim2.new(0, 0, 1, -3),
        Size = UDim2.new(1, 0, 0, 3),
        BorderSizePixel = 0,
        ZIndex = 401
    }, card)

    Paint(track, "BackgroundColor3", "Element")

    local fill = New("Frame", {
        Size = UDim2.fromScale(1, 1),
        BorderSizePixel = 0,
        ZIndex = 402
    }, track)

    Paint(fill, "BackgroundColor3", "Blue")

    TweenService:Create(card, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.fromScale(0, 0),
        GroupTransparency = 0
    }):Play()

    TweenService:Create(fill, TweenInfo.new(TOAST_LIFETIME, Enum.EasingStyle.Linear), {
        Size = UDim2.fromScale(0, 1)
    }):Play()

    task.delay(TOAST_LIFETIME, function()
        local out = TweenService:Create(card, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.fromScale(1, 0),
            GroupTransparency = 1
        })

        out:Play()
        out.Completed:Wait()

        local collapse = TweenService:Create(slot, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, 0, 0, 0)
        })

        collapse:Play()
        collapse.Completed:Wait()
        slot:Destroy()
    end)
end
end

local Popup = {Active = nil}

DimLayer.Activated:Connect(function()
    Popup.Close()
end)

function Popup.Close()
    local active = Popup.Active

    if not active then return end

    Popup.Active = nil
    DimLayer.Visible = false
    active.Frame.Visible = false

    if active.OnClose then
        active.OnClose()
    end
end

function Popup.Open(spot, frame, onClose)
    Popup.Close()

    DimLayer.Visible = true
    frame.Visible = true

    Popup.Active = {
        Frame = frame,
        OnClose = onClose
    }
end

local function placeBelow(frame, anchor, width, height, alignRight)
    local s = Scale.Scale
    local pos = anchor.AbsolutePosition - Main.AbsolutePosition
    local x, y = pos.X / s, pos.Y / s
    local aw, ah = anchor.AbsoluteSize.X / (s * ContentScale.Scale), anchor.AbsoluteSize.Y / (s * ContentScale.Scale)

    width = width or aw

    local top = y + ah + 8

    if top + height > WinH - 10 then
        top = y - height - 8
    end

    local left = alignRight and (x + aw - width) or x
    left = math.clamp(left, 8, WinW - width - 8)

    frame.Position = UDim2.fromOffset(left, math.max(8, top))
    frame.Size = UDim2.fromOffset(width, height)
end

local openModeMenu, openPicker, KeyModes
do

local ModeMenu = New("Frame", {
    Name = "KeyModeMenu",
    BorderSizePixel = 0,
    Visible = false,
    Size = UDim2.fromOffset(120, 120)
}, PopupLayer)

Paint(ModeMenu, "BackgroundColor3", "Element")
Corner(ModeMenu, 10)
Stroke(ModeMenu, "Border", 0.3)

New("UIPadding", {
    PaddingTop = UDim.new(0, 4),
    PaddingBottom = UDim.new(0, 4),
    PaddingLeft = UDim.new(0, 4),
    PaddingRight = UDim.new(0, 4)
}, ModeMenu)

New("UIListLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 0)
}, ModeMenu)

KeyModes = {"Toggle", "Hold", "Always", "None"}
local ModeTarget = nil
local ModeItems = {}

for index, mode in ipairs(KeyModes) do
    local item = New("TextButton", {
        Name = mode,
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
        Text = mode,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        LayoutOrder = index
    }, ModeMenu)

    Corner(item, 7)

    item.Activated:Connect(function()
        if ModeTarget then
            ModeTarget.SetMode(mode)
        end

        Popup.Close()
    end)

    ModeItems[mode] = item
end

local function refreshModeMenu()
    for mode, item in pairs(ModeItems) do
        local current = ModeTarget and ModeTarget.Mode == mode
        item.TextColor3 = current and Theme.Blue or Theme.Dim
        item.BackgroundColor3 = Theme.Hover
        item.BackgroundTransparency = current and 0.4 or 1
    end
end

openModeMenu = function(kp, anchor, spot)
    ModeTarget = kp
    refreshModeMenu()
    placeBelow(ModeMenu, anchor, 120, 120, true)
    Popup.Open(spot, ModeMenu, nil)
end

local PALETTE_COLORS = {
    Color3.fromRGB(255, 255, 255),
    Color3.fromRGB(255, 225, 100),
    Color3.fromRGB(255, 160, 70),
    Color3.fromRGB(255, 110, 110),
    Color3.fromRGB(255, 130, 200),
    Color3.fromRGB(60, 200, 120),
    Color3.fromRGB(80, 200, 255),
    Color3.fromRGB(0, 0, 0)
}

local PICKER_W, PICKER_H = 212, 244

local PickerFrame = New("Frame", {
    Name = "ColorPicker",
    BorderSizePixel = 0,
    Visible = false,
    Size = UDim2.fromOffset(PICKER_W, PICKER_H)
}, PopupLayer)

Paint(PickerFrame, "BackgroundColor3", "Element")
Corner(PickerFrame, 10)
Stroke(PickerFrame, "Border", 0.3)

local SvArea = New("Frame", {
    Name = "SaturationValue",
    Position = UDim2.fromOffset(10, 10),
    Size = UDim2.fromOffset(192, 116),
    BorderSizePixel = 0,
    Active = true
}, PickerFrame)

Corner(SvArea, 6)

local WhiteOverlay = New("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.new(1, 1, 1),
    BorderSizePixel = 0,
    Active = false
}, SvArea)

Corner(WhiteOverlay, 6)

New("UIGradient", {
    Transparency = NumberSequence.new(0, 1)
}, WhiteOverlay)

local BlackOverlay = New("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.new(0, 0, 0),
    BorderSizePixel = 0,
    Active = false
}, SvArea)

Corner(BlackOverlay, 6)

New("UIGradient", {
    Rotation = 90,
    Transparency = NumberSequence.new(1, 0)
}, BlackOverlay)

local SvCursor = New("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.fromOffset(10, 10),
    BackgroundColor3 = Color3.new(1, 1, 1),
    BorderSizePixel = 0,
    ZIndex = 4
}, SvArea)

Corner(SvCursor, 5)
Stroke(SvCursor, "Border", 0)

local HueBar = New("Frame", {
    Position = UDim2.fromOffset(10, 136),
    Size = UDim2.fromOffset(192, 12),
    BackgroundColor3 = Color3.new(1, 1, 1),
    BorderSizePixel = 0,
    Active = true
}, PickerFrame)

Corner(HueBar, 6)

New("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
        ColorSequenceKeypoint.new(0.167, Color3.fromHSV(0.167, 1, 1)),
        ColorSequenceKeypoint.new(0.333, Color3.fromHSV(0.333, 1, 1)),
        ColorSequenceKeypoint.new(0.5, Color3.fromHSV(0.5, 1, 1)),
        ColorSequenceKeypoint.new(0.667, Color3.fromHSV(0.667, 1, 1)),
        ColorSequenceKeypoint.new(0.833, Color3.fromHSV(0.833, 1, 1)),
        ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1))
    })
}, HueBar)

local HueCursor = New("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.fromOffset(5, 16),
    BackgroundColor3 = Color3.new(1, 1, 1),
    BorderSizePixel = 0,
    ZIndex = 4
}, HueBar)

Corner(HueCursor, 3)

local AlphaBar = New("Frame", {
    Position = UDim2.fromOffset(10, 158),
    Size = UDim2.fromOffset(192, 12),
    BackgroundColor3 = Color3.new(1, 1, 1),
    BorderSizePixel = 0,
    Active = true
}, PickerFrame)

Corner(AlphaBar, 6)

New("UIGradient", {
    Transparency = NumberSequence.new(1, 0)
}, AlphaBar)

local AlphaCursor = New("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.fromOffset(5, 16),
    BackgroundColor3 = Color3.new(1, 1, 1),
    BorderSizePixel = 0,
    ZIndex = 4
}, AlphaBar)

Corner(AlphaCursor, 3)

local HexBox = New("TextBox", {
    Position = UDim2.fromOffset(10, 180),
    Size = UDim2.fromOffset(192, 26),
    BorderSizePixel = 0,
    Text = "",
    TextSize = 12,
    Font = Enum.Font.GothamBold,
    ClearTextOnFocus = false
}, PickerFrame)

Paint(HexBox, "BackgroundColor3", "Panel")
Paint(HexBox, "TextColor3", "White")
Corner(HexBox, 7)

local SwatchRow = New("Frame", {
    Position = UDim2.fromOffset(10, 214),
    Size = UDim2.fromOffset(192, 18),
    BackgroundTransparency = 1
}, PickerFrame)

New("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    Padding = UDim.new(0, 5),
    SortOrder = Enum.SortOrder.LayoutOrder
}, SwatchRow)

local Picker = {H = 0, S = 0, V = 1, A = 1, Target = nil}

local function hexOf(color, alpha)
    return string.format(
        "#%02X%02X%02X%02X",
        math.floor(color.R * 255 + 0.5),
        math.floor(color.G * 255 + 0.5),
        math.floor(color.B * 255 + 0.5),
        math.floor(alpha * 255 + 0.5)
    )
end

local function parseHex(text)
    text = tostring(text or ""):gsub("#", ""):gsub("%s", "")

    if #text ~= 6 and #text ~= 8 then
        return nil
    end

    local r = tonumber(text:sub(1, 2), 16)
    local g = tonumber(text:sub(3, 4), 16)
    local b = tonumber(text:sub(5, 6), 16)
    local a = #text == 8 and tonumber(text:sub(7, 8), 16) or 255

    if not (r and g and b and a) then
        return nil
    end

    return Color3.fromRGB(r, g, b), a / 255
end

local function pickerColor()
    return Color3.fromHSV(Picker.H, Picker.S, Picker.V)
end

local function pickerSync()
    local color = pickerColor()

    SvArea.BackgroundColor3 = Color3.fromHSV(Picker.H, 1, 1)
    SvCursor.Position = UDim2.fromScale(Picker.S, 1 - Picker.V)
    HueCursor.Position = UDim2.fromScale(Picker.H, 0.5)
    AlphaCursor.Position = UDim2.fromScale(Picker.A, 0.5)
    AlphaBar.BackgroundColor3 = color
    HexBox.Text = hexOf(color, Picker.A)
end

local function pickerEmit()
    local target = Picker.Target

    if target then
        target.Apply(pickerColor(), Picker.A)
    end
end

local function pickerTarget(target)
    Picker.Target = target
    Picker.H, Picker.S, Picker.V = target.Color:ToHSV()
    Picker.A = target.Alpha or 1
    pickerSync()
end

local function dragArea(area, onPos)
    area.InputBegan:Connect(function(input)
        if isPress(input) then
            beginDrag(input, function(pos)
                local x = math.clamp((pos.X - area.AbsolutePosition.X) / area.AbsoluteSize.X, 0, 1)
                local y = math.clamp((pos.Y - area.AbsolutePosition.Y) / area.AbsoluteSize.Y, 0, 1)
                onPos(x, y)
                pickerSync()
                pickerEmit()
            end)
        end
    end)
end

dragArea(SvArea, function(x, y)
    Picker.S = x
    Picker.V = 1 - y
end)

dragArea(HueBar, function(x)
    Picker.H = x
end)

dragArea(AlphaBar, function(x)
    Picker.A = x
end)

HexBox.FocusLost:Connect(function()
    local color, alpha = parseHex(HexBox.Text)

    if color then
        Picker.H, Picker.S, Picker.V = color:ToHSV()
        Picker.A = alpha
        pickerSync()
        pickerEmit()
    else
        pickerSync()
    end
end)

for index, color in ipairs(PALETTE_COLORS) do
    local swatch = New("TextButton", {
        Name = "Swatch",
        Size = UDim2.fromOffset(18, 18),
        BackgroundColor3 = color,
        Text = "",
        AutoButtonColor = false,
        LayoutOrder = index
    }, SwatchRow)

    Corner(swatch, 9)

    swatch.Activated:Connect(function()
        Picker.H, Picker.S, Picker.V = color:ToHSV()
        pickerSync()
        pickerEmit()
    end)
end

openPicker = function(target, anchor, spot)
    if Popup.Active and Popup.Active.Frame == PickerFrame and Picker.Target == target then
        Popup.Close()
        return
    end

    pickerTarget(target)
    placeBelow(PickerFrame, anchor, PICKER_W, PICKER_H, true)
    Popup.Open(spot, PickerFrame, nil)
end

end

local function Divider(c)
    if c.HasRows then
        local line = New("Frame", {
            Name = "Divider",
            Size = UDim2.new(1, 0, 0, 1),
            BorderSizePixel = 0
        }, c.Body)

        Paint(line, "BackgroundColor3", "Border")
    end

    c.HasRows = true
end

local function Row(c, kind, height, cut)
    Divider(c)

    local row = New("Frame", {
        Name = "Row",
        Size = UDim2.new(1, 0, 0, height),
        BackgroundTransparency = 1
    }, c.Body)

    table.insert(Sized, {Frame = row, Base = height, Cut = cut or 0})
    return row
end

local function HeadRow(parent, size, position)
    local head = New("Frame", {
        BackgroundTransparency = 1,
        Position = position or UDim2.new(),
        Size = size
    }, parent)

    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, head)

    return head
end

local function registerSetting(name, get, set)
    local key = name
    local n = 1

    while Settings[key] do
        n += 1
        key = name .. " (" .. n .. ")"
    end

    Settings[key] = {Get = get, Set = set}
end

local function Section(column, name, pageKey)
    local card = New("Frame", {
        Name = "Card",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BorderSizePixel = 0
    }, column)

    Paint(card, "BackgroundColor3", "Panel")
    Corner(card, 14, true)

    New("UIPadding", {
        PaddingTop = UDim.new(0, 4),
        PaddingBottom = UDim.new(0, 4),
        PaddingLeft = UDim.new(0, 14),
        PaddingRight = UDim.new(0, 8)
    }, card)

    local body = New("ScrollingFrame", {
        Name = "CardBody",
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y
    }, card)

    Paint(body, "ScrollBarImageColor3", "Blue")

    New("UIPadding", {
        PaddingRight = UDim.new(0, 16)
    }, body)

    local layout = New("UIListLayout", {
        Padding = UDim.new(0, 0),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, body)

    local function update()
        local height = layout.AbsoluteContentSize.Y / math.max(Scale.Scale, 0.01)
        body.Size = UDim2.new(1, 0, 0, math.ceil(height))
    end

    Connect(layout:GetPropertyChangedSignal("AbsoluteContentSize"), update)
    table.insert(BodyUpdaters, update)

    table.insert(Cards, {Frame = card, Body = body, Page = pageKey, Name = name})
    card:SetAttribute("SectionName", name)

    return {Body = body, Spot = card, HasRows = false, Card = card}
end

local function AddGroup(c, title)
    local group = New("Frame", {
        Name = "Group",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BorderSizePixel = 0,
        LayoutOrder = 0
    }, c.Body)

    Paint(group, "BackgroundColor3", "Element")
    Corner(group, 10)
    Stroke(group, "Border", 0.2)

    New("UIPadding", {
        PaddingTop = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12)
    }, group)

    New("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, group)

    local heading = Label(group, title or "Group", 11, "Blue", Enum.Font.GothamBold)
    heading.Size = UDim2.new(1, 0, 0, 18)
    heading.LayoutOrder = 0

    local body = New("Frame", {
        Name = "GroupBody",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = 1
    }, group)

    New("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder}, body)

    return {Body = body, Spot = group, HasRows = false}
end

local function CreatePage(key, topOffset)
    local page = New("ScrollingFrame", {
        Name = key:gsub("/", "_") .. "Page",
        Position = UDim2.fromOffset(0, topOffset or 0),
        Size = UDim2.new(1, 0, 1, -(topOffset or 0)),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = BarThickness(),
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        Visible = false
    }, Content)

    Paint(page, "ScrollBarImageColor3", "Blue")

    New("UIPadding", {
        PaddingRight = UDim.new(0, 16),
        PaddingBottom = UDim.new(0, 6)
    }, page)

    local function column(anchorRight)
        local frame = New("Frame", {
            Name = anchorRight and "Right" or "Left",
            AnchorPoint = Vector2.new(anchorRight and 1 or 0, 0),
            Position = UDim2.new(anchorRight and 1 or 0, 0, 0, 0),
            Size = UDim2.new(0.5, -8, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1
        }, page)

        local layout = New("UIListLayout", {
            Padding = UDim.new(0, 16),
            SortOrder = Enum.SortOrder.LayoutOrder
        }, frame)

        table.insert(Layouts, layout)
        return frame
    end

    Pages[key] = page

    return column(false), column(true)
end

local function applyCompact()
    for _, record in ipairs(Sized) do
        if record.Frame.Parent then
            record.Frame.Size = UDim2.new(1, 0, 0, record.Base - (Compact and record.Cut or 0))
        end
    end

    for _, layout in ipairs(Layouts) do
        layout.Padding = UDim.new(0, Compact and 8 or 16)
    end

    refreshBodies()
end

local function ColorDot(parent, color, alpha, order, onChange)
    local dot = {Color = color, Alpha = alpha or 1}

    local button = New("TextButton", {
        Name = "ColorDot",
        Size = UDim2.fromOffset(14, 14),
        BackgroundColor3 = color,
        Text = "",
        AutoButtonColor = false,
        LayoutOrder = order or 0
    }, parent)

    Corner(button, 7)
    Stroke(button, "Border", 0.3)

    dot.Button = button

    dot.Apply = function(newColor, newAlpha)
        dot.Set(newColor, newAlpha, true)
    end

    dot.Set = function(newColor, newAlpha, fire)
        dot.Color = newColor
        dot.Alpha = newAlpha or 1
        button.BackgroundColor3 = newColor

        if fire and onChange then
            onChange(newColor, dot.Alpha)
        end
    end

    button.Activated:Connect(function()
        openPicker(dot, button, dot.Spot or parent)
    end)

    return dot
end

local KEY_SHORT = {
    LeftControl = "L-Ctrl",
    RightControl = "R-Ctrl",
    LeftShift = "L-Shift",
    RightShift = "R-Shift",
    LeftAlt = "L-Alt",
    RightAlt = "R-Alt"
}

local function keyLabel(key)
    if not key then return "None" end
    return KEY_SHORT[key.Name] or key.Name
end

local function parseKey(value)
    if typeof(value) == "EnumItem" then
        return value
    end

    if type(value) == "string" and value ~= "None" and value ~= "" then
        local ok, item = pcall(function() return Enum.KeyCode[value] end)

        if ok and item then
            return item
        end
    end

    return nil
end

local function MakeKeyPicker(parent, id, o)
    o = o or {}

    local kp = {
        Id = id,
        Key = parseKey(o.Key),
        Mode = table.find(KeyModes, o.Mode or "Toggle") and o.Mode or "Toggle",
        State = false,
        Callback = o.Callback,
        GetState = o.GetState,
        Spot = o.Spot
    }

    local button = New("TextButton", {
        Name = "KeyPicker",
        Size = o.Size or UDim2.fromOffset(56, 20),
        Text = "",
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        BorderSizePixel = 0,
        LayoutOrder = o.LayoutOrder or 0
    }, parent)

    Paint(button, "BackgroundColor3", "Element")
    Paint(button, "TextColor3", "Blue")
    Corner(button, 6)

    local function refresh()
        if ListeningKey == kp then
            button.Text = "..."
            return
        end

        local text = keyLabel(kp.Key)

        if o.ShowMode then
            text = text .. "  " .. kp.Mode
        end

        button.Text = text
    end

    kp.Refresh = refresh
    kp.Button = button

    function kp.Fire(state)
        kp.State = state

        if kp.Callback then
            kp.Callback(state)
        end

        refreshKeybindList()
    end

    function kp.SetKey(key)
        kp.Key = parseKey(key)
        refresh()
        refreshKeybindList()
    end

    function kp.SetMode(mode)
        if not table.find(KeyModes, mode) then return end

        local previous = kp.Mode
        kp.Mode = mode

        if mode == "Always" then
            kp.Fire(true)
        elseif previous == "Always" then
            kp.State = false
        end

        refresh()
        refreshKeybindList()
    end

    kp.Get = function()
        return {Key = kp.Key and kp.Key.Name or "None", Mode = kp.Mode}
    end

    kp.Set = function(value)
        if type(value) ~= "table" then return end

        kp.Key = parseKey(value.Key)
        kp.SetMode(value.Mode)
        refresh()
    end

    kp.Apply = function()
        if kp.Mode == "Always" then
            kp.Fire(true)
        end
    end

    local suppressTap = false

    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            openModeMenu(kp, button, kp.Spot or parent)
        elseif input.UserInputType == Enum.UserInputType.Touch then
            suppressTap = false
            local finished = false
            local stateConnection

            stateConnection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End
                    or input.UserInputState == Enum.UserInputState.Cancel then
                    finished = true
                    stateConnection:Disconnect()
                end
            end)

            task.delay(0.45, function()
                if not finished then
                    suppressTap = true
                    openModeMenu(kp, button, kp.Spot or parent)
                end
            end)
        end
    end)

    button.Activated:Connect(function()
        if suppressTap then
            suppressTap = false
            return
        end

        if ListeningKey == kp then
            ListeningKey = nil
        else
            ListeningKey = kp
        end

        refresh()
    end)

    table.insert(KeyPickerList, kp)
    refresh()

    return kp
end

local function AddToggle(c, name, default, opts)
    opts = opts or {}

    local row = Row(c, "Toggle", 45, 9)

    local head = HeadRow(row, UDim2.new(1, -170, 1, 0))

    local label = Label(head, name, 12, "Dim", Enum.Font.GothamMedium)
    label.AutomaticSize = Enum.AutomaticSize.X
    label.Size = UDim2.new(0, 0, 1, 0)

    if opts.Hint then
        Hint(head, opts.Hint)
    end

    local controls = New("Frame", {
        Name = "Controls",
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(0, 24),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1
    }, row)

    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, controls)

    local toggle = {
        Type = "Toggle",
        Name = name,
        Value = default and true or false,
        Listeners = {},
        Callback = opts.Callback
    }

    if opts.Gear then
        local gear = New("TextButton", {
            Name = "Gear",
            Size = UDim2.fromOffset(18, 18),
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false,
            LayoutOrder = 1
        }, controls)

        MakeIcon(gear, ICON_CONFIG.UI.Gear, 15, "Muted", "GearIcon")

        gear.Activated:Connect(function()
            if type(opts.OnGear) == "function" then
                opts.OnGear()
            else
                Notify(name .. " settings")
            end
        end)
    end

    if opts.Color then
        toggle.Color = ColorDot(controls, opts.Color, 1, 2, function(color, alpha)
            if opts.OnColor then
                opts.OnColor(color, alpha)
            end
        end)

        toggle.Color.Spot = c.Spot

        registerSetting(name .. " Color", function()
            local color = toggle.Color.Color
            return {color.R, color.G, color.B, toggle.Color.Alpha}
        end, function(value)
            if type(value) == "table" then
                toggle.Color.Set(Color3.new(value[1], value[2], value[3]), value[4] or 1, true)
            end
        end)
    end

    if opts.Keybind then
        local kp = MakeKeyPicker(controls, name .. " Keybind", {
            Key = opts.Keybind.Key,
            Mode = opts.Keybind.Mode,
            Size = UDim2.fromOffset(52, 18),
            LayoutOrder = 3,
            Spot = c.Spot,
            Callback = function(state)
                toggle.Set(state, true)
            end,
            GetState = function()
                return toggle.Value
            end
        })

        toggle.Keybind = kp
        registerSetting(name .. " Keybind", kp.Get, kp.Set)
    end

    local button = New("TextButton", {
        Name = "Switch",
        Size = UDim2.fromOffset(30, 15),
        Text = "",
        AutoButtonColor = false,
        LayoutOrder = 4
    }, controls)

    Corner(button, 8)

    local knob = New("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.fromOffset(9, 9),
        BorderSizePixel = 0
    }, button)

    Corner(knob, 5)

    local function render()
        button.BackgroundColor3 = toggle.Value and Theme.BlueDark or Theme.Off
        knob.Position = toggle.Value and UDim2.new(0, 18, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
        knob.BackgroundColor3 = toggle.Value and Theme.Blue or Theme.Dim
        label.TextColor3 = toggle.Value and Theme.White or Theme.Dim
        label.Font = toggle.Value and Enum.Font.GothamBold or Enum.Font.GothamMedium
    end

    Dyn(button, render)

    function toggle.Set(value, fire)
        toggle.Value = value and true or false
        render()

        for _, listener in ipairs(toggle.Listeners) do
            listener(toggle.Value)
        end

        if fire and toggle.Callback then
            toggle.Callback(toggle.Value)
        end

        refreshKeybindList()
    end

    function toggle.Get()
        return toggle.Value
    end

    button.Activated:Connect(function()
        toggle.Set(not toggle.Value, true)
    end)

    registerSetting(name, toggle.Get, function(value)
        toggle.Set(value, true)
    end)

    -- Always-mode keybinds fire on creation. Do this after toggle.Set exists.
    if toggle.Keybind then
        toggle.Keybind.Apply()
    end

    return toggle
end

local function AddDependency(c, toggle, opts)
    opts = opts or {}

    local box = New("Frame", {
        Name = "Dependency",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Visible = toggle.Get()
    }, c.Body)

    New("UIPadding", {
        PaddingLeft = UDim.new(0, opts.Indent or 14)
    }, box)

    New("UIListLayout", {
        Padding = UDim.new(0, 0),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, box)

    local gate = function()
        return toggle.Get()
    end

    DepGates[box] = gate

    table.insert(toggle.Listeners, function(value)
        box.Visible = value
    end)

    local child = {Body = box, Spot = c.Spot, HasRows = false}
    if c.HasRows then
        local line = New("Frame", {
            Name = "Divider",
            Size = UDim2.new(1, 0, 0, 1),
            BorderSizePixel = 0
        }, box)

        Paint(line, "BackgroundColor3", "Border")
    end

    child.HasRows = true
    return child
end

local function AddSlider(c, name, minimum, maximum, default, opts)
    opts = opts or {}

    local precision = opts.Precision or 0
    local step = opts.Step or (maximum - minimum) / 20
    local indent = opts.Sub and 14 or 0

    local row = Row(c, "Slider", 65, 9)

    local head = HeadRow(row, UDim2.new(0.7, 0, 0, 20), UDim2.fromOffset(indent, 10))

    local label = Label(head, name, 12, "Muted", Enum.Font.GothamMedium)
    label.AutomaticSize = Enum.AutomaticSize.X
    label.Size = UDim2.new(0, 0, 1, 0)

    if opts.Hint then
        Hint(head, opts.Hint)
    end

    local valueLabel = Label(row, "", 12, "White", Enum.Font.GothamBold)
    valueLabel.Position = UDim2.new(0.7, 0, 0, 10)
    valueLabel.Size = UDim2.new(0.3, 0, 0, 20)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right

    local function stepButton(text, rightSide)
        local button = New("TextButton", {
            Name = rightSide and "Plus" or "Minus",
            AnchorPoint = rightSide and Vector2.new(1, 0) or Vector2.zero,
            Position = rightSide and UDim2.new(1, 0, 0, 35) or UDim2.fromOffset(indent, 35),
            Size = UDim2.fromOffset(18, 18),
            Text = text,
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            AutoButtonColor = false,
            BorderSizePixel = 0
        }, row)

        Paint(button, "BackgroundColor3", "Element")
        Paint(button, "TextColor3", "White")
        Corner(button, 5)

        return button
    end

    local minus = stepButton("-", false)
    local plus = stepButton("+", true)

    local hit = New("TextButton", {
        Position = UDim2.fromOffset(indent + 24, 32),
        Size = UDim2.new(1, -(indent + 48), 0, 26),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false
    }, row)

    local track = New("Frame", {
        Position = UDim2.new(0, 0, 0.5, -2),
        Size = UDim2.new(1, 0, 0, 4),
        BorderSizePixel = 0
    }, hit)

    Paint(track, "BackgroundColor3", "Off")
    Corner(track, 4)

    local fill = New("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BorderSizePixel = 0
    }, track)

    Corner(fill, 4)

    local gradient = New("UIGradient", {}, fill)
    Dyn(gradient, function()
        gradient.Color = ColorSequence.new(Theme.Blue, Theme.Blue:Lerp(Color3.new(1, 1, 1), 0.35))
    end)

    local knob = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(14, 8),
        BorderSizePixel = 0
    }, track)

    Paint(knob, "BackgroundColor3", "White")
    Corner(knob, 4)

    local data = {
        Type = "Slider",
        Value = default,
        Minimum = minimum,
        Maximum = maximum,
        Precision = precision,
        Callback = opts.Callback
    }

    local function setValue(value, fire)
        value = math.clamp(value, minimum, maximum)

        local factor = 10 ^ precision
        value = math.floor(value * factor + 0.5) / factor
        data.Value = value

        local ratio = (value - minimum) / (maximum - minimum)

        fill.Size = UDim2.new(ratio, 0, 1, 0)
        knob.Position = UDim2.new(ratio, 0, 0.5, 0)
        valueLabel.Text = string.format("%." .. precision .. "f", value) .. (opts.Suffix or "")

        if fire and data.Callback then
            data.Callback(value)
        end
    end

    hit.InputBegan:Connect(function(input)
        if isPress(input) then
            beginDrag(input, function(pos)
                if track.AbsoluteSize.X <= 0 then return end

                local ratio = math.clamp((pos.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                setValue(minimum + (maximum - minimum) * ratio, true)
            end)
        end
    end)

    minus.Activated:Connect(function()
        setValue(data.Value - step, true)
    end)

    plus.Activated:Connect(function()
        setValue(data.Value + step, true)
    end)

    data.Set = setValue
    data.Get = function() return data.Value end

    registerSetting(name, data.Get, function(value)
        if type(value) == "number" then
            setValue(value, true)
        end
    end)

    setValue(default, false)

    return data
end

local function AddDualSlider(c, name, minimum, maximum, low, high, opts)
    opts = opts or {}

    local precision = opts.Precision or 0
    local row = Row(c, "Dual", 65, 9)

    local head = HeadRow(row, UDim2.new(0.7, 0, 0, 20), UDim2.fromOffset(0, 10))

    local label = Label(head, name, 12, "Muted", Enum.Font.GothamMedium)
    label.AutomaticSize = Enum.AutomaticSize.X
    label.Size = UDim2.new(0, 0, 1, 0)

    if opts.Hint then
        Hint(head, opts.Hint)
    end

    local valueLabel = Label(row, "", 12, "White", Enum.Font.GothamBold)
    valueLabel.Position = UDim2.new(0.5, 0, 0, 10)
    valueLabel.Size = UDim2.new(0.5, 0, 0, 20)
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right

    local hit = New("TextButton", {
        Position = UDim2.fromOffset(0, 32),
        Size = UDim2.new(1, 0, 0, 26),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false
    }, row)

    local track = New("Frame", {
        Position = UDim2.new(0, 0, 0.5, -2),
        Size = UDim2.new(1, 0, 0, 4),
        BorderSizePixel = 0
    }, hit)

    Paint(track, "BackgroundColor3", "Off")
    Corner(track, 4)

    local fill = New("Frame", {BorderSizePixel = 0}, track)
    Corner(fill, 4)

    local gradient = New("UIGradient", {}, fill)
    Dyn(gradient, function()
        gradient.Color = ColorSequence.new(Theme.Blue, Theme.Blue:Lerp(Color3.new(1, 1, 1), 0.35))
    end)

    local function makeKnob()
        local knob = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.fromOffset(14, 8),
            BorderSizePixel = 0
        }, track)

        Paint(knob, "BackgroundColor3", "White")
        Corner(knob, 4)
        return knob
    end

    local lowKnob = makeKnob()
    local highKnob = makeKnob()

    local data = {
        Type = "DualSlider",
        Low = low,
        High = high,
        Callback = opts.Callback
    }

    local function render()
        local lowRatio = (data.Low - minimum) / (maximum - minimum)
        local highRatio = (data.High - minimum) / (maximum - minimum)

        fill.Position = UDim2.new(lowRatio, 0, 0, 0)
        fill.Size = UDim2.new(highRatio - lowRatio, 0, 1, 0)
        lowKnob.Position = UDim2.new(lowRatio, 0, 0.5, 0)
        highKnob.Position = UDim2.new(highRatio, 0, 0.5, 0)

        local factor = 10 ^ precision
        valueLabel.Text = string.format(
            "%.".. precision .. "f - %.".. precision .. "f",
            math.floor(data.Low * factor + 0.5) / factor,
            math.floor(data.High * factor + 0.5) / factor
        )
    end

    local function setRange(newLow, newHigh, fire)
        newLow = math.clamp(newLow, minimum, maximum)
        newHigh = math.clamp(newHigh, minimum, maximum)

        if newLow > newHigh then
            newLow, newHigh = newHigh, newLow
        end

        data.Low = newLow
        data.High = newHigh
        render()

        if fire and data.Callback then
            data.Callback(newLow, newHigh)
        end
    end

    hit.InputBegan:Connect(function(input)
        if not isPress(input) or track.AbsoluteSize.X <= 0 then return end

        local ratio = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local value = minimum + (maximum - minimum) * ratio
        local grabLow = math.abs(value - data.Low) <= math.abs(value - data.High)

        beginDrag(input, function(pos)
            local r = math.clamp((pos.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            local v = minimum + (maximum - minimum) * r

            if grabLow then
                setRange(v, data.High, true)
            else
                setRange(data.Low, v, true)
            end
        end)
    end)

    data.Set = function(newLow, newHigh, fire)
        setRange(newLow, newHigh, fire)
    end

    data.Get = function()
        return {data.Low, data.High}
    end

    registerSetting(name, data.Get, function(value)
        if type(value) == "table" then
            setRange(value[1] or data.Low, value[2] or data.High, true)
        end
    end)

    render()

    return data
end

local function AddColorPicker(c, name, default, alpha, opts)
    opts = opts or {}

    local row = Row(c, "Color", 45, 9)

    local head = HeadRow(row, UDim2.new(1, -40, 1, 0))
    local label = Label(head, name, 12, "Muted", Enum.Font.GothamMedium)
    label.AutomaticSize = Enum.AutomaticSize.X
    label.Size = UDim2.new(0, 0, 1, 0)

    if opts.Hint then
        Hint(head, opts.Hint)
    end

    local controls = New("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(20, 20),
        BackgroundTransparency = 1
    }, row)

    local dot = ColorDot(controls, default, alpha, 1, opts.Callback)
    dot.Button.AnchorPoint = Vector2.new(0.5, 0.5)
    dot.Button.Position = UDim2.fromScale(0.5, 0.5)
    dot.Spot = c.Spot

    registerSetting(name, function()
        return {dot.Color.R, dot.Color.G, dot.Color.B, dot.Alpha}
    end, function(value)
        if type(value) == "table" then
            dot.Set(Color3.new(value[1], value[2], value[3]), value[4] or 1, true)
        end
    end)

    return dot
end

local function AddDropdown(c, name, options, default, opts)
    opts = opts or {}

    local row = Row(c, "Dropdown", 88, 12)

    local head = HeadRow(row, UDim2.new(1, 0, 0, 20), UDim2.fromOffset(0, 12))

    local label = Label(head, name, 12, "White", Enum.Font.GothamBold)
    label.AutomaticSize = Enum.AutomaticSize.X
    label.Size = UDim2.new(0, 0, 1, 0)

    if opts.Hint then
        Hint(head, opts.Hint)
    end

    local selected = default or options[1] or ""

    local button = New("TextButton", {
        Name = "DropdownButton",
        Position = UDim2.fromOffset(0, 38),
        Size = UDim2.new(1, 0, 0, 36),
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false
    }, row)

    Paint(button, "BackgroundColor3", "Element")
    Corner(button, 8)

    local valueLabel = Label(button, selected, 12, "White", Enum.Font.GothamBold)
    valueLabel.Position = UDim2.fromOffset(15, 0)
    valueLabel.Size = UDim2.new(1, -44, 1, 0)
    valueLabel.TextTruncate = Enum.TextTruncate.AtEnd

    local arrowDown = MakeIcon(button, ICON_CONFIG.UI.Dropdown, 14, "White", "ArrowDown")
    arrowDown.AnchorPoint = Vector2.new(1, 0.5)
    arrowDown.Position = UDim2.new(1, -12, 0.5, 0)

    local arrowUp = MakeIcon(button, ICON_CONFIG.UI.DropdownOpen, 14, "White", "ArrowUp")
    arrowUp.AnchorPoint = Vector2.new(1, 0.5)
    arrowUp.Position = UDim2.new(1, -12, 0.5, 0)
    arrowUp.Visible = false

    local list = New("Frame", {
        Name = "DropdownList",
        BorderSizePixel = 0,
        Visible = false,
        Size = UDim2.fromOffset(200, 100)
    }, PopupLayer)

    Paint(list, "BackgroundColor3", "Element")
    Corner(list, 9)
    Stroke(list, "Border", 0.3)

    local search = New("TextBox", {
        Name = "Search",
        Position = UDim2.fromOffset(6, 6),
        Size = UDim2.new(1, -12, 0, 28),
        BorderSizePixel = 0,
        Text = "",
        PlaceholderText = "Search...",
        TextSize = 12,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false
    }, list)

    Paint(search, "BackgroundColor3", "Panel")
    Paint(search, "TextColor3", "White")
    Paint(search, "PlaceholderColor3", "Dim")
    Corner(search, 7)

    New("UIPadding", {
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 8)
    }, search)

    local scroll = New("ScrollingFrame", {
        Position = UDim2.fromOffset(0, 40),
        Size = UDim2.new(1, 0, 1, -40),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = BarThickness(),
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    }, list)

    Paint(scroll, "ScrollBarImageColor3", "Blue")

    New("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 0)
    }, scroll)

    New("UIPadding", {
        PaddingTop = UDim.new(0, 4),
        PaddingBottom = UDim.new(0, 4),
        PaddingLeft = UDim.new(0, 6),
        PaddingRight = UDim.new(0, 6)
    }, scroll)

    local items = {}
    local dropdown = {Type = "Dropdown", Name = name, Callback = opts.Callback}

    local function refreshItems()
        for option, item in pairs(items) do
            local isSelected = option == selected

            item.Button.BackgroundTransparency = isSelected and 0.35 or 1
            item.Check.Visible = isSelected
            item.Text.TextColor3 = isSelected and Theme.White or Theme.Muted
            item.Text.Position = UDim2.fromOffset(isSelected and 34 or 10, 0)
        end
    end

    Dyn(scroll, refreshItems)

    local function visibleCount()
        local count = 0

        for _, item in pairs(items) do
            if item.Button.Visible then
                count += 1
            end
        end

        return count
    end

    local function fitList()
        local height = math.min(math.max(visibleCount(), 1) * 35 + 50, 262)
        placeBelow(list, button, nil, height, false)
    end

    local function applyFilter()
        local query = string.lower(search.Text):gsub("^%s+", ""):gsub("%s+$", "")

        for option, item in pairs(items) do
            item.Button.Visible = query == "" or string.find(string.lower(option), query, 1, true) ~= nil
        end
    end

    local function choose(option, fire)
        selected = option
        valueLabel.Text = option
        refreshItems()
        Popup.Close()

        if fire and dropdown.Callback then
            dropdown.Callback(option)
        end
    end

    local function addOption(index, option)
        local itemButton = New("TextButton", {
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false,
            LayoutOrder = index
        }, scroll)

        Paint(itemButton, "BackgroundColor3", "Hover")
        Corner(itemButton, 7)

        local check = MakeIcon(itemButton, ICON_CONFIG.UI.Check, 14, "Blue", "Check")
        check.Position = UDim2.fromOffset(18, 17)
        check.Visible = false

        local text = Label(itemButton, option, 12, "Muted", Enum.Font.GothamBold)
        text.Position = UDim2.fromOffset(10, 0)
        text.Size = UDim2.new(1, -40, 1, 0)

        items[option] = {Button = itemButton, Check = check, Text = text}

        itemButton.Activated:Connect(function()
            choose(option, true)
        end)

        itemButton.MouseEnter:Connect(function()
            if option ~= selected then
                itemButton.BackgroundTransparency = 0.6
            end
        end)

        itemButton.MouseLeave:Connect(function()
            if option ~= selected then
                itemButton.BackgroundTransparency = 1
            end
        end)
    end

    local function rebuild(newOptions)
        options = newOptions

        for _, child in ipairs(scroll:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end

        items = {}

        for index, option in ipairs(options) do
            addOption(index, option)
        end

        -- Keep the value valid: if the selection is no longer offered, fall back to the first option.
        if not table.find(options, selected) then
            selected = options[1]
            valueLabel.Text = selected or ""
        end

        refreshItems()
    end

    rebuild(options)

    search:GetPropertyChangedSignal("Text"):Connect(function()
        applyFilter()

        if list.Visible then
            fitList()
        end
    end)

    search.FocusLost:Connect(function(enterPressed)
        if not enterPressed then return end

        for _, option in ipairs(options) do
            local item = items[option]

            if item and item.Button.Visible then
                choose(option, true)
                return
            end
        end
    end)

    button.Activated:Connect(function()
        if Popup.Active and Popup.Active.Frame == list then
            Popup.Close()
            return
        end

        search.Text = ""
        applyFilter()

        arrowDown.Visible = false
        arrowUp.Visible = true

        Popup.Open(c.Spot, list, function()
            arrowDown.Visible = true
            arrowUp.Visible = false
        end)

        fitList()
    end)

    dropdown.Get = function() return selected end
    dropdown.Set = function(value, fire) choose(value, fire) end
    dropdown.SetOptions = rebuild

    registerSetting(name, dropdown.Get, function(value)
        if type(value) == "string" and table.find(options, value) then
            choose(value, true)
        end
    end)

    return dropdown
end

local function AddTextBox(c, name, default, callback)
    local row = Row(c, "Text", 72, 0)

    local label = Label(row, name, 12, "Muted", Enum.Font.GothamMedium)
    label.Position = UDim2.fromOffset(0, 8)
    label.Size = UDim2.new(1, 0, 0, 20)

    local box = New("TextBox", {
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(1, 0, 0, 34),
        BorderSizePixel = 0,
        Text = default or "",
        PlaceholderText = "Enter " .. name:lower(),
        TextSize = 12,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false
    }, row)

    Paint(box, "BackgroundColor3", "Element")
    Paint(box, "TextColor3", "White")
    Paint(box, "PlaceholderColor3", "Dim")
    Corner(box, 8)

    New("UIPadding", {
        PaddingLeft = UDim.new(0, 14),
        PaddingRight = UDim.new(0, 12)
    }, box)

    box.FocusLost:Connect(function(enterPressed)
        if callback then
            callback(box.Text, enterPressed)
        end
    end)

    return box
end

local function AddButton(c, name, callback)
    local row = Row(c, "Button", 64, 0)

    local button = New("TextButton", {
        Name = name:gsub("%W", "") .. "Button",
        Position = UDim2.fromOffset(0, 14),
        Size = UDim2.new(1, 0, 0, 36),
        BorderSizePixel = 0,
        Text = name,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false
    }, row)

    Paint(button, "BackgroundColor3", "Element")
    Paint(button, "TextColor3", "White")
    Corner(button, 8)

    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Theme.Hover
    end)

    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Theme.Element
    end)

    button.Activated:Connect(callback)

    return button
end

local function AddKeyPicker(c, name, key, mode, opts)
    opts = opts or {}

    local row = Row(c, "Key", 65, 0)

    local label = Label(row, name, 12, "Muted", Enum.Font.GothamMedium)
    label.Position = UDim2.fromOffset(0, 8)
    label.Size = UDim2.new(1, 0, 0, 20)

    local kp = MakeKeyPicker(row, name, {
        Key = key,
        Mode = mode,
        Size = UDim2.new(1, 0, 0, 34),
        ShowMode = true,
        Spot = c.Spot,
        Callback = opts.Callback,
        GetState = opts.GetState
    })

    kp.Button.Position = UDim2.fromOffset(0, 30)
    kp.Button.TextSize = 12

    registerSetting(name, kp.Get, kp.Set)
    kp.Apply()

    return kp
end

local function AddTabBox(c, opts)
    opts = opts or {}

    Divider(c)

    local row = New("Frame", {
        Name = "TabBox",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1
    }, c.Body)

    New("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, row)

    local alignment = opts.Align or "Left"
    local horizontal = alignment == "Center" and Enum.HorizontalAlignment.Center
        or alignment == "Right" and Enum.HorizontalAlignment.Right
        or Enum.HorizontalAlignment.Left

    local bar = New("Frame", {
        Name = "Bar",
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        LayoutOrder = 1
    }, row)

    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, bar)

    local tabs = {}
    local entries = {}
    local selectedName = nil
    local tabCount = 0
    local tabBox = {}

    local function refreshButtons()
        for name, entry in pairs(entries) do
            local active = selectedName == name

            entry.Button.BackgroundColor3 = active and Theme.Element or Theme.Panel
            entry.Button.TextColor3 = active and Theme.Blue or Theme.Muted
            entry.Line.BackgroundColor3 = Theme.Blue
            entry.Line.Visible = active
        end
    end

    Dyn(bar, refreshButtons)

    local function select(name)
        selectedName = name

        for tabName, tab in pairs(tabs) do
            tab.Body.Visible = tabName == name
        end

        refreshButtons()
        refreshBodies()
    end

    local function ensureTab(name)
        if tabs[name] then
            return tabs[name]
        end

        tabCount += 1

        local body = New("Frame", {
            Name = name .. "Tab",
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Visible = false,
            LayoutOrder = 2
        }, row)

        New("UIListLayout", {
            Padding = UDim.new(0, 0),
            SortOrder = Enum.SortOrder.LayoutOrder
        }, body)

        local tab = {Body = body, Spot = c.Spot, HasRows = false}
        tabs[name] = tab

        local button = New("TextButton", {
            Name = name .. "TabButton",
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.fromOffset(0, 28),
            Text = name,
            TextSize = 11,
            Font = Enum.Font.GothamBold,
            AutoButtonColor = false,
            BorderSizePixel = 0,
            LayoutOrder = tabCount
        }, bar)

        New("UIPadding", {
            PaddingLeft = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 14)
        }, button)

        Corner(button, 8)

        local line = New("Frame", {
            Name = "Indicator",
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.new(0.5, 0, 1, -2),
            Size = UDim2.new(1, -20, 0, 2),
            BorderSizePixel = 0,
            Visible = false
        }, button)

        Corner(line, 2)

        entries[name] = {Button = button, Line = line}

        button.Activated:Connect(function()
            select(name)
        end)

        return tab
    end

    for _, name in ipairs(opts.Tabs or {}) do
        ensureTab(name)
    end

    tabBox.Tab = function(name)
        local tab = ensureTab(name)

        if not selectedName then
            select(name)
        end

        return tab
    end

    tabBox.Select = select
    tabBox.Get = function()
        return selectedName
    end

    if opts.Tabs and opts.Tabs[1] then
        select(opts.Default or opts.Tabs[1])
    end

    return tabBox
end

local function AddSubWindow(c, buttonText, title, opts)
    opts = opts or {}

    local win = New("Frame", {
        Name = "SubWindow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(opts.Width or 380, opts.Height or 340),
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 140,
        Active = true
    }, Main)

    Paint(win, "BackgroundColor3", "Panel")
    Corner(win, 14)
    Stroke(win, "Border", 0.2)

    local titleBar = New("Frame", {
        Name = "Titlebar",
        Size = UDim2.new(1, 0, 0, 36),
        BorderSizePixel = 0,
        Active = true,
        ZIndex = 141
    }, win)

    Paint(titleBar, "BackgroundColor3", "Header")
    Corner(titleBar, 14)

    local titleLabel = Label(titleBar, title or buttonText, 12, "White", Enum.Font.GothamBold)
    titleLabel.Position = UDim2.fromOffset(14, 0)
    titleLabel.Size = UDim2.new(1, -60, 1, 0)
    titleLabel.ZIndex = 141

    local close = New("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -8, 0.5, 0),
        Size = UDim2.fromOffset(24, 24),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 142
    }, titleBar)

    MakeIcon(close, ICON_CONFIG.UI.Close, 14, "Muted", "CloseIcon")

    local body = New("ScrollingFrame", {
        Position = UDim2.fromOffset(0, 40),
        Size = UDim2.new(1, 0, 1, -44),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = BarThickness(),
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 141
    }, win)

    Paint(body, "ScrollBarImageColor3", "Blue")

    New("UIPadding", {
        PaddingLeft = UDim.new(0, 14),
        PaddingRight = UDim.new(0, 16)
    }, body)

    New("UIListLayout", {
        Padding = UDim.new(0, 0),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, body)

    local inner = {Body = body, Spot = win, HasRows = false}
    local window = {Frame = win, Container = inner}

    local function setOpen(open)
        win.Visible = open
    end

    function window.Open()
        setOpen(true)
    end

    function window.Close()
        setOpen(false)
    end

    titleBar.InputBegan:Connect(function(input)
        if isPress(input) then
            local startPos = input.Position
            local startPosition = win.Position

            beginDrag(input, function(pos)
                local s = Scale.Scale
                local delta = (pos - startPos) / s

                win.Position = UDim2.new(
                    startPosition.X.Scale,
                    startPosition.X.Offset + delta.X,
                    startPosition.Y.Scale,
                    startPosition.Y.Offset + delta.Y
                )
            end)
        end
    end)

    close.Activated:Connect(function()
        window.Close()
    end)

    table.insert(Windows, window)

    local button = AddButton(c, buttonText, function()
        window.Open()
    end)

    window.Button = button
    return window
end

local function AddListBox(c, height, emptyText, onSelect)
    local row = Row(c, "List", height + 24, 0)

    local box = New("Frame", {
        Position = UDim2.fromOffset(0, 12),
        Size = UDim2.new(1, 0, 0, height),
        BorderSizePixel = 0
    }, row)

    Paint(box, "BackgroundColor3", "Background")
    Corner(box, 10)

    local empty = Label(box, emptyText, 12, "Dim", Enum.Font.GothamBold)
    empty.Size = UDim2.fromScale(1, 1)
    empty.TextXAlignment = Enum.TextXAlignment.Center

    local scroll = New("ScrollingFrame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = BarThickness(),
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    }, box)

    Paint(scroll, "ScrollBarImageColor3", "Blue")

    New("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2)
    }, scroll)

    New("UIPadding", {
        PaddingTop = UDim.new(0, 6),
        PaddingBottom = UDim.new(0, 6),
        PaddingLeft = UDim.new(0, 6),
        PaddingRight = UDim.new(0, 10)
    }, scroll)

    local selected = nil
    local items = {}

    local function refreshItems()
        for option, item in pairs(items) do
            local isSelected = option == selected
            item.BackgroundTransparency = isSelected and 0 or 1
            item.TextColor3 = isSelected and Theme.White or Theme.Dim
        end
    end

    Dyn(scroll, refreshItems)

    local function select(option, fire)
        selected = option
        refreshItems()

        if fire and onSelect then
            onSelect(option)
        end
    end

    local function rebuild(options)
        for _, child in ipairs(scroll:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end

        items = {}
        empty.Visible = #options == 0

        for index, option in ipairs(options) do
            local item = New("TextButton", {
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundTransparency = 1,
                Text = option,
                TextSize = 12,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutoButtonColor = false,
                LayoutOrder = index
            }, scroll)

            Paint(item, "BackgroundColor3", "Element")
            Corner(item, 7)

            New("UIPadding", {PaddingLeft = UDim.new(0, 10)}, item)

            item.Activated:Connect(function()
                select(option, true)
            end)

            items[option] = item
        end

        refreshItems()
    end

    rebuild({})

    return {
        Get = function() return selected end,
        SetOptions = rebuild,
        Set = function(value) select(value, true) end
    }
end

local SubBar = New("Frame", {
    Name = "SettingsSubTabs",
    Size = UDim2.new(1, 0, 0, 30),
    BackgroundTransparency = 1,
    Visible = false
}, Content)

New("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    Padding = UDim.new(0, 6),
    SortOrder = Enum.SortOrder.LayoutOrder
}, SubBar)

local SubButtons = {}

local function renderSubTabs()
    for name, button in pairs(SubButtons) do
        local active = ActiveSub == name
        button.BackgroundColor3 = active and Theme.Element or Theme.Panel
        button.TextColor3 = active and Theme.Blue or Theme.Dim
    end
end

local function addSettingsSub(name, order)
    SettingsPageKeys[name] = "Settings/" .. name

    local button = New("TextButton", {
        Name = name .. "SubTab",
        Size = UDim2.fromOffset(96, 28),
        Text = name,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        BorderSizePixel = 0,
        LayoutOrder = order
    }, SubBar)

    Corner(button, 8)
    SubButtons[name] = button

    button.Activated:Connect(function()
        ActiveSub = name
        renderSubTabs()
        switchPage()
    end)

    renderSubTabs()
end

addSettingsSub("Interface", 1)

Dyn(SubBar, renderSubTabs)

local applyOverlays
local applyMobileLayout, MobileCfg

local function make(class, props, target)
    local obj = Instance.new(class)

    for key, value in pairs(props or {}) do
        obj[key] = value
    end

    obj.Parent = target
    return obj
end

local function kpCurrent(kp)
    if kp.GetState then
        return kp.GetState() and true or false
    end

    return kp.State and true or false
end

do
local WatermarkFrame = make("Frame", {
    Name = "Watermark",
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 22),
    Size = UDim2.fromOffset(650, 44),
    BorderSizePixel = 0
}, Overlay)

Paint(WatermarkFrame, "BackgroundColor3", "Background")
Corner(WatermarkFrame, 13)
Stroke(WatermarkFrame, "Border", 0.12)

local WatermarkScale = make("UIScale", {Scale = 1}, WatermarkFrame)

local function updateWatermarkScale()
    local camera = workspace.CurrentCamera

    if camera then
        WatermarkScale.Scale = math.clamp(camera.ViewportSize.X / 900, 0.65, 1)
    end
end

updateWatermarkScale()
Connect(workspace:GetPropertyChangedSignal("CurrentCamera"), updateWatermarkScale)

local WatermarkContent = make("Frame", {
    Name = "Content",
    Position = UDim2.fromOffset(12, 0),
    Size = UDim2.new(1, -24, 1, 0),
    BackgroundTransparency = 1
}, WatermarkFrame)

local BrandLabel = make("TextLabel", {
    Name = "Brand",
    Size = UDim2.fromOffset(67, 44),
    BackgroundTransparency = 1,
    Text = "SEVERE",
    TextSize = 15,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, WatermarkContent)

Paint(BrandLabel, "TextColor3", "White")

local WmAccent = make("Frame", {
    Position = UDim2.fromOffset(69, 10),
    Size = UDim2.fromOffset(3, 24),
    BorderSizePixel = 0
}, WatermarkContent)

Paint(WmAccent, "BackgroundColor3", "Blue")

local WmDivider = make("Frame", {
    Position = UDim2.fromOffset(84, 9),
    Size = UDim2.fromOffset(1, 26),
    BorderSizePixel = 0
}, WatermarkContent)

Paint(WmDivider, "BackgroundColor3", "Border")

local StatsRow = make("Frame", {
    Name = "Stats",
    Position = UDim2.fromOffset(96, 0),
    Size = UDim2.new(1, -96, 1, 0),
    BackgroundTransparency = 1
}, WatermarkContent)

make("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    HorizontalAlignment = Enum.HorizontalAlignment.Left,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 10)
}, StatsRow)

local function addStat(name, width, order, initial)
    local label = make("TextLabel", {
        Name = name,
        Size = UDim2.fromOffset(width, 30),
        BackgroundTransparency = 1,
        Text = initial,
        TextSize = 12,
        Font = Enum.Font.GothamMedium,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Center,
        LayoutOrder = order
    }, StatsRow)

    Paint(label, "TextColor3", "Muted")
    return label
end

local FpsLabel = addStat("FPS", 53, 1, "-- FPS")
local PingLabel = addStat("Ping", 62, 2, "-- ms")
local DeviceLabel = addStat("Device", 58, 3, "--")
local PlayersLabel = addStat("Players", 53, 4, "0/--")

local function getDevice()
    if UIS.TouchEnabled and not UIS.KeyboardEnabled then
        return "Mobile"
    elseif UIS.GamepadEnabled and not UIS.KeyboardEnabled then
        return "Console"
    end

    return "PC"
end

DeviceLabel.Text = getDevice()

local GameInfo = make("Frame", {
    Name = "GameInfo",
    Size = UDim2.fromOffset(190, 30),
    BackgroundTransparency = 1,
    LayoutOrder = 5
}, StatsRow)

make("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    HorizontalAlignment = Enum.HorizontalAlignment.Left,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 7)
}, GameInfo)

local IconImage = make("ImageLabel", {
    Name = "GameIcon",
    Size = UDim2.fromOffset(24, 24),
    BackgroundTransparency = 0,
    Image = "",
    ScaleType = Enum.ScaleType.Crop,
    LayoutOrder = 1
}, GameInfo)

Paint(IconImage, "BackgroundColor3", "Border")
Corner(IconImage, 6)

local PlaceLabel = make("TextLabel", {
    Name = "Place",
    Size = UDim2.new(1, -31, 1, 0),
    BackgroundTransparency = 1,
    Text = "Loading place...",
    TextSize = 12,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextTruncate = Enum.TextTruncate.AtEnd,
    LayoutOrder = 2
}, GameInfo)

Paint(PlaceLabel, "TextColor3", "White")

task.spawn(function()
    local ok, info = pcall(function()
        return MarketplaceService:GetProductInfo(game.PlaceId)
    end)

    if ok and info and info.Name then
        PlaceLabel.Text = info.Name
    else
        PlaceLabel.Text = game.Name ~= "" and game.Name or ("Place " .. tostring(game.PlaceId))
    end

    local url = "https://thumbnails.roblox.com/v1/games/icons?universeIds="
        .. tostring(game.GameId) .. "&size=150x150&format=Png&isCircular=false"

    if type(game.HttpGet) == "function" then
        local requestOk, response = pcall(function()
            return game:HttpGet(url)
        end)

        if requestOk and type(response) == "string" then
            local decodeOk, data = pcall(function()
                return HttpService:JSONDecode(response)
            end)

            if decodeOk and data and data.data then
                local entry = data.data[1]

                if entry and entry.imageUrl then
                    IconImage.Image = entry.imageUrl
                    return
                end
            end
        end
    end

    IconImage.Image = "rbxthumb://type=GameIcon&id=" .. tostring(game.GameId) .. "&w=150&h=150"
end)

local function updatePlayers()
    PlayersLabel.Text = tostring(#Players:GetPlayers()) .. "/" .. tostring(Players.MaxPlayers)
end

Connect(Players.PlayerAdded, updatePlayers)
Connect(Players.PlayerRemoving, updatePlayers)
updatePlayers()

local frameCount = 0
local sampleTime = 0
local sampleStart = os.clock()

Connect(RunService.RenderStepped, function(dt)
    frameCount += 1
    sampleTime += dt

    if sampleTime >= 0.5 then
        local elapsed = os.clock() - sampleStart

        FpsLabel.Text = tostring(math.floor(frameCount / math.max(elapsed, 0.001) + 0.5)) .. " FPS"
        frameCount = 0
        sampleTime = 0
        sampleStart = os.clock()

        DeviceLabel.Text = getDevice()

        local ok, ping = pcall(function()
            return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
        end)

        PingLabel.Text = ok and type(ping) == "number" and (tostring(math.floor(ping + 0.5)) .. " ms") or "-- ms"
        updatePlayers()
    end
end)

local KeybindFrame = make("Frame", {
    Name = "KeybindList",
    Position = UDim2.new(0, 25, 0.35, 0),
    Size = UDim2.fromOffset(245, 44),
    BorderSizePixel = 0,
    Active = true
}, Overlay)

Paint(KeybindFrame, "BackgroundColor3", "Background")
Corner(KeybindFrame, 11)
Stroke(KeybindFrame, "Border", 0.12)

local KeybindHeader = make("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 44),
    BackgroundTransparency = 1,
    Active = true
}, KeybindFrame)

local KbAccent = make("Frame", {
    Position = UDim2.fromOffset(12, 13),
    Size = UDim2.fromOffset(3, 18),
    BorderSizePixel = 0
}, KeybindHeader)

Paint(KbAccent, "BackgroundColor3", "Blue")

local KbTitle = make("TextLabel", {
    Position = UDim2.fromOffset(23, 0),
    Size = UDim2.fromOffset(120, 44),
    BackgroundTransparency = 1,
    Text = "Keybinds",
    TextSize = 14,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, KeybindHeader)

Paint(KbTitle, "TextColor3", "White")

local KbModes = {"All binds", "Enabled", "Active"}
local KbModeIndex = 1

local KbModeButton = make("TextButton", {
    Name = "DisplayMode",
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -10, 0.5, 0),
    Size = UDim2.fromOffset(105, 27),
    BorderSizePixel = 0,
    Text = "All binds  v",
    TextSize = 10,
    Font = Enum.Font.GothamSemibold,
    AutoButtonColor = false
}, KeybindHeader)

Paint(KbModeButton, "BackgroundColor3", "Panel")
Paint(KbModeButton, "TextColor3", "Blue")
Corner(KbModeButton, 6)

local KbList = make("Frame", {
    Name = "BindList",
    Position = UDim2.fromOffset(10, 49),
    Size = UDim2.new(1, -20, 0, 0),
    BackgroundTransparency = 1
}, KeybindFrame)

make("UIListLayout", {
    Padding = UDim.new(0, 5),
    SortOrder = Enum.SortOrder.LayoutOrder
}, KbList)

local KbRows = {}

local function keybindRow(kp)
    local row = KbRows[kp]

    if row then
        return row
    end

    local frame = make("Frame", {
        Name = "Bind",
        Size = UDim2.new(1, 0, 0, 32),
        BorderSizePixel = 0,
        Visible = false
    }, KbList)

    Paint(frame, "BackgroundColor3", "Panel")
    Corner(frame, 6)

    local nameLabel = make("TextLabel", {
        Position = UDim2.fromOffset(9, 0),
        Size = UDim2.new(1, -83, 1, 0),
        BackgroundTransparency = 1,
        TextSize = 11,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd
    }, frame)

    local keyBox = make("TextLabel", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -7, 0.5, 0),
        Size = UDim2.fromOffset(62, 22),
        BorderSizePixel = 0,
        TextSize = 10,
        Font = Enum.Font.GothamSemibold
    }, frame)

    Paint(keyBox, "BackgroundColor3", "Background")
    Corner(keyBox, 5)

    row = {Frame = frame, Name = nameLabel, Key = keyBox}
    KbRows[kp] = row

    return row
end

local function refreshKeybindListNow()
    local visibleCount = 0

    for _, kp in ipairs(KeyPickerList) do
        local row = keybindRow(kp)
        local enabled = kpCurrent(kp)
        local active = kp.Key ~= nil and kp.Mode ~= "None" and (kp.State or kp.Mode == "Always")
        local shown = kp.Key ~= nil and kp.Mode ~= "None"

        if KbModeIndex == 2 then
            shown = shown and enabled
        elseif KbModeIndex == 3 then
            shown = shown and active
        end

        row.Frame.Visible = shown
        row.Name.Text = kp.Id .. "  (" .. kp.Mode .. ")"
        row.Key.Text = keyLabel(kp.Key)
        row.Name.TextColor3 = enabled and Theme.White or Theme.Muted
        row.Key.TextColor3 = active and Color3.fromRGB(92, 205, 140) or Theme.Dim

        if shown then
            visibleCount += 1
        end
    end

    local showList = Settings["Show Keybind List"] == nil or Settings["Show Keybind List"].Get()
    local height = visibleCount > 0 and (49 + visibleCount * 37 + 7) or 44

    KeybindFrame.Size = UDim2.fromOffset(245, height)
    KeybindFrame.Visible = showList
    KbList.Visible = height > 44
    KbModeButton.Text = KbModes[KbModeIndex] .. "  v"
end

Dyn(KeybindFrame, refreshKeybindListNow)

refreshKeybindList = refreshKeybindListNow

KbModeButton.Activated:Connect(function()
    KbModeIndex = KbModeIndex % #KbModes + 1
    refreshKeybindListNow()
end)

KeybindHeader.InputBegan:Connect(function(input)
    if not isPress(input) then return end

    local startPos = input.Position
    local startPosition = KeybindFrame.Position

    beginDrag(input, function(pos)
        local delta = pos - startPos

        KeybindFrame.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end)
end)

local MobileGui = make("Frame", {
    Name = "MobileButtons",
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Visible = UIS.TouchEnabled
}, Overlay)

MobileCfg = {
    Width = 100,
    Height = 36,
    Transparency = 0,
    ClickMode = "Tap",
    OpenHold = 0.5,
    CloseHold = 0.5
}

local MobileLocked = false
local MobileStrokes = {}
local DOUBLE_TAP_WINDOW = 0.35
local pressToken = 0
local pressMoved = false
local lastTapAt = -math.huge

local MobileToggle = make("TextButton", {
    Name = "ToggleButton",
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -10, 0, 10),
    Size = UDim2.fromOffset(100, 36),
    Text = "Toggle",
    TextSize = 14,
    Font = Enum.Font.GothamSemibold,
    AutoButtonColor = false,
    BorderSizePixel = 0,
    Visible = false
}, MobileGui)

local MobileLock = make("TextButton", {
    Name = "LockButton",
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -10, 0, 54),
    Size = UDim2.fromOffset(100, 36),
    Text = "Lock",
    TextSize = 14,
    Font = Enum.Font.GothamSemibold,
    AutoButtonColor = false,
    BorderSizePixel = 0,
    Visible = false
}, MobileGui)

for _, button in ipairs({MobileToggle, MobileLock}) do
    Paint(button, "BackgroundColor3", "Background")
    Paint(button, "TextColor3", "White")
    Corner(button, 5)
    table.insert(MobileStrokes, Stroke(button, "White", 0.85))
end

applyMobileLayout = function()
    local alpha = MobileCfg.Transparency / 100

    for _, button in ipairs({MobileToggle, MobileLock}) do
        button.Size = UDim2.fromOffset(MobileCfg.Width, MobileCfg.Height)
        button.BackgroundTransparency = alpha
        button.TextTransparency = alpha
    end

    MobileLock.Position = UDim2.new(1, -10, 0, 10 + MobileCfg.Height + 8)

    for _, stroke in ipairs(MobileStrokes) do
        stroke.Transparency = alpha
    end
end

local function makeDraggable(button)
    button.InputBegan:Connect(function(input)
        if not isPress(input) then return end

        pressMoved = false

        if MobileLocked then return end

        local startPos = input.Position
        local startPosition = button.Position
        local moved = false

        beginDrag(input, function(pos)
            local delta = pos - startPos

            if delta.Magnitude > 6 then
                moved = true
                pressMoved = true
            end

            if moved then
                button.Position = UDim2.new(
                    startPosition.X.Scale,
                    startPosition.X.Offset + delta.X,
                    startPosition.Y.Scale,
                    startPosition.Y.Offset + delta.Y
                )
            end
        end)
    end)
end

makeDraggable(MobileToggle)
makeDraggable(MobileLock)

MobileToggle.InputBegan:Connect(function(input)
    if not isPress(input) then return end

    pressToken += 1
    pressMoved = false

    local token = pressToken

    if MobileCfg.ClickMode ~= "Hold" then return end

    local wait = MenuOpen and MobileCfg.CloseHold or MobileCfg.OpenHold

    task.delay(wait, function()
        if token == pressToken and not pressMoved then
            pressToken += 1
            setMenuOpen(not MenuOpen)
        end
    end)
end)

Connect(UIS.InputEnded, function(input)
    if isPress(input) then
        pressToken += 1
    end
end)

MobileToggle.Activated:Connect(function()
    if pressMoved then return end

    local mode = MobileCfg.ClickMode

    if mode == "Hold" then return end

    if mode == "Double Tap" then
        local now = os.clock()

        if now - lastTapAt > DOUBLE_TAP_WINDOW then
            lastTapAt = now
            return
        end

        lastTapAt = -math.huge
    end

    setMenuOpen(not MenuOpen)
end)

MobileLock.Activated:Connect(function()
    if pressMoved then return end

    MobileLocked = not MobileLocked
    MobileLock.Text = MobileLocked and "Unlock" or "Lock"
end)

setMenuOpen = function(open)
    if MenuKeyPicker and MenuKeyPicker.Mode == "Always" then
        open = true
    end

    MenuOpen = open and true or false
    Main.Visible = MenuOpen

    ParticleGui.Enabled = MenuOpen and ParticleState.Enabled

    if not MenuOpen then
        Popup.Close()
        ParticleLayer:ClearAllChildren()
        table.clear(ParticleState.Active)
    end
end

applyOverlays = function()
    local function on(name, default)
        local entry = Settings[name]

        if entry then
            return entry.Get() and true or false
        end

        return default
    end

    WatermarkFrame.Visible = on("Show Watermark", true)
    MobileToggle.Visible = on("Show Mobile Buttons", false) and UIS.TouchEnabled
    MobileLock.Visible = MobileToggle.Visible
    refreshKeybindList()
end

end

local setParticlesEnabled

local setCustomDecal

do
    local ParticlePresets = {
        Snow = {
            Mode = "Fall",
            Color = Color3.fromRGB(235, 242, 255),
            Speed = 35,
            Size = 4,
            Rate = 18,
            Spread = 30
        },
        Stars = {
            Mode = "Twinkle",
            Color = Color3.fromRGB(255, 226, 140),
            Speed = 4,
            Size = 3,
            Rate = 12,
            Spread = 0
        },
        Blossom = {
            Mode = "Fall",
            Color = Color3.fromRGB(255, 184, 212),
            Speed = 28,
            Size = 14,
            Rate = 8,
            Spread = 60,
            Decal = "rbxassetid://4915391487"
        }
    }

    local MAX_PARTICLES = 140

    local function viewport()
        local camera = workspace.CurrentCamera
        return camera and camera.ViewportSize or Vector2.new(1280, 720)
    end

    local function clearParticles()
        for _, particle in ipairs(ParticleState.Active) do
            particle.Frame:Destroy()
        end

        table.clear(ParticleState.Active)
    end

    local function spawnParticle()
        local view = viewport()
        local decal = ParticleState.Image
        local frame

        if decal then
            frame = New("ImageLabel", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Image = decal,
                ImageColor3 = ParticleState.Color,
                ZIndex = 60
            }, ParticleLayer)
        else
            frame = New("Frame", {
                BackgroundColor3 = ParticleState.Color,
                BorderSizePixel = 0,
                ZIndex = 60
            }, ParticleLayer)

            New("UICorner", {CornerRadius = UDim.new(1, 0)}, frame)
        end

        local mode = ParticleState.Mode

        table.insert(ParticleState.Active, {
            Frame = frame,
            Mode = mode,
            Scale = 0.6 + math.random() * 0.8,
            SpeedFactor = 0.6 + math.random() * 0.8,
            X = math.random() * view.X,
            Y = mode == "Fall" and -20 or math.random() * view.Y,
            Age = 0,
            Life = 3 + math.random() * 4,
            Phase = math.random() * math.pi * 2,
            Freq = 0.6 + math.random(),
            Spin = (math.random() < 0.5 and -1 or 1) * (20 + math.random() * 40)
        })
    end

    local function particleSize(particle)
        local size = ParticleState.Size * particle.Scale

        if particle.Frame:IsA("ImageLabel") then
            size *= 1.6
        end

        return size
    end

    local function updateParticles(dt)
        local state = ParticleState
        local view = viewport()

        state.Accumulator += state.Rate * dt

        while state.Accumulator >= 1 do
            state.Accumulator -= 1

            if #state.Active < MAX_PARTICLES then
                spawnParticle()
            end
        end

        for index = #state.Active, 1, -1 do
            local particle = state.Active[index]
            local size = particleSize(particle)
            local dead = false

            particle.Frame.Size = UDim2.fromOffset(size, size)

            if particle.Mode == "Fall" then
                particle.Age += dt
                particle.Y += state.Speed * particle.SpeedFactor * dt

                local sway = math.sin(particle.Age * particle.Freq + particle.Phase) * state.Spread * 0.6
                particle.Frame.Position = UDim2.fromOffset(particle.X + sway, particle.Y)

                if particle.Frame:IsA("ImageLabel") then
                    particle.Frame.Rotation = particle.Age * particle.Spin
                end

                dead = particle.Y > view.Y + size
            else
                particle.Age += dt * math.max(state.Speed, 1) / 10

                local alpha = math.sin(math.pi * math.min(particle.Age / particle.Life, 1))
                particle.Frame.Position = UDim2.fromOffset(particle.X, particle.Y)

                if particle.Frame:IsA("ImageLabel") then
                    particle.Frame.ImageTransparency = 1 - alpha
                else
                    particle.Frame.BackgroundTransparency = 1 - alpha
                end

                dead = particle.Age >= particle.Life
            end

            if dead then
                particle.Frame:Destroy()
                table.remove(state.Active, index)
            end
        end
    end

    Connect(RunService.Heartbeat, function(dt)
        if ParticleState.Enabled and MenuOpen then
            updateParticles(dt)
        end
    end)

    setParticlesEnabled = function(value)
        ParticleState.Enabled = value and true or false
        ParticleGui.Enabled = ParticleState.Enabled and MenuOpen

        if not ParticleState.Enabled then
            clearParticles()
        end
    end

    applyParticlePreset = function(name)
        ParticleState.Preset = name
        local preset = ParticlePresets[name]

        if preset then
            ParticleState.Mode = preset.Mode
            ParticleState.Image = preset.Decal

            Settings["Particle Speed"].Set(preset.Speed)
            Settings["Particle Size"].Set(preset.Size)
            Settings["Particle Rate"].Set(preset.Rate)
            Settings["Particle Spread"].Set(preset.Spread)
            Settings["Particle Color"].Set({preset.Color.R, preset.Color.G, preset.Color.B, 1})
        else
            ParticleState.Mode = "Fall"
            ParticleState.Image = ParticleState.CustomDecal
        end

        clearParticles()
    end

    setCustomDecal = function(text)
        local id = tostring(text or ""):match("%d+")
        ParticleState.CustomDecal = id and ("rbxassetid://" .. id) or nil

        if ParticleState.Preset == "Custom" then
            ParticleState.Image = ParticleState.CustomDecal
            clearParticles()
        end
    end
end

do
    local left, right = CreatePage("Settings/Interface", 38)

    local function styleScroll(obj)
        if not obj:IsA("ScrollingFrame") then
            return
        end

        local visible = ShowScrollbars and obj.Name ~= "CardBody"
        obj.ScrollBarThickness = visible and BarThickness() or 0
        obj.ScrollBarImageTransparency = visible and 0 or 1
    end

    local function applyScrollbars()
        for _, obj in ipairs(GUI:GetDescendants()) do
            styleScroll(obj)
        end
    end

    Connect(GUI.DescendantAdded, styleScroll)

    local card = Section(left, "Interface", "Settings/Interface")

    MenuKeyPicker = AddKeyPicker(card, "Menu Key", "RightShift", "Toggle", {
        Callback = function(state)
            setMenuOpen(state)
        end,
        GetState = function()
            return MenuOpen
        end
    })

    AddToggle(card, "Show Watermark", true, {Callback = applyOverlays})
    AddToggle(card, "Show Keybind List", true, {Callback = applyOverlays})
    AddToggle(card, "Auto Resize", true, {
        Hint = "Fit the window to the screen. Turn off to use Interface Scale",
        Callback = function(value)
            AutoResize = value
            refreshScale()
        end
    })
    AddSlider(card, "Interface Scale", 70, 100, 100, {
        Precision = 0,
        Suffix = "%",
        Hint = "Used when Auto Resize is off",
        Callback = function(value)
            UserScale = value / 100
            refreshScale()
        end
    })
    AddSlider(card, "Components Size", 70, 110, 100, {
        Precision = 0,
        Suffix = "%",
        Hint = "Scales the controls on every page",
        Callback = function(value)
            ContentScale.Scale = value / 100
        end
    })
    AddToggle(card, "Show Scrollbars", true, {
        Hint = "Turn off to hide the scroll bars",
        Callback = function(value)
            ShowScrollbars = value
            applyScrollbars()
        end
    })
    AddToggle(card, "Show Tooltips", true)
    AddToggle(card, "Compact Mode", false, {
        Callback = function(value)
            Compact = value
            applyCompact()
        end
    })
    AddToggle(card, "Remember Window Position", false, {
        Callback = function(value)
            if value then
                saveWindowState()
            end
        end
    })
    AddButton(card, "Reset Window Position", function()
        Main.Position = UDim2.fromScale(0.5, 0.5)
        saveWindowState()
    end)
    AddButton(card, "Unload UI", function()
        if Env.SEVEREUnload then
            Env.SEVEREUnload()
        end
    end)

    card = Section(right, "Menu", "Settings/Interface")

    local windowGroup = AddGroup(card, "Window")

    AddSlider(windowGroup, "Corner Radius", 0, 30, 18, {
        Precision = 0,
        Suffix = "px",
        Callback = function(value)
            MenuStyle.Radius = value
            applyRadius()
        end
    })

    AddSlider(windowGroup, "Menu Transparency", 0, 70, 0, {
        Precision = 0,
        Suffix = "%",
        Hint = "Makes the window and panels see-through",
        Callback = function(value)
            MenuStyle.Alpha = value / 100
            SetTheme(ThemeName, AccentOverride)
        end
    })

    card = Section(right, "Menu Particles", "Settings/Interface")

    local particles = AddToggle(card, "Menu Particles", false, {
        Callback = setParticlesEnabled
    })

    local particleBox = AddDependency(card, particles)

    local customGate = {
        Get = function()
            return ParticleState.Preset == "Custom"
        end,
        Listeners = {}
    }

    AddDropdown(particleBox, "Particle Preset", {"Snow", "Stars", "Blossom", "Custom"}, "Snow", {
        Callback = function(value)
            applyParticlePreset(value)

            for _, listener in ipairs(customGate.Listeners) do
                listener(value == "Custom")
            end
        end
    })

    local customBox = AddDependency(particleBox, customGate)

    AddTextBox(customBox, "Custom Decal ID", "", function(text)
        setCustomDecal(text)
    end)

    AddSlider(particleBox, "Particle Speed", 0, 100, 35, {
        Sub = true,
        Callback = function(value)
            ParticleState.Speed = value
        end
    })

    AddSlider(particleBox, "Particle Size", 1, 30, 4, {
        Sub = true,
        Suffix = " px",
        Callback = function(value)
            ParticleState.Size = value
        end
    })

    AddSlider(particleBox, "Particle Rate", 1, 60, 18, {
        Sub = true,
        Suffix = "/s",
        Callback = function(value)
            ParticleState.Rate = value
        end
    })

    AddSlider(particleBox, "Particle Spread", 0, 100, 30, {
        Sub = true,
        Hint = "Sideways drift",
        Callback = function(value)
            ParticleState.Spread = value
        end
    })

    AddColorPicker(particleBox, "Particle Color", Color3.fromRGB(235, 242, 255), 1, {
        Callback = function(color)
            ParticleState.Color = color

            for _, particle in ipairs(ParticleState.Active) do
                if particle.Frame:IsA("ImageLabel") then
                    particle.Frame.ImageColor3 = color
                else
                    particle.Frame.BackgroundColor3 = color
                end
            end
        end
    })

    if UIS.TouchEnabled then
        card = Section(right, "Mobile Buttons", "Settings/Interface")

        AddToggle(card, "Show Mobile Buttons", true, {
            Hint = "Toggle and Lock buttons for touch devices",
            Callback = applyOverlays
        })

        AddSlider(card, "Button Width", 60, 220, 100, {
            Precision = 0,
            Suffix = " px",
            Callback = function(value)
                MobileCfg.Width = value
                applyMobileLayout()
            end
        })

        AddSlider(card, "Button Height", 24, 90, 36, {
            Precision = 0,
            Suffix = " px",
            Callback = function(value)
                MobileCfg.Height = value
                applyMobileLayout()
            end
        })

        AddSlider(card, "Transparency", 0, 100, 0, {
            Precision = 0,
            Suffix = "%",
            Hint = "100% hides the buttons but they stay clickable",
            Callback = function(value)
                MobileCfg.Transparency = value
                applyMobileLayout()
            end
        })

        AddDropdown(card, "Click Mode", {"Tap", "Hold", "Double Tap"}, "Tap", {
            Hint = "How the Toggle button opens and closes the menu",
            Callback = function(value)
                MobileCfg.ClickMode = value
            end
        })

        AddSlider(card, "Open Hold Time", 0.1, 3, 0.5, {
            Precision = 1,
            Suffix = " s",
            Hint = "Hold this long to open the menu (Hold mode)",
            Callback = function(value)
                MobileCfg.OpenHold = value
            end
        })

        AddSlider(card, "Close Hold Time", 0.1, 3, 0.5, {
            Precision = 1,
            Suffix = " s",
            Hint = "Hold this long to close the menu (Hold mode)",
            Callback = function(value)
                MobileCfg.CloseHold = value
            end
        })
    end
end

local Footer = New("Frame", {
    Name = "Footer",
    AnchorPoint = Vector2.new(0, 1),
    Position = UDim2.new(0, 14, 1, -20),
    Size = UDim2.fromOffset(0, 48),
    AutomaticSize = Enum.AutomaticSize.X,
    BorderSizePixel = 0
}, Main)

Paint(Footer, "BackgroundColor3", "Panel")
Corner(Footer, 12, true)

New("UIPadding", {
    PaddingLeft = UDim.new(0, 4),
    PaddingRight = UDim.new(0, 4)
}, Footer)

New("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    Padding = UDim.new(0, 4),
    SortOrder = Enum.SortOrder.LayoutOrder
}, Footer)

local TabTweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TabButtons = {}

local function renderTabs()
    for name, button in pairs(TabButtons) do
        local selected = name == ActiveTab
        local icon = button:FindFirstChild("TabIcon")
        local label = button:FindFirstChild("TabLabel")

        button.BackgroundColor3 = selected and Theme.Element or Theme.Panel

        TweenService:Create(button, TabTweenInfo, {
            Size = UDim2.fromOffset(selected and 100 or 40, 40)
        }):Play()

        if icon then
            TweenService:Create(icon, TabTweenInfo, {
                Position = selected and UDim2.new(0, 22, 0.5, 0) or UDim2.new(0.5, 0, 0.5, 0)
            }):Play()
        end

        if label then
            label.Visible = selected
        end
    end
end

switchPage = function()
    Popup.Close()

    local key = ActiveTab == "Settings" and SettingsPageKeys[ActiveSub] or ActiveTab

    for pageKey, page in pairs(Pages) do
        page.Visible = pageKey == key
    end

    SubBar.Visible = ActiveTab == "Settings"
    renderSubTabs()
    renderTabs()
    refreshTheme()
    refreshBodies()
end

local function switchTab(name)
    ActiveTab = name
    switchPage()
end

local TAB_INDEX = {Main = 1, Visuals = 2, World = 3, Misc = 4, Settings = 5}

for _, name in ipairs({"Main", "Visuals", "World", "Misc", "Settings"}) do
    local button = New("TextButton", {
        Name = name .. "Tab",
        Size = UDim2.fromOffset(40, 40),
        Text = "",
        AutoButtonColor = false,
        BorderSizePixel = 0,
        LayoutOrder = TAB_INDEX[name]
    }, Footer)

    Corner(button, 9)

    MakeIcon(button, ICON_CONFIG.Tabs[name], 16, function()
        return ActiveTab == name and Theme.Blue or Theme.Dim
    end, "TabIcon")

    local tabLabel = New("TextLabel", {
        Name = "TabLabel",
        BackgroundTransparency = 1,
        Text = name,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Visible = false,
        Size = UDim2.new(1, -46, 1, 0),
        Position = UDim2.new(0, 42, 0, 0)
    }, button)

    Paint(tabLabel, "TextColor3", "Blue")

    button.Activated:Connect(function()
        switchTab(name)
    end)

    Dyn(button, function()
        button.BackgroundColor3 = ActiveTab == name and Theme.Element or Theme.Panel
    end)

    TabButtons[name] = button
end

ToolButton(ICON_CONFIG.Toolbar.Home, 4, function() switchTab("Main") end)
ToolButton(ICON_CONFIG.Toolbar.Settings, 52, function() switchTab("Settings") end)
ThemeButton("Dark", ICON_CONFIG.Toolbar.Dark, 4)
ThemeButton("Light", ICON_CONFIG.Toolbar.Light, 60)

switchTab("Main")

do

local function searchText(row)
    local pieces = {}

    for _, descendant in ipairs(row:GetDescendants()) do
        if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
            table.insert(pieces, descendant.Text)
        end
    end

    return string.lower(table.concat(pieces, " "))
end

local function filterSettings(query)
    query = string.lower(query or ""):gsub("^%s+", ""):gsub("%s+$", "")

    Popup.Close()

    if query == "" then
        for _, card in ipairs(Cards) do
            card.Frame.Visible = true

            for _, row in ipairs(card.Body:GetChildren()) do
                if row:IsA("GuiObject") then
                    local gate = DepGates[row]
                    row.Visible = gate == nil or gate()
                end
            end
        end

        switchPage()
        return
    end

    local firstPage = nil
    local matches = 0

    for _, card in ipairs(Cards) do
        local sectionMatch = string.find(string.lower(card.Name), query, 1, true) ~= nil
        local hasMatch = false

        for _, row in ipairs(card.Body:GetChildren()) do
            if row:IsA("GuiObject") then
                if row.Name == "Divider" then
                    row.Visible = false
                else
                    local show = sectionMatch or string.find(searchText(row), query, 1, true) ~= nil
                    local gate = DepGates[row]

                    if gate then
                        show = show and gate()
                    end

                    row.Visible = show

                    if show then
                        hasMatch = true
                        matches += 1
                    end
                end
            end
        end

        card.Frame.Visible = hasMatch

        if hasMatch and not firstPage then
            firstPage = card.Page
        end
    end

    if firstPage then
        if firstPage:sub(1, 9) == "Settings/" then
            ActiveTab = "Settings"
            ActiveSub = firstPage:sub(10)
        else
            ActiveTab = firstPage
        end

        switchPage()
        Notify("Found " .. tostring(matches) .. " matching items")
    else
        Notify("No settings found")
    end
end

Connect(SearchBox:GetPropertyChangedSignal("Text"), function()
    filterSettings(SearchBox.Text)
end)

end

local File = {}

do

local CONFIG_DIR = "SEVERESettings"
local WINDOW_FILE = CONFIG_DIR .. "/window.json"

local function canFile()
    return type(writefile) == "function"
        and type(readfile) == "function"
        and type(isfile) == "function"
        and type(makefolder) == "function"
end

local function ensureDir()
    if canFile() then
        pcall(makefolder, CONFIG_DIR)
    end
end

local function readJson(path)
    if not canFile() then return nil end

    local ok, raw = pcall(function()
        if isfile(path) then
            return readfile(path)
        end
        return nil
    end)

    if not ok or type(raw) ~= "string" or raw == "" then
        return nil
    end

    local decodedOk, decoded = pcall(function()
        return HttpService:JSONDecode(raw)
    end)

    return decodedOk and type(decoded) == "table" and decoded or nil
end

local function writeJson(path, data)
    if not canFile() then return end

    ensureDir()

    local ok, encoded = pcall(function()
        return HttpService:JSONEncode(data)
    end)

    if ok then
        pcall(writefile, path, encoded)
    end
end

File.Dir = CONFIG_DIR
File.CanFile = canFile
File.EnsureDir = ensureDir
File.ReadJson = readJson
File.WriteJson = writeJson

saveWindowState = function()
    if not canFile() then return end

    writeJson(WINDOW_FILE, {
        x = Main.AbsolutePosition.X + Main.AbsoluteSize.X / 2,
        y = Main.AbsolutePosition.Y + Main.AbsoluteSize.Y / 2,
        w = WinW,
        h = WinH
    })
end

local function restoreWindowState()
    local data = readJson(WINDOW_FILE)

    if not data then return end

    WinW = math.clamp(tonumber(data.w) or WinW, WIN_MIN_W, WIN_MAX_W)
    WinH = math.clamp(tonumber(data.h) or WinH, WIN_MIN_H, WIN_MAX_H)

    if tonumber(data.x) and tonumber(data.y) then
        Main.Position = UDim2.fromOffset(data.x, data.y)
    end

    refreshScale()
end

Header.InputBegan:Connect(function(input)
    if not isPress(input) then return end

    local startPos = input.Position
    local startPosition = Main.Position

    beginDrag(input, function(pos)
        local delta = pos - startPos

        Main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end, function()
        local remember = Settings["Remember Window Position"]

        if remember and remember.Get() then
            saveWindowState()
        end
    end)
end)

local Grip = New("TextButton", {
    Name = "ResizeGrip",
    AnchorPoint = Vector2.new(1, 1),
    Position = UDim2.new(1, -3, 1, -3),
    Size = UDim2.fromOffset(20, 20),
    BackgroundTransparency = 1,
    Text = "",
    AutoButtonColor = false,
    ZIndex = 300
}, Main)

MakeIcon(Grip, ICON_CONFIG.UI.Resize, 12, "Dim", "ResizeIcon")

Grip.InputBegan:Connect(function(input)
    if not isPress(input) then return end

    local startPos = input.Position
    local startW, startH = WinW, WinH
    local startScale = Scale.Scale

    beginDrag(input, function(pos)
        local delta = (pos - startPos) / startScale

        WinW = math.clamp(startW + delta.X, WIN_MIN_W, WIN_MAX_W)
        WinH = math.clamp(startH + delta.Y, WIN_MIN_H, WIN_MAX_H)
        refreshScale()
    end, function()
        local remember = Settings["Remember Window Position"]

        if remember and remember.Get() then
            saveWindowState()
        end
    end)
end)

Connect(UIS.InputBegan, function(input, processed)
    if ListeningKey then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            local kp = ListeningKey
            ListeningKey = nil

            if input.KeyCode == Enum.KeyCode.Escape or input.KeyCode == Enum.KeyCode.Backspace then
                kp.SetKey(nil)
            else
                kp.SetKey(input.KeyCode)
            end
        end

        return
    end

    if processed or input.UserInputType ~= Enum.UserInputType.Keyboard then
        return
    end

    for _, kp in ipairs(KeyPickerList) do
        if kp.Key and input.KeyCode == kp.Key then
            if kp.Mode == "Toggle" then
                kp.Fire(not kpCurrent(kp))
            elseif kp.Mode == "Hold" then
                kp.Fire(true)
            end
        end
    end
end)

Connect(UIS.InputEnded, function(input)
    if input.UserInputType ~= Enum.UserInputType.Keyboard then
        return
    end

    for _, kp in ipairs(KeyPickerList) do
        if kp.Key and kp.Mode == "Hold" and kp.State and input.KeyCode == kp.Key then
            kp.Fire(false)
        end
    end
end)

Env.SEVEREUnload = function()
    for _, connection in ipairs(Connections) do
        connection:Disconnect()
    end

    table.clear(Connections)

    for _, particle in ipairs(ParticleState.Active) do
        particle.Frame:Destroy()
    end

    table.clear(ParticleState.Active)

    if GUI then GUI:Destroy() end
    if Overlay then Overlay:Destroy() end
    if ParticleGui then ParticleGui:Destroy() end

    for _, obj in ipairs(workspace.CurrentCamera:GetChildren()) do
        if obj.Name == "SEVEREGlassBlur" then
            obj:Destroy()
        end
    end

    if Env.SEVEREUnload then
        Env.SEVEREUnload = nil
    end
end

local rememberEntry = Settings["Remember Window Position"]

if rememberEntry and rememberEntry.Get() then
    restoreWindowState()
end

applyMobileLayout()
applyOverlays()
setMenuOpen(true)

end

return {
    Settings = Settings,
    Pages = Pages,
    Notify = Notify,
    SetTheme = SetTheme,
    ApplyOverlays = applyOverlays,
    AddSettingsSub = addSettingsSub,
    CreatePage = CreatePage,
    Section = Section,
    AddToggle = AddToggle,
    AddSlider = AddSlider,
    AddDropdown = AddDropdown,
    AddColorPicker = AddColorPicker,
    AddTextBox = AddTextBox,
    AddButton = AddButton,
    AddListBox = AddListBox,
    AddDualSlider = AddDualSlider,
    AddKeyPicker = AddKeyPicker,
    AddDependency = AddDependency,
    AddGroup = AddGroup,
    AddTabBox = AddTabBox,
    AddSubWindow = AddSubWindow,
    Palettes = Palettes,
    PresetOrder = PresetOrder,
    ThemeOverrides = ThemeOverrides,
    MenuStyle = MenuStyle,
    GetTheme = function() return Theme end,
    GetThemeName = function() return ThemeName end,
    GetAccentOverride = function() return AccentOverride end,
    File = File
}
