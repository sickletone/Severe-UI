local repo = "https://raw.githubusercontent.com/sickletone/Severe-UI/main/"

local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

-- Addons return a function that takes the library, so call it with Library.
loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()(Library)
loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()(Library)

-- Every component is labeled with its type in the name, so you can see what it is.
-- CreatePage(key, topOffset) returns the left and right columns for a top tab.
-- Section(column, title, pageKey) adds a card to a column.
-- Add* functions take a column, card, group, tab or dependency column as their first argument.

local function log(component, ...)
    print("[Severe Example] " .. component .. ":", ...)
end

--// Main \\--

local mainLeft, mainRight = Library.CreatePage("Main", 0)

-- Left card: aimbot toggles, with sticky aim as a dependency.
local aimCard = Library.Section(mainLeft, "Aimbot", "Main")

-- Library.AddToggle(column, name, default, options)
-- Options: Hint, Gear, OnGear, Keybind, Color, OnColor, Callback
local aim = Library.AddToggle(aimCard, "Enable Aimbot", true, {
    Hint = "Turns the aimbot on or off",
    Gear = true,
    OnGear = function()
        Library.Notify("Aimbot gear clicked", "Aimbot")
    end,
    Keybind = {Key = "Q", Mode = "Toggle"},
    Callback = function(value) log("Enable Aimbot", value) end
})

Library.AddToggle(aimCard, "Team Check", true, {
    Hint = "Skips players on your team"
})

Library.AddToggle(aimCard, "Wall Check", false, {
    Hint = "Only locks on targets you can see through walls"
})

-- Library.AddDependency(column, toggle) returns a column that only shows while the toggle is on.
local aimDep = Library.AddDependency(aimCard, aim)

Library.AddToggle(aimDep, "Sticky Aim", true, {
    Hint = "Stays locked on the same target",
    Color = Color3.fromRGB(255, 80, 80),
    OnColor = function(color, alpha) log("Sticky Aim color", color, alpha) end
})

-- Library.AddSlider(column, name, min, max, default, options)
-- Options: Precision, Step, Suffix, Sub (indents under the parent), Callback
Library.AddSlider(aimDep, "Sticky Strength", 0, 100, 50, {
    Precision = 0,
    Suffix = "%",
    Sub = true,
    Callback = function(value) log("Sticky Strength", value) end
})

Library.AddSlider(aimDep, "Sticky Release Delay", 0, 1000, 150, {
    Precision = 0,
    Suffix = " ms",
    Step = 10,
    Sub = true
})

-- Library.AddGroup(column, title) returns a boxed group inside the card.
local targetGroup = Library.AddGroup(aimCard, "Targeting")
Library.AddToggle(targetGroup, "Ignore Friends", true)
Library.AddToggle(targetGroup, "Ignore Knocked", true)

-- Library.AddDropdown(column, name, options, default, options)
Library.AddDropdown(targetGroup, "Target Part", {"Head", "Torso", "Random"}, "Head", {
    Hint = "Which body part the aimbot aims at",
    Callback = function(option) log("Target Part", option) end
})

Library.AddDropdown(targetGroup, "Target Priority", {"Closest", "Lowest Health", "Crosshair"}, "Crosshair", {
    Callback = function(option) log("Target Priority", option) end
})

-- Tuning card: sliders and a dual slider.
local tuningCard = Library.Section(mainLeft, "Aim Tuning", "Main")

Library.AddSlider(tuningCard, "Smoothing", 0, 100, 25, {
    Precision = 0,
    Hint = "Higher values make the aim slower and smoother",
    Callback = function(value) log("Smoothing", value) end
})

Library.AddSlider(tuningCard, "FOV", 0, 500, 120, {
    Precision = 0,
    Suffix = " px",
    Callback = function(value) log("FOV", value) end
})

Library.AddSlider(tuningCard, "Hit Chance", 0, 100, 100, {
    Precision = 0,
    Suffix = "%"
})

Library.AddSlider(tuningCard, "Prediction", 0, 1, 0.15, {
    Precision = 2,
    Step = 0.01,
    Hint = "Leads moving targets by this much"
})

-- Library.AddDualSlider(column, name, min, max, low, high, options)
Library.AddDualSlider(tuningCard, "Distance Range", 0, 1000, 0, 500, {
    Precision = 0,
    Callback = function(low, high) log("Distance Range", low, high) end
})

-- Library.AddKeyPicker(column, name, key, mode, options). Mode: "Toggle", "Hold", "Always" or "None".
Library.AddKeyPicker(tuningCard, "Aim Key", "E", "Hold", {
    Callback = function(state) log("Aim Key", state) end
})

