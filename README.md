# Severe-UI

A customizable Roblox UI library inspired by Severe External.

Severe-UI features reusable components, built-in themes, keybinds, configuration management, and interface customization.

---

# Quick Install

```lua
local repo = "https://raw.githubusercontent.com/sickletone/Severe-UI/main/"

local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
```

---

# Example

```lua
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

Library.AddButton(general, "Test", function()
    Library.Notify("Button clicked", "General")
end)
```

---

# Components

Severe-UI includes the following components.

- Toggle
- Slider
- Dual Slider
- Dropdown
- Color Picker
- Key Picker
- Text Box
- Button
- List Box
- Group
- Tab Box
- Dependency
- Sub-Window

---

# Pages and Sections

Pages have two columns, allowing components to be organized side by side.

```lua
local left, right = Library.CreatePage("Main", 0)

local general = Library.Section(left, "General", "Main")
local settings = Library.Section(right, "Settings", "Main")
```

`CreatePage` accepts a page name and a top offset.

`Section` accepts a column, section title, and page name.

---

# Toggle

```lua
local toggle = Library.AddToggle(section, "Enable Feature", false, {
    Hint = "Enable or disable the feature",
    Callback = function(value)
        print(value)
    end
})

toggle.Set(true)

print(toggle.Get())
```

Options:

- `Hint`
- `Gear`
- `OnGear`
- `Keybind`
- `Color`
- `OnColor`
- `Callback`

---

# Slider

```lua
Library.AddSlider(section, "Speed", 0, 100, 50, {
    Precision = 0,
    Step = 1,
    Suffix = "%",
    Callback = function(value)
        print(value)
    end
})
```

Options:

- `Precision`
- `Step`
- `Suffix`
- `Sub`
- `Callback`

---

# Dual Slider

```lua
Library.AddDualSlider(section, "Range", 0, 100, 20, 80, {
    Precision = 0,
    Callback = function(minimum, maximum)
        print(minimum, maximum)
    end
})
```

---

# Dropdown

```lua
Library.AddDropdown(section, "Mode", {
    "Default",
    "Performance",
    "Quality"
}, "Default", {
    Callback = function(option)
        print(option)
    end
})
```

---

# Color Picker

```lua
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
```

The transparency argument ranges from `0` to `1`.

---

# Key Picker

```lua
Library.AddKeyPicker(section, "Activation Key", "E", "Toggle", {
    Callback = function(state)
        print(state)
    end
})
```

Supported activation modes:

- `Toggle`
- `Hold`
- `Always`
- `None`

---

# Text Box

```lua
Library.AddTextBox(section, "Username", "", function(text, enterPressed)
    print(text, enterPressed)
end)
```

---

# Button

```lua
Library.AddButton(section, "Run", function()
    Library.Notify("Action completed", "General")
end)
```

---

# List Box

```lua
local list = Library.AddListBox(
    section,
    120,
    "No items available",
    function(option)
        print(option)
    end
)

list.SetOptions({
    "First",
    "Second",
    "Third"
})

list.Set("First")

print(list.Get())
```

Available methods:

- `SetOptions(options)`
- `Set(option)`
- `Get()`

---

# Groups

Groups organize related components inside a section.

```lua
local group = Library.AddGroup(section, "Advanced")

Library.AddToggle(group, "Option A", false)
Library.AddToggle(group, "Option B", true)
```

---

# Dependencies

Dependencies display additional controls while their parent toggle is enabled.

```lua
local parent = Library.AddToggle(section, "Enable Advanced", false)

local dependent = Library.AddDependency(section, parent)

Library.AddSlider(dependent, "Intensity", 0, 100, 50, {
    Precision = 0
})
```

---

# Tab Boxes

Tab boxes allow users to switch between groups of controls inside a section.

```lua
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
```

---

# Sub-Windows

Create a separate window with its own controls.

```lua
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
```

Options:

- `Width`
- `Height`

Use `window.Container` to add components to the sub-window.

---

# Themes

Severe-UI includes the following built-in theme presets.

- Dark
- Light
- Midnight
- Ocean
- Rose
- Forest
- iOS 27 Glass

## Change Theme

```lua
Library.SetTheme("Midnight")
```

## Custom Accent Color

```lua
Library.SetTheme(
    "Dark",
    Color3.fromRGB(30, 125, 255)
)
```

---

# Notifications

```lua
Library.Notify("Settings saved", "Success")
```

The first argument is the notification message, and the second is the title.

---

# Theme Manager

The optional Theme Manager provides controls for changing theme presets, customizing individual colors, and saving, loading, or deleting themes.

```lua
local repo = "https://raw.githubusercontent.com/sickletone/Severe-UI/main/"

local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()(Library)
```

---

# Save Manager

The optional Save Manager provides configuration management, including saving, loading, overwriting, renaming, deleting, and autoloading configurations.

```lua
local repo = "https://raw.githubusercontent.com/sickletone/Severe-UI/main/"

local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()(Library)
```

---

# Load Both Managers

```lua
local repo = "https://raw.githubusercontent.com/sickletone/Severe-UI/main/"

local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()(Library)

loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()(Library)
```

Both addons receive the library instance through their returned functions.

Persistent configuration and theme operations depend on the execution environment supporting the required file functions.

---

# Unload

Severe-UI provides an unload function through the execution environment.

```lua
local env = (type(getgenv) == "function" and getgenv()) or _G

if type(env.SEVEREUnload) == "function" then
    env.SEVEREUnload()
end
```

This disconnects tracked connections and destroys the library's UI and related visual elements.

---

# Icons

- [Molto](https://molto.pages.dev)
- [Molto Icon Library](https://molto.pages.dev/icons)

---

# Repository

[Severe-UI on GitHub](https://github.com/sickletone/Severe-UI)

[Download Source Code](https://github.com/sickletone/Severe-UI/archive/refs/heads/main.zip)

---

# Credits

- Severe — Original UI inspiration.
- Molto — Icon Provider.