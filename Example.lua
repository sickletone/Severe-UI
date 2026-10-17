--// Severe-UI Component Showcase \\--
--
-- This script is a demo of the Severe-UI library. It is not a script hub.
-- Every component is labeled with its type, for example "Toggle Example 1"
-- or "Dropdown Example 3", so you can see what each one is.
--
-- Layout:
--   Components  Toggles, dependencies, groups, sliders, dual sliders, color pickers, key pickers
--   Inputs      Dropdowns, text boxes, buttons, list boxes, tab boxes
--   Layout      Sub windows (with their own components), nested dependencies, groups
--   Settings    Notifications, theme presets and accent color
--   Extras      Dependency chains, programmatic Get/Set, long-form examples
--
-- Each page is built from sections (cards). Left and right columns come from CreatePage.

local repo = "https://raw.githubusercontent.com/sickletone/Severe-UI/main/"

local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

-- Addons return a function that takes the library, so call it with Library.
loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()(Library)
loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()(Library)

-- Prints a line for each callback, so you can see which component fired and what value it got.
local function log(kind, name, ...)
    print("[Severe Showcase] " .. kind .. " - " .. name .. ":", ...)
end

local function notify(message, title)
    Library.Notify(message, title or "Showcase")
end

-- Shared option lists so dropdowns on different pages can reuse them.
local COLOR_CHOICES = {"Red", "Green", "Blue", "Yellow", "White"}
local SIZE_CHOICES = {"Small", "Medium", "Large"}
local LETTER_CHOICES = {"Option A", "Option B", "Option C", "Option D"}

--// PAGE 1: COMPONENTS \\--

local compLeft, compRight = Library.CreatePage("Components", 0)

--// Toggles (left column) \\--

local toggleCard = Library.Section(compLeft, "Toggles", "Components")

-- Library.AddToggle(column, name, default, options)
-- Options: Hint, Gear, OnGear, Keybind {Key, Mode}, Color, OnColor, Callback
local toggleExample1 = Library.AddToggle(toggleCard, "Toggle Example 1", true, {
    Hint = "A basic toggle with a hint. Hover the title to see it.",
    Callback = function(value)
        log("Toggle", "Toggle Example 1", value)
    end
})

Library.AddToggle(toggleCard, "Toggle Example 2", false, {
    Hint = "A toggle with a gear button. The gear runs OnGear.",
    Gear = true,
    OnGear = function()
        notify("Toggle Example 2 gear was clicked", "Gear")
    end,
    Callback = function(value)
        log("Toggle", "Toggle Example 2", value)
    end
})

Library.AddToggle(toggleCard, "Toggle Example 3", false, {
    Hint = "A toggle with a keybind in Toggle mode.",
    Keybind = {Key = "F", Mode = "Toggle"},
    Callback = function(value)
        log("Toggle", "Toggle Example 3", value)
    end
})

Library.AddToggle(toggleCard, "Toggle Example 4", false, {
    Hint = "A toggle with a color swatch. OnColor fires when the color changes.",
    Color = Color3.fromRGB(255, 80, 80),
    OnColor = function(color, alpha)
        log("Toggle", "Toggle Example 4 color", color, alpha)
    end,
    Callback = function(value)
        log("Toggle", "Toggle Example 4", value)
    end
})

Library.AddToggle(toggleCard, "Toggle Example 5", true, {
    Hint = "A toggle with a keybind in Always mode. It stays on.",
    Keybind = {Key = "G", Mode = "Always"},
    Callback = function(value)
        log("Toggle", "Toggle Example 5", value)
    end
})

--// Dependencies under Toggle Example 1 \\--

-- Library.AddDependency(column, toggle, options) returns a column that
-- shows only while the toggle is on.
local dependencyOne = Library.AddDependency(toggleCard, toggleExample1, {Indent = 14})

Library.AddSlider(dependencyOne, "Dependency Slider Example", 0, 50, 10, {
    Precision = 0,
    Suffix = " units",
    Hint = "This slider only shows while Toggle Example 1 is on.",
    Callback = function(value)
        log("Slider", "Dependency Slider Example", value)
    end
})

Library.AddDropdown(dependencyOne, "Dependency Dropdown Example", SIZE_CHOICES, "Medium", {
    Hint = "This dropdown only shows while Toggle Example 1 is on.",
    Callback = function(value)
        log("Dropdown", "Dependency Dropdown Example", value)
    end
})

Library.AddToggle(dependencyOne, "Dependency Toggle Example", false, {
    Callback = function(value)
        log("Toggle", "Dependency Toggle Example", value)
    end
})

--// Group (left column) \\--

local groupOne = Library.AddGroup(toggleCard, "Group Example")

Library.AddToggle(groupOne, "Grouped Toggle Example 1", false, {
    Callback = function(value)
        log("Toggle", "Grouped Toggle Example 1", value)
    end
})

