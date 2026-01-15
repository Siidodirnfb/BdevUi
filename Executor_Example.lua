-- BdevUi Executor Example
-- Copy and execute this in your Roblox executor

-- Load the library (replace with the actual loadstring code)
local BdevUi = loadstring(game:HttpGet("https://raw.githubusercontent.com/your-repo/BdevUi/main/BdevUi_Executor.lua"))()

-- Create your UI
local Window = BdevUi:CreateWindow("Executor UI", UDim2.new(0, 400, 0, 300))

-- Add tabs
local MainTab = Window:AddTab("Main")
local ExploitsTab = Window:AddTab("Exploits")
local SettingsTab = Window:AddTab("Settings")

-- Main Tab
MainTab:AddLabel("Welcome to Bdev UI!")
MainTab:AddLabel("High-quality UI for executors")

MainTab:AddButton("Infinite Yield", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    BdevUi:Notify("Success", "Infinite Yield loaded!", 2)
end)

MainTab:AddButton("Dex Explorer", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
    BdevUi:Notify("Success", "Dex Explorer loaded!", 2)
end)

-- Exploits Tab
ExploitsTab:AddLabel("Game Exploits")

local speedEnabled = false
ExploitsTab:AddToggle("Speed Hack", false, function(enabled)
    speedEnabled = enabled
    if enabled then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
        BdevUi:Notify("Speed Hack", "Enabled - WalkSpeed: 100", 2)
    else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
        BdevUi:Notify("Speed Hack", "Disabled - WalkSpeed: 16", 2)
    end
end)

local jumpEnabled = false
ExploitsTab:AddToggle("Jump Hack", false, function(enabled)
    jumpEnabled = enabled
    if enabled then
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = 150
        BdevUi:Notify("Jump Hack", "Enabled - JumpPower: 150", 2)
    else
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
        BdevUi:Notify("Jump Hack", "Disabled - JumpPower: 50", 2)
    end
end)

ExploitsTab:AddSlider("Fly Speed", 10, 200, 50, function(value)
    -- This would require a fly script
    BdevUi:Notify("Fly Speed", "Set to " .. value, 1)
end)

ExploitsTab:AddDropdown("Teleport Location", {"Spawn", "Random Player", "Safe Zone"}, "Spawn", function(location)
    BdevUi:Notify("Teleport", "Selected: " .. location, 2)
    if location == "Spawn" then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
    elseif location == "Random Player" then
        local players = game.Players:GetPlayers()
        local randomPlayer = players[math.random(1, #players)]
        if randomPlayer ~= game.Players.LocalPlayer and randomPlayer.Character then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = randomPlayer.Character.HumanoidRootPart.CFrame
        end
    end
end)

-- Settings Tab
SettingsTab:AddLabel("UI Settings")

SettingsTab:AddToggle("Show Notifications", true, function(enabled)
    BdevUi:Notify("Settings", "Notifications " .. (enabled and "enabled" or "disabled"), 2)
end)

SettingsTab:AddInput("Custom Command", "Enter command...", function(text, enter)
    if enter and text ~= "" then
        print("Executing command:", text)
        BdevUi:Notify("Command", "Executed: " .. text, 2)
    end
end)

SettingsTab:AddButton("Destroy UI", function()
    BdevUi:Notify("Goodbye", "UI destroyed!", 2)
    wait(1)
    Window:Destroy()
end)

-- Show welcome notification
BdevUi:Notify("Bdev UI", "Executor UI loaded successfully!", 3)

print("BdevUi Executor Example loaded!")