local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local Astral = {}

-- Main configuration system
Astral.Config = {
	Window = {
		BaseWidth = 720,               -- Default window width
		BaseHeight = 520,              -- Default window height
		BasePadding = 8,               -- Default padding between elements
		CornerRadius = 12,             -- Main window corner rounding
		BackgroundTransparency = 0.15, -- Window background transparency
		StrokeThickness = 1.5,         -- Window border thickness
		StrokeTransparency = 0.4       -- Window border transparency
	},

	Topbar = {
		Height = 36,                    -- Topbar height
		CornerRadius = 8,               -- Topbar corner rounding
		BackgroundTransparency = 0.2,   -- Topbar background transparency
		TitleFont = Enum.Font.GothamBold, -- Title font
		TitleSize = 14,                 -- Title text size
		TitleAlignment = Enum.TextXAlignment.Left -- Title alignment
	},

	Controls = {
		ButtonSize = 26,                -- Control button size
		ButtonCornerRadius = 6,         -- Control button corner rounding
		CloseButtonText = "×",          -- Close button text
		CloseButtonSize = 18,           -- Close button text size
		MinimizeButtonText = "−",       -- Minimize button text
		MinimizeButtonSize = 16         -- Minimize button text size
	},

	Bubble = {
		Size = 50,                      -- Bubble diameter
		Icon = "rbxassetid://7733954760", -- Bubble icon ID
		StrokeThickness = 2,            -- Bubble border thickness
		StrokeTransparency = 0.3,       -- Bubble border transparency
		SnapMargin = 3,                 -- Very small snap margin
		EdgeMargin = 1,                 -- Small margin from screen edges
		TopBottomMargin = 1             -- Small margin from top/bottom
	},

	Sidebar = {
		Width = 130,                    -- Sidebar width
		CornerRadius = 8,               -- Sidebar corner rounding
		BackgroundTransparency = 0.2,   -- Sidebar background transparency
		StrokeThickness = 1,            -- Sidebar border thickness
		StrokeTransparency = 0.4        -- Sidebar border transparency
	},

	Tab = {
		Height = 34,                    -- Tab button height
		CornerRadius = 8,               -- Tab button corner rounding
		BackgroundTransparency = 0.25,  -- Tab button background transparency
		IconSize = 16,                  -- Tab icon size
		LabelFont = Enum.Font.GothamMedium, -- Tab label font
		LabelSize = 11,                 -- Tab label text size
		IndicatorWidth = 2,             -- Active tab indicator width
		IndicatorHeight = 16,           -- Active tab indicator height
		Padding = 8                     -- Tab spacing
	},

	Pages = {
		CornerRadius = 8,               -- Page frame corner rounding
		BackgroundTransparency = 0.2,   -- Page background transparency
		Padding = 8                     -- Page content padding
	},

	Elements = {
		Height = 34,                    -- Standard element height
		CornerRadius = 6,               -- Element corner rounding
		BackgroundTransparency = 0.25,  -- Element background transparency
		LabelFont = Enum.Font.GothamMedium, -- Element label font
		LabelSize = 12,                 -- Element label text size
		LabelAlignment = Enum.TextXAlignment.Left, -- Element label alignment

		Button = {
			HoverTransparency = 0.15,   -- Button hover transparency
			NormalTransparency = 0.25   -- Button normal transparency
		},

		Toggle = {
			Width = 38,                  -- Toggle switch width
			Height = 18,                 -- Toggle switch height
			CircleSize = 14              -- Toggle circle size
		},

		Slider = {
			Height = 50,                 -- Slider height
			LabelHeight = 16,            -- Slider label height
			InputWidth = 48,             -- Value input width
			InputHeight = 20,            -- Value input height
			InputTextSize = 11,          -- Value input text size
			TrackHeight = 6,             -- Slider track height
			BallSize = 14,               -- Slider ball size
			ValueInputFont = Enum.Font.GothamBold -- Value input font
		},

		TextBox = {
			Height = 44,                 -- TextBox height
			LabelHeight = 16,            -- TextBox label height
			InputHeight = 16,            -- TextBox input height
			InputTextSize = 11,          -- TextBox input text size
			PlaceholderColor = Color3.fromRGB(100, 100, 110), -- Placeholder text color
			InputCornerRadius = 4,       -- TextBox input corner rounding
			StrokeThickness = 1,         -- TextBox border thickness
			StrokeTransparency = 0.5     -- TextBox border transparency
		},

		Dropdown = {
			Height = 34,                 -- Dropdown height
			LabelTextSize = 12,          -- Dropdown label text size
			ArrowSize = 12,              -- Dropdown arrow size
			ListAreaHeight = 100,        -- Dropdown list area height
			OptionHeight = 26,           -- Dropdown option height
			OptionTextSize = 11,         -- Dropdown option text size
			SearchTextSize = 11,         -- Search box text size
			ButtonTextSize = 9,          -- Action button text size
			SearchPlaceholder = "Search...", -- Search placeholder text
			ClearButtonText = "CLEAR",   -- Clear button text
			SelectAllButtonText = "ALL", -- Select all button text
			InputCornerRadius = 4,       -- Input corner rounding
			StrokeThickness = 1,         -- Input border thickness
			StrokeTransparency = 0.5     -- Input border transparency
		},

		MultiDropdown = {
			Height = 34,                 -- Multi-dropdown height
			ListAreaHeight = 120,        -- Multi-dropdown list area height
			OptionHeight = 26,           -- Multi-dropdown option height
			OptionTextSize = 11,         -- Multi-dropdown option text size
			SearchTextSize = 11,         -- Search box text size
			ButtonTextSize = 9,          -- Action button text size
			SearchPlaceholder = "Search options...", -- Search placeholder text
			ClearButtonText = "CLEAR",   -- Clear button text
			SelectAllButtonText = "ALL"  -- Select all button text
		},

		Keybind = {
			ButtonWidth = 58,            -- Keybind button width
			ButtonHeight = 24,           -- Keybind button height
			ButtonCornerRadius = 4,      -- Keybind button corner rounding
			ButtonTextSize = 10,         -- Keybind button text size
			StrokeThickness = 1,         -- Keybind border thickness
			StrokeTransparency = 0.5     -- Keybind border transparency
		},

		Label = {
			Height = 30,                 -- Label height
			TextSize = 11,               -- Label text size
			Font = Enum.Font.Gotham      -- Label font
		},

		Section = {
			CornerRadius = 8,            -- Section corner rounding
			HeaderHeight = 34,           -- Section header height
			HeaderBackgroundTransparency = 0.2, -- Section header transparency
			TitleSize = 13,              -- Section title text size
			TitleFont = Enum.Font.GothamBold -- Section title font
		}
	},

	Notification = {
		Width = 300,                     -- Notification width
		Height = 70,                     -- Notification height
		CornerRadius = 8,                -- Notification corner rounding
		BackgroundTransparency = 0.15,   -- Notification background transparency
		StrokeThickness = 1.5,           -- Notification border thickness
		TitleSize = 13,                  -- Notification title text size
		ContentSize = 11,                -- Notification content text size
		TitleFont = Enum.Font.GothamBold, -- Notification title font
		ContentFont = Enum.Font.Gotham,  -- Notification content font
		MaxNotifications = 5,            -- Maximum simultaneous notifications
		DefaultDuration = 3              -- Default notification duration in seconds
	},

	ScrollBar = {
		Thickness = 4,                   -- Scrollbar thickness
		Transparency = 0.3,              -- Scrollbar transparency
		AutoHideDelay = 0.5              -- Scrollbar auto-hide delay in seconds
	},

	Animation = {
		HoverDuration = 0.15,            -- Hover animation duration
		ClickDuration = 0.08,            -- Click animation duration
		RestoreDuration = 0.15,          -- Restore animation duration
		TweenDuration = 0.2,             -- General tween duration
		DropdownDuration = 0.2,          -- Dropdown animation duration
		NotificationDuration = 0.3,      -- Notification animation duration
		WindowCloseDuration = 0.25,      -- Window close animation duration
		CenterElementDuration = 0.3,     -- Center element animation duration
		EasingStyle = Enum.EasingStyle.Quart, -- Default easing style
		EasingDirection = Enum.EasingDirection.Out -- Default easing direction
	}
}

-- Color theme system
Astral.Theme = {
	Main = Color3.fromRGB(15, 15, 20),       -- Primary background color
	Secondary = Color3.fromRGB(25, 25, 30),  -- Secondary background color
	Tertiary = Color3.fromRGB(20, 20, 25),   -- Tertiary background color
	Accent = Color3.fromRGB(88, 139, 255),   -- Primary accent color
	Text = Color3.fromRGB(245, 245, 250),    -- Primary text color
	TextDark = Color3.fromRGB(150, 150, 160),-- Secondary text color
	TextDarker = Color3.fromRGB(100, 100, 110),-- Tertiary text color
	Stroke = Color3.fromRGB(50, 50, 60),     -- Primary border color
	StrokeDark = Color3.fromRGB(35, 35, 45), -- Secondary border color
	HoverBright = Color3.fromRGB(35, 35, 42),-- Hover state color
	Success = Color3.fromRGB(80, 200, 120),  -- Success color
	Warning = Color3.fromRGB(255, 180, 80),  -- Warning color
	Error = Color3.fromRGB(255, 100, 100),   -- Error color,

	TypeColors = {
		Info = Color3.fromRGB(88, 139, 255),    -- Info notification color
		Success = Color3.fromRGB(80, 200, 120), -- Success notification color
		Warning = Color3.fromRGB(255, 180, 80), -- Warning notification color
		Error = Color3.fromRGB(255, 100, 100)   -- Error notification color
	}
}

function Astral:SetTheme(NewTheme)
	for Key, Value in pairs(NewTheme) do
		if Astral.Theme[Key] ~= nil then
			Astral.Theme[Key] = Value
		end
	end

	if not NewTheme.TypeColors then
		Astral.Theme.TypeColors.Info = Astral.Theme.Accent
		Astral.Theme.TypeColors.Success = Astral.Theme.Success
		Astral.Theme.TypeColors.Warning = Astral.Theme.Warning
		Astral.Theme.TypeColors.Error = Astral.Theme.Error
	end
end

function Astral:SetConfig(NewConfig)
	local function UpdateConfigTable(Target, Source)
		for Key, Value in pairs(Source) do
			if type(Value) == "table" and Target[Key] ~= nil and type(Target[Key]) == "table" then
				UpdateConfigTable(Target[Key], Value)
			elseif Target[Key] ~= nil then
				Target[Key] = Value
			end
		end
	end

	UpdateConfigTable(Astral.Config, NewConfig)
end

local IsStudio = game:GetService("RunService"):IsStudio()
local TargetParent = IsStudio and Player.PlayerGui or CoreGui

if TargetParent:FindFirstChild("AstralUI") then
	for _, Child in pairs(TargetParent:GetChildren()) do
		if Child.Name == "AstralLib" or Child.Name == "AstralBubble" then
			Child:Destroy()
		end
	end

	for _, Child in pairs(TargetParent:GetChildren()) do
		if Child:IsA("ScreenGui") and (Child.Name:find("Astral") or Child.Name:find("Notification")) then
			Child:Destroy()
		end
	end
end

local function ApplyPadding(Parent, Padding)
	local Pad = Instance.new("UIPadding")
	Pad.Parent = Parent
	Pad.PaddingTop = UDim.new(0, Padding)
	Pad.PaddingRight = UDim.new(0, Padding)
	Pad.PaddingBottom = UDim.new(0, Padding)
	Pad.PaddingLeft = UDim.new(0, Padding)
	return Pad
end

local function MakeDraggable(DragBar, WindowObject)
	local Dragging, DragInput, DragStart, StartPosition

	local function Update(Input)
		local Delta = Input.Position - DragStart
		WindowObject.Position = UDim2.new(
			StartPosition.X.Scale,
			StartPosition.X.Offset + Delta.X,
			StartPosition.Y.Scale,
			StartPosition.Y.Offset + Delta.Y
		)
	end

	DragBar.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = Input.Position
			StartPosition = WindowObject.Position

			Input.Changed:Connect(function()
				if Input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)

	DragBar.InputChanged:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
			DragInput = Input
		end
	end)

	UserInputService.InputChanged:Connect(function(Input)
		if Input == DragInput and Dragging then
			Update(Input)
		end
	end)
end

local function AddHoverEffect(Object, HoverColor, NormalColor, HoverTransparency, NormalTransparency)
	Object.MouseEnter:Connect(function()
		local Properties = {BackgroundColor3 = HoverColor}
		if HoverTransparency then
			Properties.BackgroundTransparency = HoverTransparency
		end
		TweenService:Create(Object, TweenInfo.new(Astral.Config.Animation.HoverDuration), Properties):Play()
	end)

	Object.MouseLeave:Connect(function()
		local Properties = {BackgroundColor3 = NormalColor}
		if NormalTransparency then
			Properties.BackgroundTransparency = NormalTransparency
		end
		TweenService:Create(Object, TweenInfo.new(Astral.Config.Animation.HoverDuration), Properties):Play()
	end)
end

local function AddClickEffect(Object)
	local OriginalSize = Object.Size

	Object.MouseButton1Down:Connect(function()
		TweenService:Create(Object, TweenInfo.new(Astral.Config.Animation.ClickDuration), {
			Size = UDim2.new(
				OriginalSize.X.Scale * 0.98,
				OriginalSize.X.Offset,
				OriginalSize.Y.Scale * 0.98,
				OriginalSize.Y.Offset
			)
		}):Play()
	end)

	local function Restore()
		TweenService:Create(Object, TweenInfo.new(Astral.Config.Animation.RestoreDuration), {Size = OriginalSize}):Play()
	end

	Object.MouseButton1Up:Connect(Restore)
	Object.MouseLeave:Connect(Restore)
end