Library.AddToggle(groupOne, "Grouped Toggle Example 2", true, {
    Callback = function(value)
        log("Toggle", "Grouped Toggle Example 2", value)
    end
})

--// Sub window opened from a button (left column) \\--

-- Library.AddSubWindow(column, buttonText, title, options) returns a window.
-- window.Container is a column you can add components to.
-- window.Open() and window.Close() show and hide it.
local subWindowOne = Library.AddSubWindow(toggleCard, "Open Sub Window Example", "Sub Window Example", {
    Width = 420,
    Height = 380
})

Library.AddToggle(subWindowOne.Container, "Sub Window Toggle Example 1", false, {
    Hint = "A toggle inside a sub window.",
    Callback = function(value)
        log("Toggle", "Sub Window Toggle Example 1", value)
    end
})

Library.AddToggle(subWindowOne.Container, "Sub Window Toggle Example 2", true, {
    Callback = function(value)
        log("Toggle", "Sub Window Toggle Example 2", value)
    end
})

Library.AddSlider(subWindowOne.Container, "Sub Window Slider Example", 0, 100, 25, {
    Precision = 0,
    Suffix = "%",
    Callback = function(value)
        log("Slider", "Sub Window Slider Example", value)
    end
})

Library.AddDropdown(subWindowOne.Container, "Sub Window Dropdown Example", COLOR_CHOICES, "Blue", {
    Callback = function(value)
        log("Dropdown", "Sub Window Dropdown Example", value)
    end
})

Library.AddColorPicker(subWindowOne.Container, "Sub Window Color Picker Example", Color3.fromRGB(120, 200, 255), 1, {
    Callback = function(color, alpha)
        log("ColorPicker", "Sub Window Color Picker Example", color, alpha)
    end
})

Library.AddButton(subWindowOne.Container, "Close This Sub Window", function()
    subWindowOne.Close()
end)

--// Sliders and pickers (right column) \\--

local sliderCard = Library.Section(compRight, "Sliders and Pickers", "Components")

-- Library.AddSlider(column, name, minimum, maximum, default, options)
-- Options: Hint, Precision, Step, Suffix, Sub, Callback
Library.AddSlider(sliderCard, "Slider Example 1", 0, 100, 50, {
    Hint = "A slider from 0 to 100 with no decimals and a percent suffix.",
    Precision = 0,
    Suffix = "%",
    Callback = function(value)
        log("Slider", "Slider Example 1", value)
    end
})

Library.AddSlider(sliderCard, "Slider Example 2", 0, 10, 2.5, {
    Hint = "A slider with one decimal place and a step of 0.5.",
    Precision = 1,
    Step = 0.5,
    Callback = function(value)
        log("Slider", "Slider Example 2", value)
    end
})

Library.AddSlider(sliderCard, "Slider Example 3", 1, 16, 4, {
    Hint = "A slider with Sub set, so it is indented as a sub-option.",
    Precision = 0,
    Sub = true,
    Callback = function(value)
        log("Slider", "Slider Example 3", value)
    end
})

-- Library.AddDualSlider(column, name, minimum, maximum, low, high, options)
Library.AddDualSlider(sliderCard, "Dual Slider Example 1", 0, 100, 20, 80, {
    Hint = "Two handles. The callback gets the low and high values.",
    Precision = 0,
    Suffix = "px",
    Callback = function(low, high)
        log("DualSlider", "Dual Slider Example 1", low, high)
    end
})

Library.AddDualSlider(sliderCard, "Dual Slider Example 2", -50, 50, -10, 10, {
    Precision = 1,
    Callback = function(low, high)
        log("DualSlider", "Dual Slider Example 2", low, high)
    end
})

-- Library.AddColorPicker(column, name, default, alpha, options)
Library.AddColorPicker(sliderCard, "Color Picker Example 1", Color3.fromRGB(255, 0, 0), 1, {
    Hint = "A color picker with full opacity.",
    Callback = function(color, alpha)
        log("ColorPicker", "Color Picker Example 1", color, alpha)
    end
})

Library.AddColorPicker(sliderCard, "Color Picker Example 2", Color3.fromRGB(0, 170, 255), 0.5, {
    Hint = "A color picker that starts at half opacity.",
    Callback = function(color, alpha)
        log("ColorPicker", "Color Picker Example 2", color, alpha)
    end
})

-- Library.AddKeyPicker(column, name, key, mode, options)
-- Modes: Toggle, Hold, Always, None
Library.AddKeyPicker(sliderCard, "Key Picker Example 1", "E", "Toggle", {
    Hint = "A key picker in Toggle mode.",
    Callback = function(state)
        log("KeyPicker", "Key Picker Example 1", state)
    end
})

