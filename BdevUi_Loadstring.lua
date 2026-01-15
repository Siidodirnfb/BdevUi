-- BdevUi - Loadstring Compatible Version
-- For Roblox Executors
-- Version 1.0.0

local BdevUi = {}

-- Services (with executor compatibility)
local success, TweenService = pcall(function() return game:GetService("TweenService") end)
if not success then
    warn("BdevUi: TweenService not available")
    TweenService = {
        Create = function() return {
            Play = function() end,
            Cancel = function() end,
            PlaybackState = {Playing = 1},
            Completed = {Connect = function() end}
        } end
    }
end

local success2, UserInputService = pcall(function() return game:GetService("UserInputService") end)
if not success2 then
    warn("BdevUi: UserInputService not available")
    UserInputService = {
        InputChanged = {Connect = function() end},
        InputBegan = {Connect = function() end},
        InputEnded = {Connect = function() end}
    }
end

local success3, RunService = pcall(function() return game:GetService("RunService") end)
if not success3 then
    warn("BdevUi: RunService not available")
    RunService = {RenderStepped = {Connect = function() end}}
end

local success4, Players = pcall(function() return game:GetService("Players") end)
if not success4 then
    warn("BdevUi: Players service not available")
    Players = {LocalPlayer = nil}
end

local success5, CoreGui = pcall(function() return game:GetService("CoreGui") end)
if not success5 then
    warn("BdevUi: CoreGui not available")
    CoreGui = game
end

-- Configuration
BdevUi.Version = "1.0.0"
BdevUi.Author = "Bdev Team"

-- Theme Configuration (Black, White, Gray)
BdevUi.Theme = {
    -- Primary Colors
    Primary = Color3.fromRGB(0, 0, 0),
    Secondary = Color3.fromRGB(255, 255, 255),
    Accent = Color3.fromRGB(64, 64, 64),

    -- Background Colors
    Background = Color3.fromRGB(15, 15, 15),
    SecondaryBackground = Color3.fromRGB(25, 25, 25),
    TertiaryBackground = Color3.fromRGB(35, 35, 35),

    -- Text Colors
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(200, 200, 200),
    TextTertiary = Color3.fromRGB(150, 150, 150),

    -- Border Colors
    Border = Color3.fromRGB(45, 45, 45),
    BorderLight = Color3.fromRGB(75, 75, 75),

    -- Interactive Colors
    Hover = Color3.fromRGB(55, 55, 55),
    Selected = Color3.fromRGB(85, 85, 85),
    Disabled = Color3.fromRGB(40, 40, 40),

    -- Special Colors
    Success = Color3.fromRGB(100, 255, 100),
    Warning = Color3.fromRGB(255, 255, 100),
    Error = Color3.fromRGB(255, 100, 100),

    -- Font
    Font = Enum.Font.SourceSansSemibold,
    TextSize = 14,
    TextScaled = false,

    -- Animation
    TweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    TweenInfoFast = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    TweenInfoSlow = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),

    -- Sizes
    BorderSize = 1,
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 1,

    -- Shadows
    ShadowEnabled = true,
    ShadowColor = Color3.fromRGB(0, 0, 0),
    ShadowTransparency = 0.5,
    ShadowOffset = UDim2.new(0, 2, 0, 2)
}

-- Internal Variables
BdevUi._windows = {}
BdevUi._connections = {}
BdevUi._tweens = {}

-- Utility Functions
BdevUi.Utils = {}

function BdevUi.Utils:Tween(Object, Properties, TweenInfo)
    if not TweenService then return end
    local tweenInfo = TweenInfo or self.Theme.TweenInfo
    local tween = TweenService:Create(Object, tweenInfo, Properties)

    table.insert(self._tweens, tween)
    tween:Play()

    tween.Completed:Connect(function()
        local index = table.find(self._tweens, tween)
        if index then
            table.remove(self._tweens, index)
        end
    end)

    return tween
end

function BdevUi.Utils:CreateShadow(Parent)
    if not self.Theme.ShadowEnabled then return end

    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.BackgroundColor3 = self.Theme.ShadowColor
    shadow.BackgroundTransparency = self.Theme.ShadowTransparency
    shadow.BorderSizePixel = 0
    shadow.Size = UDim2.new(1, 4, 1, 4)
    shadow.Position = self.Theme.ShadowOffset
    shadow.ZIndex = Parent.ZIndex - 1
    shadow.Parent = Parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = shadow

    return shadow
end

function BdevUi.Utils:CreateBorder(Parent)
    local border = Instance.new("UIStroke")
    border.Name = "Border"
    border.Color = self.Theme.Border
    border.Thickness = self.Theme.StrokeThickness
    border.Transparency = self.Theme.BorderTransparency
    border.Parent = Parent

    return border
end

