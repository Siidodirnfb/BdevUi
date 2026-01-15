-- BdevUi Quick Start Guide
-- Copy and paste this into your script to get started quickly

local BdevUi = require(game.ServerScriptService.BdevUi) -- Change path as needed

-- Create your first window
local MyWindow = BdevUi:CreateWindow("My Game UI", UDim2.new(0, 400, 0, 300))

-- Create a tab
local MainTab = MyWindow:AddTab("Main")

-- Add some basic elements
MainTab:AddLabel("Welcome to my game!")

MainTab:AddButton("Click Me", function()
    BdevUi:Notify("Hello!", "Thanks for clicking!", 2)
end)

MainTab:AddToggle("Enable Music", true, function(enabled)
    if enabled then
        print("Music enabled")
    else
        print("Music disabled")
    end
end)

MainTab:AddSlider("Volume", 0, 100, 50, function(value)
    print("Volume set to " .. value)
end)

-- That's it! Your UI is ready to use.
-- Check the Example.lua file for more advanced usage.