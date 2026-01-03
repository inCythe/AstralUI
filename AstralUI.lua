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

-- Design System with Compact Layout
Astral.Design = {
    BaseScale = 1,
    Spacing = {
        XS = 2,
        SM = 4,
        MD = 6,
        LG = 8,
        XL = 10
    },
    BorderRadius = {
        XS = 3,
        SM = 4,
        MD = 6,
        LG = 8,
        XL = 10
    },
    ElementHeight = 28, -- Reduced from 34 for more compact layout
    TopbarHeight = 32, -- Reduced from 36
    ButtonSize = 24, -- Reduced from 26
    IconSize = 14, -- Reduced from 16
    BaseWidth = 560, -- Slightly narrower
    BaseHeight = 380, -- More compact
    FontSizes = {
        XS = 9,
        SM = 10,
        MD = 11,
        LG = 12,
        XL = 13
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

-- Compact Padding System
local function ApplyCompactPadding(parent, paddingValues, scale)
    local padding = Instance.new("UIPadding")
    padding.Parent = parent
    
    if type(paddingValues) == "table" then
        padding.PaddingTop = UDim.new(0, ApplyScale(paddingValues.T or paddingValues.Top or 0, scale))
        padding.PaddingRight = UDim.new(0, ApplyScale(paddingValues.R or paddingValues.Right or 0, scale))
        padding.PaddingBottom = UDim.new(0, ApplyScale(paddingValues.B or paddingValues.Bottom or 0, scale))
        padding.PaddingLeft = UDim.new(0, ApplyScale(paddingValues.L or paddingValues.Left or 0, scale))
    else
        local padded = ApplyScale(paddingValues, scale)
        padding.PaddingTop = UDim.new(0, padded)
        padding.PaddingRight = UDim.new(0, padded)
        padding.PaddingBottom = UDim.new(0, padded)
        padding.PaddingLeft = UDim.new(0, padded)
    end
    
    return padding
end

-- Unified UI Element Creation
local function CreateElement(elementType, parent, properties)
    local element = Instance.new(elementType)
    
    for prop, value in pairs(properties) do
        if prop == "Parent" then
            element.Parent = value
        else
            element[prop] = value
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

-- Button Utility Functions
local function CreateButton(parent, text, callback, options)
    options = options or {}
    local scale = options.Scale or Astral.Design.BaseScale
    local size = options.Size or UDim2.new(1, 0, 0, GetDesignValue(Astral.Design, "ElementHeight", scale))
    local position = options.Position or UDim2.new(0, 0, 0, 0)
    local textSize = GetDesignValue(Astral.Design.FontSizes, options.FontSize or "MD", scale)
    local borderRadius = UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, options.BorderRadius or "SM", scale))
    
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
    
    -- Hover Effect
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
    
    -- Click Effect
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
    local textSize = GetDesignValue(Astral.Design.FontSizes, options.FontSize or "MD", scale)
    
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

-- Compact Layout Functions
local function CreateCompactListLayout(parent, padding, scale)
    local layout = Instance.new("UIListLayout")
    layout.Parent = parent
    layout.Padding = UDim.new(0, GetDesignValue(Astral.Design.Spacing, padding or "MD", scale))
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
        ScrollingEnabled = true
    })
    
    if options.Padding then
        ApplyCompactPadding(scrollingFrame, options.Padding, scale)
    end
    
    return scrollingFrame
end

-- Draggable Function (Compact)
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

