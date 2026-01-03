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

Astral.Design = {
    BaseScale = 1,
    Spacing = {
        ExtraSmall = 2,
        Small = 4,
        Medium = 6,
        Large = 8,
        ExtraLarge = 10
    },
    BorderRadius = {
        ExtraSmall = 3,
        Small = 4,
        Medium = 6,
        Large = 8,
        ExtraLarge = 10
    },
    ElementHeight = 28,
    TopbarHeight = 32,
    ButtonSize = 24,
    IconSize = 14,
    BaseWidth = 560,
    BaseHeight = 380,
    FontSizes = {
        ExtraSmall = 9,
        Small = 10,
        Medium = 11,
        Large = 12,
        ExtraLarge = 13
    },
    Transparencies = {
        Background = 0.12,
        Element = 0.2,
        Stroke = 0.35,
        ScrollBar = 0.25,
        Hover = 0.12
    }
}

local IsStudio = game:GetService("RunService"):IsStudio()
local TargetParent = IsStudio and Player.PlayerGui or CoreGui

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

local function ApplyScale(value, scale)
    return math.floor(value * scale + 0.5)
end

local function GetDesignValue(designTable, key, scale)
    local value = designTable[key] or designTable.Medium
    return ApplyScale(value, scale)
end

local function ApplyCompactPadding(parent, paddingValues, scale)
    local padding = Instance.new("UIPadding")
    padding.Parent = parent
    
    if type(paddingValues) == "table" then
        padding.PaddingTop = UDim.new(0, ApplyScale(paddingValues.Top or 0, scale))
        padding.PaddingRight = UDim.new(0, ApplyScale(paddingValues.Right or 0, scale))
        padding.PaddingBottom = UDim.new(0, ApplyScale(paddingValues.Bottom or 0, scale))
        padding.PaddingLeft = UDim.new(0, ApplyScale(paddingValues.Left or 0, scale))
    else
        local padded = ApplyScale(paddingValues, scale)
        padding.PaddingTop = UDim.new(0, padded)
        padding.PaddingRight = UDim.new(0, padded)
        padding.PaddingBottom = UDim.new(0, padded)
        padding.PaddingLeft = UDim.new(0, padded)
    end
    
    return padding
end

local function CreateElement(elementType, parent, properties)
    local element = Instance.new(elementType)
    
    for property, value in pairs(properties) do
        if property == "Parent" then
            element.Parent = value
        else
            element[property] = value
        end
    end
    
    return element
end

local function CreateRoundedElement(elementType, parent, properties, borderRadius)
    local element = CreateElement(elementType, parent, properties)
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = borderRadius
    corner.Parent = element
    
    return element, corner
end

local function CreateFrame(parent, properties, borderRadius)
    local frame = CreateElement("Frame", parent, properties)
    
    if borderRadius then
        local corner = Instance.new("UICorner")
        corner.CornerRadius = borderRadius
        corner.Parent = frame
    end
    
    return frame
end

local function CreateRoundedFrame(parent, properties, borderRadius)
    return CreateRoundedElement("Frame", parent, properties, borderRadius)
end

local function CreateStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Parent = parent
    stroke.Color = color
    stroke.Thickness = thickness
    stroke.Transparency = transparency or 0
    return stroke
end

local function CreateButton(parent, text, callback, options)
    options = options or {}
    local scale = options.Scale or Astral.Design.BaseScale
    local size = options.Size or UDim2.new(1, 0, 0, GetDesignValue(Astral.Design, "ElementHeight", scale))
    local position = options.Position or UDim2.new(0, 0, 0, 0)
    local textSize = GetDesignValue(Astral.Design.FontSizes, options.FontSize or "Medium", scale)
    local borderRadius = UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, options.BorderRadius or "Small", scale))
    
    local button = CreateElement("TextButton", parent, {
        Parent = parent,
        BackgroundColor3 = options.BackgroundColor or Astral.Theme.Main,
        BackgroundTransparency = options.BackgroundTransparency or Astral.Design.Transparencies.Element,
        Size = size,
        Position = position,
        Text = text,
        TextColor3 = options.TextColor or Astral.Theme.Text,
        Font = options.Font or Enum.Font.GothamMedium,
        TextSize = textSize,
        AutoButtonColor = false
    })
    
    if borderRadius.Offset > 0 then
        CreateElement("UICorner", button, {CornerRadius = borderRadius})
    end
    
    if options.Padding then
        ApplyCompactPadding(button, options.Padding, scale)
    end
    
    if options.Stroke then
        CreateStroke(button, Astral.Theme.Stroke, 1, 0.5)
    end
    
    local originalColor = button.BackgroundColor3
    local originalTransparency = button.BackgroundTransparency
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15), {
            BackgroundColor3 = Astral.Theme.HoverBright,
            BackgroundTransparency = Astral.Design.Transparencies.Hover
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.15), {
            BackgroundColor3 = originalColor,
            BackgroundTransparency = originalTransparency
        }):Play()
    end)
    
    local originalSize = button.Size
    button.MouseButton1Down:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.08), {
            Size = UDim2.new(originalSize.X.Scale * 0.98, originalSize.X.Offset,
                            originalSize.Y.Scale * 0.98, originalSize.Y.Offset)
        }):Play()
    end)
    
    local function Restore()
        TweenService:Create(button, TweenInfo.new(0.15), {Size = originalSize}):Play()
    end
    
    button.MouseButton1Up:Connect(Restore)
    button.MouseLeave:Connect(Restore)
    
    if callback then
        button.MouseButton1Click:Connect(callback)
    end
    
    return button
end

local function CreateLabel(parent, text, options)
    options = options or {}
    local scale = options.Scale or Astral.Design.BaseScale
    local textSize = GetDesignValue(Astral.Design.FontSizes, options.FontSize or "Medium", scale)
    
    local label = CreateElement("TextLabel", parent, {
        Parent = parent,
        BackgroundTransparency = 1,
        Size = options.Size or UDim2.new(1, 0, 1, 0),
        Text = text,
        TextColor3 = options.TextColor or Astral.Theme.Text,
        Font = options.Font or Enum.Font.Gotham,
        TextSize = textSize,
        TextXAlignment = options.XAlignment or Enum.TextXAlignment.Left,
        TextYAlignment = options.YAlignment or Enum.TextYAlignment.Center
    })
    
    if options.Padding then
        ApplyCompactPadding(label, options.Padding, scale)
    end
    
    return label
end