local function ScrollToElement(ScrollingFrame, Element, ElementFutureHeight)
	if not ScrollingFrame or not Element then return end

	local function PerformScrolling(UseFutureHeight)
		local CanvasSize = ScrollingFrame.CanvasSize.Y.Offset
		local ViewportHeight = ScrollingFrame.AbsoluteSize.Y

		local ElementAbsY = Element.AbsolutePosition.Y
		local FrameAbsY = ScrollingFrame.AbsolutePosition.Y
		local CanvasPosY = ScrollingFrame.CanvasPosition.Y

		local ElementPosY = ElementAbsY - FrameAbsY + CanvasPosY

		local ElementHeight
		if UseFutureHeight and ElementFutureHeight then
			ElementHeight = ElementFutureHeight
		else
			ElementHeight = Element.AbsoluteSize.Y
		end

		local ElementTop = ElementPosY
		local ElementBottom = ElementPosY + ElementHeight
		local ViewportTop = ScrollingFrame.CanvasPosition.Y
		local ViewportBottom = ViewportTop + ViewportHeight

		local TargetPosition

		if ElementHeight > ViewportHeight then
			TargetPosition = ElementTop
		else
			if ElementTop >= ViewportTop and ElementBottom <= ViewportBottom then
				return
			end

			if ElementTop < ViewportTop then
				TargetPosition = ElementTop
			elseif ElementBottom > ViewportBottom then
				TargetPosition = ElementBottom - ViewportHeight
			else
				TargetPosition = ElementTop
			end
		end

		local MaxScroll = math.max(0, CanvasSize - ViewportHeight)
		TargetPosition = math.clamp(TargetPosition, 0, MaxScroll)

		TweenService:Create(ScrollingFrame, TweenInfo.new(
			Astral.Config.Animation.CenterElementDuration,
			Astral.Config.Animation.EasingStyle,
			Astral.Config.Animation.EasingDirection
			), {
				CanvasPosition = Vector2.new(0, TargetPosition)
			}):Play()
	end

	if ElementFutureHeight then
		task.spawn(function()
			task.wait(0.05)
			PerformScrolling(true)
		end)
	else
		PerformScrolling(false)
	end
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
			TweenService:Create(ScrollingFrame, TweenInfo.new(Astral.Config.Animation.TweenDuration), {
				ScrollBarThickness = Astral.Config.ScrollBar.Thickness,
				ScrollBarImageTransparency = Astral.Config.ScrollBar.Transparency
			}):Play()
		end
		LastScrollTime = tick()
	end

	local function HideScrollBar()
		if ScrollBarVisible and not IsDragging and not IsHovering and tick() - LastScrollTime > Astral.Config.ScrollBar.AutoHideDelay then
			ScrollBarVisible = false
			TweenService:Create(ScrollingFrame, TweenInfo.new(Astral.Config.Animation.TweenDuration * 2.5), {
				ScrollBarThickness = 0,
				ScrollBarImageTransparency = 1
			}):Play()
		end
	end

	ScrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(ShowScrollBar)

	game:GetService("RunService").Heartbeat:Connect(function()
		if ScrollBarVisible and not IsDragging and not IsHovering and tick() - LastScrollTime > Astral.Config.ScrollBar.AutoHideDelay then
			HideScrollBar()
		end
	end)

	ScrollingFrame.MouseEnter:Connect(function()
		IsHovering = true
		ShowScrollBar()
	end)

	ScrollingFrame.MouseLeave:Connect(function()
		IsHovering = false
		if not IsDragging and tick() - LastScrollTime > Astral.Config.ScrollBar.AutoHideDelay then
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

function Astral:Window(Options)
	local Name = Options.Name or "Astral"
	local Scale = Options.Scale or 1

	local function ApplyScale(Value)
		return Value * Scale
	end

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "AstralUI"
	ScreenGui.Parent = TargetParent
	ScreenGui.DisplayOrder = 999
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.ResetOnSpawn = false

	local NotificationQueue = {}
	local ActiveNotifications = {}
	local MaxNotifications = Astral.Config.Notification.MaxNotifications

	local BaseWidth = Astral.Config.Window.BaseWidth
	local BaseHeight = Astral.Config.Window.BaseHeight
	local BasePadding = Astral.Config.Window.BasePadding
	local ElementHeight = Astral.Config.Elements.Height
	local TopbarHeight = Astral.Config.Topbar.Height
	local ButtonSize = Astral.Config.Controls.ButtonSize

	local CurrentWidth = ApplyScale(BaseWidth)
	local CurrentHeight = ApplyScale(BaseHeight)

	local MainFrame = Instance.new("Frame")
	MainFrame.Parent = ScreenGui
	MainFrame.BackgroundColor3 = Astral.Theme.Main
	MainFrame.BackgroundTransparency = Astral.Config.Window.BackgroundTransparency
	MainFrame.Position = UDim2.new(0.5, -CurrentWidth / 2, 0.5, -CurrentHeight / 2)
	MainFrame.Size = UDim2.new(0, CurrentWidth, 0, CurrentHeight)
	MainFrame.ClipsDescendants = true
	MainFrame.Active = true

	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Window.CornerRadius))
	MainCorner.Parent = MainFrame

	local MainStroke = Instance.new("UIStroke")
	MainStroke.Color = Astral.Theme.Stroke
	MainStroke.Thickness = ApplyScale(Astral.Config.Window.StrokeThickness)
	MainStroke.Transparency = Astral.Config.Window.StrokeTransparency
	MainStroke.Parent = MainFrame

	local TopbarFrame = Instance.new("Frame")
	TopbarFrame.Name = "Topbar"
	TopbarFrame.Parent = MainFrame
	TopbarFrame.BackgroundColor3 = Astral.Theme.Main
	TopbarFrame.BackgroundTransparency = Astral.Config.Topbar.BackgroundTransparency
	TopbarFrame.Position = UDim2.new(0, ApplyScale(BasePadding), 0, ApplyScale(BasePadding))
	TopbarFrame.Size = UDim2.new(1, -ApplyScale(88), 0, ApplyScale(TopbarHeight))
	TopbarFrame.ZIndex = 5

	local TopbarCorner = Instance.new("UICorner")
	TopbarCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Topbar.CornerRadius))
	TopbarCorner.Parent = TopbarFrame

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Parent = TopbarFrame
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Size = UDim2.new(1, 0, 1, 0)
	ApplyPadding(TitleLabel, ApplyScale(BasePadding))
	TitleLabel.Font = Astral.Config.Topbar.TitleFont
	TitleLabel.Text = Name
	TitleLabel.TextColor3 = Astral.Theme.Text
	TitleLabel.TextSize = ApplyScale(Astral.Config.Topbar.TitleSize)
	TitleLabel.TextXAlignment = Astral.Config.Topbar.TitleAlignment

	MakeDraggable(TopbarFrame, MainFrame)

	local ControlsFrame = Instance.new("Frame")
	ControlsFrame.Parent = MainFrame
	ControlsFrame.BackgroundTransparency = 1
	ControlsFrame.Position = UDim2.new(1, -ApplyScale(88), 0, ApplyScale(BasePadding))
	ControlsFrame.Size = UDim2.new(0, ApplyScale(80), 0, ApplyScale(TopbarHeight))
	ControlsFrame.ZIndex = 10

	local CloseButton = Instance.new("TextButton")
	CloseButton.Parent = ControlsFrame
	CloseButton.BackgroundColor3 = Astral.Theme.Main
	CloseButton.BackgroundTransparency = Astral.Config.Topbar.BackgroundTransparency
	CloseButton.Size = UDim2.new(0, ApplyScale(ButtonSize), 0, ApplyScale(TopbarHeight))
	CloseButton.Position = UDim2.new(1, -ApplyScale(ButtonSize + BasePadding), 0, 0)
	CloseButton.AutoButtonColor = false
	CloseButton.Font = Enum.Font.GothamBold
	CloseButton.Text = Astral.Config.Controls.CloseButtonText
	CloseButton.TextColor3 = Astral.Theme.Error
	CloseButton.TextSize = ApplyScale(Astral.Config.Controls.CloseButtonSize)
	CloseButton.TextYAlignment = Enum.TextYAlignment.Center
	CloseButton.ZIndex = 11

	local CloseCorner = Instance.new("UICorner")
	CloseCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Controls.ButtonCornerRadius))
	CloseCorner.Parent = CloseButton

	AddHoverEffect(
		CloseButton,
		Astral.Theme.HoverBright,
		Astral.Theme.Main,
		Astral.Config.Elements.Button.HoverTransparency,
		Astral.Config.Topbar.BackgroundTransparency
	)

	AddClickEffect(CloseButton)

	CloseButton.MouseButton1Click:Connect(function()
		local Tween = TweenService:Create(
			MainFrame,
			TweenInfo.new(
				Astral.Config.Animation.WindowCloseDuration,
				Enum.EasingStyle.Back,
				Enum.EasingDirection.In
			),
			{
				Size = UDim2.new(0, 0, 0, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0)
			}
		)

		Tween:Play()
		task.wait(Astral.Config.Animation.WindowCloseDuration)
		ScreenGui:Destroy()
	end)
	
	local MinimizeButton = Instance.new("TextButton")
	MinimizeButton.Parent = ControlsFrame
	MinimizeButton.BackgroundColor3 = Astral.Theme.Main
	MinimizeButton.BackgroundTransparency = Astral.Config.Topbar.BackgroundTransparency
	MinimizeButton.Size = UDim2.new(0, ApplyScale(ButtonSize), 0, ApplyScale(TopbarHeight))
	MinimizeButton.Position = UDim2.new(1, -ApplyScale(ButtonSize * 2 + BasePadding * 1.5), 0, 0)
	MinimizeButton.AutoButtonColor = false
	MinimizeButton.Font = Enum.Font.GothamBold
	MinimizeButton.Text = Astral.Config.Controls.MinimizeButtonText
	MinimizeButton.TextColor3 = Astral.Theme.TextDark
	MinimizeButton.TextSize = ApplyScale(Astral.Config.Controls.MinimizeButtonSize)
	MinimizeButton.TextYAlignment = Enum.TextYAlignment.Center
	MinimizeButton.ZIndex = 11

	local MinimizeCorner = Instance.new("UICorner")
	MinimizeCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Controls.ButtonCornerRadius))
	MinimizeCorner.Parent = MinimizeButton

	AddHoverEffect(
		MinimizeButton,
		Astral.Theme.HoverBright,
		Astral.Theme.Main,
		Astral.Config.Elements.Button.HoverTransparency,
		Astral.Config.Topbar.BackgroundTransparency
	)

	AddClickEffect(MinimizeButton)

	MinimizeButton.MouseButton1Click:Connect(function()
		MainFrame.Visible = not MainFrame.Visible
	end)


	local Bubble = Instance.new("TextButton")
	Bubble.Name = "AstralBubble"
	Bubble.Parent = ScreenGui
	Bubble.BackgroundColor3 = Astral.Theme.Main
	Bubble.Position = UDim2.new(1, -50, 0.5, -25)
	Bubble.Size = UDim2.new(0, Astral.Config.Bubble.Size, 0, Astral.Config.Bubble.Size)
	Bubble.ZIndex = 500
	Bubble.Text = ""
	Bubble.AutoButtonColor = false

	local BubbleCorner = Instance.new("UICorner")
	BubbleCorner.CornerRadius = UDim.new(1, 0)
	BubbleCorner.Parent = Bubble

	local BubbleIcon = Instance.new("ImageLabel")
	BubbleIcon.Parent = Bubble
	BubbleIcon.BackgroundTransparency = 1
	BubbleIcon.Size = UDim2.new(1, 0, 1, 0)
	BubbleIcon.Position = UDim2.new(0, 0, 0, 0)
	BubbleIcon.Image = Options.Icon or Astral.Config.Bubble.Icon
	BubbleIcon.ImageColor3 = Astral.Theme.Accent
	BubbleIcon.ScaleType = Enum.ScaleType.Fit

	local BubbleStroke = Instance.new("UIStroke")
	BubbleStroke.Thickness = Astral.Config.Bubble.StrokeThickness
	BubbleStroke.Color = Astral.Theme.Stroke
	BubbleStroke.Transparency = Astral.Config.Bubble.StrokeTransparency
	BubbleStroke.Parent = Bubble

	local BubbleDragging = false
	local DragInput, DragStart, StartPos

	local function SnapToSide()
		local ScreenSize = ScreenGui.AbsoluteSize
		local CurrentPos = Bubble.AbsolutePosition
		local BubbleSize = Bubble.AbsoluteSize
		local CenterX = ScreenSize.X / 2

		local BubbleCenterX = CurrentPos.X + (BubbleSize.X / 2)

		local SnapMargin = Astral.Config.Bubble.SnapMargin
		local EdgeMargin = Astral.Config.Bubble.EdgeMargin
		local TopBottomMargin = Astral.Config.Bubble.TopBottomMargin

		local TargetX
		if BubbleCenterX < CenterX then
			TargetX = EdgeMargin
		else
			TargetX = ScreenSize.X - BubbleSize.X - EdgeMargin
		end

		local TargetY = math.clamp(
			CurrentPos.Y, 
			TopBottomMargin, 
			ScreenSize.Y - BubbleSize.Y - TopBottomMargin
		)

		TweenService:Create(Bubble, TweenInfo.new(
			Astral.Config.Animation.TweenDuration, 
			Enum.EasingStyle.Back, 
			Enum.EasingDirection.Out
			), {
				Position = UDim2.new(0, TargetX, 0, TargetY)
			}):Play()
	end

	Bubble.InputBegan:Connect(function(Input)
		if (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) then
			BubbleDragging = true
			DragStart = Input.Position
			StartPos = Bubble.Position

			Input.Changed:Connect(function()
				if Input.UserInputState == Enum.UserInputState.End then
					BubbleDragging = false
					SnapToSide()
				end
			end)
		end
	end)

	Bubble.InputChanged:Connect(function(Input)
		if (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
			DragInput = Input
		end
	end)

	UserInputService.InputChanged:Connect(function(Input)
		if Input == DragInput and BubbleDragging then
			local Delta = Input.Position - DragStart
			Bubble.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
		end
	end)

	Bubble.MouseButton1Click:Connect(function()
		local MovementThreshold = Astral.Config.Bubble.SnapMargin * 2
		if math.abs(StartPos.X.Offset - Bubble.Position.X.Offset) < MovementThreshold then
			MainFrame.Visible = not MainFrame.Visible
		end
	end)

	local ContentFrame = Instance.new("Frame")
	ContentFrame.Parent = MainFrame
	ContentFrame.BackgroundTransparency = 1
	ContentFrame.Position = UDim2.new(0, 0, 0, ApplyScale(TopbarHeight + BasePadding * 2))
	ContentFrame.Size = UDim2.new(1, 0, 1, -ApplyScale(TopbarHeight + BasePadding * 2))
	ContentFrame.ClipsDescendants = true

	local SidebarFrame = Instance.new("Frame")
	SidebarFrame.Parent = ContentFrame
	SidebarFrame.BackgroundColor3 = Astral.Theme.Tertiary
	SidebarFrame.BackgroundTransparency = Astral.Config.Sidebar.BackgroundTransparency
	SidebarFrame.Position = UDim2.new(0, ApplyScale(BasePadding), 0, 0)
	SidebarFrame.Size = UDim2.new(0, ApplyScale(Astral.Config.Sidebar.Width), 1, -ApplyScale(BasePadding))
	local SidebarCorner = Instance.new("UICorner")
	SidebarCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Sidebar.CornerRadius))
	SidebarCorner.Parent = SidebarFrame

	local SidebarStroke = Instance.new("UIStroke")
	SidebarStroke.Color = Astral.Theme.StrokeDark
	SidebarStroke.Thickness = ApplyScale(Astral.Config.Sidebar.StrokeThickness)
	SidebarStroke.Transparency = Astral.Config.Sidebar.StrokeTransparency
	SidebarStroke.Parent = SidebarFrame

	local TabContainer = Instance.new("ScrollingFrame")
	TabContainer.Parent = SidebarFrame
	TabContainer.BackgroundTransparency = 1
	TabContainer.Position = UDim2.new(0, ApplyScale(BasePadding), 0, ApplyScale(BasePadding))
	TabContainer.Size = UDim2.new(1, -ApplyScale(BasePadding * 2), 1, -ApplyScale(BasePadding * 2))
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
	TabLayout.Padding = UDim.new(0, ApplyScale(Astral.Config.Tab.Padding))
	TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + ApplyScale(Astral.Config.Tab.Padding))
	end)

	local PagesFrame = Instance.new("Frame")
	PagesFrame.Parent = ContentFrame
	PagesFrame.BackgroundColor3 = Astral.Theme.Secondary
	PagesFrame.BackgroundTransparency = Astral.Config.Pages.BackgroundTransparency
	PagesFrame.Position = UDim2.new(0, ApplyScale(Astral.Config.Sidebar.Width + BasePadding * 2), 0, 0)
	PagesFrame.Size = UDim2.new(1, -ApplyScale(Astral.Config.Sidebar.Width + BasePadding * 3), 1, -ApplyScale(BasePadding))
	local PagesCorner = Instance.new("UICorner")
	PagesCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Pages.CornerRadius))
	PagesCorner.Parent = PagesFrame

	local PagesContainer = Instance.new("Frame")
	PagesContainer.Parent = PagesFrame
	PagesContainer.BackgroundTransparency = 1
	PagesContainer.Size = UDim2.new(1, 0, 1, 0)
	ApplyPadding(PagesContainer, ApplyScale(Astral.Config.Pages.Padding))
	PagesContainer.ClipsDescendants = true

	local WindowFunctions = {}
	local FirstTab = true
	local AllTabs = {}
	local ActiveTab = nil

	local function UpdateNotificationPositions()
		for Index, Notification in ipairs(ActiveNotifications) do
			local TargetYOffset = -ApplyScale(20) - ((Index - 1) * ApplyScale(80))
			TweenService:Create(Notification, TweenInfo.new(
				Astral.Config.Animation.NotificationDuration,
				Astral.Config.Animation.EasingStyle,
				Astral.Config.Animation.EasingDirection
				), {
					Position = UDim2.new(1, -ApplyScale(20), 1, TargetYOffset)
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

		local ExitTween = TweenService:Create(NotificationFrame, TweenInfo.new(Astral.Config.Animation.NotificationDuration), {
			Position = UDim2.new(1, ApplyScale(20), NotificationFrame.Position.Y.Scale, NotificationFrame.Position.Y.Offset)
		})
		ExitTween:Play()

		task.wait(Astral.Config.Animation.NotificationDuration)
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
		local Duration = Options.Duration or Astral.Config.Notification.DefaultDuration
		local Type = Options.Type or "Info"

		local TypeColors = Astral.Theme.TypeColors

		if #ActiveNotifications >= MaxNotifications then
			table.insert(NotificationQueue, Options)
			return
		end

		local NotificationFrame = Instance.new("Frame")
		NotificationFrame.Parent = ScreenGui
		NotificationFrame.BackgroundColor3 = Astral.Theme.Main
		NotificationFrame.BackgroundTransparency = Astral.Config.Notification.BackgroundTransparency
		NotificationFrame.Size = UDim2.new(0, ApplyScale(Astral.Config.Notification.Width), 0, ApplyScale(Astral.Config.Notification.Height))
		NotificationFrame.AnchorPoint = Vector2.new(1, 1)
		NotificationFrame.Position = UDim2.new(1.5, 0, 1, -ApplyScale(20))
		NotificationFrame.ZIndex = 100

		local NotificationCorner = Instance.new("UICorner")
		NotificationCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Notification.CornerRadius))
		NotificationCorner.Parent = NotificationFrame

		local NotificationStroke = Instance.new("UIStroke")
		NotificationStroke.Color = TypeColors[Type]
		NotificationStroke.Thickness = ApplyScale(Astral.Config.Notification.StrokeThickness)
		NotificationStroke.Transparency = Astral.Config.Notification.StrokeThickness
		NotificationStroke.Parent = NotificationFrame

		local NotificationTitle = Instance.new("TextLabel")
		NotificationTitle.Parent = NotificationFrame
		NotificationTitle.BackgroundTransparency = 1
		NotificationTitle.Size = UDim2.new(1, 0, 0, ApplyScale(18))
		ApplyPadding(NotificationTitle, ApplyScale(BasePadding))
		NotificationTitle.Font = Astral.Config.Notification.TitleFont
		NotificationTitle.Text = Title
		NotificationTitle.TextColor3 = Astral.Theme.Text
		NotificationTitle.TextSize = ApplyScale(Astral.Config.Notification.TitleSize)
		NotificationTitle.TextXAlignment = Enum.TextXAlignment.Left

		local NotificationContent = Instance.new("TextLabel")
		NotificationContent.Parent = NotificationFrame
		NotificationContent.BackgroundTransparency = 1
		NotificationContent.Position = UDim2.new(0, 0, 0, ApplyScale(28))
		NotificationContent.Size = UDim2.new(1, 0, 1, -ApplyScale(36))
		ApplyPadding(NotificationContent, ApplyScale(BasePadding))
		NotificationContent.Font = Astral.Config.Notification.ContentFont
		NotificationContent.Text = Content
		NotificationContent.TextColor3 = Astral.Theme.TextDark
		NotificationContent.TextSize = ApplyScale(Astral.Config.Notification.ContentSize)
		NotificationContent.TextXAlignment = Enum.TextXAlignment.Left
		NotificationContent.TextYAlignment = Enum.TextYAlignment.Top
		NotificationContent.TextWrapped = true

		table.insert(ActiveNotifications, NotificationFrame)
		UpdateNotificationPositions()

		task.delay(Duration, function()
			local ExitTween = TweenService:Create(NotificationFrame, TweenInfo.new(
				Astral.Config.Animation.NotificationDuration,
				Enum.EasingStyle.Quart,
				Enum.EasingDirection.In
				), {
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

	function WindowFunctions:Hide()
		MainFrame.Visible = false
	end

	function WindowFunctions:Show()
		MainFrame.Visible = true
	end

	function WindowFunctions:Toggle()
		MainFrame.Visible = not MainFrame.Visible
		return MainFrame.Visible
	end

	function WindowFunctions:Destroy()
		ScreenGui:Destroy()
	end

	function WindowFunctions:Minimize()
		MainFrame.Visible = false
	end

	function WindowFunctions:GetMainFrame()
		return MainFrame
	end

	function WindowFunctions:GetScreenGui()
		return ScreenGui
	end

	function WindowFunctions:SetScale(NewScale)
		Scale = NewScale

		local NewWidth = ApplyScale(BaseWidth)
		local NewHeight = ApplyScale(BaseHeight)

		CurrentWidth = NewWidth
		CurrentHeight = NewHeight

		TweenService:Create(MainFrame, TweenInfo.new(Astral.Config.Animation.TweenDuration), {
			Size = UDim2.new(0, NewWidth, 0, NewHeight),
			Position = UDim2.new(0.5, -NewWidth/2, 0.5, -NewHeight/2)
		}):Play()
	end

	function WindowFunctions:GetScale()
		return Scale
	end

	function WindowFunctions:Tab(Options)
		local TabName = Options.Name or "Tab"
		local TabIcon = Options.Icon or "rbxassetid://7733954760"

		local TabButton = Instance.new("TextButton")
		TabButton.Parent = TabContainer
		TabButton.BackgroundColor3 = Astral.Theme.Main
		TabButton.BackgroundTransparency = Astral.Config.Tab.BackgroundTransparency
		TabButton.Size = UDim2.new(1, 0, 0, ApplyScale(Astral.Config.Tab.Height))
		TabButton.AutoButtonColor = false
		TabButton.Text = ""

		local TabButtonCorner = Instance.new("UICorner")
		TabButtonCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Tab.CornerRadius))
		TabButtonCorner.Parent = TabButton

		local IconImage = Instance.new("ImageLabel")
		IconImage.Parent = TabButton
		IconImage.BackgroundTransparency = 1
		IconImage.Position = UDim2.new(0, ApplyScale(BasePadding), 0.5, -ApplyScale(Astral.Config.Tab.IconSize / 2))
		IconImage.Size = UDim2.new(0, ApplyScale(Astral.Config.Tab.IconSize), 0, ApplyScale(Astral.Config.Tab.IconSize))
		IconImage.Image = TabIcon
		IconImage.ImageColor3 = Astral.Theme.TextDark

		local LabelText = Instance.new("TextLabel")
		LabelText.Parent = TabButton
		LabelText.BackgroundTransparency = 1
		LabelText.Position = UDim2.new(0, ApplyScale(30), 0, 0)
		LabelText.Size = UDim2.new(1, -ApplyScale(35), 1, 0)
		LabelText.Font = Astral.Config.Tab.LabelFont
		LabelText.Text = TabName
		LabelText.TextColor3 = Astral.Theme.TextDark
		LabelText.TextSize = ApplyScale(Astral.Config.Tab.LabelSize)
		LabelText.TextXAlignment = Enum.TextXAlignment.Left

		local IndicatorFrame = Instance.new("Frame")
		IndicatorFrame.Name = "Indicator"
		IndicatorFrame.Parent = TabButton
		IndicatorFrame.BackgroundColor3 = Astral.Theme.Accent
		IndicatorFrame.BorderSizePixel = 0
		IndicatorFrame.Position = UDim2.new(0, ApplyScale(2), 0.5, -ApplyScale(Astral.Config.Tab.IndicatorHeight / 2))
		IndicatorFrame.Size = UDim2.new(0, ApplyScale(Astral.Config.Tab.IndicatorWidth), 0, ApplyScale(Astral.Config.Tab.IndicatorHeight))
		IndicatorFrame.Visible = false

		local function ApplyTabHover()
			if ActiveTab ~= TabButton then
				TweenService:Create(TabButton, TweenInfo.new(Astral.Config.Animation.HoverDuration), {
					BackgroundColor3 = Astral.Theme.Tertiary,
					BackgroundTransparency = 0.25
				}):Play()
			end
		end

		local function RemoveTabHover()
			if ActiveTab ~= TabButton then
				TweenService:Create(TabButton, TweenInfo.new(Astral.Config.Animation.HoverDuration), {
					BackgroundColor3 = Astral.Theme.Main,
					BackgroundTransparency = Astral.Config.Tab.BackgroundTransparency
				}):Play()
			end
		end

		TabButton.MouseEnter:Connect(ApplyTabHover)
		TabButton.MouseLeave:Connect(RemoveTabHover)
		AddClickEffect(TabButton)

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
		ApplyPadding(PageFrame, ApplyScale(Astral.Config.Pages.Padding))

		local PageLayout = Instance.new("UIListLayout")
		PageLayout.Parent = PageFrame
		PageLayout.Padding = UDim.new(0, ApplyScale(Astral.Config.Pages.Padding))
		PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			PageFrame.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + ApplyScale(Astral.Config.Pages.Padding * 2))
		end)

		local function Activate()
			for _, Page in pairs(PagesContainer:GetChildren()) do
				if Page:IsA("ScrollingFrame") then
					Page.Visible = false
				end
			end
			for _, TabData in pairs(AllTabs) do
				TabData.Button.Indicator.Visible = false
				TweenService:Create(TabData.Button, TweenInfo.new(Astral.Config.Animation.TweenDuration), {
					BackgroundColor3 = Astral.Theme.Main,
					BackgroundTransparency = Astral.Config.Tab.BackgroundTransparency
				}):Play()
				TweenService:Create(TabData.Label, TweenInfo.new(Astral.Config.Animation.TweenDuration), {TextColor3 = Astral.Theme.TextDark}):Play()
				TweenService:Create(TabData.Icon, TweenInfo.new(Astral.Config.Animation.TweenDuration), {ImageColor3 = Astral.Theme.TextDark}):Play()
			end

			PageFrame.Visible = true
			IndicatorFrame.Visible = true
			TweenService:Create(TabButton, TweenInfo.new(Astral.Config.Animation.TweenDuration), {
				BackgroundColor3 = Astral.Theme.Main,
				BackgroundTransparency = 0
			}):Play()
			TweenService:Create(LabelText, TweenInfo.new(Astral.Config.Animation.TweenDuration), {TextColor3 = Astral.Theme.Text}):Play()
			TweenService:Create(IconImage, TweenInfo.new(Astral.Config.Animation.TweenDuration), {ImageColor3 = Astral.Theme.Accent}):Play()

			ActiveTab = TabButton
		end

		TabButton.MouseButton1Click:Connect(Activate)
		table.insert(AllTabs, {Name = TabName, Button = TabButton, Label = LabelText, Icon = IconImage})

		if FirstTab then
			FirstTab = false
			Activate()
		end

		local TabFunctions = {}

		local TabFunctions = {}

		function TabFunctions:TwoColumn(Options)
			Options = Options or {}

			local TwoColumnFrame = Instance.new("Frame")
			TwoColumnFrame.Parent = PageFrame
			TwoColumnFrame.BackgroundTransparency = 1
			TwoColumnFrame.Size = UDim2.new(1, 0, 0, 0)
			TwoColumnFrame.AutomaticSize = Enum.AutomaticSize.Y

			local LeftColumn = Instance.new("Frame")
			LeftColumn.Parent = TwoColumnFrame
			LeftColumn.BackgroundTransparency = 1
			LeftColumn.Position = UDim2.new(0, 0, 0, 0)
			LeftColumn.Size = UDim2.new(0.5, -ApplyScale(BasePadding / 2), 0, 0)
			LeftColumn.AutomaticSize = Enum.AutomaticSize.Y

			local LeftLayout = Instance.new("UIListLayout")
			LeftLayout.Parent = LeftColumn
			LeftLayout.Padding = UDim.new(0, ApplyScale(Astral.Config.Pages.Padding))

			local RightColumn = Instance.new("Frame")
			RightColumn.Parent = TwoColumnFrame
			RightColumn.BackgroundTransparency = 1
			RightColumn.Position = UDim2.new(0.5, ApplyScale(BasePadding / 2), 0, 0)
			RightColumn.Size = UDim2.new(0.5, -ApplyScale(BasePadding / 2), 0, 0)
			RightColumn.AutomaticSize = Enum.AutomaticSize.Y

			local RightLayout = Instance.new("UIListLayout")
			RightLayout.Parent = RightColumn
			RightLayout.Padding = UDim.new(0, ApplyScale(Astral.Config.Pages.Padding))

			local TwoColumnFunctions = {}

			function TwoColumnFunctions:CreateSection(Column, Options)
				local Parent = Column == "Left" and LeftColumn or RightColumn
				local SectionName = Options.Name or "Section"

				local SectionFrame = Instance.new("Frame")
				SectionFrame.Parent = Parent
				SectionFrame.BackgroundColor3 = Astral.Theme.Tertiary
				SectionFrame.BackgroundTransparency = Astral.Config.Elements.BackgroundTransparency
				SectionFrame.Size = UDim2.new(1, 0, 0, 0)
				SectionFrame.AutomaticSize = Enum.AutomaticSize.Y

				local SectionCorner = Instance.new("UICorner")
				SectionCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Elements.Section.CornerRadius))
				SectionCorner.Parent = SectionFrame

				local HeaderFrame = Instance.new("Frame")
				HeaderFrame.Parent = SectionFrame
				HeaderFrame.BackgroundColor3 = Astral.Theme.Main
				HeaderFrame.BackgroundTransparency = Astral.Config.Elements.Section.HeaderBackgroundTransparency
				HeaderFrame.Size = UDim2.new(1, 0, 0, ApplyScale(Astral.Config.Elements.Section.HeaderHeight))
				local HeaderCorner = Instance.new("UICorner")
				HeaderCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Elements.Section.CornerRadius))
				HeaderCorner.Parent = HeaderFrame

				local SectionLabel = Instance.new("TextLabel")
				SectionLabel.Parent = HeaderFrame
				SectionLabel.BackgroundTransparency = 1
				SectionLabel.Size = UDim2.new(1, 0, 1, 0)
				ApplyPadding(SectionLabel, ApplyScale(BasePadding))
				SectionLabel.Font = Astral.Config.Elements.Section.TitleFont
				SectionLabel.Text = SectionName
				SectionLabel.TextColor3 = Astral.Theme.Text
				SectionLabel.TextSize = ApplyScale(Astral.Config.Elements.Section.TitleSize)
				SectionLabel.TextXAlignment = Enum.TextXAlignment.Left

				local SectionContent = Instance.new("Frame")
				SectionContent.Parent = SectionFrame
				SectionContent.BackgroundTransparency = 1
				SectionContent.Position = UDim2.new(0, 0, 0, ApplyScale(Astral.Config.Elements.Section.HeaderHeight))
				SectionContent.Size = UDim2.new(1, 0, 0, 0)
				SectionContent.AutomaticSize = Enum.AutomaticSize.Y

				ApplyPadding(SectionContent, ApplyScale(BasePadding))

				local SectionLayout = Instance.new("UIListLayout")
				SectionLayout.Parent = SectionContent
				SectionLayout.Padding = UDim.new(0, ApplyScale(BasePadding))

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

			function TwoColumnFunctions:Left(Options)
				return TwoColumnFunctions:CreateSection("Left", Options)
			end

			function TwoColumnFunctions:Right(Options)
				return TwoColumnFunctions:CreateSection("Right", Options)
			end

			return TwoColumnFunctions
		end

		function TabFunctions:Section(Options)
			local SectionName = Options.Name or "Section"

			local SectionFrame = Instance.new("Frame")
			SectionFrame.Parent = PageFrame
			SectionFrame.BackgroundColor3 = Astral.Theme.Tertiary
			SectionFrame.BackgroundTransparency = Astral.Config.Elements.BackgroundTransparency
			SectionFrame.Size = UDim2.new(1, 0, 0, 0)
			SectionFrame.AutomaticSize = Enum.AutomaticSize.Y

			local SectionCorner = Instance.new("UICorner")
			SectionCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Elements.Section.CornerRadius))
			SectionCorner.Parent = SectionFrame

			local HeaderFrame = Instance.new("Frame")
			HeaderFrame.Parent = SectionFrame
			HeaderFrame.BackgroundColor3 = Astral.Theme.Main
			HeaderFrame.BackgroundTransparency = Astral.Config.Elements.Section.HeaderBackgroundTransparency
			HeaderFrame.Size = UDim2.new(1, 0, 0, ApplyScale(Astral.Config.Elements.Section.HeaderHeight))
			local HeaderCorner = Instance.new("UICorner")
			HeaderCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Elements.Section.CornerRadius))
			HeaderCorner.Parent = HeaderFrame

			local SectionLabel = Instance.new("TextLabel")
			SectionLabel.Parent = HeaderFrame
			SectionLabel.BackgroundTransparency = 1
			SectionLabel.Size = UDim2.new(1, 0, 1, 0)
			ApplyPadding(SectionLabel, ApplyScale(BasePadding))
			SectionLabel.Font = Astral.Config.Elements.Section.TitleFont
			SectionLabel.Text = SectionName
			SectionLabel.TextColor3 = Astral.Theme.Text
			SectionLabel.TextSize = ApplyScale(Astral.Config.Elements.Section.TitleSize)
			SectionLabel.TextXAlignment = Enum.TextXAlignment.Left

			local SectionContent = Instance.new("Frame")
			SectionContent.Parent = SectionFrame
			SectionContent.BackgroundTransparency = 1
			SectionContent.Position = UDim2.new(0, 0, 0, ApplyScale(Astral.Config.Elements.Section.HeaderHeight))
			SectionContent.Size = UDim2.new(1, 0, 0, 0)
			SectionContent.AutomaticSize = Enum.AutomaticSize.Y

			ApplyPadding(SectionContent, ApplyScale(BasePadding))

			local SectionLayout = Instance.new("UIListLayout")
			SectionLayout.Parent = SectionContent
			SectionLayout.Padding = UDim.new(0, ApplyScale(BasePadding))

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

		function TabFunctions:Button(Options, Parent)
			Parent = Parent or PageFrame
			local ButtonName = Options.Name or "Button"
			local Callback = Options.Callback or function() end
			local ButtonFont = Options.Font or Astral.Config.Elements.LabelFont
			local ButtonSize = Options.Size or Astral.Config.Elements.LabelSize
			local ButtonHeight = Options.Height or Astral.Config.Elements.Height
			local ButtonWidth = Options.Width
			local ButtonAlignment = Options.Alignment or Astral.Config.Elements.LabelAlignment

			local ButtonFrame = Instance.new("TextButton")
			ButtonFrame.Parent = Parent
			ButtonFrame.BackgroundColor3 = Astral.Theme.Main
			ButtonFrame.BackgroundTransparency = Astral.Config.Elements.BackgroundTransparency
			
			if ButtonWidth then
				ButtonFrame.Size = UDim2.new(0, ApplyScale(ButtonWidth), 0, ApplyScale(ButtonHeight))
			else
				ButtonFrame.Size = UDim2.new(1, 0, 0, ApplyScale(ButtonHeight))
			end
			
			ButtonFrame.AutoButtonColor = false
			ButtonFrame.Text = ""

			local ButtonCorner = Instance.new("UICorner")
			ButtonCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Elements.CornerRadius))
			ButtonCorner.Parent = ButtonFrame

			local ButtonLabel = Instance.new("TextLabel")
			ButtonLabel.Parent = ButtonFrame
			ButtonLabel.BackgroundTransparency = 1
			ButtonLabel.Size = UDim2.new(1, 0, 1, 0)
			ApplyPadding(ButtonLabel, ApplyScale(BasePadding))
			ButtonLabel.Font = ButtonFont
			ButtonLabel.Text = ButtonName
			ButtonLabel.TextColor3 = Astral.Theme.Text
			ButtonLabel.TextSize = ApplyScale(ButtonSize)
			ButtonLabel.TextXAlignment = ButtonAlignment

			AddHoverEffect(
				ButtonFrame, 
				Astral.Theme.HoverBright, 
				Astral.Theme.Main, 
				Astral.Config.Elements.Button.HoverTransparency, 
				Astral.Config.Elements.Button.NormalTransparency
			)
			AddClickEffect(ButtonFrame)
			ButtonFrame.MouseButton1Click:Connect(Callback)

			-- Button update functions
			local ButtonObject = {}
			function ButtonObject:Update(NewOptions)
				if NewOptions.Name then
					ButtonLabel.Text = NewOptions.Name
				end
				if NewOptions.Callback then
					-- Disconnect old callback and connect new one
					ButtonFrame.MouseButton1Click:Disconnect()
					ButtonFrame.MouseButton1Click:Connect(NewOptions.Callback)
				end
				if NewOptions.Font then
					ButtonLabel.Font = NewOptions.Font
				end
				if NewOptions.Size then
					ButtonLabel.TextSize = ApplyScale(NewOptions.Size)
				end
				if NewOptions.Height then
					local NewHeight = ApplyScale(NewOptions.Height)
					ButtonFrame.Size = ButtonWidth and 
						UDim2.new(0, ApplyScale(ButtonWidth), 0, NewHeight) or
						UDim2.new(1, 0, 0, NewHeight)
				end
				if NewOptions.Width then
					ButtonWidth = NewOptions.Width
					ButtonFrame.Size = UDim2.new(0, ApplyScale(ButtonWidth), 0, ButtonFrame.Size.Y.Offset)
				end
				if NewOptions.Alignment then
					ButtonLabel.TextXAlignment = NewOptions.Alignment
				end
			end
			
			function ButtonObject:SetText(Text)
				ButtonLabel.Text = Text
			end
			
			function ButtonObject:SetCallback(NewCallback)
				ButtonFrame.MouseButton1Click:Disconnect()
				ButtonFrame.MouseButton1Click:Connect(NewCallback)
			end

			return ButtonObject
		end

		function TabFunctions:Toggle(Options, Parent)
			Parent = Parent or PageFrame
			local ToggleName = Options.Name or "Toggle"
			local Default = Options.Default or false
			local Callback = Options.Callback or function() end
			local State = Default
			local ToggleFont = Options.Font or Astral.Config.Elements.LabelFont
			local ToggleSize = Options.Size or Astral.Config.Elements.LabelSize
			local ToggleHeight = Options.Height or Astral.Config.Elements.Height
			local ToggleWidth = Options.Width
			local ToggleAlignment = Options.Alignment or Astral.Config.Elements.LabelAlignment

			local ToggleFrame = Instance.new("Frame")
			ToggleFrame.Parent = Parent
			ToggleFrame.BackgroundColor3 = Astral.Theme.Main
			ToggleFrame.BackgroundTransparency = Astral.Config.Elements.BackgroundTransparency
			
			if ToggleWidth then
				ToggleFrame.Size = UDim2.new(0, ApplyScale(ToggleWidth), 0, ApplyScale(ToggleHeight))
			else
				ToggleFrame.Size = UDim2.new(1, 0, 0, ApplyScale(ToggleHeight))
			end

			local ToggleCorner = Instance.new("UICorner")
			ToggleCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Elements.CornerRadius))
			ToggleCorner.Parent = ToggleFrame

			local ToggleLabel = Instance.new("TextLabel")
			ToggleLabel.Parent = ToggleFrame
			ToggleLabel.BackgroundTransparency = 1
			ToggleLabel.Size = UDim2.new(1, 0, 1, 0)
			ApplyPadding(ToggleLabel, ApplyScale(BasePadding))
			ToggleLabel.Font = ToggleFont
			ToggleLabel.Text = ToggleName
			ToggleLabel.TextColor3 = Astral.Theme.Text
			ToggleLabel.TextSize = ApplyScale(ToggleSize)
			ToggleLabel.TextXAlignment = ToggleAlignment

			local ToggleSwitchWidth = ApplyScale(Astral.Config.Elements.Toggle.Width)
			local ToggleSwitchHeight = ApplyScale(Astral.Config.Elements.Toggle.Height)
			local ToggleCircleSize = ApplyScale(Astral.Config.Elements.Toggle.CircleSize)
			
			local CheckButton = Instance.new("TextButton")
			CheckButton.Parent = ToggleFrame
			CheckButton.BackgroundColor3 = State and Astral.Theme.Accent or Astral.Theme.Tertiary
			CheckButton.Position = UDim2.new(1, -ToggleSwitchWidth - ApplyScale(8), 0.5, -ToggleSwitchHeight / 2)
			CheckButton.Size = UDim2.new(0, ToggleSwitchWidth, 0, ToggleSwitchHeight)
			CheckButton.AutoButtonColor = false
			CheckButton.Text = ""

			local CheckCorner = Instance.new("UICorner")
			CheckCorner.CornerRadius = UDim.new(1, 0)
			CheckCorner.Parent = CheckButton

			local CircleFrame = Instance.new("Frame")
			CircleFrame.Parent = CheckButton
			CircleFrame.BackgroundColor3 = Astral.Theme.Text
			CircleFrame.Size = UDim2.new(0, ToggleCircleSize, 0, ToggleCircleSize)
			CircleFrame.Position = State and UDim2.new(1, -ToggleCircleSize - ApplyScale(2), 0.5, -ToggleCircleSize / 2) or UDim2.new(0, ApplyScale(2), 0.5, -ToggleCircleSize / 2)

			local CircleCorner = Instance.new("UICorner")
			CircleCorner.CornerRadius = UDim.new(1, 0)
			CircleCorner.Parent = CircleFrame

			local function Update()
				local Position = State and UDim2.new(1, -ToggleCircleSize - ApplyScale(2), 0.5, -ToggleCircleSize / 2) or UDim2.new(0, ApplyScale(2), 0.5, -ToggleCircleSize / 2)
				local Color = State and Astral.Theme.Accent or Astral.Theme.Tertiary
				TweenService:Create(CircleFrame, TweenInfo.new(Astral.Config.Animation.TweenDuration), {Position = Position}):Play()
				TweenService:Create(CheckButton, TweenInfo.new(Astral.Config.Animation.TweenDuration), {BackgroundColor3 = Color}):Play()
				Callback(State)
			end

			CheckButton.MouseButton1Click:Connect(function()
				State = not State
				Update()
			end)
			Update()

			-- Toggle update functions
			local ToggleObject = {}
			function ToggleObject:Update(NewOptions)
				if NewOptions.Name then
					ToggleLabel.Text = NewOptions.Name
				end
				if NewOptions.Callback then
					Callback = NewOptions.Callback
					-- Reconnect with new callback
					CheckButton.MouseButton1Click:Disconnect()
					CheckButton.MouseButton1Click:Connect(function()
						State = not State
						Update()
					end)
				end
				if NewOptions.Default ~= nil and NewOptions.Default ~= State then
					State = NewOptions.Default
					Update()
				end
				if NewOptions.Font then
					ToggleLabel.Font = NewOptions.Font
				end
				if NewOptions.Size then
					ToggleLabel.TextSize = ApplyScale(NewOptions.Size)
				end
				if NewOptions.Height then
					local NewHeight = ApplyScale(NewOptions.Height)
					ToggleFrame.Size = ToggleWidth and 
						UDim2.new(0, ApplyScale(ToggleWidth), 0, NewHeight) or
						UDim2.new(1, 0, 0, NewHeight)
					-- Update switch position
					CheckButton.Position = UDim2.new(1, -ToggleSwitchWidth - ApplyScale(8), 0.5, -ToggleSwitchHeight / 2)
				end
				if NewOptions.Width then
					ToggleWidth = NewOptions.Width
					ToggleFrame.Size = UDim2.new(0, ApplyScale(ToggleWidth), 0, ToggleFrame.Size.Y.Offset)
					CheckButton.Position = UDim2.new(1, -ToggleSwitchWidth - ApplyScale(8), 0.5, -ToggleSwitchHeight / 2)
				end
				if NewOptions.Alignment then
					ToggleLabel.TextXAlignment = NewOptions.Alignment
				end
			end
			
			function ToggleObject:SetState(NewState)
				if State ~= NewState then
					State = NewState
					Update()
				end
			end
			
			function ToggleObject:GetState()
				return State
			end
			
			function ToggleObject:SetText(Text)
				ToggleLabel.Text = Text
			end
			
			function ToggleObject:SetCallback(NewCallback)
				Callback = NewCallback
			end
			
			function ToggleObject:Toggle()
				State = not State
				Update()
				return State
			end

			return ToggleObject
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
			local SliderFont = Options.Font or Astral.Config.Elements.LabelFont
			local SliderSize = Options.Size or Astral.Config.Elements.LabelSize
			local SliderHeight = Options.Height or Astral.Config.Elements.Slider.Height
			local SliderWidth = Options.Width
			local SliderAlignment = Options.Alignment or Astral.Config.Elements.LabelAlignment

			local SliderFrame = Instance.new("Frame")
			SliderFrame.Parent = Parent
			SliderFrame.BackgroundColor3 = Astral.Theme.Main
			SliderFrame.BackgroundTransparency = Astral.Config.Elements.BackgroundTransparency
			
			if SliderWidth then
				SliderFrame.Size = UDim2.new(0, ApplyScale(SliderWidth), 0, ApplyScale(SliderHeight))
			else
				SliderFrame.Size = UDim2.new(1, 0, 0, ApplyScale(SliderHeight))
			end

			local SliderCorner = Instance.new("UICorner")
			SliderCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Elements.CornerRadius))
			SliderCorner.Parent = SliderFrame

			local SliderLabel = Instance.new("TextLabel")
			SliderLabel.Parent = SliderFrame
			SliderLabel.BackgroundTransparency = 1
			SliderLabel.Size = UDim2.new(1, 0, 0, ApplyScale(Astral.Config.Elements.Slider.LabelHeight))
			ApplyPadding(SliderLabel, ApplyScale(BasePadding))
			SliderLabel.Font = SliderFont
			SliderLabel.Text = SliderName
			SliderLabel.TextColor3 = Astral.Theme.Text
			SliderLabel.TextSize = ApplyScale(SliderSize)
			SliderLabel.TextXAlignment = SliderAlignment

			local ValueInput = Instance.new("TextBox")
			ValueInput.Parent = SliderFrame
			ValueInput.BackgroundColor3 = Astral.Theme.Tertiary
			ValueInput.BackgroundTransparency = Astral.Config.Elements.BackgroundTransparency
			ValueInput.Position = UDim2.new(1, -ApplyScale(Astral.Config.Elements.Slider.InputWidth + 12), 0, ApplyScale(4))
			ValueInput.Size = UDim2.new(0, ApplyScale(Astral.Config.Elements.Slider.InputWidth), 0, ApplyScale(Astral.Config.Elements.Slider.InputHeight))
			ValueInput.Font = Astral.Config.Elements.Slider.ValueInputFont
			ValueInput.Text = tostring(Value)
			ValueInput.TextColor3 = Astral.Theme.Accent
			ValueInput.TextSize = ApplyScale(Astral.Config.Elements.Slider.InputTextSize)
			ValueInput.ClearTextOnFocus = false

			local InputStroke = Instance.new("UIStroke")
			InputStroke.Parent = ValueInput
			InputStroke.Color = Astral.Theme.Stroke
			InputStroke.Thickness = ApplyScale(Astral.Config.Elements.TextBox.StrokeThickness)
			InputStroke.Transparency = Astral.Config.Elements.TextBox.StrokeTransparency

			local BackgroundFrame = Instance.new("Frame")
			BackgroundFrame.Parent = SliderFrame
			BackgroundFrame.BackgroundColor3 = Astral.Theme.Tertiary
			BackgroundFrame.Position = UDim2.new(0, ApplyScale(BasePadding), 1, -ApplyScale(Astral.Config.Elements.Slider.TrackHeight + 12))
			BackgroundFrame.Size = UDim2.new(1, -ApplyScale(BasePadding * 2), 0, ApplyScale(Astral.Config.Elements.Slider.TrackHeight))

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

			local BallSize = ApplyScale(Astral.Config.Elements.Slider.BallSize)
			local BallFrame = Instance.new("Frame")
			BallFrame.Parent = BackgroundFrame
			BallFrame.BackgroundColor3 = Astral.Theme.Text
			BallFrame.Size = UDim2.new(0, BallSize, 0, BallSize)
			BallFrame.Position = UDim2.new((Value - Min) / (Max - Min), -BallSize / 2, 0.5, -BallSize / 2)
			BallFrame.ZIndex = 2

			local BallCorner = Instance.new("UICorner")
			BallCorner.CornerRadius = UDim.new(1, 0)
			BallCorner.Parent = BallFrame

			local Dragging = false

			local function UpdateVisuals()
				local VisualPercentage = (Value - Min) / (Max - Min)
				TweenService:Create(FillFrame, TweenInfo.new(0.05), {Size = UDim2.new(VisualPercentage, 0, 1, 0)}):Play()
				TweenService:Create(BallFrame, TweenInfo.new(0.05), {Position = UDim2.new(VisualPercentage, -BallSize / 2, 0.5, -BallSize / 2)}):Play()
				ValueInput.Text = tostring(Value)
				Callback(Value)
			end

			local function Update(Input)
				local SizeX = BackgroundFrame.AbsoluteSize.X
				local OffsetX = math.clamp(Input.Position.X - BackgroundFrame.AbsolutePosition.X, 0, SizeX)
				local Percentage = OffsetX / SizeX

				Value = math.floor(((Max - Min) * Percentage + Min) / Increment + 0.5) * Increment
				Value = math.clamp(Value, Min, Max)
				UpdateVisuals()
			end

			local function UpdateFromText()
				local InputValue = tonumber(ValueInput.Text)
				if InputValue then
					Value = math.clamp(math.floor(InputValue / Increment + 0.5) * Increment, Min, Max)
					UpdateVisuals()
				else
					ValueInput.Text = tostring(Value)
				end
			end

			BallFrame.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					Dragging = true
					ScrollToElement(PageFrame, SliderFrame)
				end
			end)

			BackgroundFrame.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					Dragging = true
					ScrollToElement(PageFrame, SliderFrame)
					Update(Input)
				end
			end)

			UserInputService.InputChanged:Connect(function(Input)
				if Dragging and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch) then
					Update(Input)
				end
			end)

			UserInputService.InputEnded:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					Dragging = false
				end
			end)

			ValueInput.Focused:Connect(function()
				ScrollToElement(PageFrame, SliderFrame)
			end)

			ValueInput.FocusLost:Connect(function(EnterPressed)
				UpdateFromText()
			end)

			-- Slider update functions
			local SliderObject = {}
			function SliderObject:Update(NewOptions)
				if NewOptions.Name then
					SliderLabel.Text = NewOptions.Name
				end
				if NewOptions.Callback then
					Callback = NewOptions.Callback
					Callback(Value) -- Call with current value
				end
				if NewOptions.Min then
					Min = NewOptions.Min
					Value = math.clamp(Value, Min, Max)
					UpdateVisuals()
				end
				if NewOptions.Max then
					Max = NewOptions.Max
					Value = math.clamp(Value, Min, Max)
					UpdateVisuals()
				end
				if NewOptions.Default ~= nil then
					Value = math.clamp(NewOptions.Default, Min, Max)
					UpdateVisuals()
				end
				if NewOptions.Increment then
					Increment = NewOptions.Increment
					Value = math.floor(Value / Increment + 0.5) * Increment
					UpdateVisuals()
				end
				if NewOptions.Font then
					SliderLabel.Font = NewOptions.Font
				end
				if NewOptions.Size then
					SliderLabel.TextSize = ApplyScale(NewOptions.Size)
				end
				if NewOptions.Height then
					local NewHeight = ApplyScale(NewOptions.Height)
					SliderFrame.Size = SliderWidth and 
						UDim2.new(0, ApplyScale(SliderWidth), 0, NewHeight) or
						UDim2.new(1, 0, 0, NewHeight)
				end
				if NewOptions.Width then
					SliderWidth = NewOptions.Width
					SliderFrame.Size = UDim2.new(0, ApplyScale(SliderWidth), 0, SliderFrame.Size.Y.Offset)
				end
				if NewOptions.Alignment then
					SliderLabel.TextXAlignment = NewOptions.Alignment
				end
			end
			
			function SliderObject:SetValue(NewValue)
				Value = math.clamp(NewValue, Min, Max)
				UpdateVisuals()
			end
			
			function SliderObject:GetValue()
				return Value
			end
			
			function SliderObject:SetRange(NewMin, NewMax)
				Min = NewMin
				Max = NewMax
				Value = math.clamp(Value, Min, Max)
				UpdateVisuals()
			end
			
			function SliderObject:SetText(Text)
				SliderLabel.Text = Text
			end
			
			function SliderObject:SetCallback(NewCallback)
				Callback = NewCallback
			end

			return SliderObject
		end

		function TabFunctions:TextBox(Options, Parent)
			Parent = Parent or PageFrame
			local TextBoxName = Options.Name or "TextBox"
			local Default = Options.Default or ""
			local Placeholder = Options.Placeholder or "Enter text..."
			local Callback = Options.Callback or function() end
			local TextBoxFont = Options.Font or Astral.Config.Elements.LabelFont
			local TextBoxSize = Options.Size or Astral.Config.Elements.LabelSize
			local TextBoxHeight = Options.Height or Astral.Config.Elements.TextBox.Height
			local TextBoxWidth = Options.Width
			local TextBoxAlignment = Options.Alignment or Astral.Config.Elements.LabelAlignment

			local TextBoxFrame = Instance.new("Frame")
			TextBoxFrame.Parent = Parent
			TextBoxFrame.BackgroundColor3 = Astral.Theme.Main
			TextBoxFrame.BackgroundTransparency = Astral.Config.Elements.BackgroundTransparency
			
			if TextBoxWidth then
				TextBoxFrame.Size = UDim2.new(0, ApplyScale(TextBoxWidth), 0, ApplyScale(TextBoxHeight))
			else
				TextBoxFrame.Size = UDim2.new(1, 0, 0, ApplyScale(TextBoxHeight))
			end

			local TextBoxCorner = Instance.new("UICorner")
			TextBoxCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Elements.CornerRadius))
			TextBoxCorner.Parent = TextBoxFrame

			local TextBoxLabel = Instance.new("TextLabel")
			TextBoxLabel.Parent = TextBoxFrame
			TextBoxLabel.BackgroundTransparency = 1
			TextBoxLabel.Size = UDim2.new(1, 0, 0, ApplyScale(Astral.Config.Elements.TextBox.LabelHeight))
			ApplyPadding(TextBoxLabel, ApplyScale(BasePadding))
			TextBoxLabel.Font = TextBoxFont
			TextBoxLabel.Text = TextBoxName
			TextBoxLabel.TextColor3 = Astral.Theme.Text
			TextBoxLabel.TextSize = ApplyScale(TextBoxSize)
			TextBoxLabel.TextXAlignment = TextBoxAlignment

			local InputBox = Instance.new("TextBox")
			InputBox.Parent = TextBoxFrame
			InputBox.BackgroundColor3 = Astral.Theme.Tertiary
			InputBox.BackgroundTransparency = Astral.Config.Elements.BackgroundTransparency
			InputBox.Position = UDim2.new(0, ApplyScale(BasePadding), 0, ApplyScale(Astral.Config.Elements.TextBox.LabelHeight + 8))
			InputBox.Size = UDim2.new(1, -ApplyScale(BasePadding * 2), 0, ApplyScale(Astral.Config.Elements.TextBox.InputHeight))
			InputBox.Font = Enum.Font.Gotham
			InputBox.PlaceholderText = Placeholder
			InputBox.PlaceholderColor3 = Astral.Config.Elements.TextBox.PlaceholderColor
			InputBox.Text = Default
			InputBox.TextColor3 = Astral.Theme.Text
			InputBox.TextSize = ApplyScale(Astral.Config.Elements.TextBox.InputTextSize)
			InputBox.TextXAlignment = Enum.TextXAlignment.Left
			InputBox.ClearTextOnFocus = false

			local InputCorner = Instance.new("UICorner")
			InputCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Elements.TextBox.InputCornerRadius))
			InputCorner.Parent = InputBox

			local InputStroke = Instance.new("UIStroke")
			InputStroke.Parent = InputBox
			InputStroke.Color = Astral.Theme.Stroke
			InputStroke.Thickness = ApplyScale(Astral.Config.Elements.TextBox.StrokeThickness)
			InputStroke.Transparency = Astral.Config.Elements.TextBox.StrokeTransparency

			InputBox.Focused:Connect(function()
				ScrollToElement(PageFrame, TextBoxFrame)
			end)

			InputBox.FocusLost:Connect(function(EnterPressed)
				if EnterPressed then
					Callback(InputBox.Text)
				end
			end)

			-- TextBox update functions
			local TextBoxObject = {}
			function TextBoxObject:Update(NewOptions)
				if NewOptions.Name then
					TextBoxLabel.Text = NewOptions.Name
				end
				if NewOptions.Callback then
					Callback = NewOptions.Callback
				end
				if NewOptions.Default then
					InputBox.Text = NewOptions.Default
				end
				if NewOptions.Placeholder then
					InputBox.PlaceholderText = NewOptions.Placeholder
				end
				if NewOptions.Font then
					TextBoxLabel.Font = NewOptions.Font
				end
				if NewOptions.Size then
					TextBoxLabel.TextSize = ApplyScale(NewOptions.Size)
				end
				if NewOptions.Height then
					local NewHeight = ApplyScale(NewOptions.Height)
					TextBoxFrame.Size = TextBoxWidth and 
						UDim2.new(0, ApplyScale(TextBoxWidth), 0, NewHeight) or
						UDim2.new(1, 0, 0, NewHeight)
					-- Update input box position
					InputBox.Position = UDim2.new(0, ApplyScale(BasePadding), 0, ApplyScale(Astral.Config.Elements.TextBox.LabelHeight + 8))
				end
				if NewOptions.Width then
					TextBoxWidth = NewOptions.Width
					TextBoxFrame.Size = UDim2.new(0, ApplyScale(TextBoxWidth), 0, TextBoxFrame.Size.Y.Offset)
					InputBox.Size = UDim2.new(1, -ApplyScale(BasePadding * 2), 0, ApplyScale(Astral.Config.Elements.TextBox.InputHeight))
				end
				if NewOptions.Alignment then
					TextBoxLabel.TextXAlignment = NewOptions.Alignment
				end
			end
			
			function TextBoxObject:SetText(Text)
				InputBox.Text = Text
			end
			
			function TextBoxObject:GetText()
				return InputBox.Text
			end
			
			function TextBoxObject:SetPlaceholder(Text)
				InputBox.PlaceholderText = Text
			end
			
			function TextBoxObject:SetName(Text)
				TextBoxLabel.Text = Text
			end
			
			function TextBoxObject:SetCallback(NewCallback)
				Callback = NewCallback
			end

			return TextBoxObject
		end

		function TabFunctions:Dropdown(Options, Parent)
			Parent = Parent or PageFrame
			local DropdownName = Options.Name or "Dropdown"
			local DropdownOptions = Options.Options or {}
			local CurrentSelected = Options.Default or nil
			local Callback = Options.Callback or function() end
			local Dropped = false
			local VisibleOptions = Options.VisibleOptions or 4
			local DropdownFont = Options.Font or Astral.Config.Elements.LabelFont
			local DropdownSize = Options.Size or Astral.Config.Elements.LabelSize
			local DropdownHeight = Options.Height or Astral.Config.Elements.Dropdown.Height
			local DropdownWidth = Options.Width

			local BaseElementHeight = DropdownHeight
			local BaseOptionHeight = Astral.Config.Elements.Dropdown.OptionHeight
			local BasePaddingValue = BasePadding

			local OptionHeight = ApplyScale(BaseOptionHeight)
			local OptionPadding = ApplyScale(BasePaddingValue)

			local CalculatedListHeight = (OptionHeight + OptionPadding) * VisibleOptions - OptionPadding
			if CalculatedListHeight < OptionHeight then
				CalculatedListHeight = OptionHeight
			end

			local ExpandedHeight = ApplyScale(BaseElementHeight) + 
				ApplyScale(BaseElementHeight) + 
				ApplyScale(BasePaddingValue) + 
				CalculatedListHeight + 
				ApplyScale(BasePaddingValue * 2)

			local BaseTotalHeight = ApplyScale(BaseElementHeight)

			local DropdownFrame = Instance.new("Frame")
			DropdownFrame.Parent = Parent
			DropdownFrame.BackgroundColor3 = Astral.Theme.Main
			DropdownFrame.BackgroundTransparency = Astral.Config.Elements.BackgroundTransparency
			
			if DropdownWidth then
				DropdownFrame.Size = UDim2.new(0, ApplyScale(DropdownWidth), 0, BaseTotalHeight)
			else
				DropdownFrame.Size = UDim2.new(1, 0, 0, BaseTotalHeight)
			end
			
			DropdownFrame.ClipsDescendants = true
			local DropdownCorner = Instance.new("UICorner")
			DropdownCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Elements.CornerRadius))
			DropdownCorner.Parent = DropdownFrame

			local DropdownPadding = Instance.new("UIPadding")
			DropdownPadding.Parent = DropdownFrame
			DropdownPadding.PaddingBottom = UDim.new(0, ApplyScale(BasePaddingValue))

			local DropdownButton = Instance.new("TextButton")
			DropdownButton.Parent = DropdownFrame
			DropdownButton.BackgroundTransparency = 1
			DropdownButton.Size = UDim2.new(1, 0, 0, ApplyScale(BaseElementHeight))
			DropdownButton.Text = ""

			local DropdownLabel = Instance.new("TextLabel")
			DropdownLabel.Parent = DropdownButton
			DropdownLabel.Size = UDim2.new(1, 0, 1, 0)
			ApplyPadding(DropdownLabel, ApplyScale(BasePaddingValue))
			DropdownLabel.Font = DropdownFont
			DropdownLabel.Text = DropdownName .. (CurrentSelected and (": " .. tostring(CurrentSelected)) or "")
			DropdownLabel.TextColor3 = Astral.Theme.Text
			DropdownLabel.TextSize = ApplyScale(DropdownSize)
			DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
			DropdownLabel.BackgroundTransparency = 1

			local ArrowImage = Instance.new("ImageLabel")
			ArrowImage.Parent = DropdownButton
			ArrowImage.BackgroundTransparency = 1
			ArrowImage.Position = UDim2.new(1, -ApplyScale(26), 0.5, -Astral.Config.Elements.Dropdown.ArrowSize / 2)
			ArrowImage.Size = UDim2.new(0, ApplyScale(Astral.Config.Elements.Dropdown.ArrowSize), 0, Astral.Config.Elements.Dropdown.ArrowSize)
			ArrowImage.Image = "rbxassetid://6031091004"
			ArrowImage.ImageColor3 = Astral.Theme.Accent

			local Header = Instance.new("Frame")
			Header.Parent = DropdownFrame
			Header.Position = UDim2.new(0, ApplyScale(BasePaddingValue), 0, ApplyScale(BaseElementHeight + BasePaddingValue))
			Header.Size = UDim2.new(1, -ApplyScale(BasePaddingValue * 2), 0, ApplyScale(BaseElementHeight))
			Header.BackgroundTransparency = 1
			Header.Visible = false

			local SearchBox = Instance.new("TextBox")
			SearchBox.Parent = Header
			SearchBox.Size = UDim2.new(1, -ApplyScale(50), 1, 0)
			SearchBox.BackgroundColor3 = Astral.Theme.Tertiary
			SearchBox.BackgroundTransparency = Astral.Config.Elements.BackgroundTransparency
			SearchBox.PlaceholderText = Astral.Config.Elements.Dropdown.SearchPlaceholder
			SearchBox.Text = ""
			SearchBox.TextColor3 = Astral.Theme.Text
			SearchBox.Font = Enum.Font.Gotham
			SearchBox.TextSize = Astral.Config.Elements.Dropdown.SearchTextSize
			local SearchBoxCorner = Instance.new("UICorner")
			SearchBoxCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Elements.Dropdown.InputCornerRadius))
			SearchBoxCorner.Parent = SearchBox

			local SearchStroke = Instance.new("UIStroke")
			SearchStroke.Parent = SearchBox
			SearchStroke.Color = Astral.Theme.Stroke
			SearchStroke.Thickness = ApplyScale(Astral.Config.Elements.Dropdown.StrokeThickness)
			SearchStroke.Transparency = Astral.Config.Elements.Dropdown.StrokeTransparency

			local ClearBtn = Instance.new("TextButton")
			ClearBtn.Parent = Header
			ClearBtn.Position = UDim2.new(1, -ApplyScale(45), 0, 0)
			ClearBtn.Size = UDim2.new(0, ApplyScale(45), 1, 0)
			ClearBtn.BackgroundColor3 = Astral.Theme.Error
			ClearBtn.BackgroundTransparency = Astral.Config.Elements.BackgroundTransparency
			ClearBtn.Text = Astral.Config.Elements.Dropdown.ClearButtonText
			ClearBtn.Font = Enum.Font.GothamBold
			ClearBtn.TextColor3 = Astral.Theme.Text
			ClearBtn.TextSize = Astral.Config.Elements.Dropdown.ButtonTextSize
			local ClearBtnCorner = Instance.new("UICorner")
			ClearBtnCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Elements.Dropdown.InputCornerRadius))
			ClearBtnCorner.Parent = ClearBtn

			local DropdownList = Instance.new("ScrollingFrame")
			DropdownList.Parent = DropdownFrame
			DropdownList.BackgroundTransparency = 1
			DropdownList.Position = UDim2.new(0, ApplyScale(BasePaddingValue), 0, ApplyScale(BaseElementHeight * 2 + BasePaddingValue * 2))
			DropdownList.Size = UDim2.new(1, -ApplyScale(BasePaddingValue * 2), 0, CalculatedListHeight)
			DropdownList.ScrollBarThickness = 0
			DropdownList.ScrollBarImageTransparency = 1
			DropdownList.BorderSizePixel = 0
			DropdownList.ScrollBarImageColor3 = Astral.Theme.Accent
			DropdownList.VerticalScrollBarInset = Enum.ScrollBarInset.None
			DropdownList.HorizontalScrollBarInset = Enum.ScrollBarInset.None
			DropdownList.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
			DropdownList.ScrollingEnabled = false
			DropdownList.Visible = false

			CreateScrollBar(DropdownList)

			local DropdownLayout = Instance.new("UIListLayout")
			DropdownLayout.Parent = DropdownList
			DropdownLayout.Padding = UDim.new(0, ApplyScale(BasePaddingValue))

			local function Refresh(Filter)
				for _, Child in pairs(DropdownList:GetChildren()) do
					if Child:IsA("TextButton") then Child:Destroy() end
				end
				for _, Option in pairs(DropdownOptions) do
					if Filter and Filter ~= "" and not string.find(string.lower(Option), string.lower(Filter)) then continue end

					local IsSelected = (CurrentSelected == Option)
					local OptionButton = Instance.new("TextButton")
					OptionButton.Parent = DropdownList
					OptionButton.BackgroundColor3 = IsSelected and Astral.Theme.Accent or Astral.Theme.Tertiary
					OptionButton.BackgroundTransparency = IsSelected and 0.15 or Astral.Config.Elements.BackgroundTransparency
					OptionButton.Size = UDim2.new(1, 0, 0, Astral.Config.Elements.Dropdown.OptionHeight)
					OptionButton.Text = Option
					OptionButton.Font = IsSelected and Enum.Font.GothamBold or Enum.Font.Gotham
					OptionButton.TextColor3 = IsSelected and Astral.Theme.Text or Astral.Theme.TextDark
					OptionButton.TextSize = Astral.Config.Elements.Dropdown.OptionTextSize
					local OptionCorner = Instance.new("UICorner")
					OptionCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Elements.Dropdown.InputCornerRadius))
					OptionCorner.Parent = OptionButton

					OptionButton.MouseButton1Click:Connect(function()
						CurrentSelected = Option
						DropdownLabel.Text = DropdownName .. ": " .. Option
						Callback(Option)
						Refresh(SearchBox.Text)
					end)
				end

				local ContentHeight = DropdownLayout.AbsoluteContentSize.Y
				DropdownList.CanvasSize = UDim2.new(0, 0, 0, ContentHeight)
				DropdownList.ScrollingEnabled = ContentHeight > CalculatedListHeight
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

					ScrollToElement(PageFrame, DropdownFrame, ExpandedHeight)

					TweenService:Create(DropdownFrame, TweenInfo.new(Astral.Config.Animation.DropdownDuration), {
						Size = UDim2.new(1, 0, 0, ExpandedHeight)
					}):Play()
					TweenService:Create(ArrowImage, TweenInfo.new(Astral.Config.Animation.DropdownDuration), {
						Rotation = 180
					}):Play()
				else
					Header.Visible = false
					DropdownList.Visible = false

					TweenService:Create(DropdownFrame, TweenInfo.new(Astral.Config.Animation.DropdownDuration), {
						Size = UDim2.new(1, 0, 0, BaseTotalHeight)
					}):Play()
					TweenService:Create(ArrowImage, TweenInfo.new(Astral.Config.Animation.DropdownDuration), {
						Rotation = 0
					}):Play()
				end
			end)

			-- Dropdown update functions
			local DropdownObject = {}
			function DropdownObject:Update(NewOptions)
				if NewOptions.Name then
					DropdownName = NewOptions.Name
					DropdownLabel.Text = DropdownName .. (CurrentSelected and (": " .. tostring(CurrentSelected)) or "")
				end
				if NewOptions.Callback then
					Callback = NewOptions.Callback
				end
				if NewOptions.Options then
					DropdownOptions = NewOptions.Options
					Refresh(SearchBox.Text)
				end
				if NewOptions.Default ~= nil then
					if NewOptions.Default == nil then
						CurrentSelected = nil
						DropdownLabel.Text = DropdownName
					elseif table.find(DropdownOptions, NewOptions.Default) then
						CurrentSelected = NewOptions.Default
						DropdownLabel.Text = DropdownName .. ": " .. CurrentSelected
					end
					Callback(CurrentSelected)
					Refresh(SearchBox.Text)
				end
				if NewOptions.VisibleOptions then
					VisibleOptions = NewOptions.VisibleOptions
					-- Recalculate heights
					CalculatedListHeight = (OptionHeight + OptionPadding) * VisibleOptions - OptionPadding
					if CalculatedListHeight < OptionHeight then
						CalculatedListHeight = OptionHeight
					end
					ExpandedHeight = ApplyScale(BaseElementHeight) + 
						ApplyScale(BaseElementHeight) + 
						ApplyScale(BasePaddingValue) + 
						CalculatedListHeight + 
						ApplyScale(BasePaddingValue * 2)
					
					DropdownList.Size = UDim2.new(1, -ApplyScale(BasePaddingValue * 2), 0, CalculatedListHeight)
				end
				if NewOptions.Font then
					DropdownLabel.Font = NewOptions.Font
				end
				if NewOptions.Size then
					DropdownLabel.TextSize = ApplyScale(NewOptions.Size)
				end
				if NewOptions.Height then
					BaseElementHeight = NewOptions.Height
					BaseTotalHeight = ApplyScale(BaseElementHeight)
					DropdownButton.Size = UDim2.new(1, 0, 0, BaseTotalHeight)
					DropdownFrame.Size = DropdownWidth and 
						UDim2.new(0, ApplyScale(DropdownWidth), 0, BaseTotalHeight) or
						UDim2.new(1, 0, 0, BaseTotalHeight)
				end
				if NewOptions.Width then
					DropdownWidth = NewOptions.Width
					DropdownFrame.Size = UDim2.new(0, ApplyScale(DropdownWidth), 0, BaseTotalHeight)
				end
			end
			
			function DropdownObject:SetOptions(NewOptions)
				DropdownOptions = NewOptions
				Refresh(SearchBox.Text)
			end
			
			function DropdownObject:AddOption(Option)
				table.insert(DropdownOptions, Option)
				Refresh(SearchBox.Text)
			end
			
			function DropdownObject:RemoveOption(Option)
				for i, v in ipairs(DropdownOptions) do
					if v == Option then
						table.remove(DropdownOptions, i)
						break
					end
				end
				if CurrentSelected == Option then
					CurrentSelected = nil
					DropdownLabel.Text = DropdownName
					Callback(nil)
				end
				Refresh(SearchBox.Text)
			end
			
			function DropdownObject:SetSelected(Option)
				if Option == nil or table.find(DropdownOptions, Option) then
					CurrentSelected = Option
					DropdownLabel.Text = DropdownName .. (Option and (": " .. Option) or "")
					Callback(Option)
					Refresh(SearchBox.Text)
				end
			end
			
			function DropdownObject:GetSelected()
				return CurrentSelected
			end
			
			function DropdownObject:GetOptions()
				return DropdownOptions
			end
			
			function DropdownObject:SetName(Text)
				DropdownName = Text
				DropdownLabel.Text = DropdownName .. (CurrentSelected and (": " .. CurrentSelected) or "")
			end
			
			function DropdownObject:SetCallback(NewCallback)
				Callback = NewCallback
			end

			return DropdownObject
		end

		function TabFunctions:MultiDropdown(Options, Parent)
			Parent = Parent or PageFrame
			local DropdownName = Options.Name or "Multi-Dropdown"
			local DropdownOptions = Options.Options or {}
			local Default = Options.Default or {}
			local Callback = Options.Callback or function() end
			local Max = Options.Max or #DropdownOptions
			local Min = Options.Min or 0
			local VisibleOptions = Options.VisibleOptions or 4
			local MultiDropdownFont = Options.Font or Astral.Config.Elements.LabelFont
			local MultiDropdownSize = Options.Size or Astral.Config.Elements.LabelSize
			local MultiDropdownHeight = Options.Height or Astral.Config.Elements.MultiDropdown.Height
			local MultiDropdownWidth = Options.Width

			local Selected = {}
			local SelectionOrder = {}
			local Dropped = false

			for _, v in pairs(Default) do
				if #SelectionOrder < Max then
					Selected[v] = true
					table.insert(SelectionOrder, v)
				end
			end

			local BaseElementHeight = MultiDropdownHeight
			local BaseOptionHeight = Astral.Config.Elements.MultiDropdown.OptionHeight
			local BasePaddingValue = BasePadding

			local OptionHeight = ApplyScale(BaseOptionHeight)
			local OptionPadding = ApplyScale(BasePaddingValue)

			local CalculatedListHeight = (OptionHeight + OptionPadding) * VisibleOptions - OptionPadding
			if CalculatedListHeight < OptionHeight then
				CalculatedListHeight = OptionHeight
			end

			local ExpandedHeight = ApplyScale(BaseElementHeight) + 
				ApplyScale(BaseElementHeight) + 
				ApplyScale(BasePaddingValue) + 
				CalculatedListHeight + 
				ApplyScale(BasePaddingValue * 2)

			local BaseTotalHeight = ApplyScale(BaseElementHeight)

			local DropdownFrame = Instance.new("Frame")
			DropdownFrame.Parent = Parent
			DropdownFrame.BackgroundColor3 = Astral.Theme.Main
			DropdownFrame.BackgroundTransparency = Astral.Config.Elements.BackgroundTransparency
			
			if MultiDropdownWidth then
				DropdownFrame.Size = UDim2.new(0, ApplyScale(MultiDropdownWidth), 0, BaseTotalHeight)
			else
				DropdownFrame.Size = UDim2.new(1, 0, 0, BaseTotalHeight)
			end
			
			DropdownFrame.ClipsDescendants = true
			local DropdownCorner = Instance.new("UICorner")
			DropdownCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Elements.CornerRadius))
			DropdownCorner.Parent = DropdownFrame

			local DropdownPadding = Instance.new("UIPadding")
			DropdownPadding.Parent = DropdownFrame
			DropdownPadding.PaddingBottom = UDim.new(0, ApplyScale(BasePaddingValue))

			local DropdownButton = Instance.new("TextButton")
			DropdownButton.Parent = DropdownFrame
			DropdownButton.BackgroundTransparency = 1
			DropdownButton.Size = UDim2.new(1, 0, 0, ApplyScale(BaseElementHeight))
			DropdownButton.Text = ""

			local DropdownLabel = Instance.new("TextLabel")
			DropdownLabel.Parent = DropdownButton
			DropdownLabel.Size = UDim2.new(1, 0, 1, 0)
			ApplyPadding(DropdownLabel, ApplyScale(BasePaddingValue))
			DropdownLabel.Font = MultiDropdownFont
			DropdownLabel.TextColor3 = Astral.Theme.Text
			DropdownLabel.TextSize = ApplyScale(MultiDropdownSize)
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
			ArrowImage.Position = UDim2.new(1, -ApplyScale(26), 0.5, -Astral.Config.Elements.Dropdown.ArrowSize / 2)
			ArrowImage.Size = UDim2.new(0, ApplyScale(Astral.Config.Elements.Dropdown.ArrowSize), 0, Astral.Config.Elements.Dropdown.ArrowSize)
			ArrowImage.Image = "rbxassetid://6031091004"
			ArrowImage.ImageColor3 = Astral.Theme.Accent

			local Header = Instance.new("Frame")
			Header.Parent = DropdownFrame
			Header.Position = UDim2.new(0, ApplyScale(BasePaddingValue), 0, ApplyScale(BaseElementHeight + BasePaddingValue))
			Header.Size = UDim2.new(1, -ApplyScale(BasePaddingValue * 2), 0, ApplyScale(BaseElementHeight))
			Header.BackgroundTransparency = 1
			Header.Visible = false

			local SearchBox = Instance.new("TextBox")
			SearchBox.Parent = Header
			SearchBox.Size = UDim2.new(1, -ApplyScale(100), 1, 0)
			SearchBox.BackgroundColor3 = Astral.Theme.Tertiary
			SearchBox.BackgroundTransparency = Astral.Config.Elements.BackgroundTransparency
			SearchBox.PlaceholderText = Astral.Config.Elements.MultiDropdown.SearchPlaceholder
			SearchBox.Text = ""
			SearchBox.TextColor3 = Astral.Theme.Text
			SearchBox.Font = Enum.Font.Gotham
			SearchBox.TextSize = Astral.Config.Elements.MultiDropdown.SearchTextSize
			local SearchBoxCorner = Instance.new("UICorner")
			SearchBoxCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Elements.Dropdown.InputCornerRadius))
			SearchBoxCorner.Parent = SearchBox

			local SearchStroke = Instance.new("UIStroke")
			SearchStroke.Parent = SearchBox
			SearchStroke.Color = Astral.Theme.Stroke
			SearchStroke.Thickness = ApplyScale(Astral.Config.Elements.Dropdown.StrokeThickness)
			SearchStroke.Transparency = Astral.Config.Elements.Dropdown.StrokeTransparency

			local SelectAllBtn = Instance.new("TextButton")
			SelectAllBtn.Parent = Header
			SelectAllBtn.Position = UDim2.new(1, -ApplyScale(95), 0, 0)
			SelectAllBtn.Size = UDim2.new(0, ApplyScale(45), 1, 0)
			SelectAllBtn.BackgroundColor3 = Astral.Theme.Success
			SelectAllBtn.BackgroundTransparency = Astral.Config.Elements.BackgroundTransparency
			SelectAllBtn.Text = Astral.Config.Elements.MultiDropdown.SelectAllButtonText
			SelectAllBtn.Font = Enum.Font.GothamBold
			SelectAllBtn.TextColor3 = Astral.Theme.Text
			SelectAllBtn.TextSize = Astral.Config.Elements.MultiDropdown.ButtonTextSize
			local SelectAllCorner = Instance.new("UICorner")
			SelectAllCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Elements.Dropdown.InputCornerRadius))
			SelectAllCorner.Parent = SelectAllBtn

			local ClearAllBtn = Instance.new("TextButton")
			ClearAllBtn.Parent = Header
			ClearAllBtn.Position = UDim2.new(1, -ApplyScale(45), 0, 0)
			ClearAllBtn.Size = UDim2.new(0, ApplyScale(45), 1, 0)
			ClearAllBtn.BackgroundColor3 = Astral.Theme.Error
			ClearAllBtn.BackgroundTransparency = Astral.Config.Elements.BackgroundTransparency
			ClearAllBtn.Text = Astral.Config.Elements.MultiDropdown.ClearButtonText
			ClearAllBtn.Font = Enum.Font.GothamBold
			ClearAllBtn.TextColor3 = Astral.Theme.Text
			ClearAllBtn.TextSize = Astral.Config.Elements.MultiDropdown.ButtonTextSize
			local ClearAllCorner = Instance.new("UICorner")
			ClearAllCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Elements.Dropdown.InputCornerRadius))
			ClearAllCorner.Parent = ClearAllBtn

			local DropdownList = Instance.new("ScrollingFrame")
			DropdownList.Parent = DropdownFrame
			DropdownList.BackgroundTransparency = 1
			DropdownList.Position = UDim2.new(0, ApplyScale(BasePaddingValue), 0, ApplyScale(BaseElementHeight * 2 + BasePaddingValue * 2))
			DropdownList.Size = UDim2.new(1, -ApplyScale(BasePaddingValue * 2), 0, CalculatedListHeight)
			DropdownList.ScrollBarThickness = 0
			DropdownList.ScrollBarImageTransparency = 1
			DropdownList.ScrollBarImageColor3 = Astral.Theme.Accent
			DropdownList.BorderSizePixel = 0
			DropdownList.VerticalScrollBarInset = Enum.ScrollBarInset.None
			DropdownList.HorizontalScrollBarInset = Enum.ScrollBarInset.None
			DropdownList.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
			DropdownList.Visible = false

			CreateScrollBar(DropdownList)

			local DropdownLayout = Instance.new("UIListLayout")
			DropdownLayout.Parent = DropdownList
			DropdownLayout.Padding = UDim.new(0, ApplyScale(BasePaddingValue))

			local function Refresh(Filter)
				for _, Child in pairs(DropdownList:GetChildren()) do
					if Child:IsA("TextButton") then Child:Destroy() end
				end
				for _, Option in pairs(DropdownOptions) do
					if Filter and Filter ~= "" and not string.find(string.lower(Option), string.lower(Filter)) then continue end

					local IsSelected = Selected[Option]
					local OptionButton = Instance.new("TextButton")
					OptionButton.Parent = DropdownList
					OptionButton.BackgroundColor3 = IsSelected and Astral.Theme.Accent or Astral.Theme.Tertiary
					OptionButton.BackgroundTransparency = IsSelected and 0.15 or Astral.Config.Elements.BackgroundTransparency
					OptionButton.Size = UDim2.new(1, 0, 0, Astral.Config.Elements.MultiDropdown.OptionHeight)
					OptionButton.Text = Option
					OptionButton.Font = IsSelected and Enum.Font.GothamBold or Enum.Font.Gotham
					OptionButton.TextColor3 = IsSelected and Astral.Theme.Text or Astral.Theme.TextDark
					OptionButton.TextSize = Astral.Config.Elements.MultiDropdown.OptionTextSize
					local OptionCorner = Instance.new("UICorner")
					OptionCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Elements.Dropdown.InputCornerRadius))
					OptionCorner.Parent = OptionButton

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
				DropdownList.CanvasSize = UDim2.new(0, 0, 0, DropdownLayout.AbsoluteContentSize.Y + ApplyScale(BasePaddingValue))
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

					ScrollToElement(PageFrame, DropdownFrame, ExpandedHeight)

					TweenService:Create(DropdownFrame, TweenInfo.new(Astral.Config.Animation.DropdownDuration), {
						Size = UDim2.new(1, 0, 0, ExpandedHeight)
					}):Play()
					TweenService:Create(ArrowImage, TweenInfo.new(Astral.Config.Animation.DropdownDuration), {
						Rotation = 180
					}):Play()
				else
					Header.Visible = false
					DropdownList.Visible = false

					TweenService:Create(DropdownFrame, TweenInfo.new(Astral.Config.Animation.DropdownDuration), {
						Size = UDim2.new(1, 0, 0, BaseTotalHeight)
					}):Play()
					TweenService:Create(ArrowImage, TweenInfo.new(Astral.Config.Animation.DropdownDuration), {
						Rotation = 0
					}):Play()
				end
			end)

			-- MultiDropdown update functions
			local MultiDropdownObject = {}
			function MultiDropdownObject:Update(NewOptions)
				if NewOptions.Name then
					DropdownName = NewOptions.Name
					UpdateLabel()
				end
				if NewOptions.Callback then
					Callback = NewOptions.Callback
				end
				if NewOptions.Options then
					DropdownOptions = NewOptions.Options
					-- Filter out selections that are no longer in options
					for i = #SelectionOrder, 1, -1 do
						local option = SelectionOrder[i]
						if not table.find(DropdownOptions, option) then
							Selected[option] = false
							table.remove(SelectionOrder, i)
						end
					end
					UpdateLabel()
					Refresh(SearchBox.Text)
				end
				if NewOptions.Default then
					Selected = {}
					SelectionOrder = {}
					for _, v in pairs(NewOptions.Default) do
						if #SelectionOrder < Max then
							Selected[v] = true
							table.insert(SelectionOrder, v)
						end
					end
					UpdateLabel()
					Refresh(SearchBox.Text)
					Callback(SelectionOrder)
				end
				if NewOptions.Max then
					Max = NewOptions.Max
					-- Remove excess selections if needed
					while #SelectionOrder > Max do
						local removed = table.remove(SelectionOrder, 1)
						Selected[removed] = false
					end
					UpdateLabel()
					Refresh(SearchBox.Text)
				end
				if NewOptions.Min then
					Min = NewOptions.Min
				end
				if NewOptions.VisibleOptions then
					VisibleOptions = NewOptions.VisibleOptions
					-- Recalculate heights
					CalculatedListHeight = (OptionHeight + OptionPadding) * VisibleOptions - OptionPadding
					if CalculatedListHeight < OptionHeight then
						CalculatedListHeight = OptionHeight
					end
					ExpandedHeight = ApplyScale(BaseElementHeight) + 
						ApplyScale(BaseElementHeight) + 
						ApplyScale(BasePaddingValue) + 
						CalculatedListHeight + 
						ApplyScale(BasePaddingValue * 2)
					
					DropdownList.Size = UDim2.new(1, -ApplyScale(BasePaddingValue * 2), 0, CalculatedListHeight)
				end
				if NewOptions.Font then
					DropdownLabel.Font = NewOptions.Font
				end
				if NewOptions.Size then
					DropdownLabel.TextSize = ApplyScale(NewOptions.Size)
				end
				if NewOptions.Height then
					BaseElementHeight = NewOptions.Height
					BaseTotalHeight = ApplyScale(BaseElementHeight)
					DropdownButton.Size = UDim2.new(1, 0, 0, BaseTotalHeight)
					DropdownFrame.Size = MultiDropdownWidth and 
						UDim2.new(0, ApplyScale(MultiDropdownWidth), 0, BaseTotalHeight) or
						UDim2.new(1, 0, 0, BaseTotalHeight)
				end
				if NewOptions.Width then
					MultiDropdownWidth = NewOptions.Width
					DropdownFrame.Size = UDim2.new(0, ApplyScale(MultiDropdownWidth), 0, BaseTotalHeight)
				end
			end
			
			function MultiDropdownObject:SetOptions(NewOptions)
				DropdownOptions = NewOptions
				-- Filter out selections that are no longer in options
				for i = #SelectionOrder, 1, -1 do
					local option = SelectionOrder[i]
					if not table.find(DropdownOptions, option) then
						Selected[option] = false
						table.remove(SelectionOrder, i)
					end
				end
				UpdateLabel()
				Refresh(SearchBox.Text)
			end
			
			function MultiDropdownObject:AddOption(Option)
				table.insert(DropdownOptions, Option)
				Refresh(SearchBox.Text)
			end
			
			function MultiDropdownObject:RemoveOption(Option)
				for i, v in ipairs(DropdownOptions) do
					if v == Option then
						table.remove(DropdownOptions, i)
						break
					end
				end
				if Selected[Option] then
					Selected[Option] = false
					for i, v in ipairs(SelectionOrder) do
						if v == Option then
							table.remove(SelectionOrder, i)
							break
						end
					end
					UpdateLabel()
					Callback(SelectionOrder)
				end
				Refresh(SearchBox.Text)
			end
			
			function MultiDropdownObject:SetSelected(Options)
				Selected = {}
				SelectionOrder = {}
				for _, v in pairs(Options) do
					if #SelectionOrder < Max then
						Selected[v] = true
						table.insert(SelectionOrder, v)
					end
				end
				UpdateLabel()
				Refresh(SearchBox.Text)
				Callback(SelectionOrder)
			end
			
			function MultiDropdownObject:GetSelected()
				return SelectionOrder
			end
			
			function MultiDropdownObject:GetOptions()
				return DropdownOptions
			end
			
			function MultiDropdownObject:AddSelection(Option)
				if not Selected[Option] and #SelectionOrder < Max then
					Selected[Option] = true
					table.insert(SelectionOrder, Option)
					UpdateLabel()
					Refresh(SearchBox.Text)
					Callback(SelectionOrder)
				end
			end
			
			function MultiDropdownObject:RemoveSelection(Option)
				if Selected[Option] and #SelectionOrder > Min then
					Selected[Option] = false
					for i, v in ipairs(SelectionOrder) do
						if v == Option then
							table.remove(SelectionOrder, i)
							break
						end
					end
					UpdateLabel()
					Refresh(SearchBox.Text)
					Callback(SelectionOrder)
				end
			end
			
			function MultiDropdownObject:ClearSelections()
				Selected = {}
				SelectionOrder = {}
				UpdateLabel()
				Refresh(SearchBox.Text)
				Callback(SelectionOrder)
			end
			
			function MultiDropdownObject:SetName(Text)
				DropdownName = Text
				UpdateLabel()
			end
			
			function MultiDropdownObject:SetCallback(NewCallback)
				Callback = NewCallback
			end

			return MultiDropdownObject
		end

		function TabFunctions:Keybind(Options, Parent)
			Parent = Parent or PageFrame
			local KeybindName = Options.Name or "Keybind"
			local Default = Options.Default or Enum.KeyCode.E
			local Callback = Options.Callback or function() end
			local Current = Default
			local KeybindFont = Options.Font or Astral.Config.Elements.LabelFont
			local KeybindSize = Options.Size or Astral.Config.Elements.LabelSize
			local KeybindHeight = Options.Height or Astral.Config.Elements.Height
			local KeybindWidth = Options.Width
			local KeybindAlignment = Options.Alignment or Astral.Config.Elements.LabelAlignment

			local KeybindFrame = Instance.new("Frame")
			KeybindFrame.Parent = Parent
			KeybindFrame.BackgroundColor3 = Astral.Theme.Main
			KeybindFrame.BackgroundTransparency = Astral.Config.Elements.BackgroundTransparency
			
			if KeybindWidth then
				KeybindFrame.Size = UDim2.new(0, ApplyScale(KeybindWidth), 0, ApplyScale(KeybindHeight))
			else
				KeybindFrame.Size = UDim2.new(1, 0, 0, ApplyScale(KeybindHeight))
			end

			local KeybindCorner = Instance.new("UICorner")
			KeybindCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Elements.CornerRadius))
			KeybindCorner.Parent = KeybindFrame

			local KeybindLabel = Instance.new("TextLabel")
			KeybindLabel.Parent = KeybindFrame
			KeybindLabel.BackgroundTransparency = 1
			KeybindLabel.Size = UDim2.new(1, 0, 1, 0)
			ApplyPadding(KeybindLabel, ApplyScale(BasePadding))
			KeybindLabel.Font = KeybindFont
			KeybindLabel.Text = KeybindName
			KeybindLabel.TextColor3 = Astral.Theme.Text
			KeybindLabel.TextSize = ApplyScale(KeybindSize)
			KeybindLabel.TextXAlignment = KeybindAlignment

			local KeybindButton = Instance.new("Frame")
			KeybindButton.Parent = KeybindFrame
			KeybindButton.BackgroundColor3 = Astral.Theme.Tertiary
			KeybindButton.BackgroundTransparency = Astral.Config.Elements.BackgroundTransparency
			KeybindButton.Position = UDim2.new(1, -ApplyScale(Astral.Config.Elements.Keybind.ButtonWidth + 12), 0.5, -ApplyScale(Astral.Config.Elements.Keybind.ButtonHeight / 2))
			KeybindButton.Size = UDim2.new(0, ApplyScale(Astral.Config.Elements.Keybind.ButtonWidth), 0, ApplyScale(Astral.Config.Elements.Keybind.ButtonHeight))

			local KeybindButtonCorner = Instance.new("UICorner")
			KeybindButtonCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Elements.Keybind.ButtonCornerRadius))
			KeybindButtonCorner.Parent = KeybindButton

			local KeybindStroke = Instance.new("UIStroke")
			KeybindStroke.Parent = KeybindButton
			KeybindStroke.Color = Astral.Theme.Stroke
			KeybindStroke.Thickness = ApplyScale(Astral.Config.Elements.Keybind.StrokeThickness)
			KeybindStroke.Transparency = Astral.Config.Elements.Keybind.StrokeTransparency

			local KeybindText = Instance.new("TextButton")
			KeybindText.Parent = KeybindButton
			KeybindText.BackgroundTransparency = 1
			KeybindText.Size = UDim2.new(1, 0, 1, 0)
			KeybindText.Font = Enum.Font.GothamBold
			KeybindText.Text = Current.Name
			KeybindText.TextColor3 = Astral.Theme.Accent
			KeybindText.TextSize = ApplyScale(Astral.Config.Elements.Keybind.ButtonTextSize)
			KeybindText.AutoButtonColor = false

			local Binding = false
			KeybindText.MouseButton1Click:Connect(function()
				Binding = true
				KeybindText.Text = "..."
				KeybindText.TextColor3 = Astral.Theme.Warning
			end)

			UserInputService.InputBegan:Connect(function(Input, GameProcessed)
				if not GameProcessed and Binding and Input.UserInputType == Enum.UserInputType.Keyboard then
					Current = Input.KeyCode
					KeybindText.Text = Current.Name
					KeybindText.TextColor3 = Astral.Theme.Accent
					Binding = false
					Callback(Current)
				elseif not GameProcessed and Input.KeyCode == Current then
					Callback(Current)
				end
			end)

			-- Keybind update functions
			local KeybindObject = {}
			function KeybindObject:Update(NewOptions)
				if NewOptions.Name then
					KeybindLabel.Text = NewOptions.Name
				end
				if NewOptions.Callback then
					Callback = NewOptions.Callback
				end
				if NewOptions.Default then
					Current = NewOptions.Default
					KeybindText.Text = Current.Name
					KeybindText.TextColor3 = Astral.Theme.Accent
				end
				if NewOptions.Font then
					KeybindLabel.Font = NewOptions.Font
				end
				if NewOptions.Size then
					KeybindLabel.TextSize = ApplyScale(NewOptions.Size)
				end
				if NewOptions.Height then
					local NewHeight = ApplyScale(NewOptions.Height)
					KeybindFrame.Size = KeybindWidth and 
						UDim2.new(0, ApplyScale(KeybindWidth), 0, NewHeight) or
						UDim2.new(1, 0, 0, NewHeight)
					-- Update button position
					KeybindButton.Position = UDim2.new(1, -ApplyScale(Astral.Config.Elements.Keybind.ButtonWidth + 12), 0.5, -ApplyScale(Astral.Config.Elements.Keybind.ButtonHeight / 2))
				end
				if NewOptions.Width then
					KeybindWidth = NewOptions.Width
					KeybindFrame.Size = UDim2.new(0, ApplyScale(KeybindWidth), 0, KeybindFrame.Size.Y.Offset)
					KeybindButton.Position = UDim2.new(1, -ApplyScale(Astral.Config.Elements.Keybind.ButtonWidth + 12), 0.5, -ApplyScale(Astral.Config.Elements.Keybind.ButtonHeight / 2))
				end
				if NewOptions.Alignment then
					KeybindLabel.TextXAlignment = NewOptions.Alignment
				end
			end
			
			function KeybindObject:SetKey(Key)
				Current = Key
				KeybindText.Text = Current.Name
				KeybindText.TextColor3 = Astral.Theme.Accent
			end
			
			function KeybindObject:GetKey()
				return Current
			end
			
			function KeybindObject:SetText(Text)
				KeybindLabel.Text = Text
			end
			
			function KeybindObject:SetCallback(NewCallback)
				Callback = NewCallback
			end

			return KeybindObject
		end

		function TabFunctions:Label(Options, Parent)
			Parent = Parent or PageFrame
			local LabelText = Options.Text or "Label"
			local LabelFont = Options.Font or Astral.Config.Elements.Label.Font
			local LabelSize = Options.Size or Astral.Config.Elements.Label.TextSize
			local LabelHeight = Options.Height or Astral.Config.Elements.Label.Height
			local LabelWidth = Options.Width
			local LabelAlignment = Options.Alignment or Enum.TextXAlignment.Left

			local LabelFrame = Instance.new("Frame")
			LabelFrame.Parent = Parent
			LabelFrame.BackgroundColor3 = Astral.Theme.Main
			LabelFrame.BackgroundTransparency = Astral.Config.Elements.BackgroundTransparency
			
			if LabelWidth then
				LabelFrame.Size = UDim2.new(0, ApplyScale(LabelWidth), 0, ApplyScale(LabelHeight))
			else
				LabelFrame.Size = UDim2.new(1, 0, 0, ApplyScale(LabelHeight))
			end

			local LabelCorner = Instance.new("UICorner")
			LabelCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Elements.CornerRadius))
			LabelCorner.Parent = LabelFrame

			local Label = Instance.new("TextLabel")
			Label.Parent = LabelFrame
			Label.BackgroundTransparency = 1
			Label.Size = UDim2.new(1, 0, 1, 0)
			ApplyPadding(Label, ApplyScale(BasePadding))
			Label.Font = LabelFont
			Label.Text = LabelText
			Label.TextColor3 = Astral.Theme.TextDark
			Label.TextSize = ApplyScale(LabelSize)
			Label.TextXAlignment = LabelAlignment
			Label.TextWrapped = true

			local LabelObject = {}
			function LabelObject:Update(NewOptions)
				if NewOptions.Text then
					Label.Text = NewOptions.Text
				end
				if NewOptions.Font then
					Label.Font = NewOptions.Font
				end
				if NewOptions.Size then
					Label.TextSize = ApplyScale(NewOptions.Size)
				end
				if NewOptions.Height then
					local NewHeight = ApplyScale(NewOptions.Height)
					LabelFrame.Size = LabelWidth and 
						UDim2.new(0, ApplyScale(LabelWidth), 0, NewHeight) or
						UDim2.new(1, 0, 0, NewHeight)
				end
				if NewOptions.Width then
					LabelWidth = NewOptions.Width
					LabelFrame.Size = UDim2.new(0, ApplyScale(LabelWidth), 0, LabelFrame.Size.Y.Offset)
				end
				if NewOptions.Alignment then
					Label.TextXAlignment = NewOptions.Alignment
				end
				if NewOptions.Color then
					Label.TextColor3 = NewOptions.Color
				end
			end
			
			function LabelObject:SetText(Text)
				Label.Text = Text
			end
			
			function LabelObject:SetFont(Font, Size, Color)
				if Font then Label.Font = Font end
				if Size then Label.TextSize = ApplyScale(Size) end
				if Color then Label.TextColor3 = Color end
			end
			
			function LabelObject:GetText()
				return Label.Text
			end

			return LabelObject
		end

		return TabFunctions
	end

	return WindowFunctions
end

return Astral