Library.AddKeyPicker(sliderCard, "Key Picker Example 2", "Q", "Hold", {
    Hint = "A key picker in Hold mode. It is on only while the key is held.",
    Callback = function(state)
        log("KeyPicker", "Key Picker Example 2", state)
    end
})

Library.AddKeyPicker(sliderCard, "Key Picker Example 3", "R", "Always", {
    Hint = "A key picker in Always mode. It is always on.",
    Callback = function(state)
        log("KeyPicker", "Key Picker Example 3", state)
    end
})

Library.AddKeyPicker(sliderCard, "Key Picker Example 4", "X", "None", {
    Hint = "A key picker in None mode. It does nothing.",
    Callback = function(state)
        log("KeyPicker", "Key Picker Example 4", state)
    end
})

--// PAGE 2: INPUTS \\--

local inputLeft, inputRight = Library.CreatePage("Inputs", 0)

--// Dropdowns, text boxes, buttons, list boxes (left column) \\--

local inputCard = Library.Section(inputLeft, "Dropdowns, Text and Lists", "Inputs")

-- Library.AddDropdown(column, name, options, default, options)
Library.AddDropdown(inputCard, "Dropdown Example 1", LETTER_CHOICES, "Option A", {
    Hint = "A dropdown with four choices.",
    Callback = function(value)
        log("Dropdown", "Dropdown Example 1", value)
    end
})

Library.AddDropdown(inputCard, "Dropdown Example 2", SIZE_CHOICES, "Medium", {
    Hint = "A dropdown with three sizes.",
    Callback = function(value)
        log("Dropdown", "Dropdown Example 2", value)
    end
})

-- Keep a reference so a button below can replace its options with SetOptions.
local dropdownThree = Library.AddDropdown(inputCard, "Dropdown Example 3", COLOR_CHOICES, "Red", {
    Hint = "Use Button Example 2 to swap this dropdown's options.",
    Callback = function(value)
        log("Dropdown", "Dropdown Example 3", value)
    end
})

-- Library.AddTextBox(column, name, default, callback)
Library.AddTextBox(inputCard, "Text Box Example 1", "Hello", function(text)
    log("TextBox", "Text Box Example 1", text)
end)

Library.AddTextBox(inputCard, "Text Box Example 2", "", function(text)
    log("TextBox", "Text Box Example 2", text)
end)

-- Library.AddButton(column, name, callback)
Library.AddButton(inputCard, "Button Example 1", function()
    notify("Button Example 1 was clicked", "Button")
end)

Library.AddButton(inputCard, "Button Example 2 (Refresh Dropdown 3)", function()
    dropdownThree.SetOptions({"Cyan", "Magenta", "Lime", "Orange"})
    notify("Dropdown Example 3 now has new options", "Dropdown")
end)

-- Library.AddListBox(column, height, emptyText, onSelect) returns a box
-- with Get, Set and SetOptions.
local listBox = Library.AddListBox(inputCard, 120, "No items yet", function(option)
    log("ListBox", "List Box Example", option)
end)

Library.AddButton(inputCard, "Button Example 3 (Fill List Box)", function()
    listBox.SetOptions({"Item One", "Item Two", "Item Three", "Item Four", "Item Five"})
end)

Library.AddDropdown(inputCard, "Dropdown Example 4", {"Alpha", "Beta"}, "Alpha", {
    Callback = function(value)
        log("Dropdown", "Dropdown Example 4", value)
    end
})

--// Tab box (right column) \\--

local tabCard = Library.Section(inputRight, "Tab Box", "Inputs")

-- Library.AddTabBox(column, options)
-- Options: Tabs (list of names), Default (tab to open first), Align (Left, Center, Right)
local tabBox = Library.AddTabBox(tabCard, {
    Tabs = {"Alpha", "Beta", "Gamma"},
    Default = "Beta",
    Align = "Center"
})

-- tabBox.Tab(name) returns the tab. Tabs act as columns for components.
local tabAlpha = tabBox.Tab("Alpha")

Library.AddToggle(tabAlpha, "Tab Alpha Toggle Example", true, {
    Hint = "A toggle inside the Alpha tab.",
    Callback = function(value)
        log("Toggle", "Tab Alpha Toggle Example", value)
    end
})

Library.AddSlider(tabAlpha, "Tab Alpha Slider Example", 0, 10, 5, {
    Precision = 0,
    Callback = function(value)
        log("Slider", "Tab Alpha Slider Example", value)
    end
})

Library.AddDropdown(tabAlpha, "Tab Alpha Dropdown Example", SIZE_CHOICES, "Small", {
    Callback = function(value)
        log("Dropdown", "Tab Alpha Dropdown Example", value)
    end
})

Library.AddButton(tabAlpha, "Tab Alpha Button Example", function()
    notify("Tab Alpha Button Example was clicked", "Tab Alpha")
end)

local tabBeta = tabBox.Tab("Beta")

