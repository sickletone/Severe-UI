Severe-UI

A customizable Roblox UI library inspired by Severe External, with support for reusable components, themes, keybinds, and interface customization.

Quick Install

Load the library directly from GitHub.

local repo = "https://raw.githubusercontent.com/sickletone/Severe-UI/main/"

local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

Example

Create a page, add a section, and start adding components.

local repo = "https://raw.githubusercontent.com/sickletone/Severe-UI/main/"

local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

local left, right = Library.CreatePage("Main", 0)

local section = Library.Section(left, "General", "Main")

Library.AddToggle(section, "Enable Feature", false, {
    Callback = function(value)
        print("Enabled:", value)
    end
})

Library.AddSlider(section, "Speed", 1, 100, 25, {
    Precision = 0,
    Callback = function(value)
        print("Speed:", value)
    end
})

Library.AddButton(section, "Test", function()
    Library.Notify("Button clicked", "General")
end)

Components

Severe-UI includes the following components.

Component| Description
Toggle| Enable or disable a setting
Slider| Select a numeric value
Dual Slider| Select a minimum and maximum value
Dropdown| Choose an option from a list
Color Picker| Select a color and transparency
Key Picker| Assign a key and activation mode
Text Box| Accept text input
Button| Run a callback when clicked
List Box| Display and select items
Group| Organize related components
Tab Box| Switch between nested tabs
Dependency| Show controls based on a toggle
Sub-Window| Open a separate configurable window

Pages and Sections

Pages have two columns, allowing sections and components to be organized side by side.

local left, right = Library.CreatePage("Main", 0)

local general = Library.Section(left, "General", "Main")
local settings = Library.Section(right, "Settings", "Main")

"CreatePage" accepts a page name and a top offset. "Section" accepts a column, section title, and page name.

Toggle

local toggle = Library.AddToggle(section, "Enable Feature", false, {
    Hint = "Enable or disable the feature",
    Callback = function(value)
        print(value)
    end
})

toggle.Set(true)
print(toggle.Get())

Additional options include "Gear", "OnGear", "Keybind", "Color", and "OnColor".

Slider

Library.AddSlider(section, "Speed", 0, 100, 50, {
    Precision = 0,
    Step = 1,
    Suffix = "%",
    Callback = function(value)
        print(value)
    end
})

Options include "Precision", "Step", "Suffix", "Sub", and "Callback".

Dual Slider

Library.AddDualSlider(section, "Range", 0, 100, 20, 80, {
    Precision = 0,
    Callback = function(minimum, maximum)
        print(minimum, maximum)
    end
})

Dropdown

Library.AddDropdown(section, "Mode", {
    "Default",
    "Performance",
    "Quality"
}, "Default", {
    Callback = function(option)
        print(option)
    end
})

Color Picker

Library.AddColorPicker(
    section,
    "Accent",
    Color3.fromRGB(30, 125, 255),
    1,
    {
        Callback = function(color, alpha)
            print(color, alpha)
        end
    }
)

The transparency argument ranges from "0" to "1".

Key Picker

Library.AddKeyPicker(section, "Activation Key", "E", "Toggle", {
    Callback = function(state)
        print(state)
    end
})

Supported activation modes:

- "Toggle"
- "Hold"
- "Always"
- "None"

Text Box

Library.AddTextBox(section, "Username", "", function(text, enterPressed)
    print(text, enterPressed)
end)

Button

Library.AddButton(section, "Run", function()
    Library.Notify("Action completed", "General")
end)

List Box

local list = Library.AddListBox(
    section,
    120,
    "No items available",
    function(option)
        print(option)
    end
)

list.SetOptions({"First", "Second", "Third"})
list.Set("First")

print(list.Get())

Available methods: "SetOptions", "Set", and "Get".

Groups and Dependencies

Groups organize related controls inside a section.

local group = Library.AddGroup(section, "Advanced")

Library.AddToggle(group, "Option A", false)
Library.AddToggle(group, "Option B", true)

Dependencies display additional controls while their parent toggle is enabled.

local parent = Library.AddToggle(section, "Enable Advanced", false)

local dependent = Library.AddDependency(section, parent)

Library.AddSlider(dependent, "Intensity", 0, 100, 50, {
    Precision = 0
})

Tab Boxes

Tab boxes let users switch between groups of controls within a section.

local tabs = Library.AddTabBox(section, {
    Align = "Center",
    Tabs = {"General", "Advanced"},
    Default = "General"
})

Library.AddToggle(tabs.Tab("General"), "Enabled", false)
Library.AddSlider(tabs.Tab("Advanced"), "Intensity", 0, 100, 50)

Sub-Windows

Create a separate window with its own controls.

local window = Library.AddSubWindow(
    section,
    "Open Settings",
    "Advanced Settings",
    {
        Width = 380,
        Height = 300
    }
)

Library.AddToggle(window.Container, "Enabled", false)
Library.AddSlider(window.Container, "Speed", 0, 100, 50)

Themes

Severe-UI includes several built-in theme presets.

- Dark
- Light
- Midnight
- Ocean
- Rose
- Forest
- iOS 27 Glass

Change the theme using:

Library.SetTheme("Midnight")

Set a custom accent color:

Library.SetTheme(
    "Dark",
    Color3.fromRGB(30, 125, 255)
)

Display a notification:

Library.Notify("Settings saved", "Success")

Theme Manager

The optional Theme Manager adds controls for changing presets, customizing individual colors, and saving, loading, or deleting themes.

local repo = "https://raw.githubusercontent.com/sickletone/Severe-UI/main/"

local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()(Library)

Save Manager

The optional Save Manager adds configuration management, including saving, loading, overwriting, renaming, deleting, and autoloading configurations.

local repo = "https://raw.githubusercontent.com/sickletone/Severe-UI/main/"

local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()(Library)

Load both managers by calling each addon's returned function with "Library".

The managers use the library's settings and file APIs. Persistent file operations depend on the execution environment supporting the required file functions.

Unload

The library provides an unload function through the execution environment.

local env = (type(getgenv) == "function" and getgenv()) or _G

if type(env.SEVEREUnload) == "function" then
    env.SEVEREUnload()
end

This disconnects tracked connections and destroys the library's UI and related visual elements.

Icons

Severe-UI uses Molto icons.

- "Molto" (https://molto.pages.dev)
- "Molto Icon Library Page" (https://molto.pages.dev/icons)

Repository

"GitHub — Severe-UI" (https://github.com/sickletone/Severe-UI)

"Download Source Code" (https://github.com/sickletone/Severe-UI/archive/refs/heads/main.zip)

Credits

- Severe — Original UI inspiration.
- Molto — Icon Provider.