-- Right card: inputs, buttons and lists.
local miscMainCard = Library.Section(mainRight, "Filters and Actions", "Main")

-- Library.AddTextBox(column, name, default, callback)
Library.AddTextBox(miscMainCard, "Target Name Filter", "", function(text, enterPressed)
    log("Target Name Filter", text, enterPressed)
end)

-- Library.AddButton(column, name, callback)
Library.AddButton(miscMainCard, "Reset Aimbot Settings", function()
    Library.Notify("Aimbot settings reset", "Aimbot")
end)

-- Library.AddListBox(column, height, emptyText, onSelect) returns SetOptions, Set and Get.
local whitelist = Library.AddListBox(miscMainCard, 120, "No players whitelisted", function(option)
    log("Whitelist", option)
end)
whitelist.SetOptions({"PlayerOne", "PlayerTwo", "PlayerThree"})

-- Sub window: Library.AddSubWindow(column, buttonText, title, options) returns a window.
-- Add components to window.Container exactly like a column.
local subCard = Library.Section(mainRight, "Advanced", "Main")

local advancedAim = Library.AddSubWindow(subCard, "Open Advanced Aim", "Advanced Aim", {Width = 380, Height = 320})
Library.AddToggle(advancedAim.Container, "Silent Aim", false, {
    Hint = "Aims without moving your camera"
})
Library.AddSlider(advancedAim.Container, "Silent Hit Chance", 0, 100, 60, {
    Precision = 0,
    Suffix = "%"
})
Library.AddDropdown(advancedAim.Container, "Silent Method", {"Raycast", "Mouse Hit", "Remote"}, "Raycast")
Library.AddColorPicker(advancedAim.Container, "FOV Circle Color", Color3.fromRGB(255, 255, 255), 0.5)
Library.AddButton(advancedAim.Container, "Test Silent Aim", function()
    Library.Notify("Silent aim test fired", "Advanced Aim")
end)

--// Visuals \\--

local visLeft, visRight = Library.CreatePage("Visuals", 0)

local espCard = Library.Section(visLeft, "ESP", "Visuals")

local espToggle = Library.AddToggle(espCard, "Enable ESP", true, {
    Gear = true,
    OnGear = function()
        Library.Notify("ESP gear clicked", "ESP")
    end,
    Keybind = {Key = "F", Mode = "Toggle"}
})

Library.AddToggle(espCard, "Box ESP", true, {
    Color = Color3.fromRGB(255, 60, 60),
    OnColor = function(color, alpha) log("Box ESP color", color, alpha) end
})

Library.AddToggle(espCard, "Name ESP", true)
Library.AddToggle(espCard, "Health Bar", true, {
    Color = Color3.fromRGB(80, 255, 120)
})
Library.AddToggle(espCard, "Tracers", false, {
    Hint = "Draws a line from the bottom of the screen to each player"
})

local chamsParent = Library.AddToggle(espCard, "Chams", false)
local chamsDep = Library.AddDependency(espCard, chamsParent)
Library.AddToggle(chamsDep, "Chams Outline", true)
Library.AddSlider(chamsDep, "Chams Fill Transparency", 0, 100, 40, {
    Precision = 0,
    Suffix = "%",
    Sub = true
})

local infoGroup = Library.AddGroup(espCard, "Info")
Library.AddToggle(infoGroup, "Show Team Color", true)
Library.AddToggle(infoGroup, "Show Health Number", false)

local boxTabs = Library.AddTabBox(espCard, {
    Align = "Center",
    Tabs = {"Corners", "Full"},
    Default = "Corners"
})
Library.AddToggle(boxTabs.Tab("Corners"), "Rounded Corners", false)
Library.AddToggle(boxTabs.Tab("Full"), "Filled Box", false)

local espTuning = Library.Section(visLeft, "ESP Tuning", "Visuals")

Library.AddSlider(espTuning, "Max Distance", 0, 2000, 1000, {
    Precision = 0,
    Suffix = " studs",
    Callback = function(value) log("Max Distance", value) end
})
Library.AddSlider(espTuning, "Text Size", 8, 24, 14, {Precision = 0, Step = 1})
Library.AddSlider(espTuning, "Box Thickness", 1, 5, 2, {Precision = 0, Step = 1})
Library.AddSlider(espTuning, "Tracer Origin", 0, 100, 50, {Precision = 0, Suffix = "%"})
Library.AddSlider(espTuning, "ESP Opacity", 0, 1, 0.8, {Precision = 2, Step = 0.05})
Library.AddDualSlider(espTuning, "Health Range", 0, 100, 20, 80, {Precision = 0})

local espPickers = Library.Section(visRight, "Colors and Styles", "Visuals")

