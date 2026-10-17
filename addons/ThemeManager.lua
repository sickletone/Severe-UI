return function(Library)
    local Settings = Library.Settings
    local Notify = Library.Notify
    local File = Library.File
    local Palettes = Library.Palettes
    local PresetOrder = Library.PresetOrder
    local ThemeOverrides = Library.ThemeOverrides
    local MenuStyle = Library.MenuStyle

    local THEME_FILE = File.Dir .. "/themes.json"

    local MemoryThemes = {}
    local ThemeRows = {}
    local PresetDropdown
    local ThemeNameBoxObj
    local ThemeListObj

    local function listThemes()
        local names = {}

        for name in pairs(MemoryThemes) do
            if type(name) == "string" then
                table.insert(names, name)
            end
        end

        table.sort(names)
        ThemeListObj.SetOptions(names)
    end

    local function validName(name)
        name = tostring(name or ""):gsub("^%s+", ""):gsub("%s+$", "")

        if name == "" then return nil end

        name = name:gsub("[/\\:*?\"<>|]", "_")
        return name
    end

    local function refreshRows()
        local theme = Library.GetTheme()

        for key, dot in pairs(ThemeRows) do
            dot.Set(theme[key], 1, false)
        end
    end

    local function saveTheme()
        local name = validName(ThemeNameBoxObj.Text)

        if not name then
            Notify("Enter a theme name first")
            return
        end

        local overrides = {}

        for key, color in pairs(ThemeOverrides) do
            overrides[key] = {color.R, color.G, color.B}
        end

        local accent = Library.GetAccentOverride()

        MemoryThemes[name] = {
            Preset = Library.GetThemeName(),
            Accent = accent and {accent.R, accent.G, accent.B} or nil,
            Overrides = overrides,
            Alpha = MenuStyle.Alpha
        }

        File.WriteJson(THEME_FILE, MemoryThemes)
        listThemes()
        ThemeListObj.Set(name)
        Notify("Saved theme: " .. name)
    end

    local function loadTheme()
        local name = ThemeListObj.Get()
        local data = name and MemoryThemes[name]

        if not data then
            Notify("Select a saved theme first")
            return
        end

        local accent = data.Accent and Color3.new(data.Accent[1], data.Accent[2], data.Accent[3]) or nil

        for key in pairs(ThemeOverrides) do
            ThemeOverrides[key] = nil
        end

        for key, rgb in pairs(data.Overrides or {}) do
            ThemeOverrides[key] = Color3.new(rgb[1], rgb[2], rgb[3])
        end

        MenuStyle.Alpha = data.Alpha or 0

        local transparency = Settings["Menu Transparency"]

        if transparency then
            transparency.Set(MenuStyle.Alpha * 100)
        end

        Library.SetTheme(data.Preset or "Dark", accent)
        refreshRows()

        if PresetDropdown then
            PresetDropdown.Set(Library.GetThemeName(), false)
        end

        Notify("Loaded theme: " .. name)
    end

    local function deleteTheme()
        local name = ThemeListObj.Get()

        if not name or not MemoryThemes[name] then
            Notify("Select a saved theme first")
            return
        end

        MemoryThemes[name] = nil
        File.WriteJson(THEME_FILE, MemoryThemes)
        listThemes()
        Notify("Deleted theme: " .. name)
    end

    Library.AddSettingsSub("Theme", 3)

    local left, right = Library.CreatePage("Settings/Theme", 38)

    local card = Library.Section(left, "Theme Manager", "Settings/Theme")

    PresetDropdown = Library.AddDropdown(card, "Theme Preset", PresetOrder, Library.GetThemeName(), {
        Callback = function(value)
            for key in pairs(ThemeOverrides) do
                ThemeOverrides[key] = nil
            end

            MenuStyle.Alpha = value == "iOS 27 Glass" and 0.18 or 0

            local radius = Settings["Corner Radius"]

            if value == "iOS 27 Glass" and radius then
                radius.Set(24)
            end

            local transparency = Settings["Menu Transparency"]

            if transparency then
                transparency.Set(MenuStyle.Alpha * 100)
            end

            Library.SetTheme(value, Library.GetAccentOverride())
            refreshRows()
        end
    })

    Library.AddColorPicker(card, "Accent Color", Palettes.Dark.Blue, 1, {
        Callback = function(color)
            Library.SetTheme(Library.GetThemeName(), color)
        end
    })

    Library.AddButton(card, "Reset Accent", function()
        Library.SetTheme(Library.GetThemeName(), nil)
    end)

    card = Library.Section(left, "Colors", "Settings/Theme")

    local THEME_COLOR_ROWS = {
        {"Background", "Background"},
        {"Header", "Header"},
        {"Panel", "Panel"},
        {"Element", "Element"},
        {"Hover", "Hover"},
        {"Border", "Border"},
        {"Text", "White"},
        {"Muted Text", "Muted"},
        {"Dim Text", "Dim"}
    }

    for _, item in ipairs(THEME_COLOR_ROWS) do
        local key = item[2]

        ThemeRows[key] = Library.AddColorPicker(card, item[1], Library.GetTheme()[key], 1, {
            Callback = function(color)
                ThemeOverrides[key] = color
                Library.SetTheme(Library.GetThemeName(), Library.GetAccentOverride())
            end
        })
    end

    Library.AddButton(card, "Reset Colors", function()
        for key in pairs(ThemeOverrides) do
            ThemeOverrides[key] = nil
        end

        Library.SetTheme(Library.GetThemeName(), Library.GetAccentOverride())
        refreshRows()
    end)

    card = Library.Section(right, "Save Theme", "Settings/Theme")

    ThemeNameBoxObj = Library.AddTextBox(card, "Theme Name", "My Theme")
    Library.AddButton(card, "Save theme", saveTheme)

    card = Library.Section(right, "Saved Themes", "Settings/Theme")

    ThemeListObj = Library.AddListBox(card, 110, "No saved themes yet", function() end)
    Library.AddButton(card, "Load theme", loadTheme)
    Library.AddButton(card, "Delete theme", deleteTheme)

    MemoryThemes = File.ReadJson(THEME_FILE) or {}
    listThemes()
end
