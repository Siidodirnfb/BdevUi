-- BdevUi Test Script
-- Simple test to verify all components work correctly

local BdevUi = require(script.Parent.BdevUi)

print("Starting BdevUi Test...")

-- Test 1: Create Window
local Window = BdevUi:CreateWindow("BdevUi Test", UDim2.new(0, 400, 0, 300))
assert(Window, "Window creation failed")
print("✓ Window created successfully")

-- Test 2: Create Tab
local TestTab = Window:AddTab("Test")
assert(TestTab, "Tab creation failed")
print("✓ Tab created successfully")

-- Test 3: Add Button
local Button = TestTab:AddButton("Test Button", function()
    print("Button callback executed")
end)
assert(Button, "Button creation failed")
print("✓ Button created successfully")

-- Test 4: Add Toggle
local Toggle = TestTab:AddToggle("Test Toggle", true, function(value)
    print("Toggle callback executed with value:", value)
end)
assert(Toggle, "Toggle creation failed")
print("✓ Toggle created successfully")

-- Test 5: Add Slider
local Slider = TestTab:AddSlider("Test Slider", 0, 100, 50, function(value)
    print("Slider callback executed with value:", value)
end)
assert(Slider, "Slider creation failed")
print("✓ Slider created successfully")

-- Test 6: Add Dropdown
local Dropdown = TestTab:AddDropdown("Test Dropdown", {"Option 1", "Option 2", "Option 3"}, "Option 1", function(value)
    print("Dropdown callback executed with value:", value)
end)
assert(Dropdown, "Dropdown creation failed")
print("✓ Dropdown created successfully")

-- Test 7: Add Input
local Input = TestTab:AddInput("Test Input", "Enter text...", function(value, enterPressed)
    print("Input callback executed with value:", value, "enterPressed:", enterPressed)
end)
assert(Input, "Input creation failed")
print("✓ Input created successfully")

-- Test 8: Add Label
local Label = TestTab:AddLabel("Test Label")
assert(Label, "Label creation failed")
print("✓ Label created successfully")

-- Test 9: Notification System
local Notification = BdevUi:Notify("Test", "This is a test notification", 2)
assert(Notification, "Notification creation failed")
print("✓ Notification created successfully")

-- Test 10: Component Methods
Button:SetText("Updated Button")
assert(Button.Button.Text == "Updated Button", "Button SetText failed")
print("✓ Button methods working")

Toggle:SetValue(false)
assert(Toggle:GetValue() == false, "Toggle methods failed")
print("✓ Toggle methods working")

Slider:SetValue(75)
assert(Slider:GetValue() == 75, "Slider methods failed")
print("✓ Slider methods working")

Dropdown:SetValue("Option 2")
assert(Dropdown:GetValue() == "Option 2", "Dropdown methods failed")
print("✓ Dropdown methods working")

Input:SetValue("Test Text")
assert(Input:GetValue() == "Test Text", "Input methods failed")
print("✓ Input methods working")

Label:SetText("Updated Label")
assert(Label.Label.Text == "Updated Label", "Label SetText failed")
print("✓ Label methods working")

-- Test 11: Window Methods
Window:SetActiveTab("Test")
assert(Window.ActiveTab.Name == "Test", "SetActiveTab failed")
print("✓ Window methods working")

-- Test 12: Cleanup
Window:Destroy()
BdevUi:Destroy()
print("✓ Cleanup completed")

print("All tests passed! ✓")
print("BdevUi library is working correctly.")

return true