return function(Library)
    local HttpService = game:GetService("HttpService")

    local Settings = Library.Settings
    local Notify = Library.Notify
    local File = Library.File

    local CONFIG_FILE = File.Dir .. "/configs.json"
    local AUTOLOAD_FILE = File.Dir .. "/autoload.txt"

    local ConfigName = "default"
    local AutoLoadConfig = ""
    local MemoryConfigs = {}
    local ClipboardFallback = ""

    local ConfigListObj
    local ConfigNameBoxObj

    local function writeConfigs()
        File.WriteJson(CONFIG_FILE, MemoryConfigs)

        if File.CanFile() then
            File.EnsureDir()

            if AutoLoadConfig ~= "" then
                pcall(writefile, AUTOLOAD_FILE, AutoLoadConfig)
            elseif type(delfile) == "function" then
                pcall(delfile, AUTOLOAD_FILE)
            end
        end
    end

    local function loadFiles()
        MemoryConfigs = File.ReadJson(CONFIG_FILE) or {}

        if File.CanFile() then
            local ok, name = pcall(function()
                if isfile(AUTOLOAD_FILE) then
                    return readfile(AUTOLOAD_FILE)
                end
                return nil
            end)

            if ok and type(name) == "string" then
                AutoLoadConfig = name
            end
        end
    end

    local function snapshot()
        local result = {}

        for name, entry in pairs(Settings) do
            local ok, value = pcall(entry.Get)

            if ok and value ~= nil then
                result[name] = value
            end
        end

        result.__configName = ConfigName
        return result
    end

    local function applySnapshot(data)
        if type(data) ~= "table" then return false end

        local first = {"Theme Preset", "Accent Color", "Particle Preset", "Show Mobile Buttons"}

        for _, name in ipairs(first) do
            if data[name] ~= nil and Settings[name] then
                pcall(Settings[name].Set, data[name])
            end
        end

        for name, value in pairs(data) do
            if Settings[name] and not table.find(first, name) then
                pcall(Settings[name].Set, value)
            end
        end

        Library.ApplyOverlays()
        return true
    end

    local function listConfigs()
        local names = {}

        for name in pairs(MemoryConfigs) do
            if type(name) == "string" then
                table.insert(names, name)
            end
        end

        table.sort(names)
        ConfigListObj.SetOptions(names)
    end

    local function validName(name)
        name = tostring(name or ""):gsub("^%s+", ""):gsub("%s+$", "")

        if name == "" then return nil end

        name = name:gsub("[/\\:*?\"<>|]", "_")
        return name
    end

    local function saveConfig(overwrite)
        local name = validName(ConfigNameBoxObj.Text ~= "" and ConfigNameBoxObj.Text or ConfigName)

        if not name then
            Notify("Enter a config name first")
            return
        end

        if MemoryConfigs[name] and not overwrite then
            Notify("Config already exists - use Overwrite config")
            return
        end

        ConfigName = name
        ConfigNameBoxObj.Text = name

        MemoryConfigs[name] = snapshot()
        MemoryConfigs[name].__configName = name

        writeConfigs()
        listConfigs()
        ConfigListObj.Set(name)

        Notify(overwrite and ("Config overwritten: " .. name) or ("Config created: " .. name))
    end

    local function loadConfig()
        local name = validName(ConfigListObj.Get() or ConfigName)
        local data = name and MemoryConfigs[name]

        if not data then
            Notify("Config not found")
            return
        end

        ConfigName = name
        ConfigNameBoxObj.Text = name

        applySnapshot(data)
        Notify("Loaded config: " .. name)
    end

    local function renameConfig()
        local oldName = validName(ConfigListObj.Get() or ConfigName)
        local newName = validName(ConfigNameBoxObj.Text)

        if not oldName or not MemoryConfigs[oldName] then
            Notify("Select an existing config first")
            return
        end

        if not newName then
            Notify("Enter a new config name")
            return
        end

        if oldName ~= newName and MemoryConfigs[newName] then
            Notify("That config name already exists")
            return
        end

        MemoryConfigs[newName] = MemoryConfigs[oldName]
        MemoryConfigs[newName].__configName = newName
        MemoryConfigs[oldName] = nil

        if AutoLoadConfig == oldName then
            AutoLoadConfig = newName
        end

        ConfigName = newName
        ConfigNameBoxObj.Text = newName

        writeConfigs()
        listConfigs()
        ConfigListObj.Set(newName)

        Notify("Renamed config to: " .. newName)
    end

    local function deleteConfig()
        local name = validName(ConfigListObj.Get() or ConfigName)

        if not name or not MemoryConfigs[name] then
            Notify("Select an existing config first")
            return
        end

        if name == "default" then
            Notify("The default config can't be deleted")
            return
        end

        MemoryConfigs[name] = nil

        if AutoLoadConfig == name then
            AutoLoadConfig = ""
        end

        writeConfigs()
        listConfigs()
        Notify("Deleted config: " .. name)
    end

    local function copyToClipboard(text)
        if type(setclipboard) == "function" then
            local ok = pcall(setclipboard, text)

            if ok then
                return true
            end
        end

        ClipboardFallback = text
        return false
    end

    local function pasteFromClipboard()
        if type(getclipboard) == "function" then
            local ok, result = pcall(getclipboard)

            if ok and type(result) == "string" then
                return result
            end
        end

        return ClipboardFallback
    end

    Library.AddSettingsSub("Configs", 2)

    local left, right = Library.CreatePage("Settings/Configs", 38)

    local card = Library.Section(left, "Saved Configs", "Settings/Configs")

    ConfigListObj = Library.AddListBox(card, 150, "It's still empty here", function(option)
        ConfigName = option

        if ConfigNameBoxObj then
            ConfigNameBoxObj.Text = option
        end
    end)

    card = Library.Section(right, "Config", "Settings/Configs")

    ConfigNameBoxObj = Library.AddTextBox(card, "Config Name", "default", function(value)
        if value and value:gsub("%s", "") ~= "" then
            ConfigName = value
        end
    end)

    Library.AddButton(card, "Save config", function() saveConfig(false) end)
    Library.AddButton(card, "Overwrite config", function() saveConfig(true) end)
    Library.AddButton(card, "Load config", loadConfig)
    Library.AddButton(card, "Rename config", renameConfig)
    Library.AddButton(card, "Delete config", deleteConfig)

    Library.AddButton(card, "Refresh list", function()
        loadFiles()
        listConfigs()
        Notify("Config list refreshed")
    end)

    card = Library.Section(right, "Autoload", "Settings/Configs")

    Library.AddButton(card, "Set Config as Auto Load", function()
        local name = validName(ConfigListObj.Get() or ConfigName)

        if not name or not MemoryConfigs[name] then
            Notify("Create or select a config first")
            return
        end

        AutoLoadConfig = name
        writeConfigs()
        Notify("Autoload set to: " .. name)
    end)

    Library.AddButton(card, "Remove Config as Autoload", function()
        AutoLoadConfig = ""
        writeConfigs()
        Notify("Autoload removed")
    end)

    card = Library.Section(right, "Clipboard", "Settings/Configs")

    Library.AddButton(card, "Copy Config to Clipboard", function()
        local payload = HttpService:JSONEncode(snapshot())
        local copied = copyToClipboard(payload)
        Notify(copied and "Config copied to clipboard" or "Clipboard API unavailable; stored internally")
    end)

    Library.AddButton(card, "Paste Config from Clipboard", function()
        local raw = pasteFromClipboard()

        if not raw or raw == "" then
            Notify("Clipboard is empty or unavailable")
            return
        end

        local ok, decoded = pcall(function()
            return HttpService:JSONDecode(raw)
        end)

        if not ok or type(decoded) ~= "table" then
            Notify("Clipboard does not contain a valid config")
            return
        end

        applySnapshot(decoded)
        Notify("Pasted config values")
    end)

    loadFiles()

    if not MemoryConfigs.default then
        MemoryConfigs.default = snapshot()
        MemoryConfigs.default.__configName = "default"
        writeConfigs()
    end

    listConfigs()

    if AutoLoadConfig ~= "" and MemoryConfigs[AutoLoadConfig] then
        ConfigName = AutoLoadConfig
        ConfigNameBoxObj.Text = AutoLoadConfig
        applySnapshot(MemoryConfigs[AutoLoadConfig])
    end
end