Library.AddToggle(tabBeta, "Tab Beta Toggle Example", false, {
    Callback = function(value)
        log("Toggle", "Tab Beta Toggle Example", value)
    end
})

Library.AddDualSlider(tabBeta, "Tab Beta Dual Slider Example", 0, 10, 2, 8, {
    Precision = 0,
    Callback = function(low, high)
        log("DualSlider", "Tab Beta Dual Slider Example", low, high)
    end
})

Library.AddColorPicker(tabBeta, "Tab Beta Color Picker Example", Color3.fromRGB(180, 90, 255), 1, {
    Callback = function(color, alpha)
        log("ColorPicker", "Tab Beta Color Picker Example", color, alpha)
    end
})

Library.AddTextBox(tabBeta, "Tab Beta Text Box Example", "Beta text", function(text)
    log("TextBox", "Tab Beta Text Box Example", text)
end)

local tabGamma = tabBox.Tab("Gamma")

Library.AddKeyPicker(tabGamma, "Tab Gamma Key Picker Example", "C", "Toggle", {
    Callback = function(state)
        log("KeyPicker", "Tab Gamma Key Picker Example", state)
    end
})

local gammaGroup = Library.AddGroup(tabGamma, "Tab Gamma Group Example")

Library.AddToggle(gammaGroup, "Tab Gamma Grouped Toggle Example 1", false, {
    Callback = function(value)
        log("Toggle", "Tab Gamma Grouped Toggle Example 1", value)
    end
})

Library.AddToggle(gammaGroup, "Tab Gamma Grouped Toggle Example 2", true, {
    Callback = function(value)
        log("Toggle", "Tab Gamma Grouped Toggle Example 2", value)
    end
})

local gammaWindow = Library.AddSubWindow(tabGamma, "Open Tab Gamma Sub Window", "Tab Gamma Sub Window", {
    Width = 380,
    Height = 300
})

Library.AddDropdown(gammaWindow.Container, "Tab Gamma Sub Window Dropdown Example", LETTER_CHOICES, "Option B", {
    Callback = function(value)
        log("Dropdown", "Tab Gamma Sub Window Dropdown Example", value)
    end
})

Library.AddSlider(gammaWindow.Container, "Tab Gamma Sub Window Slider Example", 0, 1, 0.5, {
    Precision = 2,
    Step = 0.05,
    Callback = function(value)
        log("Slider", "Tab Gamma Sub Window Slider Example", value)
    end
})

Library.AddButton(gammaWindow.Container, "Close Tab Gamma Sub Window", function()
    gammaWindow.Close()
end)

--// PAGE 3: LAYOUT \\--

local layoutLeft, layoutRight = Library.CreatePage("Layout", 0)

--// Sub windows (left column) \\--

local windowCard = Library.Section(layoutLeft, "Sub Windows", "Layout")

-- Sub window one: plain components.
local windowOne = Library.AddSubWindow(windowCard, "Open Sub Window One", "Sub Window One", {
    Width = 400,
    Height = 340
})

Library.AddToggle(windowOne.Container, "Window One Toggle Example 1", true, {
    Callback = function(value)
        log("Toggle", "Window One Toggle Example 1", value)
    end
})

Library.AddToggle(windowOne.Container, "Window One Toggle Example 2", false, {
    Callback = function(value)
        log("Toggle", "Window One Toggle Example 2", value)
    end
})

Library.AddSlider(windowOne.Container, "Window One Slider Example", 0, 100, 40, {
    Precision = 0,
    Suffix = "%",
    Callback = function(value)
        log("Slider", "Window One Slider Example", value)
    end
})

Library.AddDropdown(windowOne.Container, "Window One Dropdown Example", SIZE_CHOICES, "Large", {
    Callback = function(value)
        log("Dropdown", "Window One Dropdown Example", value)
    end
})

Library.AddButton(windowOne.Container, "Close Sub Window One", function()
    windowOne.Close()
end)

-- Sub window two: a tab box and a list box inside the window.
local windowTwo = Library.AddSubWindow(windowCard, "Open Sub Window Two", "Sub Window Two", {
    Width = 440,
    Height = 420
})

local windowTwoTabs = Library.AddTabBox(windowTwo.Container, {
    Tabs = {"One", "Two"},
    Default = "One"
})

local windowTwoOne = windowTwoTabs.Tab("One")

Library.AddToggle(windowTwoOne, "Window Two Tab One Toggle Example", true, {
    Callback = function(value)
        log("Toggle", "Window Two Tab One Toggle Example", value)
    end
})

Library.AddSlider(windowTwoOne, "Window Two Tab One Slider Example", 0, 20, 10, {
    Precision = 0,
    Callback = function(value)
        log("Slider", "Window Two Tab One Slider Example", value)
    end
})

local windowTwoTwo = windowTwoTabs.Tab("Two")