local function CreateCompactListLayout(parent, padding, scale)
    local layout = Instance.new("UIListLayout")
    layout.Parent = parent
    layout.Padding = UDim.new(0, GetDesignValue(Astral.Design.Spacing, padding or "Medium", scale))
    return layout
end

local function CreateScrollingFrame(parent, options)
    options = options or {}
    local scale = options.Scale or Astral.Design.BaseScale
    
    local scrollingFrame = CreateElement("ScrollingFrame", parent, {
        Parent = parent,
        BackgroundTransparency = 1,
        Size = options.Size or UDim2.new(1, 0, 1, 0),
        Position = options.Position or UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 0,
        ScrollBarImageTransparency = 1,
        BorderSizePixel = 0,
        ScrollingEnabled = true,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    })
    
    if options.Padding then
        ApplyCompactPadding(scrollingFrame, options.Padding, scale)
    end
    
    return scrollingFrame
end

local function MakeDraggable(DragBar, WindowObject)
    local Dragging, DragInput, DragStart, StartPosition

    local function Update(input)
        local Delta = input.Position - DragStart
        WindowObject.Position = UDim2.new(
            StartPosition.X.Scale, StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y
        )
    end

    DragBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
end

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
                ScrollBarThickness = 3,
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
            local ScrollBarPosition = ScrollingFrame.AbsolutePosition + Vector2.new(ScrollingFrame.AbsoluteSize.X - 8, 0)
            local ScrollBarSize = Vector2.new(8, ScrollingFrame.AbsoluteSize.Y)

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

        TweenService:Create(ScrollingFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
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

function Astral:Window(Options)
    local WindowName = Options.Name or "Astral"
    local Scale = Options.Scale or 1
    Astral.Design.BaseScale = Scale

    local ScreenGui = CreateElement("ScreenGui", TargetParent, {
        Name = "AstralUI",
        DisplayOrder = 999,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })

    local CurrentWidth = ApplyScale(Astral.Design.BaseWidth, Scale)
    local CurrentHeight = ApplyScale(Astral.Design.BaseHeight, Scale)
    local CurrentSpacing = GetDesignValue(Astral.Design.Spacing, "Medium", Scale)
    local CurrentElementHeight = GetDesignValue(Astral.Design, "ElementHeight", Scale)
    local CurrentTopbarHeight = GetDesignValue(Astral.Design, "TopbarHeight", Scale)
    local CurrentBorderRadius = GetDesignValue(Astral.Design.BorderRadius, "Medium", Scale)

    local MainFrame, MainCorner = CreateRoundedElement("Frame", ScreenGui, {
        BackgroundColor3 = Astral.Theme.Main,
        BackgroundTransparency = Astral.Design.Transparencies.Background,
        Position = UDim2.new(0.5, -CurrentWidth / 2, 0.5, -CurrentHeight / 2),
        Size = UDim2.new(0, CurrentWidth, 0, CurrentHeight),
        ClipsDescendants = true,
        Active = true
    }, UDim.new(0, CurrentBorderRadius))

    CreateStroke(MainFrame, Astral.Theme.Stroke, 1, Astral.Design.Transparencies.Stroke)

    local TopbarFrame, TopbarCorner = CreateRoundedElement("Frame", MainFrame, {
        Name = "Topbar",
        BackgroundColor3 = Astral.Theme.Tertiary,
        BackgroundTransparency = 0.15,
        Position = UDim2.new(0, CurrentSpacing, 0, CurrentSpacing),
        Size = UDim2.new(1, -ApplyScale(74, Scale), 0, CurrentTopbarHeight),
        ZIndex = 5
    }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "Small", Scale)))

    CreateLabel(TopbarFrame, WindowName, {
        Font = Enum.Font.GothamBold,
        FontSize = "Large",
        Padding = Astral.Design.Spacing.Small
    })

    MakeDraggable(TopbarFrame, MainFrame)

    local ControlsFrame = CreateElement("Frame", MainFrame, {
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -ApplyScale(70, Scale), 0, CurrentSpacing),
        Size = UDim2.new(0, ApplyScale(64, Scale), 0, CurrentTopbarHeight),
        ZIndex = 10
    })

    local CloseButton = CreateButton(ControlsFrame, "×", function()
        local Tween = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        Tween:Play()
        task.wait(0.2)
        ScreenGui:Destroy()
    end, {
        Size = UDim2.new(0, GetDesignValue(Astral.Design, "ButtonSize", Scale), 1, 0),
        Position = UDim2.new(1, -GetDesignValue(Astral.Design, "ButtonSize", Scale) - CurrentSpacing, 0, 0),
        BackgroundColor = Astral.Theme.Tertiary,
        TextColor = Astral.Theme.Error,
        FontSize = "ExtraLarge",
        BorderRadius = "Small"
    })

    local MinimizeButton = CreateButton(ControlsFrame, "−", function()
        MainFrame.Visible = not MainFrame.Visible
    end, {
        Size = UDim2.new(0, GetDesignValue(Astral.Design, "ButtonSize", Scale), 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor = Astral.Theme.Tertiary,
        TextColor = Astral.Theme.TextDark,
        FontSize = "ExtraLarge",
        BorderRadius = "Small"
    })

    local Bubble = CreateElement("TextButton", ScreenGui, {
        Name = "AstralBubble",
        BackgroundColor3 = Astral.Theme.Main,
        Position = UDim2.new(1, -ApplyScale(60, Scale), 0.5, -ApplyScale(20, Scale)),
        Size = UDim2.new(0, ApplyScale(40, Scale), 0, ApplyScale(40, Scale)),
        ZIndex = 500,
        Text = "",
        AutoButtonColor = false
    })

    CreateElement("UICorner", Bubble, {CornerRadius = UDim.new(1, 0)})
    
    local BubbleIcon = CreateElement("ImageLabel", Bubble, {
        BackgroundTransparency = 1,
        Size = UDim2.new(0.7, 0, 0.7, 0),
        Position = UDim2.new(0.15, 0, 0.15, 0),
        Image = Options.Icon or "rbxassetid://7733954760",
        ImageColor3 = Astral.Theme.Accent,
        ScaleType = Enum.ScaleType.Fit
    })

    CreateStroke(Bubble, Astral.Theme.Stroke, 1, 0.3)

    local BubbleDragging = false
    local DragInput, DragStart, StartPosition

    local function SnapToSide()
        local ScreenSize = ScreenGui.AbsoluteSize
        local CurrentPosition = Bubble.AbsolutePosition
        local CenterX = ScreenSize.X / 2

        local TargetX = (CurrentPosition.X + ApplyScale(20, Scale) < CenterX) and ApplyScale(10, Scale) or (ScreenSize.X - ApplyScale(50, Scale))
        local TargetY = math.clamp(CurrentPosition.Y, ApplyScale(10, Scale), ScreenSize.Y - ApplyScale(50, Scale))

        TweenService:Create(Bubble, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
            Position = UDim2.new(0, TargetX, 0, TargetY)
        }):Play()
    end

    Bubble.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            BubbleDragging = true
            DragStart = input.Position
            StartPosition = Bubble.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    BubbleDragging = false
                    SnapToSide()
                end
            end)
        end
    end)

    Bubble.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and BubbleDragging then
            local Delta = input.Position - DragStart
            Bubble.Position = UDim2.new(
                StartPosition.X.Scale, StartPosition.X.Offset + Delta.X,
                StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y
            )
        end
    end)

    Bubble.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)

    local ContentFrame = CreateElement("Frame", MainFrame, {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, CurrentTopbarHeight + CurrentSpacing),
        Size = UDim2.new(1, 0, 1, -(CurrentTopbarHeight + CurrentSpacing)),
        ClipsDescendants = true
    })

    local SidebarFrame, SidebarCorner = CreateRoundedElement("Frame", ContentFrame, {
        BackgroundColor3 = Astral.Theme.Tertiary,
        BackgroundTransparency = 0.15,
        Position = UDim2.new(0, CurrentSpacing, 0, 0),
        Size = UDim2.new(0, ApplyScale(110, Scale), 1, -CurrentSpacing)
    }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "Small", Scale)))

    CreateStroke(SidebarFrame, Astral.Theme.StrokeDark, 0.5, 0.3)

    local TabContainer = CreateScrollingFrame(SidebarFrame, {
        Position = UDim2.new(0, CurrentSpacing, 0, CurrentSpacing),
        Size = UDim2.new(1, -CurrentSpacing * 2, 1, -CurrentSpacing * 2),
        Scale = Scale
    })
    CreateScrollBar(TabContainer)

    local TabLayout = CreateCompactListLayout(TabContainer, "Small", Scale)
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + CurrentSpacing)
    end)

    local PagesFrame, PagesCorner = CreateRoundedElement("Frame", ContentFrame, {
        BackgroundColor3 = Astral.Theme.Secondary,
        BackgroundTransparency = 0.15,
        Position = UDim2.new(0, ApplyScale(110 + CurrentSpacing * 2, Scale), 0, 0),
        Size = UDim2.new(1, -ApplyScale(110 + CurrentSpacing * 3, Scale), 1, -CurrentSpacing)
    }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "Small", Scale)))

    local PagesContainer = CreateElement("Frame", PagesFrame, {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ClipsDescendants = true
    })
    ApplyCompactPadding(PagesContainer, Astral.Design.Spacing.Small, Scale)

    local WindowFunctions = {}
    local FirstTab = true
    local AllTabs = {}

    local NotificationQueue = {}
    local ActiveNotifications = {}
    local MaxNotifications = 5

    local function UpdateNotificationPositions()
        for Index, Notification in ipairs(ActiveNotifications) do
            local TargetYOffset = -ApplyScale(20, Scale) - ((Index - 1) * ApplyScale(70, Scale))
            TweenService:Create(Notification, TweenInfo.new(0.2), {
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

        local NotificationFrame = CreateRoundedElement("Frame", ScreenGui, {
            BackgroundColor3 = Astral.Theme.Main,
            BackgroundTransparency = Astral.Design.Transparencies.Background,
            Size = UDim2.new(0, ApplyScale(280, Scale), 0, ApplyScale(60, Scale)),
            AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.new(1.5, 0, 1, -ApplyScale(20, Scale)),
            ZIndex = 100
        }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "Small", Scale)))[1]

        CreateStroke(NotificationFrame, TypeColors[Type], 1, 0.4)

        CreateLabel(NotificationFrame, Title, {
            Size = UDim2.new(1, 0, 0, ApplyScale(16, Scale)),
            Font = Enum.Font.GothamBold,
            FontSize = "Small",
            Padding = Astral.Design.Spacing.Small
        })

        local ContentLabel = CreateLabel(NotificationFrame, Content, {
            Position = UDim2.new(0, 0, 0, ApplyScale(20, Scale)),
            Size = UDim2.new(1, 0, 1, -ApplyScale(26, Scale)),
            Font = Enum.Font.Gotham,
            FontSize = "ExtraSmall",
            TextColor = Astral.Theme.TextDark,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true,
            Padding = Astral.Design.Spacing.Small
        })

        table.insert(ActiveNotifications, NotificationFrame)
        UpdateNotificationPositions()

        TweenService:Create(NotificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
            Position = UDim2.new(1, -ApplyScale(20, Scale), 1, NotificationFrame.Position.Y.Offset)
        }):Play()

        task.delay(Duration, function()
            TweenService:Create(NotificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Position = UDim2.new(1.5, 0, 1, NotificationFrame.Position.Y.Offset),
                BackgroundTransparency = 1
            }):Play()

            task.wait(0.3)
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
    end

    function WindowFunctions:Tab(Options)
        local TabName = Options.Name or "Tab"
        local TabIcon = Options.Icon or "rbxassetid://7733954760"

        local TabButton = CreateButton(TabContainer, "", nil, {
            Size = UDim2.new(1, 0, 0, CurrentElementHeight),
            BackgroundTransparency = 0.2,
            BorderRadius = "Small"
        })

        local IconImage = CreateElement("ImageLabel", TabButton, {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, CurrentSpacing, 0.5, -ApplyScale(7, Scale)),
            Size = UDim2.new(0, GetDesignValue(Astral.Design, "IconSize", Scale), 0, GetDesignValue(Astral.Design, "IconSize", Scale)),
            Image = TabIcon,
            ImageColor3 = Astral.Theme.TextDark
        })

        local LabelText = CreateLabel(TabButton, TabName, {
            Position = UDim2.new(0, ApplyScale(24, Scale), 0, 0),
            Size = UDim2.new(1, -ApplyScale(30, Scale), 1, 0),
            Font = Enum.Font.GothamMedium,
            FontSize = "Small",
            TextColor = Astral.Theme.TextDark
        })

        local IndicatorFrame = CreateElement("Frame", TabButton, {
            Name = "Indicator",
            BackgroundColor3 = Astral.Theme.Accent,
            BorderSizePixel = 0,
            Position = UDim2.new(0, ApplyScale(1, Scale), 0.5, -ApplyScale(7, Scale)),
            Size = UDim2.new(0, ApplyScale(2, Scale), 0, ApplyScale(14, Scale)),
            Visible = false
        })

        local PageFrame = CreateScrollingFrame(PagesContainer, {
            Name = TabName,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
            Scale = Scale
        })
        ApplyCompactPadding(PageFrame, Astral.Design.Spacing.Small, Scale)
        CreateScrollBar(PageFrame)

        local PageLayout = CreateCompactListLayout(PageFrame, "Small", Scale)
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            PageFrame.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + CurrentSpacing * 2)
        end)

        local function Activate()
            for _, Page in pairs(PagesContainer:GetChildren()) do
                if Page:IsA("ScrollingFrame") then
                    Page.Visible = false
                end
            end
            for _, TabData in pairs(AllTabs) do
                TabData.Indicator.Visible = false
                TweenService:Create(TabData.Button, TweenInfo.new(0.15), {
                    BackgroundColor3 = Astral.Theme.Main,
                    BackgroundTransparency = 0.2
                }):Play()
                TweenService:Create(TabData.Label, TweenInfo.new(0.15), {TextColor3 = Astral.Theme.TextDark}):Play()
                TweenService:Create(TabData.Icon, TweenInfo.new(0.15), {ImageColor3 = Astral.Theme.TextDark}):Play()
            end
            PageFrame.Visible = true
            IndicatorFrame.Visible = true
            TweenService:Create(TabButton, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.fromRGB(5, 5, 8),
                BackgroundTransparency = 0.1
            }):Play()
            TweenService:Create(LabelText, TweenInfo.new(0.15), {TextColor3 = Astral.Theme.Text}):Play()
            TweenService:Create(IconImage, TweenInfo.new(0.15), {ImageColor3 = Astral.Theme.Accent}):Play()
        end

        TabButton.MouseButton1Click:Connect(Activate)
        table.insert(AllTabs, {Button = TabButton, Label = LabelText, Icon = IconImage, Indicator = IndicatorFrame})

        if FirstTab then
            FirstTab = false
            Activate()
        end

        local TabFunctions = {}

        function TabFunctions:Section(Options)
            local SectionName = Options.Name or "Section"

            local SectionFrame = CreateRoundedFrame(PageFrame, {
                BackgroundColor3 = Astral.Theme.Tertiary,
                BackgroundTransparency = Astral.Design.Transparencies.Element,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y
            }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "Small", Scale)))

            local HeaderFrame = CreateRoundedFrame(SectionFrame, {
                BackgroundColor3 = Astral.Theme.Main,
                BackgroundTransparency = 0.15,
                Size = UDim2.new(1, 0, 0, CurrentElementHeight)
            }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "Small", Scale)))

            CreateLabel(HeaderFrame, SectionName, {
                Font = Enum.Font.GothamBold,
                FontSize = "Medium",
                Padding = Astral.Design.Spacing.Small
            })

            local SectionContent = CreateElement("Frame", SectionFrame, {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, CurrentElementHeight),
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y
            })
            ApplyCompactPadding(SectionContent, Astral.Design.Spacing.Small, Scale)

            CreateCompactListLayout(SectionContent, "Small", Scale)

            local SectionFunctions = {}
            for _, functionName in pairs({"Button", "Toggle", "Slider", "TextBox", "Dropdown", "MultiDropdown", "Keybind", "Label"}) do
                SectionFunctions[functionName] = function(Options)
                    return TabFunctions[functionName](Options, SectionContent)
                end
            end

            return SectionFunctions
        end

        function TabFunctions:Button(Options, Parent)
            Parent = Parent or PageFrame
            local ButtonName = Options.Name or "Button"
            local Callback = Options.Callback or function() end

            return CreateButton(Parent, ButtonName, Callback, {
                Size = UDim2.new(1, 0, 0, CurrentElementHeight),
                BackgroundTransparency = Astral.Design.Transparencies.Element,
                BorderRadius = "Small",
                FontSize = "Small",
                Padding = Astral.Design.Spacing.Small
            })
        end

        function TabFunctions:Toggle(Options, Parent)
            Parent = Parent or PageFrame
            local ToggleName = Options.Name or "Toggle"
            local Default = Options.Default or false
            local Callback = Options.Callback or function() end
            local State = Default

            local ToggleFrame = CreateRoundedFrame(Parent, {
                BackgroundColor3 = Astral.Theme.Main,
                BackgroundTransparency = Astral.Design.Transparencies.Element,
                Size = UDim2.new(1, 0, 0, CurrentElementHeight),
                ClipsDescendants = true
            }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "Small", Scale)))

            CreateLabel(ToggleFrame, ToggleName, {
                FontSize = "Small",
                Padding = Astral.Design.Spacing.Small
            })

            local CheckButton = CreateElement("TextButton", ToggleFrame, {
                BackgroundColor3 = State and Astral.Theme.Accent or Astral.Theme.Tertiary,
                Position = UDim2.new(1, -ApplyScale(40, Scale), 0.5, -ApplyScale(8, Scale)),
                Size = UDim2.new(0, ApplyScale(36, Scale), 0, ApplyScale(16, Scale)),
                AutoButtonColor = false,
                Text = ""
            })

            CreateElement("UICorner", CheckButton, {CornerRadius = UDim.new(1, 0)})

            local CircleFrame = CreateElement("Frame", CheckButton, {
                BackgroundColor3 = Astral.Theme.Text,
                Size = UDim2.new(0, ApplyScale(12, Scale), 0, ApplyScale(12, Scale)),
                Position = State and UDim2.new(1, -ApplyScale(14, Scale), 0.5, -ApplyScale(6, Scale)) 
                          or UDim2.new(0, ApplyScale(2, Scale), 0.5, -ApplyScale(6, Scale))
            })

            CreateElement("UICorner", CircleFrame, {CornerRadius = UDim.new(1, 0)})

            local function Update()
                local Position = State and UDim2.new(1, -ApplyScale(14, Scale), 0.5, -ApplyScale(6, Scale)) 
                              or UDim2.new(0, ApplyScale(2, Scale), 0.5, -ApplyScale(6, Scale))
                local Color = State and Astral.Theme.Accent or Astral.Theme.Tertiary
                TweenService:Create(CircleFrame, TweenInfo.new(0.15), {Position = Position}):Play()
                TweenService:Create(CheckButton, TweenInfo.new(0.15), {BackgroundColor3 = Color}):Play()
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
            local Minimum = Options.Min or 0
            local Maximum = Options.Max or 100
            local Default = Options.Default or Minimum
            local Increment = Options.Increment or 1
            local Callback = Options.Callback or function() end
            local Value = Default

            local SliderFrame = CreateRoundedFrame(Parent, {
                BackgroundColor3 = Astral.Theme.Main,
                BackgroundTransparency = Astral.Design.Transparencies.Element,
                Size = UDim2.new(1, 0, 0, ApplyScale(44, Scale)),
                ClipsDescendants = true
            }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "Small", Scale)))

            CreateLabel(SliderFrame, SliderName, {
                Size = UDim2.new(1, 0, 0, ApplyScale(16, Scale)),
                FontSize = "Small",
                Padding = Astral.Design.Spacing.Small
            })

            local ValueInput = CreateElement("TextBox", SliderFrame, {
                BackgroundColor3 = Astral.Theme.Tertiary,
                BackgroundTransparency = Astral.Design.Transparencies.Element,
                Position = UDim2.new(1, -ApplyScale(52, Scale), 0, ApplyScale(4, Scale)),
                Size = UDim2.new(0, ApplyScale(44, Scale), 0, ApplyScale(18, Scale)),
                Font = Enum.Font.GothamBold,
                Text = tostring(Value),
                TextColor3 = Astral.Theme.Accent,
                TextSize = GetDesignValue(Astral.Design.FontSizes, "ExtraSmall", Scale),
                ClearTextOnFocus = false
            })

            CreateElement("UICorner", ValueInput, {CornerRadius = UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "ExtraSmall", Scale))})
            CreateStroke(ValueInput, Astral.Theme.Stroke, 0.5, 0.5)

            local BackgroundFrame = CreateRoundedFrame(SliderFrame, {
                BackgroundColor3 = Astral.Theme.Tertiary,
                Position = UDim2.new(0, CurrentSpacing, 1, -ApplyScale(16, Scale)),
                Size = UDim2.new(1, -CurrentSpacing * 2, 0, ApplyScale(5, Scale))
            }, UDim.new(1, 0))

            local FillFrame = CreateRoundedFrame(BackgroundFrame, {
                BackgroundColor3 = Astral.Theme.Accent,
                Size = UDim2.new((Value - Minimum) / (Maximum - Minimum), 0, 1, 0)
            }, UDim.new(1, 0))

            local BallFrame = CreateRoundedFrame(BackgroundFrame, {
                BackgroundColor3 = Astral.Theme.Text,
                Size = UDim2.new(0, ApplyScale(12, Scale), 0, ApplyScale(12, Scale)),
                Position = UDim2.new((Value - Minimum) / (Maximum - Minimum), -ApplyScale(6, Scale), 0.5, -ApplyScale(6, Scale)),
                ZIndex = 2
            }, UDim.new(1, 0))

            local Dragging = false

            local function Update(input)
                local SizeX = BackgroundFrame.AbsoluteSize.X
                local OffsetX = math.clamp(input.Position.X - BackgroundFrame.AbsolutePosition.X, 0, SizeX)
                local Percentage = OffsetX / SizeX

                Value = math.floor(((Maximum - Minimum) * Percentage + Minimum) / Increment + 0.5) * Increment
                Value = math.clamp(Value, Minimum, Maximum)

                local VisualPercentage = (Value - Minimum) / (Maximum - Minimum)

                TweenService:Create(FillFrame, TweenInfo.new(0.05), {Size = UDim2.new(VisualPercentage, 0, 1, 0)}):Play()
                TweenService:Create(BallFrame, TweenInfo.new(0.05), {Position = UDim2.new(VisualPercentage, -ApplyScale(6, Scale), 0.5, -ApplyScale(6, Scale))}):Play()
                ValueInput.Text = tostring(Value)
                Callback(Value)
            end

            BackgroundFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = true
                    CenterElement(PageFrame, SliderFrame)
                    Update(input)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    Update(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = false
                end
            end)

            ValueInput.Focused:Connect(function()
                CenterElement(PageFrame, SliderFrame)
            end)

            ValueInput.FocusLost:Connect(function()
                local InputValue = tonumber(ValueInput.Text)
                if InputValue then
                    Value = math.clamp(math.floor(InputValue / Increment + 0.5) * Increment, Minimum, Maximum)
                    local VisualPercentage = (Value - Minimum) / (Maximum - Minimum)
                    TweenService:Create(FillFrame, TweenInfo.new(0.15), {Size = UDim2.new(VisualPercentage, 0, 1, 0)}):Play()
                    TweenService:Create(BallFrame, TweenInfo.new(0.15), {Position = UDim2.new(VisualPercentage, -ApplyScale(6, Scale), 0.5, -ApplyScale(6, Scale))}):Play()
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

            local TextBoxFrame = CreateRoundedFrame(Parent, {
                BackgroundColor3 = Astral.Theme.Main,
                BackgroundTransparency = Astral.Design.Transparencies.Element,
                Size = UDim2.new(1, 0, 0, ApplyScale(40, Scale)),
                ClipsDescendants = true
            }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "Small", Scale)))

            CreateLabel(TextBoxFrame, TextBoxName, {
                Size = UDim2.new(1, 0, 0, ApplyScale(16, Scale)),
                FontSize = "Small",
                Padding = Astral.Design.Spacing.Small
            })

            local InputBox = CreateElement("TextBox", TextBoxFrame, {
                BackgroundColor3 = Astral.Theme.Tertiary,
                BackgroundTransparency = Astral.Design.Transparencies.Element,
                Position = UDim2.new(0, CurrentSpacing, 0, ApplyScale(22, Scale)),
                Size = UDim2.new(1, -CurrentSpacing * 2, 0, ApplyScale(16, Scale)),
                Font = Enum.Font.Gotham,
                PlaceholderText = Placeholder,
                PlaceholderColor3 = Astral.Theme.TextDarker,
                Text = Default,
                TextColor3 = Astral.Theme.Text,
                TextSize = GetDesignValue(Astral.Design.FontSizes, "Small", Scale),
                ClearTextOnFocus = false
            })

            CreateElement("UICorner", InputBox, {CornerRadius = UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "ExtraSmall", Scale))})
            CreateStroke(InputBox, Astral.Theme.Stroke, 0.5, 0.5)

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

            local BaseElementHeight = CurrentElementHeight
            local ListMaxHeight = ApplyScale(100, Scale)
            local HeaderHeight = ApplyScale(26, Scale)
            
            local TotalHeightWhenDropped = BaseElementHeight + HeaderHeight + ListMaxHeight + CurrentSpacing * 2

            local DropdownFrame = CreateRoundedFrame(Parent, {
                BackgroundColor3 = Astral.Theme.Main,
                BackgroundTransparency = Astral.Design.Transparencies.Element,
                Size = UDim2.new(1, 0, 0, BaseElementHeight),
                ClipsDescendants = true
            }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "Small", Scale)))
            
            ApplyCompactPadding(DropdownFrame, Astral.Design.Spacing.Small, Scale)

            local DropdownButton = CreateButton(DropdownFrame, "", nil, {
                Size = UDim2.new(1, 0, 0, BaseElementHeight - CurrentSpacing * 2),
                BackgroundTransparency = 1
            })

            local DropdownLabel = CreateLabel(DropdownButton, DropdownName .. (CurrentSelected and (": " .. tostring(CurrentSelected)) or ""), {
                FontSize = "Small",
                Padding = Astral.Design.Spacing.Small
            })

            local ArrowImage = CreateElement("ImageLabel", DropdownButton, {
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -ApplyScale(20, Scale), 0.5, -ApplyScale(5, Scale)),
                Size = UDim2.new(0, ApplyScale(10, Scale), 0, ApplyScale(10, Scale)),
                Image = "rbxassetid://6031091004",
                ImageColor3 = Astral.Theme.Accent
            })

            local Header = CreateElement("Frame", DropdownFrame, {
                Position = UDim2.new(0, 0, 0, BaseElementHeight - CurrentSpacing),
                Size = UDim2.new(1, 0, 0, HeaderHeight),
                BackgroundTransparency = 1,
                Visible = false
            })

            local SearchBox = CreateElement("TextBox", Header, {
                Size = UDim2.new(1, -ApplyScale(50, Scale), 1, 0),
                BackgroundColor3 = Astral.Theme.Tertiary,
                BackgroundTransparency = Astral.Design.Transparencies.Element,
                PlaceholderText = "Search...",
                Text = "",
                TextColor3 = Astral.Theme.Text,
                Font = Enum.Font.Gotham,
                TextSize = GetDesignValue(Astral.Design.FontSizes, "ExtraSmall", Scale)
            })

            CreateElement("UICorner", SearchBox, {CornerRadius = UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "ExtraSmall", Scale))})
            CreateStroke(SearchBox, Astral.Theme.Stroke, 0.5, 0.5)

            local ClearButton = CreateButton(Header, "CLEAR", function()
                CurrentSelected = nil
                DropdownLabel.Text = DropdownName
                Callback(nil)
                Refresh(SearchBox.Text)
            end, {
                Size = UDim2.new(0, ApplyScale(45, Scale), 1, 0),
                Position = UDim2.new(1, -ApplyScale(45, Scale), 0, 0),
                BackgroundColor = Astral.Theme.Error,
                FontSize = "ExtraSmall",
                BorderRadius = "ExtraSmall"
            })

            local DropdownList = CreateScrollingFrame(DropdownFrame, {
                Position = UDim2.new(0, 0, 0, BaseElementHeight + HeaderHeight - CurrentSpacing * 2),
                Size = UDim2.new(1, 0, 0, ListMaxHeight),
                Visible = false,
                Scale = Scale
            })
            CreateScrollBar(DropdownList)

            ApplyCompactPadding(DropdownList, {Top = Astral.Design.Spacing.Small, Bottom = Astral.Design.Spacing.Small}, Scale)

            local DropdownLayout = CreateCompactListLayout(DropdownList, "Small", Scale)

            local function Refresh(filter)
                for _, Child in pairs(DropdownList:GetChildren()) do
                    if Child:IsA("TextButton") then Child:Destroy() end
                end
                for _, Option in pairs(DropdownOptions) do
                    if filter and filter ~= "" and not string.find(string.lower(Option), string.lower(filter)) then continue end

                    local IsSelected = (CurrentSelected == Option)
                    local OptionButton = CreateButton(DropdownList, Option, function()
                        CurrentSelected = Option
                        DropdownLabel.Text = DropdownName .. ": " .. Option
                        Callback(Option)
                        Refresh(SearchBox.Text)
                    end, {
                        Size = UDim2.new(1, 0, 0, ApplyScale(24, Scale)),
                        BackgroundColor = IsSelected and Astral.Theme.Accent or Astral.Theme.Tertiary,
                        BackgroundTransparency = IsSelected and 0.15 or Astral.Design.Transparencies.Element,
                        TextColor = IsSelected and Astral.Theme.Text or Astral.Theme.TextDark,
                        Font = IsSelected and Enum.Font.GothamBold or Enum.Font.Gotham,
                        FontSize = "ExtraSmall",
                        BorderRadius = "ExtraSmall"
                    })
                end

                local ContentHeight = DropdownLayout.AbsoluteContentSize.Y
                DropdownList.CanvasSize = UDim2.new(0, 0, 0, ContentHeight + CurrentSpacing)
                DropdownList.ScrollingEnabled = ContentHeight > ListMaxHeight
            end

            SearchBox:GetPropertyChangedSignal("Text"):Connect(function() 
                Refresh(SearchBox.Text) 
            end)

            DropdownButton.MouseButton1Click:Connect(function()
                Dropped = not Dropped
                if Dropped then 
                    Refresh()
                    Header.Visible = true
                    DropdownList.Visible = true
                    
                    CenterElement(PageFrame, DropdownFrame, TotalHeightWhenDropped)
                    
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.15), {
                        Size = UDim2.new(1, 0, 0, TotalHeightWhenDropped)
                    }):Play()
                    TweenService:Create(ArrowImage, TweenInfo.new(0.15), {
                        Rotation = 180
                    }):Play()
                else
                    Header.Visible = false
                    DropdownList.Visible = false
                    
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.15), {
                        Size = UDim2.new(1, 0, 0, BaseElementHeight)
                    }):Play()
                    TweenService:Create(ArrowImage, TweenInfo.new(0.15), {
                        Rotation = 0
                    }):Play()
                end
            end)

            local DropdownFunctions = {}
            function DropdownFunctions:SetOptions(Options)
                DropdownOptions = Options
                Refresh(SearchBox.Text)
            end
            
            function DropdownFunctions:SetValue(Value)
                CurrentSelected = Value
                DropdownLabel.Text = DropdownName .. (CurrentSelected and (": " .. tostring(CurrentSelected)) or "")
                Callback(CurrentSelected)
                Refresh(SearchBox.Text)
            end
            
            function DropdownFunctions:GetValue()
                return CurrentSelected
            end
            
            return DropdownFunctions
        end

        function TabFunctions:MultiDropdown(Options, Parent)
            Parent = Parent or PageFrame
            local DropdownName = Options.Name or "Multi-Dropdown"
            local DropdownOptions = Options.Options or {}
            local Default = Options.Default or {}
            local Callback = Options.Callback or function() end
            local Maximum = Options.Max or #DropdownOptions
            local Minimum = Options.Min or 0

            local Selected = {}
            local SelectionOrder = {}
            local Dropped = false

            for _, value in pairs(Default) do
                if #SelectionOrder < Maximum then
                    Selected[value] = true
                    table.insert(SelectionOrder, value)
                end
            end

            local BaseElementHeight = CurrentElementHeight
            local ListMaxHeight = ApplyScale(120, Scale)
            local HeaderHeight = ApplyScale(26, Scale)
            
            local TotalHeightWhenDropped = BaseElementHeight + HeaderHeight + ListMaxHeight + CurrentSpacing * 2

            local DropdownFrame = CreateRoundedFrame(Parent, {
                BackgroundColor3 = Astral.Theme.Main,
                BackgroundTransparency = Astral.Design.Transparencies.Element,
                Size = UDim2.new(1, 0, 0, BaseElementHeight),
                ClipsDescendants = true
            }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "Small", Scale)))
            
            ApplyCompactPadding(DropdownFrame, Astral.Design.Spacing.Small, Scale)

            local DropdownButton = CreateButton(DropdownFrame, "", nil, {
                Size = UDim2.new(1, 0, 0, BaseElementHeight - CurrentSpacing * 2),
                BackgroundTransparency = 1
            })

            local DropdownLabel = CreateLabel(DropdownButton, "", {
                FontSize = "Small",
                TextColor = Astral.Theme.Text,
                Padding = Astral.Design.Spacing.Small
            })

            local function UpdateLabel()
                if #SelectionOrder == 0 then
                    DropdownLabel.Text = DropdownName
                else
                    local combinedText = DropdownName .. ": " .. table.concat(SelectionOrder, ", ")
                    DropdownLabel.Text = string.sub(combinedText, 1, 50) .. (#combinedText > 50 and "..." or "")
                end
            end
            UpdateLabel()

            local ArrowImage = CreateElement("ImageLabel", DropdownButton, {
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -ApplyScale(20, Scale), 0.5, -ApplyScale(5, Scale)),
                Size = UDim2.new(0, ApplyScale(10, Scale), 0, ApplyScale(10, Scale)),
                Image = "rbxassetid://6031091004",
                ImageColor3 = Astral.Theme.Accent
            })

            local Header = CreateElement("Frame", DropdownFrame, {
                Position = UDim2.new(0, 0, 0, BaseElementHeight - CurrentSpacing),
                Size = UDim2.new(1, 0, 0, HeaderHeight),
                BackgroundTransparency = 1,
                Visible = false
            })

            local SearchBox = CreateElement("TextBox", Header, {
                Size = UDim2.new(1, -ApplyScale(100, Scale), 1, 0),
                BackgroundColor3 = Astral.Theme.Tertiary,
                BackgroundTransparency = Astral.Design.Transparencies.Element,
                PlaceholderText = "Search...",
                Text = "",
                TextColor3 = Astral.Theme.Text,
                Font = Enum.Font.Gotham,
                TextSize = GetDesignValue(Astral.Design.FontSizes, "ExtraSmall", Scale)
            })

            CreateElement("UICorner", SearchBox, {CornerRadius = UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "ExtraSmall", Scale))})
            CreateStroke(SearchBox, Astral.Theme.Stroke, 0.5, 0.5)

            local SelectAllButton = CreateButton(Header, "ALL", function()
                for _, Option in ipairs(DropdownOptions) do
                    if #SelectionOrder >= Maximum then break end
                    if not Selected[Option] then
                        Selected[Option] = true
                        table.insert(SelectionOrder, Option)
                    end
                end
                UpdateLabel()
                Refresh(SearchBox.Text)
                Callback(SelectionOrder)
            end, {
                Size = UDim2.new(0, ApplyScale(45, Scale), 1, 0),
                Position = UDim2.new(1, -ApplyScale(95, Scale), 0, 0),
                BackgroundColor = Astral.Theme.Success,
                FontSize = "ExtraSmall",
                BorderRadius = "ExtraSmall"
            })

            local ClearAllButton = CreateButton(Header, "CLEAR", function()
                while #SelectionOrder > Minimum do
                    local removed = table.remove(SelectionOrder, 1)
                    Selected[removed] = false
                end
                UpdateLabel()
                Refresh(SearchBox.Text)
                Callback(SelectionOrder)
            end, {
                Size = UDim2.new(0, ApplyScale(45, Scale), 1, 0),
                Position = UDim2.new(1, -ApplyScale(45, Scale), 0, 0),
                BackgroundColor = Astral.Theme.Error,
                FontSize = "ExtraSmall",
                BorderRadius = "ExtraSmall"
            })

            local DropdownList = CreateScrollingFrame(DropdownFrame, {
                Position = UDim2.new(0, 0, 0, BaseElementHeight + HeaderHeight - CurrentSpacing * 2),
                Size = UDim2.new(1, 0, 0, ListMaxHeight),
                Visible = false,
                Scale = Scale
            })
            CreateScrollBar(DropdownList)

            ApplyCompactPadding(DropdownList, {Top = Astral.Design.Spacing.Small, Bottom = Astral.Design.Spacing.Small}, Scale)

            local DropdownLayout = CreateCompactListLayout(DropdownList, "Small", Scale)

            local function Refresh(filter)
                for _, Child in pairs(DropdownList:GetChildren()) do
                    if Child:IsA("TextButton") then Child:Destroy() end
                end
                for _, Option in pairs(DropdownOptions) do
                    if filter and filter ~= "" and not string.find(string.lower(Option), string.lower(filter)) then continue end

                    local IsSelected = Selected[Option]
                    local OptionButton = CreateButton(DropdownList, Option, function()
                        if Selected[Option] then
                            if #SelectionOrder > Minimum then
                                Selected[Option] = false
                                for i, value in ipairs(SelectionOrder) do 
                                    if value == Option then 
                                        table.remove(SelectionOrder, i) 
                                        break 
                                    end 
                                end
                            end
                        elseif #SelectionOrder < Maximum then
                            Selected[Option] = true
                            table.insert(SelectionOrder, Option)
                        end
                        UpdateLabel()
                        Refresh(SearchBox.Text)
                        Callback(SelectionOrder)
                    end, {
                        Size = UDim2.new(1, 0, 0, ApplyScale(24, Scale)),
                        BackgroundColor = IsSelected and Astral.Theme.Accent or Astral.Theme.Tertiary,
                        BackgroundTransparency = IsSelected and 0.15 or Astral.Design.Transparencies.Element,
                        TextColor = IsSelected and Astral.Theme.Text or Astral.Theme.TextDark,
                        Font = IsSelected and Enum.Font.GothamBold or Enum.Font.Gotham,
                        FontSize = "ExtraSmall",
                        BorderRadius = "ExtraSmall"
                    })
                end

                local ContentHeight = DropdownLayout.AbsoluteContentSize.Y
                DropdownList.CanvasSize = UDim2.new(0, 0, 0, ContentHeight + CurrentSpacing)
                DropdownList.ScrollingEnabled = ContentHeight > ListMaxHeight
            end

            SearchBox:GetPropertyChangedSignal("Text"):Connect(function() 
                Refresh(SearchBox.Text) 
            end)

            DropdownButton.MouseButton1Click:Connect(function()
                Dropped = not Dropped
                if Dropped then 
                    Refresh()
                    Header.Visible = true
                    DropdownList.Visible = true
                    
                    CenterElement(PageFrame, DropdownFrame, TotalHeightWhenDropped)
                    
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.15), {
                        Size = UDim2.new(1, 0, 0, TotalHeightWhenDropped)
                    }):Play()
                    TweenService:Create(ArrowImage, TweenInfo.new(0.15), {
                        Rotation = 180
                    }):Play()
                else
                    Header.Visible = false
                    DropdownList.Visible = false
                    
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.15), {
                        Size = UDim2.new(1, 0, 0, BaseElementHeight)
                    }):Play()
                    TweenService:Create(ArrowImage, TweenInfo.new(0.15), {
                        Rotation = 0
                    }):Play()
                end
            end)

            local MultiDropdownFunctions = {}
            function MultiDropdownFunctions:SetOptions(Options)
                DropdownOptions = Options
                Selected = {}
                SelectionOrder = {}
                for _, value in pairs(Default) do
                    if #SelectionOrder < Maximum then
                        Selected[value] = true
                        table.insert(SelectionOrder, value)
                    end
                end
                UpdateLabel()
                Refresh(SearchBox.Text)
            end
            
            function MultiDropdownFunctions:SetValues(Values)
                Selected = {}
                SelectionOrder = {}
                for _, value in pairs(Values) do
                    if #SelectionOrder < Maximum then
                        Selected[value] = true
                        table.insert(SelectionOrder, value)
                    end
                end
                UpdateLabel()
                Refresh(SearchBox.Text)
                Callback(SelectionOrder)
            end
            
            function MultiDropdownFunctions:GetValues()
                return SelectionOrder
            end
            
            return MultiDropdownFunctions
        end

        function TabFunctions:Keybind(Options, Parent)
            Parent = Parent or PageFrame
            local KeybindName = Options.Name or "Keybind"
            local Default = Options.Default or Enum.KeyCode.E
            local Callback = Options.Callback or function() end
            local Current = Default

            local KeybindFrame = CreateRoundedFrame(Parent, {
                BackgroundColor3 = Astral.Theme.Main,
                BackgroundTransparency = Astral.Design.Transparencies.Element,
                Size = UDim2.new(1, 0, 0, CurrentElementHeight),
                ClipsDescendants = true
            }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "Small", Scale)))

            CreateLabel(KeybindFrame, KeybindName, {
                FontSize = "Small",
                Padding = Astral.Design.Spacing.Small
            })

            local KeybindButton = CreateRoundedFrame(KeybindFrame, {
                BackgroundColor3 = Astral.Theme.Tertiary,
                BackgroundTransparency = Astral.Design.Transparencies.Element,
                Position = UDim2.new(1, -ApplyScale(65, Scale), 0.5, -ApplyScale(10, Scale)),
                Size = UDim2.new(0, ApplyScale(55, Scale), 0, ApplyScale(20, Scale))
            }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "ExtraSmall", Scale)))

            CreateStroke(KeybindButton, Astral.Theme.Stroke, 0.5, 0.5)

            local KeybindText = CreateElement("TextButton", KeybindButton, {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Font = Enum.Font.GothamBold,
                Text = Current.Name,
                TextColor3 = Astral.Theme.Accent,
                TextSize = GetDesignValue(Astral.Design.FontSizes, "ExtraSmall", Scale),
                AutoButtonColor = false
            })

            local Binding = false
            KeybindText.MouseButton1Click:Connect(function()
                Binding = true
                KeybindText.Text = "..."
                KeybindText.TextColor3 = Astral.Theme.Warning
            end)

            local function SetKeybind(key)
                Current = key
                KeybindText.Text = Current.Name
                KeybindText.TextColor3 = Astral.Theme.Accent
                Callback(Current)
            end

            UserInputService.InputBegan:Connect(function(input, GameProcessed)
                if not GameProcessed and Binding and input.UserInputType == Enum.UserInputType.Keyboard then
                    Binding = false
                    SetKeybind(input.KeyCode)
                elseif not GameProcessed and input.KeyCode == Current then
                    Callback(Current)
                end
            end)

            local KeybindFunctions = {}
            function KeybindFunctions:SetKeybind(key)
                SetKeybind(key)
            end
            
            function KeybindFunctions:GetKeybind()
                return Current
            end
            
            return KeybindFunctions
        end

        function TabFunctions:Label(Options, Parent)
            Parent = Parent or PageFrame
            local LabelText = Options.Text or "Label"

            local LabelFrame = CreateRoundedFrame(Parent, {
                BackgroundColor3 = Astral.Theme.Main,
                BackgroundTransparency = Astral.Design.Transparencies.Element,
                Size = UDim2.new(1, 0, 0, ApplyScale(24, Scale))
            }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "Small", Scale)))

            local Label = CreateLabel(LabelFrame, LabelText, {
                FontSize = "Small",
                TextColor = Astral.Theme.TextDark,
                Padding = Astral.Design.Spacing.Small
            })

            local LabelObject = {}
            function LabelObject:SetText(Text)
                Label.Text = Text
            end
            
            function LabelObject:GetText()
                return Label.Text
            end
            
            return LabelObject
        end

        return TabFunctions
    end

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

        TweenService:Create(MainFrame, TweenInfo.new(0.2), {
            Size = UDim2.new(0, CurrentWidth, 0, CurrentHeight),
            Position = UDim2.new(0.5, -CurrentWidth/2, 0.5, -CurrentHeight/2)
        }):Play()
    end

    function WindowFunctions:GetScale() return Astral.Design.BaseScale end

    return WindowFunctions
end

return Astral