function BdevUi.Utils:CreateCorner(Parent, Radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = Radius or self.Theme.CornerRadius
    corner.Parent = Parent

    return corner
end

function BdevUi.Utils:DeepCopy(Table)
    local copy = {}
    for key, value in pairs(Table) do
        if type(value) == "table" then
            copy[key] = self:DeepCopy(value)
        else
            copy[key] = value
        end
    end
    return copy
end

function BdevUi.Utils:Disconnect(Connection)
    if Connection and Connection.Connected then
        Connection:Disconnect()
    end
end

function BdevUi.Utils:CleanConnections()
    for _, connection in pairs(self._connections) do
        self:Disconnect(connection)
    end
    self._connections = {}
end

function BdevUi.Utils:CleanTweens()
    for _, tween in pairs(self._tweens) do
        if tween.PlaybackState == Enum.PlaybackState.Playing then
            tween:Cancel()
        end
    end
    self._tweens = {}
end

-- Component Classes
BdevUi.Components = {}

-- Window Class
BdevUi.Components.Window = {}
BdevUi.Components.Window.__index = BdevUi.Components.Window

function BdevUi.Components.Window.new(Title, Size, Position)
    local self = setmetatable({}, BdevUi.Components.Window)

    -- Create ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "BdevUi_" .. Title:gsub("%s+", "_")
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Try to parent to CoreGui, fallback to PlayerGui
    local success, error = pcall(function()
        self.ScreenGui.Parent = CoreGui
    end)

    if not success then
        if Players and Players.LocalPlayer then
            local success2, error2 = pcall(function()
                self.ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
            end)
            if not success2 then
                warn("BdevUi: Could not parent ScreenGui to PlayerGui")
                return nil
            end
        else
            warn("BdevUi: No suitable parent found for ScreenGui")
            return nil
        end
    end

    -- Create Main Frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.BackgroundColor3 = BdevUi.Theme.Background
    self.MainFrame.BackgroundTransparency = BdevUi.Theme.BackgroundTransparency
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Size = Size or UDim2.new(0, 400, 0, 300)
    self.MainFrame.Position = Position or UDim2.new(0.5, -200, 0.5, -150)
    self.MainFrame.Active = true
    self.MainFrame.Draggable = true
    self.MainFrame.Parent = self.ScreenGui

    -- Add corner radius and border
    BdevUi.Utils:CreateCorner(self.MainFrame)
    BdevUi.Utils:CreateBorder(self.MainFrame)
    BdevUi.Utils:CreateShadow(self.MainFrame)

    -- Create Title Bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.BackgroundColor3 = BdevUi.Theme.SecondaryBackground
    self.TitleBar.BackgroundTransparency = BdevUi.Theme.BackgroundTransparency
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Size = UDim2.new(1, 0, 0, 35)
    self.TitleBar.Position = UDim2.new(0, 0, 0, 0)
    self.TitleBar.Parent = self.MainFrame

    BdevUi.Utils:CreateCorner(self.TitleBar, UDim.new(0, 6))

    -- Title Text
    self.TitleText = Instance.new("TextLabel")
    self.TitleText.Name = "TitleText"
    self.TitleText.BackgroundTransparency = 1
    self.TitleText.BorderSizePixel = 0
    self.TitleText.Size = UDim2.new(1, -70, 1, 0)
    self.TitleText.Position = UDim2.new(0, 15, 0, 0)
    self.TitleText.Font = BdevUi.Theme.Font
    self.TitleText.Text = Title or "Bdev UI"
    self.TitleText.TextColor3 = BdevUi.Theme.Text
    self.TitleText.TextSize = 16
    self.TitleText.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleText.Parent = self.TitleBar

    -- Close Button
    self.CloseButton = Instance.new("TextButton")
    self.CloseButton.Name = "CloseButton"
    self.CloseButton.BackgroundColor3 = BdevUi.Theme.Background
    self.CloseButton.BackgroundTransparency = 1
    self.CloseButton.BorderSizePixel = 0
    self.CloseButton.Size = UDim2.new(0, 30, 0, 30)
    self.CloseButton.Position = UDim2.new(1, -35, 0, 2.5)
    self.CloseButton.Font = Enum.Font.SourceSansBold
    self.CloseButton.Text = "×"
    self.CloseButton.TextColor3 = BdevUi.Theme.TextSecondary
    self.CloseButton.TextSize = 20
    self.CloseButton.Parent = self.TitleBar

    -- Content Frame
    self.ContentFrame = Instance.new("Frame")
    self.ContentFrame.Name = "ContentFrame"
    self.ContentFrame.BackgroundTransparency = 1
    self.ContentFrame.BorderSizePixel = 0
    self.ContentFrame.Size = UDim2.new(1, -20, 1, -55)
    self.ContentFrame.Position = UDim2.new(0, 10, 0, 45)
    self.ContentFrame.Parent = self.MainFrame

    -- Tab Container
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.BorderSizePixel = 0
    self.TabContainer.Size = UDim2.new(1, 0, 0, 30)
    self.TabContainer.Position = UDim2.new(0, 0, 0, 0)
    self.TabContainer.Parent = self.ContentFrame

    -- Tab Content Container
    self.TabContentContainer = Instance.new("Frame")
    self.TabContentContainer.Name = "TabContentContainer"
    self.TabContentContainer.BackgroundTransparency = 1
    self.TabContentContainer.BorderSizePixel = 0
    self.TabContentContainer.Size = UDim2.new(1, 0, 1, -40)
    self.TabContentContainer.Position = UDim2.new(0, 0, 0, 40)
    self.TabContentContainer.Parent = self.ContentFrame

    -- Initialize Properties
    self.Tabs = {}
    self.ActiveTab = nil
    self.Minimized = false
    self.Closed = false

    -- Connect Events
    self:ConnectEvents()

    -- Register Window
    table.insert(BdevUi._windows, self)

    return self
end

function BdevUi.Components.Window:ConnectEvents()
    -- Close Button
    local closeConnection = self.CloseButton.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    table.insert(BdevUi._connections, closeConnection)

    -- Hover Effects
    local closeHoverConnection = self.CloseButton.MouseEnter:Connect(function()
        BdevUi.Utils:Tween(self.CloseButton, {TextColor3 = BdevUi.Theme.Error})
    end)
    table.insert(BdevUi._connections, closeHoverConnection)

    local closeLeaveConnection = self.CloseButton.MouseLeave:Connect(function()
        BdevUi.Utils:Tween(self.CloseButton, {TextColor3 = BdevUi.Theme.TextSecondary})
    end)
    table.insert(BdevUi._connections, closeLeaveConnection)
end

function BdevUi.Components.Window:AddTab(Name)
    local tab = BdevUi.Components.Tab.new(self, Name)
    self.Tabs[Name] = tab

    if not self.ActiveTab then
        self:SetActiveTab(Name)
    end

    return tab
end

function BdevUi.Components.Window:SetActiveTab(TabName)
    if self.ActiveTab then
        self.ActiveTab:SetActive(false)
    end

    self.ActiveTab = self.Tabs[TabName]
    if self.ActiveTab then
        self.ActiveTab:SetActive(true)
    end
end

function BdevUi.Components.Window:Minimize()
    self.Minimized = not self.Minimized

    if self.Minimized then
        BdevUi.Utils:Tween(self.MainFrame, {Size = UDim2.new(self.MainFrame.Size.X.Scale, self.MainFrame.Size.X.Offset, 0, 35)})
        BdevUi.Utils:Tween(self.ContentFrame, {Visible = false})
    else
        BdevUi.Utils:Tween(self.MainFrame, {Size = UDim2.new(0, 400, 0, 300)})
        BdevUi.Utils:Tween(self.ContentFrame, {Visible = true})
    end
end

function BdevUi.Components.Window:Destroy()
    self.Closed = true

    -- Clean up connections and tweens
    BdevUi.Utils:CleanConnections()
    BdevUi.Utils:CleanTweens()

    -- Destroy GUI
    if self.ScreenGui then
        pcall(function() self.ScreenGui:Destroy() end)
    end

    -- Remove from windows list
    local index = table.find(BdevUi._windows, self)
    if index then
        table.remove(BdevUi._windows, index)
    end
end

-- Tab Class
BdevUi.Components.Tab = {}
BdevUi.Components.Tab.__index = BdevUi.Components.Tab

function BdevUi.Components.Tab.new(Window, Name)
    local self = setmetatable({}, BdevUi.Components.Tab)

    self.Window = Window
    self.Name = Name
    self.Active = false

    -- Create Tab Button
    self.Button = Instance.new("TextButton")
    self.Button.Name = "TabButton_" .. Name:gsub("%s+", "_")
    self.Button.BackgroundColor3 = BdevUi.Theme.SecondaryBackground
    self.Button.BackgroundTransparency = 1
    self.Button.BorderSizePixel = 0
    self.Button.Size = UDim2.new(0, 80, 1, 0)
    self.Button.Position = UDim2.new(0, (#Window.Tabs * 85), 0, 0)
    self.Button.Font = BdevUi.Theme.Font
    self.Button.Text = Name
    self.Button.TextColor3 = BdevUi.Theme.TextSecondary
    self.Button.TextSize = BdevUi.Theme.TextSize
    self.Button.Parent = Window.TabContainer

    BdevUi.Utils:CreateCorner(self.Button, UDim.new(0, 4))

    -- Create Tab Content Frame
    self.ContentFrame = Instance.new("ScrollingFrame")
    self.ContentFrame.Name = "TabContent_" .. Name:gsub("%s+", "_")
    self.ContentFrame.BackgroundTransparency = 1
    self.ContentFrame.BorderSizePixel = 0
    self.ContentFrame.Size = UDim2.new(1, 0, 1, 0)
    self.ContentFrame.Position = UDim2.new(0, 0, 0, 0)
    self.ContentFrame.ScrollBarThickness = 4
    self.ContentFrame.ScrollBarImageColor3 = BdevUi.Theme.Accent
    self.ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.ContentFrame.Visible = false
    self.ContentFrame.Parent = Window.TabContentContainer

    -- UIListLayout for content
    self.Layout = Instance.new("UIListLayout")
    self.Layout.SortOrder = Enum.SortOrder.LayoutOrder
    self.Layout.Padding = UDim.new(0, 8)
    self.Layout.Parent = self.ContentFrame

    -- Initialize Elements
    self.Elements = {}
    self.LayoutOrder = 0

    -- Connect Events
    self:ConnectEvents()

    return self
end

function BdevUi.Components.Tab:ConnectEvents()
    local clickConnection = self.Button.MouseButton1Click:Connect(function()
        self.Window:SetActiveTab(self.Name)
    end)
    table.insert(BdevUi._connections, clickConnection)

    -- Hover Effects
    local enterConnection = self.Button.MouseEnter:Connect(function()
        if not self.Active then
            BdevUi.Utils:Tween(self.Button, {BackgroundTransparency = 0.8})
        end
    end)
    table.insert(BdevUi._connections, enterConnection)

    local leaveConnection = self.Button.MouseLeave:Connect(function()
        if not self.Active then
            BdevUi.Utils:Tween(self.Button, {BackgroundTransparency = 1})
        end
    end)
    table.insert(BdevUi._connections, leaveConnection)
end

function BdevUi.Components.Tab:SetActive(Active)
    self.Active = Active

    if Active then
        BdevUi.Utils:Tween(self.Button, {
            BackgroundTransparency = 0,
            TextColor3 = BdevUi.Theme.Text
        })
        self.ContentFrame.Visible = true
    else
        BdevUi.Utils:Tween(self.Button, {
            BackgroundTransparency = 1,
            TextColor3 = BdevUi.Theme.TextSecondary
        })
        self.ContentFrame.Visible = false
    end
end

function BdevUi.Components.Tab:AddButton(Text, Callback)
    local button = BdevUi.Components.Button.new(self, Text, Callback)
    table.insert(self.Elements, button)
    self.LayoutOrder = self.LayoutOrder + 1
    button.Frame.LayoutOrder = self.LayoutOrder

    self:UpdateCanvasSize()

    return button
end

function BdevUi.Components.Tab:AddToggle(Text, Default, Callback)
    local toggle = BdevUi.Components.Toggle.new(self, Text, Default, Callback)
    table.insert(self.Elements, toggle)
    self.LayoutOrder = self.LayoutOrder + 1
    toggle.Frame.LayoutOrder = self.LayoutOrder

    self:UpdateCanvasSize()

    return toggle
end

function BdevUi.Components.Tab:AddSlider(Text, Min, Max, Default, Callback)
    local slider = BdevUi.Components.Slider.new(self, Text, Min, Max, Default, Callback)
    table.insert(self.Elements, slider)
    self.LayoutOrder = self.LayoutOrder + 1
    slider.Frame.LayoutOrder = self.LayoutOrder

    self:UpdateCanvasSize()

    return slider
end

function BdevUi.Components.Tab:AddDropdown(Text, Options, Default, Callback)
    local dropdown = BdevUi.Components.Dropdown.new(self, Text, Options, Default, Callback)
    table.insert(self.Elements, dropdown)
    self.LayoutOrder = self.LayoutOrder + 1
    dropdown.Frame.LayoutOrder = self.LayoutOrder

    self:UpdateCanvasSize()

    return dropdown
end

function BdevUi.Components.Tab:AddInput(Text, Placeholder, Callback)
    local input = BdevUi.Components.Input.new(self, Text, Placeholder, Callback)
    table.insert(self.Elements, input)
    self.LayoutOrder = self.LayoutOrder + 1
    input.Frame.LayoutOrder = self.LayoutOrder

    self:UpdateCanvasSize()

    return input
end

function BdevUi.Components.Tab:AddLabel(Text)
    local label = BdevUi.Components.Label.new(self, Text)
    table.insert(self.Elements, label)
    self.LayoutOrder = self.LayoutOrder + 1
    label.Frame.LayoutOrder = self.LayoutOrder

    self:UpdateCanvasSize()

    return label
end

function BdevUi.Components.Tab:UpdateCanvasSize()
    local totalHeight = 0
    for _, element in pairs(self.Elements) do
        if element.Frame and element.Frame.Visible then
            totalHeight = totalHeight + element.Frame.AbsoluteSize.Y + 8
        end
    end

    self.ContentFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

-- Button Component
BdevUi.Components.Button = {}
BdevUi.Components.Button.__index = BdevUi.Components.Button

function BdevUi.Components.Button.new(Tab, Text, Callback)
    local self = setmetatable({}, BdevUi.Components.Button)

    self.Tab = Tab
    self.Text = Text
    self.Callback = Callback or function() end

    -- Create Frame
    self.Frame = Instance.new("Frame")
    self.Frame.Name = "ButtonFrame"
    self.Frame.BackgroundTransparency = 1
    self.Frame.BorderSizePixel = 0
    self.Frame.Size = UDim2.new(1, 0, 0, 35)
    self.Frame.Parent = Tab.ContentFrame

    -- Create Button
    self.Button = Instance.new("TextButton")
    self.Button.Name = "Button"
    self.Button.BackgroundColor3 = BdevUi.Theme.SecondaryBackground
    self.Button.BackgroundTransparency = BdevUi.Theme.BackgroundTransparency
    self.Button.BorderSizePixel = 0
    self.Button.Size = UDim2.new(1, 0, 1, 0)
    self.Button.Position = UDim2.new(0, 0, 0, 0)
    self.Button.Font = BdevUi.Theme.Font
    self.Button.Text = Text
    self.Button.TextColor3 = BdevUi.Theme.Text
    self.Button.TextSize = BdevUi.Theme.TextSize
    self.Button.Parent = self.Frame

    BdevUi.Utils:CreateCorner(self.Button)
    BdevUi.Utils:CreateBorder(self.Button)

    -- Connect Events
    self:ConnectEvents()

    return self
end

function BdevUi.Components.Button:ConnectEvents()
    local clickConnection = self.Button.MouseButton1Click:Connect(function()
        self.Callback()
        BdevUi.Utils:Tween(self.Button, {BackgroundColor3 = BdevUi.Theme.Selected}, BdevUi.Theme.TweenInfoFast)
        wait(0.1)
        BdevUi.Utils:Tween(self.Button, {BackgroundColor3 = BdevUi.Theme.SecondaryBackground}, BdevUi.Theme.TweenInfoFast)
    end)
    table.insert(BdevUi._connections, clickConnection)

    -- Hover Effects
    local enterConnection = self.Button.MouseEnter:Connect(function()
        BdevUi.Utils:Tween(self.Button, {BackgroundColor3 = BdevUi.Theme.Hover})
    end)
    table.insert(BdevUi._connections, enterConnection)

    local leaveConnection = self.Button.MouseLeave:Connect(function()
        BdevUi.Utils:Tween(self.Button, {BackgroundColor3 = BdevUi.Theme.SecondaryBackground})
    end)
    table.insert(BdevUi._connections, leaveConnection)
end

function BdevUi.Components.Button:SetText(Text)
    self.Text = Text
    self.Button.Text = Text
end

function BdevUi.Components.Button:SetCallback(Callback)
    self.Callback = Callback or function() end
end

-- Toggle Component
BdevUi.Components.Toggle = {}
BdevUi.Components.Toggle.__index = BdevUi.Components.Toggle

function BdevUi.Components.Toggle.new(Tab, Text, Default, Callback)
    local self = setmetatable({}, BdevUi.Components.Toggle)

    self.Tab = Tab
    self.Text = Text
    self.Value = Default or false
    self.Callback = Callback or function() end

    -- Create Frame
    self.Frame = Instance.new("Frame")
    self.Frame.Name = "ToggleFrame"
    self.Frame.BackgroundTransparency = 1
    self.Frame.BorderSizePixel = 0
    self.Frame.Size = UDim2.new(1, 0, 0, 35)
    self.Frame.Parent = Tab.ContentFrame

    -- Create Label
    self.Label = Instance.new("TextLabel")
    self.Label.Name = "Label"
    self.Label.BackgroundTransparency = 1
    self.Label.BorderSizePixel = 0
    self.Label.Size = UDim2.new(1, -50, 1, 0)
    self.Label.Position = UDim2.new(0, 0, 0, 0)
    self.Label.Font = BdevUi.Theme.Font
    self.Label.Text = Text
    self.Label.TextColor3 = BdevUi.Theme.Text
    self.Label.TextSize = BdevUi.Theme.TextSize
    self.Label.TextXAlignment = Enum.TextXAlignment.Left
    self.Label.Parent = self.Frame

    -- Create Toggle Button
    self.ToggleButton = Instance.new("Frame")
    self.ToggleButton.Name = "ToggleButton"
    self.ToggleButton.BackgroundColor3 = self.Value and BdevUi.Theme.Success or BdevUi.Theme.Border
    self.ToggleButton.BackgroundTransparency = BdevUi.Theme.BackgroundTransparency
    self.ToggleButton.BorderSizePixel = 0
    self.ToggleButton.Size = UDim2.new(0, 40, 0, 20)
    self.ToggleButton.Position = UDim2.new(1, -45, 0, 7.5)
    self.ToggleButton.Parent = self.Frame

    BdevUi.Utils:CreateCorner(self.ToggleButton, UDim.new(0, 10))
    BdevUi.Utils:CreateBorder(self.ToggleButton)

    -- Create Toggle Knob
    self.ToggleKnob = Instance.new("Frame")
    self.ToggleKnob.Name = "ToggleKnob"
    self.ToggleKnob.BackgroundColor3 = BdevUi.Theme.Text
    self.ToggleKnob.BackgroundTransparency = BdevUi.Theme.BackgroundTransparency
    self.ToggleKnob.BorderSizePixel = 0
    self.ToggleKnob.Size = UDim2.new(0, 16, 0, 16)
    self.ToggleKnob.Position = self.Value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    self.ToggleKnob.Parent = self.ToggleButton

    BdevUi.Utils:CreateCorner(self.ToggleKnob, UDim.new(0, 8))

    -- Connect Events
    self:ConnectEvents()

    return self
end

function BdevUi.Components.Toggle:ConnectEvents()
    local clickConnection = self.ToggleButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self:Toggle()
        end
    end)
    table.insert(BdevUi._connections, clickConnection)
end

function BdevUi.Components.Toggle:Toggle()
    self.Value = not self.Value
    self.Callback(self.Value)

    BdevUi.Utils:Tween(self.ToggleButton, {
        BackgroundColor3 = self.Value and BdevUi.Theme.Success or BdevUi.Theme.Border
    })

    BdevUi.Utils:Tween(self.ToggleKnob, {
        Position = self.Value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    })
end

function BdevUi.Components.Toggle:SetValue(Value)
    if self.Value ~= Value then
        self.Value = Value
        self:Toggle()
    end
end

function BdevUi.Components.Toggle:GetValue()
    return self.Value
end

-- Slider Component
BdevUi.Components.Slider = {}
BdevUi.Components.Slider.__index = BdevUi.Components.Slider

function BdevUi.Components.Slider.new(Tab, Text, Min, Max, Default, Callback)
    local self = setmetatable({}, BdevUi.Components.Slider)

    self.Tab = Tab
    self.Text = Text
    self.Min = Min or 0
    self.Max = Max or 100
    self.Value = Default or self.Min
    self.Callback = Callback or function() end

    -- Create Frame
    self.Frame = Instance.new("Frame")
    self.Frame.Name = "SliderFrame"
    self.Frame.BackgroundTransparency = 1
    self.Frame.BorderSizePixel = 0
    self.Frame.Size = UDim2.new(1, 0, 0, 50)
    self.Frame.Parent = Tab.ContentFrame

    -- Create Label
    self.Label = Instance.new("TextLabel")
    self.Label.Name = "Label"
    self.Label.BackgroundTransparency = 1
    self.Label.BorderSizePixel = 0
    self.Label.Size = UDim2.new(1, 0, 0, 20)
    self.Label.Position = UDim2.new(0, 0, 0, 0)
    self.Label.Font = BdevUi.Theme.Font
    self.Label.Text = Text .. ": " .. tostring(self.Value)
    self.Label.TextColor3 = BdevUi.Theme.Text
    self.Label.TextSize = BdevUi.Theme.TextSize
    self.Label.TextXAlignment = Enum.TextXAlignment.Left
    self.Label.Parent = self.Frame

    -- Create Slider Bar Background
    self.SliderBar = Instance.new("Frame")
    self.SliderBar.Name = "SliderBar"
    self.SliderBar.BackgroundColor3 = BdevUi.Theme.Border
    self.SliderBar.BackgroundTransparency = BdevUi.Theme.BackgroundTransparency
    self.SliderBar.BorderSizePixel = 0
    self.SliderBar.Size = UDim2.new(1, 0, 0, 6)
    self.SliderBar.Position = UDim2.new(0, 0, 0, 25)
    self.SliderBar.Parent = self.Frame

    BdevUi.Utils:CreateCorner(self.SliderBar, UDim.new(0, 3))
    BdevUi.Utils:CreateBorder(self.SliderBar)

    -- Create Slider Fill
    self.SliderFill = Instance.new("Frame")
    self.SliderFill.Name = "SliderFill"
    self.SliderFill.BackgroundColor3 = BdevUi.Theme.Accent
    self.SliderFill.BackgroundTransparency = BdevUi.Theme.BackgroundTransparency
    self.SliderFill.BorderSizePixel = 0
    self.SliderFill.Size = UDim2.new((self.Value - self.Min) / (self.Max - self.Min), 0, 1, 0)
    self.SliderFill.Position = UDim2.new(0, 0, 0, 0)
    self.SliderFill.Parent = self.SliderBar

    BdevUi.Utils:CreateCorner(self.SliderFill, UDim.new(0, 3))

    -- Create Slider Knob
    self.SliderKnob = Instance.new("Frame")
    self.SliderKnob.Name = "SliderKnob"
    self.SliderKnob.BackgroundColor3 = BdevUi.Theme.Text
    self.SliderKnob.BackgroundTransparency = BdevUi.Theme.BackgroundTransparency
    self.SliderKnob.BorderSizePixel = 0
    self.SliderKnob.Size = UDim2.new(0, 12, 0, 12)
    self.SliderKnob.Position = UDim2.new(self.SliderFill.Size.X.Scale, -6, 0.5, -6)
    self.SliderKnob.Parent = self.SliderBar

    BdevUi.Utils:CreateCorner(self.SliderKnob, UDim.new(0, 6))
    BdevUi.Utils:CreateBorder(self.SliderKnob)

    -- Connect Events
    self:ConnectEvents()

    return self
end

function BdevUi.Components.Slider:ConnectEvents()
    local dragging = false

    local function updateSlider(input)
        local relativeX = math.clamp((input.Position.X - self.SliderBar.AbsolutePosition.X) / self.SliderBar.AbsoluteSize.X, 0, 1)
        self.Value = math.floor(self.Min + (self.Max - self.Min) * relativeX + 0.5)
        self:UpdateVisuals()
        self.Callback(self.Value)
    end

    local inputBeganConnection = self.SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateSlider(input)
        end
    end)
    table.insert(BdevUi._connections, inputBeganConnection)

    local inputEndedConnection = self.SliderBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    table.insert(BdevUi._connections, inputEndedConnection)

    if UserInputService then
        local moveConnection = UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input)
            end
        end)
        table.insert(BdevUi._connections, moveConnection)
    end