local windowTwoList = Library.AddListBox(windowTwoTwo, 100, "Empty list", function(option)
    log("ListBox", "Window Two List Box Example", option)
end)

windowTwoList.SetOptions({"Entry A", "Entry B", "Entry C"})

Library.AddButton(windowTwo.Container, "Close Sub Window Two", function()
    windowTwo.Close()
end)

-- Sub window three: color, key and text inputs.
local windowThree = Library.AddSubWindow(windowCard, "Open Sub Window Three", "Sub Window Three", {
    Width = 400,
    Height = 360
})

Library.AddColorPicker(windowThree.Container, "Window Three Color Picker Example", Color3.fromRGB(255, 200, 80), 1, {
    Callback = function(color, alpha)
        log("ColorPicker", "Window Three Color Picker Example", color, alpha)
    end
})

Library.AddKeyPicker(windowThree.Container, "Window Three Key Picker Example", "P", "Toggle", {
    Callback = function(state)
        log("KeyPicker", "Window Three Key Picker Example", state)
    end
})

Library.AddDualSlider(windowThree.Container, "Window Three Dual Slider Example", 0, 255, 60, 200, {
    Precision = 0,
    Callback = function(low, high)
        log("DualSlider", "Window Three Dual Slider Example", low, high)
    end
})

Library.AddTextBox(windowThree.Container, "Window Three Text Box Example", "Type here", function(text)
    log("TextBox", "Window Three Text Box Example", text)
end)

Library.AddButton(windowThree.Container, "Close Sub Window Three", function()
    windowThree.Close()
end)

--// Groups and nested dependencies (right column) \\--

local groupCard = Library.Section(layoutRight, "Groups and Dependencies", "Layout")

local groupA = Library.AddGroup(groupCard, "Group Example A")

Library.AddToggle(groupA, "Group A Toggle Example 1", false, {
    Callback = function(value)
        log("Toggle", "Group A Toggle Example 1", value)
    end
})

Library.AddToggle(groupA, "Group A Toggle Example 2", true, {
    Callback = function(value)
        log("Toggle", "Group A Toggle Example 2", value)
    end
})

Library.AddSlider(groupA, "Group A Slider Example", 0, 5, 1, {
    Precision = 0,
    Callback = function(value)
        log("Slider", "Group A Slider Example", value)
    end
})

local groupB = Library.AddGroup(groupCard, "Group Example B")

Library.AddDropdown(groupB, "Group B Dropdown Example", COLOR_CHOICES, "Green", {
    Callback = function(value)
        log("Dropdown", "Group B Dropdown Example", value)
    end
})

Library.AddTextBox(groupB, "Group B Text Box Example", "Group text", function(text)
    log("TextBox", "Group B Text Box Example", text)
end)

Library.AddButton(groupB, "Group B Button Example", function()
    notify("Group B Button Example was clicked", "Group B")
end)

-- Nested dependencies: the second toggle only shows while the first one is on.
local nestedParent = Library.AddToggle(groupCard, "Nested Parent Toggle Example", false, {
    Callback = function(value)
        log("Toggle", "Nested Parent Toggle Example", value)
    end
})

local nestedChild = Library.AddDependency(groupCard, nestedParent, {Indent = 14})

local nestedGrandchild = nil

local nestedToggle = Library.AddToggle(nestedChild, "Nested Child Toggle Example", false, {
    Callback = function(value)
        log("Toggle", "Nested Child Toggle Example", value)
    end
})

nestedGrandchild = Library.AddDependency(nestedChild, nestedToggle, {Indent = 14})

Library.AddSlider(nestedGrandchild, "Nested Grandchild Slider Example", 0, 100, 60, {
    Precision = 0,
    Suffix = "%",
    Callback = function(value)
        log("Slider", "Nested Grandchild Slider Example", value)
    end
})

Library.AddDropdown(nestedGrandchild, "Nested Grandchild Dropdown Example", SIZE_CHOICES, "Small", {
    Callback = function(value)
        log("Dropdown", "Nested Grandchild Dropdown Example", value)
    end
})

--// PAGE 4: SETTINGS \\--

local settingsLeft, settingsRight = Library.CreatePage("Settings", 0)

--// Notifications (left column) \\--

local notifyCard = Library.Section(settingsLeft, "Notifications", "Settings")

Library.AddButton(notifyCard, "Notify Example 1 (Info)", function()
    notify("This is an info notification.", "Info")
end)

Library.AddButton(notifyCard, "Notify Example 2 (Warning)", function()
    notify("This is a warning notification.", "Warning")
end)

Library.AddButton(notifyCard, "Notify Example 3 (Success)", function()
    notify("This is a success notification.", "Success")
end)

Library.AddToggle(notifyCard, "Notification Toggle Example", true, {
    Hint = "Notifications are controlled by the Show Notifications setting.",
    Callback = function(value)
        log("Toggle", "Notification Toggle Example", value)
    end
})