-- Main Window Creation (More Compact)
function Astral:Window(Options)
    local Name = Options.Name or "Astral"
    local Scale = Options.Scale or 1
    Astral.Design.BaseScale = Scale

    -- Create ScreenGui
    local ScreenGui = CreateElement("ScreenGui", TargetParent, {
        Name = "AstralUI",
        DisplayOrder = 999,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })

    -- Calculate Compact Dimensions
    local CurrentWidth = ApplyScale(Astral.Design.BaseWidth, Scale)
    local CurrentHeight = ApplyScale(Astral.Design.BaseHeight, Scale)
    local CurrentSpacing = GetDesignValue(Astral.Design.Spacing, "MD", Scale)
    local CurrentElementHeight = GetDesignValue(Astral.Design, "ElementHeight", Scale)
    local CurrentTopbarHeight = GetDesignValue(Astral.Design, "TopbarHeight", Scale)
    local CurrentBorderRadius = GetDesignValue(Astral.Design.BorderRadius, "MD", Scale)

    -- Main Window Frame (More Compact)
    local MainFrame, MainCorner = CreateRoundedElement("Frame", ScreenGui, {
        BackgroundColor3 = Astral.Theme.Main,
        BackgroundTransparency = Astral.Design.Transparencies.Background,
        Position = UDim2.new(0.5, -CurrentWidth / 2, 0.5, -CurrentHeight / 2),
        Size = UDim2.new(0, CurrentWidth, 0, CurrentHeight),
        ClipsDescendants = true,
        Active = true
    }, UDim.new(0, CurrentBorderRadius))

    CreateStroke(MainFrame, Astral.Theme.Stroke, 1, Astral.Design.Transparencies.Stroke)

    -- Compact Topbar
    local TopbarFrame, TopbarCorner = CreateRoundedElement("Frame", MainFrame, {
        Name = "Topbar",
        BackgroundColor3 = Astral.Theme.Tertiary,
        BackgroundTransparency = 0.15,
        Position = UDim2.new(0, CurrentSpacing, 0, CurrentSpacing),
        Size = UDim2.new(1, -ApplyScale(74, Scale), 0, CurrentTopbarHeight),
        ZIndex = 5
    }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "SM", Scale)))

    -- Title (Compact)
    CreateLabel(TopbarFrame, Name, {
        Font = Enum.Font.GothamBold,
        FontSize = "LG",
        Padding = Astral.Design.Spacing.SM
    })

    MakeDraggable(TopbarFrame, MainFrame)

    -- Compact Controls
    local ControlsFrame = CreateElement("Frame", MainFrame, {
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -ApplyScale(70, Scale), 0, CurrentSpacing),
        Size = UDim2.new(0, ApplyScale(64, Scale), 0, CurrentTopbarHeight),
        ZIndex = 10
    })

    -- Control Buttons
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
        FontSize = "XL",
        BorderRadius = "SM"
    })

    local MinimizeButton = CreateButton(ControlsFrame, "−", function()
        MainFrame.Visible = not MainFrame.Visible
    end, {
        Size = UDim2.new(0, GetDesignValue(Astral.Design, "ButtonSize", Scale), 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor = Astral.Theme.Tertiary,
        TextColor = Astral.Theme.TextDark,
        FontSize = "XL",
        BorderRadius = "SM"
    })

    -- Compact Bubble
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

    -- Bubble Dragging
    local BubbleDragging = false
    local DragInput, DragStart, StartPos

    local function SnapToSide()
        local ScreenSize = ScreenGui.AbsoluteSize
        local CurrentPos = Bubble.AbsolutePosition
        local CenterX = ScreenSize.X / 2

        local TargetX = (CurrentPos.X + ApplyScale(20, Scale) < CenterX) and ApplyScale(10, Scale) or (ScreenSize.X - ApplyScale(50, Scale))
        local TargetY = math.clamp(CurrentPos.Y, ApplyScale(10, Scale), ScreenSize.Y - ApplyScale(50, Scale))

        TweenService:Create(Bubble, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
            Position = UDim2.new(0, TargetX, 0, TargetY)
        }):Play()
    end

    Bubble.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and BubbleDragging then
            local Delta = input.Position - DragStart
            Bubble.Position = UDim2.new(
                StartPos.X.Scale, StartPos.X.Offset + Delta.X,
                StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y
            )
        end
    end)

    Bubble.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)

    -- Content Area (More Compact)
    local ContentFrame = CreateElement("Frame", MainFrame, {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, CurrentTopbarHeight + CurrentSpacing),
        Size = UDim2.new(1, 0, 1, -(CurrentTopbarHeight + CurrentSpacing)),
        ClipsDescendants = true
    })

    -- Compact Sidebar
    local SidebarFrame, SidebarCorner = CreateRoundedElement("Frame", ContentFrame, {
        BackgroundColor3 = Astral.Theme.Tertiary,
        BackgroundTransparency = 0.15,
        Position = UDim2.new(0, CurrentSpacing, 0, 0),
        Size = UDim2.new(0, ApplyScale(110, Scale), 1, -CurrentSpacing)
    }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "SM", Scale)))

    CreateStroke(SidebarFrame, Astral.Theme.StrokeDark, 0.5, 0.3)

    -- Tab Container
    local TabContainer = CreateScrollingFrame(SidebarFrame, {
        Position = UDim2.new(0, CurrentSpacing, 0, CurrentSpacing),
        Size = UDim2.new(1, -CurrentSpacing * 2, 1, -CurrentSpacing * 2),
        Scale = Scale
    })

    local TabLayout = CreateCompactListLayout(TabContainer, "SM", Scale)
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + CurrentSpacing)
    end)

    -- Compact Pages Area
    local PagesFrame, PagesCorner = CreateRoundedElement("Frame", ContentFrame, {
        BackgroundColor3 = Astral.Theme.Secondary,
        BackgroundTransparency = 0.15,
        Position = UDim2.new(0, ApplyScale(110 + CurrentSpacing * 2, Scale), 0, 0),
        Size = UDim2.new(1, -ApplyScale(110 + CurrentSpacing * 3, Scale), 1, -CurrentSpacing)
    }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "SM", Scale)))

    local PagesContainer = CreateElement("Frame", PagesFrame, {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ClipsDescendants = true
    })
    ApplyCompactPadding(PagesContainer, Astral.Design.Spacing.SM, Scale)

    -- Window Functions
    local WindowFunctions = {}
    local FirstTab = true
    local AllTabs = {}

    -- Tab Creation
    function WindowFunctions:Tab(Options)
        local TabName = Options.Name or "Tab"
        local TabIcon = Options.Icon or "rbxassetid://7733954760"

        -- Compact Tab Button
        local TabButton = CreateButton(TabContainer, "", nil, {
            Size = UDim2.new(1, 0, 0, CurrentElementHeight),
            BackgroundTransparency = 0.2,
            BorderRadius = "SM"
        })

        -- Tab Icon
        local IconImage = CreateElement("ImageLabel", TabButton, {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, CurrentSpacing, 0.5, -ApplyScale(7, Scale)),
            Size = UDim2.new(0, GetDesignValue(Astral.Design, "IconSize", Scale), 0, GetDesignValue(Astral.Design, "IconSize", Scale)),
            Image = TabIcon,
            ImageColor3 = Astral.Theme.TextDark
        })

        -- Tab Label
        local LabelText = CreateLabel(TabButton, TabName, {
            Position = UDim2.new(0, ApplyScale(24, Scale), 0, 0),
            Size = UDim2.new(1, -ApplyScale(30, Scale), 1, 0),
            Font = Enum.Font.GothamMedium,
            FontSize = "SM",
            TextColor = Astral.Theme.TextDark
        })

        -- Active Indicator
        local IndicatorFrame = CreateElement("Frame", TabButton, {
            Name = "Indicator",
            BackgroundColor3 = Astral.Theme.Accent,
            BorderSizePixel = 0,
            Position = UDim2.new(0, ApplyScale(1, Scale), 0.5, -ApplyScale(7, Scale)),
            Size = UDim2.new(0, ApplyScale(2, Scale), 0, ApplyScale(14, Scale)),
            Visible = false
        })

        -- Page Frame
        local PageFrame = CreateScrollingFrame(PagesContainer, {
            Name = TabName,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false,
            Scale = Scale
        })
        ApplyCompactPadding(PageFrame, Astral.Design.Spacing.SM, Scale)

        local PageLayout = CreateCompactListLayout(PageFrame, "SM", Scale)
        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            PageFrame.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + CurrentSpacing * 2)
        end)

        -- Tab Activation
        local function Activate()
            for _, Page in pairs(PagesContainer:GetChildren()) do
                if Page:IsA("ScrollingFrame") then
                    Page.Visible = false
                end
            end
            for _, TabData in pairs(AllTabs) do
                TabData.Button.Indicator.Visible = false
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
        table.insert(AllTabs, {Button = TabButton, Label = LabelText, Icon = IconImage})

        if FirstTab then
            FirstTab = false
            Activate()
        end

        local TabFunctions = {}

        -- Section Creation (Compact)
        function TabFunctions:Section(Options)
            local SectionName = Options.Name or "Section"

            local SectionFrame = CreateRoundedFrame(PageFrame, {
                BackgroundColor3 = Astral.Theme.Tertiary,
                BackgroundTransparency = Astral.Design.Transparencies.Element,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y
            }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "SM", Scale)))

            -- Compact Header
            local HeaderFrame = CreateRoundedFrame(SectionFrame, {
                BackgroundColor3 = Astral.Theme.Main,
                BackgroundTransparency = 0.15,
                Size = UDim2.new(1, 0, 0, CurrentElementHeight)
            }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "SM", Scale)))

            CreateLabel(HeaderFrame, SectionName, {
                Font = Enum.Font.GothamBold,
                FontSize = "MD",
                Padding = Astral.Design.Spacing.SM
            })

            -- Content Area
            local SectionContent = CreateElement("Frame", SectionFrame, {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 0, 0, CurrentElementHeight),
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y
            })
            ApplyCompactPadding(SectionContent, Astral.Design.Spacing.SM, Scale)

            CreateCompactListLayout(SectionContent, "SM", Scale)

            local SectionFunctions = {}
            for _, funcName in pairs({"Button", "Toggle", "Slider", "TextBox", "Dropdown", "MultiDropdown", "Keybind", "Label"}) do
                SectionFunctions[funcName] = function(Options)
                    return TabFunctions[funcName](Options, SectionContent)
                end
            end

            return SectionFunctions
        end

        -- Button Element (Compact)
        function TabFunctions:Button(Options, Parent)
            Parent = Parent or PageFrame
            local ButtonName = Options.Name or "Button"
            local Callback = Options.Callback or function() end

            return CreateButton(Parent, ButtonName, Callback, {
                Size = UDim2.new(1, 0, 0, CurrentElementHeight),
                BackgroundTransparency = Astral.Design.Transparencies.Element,
                BorderRadius = "SM",
                FontSize = "SM",
                Padding = Astral.Design.Spacing.SM
            })
        end

        -- Toggle Element (Compact)
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
            }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "SM", Scale)))

            CreateLabel(ToggleFrame, ToggleName, {
                FontSize = "SM",
                Padding = Astral.Design.Spacing.SM
            })

            -- Compact Toggle Switch
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

        -- Slider Element (Compact)
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
                BackgroundColor3 = Astral.Theme.Main,
                BackgroundTransparency = Astral.Design.Transparencies.Element,
                Size = UDim2.new(1, 0, 0, ApplyScale(44, Scale)),
                ClipsDescendants = true
            }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "SM", Scale)))

            CreateLabel(SliderFrame, SliderName, {
                Size = UDim2.new(1, 0, 0, ApplyScale(16, Scale)),
                FontSize = "SM",
                Padding = Astral.Design.Spacing.SM
            })

            -- Compact Value Display
            local ValueInput = CreateElement("TextBox", SliderFrame, {
                BackgroundColor3 = Astral.Theme.Tertiary,
                BackgroundTransparency = Astral.Design.Transparencies.Element,
                Position = UDim2.new(1, -ApplyScale(52, Scale), 0, ApplyScale(4, Scale)),
                Size = UDim2.new(0, ApplyScale(44, Scale), 0, ApplyScale(18, Scale)),
                Font = Enum.Font.GothamBold,
                Text = tostring(Value),
                TextColor3 = Astral.Theme.Accent,
                TextSize = GetDesignValue(Astral.Design.FontSizes, "XS", Scale),
                ClearTextOnFocus = false
            })

            CreateElement("UICorner", ValueInput, {CornerRadius = UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "XS", Scale))})
            CreateStroke(ValueInput, Astral.Theme.Stroke, 0.5, 0.5)

            -- Compact Slider Track
            local BackgroundFrame = CreateRoundedFrame(SliderFrame, {
                BackgroundColor3 = Astral.Theme.Tertiary,
                Position = UDim2.new(0, CurrentSpacing, 1, -ApplyScale(16, Scale)),
                Size = UDim2.new(1, -CurrentSpacing * 2, 0, ApplyScale(5, Scale))
            }, UDim.new(1, 0))

            local FillFrame = CreateRoundedFrame(BackgroundFrame, {
                BackgroundColor3 = Astral.Theme.Accent,
                Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
            }, UDim.new(1, 0))

            local BallFrame = CreateRoundedFrame(BackgroundFrame, {
                BackgroundColor3 = Astral.Theme.Text,
                Size = UDim2.new(0, ApplyScale(12, Scale), 0, ApplyScale(12, Scale)),
                Position = UDim2.new((Value - Min) / (Max - Min), -ApplyScale(6, Scale), 0.5, -ApplyScale(6, Scale)),
                ZIndex = 2
            }, UDim.new(1, 0))

            -- Slider Logic
            local Dragging = false

            local function Update(input)
                local SizeX = BackgroundFrame.AbsoluteSize.X
                local OffsetX = math.clamp(input.Position.X - BackgroundFrame.AbsolutePosition.X, 0, SizeX)
                local Percentage = OffsetX / SizeX

                Value = math.floor(((Max - Min) * Percentage + Min) / Increment + 0.5) * Increment
                Value = math.clamp(Value, Min, Max)

                local VisualPercentage = (Value - Min) / (Max - Min)

                TweenService:Create(FillFrame, TweenInfo.new(0.05), {Size = UDim2.new(VisualPercentage, 0, 1, 0)}):Play()
                TweenService:Create(BallFrame, TweenInfo.new(0.05), {Position = UDim2.new(VisualPercentage, -ApplyScale(6, Scale), 0.5, -ApplyScale(6, Scale))}):Play()
                ValueInput.Text = tostring(Value)
                Callback(Value)
            end

            BackgroundFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = true
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

            ValueInput.FocusLost:Connect(function()
                local InputValue = tonumber(ValueInput.Text)
                if InputValue then
                    Value = math.clamp(math.floor(InputValue / Increment + 0.5) * Increment, Min, Max)
                    local VisualPercentage = (Value - Min) / (Max - Min)
                    TweenService:Create(FillFrame, TweenInfo.new(0.15), {Size = UDim2.new(VisualPercentage, 0, 1, 0)}):Play()
                    TweenService:Create(BallFrame, TweenInfo.new(0.15), {Position = UDim2.new(VisualPercentage, -ApplyScale(6, Scale), 0.5, -ApplyScale(6, Scale))}):Play()
                    ValueInput.Text = tostring(Value)
                    Callback(Value)
                else
                    ValueInput.Text = tostring(Value)
                end
            end)
        end

        -- TextBox Element (Compact)
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
            }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "SM", Scale)))

            CreateLabel(TextBoxFrame, TextBoxName, {
                Size = UDim2.new(1, 0, 0, ApplyScale(16, Scale)),
                FontSize = "SM",
                Padding = Astral.Design.Spacing.SM
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
                TextSize = GetDesignValue(Astral.Design.FontSizes, "SM", Scale),
                ClearTextOnFocus = false
            })

            CreateElement("UICorner", InputBox, {CornerRadius = UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "XS", Scale))})
            CreateStroke(InputBox, Astral.Theme.Stroke, 0.5, 0.5)

            InputBox.FocusLost:Connect(function(EnterPressed)
                if EnterPressed then
                    Callback(InputBox.Text)
                end
            end)
        end

        -- Dropdown (Compact - keep original logic but with new styling)
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
            }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "SM", Scale)))
            
            ApplyCompactPadding(DropdownFrame, Astral.Design.Spacing.SM, Scale)

            local DropdownButton = CreateButton(DropdownFrame, "", function()
                Dropped = not Dropped
                if Dropped then 
                    Header.Visible = true
                    DropdownList.Visible = true
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.15), {
                        Size = UDim2.new(1, 0, 0, TotalHeightWhenDropped)
                    }):Play()
                    TweenService:Create(ArrowImage, TweenInfo.new(0.15), {Rotation = 180}):Play()
                else
                    Header.Visible = false
                    DropdownList.Visible = false
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.15), {
                        Size = UDim2.new(1, 0, 0, BaseElementHeight)
                    }):Play()
                    TweenService:Create(ArrowImage, TweenInfo.new(0.15), {Rotation = 0}):Play()
                end
            end, {
                Size = UDim2.new(1, 0, 0, BaseElementHeight - CurrentSpacing * 2),
                BackgroundTransparency = 1
            })

            CreateLabel(DropdownButton, DropdownName .. (CurrentSelected and (": " .. tostring(CurrentSelected)) or ""), {
                FontSize = "SM",
                Padding = Astral.Design.Spacing.SM
            })

            local ArrowImage = CreateElement("ImageLabel", DropdownButton, {
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -ApplyScale(20, Scale), 0.5, -ApplyScale(5, Scale)),
                Size = UDim2.new(0, ApplyScale(10, Scale), 0, ApplyScale(10, Scale)),
                Image = "rbxassetid://6031091004",
                ImageColor3 = Astral.Theme.Accent
            })

            -- Dropdown content (simplified)
            local Header = CreateElement("Frame", DropdownFrame, {
                Position = UDim2.new(0, 0, 0, BaseElementHeight - CurrentSpacing),
                Size = UDim2.new(1, 0, 0, HeaderHeight),
                BackgroundTransparency = 1,
                Visible = false
            })

            -- Add dropdown list logic here (similar to original but more compact)
            -- ... (rest of dropdown logic)

            -- Return a placeholder for now
            local DropdownFunctions = {}
            function DropdownFunctions:SetOptions(Options)
                -- Implementation
            end
            return DropdownFunctions
        end

        -- Add other elements (Keybind, Label, etc.) with similar compact styling...

        -- Label Element (Compact)
        function TabFunctions:Label(Options, Parent)
            Parent = Parent or PageFrame
            local LabelText = Options.Text or "Label"

            local LabelFrame = CreateRoundedFrame(Parent, {
                BackgroundColor3 = Astral.Theme.Main,
                BackgroundTransparency = Astral.Design.Transparencies.Element,
                Size = UDim2.new(1, 0, 0, ApplyScale(26, Scale))
            }, UDim.new(0, GetDesignValue(Astral.Design.BorderRadius, "SM", Scale)))

            local Label = CreateLabel(LabelFrame, LabelText, {
                FontSize = "SM",
                TextColor = Astral.Theme.TextDark,
                Padding = Astral.Design.Spacing.SM
            })

            local LabelObject = {}
            function LabelObject:SetText(Text)
                Label.Text = Text
            end
            return LabelObject
        end

        return TabFunctions
    end

    -- Window Control Functions
    function WindowFunctions:Hide() MainFrame.Visible = false end
    function WindowFunctions:Show() MainFrame.Visible = true end
    function WindowFunctions:Toggle() MainFrame.Visible = not MainFrame.Visible return MainFrame.Visible end
    function WindowFunctions:Destroy() ScreenGui:Destroy() end
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