Library.AddColorPicker(espPickers, "Box Color", Color3.fromRGB(255, 60, 60), 1, {
    Hint = "Color of the box outline",
    Callback = function(color, alpha) log("Box Color", color, alpha) end
})
Library.AddColorPicker(espPickers, "Tracer Color", Color3.fromRGB(255, 255, 255), 0.8)
Library.AddDropdown(espPickers, "Font", {"Gotham", "Arial", "Code"}, "Gotham", {
    Callback = function(option) log("Font", option) end
})
Library.AddDropdown(espPickers, "Box Style", {"Box", "Corner", "3D"}, "Box", {
    Hint = "Shape drawn around each player"
})
Library.AddTextBox(espPickers, "Custom Label", "", function(text, enterPressed)
    log("Custom Label", text, enterPressed)
end)
Library.AddButton(espPickers, "Refresh ESP Cache", function()
    Library.Notify("ESP cache refreshed", "ESP")
end)

local espSub = Library.Section(visRight, "Sub Windows", "Visuals")

local espColors = Library.AddSubWindow(espSub, "Open ESP Colors", "ESP Colors", {Width = 360, Height = 280})
Library.AddColorPicker(espColors.Container, "Enemy Color", Color3.fromRGB(255, 80, 80), 1)
Library.AddColorPicker(espColors.Container, "Ally Color", Color3.fromRGB(80, 160, 255), 1)
Library.AddToggle(espColors.Container, "Use Team Colors", false)
Library.AddSlider(espColors.Container, "Outline Thickness", 0, 4, 1, {Precision = 0, Step = 1})

--// World \\--

local worldLeft, worldRight = Library.CreatePage("World", 0)

local lightingCard = Library.Section(worldLeft, "Lighting", "World")

Library.AddToggle(lightingCard, "Fullbright", false, {
    Hint = "Brightens dark areas",
    Keybind = {Key = "L", Mode = "Toggle"}
})
Library.AddToggle(lightingCard, "No Fog", false, {
    Gear = true,
    OnGear = function()
        Library.Notify("Fog gear clicked", "World")
    end
})
Library.AddToggle(lightingCard, "Remove Shadows", false)
Library.AddToggle(lightingCard, "Disable Post Effects", false)

local timeParent = Library.AddToggle(lightingCard, "Custom Time", false)
local timeDep = Library.AddDependency(lightingCard, timeParent)
Library.AddSlider(timeDep, "Time of Day", 0, 24, 12, {
    Precision = 1,
    Step = 0.5,
    Sub = true,
    Callback = function(value) log("Time of Day", value) end
})
Library.AddToggle(timeDep, "Freeze Time", true)

local weatherGroup = Library.AddGroup(lightingCard, "Weather")
Library.AddToggle(weatherGroup, "Rain", false)
Library.AddToggle(weatherGroup, "Snow", false)

local skyTabs = Library.AddTabBox(lightingCard, {
    Align = "Left",
    Tabs = {"Day", "Night"},
    Default = "Day"
})
Library.AddToggle(skyTabs.Tab("Day"), "Day Skybox", true)
Library.AddToggle(skyTabs.Tab("Night"), "Night Skybox", false)

local worldTuning = Library.Section(worldLeft, "Environment Tuning", "World")

Library.AddSlider(worldTuning, "Fog Density", 0, 100, 20, {Precision = 0, Suffix = "%"})
Library.AddSlider(worldTuning, "Brightness", 0, 10, 2, {Precision = 1, Step = 0.1})
Library.AddSlider(worldTuning, "Ambient Red", 0, 255, 128, {Precision = 0})
Library.AddSlider(worldTuning, "Ambient Green", 0, 255, 128, {Precision = 0})
Library.AddSlider(worldTuning, "Exposure", -5, 5, 0, {Precision = 1, Step = 0.1})
Library.AddDualSlider(worldTuning, "Visible Distance", 0, 2000, 100, 1500, {Precision = 0})

local worldPresets = Library.Section(worldRight, "Presets", "World")

Library.AddDropdown(worldPresets, "Weather Preset", {"Clear", "Foggy", "Stormy"}, "Clear", {
    Callback = function(option) log("Weather Preset", option) end
})
Library.AddDropdown(worldPresets, "Sky Preset", {"Default", "Sunset", "Midnight"}, "Default")
Library.AddColorPicker(worldPresets, "Ambient Color", Color3.fromRGB(128, 128, 128), 1)
Library.AddKeyPicker(worldPresets, "Fullbright Key", "L", "Toggle", {
    Callback = function(state) log("Fullbright Key", state) end
})
Library.AddTextBox(worldPresets, "Set Time Command", "12:00", function(text, enterPressed)
    log("Set Time Command", text, enterPressed)
end)
Library.AddButton(worldPresets, "Apply Lighting", function()
    Library.Notify("Lighting applied", "World")
end)
Library.AddButton(worldPresets, "Reset Lighting", function()
    Library.Notify("Lighting reset", "World")
end)