Library.AddSlider(notifyCard, "Notification Slider Example", 1, 10, 3, {
    Precision = 0,
    Suffix = " sec",
    Callback = function(value)
        log("Slider", "Notification Slider Example", value)
    end
})

Library.AddTextBox(notifyCard, "Notification Text Box Example", "Custom message", function(text)
    log("TextBox", "Notification Text Box Example", text)
end)

Library.AddButton(notifyCard, "Notify Example 4 (Custom Message)", function()
    notify("Custom message from the text box above.", "Custom")
end)

--// Theme (left column) \\--

local themeCard = Library.Section(settingsLeft, "Theme", "Settings")

-- Library.SetTheme(name, accent) applies a preset and an optional accent color.
Library.AddDropdown(themeCard, "Theme Preset Example", Library.PresetOrder, Library.GetThemeName(), {
    Hint = "Applies a built-in theme preset.",
    Callback = function(value)
        log("Dropdown", "Theme Preset Example", value)
        Library.SetTheme(value, Library.GetAccentOverride())
    end
})

Library.AddColorPicker(themeCard, "Accent Color Example", Color3.fromRGB(0, 170, 255), 1, {
    Hint = "Overrides the accent color on top of the current preset.",
    Callback = function(color, alpha)
        log("ColorPicker", "Accent Color Example", color, alpha)
        Library.SetTheme(Library.GetThemeName(), color)
    end
})

Library.AddDropdown(themeCard, "Theme Size Example", SIZE_CHOICES, "Medium", {
    Callback = function(value)
        log("Dropdown", "Theme Size Example", value)
    end
})

--// Misc (right column) \\--

local miscCard = Library.Section(settingsRight, "Misc Components", "Settings")

Library.AddToggle(miscCard, "Misc Toggle Example 1", false, {
    Hint = "A toggle on the Settings page.",
    Callback = function(value)
        log("Toggle", "Misc Toggle Example 1", value)
    end
})

Library.AddToggle(miscCard, "Misc Toggle Example 2", true, {
    Callback = function(value)
        log("Toggle", "Misc Toggle Example 2", value)
    end
})

Library.AddSlider(miscCard, "Misc Slider Example 1", 0, 1, 0.25, {
    Precision = 2,
    Step = 0.05,
    Callback = function(value)
        log("Slider", "Misc Slider Example 1", value)
    end
})

Library.AddSlider(miscCard, "Misc Slider Example 2", 10, 200, 90, {
    Precision = 0,
    Suffix = " ms",
    Callback = function(value)
        log("Slider", "Misc Slider Example 2", value)
    end
})

Library.AddDualSlider(miscCard, "Misc Dual Slider Example", 0, 100, 25, 75, {
    Precision = 0,
    Suffix = "%",
    Callback = function(low, high)
        log("DualSlider", "Misc Dual Slider Example", low, high)
    end
})

Library.AddColorPicker(miscCard, "Misc Color Picker Example", Color3.fromRGB(255, 255, 255), 1, {
    Callback = function(color, alpha)
        log("ColorPicker", "Misc Color Picker Example", color, alpha)
    end
})

Library.AddKeyPicker(miscCard, "Misc Key Picker Example", "H", "Toggle", {
    Callback = function(state)
        log("KeyPicker", "Misc Key Picker Example", state)
    end
})

Library.AddDropdown(miscCard, "Misc Dropdown Example", COLOR_CHOICES, "White", {
    Callback = function(value)
        log("Dropdown", "Misc Dropdown Example", value)
    end
})

Library.AddTextBox(miscCard, "Misc Text Box Example", "", function(text)
    log("TextBox", "Misc Text Box Example", text)
end)

Library.AddButton(miscCard, "Misc Button Example", function()
    notify("Misc Button Example was clicked", "Misc")
end)

local miscGroup = Library.AddGroup(miscCard, "Misc Group Example")

Library.AddToggle(miscGroup, "Misc Grouped Toggle Example", false, {
    Callback = function(value)
        log("Toggle", "Misc Grouped Toggle Example", value)
    end
})

Library.AddSlider(miscGroup, "Misc Grouped Slider Example", 0, 3, 1, {
    Precision = 0,
    Callback = function(value)
        log("Slider", "Misc Grouped Slider Example", value)
    end
})

-- A sub window on the Settings page, with a few components of its own.
local miscWindow = Library.AddSubWindow(miscCard, "Open Misc Sub Window", "Misc Sub Window", {
    Width = 380,
    Height = 300
})

Library.AddToggle(miscWindow.Container, "Misc Window Toggle Example", true, {
    Callback = function(value)
        log("Toggle", "Misc Window Toggle Example", value)
    end
})

