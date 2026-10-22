Severe-UI

A customizable Roblox UI library inspired by Severe External, featuring reusable components, built-in themes, keybinds, configuration management, and interface customization.

Quick Install

Load Severe-UI directly from GitHub using the following loader:

local repo = "https://raw.githubusercontent.com/sickletone/Severe-UI/main/"

local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

Example

Create a page, add sections, and start adding components.

local repo = "https://raw.githubusercontent.com/sickletone/Severe-UI/main/"

local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

local left, right = Library.CreatePage("Main", 0)

local general = Library.Section(left, "General", "Main")
local settings = Library.Section(right, "Settings", "Main")

Library.AddToggle(general, "Enable Feature", false, {
    Callback = function(value)
        print("Enabled:", value)
    end
})

Library.AddSlider(settings, "Speed", 1, 100, 25, {
    Precision = 0,
    Callback = function(value)
        print("Speed:", value)
    end
})

Library.AddButton(general, "Test Notification", function()
    Library.Notify("Button clicked", "General")
end)

Components

Severe-UI includes the following components:

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
Group| Organize related controls
Tab Box| Switch between nested tabs
Dependency| Display controls based on a toggle
Sub-Window| Open a separate configurable window

Pages and Sections

Pages contain two columns, allowing components to be organized side by side.

local left, right = Library.CreatePage("Main", 0)

local general = Library.Section(left, "General", "Main")
local settings = Library.Section(right, "Settings", "Main")

- "CreatePage(name, topOffset)" creates a page and returns its left and right columns.
- "Section(column, title, pageName)" creates a section inside a column.

Toggle

Toggles enable or disable settings and support optional controls and callbacks.

local toggle = Library.AddToggle(section, "Enable Feature", false, {
    Hint = "Enable or disable the feature",
    Callback = function(value)
        print("Enabled:", value)
    end
})

toggle.Set(true)
print(toggle.Get())

Options

Option| Description
"Hint"| Additional information about the toggle
"Gear"| Enables the optional gear control
"OnGear"| Callback for the gear control
"Keybind"| Optional keybind configuration
"Color"| Optional color control
"OnColor"| Callback for color changes
"Callback"| Called when the toggle value changes

Slider

Sliders select numeric values within a specified range.

Library.AddSlider(section, "Speed", 0, 100, 50, {
    Precision = 0,
    Step = 1,
    Suffix = "%",
    Callback = function(value)
        print("Speed:", value)
    end
})

Options

Option| Description
"Precision"| Number of decimal places
"Step"| Value increment
"Suffix"| Text displayed after the value
"Sub"| Additional slider configuration
"Callback"| Called when the value changes

Dual Slider

Dual sliders select two values within a shared range.

Library.AddDualSlider(section, "Range", 0, 100, 20, 80, {
    Precision = 0,
    Callback = function(minimum, maximum)
        print("Minimum:", minimum)
        print("Maximum:", maximum)
    end
})

Dropdown

Dropdowns let users select an option from a list.

Library.AddDropdown(section, "Mode", {
    "Default",
    "Performance",
    "Quality"
}, "Default", {
    Callback = function(option)
        print("Selected:", option)
    end
})

The callback receives the selected option.

Color Picker

Color pickers support color selection and transparency.

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

Key pickers let users assign a key and choose an activation mode.

Library.AddKeyPicker(section, "Activation Key", "E", "Toggle", {
    Callback = function(state)
        print("State:", state)
    end
})

Supported activation modes

- "Toggle"
- "Hold"
- "Always"
- "None"

Text Box

Text boxes accept user input.

Library.AddTextBox(section, "Username", "", function(text, enterPressed)
    print("Text:", text)
    print("Enter pressed:", enterPressed)
end)

The callback receives the current text and whether Enter was pressed.

Button

Buttons execute a callback when clicked.

Library.AddButton(section, "Run", function()
    Library.Notify("Action completed", "Success")
end)

List Box

List boxes display selectable items and provide methods to update or retrieve the selection.

local list = Library.AddListBox(
    section,
    120,
    "No items available",
    function(option)
        print("Selected:", option)
    end
)

list.SetOptions({
    "First",
    "Second",
    "Third"
})

list.Set("First")

print(list.Get())

Available methods

Method| Description
"SetOptions(options)"| Updates the available items
"Set(option)"| Sets the selected item
"Get()"| Returns the current selection

Groups and Dependencies

Groups

Groups organize related controls inside a section.

local group = Library.AddGroup(section, "Advanced")

Library.AddToggle(group, "Option A", false)
Library.AddToggle(group, "Option B", true)

Dependencies

Dependencies display additional controls based on the state of a parent toggle.

local parent = Library.AddToggle(section, "Enable Advanced", false)

local dependent = Library.AddDependency(section, parent)

Library.AddSlider(dependent, "Intensity", 0, 100, 50, {
    Precision = 0
})

The dependent controls are displayed while the parent toggle is enabled.

Tab Boxes

Tab boxes let users switch between groups of controls inside a section.

local tabs = Library.AddTabBox(section, {
    Align = "Center",
    Tabs = {
        "General",
        "Advanced"
    },
    Default = "General"
})

Library.AddToggle(tabs.Tab("General"), "Enabled", false)

Library.AddSlider(
    tabs.Tab("Advanced"),
    "Intensity",
    0,
    100,
    50
)

Use "tabs.Tab("TabName")" to access a tab's container.

Sub-Windows

Sub-windows create separate windows with their own controls.

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

Library.AddSlider(
    window.Container,
    "Speed",
    0,
    100,
    50
)

Options

Option| Description
"Width"| Window width
"Height"| Window height

Add components to "window.Container" to place them inside the sub-window.

Themes

Severe-UI includes built-in theme presets:

- "Dark"
- "Light"
- "Midnight"
- "Ocean"
- "Rose"
- "Forest"
- "iOS 27 Glass"

Change Theme

Library.SetTheme("Midnight")

Custom Accent Color

Library.SetTheme(
    "Dark",
    Color3.fromRGB(30, 125, 255)
)

Notifications

Display a notification with an optional title.

Library.Notify("Settings saved", "Success")

Theme Manager

The optional Theme Manager addon provides controls for changing theme presets, customizing individual colors, and saving, loading, or deleting themes.

local repo = "https://raw.githubusercontent.com/sickletone/Severe-UI/main/"

local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()(Library)

Save Manager

The optional Save Manager addon provides configuration management, including saving, loading, overwriting, renaming, deleting, and autoloading configurations.

local repo = "https://raw.githubusercontent.com/sickletone/Severe-UI/main/"

local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()(Library)

Loading Both Addons

Load both addons by calling each addon's returned function with "Library".

local repo = "https://raw.githubusercontent.com/sickletone/Severe-UI/main/"

local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()(Library)
loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()(Library)

The managers use the library's settings and file APIs. Persistent file operations depend on whether the execution environment supports the required file functions.

Unload

Severe-UI provides an unload function through the execution environment.

local env = (type(getgenv) == "function" and getgenv()) or _G

if type(env.SEVEREUnload) == "function" then
    env.SEVEREUnload()
end

This disconnects tracked connections and destroys the library's UI and related visual elements.

Icons

- "Molto" (https://molto.pages.dev)
- "Molto Icon Library" (https://molto.pages.dev/icons)

Check the library source to confirm which icon provider is currently integrated.

Repository

- "Severe-UI on GitHub" (https://github.com/sickletone/Severe-UI)
- "Download Source Code" (https://github.com/sickletone/Severe-UI/archive/refs/heads/main.zip)

Credits

- Severe — Original UI inspiration.
- Molto — Icon provider, if used by the current implementation.