end

function BdevUi.Components.Slider:UpdateVisuals()
    local ratio = (self.Value - self.Min) / (self.Max - self.Min)

    BdevUi.Utils:Tween(self.SliderFill, {Size = UDim2.new(ratio, 0, 1, 0)})
    BdevUi.Utils:Tween(self.SliderKnob, {Position = UDim2.new(ratio, -6, 0.5, -6)})

    self.Label.Text = self.Text .. ": " .. tostring(self.Value)
end

function BdevUi.Components.Slider:SetValue(Value)
    self.Value = math.clamp(Value, self.Min, self.Max)
    self:UpdateVisuals()
    self.Callback(self.Value)
end

function BdevUi.Components.Slider:GetValue()
    return self.Value
end

-- Dropdown Component
BdevUi.Components.Dropdown = {}
BdevUi.Components.Dropdown.__index = BdevUi.Components.Dropdown

function BdevUi.Components.Dropdown.new(Tab, Text, Options, Default, Callback)
    local self = setmetatable({}, BdevUi.Components.Dropdown)

    self.Tab = Tab
    self.Text = Text
    self.Options = Options or {}
    self.Value = Default or (self.Options[1] or "")
    self.Callback = Callback or function() end
    self.Open = false

    -- Create Frame
    self.Frame = Instance.new("Frame")
    self.Frame.Name = "DropdownFrame"
    self.Frame.BackgroundTransparency = 1
    self.Frame.BorderSizePixel = 0
    self.Frame.Size = UDim2.new(1, 0, 0, 35)
    self.Frame.Parent = Tab.ContentFrame

    -- Create Label
    self.Label = Instance.new("TextLabel")
    self.Label.Name = "Label"
    self.Label.BackgroundTransparency = 1
    self.Label.BorderSizePixel = 0
    self.Label.Size = UDim2.new(1, -50, 1, 0)
    self.Label.Position = UDim2.new(0, 0, 0, 0)
    self.Label.Font = BdevUi.Theme.Font
    self.Label.Text = Text
    self.Label.TextColor3 = BdevUi.Theme.Text
    self.Label.TextSize = BdevUi.Theme.TextSize
    self.Label.TextXAlignment = Enum.TextXAlignment.Left
    self.Label.Parent = self.Frame

    -- Create Dropdown Button
    self.DropdownButton = Instance.new("Frame")
    self.DropdownButton.Name = "DropdownButton"
    self.DropdownButton.BackgroundColor3 = BdevUi.Theme.SecondaryBackground
    self.DropdownButton.BackgroundTransparency = BdevUi.Theme.BackgroundTransparency
    self.DropdownButton.BorderSizePixel = 0
    self.DropdownButton.Size = UDim2.new(0, 120, 1, 0)
    self.DropdownButton.Position = UDim2.new(1, -125, 0, 0)
    self.DropdownButton.Parent = self.Frame

    BdevUi.Utils:CreateCorner(self.DropdownButton)
    BdevUi.Utils:CreateBorder(self.DropdownButton)

    -- Selected Text
    self.SelectedText = Instance.new("TextLabel")
    self.SelectedText.Name = "SelectedText"
    self.SelectedText.BackgroundTransparency = 1
    self.SelectedText.BorderSizePixel = 0
    self.SelectedText.Size = UDim2.new(1, -20, 1, 0)
    self.SelectedText.Position = UDim2.new(0, 5, 0, 0)
    self.SelectedText.Font = BdevUi.Theme.Font
    self.SelectedText.Text = self.Value
    self.SelectedText.TextColor3 = BdevUi.Theme.Text
    self.SelectedText.TextSize = BdevUi.Theme.TextSize
    self.SelectedText.TextXAlignment = Enum.TextXAlignment.Left
    self.SelectedText.Parent = self.DropdownButton

    -- Arrow
    self.Arrow = Instance.new("TextLabel")
    self.Arrow.Name = "Arrow"
    self.Arrow.BackgroundTransparency = 1
    self.Arrow.BorderSizePixel = 0
    self.Arrow.Size = UDim2.new(0, 15, 1, 0)
    self.Arrow.Position = UDim2.new(1, -18, 0, 0)
    self.Arrow.Font = Enum.Font.SourceSansBold
    self.Arrow.Text = "▼"
    self.Arrow.TextColor3 = BdevUi.Theme.TextSecondary
    self.Arrow.TextSize = 12
    self.Arrow.Parent = self.DropdownButton

    -- Options Frame
    self.OptionsFrame = Instance.new("Frame")
    self.OptionsFrame.Name = "OptionsFrame"
    self.OptionsFrame.BackgroundColor3 = BdevUi.Theme.SecondaryBackground
    self.OptionsFrame.BackgroundTransparency = BdevUi.Theme.BackgroundTransparency
    self.OptionsFrame.BorderSizePixel = 0
    self.OptionsFrame.Size = UDim2.new(0, 120, 0, 0)
    self.OptionsFrame.Position = UDim2.new(0, 0, 1, 5)
    self.OptionsFrame.Visible = false
    self.OptionsFrame.ZIndex = 10
    self.OptionsFrame.Parent = self.DropdownButton

    BdevUi.Utils:CreateCorner(self.OptionsFrame)
    BdevUi.Utils:CreateBorder(self.OptionsFrame)

    -- Create Options
    self.OptionButtons = {}
    for i, option in pairs(self.Options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Name = "Option_" .. tostring(i)
        optionButton.BackgroundTransparency = 1
        optionButton.BorderSizePixel = 0
        optionButton.Size = UDim2.new(1, 0, 0, 25)
        optionButton.Position = UDim2.new(0, 0, 0, (i-1) * 25)
        optionButton.Font = BdevUi.Theme.Font
        optionButton.Text = option
        optionButton.TextColor3 = BdevUi.Theme.Text
        optionButton.TextSize = BdevUi.Theme.TextSize
        optionButton.ZIndex = 11
        optionButton.Parent = self.OptionsFrame

        local clickConnection = optionButton.MouseButton1Click:Connect(function()
            self:SetValue(option)
            self:ToggleDropdown()
        end)
        table.insert(BdevUi._connections, clickConnection)

        self.OptionButtons[option] = optionButton
    end

    -- Update Options Frame Size
    self.OptionsFrame.Size = UDim2.new(0, 120, 0, #self.Options * 25)

    -- Connect Events
    self:ConnectEvents()

    return self
end

function BdevUi.Components.Dropdown:ConnectEvents()
    local clickConnection = self.DropdownButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self:ToggleDropdown()
        end
    end)
    table.insert(BdevUi._connections, clickConnection)
end

function BdevUi.Components.Dropdown:ToggleDropdown()
    self.Open = not self.Open

    if self.Open then
        self.OptionsFrame.Visible = true
        BdevUi.Utils:Tween(self.OptionsFrame, {Size = UDim2.new(0, 120, 0, #self.Options * 25)})
        BdevUi.Utils:Tween(self.Arrow, {Rotation = 180})
    else
        BdevUi.Utils:Tween(self.OptionsFrame, {Size = UDim2.new(0, 120, 0, 0)}, function()
            self.OptionsFrame.Visible = false
        end)
        BdevUi.Utils:Tween(self.Arrow, {Rotation = 0})
    end
end

function BdevUi.Components.Dropdown:SetValue(Value)
    if table.find(self.Options, Value) then
        self.Value = Value
        self.SelectedText.Text = Value
        self.Callback(Value)
    end
end

function BdevUi.Components.Dropdown:GetValue()
    return self.Value
end

-- Input Component
BdevUi.Components.Input = {}
BdevUi.Components.Input.__index = BdevUi.Components.Input

function BdevUi.Components.Input.new(Tab, Text, Placeholder, Callback)
    local self = setmetatable({}, BdevUi.Components.Input)

    self.Tab = Tab
    self.Text = Text
    self.Value = ""
    self.Callback = Callback or function() end

    -- Create Frame
    self.Frame = Instance.new("Frame")
    self.Frame.Name = "InputFrame"
    self.Frame.BackgroundTransparency = 1
    self.Frame.BorderSizePixel = 0
    self.Frame.Size = UDim2.new(1, 0, 0, 55)
    self.Frame.Parent = Tab.ContentFrame

    -- Create Label
    self.Label = Instance.new("TextLabel")
    self.Label.Name = "Label"
    self.Label.BackgroundTransparency = 1
    self.Label.BorderSizePixel = 0
    self.Label.Size = UDim2.new(1, 0, 0, 20)
    self.Label.Position = UDim2.new(0, 0, 0, 0)
    self.Label.Font = BdevUi.Theme.Font
    self.Label.Text = Text
    self.Label.TextColor3 = BdevUi.Theme.Text
    self.Label.TextSize = BdevUi.Theme.TextSize
    self.Label.TextXAlignment = Enum.TextXAlignment.Left
    self.Label.Parent = self.Frame

    -- Create TextBox
    self.TextBox = Instance.new("TextBox")
    self.TextBox.Name = "TextBox"
    self.TextBox.BackgroundColor3 = BdevUi.Theme.SecondaryBackground
    self.TextBox.BackgroundTransparency = BdevUi.Theme.BackgroundTransparency
    self.TextBox.BorderSizePixel = 0
    self.TextBox.Size = UDim2.new(1, 0, 0, 25)
    self.TextBox.Position = UDim2.new(0, 0, 0, 25)
    self.TextBox.Font = BdevUi.Theme.Font
    self.TextBox.PlaceholderText = Placeholder or "Enter text..."
    self.TextBox.PlaceholderColor3 = BdevUi.Theme.TextTertiary
    self.TextBox.Text = ""
    self.TextBox.TextColor3 = BdevUi.Theme.Text
    self.TextBox.TextSize = BdevUi.Theme.TextSize
    self.TextBox.ClearTextOnFocus = false
    self.TextBox.Parent = self.Frame

    BdevUi.Utils:CreateCorner(self.TextBox)
    BdevUi.Utils:CreateBorder(self.TextBox)

    -- Connect Events
    self:ConnectEvents()

    return self
end

function BdevUi.Components.Input:ConnectEvents()
    local focusLostConnection = self.TextBox.FocusLost:Connect(function(enterPressed)
        self.Value = self.TextBox.Text
        self.Callback(self.Value, enterPressed)
    end)
    table.insert(BdevUi._connections, focusLostConnection)

    -- Focus Effects
    local focusedConnection = self.TextBox.Focused:Connect(function()
        BdevUi.Utils:Tween(self.TextBox, {BackgroundColor3 = BdevUi.Theme.Hover})
    end)
    table.insert(BdevUi._connections, focusedConnection)

    local focusLostVisualConnection = self.TextBox.FocusLost:Connect(function()
        BdevUi.Utils:Tween(self.TextBox, {BackgroundColor3 = BdevUi.Theme.SecondaryBackground})
    end)
    table.insert(BdevUi._connections, focusLostVisualConnection)
end

function BdevUi.Components.Input:SetValue(Value)
    self.Value = Value or ""
    self.TextBox.Text = self.Value
end

function BdevUi.Components.Input:GetValue()
    return self.Value
end

-- Label Component
BdevUi.Components.Label = {}
BdevUi.Components.Label.__index = BdevUi.Components.Label

function BdevUi.Components.Label.new(Tab, Text)
    local self = setmetatable({}, BdevUi.Components.Label)

    self.Tab = Tab
    self.Text = Text

    -- Create Frame
    self.Frame = Instance.new("Frame")
    self.Frame.Name = "LabelFrame"
    self.Frame.BackgroundTransparency = 1
    self.Frame.BorderSizePixel = 0
    self.Frame.Size = UDim2.new(1, 0, 0, 25)
    self.Frame.Parent = Tab.ContentFrame

    -- Create Label
    self.Label = Instance.new("TextLabel")
    self.Label.Name = "Label"
    self.Label.BackgroundTransparency = 1
    self.Label.BorderSizePixel = 0
    self.Label.Size = UDim2.new(1, 0, 1, 0)
    self.Label.Position = UDim2.new(0, 0, 0, 0)
    self.Label.Font = BdevUi.Theme.Font
    self.Label.Text = Text
    self.Label.TextColor3 = BdevUi.Theme.Text
    self.Label.TextSize = BdevUi.Theme.TextSize
    self.Label.TextXAlignment = Enum.TextXAlignment.Left
    self.Label.Parent = self.Frame

    return self
end

function BdevUi.Components.Label:SetText(Text)
    self.Text = Text
    self.Label.Text = Text
end

-- Notification System
BdevUi.Notification = {}

function BdevUi.Notification.new(Title, Text, Duration)
    local notification = {}

    notification.Title = Title or "Notification"
    notification.Text = Text or ""
    notification.Duration = Duration or 3

    -- Create ScreenGui for notifications
    if not BdevUi._notificationGui then
        BdevUi._notificationGui = Instance.new("ScreenGui")
        BdevUi._notificationGui.Name = "BdevUiNotifications"
        BdevUi._notificationGui.ResetOnSpawn = false
        BdevUi._notificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        local success, error = pcall(function()
            BdevUi._notificationGui.Parent = CoreGui
        end)

        if not success then
            if Players and Players.LocalPlayer then
                local success2, error2 = pcall(function()
                    BdevUi._notificationGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
                end)
                if not success2 then
                    warn("BdevUi: Could not create notification GUI")
                    return nil
                end
            else
                warn("BdevUi: No suitable parent for notifications")
                return nil
            end
        end
    end

    -- Create notification frame
    notification.Frame = Instance.new("Frame")
    notification.Frame.Name = "Notification"
    notification.Frame.BackgroundColor3 = BdevUi.Theme.Background
    notification.Frame.BackgroundTransparency = BdevUi.Theme.BackgroundTransparency
    notification.Frame.BorderSizePixel = 0
    notification.Frame.Size = UDim2.new(0, 300, 0, 80)
    notification.Frame.Position = UDim2.new(1, 310, 1, -90 - (#BdevUi._notifications or 0) * 90)
    notification.Frame.ZIndex = 100
    notification.Frame.Parent = BdevUi._notificationGui

    BdevUi.Utils:CreateCorner(notification.Frame)
    BdevUi.Utils:CreateBorder(notification.Frame)
    BdevUi.Utils:CreateShadow(notification.Frame)

    -- Title Label
    notification.TitleLabel = Instance.new("TextLabel")
    notification.TitleLabel.Name = "Title"
    notification.TitleLabel.BackgroundTransparency = 1
    notification.TitleLabel.BorderSizePixel = 0
    notification.TitleLabel.Size = UDim2.new(1, -20, 0, 25)
    notification.TitleLabel.Position = UDim2.new(0, 10, 0, 5)
    notification.TitleLabel.Font = BdevUi.Theme.Font
    notification.TitleLabel.Text = notification.Title
    notification.TitleLabel.TextColor3 = BdevUi.Theme.Text
    notification.TitleLabel.TextSize = 16
    notification.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    notification.TitleLabel.Parent = notification.Frame

    -- Text Label
    notification.TextLabel = Instance.new("TextLabel")
    notification.TextLabel.Name = "Text"
    notification.TextLabel.BackgroundTransparency = 1
    notification.TextLabel.BorderSizePixel = 0
    notification.TextLabel.Size = UDim2.new(1, -20, 0, 40)
    notification.TextLabel.Position = UDim2.new(0, 10, 0, 30)
    notification.TextLabel.Font = BdevUi.Theme.Font
    notification.TextLabel.Text = notification.Text
    notification.TextLabel.TextColor3 = BdevUi.Theme.TextSecondary
    notification.TextLabel.TextSize = 14
    notification.TextLabel.TextWrapped = true
    notification.TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    notification.TextLabel.TextYAlignment = Enum.TextYAlignment.Top
    notification.TextLabel.Parent = notification.Frame

    -- Animate in
    BdevUi.Utils:Tween(notification.Frame, {Position = UDim2.new(1, -310, 1, -90 - (#BdevUi._notifications or 0) * 90)})

    -- Store notification
    BdevUi._notifications = BdevUi._notifications or {}
    table.insert(BdevUi._notifications, notification)

    -- Auto remove after duration
    spawn(function()
        wait(notification.Duration)
        notification:Destroy()
    end)

    function notification:Destroy()
        BdevUi.Utils:Tween(notification.Frame, {Position = UDim2.new(1, 310, notification.Frame.Position.Y)}, function()
            pcall(function() notification.Frame:Destroy() end)

            -- Remove from list
            local index = table.find(BdevUi._notifications, notification)
            if index then
                table.remove(BdevUi._notifications, index)
            end

            -- Shift remaining notifications up
            for i, notif in pairs(BdevUi._notifications) do
                BdevUi.Utils:Tween(notif.Frame, {Position = UDim2.new(1, -310, 1, -90 - (i-1) * 90)})
            end
        end)
    end

    return notification
end

-- Main Library Functions
function BdevUi:CreateWindow(Title, Size, Position)
    return BdevUi.Components.Window.new(Title, Size, Position)
end

function BdevUi:Notify(Title, Text, Duration)
    return BdevUi.Notification.new(Title, Text, Duration)
end

function BdevUi:Destroy()
    -- Clean up all windows
    for _, window in pairs(BdevUi._windows) do
        window:Destroy()
    end

    -- Clean up notification gui
    if BdevUi._notificationGui then
        pcall(function() BdevUi._notificationGui:Destroy() end)
        BdevUi._notificationGui = nil
    end

    -- Clean up connections and tweens
    BdevUi.Utils:CleanConnections()
    BdevUi.Utils:CleanTweens()

    BdevUi._windows = {}
    BdevUi._notifications = {}
end

return BdevUi