local savedPresets = Library.AddListBox(worldPresets, 100, "No saved presets", function(option)
    log("Saved Presets", option)
end)
savedPresets.SetOptions({"Night Run", "Bright Map", "Foggy Arena"})

local worldSub = Library.Section(worldRight, "Sub Windows", "World")

local lightingWindow = Library.AddSubWindow(worldSub, "Open Advanced Lighting", "Advanced Lighting", {Width = 380, Height = 300})
Library.AddSlider(lightingWindow.Container, "Exposure Curve", 0, 100, 50, {Precision = 0})
Library.AddToggle(lightingWindow.Container, "Bloom", true)
Library.AddDropdown(lightingWindow.Container, "Shadow Quality", {"Low", "Medium", "High"}, "Medium")
Library.AddColorPicker(lightingWindow.Container, "Bloom Color", Color3.fromRGB(255, 240, 200), 1)

--// Misc \\--

local miscLeft, miscRight = Library.CreatePage("Misc", 0)

local playerCard = Library.Section(miscLeft, "Player", "Misc")

Library.AddToggle(playerCard, "Infinite Jump", false, {
    Hint = "Lets you jump again while in the air"
})
Library.AddToggle(playerCard, "No Clip", false, {
    Keybind = {Key = "N", Mode = "Hold"}
})
Library.AddToggle(playerCard, "Anti AFK", true, {
    Hint = "Stops you from being kicked for idling"
})
Library.AddToggle(playerCard, "Auto Respawn", false, {
    Gear = true,
    OnGear = function()
        Library.Notify("Auto respawn gear clicked", "Misc")
    end
})

local flyParent = Library.AddToggle(playerCard, "Fly", false, {
    Keybind = {Key = "X", Mode = "Toggle"}
})
local flyDep = Library.AddDependency(playerCard, flyParent)
Library.AddSlider(flyDep, "Fly Speed", 1, 200, 50, {
    Precision = 0,
    Sub = true,
    Callback = function(value) log("Fly Speed", value) end
})
Library.AddToggle(flyDep, "Fly Bob", false)

local movementGroup = Library.AddGroup(playerCard, "Movement")
Library.AddSlider(movementGroup, "Walk Speed", 16, 200, 16, {Precision = 0})
Library.AddSlider(movementGroup, "Jump Power", 50, 200, 50, {Precision = 0})
Library.AddSlider(movementGroup, "Gravity", 0, 196.2, 196.2, {Precision = 1, Step = 0.5})
Library.AddDualSlider(movementGroup, "Random Speed Range", 16, 100, 20, 40, {Precision = 0})

local miscUtility = Library.Section(miscRight, "Utilities", "Misc")

Library.AddDropdown(miscUtility, "Server Region", {"Auto", "US East", "EU West"}, "Auto", {
    Callback = function(option) log("Server Region", option) end
})
Library.AddTextBox(miscUtility, "Config Name", "default", function(text, enterPressed)
    log("Config Name", text, enterPressed)
end)
Library.AddColorPicker(miscUtility, "Menu Accent", Color3.fromRGB(60, 120, 255), 1)
Library.AddKeyPicker(miscUtility, "Panic Key", "Delete", "Always", {
    Callback = function(state) log("Panic Key", state) end
})
Library.AddButton(miscUtility, "Rejoin Server", function()
    Library.Notify("Rejoining server...", "Misc")
end)
Library.AddButton(miscUtility, "Copy Job ID", function()
    Library.Notify("Job ID copied", "Misc")
end)

local favorites = Library.AddListBox(miscUtility, 110, "No favorite servers", function(option)
    log("Favorite Servers", option)
end)
favorites.SetOptions({"Server A", "Server B"})

local miscSub = Library.Section(miscRight, "Sub Windows", "Misc")

local serverTools = Library.AddSubWindow(miscSub, "Open Server Tools", "Server Tools", {Width = 360, Height = 280})
Library.AddToggle(serverTools.Container, "Auto Join", false)
Library.AddDropdown(serverTools.Container, "Join Mode", {"Fast", "Safe"}, "Safe")
Library.AddSlider(serverTools.Container, "Retry Limit", 1, 10, 3, {Precision = 0, Step = 1})
Library.AddButton(serverTools.Container, "Copy Server Link", function()
    Library.Notify("Server link copied", "Server Tools")
end)
