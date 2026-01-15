-- BdevUi Example Script
-- This script demonstrates how to use the BdevUi library

local BdevUi = require(game.ServerScriptService.BdevUi) -- Change this path to where you placed BdevUi.lua

-- Wait for the game to load
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Create the main window
local Window = BdevUi:CreateWindow("Bdev UI Demo", UDim2.new(0, 500, 0, 400))

-- Create tabs
local MainTab = Window:AddTab("Main")
local SettingsTab = Window:AddTab("Settings")
local AdvancedTab = Window:AddTab("Advanced")

-- Main Tab Elements
MainTab:AddLabel("Welcome to Bdev UI!")
MainTab:AddLabel("This is a high-quality UI library for Roblox")

MainTab:AddButton("Click Me!", function()
    print("Button clicked!")
    BdevUi:Notify("Success", "Button was clicked successfully!", 2)
end)

MainTab:AddButton("Spawn Part", function()
    local part = Instance.new("Part")
    part.Anchored = true
    part.Size = Vector3.new(4, 1, 4)
    part.Position = Vector3.new(0, 5, 0)
    part.BrickColor = BrickColor.new("Bright red")
    part.Parent = workspace

    BdevUi:Notify("Spawned", "A red part has been spawned at (0, 5, 0)", 3)
end)

local toggleValue = false
MainTab:AddToggle("Enable Feature", false, function(value)
    toggleValue = value
    print("Toggle changed to:", value)
    BdevUi:Notify("Toggle", "Feature " .. (value and "enabled" or "disabled"), 2)
end)

MainTab:AddSlider("Volume", 0, 100, 50, function(value)
    print("Volume set to:", value)
end)

MainTab:AddDropdown("Game Mode", {"Classic", "Hardcore", "Creative", "Survival"}, "Classic", function(value)
    print("Selected game mode:", value)
    BdevUi:Notify("Game Mode", "Changed to: " .. value, 2)
end)

MainTab:AddInput("Player Name", "Enter your name...", function(value, enterPressed)
    print("Player name:", value)
    if enterPressed then
        BdevUi:Notify("Welcome", "Hello, " .. value .. "!", 3)
    end
end)

-- Settings Tab Elements
SettingsTab:AddLabel("Game Settings")

local musicEnabled = true
SettingsTab:AddToggle("Background Music", true, function(value)
    musicEnabled = value
    print("Music:", value and "enabled" or "disabled")
end)

local soundVolume = 75
SettingsTab:AddSlider("Sound Volume", 0, 100, 75, function(value)
    soundVolume = value
    print("Sound volume:", value)
end)

local graphicsQuality = "High"
SettingsTab:AddDropdown("Graphics Quality", {"Low", "Medium", "High", "Ultra"}, "High", function(value)
    graphicsQuality = value
    print("Graphics quality:", value)
end)

SettingsTab:AddButton("Apply Settings", function()
    BdevUi:Notify("Settings", "Settings applied successfully!\nMusic: " .. (musicEnabled and "ON" or "OFF") ..
                  "\nVolume: " .. soundVolume .. "\nQuality: " .. graphicsQuality, 4)
end)

SettingsTab:AddButton("Reset to Defaults", function()
    musicEnabled = true
    soundVolume = 75
    graphicsQuality = "High"

    BdevUi:Notify("Reset", "Settings reset to defaults", 2)
end)

-- Advanced Tab Elements
AdvancedTab:AddLabel("Advanced Features")
AdvancedTab:AddLabel("These are more complex UI elements")

AdvancedTab:AddButton("Show Notification Types", function()
    -- Show different notification types
    BdevUi:Notify("Success", "This is a success notification!", 3)
    wait(1)
    BdevUi:Notify("Warning", "This is a warning notification!", 3)
    wait(1)
    BdevUi:Notify("Error", "This is an error notification!", 3)
end)

local debugMode = false
AdvancedTab:AddToggle("Debug Mode", false, function(value)
    debugMode = value
    if value then
        print("Debug mode enabled")
        BdevUi:Notify("Debug", "Debug mode enabled - check console for logs", 3)
    else
        print("Debug mode disabled")
        BdevUi:Notify("Debug", "Debug mode disabled", 2)
    end
end)

AdvancedTab:AddSlider("Render Distance", 100, 1000, 500, function(value)
    print("Render distance:", value)
    if debugMode then
        BdevUi:Notify("Render", "Distance set to " .. value .. " studs", 1)
    end
end)

AdvancedTab:AddDropdown("Difficulty", {"Easy", "Normal", "Hard", "Expert", "Nightmare"}, "Normal", function(value)
    print("Difficulty changed to:", value)

    local descriptions = {
        Easy = "Relaxed gameplay with generous checkpoints",
        Normal = "Standard difficulty for most players",
        Hard = "Challenging gameplay with fewer checkpoints",
        Expert = "Very difficult with minimal assistance",
        Nightmare = "Extreme difficulty for experienced players"
    }

    BdevUi:Notify("Difficulty", value .. ": " .. descriptions[value], 4)
end)

AdvancedTab:AddInput("Admin Command", "Enter command...", function(value, enterPressed)
    if enterPressed and value ~= "" then
        print("Admin command executed:", value)

        -- Simulate command processing
        if value:lower() == "help" then
            BdevUi:Notify("Help", "Available commands: help, clear, status, restart", 4)
        elseif value:lower() == "clear" then
            BdevUi:Notify("Clear", "Console cleared (simulation)", 2)
        elseif value:lower() == "status" then
            BdevUi:Notify("Status", "Server: Online\nPlayers: " .. #game.Players:GetPlayers() .. "\nUptime: 2h 34m", 4)
        elseif value:lower() == "restart" then
            BdevUi:Notify("Warning", "Server restart initiated...", 3)
        else
            BdevUi:Notify("Unknown Command", "Command '" .. value .. "' not recognized. Type 'help' for commands.", 3)
        end
    end
end)

AdvancedTab:AddLabel("")
AdvancedTab:AddButton("Close UI", function()
    BdevUi:Notify("Goodbye", "Thanks for using Bdev UI!", 3)
    wait(1)
    Window:Destroy()
end)

-- Show welcome notification
BdevUi:Notify("Welcome", "Bdev UI Demo loaded successfully!\nExplore the different tabs to see all features.", 5)

print("BdevUi Demo loaded! Check the UI on your screen.")
print("Library Version:", BdevUi.Version)
print("Author:", BdevUi.Author)