# BdevUi

A high-quality, modern UI library for Roblox with a sleek black, white, and gray design theme.

![BdevUi Preview](https://i.imgur.com/placeholder.png)

## Features

- 🎨 **Modern Design**: Clean black, white, and gray color scheme
- 🧩 **Component-Based**: Modular UI components that are easy to use
- 📱 **Responsive**: Smooth animations and transitions
- 🔔 **Notifications**: Built-in notification system
- 🎛️ **Interactive Elements**: Buttons, toggles, sliders, dropdowns, and text inputs
- 📑 **Tab System**: Organize your UI with multiple tabs
- 🎯 **Easy to Use**: Simple API with comprehensive documentation
- 🔧 **Customizable**: Extensive theming options

## Components

### Core Components
- **Window**: Main UI container with title bar and content area
- **Tab**: Organize content into different sections
- **Button**: Interactive buttons with hover effects

### Interactive Components
- **Toggle**: On/off switches with smooth animations
- **Slider**: Range selectors with customizable min/max values
- **Dropdown**: Selection menus with multiple options
- **Input**: Text input fields
- **Label**: Text display elements

### Special Features
- **Notifications**: Toast-style notifications
- **Themes**: Customizable color schemes
- **Animations**: Smooth transitions and effects

## Installation

1. Download `BdevUi.lua` and place it in your game
2. Require the module in your script:

```lua
local BdevUi = require(path.to.BdevUi)
```

## Quick Start

```lua
-- Create a window
local Window = BdevUi:CreateWindow("My UI", UDim2.new(0, 400, 0, 300))

-- Add a tab
local MainTab = Window:AddTab("Main")

-- Add components
MainTab:AddLabel("Welcome to Bdev UI!")
MainTab:AddButton("Click Me!", function()
    print("Button clicked!")
end)

MainTab:AddToggle("Enable Feature", false, function(value)
    print("Toggle:", value)
end)

MainTab:AddSlider("Volume", 0, 100, 50, function(value)
    print("Volume:", value)
end)
```

## API Reference

### BdevUi (Main Library)

#### Methods

##### `BdevUi:CreateWindow(title, size, position)`
Creates a new UI window.

**Parameters:**
- `title` (string): Window title
- `size` (UDim2, optional): Window size (default: 400x300)
- `position` (UDim2, optional): Window position (default: centered)

**Returns:** Window object

##### `BdevUi:Notify(title, text, duration)`
Shows a notification.

**Parameters:**
- `title` (string): Notification title
- `text` (string): Notification message
- `duration` (number, optional): Display duration in seconds (default: 3)

##### `BdevUi:Destroy()`
Destroys all UI elements and cleans up resources.

### Window

#### Methods

##### `Window:AddTab(name)`
Adds a new tab to the window.

**Parameters:**
- `name` (string): Tab name

**Returns:** Tab object

##### `Window:SetActiveTab(tabName)`
Sets the active tab.

**Parameters:**
- `tabName` (string): Name of the tab to activate

##### `Window:Minimize()`
Toggles window minimization.

##### `Window:Destroy()`
Destroys the window.

### Tab

#### Methods

##### `Tab:AddButton(text, callback)`
Adds a button to the tab.

**Parameters:**
- `text` (string): Button text
- `callback` (function): Function called when clicked

**Returns:** Button object

##### `Tab:AddToggle(text, default, callback)`
Adds a toggle to the tab.

**Parameters:**
- `text` (string): Toggle label
- `default` (boolean): Initial state
- `callback` (function): Function called when toggled (receives boolean value)

**Returns:** Toggle object

##### `Tab:AddSlider(text, min, max, default, callback)`
Adds a slider to the tab.

**Parameters:**
- `text` (string): Slider label
- `min` (number): Minimum value
- `max` (number): Maximum value
- `default` (number): Initial value
- `callback` (function): Function called when value changes (receives number value)

**Returns:** Slider object

##### `Tab:AddDropdown(text, options, default, callback)`
Adds a dropdown to the tab.

**Parameters:**
- `text` (string): Dropdown label
- `options` (table): Array of option strings
- `default` (string): Initial selected option
- `callback` (function): Function called when selection changes (receives string value)

**Returns:** Dropdown object

##### `Tab:AddInput(text, placeholder, callback)`
Adds a text input to the tab.

**Parameters:**
- `text` (string): Input label
- `placeholder` (string): Placeholder text
- `callback` (function): Function called when text changes (receives string value and enterPressed boolean)

**Returns:** Input object

##### `Tab:AddLabel(text)`
Adds a label to the tab.

**Parameters:**
- `text` (string): Label text

**Returns:** Label object

## Theming

BdevUi comes with a comprehensive theming system. You can customize colors, fonts, sizes, and animations.

### Default Theme

```lua
BdevUi.Theme = {
    -- Primary Colors
    Primary = Color3.fromRGB(0, 0, 0),        -- Pure Black
    Secondary = Color3.fromRGB(255, 255, 255), -- Pure White
    Accent = Color3.fromRGB(64, 64, 64),       -- Medium Gray

    -- Background Colors
    Background = Color3.fromRGB(15, 15, 15),   -- Dark Gray Background
    SecondaryBackground = Color3.fromRGB(25, 25, 25),
    TertiaryBackground = Color3.fromRGB(35, 35, 35),

    -- Text Colors
    Text = Color3.fromRGB(255, 255, 255),      -- White text
    TextSecondary = Color3.fromRGB(200, 200, 200),
    TextTertiary = Color3.fromRGB(150, 150, 150),

    -- And many more options...
}
```

### Customizing Theme

You can modify the theme before creating UI elements:

```lua
-- Change primary colors
BdevUi.Theme.Primary = Color3.fromRGB(30, 30, 30)
BdevUi.Theme.Accent = Color3.fromRGB(100, 100, 100)

-- Change font
BdevUi.Theme.Font = Enum.Font.SourceSansBold
BdevUi.Theme.TextSize = 16

-- Create UI with custom theme
local Window = BdevUi:CreateWindow("Custom Themed UI")
```

## Examples

### Basic UI Setup

```lua
local BdevUi = require(game.ServerScriptService.BdevUi)

local Window = BdevUi:CreateWindow("Game Settings", UDim2.new(0, 450, 0, 350))
local SettingsTab = Window:AddTab("Settings")

-- Volume control
SettingsTab:AddSlider("Master Volume", 0, 100, 80, function(value)
    -- Set game volume
    game.SoundService.Volume = value / 100
end)

-- Graphics settings
SettingsTab:AddDropdown("Quality", {"Low", "Medium", "High", "Ultra"}, "High", function(value)
    print("Graphics quality set to:", value)
end)

-- Feature toggles
SettingsTab:AddToggle("Particles", true, function(enabled)
    game.Lighting.GlobalShadows = enabled
end)

SettingsTab:AddButton("Apply Settings", function()
    BdevUi:Notify("Settings", "Settings applied successfully!", 2)
end)
```

### Advanced UI with Multiple Tabs

```lua
local BdevUi = require(game.ServerScriptService.BdevUi)

local MainWindow = BdevUi:CreateWindow("Admin Panel", UDim2.new(0, 600, 0, 450))

-- Player Management Tab
local PlayerTab = MainWindow:AddTab("Players")
PlayerTab:AddLabel("Player Management")

PlayerTab:AddButton("Kick All", function()
    for _, player in pairs(game.Players:GetPlayers()) do
        player:Kick("Server maintenance")
    end
    BdevUi:Notify("Admin", "All players kicked", 3)
end)

-- Server Settings Tab
local ServerTab = MainWindow:AddTab("Server")
ServerTab:AddLabel("Server Configuration")

ServerTab:AddToggle("Whitelist", false, function(enabled)
    print("Whitelist:", enabled)
end)

ServerTab:AddInput("Server Message", "Enter message...", function(text, enter)
    if enter and text ~= "" then
        -- Broadcast message to all players
        BdevUi:Notify("Server", text, 5)
    end
end)

-- Teleportation Tab
local TeleportTab = MainWindow:AddTab("Teleport")
TeleportTab:AddLabel("Teleport Options")

TeleportTab:AddDropdown("Location", {"Spawn", "Base", "Arena", "Shop"}, "Spawn", function(location)
    -- Teleport player to selected location
    print("Teleporting to:", location)
end)
```

## Component Methods

Most components have additional methods for runtime manipulation:

### Button
```lua
local button = Tab:AddButton("Click Me!", callback)
button:SetText("New Text")
button:SetCallback(newCallback)
```

### Toggle
```lua
local toggle = Tab:AddToggle("Feature", false, callback)
toggle:SetValue(true)  -- Programmatically set value
local value = toggle:GetValue()  -- Get current value
```

### Slider
```lua
local slider = Tab:AddSlider("Volume", 0, 100, 50, callback)
slider:SetValue(75)  -- Set to 75
local value = slider:GetValue()  -- Get current value
```

### Dropdown
```lua
local dropdown = Tab:AddDropdown("Mode", {"Easy", "Hard"}, "Easy", callback)
dropdown:SetValue("Hard")  -- Select "Hard"
local selected = dropdown:GetValue()  -- Get selected value
```

### Input
```lua
local input = Tab:AddInput("Name", "Enter name...", callback)
input:SetValue("New Name")  -- Set text
local text = input:GetValue()  -- Get current text
```

## Best Practices

1. **Organization**: Use tabs to organize related settings
2. **Naming**: Use clear, descriptive names for components
3. **Validation**: Validate user input in callbacks
4. **Feedback**: Use notifications to provide user feedback
5. **Cleanup**: Call `BdevUi:Destroy()` when done to clean up resources
6. **Performance**: Avoid creating too many UI elements at once

## Compatibility

- **Roblox Studio**: Fully compatible
- **Live Games**: Works in all Roblox environments
- **All Platforms**: Supports PC, Mobile, Xbox, etc.

## License

This library is provided as-is for use in Roblox games. Feel free to modify and distribute.

## Support

For issues or questions:
- Check the example script (`Example.lua`)
- Review the API documentation above
- Test in a simple setup first

## Version History

### v1.0.0
- Initial release
- Core components (Window, Tab, Button, Toggle, Slider, Dropdown, Input, Label)
- Notification system
- Comprehensive theming
- Example scripts and documentation