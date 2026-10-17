-- SEVERE example
-- Showcases every component of the library. The demo pages that used to live
-- in Library.lua are here now. Sub windows are not used in this example.

-- Base URL of this repo. Change it if you fork the library.
local REPO = "https://raw.githubusercontent.com/sickletone/Severe-UI/main/"

-- Load the library. It returns a table of functions and settings.
local Library = loadstring(game:HttpGet(REPO .. "Library.lua"))()

-- Load the addons. Each addon returns a function that takes the library.
-- SaveManager adds Settings > Configs. ThemeManager adds Settings > Theme.
loadstring(game:HttpGet(REPO .. "addons/SaveManager.lua"))()(Library)
loadstring(game:HttpGet(REPO .. "addons/ThemeManager.lua"))()(Library)

-- Every page has two columns, left and right. Each column holds cards.
-- Section(column, title, pageKey) makes a card. Pass the page key it belongs to.
-- The top tabs are Main, Visuals, World, Misc and Settings.

--// Main \\--

local mainLeft, mainRight = Library.CreatePage("Main", 0)

local controls = Library.Section(mainLeft, "Toggles and Dependencies", "Main")

-- Toggle: name, default, options.
-- Options: Hint (tooltip), Gear (shows a gear button), OnGear (gear callback),
-- Keybind ({Key, Mode}), Color (color dot), OnColor (color callback), Callback.
local aim = Library.AddToggle(controls, "Enable Aimbot", true, {
    Hint = "Turns the aimbot on or off",
    Gear = true,
    OnGear = function()
        Library.Notify("Gear button clicked", "Aimbot")
    end,
    Keybind = {Key = "Q", Mode = "Toggle"},
    Callback = function(value)
        print("Enable Aimbot:", value)
    end
})

-- AddDependency(column, toggle): the child rows only show while the toggle is on.
local aimDep = Library.AddDependency(controls, aim)

Library.AddToggle(aimDep, "Sticky Aim", true, {
    Hint = "Stays locked on the same target"
})

-- Slider: name, minimum, maximum, default, options.
-- Options: Precision (decimals), Step, Suffix (text after the value), Sub (indent), Hint, Callback.
Library.AddSlider(aimDep, "Sticky Strength", 0, 100, 50, {
    Precision = 0,
    Suffix = "%",
    Sub = true,
    Callback = function(value)
        print("Sticky Strength:", value)
    end
})

-- Color toggle: Color sets the color dot, and OnColor runs when it changes.
Library.AddToggle(controls, "Snaplines", false, {
    Hint = "Draws a line to each target",
    Color = Color3.fromRGB(255, 255, 255),
    OnColor = function(color, alpha)
        print("Snaplines color:", color, alpha)
    end
})

-- Groups hold related rows inside a card. Use the group as the column.
local group = Library.AddGroup(controls, "Grouped Rows")
Library.AddToggle(group, "Reload Check", false, {Hint = "Pauses while reloading"})
Library.AddToggle(group, "Mouse Teleport", false, {Hint = "Jumps the cursor to the target"})

-- Tab box: Tabs (list), Default (starting tab), Align ("Left" or "Center").
-- Call tabs.Tab(name) to get the container for that tab.
local tabs = Library.AddTabBox(controls, {
    Align = "Center",
    Tabs = {"Players", "NPCs"},
    Default = "Players"
})

Library.AddToggle(tabs.Tab("Players"), "Team Check", false, {Hint = "Skips your teammates"})
Library.AddToggle(tabs.Tab("Players"), "Visible Only", true)
Library.AddToggle(tabs.Tab("NPCs"), "Target NPCs", false)
Library.AddSlider(tabs.Tab("NPCs"), "NPC Priority", 0, 10, 3, {Precision = 0})

local targeting = Library.Section(mainRight, "Targeting Inputs", "Main")

-- Dropdown: name, list of options, default, options (Hint, Callback(option)).
Library.AddDropdown(targeting, "Part", {
    "HumanoidRootPart", "Closest", "Random", "Head", "Torso"
}, "HumanoidRootPart", {
    Hint = "Which body part to aim at",
    Callback = function(option)
        print("Part:", option)
    end
})