Library.AddDropdown(miscWindow.Container, "Misc Window Dropdown Example", LETTER_CHOICES, "Option C", {
    Callback = function(value)
        log("Dropdown", "Misc Window Dropdown Example", value)
    end
})

Library.AddButton(miscWindow.Container, "Close Misc Sub Window", function()
    miscWindow.Close()
end)

--// PAGE 5: EXTRAS \\--

local extraLeft, extraRight = Library.CreatePage("Extras", 0)

--// Dependency chains (left column) \\--

local chainCard = Library.Section(extraLeft, "Dependency Chains", "Extras")

local chainRoot = Library.AddToggle(chainCard, "Chain Root Toggle Example", true, {
    Hint = "Turning this off hides every row in the chain below it.",
    Callback = function(value)
        log("Toggle", "Chain Root Toggle Example", value)
    end
})

local chainLevelOne = Library.AddDependency(chainCard, chainRoot, {Indent = 14})

local chainLevelOneToggle = Library.AddToggle(chainLevelOne, "Chain Level One Toggle Example", true, {
    Callback = function(value)
        log("Toggle", "Chain Level One Toggle Example", value)
    end
})

local chainLevelTwo = Library.AddDependency(chainLevelOne, chainLevelOneToggle, {Indent = 14})

Library.AddSlider(chainLevelTwo, "Chain Level Two Slider Example", 0, 30, 15, {
    Precision = 0,
    Callback = function(value)
        log("Slider", "Chain Level Two Slider Example", value)
    end
})

Library.AddKeyPicker(chainLevelTwo, "Chain Level Two Key Picker Example", "K", "Hold", {
    Callback = function(state)
        log("KeyPicker", "Chain Level Two Key Picker Example", state)
    end
})

--// Programmatic Get and Set (right column) \\--

local programmaticCard = Library.Section(extraRight, "Programmatic Control", "Extras")

local targetToggle = Library.AddToggle(programmaticCard, "Target Toggle Example", false, {
    Callback = function(value)
        log("Toggle", "Target Toggle Example", value)
    end
})

local targetSlider = Library.AddSlider(programmaticCard, "Target Slider Example", 0, 100, 10, {
    Precision = 0,
    Callback = function(value)
        log("Slider", "Target Slider Example", value)
    end
})

local targetDropdown = Library.AddDropdown(programmaticCard, "Target Dropdown Example", SIZE_CHOICES, "Small", {
    Callback = function(value)
        log("Dropdown", "Target Dropdown Example", value)
    end
})

local targetKey = Library.AddKeyPicker(programmaticCard, "Target Key Picker Example", "J", "Toggle", {
    Callback = function(state)
        log("KeyPicker", "Target Key Picker Example", state)
    end
})

Library.AddButton(programmaticCard, "Button Example 4 (Set Target Values)", function()
    targetToggle.Set(true, true)
    targetSlider.Set(75, true)
    targetDropdown.Set("Large", true)
    targetKey.SetKey("L")
    notify("Set the target values from code", "Programmatic")
end)

Library.AddButton(programmaticCard, "Button Example 5 (Read Target Values)", function()
    log("Read", "Target Toggle Example", targetToggle.Get())
    log("Read", "Target Slider Example", targetSlider.Get())
    log("Read", "Target Dropdown Example", targetDropdown.Get())
    log("Read", "Target Key Picker Example", targetKey.Get().Key)
end)

--// Long-form examples (both columns) \\--

local longCard = Library.Section(extraLeft, "Long Form Examples", "Extras")

Library.AddToggle(longCard, "Long Toggle Example 1", false, {
    Hint = "Hint text for a toggle with every common option set.",
    Gear = true,
    OnGear = function()
        notify("Long Toggle Example 1 gear clicked", "Gear")
    end,
    Color = Color3.fromRGB(90, 220, 140),
    OnColor = function(color, alpha)
        log("Toggle", "Long Toggle Example 1 color", color, alpha)
    end,
    Keybind = {Key = "V", Mode = "Hold"},
    Callback = function(value)
        log("Toggle", "Long Toggle Example 1", value)
    end
})

Library.AddToggle(longCard, "Long Toggle Example 2", true, {
    Hint = "A toggle with a keybind in None mode.",
    Keybind = {Key = "N", Mode = "None"},
    Callback = function(value)
        log("Toggle", "Long Toggle Example 2", value)
    end
})

Library.AddSlider(longCard, "Long Slider Example 1", -100, 100, 0, {
    Hint = "A slider with negative values.",
    Precision = 0,
    Step = 5,
    Callback = function(value)
        log("Slider", "Long Slider Example 1", value)
    end
})

Library.AddSlider(longCard, "Long Slider Example 2", 0, 1000, 500, {
    Hint = "A wide slider with a large step.",
    Precision = 0,
    Step = 50,
    Suffix = " pts",
    Callback = function(value)
        log("Slider", "Long Slider Example 2", value)
    end
})

