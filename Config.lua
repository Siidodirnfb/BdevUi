-- BdevUi Configuration
-- Modify these settings to customize the library behavior

local Config = {
    -- Library Settings
    Version = "1.0.0",
    Author = "Bdev Team",

    -- Performance Settings
    MaxNotifications = 5,        -- Maximum number of simultaneous notifications
    TweenCleanupDelay = 1,       -- Delay before cleaning up completed tweens (seconds)
    ConnectionCleanupDelay = 1,  -- Delay before cleaning up unused connections (seconds)

    -- UI Behavior
    DefaultWindowSize = UDim2.new(0, 400, 0, 300),
    DefaultWindowPosition = UDim2.new(0.5, -200, 0.5, -150),
    WindowDraggable = true,
    WindowMinimizable = true,

    -- Animation Settings
    EnableAnimations = true,
    DefaultTweenSpeed = 0.2,
    FastTweenSpeed = 0.1,
    SlowTweenSpeed = 0.4,

    -- Notification Settings
    NotificationDuration = 3,    -- Default notification duration
    NotificationSpacing = 90,    -- Vertical spacing between notifications
    NotificationWidth = 300,
    NotificationHeight = 80,

    -- Component Defaults
    ButtonHeight = 35,
    ToggleHeight = 35,
    SliderHeight = 50,
    DropdownHeight = 35,
    InputHeight = 55,
    LabelHeight = 25,

    -- Tab Settings
    TabButtonWidth = 80,
    TabHeight = 30,
    MaxTabsPerWindow = 10,

    -- Slider Settings
    SliderKnobSize = 12,
    SliderBarHeight = 6,

    -- Toggle Settings
    ToggleButtonWidth = 40,
    ToggleButtonHeight = 20,
    ToggleKnobSize = 16,

    -- Dropdown Settings
    DropdownButtonWidth = 120,
    MaxDropdownOptions = 20,

    -- Input Settings
    MaxInputLength = 100,

    -- Safety Settings
    EnableSafeMode = false,      -- Enable additional error checking
    LogErrors = true,            -- Log errors to console
    LogWarnings = true,          -- Log warnings to console

    -- Debug Settings
    DebugMode = false,           -- Enable debug logging
    ShowFrameBounds = false,     -- Show debug frames around components
    ShowPerformanceStats = false -- Show performance statistics
}

return Config