-- Dual slider: name, minimum, maximum, low value, high value, options.
-- Callback receives both values.
Library.AddDualSlider(targeting, "Target Range", 0, 1000, 50, 400, {
    Precision = 0,
    Hint = "Minimum and maximum distance to pick targets",
    Callback = function(low, high)
        print("Target Range:", low, high)
    end
})

-- Color picker: name, default color, alpha (0 to 1), options (Hint, Callback(color, alpha)).
Library.AddColorPicker(targeting, "FOV Color", Color3.fromRGB(60, 120, 255), 1, {
    Hint = "Color of the FOV circle",
    Callback = function(color, alpha)
        print("FOV Color:", color, alpha)
    end
})

-- Key picker: name, default key, mode ("Toggle", "Hold", "Always" or "None"), options.
-- Callback(state) runs when the key state changes.
Library.AddKeyPicker(targeting, "Action Key", "E", "Toggle", {
    Callback = function(state)
        print("Action Key state:", state)
    end
})

-- List box: height, empty text, onSelect(option).
-- SetOptions replaces the list. Get returns the selected option.
local playerList = Library.AddListBox(targeting, 120, "No players", function(option)
    Library.Notify("Selected " .. option, "Player List")
end)
playerList.SetOptions({"Alpha", "Bravo", "Charlie"})

--// Visuals \\--

local visLeft, visRight = Library.CreatePage("Visuals", 0)

local esp = Library.Section(visLeft, "Players", "Visuals")
Library.AddToggle(esp, "Enable Visuals", false)
Library.AddToggle(esp, "Player Boxes", false, {Color = Color3.fromRGB(255, 255, 255)})
Library.AddToggle(esp, "Player Names", true, {Color = Color3.fromRGB(255, 255, 255)})
Library.AddToggle(esp, "Health Display", true, {Color = Color3.fromRGB(60, 200, 120)})
Library.AddToggle(esp, "Distance Display", false, {Color = Color3.fromRGB(255, 225, 100)})

local display = Library.Section(visRight, "Display", "Visuals")
Library.AddSlider(display, "Visual Range", 0, 5000, 1000, {Precision = 0})
Library.AddToggle(display, "Team Check", false, {Hint = "Skips your teammates"})
Library.AddToggle(display, "Highlight Target", true, {Color = Color3.fromRGB(255, 110, 110)})
Library.AddDropdown(display, "Text Style", {"Regular", "Bold", "Outline"}, "Regular")

--// World \\--

local worldLeft, worldRight = Library.CreatePage("World", 0)

local world = Library.Section(worldLeft, "World", "World")
local worldToggle = Library.AddToggle(world, "Enable World Settings", false)
local worldDep = Library.AddDependency(world, worldToggle)
Library.AddToggle(worldDep, "Full Brightness", false)
Library.AddToggle(worldDep, "Remove Fog", false)
Library.AddToggle(world, "World Visual Effects", true)

local environment = Library.Section(worldRight, "Environment", "World")
Library.AddSlider(environment, "Brightness", 0, 5, 2, {Precision = 1})
Library.AddSlider(environment, "Clock Time", 0, 24, 14, {Precision = 1})
Library.AddSlider(environment, "Fog End Distance", 100, 100000, 100000, {Precision = 0})

--// Misc \\--

local miscLeft, miscRight = Library.CreatePage("Misc", 0)

local misc = Library.Section(miscLeft, "Miscellaneous", "Misc")
Library.AddToggle(misc, "Enable Miscellaneous", true)
Library.AddToggle(misc, "Auto Jump", false)
Library.AddToggle(misc, "Show Notifications", true)

local actions = Library.Section(miscRight, "Actions and Input", "Misc")

-- Text box: name, default text, callback(text, enterPressed).
Library.AddTextBox(actions, "Player Name", "", function(text, enterPressed)
    print("Player Name:", text, enterPressed)
end)

-- Button: name, callback.
Library.AddButton(actions, "Show Notification", function()
    -- Notify(message, title) shows a popup.
    Library.Notify("Hello from the example", "SEVERE")
end)

-- GetThemeName returns the active theme name.
Library.AddButton(actions, "Print Theme", function()
    print("Active theme:", Library.GetThemeName())
end)