Library.AddDualSlider(longCard, "Long Dual Slider Example", 0, 360, 45, 315, {
    Hint = "A dual slider for angles.",
    Precision = 0,
    Suffix = " deg",
    Callback = function(low, high)
        log("DualSlider", "Long Dual Slider Example", low, high)
    end
})

Library.AddDropdown(longCard, "Long Dropdown Example 1", {"First", "Second", "Third", "Fourth", "Fifth", "Sixth"}, "Third", {
    Hint = "A dropdown with six choices.",
    Callback = function(value)
        log("Dropdown", "Long Dropdown Example 1", value)
    end
})

Library.AddDropdown(longCard, "Long Dropdown Example 2", {}, nil, {
    Hint = "An empty dropdown. Use Button Example 6 to fill it.",
    Callback = function(value)
        log("Dropdown", "Long Dropdown Example 2", value)
    end
})

local longDropdownTwo = nil

longDropdownTwo = Library.AddDropdown(longCard, "Long Dropdown Example 3", {"Start"}, "Start", {
    Callback = function(value)
        log("Dropdown", "Long Dropdown Example 3", value)
    end
})

Library.AddButton(longCard, "Button Example 6 (Fill Long Dropdown)", function()
    longDropdownTwo.SetOptions({"Start", "Middle", "End"})
    notify("Long Dropdown Example 3 has new options", "Dropdown")
end)

Library.AddTextBox(longCard, "Long Text Box Example", "Type a value", function(text, enterPressed)
    log("TextBox", "Long Text Box Example", text, enterPressed)
end)

local longColumnGroup = Library.AddGroup(longCard, "Long Group Example")

Library.AddToggle(longColumnGroup, "Long Grouped Toggle Example 1", true, {
    Callback = function(value)
        log("Toggle", "Long Grouped Toggle Example 1", value)
    end
})

Library.AddToggle(longColumnGroup, "Long Grouped Toggle Example 2", false, {
    Callback = function(value)
        log("Toggle", "Long Grouped Toggle Example 2", value)
    end
})

Library.AddSlider(longColumnGroup, "Long Grouped Slider Example", 0, 10, 5, {
    Precision = 0,
    Callback = function(value)
        log("Slider", "Long Grouped Slider Example", value)
    end
})

--// Right column: tab box with a list box and sub window \\--

local longRightCard = Library.Section(extraRight, "Tab Box and List Box", "Extras")

local longTabs = Library.AddTabBox(longRightCard, {
    Tabs = {"First", "Second", "Third"},
    Default = "Second",
    Align = "Right"
})

local longTabFirst = longTabs.Tab("First")

local listExample = Library.AddListBox(longTabFirst, 110, "Empty list", function(option)
    log("ListBox", "List Box Example", option)
end)

listExample.SetOptions({"Option One", "Option Two", "Option Three"})

Library.AddToggle(longTabFirst, "Tab First Toggle Example", true, {
    Callback = function(value)
        log("Toggle", "Tab First Toggle Example", value)
    end
})

local longTabSecond = longTabs.Tab("Second")

Library.AddDropdown(longTabSecond, "Tab Second Dropdown Example", {"Choice A", "Choice B", "Choice C"}, "Choice B", {
    Callback = function(value)
        log("Dropdown", "Tab Second Dropdown Example", value)
    end
})

Library.AddButton(longTabSecond, "Tab Second Button Example", function()
    notify("Tab Second Button Example was clicked", "Second")
end)

local longTabThird = longTabs.Tab("Third")

Library.AddSlider(longTabThird, "Tab Third Slider Example", 1, 5, 3, {
    Precision = 0,
    Callback = function(value)
        log("Slider", "Tab Third Slider Example", value)
    end
})

Library.AddColorPicker(longTabThird, "Tab Third Color Picker Example", Color3.fromRGB(255, 120, 40), 1, {
    Callback = function(color, alpha)
        log("ColorPicker", "Tab Third Color Picker Example", color, alpha)
    end
})

local longWindow = Library.AddSubWindow(longRightCard, "Open Extras Sub Window", "Extras Sub Window", {
    Width = 400,
    Height = 320
})

Library.AddToggle(longWindow.Container, "Extras Window Toggle Example", false, {
    Callback = function(value)
        log("Toggle", "Extras Window Toggle Example", value)
    end
})

Library.AddSlider(longWindow.Container, "Extras Window Slider Example", 0, 20, 4, {
    Precision = 0,
    Callback = function(value)
        log("Slider", "Extras Window Slider Example", value)
    end
})

Library.AddButton(longWindow.Container, "Close Extras Sub Window", function()
    longWindow.Close()
end)

--// Finish \\--

print("[Severe Showcase] Loaded. Pages: Components, Inputs, Layout, Settings, Extras.")
