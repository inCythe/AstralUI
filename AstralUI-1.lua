--[[ 
    ASTRAL V3 UI LIBRARY - Enhanced Edition
    - Visually appealing notifications with icons
    - Multi-select dropdowns with min/max selection constraints
    - Improved dropdown search functionality
    - Enhanced demo showing all features
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local Astral = {}

--// THEME
Astral.Theme = {
    Main = Color3.fromRGB(15, 15, 20),
    Secondary = Color3.fromRGB(25, 25, 30),
    Tertiary = Color3.fromRGB(20, 20, 25),
    Accent = Color3.fromRGB(88, 139, 255),
    Text = Color3.fromRGB(245, 245, 250),
    TextDark = Color3.fromRGB(150, 150, 160),
    TextDarker = Color3.fromRGB(100, 100, 110),
    Stroke = Color3.fromRGB(50, 50, 60),
    StrokeDark = Color3.fromRGB(35, 35, 45),
    HoverBright = Color3.fromRGB(35, 35, 42),
    Success = Color3.fromRGB(80, 200, 120),
    Warning = Color3.fromRGB(255, 180, 80),
    Error = Color3.fromRGB(255, 100, 100),
    NotificationSuccess = Color3.fromRGB(46, 204, 113),
    NotificationInfo = Color3.fromRGB(52, 152, 219),
    NotificationWarning = Color3.fromRGB(241, 196, 15),
    NotificationError = Color3.fromRGB(231, 76, 60)
}

-- Notification icons (using Roblox asset IDs)
Astral.Icons = {
    Info = "rbxassetid://6031091004",
    Success = "rbxassetid://6031091003",
    Warning = "rbxassetid://6031091002",
    Error = "rbxassetid://6031091001",
    Check = "rbxassetid://6031091000",
    Close = "rbxassetid://6031090998"
}

-- Prevent duplicate GUIs
if CoreGui:FindFirstChild("AstralLib") then 
    CoreGui.AstralLib:Destroy() 
end

--// UTILITY FUNCTIONS
local function MakeDraggable(DragBar, WindowObject)
    local Dragging, DragInput, DragStart, StartPosition

    local function Update(input)
        local Delta = input.Position - DragStart
        WindowObject.Position = UDim2.new(
            StartPosition.X.Scale, 
            StartPosition.X.Offset + Delta.X, 
            StartPosition.Y.Scale, 
            StartPosition.Y.Offset + Delta.Y
        )
    end

    DragBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = WindowObject.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    DragBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
end

local function AddHoverEffect(Object, HoverColor, NormalColor, HoverTransparency, NormalTransparency)
    Object.MouseEnter:Connect(function()
        local Properties = {BackgroundColor3 = HoverColor}
        if HoverTransparency then 
            Properties.BackgroundTransparency = HoverTransparency 
        end
        TweenService:Create(Object, TweenInfo.new(0.15), Properties):Play()
    end)

    Object.MouseLeave:Connect(function()
        local Properties = {BackgroundColor3 = NormalColor}
        if NormalTransparency then 
            Properties.BackgroundTransparency = NormalTransparency 
        end
        TweenService:Create(Object, TweenInfo.new(0.15), Properties):Play()
    end)
end

local function AddClickEffect(Object)
    local OriginalSize = Object.Size
    
    Object.MouseButton1Down:Connect(function()
        TweenService:Create(Object, TweenInfo.new(0.08), {
            Size = UDim2.new(
                OriginalSize.X.Scale * 0.98, 
                OriginalSize.X.Offset, 
                OriginalSize.Y.Scale * 0.98, 
                OriginalSize.Y.Offset
            )
        }):Play()
    end)

    local function Restore()
        TweenService:Create(Object, TweenInfo.new(0.15), {Size = OriginalSize}):Play()
    end

    Object.MouseButton1Up:Connect(Restore)
    Object.MouseLeave:Connect(Restore)
end

--// MAIN WINDOW
function Astral:Window(Options)
    local Name = Options.Name or "Astral V3"
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AstralLib"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Notification system internals
    local NotificationQueue = {}
    local ActiveNotifications = {}
    local MaxNotifications = 5

    local MainFrame = Instance.new("Frame")
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Astral.Theme.Main
    MainFrame.BackgroundTransparency = 0.15
    MainFrame.Position = UDim2.new(0.5, -290, 0.5, -210)
    MainFrame.Size = UDim2.new(0, 580, 0, 420)
    MainFrame.ClipsDescendants = true

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Color = Astral.Theme.Stroke
    MainStroke.Thickness = 1.5
    MainStroke.Transparency = 0.5
    MainStroke.Parent = MainFrame

    -- Title bar
    local TitleFrame = Instance.new("Frame")
    TitleFrame.Parent = MainFrame
    TitleFrame.BackgroundTransparency = 1
    TitleFrame.Size = UDim2.new(1, 0, 0, 38)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Parent = TitleFrame
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 18, 0, 0)
    TitleLabel.Size = UDim2.new(0.5, 0, 1, 0)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Text = Name
    TitleLabel.TextColor3 = Astral.Theme.Text
    TitleLabel.TextSize = 15
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    MakeDraggable(TitleFrame, MainFrame)

    -- Controls
    local ControlsFrame = Instance.new("Frame")
    ControlsFrame.Parent = TitleFrame
    ControlsFrame.BackgroundTransparency = 1
    ControlsFrame.Position = UDim2.new(1, -90, 0, 0)
    ControlsFrame.Size = UDim2.new(0, 90, 1, 0)

    local function MakeButton(Text, Position, Color)
        local Button = Instance.new("TextButton")
        Button.Parent = ControlsFrame
        Button.BackgroundColor3 = Astral.Theme.Tertiary
        Button.BackgroundTransparency = 0.3
        Button.Position = Position
        Button.Size = UDim2.new(0, 28, 0, 28)
        Button.AutoButtonColor = false
        Button.Font = Enum.Font.GothamBold
        Button.Text = Text
        Button.TextColor3 = Color
        Button.TextSize = 14
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 6)
        ButtonCorner.Parent = Button
        
        AddHoverEffect(Button, Astral.Theme.HoverBright, Astral.Theme.Tertiary, 0.1, 0.3)
        AddClickEffect(Button)
        return Button
    end

    local CloseButton = MakeButton("×", UDim2.new(1, -32, 0.5, -14), Astral.Theme.Error)
    CloseButton.TextSize = 18
    CloseButton.MouseButton1Click:Connect(function()
        local Tween = TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0), 
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        Tween:Play()
        task.wait(0.25)
        ScreenGui:Destroy()
    end)

    local MinimizeButton = MakeButton("−", UDim2.new(1, -64, 0.5, -14), Astral.Theme.TextDark)
    MinimizeButton.TextSize = 16
    local Minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        local TargetSize = Minimized and UDim2.new(0, 580, 0, 38) or UDim2.new(0, 580, 0, 420)
        TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = TargetSize}):Play()
    end)

    -- Content Area
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Parent = MainFrame
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Position = UDim2.new(0, 0, 0, 42)
    ContentFrame.Size = UDim2.new(1, 0, 1, -42)
    ContentFrame.ClipsDescendants = true

    -- Sidebar
    local SidebarFrame = Instance.new("Frame")
    SidebarFrame.Parent = ContentFrame
    SidebarFrame.BackgroundColor3 = Astral.Theme.Secondary
    SidebarFrame.BackgroundTransparency = 0.2
    SidebarFrame.Position = UDim2.new(0, 8, 0, 0)
    SidebarFrame.Size = UDim2.new(0, 130, 1, -8)

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 8)
    SidebarCorner.Parent = SidebarFrame

    local SidebarStroke = Instance.new("UIStroke")
    SidebarStroke.Color = Astral.Theme.StrokeDark
    SidebarStroke.Thickness = 1
    SidebarStroke.Transparency = 0.5
    SidebarStroke.Parent = SidebarFrame

    -- Search Box
    local SearchFrame = Instance.new("Frame")
    SearchFrame.Parent = SidebarFrame
    SearchFrame.BackgroundColor3 = Astral.Theme.Tertiary
    SearchFrame.BackgroundTransparency = 0.3
    SearchFrame.Position = UDim2.new(0, 6, 0, 6)
    SearchFrame.Size = UDim2.new(1, -12, 0, 30)

    local SearchCorner = Instance.new("UICorner")
    SearchCorner.CornerRadius = UDim.new(0, 6)
    SearchCorner.Parent = SearchFrame

    local SearchBox = Instance.new("TextBox")
    SearchBox.Parent = SearchFrame
    SearchBox.BackgroundTransparency = 1
    SearchBox.Position = UDim2.new(0, 8, 0, 0)
    SearchBox.Size = UDim2.new(1, -16, 1, 0)
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.PlaceholderText = "Search..."
    SearchBox.PlaceholderColor3 = Astral.Theme.TextDarker
    SearchBox.Text = ""
    SearchBox.TextColor3 = Astral.Theme.TextDark
    SearchBox.TextSize = 11
    SearchBox.TextXAlignment = Enum.TextXAlignment.Left

    -- Tab Container
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Parent = SidebarFrame
    TabContainer.BackgroundTransparency = 1
    TabContainer.Position = UDim2.new(0, 6, 0, 42)
    TabContainer.Size = UDim2.new(1, -12, 1, -48)
    TabContainer.ScrollBarThickness = 3
    TabContainer.ScrollBarImageColor3 = Astral.Theme.Accent
    TabContainer.BorderSizePixel = 0

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = TabContainer
    TabLayout.Padding = UDim.new(0, 5)
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
    end)

    -- Page Container
    local PagesFrame = Instance.new("Frame")
    PagesFrame.Parent = ContentFrame
    PagesFrame.BackgroundColor3 = Astral.Theme.Secondary
    PagesFrame.BackgroundTransparency = 0.2
    PagesFrame.Position = UDim2.new(0, 146, 0, 0)
    PagesFrame.Size = UDim2.new(1, -154, 1, -8)

    local PagesCorner = Instance.new("UICorner")
    PagesCorner.CornerRadius = UDim.new(0, 8)
    PagesCorner.Parent = PagesFrame

    local WindowFunctions = {}
    local FirstTab = true
    local AllTabs = {}

    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local Text = SearchBox.Text:lower()
        for _, TabData in pairs(AllTabs) do
            TabData.Button.Visible = (Text == "" or TabData.Name:lower():find(Text))
        end
    end)

    --// ENHANCED NOTIFICATION LOGIC
    local function UpdateNotificationPositions()
        for Index, Notification in ipairs(ActiveNotifications) do
            local TargetYOffset = -20 - ((Index - 1) * 90) 
            
            TweenService:Create(Notification, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, -20, 1, TargetYOffset)
            }):Play()
        end
    end

    local function RemoveNotification(NotificationFrame)
        for Index, Notification in ipairs(ActiveNotifications) do
            if Notification == NotificationFrame then
                table.remove(ActiveNotifications, Index)
                break
            end
        end

        local ExitTween = TweenService:Create(NotificationFrame, TweenInfo.new(0.3), {
            Position = UDim2.new(1, 20, NotificationFrame.Position.Y.Scale, NotificationFrame.Position.Y.Offset),
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 0, 0, 0)
        })
        ExitTween:Play()
        
        task.wait(0.3)
        NotificationFrame:Destroy()
        UpdateNotificationPositions()
        
        if #NotificationQueue > 0 then
            local Next = table.remove(NotificationQueue, 1)
            WindowFunctions:Notify(Next)
        end
    end

    function WindowFunctions:Notify(Options)
        local Title = Options.Title or "Notification"
        local Content = Options.Content or "Message"
        local Duration = Options.Duration or 3
        local Type = Options.Type or "Info"

        local TypeColors = {
            Info = Astral.Theme.NotificationInfo,
            Success = Astral.Theme.NotificationSuccess,
            Warning = Astral.Theme.NotificationWarning,
            Error = Astral.Theme.NotificationError
        }
        
        local TypeIcons = {
            Info = Astral.Icons.Info,
            Success = Astral.Icons.Success,
            Warning = Astral.Icons.Warning,
            Error = Astral.Icons.Error
        }

        if #ActiveNotifications >= MaxNotifications then
            table.insert(NotificationQueue, Options)
            return
        end

        local NotificationFrame = Instance.new("Frame")
        NotificationFrame.Parent = ScreenGui
        NotificationFrame.BackgroundColor3 = Astral.Theme.Main
        NotificationFrame.BackgroundTransparency = 0.1
        NotificationFrame.Size = UDim2.new(0, 0, 0, 0) -- Start at 0 for animation
        NotificationFrame.AnchorPoint = Vector2.new(1, 1)
        NotificationFrame.Position = UDim2.new(1.5, 0, 1, -20)
        NotificationFrame.ZIndex = 100
        NotificationFrame.ClipsDescendants = true

        local NotificationCorner = Instance.new("UICorner")
        NotificationCorner.CornerRadius = UDim.new(0, 10)
        NotificationCorner.Parent = NotificationFrame

        local NotificationStroke = Instance.new("UIStroke")
        NotificationStroke.Color = TypeColors[Type]
        NotificationStroke.Thickness = 2
        NotificationStroke.Parent = NotificationFrame

        -- Icon
        local IconFrame = Instance.new("Frame")
        IconFrame.Parent = NotificationFrame
        IconFrame.BackgroundColor3 = TypeColors[Type]
        IconFrame.Size = UDim2.new(0, 40, 1, 0)
        
        local IconCorner = Instance.new("UICorner")
        IconCorner.CornerRadius = UDim.new(0, 10)
        IconCorner.Parent = IconFrame

        local IconImage = Instance.new("ImageLabel")
        IconImage.Parent = IconFrame
        IconImage.BackgroundTransparency = 1
        IconImage.Size = UDim2.new(0, 24, 0, 24)
        IconImage.Position = UDim2.new(0.5, -12, 0.5, -12)
        IconImage.Image = TypeIcons[Type]
        IconImage.ImageColor3 = Color3.fromRGB(255, 255, 255)

        -- Content Area
        local ContentFrame = Instance.new("Frame")
        ContentFrame.Parent = NotificationFrame
        ContentFrame.BackgroundTransparency = 1
        ContentFrame.Position = UDim2.new(0, 48, 0, 0)
        ContentFrame.Size = UDim2.new(1, -56, 1, 0)

        local NotificationTitle = Instance.new("TextLabel")
        NotificationTitle.Parent = ContentFrame
        NotificationTitle.BackgroundTransparency = 1
        NotificationTitle.Position = UDim2.new(0, 0, 0, 12)
        NotificationTitle.Size = UDim2.new(1, -8, 0, 18)
        NotificationTitle.Font = Enum.Font.GothamBold
        NotificationTitle.Text = Title
        NotificationTitle.TextColor3 = Astral.Theme.Text
        NotificationTitle.TextSize = 14
        NotificationTitle.TextXAlignment = Enum.TextXAlignment.Left

        local NotificationContent = Instance.new("TextLabel")
        NotificationContent.Parent = ContentFrame
        NotificationContent.BackgroundTransparency = 1
        NotificationContent.Position = UDim2.new(0, 0, 0, 30)
        NotificationContent.Size = UDim2.new(1, -8, 1, -40)
        NotificationContent.Font = Enum.Font.Gotham
        NotificationContent.Text = Content
        NotificationContent.TextColor3 = Astral.Theme.TextDark
        NotificationContent.TextSize = 11
        NotificationContent.TextXAlignment = Enum.TextXAlignment.Left
        NotificationContent.TextYAlignment = Enum.TextYAlignment.Top
        NotificationContent.TextWrapped = true

        -- Close button
        local CloseButton = Instance.new("ImageButton")
        CloseButton.Parent = NotificationFrame
        CloseButton.BackgroundTransparency = 1
        CloseButton.Position = UDim2.new(1, -30, 0, 8)
        CloseButton.Size = UDim2.new(0, 20, 0, 20)
        CloseButton.Image = Astral.Icons.Close
        CloseButton.ImageColor3 = Astral.Theme.TextDark
        
        CloseButton.MouseEnter:Connect(function()
            TweenService:Create(CloseButton, TweenInfo.new(0.15), {
                ImageColor3 = Astral.Theme.Error
            }):Play()
        end)
        
        CloseButton.MouseLeave:Connect(function()
            TweenService:Create(CloseButton, TweenInfo.new(0.15), {
                ImageColor3 = Astral.Theme.TextDark
            }):Play()
        end)
        
        CloseButton.MouseButton1Click:Connect(function()
            RemoveNotification(NotificationFrame)
        end)

        table.insert(ActiveNotifications, NotificationFrame)
        
        -- Entrance animation
        TweenService:Create(NotificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 320, 0, 80)
        }):Play()
        
        UpdateNotificationPositions()

        -- Auto-remove after duration
        local AutoRemove = task.delay(Duration, function()
            RemoveNotification(NotificationFrame)
        end)
        
        -- Hover to pause removal
        NotificationFrame.MouseEnter:Connect(function()
            if AutoRemove then
                task.cancel(AutoRemove)
            end
        end)
        
        NotificationFrame.MouseLeave:Connect(function()
            AutoRemove = task.delay(Duration, function()
                RemoveNotification(NotificationFrame)
            end)
        end)
    end

    --// TABS
    function WindowFunctions:Tab(Options)
        local TabName = Options.Name or "Tab"
        local TabIcon = Options.Icon or "rbxassetid://7733954760"

        local TabButton = Instance.new("TextButton")
        TabButton.Parent = TabContainer
        TabButton.BackgroundColor3 = Astral.Theme.Tertiary
        TabButton.BackgroundTransparency = 0.4
        TabButton.Size = UDim2.new(1, 0, 0, 28)
        TabButton.AutoButtonColor = false
        TabButton.Text = ""
        
        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 8)
        TabButtonCorner.Parent = TabButton

        local IconImage = Instance.new("ImageLabel")
        IconImage.Parent = TabButton
        IconImage.BackgroundTransparency = 1
        IconImage.Position = UDim2.new(0, 8, 0.5, -8)
        IconImage.Size = UDim2.new(0, 16, 0, 16)
        IconImage.Image = TabIcon
        IconImage.ImageColor3 = Astral.Theme.TextDark

        local LabelText = Instance.new("TextLabel")
        LabelText.Parent = TabButton
        LabelText.BackgroundTransparency = 1
        LabelText.Position = UDim2.new(0, 30, 0, 0)
        LabelText.Size = UDim2.new(1, -35, 1, 0)
        LabelText.Font = Enum.Font.GothamMedium
        LabelText.Text = TabName
        LabelText.TextColor3 = Astral.Theme.TextDark
        LabelText.TextSize = 11
        LabelText.TextXAlignment = Enum.TextXAlignment.Left

        local IndicatorFrame = Instance.new("Frame")
        IndicatorFrame.Name = "Indicator"
        IndicatorFrame.Parent = TabButton
        IndicatorFrame.BackgroundColor3 = Astral.Theme.Accent
        IndicatorFrame.BorderSizePixel = 0
        IndicatorFrame.Position = UDim2.new(0, 2, 0.5, -8)
        IndicatorFrame.Size = UDim2.new(0, 2, 0, 16)
        IndicatorFrame.Visible = false

        AddHoverEffect(TabButton, Astral.Theme.HoverBright, Astral.Theme.Tertiary, 0.2, 0.4)
        AddClickEffect(TabButton)

        local PageFrame = Instance.new("ScrollingFrame")
        PageFrame.Parent = PagesFrame
        PageFrame.BackgroundTransparency = 1
        PageFrame.BorderSizePixel = 0
        PageFrame.Size = UDim2.new(1, 0, 1, 0)
        PageFrame.ScrollBarThickness = 4
        PageFrame.ScrollBarImageColor3 = Astral.Theme.Accent
        PageFrame.Visible = false

        local PagePadding = Instance.new("UIPadding")
        PagePadding.Parent = PageFrame
        PagePadding.PaddingTop = UDim.new(0, 8)
        PagePadding.PaddingLeft = UDim.new(0, 8)
        PagePadding.PaddingRight = UDim.new(0, 8)
        PagePadding.PaddingBottom = UDim.new(0, 8)

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Parent = PageFrame
        PageLayout.Padding = UDim.new(0, 6)
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            PageFrame.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 16)
        end)

        local function Activate()
            for _, Page in pairs(PagesFrame:GetChildren()) do
                if Page:IsA("ScrollingFrame") then 
                    Page.Visible = false 
                end
            end
            for _, TabData in pairs(AllTabs) do
                TabData.Button.Indicator.Visible = false
                TweenService:Create(TabData.Button, TweenInfo.new(0.2), {BackgroundTransparency = 0.4}):Play()
                TweenService:Create(TabData.Label, TweenInfo.new(0.2), {TextColor3 = Astral.Theme.TextDark}):Play()
                TweenService:Create(TabData.Icon, TweenInfo.new(0.2), {ImageColor3 = Astral.Theme.TextDark}):Play()
            end
            PageFrame.Visible = true
            IndicatorFrame.Visible = true
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.1}):Play()
            TweenService:Create(LabelText, TweenInfo.new(0.2), {TextColor3 = Astral.Theme.Text}):Play()
            TweenService:Create(IconImage, TweenInfo.new(0.2), {ImageColor3 = Astral.Theme.Accent}):Play()
        end

        TabButton.MouseButton1Click:Connect(Activate)
        table.insert(AllTabs, {Name = TabName, Button = TabButton, Label = LabelText, Icon = IconImage})

        if FirstTab then
            FirstTab = false
            Activate()
        end

        local TabFunctions = {}

        --// SECTIONS
        function TabFunctions:Section(Options)
            local SectionName = Options.Name or "Section"

            local SectionFrame = Instance.new("Frame")
            SectionFrame.Parent = PageFrame
            SectionFrame.BackgroundColor3 = Astral.Theme.Tertiary
            SectionFrame.BackgroundTransparency = 0.3
            SectionFrame.Size = UDim2.new(1, 0, 0, 0)
            SectionFrame.AutomaticSize = Enum.AutomaticSize.Y

            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 8)
            SectionCorner.Parent = SectionFrame

            local HeaderFrame = Instance.new("Frame")
            HeaderFrame.Parent = SectionFrame
            HeaderFrame.BackgroundColor3 = Astral.Theme.Main
            HeaderFrame.BackgroundTransparency = 0.3
            HeaderFrame.Size = UDim2.new(1, 0, 0, 32)

            local HeaderCorner = Instance.new("UICorner")
            HeaderCorner.CornerRadius = UDim.new(0, 8)
            HeaderCorner.Parent = HeaderFrame

            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Parent = HeaderFrame
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Position = UDim2.new(0, 12, 0, 0)
            SectionLabel.Size = UDim2.new(1, -24, 1, 0)
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.Text = SectionName
            SectionLabel.TextColor3 = Astral.Theme.Text
            SectionLabel.TextSize = 13
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left

            local SectionContent = Instance.new("Frame")
            SectionContent.Parent = SectionFrame
            SectionContent.BackgroundTransparency = 1
            SectionContent.Position = UDim2.new(0, 0, 0, 32)
            SectionContent.Size = UDim2.new(1, 0, 0, 0)
            SectionContent.AutomaticSize = Enum.AutomaticSize.Y

            local SectionPadding = Instance.new("UIPadding")
            SectionPadding.Parent = SectionContent
            SectionPadding.PaddingTop = UDim.new(0, 8)
            SectionPadding.PaddingLeft = UDim.new(0, 8)
            SectionPadding.PaddingRight = UDim.new(0, 8)
            SectionPadding.PaddingBottom = UDim.new(0, 8)

            local SectionLayout = Instance.new("UIListLayout")
            SectionLayout.Parent = SectionContent
            SectionLayout.Padding = UDim.new(0, 6)

            local SectionFunctions = {}
            function SectionFunctions:Button(Options) return TabFunctions:Button(Options, SectionContent) end
            function SectionFunctions:Toggle(Options) return TabFunctions:Toggle(Options, SectionContent) end
            function SectionFunctions:Slider(Options) return TabFunctions:Slider(Options, SectionContent) end
            function SectionFunctions:TextBox(Options) return TabFunctions:TextBox(Options, SectionContent) end
            function SectionFunctions:Dropdown(Options) return TabFunctions:Dropdown(Options, SectionContent) end
            function SectionFunctions:MultiDropdown(Options) return TabFunctions:MultiDropdown(Options, SectionContent) end
            function SectionFunctions:Keybind(Options) return TabFunctions:Keybind(Options, SectionContent) end
            function SectionFunctions:Label(Options) return TabFunctions:Label(Options, SectionContent) end

            return SectionFunctions
        end

        --// ELEMENTS
        function TabFunctions:Button(Options, Parent)
            Parent = Parent or PageFrame
            local ButtonName = Options.Name or "Button"
            local Callback = Options.Callback or function() end

            local ButtonFrame = Instance.new("TextButton")
            ButtonFrame.Parent = Parent
            ButtonFrame.BackgroundColor3 = Astral.Theme.Main
            ButtonFrame.BackgroundTransparency = 0.3
            ButtonFrame.Size = UDim2.new(1, 0, 0, 34)
            ButtonFrame.AutoButtonColor = false
            ButtonFrame.Text = ""
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Parent = ButtonFrame

            local ButtonLabel = Instance.new("TextLabel")
            ButtonLabel.Parent = ButtonFrame
            ButtonLabel.BackgroundTransparency = 1
            ButtonLabel.Position = UDim2.new(0, 12, 0, 0)
            ButtonLabel.Size = UDim2.new(1, -40, 1, 0)
            ButtonLabel.Font = Enum.Font.GothamMedium
            ButtonLabel.Text = ButtonName
            ButtonLabel.TextColor3 = Astral.Theme.Text
            ButtonLabel.TextSize = 12
            ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left

            AddHoverEffect(ButtonFrame, Astral.Theme.HoverBright, Astral.Theme.Main, 0.1, 0.3)
            AddClickEffect(ButtonFrame)
            ButtonFrame.MouseButton1Click:Connect(Callback)
            
            return {
                UpdateText = function(Text)
                    ButtonLabel.Text = Text
                end,
                UpdateCallback = function(NewCallback)
                    Callback = NewCallback
                end
            }
        end

        function TabFunctions:Toggle(Options, Parent)
            Parent = Parent or PageFrame
            local ToggleName = Options.Name or "Toggle"
            local Default = Options.Default or false
            local Callback = Options.Callback or function() end
            local State = Default

            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Parent = Parent
            ToggleFrame.BackgroundColor3 = Astral.Theme.Main
            ToggleFrame.BackgroundTransparency = 0.3
            ToggleFrame.Size = UDim2.new(1, 0, 0, 34)
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 6)
            ToggleCorner.Parent = ToggleFrame

            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Parent = ToggleFrame
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
            ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
            ToggleLabel.Font = Enum.Font.GothamMedium
            ToggleLabel.Text = ToggleName
            ToggleLabel.TextColor3 = Astral.Theme.Text
            ToggleLabel.TextSize = 12
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left

            local CheckButton = Instance.new("TextButton")
            CheckButton.Parent = ToggleFrame
            CheckButton.BackgroundColor3 = State and Astral.Theme.Accent or Astral.Theme.Tertiary
            CheckButton.Position = UDim2.new(1, -46, 0.5, -9)
            CheckButton.Size = UDim2.new(0, 38, 0, 18)
            CheckButton.AutoButtonColor = false
            CheckButton.Text = ""
            
            local CheckCorner = Instance.new("UICorner")
            CheckCorner.CornerRadius = UDim.new(1, 0)
            CheckCorner.Parent = CheckButton

            local CircleFrame = Instance.new("Frame")
            CircleFrame.Parent = CheckButton
            CircleFrame.BackgroundColor3 = Astral.Theme.Text
            CircleFrame.Size = UDim2.new(0, 14, 0, 14)
            CircleFrame.Position = State and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            
            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = CircleFrame

            local function Update()
                local Position = State and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                local Color = State and Astral.Theme.Accent or Astral.Theme.Tertiary
                TweenService:Create(CircleFrame, TweenInfo.new(0.2), {Position = Position}):Play()
                TweenService:Create(CheckButton, TweenInfo.new(0.2), {BackgroundColor3 = Color}):Play()
                Callback(State)
            end
            
            CheckButton.MouseButton1Click:Connect(function() 
                State = not State 
                Update() 
            end)
            Update()
            
            return {
                SetState = function(NewState)
                    State = NewState
                    Update()
                end,
                GetState = function()
                    return State
                end,
                UpdateText = function(Text)
                    ToggleLabel.Text = Text
                end
            }
        end

        function TabFunctions:Slider(Options, Parent)
            Parent = Parent or PageFrame
            local SliderName = Options.Name or "Slider"
            local Min = Options.Min or 0
            local Max = Options.Max or 100
            local Default = Options.Default or Min
            local Increment = Options.Increment or 1
            local Callback = Options.Callback or function() end
            local Value = Default

            local SliderFrame = Instance.new("Frame")
            SliderFrame.Parent = Parent
            SliderFrame.BackgroundColor3 = Astral.Theme.Main
            SliderFrame.BackgroundTransparency = 0.3
            SliderFrame.Size = UDim2.new(1, 0, 0, 50)
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 6)
            SliderCorner.Parent = SliderFrame

            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Parent = SliderFrame
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Position = UDim2.new(0, 12, 0, 6)
            SliderLabel.Size = UDim2.new(1, -24, 0, 16)
            SliderLabel.Font = Enum.Font.GothamMedium
            SliderLabel.Text = SliderName
            SliderLabel.TextColor3 = Astral.Theme.Text
            SliderLabel.TextSize = 12
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left

            local ValueInput = Instance.new("TextBox")
            ValueInput.Parent = SliderFrame
            ValueInput.BackgroundColor3 = Astral.Theme.Tertiary
            ValueInput.BackgroundTransparency = 0.3
            ValueInput.Position = UDim2.new(1, -60, 0, 4)
            ValueInput.Size = UDim2.new(0, 48, 0, 20)
            ValueInput.Font = Enum.Font.GothamBold
            ValueInput.Text = tostring(Value)
            ValueInput.TextColor3 = Astral.Theme.Accent
            ValueInput.TextSize = 11
            ValueInput.ClearTextOnFocus = false

            local BackgroundFrame = Instance.new("Frame")
            BackgroundFrame.Parent = SliderFrame
            BackgroundFrame.BackgroundColor3 = Astral.Theme.Tertiary
            BackgroundFrame.Position = UDim2.new(0, 12, 1, -18)
            BackgroundFrame.Size = UDim2.new(1, -24, 0, 6)
            
            local BackgroundCorner = Instance.new("UICorner")
            BackgroundCorner.CornerRadius = UDim.new(1, 0)
            BackgroundCorner.Parent = BackgroundFrame

            local FillFrame = Instance.new("Frame")
            FillFrame.Parent = BackgroundFrame
            FillFrame.BackgroundColor3 = Astral.Theme.Accent
            FillFrame.Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
            
            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = FillFrame

            local BallFrame = Instance.new("Frame")
            BallFrame.Parent = BackgroundFrame
            BallFrame.BackgroundColor3 = Astral.Theme.Text
            BallFrame.Size = UDim2.new(0, 14, 0, 14)
            BallFrame.Position = UDim2.new((Value - Min) / (Max - Min), -7, 0.5, -7)
            BallFrame.ZIndex = 2
            
            local BallCorner = Instance.new("UICorner")
            BallCorner.CornerRadius = UDim.new(1, 0)
            BallCorner.Parent = BallFrame

            -- FIXED DRAG LOGIC
            local Dragging = false

            local function Update(input)
                local SizeX = BackgroundFrame.AbsoluteSize.X
                local OffsetX = math.clamp(input.Position.X - BackgroundFrame.AbsolutePosition.X, 0, SizeX)
                local Percentage = OffsetX / SizeX
                
                Value = math.floor(((Max - Min) * Percentage + Min) / Increment + 0.5) * Increment
                Value = math.clamp(Value, Min, Max)
                
                local VisualPercentage = (Value - Min) / (Max - Min)
                
                TweenService:Create(FillFrame, TweenInfo.new(0.05), {Size = UDim2.new(VisualPercentage, 0, 1, 0)}):Play()
                TweenService:Create(BallFrame, TweenInfo.new(0.05), {Position = UDim2.new(VisualPercentage, -7, 0.5, -7)}):Play()
                
                ValueInput.Text = tostring(Value)
                Callback(Value)
            end

            BallFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                end
            end)

            BackgroundFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                    Update(input)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    Update(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = false
                end
            end)

            ValueInput.FocusLost:Connect(function()
                local InputValue = tonumber(ValueInput.Text)
                if InputValue then
                    Value = math.clamp(math.floor(InputValue / Increment + 0.5) * Increment, Min, Max)
                    local VisualPercentage = (Value - Min) / (Max - Min)
                    TweenService:Create(FillFrame, TweenInfo.new(0.2), {Size = UDim2.new(VisualPercentage, 0, 1, 0)}):Play()
                    TweenService:Create(BallFrame, TweenInfo.new(0.2), {Position = UDim2.new(VisualPercentage, -7, 0.5, -7)}):Play()
                    ValueInput.Text = tostring(Value)
                    Callback(Value)
                else
                    ValueInput.Text = tostring(Value)
                end
            end)
            
            return {
                SetValue = function(NewValue)
                    Value = math.clamp(NewValue, Min, Max)
                    local VisualPercentage = (Value - Min) / (Max - Min)
                    TweenService:Create(FillFrame, TweenInfo.new(0.2), {Size = UDim2.new(VisualPercentage, 0, 1, 0)}):Play()
                    TweenService:Create(BallFrame, TweenInfo.new(0.2), {Position = UDim2.new(VisualPercentage, -7, 0.5, -7)}):Play()
                    ValueInput.Text = tostring(Value)
                    Callback(Value)
                end,
                GetValue = function()
                    return Value
                end
            }
        end

        function TabFunctions:TextBox(Options, Parent)
            Parent = Parent or PageFrame
            local TextBoxName = Options.Name or "TextBox"
            local Default = Options.Default or ""
            local Placeholder = Options.Placeholder or "Enter text..."
            local Callback = Options.Callback or function() end

            local TextBoxFrame = Instance.new("Frame")
            TextBoxFrame.Parent = Parent
            TextBoxFrame.BackgroundColor3 = Astral.Theme.Main
            TextBoxFrame.BackgroundTransparency = 0.3
            TextBoxFrame.Size = UDim2.new(1, 0, 0, 44)
            
            local TextBoxCorner = Instance.new("UICorner")
            TextBoxCorner.CornerRadius = UDim.new(0, 6)
            TextBoxCorner.Parent = TextBoxFrame

            local TextBoxLabel = Instance.new("TextLabel")
            TextBoxLabel.Parent = TextBoxFrame
            TextBoxLabel.BackgroundTransparency = 1
            TextBoxLabel.Position = UDim2.new(0, 12, 0, 4)
            TextBoxLabel.Size = UDim2.new(1, -24, 0, 16)
            TextBoxLabel.Font = Enum.Font.GothamMedium
            TextBoxLabel.Text = TextBoxName
            TextBoxLabel.TextColor3 = Astral.Theme.Text
            TextBoxLabel.TextSize = 12
            TextBoxLabel.TextXAlignment = Enum.TextXAlignment.Left

            local InputBox = Instance.new("TextBox")
            InputBox.Parent = TextBoxFrame
            InputBox.BackgroundColor3 = Astral.Theme.Tertiary
            InputBox.BackgroundTransparency = 0.3
            InputBox.Position = UDim2.new(0, 12, 0, 24)
            InputBox.Size = UDim2.new(1, -24, 0, 16)
            InputBox.Font = Enum.Font.Gotham
            InputBox.PlaceholderText = Placeholder
            InputBox.PlaceholderColor3 = Astral.Theme.TextDarker
            InputBox.Text = Default
            InputBox.TextColor3 = Astral.Theme.Text
            InputBox.TextSize = 11
            InputBox.TextXAlignment = Enum.TextXAlignment.Left
            InputBox.ClearTextOnFocus = false
            
            local InputCorner = Instance.new("UICorner")
            InputCorner.CornerRadius = UDim.new(0, 4)
            InputCorner.Parent = InputBox

            InputBox.FocusLost:Connect(function(EnterPressed) 
                if EnterPressed then 
                    Callback(InputBox.Text) 
                end 
            end)
            
            return {
                SetText = function(Text)
                    InputBox.Text = Text
                end,
                GetText = function()
                    return InputBox.Text
                end
            }
        end

        function TabFunctions:Dropdown(Options, Parent)
            Parent = Parent or PageFrame
            local DropdownName = Options.Name or "Dropdown"
            local DropdownOptions = Options.Options or {"Option 1", "Option 2"}
            local Default = Options.Default or DropdownOptions[1]
            local Callback = Options.Callback or function() end
            local Dropped = false
            local Selected = Default

            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Parent = Parent
            DropdownFrame.BackgroundColor3 = Astral.Theme.Main
            DropdownFrame.BackgroundTransparency = 0.3
            DropdownFrame.Size = UDim2.new(1, 0, 0, 34)
            DropdownFrame.ClipsDescendants = true
            
            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 6)
            DropdownCorner.Parent = DropdownFrame

            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Parent = DropdownFrame
            DropdownButton.BackgroundTransparency = 1
            DropdownButton.Size = UDim2.new(1, 0, 0, 34)
            DropdownButton.Text = ""

            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Parent = DropdownButton
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Position = UDim2.new(0, 12, 0, 0)
            DropdownLabel.Size = UDim2.new(1, -40, 1, 0)
            DropdownLabel.Font = Enum.Font.GothamMedium
            DropdownLabel.Text = DropdownName .. ": " .. Selected
            DropdownLabel.TextColor3 = Astral.Theme.Text
            DropdownLabel.TextSize = 12
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left

            local ArrowImage = Instance.new("ImageLabel")
            ArrowImage.Parent = DropdownButton
            ArrowImage.BackgroundTransparency = 1
            ArrowImage.Position = UDim2.new(1, -26, 0.5, -6)
            ArrowImage.Size = UDim2.new(0, 12, 0, 12)
            ArrowImage.Image = "rbxassetid://6031091004"
            ArrowImage.ImageColor3 = Astral.Theme.Accent

            local DropdownList = Instance.new("ScrollingFrame")
            DropdownList.Parent = DropdownFrame
            DropdownList.BackgroundTransparency = 1
            DropdownList.Position = UDim2.new(0, 6, 0, 38)
            DropdownList.Size = UDim2.new(1, -12, 0, 120)
            DropdownList.ScrollBarThickness = 2
            DropdownList.ScrollBarImageColor3 = Astral.Theme.Accent
            DropdownList.BorderSizePixel = 0
            DropdownList.Visible = false

            local DropdownLayout = Instance.new("UIListLayout")
            DropdownLayout.Parent = DropdownList
            DropdownLayout.Padding = UDim.new(0, 3)

            local function Refresh()
                for _, Child in pairs(DropdownList:GetChildren()) do
                    if Child:IsA("TextButton") then 
                        Child:Destroy() 
                    end
                end
                for _, Option in pairs(DropdownOptions) do
                    local OptionButton = Instance.new("TextButton")
                    OptionButton.Parent = DropdownList
                    OptionButton.BackgroundColor3 = (Option == Selected) and Astral.Theme.Accent or Astral.Theme.Tertiary
                    OptionButton.BackgroundTransparency = 0.3
                    OptionButton.Size = UDim2.new(1, 0, 0, 26)
                    OptionButton.Font = Enum.Font.Gotham
                    OptionButton.Text = Option
                    OptionButton.TextColor3 = (Option == Selected) and Astral.Theme.Text or Astral.Theme.TextDark
                    OptionButton.TextSize = 11
                    
                    local OptionCorner = Instance.new("UICorner")
                    OptionCorner.CornerRadius = UDim.new(0, 4)
                    OptionCorner.Parent = OptionButton
                    
                    AddHoverEffect(OptionButton, Astral.Theme.HoverBright, 
                        (Option == Selected) and Astral.Theme.Accent or Astral.Theme.Tertiary, 0.1, 0.3)
                    AddClickEffect(OptionButton)
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        Selected = Option
                        Dropped = false
                        DropdownLabel.Text = DropdownName .. ": " .. Selected
                        Callback(Selected)
                        TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 34)}):Play()
                        TweenService:Create(ArrowImage, TweenInfo.new(0.2), {Rotation = 0}):Play()
                        DropdownList.Visible = false
                        Refresh()
                    end)
                end
                DropdownList.CanvasSize = UDim2.new(0, 0, 0, DropdownLayout.AbsoluteContentSize.Y + 6)
            end
            Refresh()

            DropdownButton.MouseButton1Click:Connect(function()
                Dropped = not Dropped
                local TargetSize = Dropped and UDim2.new(1, 0, 0, 164) or UDim2.new(1, 0, 0, 34)
                DropdownList.Visible = Dropped
                TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = TargetSize}):Play()
                TweenService:Create(ArrowImage, TweenInfo.new(0.2), {Rotation = Dropped and 180 or 0}):Play()
            end)
            
            return {
                SetOptions = function(NewOptions)
                    DropdownOptions = NewOptions
                    Selected = NewOptions[1] or Selected
                    DropdownLabel.Text = DropdownName .. ": " .. Selected
                    Refresh()
                end,
                SetSelected = function(Option)
                    if table.find(DropdownOptions, Option) then
                        Selected = Option
                        DropdownLabel.Text = DropdownName .. ": " .. Selected
                        Refresh()
                    end
                end,
                GetSelected = function()
                    return Selected
                end
            }
        end

        --// NEW: MULTI-SELECT DROPDOWN
        function TabFunctions:MultiDropdown(Options, Parent)
            Parent = Parent or PageFrame
            local DropdownName = Options.Name or "Multi Dropdown"
            local DropdownOptions = Options.Options or {"Option 1", "Option 2"}
            local Default = Options.Default or {}
            local MinSelections = Options.MinSelections or 0
            local MaxSelections = Options.MaxSelections or #DropdownOptions
            local Callback = Options.Callback or function() end
            local Dropped = false
            local Selected = Default
            if type(Selected) ~= "table" then Selected = {Selected} end

            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Parent = Parent
            DropdownFrame.BackgroundColor3 = Astral.Theme.Main
            DropdownFrame.BackgroundTransparency = 0.3
            DropdownFrame.Size = UDim2.new(1, 0, 0, 34)
            DropdownFrame.ClipsDescendants = true
            
            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 6)
            DropdownCorner.Parent = DropdownFrame

            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Parent = DropdownFrame
            DropdownButton.BackgroundTransparency = 1
            DropdownButton.Size = UDim2.new(1, 0, 0, 34)
            DropdownButton.Text = ""

            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Parent = DropdownButton
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Position = UDim2.new(0, 12, 0, 0)
            DropdownLabel.Size = UDim2.new(1, -40, 1, 0)
            DropdownLabel.Font = Enum.Font.GothamMedium
            DropdownLabel.Text = DropdownName .. ": " .. (#Selected > 0 and table.concat(Selected, ", ") or "None")
            DropdownLabel.TextColor3 = Astral.Theme.Text
            DropdownLabel.TextSize = 12
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropdownLabel.TextTruncate = Enum.TextTruncate.AtEnd

            local ArrowImage = Instance.new("ImageLabel")
            ArrowImage.Parent = DropdownButton
            ArrowImage.BackgroundTransparency = 1
            ArrowImage.Position = UDim2.new(1, -26, 0.5, -6)
            ArrowImage.Size = UDim2.new(0, 12, 0, 12)
            ArrowImage.Image = "rbxassetid://6031091004"
            ArrowImage.ImageColor3 = Astral.Theme.Accent

            local DropdownList = Instance.new("ScrollingFrame")
            DropdownList.Parent = DropdownFrame
            DropdownList.BackgroundTransparency = 1
            DropdownList.Position = UDim2.new(0, 6, 0, 38)
            DropdownList.Size = UDim2.new(1, -12, 0, 150)
            DropdownList.ScrollBarThickness = 2
            DropdownList.ScrollBarImageColor3 = Astral.Theme.Accent
            DropdownList.BorderSizePixel = 0
            DropdownList.Visible = false

            local DropdownLayout = Instance.new("UIListLayout")
            DropdownLayout.Parent = DropdownList
            DropdownLayout.Padding = UDim.new(0, 3)

            local SelectionCounter = Instance.new("TextLabel")
            SelectionCounter.Parent = DropdownList
            SelectionCounter.BackgroundTransparency = 1
            SelectionCounter.Size = UDim2.new(1, 0, 0, 20)
            SelectionCounter.Font = Enum.Font.Gotham
            SelectionCounter.Text = "Selected: " .. #Selected .. "/" .. MaxSelections
            SelectionCounter.TextColor3 = Astral.Theme.TextDark
            SelectionCounter.TextSize = 10
            SelectionCounter.TextXAlignment = Enum.TextXAlignment.Center

            local function UpdateLabel()
                local displayText = (#Selected > 0 and table.concat(Selected, ", ") or "None")
                if #displayText > 25 then
                    displayText = string.sub(displayText, 1, 22) .. "..."
                end
                DropdownLabel.Text = DropdownName .. ": " .. displayText
                SelectionCounter.Text = "Selected: " .. #Selected .. "/" .. MaxSelections
                Callback(Selected)
            end

            local function ToggleSelection(Option)
                local index = table.find(Selected, Option)
                if index then
                    if #Selected > MinSelections then
                        table.remove(Selected, index)
                    else
                        WindowFunctions:Notify({
                            Title = "Warning",
                            Content = "Minimum " .. MinSelections .. " selections required",
                            Type = "Warning",
                            Duration = 2
                        })
                        return
                    end
                else
                    if #Selected < MaxSelections then
                        table.insert(Selected, Option)
                    else
                        WindowFunctions:Notify({
                            Title = "Warning",
                            Content = "Maximum " .. MaxSelections .. " selections allowed",
                            Type = "Warning",
                            Duration = 2
                        })
                        return
                    end
                end
                UpdateLabel()
            end

            local function Refresh()
                for _, Child in pairs(DropdownList:GetChildren()) do
                    if Child:IsA("TextButton") then 
                        Child:Destroy() 
                    end
                end
                
                -- Add search box for multi-dropdown
                local SearchFrame = Instance.new("Frame")
                SearchFrame.Parent = DropdownList
                SearchFrame.BackgroundColor3 = Astral.Theme.Tertiary
                SearchFrame.BackgroundTransparency = 0.3
                SearchFrame.Size = UDim2.new(1, 0, 0, 26)
                
                local SearchCorner = Instance.new("UICorner")
                SearchCorner.CornerRadius = UDim.new(0, 4)
                SearchCorner.Parent = SearchFrame
                
                local SearchBox = Instance.new("TextBox")
                SearchBox.Parent = SearchFrame
                SearchBox.BackgroundTransparency = 1
                SearchBox.Position = UDim2.new(0, 8, 0, 0)
                SearchBox.Size = UDim2.new(1, -16, 1, 0)
                SearchBox.Font = Enum.Font.Gotham
                SearchBox.PlaceholderText = "Search options..."
                SearchBox.PlaceholderColor3 = Astral.Theme.TextDarker
                SearchBox.Text = ""
                SearchBox.TextColor3 = Astral.Theme.Text
                SearchBox.TextSize = 11
                SearchBox.TextXAlignment = Enum.TextXAlignment.Left
                
                local OptionsFrame = Instance.new("Frame")
                OptionsFrame.Parent = DropdownList
                OptionsFrame.BackgroundTransparency = 1
                OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
                OptionsFrame.AutomaticSize = Enum.AutomaticSize.Y
                
                local OptionsLayout = Instance.new("UIListLayout")
                OptionsLayout.Parent = OptionsFrame
                OptionsLayout.Padding = UDim.new(0, 3)
                
                local function FilterOptions()
                    local searchTerm = SearchBox.Text:lower()
                    for _, OptionButton in pairs(OptionsFrame:GetChildren()) do
                        if OptionButton:IsA("TextButton") then
                            OptionButton.Visible = searchTerm == "" or OptionButton.Name:lower():find(searchTerm)
                        end
                    end
                end
                
                SearchBox:GetPropertyChangedSignal("Text"):Connect(FilterOptions)
                
                for _, Option in pairs(DropdownOptions) do
                    local OptionButton = Instance.new("TextButton")
                    OptionButton.Parent = OptionsFrame
                    OptionButton.Name = Option
                    OptionButton.BackgroundColor3 = table.find(Selected, Option) and Astral.Theme.Accent or Astral.Theme.Tertiary
                    OptionButton.BackgroundTransparency = 0.3
                    OptionButton.Size = UDim2.new(1, 0, 0, 26)
                    OptionButton.Font = Enum.Font.Gotham
                    OptionButton.Text = Option
                    OptionButton.TextColor3 = table.find(Selected, Option) and Astral.Theme.Text or Astral.Theme.TextDark
                    OptionButton.TextSize = 11
                    
                    local OptionCorner = Instance.new("UICorner")
                    OptionCorner.CornerRadius = UDim.new(0, 4)
                    OptionCorner.Parent = OptionButton
                    
                    local CheckIcon = Instance.new("ImageLabel")
                    CheckIcon.Parent = OptionButton
                    CheckIcon.BackgroundTransparency = 1
                    CheckIcon.Position = UDim2.new(1, -24, 0.5, -8)
                    CheckIcon.Size = UDim2.new(0, 16, 0, 16)
                    CheckIcon.Image = Astral.Icons.Check
                    CheckIcon.ImageColor3 = table.find(Selected, Option) and Astral.Theme.Text or Color3.fromRGB(100, 100, 100)
                    CheckIcon.ImageTransparency = table.find(Selected, Option) and 0 or 0.5
                    
                    AddHoverEffect(OptionButton, Astral.Theme.HoverBright, 
                        table.find(Selected, Option) and Astral.Theme.Accent or Astral.Theme.Tertiary, 0.1, 0.3)
                    AddClickEffect(OptionButton)
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        ToggleSelection(Option)
                        OptionButton.BackgroundColor3 = table.find(Selected, Option) and Astral.Theme.Accent or Astral.Theme.Tertiary
                        OptionButton.TextColor3 = table.find(Selected, Option) and Astral.Theme.Text or Astral.Theme.TextDark
                        CheckIcon.ImageColor3 = table.find(Selected, Option) and Astral.Theme.Text or Color3.fromRGB(100, 100, 100)
                        CheckIcon.ImageTransparency = table.find(Selected, Option) and 0 or 0.5
                    end)
                end
                
                OptionsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    OptionsFrame.Size = UDim2.new(1, 0, 0, OptionsLayout.AbsoluteContentSize.Y)
                end)
                
                DropdownList.CanvasSize = UDim2.new(0, 0, 0, DropdownLayout.AbsoluteContentSize.Y + 10)
            end
            Refresh()
            UpdateLabel()

            DropdownButton.MouseButton1Click:Connect(function()
                Dropped = not Dropped
                local rowHeight = 26
                local visibleRows = math.min(#DropdownOptions + 2, 6) -- Show max 6 rows
                local totalHeight = 34 + (visibleRows * (rowHeight + 3)) + 30
                local TargetSize = Dropped and UDim2.new(1, 0, 0, totalHeight) or UDim2.new(1, 0, 0, 34)
                DropdownList.Visible = Dropped
                TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = TargetSize}):Play()
                TweenService:Create(ArrowImage, TweenInfo.new(0.2), {Rotation = Dropped and 180 or 0}):Play()
            end)
            
            return {
                SetOptions = function(NewOptions)
                    DropdownOptions = NewOptions
                    -- Remove selections that are no longer in options
                    local newSelected = {}
                    for _, sel in ipairs(Selected) do
                        if table.find(NewOptions, sel) then
                            table.insert(newSelected, sel)
                        end
                    end
                    Selected = newSelected
                    MaxSelections = math.min(MaxSelections, #NewOptions)
                    Refresh()
                    UpdateLabel()
                end,
                SetSelected = function(Selections)
                    if type(Selections) ~= "table" then Selections = {Selections} end
                    Selected = {}
                    for _, sel in ipairs(Selections) do
                        if table.find(DropdownOptions, sel) and #Selected < MaxSelections then
                            table.insert(Selected, sel)
                        end
                    end
                    Refresh()
                    UpdateLabel()
                end,
                GetSelected = function()
                    return Selected
                end,
                Clear = function()
                    Selected = {}
                    Refresh()
                    UpdateLabel()
                end
            }
        end

        function TabFunctions:Keybind(Options, Parent)
            Parent = Parent or PageFrame
            local KeybindName = Options.Name or "Keybind"
            local Default = Options.Default or Enum.KeyCode.E
            local Callback = Options.Callback or function() end
            local Current = Default

            local KeybindFrame = Instance.new("Frame")
            KeybindFrame.Parent = Parent
            KeybindFrame.BackgroundColor3 = Astral.Theme.Main
            KeybindFrame.BackgroundTransparency = 0.3
            KeybindFrame.Size = UDim2.new(1, 0, 0, 34)
            
            local KeybindCorner = Instance.new("UICorner")
            KeybindCorner.CornerRadius = UDim.new(0, 6)
            KeybindCorner.Parent = KeybindFrame
            
            AddHoverEffect(KeybindFrame, Astral.Theme.HoverBright, Astral.Theme.Main, 0.1, 0.3)

            local KeybindLabel = Instance.new("TextLabel")
            KeybindLabel.Parent = KeybindFrame
            KeybindLabel.BackgroundTransparency = 1
            KeybindLabel.Position = UDim2.new(0, 12, 0, 0)
            KeybindLabel.Size = UDim2.new(1, -90, 1, 0)
            KeybindLabel.Font = Enum.Font.GothamMedium
            KeybindLabel.Text = KeybindName
            KeybindLabel.TextColor3 = Astral.Theme.Text
            KeybindLabel.TextSize = 12
            KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left

            local KeybindButton = Instance.new("TextButton")
            KeybindButton.Parent = KeybindFrame
            KeybindButton.BackgroundColor3 = Astral.Theme.Tertiary
            KeybindButton.BackgroundTransparency = 0.3
            KeybindButton.Position = UDim2.new(1, -70, 0.5, -12)
            KeybindButton.Size = UDim2.new(0, 58, 0, 24)
            KeybindButton.Font = Enum.Font.GothamBold
            KeybindButton.Text = Current.Name
            KeybindButton.TextColor3 = Astral.Theme.Accent
            KeybindButton.TextSize = 10
            KeybindButton.AutoButtonColor = false
            
            local KeybindButtonCorner = Instance.new("UICorner")
            KeybindButtonCorner.CornerRadius = UDim.new(0, 4)
            KeybindButtonCorner.Parent = KeybindButton
            
            AddClickEffect(KeybindButton)

            local Binding = false
            KeybindButton.MouseButton1Click:Connect(function()
                Binding = true
                KeybindButton.Text = "..."
                KeybindButton.TextColor3 = Astral.Theme.Warning
            end)

            UserInputService.InputBegan:Connect(function(input, GameProcessed)
                if not GameProcessed and Binding and input.UserInputType == Enum.UserInputType.Keyboard then
                    Current = input.KeyCode
                    KeybindButton.Text = Current.Name
                    KeybindButton.TextColor3 = Astral.Theme.Accent
                    Binding = false
                    Callback(Current)
                elseif not GameProcessed and input.KeyCode == Current then
                    Callback(Current)
                end
            end)
            
            return {
                SetKey = function(Key)
                    Current = Key
                    KeybindButton.Text = Current.Name
                    Callback(Current)
                end,
                GetKey = function()
                    return Current
                end
            }
        end

        function TabFunctions:Label(Options, Parent)
            Parent = Parent or PageFrame
            local LabelText = Options.Text or "Label"

            local LabelFrame = Instance.new("Frame")
            LabelFrame.Parent = Parent
            LabelFrame.BackgroundColor3 = Astral.Theme.Main
            LabelFrame.BackgroundTransparency = 0.3
            LabelFrame.Size = UDim2.new(1, 0, 0, 30)
            
            local LabelCorner = Instance.new("UICorner")
            LabelCorner.CornerRadius = UDim.new(0, 6)
            LabelCorner.Parent = LabelFrame

            local Label = Instance.new("TextLabel")
            Label.Parent = LabelFrame
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.Size = UDim2.new(1, -24, 1, 0)
            Label.Font = Enum.Font.Gotham
            Label.Text = LabelText
            Label.TextColor3 = Astral.Theme.TextDark
            Label.TextSize = 11
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.TextWrapped = true

            return {
                SetText = function(Text) 
                    Label.Text = Text 
                end
            }
        end

        return TabFunctions
    end

    return WindowFunctions
end

--// ENHANCED DEMO USAGE
local Window = Astral:Window({
    Name = "Astral Hub V3"
})

-- Show welcome notification
task.wait(0.5)
Window:Notify({
    Title = "Welcome to Astral V3!",
    Content = "Enhanced UI Library with beautiful notifications and multi-select dropdowns",
    Duration = 5,
    Type = "Success"
})

-- Combat Tab
local CombatTab = Window:Tab({
    Name = "Combat", 
    Icon = "rbxassetid://7733955511"
})

local MainSection = CombatTab:Section({
    Name = "⚔️ Main Features"
})

-- Button with callback that shows notification
local KillButton = MainSection:Button({
    Name = "Kill All Players", 
    Callback = function() 
        Window:Notify({
            Title = "Combat Action",
            Content = "Kill All command executed successfully!",
            Type = "Success",
            Duration = 3
        })
    end
})

-- Toggle with state tracking
local AutoAttackToggle = MainSection:Toggle({
    Name = "Auto Attack", 
    Default = false,
    Callback = function(Value) 
        Window:Notify({
            Title = "Combat",
            Content = "Auto Attack: " .. (Value and "ENABLED" or "DISABLED"),
            Type = Value and "Success" or "Warning",
            Duration = 2
        })
    end
})

-- Slider with value display
local SpeedSlider = MainSection:Slider({
    Name = "Attack Speed", 
    Min = 1, 
    Max = 500, 
    Default = 100,
    Increment = 5,
    Callback = function(Value) 
        print("Attack Speed set to:", Value)
    end
})

-- Movement Section in Combat Tab
local DefenseSection = CombatTab:Section({
    Name = "🛡️ Defense"
})

-- Regular dropdown
local ModeDropdown = DefenseSection:Dropdown({
    Name = "Combat Mode", 
    Options = {"Normal", "Aggressive", "Defensive", "Stealth", "Berserk"}, 
    Default = "Normal",
    Callback = function(Value) 
        Window:Notify({
            Title = "Mode Changed",
            Content = "Combat mode set to: " .. Value,
            Type = "Info",
            Duration = 2
        })
    end
})

-- Multi-select dropdown with constraints
local WeaponDropdown = DefenseSection:MultiDropdown({
    Name = "Weapons", 
    Options = {"Sword", "Bow", "Staff", "Dagger", "Shield", "Axe", "Spear", "Hammer"},
    Default = {"Sword", "Shield"},
    MinSelections = 1,
    MaxSelections = 3,
    Callback = function(Selected) 
        Window:Notify({
            Title = "Weapons Updated",
            Content = "Selected: " .. table.concat(Selected, ", "),
            Type = "Info",
            Duration = 3
        })
    end
})

-- Utility Tab
local UtilityTab = Window:Tab({
    Name = "Utility", 
    Icon = "rbxassetid://7733955201"
})

local SettingsSection = UtilityTab:Section({
    Name = "⚙️ Settings"
})

-- TextBox for input
local NameInput = SettingsSection:TextBox({
    Name = "Player Name",
    Placeholder = "Enter your username...",
    Default = "",
    Callback = function(Text)
        Window:Notify({
            Title = "Name Updated",
            Content = "Hello, " .. (Text ~= "" and Text or "Anonymous") .. "!",
            Type = "Success",
            Duration = 3
        })
    end
})

-- Keybind for quick actions
local TeleportKeybind = SettingsSection:Keybind({
    Name = "Teleport Key",
    Default = Enum.KeyCode.T,
    Callback = function(Key)
        Window:Notify({
            Title = "Keybind Pressed",
            Content = "Teleport key (" .. Key.Name .. ") activated!",
            Type = "Info",
            Duration = 2
        })
    end
})

-- Another multi-select dropdown with different constraints
local TeleportLocations = SettingsSection:MultiDropdown({
    Name = "Teleport Locations", 
    Options = {"Spawn", "Market", "Castle", "Dungeon", "Forest", "Mountain", "Beach", "City"},
    Default = {"Spawn"},
    MinSelections = 1,
    MaxSelections = 5,
    Callback = function(Selected) 
        print("Teleport locations selected:", #Selected, "locations")
    end
})

-- Visual Tab
local VisualTab = Window:Tab({
    Name = "Visual", 
    Icon = "rbxassetid://7733954901"
})

local EffectsSection = VisualTab:Section({
    Name = "✨ Visual Effects"
})

EffectsSection:Button({
    Name = "Rainbow Effects",
    Callback = function()
        for i = 1, 3 do
            task.wait(0.3)
            Window:Notify({
                Title = "Visual Effect " .. i,
                Content = "Applying rainbow effect...",
                Type = i == 3 and "Success" or "Info",
                Duration = 2
            })
        end
    end
})

local QualitySlider = EffectsSection:Slider({
    Name = "Effect Quality", 
    Min = 1, 
    Max = 10, 
    Default = 5,
    Increment = 1,
    Callback = function(Value) 
        print("Effect quality set to:", Value)
    end
})

-- Label for information
local InfoLabel = EffectsSection:Label({
    Text = "Visual effects may impact performance on lower-end devices."
})

-- Demo notifications
task.wait(2)
Window:Notify({
    Title = "System Info",
    Content = "All UI elements loaded and ready!",
    Duration = 4,
    Type = "Info"
})

task.wait(1)
Window:Notify({
    Title = "Tip",
    Content = "Try selecting multiple weapons in the Combat tab!",
    Duration = 5,
    Type = "Warning"
})

task.wait(1.5)
Window:Notify({
    Title = "Multi-Select Demo",
    Content = "You can select 1-3 weapons and 1-5 teleport locations",
    Duration = 5,
    Type = "Success"
})

-- Function to test notification queue
task.spawn(function()
    for i = 1, 8 do
        task.wait(0.8)
        Window:Notify({
            Title = "Queue Test " .. i,
            Content = "This shows notification queuing system",
            Duration = 2,
            Type = i % 4 == 0 and "Error" or (i % 3 == 0 and "Warning" or (i % 2 == 0 and "Success" or "Info"))
        })
    end
end)

print("Astral V3 UI Library loaded successfully!")