local repo = "https://raw.githubusercontent.com/sickletone/Severe-UI/main/"

local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

-- Addons take the library as an argument, so call the returned function with it.
loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()(Library)
loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()(Library)

-- Pages are the top tabs. CreatePage(name, index) returns the left and right columns.
-- Section(column, title, pageKey) adds a card to a column.
-- Every Add* function takes a column (or a card, group, tab or dependency row) as its first argument.

--// Main \\--

local mainLeft, mainRight = Library.CreatePage("Main", 0)

-- Cards with toggles, dependencies and nested rows.
local controls = Library.Section(mainLeft, "Toggles and Dependencies", "Main")

-- Library.AddToggle(column, name, default, options)
-- Options:
--   Hint         tooltip text shown on hover
--   Gear         shows a gear button on the row
--   OnGear       runs when the gear button is clicked
--   Keybind      {Key = "KeyName", Mode = "Toggle" | "Hold" | "Always" | "None"}
--   Color        color of the color dot
--   OnColor      runs when the color dot changes, OnColor(color, alpha)
--   Callback     runs when the toggle changes, Callback(value)
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

-- Library.AddDependency(column, toggle)
-- Rows added to the returned column only show while the toggle is on.
local aimDep = Library.AddDependency(controls, aim)

Library.AddToggle(aimDep, "Sticky Aim", true, {
    Hint = "Stays locked on the same target"
})

-- Library.AddSlider(column, name, min, max, default, options)
-- Options:
--   Precision    number of decimal places
--   Step         amount each step moves the value
--   Suffix       text shown after the value, e.g. "%"
--   Sub          indents the row under its parent
--   Callback     runs when the value changes, Callback(value)
Library.AddSlider(aimDep, "Sticky Strength", 0, 100, 50, {
    Precision = 0,
    Suffix = "%",
    Sub = true,
    Callback = function(value)
        print("Sticky Strength:", value)
    end
})

-- Color option on a toggle: the dot sets the color, and OnColor runs on change.
Library.AddToggle(controls, "Snaplines", false, {
    Hint = "Draws a line to each target",
    Color = Color3.fromRGB(255, 255, 255),
    OnColor = function(color, alpha)
        print("Snaplines color:", color, alpha)
    end
})

-- Library.AddGroup(column, title)
-- Returns a group you can use as a column. Rows added to it are grouped inside the card.
local group = Library.AddGroup(controls, "Grouped Rows")
Library.AddToggle(group, "Reload Check", false, {Hint = "Pauses while reloading"})
Library.AddToggle(group, "Mouse Teleport", false, {Hint = "Jumps the cursor to the target"})

-- Library.AddTabBox(column, options)
-- Options:
--   Tabs     list of tab names
--   Default  tab shown first
--   Align    "Left" or "Center"
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

-- Library.AddDropdown(column, name, values, default, options)
-- Options:
--   Hint      tooltip text
--   Callback  runs when the selection changes, Callback(option)
Library.AddDropdown(targeting, "Part", {
    "HumanoidRootPart", "Closest", "Random", "Head", "Torso"
}, "HumanoidRootPart", {
    Hint = "Which body part to aim at",
    Callback = function(option)
        print("Part:", option)
    end
})

-- Library.AddDualSlider(column, name, min, max, low, high, options)
-- Callback receives both values, Callback(low, high).
Library.AddDualSlider(targeting, "Target Range", 0, 1000, 50, 400, {
    Precision = 0,
    Hint = "Minimum and maximum distance to pick targets",
    Callback = function(low, high)
        print("Target Range:", low, high)
    end
})

-- Library.AddColorPicker(column, name, color, alpha, options)
-- alpha goes from 0 to 1. Callback(color, alpha) runs when the color changes.
Library.AddColorPicker(targeting, "FOV Color", Color3.fromRGB(60, 120, 255), 1, {
    Hint = "Color of the FOV circle",
    Callback = function(color, alpha)
        print("FOV Color:", color, alpha)
    end
})

-- Library.AddKeyPicker(column, name, key, mode, options)
-- mode is "Toggle", "Hold", "Always" or "None".
-- Callback(state) runs when the key state changes.
Library.AddKeyPicker(targeting, "Action Key", "E", "Toggle", {
    Callback = function(state)
        print("Action Key state:", state)
    end
})

-- Library.AddListBox(column, height, emptyText, onSelect)
-- Returns an object with:
--   SetOptions(list)  replaces the list
--   Set(option)       selects an option and runs onSelect
--   Get()             returns the selected option
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

-- A dependency row is hidden until the toggle above it is on.
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

-- Library.AddTextBox(column, name, default, callback)
-- callback(text, enterPressed) runs when the text changes or Enter is pressed.
Library.AddTextBox(actions, "Player Name", "", function(text, enterPressed)
    print("Player Name:", text, enterPressed)
end)

-- Library.AddButton(column, name, callback)
Library.AddButton(actions, "Show Notification", function()
    -- Library.Notify(message, title) shows a popup.
    Library.Notify("Hello from the example", "SEVERE")
end)

-- Library.GetThemeName() returns the active theme name.
Library.AddButton(actions, "Print Theme", function()
    print("Active theme:", Library.GetThemeName())
end)
