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
}

-- Prevent duplicate GUIs
if CoreGui:FindFirstChild("AstralUI") then 
    for _, child in pairs(CoreGui:GetChildren()) do
        if child.Name == "AstralLib" or child.Name == "AstralBubble" then
            child:Destroy()
        end
    end
    
    -- Also check for any notifications or other UI elements
    for _, child in pairs(CoreGui:GetChildren()) do
        if child:IsA("ScreenGui") and (child.Name:find("Astral") or child.Name:find("Notification")) then
            child:Destroy()
        end
    end 
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

local function CenterElement(ScrollingFrame, Element)
    if not ScrollingFrame or not Element then return end
    
    local RelativeY = Element.AbsolutePosition.Y - ScrollingFrame.AbsolutePosition.Y
    
    local TargetY = ScrollingFrame.CanvasPosition.Y + RelativeY - (ScrollingFrame.AbsoluteSize.Y / 2) + (Element.AbsoluteSize.Y / 2)
    
    TweenService:Create(ScrollingFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        CanvasPosition = Vector2.new(0, math.clamp(TargetY, 0, ScrollingFrame.CanvasSize.Y.Offset))
    }):Play()
end

--// MAIN WINDOW
function Astral:Window(Options)
    local Name = Options.Name or "Astral"
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AstralUI"
    ScreenGui.Parent = CoreGui
    ScreenGui.DisplayOrder = 999
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

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
    MainFrame.Active = true

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

    -- Minimize button
    local MinimizeButton = MakeButton("−", UDim2.new(1, -64, 0.5, -14), Astral.Theme.TextDark)
    MinimizeButton.TextSize = 16
    MinimizeButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)

    -- Floating bubble
    local Bubble = Instance.new("TextButton")
    Bubble.Name = "AstralBubble"
    Bubble.Parent = ScreenGui
    Bubble.BackgroundColor3 = Astral.Theme.Main
    -- Spawn in the middle of the right side
    Bubble.Position = UDim2.new(1, -60, 0.5, -25)
    Bubble.Size = UDim2.new(0, 50, 0, 50)
    Bubble.ZIndex = 500
    Bubble.Text = ""
    Bubble.AutoButtonColor = false
    
    local BubbleCorner = Instance.new("UICorner")
    BubbleCorner.CornerRadius = UDim.new(1, 0)
    BubbleCorner.Parent = Bubble
    
    local BubbleIcon = Instance.new("ImageLabel")
    BubbleIcon.Parent = Bubble
    BubbleIcon.BackgroundTransparency = 1
    BubbleIcon.Position = UDim2.new(0.5, -12, 0.5, -12)
    BubbleIcon.Size = UDim2.new(0, 24, 0, 24)
    BubbleIcon.Image = Options.Icon or "rbxassetid://7733954760"
    BubbleIcon.ImageColor3 = Astral.Theme.Accent

    local BubbleStroke = Instance.new("UIStroke")
    BubbleStroke.Thickness = 2
    BubbleStroke.Color = Astral.Theme.Stroke
    BubbleStroke.Parent = Bubble

    local BubbleDragging = false
    local DragInput, DragStart, StartPos

    local function SnapToSide()
        local ScreenSize = ScreenGui.AbsoluteSize
        local CurrentPos = Bubble.AbsolutePosition
        local CenterX = ScreenSize.X / 2
        
        local TargetX = (CurrentPos.X + 25 < CenterX) and 10 or (ScreenSize.X - 60)
        
        local TargetY = math.clamp(CurrentPos.Y, 10, ScreenSize.Y - 60)
        
        if TargetY < 100 then TargetY = 10 end
        if TargetY > ScreenSize.Y - 160 then TargetY = ScreenSize.Y - 60 end

        TweenService:Create(Bubble, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, TargetX, 0, TargetY)
        }):Play()
    end

    Bubble.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            BubbleDragging = true
            DragStart = input.Position
            StartPos = Bubble.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    BubbleDragging = false
                    SnapToSide()
                end
            end)
        end
    end)

    Bubble.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and BubbleDragging then
            local Delta = input.Position - DragStart
            Bubble.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
        end
    end)

    Bubble.MouseButton1Click:Connect(function()
        if (StartPos.X.Offset - Bubble.Position.X.Offset) < 5 then
            MainFrame.Visible = not MainFrame.Visible
        end
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
    TabContainer.ScrollingDirection = Enum.ScrollingDirection.Y
    TabContainer.VerticalScrollBarInset = Enum.ScrollBarInset.Always

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

    --// NOTIFICATION LOGIC
    local function UpdateNotificationPositions()
        for Index, Notification in ipairs(ActiveNotifications) do
            local TargetYOffset = -20 - ((Index - 1) * 80) 
            
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
            Position = UDim2.new(1, 20, NotificationFrame.Position.Y.Scale, NotificationFrame.Position.Y.Offset)
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
            Info = Astral.Theme.Accent,
            Success = Astral.Theme.Success,
            Warning = Astral.Theme.Warning,
            Error = Astral.Theme.Error
        }

        if #ActiveNotifications >= MaxNotifications then
            table.insert(NotificationQueue, Options)
            return
        end

        local NotificationFrame = Instance.new("Frame")
        NotificationFrame.Parent = ScreenGui
        NotificationFrame.BackgroundColor3 = Astral.Theme.Main
        NotificationFrame.BackgroundTransparency = 0.1
        NotificationFrame.Size = UDim2.new(0, 300, 0, 70)
        

        NotificationFrame.AnchorPoint = Vector2.new(1, 1)
        NotificationFrame.Position = UDim2.new(1.5, 0, 1, -20)
        NotificationFrame.ZIndex = 100

        local NotificationCorner = Instance.new("UICorner")
        NotificationCorner.CornerRadius = UDim.new(0, 8)
        NotificationCorner.Parent = NotificationFrame

        local NotificationStroke = Instance.new("UIStroke")
        NotificationStroke.Color = TypeColors[Type]
        NotificationStroke.Thickness = 1.5
        NotificationStroke.Transparency = 0.5
        NotificationStroke.Parent = NotificationFrame

        local NotificationTitle = Instance.new("TextLabel")
        NotificationTitle.Parent = NotificationFrame
        NotificationTitle.BackgroundTransparency = 1
        NotificationTitle.Position = UDim2.new(0, 12, 0, 8)
        NotificationTitle.Size = UDim2.new(1, -24, 0, 18)
        NotificationTitle.Font = Enum.Font.GothamBold
        NotificationTitle.Text = Title
        NotificationTitle.TextColor3 = Astral.Theme.Text
        NotificationTitle.TextSize = 13
        NotificationTitle.TextXAlignment = Enum.TextXAlignment.Left

        local NotificationContent = Instance.new("TextLabel")
        NotificationContent.Parent = NotificationFrame
        NotificationContent.BackgroundTransparency = 1
        NotificationContent.Position = UDim2.new(0, 12, 0, 28)
        NotificationContent.Size = UDim2.new(1, -24, 1, -36)
        NotificationContent.Font = Enum.Font.Gotham
        NotificationContent.Text = Content
        NotificationContent.TextColor3 = Astral.Theme.TextDark
        NotificationContent.TextSize = 11
        NotificationContent.TextXAlignment = Enum.TextXAlignment.Left
        NotificationContent.TextYAlignment = Enum.TextYAlignment.Top
        NotificationContent.TextWrapped = true

        table.insert(ActiveNotifications, NotificationFrame)
        UpdateNotificationPositions()

        task.delay(Duration, function()
            -- Exit animation
            local ExitTween = TweenService:Create(NotificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Position = UDim2.new(1.5, 0, 1, NotificationFrame.Position.Y.Offset),
                BackgroundTransparency = 1
            })
            
            ExitTween:Play()
            ExitTween.Completed:Connect(function()
                NotificationFrame:Destroy()
                -- Remove from active list and shift others down
                for i, v in ipairs(ActiveNotifications) do
                    if v == NotificationFrame then
                        table.remove(ActiveNotifications, i)
                        break
                    end
                end
                UpdateNotificationPositions()
                
                -- Check queue
                if #NotificationQueue > 0 then
                    local Next = table.remove(NotificationQueue, 1)
                    WindowFunctions:Notify(Next)
                end
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
        PageFrame.ScrollingDirection = Enum.ScrollingDirection.Y
        PageFrame.VerticalScrollBarInset = Enum.ScrollBarInset.Always
        PageFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

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
                    CenterElement(PageFrame, SliderFrame)
                end
            end)

            BackgroundFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                    CenterElement(PageFrame, SliderFrame)
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

            ValueInput.Focused:Connect(function()
                CenterElement(PageFrame, SliderFrame)
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

            InputBox.Focused:Connect(function()
                CenterElement(PageFrame, TextBoxFrame)
            end)

            InputBox.FocusLost:Connect(function(EnterPressed) 
                if EnterPressed then 
                    Callback(InputBox.Text) 
                end 
            end)
        end

        function TabFunctions:Dropdown(Options, Parent)
            Parent = Parent or PageFrame
            local DropdownName = Options.Name or "Dropdown"
            local DropdownOptions = Options.Options or {}
            local CurrentSelected = Options.Default or nil
            local Callback = Options.Callback or function() end
            local Dropped = false

            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Parent = Parent
            DropdownFrame.BackgroundColor3 = Astral.Theme.Main
            DropdownFrame.BackgroundTransparency = 0.3
            DropdownFrame.Size = UDim2.new(1, 0, 0, 34)
            DropdownFrame.ClipsDescendants = true
            Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0, 6)

            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Parent = DropdownFrame
            DropdownButton.BackgroundTransparency = 1
            DropdownButton.Size = UDim2.new(1, 0, 0, 34)
            DropdownButton.Text = ""

            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Parent = DropdownButton
            DropdownLabel.Position = UDim2.new(0, 12, 0, 0)
            DropdownLabel.Size = UDim2.new(1, -40, 1, 0)
            DropdownLabel.Font = Enum.Font.GothamMedium
            DropdownLabel.Text = DropdownName .. (CurrentSelected and (": " .. tostring(CurrentSelected)) or "")
            DropdownLabel.TextColor3 = Astral.Theme.Text
            DropdownLabel.TextSize = 12
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropdownLabel.BackgroundTransparency = 1

            local ArrowImage = Instance.new("ImageLabel")
            ArrowImage.Parent = DropdownButton
            ArrowImage.BackgroundTransparency = 1
            ArrowImage.Position = UDim2.new(1, -26, 0.5, -6)
            ArrowImage.Size = UDim2.new(0, 12, 0, 12)
            ArrowImage.Image = "rbxassetid://6031091004"
            ArrowImage.ImageColor3 = Astral.Theme.Accent

            local Header = Instance.new("Frame")
            Header.Parent = DropdownFrame
            Header.Position = UDim2.new(0, 6, 0, 38)
            Header.Size = UDim2.new(1, -12, 0, 28)
            Header.BackgroundTransparency = 1

            local SearchBox = Instance.new("TextBox")
            SearchBox.Parent = Header
            SearchBox.Size = UDim2.new(1, -50, 1, 0)
            SearchBox.BackgroundColor3 = Astral.Theme.Tertiary
            SearchBox.PlaceholderText = "Search..."
            SearchBox.Text = ""
            SearchBox.TextColor3 = Astral.Theme.Text
            SearchBox.Font = Enum.Font.Gotham
            SearchBox.TextSize = 11
            Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 4)

            local ClearBtn = Instance.new("TextButton")
            ClearBtn.Parent = Header
            ClearBtn.Position = UDim2.new(1, -45, 0, 0)
            ClearBtn.Size = UDim2.new(0, 45, 1, 0)
            ClearBtn.BackgroundColor3 = Astral.Theme.Error
            ClearBtn.BackgroundTransparency = 0.4
            ClearBtn.Text = "CLEAR"
            ClearBtn.Font = Enum.Font.GothamBold
            ClearBtn.TextColor3 = Astral.Theme.Text
            ClearBtn.TextSize = 9
            Instance.new("UICorner", ClearBtn).CornerRadius = UDim.new(0, 4)

            local DropdownList = Instance.new("ScrollingFrame")
            DropdownList.Parent = DropdownFrame
            DropdownList.BackgroundTransparency = 1
            DropdownList.Position = UDim2.new(0, 6, 0, 72)
            DropdownList.Size = UDim2.new(1, -12, 0, 100)
            DropdownList.ScrollBarThickness = 2
            DropdownList.BorderSizePixel = 0
            DropdownList.ScrollingDirection = Enum.ScrollingDirection.Y
            DropdownList.VerticalScrollBarInset = Enum.ScrollBarInset.Always

            local DropdownLayout = Instance.new("UIListLayout")
            DropdownLayout.Parent = DropdownList
            DropdownLayout.Padding = UDim.new(0, 3)

            local function Refresh(filter)
                for _, Child in pairs(DropdownList:GetChildren()) do
                    if Child:IsA("TextButton") then Child:Destroy() end
                end
                for _, Option in pairs(DropdownOptions) do
                    if filter and filter ~= "" and not string.find(string.lower(Option), string.lower(filter)) then continue end
                    
                    local IsSelected = (CurrentSelected == Option)
                    local OptionButton = Instance.new("TextButton")
                    OptionButton.Parent = DropdownList
                    OptionButton.BackgroundColor3 = IsSelected and Astral.Theme.Accent or Astral.Theme.Tertiary
                    OptionButton.Size = UDim2.new(1, 0, 0, 26)
                    OptionButton.Text = Option
                    OptionButton.TextColor3 = IsSelected and Astral.Theme.Main or Astral.Theme.Text
                    OptionButton.Font = Enum.Font.Gotham
                    OptionButton.TextSize = 11
                    Instance.new("UICorner", OptionButton).CornerRadius = UDim.new(0, 4)
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        CurrentSelected = Option
                        DropdownLabel.Text = DropdownName .. ": " .. Option
                        Callback(Option)
                        Refresh(SearchBox.Text)
                    end)
                end
                
                local ContentHeight = DropdownLayout.AbsoluteContentSize.Y
                DropdownList.CanvasSize = UDim2.new(0, 0, 0, ContentHeight)
                DropdownList.ScrollingEnabled = ContentHeight > 100
            end

            SearchBox:GetPropertyChangedSignal("Text"):Connect(function() Refresh(SearchBox.Text) end)
            
            ClearBtn.MouseButton1Click:Connect(function()
                CurrentSelected = nil
                DropdownLabel.Text = DropdownName
                Callback(nil)
                Refresh(SearchBox.Text)
            end)

            DropdownButton.MouseButton1Click:Connect(function()
                Dropped = not Dropped
                if Dropped then CenterElement(PageFrame, DropdownFrame) end
                TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = Dropped and UDim2.new(1, 0, 0, 180) or UDim2.new(1, 0, 0, 34)}):Play()
                TweenService:Create(ArrowImage, TweenInfo.new(0.2), {Rotation = Dropped and 180 or 0}):Play()
                if Dropped then Refresh() end
            end)
            Refresh()
        end

        function TabFunctions:MultiDropdown(Options, Parent)
            Parent = Parent or PageFrame
            local DropdownName = Options.Name or "Multi-Dropdown"
            local DropdownOptions = Options.Options or {}
            local Default = Options.Default or {}
            local Callback = Options.Callback or function() end
            local Max = Options.Max or #DropdownOptions
            local Min = Options.Min or 0
            
            local Selected = {}
            local SelectionOrder = {}
            local Dropped = false

            for _, v in pairs(Default) do 
                if #SelectionOrder < Max then
                    Selected[v] = true 
                    table.insert(SelectionOrder, v)
                end
            end

            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Parent = Parent
            DropdownFrame.BackgroundColor3 = Astral.Theme.Main
            DropdownFrame.BackgroundTransparency = 0.3
            DropdownFrame.Size = UDim2.new(1, 0, 0, 34)
            DropdownFrame.ClipsDescendants = true
            Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0, 6)

            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Parent = DropdownFrame
            DropdownButton.BackgroundTransparency = 1
            DropdownButton.Size = UDim2.new(1, 0, 0, 34)
            DropdownButton.Text = ""

            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Parent = DropdownButton
            DropdownLabel.Position = UDim2.new(0, 12, 0, 0)
            DropdownLabel.Size = UDim2.new(1, -45, 1, 0)
            DropdownLabel.Font = Enum.Font.GothamMedium
            DropdownLabel.TextColor3 = Astral.Theme.Text
            DropdownLabel.TextSize = 12
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.TextTruncate = Enum.TextTruncate.AtEnd

            local function UpdateLabel()
                if #SelectionOrder == 0 then
                    DropdownLabel.Text = DropdownName
                else
                    local combinedText = DropdownName .. ": " .. table.concat(SelectionOrder, ", ")
                    DropdownLabel.Text = combinedText
                end
            end
            UpdateLabel()

            local ArrowImage = Instance.new("ImageLabel")
            ArrowImage.Parent = DropdownButton
            ArrowImage.BackgroundTransparency = 1
            ArrowImage.Position = UDim2.new(1, -26, 0.5, -6)
            ArrowImage.Size = UDim2.new(0, 12, 0, 12)
            ArrowImage.Image = "rbxassetid://6031091004"
            ArrowImage.ImageColor3 = Astral.Theme.Accent

            local Header = Instance.new("Frame")
            Header.Parent = DropdownFrame
            Header.Position = UDim2.new(0, 6, 0, 38)
            Header.Size = UDim2.new(1, -12, 0, 58)
            Header.BackgroundTransparency = 1

            local SearchBox = Instance.new("TextBox")
            SearchBox.Parent = Header
            SearchBox.Size = UDim2.new(1, 0, 0, 25)
            SearchBox.BackgroundColor3 = Astral.Theme.Tertiary
            SearchBox.PlaceholderText = "Search options..."
            SearchBox.Text = ""
            SearchBox.TextColor3 = Astral.Theme.Text
            SearchBox.Font = Enum.Font.Gotham
            SearchBox.TextSize = 11
            Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 4)

            local SelectAllBtn = Instance.new("TextButton")
            SelectAllBtn.Parent = Header
            SelectAllBtn.Position = UDim2.new(0, 0, 0, 30)
            SelectAllBtn.Size = UDim2.new(0.5, -3, 0, 25)
            SelectAllBtn.BackgroundColor3 = Astral.Theme.Success
            SelectAllBtn.BackgroundTransparency = 0.4
            SelectAllBtn.Text = "SELECT ALL"
            SelectAllBtn.Font = Enum.Font.GothamBold
            SelectAllBtn.TextColor3 = Astral.Theme.Text
            SelectAllBtn.TextSize = 9
            Instance.new("UICorner", SelectAllBtn).CornerRadius = UDim.new(0, 4)

            local ClearAllBtn = Instance.new("TextButton")
            ClearAllBtn.Parent = Header
            ClearAllBtn.Position = UDim2.new(0.5, 3, 0, 30)
            ClearAllBtn.Size = UDim2.new(0.5, -3, 0, 25)
            ClearAllBtn.BackgroundColor3 = Astral.Theme.Error
            ClearAllBtn.BackgroundTransparency = 0.4
            ClearAllBtn.Text = "CLEAR ALL"
            ClearAllBtn.Font = Enum.Font.GothamBold
            ClearAllBtn.TextColor3 = Astral.Theme.Text
            ClearAllBtn.TextSize = 9
            Instance.new("UICorner", ClearAllBtn).CornerRadius = UDim.new(0, 4)

            local DropdownList = Instance.new("ScrollingFrame")
            DropdownList.Parent = DropdownFrame
            DropdownList.BackgroundTransparency = 1
            DropdownList.Position = UDim2.new(0, 6, 0, 100)
            DropdownList.Size = UDim2.new(1, -12, 0, 120)
            DropdownList.ScrollBarThickness = 2
            DropdownList.ScrollBarImageColor3 = Astral.Theme.Accent
            DropdownList.BorderSizePixel = 0
            DropdownList.ScrollingDirection = Enum.ScrollingDirection.Y
            DropdownList.VerticalScrollBarInset = Enum.ScrollBarInset.Always

            local DropdownLayout = Instance.new("UIListLayout")
            DropdownLayout.Parent = DropdownList
            DropdownLayout.Padding = UDim.new(0, 3)

            local function Refresh(filter)
                for _, Child in pairs(DropdownList:GetChildren()) do
                    if Child:IsA("TextButton") then Child:Destroy() end
                end
                for _, Option in pairs(DropdownOptions) do
                    if filter and filter ~= "" and not string.find(string.lower(Option), string.lower(filter)) then continue end
                    
                    local IsSelected = Selected[Option]
                    local OptionButton = Instance.new("TextButton")
                    OptionButton.Parent = DropdownList
                    OptionButton.BackgroundColor3 = IsSelected and Astral.Theme.Accent or Astral.Theme.Tertiary
                    OptionButton.Size = UDim2.new(1, 0, 0, 26)
                    OptionButton.Text = Option
                    OptionButton.TextColor3 = IsSelected and Astral.Theme.Main or Astral.Theme.Text
                    OptionButton.Font = Enum.Font.Gotham
                    OptionButton.TextSize = 11
                    Instance.new("UICorner", OptionButton).CornerRadius = UDim.new(0, 4)
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        if Selected[Option] then
                            if #SelectionOrder > Min then
                                Selected[Option] = false
                                for i, v in ipairs(SelectionOrder) do if v == Option then table.remove(SelectionOrder, i) break end end
                            end
                        elseif #SelectionOrder < Max then
                            Selected[Option] = true
                            table.insert(SelectionOrder, Option)
                        end
                        UpdateLabel()
                        Refresh(SearchBox.Text)
                        Callback(SelectionOrder)
                    end)
                end
                DropdownList.CanvasSize = UDim2.new(0, 0, 0, DropdownLayout.AbsoluteContentSize.Y + 5)
            end

            SearchBox:GetPropertyChangedSignal("Text"):Connect(function() Refresh(SearchBox.Text) end)

            SelectAllBtn.MouseButton1Click:Connect(function()
                for _, Option in ipairs(DropdownOptions) do
                    if #SelectionOrder >= Max then break end
                    if not Selected[Option] then
                        Selected[Option] = true
                        table.insert(SelectionOrder, Option)
                    end
                end
                UpdateLabel()
                Refresh(SearchBox.Text)
                Callback(SelectionOrder)
            end)

            ClearAllBtn.MouseButton1Click:Connect(function()
                while #SelectionOrder > Min do
                    local removed = table.remove(SelectionOrder, 1)
                    Selected[removed] = false
                end
                UpdateLabel()
                Refresh(SearchBox.Text)
                Callback(SelectionOrder)
            end)

            DropdownButton.MouseButton1Click:Connect(function()
                Dropped = not Dropped
                local TargetSize = Dropped and UDim2.new(1, 0, 0, 230) or UDim2.new(1, 0, 0, 34)
                if Dropped then CenterElement(PageFrame, DropdownFrame) end
                TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = TargetSize}):Play()
                TweenService:Create(ArrowImage, TweenInfo.new(0.2), {Rotation = Dropped and 180 or 0}):Play()
                if Dropped then Refresh() end
            end)
            Refresh()
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

return Astral