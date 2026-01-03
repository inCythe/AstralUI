local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local Astral = {}

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

-- Design System Constants
Astral.Design = {
    BaseScale = 1,
    Padding = {XS = 4, SM = 8, MD = 12, LG = 16, XL = 20},
    BorderRadius = {XS = 4, SM = 6, MD = 8, LG = 12, XL = 16},
    ElementHeight = 34,
    TopbarHeight = 36,
    ButtonSize = 26,
    BaseWidth = 580,
    BaseHeight = 420,
    FontSizes = {
        XS = 10,
        SM = 11,
        MD = 12,
        LG = 13,
        XL = 14,
        XXL = 16
    },
    Transparencies = {
        Background = 0.15,
        Element = 0.25,
        Stroke = 0.4,
        ScrollBar = 0.3,
        Hover = 0.15
    }
}

local IsStudio = game:GetService("RunService"):IsStudio()
local TargetParent = IsStudio and Player.PlayerGui or CoreGui

-- Cleanup existing UI
if TargetParent:FindFirstChild("AstralUI") then
    for _, child in pairs(TargetParent:GetChildren()) do
        if child.Name == "AstralLib" or child.Name == "AstralBubble" then
            child:Destroy()
        end
    end

    for _, child in pairs(TargetParent:GetChildren()) do
        if child:IsA("ScreenGui") and (child.Name:find("Astral") or child.Name:find("Notification")) then
            child:Destroy()
        end
    end
end

-- Utility Functions
local function ApplyScale(value, scale)
    return math.floor(value * scale + 0.5)
end

local function GetDesignValue(designTable, key, scale)
    local value = designTable[key] or designTable.MD
    return ApplyScale(value, scale)
end

local function CreateStyledFrame(parent, properties)
    local frame = Instance.new("Frame")
    
    for prop, value in pairs(properties) do
        if prop == "Parent" then
            frame.Parent = value
        else
            frame[prop] = value
        end
    end
    
    return frame
end

local function CreateRoundedFrame(parent, properties, cornerRadius)
    local frame = CreateStyledFrame(parent, properties)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = cornerRadius
    corner.Parent = frame
    
    return frame, corner
end

local function CreateStyledStroke(parent, properties)
    local stroke = Instance.new("UIStroke")
    
    for prop, value in pairs(properties) do
        if prop == "Parent" then
            stroke.Parent = value
        else
            stroke[prop] = value
        end
    end
    
    return stroke
end

local function ApplyPadding(parent, paddingValues, scale)
    local padding = Instance.new("UIPadding")
    padding.Parent = parent
    
    if type(paddingValues) == "table" then
        padding.PaddingTop = UDim.new(0, ApplyScale(paddingValues.Top or paddingValues.MD or 0, scale))
        padding.PaddingRight = UDim.new(0, ApplyScale(paddingValues.Right or paddingValues.MD or 0, scale))
        padding.PaddingBottom = UDim.new(0, ApplyScale(paddingValues.Bottom or paddingValues.MD or 0, scale))
        padding.PaddingLeft = UDim.new(0, ApplyScale(paddingValues.Left or paddingValues.MD or 0, scale))
    else
        local padded = ApplyScale(paddingValues, scale)
        padding.PaddingTop = UDim.new(0, padded)
        padding.PaddingRight = UDim.new(0, padded)
        padding.PaddingBottom = UDim.new(0, padded)
        padding.PaddingLeft = UDim.new(0, padded)
    end
    
    return padding
end

local function CreateTextLabel(parent, properties, fontSizeKey)
    local label = Instance.new("TextLabel")
    
    for prop, value in pairs(properties) do
        if prop == "Parent" then
            label.Parent = value
        else
            label[prop] = value
        end
    end
    
    if fontSizeKey then
        label.TextSize = GetDesignValue(Astral.Design.FontSizes, fontSizeKey, Astral.Design.BaseScale)
    end
    
    return label
end

-- Draggable Function
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

-- Hover Effect Function
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

-- Click Effect Function
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

-- Centering Function
local function CenterElement(ScrollingFrame, Element, ElementFutureHeight)
    if not ScrollingFrame or not Element then return end

    local function PerformCentering()
        local ScrollingFrameCanvasSize = ScrollingFrame.CanvasSize.Y.Offset
        local ScrollingFrameHeight = ScrollingFrame.AbsoluteSize.Y
        local ElementPosition = Element.AbsolutePosition.Y - ScrollingFrame.AbsolutePosition.Y + ScrollingFrame.CanvasPosition.Y
        local ElementHeight = ElementFutureHeight or Element.AbsoluteSize.Y

        local ElementTop = ElementPosition
        local ElementBottom = ElementPosition + ElementHeight

        local TargetPosition

        if ElementHeight <= ScrollingFrameHeight then
            TargetPosition = ElementPosition - (ScrollingFrameHeight / 2) + (ElementHeight / 2)
        else
            TargetPosition = ElementTop
        end

        local MaxScroll = math.max(0, ScrollingFrameCanvasSize - ScrollingFrameHeight)
        TargetPosition = math.clamp(TargetPosition, 0, MaxScroll)

        TweenService:Create(ScrollingFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            CanvasPosition = Vector2.new(0, TargetPosition)
        }):Play()
    end

    if ElementFutureHeight then
        task.spawn(function()
            local InitialCanvasSize = ScrollingFrame.CanvasSize.Y.Offset
            local MaxWaitTime = 0.5
            local StartTime = tick()
            
            while ScrollingFrame.CanvasSize.Y.Offset == InitialCanvasSize and (tick() - StartTime) < MaxWaitTime do
                task.wait()
            end
            
            task.wait()
            PerformCentering()
        end)
    else
        PerformCentering()
    end
end

-- ScrollBar Function
local function CreateScrollBar(ScrollingFrame)
    ScrollingFrame.ScrollBarThickness = 0
    ScrollingFrame.ScrollBarImageTransparency = 1

    local ScrollBarVisible = false
    local LastScrollTime = tick()
    local IsDragging = false
    local IsHovering = false

    local function ShowScrollBar()
        if not ScrollBarVisible then
            ScrollBarVisible = true
            TweenService:Create(ScrollingFrame, TweenInfo.new(0.2), {
                ScrollBarThickness = 4,
                ScrollBarImageTransparency = Astral.Design.Transparencies.ScrollBar
            }):Play()
        end
        LastScrollTime = tick()
    end

    local function HideScrollBar()
        if ScrollBarVisible and not IsDragging and not IsHovering and tick() - LastScrollTime > 0.5 then
            ScrollBarVisible = false
            TweenService:Create(ScrollingFrame, TweenInfo.new(0.5), {
                ScrollBarThickness = 0,
                ScrollBarImageTransparency = 1
            }):Play()
        end
    end

    ScrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(ShowScrollBar)

    game:GetService("RunService").Heartbeat:Connect(function()
        if ScrollBarVisible and not IsDragging and not IsHovering and tick() - LastScrollTime > 0.5 then
            HideScrollBar()
        end
    end)

    ScrollingFrame.MouseEnter:Connect(function()
        IsHovering = true
        ShowScrollBar()
    end)

    ScrollingFrame.MouseLeave:Connect(function()
        IsHovering = false
        if not IsDragging and tick() - LastScrollTime > 0.5 then
            HideScrollBar()
        end
    end)

    local DragStart = nil
    local StartCanvasPosition = nil

    UserInputService.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            local MousePosition = UserInputService:GetMouseLocation()
            local ScrollBarPosition = ScrollingFrame.AbsolutePosition + Vector2.new(ScrollingFrame.AbsoluteSize.X - 10, 0)
            local ScrollBarSize = Vector2.new(10, ScrollingFrame.AbsoluteSize.Y)

            if MousePosition.X >= ScrollBarPosition.X and MousePosition.X <= ScrollBarPosition.X + ScrollBarSize.X and
               MousePosition.Y >= ScrollBarPosition.Y and MousePosition.Y <= ScrollBarPosition.Y + ScrollBarSize.Y then
                IsDragging = true
                DragStart = MousePosition
                StartCanvasPosition = ScrollingFrame.CanvasPosition
                ShowScrollBar()
            end
        end
    end)

    UserInputService.InputChanged:Connect(function(Input)
        if IsDragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
            local MousePosition = UserInputService:GetMouseLocation()
            local Delta = MousePosition - DragStart

            local MaxScroll = math.max(0, ScrollingFrame.CanvasSize.Y.Offset - ScrollingFrame.AbsoluteSize.Y)
            local ScrollRatio = Delta.Y / ScrollingFrame.AbsoluteSize.Y
            local NewPosition = StartCanvasPosition.Y + (ScrollRatio * ScrollingFrame.CanvasSize.Y.Offset)
            NewPosition = math.clamp(NewPosition, 0, MaxScroll)

            ScrollingFrame.CanvasPosition = Vector2.new(0, NewPosition)
        end
    end)

    UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            IsDragging = false
            if not IsHovering then
                LastScrollTime = tick()
            end
        end
    end)
