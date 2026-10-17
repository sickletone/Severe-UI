-- SEVERE example
-- Loads the library and its addons, then adds a sample page under
-- Settings > Example. The example uses only public library functions and
-- does not use sub windows.

-- Base URL of this repo. Change it if you fork the library.
local REPO = "https://raw.githubusercontent.com/sickletone/Severe-UI/main/"

-- Load the library. It returns a table of functions and settings.
local Library = loadstring(game:HttpGet(REPO .. "Library.lua"))()

-- Load the addons. Each addon returns a function that takes the library.
-- SaveManager adds Settings > Configs. ThemeManager adds Settings > Theme.
loadstring(game:HttpGet(REPO .. "addons/SaveManager.lua"))()(Library)
loadstring(game:HttpGet(REPO .. "addons/ThemeManager.lua"))()(Library)

-- Add a Settings > Example sub tab. The order number sets its position.
Library.AddSettingsSub("Example", 4)

-- CreatePage(key, topOffset) returns two columns, left and right.
-- The 38 leaves room for the sub tab bar.
local left, right = Library.CreatePage("Settings/Example", 38)

-- Section(column, title, pageKey) makes a card inside a column.
local demoCard = Library.Section(left, "Components", "Settings/Example")
local actionCard = Library.Section(right, "Actions", "Settings/Example")

-- Toggle: name, default value, options. Callback runs when it changes.
Library.AddToggle(demoCard, "Enable Demo", true, {
    Callback = function(value)
        print("Enable Demo:", value)
    end
})

-- Slider: name, minimum, maximum, default, options.
Library.AddSlider(demoCard, "Speed", 0, 100, 50, {
    Precision = 0,
    Suffix = "%",
    Callback = function(value)
        print("Speed:", value)
    end
})

-- Dropdown: name, list of options, default option, options.
Library.AddDropdown(demoCard, "Mode", {"Fast", "Balanced", "Slow"}, "Balanced", {
    Callback = function(option)
        print("Mode:", option)
    end
})

-- Text box: name, default text, callback when the text is submitted.
Library.AddTextBox(demoCard, "Player Name", "", function(text)
    print("Player Name:", text)
end)

-- Button: name, callback when clicked.
Library.AddButton(actionCard, "Show Notification", function()
    -- Notify(message, title) shows a popup in the library.
    Library.Notify("Hello from the example", "SEVERE")
end)

Library.AddButton(actionCard, "Print Theme", function()
    -- GetThemeName returns the active theme name, such as "Dark".
    print("Active theme:", Library.GetThemeName())
end)
