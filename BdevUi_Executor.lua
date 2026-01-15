-- BdevUi - Executor Loadstring Version
-- Copy and execute this entire script with loadstring

local BdevUi = (function()
    local library = {}

    -- Services with executor compatibility
    local TweenService, UserInputService, RunService, Players, CoreGui
    pcall(function() TweenService = game:GetService("TweenService") end)
    pcall(function() UserInputService = game:GetService("UserInputService") end)
    pcall(function() RunService = game:GetService("RunService") end)
    pcall(function() Players = game:GetService("Players") end)
    pcall(function() CoreGui = game:GetService("CoreGui") end)

    -- Configuration
    library.Version = "1.0.0"
    library.Author = "Bdev Team"

    -- Theme (Black, White, Gray)
    library.Theme = {
        Primary = Color3.fromRGB(0, 0, 0),
        Secondary = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(64, 64, 64),
        Background = Color3.fromRGB(15, 15, 15),
        SecondaryBackground = Color3.fromRGB(25, 25, 25),
        TertiaryBackground = Color3.fromRGB(35, 35, 35),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(200, 200, 200),
        TextTertiary = Color3.fromRGB(150, 150, 150),
        Border = Color3.fromRGB(45, 45, 45),
        BorderLight = Color3.fromRGB(75, 75, 75),
        Hover = Color3.fromRGB(55, 55, 55),
        Selected = Color3.fromRGB(85, 85, 85),
        Disabled = Color3.fromRGB(40, 40, 40),
        Success = Color3.fromRGB(100, 255, 100),
        Warning = Color3.fromRGB(255, 255, 100),
        Error = Color3.fromRGB(255, 100, 100),
        Font = Enum.Font.SourceSansSemibold,
        TextSize = 14,
        TweenInfo = TweenService and TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out) or nil,
        TweenInfoFast = TweenService and TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out) or nil,
        TweenInfoSlow = TweenService and TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out) or nil,
        CornerRadius = UDim.new(0, 6),
        ShadowEnabled = true,
        ShadowColor = Color3.fromRGB(0, 0, 0),
        ShadowTransparency = 0.5,
        ShadowOffset = UDim2.new(0, 2, 0, 2)
    }

    -- Internal variables
    library._windows = {}
    library._connections = {}
    library._tweens = {}

    -- Utility Functions
    library.Utils = {}

    function library.Utils:Tween(Object, Properties, Info)
        if not TweenService then return end
        local tween = TweenService:Create(Object, Info or self.Theme.TweenInfo, Properties)
        table.insert(self._tweens, tween)
        tween:Play()
        tween.Completed:Connect(function()
            local i = table.find(self._tweens, tween)
            if i then table.remove(self._tweens, i) end
        end)
        return tween
    end

    function library.Utils:CreateShadow(Parent)
        if not self.Theme.ShadowEnabled then return end
        local s = Instance.new("Frame")
        s.Name = "Shadow"
        s.BackgroundColor3 = self.Theme.ShadowColor
        s.BackgroundTransparency = self.Theme.ShadowTransparency
        s.BorderSizePixel = 0
        s.Size = UDim2.new(1, 4, 1, 4)
        s.Position = self.Theme.ShadowOffset
        s.ZIndex = Parent.ZIndex - 1
        s.Parent = Parent
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 8)
        c.Parent = s
        return s
    end

    function library.Utils:CreateBorder(Parent)
        local b = Instance.new("UIStroke")
        b.Name = "Border"
        b.Color = self.Theme.Border
        b.Thickness = 1
        b.Parent = Parent
        return b
    end

    function library.Utils:CreateCorner(Parent, Radius)
        local c = Instance.new("UICorner")
        c.CornerRadius = Radius or self.Theme.CornerRadius
        c.Parent = Parent
        return c
    end

    -- Component Classes
    library.Components = {}

    -- Window Class
    library.Components.Window = {}
    library.Components.Window.__index = library.Components.Window

    function library.Components.Window.new(Title, Size, Position)
        local self = setmetatable({}, library.Components.Window)

        -- ScreenGui
        self.ScreenGui = Instance.new("ScreenGui")
        self.ScreenGui.Name = "BdevUi_" .. (Title or "Window"):gsub("%s+", "_")
        self.ScreenGui.ResetOnSpawn = false
        self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        -- Parent to CoreGui or PlayerGui
        local success = pcall(function() self.ScreenGui.Parent = CoreGui end)
        if not success and Players and Players.LocalPlayer then
            pcall(function() self.ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end)
        end

        -- Main Frame
        self.MainFrame = Instance.new("Frame")
        self.MainFrame.BackgroundColor3 = library.Theme.Background
        self.MainFrame.BorderSizePixel = 0
        self.MainFrame.Size = Size or UDim2.new(0, 400, 0, 300)
        self.MainFrame.Position = Position or UDim2.new(0.5, -200, 0.5, -150)
        self.MainFrame.Active = true
        self.MainFrame.Draggable = true
        self.MainFrame.Parent = self.ScreenGui

        library.Utils:CreateCorner(self.MainFrame)
        library.Utils:CreateBorder(self.MainFrame)
        library.Utils:CreateShadow(self.MainFrame)

        -- Title Bar
        self.TitleBar = Instance.new("Frame")
        self.TitleBar.BackgroundColor3 = library.Theme.SecondaryBackground
        self.TitleBar.BorderSizePixel = 0
        self.TitleBar.Size = UDim2.new(1, 0, 0, 35)
        self.TitleBar.Parent = self.MainFrame
        library.Utils:CreateCorner(self.TitleBar, UDim.new(0, 6))

        -- Title Text
        self.TitleText = Instance.new("TextLabel")
        self.TitleText.BackgroundTransparency = 1
        self.TitleText.Size = UDim2.new(1, -70, 1, 0)
        self.TitleText.Position = UDim2.new(0, 15, 0, 0)
        self.TitleText.Font = library.Theme.Font
        self.TitleText.Text = Title or "Bdev UI"
        self.TitleText.TextColor3 = library.Theme.Text
        self.TitleText.TextSize = 16
        self.TitleText.TextXAlignment = Enum.TextXAlignment.Left
        self.TitleText.Parent = self.TitleBar

        -- Close Button
        self.CloseButton = Instance.new("TextButton")
        self.CloseButton.BackgroundTransparency = 1
        self.CloseButton.Size = UDim2.new(0, 30, 0, 30)
        self.CloseButton.Position = UDim2.new(1, -35, 0, 2.5)
        self.CloseButton.Font = Enum.Font.SourceSansBold
        self.CloseButton.Text = "×"
        self.CloseButton.TextColor3 = library.Theme.TextSecondary
        self.CloseButton.TextSize = 20
        self.CloseButton.Parent = self.TitleBar

        -- Content
        self.ContentFrame = Instance.new("Frame")
        self.ContentFrame.BackgroundTransparency = 1
        self.ContentFrame.Size = UDim2.new(1, -20, 1, -55)
        self.ContentFrame.Position = UDim2.new(0, 10, 0, 45)
        self.ContentFrame.Parent = self.MainFrame

        self.TabContainer = Instance.new("Frame")
        self.TabContainer.BackgroundTransparency = 1
        self.TabContainer.Size = UDim2.new(1, 0, 0, 30)
        self.TabContainer.Parent = self.ContentFrame

        self.TabContentContainer = Instance.new("Frame")
        self.TabContentContainer.BackgroundTransparency = 1
        self.TabContentContainer.Size = UDim2.new(1, 0, 1, -40)
        self.TabContentContainer.Position = UDim2.new(0, 0, 0, 40)
        self.TabContentContainer.Parent = self.ContentFrame

        -- Initialize
        self.Tabs = {}
        self.ActiveTab = nil
        self.Closed = false

        -- Events
        self.CloseButton.MouseButton1Click:Connect(function() self:Destroy() end)
        self.CloseButton.MouseEnter:Connect(function()
            library.Utils:Tween(self.CloseButton, {TextColor3 = library.Theme.Error})
        end)
        self.CloseButton.MouseLeave:Connect(function()
            library.Utils:Tween(self.CloseButton, {TextColor3 = library.Theme.TextSecondary})
        end)

        table.insert(library._windows, self)
        return self
    end

    function library.Components.Window:AddTab(Name)
        local tab = library.Components.Tab.new(self, Name)
        self.Tabs[Name] = tab
        if not self.ActiveTab then self:SetActiveTab(Name) end
        return tab
    end

    function library.Components.Window:SetActiveTab(TabName)
        if self.ActiveTab then self.ActiveTab:SetActive(false) end
        self.ActiveTab = self.Tabs[TabName]
        if self.ActiveTab then self.ActiveTab:SetActive(true) end
    end

    function library.Components.Window:Destroy()
        self.Closed = true
        if self.ScreenGui then pcall(function() self.ScreenGui:Destroy() end) end
        local i = table.find(library._windows, self)
        if i then table.remove(library._windows, i) end
    end

    -- Tab Class
    library.Components.Tab = {}
    library.Components.Tab.__index = library.Components.Tab

    function library.Components.Tab.new(Window, Name)
        local self = setmetatable({}, library.Components.Tab)
        self.Window = Window
        self.Name = Name
        self.Active = false

        -- Tab Button
        self.Button = Instance.new("TextButton")
        self.Button.BackgroundTransparency = 1
        self.Button.Size = UDim2.new(0, 80, 1, 0)
        self.Button.Position = UDim2.new(0, (#Window.Tabs * 85), 0, 0)
        self.Button.Font = library.Theme.Font
        self.Button.Text = Name
        self.Button.TextColor3 = library.Theme.TextSecondary
        self.Button.TextSize = library.Theme.TextSize
        self.Button.Parent = Window.TabContainer
        library.Utils:CreateCorner(self.Button, UDim.new(0, 4))

        -- Tab Content
        self.ContentFrame = Instance.new("ScrollingFrame")
        self.ContentFrame.BackgroundTransparency = 1
        self.ContentFrame.Size = UDim2.new(1, 0, 1, 0)
        self.ContentFrame.ScrollBarThickness = 4
        self.ContentFrame.ScrollBarImageColor3 = library.Theme.Accent
        self.ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        self.ContentFrame.Visible = false
        self.ContentFrame.Parent = Window.TabContentContainer

        self.Layout = Instance.new("UIListLayout")
        self.Layout.SortOrder = Enum.SortOrder.LayoutOrder
        self.Layout.Padding = UDim.new(0, 8)
        self.Layout.Parent = self.ContentFrame

        self.Elements = {}
        self.LayoutOrder = 0

        -- Events
        self.Button.MouseButton1Click:Connect(function() self.Window:SetActiveTab(self.Name) end)
        self.Button.MouseEnter:Connect(function()
            if not self.Active then library.Utils:Tween(self.Button, {BackgroundTransparency = 0.8}) end
        end)
        self.Button.MouseLeave:Connect(function()
            if not self.Active then library.Utils:Tween(self.Button, {BackgroundTransparency = 1}) end
        end)

        return self
    end

    function library.Components.Tab:SetActive(Active)
        self.Active = Active
        if Active then
            library.Utils:Tween(self.Button, {BackgroundTransparency = 0, TextColor3 = library.Theme.Text})
            self.ContentFrame.Visible = true
        else
            library.Utils:Tween(self.Button, {BackgroundTransparency = 1, TextColor3 = library.Theme.TextSecondary})
            self.ContentFrame.Visible = false
        end
    end

    function library.Components.Tab:AddButton(Text, Callback)
        local button = library.Components.Button.new(self, Text, Callback)
        table.insert(self.Elements, button)
        self.LayoutOrder = self.LayoutOrder + 1
        button.Frame.LayoutOrder = self.LayoutOrder
        self:UpdateCanvasSize()
        return button
    end

    function library.Components.Tab:AddToggle(Text, Default, Callback)
        local toggle = library.Components.Toggle.new(self, Text, Default, Callback)
        table.insert(self.Elements, toggle)
        self.LayoutOrder = self.LayoutOrder + 1
        toggle.Frame.LayoutOrder = self.LayoutOrder
        self:UpdateCanvasSize()
        return toggle
    end

    function library.Components.Tab:AddSlider(Text, Min, Max, Default, Callback)
        local slider = library.Components.Slider.new(self, Text, Min, Max, Default, Callback)
        table.insert(self.Elements, slider)
        self.LayoutOrder = self.LayoutOrder + 1
        slider.Frame.LayoutOrder = self.LayoutOrder
        self:UpdateCanvasSize()
        return slider
    end

    function library.Components.Tab:AddDropdown(Text, Options, Default, Callback)
        local dropdown = library.Components.Dropdown.new(self, Text, Options, Default, Callback)
        table.insert(self.Elements, dropdown)
        self.LayoutOrder = self.LayoutOrder + 1
        dropdown.Frame.LayoutOrder = self.LayoutOrder
        self:UpdateCanvasSize()
        return dropdown
    end

    function library.Components.Tab:AddInput(Text, Placeholder, Callback)
        local input = library.Components.Input.new(self, Text, Placeholder, Callback)
        table.insert(self.Elements, input)
        self.LayoutOrder = self.LayoutOrder + 1
        input.Frame.LayoutOrder = self.LayoutOrder
        self:UpdateCanvasSize()
        return input
    end

    function library.Components.Tab:AddLabel(Text)
        local label = library.Components.Label.new(self, Text)
        table.insert(self.Elements, label)
        self.LayoutOrder = self.LayoutOrder + 1
        label.Frame.LayoutOrder = self.LayoutOrder
        self:UpdateCanvasSize()
        return label
    end

    function library.Components.Tab:UpdateCanvasSize()
        local h = 0
        for _, e in pairs(self.Elements) do
            if e.Frame and e.Frame.Visible then
                h = h + e.Frame.AbsoluteSize.Y + 8
            end
        end
        self.ContentFrame.CanvasSize = UDim2.new(0, 0, 0, h)
    end

    -- Button Component
    library.Components.Button = {}
    library.Components.Button.__index = library.Components.Button

    function library.Components.Button.new(Tab, Text, Callback)
        local self = setmetatable({}, library.Components.Button)
        self.Tab = Tab
        self.Text = Text
        self.Callback = Callback or function() end

        self.Frame = Instance.new("Frame")
        self.Frame.BackgroundTransparency = 1
        self.Frame.Size = UDim2.new(1, 0, 0, 35)
        self.Frame.Parent = Tab.ContentFrame

        self.Button = Instance.new("TextButton")
        self.Button.BackgroundColor3 = library.Theme.SecondaryBackground
        self.Button.Size = UDim2.new(1, 0, 1, 0)
        self.Button.Font = library.Theme.Font
        self.Button.Text = Text
        self.Button.TextColor3 = library.Theme.Text
        self.Button.TextSize = library.Theme.TextSize
        self.Button.Parent = self.Frame

        library.Utils:CreateCorner(self.Button)
        library.Utils:CreateBorder(self.Button)

        -- Events
        self.Button.MouseButton1Click:Connect(function()
            self.Callback()
            library.Utils:Tween(self.Button, {BackgroundColor3 = library.Theme.Selected}, library.Theme.TweenInfoFast)
            spawn(function() wait(0.1) library.Utils:Tween(self.Button, {BackgroundColor3 = library.Theme.SecondaryBackground}, library.Theme.TweenInfoFast) end)
        end)

        self.Button.MouseEnter:Connect(function()
            library.Utils:Tween(self.Button, {BackgroundColor3 = library.Theme.Hover})
        end)

        self.Button.MouseLeave:Connect(function()
            library.Utils:Tween(self.Button, {BackgroundColor3 = library.Theme.SecondaryBackground})
        end)

        return self
    end

    -- Toggle Component
    library.Components.Toggle = {}
    library.Components.Toggle.__index = library.Components.Toggle

    function library.Components.Toggle.new(Tab, Text, Default, Callback)
        local self = setmetatable({}, library.Components.Toggle)
        self.Tab = Tab
        self.Text = Text
        self.Value = Default or false
        self.Callback = Callback or function() end

        self.Frame = Instance.new("Frame")
        self.Frame.BackgroundTransparency = 1
        self.Frame.Size = UDim2.new(1, 0, 0, 35)
        self.Frame.Parent = Tab.ContentFrame

        self.Label = Instance.new("TextLabel")
        self.Label.BackgroundTransparency = 1
        self.Label.Size = UDim2.new(1, -50, 1, 0)
        self.Label.Font = library.Theme.Font
        self.Label.Text = Text
        self.Label.TextColor3 = library.Theme.Text
        self.Label.TextSize = library.Theme.TextSize
        self.Label.TextXAlignment = Enum.TextXAlignment.Left
        self.Label.Parent = self.Frame

        self.ToggleButton = Instance.new("Frame")
        self.ToggleButton.BackgroundColor3 = self.Value and library.Theme.Success or library.Theme.Border
        self.ToggleButton.Size = UDim2.new(0, 40, 0, 20)
        self.ToggleButton.Position = UDim2.new(1, -45, 0, 7.5)
        self.ToggleButton.Parent = self.Frame
        library.Utils:CreateCorner(self.ToggleButton, UDim.new(0, 10))
        library.Utils:CreateBorder(self.ToggleButton)

        self.ToggleKnob = Instance.new("Frame")
        self.ToggleKnob.BackgroundColor3 = library.Theme.Text
        self.ToggleKnob.Size = UDim2.new(0, 16, 0, 16)
        self.ToggleKnob.Position = self.Value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        self.ToggleKnob.Parent = self.ToggleButton
        library.Utils:CreateCorner(self.ToggleKnob, UDim.new(0, 8))

        -- Events
        self.ToggleButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                self:Toggle()
            end
        end)

        return self
    end

    function library.Components.Toggle:Toggle()
        self.Value = not self.Value
        self.Callback(self.Value)
        library.Utils:Tween(self.ToggleButton, {BackgroundColor3 = self.Value and library.Theme.Success or library.Theme.Border})
        library.Utils:Tween(self.ToggleKnob, {
            Position = self.Value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        })
    end

    -- Slider Component
    library.Components.Slider = {}
    library.Components.Slider.__index = library.Components.Slider

    function library.Components.Slider.new(Tab, Text, Min, Max, Default, Callback)
        local self = setmetatable({}, library.Components.Slider)
        self.Tab = Tab
        self.Text = Text
        self.Min = Min or 0
        self.Max = Max or 100
        self.Value = Default or self.Min
        self.Callback = Callback or function() end

        self.Frame = Instance.new("Frame")
        self.Frame.BackgroundTransparency = 1
        self.Frame.Size = UDim2.new(1, 0, 0, 50)
        self.Frame.Parent = Tab.ContentFrame

        self.Label = Instance.new("TextLabel")
        self.Label.BackgroundTransparency = 1
        self.Label.Size = UDim2.new(1, 0, 0, 20)
        self.Label.Font = library.Theme.Font
        self.Label.Text = Text .. ": " .. tostring(self.Value)
        self.Label.TextColor3 = library.Theme.Text
        self.Label.TextSize = library.Theme.TextSize
        self.Label.TextXAlignment = Enum.TextXAlignment.Left
        self.Label.Parent = self.Frame

        self.SliderBar = Instance.new("Frame")
        self.SliderBar.BackgroundColor3 = library.Theme.Border
        self.SliderBar.Size = UDim2.new(1, 0, 0, 6)
        self.SliderBar.Position = UDim2.new(0, 0, 0, 25)
        self.SliderBar.Parent = self.Frame
        library.Utils:CreateCorner(self.SliderBar, UDim.new(0, 3))
        library.Utils:CreateBorder(self.SliderBar)

        self.SliderFill = Instance.new("Frame")
        self.SliderFill.BackgroundColor3 = library.Theme.Accent
        self.SliderFill.Size = UDim2.new((self.Value - self.Min) / (self.Max - self.Min), 0, 1, 0)
        self.SliderFill.Parent = self.SliderBar
        library.Utils:CreateCorner(self.SliderFill, UDim.new(0, 3))

        self.SliderKnob = Instance.new("Frame")
        self.SliderKnob.BackgroundColor3 = library.Theme.Text
        self.SliderKnob.Size = UDim2.new(0, 12, 0, 12)
        self.SliderKnob.Position = UDim2.new(self.SliderFill.Size.X.Scale, -6, 0.5, -6)
        self.SliderKnob.Parent = self.SliderBar
        library.Utils:CreateCorner(self.SliderKnob, UDim.new(0, 6))
        library.Utils:CreateBorder(self.SliderKnob)

        -- Events
        local dragging = false
        local function updateSlider(input)
            local rx = math.clamp((input.Position.X - self.SliderBar.AbsolutePosition.X) / self.SliderBar.AbsoluteSize.X, 0, 1)
            self.Value = math.floor(self.Min + (self.Max - self.Min) * rx + 0.5)
            self:UpdateVisuals()
            self.Callback(self.Value)
        end

        self.SliderBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                updateSlider(input)
            end
        end)

        self.SliderBar.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)

        if UserInputService then
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)
        end

        return self
    end

    function library.Components.Slider:UpdateVisuals()
        local r = (self.Value - self.Min) / (self.Max - self.Min)
        library.Utils:Tween(self.SliderFill, {Size = UDim2.new(r, 0, 1, 0)})
        library.Utils:Tween(self.SliderKnob, {Position = UDim2.new(r, -6, 0.5, -6)})
        self.Label.Text = self.Text .. ": " .. tostring(self.Value)
    end

    -- Dropdown Component
    library.Components.Dropdown = {}
    library.Components.Dropdown.__index = library.Components.Dropdown

    function library.Components.Dropdown.new(Tab, Text, Options, Default, Callback)
        local self = setmetatable({}, library.Components.Dropdown)
        self.Tab = Tab
        self.Text = Text
        self.Options = Options or {}
        self.Value = Default or (self.Options[1] or "")
        self.Callback = Callback or function() end
        self.Open = false

        self.Frame = Instance.new("Frame")
        self.Frame.BackgroundTransparency = 1
        self.Frame.Size = UDim2.new(1, 0, 0, 35)
        self.Frame.Parent = Tab.ContentFrame

        self.Label = Instance.new("TextLabel")
        self.Label.BackgroundTransparency = 1
        self.Label.Size = UDim2.new(1, -50, 1, 0)
        self.Label.Font = library.Theme.Font
        self.Label.Text = Text
        self.Label.TextColor3 = library.Theme.Text
        self.Label.TextSize = library.Theme.TextSize
        self.Label.TextXAlignment = Enum.TextXAlignment.Left
        self.Label.Parent = self.Frame

        self.DropdownButton = Instance.new("Frame")
        self.DropdownButton.BackgroundColor3 = library.Theme.SecondaryBackground
        self.DropdownButton.Size = UDim2.new(0, 120, 1, 0)
        self.DropdownButton.Position = UDim2.new(1, -125, 0, 0)
        self.DropdownButton.Parent = self.Frame
        library.Utils:CreateCorner(self.DropdownButton)
        library.Utils:CreateBorder(self.DropdownButton)

        self.SelectedText = Instance.new("TextLabel")
        self.SelectedText.BackgroundTransparency = 1
        self.SelectedText.Size = UDim2.new(1, -20, 1, 0)
        self.SelectedText.Position = UDim2.new(0, 5, 0, 0)
        self.SelectedText.Font = library.Theme.Font
        self.SelectedText.Text = self.Value
        self.SelectedText.TextColor3 = library.Theme.Text
        self.SelectedText.TextSize = library.Theme.TextSize
        self.SelectedText.TextXAlignment = Enum.TextXAlignment.Left
        self.SelectedText.Parent = self.DropdownButton

        self.Arrow = Instance.new("TextLabel")
        self.Arrow.BackgroundTransparency = 1
        self.Arrow.Size = UDim2.new(0, 15, 1, 0)
        self.Arrow.Position = UDim2.new(1, -18, 0, 0)
        self.Arrow.Font = Enum.Font.SourceSansBold
        self.Arrow.Text = "▼"
        self.Arrow.TextColor3 = library.Theme.TextSecondary
        self.Arrow.TextSize = 12
        self.Arrow.Parent = self.DropdownButton

        self.OptionsFrame = Instance.new("Frame")
        self.OptionsFrame.BackgroundColor3 = library.Theme.SecondaryBackground
        self.OptionsFrame.Size = UDim2.new(0, 120, 0, 0)
        self.OptionsFrame.Position = UDim2.new(0, 0, 1, 5)
        self.OptionsFrame.Visible = false
        self.OptionsFrame.ZIndex = 10
        self.OptionsFrame.Parent = self.DropdownButton
        library.Utils:CreateCorner(self.OptionsFrame)
        library.Utils:CreateBorder(self.OptionsFrame)

        self.OptionButtons = {}
        for i, opt in pairs(self.Options) do
            local btn = Instance.new("TextButton")
            btn.BackgroundTransparency = 1
            btn.Size = UDim2.new(1, 0, 0, 25)
            btn.Position = UDim2.new(0, 0, 0, (i-1) * 25)
            btn.Font = library.Theme.Font
            btn.Text = opt
            btn.TextColor3 = library.Theme.Text
            btn.TextSize = library.Theme.TextSize
            btn.ZIndex = 11
            btn.Parent = self.OptionsFrame
            btn.MouseButton1Click:Connect(function()
                self:SetValue(opt)
                self:ToggleDropdown()
            end)
            self.OptionButtons[opt] = btn
        end

        self.OptionsFrame.Size = UDim2.new(0, 120, 0, #self.Options * 25)

        -- Events
        self.DropdownButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                self:ToggleDropdown()
            end
        end)

        return self
    end

    function library.Components.Dropdown:ToggleDropdown()
        self.Open = not self.Open
        if self.Open then
            self.OptionsFrame.Visible = true
            library.Utils:Tween(self.OptionsFrame, {Size = UDim2.new(0, 120, 0, #self.Options * 25)})
            library.Utils:Tween(self.Arrow, {Rotation = 180})
        else
            library.Utils:Tween(self.OptionsFrame, {Size = UDim2.new(0, 120, 0, 0)}, function()
                self.OptionsFrame.Visible = false
            end)
            library.Utils:Tween(self.Arrow, {Rotation = 0})
        end
    end

    function library.Components.Dropdown:SetValue(Value)
        if table.find(self.Options, Value) then
            self.Value = Value
            self.SelectedText.Text = Value
            self.Callback(Value)
        end
    end

    -- Input Component
    library.Components.Input = {}
    library.Components.Input.__index = library.Components.Input

    function library.Components.Input.new(Tab, Text, Placeholder, Callback)
        local self = setmetatable({}, library.Components.Input)
        self.Tab = Tab
        self.Text = Text
        self.Value = ""
        self.Callback = Callback or function() end

        self.Frame = Instance.new("Frame")
        self.Frame.BackgroundTransparency = 1
        self.Frame.Size = UDim2.new(1, 0, 0, 55)
        self.Frame.Parent = Tab.ContentFrame

        self.Label = Instance.new("TextLabel")
        self.Label.BackgroundTransparency = 1
        self.Label.Size = UDim2.new(1, 0, 0, 20)
        self.Label.Font = library.Theme.Font
        self.Label.Text = Text
        self.Label.TextColor3 = library.Theme.Text
        self.Label.TextSize = library.Theme.TextSize
        self.Label.TextXAlignment = Enum.TextXAlignment.Left
        self.Label.Parent = self.Frame

        self.TextBox = Instance.new("TextBox")
        self.TextBox.BackgroundColor3 = library.Theme.SecondaryBackground
        self.TextBox.Size = UDim2.new(1, 0, 0, 25)
        self.TextBox.Position = UDim2.new(0, 0, 0, 25)
        self.TextBox.Font = library.Theme.Font
        self.TextBox.PlaceholderText = Placeholder or "Enter text..."
        self.TextBox.PlaceholderColor3 = library.Theme.TextTertiary
        self.TextBox.Text = ""
        self.TextBox.TextColor3 = library.Theme.Text
        self.TextBox.TextSize = library.Theme.TextSize
        self.TextBox.ClearTextOnFocus = false
        self.TextBox.Parent = self.Frame
        library.Utils:CreateCorner(self.TextBox)
        library.Utils:CreateBorder(self.TextBox)

        -- Events
        self.TextBox.FocusLost:Connect(function(enter)
            self.Value = self.TextBox.Text
            self.Callback(self.Value, enter)
        end)

        self.TextBox.Focused:Connect(function()
            library.Utils:Tween(self.TextBox, {BackgroundColor3 = library.Theme.Hover})
        end)

        self.TextBox.FocusLost:Connect(function()
            library.Utils:Tween(self.TextBox, {BackgroundColor3 = library.Theme.SecondaryBackground})
        end)

        return self
    end

    -- Label Component
    library.Components.Label = {}
    library.Components.Label.__index = library.Components.Label

    function library.Components.Label.new(Tab, Text)
        local self = setmetatable({}, library.Components.Label)
        self.Tab = Tab
        self.Text = Text

        self.Frame = Instance.new("Frame")
        self.Frame.BackgroundTransparency = 1
        self.Frame.Size = UDim2.new(1, 0, 0, 25)
        self.Frame.Parent = Tab.ContentFrame

        self.Label = Instance.new("TextLabel")
        self.Label.BackgroundTransparency = 1
        self.Label.Size = UDim2.new(1, 0, 1, 0)
        self.Label.Font = library.Theme.Font
        self.Label.Text = Text
        self.Label.TextColor3 = library.Theme.Text
        self.Label.TextSize = library.Theme.TextSize
        self.Label.TextXAlignment = Enum.TextXAlignment.Left
        self.Label.Parent = self.Frame

        return self
    end

    -- Notification System
    library.Notification = {}

    function library.Notification.new(Title, Text, Duration)
        local notif = {}

        if not library._notificationGui then
            library._notificationGui = Instance.new("ScreenGui")
            library._notificationGui.Name = "BdevUiNotifications"
            library._notificationGui.ResetOnSpawn = false
            library._notificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

            local success = pcall(function() library._notificationGui.Parent = CoreGui end)
            if not success and Players and Players.LocalPlayer then
                pcall(function() library._notificationGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end)
            end
        end

        notif.Frame = Instance.new("Frame")
        notif.Frame.BackgroundColor3 = library.Theme.Background
        notif.Frame.Size = UDim2.new(0, 300, 0, 80)
        notif.Frame.Position = UDim2.new(1, 310, 1, -90 - (#(library._notifications or {}) * 90))
        notif.Frame.ZIndex = 100
        notif.Frame.Parent = library._notificationGui

        library.Utils:CreateCorner(notif.Frame)
        library.Utils:CreateBorder(notif.Frame)
        library.Utils:CreateShadow(notif.Frame)

        notif.TitleLabel = Instance.new("TextLabel")
        notif.TitleLabel.BackgroundTransparency = 1
        notif.TitleLabel.Size = UDim2.new(1, -20, 0, 25)
        notif.TitleLabel.Position = UDim2.new(0, 10, 0, 5)
        notif.TitleLabel.Font = library.Theme.Font
        notif.TitleLabel.Text = Title or "Notification"
        notif.TitleLabel.TextColor3 = library.Theme.Text
        notif.TitleLabel.TextSize = 16
        notif.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        notif.TitleLabel.Parent = notif.Frame

        notif.TextLabel = Instance.new("TextLabel")
        notif.TextLabel.BackgroundTransparency = 1
        notif.TextLabel.Size = UDim2.new(1, -20, 0, 40)
        notif.TextLabel.Position = UDim2.new(0, 10, 0, 30)
        notif.TextLabel.Font = library.Theme.Font
        notif.TextLabel.Text = Text or ""
        notif.TextLabel.TextColor3 = library.Theme.TextSecondary
        notif.TextLabel.TextSize = 14
        notif.TextLabel.TextWrapped = true
        notif.TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        notif.TextLabel.TextYAlignment = Enum.TextYAlignment.Top
        notif.TextLabel.Parent = notif.Frame

        library.Utils:Tween(notif.Frame, {Position = UDim2.new(1, -310, 1, -90 - (#(library._notifications or {}) * 90))})

        library._notifications = library._notifications or {}
        table.insert(library._notifications, notif)

        spawn(function()
            wait(Duration or 3)
            notif:Destroy()
        end)

        function notif:Destroy()
            library.Utils:Tween(notif.Frame, {Position = UDim2.new(1, 310, notif.Frame.Position.Y)}, function()
                pcall(function() notif.Frame:Destroy() end)
                local i = table.find(library._notifications, notif)
                if i then table.remove(library._notifications, i) end
                for j, n in pairs(library._notifications) do
                    library.Utils:Tween(n.Frame, {Position = UDim2.new(1, -310, 1, -90 - (j-1) * 90)})
                end
            end)
        end

        return notif
    end

    -- Main Functions
    function library:CreateWindow(Title, Size, Position)
        return library.Components.Window.new(Title, Size, Position)
    end

    function library:Notify(Title, Text, Duration)
        return library.Notification.new(Title, Text, Duration)
    end

    function library:Destroy()
        for _, w in pairs(library._windows) do
            w:Destroy()
        end
        if library._notificationGui then
            pcall(function() library._notificationGui:Destroy() end)
            library._notificationGui = nil
        end
        library._windows = {}
        library._notifications = {}
    end

    return library
end)()

-- Return the library for loadstring usage
return BdevUi