end

-- Main Window Creation
function Astral:Window(Options)
    local Name = Options.Name or "Astral"
    local Scale = Options.Scale or 1
    Astral.Design.BaseScale = Scale

    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AstralUI"
    ScreenGui.Parent = TargetParent
    ScreenGui.DisplayOrder = 999
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false

    -- Notification System
    local NotificationQueue = {}
    local ActiveNotifications = {}
    local MaxNotifications = 5

    -- Calculate dynamic dimensions
    local CurrentWidth = ApplyScale(Astral.Design.BaseWidth, Scale)
    local CurrentHeight = ApplyScale(Astral.Design.BaseHeight, Scale)
    local CurrentPadding = GetDesignValue(Astral.Design.Padding, "MD", Scale)
    local CurrentElementHeight = GetDesignValue(Astral.Design, "ElementHeight", Scale)
    local CurrentTopbarHeight = GetDesignValue(Astral.Design, "TopbarHeight", Scale)
    local CurrentButtonSize = GetDesignValue(Astral.Design, "ButtonSize", Scale)
    local CurrentBorderRadius = GetDesignValue(Astral.Design.BorderRadius, "LG", Scale)

    -- Main Window Frame
    local MainFrame = CreateRoundedFrame(ScreenGui, {
        Parent = ScreenGui,
        BackgroundColor3 = Astral.Theme.Main,
        BackgroundTransparency = Astral.Design.Transparencies.Background,
        Position = UDim2.new(0.5, -CurrentWidth / 2, 0.5, -CurrentHeight / 2),
        Size = UDim2.new(0, CurrentWidth, 0, CurrentHeight),
        ClipsDescendants = true,
        Active = true
    }, UDim.new(0, CurrentBorderRadius))

    -- Main Stroke
    CreateStyledStroke(MainFrame, {
        Parent = MainFrame,
        Color = Astral.Theme.Stroke,
        Thickness = ApplyScale(1.5, Scale),
        Transparency = Astral.Design.Transparencies.Stroke
    })

    -- Topbar
    local TopbarFrame = CreateRoundedFrame(MainFrame, {
        Parent = MainFrame,
        Name = "Topbar",
        BackgroundColor3 = Astral.Theme.Tertiary,
        BackgroundTransparency = 0.2,
        Position = UDim2.new(0, CurrentPadding, 0, CurrentPadding),
        Size = UDim2.new(1, -ApplyScale(88, Scale), 0, CurrentTopbarHeight),
        ZIndex = 5
    }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "MD", Scale)))

    -- Title
    CreateTextLabel(TopbarFrame, {
        Parent = TopbarFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = Name,
        TextColor3 = Astral.Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left
    }, "XL")
    ApplyPadding(TopbarFrame, Astral.Design.Padding.SM, Scale)

    MakeDraggable(TopbarFrame, MainFrame)

    -- Controls Frame
    local ControlsFrame = CreateStyledFrame(MainFrame, {
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -ApplyScale(88, Scale), 0, CurrentPadding),
        Size = UDim2.new(0, ApplyScale(80, Scale), 0, CurrentTopbarHeight),
        ZIndex = 10
    })

    -- Control Button Factory
    local function CreateControlButton(text, position, color, callback)
        local Button = Instance.new("TextButton")
        Button.Parent = ControlsFrame
        Button.BackgroundColor3 = Astral.Theme.Tertiary
        Button.BackgroundTransparency = 0.25
        Button.Position = position
        Button.Size = UDim2.new(0, CurrentButtonSize, 0, CurrentButtonSize)
        Button.AutoButtonColor = false
        Button.Font = Enum.Font.GothamBold
        Button.Text = text
        Button.TextColor3 = color
        Button.TextSize = GetDesignValue(Astral.Design.FontSizes, "XL", Scale)
        Button.ZIndex = 11

        CreateRoundedFrame(Button, {
            Parent = Button
        }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "SM", Scale)))

        AddHoverEffect(Button, Astral.Theme.HoverBright, Astral.Theme.Tertiary, 
            Astral.Design.Transparencies.Hover, 0.25)
        AddClickEffect(Button)
        
        if callback then
            Button.MouseButton1Click:Connect(callback)
        end
        
        return Button
    end

    -- Close Button
    CreateControlButton("×", 
        UDim2.new(1, -ApplyScale(CurrentButtonSize + CurrentPadding, Scale), 0.5, -CurrentButtonSize / 2),
        Astral.Theme.Error,
        function()
            local Tween = TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0)
            })
            Tween:Play()
            task.wait(0.25)
            ScreenGui:Destroy()
        end
    ).TextSize = GetDesignValue(Astral.Design.FontSizes, "XXL", Scale)

    -- Minimize Button
    CreateControlButton("−", 
        UDim2.new(1, -ApplyScale(CurrentButtonSize * 2 + CurrentPadding * 1.5, Scale), 0.5, -CurrentButtonSize / 2),
        Astral.Theme.TextDark,
        function()
            MainFrame.Visible = not MainFrame.Visible
        end
    ).TextSize = GetDesignValue(Astral.Design.FontSizes, "XXL", Scale)

    -- Bubble Icon
    local Bubble = Instance.new("TextButton")
    Bubble.Name = "AstralBubble"
    Bubble.Parent = ScreenGui
    Bubble.BackgroundColor3 = Astral.Theme.Main
    Bubble.Position = UDim2.new(1, -ApplyScale(70, Scale), 0.5, -ApplyScale(25, Scale))
    Bubble.Size = UDim2.new(0, ApplyScale(50, Scale), 0, ApplyScale(50, Scale))
    Bubble.ZIndex = 500
    Bubble.Text = ""
    Bubble.AutoButtonColor = false

    CreateRoundedFrame(Bubble, {
        Parent = Bubble
    }, UDim.new(1, 0))

    local BubbleIcon = Instance.new("ImageLabel")
    BubbleIcon.Parent = Bubble
    BubbleIcon.BackgroundTransparency = 1
    BubbleIcon.Size = UDim2.new(1, 0, 1, 0)
    BubbleIcon.Image = Options.Icon or "rbxassetid://7733954760"
    BubbleIcon.ImageColor3 = Astral.Theme.Accent
    BubbleIcon.ScaleType = Enum.ScaleType.Fit

    CreateStyledStroke(Bubble, {
        Parent = Bubble,
        Thickness = ApplyScale(2, Scale),
        Color = Astral.Theme.Stroke,
        Transparency = 0.3
    })

    -- Bubble Dragging Logic
    local BubbleDragging = false
    local DragInput, DragStart, StartPos

    local function SnapToSide()
        local ScreenSize = ScreenGui.AbsoluteSize
        local CurrentPos = Bubble.AbsolutePosition
        local CenterX = ScreenSize.X / 2

        local TargetX = (CurrentPos.X + ApplyScale(25, Scale) < CenterX) and ApplyScale(15, Scale) or (ScreenSize.X - ApplyScale(65, Scale))
        local TargetY = math.clamp(CurrentPos.Y, ApplyScale(15, Scale), ScreenSize.Y - ApplyScale(65, Scale))

        if TargetY < ApplyScale(100, Scale) then TargetY = ApplyScale(15, Scale) end
        if TargetY > ScreenSize.Y - ApplyScale(165, Scale) then TargetY = ScreenSize.Y - ApplyScale(65, Scale) end

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
        if (StartPos.X.Offset - Bubble.Position.X.Offset) < ApplyScale(5, Scale) then
            MainFrame.Visible = not MainFrame.Visible
        end
    end)

    -- Content Area
    local ContentFrame = CreateStyledFrame(MainFrame, {
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, CurrentTopbarHeight + CurrentPadding * 2),
        Size = UDim2.new(1, 0, 1, -(CurrentTopbarHeight + CurrentPadding * 2)),
        ClipsDescendants = true
    })

    -- Sidebar
    local SidebarFrame = CreateRoundedFrame(ContentFrame, {
        Parent = ContentFrame,
        BackgroundColor3 = Astral.Theme.Tertiary,
        BackgroundTransparency = 0.2,
        Position = UDim2.new(0, CurrentPadding, 0, 0),
        Size = UDim2.new(0, ApplyScale(130, Scale), 1, -CurrentPadding)
    }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "MD", Scale)))

    CreateStyledStroke(SidebarFrame, {
        Parent = SidebarFrame,
        Color = Astral.Theme.StrokeDark,
        Thickness = ApplyScale(1, Scale),
        Transparency = Astral.Design.Transparencies.Stroke
    })

    -- Tab Container
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Parent = SidebarFrame
    TabContainer.BackgroundTransparency = 1
    TabContainer.Position = UDim2.new(0, CurrentPadding, 0, CurrentPadding)
    TabContainer.Size = UDim2.new(1, -CurrentPadding * 2, 1, -CurrentPadding * 2)
    TabContainer.ScrollBarThickness = 0
    TabContainer.ScrollBarImageTransparency = 1
    TabContainer.ScrollBarImageColor3 = Astral.Theme.Accent
    TabContainer.BorderSizePixel = 0
    TabContainer.VerticalScrollBarInset = Enum.ScrollBarInset.None
    TabContainer.HorizontalScrollBarInset = Enum.ScrollBarInset.None
    TabContainer.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
    TabContainer.ScrollingEnabled = true

    CreateScrollBar(TabContainer)

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = TabContainer
    TabLayout.Padding = UDim.new(0, CurrentPadding)
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + CurrentPadding)
    end)

    -- Pages Area
    local PagesFrame = CreateRoundedFrame(ContentFrame, {
        Parent = ContentFrame,
        BackgroundColor3 = Astral.Theme.Secondary,
        BackgroundTransparency = 0.2,
        Position = UDim2.new(0, ApplyScale(130 + CurrentPadding * 2, Scale), 0, 0),
        Size = UDim2.new(1, -ApplyScale(130 + CurrentPadding * 3, Scale), 1, -CurrentPadding)
    }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "MD", Scale)))

    local PagesContainer = CreateStyledFrame(PagesFrame, {
        Parent = PagesFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ClipsDescendants = true
    })
    ApplyPadding(PagesContainer, Astral.Design.Padding.MD, Scale)

    -- Window Functions
    local WindowFunctions = {}
    local FirstTab = true
    local AllTabs = {}

    -- Notification Functions
    local function UpdateNotificationPositions()
        for Index, Notification in ipairs(ActiveNotifications) do
            local TargetYOffset = -ApplyScale(20, Scale) - ((Index - 1) * ApplyScale(80, Scale))
            TweenService:Create(Notification, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, -ApplyScale(20, Scale), 1, TargetYOffset)
            }):Play()
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

        local NotificationFrame = CreateRoundedFrame(ScreenGui, {
            Parent = ScreenGui,
            BackgroundColor3 = Astral.Theme.Main,
            BackgroundTransparency = Astral.Design.Transparencies.Background,
            Size = UDim2.new(0, ApplyScale(300, Scale), 0, ApplyScale(70, Scale)),
            AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.new(1.5, 0, 1, -ApplyScale(20, Scale)),
            ZIndex = 100
        }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "MD", Scale)))

        CreateStyledStroke(NotificationFrame, {
            Parent = NotificationFrame,
            Color = TypeColors[Type],
            Thickness = ApplyScale(1.5, Scale),
            Transparency = Astral.Design.Transparencies.Stroke
        })

        -- Notification Title
        CreateTextLabel(NotificationFrame, {
            Parent = NotificationFrame,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, ApplyScale(18, Scale)),
            Font = Enum.Font.GothamBold,
            Text = Title,
            TextColor3 = Astral.Theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left
        }, "LG")
        ApplyPadding(NotificationFrame:FindFirstChildWhichIsA("TextLabel"), Astral.Design.Padding.SM, Scale)

        -- Notification Content
        local ContentLabel = CreateTextLabel(NotificationFrame, {
            Parent = NotificationFrame,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, ApplyScale(28, Scale)),
            Size = UDim2.new(1, 0, 1, -ApplyScale(36, Scale)),
            Font = Enum.Font.Gotham,
            Text = Content,
            TextColor3 = Astral.Theme.TextDark,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true
        }, "SM")
        ApplyPadding(ContentLabel, Astral.Design.Padding.SM, Scale)

        table.insert(ActiveNotifications, NotificationFrame)
        UpdateNotificationPositions()

        task.delay(Duration, function()
            local ExitTween = TweenService:Create(NotificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Position = UDim2.new(1.5, 0, 1, NotificationFrame.Position.Y.Offset),
                BackgroundTransparency = 1
            })

            ExitTween:Play()
            ExitTween.Completed:Connect(function()
                NotificationFrame:Destroy()
                for i, v in ipairs(ActiveNotifications) do
                    if v == NotificationFrame then
                        table.remove(ActiveNotifications, i)
                        break
                    end
                end
                UpdateNotificationPositions()

                if #NotificationQueue > 0 then
                    local Next = table.remove(NotificationQueue, 1)
                    WindowFunctions:Notify(Next)
                end
            end)
        end)
    end

    -- Window Control Functions
    function WindowFunctions:Hide() MainFrame.Visible = false end
    function WindowFunctions:Show() MainFrame.Visible = true end
    function WindowFunctions:Toggle() MainFrame.Visible = not MainFrame.Visible return MainFrame.Visible end
    function WindowFunctions:Destroy() ScreenGui:Destroy() end
    function WindowFunctions:Minimize() MainFrame.Visible = false end
    function WindowFunctions:GetMainFrame() return MainFrame end
    function WindowFunctions:GetScreenGui() return ScreenGui end

    function WindowFunctions:SetScale(newScale)
        if newScale <= 0 then return end
        Astral.Design.BaseScale = newScale
        
        CurrentWidth = ApplyScale(Astral.Design.BaseWidth, newScale)
        CurrentHeight = ApplyScale(Astral.Design.BaseHeight, newScale)

        TweenService:Create(MainFrame, TweenInfo.new(0.3), {
            Size = UDim2.new(0, CurrentWidth, 0, CurrentHeight),
            Position = UDim2.new(0.5, -CurrentWidth/2, 0.5, -CurrentHeight/2)
        }):Play()
    end

    function WindowFunctions:GetScale() return Astral.Design.BaseScale end

    -- Tab Creation
    function WindowFunctions:Tab(Options)
        local TabName = Options.Name or "Tab"
        local TabIcon = Options.Icon or "rbxassetid://7733954760"

        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Parent = TabContainer
        TabButton.BackgroundColor3 = Astral.Theme.Main
        TabButton.BackgroundTransparency = Astral.Design.Transparencies.Element
        TabButton.Size = UDim2.new(1, 0, 0, CurrentElementHeight)
        TabButton.AutoButtonColor = false
        TabButton.Text = ""

        CreateRoundedFrame(TabButton, {
            Parent = TabButton
        }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "MD", Scale)))

        -- Tab Icon
        local IconImage = Instance.new("ImageLabel")
        IconImage.Parent = TabButton
        IconImage.BackgroundTransparency = 1
        IconImage.Position = UDim2.new(0, CurrentPadding, 0.5, -ApplyScale(8, Scale))
        IconImage.Size = UDim2.new(0, ApplyScale(16, Scale), 0, ApplyScale(16, Scale))
        IconImage.Image = TabIcon
        IconImage.ImageColor3 = Astral.Theme.TextDark

        -- Tab Label
        local LabelText = CreateTextLabel(TabButton, {
            Parent = TabButton,
            BackgroundTransparency = 1,
            Position = UDim2.new(0, ApplyScale(30, Scale), 0, 0),
            Size = UDim2.new(1, -ApplyScale(35, Scale), 1, 0),
            Font = Enum.Font.GothamMedium,
            Text = TabName,
            TextColor3 = Astral.Theme.TextDark,
            TextXAlignment = Enum.TextXAlignment.Left
        }, "SM")

        -- Active Indicator
        local IndicatorFrame = CreateStyledFrame(TabButton, {
            Parent = TabButton,
            Name = "Indicator",
            BackgroundColor3 = Astral.Theme.Accent,
            BorderSizePixel = 0,
            Position = UDim2.new(0, ApplyScale(2, Scale), 0.5, -ApplyScale(8, Scale)),
            Size = UDim2.new(0, ApplyScale(2, Scale), 0, ApplyScale(16, Scale)),
            Visible = false
        })

        AddHoverEffect(TabButton, Astral.Theme.HoverBright, Astral.Theme.Main, 
            0.2, Astral.Design.Transparencies.Element)
        AddClickEffect(TabButton)

        -- Page Frame
        local PageFrame = Instance.new("ScrollingFrame")
        PageFrame.Name = TabName
        PageFrame.Parent = PagesContainer
        PageFrame.BackgroundTransparency = 1
        PageFrame.BorderSizePixel = 0
        PageFrame.Size = UDim2.new(1, 0, 1, 0)
        PageFrame.ScrollBarThickness = 0
        PageFrame.ScrollBarImageTransparency = 1
        PageFrame.ScrollBarImageColor3 = Astral.Theme.Accent
        PageFrame.Visible = false
        PageFrame.VerticalScrollBarInset = Enum.ScrollBarInset.None
        PageFrame.HorizontalScrollBarInset = Enum.ScrollBarInset.None
        PageFrame.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
        PageFrame.ScrollingEnabled = true

        CreateScrollBar(PageFrame)
        ApplyPadding(PageFrame, Astral.Design.Padding.MD, Scale)

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Parent = PageFrame
        PageLayout.Padding = UDim.new(0, CurrentPadding)
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            PageFrame.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + CurrentPadding * 2)
        end)

        -- Tab Activation Function
        local function Activate()
            for _, Page in pairs(PagesContainer:GetChildren()) do
                if Page:IsA("ScrollingFrame") then
                    Page.Visible = false
                end
            end
            for _, TabData in pairs(AllTabs) do
                TabData.Button.Indicator.Visible = false
                TweenService:Create(TabData.Button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Astral.Theme.Main,
                    BackgroundTransparency = Astral.Design.Transparencies.Element
                }):Play()
                TweenService:Create(TabData.Label, TweenInfo.new(0.2), {TextColor3 = Astral.Theme.TextDark}):Play()
                TweenService:Create(TabData.Icon, TweenInfo.new(0.2), {ImageColor3 = Astral.Theme.TextDark}):Play()
            end
            PageFrame.Visible = true
            IndicatorFrame.Visible = true
            TweenService:Create(TabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(5, 5, 8),
                BackgroundTransparency = 0.1
            }):Play()
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

        -- Section Creation
        function TabFunctions:Section(Options)
            local SectionName = Options.Name or "Section"

            local SectionFrame = CreateRoundedFrame(PageFrame, {
                Parent = PageFrame,
                BackgroundColor3 = Astral.Theme.Tertiary,
                BackgroundTransparency = Astral.Design.Transparencies.Element,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y
            }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "MD", Scale)))

            -- Header
            local HeaderFrame = CreateRoundedFrame(SectionFrame, {
                Parent = SectionFrame,
                BackgroundColor3 = Astral.Theme.Main,
                BackgroundTransparency = 0.2,
                Size = UDim2.new(1, 0, 0, CurrentElementHeight)
            }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "MD", Scale)))

            CreateTextLabel(HeaderFrame, {
                Parent = HeaderFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.GothamBold,
                Text = SectionName,
                TextColor3 = Astral.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left
            }, "LG")
            ApplyPadding(HeaderFrame, Astral.Design.Padding.SM, Scale)

            -- Content Area
            local SectionContent = CreateStyledFrame(SectionFrame, {
                Parent = SectionFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, CurrentElementHeight),
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y
            })
            ApplyPadding(SectionContent, Astral.Design.Padding.MD, Scale)

            local SectionLayout = Instance.new("UIListLayout")
            SectionLayout.Parent = SectionContent
            SectionLayout.Padding = UDim.new(0, CurrentPadding)

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

        -- Button Element
        function TabFunctions:Button(Options, Parent)
            Parent = Parent or PageFrame
            local ButtonName = Options.Name or "Button"
            local Callback = Options.Callback or function() end

            local ButtonFrame = Instance.new("TextButton")
            ButtonFrame.Parent = Parent
            ButtonFrame.BackgroundColor3 = Astral.Theme.Main
            ButtonFrame.BackgroundTransparency = Astral.Design.Transparencies.Element
            ButtonFrame.Size = UDim2.new(1, 0, 0, CurrentElementHeight)
            ButtonFrame.AutoButtonColor = false
            ButtonFrame.Text = ""

            CreateRoundedFrame(ButtonFrame, {
                Parent = ButtonFrame
            }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "SM", Scale)))

            CreateTextLabel(ButtonFrame, {
                Parent = ButtonFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.GothamMedium,
                Text = ButtonName,
                TextColor3 = Astral.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left
            }, "MD")
            ApplyPadding(ButtonFrame, Astral.Design.Padding.SM, Scale)

            AddHoverEffect(ButtonFrame, Astral.Theme.HoverBright, Astral.Theme.Main, 
                Astral.Design.Transparencies.Hover, Astral.Design.Transparencies.Element)
            AddClickEffect(ButtonFrame)
            ButtonFrame.MouseButton1Click:Connect(Callback)
        end

        -- Toggle Element
        function TabFunctions:Toggle(Options, Parent)
            Parent = Parent or PageFrame
            local ToggleName = Options.Name or "Toggle"
            local Default = Options.Default or false
            local Callback = Options.Callback or function() end
            local State = Default

            local ToggleFrame = CreateRoundedFrame(Parent, {
                Parent = Parent,
                BackgroundColor3 = Astral.Theme.Main,
                BackgroundTransparency = Astral.Design.Transparencies.Element,
                Size = UDim2.new(1, 0, 0, CurrentElementHeight),
                ClipsDescendants = true
            }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "SM", Scale)))

            CreateTextLabel(ToggleFrame, {
                Parent = ToggleFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.GothamMedium,
                Text = ToggleName,
                TextColor3 = Astral.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left
            }, "MD")
            ApplyPadding(ToggleFrame, Astral.Design.Padding.SM, Scale)

            local CheckButton = Instance.new("TextButton")
            CheckButton.Parent = ToggleFrame
            CheckButton.BackgroundColor3 = State and Astral.Theme.Accent or Astral.Theme.Tertiary
            CheckButton.Position = UDim2.new(1, -ApplyScale(46, Scale), 0.5, -ApplyScale(9, Scale))
            CheckButton.Size = UDim2.new(0, ApplyScale(38, Scale), 0, ApplyScale(18, Scale))
            CheckButton.AutoButtonColor = false
            CheckButton.Text = ""

            CreateRoundedFrame(CheckButton, {
                Parent = CheckButton
            }, UDim.new(1, 0))

            local CircleFrame = CreateRoundedFrame(CheckButton, {
                Parent = CheckButton,
                BackgroundColor3 = Astral.Theme.Text,
                Size = UDim2.new(0, ApplyScale(14, Scale), 0, ApplyScale(14, Scale)),
                Position = State and UDim2.new(1, -ApplyScale(16, Scale), 0.5, -ApplyScale(7, Scale)) or UDim2.new(0, ApplyScale(2, Scale), 0.5, -ApplyScale(7, Scale))
            }, UDim.new(1, 0))

            local function Update()
                local Position = State and UDim2.new(1, -ApplyScale(16, Scale), 0.5, -ApplyScale(7, Scale)) or UDim2.new(0, ApplyScale(2, Scale), 0.5, -ApplyScale(7, Scale))
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

        -- Slider Element (kept similar structure but with consistent styling)
        function TabFunctions:Slider(Options, Parent)
            Parent = Parent or PageFrame
            local SliderName = Options.Name or "Slider"
            local Min = Options.Min or 0
            local Max = Options.Max or 100
            local Default = Options.Default or Min
            local Increment = Options.Increment or 1
            local Callback = Options.Callback or function() end
            local Value = Default

            local SliderFrame = CreateRoundedFrame(Parent, {
                Parent = Parent,
                BackgroundColor3 = Astral.Theme.Main,
                BackgroundTransparency = Astral.Design.Transparencies.Element,
                Size = UDim2.new(1, 0, 0, ApplyScale(50, Scale)),
                ClipsDescendants = true
            }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "SM", Scale)))

            CreateTextLabel(SliderFrame, {
                Parent = SliderFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, ApplyScale(16, Scale)),
                Font = Enum.Font.GothamMedium,
                Text = SliderName,
                TextColor3 = Astral.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left
            }, "MD")
            ApplyPadding(SliderFrame, Astral.Design.Padding.SM, Scale)

            -- Value Input
            local ValueInput = Instance.new("TextBox")
            ValueInput.Parent = SliderFrame
            ValueInput.BackgroundColor3 = Astral.Theme.Tertiary
            ValueInput.BackgroundTransparency = Astral.Design.Transparencies.Element
            ValueInput.Position = UDim2.new(1, -ApplyScale(60, Scale), 0, ApplyScale(4, Scale))
            ValueInput.Size = UDim2.new(0, ApplyScale(48, Scale), 0, ApplyScale(20, Scale))
            ValueInput.Font = Enum.Font.GothamBold
            ValueInput.Text = tostring(Value)
            ValueInput.TextColor3 = Astral.Theme.Accent
            ValueInput.TextSize = GetDesignValue(Astral.Design.FontSizes, "SM", Scale)
            ValueInput.ClearTextOnFocus = false

            CreateRoundedFrame(ValueInput, {
                Parent = ValueInput
            }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "XS", Scale)))

            CreateStyledStroke(ValueInput, {
                Parent = ValueInput,
                Color = Astral.Theme.Stroke,
                Thickness = ApplyScale(1, Scale),
                Transparency = 0.5
            })

            -- Slider Track
            local BackgroundFrame = CreateRoundedFrame(SliderFrame, {
                Parent = SliderFrame,
                BackgroundColor3 = Astral.Theme.Tertiary,
                Position = UDim2.new(0, CurrentPadding, 1, -ApplyScale(18, Scale)),
                Size = UDim2.new(1, -CurrentPadding * 2, 0, ApplyScale(6, Scale))
            }, UDim.new(1, 0))

            local FillFrame = CreateRoundedFrame(BackgroundFrame, {
                Parent = BackgroundFrame,
                BackgroundColor3 = Astral.Theme.Accent,
                Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
            }, UDim.new(1, 0))

            local BallFrame = CreateRoundedFrame(BackgroundFrame, {
                Parent = BackgroundFrame,
                BackgroundColor3 = Astral.Theme.Text,
                Size = UDim2.new(0, ApplyScale(14, Scale), 0, ApplyScale(14, Scale)),
                Position = UDim2.new((Value - Min) / (Max - Min), -ApplyScale(7, Scale), 0.5, -ApplyScale(7, Scale)),
                ZIndex = 2
            }, UDim.new(1, 0))

            -- Slider Logic (same as original)
            local Dragging = false

            local function Update(input)
                local SizeX = BackgroundFrame.AbsoluteSize.X
                local OffsetX = math.clamp(input.Position.X - BackgroundFrame.AbsolutePosition.X, 0, SizeX)
                local Percentage = OffsetX / SizeX

                Value = math.floor(((Max - Min) * Percentage + Min) / Increment + 0.5) * Increment
                Value = math.clamp(Value, Min, Max)

                local VisualPercentage = (Value - Min) / (Max - Min)

                TweenService:Create(FillFrame, TweenInfo.new(0.05), {Size = UDim2.new(VisualPercentage, 0, 1, 0)}):Play()
                TweenService:Create(BallFrame, TweenInfo.new(0.05), {Position = UDim2.new(VisualPercentage, -ApplyScale(7, Scale), 0.5, -ApplyScale(7, Scale))}):Play()

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
                    TweenService:Create(BallFrame, TweenInfo.new(0.2), {Position = UDim2.new(VisualPercentage, -ApplyScale(7, Scale), 0.5, -ApplyScale(7, Scale))}):Play()
                    ValueInput.Text = tostring(Value)
                    Callback(Value)
                else
                    ValueInput.Text = tostring(Value)
                end
            end)
        end

        -- TextBox Element
        function TabFunctions:TextBox(Options, Parent)
            Parent = Parent or PageFrame
            local TextBoxName = Options.Name or "TextBox"
            local Default = Options.Default or ""
            local Placeholder = Options.Placeholder or "Enter text..."
            local Callback = Options.Callback or function() end

            local TextBoxFrame = CreateRoundedFrame(Parent, {
                Parent = Parent,
                BackgroundColor3 = Astral.Theme.Main,
                BackgroundTransparency = Astral.Design.Transparencies.Element,
                Size = UDim2.new(1, 0, 0, ApplyScale(44, Scale)),
                ClipsDescendants = true
            }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "SM", Scale)))

            CreateTextLabel(TextBoxFrame, {
                Parent = TextBoxFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, ApplyScale(16, Scale)),
                Font = Enum.Font.GothamMedium,
                Text = TextBoxName,
                TextColor3 = Astral.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left
            }, "MD")
            ApplyPadding(TextBoxFrame, Astral.Design.Padding.SM, Scale)

            local InputBox = Instance.new("TextBox")
            InputBox.Parent = TextBoxFrame
            InputBox.BackgroundColor3 = Astral.Theme.Tertiary
            InputBox.BackgroundTransparency = Astral.Design.Transparencies.Element
            InputBox.Position = UDim2.new(0, CurrentPadding, 0, ApplyScale(24, Scale))
            InputBox.Size = UDim2.new(1, -CurrentPadding * 2, 0, ApplyScale(16, Scale))
            InputBox.Font = Enum.Font.Gotham
            InputBox.PlaceholderText = Placeholder
            InputBox.PlaceholderColor3 = Astral.Theme.TextDarker
            InputBox.Text = Default
            InputBox.TextColor3 = Astral.Theme.Text
            InputBox.TextSize = GetDesignValue(Astral.Design.FontSizes, "SM", Scale)
            InputBox.TextXAlignment = Enum.TextXAlignment.Left
            InputBox.ClearTextOnFocus = false

            CreateRoundedFrame(InputBox, {
                Parent = InputBox
            }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "XS", Scale)))

            CreateStyledStroke(InputBox, {
                Parent = InputBox,
                Color = Astral.Theme.Stroke,
                Thickness = ApplyScale(1, Scale),
                Transparency = 0.5
            })

            InputBox.Focused:Connect(function()
                CenterElement(PageFrame, TextBoxFrame)
            end)

            InputBox.FocusLost:Connect(function(EnterPressed)
                if EnterPressed then
                    Callback(InputBox.Text)
                end
            end)
        end

        -- Dropdown Element (keeping original logic with consistent styling)
        function TabFunctions:Dropdown(Options, Parent)
            Parent = Parent or PageFrame
            local DropdownName = Options.Name or "Dropdown"
            local DropdownOptions = Options.Options or {}
            local CurrentSelected = Options.Default or nil
            local Callback = Options.Callback or function() end
            local Dropped = false

            local BaseElementHeight = CurrentElementHeight
            local ListMaxHeight = ApplyScale(120, Scale)
            local HeaderHeight = ApplyScale(30, Scale)
            
            local TotalHeightWhenDropped = BaseElementHeight + HeaderHeight + ListMaxHeight + CurrentPadding * 3

            local DropdownFrame = CreateRoundedFrame(Parent, {
                Parent = Parent,
                BackgroundColor3 = Astral.Theme.Main,
                BackgroundTransparency = Astral.Design.Transparencies.Element,
                Size = UDim2.new(1, 0, 0, BaseElementHeight),
                ClipsDescendants = true
            }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "SM", Scale)))
            
            ApplyPadding(DropdownFrame, Astral.Design.Padding.SM, Scale)

            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Parent = DropdownFrame
            DropdownButton.BackgroundTransparency = 1
            DropdownButton.Size = UDim2.new(1, 0, 0, BaseElementHeight - CurrentPadding * 2)
            DropdownButton.Text = ""

            local DropdownLabel = CreateTextLabel(DropdownButton, {
                Parent = DropdownButton,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.GothamMedium,
                Text = DropdownName .. (CurrentSelected and (": " .. tostring(CurrentSelected)) or ""),
                TextColor3 = Astral.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1
            }, "MD")
            ApplyPadding(DropdownLabel, Astral.Design.Padding.SM, Scale)

            local ArrowImage = Instance.new("ImageLabel")
            ArrowImage.Parent = DropdownButton
            ArrowImage.BackgroundTransparency = 1
            ArrowImage.Position = UDim2.new(1, -ApplyScale(26, Scale), 0.5, -ApplyScale(6, Scale))
            ArrowImage.Size = UDim2.new(0, ApplyScale(12, Scale), 0, ApplyScale(12, Scale))
            ArrowImage.Image = "rbxassetid://6031091004"
            ArrowImage.ImageColor3 = Astral.Theme.Accent

            -- Dropdown content (same structure as original but with consistent styling)
            local Header = CreateStyledFrame(DropdownFrame, {
                Parent = DropdownFrame,
                Position = UDim2.new(0, 0, 0, BaseElementHeight - CurrentPadding),
                Size = UDim2.new(1, 0, 0, HeaderHeight),
                BackgroundTransparency = 1,
                Visible = false
            })

            local SearchBox = Instance.new("TextBox")
            SearchBox.Parent = Header
            SearchBox.Size = UDim2.new(1, -ApplyScale(50, Scale), 1, 0)
            SearchBox.BackgroundColor3 = Astral.Theme.Tertiary
            SearchBox.BackgroundTransparency = Astral.Design.Transparencies.Element
            SearchBox.PlaceholderText = "Search..."
            SearchBox.Text = ""
            SearchBox.TextColor3 = Astral.Theme.Text
            SearchBox.Font = Enum.Font.Gotham
            SearchBox.TextSize = GetDesignValue(Astral.Design.FontSizes, "SM", Scale)
            CreateRoundedFrame(SearchBox, {
                Parent = SearchBox
            }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "XS", Scale)))
            
            CreateStyledStroke(SearchBox, {
                Parent = SearchBox,
                Color = Astral.Theme.Stroke,
                Thickness = ApplyScale(1, Scale),
                Transparency = 0.5
            })

            local ClearBtn = Instance.new("TextButton")
            ClearBtn.Parent = Header
            ClearBtn.Position = UDim2.new(1, -ApplyScale(45, Scale), 0, 0)
            ClearBtn.Size = UDim2.new(0, ApplyScale(45, Scale), 1, 0)
            ClearBtn.BackgroundColor3 = Astral.Theme.Error
            ClearBtn.BackgroundTransparency = Astral.Design.Transparencies.Element
            ClearBtn.Text = "CLEAR"
            ClearBtn.Font = Enum.Font.GothamBold
            ClearBtn.TextColor3 = Astral.Theme.Text
            ClearBtn.TextSize = GetDesignValue(Astral.Design.FontSizes, "XS", Scale)
            CreateRoundedFrame(ClearBtn, {
                Parent = ClearBtn
            }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "XS", Scale)))

            local DropdownList = Instance.new("ScrollingFrame")
            DropdownList.Parent = DropdownFrame
            DropdownList.BackgroundTransparency = 1
            DropdownList.Position = UDim2.new(0, 0, 0, BaseElementHeight + HeaderHeight - CurrentPadding * 2)
            DropdownList.Size = UDim2.new(1, 0, 0, ListMaxHeight)
            DropdownList.ScrollBarThickness = 0
            DropdownList.ScrollBarImageTransparency = 1
            DropdownList.ScrollBarImageColor3 = Astral.Theme.Accent
            DropdownList.BorderSizePixel = 0
            DropdownList.VerticalScrollBarInset = Enum.ScrollBarInset.None
            DropdownList.HorizontalScrollBarInset = Enum.ScrollBarInset.None
            DropdownList.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
            DropdownList.ScrollingEnabled = false
            DropdownList.Visible = false
            
            ApplyPadding(DropdownList, {Top = Astral.Design.Padding.SM, Bottom = Astral.Design.Padding.SM}, Scale)
            CreateScrollBar(DropdownList)

            local DropdownLayout = Instance.new("UIListLayout")
            DropdownLayout.Parent = DropdownList
            DropdownLayout.Padding = UDim.new(0, CurrentPadding)

            -- Original dropdown logic remains the same
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
                    OptionButton.BackgroundTransparency = IsSelected and 0.15 or Astral.Design.Transparencies.Element
                    OptionButton.Size = UDim2.new(1, 0, 0, ApplyScale(26, Scale))
                    OptionButton.Text = Option
                    OptionButton.Font = IsSelected and Enum.Font.GothamBold or Enum.Font.Gotham
                    OptionButton.TextColor3 = IsSelected and Astral.Theme.Text or Astral.Theme.TextDark
                    OptionButton.TextSize = GetDesignValue(Astral.Design.FontSizes, "SM", Scale)
                    CreateRoundedFrame(OptionButton, {
                        Parent = OptionButton
                    }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "XS", Scale)))

                    OptionButton.MouseButton1Click:Connect(function()
                        CurrentSelected = Option
                        DropdownLabel.Text = DropdownName .. ": " .. Option
                        Callback(Option)
                        Refresh(SearchBox.Text)
                    end)
                end

                local ContentHeight = DropdownLayout.AbsoluteContentSize.Y
                DropdownList.CanvasSize = UDim2.new(0, 0, 0, ContentHeight + CurrentPadding)
                DropdownList.ScrollingEnabled = ContentHeight > ListMaxHeight
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
                if Dropped then 
                    Refresh()
                    Header.Visible = true
                    DropdownList.Visible = true
                    
                    CenterElement(PageFrame, DropdownFrame, TotalHeightWhenDropped)
                    
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {
                        Size = UDim2.new(1, 0, 0, TotalHeightWhenDropped)
                    }):Play()
                    TweenService:Create(ArrowImage, TweenInfo.new(0.2), {
                        Rotation = 180
                    }):Play()
                else
                    Header.Visible = false
                    DropdownList.Visible = false
                    
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {
                        Size = UDim2.new(1, 0, 0, BaseElementHeight)
                    }):Play()
                    TweenService:Create(ArrowImage, TweenInfo.new(0.2), {
                        Rotation = 0
                    }):Play()
                end
            end)
        end

        -- MultiDropdown Element (keeping original structure with consistent styling)
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

            local BaseElementHeight = CurrentElementHeight
            local ListMaxHeight = ApplyScale(140, Scale)
            local HeaderHeight = ApplyScale(30, Scale)
            
            local TotalHeightWhenDropped = BaseElementHeight + HeaderHeight + ListMaxHeight + CurrentPadding * 3

            local DropdownFrame = CreateRoundedFrame(Parent, {
                Parent = Parent,
                BackgroundColor3 = Astral.Theme.Main,
                BackgroundTransparency = Astral.Design.Transparencies.Element,
                Size = UDim2.new(1, 0, 0, BaseElementHeight),
                ClipsDescendants = true
            }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "SM", Scale)))
            
            ApplyPadding(DropdownFrame, Astral.Design.Padding.SM, Scale)

            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Parent = DropdownFrame
            DropdownButton.BackgroundTransparency = 1
            DropdownButton.Size = UDim2.new(1, 0, 0, BaseElementHeight - CurrentPadding * 2)
            DropdownButton.Text = ""

            local DropdownLabel = CreateTextLabel(DropdownButton, {
                Parent = DropdownButton,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.GothamMedium,
                TextColor3 = Astral.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                TextTruncate = Enum.TextTruncate.AtEnd
            }, "MD")
            ApplyPadding(DropdownLabel, Astral.Design.Padding.SM, Scale)

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
            ArrowImage.Position = UDim2.new(1, -ApplyScale(26, Scale), 0.5, -ApplyScale(6, Scale))
            ArrowImage.Size = UDim2.new(0, ApplyScale(12, Scale), 0, ApplyScale(12, Scale))
            ArrowImage.Image = "rbxassetid://6031091004"
            ArrowImage.ImageColor3 = Astral.Theme.Accent

            -- Multi-dropdown content (same structure as original but with consistent styling)
            local Header = CreateStyledFrame(DropdownFrame, {
                Parent = DropdownFrame,
                Position = UDim2.new(0, 0, 0, BaseElementHeight - CurrentPadding),
                Size = UDim2.new(1, 0, 0, HeaderHeight),
                BackgroundTransparency = 1,
                Visible = false
            })

            local SearchBox = Instance.new("TextBox")
            SearchBox.Parent = Header
            SearchBox.Size = UDim2.new(1, -ApplyScale(100, Scale), 1, 0)
            SearchBox.BackgroundColor3 = Astral.Theme.Tertiary
            SearchBox.BackgroundTransparency = Astral.Design.Transparencies.Element
            SearchBox.PlaceholderText = "Search options..."
            SearchBox.Text = ""
            SearchBox.TextColor3 = Astral.Theme.Text
            SearchBox.Font = Enum.Font.Gotham
            SearchBox.TextSize = GetDesignValue(Astral.Design.FontSizes, "SM", Scale)
            CreateRoundedFrame(SearchBox, {
                Parent = SearchBox
            }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "XS", Scale)))
            
            CreateStyledStroke(SearchBox, {
                Parent = SearchBox,
                Color = Astral.Theme.Stroke,
                Thickness = ApplyScale(1, Scale),
                Transparency = 0.5
            })

            local SelectAllBtn = Instance.new("TextButton")
            SelectAllBtn.Parent = Header
            SelectAllBtn.Position = UDim2.new(1, -ApplyScale(95, Scale), 0, 0)
            SelectAllBtn.Size = UDim2.new(0, ApplyScale(45, Scale), 1, 0)
            SelectAllBtn.BackgroundColor3 = Astral.Theme.Success
            SelectAllBtn.BackgroundTransparency = Astral.Design.Transparencies.Element
            SelectAllBtn.Text = "ALL"
            SelectAllBtn.Font = Enum.Font.GothamBold
            SelectAllBtn.TextColor3 = Astral.Theme.Text
            SelectAllBtn.TextSize = GetDesignValue(Astral.Design.FontSizes, "XS", Scale)
            CreateRoundedFrame(SelectAllBtn, {
                Parent = SelectAllBtn
            }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "XS", Scale)))

            local ClearAllBtn = Instance.new("TextButton")
            ClearAllBtn.Parent = Header
            ClearAllBtn.Position = UDim2.new(1, -ApplyScale(45, Scale), 0, 0)
            ClearAllBtn.Size = UDim2.new(0, ApplyScale(45, Scale), 1, 0)
            ClearAllBtn.BackgroundColor3 = Astral.Theme.Error
            ClearAllBtn.BackgroundTransparency = Astral.Design.Transparencies.Element
            ClearAllBtn.Text = "CLEAR"
            ClearAllBtn.Font = Enum.Font.GothamBold
            ClearAllBtn.TextColor3 = Astral.Theme.Text
            ClearAllBtn.TextSize = GetDesignValue(Astral.Design.FontSizes, "XS", Scale)
            CreateRoundedFrame(ClearAllBtn, {
                Parent = ClearAllBtn
            }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "XS", Scale)))

            local DropdownList = Instance.new("ScrollingFrame")
            DropdownList.Parent = DropdownFrame
            DropdownList.BackgroundTransparency = 1
            DropdownList.Position = UDim2.new(0, 0, 0, BaseElementHeight + HeaderHeight - CurrentPadding * 2)
            DropdownList.Size = UDim2.new(1, 0, 0, ListMaxHeight)
            DropdownList.ScrollBarThickness = 0
            DropdownList.ScrollBarImageTransparency = 1
            DropdownList.ScrollBarImageColor3 = Astral.Theme.Accent
            DropdownList.BorderSizePixel = 0
            DropdownList.VerticalScrollBarInset = Enum.ScrollBarInset.None
            DropdownList.HorizontalScrollBarInset = Enum.ScrollBarInset.None
            DropdownList.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
            DropdownList.Visible = false
            
            ApplyPadding(DropdownList, {Top = Astral.Design.Padding.SM, Bottom = Astral.Design.Padding.SM}, Scale)
            CreateScrollBar(DropdownList)

            local DropdownLayout = Instance.new("UIListLayout")
            DropdownLayout.Parent = DropdownList
            DropdownLayout.Padding = UDim.new(0, CurrentPadding)

            -- Original multi-dropdown logic remains the same
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
                    OptionButton.BackgroundTransparency = IsSelected and 0.15 or Astral.Design.Transparencies.Element
                    OptionButton.Size = UDim2.new(1, 0, 0, ApplyScale(26, Scale))
                    OptionButton.Text = Option
                    OptionButton.Font = IsSelected and Enum.Font.GothamBold or Enum.Font.Gotham
                    OptionButton.TextColor3 = IsSelected and Astral.Theme.Text or Astral.Theme.TextDark
                    OptionButton.TextSize = GetDesignValue(Astral.Design.FontSizes, "SM", Scale)
                    CreateRoundedFrame(OptionButton, {
                        Parent = OptionButton
                    }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "XS", Scale)))

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
                DropdownList.CanvasSize = UDim2.new(0, 0, 0, DropdownLayout.AbsoluteContentSize.Y + CurrentPadding)
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
                if Dropped then 
                    Refresh()
                    Header.Visible = true
                    DropdownList.Visible = true
                    
                    CenterElement(PageFrame, DropdownFrame, TotalHeightWhenDropped)
                    
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {
                        Size = UDim2.new(1, 0, 0, TotalHeightWhenDropped)
                    }):Play()
                    TweenService:Create(ArrowImage, TweenInfo.new(0.2), {
                        Rotation = 180
                    }):Play()
                else
                    Header.Visible = false
                    DropdownList.Visible = false
                    
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {
                        Size = UDim2.new(1, 0, 0, BaseElementHeight)
                    }):Play()
                    TweenService:Create(ArrowImage, TweenInfo.new(0.2), {
                        Rotation = 0
                    }):Play()
                end
            end)
        end

        -- Keybind Element
        function TabFunctions:Keybind(Options, Parent)
            Parent = Parent or PageFrame
            local KeybindName = Options.Name or "Keybind"
            local Default = Options.Default or Enum.KeyCode.E
            local Callback = Options.Callback or function() end
            local Current = Default

            local KeybindFrame = CreateRoundedFrame(Parent, {
                Parent = Parent,
                BackgroundColor3 = Astral.Theme.Main,
                BackgroundTransparency = Astral.Design.Transparencies.Element,
                Size = UDim2.new(1, 0, 0, CurrentElementHeight),
                ClipsDescendants = true
            }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "SM", Scale)))

            CreateTextLabel(KeybindFrame, {
                Parent = KeybindFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.GothamMedium,
                Text = KeybindName,
                TextColor3 = Astral.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left
            }, "MD")
            ApplyPadding(KeybindFrame, Astral.Design.Padding.SM, Scale)

            local KeybindButton = CreateRoundedFrame(KeybindFrame, {
                Parent = KeybindFrame,
                BackgroundColor3 = Astral.Theme.Tertiary,
                BackgroundTransparency = Astral.Design.Transparencies.Element,
                Position = UDim2.new(1, -ApplyScale(70, Scale), 0.5, -ApplyScale(12, Scale)),
                Size = UDim2.new(0, ApplyScale(58, Scale), 0, ApplyScale(24, Scale))
            }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "XS", Scale)))

            CreateStyledStroke(KeybindButton, {
                Parent = KeybindButton,
                Color = Astral.Theme.Stroke,
                Thickness = ApplyScale(1, Scale),
                Transparency = 0.5
            })

            local KeybindText = Instance.new("TextButton")
            KeybindText.Parent = KeybindButton
            KeybindText.BackgroundTransparency = 1
            KeybindText.Size = UDim2.new(1, 0, 1, 0)
            KeybindText.Font = Enum.Font.GothamBold
            KeybindText.Text = Current.Name
            KeybindText.TextColor3 = Astral.Theme.Accent
            KeybindText.TextSize = GetDesignValue(Astral.Design.FontSizes, "XS", Scale)
            KeybindText.AutoButtonColor = false

            local Binding = false
            KeybindText.MouseButton1Click:Connect(function()
                Binding = true
                KeybindText.Text = "..."
                KeybindText.TextColor3 = Astral.Theme.Warning
            end)

            UserInputService.InputBegan:Connect(function(input, GameProcessed)
                if not GameProcessed and Binding and input.UserInputType == Enum.UserInputType.Keyboard then
                    Current = input.KeyCode
                    KeybindText.Text = Current.Name
                    KeybindText.TextColor3 = Astral.Theme.Accent
                    Binding = false
                    Callback(Current)
                elseif not GameProcessed and input.KeyCode == Current then
                    Callback(Current)
                end
            end)
        end

        -- Label Element
        function TabFunctions:Label(Options, Parent)
            Parent = Parent or PageFrame
            local LabelText = Options.Text or "Label"

            local LabelFrame = CreateRoundedFrame(Parent, {
                Parent = Parent,
                BackgroundColor3 = Astral.Theme.Main,
                BackgroundTransparency = Astral.Design.Transparencies.Element,
                Size = UDim2.new(1, 0, 0, ApplyScale(30, Scale)),
                ClipsDescendants = true
            }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "SM", Scale)))

            local Label = CreateTextLabel(LabelFrame, {
                Parent = LabelFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.Gotham,
                Text = LabelText,
                TextColor3 = Astral.Theme.TextDark,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true
            }, "SM")
            ApplyPadding(Label, Astral.Design.Padding.SM, Scale)

            local LabelObject = {}
            function LabelObject:SetText(Text)
                Label.Text = Text
            end
            return LabelObject
        end

        return TabFunctions
    end

    return WindowFunctions
end

return Astral
