local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local Astral = {}

Astral.Config = {
	Window = {
		Width = 720,
		Height = 520,
		Padding = 8,
		CornerRadius = 12,
		BackgroundTransparency = 0.15,
		StrokeThickness = 1.5,
		StrokeTransparency = 0.4
	},

	Topbar = {
		Height = 36,
		CornerRadius = 8,
		BackgroundTransparency = 0.2,
		TitleFont = Enum.Font.GothamBold,
		TitleSize = 14,
		TitleAlignment = Enum.TextXAlignment.Left
	},

	Controls = {
		ButtonSize = 26,
		ButtonCornerRadius = 6,
		CloseButton = {
			Text = "×",
			Size = 18
		},
		MinimizeButton = {
			Text = "−",
			Size = 16
		}
	},

	Bubble = {
		Size = 50,
		Icon = "rbxassetid://7733954760",
		StrokeThickness = 2,
		StrokeTransparency = 0.3,
		SnapMargin = 3,
		EdgeMargin = 1,
		TopBottomMargin = 1
	},

	Sidebar = {
		Width = 130,
		CornerRadius = 8,
		BackgroundTransparency = 0.2
	},

	Tab = {
		Height = 34,
		CornerRadius = 8,
		BackgroundTransparency = 0.25,
		IconSize = 16,
		Font = Enum.Font.GothamMedium,
		Size = 11,
		IndicatorWidth = 2,
		IndicatorHeight = 16,
		Padding = 8
	},

	Pages = {
		CornerRadius = 8,
		BackgroundTransparency = 0.5,
		Padding = 8
	},

	Elements = {
		Height = 34,
		CornerRadius = 6,
		BackgroundTransparency = 0.25,
		Font = Enum.Font.GothamMedium,
		Size = 12,
		Alignment = Enum.TextXAlignment.Left,

		Button = {
			HoverTransparency = 0.15,
			NormalTransparency = 0.25
		},

		Toggle = {
			Width = 38,
			Height = 18,
			CircleSize = 14
		},

		Slider = {
			Height = 50,
			LabelHeight = 16,
			InputWidth = 58,
			InputHeight = 24,
			InputSize = 11,
			TrackHeight = 6,
			BallSize = 12,
			InputFont = Enum.Font.GothamBold
		},

		TextBox = {
			Height = 50,
			LabelHeight = 20,
			InputHeight = 20,
			InputSize = 11,
			InputCornerRadius = 4,
			StrokeThickness = 1,
			StrokeTransparency = 0.5
		},

		Dropdown = {
			Height = 34,
			Size = 12,
			ArrowSize = 12,
			ListAreaHeight = 100,
			OptionHeight = 26,
			OptionSize = 11,
			SearchSize = 11,
			ButtonSize = 9,
			InputCornerRadius = 4,
			StrokeThickness = 1,
			StrokeTransparency = 0.5
		},

		MultiDropdown = {
			Height = 34,
			ListAreaHeight = 120,
			OptionHeight = 26,
			OptionSize = 11,
			SearchSize = 11,
			ButtonSize = 9
		},

		Keybind = {
			ButtonWidth = 58,
			ButtonHeight = 24,
			ButtonCornerRadius = 4,
			ButtonSize = 10,
			StrokeThickness = 1,
			StrokeTransparency = 0.5
		},

		Label = {
			Height = 30,
			Size = 11,
			Font = Enum.Font.Gotham
		},

		Section = {
			CornerRadius = 8,
			BackgroundTransparency = 0.25,
			HeaderHeight = 34,
			HeaderBackgroundTransparency = 0.2,
			TitleSize = 13,
			TitleFont = Enum.Font.GothamBold
		}
	},

	Notification = {
		Width = 300,
		Height = 70,
		CornerRadius = 8,
		BackgroundTransparency = 0.15,
		StrokeThickness = 1.5,
		TitleSize = 13,
		ContentSize = 11,
		TitleFont = Enum.Font.GothamBold,
		ContentFont = Enum.Font.Gotham,
		MaxNotifications = 5,
		DefaultDuration = 3
	},

	ScrollBar = {
		Thickness = 4,
		Transparency = 0.3,
		AutoHideDelay = 0.5
	},

	Animation = {
		HoverDuration = 0.15,
		ClickDuration = 0.08,
		RestoreDuration = 0.15,
		TweenDuration = 0.2,
		DropdownDuration = 0.2,
		NotificationDuration = 0.3,
		WindowCloseDuration = 0.25,
		CenterElementDuration = 0.3,
		EasingStyle = Enum.EasingStyle.Quart,
		EasingDirection = Enum.EasingDirection.Out
	}
}

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
	Info = Color3.fromRGB(88, 139, 255),
}

Astral.UIObjects = {
	Windows = {},
	Elements = {},
	ScrollBars = {}
}

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

function Astral:GetElementColor(ColorType)
	local ColorMap = {
		WindowBackground = self.Theme.Main,
		WindowStroke = self.Theme.Stroke,
		TopbarBackground = self.Theme.Main,
		SidebarBackground = self.Theme.Main,
		PagesBackground = self.Theme.Secondary,

		SectionBackground = self.Theme.Tertiary,
		SectionHeaderBackground = self.Theme.Main,
		SectionTitle = self.Theme.Text,

		ElementBackground = self.Theme.Main,
		ElementSecondary = self.Theme.Secondary,
		ElementTertiary = self.Theme.Tertiary,

		ButtonBackground = self.Theme.Main,
		ButtonHover = self.Theme.HoverBright,
		ButtonText = self.Theme.Text,

		ToggleOn = self.Theme.Accent,
		ToggleOff = self.Theme.Tertiary,
		ToggleCircle = self.Theme.Text,
		ToggleBackground = self.Theme.Main,

		SliderTrack = self.Theme.Tertiary,
		SliderFill = self.Theme.Accent,
		SliderBall = self.Theme.Text,
		SliderInputBackground = self.Theme.Tertiary,
		SliderInputText = self.Theme.Accent,
		SliderLabel = self.Theme.Text,
		SliderInputBorder = self.Theme.Stroke,

		TextBoxBackground = self.Theme.Tertiary,
		TextBoxText = self.Theme.Text,
		TextBoxPlaceholder = self.Theme.TextDarker,
		TextBoxBorder = self.Theme.Stroke,
		TextBoxLabel = self.Theme.Text,

		DropdownBackground = self.Theme.Tertiary,
		DropdownSelected = self.Theme.Accent,
		DropdownOptionText = self.Theme.TextDark,
		DropdownOptionSelectedText = self.Theme.Text,
		DropdownOptionBackground = self.Theme.Tertiary,
		DropdownOptionSelectedBackground = self.Theme.Accent,
		DropdownSearchBackground = self.Theme.Tertiary,
		DropdownSearchText = self.Theme.Text,
		DropdownSearchPlaceholder = self.Theme.TextDarker,
		DropdownSearchBorder = self.Theme.Stroke,
		DropdownArrow = self.Theme.Accent,
		DropdownClearButton = self.Theme.Error,
		DropdownClearButtonText = self.Theme.Text,
		DropdownSelectAllButton = self.Theme.Success,
		DropdownSelectAllButtonText = self.Theme.Text,
		DropdownLabel = self.Theme.Text,

		KeybindButton = self.Theme.Tertiary,
		KeybindText = self.Theme.Accent,
		KeybindLabel = self.Theme.Text,
		KeybindBorder = self.Theme.Stroke,

		ScrollBar = self.Theme.Accent,
		TabIndicator = self.Theme.Accent,
		BubbleBackground = self.Theme.Main,
		BubbleIcon = self.Theme.Accent,

		LabelText = self.Theme.TextDark,
		LabelBackground = self.Theme.Main,
		TitleText = self.Theme.Text,

		ElementStroke = self.Theme.Stroke,
		DarkStroke = self.Theme.StrokeDark,

		NotificationInfo = self.Theme.Info,
		NotificationSuccess = self.Theme.Success,
		NotificationWarning = self.Theme.Warning,
		NotificationError = self.Theme.Error,
		NotificationBackground = self.Theme.Main,
		NotificationTitle = self.Theme.Text,
		NotificationContent = self.Theme.TextDark,

		ControlButtonBackground = self.Theme.Main,
		ControlButtonText = self.Theme.Text,
		ControlButtonHover = self.Theme.HoverBright,

		TabBackground = self.Theme.Main,
		TabText = self.Theme.TextDark,
		TabSelectedText = self.Theme.Text,
		TabIcon = self.Theme.TextDark,
		TabSelectedIcon = self.Theme.Accent,
		TabHover = self.Theme.Tertiary,

		LabelScrollBar = self.Theme.Accent,
	}

	return ColorMap[ColorType] or self.Theme.Main
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

-- Updated hover effect function to use GetElementColor dynamically
local function AddHoverEffect(Object, HoverColorType, NormalColorType, HoverTransparency, NormalTransparency)
	Object.MouseEnter:Connect(function()
		local HoverColor = Astral:GetElementColor(HoverColorType)
		local Properties = {BackgroundColor3 = HoverColor}
		if HoverTransparency then
			Properties.BackgroundTransparency = HoverTransparency
		end
		TweenService:Create(Object, TweenInfo.new(Astral.Config.Animation.HoverDuration), Properties):Play()
	end)

	Object.MouseLeave:Connect(function()
		local NormalColor = Astral:GetElementColor(NormalColorType)
		local Properties = {BackgroundColor3 = NormalColor}
		if NormalTransparency then
			Properties.BackgroundTransparency = NormalTransparency
		end
		TweenService:Create(Object, TweenInfo.new(Astral.Config.Animation.HoverDuration), Properties):Play()
	end)
end

-- New function for tab hover effects that dynamically gets colors
local function AddTabHoverEffect(TabButton, IsActive)
	TabButton.MouseEnter:Connect(function()
		if not IsActive then
			TweenService:Create(TabButton, TweenInfo.new(Astral.Config.Animation.HoverDuration), {
				BackgroundColor3 = Astral:GetElementColor("TabHover"),
				BackgroundTransparency = 0.25
			}):Play()
		end
	end)

	TabButton.MouseLeave:Connect(function()
		if not IsActive then
			TweenService:Create(TabButton, TweenInfo.new(Astral.Config.Animation.HoverDuration), {
				BackgroundColor3 = Astral:GetElementColor("TabBackground"),
				BackgroundTransparency = Astral.Config.Tab.BackgroundTransparency
			}):Play()
		end
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

local function CreateScrollBar(ScrollingFrame, WindowId)
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

	table.insert(Astral.UIObjects.ScrollBars, {
		Frame = ScrollingFrame,
		WindowId = WindowId
	})
end

function Astral:SetTheme(NewTheme)
	for Key, Value in pairs(NewTheme) do
		if self.Theme[Key] ~= nil then
			self.Theme[Key] = Value
		end
	end

	self:ApplyThemeToAll()
end

function Astral:ApplyThemeToAll()
	for _, WindowData in pairs(Astral.UIObjects.Windows) do
		if WindowData.Window and WindowData.Window.MainFrame then
			self:ApplyThemeToWindow(WindowData.Window)

			if WindowData.Window.Functions and WindowData.Window.Functions.UpdateTabVisuals then
				WindowData.Window.Functions:UpdateTabVisuals()
			end
		end
	end

	for _, Element in pairs(Astral.UIObjects.Elements) do
		if Element.UpdateTheme then
			Element:UpdateTheme()
		end
	end

	for _, ScrollbarData in pairs(Astral.UIObjects.ScrollBars) do
		if ScrollbarData.Frame and ScrollbarData.Frame.Parent then
			ScrollbarData.Frame.ScrollBarImageColor3 = Astral:GetElementColor("ScrollBar")
		end
	end
end

function Astral:ApplyThemeToWindow(Window)
	local MainFrame = Window.MainFrame
	local ScreenGui = Window.ScreenGui

	if not MainFrame then return end

	-- Update main window
	MainFrame.BackgroundColor3 = Astral:GetElementColor("WindowBackground")
	if MainFrame.UIStroke then
		MainFrame.UIStroke.Color = Astral:GetElementColor("WindowStroke")
	end

	-- Update topbar
	local TopbarFrame = MainFrame:FindFirstChild("Topbar")
	if TopbarFrame then
		TopbarFrame.BackgroundColor3 = Astral:GetElementColor("TopbarBackground")

		local TitleLabel = TopbarFrame:FindFirstChildOfClass("TextLabel")
		if TitleLabel then
			TitleLabel.TextColor3 = Astral:GetElementColor("TitleText")
		end
	end

	-- Update control buttons
	for _, child in pairs(MainFrame:GetDescendants()) do
		if child:IsA("TextButton") then
			if child.Text == self.Config.Controls.CloseButton.Text then
				child.BackgroundColor3 = Astral:GetElementColor("ControlButtonBackground")
				child.TextColor3 = Astral:GetElementColor("ControlButtonText")
			elseif child.Text == self.Config.Controls.MinimizeButton.Text then
				child.BackgroundColor3 = Astral:GetElementColor("ControlButtonBackground")
				child.TextColor3 = Astral:GetElementColor("ControlButtonText")
			end
		end
	end

	local ContentFrame = MainFrame:FindFirstChildOfClass("Frame")
	if ContentFrame then
		-- Update sidebar
		local SidebarFrame = ContentFrame:FindFirstChildOfClass("Frame")
		if SidebarFrame then
			SidebarFrame.BackgroundColor3 = Astral:GetElementColor("SidebarBackground")
			-- Sidebar stroke removed

			local TabContainer = SidebarFrame:FindFirstChildOfClass("ScrollingFrame")
			if TabContainer then
				TabContainer.ScrollBarImageColor3 = Astral:GetElementColor("ScrollBar")

				if Window.Functions and Window.Functions.UpdateTabVisuals then
					Window.Functions:UpdateTabVisuals()
				end
			end
		end

		-- Update pages frame
		for _, child in pairs(ContentFrame:GetChildren()) do
			if child:IsA("Frame") then
				if child.Name ~= "Topbar" then
					local isSidebar = child:FindFirstChildOfClass("ScrollingFrame") ~= nil
					if not isSidebar then
						child.BackgroundColor3 = Astral:GetElementColor("PagesBackground")
					end
				end
			end
		end
	end

	if ScreenGui then
		local Bubble = ScreenGui:FindFirstChild("AstralBubble")
		if Bubble then
			Bubble.BackgroundColor3 = Astral:GetElementColor("BubbleBackground")
			if Bubble.UIStroke then
				Bubble.UIStroke.Color = Astral:GetElementColor("WindowStroke")
			end
			local BubbleIcon = Bubble:FindFirstChildOfClass("ImageLabel")
			if BubbleIcon then
				BubbleIcon.ImageColor3 = Astral:GetElementColor("BubbleIcon")
			end
		end
	end

	-- Apply theme to all elements within the window
	self:ApplyThemeToWindowElements(Window)
end

function Astral:ApplyThemeToWindowElements(Window)
	if not Window or not Window.MainFrame then return end

	local MainFrame = Window.MainFrame

	-- Recursively apply theme to all UI elements
	local function ApplyThemeRecursive(Parent)
		for _, child in pairs(Parent:GetDescendants()) do
			if child:IsA("Frame") or child:IsA("TextButton") then
				-- Apply background colors based on element type
				if child.Name:find("Section") and not child.Name:find("Header") then
					child.BackgroundColor3 = Astral:GetElementColor("SectionBackground")
				elseif child.Name:find("Header") then
					child.BackgroundColor3 = Astral:GetElementColor("SectionHeaderBackground")
				elseif child.Name == "CheckButton" or child.Name:find("Toggle") then
					-- Skip toggle buttons as they handle their own state
				elseif child.Name:find("Button") and child:IsA("TextButton") then
					-- Check if it's a control button
					if child.Text == self.Config.Controls.CloseButton.Text or 
						child.Text == self.Config.Controls.MinimizeButton.Text then
						child.BackgroundColor3 = Astral:GetElementColor("ControlButtonBackground")
						child.TextColor3 = Astral:GetElementColor("ControlButtonText")
					end
				else
					-- Check if this is an element frame
					local isElement = false
					for _, element in pairs(Astral.UIObjects.Elements) do
						if element.Frame == child then
							isElement = true
							break
						end
					end

					if not isElement then
						-- Apply default background color
						if child.BackgroundTransparency < 1 then
							child.BackgroundColor3 = Astral:GetElementColor("ElementBackground")
						end
					end
				end
			end

			-- Apply text colors
			if child:IsA("TextLabel") or child:IsA("TextBox") then
				if child.Name:find("SectionLabel") or child.Name:find("Section") then
					child.TextColor3 = Astral:GetElementColor("SectionTitle")
				elseif child.Name:find("Label") or child.Name:find("Content") then
					child.TextColor3 = Astral:GetElementColor("LabelText")
				elseif child.Name:find("Title") or child.Name:find("Text") then
					child.TextColor3 = Astral:GetElementColor("TitleText")
				else
					-- Default text color
					child.TextColor3 = Astral:GetElementColor("ButtonText")
				end
			end

			-- Apply stroke colors
			if child:IsA("UIStroke") then
				if child.Parent.Name == "MainFrame" then
					child.Color = Astral:GetElementColor("WindowStroke")
				else
					child.Color = Astral:GetElementColor("ElementStroke")
				end
			end
		end
	end

	ApplyThemeRecursive(MainFrame)
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

function Astral:Window(Options)
	local Name = Options.Name or "Astral"
	local Scale = Options.Scale or 1
	local WindowId = #Astral.UIObjects.Windows + 1

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

	local BaseWidth = Astral.Config.Window.Width
	local BaseHeight = Astral.Config.Window.Height
	local BasePadding = Astral.Config.Window.Padding
	local ElementHeight = Astral.Config.Elements.Height
	local TopbarHeight = Astral.Config.Topbar.Height
	local ButtonSize = Astral.Config.Controls.ButtonSize

	local CurrentWidth = ApplyScale(BaseWidth)
	local CurrentHeight = ApplyScale(BaseHeight)

	local MainFrame = Instance.new("Frame")
	MainFrame.Parent = ScreenGui
	MainFrame.BackgroundColor3 = Astral:GetElementColor("WindowBackground")
	MainFrame.BackgroundTransparency = Astral.Config.Window.BackgroundTransparency
	MainFrame.Position = UDim2.new(0.5, -CurrentWidth / 2, 0.5, -CurrentHeight / 2)
	MainFrame.Size = UDim2.new(0, CurrentWidth, 0, CurrentHeight)
	MainFrame.ClipsDescendants = true
	MainFrame.Active = true

	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Window.CornerRadius))
	MainCorner.Parent = MainFrame

	local MainStroke = Instance.new("UIStroke")
	MainStroke.Color = Astral:GetElementColor("WindowStroke")
	MainStroke.Thickness = ApplyScale(Astral.Config.Window.StrokeThickness)
	MainStroke.Transparency = Astral.Config.Window.StrokeTransparency
	MainStroke.Parent = MainFrame

	local TopbarFrame = Instance.new("Frame")
	TopbarFrame.Name = "Topbar"
	TopbarFrame.Parent = MainFrame
	TopbarFrame.BackgroundColor3 = Astral:GetElementColor("TopbarBackground")
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
	TitleLabel.TextColor3 = Astral:GetElementColor("TitleText")
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
	CloseButton.BackgroundColor3 = Astral:GetElementColor("ControlButtonBackground")
	CloseButton.BackgroundTransparency = Astral.Config.Topbar.BackgroundTransparency
	CloseButton.Size = UDim2.new(0, ApplyScale(ButtonSize), 0, ApplyScale(TopbarHeight))
	CloseButton.Position = UDim2.new(1, -ApplyScale(ButtonSize + BasePadding), 0, 0)
	CloseButton.AutoButtonColor = false
	CloseButton.Font = Enum.Font.GothamBold
	CloseButton.Text = Astral.Config.Controls.CloseButton.Text
	CloseButton.TextColor3 = Astral:GetElementColor("ControlButtonText")
	CloseButton.TextSize = ApplyScale(Astral.Config.Controls.CloseButton.Size)
	CloseButton.TextYAlignment = Enum.TextYAlignment.Center
	CloseButton.ZIndex = 11

	local CloseCorner = Instance.new("UICorner")
	CloseCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Controls.ButtonCornerRadius))
	CloseCorner.Parent = CloseButton

	AddHoverEffect(
		CloseButton,
		"ControlButtonHover",
		"ControlButtonBackground",
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

		for i, WindowData in ipairs(Astral.UIObjects.Windows) do
			if WindowData.Window.MainFrame == MainFrame then
				table.remove(Astral.UIObjects.Windows, i)
				break
			end
		end
	end)

	local MinimizeButton = Instance.new("TextButton")
	MinimizeButton.Parent = ControlsFrame
	MinimizeButton.BackgroundColor3 = Astral:GetElementColor("ControlButtonBackground")
	MinimizeButton.BackgroundTransparency = Astral.Config.Topbar.BackgroundTransparency
	MinimizeButton.Size = UDim2.new(0, ApplyScale(ButtonSize), 0, ApplyScale(TopbarHeight))
	MinimizeButton.Position = UDim2.new(1, -ApplyScale(ButtonSize * 2 + BasePadding * 1.5), 0, 0)
	MinimizeButton.AutoButtonColor = false
	MinimizeButton.Font = Enum.Font.GothamBold
	MinimizeButton.Text = Astral.Config.Controls.MinimizeButton.Text
	MinimizeButton.TextColor3 = Astral:GetElementColor("ControlButtonText")
	MinimizeButton.TextSize = ApplyScale(Astral.Config.Controls.MinimizeButton.Size)
	MinimizeButton.TextYAlignment = Enum.TextYAlignment.Center
	MinimizeButton.ZIndex = 11

	local MinimizeCorner = Instance.new("UICorner")
	MinimizeCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Controls.ButtonCornerRadius))
	MinimizeCorner.Parent = MinimizeButton

	AddHoverEffect(
		MinimizeButton,
		"ControlButtonHover",
		"ControlButtonBackground",
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
	Bubble.BackgroundColor3 = Astral:GetElementColor("BubbleBackground")
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
	BubbleIcon.ImageColor3 = Astral:GetElementColor("BubbleIcon")
	BubbleIcon.ScaleType = Enum.ScaleType.Fit

	local BubbleStroke = Instance.new("UIStroke")
	BubbleStroke.Thickness = Astral.Config.Bubble.StrokeThickness
	BubbleStroke.Color = Astral:GetElementColor("WindowStroke")
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
	SidebarFrame.BackgroundColor3 = Astral:GetElementColor("SidebarBackground")
	SidebarFrame.BackgroundTransparency = Astral.Config.Sidebar.BackgroundTransparency
	SidebarFrame.Position = UDim2.new(0, ApplyScale(BasePadding), 0, 0)
	SidebarFrame.Size = UDim2.new(0, ApplyScale(Astral.Config.Sidebar.Width), 1, -ApplyScale(BasePadding))
	local SidebarCorner = Instance.new("UICorner")
	SidebarCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Sidebar.CornerRadius))
	SidebarCorner.Parent = SidebarFrame

	local TabContainer = Instance.new("ScrollingFrame")
	TabContainer.Parent = SidebarFrame
	TabContainer.BackgroundTransparency = 1
	TabContainer.Position = UDim2.new(0, ApplyScale(BasePadding), 0, ApplyScale(BasePadding))
	TabContainer.Size = UDim2.new(1, -ApplyScale(BasePadding * 2), 1, -ApplyScale(BasePadding * 2))
	TabContainer.ScrollBarThickness = 0
	TabContainer.ScrollBarImageTransparency = 1
	TabContainer.ScrollBarImageColor3 = Astral:GetElementColor("ScrollBar")
	TabContainer.BorderSizePixel = 0
	TabContainer.VerticalScrollBarInset = Enum.ScrollBarInset.None
	TabContainer.HorizontalScrollBarInset = Enum.ScrollBarInset.None
	TabContainer.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
	TabContainer.ScrollingEnabled = true

	CreateScrollBar(TabContainer, WindowId)

	local TabLayout = Instance.new("UIListLayout")
	TabLayout.Parent = TabContainer
	TabLayout.Padding = UDim.new(0, ApplyScale(Astral.Config.Tab.Padding))
	TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + ApplyScale(Astral.Config.Tab.Padding))
	end)

	local PagesFrame = Instance.new("Frame")
	PagesFrame.Parent = ContentFrame
	PagesFrame.BackgroundColor3 = Astral:GetElementColor("PagesBackground")
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
	local ActiveTabName = nil

	local function UpdateTabVisuals()
		for _, TabData in pairs(AllTabs) do
			local Tab = TabData.Button
			local IsActive = (Tab == ActiveTab)

			if TabData.Icon then
				TabData.Icon.ImageColor3 = IsActive and Astral:GetElementColor("TabSelectedIcon") or Astral:GetElementColor("TabIcon")
			end

			if TabData.Label then
				TabData.Label.TextColor3 = IsActive and Astral:GetElementColor("TabSelectedText") or Astral:GetElementColor("TabText")
			end

			local Indicator = Tab:FindFirstChild("Indicator")
			if Indicator then
				Indicator.Visible = IsActive
				Indicator.BackgroundColor3 = Astral:GetElementColor("TabIndicator")
			end

			Tab.BackgroundColor3 = Astral:GetElementColor("TabBackground")
			Tab.BackgroundTransparency = IsActive and 0 or Astral.Config.Tab.BackgroundTransparency

			-- Update tab hover effect when theme changes
			Tab.MouseEnter:Connect(function()
				if not IsActive then
					TweenService:Create(Tab, TweenInfo.new(Astral.Config.Animation.HoverDuration), {
						BackgroundColor3 = Astral:GetElementColor("TabHover"),
						BackgroundTransparency = 0.25
					}):Play()
				end
			end)

			Tab.MouseLeave:Connect(function()
				if not IsActive then
					TweenService:Create(Tab, TweenInfo.new(Astral.Config.Animation.HoverDuration), {
						BackgroundColor3 = Astral:GetElementColor("TabBackground"),
						BackgroundTransparency = Astral.Config.Tab.BackgroundTransparency
					}):Play()
				end
			end)
		end
	end

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
		local Duration = tonumber(Options.Duration) or tonumber(Astral.Config.Notification.DefaultDuration) or 3
		local Type = Options.Type or "Info"

		local NotificationColor
		if Type == "Info" then
			NotificationColor = Astral:GetElementColor("NotificationInfo")
		elseif Type == "Success" then
			NotificationColor = Astral:GetElementColor("NotificationSuccess")
		elseif Type == "Warning" then
			NotificationColor = Astral:GetElementColor("NotificationWarning")
		elseif Type == "Error" then
			NotificationColor = Astral:GetElementColor("NotificationError")
		else
			NotificationColor = Astral:GetElementColor("NotificationInfo")
		end

		if #ActiveNotifications >= MaxNotifications then
			local ToRemove = #ActiveNotifications - MaxNotifications + 1

			for i = 1, ToRemove do
				if ActiveNotifications[1] then
					local Notif = ActiveNotifications[1]
					table.remove(ActiveNotifications, 1)
					Notif:Destroy()
				end
			end
			UpdateNotificationPositions()
		end

		local BaseHeight = ApplyScale(Astral.Config.Notification.Height)
		local MaxNotificationWidth = ApplyScale(Astral.Config.Notification.Width) - ApplyScale(BasePadding * 4)

		local function CalculateTextHeight(Text, Font, TextSize, MaxWidth)
			local TextService = game:GetService("TextService")
			local TextBounds = TextService:GetTextSize(
				Text,
				TextSize,
				Font,
				Vector2.new(MaxWidth, 10000)
			)
			return TextBounds.Y
		end

		local TitleHeight = ApplyScale(18)
		local TitleTextSize = ApplyScale(Astral.Config.Notification.TitleSize)
		local ContentTextSize = ApplyScale(Astral.Config.Notification.ContentSize)

		local ContentLines = string.split(Content, "\n")
		local MaxContentHeight = ApplyScale(100)
		local MinContentHeight = ApplyScale(20)

		local CalculatedContentHeight = CalculateTextHeight(Content, Astral.Config.Notification.ContentFont, ContentTextSize, MaxNotificationWidth)
		CalculatedContentHeight = math.min(math.max(CalculatedContentHeight, MinContentHeight), MaxContentHeight)

		local TotalHeight = TitleHeight + CalculatedContentHeight + ApplyScale(BasePadding * 3)
		TotalHeight = math.max(BaseHeight, TotalHeight)

		local NotificationFrame = Instance.new("Frame")
		NotificationFrame.Parent = ScreenGui
		NotificationFrame.BackgroundColor3 = Astral:GetElementColor("NotificationBackground")
		NotificationFrame.BackgroundTransparency = Astral.Config.Notification.BackgroundTransparency
		NotificationFrame.Size = UDim2.new(0, ApplyScale(Astral.Config.Notification.Width), 0, TotalHeight)
		NotificationFrame.AnchorPoint = Vector2.new(1, 1)
		NotificationFrame.Position = UDim2.new(1.5, 0, 1, -ApplyScale(20))
		NotificationFrame.ZIndex = 100

		local NotificationCorner = Instance.new("UICorner")
		NotificationCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Notification.CornerRadius))
		NotificationCorner.Parent = NotificationFrame

		local NotificationStroke = Instance.new("UIStroke")
		NotificationStroke.Color = NotificationColor
		NotificationStroke.Thickness = ApplyScale(Astral.Config.Notification.StrokeThickness)
		NotificationStroke.Parent = NotificationFrame

		local NotificationTitle = Instance.new("TextLabel")
		NotificationTitle.Parent = NotificationFrame
		NotificationTitle.BackgroundTransparency = 1
		NotificationTitle.Size = UDim2.new(1, 0, 0, TitleHeight)
		ApplyPadding(NotificationTitle, ApplyScale(BasePadding))
		NotificationTitle.Font = Astral.Config.Notification.TitleFont
		NotificationTitle.Text = Title
		NotificationTitle.TextColor3 = Astral:GetElementColor("NotificationTitle")
		NotificationTitle.TextSize = TitleTextSize
		NotificationTitle.TextXAlignment = Enum.TextXAlignment.Left
		NotificationTitle.TextTruncate = Enum.TextTruncate.AtEnd

		local NotificationContent = Instance.new("TextLabel")
		NotificationContent.Parent = NotificationFrame
		NotificationContent.BackgroundTransparency = 1
		NotificationContent.Position = UDim2.new(0, 0, 0, TitleHeight + ApplyScale(BasePadding))
		NotificationContent.Size = UDim2.new(1, -ApplyScale(BasePadding * 2), 0, CalculatedContentHeight)
		NotificationContent.Position = UDim2.new(0.5, 0, 0, TitleHeight + ApplyScale(BasePadding))
		NotificationContent.AnchorPoint = Vector2.new(0.5, 0)
		NotificationContent.Font = Astral.Config.Notification.ContentFont
		NotificationContent.Text = Content
		NotificationContent.TextColor3 = Astral:GetElementColor("NotificationContent")
		NotificationContent.TextSize = ContentTextSize
		NotificationContent.TextXAlignment = Enum.TextXAlignment.Left
		NotificationContent.TextYAlignment = Enum.TextYAlignment.Top
		NotificationContent.TextWrapped = true
		NotificationContent.TextTruncate = Enum.TextTruncate.None

		local ClickOverlay = Instance.new("TextButton")
		ClickOverlay.Parent = NotificationFrame
		ClickOverlay.BackgroundTransparency = 1
		ClickOverlay.Size = UDim2.new(1, 0, 1, 0)
		ClickOverlay.Text = ""
		ClickOverlay.AutoButtonColor = false
		ClickOverlay.ZIndex = 101

		table.insert(ActiveNotifications, NotificationFrame)
		UpdateNotificationPositions()

		local NotificationSpacing = ApplyScale(80)
		TweenService:Create(NotificationFrame, TweenInfo.new(
			Astral.Config.Animation.NotificationDuration,
			Astral.Config.Animation.EasingStyle,
			Astral.Config.Animation.EasingDirection
			), {
				Position = UDim2.new(1, -ApplyScale(20), 1, -ApplyScale(20) - ((#ActiveNotifications - 1) * NotificationSpacing))
			}):Play()

		local NotificationData = {
			Frame = NotificationFrame,
			Active = true,
			StartTime = os.clock(),
			Duration = Duration
		}

		local function DestroyNotification(Immediate)
			NotificationData.Active = false

			for i, v in ipairs(ActiveNotifications) do
				if v == NotificationFrame then
					table.remove(ActiveNotifications, i)
					break
				end
			end

			if Immediate then
				NotificationFrame:Destroy()
				UpdateNotificationPositions()

				if #NotificationQueue > 0 then
					local Next = table.remove(NotificationQueue, 1)
					WindowFunctions:Notify(Next)
				end
			else
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
					UpdateNotificationPositions()

					if #NotificationQueue > 0 then
						local Next = table.remove(NotificationQueue, 1)
						WindowFunctions:Notify(Next)
					end
				end)
			end
		end

		ClickOverlay.MouseButton1Click:Connect(function()
			DestroyNotification(false)
		end)

		task.spawn(function()
			while NotificationData.Active do
				local elapsed = os.clock() - NotificationData.StartTime
				if elapsed >= NotificationData.Duration then
					DestroyNotification(false)
					break
				end
				task.wait(0.1)
			end
		end)

		return {
			Destroy = function(Immediate)
				if NotificationData.Active then
					DestroyNotification(Immediate == true)
				end
			end,
			Extend = function(AdditionalSeconds)
				local seconds = tonumber(AdditionalSeconds) or 0
				NotificationData.Duration = NotificationData.Duration + seconds
			end,
			GetTimeRemaining = function()
				if NotificationData.Active then
					return math.max(0, NotificationData.Duration - (os.clock() - NotificationData.StartTime))
				end
				return 0
			end
		}
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

		for i, WindowData in ipairs(Astral.UIObjects.Windows) do
			if WindowData.Window.MainFrame == MainFrame then
				table.remove(Astral.UIObjects.Windows, i)
				break
			end
		end
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

	function WindowFunctions:UpdateTabVisuals()
		UpdateTabVisuals()
	end

	function WindowFunctions:GetActiveTab()
		return ActiveTabName
	end

	function WindowFunctions:SetActiveTab(TabName)
		for _, TabData in pairs(AllTabs) do
			if TabData.Name == TabName then
				local function ActivateTab()
					for _, Page in pairs(PagesContainer:GetChildren()) do
						if Page:IsA("ScrollingFrame") then
							Page.Visible = false
						end
					end

					ActiveTab = TabData.Button
					ActiveTabName = TabName

					TabData.Page.Visible = true

					UpdateTabVisuals()
				end

				ActivateTab()
				return true
			end
		end
		return false
	end

	function WindowFunctions:Tab(Options)
		local TabName = Options.Name or "Tab"
		local TabIcon = Options.Icon or "rbxassetid://7733954760"

		local TabButton = Instance.new("TextButton")
		TabButton.Parent = TabContainer
		TabButton.BackgroundColor3 = Astral:GetElementColor("TabBackground")
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
		IconImage.ImageColor3 = Astral:GetElementColor("TabIcon")

		local LabelText = Instance.new("TextLabel")
		LabelText.Parent = TabButton
		LabelText.BackgroundTransparency = 1
		LabelText.Position = UDim2.new(0, ApplyScale(30), 0, 0)
		LabelText.Size = UDim2.new(1, -ApplyScale(35), 1, 0)
		LabelText.Font = Astral.Config.Tab.Font
		LabelText.Text = TabName
		LabelText.TextColor3 = Astral:GetElementColor("TabText")
		LabelText.TextSize = ApplyScale(Astral.Config.Tab.Size)
		LabelText.TextXAlignment = Enum.TextXAlignment.Left

		local IndicatorFrame = Instance.new("Frame")
		IndicatorFrame.Name = "Indicator"
		IndicatorFrame.Parent = TabButton
		IndicatorFrame.BackgroundColor3 = Astral:GetElementColor("TabIndicator")
		IndicatorFrame.BorderSizePixel = 0
		IndicatorFrame.Position = UDim2.new(0, ApplyScale(2), 0.5, -ApplyScale(Astral.Config.Tab.IndicatorHeight / 2))
		IndicatorFrame.Size = UDim2.new(0, ApplyScale(Astral.Config.Tab.IndicatorWidth), 0, ApplyScale(Astral.Config.Tab.IndicatorHeight))
		IndicatorFrame.Visible = false

		-- Add dynamic hover effect for tabs
		local function ApplyTabHover()
			if ActiveTab ~= TabButton then
				TweenService:Create(TabButton, TweenInfo.new(Astral.Config.Animation.HoverDuration), {
					BackgroundColor3 = Astral:GetElementColor("TabHover"),
					BackgroundTransparency = 0.25
				}):Play()
			end
		end

		local function RemoveTabHover()
			if ActiveTab ~= TabButton then
				TweenService:Create(TabButton, TweenInfo.new(Astral.Config.Animation.HoverDuration), {
					BackgroundColor3 = Astral:GetElementColor("TabBackground"),
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
		PageFrame.ScrollBarImageColor3 = Astral:GetElementColor("ScrollBar")
		PageFrame.Visible = false
		PageFrame.VerticalScrollBarInset = Enum.ScrollBarInset.None
		PageFrame.HorizontalScrollBarInset = Enum.ScrollBarInset.None
		PageFrame.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
		PageFrame.ScrollingEnabled = true

		CreateScrollBar(PageFrame, WindowId)
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

			ActiveTab = TabButton
			ActiveTabName = TabName

			PageFrame.Visible = true

			UpdateTabVisuals()
		end

		TabButton.MouseButton1Click:Connect(Activate)

		local TabData = {
			Button = TabButton,
			Label = LabelText,
			Icon = IconImage,
			Name = TabName,
			Page = PageFrame
		}
		table.insert(AllTabs, TabData)

		if FirstTab then
			FirstTab = false
			Activate()
		end

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
				SectionFrame.BackgroundColor3 = Astral:GetElementColor("SectionBackground")
				SectionFrame.BackgroundTransparency = Astral.Config.Elements.Section.BackgroundTransparency
				SectionFrame.Size = UDim2.new(1, 0, 0, 0)
				SectionFrame.AutomaticSize = Enum.AutomaticSize.Y

				local SectionCorner = Instance.new("UICorner")
				SectionCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Elements.Section.CornerRadius))
				SectionCorner.Parent = SectionFrame

				local HeaderFrame = Instance.new("Frame")
				HeaderFrame.Parent = SectionFrame
				HeaderFrame.BackgroundColor3 = Astral:GetElementColor("SectionHeaderBackground")
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
				SectionLabel.TextColor3 = Astral:GetElementColor("SectionTitle")
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
			SectionFrame.BackgroundColor3 = Astral:GetElementColor("SectionBackground")
			SectionFrame.BackgroundTransparency = Astral.Config.Elements.Section.BackgroundTransparency
			SectionFrame.Size = UDim2.new(1, 0, 0, 0)
			SectionFrame.AutomaticSize = Enum.AutomaticSize.Y

			local SectionCorner = Instance.new("UICorner")
			SectionCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Elements.Section.CornerRadius))
			SectionCorner.Parent = SectionFrame

			local HeaderFrame = Instance.new("Frame")
			HeaderFrame.Parent = SectionFrame
			HeaderFrame.BackgroundColor3 = Astral:GetElementColor("SectionHeaderBackground")
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
			SectionLabel.TextColor3 = Astral:GetElementColor("SectionTitle")
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
			local ButtonFont = Options.Font or Astral.Config.Elements.Font
			local ButtonSize = Options.Size or Astral.Config.Elements.Size
			local ButtonHeight = Options.Height or Astral.Config.Elements.Height
			local ButtonWidth = Options.Width
			local ButtonAlignment = Options.Alignment or Astral.Config.Elements.Alignment

			local ButtonFrame = Instance.new("TextButton")
			ButtonFrame.Parent = Parent
			ButtonFrame.BackgroundColor3 = Astral:GetElementColor("ButtonBackground")
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
			ButtonLabel.TextColor3 = Astral:GetElementColor("ButtonText")
			ButtonLabel.TextSize = ApplyScale(ButtonSize)
			ButtonLabel.TextXAlignment = ButtonAlignment

			-- Updated to use dynamic color types
			AddHoverEffect(
				ButtonFrame, 
				"ButtonHover", 
				"ButtonBackground", 
				Astral.Config.Elements.Button.HoverTransparency, 
				Astral.Config.Elements.Button.NormalTransparency
			)
			AddClickEffect(ButtonFrame)

			local ButtonObject = {
				Frame = ButtonFrame,
				Label = ButtonLabel,
				Type = "Button"
			}

			local Connection = ButtonFrame.MouseButton1Click:Connect(function()
				Callback(ButtonObject)
			end)
			ButtonObject.Connection = Connection

			function ButtonObject:Update(NewOptions)
				if NewOptions.Name then
					self.Label.Text = NewOptions.Name
				end
				if NewOptions.Callback then
					if self.Connection then
						self.Connection:Disconnect()
					end
					Callback = NewOptions.Callback
					self.Connection = self.Frame.MouseButton1Click:Connect(function()
						Callback(self)
					end)
				end
				if NewOptions.Font then
					self.Label.Font = NewOptions.Font
				end
				if NewOptions.Size then
					self.Label.TextSize = ApplyScale(NewOptions.Size)
				end
				if NewOptions.Height then
					local NewHeight = ApplyScale(NewOptions.Height)
					self.Frame.Size = ButtonWidth and 
						UDim2.new(0, ApplyScale(ButtonWidth), 0, NewHeight) or
						UDim2.new(1, 0, 0, NewHeight)
				end
				if NewOptions.Width then
					ButtonWidth = NewOptions.Width
					self.Frame.Size = UDim2.new(0, ApplyScale(ButtonWidth), 0, self.Frame.Size.Y.Offset)
				end
				if NewOptions.Alignment then
					self.Label.TextXAlignment = NewOptions.Alignment
				end
				return self
			end

			function ButtonObject:SetText(Text)
				self.Label.Text = Text
				return self
			end

			function ButtonObject:GetText()
				return self.Label.Text
			end

			function ButtonObject:SetCallback(NewCallback)
				if self.Connection then
					self.Connection:Disconnect()
				end
				Callback = NewCallback
				self.Connection = self.Frame.MouseButton1Click:Connect(function()
					Callback(self)
				end)
				return self
			end

			function ButtonObject:Destroy()
				if self.Connection then
					self.Connection:Disconnect()
				end
				self.Frame:Destroy()
			end

			function ButtonObject:UpdateTheme()
				self.Frame.BackgroundColor3 = Astral:GetElementColor("ButtonBackground")
				self.Label.TextColor3 = Astral:GetElementColor("ButtonText")
			end

			table.insert(Astral.UIObjects.Elements, ButtonObject)

			return ButtonObject
		end

		function TabFunctions:Toggle(Options, Parent)
			Parent = Parent or PageFrame
			local ToggleName = Options.Name or "Toggle"
			local Default = Options.Default or false
			local Callback = Options.Callback or function() end
			local State = Default
			local ToggleFont = Options.Font or Astral.Config.Elements.Font
			local ToggleSize = Options.Size or Astral.Config.Elements.Size
			local ToggleHeight = Options.Height or Astral.Config.Elements.Height
			local ToggleWidth = Options.Width
			local ToggleAlignment = Options.Alignment or Astral.Config.Elements.Alignment

			local ToggleFrame = Instance.new("Frame")
			ToggleFrame.Parent = Parent
			ToggleFrame.BackgroundColor3 = Astral:GetElementColor("ToggleBackground")
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
			ToggleLabel.TextColor3 = Astral:GetElementColor("ButtonText")
			ToggleLabel.TextSize = ApplyScale(ToggleSize)
			ToggleLabel.TextXAlignment = ToggleAlignment

			local ToggleSwitchWidth = ApplyScale(Astral.Config.Elements.Toggle.Width)
			local ToggleSwitchHeight = ApplyScale(Astral.Config.Elements.Toggle.Height)
			local ToggleCircleSize = ApplyScale(Astral.Config.Elements.Toggle.CircleSize)

			local CheckButton = Instance.new("TextButton")
			CheckButton.Parent = ToggleFrame
			CheckButton.BackgroundColor3 = State and Astral:GetElementColor("ToggleOn") or Astral:GetElementColor("ToggleOff")
			CheckButton.Position = UDim2.new(1, -ToggleSwitchWidth - ApplyScale(8), 0.5, -ToggleSwitchHeight / 2)
			CheckButton.Size = UDim2.new(0, ToggleSwitchWidth, 0, ToggleSwitchHeight)
			CheckButton.AutoButtonColor = false
			CheckButton.Text = ""

			local CheckCorner = Instance.new("UICorner")
			CheckCorner.CornerRadius = UDim.new(1, 0)
			CheckCorner.Parent = CheckButton

			local CircleFrame = Instance.new("Frame")
			CircleFrame.Parent = CheckButton
			CircleFrame.BackgroundColor3 = Astral:GetElementColor("ToggleCircle")
			CircleFrame.Size = UDim2.new(0, ToggleCircleSize, 0, ToggleCircleSize)
			CircleFrame.Position = State and UDim2.new(1, -ToggleCircleSize - ApplyScale(2), 0.5, -ToggleCircleSize / 2) or UDim2.new(0, ApplyScale(2), 0.5, -ToggleCircleSize / 2)

			local CircleCorner = Instance.new("UICorner")
			CircleCorner.CornerRadius = UDim.new(1, 0)
			CircleCorner.Parent = CircleFrame

			local function Update()
				local Position = State and UDim2.new(1, -ToggleCircleSize - ApplyScale(2), 0.5, -ToggleCircleSize / 2) or UDim2.new(0, ApplyScale(2), 0.5, -ToggleCircleSize / 2)
				local Color = State and Astral:GetElementColor("ToggleOn") or Astral:GetElementColor("ToggleOff")
				TweenService:Create(CircleFrame, TweenInfo.new(Astral.Config.Animation.TweenDuration), {Position = Position}):Play()
				TweenService:Create(CheckButton, TweenInfo.new(Astral.Config.Animation.TweenDuration), {BackgroundColor3 = Color}):Play()
			end

			local ToggleObject = {
				Frame = ToggleFrame,
				Label = ToggleLabel,
				CheckButton = CheckButton,
				CircleFrame = CircleFrame,
				Type = "Toggle",
				State = State,
				Name = ToggleName
			}

			-- Store the Update function in the object so UpdateTheme can access it
			ToggleObject.UpdateVisuals = Update

			local function OnClick()
				State = not State
				ToggleObject.State = State
				Update()
				Callback(ToggleObject, State)
			end

			local ClickConnection = CheckButton.MouseButton1Click:Connect(OnClick)
			ToggleObject.Connection = ClickConnection

			Update()

			function ToggleObject:Update(NewOptions)
				if NewOptions.Name then
					self.Label.Text = NewOptions.Name
					self.Name = NewOptions.Name
				end
				if NewOptions.Callback then
					if self.Connection then
						self.Connection:Disconnect()
					end
					Callback = NewOptions.Callback
					self.Connection = self.CheckButton.MouseButton1Click:Connect(function()
						self.State = not self.State
						State = self.State
						Update()
						Callback(self, State)
					end)
				end
				if NewOptions.Default ~= nil and NewOptions.Default ~= State then
					State = NewOptions.Default
					self.State = State
					Update()
				end
				if NewOptions.Font then
					self.Label.Font = NewOptions.Font
				end
				if NewOptions.Size then
					self.Label.TextSize = ApplyScale(NewOptions.Size)
				end
				if NewOptions.Height then
					local NewHeight = ApplyScale(NewOptions.Height)
					self.Frame.Size = ToggleWidth and 
						UDim2.new(0, ApplyScale(ToggleWidth), 0, NewHeight) or
						UDim2.new(1, 0, 0, NewHeight)
					self.CheckButton.Position = UDim2.new(1, -ToggleSwitchWidth - ApplyScale(8), 0.5, -ToggleSwitchHeight / 2)
				end
				if NewOptions.Width then
					ToggleWidth = NewOptions.Width
					self.Frame.Size = UDim2.new(0, ApplyScale(ToggleWidth), 0, self.Frame.Size.Y.Offset)
					self.CheckButton.Position = UDim2.new(1, -ToggleSwitchWidth - ApplyScale(8), 0.5, -ToggleSwitchHeight / 2)
				end
				if NewOptions.Alignment then
					self.Label.TextXAlignment = NewOptions.Alignment
				end
				return self
			end

			function ToggleObject:SetState(NewState)
				if State ~= NewState then
					State = NewState
					self.State = State
					Update()
					Callback(self, State)
				end
				return self
			end

			function ToggleObject:GetState()
				return State
			end

			function ToggleObject:SetText(Text)
				if self.Label then
					self.Label.Text = Text
					self.Name = Text
				end
				return self
			end

			function ToggleObject:GetText()
				return self.Label and self.Label.Text or ""
			end

			function ToggleObject:SetCallback(NewCallback)
				if self.Connection then
					self.Connection:Disconnect()
				end
				Callback = NewCallback
				self.Connection = self.CheckButton.MouseButton1Click:Connect(function()
					self.State = not self.State
					State = self.State
					Update()
					Callback(self, State)
				end)
				return self
			end

			function ToggleObject:Toggle()
				State = not State
				self.State = State
				Update()
				Callback(self, State)
				return State
			end

			function ToggleObject:Destroy()
				if self.Connection then
					self.Connection:Disconnect()
				end
				self.Frame:Destroy()
			end

			function ToggleObject:UpdateTheme()
				if self.Frame then
					self.Frame.BackgroundColor3 = Astral:GetElementColor("ToggleBackground")
				end
				if self.Label then
					self.Label.TextColor3 = Astral:GetElementColor("ButtonText")
				end
				if self.CheckButton then
					local currentState = self.State or false
					self.CheckButton.BackgroundColor3 = currentState and Astral:GetElementColor("ToggleOn") or Astral:GetElementColor("ToggleOff")
				end
				if self.CircleFrame then
					self.CircleFrame.BackgroundColor3 = Astral:GetElementColor("ToggleCircle")
				end
				-- Refresh the visual state
				if self.UpdateVisuals then
					self.UpdateVisuals()
				end
			end

			table.insert(Astral.UIObjects.Elements, ToggleObject)

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
			local SliderFont = Options.Font or Astral.Config.Elements.Font
			local SliderSize = Options.Size or Astral.Config.Elements.Size
			local SliderHeight = Options.Height or Astral.Config.Elements.Slider.Height
			local SliderWidth = Options.Width
			local SliderAlignment = Options.Alignment or Astral.Config.Elements.Alignment

			local SliderFrame = Instance.new("Frame")
			SliderFrame.Parent = Parent
			SliderFrame.BackgroundColor3 = Astral:GetElementColor("ElementBackground")
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
			SliderLabel.Position = UDim2.new(0, 0, 0, ApplyScale(8))
			ApplyPadding(SliderLabel, ApplyScale(BasePadding))
			SliderLabel.Font = SliderFont
			SliderLabel.Text = SliderName
			SliderLabel.TextColor3 = Astral:GetElementColor("SliderLabel")
			SliderLabel.TextSize = ApplyScale(SliderSize)
			SliderLabel.TextXAlignment = SliderAlignment

			local ValueInputScrollingFrame = Instance.new("ScrollingFrame")
			ValueInputScrollingFrame.Parent = SliderFrame
			ValueInputScrollingFrame.BackgroundColor3 = Astral:GetElementColor("SliderInputBackground")
			ValueInputScrollingFrame.BackgroundTransparency = Astral.Config.Elements.BackgroundTransparency
			ValueInputScrollingFrame.Position = UDim2.new(1, -ApplyScale(Astral.Config.Elements.Slider.InputWidth + 12), 0, ApplyScale(4))
			ValueInputScrollingFrame.Size = UDim2.new(0, ApplyScale(Astral.Config.Elements.Slider.InputWidth), 0, ApplyScale(Astral.Config.Elements.Slider.InputHeight))
			ValueInputScrollingFrame.ScrollBarThickness = 0
			ValueInputScrollingFrame.ScrollBarImageTransparency = 1
			ValueInputScrollingFrame.BorderSizePixel = 0
			ValueInputScrollingFrame.ClipsDescendants = true

			local ValueInputScrollingCorner = Instance.new("UICorner")
			ValueInputScrollingCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Elements.TextBox.InputCornerRadius))
			ValueInputScrollingCorner.Parent = ValueInputScrollingFrame

			local ValueInputPadding = Instance.new("UIPadding")
			ValueInputPadding.Parent = ValueInputScrollingFrame
			ValueInputPadding.PaddingLeft = UDim.new(0, ApplyScale(4))
			ValueInputPadding.PaddingRight = UDim.new(0, ApplyScale(4))

			local ValueInput = Instance.new("TextBox")
			ValueInput.Parent = ValueInputScrollingFrame
			ValueInput.BackgroundTransparency = 1
			ValueInput.Size = UDim2.new(1, 0, 1, 0)
			ValueInput.Font = Astral.Config.Elements.Slider.InputFont
			ValueInput.Text = tostring(Value)
			ValueInput.TextColor3 = Astral:GetElementColor("SliderInputText")
			ValueInput.TextSize = ApplyScale(Astral.Config.Elements.Slider.InputSize)
			ValueInput.ClearTextOnFocus = false
			ValueInput.TextXAlignment = Enum.TextXAlignment.Center
			ValueInput.TextTruncate = Enum.TextTruncate.None

			local InputStroke = Instance.new("UIStroke")
			InputStroke.Parent = ValueInputScrollingFrame
			InputStroke.Color = Astral:GetElementColor("SliderInputBorder")
			InputStroke.Thickness = ApplyScale(Astral.Config.Elements.TextBox.StrokeThickness)
			InputStroke.Transparency = Astral.Config.Elements.TextBox.StrokeTransparency

			local BackgroundFrame = Instance.new("Frame")
			BackgroundFrame.Name = "BackgroundFrame"
			BackgroundFrame.Parent = SliderFrame
			BackgroundFrame.BackgroundColor3 = Astral:GetElementColor("SliderTrack")
			BackgroundFrame.Position = UDim2.new(0, ApplyScale(BasePadding), 1, -ApplyScale(Astral.Config.Elements.Slider.TrackHeight + 6))
			BackgroundFrame.Size = UDim2.new(1, -ApplyScale(BasePadding * 2), 0, ApplyScale(Astral.Config.Elements.Slider.TrackHeight))

			local BackgroundCorner = Instance.new("UICorner")
			BackgroundCorner.CornerRadius = UDim.new(1, 0)
			BackgroundCorner.Parent = BackgroundFrame

			local FillFrame = Instance.new("Frame")
			FillFrame.Parent = BackgroundFrame
			FillFrame.BackgroundColor3 = Astral:GetElementColor("SliderFill")
			FillFrame.Size = UDim2.new(0, 0, 1, 0)

			local FillCorner = Instance.new("UICorner")
			FillCorner.CornerRadius = UDim.new(1, 0)
			FillCorner.Parent = FillFrame

			local BallSize = ApplyScale(Astral.Config.Elements.Slider.BallSize)
			local BallFrame = Instance.new("Frame")
			BallFrame.Name = "BallFrame"
			BallFrame.Parent = BackgroundFrame
			BallFrame.BackgroundColor3 = Astral:GetElementColor("SliderBall")
			BallFrame.Size = UDim2.new(0, BallSize, 0, BallSize)
			BallFrame.ZIndex = 2

			local BallCorner = Instance.new("UICorner")
			BallCorner.CornerRadius = UDim.new(1, 0)
			BallCorner.Parent = BallFrame

			local Dragging = false

			local SliderObject = {
				Frame = SliderFrame,
				Label = SliderLabel,
				ValueInputScrollingFrame = ValueInputScrollingFrame,
				ValueInput = ValueInput,
				BackgroundFrame = BackgroundFrame,
				FillFrame = FillFrame,
				BallFrame = BallFrame,
				Type = "Slider",
				Value = Value,
				Min = Min,
				Max = Max
			}

			local function TruncateTextWithEllipsis(Text, MaxWidth, TextSize, Font)
				local TextService = game:GetService("TextService")

				local TextBounds = TextService:GetTextSize(Text, TextSize, Font, Vector2.new(10000, 10000))
				if TextBounds.X <= MaxWidth then
					return Text
				end

				local Ellipsis = "..."
				local EllipsisWidth = TextService:GetTextSize(Ellipsis, TextSize, Font, Vector2.new(10000, 10000)).X

				local Low, High = 1, #Text
				local Result = ""

				while Low <= High do
					local Mid = math.floor((Low + High) / 2)
					local TestText = Text:sub(1, Mid) .. Ellipsis
					local TestBounds = TextService:GetTextSize(TestText, TextSize, Font, Vector2.new(10000, 10000))

					if TestBounds.X <= MaxWidth then
						Result = TestText
						Low = Mid + 1
					else
						High = Mid - 1
					end
				end

				return Result == "" and Ellipsis or Result
			end

			local function UpdateTextDisplay()
				local TextService = game:GetService("TextService")
				local CurrentText = ValueInput.Text
				local MaxWidth = ValueInputScrollingFrame.AbsoluteSize.X
				local TextSize = ValueInput.TextSize
				local Font = ValueInput.Font

				if ValueInput:IsFocused() then
					ValueInput.Text = CurrentText
					ValueInput.TextTruncate = Enum.TextTruncate.None

					local TextBounds = TextService:GetTextSize(CurrentText, TextSize, Font, Vector2.new(10000, 10000))
					ValueInputScrollingFrame.CanvasSize = UDim2.new(0, TextBounds.X, 0, 0)

					if TextBounds.X > MaxWidth then
						local ScrollPosition = TextBounds.X - MaxWidth
						ValueInputScrollingFrame.CanvasPosition = Vector2.new(ScrollPosition, 0)
					else
						ValueInputScrollingFrame.CanvasPosition = Vector2.new(0, 0)
					end
				else
					local FullText = ValueInput:GetAttribute("FullText") or CurrentText
					local TruncatedText = TruncateTextWithEllipsis(FullText, MaxWidth, TextSize, Font)
					ValueInput.Text = TruncatedText
					ValueInput.TextTruncate = Enum.TextTruncate.None

					local TextBounds = TextService:GetTextSize(TruncatedText, TextSize, Font, Vector2.new(10000, 10000))
					ValueInputScrollingFrame.CanvasSize = UDim2.new(0, TextBounds.X, 0, 0)
					ValueInputScrollingFrame.CanvasPosition = Vector2.new(0, 0)
				end
			end

			local function CalculateBallPosition(Percentage)
				local TrackWidth = BackgroundFrame.AbsoluteSize.X
				local BallRadius = BallSize / 2
				local Padding = BallRadius
				local AvailableWidth = TrackWidth - (Padding * 2)
				local Position = Padding + (AvailableWidth * Percentage)
				return Position
			end

			local function UpdateVisualsOnly()
				local VisualPercentage = (Value - Min) / (Max - Min)

				local TrackWidth = BackgroundFrame.AbsoluteSize.X
				local FillWidth = TrackWidth * VisualPercentage

				TweenService:Create(FillFrame, TweenInfo.new(0.05), {
					Size = UDim2.new(0, FillWidth, 1, 0)
				}):Play()

				local BallPosition = CalculateBallPosition(VisualPercentage)
				local BallRadius = BallSize / 2

				TweenService:Create(BallFrame, TweenInfo.new(0.05), {
					Position = UDim2.new(0, BallPosition - BallRadius, 0.5, -BallRadius)
				}):Play()

				local FullValueText = tostring(Value)
				ValueInput:SetAttribute("FullText", FullValueText)
				UpdateTextDisplay()
			end

			local function UpdateVisuals()
				UpdateVisualsOnly()
				Callback(SliderObject, Value)
			end

			SliderObject.UpdateVisualsOnly = UpdateVisualsOnly

			local function Update(Input)
				local SizeX = BackgroundFrame.AbsoluteSize.X
				local OffsetX = math.clamp(Input.Position.X - BackgroundFrame.AbsolutePosition.X, 0, SizeX)
				local BallRadius = BallSize / 2
				local Padding = BallRadius
				local AvailableWidth = SizeX - (Padding * 2)

				local AdjustedOffsetX = math.clamp(OffsetX - Padding, 0, AvailableWidth)
				local Percentage = AvailableWidth > 0 and (AdjustedOffsetX / AvailableWidth) or 0

				Value = math.floor(((Max - Min) * Percentage + Min) / Increment + 0.5) * Increment
				Value = math.clamp(Value, Min, Max)
				UpdateVisuals()
			end

			local function UpdateFromText()
				local InputText = ValueInput.Text
				local FullText = ValueInput:GetAttribute("FullText") or InputText
				local InputValue = tonumber(FullText)

				if InputValue then
					Value = math.clamp(math.floor(InputValue / Increment + 0.5) * Increment, Min, Max)
					UpdateVisuals()
				else
					UpdateVisualsOnly()
				end
			end

			ValueInput:GetPropertyChangedSignal("Text"):Connect(function()
				if ValueInput:IsFocused() then
					ValueInput:SetAttribute("FullText", ValueInput.Text)
					UpdateTextDisplay()
				end
			end)

			ValueInput.Focused:Connect(function()
				ScrollToElement(PageFrame, SliderFrame)
				local FullText = ValueInput:GetAttribute("FullText") or tostring(Value)
				ValueInput.Text = FullText
				UpdateTextDisplay()

				ValueInput:CaptureFocus()
				delay(0.01, function()
					ValueInput.SelectionStart = 1
					ValueInput.CursorPosition = #FullText + 1
				end)
			end)

			ValueInput.FocusLost:Connect(function(EnterPressed)
				UpdateFromText()
				UpdateTextDisplay()
			end)

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

			UpdateVisualsOnly()

			function SliderObject:Update(NewOptions)
				if NewOptions.Name then
					self.Label.Text = NewOptions.Name
				end
				if NewOptions.Callback then
					Callback = NewOptions.Callback
				end
				if NewOptions.Min then
					Min = NewOptions.Min
					self.Min = Min
					Value = math.clamp(Value, Min, Max)
					UpdateVisuals()
				end
				if NewOptions.Max then
					Max = NewOptions.Max
					self.Max = Max
					Value = math.clamp(Value, Min, Max)
					UpdateVisuals()
				end
				if NewOptions.Default ~= nil then
					Value = math.clamp(NewOptions.Default, Min, Max)
					self.Value = Value
					UpdateVisuals()
				end
				if NewOptions.Increment then
					Increment = NewOptions.Increment
					Value = math.floor(Value / Increment + 0.5) * Increment
					UpdateVisuals()
				end
				if NewOptions.Font then
					self.Label.Font = NewOptions.Font
				end
				if NewOptions.Size then
					self.Label.TextSize = ApplyScale(NewOptions.Size)
				end
				if NewOptions.Height then
					local NewHeight = ApplyScale(NewOptions.Height)
					self.Frame.Size = SliderWidth and 
						UDim2.new(0, ApplyScale(SliderWidth), 0, NewHeight) or
						UDim2.new(1, 0, 0, NewHeight)
				end
				if NewOptions.Width then
					SliderWidth = NewOptions.Width
					self.Frame.Size = UDim2.new(0, ApplyScale(SliderWidth), 0, self.Frame.Size.Y.Offset)
				end
				if NewOptions.Alignment then
					self.Label.TextXAlignment = NewOptions.Alignment
				end
				return self
			end

			function SliderObject:SetValue(NewValue)
				Value = math.clamp(NewValue, Min, Max)
				self.Value = Value
				UpdateVisuals()
				return self
			end

			function SliderObject:GetValue()
				return Value
			end

			function SliderObject:SetRange(NewMin, NewMax)
				Min = NewMin
				Max = NewMax
				self.Min = Min
				self.Max = Max
				Value = math.clamp(Value, Min, Max)
				self.Value = Value
				UpdateVisuals()
				return self
			end

			function SliderObject:SetText(Text)
				self.Label.Text = Text
				return self
			end

			function SliderObject:GetText()
				return self.Label.Text
			end

			function SliderObject:SetCallback(NewCallback)
				Callback = NewCallback
				return self
			end

			function SliderObject:Destroy()
				self.Frame:Destroy()
			end

			function SliderObject:UpdateTheme()
				self.Frame.BackgroundColor3 = Astral:GetElementColor("ElementBackground")
				self.Label.TextColor3 = Astral:GetElementColor("SliderLabel")
				self.ValueInputScrollingFrame.BackgroundColor3 = Astral:GetElementColor("SliderInputBackground")
				self.ValueInput.TextColor3 = Astral:GetElementColor("SliderInputText")
				self.BackgroundFrame.BackgroundColor3 = Astral:GetElementColor("SliderTrack")
				self.FillFrame.BackgroundColor3 = Astral:GetElementColor("SliderFill")
				self.BallFrame.BackgroundColor3 = Astral:GetElementColor("SliderBall")

				local InputStroke = self.ValueInputScrollingFrame:FindFirstChildOfClass("UIStroke")
				if InputStroke then
					InputStroke.Color = Astral:GetElementColor("SliderInputBorder")
				end

				if self.UpdateVisualsOnly then
					self.UpdateVisualsOnly()
				end
			end

			table.insert(Astral.UIObjects.Elements, SliderObject)

			return SliderObject
		end

		function TabFunctions:TextBox(Options, Parent)
			Parent = Parent or PageFrame
			local TextBoxName = Options.Name or "TextBox"
			local Default = Options.Default or ""
			local Placeholder = Options.Placeholder or "Enter text..."
			local Callback = Options.Callback or function() end
			local TextBoxFont = Options.Font or Astral.Config.Elements.Font
			local TextBoxSize = Options.Size or Astral.Config.Elements.Size
			local TextBoxHeight = Options.Height or Astral.Config.Elements.TextBox.Height
			local TextBoxWidth = Options.Width
			local TextBoxAlignment = Options.Alignment or Astral.Config.Elements.Alignment

			local TextBoxFrame = Instance.new("Frame")
			TextBoxFrame.Parent = Parent
			TextBoxFrame.BackgroundColor3 = Astral:GetElementColor("ElementBackground")
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
			TextBoxLabel.TextColor3 = Astral:GetElementColor("TextBoxLabel")
			TextBoxLabel.TextSize = ApplyScale(TextBoxSize)
			TextBoxLabel.TextXAlignment = TextBoxAlignment

			local LabelHeight = ApplyScale(Astral.Config.Elements.TextBox.LabelHeight)
			local InputHeight = ApplyScale(Astral.Config.Elements.TextBox.InputHeight)
			local TotalHeight = ApplyScale(TextBoxHeight)

			local RemainingSpace = TotalHeight - LabelHeight
			local InputTopPosition = LabelHeight + (RemainingSpace - InputHeight) / 2

			local InputScrollingFrame = Instance.new("ScrollingFrame")
			InputScrollingFrame.Parent = TextBoxFrame
			InputScrollingFrame.BackgroundColor3 = Astral:GetElementColor("TextBoxBackground")
			InputScrollingFrame.BackgroundTransparency = Astral.Config.Elements.BackgroundTransparency
			InputScrollingFrame.Position = UDim2.new(0, ApplyScale(BasePadding), 0, InputTopPosition)
			InputScrollingFrame.Size = UDim2.new(1, -ApplyScale(BasePadding * 2), 0, InputHeight)
			InputScrollingFrame.ScrollBarThickness = 0
			InputScrollingFrame.ScrollBarImageTransparency = 1
			InputScrollingFrame.BorderSizePixel = 0
			InputScrollingFrame.ClipsDescendants = true

			local InputCorner = Instance.new("UICorner")
			InputCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Elements.TextBox.InputCornerRadius))
			InputCorner.Parent = InputScrollingFrame

			local InputPadding = Instance.new("UIPadding")
			InputPadding.Parent = InputScrollingFrame
			InputPadding.PaddingLeft = UDim.new(0, ApplyScale(6))
			InputPadding.PaddingRight = UDim.new(0, ApplyScale(6))

			local InputBox = Instance.new("TextBox")
			InputBox.Parent = InputScrollingFrame
			InputBox.BackgroundTransparency = 1
			InputBox.Size = UDim2.new(1, 0, 1, 0)
			InputBox.Font = Enum.Font.Gotham
			InputBox.PlaceholderText = Placeholder
			InputBox.PlaceholderColor3 = Astral:GetElementColor("TextBoxPlaceholder")
			InputBox.Text = Default
			InputBox.TextColor3 = Astral:GetElementColor("TextBoxText")
			InputBox.TextSize = ApplyScale(Astral.Config.Elements.TextBox.InputSize)
			InputBox.TextXAlignment = Enum.TextXAlignment.Left
			InputBox.ClearTextOnFocus = false
			InputBox.TextTruncate = Enum.TextTruncate.None

			local InputStroke = Instance.new("UIStroke")
			InputStroke.Parent = InputScrollingFrame
			InputStroke.Color = Astral:GetElementColor("TextBoxBorder")
			InputStroke.Thickness = ApplyScale(Astral.Config.Elements.TextBox.StrokeThickness)
			InputStroke.Transparency = Astral.Config.Elements.TextBox.StrokeTransparency

			local TextBoxObject = {
				Frame = TextBoxFrame,
				Label = TextBoxLabel,
				InputScrollingFrame = InputScrollingFrame,
				InputBox = InputBox,
				Type = "TextBox"
			}

			local function TruncateTextWithEllipsis(Text, MaxWidth, TextSize, Font)
				local TextService = game:GetService("TextService")

				local TextBounds = TextService:GetTextSize(Text, TextSize, Font, Vector2.new(10000, 10000))
				if TextBounds.X <= MaxWidth then
					return Text
				end

				local Ellipsis = "..."
				local EllipsisWidth = TextService:GetTextSize(Ellipsis, TextSize, Font, Vector2.new(10000, 10000)).X

				local Low, High = 1, #Text
				local Result = ""

				while Low <= High do
					local Mid = math.floor((Low + High) / 2)
					local TestText = Text:sub(1, Mid) .. Ellipsis
					local TestBounds = TextService:GetTextSize(TestText, TextSize, Font, Vector2.new(10000, 10000))

					if TestBounds.X <= MaxWidth then
						Result = TestText
						Low = Mid + 1
					else
						High = Mid - 1
					end
				end

				return Result == "" and Ellipsis or Result
			end

			local function UpdateTextDisplay()
				local TextService = game:GetService("TextService")
				local CurrentText = InputBox.Text
				local MaxWidth = InputScrollingFrame.AbsoluteSize.X
				local TextSize = InputBox.TextSize
				local Font = InputBox.Font

				if InputBox:IsFocused() then
					InputBox.Text = CurrentText
					InputBox.TextTruncate = Enum.TextTruncate.None

					local TextBounds = TextService:GetTextSize(CurrentText, TextSize, Font, Vector2.new(10000, 10000))
					InputScrollingFrame.CanvasSize = UDim2.new(0, TextBounds.X, 0, 0)

					if TextBounds.X > MaxWidth then
						local ScrollPosition = TextBounds.X - MaxWidth
						InputScrollingFrame.CanvasPosition = Vector2.new(ScrollPosition, 0)
					else
						InputScrollingFrame.CanvasPosition = Vector2.new(0, 0)
					end

					InputBox:SetAttribute("FullText", CurrentText)
				else
					local FullText = InputBox:GetAttribute("FullText") or CurrentText
					local TruncatedText = TruncateTextWithEllipsis(FullText, MaxWidth, TextSize, Font)
					InputBox.Text = TruncatedText
					InputBox.TextTruncate = Enum.TextTruncate.None

					local TextBounds = TextService:GetTextSize(TruncatedText, TextSize, Font, Vector2.new(10000, 10000))
					InputScrollingFrame.CanvasSize = UDim2.new(0, TextBounds.X, 0, 0)
					InputScrollingFrame.CanvasPosition = Vector2.new(0, 0)
				end
			end

			InputBox:GetPropertyChangedSignal("Text"):Connect(function()
				if InputBox:IsFocused() then
					InputBox:SetAttribute("FullText", InputBox.Text)
					UpdateTextDisplay()
				end
			end)

			InputBox.Focused:Connect(function()
				ScrollToElement(PageFrame, TextBoxFrame)
				local FullText = InputBox:GetAttribute("FullText") or InputBox.Text
				InputBox.Text = FullText
				UpdateTextDisplay()

				InputBox:CaptureFocus()
				delay(0.01, function()
					InputBox.SelectionStart = 1
					InputBox.CursorPosition = #FullText + 1
				end)
			end)

			InputBox.FocusLost:Connect(function(EnterPressed)
				if EnterPressed then
					Callback(TextBoxObject, InputBox:GetAttribute("FullText") or InputBox.Text)
				end
				UpdateTextDisplay()
			end)

			InputBox:SetAttribute("FullText", Default)
			UpdateTextDisplay()

			function TextBoxObject:Update(NewOptions)
				if NewOptions.Name then
					self.Label.Text = NewOptions.Name
				end
				if NewOptions.Callback then
					Callback = NewOptions.Callback
				end
				if NewOptions.Default then
					self.InputBox.Text = NewOptions.Default
					self.InputBox:SetAttribute("FullText", NewOptions.Default)
					UpdateTextDisplay()
				end
				if NewOptions.Placeholder then
					self.InputBox.PlaceholderText = NewOptions.Placeholder
				end
				if NewOptions.Font then
					self.Label.Font = NewOptions.Font
				end
				if NewOptions.Size then
					self.Label.TextSize = ApplyScale(NewOptions.Size)
				end
				if NewOptions.Height then
					local NewHeight = ApplyScale(NewOptions.Height)
					self.Frame.Size = TextBoxWidth and 
						UDim2.new(0, ApplyScale(TextBoxWidth), 0, NewHeight) or
						UDim2.new(1, 0, 0, NewHeight)

					local LabelHeight = ApplyScale(Astral.Config.Elements.TextBox.LabelHeight)
					local InputHeight = ApplyScale(Astral.Config.Elements.TextBox.InputHeight)
					local TotalHeight = NewHeight
					local RemainingSpace = TotalHeight - LabelHeight
					local InputTopPosition = LabelHeight + (RemainingSpace - InputHeight) / 2

					self.InputScrollingFrame.Position = UDim2.new(0, ApplyScale(BasePadding), 0, InputTopPosition)
					UpdateTextDisplay()
				end
				if NewOptions.Width then
					TextBoxWidth = NewOptions.Width
					self.Frame.Size = UDim2.new(0, ApplyScale(TextBoxWidth), 0, self.Frame.Size.Y.Offset)
					self.InputScrollingFrame.Size = UDim2.new(1, -ApplyScale(BasePadding * 2), 0, ApplyScale(Astral.Config.Elements.TextBox.InputHeight))
					UpdateTextDisplay()
				end
				if NewOptions.Alignment then
					self.Label.TextXAlignment = NewOptions.Alignment
				end
				return self
			end

			function TextBoxObject:SetText(Text)
				self.InputBox.Text = Text
				self.InputBox:SetAttribute("FullText", Text)
				UpdateTextDisplay()
				return self
			end

			function TextBoxObject:GetText()
				return self.InputBox:GetAttribute("FullText") or self.InputBox.Text
			end

			function TextBoxObject:SetPlaceholder(Text)
				self.InputBox.PlaceholderText = Text
				return self
			end

			function TextBoxObject:SetName(Text)
				self.Label.Text = Text
				return self
			end

			function TextBoxObject:SetCallback(NewCallback)
				Callback = NewCallback
				return self
			end

			function TextBoxObject:Destroy()
				self.Frame:Destroy()
			end

			function TextBoxObject:UpdateTheme()
				self.Frame.BackgroundColor3 = Astral:GetElementColor("ElementBackground")
				self.Label.TextColor3 = Astral:GetElementColor("TextBoxLabel")
				self.InputScrollingFrame.BackgroundColor3 = Astral:GetElementColor("TextBoxBackground")
				self.InputBox.TextColor3 = Astral:GetElementColor("TextBoxText")
				self.InputBox.PlaceholderColor3 = Astral:GetElementColor("TextBoxPlaceholder")

				local InputStroke = self.InputScrollingFrame:FindFirstChildOfClass("UIStroke")
				if InputStroke then
					InputStroke.Color = Astral:GetElementColor("TextBoxBorder")
				end

				UpdateTextDisplay()
			end

			table.insert(Astral.UIObjects.Elements, TextBoxObject)

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
			local DropdownFont = Options.Font or Astral.Config.Elements.Font
			local DropdownSize = Options.Size or Astral.Config.Elements.Size
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
			DropdownFrame.BackgroundColor3 = Astral:GetElementColor("ElementBackground")
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
			DropdownLabel.TextColor3 = Astral:GetElementColor("DropdownLabel")
			DropdownLabel.TextSize = ApplyScale(DropdownSize)
			DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
			DropdownLabel.BackgroundTransparency = 1

			local ArrowImage = Instance.new("ImageLabel")
			ArrowImage.Parent = DropdownButton
			ArrowImage.BackgroundTransparency = 1
			ArrowImage.Position = UDim2.new(1, -ApplyScale(26), 0.5, -Astral.Config.Elements.Dropdown.ArrowSize / 2)
			ArrowImage.Size = UDim2.new(0, ApplyScale(Astral.Config.Elements.Dropdown.ArrowSize), 0, Astral.Config.Elements.Dropdown.ArrowSize)
			ArrowImage.Image = "rbxassetid://6031091004"
			ArrowImage.ImageColor3 = Astral:GetElementColor("DropdownArrow")

			local Header = Instance.new("Frame")
			Header.Parent = DropdownFrame
			Header.Position = UDim2.new(0, ApplyScale(BasePaddingValue), 0, ApplyScale(BaseElementHeight + BasePaddingValue))
			Header.Size = UDim2.new(1, -ApplyScale(BasePaddingValue * 2), 0, ApplyScale(BaseElementHeight))
			Header.BackgroundTransparency = 1
			Header.Visible = false

			local SearchBox = Instance.new("TextBox")
			SearchBox.Parent = Header
			SearchBox.Size = UDim2.new(1, -ApplyScale(50), 1, 0)
			SearchBox.BackgroundColor3 = Astral:GetElementColor("DropdownSearchBackground")
			SearchBox.BackgroundTransparency = Astral.Config.Elements.BackgroundTransparency
			SearchBox.PlaceholderText = "Search..."
			SearchBox.Text = ""
			SearchBox.TextColor3 = Astral:GetElementColor("DropdownSearchText")
			SearchBox.Font = Enum.Font.Gotham
			SearchBox.TextSize = Astral.Config.Elements.Dropdown.SearchSize
			local SearchBoxCorner = Instance.new("UICorner")
			SearchBoxCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Elements.Dropdown.InputCornerRadius))
			SearchBoxCorner.Parent = SearchBox

			local SearchStroke = Instance.new("UIStroke")
			SearchStroke.Parent = SearchBox
			SearchStroke.Color = Astral:GetElementColor("DropdownSearchBorder")
			SearchStroke.Thickness = ApplyScale(Astral.Config.Elements.Dropdown.StrokeThickness)
			SearchStroke.Transparency = Astral.Config.Elements.Dropdown.StrokeTransparency

			local ClearBtn = Instance.new("TextButton")
			ClearBtn.Parent = Header
			ClearBtn.Position = UDim2.new(1, -ApplyScale(45), 0, 0)
			ClearBtn.Size = UDim2.new(0, ApplyScale(45), 1, 0)
			ClearBtn.BackgroundColor3 = Astral:GetElementColor("DropdownClearButton")
			ClearBtn.BackgroundTransparency = Astral.Config.Elements.BackgroundTransparency
			ClearBtn.Text = "CLEAR"
			ClearBtn.Font = Enum.Font.GothamBold
			ClearBtn.TextColor3 = Astral:GetElementColor("DropdownClearButtonText")
			ClearBtn.TextSize = Astral.Config.Elements.Dropdown.ButtonSize
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
			DropdownList.ScrollBarImageColor3 = Astral:GetElementColor("ScrollBar")
			DropdownList.BorderSizePixel = 0
			DropdownList.VerticalScrollBarInset = Enum.ScrollBarInset.None
			DropdownList.HorizontalScrollBarInset = Enum.ScrollBarInset.None
			DropdownList.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
			DropdownList.ScrollingEnabled = false
			DropdownList.Visible = false

			CreateScrollBar(DropdownList, WindowId)

			local DropdownLayout = Instance.new("UIListLayout")
			DropdownLayout.Parent = DropdownList
			DropdownLayout.Padding = UDim.new(0, ApplyScale(BasePaddingValue))

			local DropdownObject = {
				Frame = DropdownFrame,
				Label = DropdownLabel,
				DropdownList = DropdownList,
				Type = "Dropdown",
				CurrentSelected = CurrentSelected,
				DropdownOptions = DropdownOptions
			}

			local function Refresh(Filter)
				for _, Child in pairs(DropdownList:GetChildren()) do
					if Child:IsA("TextButton") then Child:Destroy() end
				end
				for _, Option in pairs(DropdownObject.DropdownOptions) do
					if Filter and Filter ~= "" and not string.find(string.lower(Option), string.lower(Filter)) then continue end

					local IsSelected = (CurrentSelected == Option)
					local OptionButton = Instance.new("TextButton")
					OptionButton.Parent = DropdownList
					OptionButton.BackgroundColor3 = IsSelected and Astral:GetElementColor("DropdownOptionSelectedBackground") or Astral:GetElementColor("DropdownOptionBackground")
					OptionButton.BackgroundTransparency = IsSelected and 0.15 or Astral.Config.Elements.BackgroundTransparency
					OptionButton.Size = UDim2.new(1, 0, 0, Astral.Config.Elements.Dropdown.OptionHeight)
					OptionButton.Text = Option
					OptionButton.Font = IsSelected and Enum.Font.GothamBold or Enum.Font.Gotham
					OptionButton.TextColor3 = IsSelected and Astral:GetElementColor("DropdownOptionSelectedText") or Astral:GetElementColor("DropdownOptionText")
					OptionButton.TextSize = Astral.Config.Elements.Dropdown.OptionSize
					local OptionCorner = Instance.new("UICorner")
					OptionCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Elements.Dropdown.InputCornerRadius))
					OptionCorner.Parent = OptionButton

					OptionButton.MouseButton1Click:Connect(function()
						CurrentSelected = Option
						DropdownLabel.Text = DropdownName .. ": " .. Option
						DropdownObject.CurrentSelected = Option
						Callback(DropdownObject, Option)
						Refresh(SearchBox.Text)
					end)
				end

				local ContentHeight = DropdownLayout.AbsoluteContentSize.Y
				DropdownList.CanvasSize = UDim2.new(0, 0, 0, ContentHeight)
				DropdownList.ScrollingEnabled = ContentHeight > CalculatedListHeight
			end

			-- Store the Refresh function in the object
			DropdownObject.RefreshFunction = Refresh

			SearchBox:GetPropertyChangedSignal("Text"):Connect(function() Refresh(SearchBox.Text) end)

			ClearBtn.MouseButton1Click:Connect(function()
				CurrentSelected = nil
				DropdownObject.CurrentSelected = nil
				DropdownLabel.Text = DropdownName
				Callback(DropdownObject, nil)
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

			function DropdownObject:Update(NewOptions)
				if NewOptions.Name then
					DropdownName = NewOptions.Name
					self.Label.Text = DropdownName .. (self.CurrentSelected and (": " .. tostring(self.CurrentSelected)) or "")
				end
				if NewOptions.Callback then
					Callback = NewOptions.Callback
				end
				if NewOptions.Options then
					self.DropdownOptions = NewOptions.Options
					if self.CurrentSelected and not table.find(self.DropdownOptions, self.CurrentSelected) then
						self.CurrentSelected = nil
						CurrentSelected = nil
						self.Label.Text = DropdownName
					end
					Refresh(SearchBox.Text)
				end
				if NewOptions.Default ~= nil then
					if NewOptions.Default == nil then
						self.CurrentSelected = nil
						CurrentSelected = nil
						self.Label.Text = DropdownName
					elseif table.find(self.DropdownOptions, NewOptions.Default) then
						self.CurrentSelected = NewOptions.Default
						CurrentSelected = NewOptions.Default
						self.Label.Text = DropdownName .. ": " .. self.CurrentSelected
					end
					Refresh(SearchBox.Text)
				end
				if NewOptions.VisibleOptions then
					VisibleOptions = NewOptions.VisibleOptions
					CalculatedListHeight = (OptionHeight + OptionPadding) * VisibleOptions - OptionPadding
					if CalculatedListHeight < OptionHeight then
						CalculatedListHeight = OptionHeight
					end
					ExpandedHeight = ApplyScale(BaseElementHeight) + 
						ApplyScale(BaseElementHeight) + 
						ApplyScale(BasePaddingValue) + 
						CalculatedListHeight + 
						ApplyScale(BasePaddingValue * 2)

					self.DropdownList.Size = UDim2.new(1, -ApplyScale(BasePaddingValue * 2), 0, CalculatedListHeight)
				end
				if NewOptions.Font then
					self.Label.Font = NewOptions.Font
				end
				if NewOptions.Size then
					self.Label.TextSize = ApplyScale(NewOptions.Size)
				end
				if NewOptions.Height then
					BaseElementHeight = NewOptions.Height
					BaseTotalHeight = ApplyScale(BaseElementHeight)
					DropdownButton.Size = UDim2.new(1, 0, 0, BaseTotalHeight)
					self.Frame.Size = DropdownWidth and 
						UDim2.new(0, ApplyScale(DropdownWidth), 0, BaseTotalHeight) or
						UDim2.new(1, 0, 0, BaseTotalHeight)
				end
				if NewOptions.Width then
					DropdownWidth = NewOptions.Width
					self.Frame.Size = UDim2.new(0, ApplyScale(DropdownWidth), 0, BaseTotalHeight)
				end
				return self
			end

			function DropdownObject:SetOptions(NewOptions)
				self.DropdownOptions = NewOptions
				if self.CurrentSelected and not table.find(self.DropdownOptions, self.CurrentSelected) then
					self.CurrentSelected = nil
					CurrentSelected = nil
					self.Label.Text = DropdownName
				end
				Refresh(SearchBox.Text)
				return self
			end

			function DropdownObject:AddOption(Option)
				table.insert(self.DropdownOptions, Option)
				Refresh(SearchBox.Text)
				return self
			end

			function DropdownObject:RemoveOption(Option)
				for i, v in ipairs(self.DropdownOptions) do
					if v == Option then
						table.remove(self.DropdownOptions, i)
						break
					end
				end
				if self.CurrentSelected == Option then
					self.CurrentSelected = nil
					CurrentSelected = nil
					self.Label.Text = DropdownName
				end
				Refresh(SearchBox.Text)
				return self
			end

			function DropdownObject:SetSelected(Option)
				if Option == nil or table.find(self.DropdownOptions, Option) then
					self.CurrentSelected = Option
					CurrentSelected = Option
					self.Label.Text = DropdownName .. (Option and (": " .. Option) or "")
					Callback(self, Option)
					Refresh(SearchBox.Text)
				end
				return self
			end

			function DropdownObject:GetSelected()
				return self.CurrentSelected
			end

			function DropdownObject:GetOptions()
				return self.DropdownOptions
			end

			function DropdownObject:SetName(Text)
				DropdownName = Text
				self.Label.Text = DropdownName .. (self.CurrentSelected and (": " .. self.CurrentSelected) or "")
				return self
			end

			function DropdownObject:SetCallback(NewCallback)
				Callback = NewCallback
				return self
			end

			function DropdownObject:Destroy()
				self.Frame:Destroy()
			end

			function DropdownObject:UpdateTheme()
				self.Frame.BackgroundColor3 = Astral:GetElementColor("ElementBackground")
				self.Label.TextColor3 = Astral:GetElementColor("DropdownLabel")
				ArrowImage.ImageColor3 = Astral:GetElementColor("DropdownArrow")

				SearchBox.BackgroundColor3 = Astral:GetElementColor("DropdownSearchBackground")
				SearchBox.TextColor3 = Astral:GetElementColor("DropdownSearchText")
				SearchBox.PlaceholderColor3 = Astral:GetElementColor("DropdownSearchPlaceholder")

				local SearchStroke = SearchBox:FindFirstChildOfClass("UIStroke")
				if SearchStroke then
					SearchStroke.Color = Astral:GetElementColor("DropdownSearchBorder")
				end

				ClearBtn.BackgroundColor3 = Astral:GetElementColor("DropdownClearButton")
				ClearBtn.TextColor3 = Astral:GetElementColor("DropdownClearButtonText")

				self.DropdownList.ScrollBarImageColor3 = Astral:GetElementColor("ScrollBar")

				-- Refresh options with new theme colors
				if self.RefreshFunction then
					self.RefreshFunction(SearchBox.Text)
				end
			end

			table.insert(Astral.UIObjects.Elements, DropdownObject)

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
			local MultiDropdownFont = Options.Font or Astral.Config.Elements.Font
			local MultiDropdownSize = Options.Size or Astral.Config.Elements.Size
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
			DropdownFrame.BackgroundColor3 = Astral:GetElementColor("ElementBackground")
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
			DropdownLabel.TextColor3 = Astral:GetElementColor("DropdownLabel")
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
			ArrowImage.ImageColor3 = Astral:GetElementColor("DropdownArrow")

			local Header = Instance.new("Frame")
			Header.Parent = DropdownFrame
			Header.Position = UDim2.new(0, ApplyScale(BasePaddingValue), 0, ApplyScale(BaseElementHeight + BasePaddingValue))
			Header.Size = UDim2.new(1, -ApplyScale(BasePaddingValue * 2), 0, ApplyScale(BaseElementHeight))
			Header.BackgroundTransparency = 1
			Header.Visible = false

			local SearchBox = Instance.new("TextBox")
			SearchBox.Parent = Header
			SearchBox.Size = UDim2.new(1, -ApplyScale(100), 1, 0)
			SearchBox.BackgroundColor3 = Astral:GetElementColor("DropdownSearchBackground")
			SearchBox.BackgroundTransparency = Astral.Config.Elements.BackgroundTransparency
			SearchBox.PlaceholderText = "Search options..."
			SearchBox.Text = ""
			SearchBox.TextColor3 = Astral:GetElementColor("DropdownSearchText")
			SearchBox.Font = Enum.Font.Gotham
			SearchBox.TextSize = Astral.Config.Elements.MultiDropdown.SearchSize
			local SearchBoxCorner = Instance.new("UICorner")
			SearchBoxCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Elements.Dropdown.InputCornerRadius))
			SearchBoxCorner.Parent = SearchBox

			local SearchStroke = Instance.new("UIStroke")
			SearchStroke.Parent = SearchBox
			SearchStroke.Color = Astral:GetElementColor("DropdownSearchBorder")
			SearchStroke.Thickness = ApplyScale(Astral.Config.Elements.Dropdown.StrokeThickness)
			SearchStroke.Transparency = Astral.Config.Elements.Dropdown.StrokeTransparency

			local SelectAllBtn = Instance.new("TextButton")
			SelectAllBtn.Parent = Header
			SelectAllBtn.Position = UDim2.new(1, -ApplyScale(95), 0, 0)
			SelectAllBtn.Size = UDim2.new(0, ApplyScale(45), 1, 0)
			SelectAllBtn.BackgroundColor3 = Astral:GetElementColor("DropdownSelectAllButton")
			SelectAllBtn.BackgroundTransparency = Astral.Config.Elements.BackgroundTransparency
			SelectAllBtn.Text = "ALL"
			SelectAllBtn.Font = Enum.Font.GothamBold
			SelectAllBtn.TextColor3 = Astral:GetElementColor("DropdownSelectAllButtonText")
			SelectAllBtn.TextSize = Astral.Config.Elements.MultiDropdown.ButtonSize
			local SelectAllCorner = Instance.new("UICorner")
			SelectAllCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Elements.Dropdown.InputCornerRadius))
			SelectAllCorner.Parent = SelectAllBtn

			local ClearAllBtn = Instance.new("TextButton")
			ClearAllBtn.Parent = Header
			ClearAllBtn.Position = UDim2.new(1, -ApplyScale(45), 0, 0)
			ClearAllBtn.Size = UDim2.new(0, ApplyScale(45), 1, 0)
			ClearAllBtn.BackgroundColor3 = Astral:GetElementColor("DropdownClearButton")
			ClearAllBtn.BackgroundTransparency = Astral.Config.Elements.BackgroundTransparency
			ClearAllBtn.Text = "CLEAR"
			ClearAllBtn.Font = Enum.Font.GothamBold
			ClearAllBtn.TextColor3 = Astral:GetElementColor("DropdownClearButtonText")
			ClearAllBtn.TextSize = Astral.Config.Elements.MultiDropdown.ButtonSize
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
			DropdownList.ScrollBarImageColor3 = Astral:GetElementColor("ScrollBar")
			DropdownList.BorderSizePixel = 0
			DropdownList.VerticalScrollBarInset = Enum.ScrollBarInset.None
			DropdownList.HorizontalScrollBarInset = Enum.ScrollBarInset.None
			DropdownList.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
			DropdownList.Visible = false

			CreateScrollBar(DropdownList, WindowId)

			local DropdownLayout = Instance.new("UIListLayout")
			DropdownLayout.Parent = DropdownList
			DropdownLayout.Padding = UDim.new(0, ApplyScale(BasePaddingValue))

			local MultiDropdownObject = {
				Frame = DropdownFrame,
				Label = DropdownLabel,
				DropdownList = DropdownList,
				Type = "MultiDropdown",
				Selected = Selected,
				SelectionOrder = SelectionOrder,
				DropdownOptions = DropdownOptions,
				Max = Max,
				Min = Min
			}

			local function Refresh(Filter)
				for _, Child in pairs(DropdownList:GetChildren()) do
					if Child:IsA("TextButton") then Child:Destroy() end
				end
				for _, Option in pairs(MultiDropdownObject.DropdownOptions) do
					if Filter and Filter ~= "" and not string.find(string.lower(Option), string.lower(Filter)) then continue end

					local IsSelected = Selected[Option]
					local OptionButton = Instance.new("TextButton")
					OptionButton.Parent = DropdownList
					OptionButton.BackgroundColor3 = IsSelected and Astral:GetElementColor("DropdownOptionSelectedBackground") or Astral:GetElementColor("DropdownOptionBackground")
					OptionButton.BackgroundTransparency = IsSelected and 0.15 or Astral.Config.Elements.BackgroundTransparency
					OptionButton.Size = UDim2.new(1, 0, 0, Astral.Config.Elements.MultiDropdown.OptionHeight)
					OptionButton.Text = Option
					OptionButton.Font = IsSelected and Enum.Font.GothamBold or Enum.Font.Gotham
					OptionButton.TextColor3 = IsSelected and Astral:GetElementColor("DropdownOptionSelectedText") or Astral:GetElementColor("DropdownOptionText")
					OptionButton.TextSize = Astral.Config.Elements.MultiDropdown.OptionSize
					local OptionCorner = Instance.new("UICorner")
					OptionCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Elements.Dropdown.InputCornerRadius))
					OptionCorner.Parent = OptionButton

					OptionButton.MouseButton1Click:Connect(function()
						if Selected[Option] then
							if #SelectionOrder > Min then
								Selected[Option] = false
								for i, v in ipairs(SelectionOrder) do if v == Option then table.remove(SelectionOrder, i) break end end
								UpdateLabel()
								MultiDropdownObject.Selected = Selected
								MultiDropdownObject.SelectionOrder = SelectionOrder
								Refresh(SearchBox.Text)
								Callback(MultiDropdownObject, SelectionOrder)
							end
						elseif #SelectionOrder < Max then
							Selected[Option] = true
							table.insert(SelectionOrder, Option)
							UpdateLabel()
							MultiDropdownObject.Selected = Selected
							MultiDropdownObject.SelectionOrder = SelectionOrder
							Refresh(SearchBox.Text)
							Callback(MultiDropdownObject, SelectionOrder)
						end
					end)
				end
				DropdownList.CanvasSize = UDim2.new(0, 0, 0, DropdownLayout.AbsoluteContentSize.Y + ApplyScale(BasePaddingValue))
			end

			-- Store the Refresh function in the object
			MultiDropdownObject.RefreshFunction = Refresh

			SearchBox:GetPropertyChangedSignal("Text"):Connect(function() Refresh(SearchBox.Text) end)

			SelectAllBtn.MouseButton1Click:Connect(function()
				for _, Option in ipairs(MultiDropdownObject.DropdownOptions) do
					if #SelectionOrder >= Max then break end
					if not Selected[Option] then
						Selected[Option] = true
						table.insert(SelectionOrder, Option)
					end
				end
				UpdateLabel()
				MultiDropdownObject.Selected = Selected
				MultiDropdownObject.SelectionOrder = SelectionOrder
				Refresh(SearchBox.Text)
				Callback(MultiDropdownObject, SelectionOrder)
			end)

			ClearAllBtn.MouseButton1Click:Connect(function()
				while #SelectionOrder > Min do
					local removed = table.remove(SelectionOrder, 1)
					Selected[removed] = false
				end
				UpdateLabel()
				MultiDropdownObject.Selected = Selected
				MultiDropdownObject.SelectionOrder = SelectionOrder
				Refresh(SearchBox.Text)
				Callback(MultiDropdownObject, SelectionOrder)
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

			function MultiDropdownObject:Update(NewOptions)
				if NewOptions.Name then
					DropdownName = NewOptions.Name
					UpdateLabel()
				end
				if NewOptions.Callback then
					Callback = NewOptions.Callback
				end
				if NewOptions.Options then
					self.DropdownOptions = NewOptions.Options
					for i = #self.SelectionOrder, 1, -1 do
						local option = self.SelectionOrder[i]
						if not table.find(self.DropdownOptions, option) then
							self.Selected[option] = false
							Selected[option] = false
							table.remove(self.SelectionOrder, i)
							table.remove(SelectionOrder, i)
						end
					end
					UpdateLabel()
					Refresh(SearchBox.Text)
				end
				if NewOptions.Default then
					self.Selected = {}
					self.SelectionOrder = {}
					Selected = {}
					SelectionOrder = {}
					for _, v in pairs(NewOptions.Default) do
						if #self.SelectionOrder < self.Max then
							self.Selected[v] = true
							Selected[v] = true
							table.insert(self.SelectionOrder, v)
							table.insert(SelectionOrder, v)
						end
					end
					UpdateLabel()
					Refresh(SearchBox.Text)
				end
				if NewOptions.Max then
					self.Max = NewOptions.Max
					Max = NewOptions.Max
					while #self.SelectionOrder > self.Max do
						local removed = table.remove(self.SelectionOrder, 1)
						self.Selected[removed] = false
						table.remove(SelectionOrder, 1)
						Selected[removed] = false
					end
					UpdateLabel()
					Refresh(SearchBox.Text)
				end
				if NewOptions.Min then
					self.Min = NewOptions.Min
					Min = NewOptions.Min
				end
				if NewOptions.VisibleOptions then
					VisibleOptions = NewOptions.VisibleOptions
					CalculatedListHeight = (OptionHeight + OptionPadding) * VisibleOptions - OptionPadding
					if CalculatedListHeight < OptionHeight then
						CalculatedListHeight = OptionHeight
					end
					ExpandedHeight = ApplyScale(BaseElementHeight) + 
						ApplyScale(BaseElementHeight) + 
						ApplyScale(BasePaddingValue) + 
						CalculatedListHeight + 
						ApplyScale(BasePaddingValue * 2)

					self.DropdownList.Size = UDim2.new(1, -ApplyScale(BasePaddingValue * 2), 0, CalculatedListHeight)
				end
				if NewOptions.Font then
					self.Label.Font = NewOptions.Font
				end
				if NewOptions.Size then
					self.Label.TextSize = ApplyScale(NewOptions.Size)
				end
				if NewOptions.Height then
					BaseElementHeight = NewOptions.Height
					BaseTotalHeight = ApplyScale(BaseElementHeight)
					DropdownButton.Size = UDim2.new(1, 0, 0, BaseTotalHeight)
					self.Frame.Size = MultiDropdownWidth and 
						UDim2.new(0, ApplyScale(MultiDropdownWidth), 0, BaseTotalHeight) or
						UDim2.new(1, 0, 0, BaseTotalHeight)
				end
				if NewOptions.Width then
					MultiDropdownWidth = NewOptions.Width
					self.Frame.Size = UDim2.new(0, ApplyScale(MultiDropdownWidth), 0, BaseTotalHeight)
				end
				return self
			end

			function MultiDropdownObject:SetOptions(NewOptions)
				self.DropdownOptions = NewOptions
				for i = #self.SelectionOrder, 1, -1 do
					local option = self.SelectionOrder[i]
					if not table.find(self.DropdownOptions, option) then
						self.Selected[option] = false
						Selected[option] = false
						table.remove(self.SelectionOrder, i)
						table.remove(SelectionOrder, i)
					end
				end
				UpdateLabel()
				Refresh(SearchBox.Text)
				return self
			end

			function MultiDropdownObject:AddOption(Option)
				table.insert(self.DropdownOptions, Option)
				Refresh(SearchBox.Text)
				return self
			end

			function MultiDropdownObject:RemoveOption(Option)
				for i, v in ipairs(self.DropdownOptions) do
					if v == Option then
						table.remove(self.DropdownOptions, i)
						break
					end
				end
				if self.Selected[Option] then
					self.Selected[Option] = false
					Selected[Option] = false
					for i, v in ipairs(self.SelectionOrder) do
						if v == Option then
							table.remove(self.SelectionOrder, i)
							break
						end
					end
					for i, v in ipairs(SelectionOrder) do
						if v == Option then
							table.remove(SelectionOrder, i)
							break
						end
					end
					UpdateLabel()
					Callback(self, self.SelectionOrder)
				end
				Refresh(SearchBox.Text)
				return self
			end

			function MultiDropdownObject:SetSelected(Options)
				self.Selected = {}
				self.SelectionOrder = {}
				Selected = {}
				SelectionOrder = {}
				for _, v in pairs(Options) do
					if #self.SelectionOrder < self.Max then
						self.Selected[v] = true
						Selected[v] = true
						table.insert(self.SelectionOrder, v)
						table.insert(SelectionOrder, v)
					end
				end
				UpdateLabel()
				Refresh(SearchBox.Text)
				Callback(self, self.SelectionOrder)
				return self
			end

			function MultiDropdownObject:GetSelected()
				return self.SelectionOrder
			end

			function MultiDropdownObject:GetOptions()
				return self.DropdownOptions
			end

			function MultiDropdownObject:AddSelection(Option)
				if not self.Selected[Option] and #self.SelectionOrder < self.Max then
					self.Selected[Option] = true
					Selected[Option] = true
					table.insert(self.SelectionOrder, Option)
					table.insert(SelectionOrder, Option)
					UpdateLabel()
					Refresh(SearchBox.Text)
					Callback(self, self.SelectionOrder)
				end
				return self
			end

			function MultiDropdownObject:RemoveSelection(Option)
				if self.Selected[Option] and #self.SelectionOrder > self.Min then
					self.Selected[Option] = false
					Selected[Option] = false
					for i, v in ipairs(self.SelectionOrder) do
						if v == Option then
							table.remove(self.SelectionOrder, i)
							break
						end
					end
					for i, v in ipairs(SelectionOrder) do
						if v == Option then
							table.remove(SelectionOrder, i)
							break
						end
					end
					UpdateLabel()
					Refresh(SearchBox.Text)
					Callback(self, self.SelectionOrder)
				end
				return self
			end

			function MultiDropdownObject:ClearSelections()
				self.Selected = {}
				self.SelectionOrder = {}
				Selected = {}
				SelectionOrder = {}
				UpdateLabel()
				Refresh(SearchBox.Text)
				Callback(self, self.SelectionOrder)
				return self
			end

			function MultiDropdownObject:SetName(Text)
				DropdownName = Text
				UpdateLabel()
				return self
			end

			function MultiDropdownObject:SetCallback(NewCallback)
				Callback = NewCallback
				return self
			end

			function MultiDropdownObject:Destroy()
				self.Frame:Destroy()
			end

			function MultiDropdownObject:UpdateTheme()
				self.Frame.BackgroundColor3 = Astral:GetElementColor("ElementBackground")
				self.Label.TextColor3 = Astral:GetElementColor("DropdownLabel")
				ArrowImage.ImageColor3 = Astral:GetElementColor("DropdownArrow")

				SearchBox.BackgroundColor3 = Astral:GetElementColor("DropdownSearchBackground")
				SearchBox.TextColor3 = Astral:GetElementColor("DropdownSearchText")
				SearchBox.PlaceholderColor3 = Astral:GetElementColor("DropdownSearchPlaceholder")

				local SearchStroke = SearchBox:FindFirstChildOfClass("UIStroke")
				if SearchStroke then
					SearchStroke.Color = Astral:GetElementColor("DropdownSearchBorder")
				end

				SelectAllBtn.BackgroundColor3 = Astral:GetElementColor("DropdownSelectAllButton")
				SelectAllBtn.TextColor3 = Astral:GetElementColor("DropdownSelectAllButtonText")

				ClearAllBtn.BackgroundColor3 = Astral:GetElementColor("DropdownClearButton")
				ClearAllBtn.TextColor3 = Astral:GetElementColor("DropdownClearButtonText")

				self.DropdownList.ScrollBarImageColor3 = Astral:GetElementColor("ScrollBar")

				-- Refresh options with new theme colors
				if self.RefreshFunction then
					self.RefreshFunction(SearchBox.Text)
				end
			end

			table.insert(Astral.UIObjects.Elements, MultiDropdownObject)

			return MultiDropdownObject
		end

		function TabFunctions:Keybind(Options, Parent)
			Parent = Parent or PageFrame
			local KeybindName = Options.Name or "Keybind"
			local Default = Options.Default or Enum.KeyCode.E
			local Callback = Options.Callback or function() end
			local Current = Default
			local KeybindFont = Options.Font or Astral.Config.Elements.Font
			local KeybindSize = Options.Size or Astral.Config.Elements.Size
			local KeybindHeight = Options.Height or Astral.Config.Elements.Height
			local KeybindWidth = Options.Width
			local KeybindAlignment = Options.Alignment or Astral.Config.Elements.Alignment

			local KeybindFrame = Instance.new("Frame")
			KeybindFrame.Parent = Parent
			KeybindFrame.BackgroundColor3 = Astral:GetElementColor("ElementBackground")
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
			KeybindLabel.TextColor3 = Astral:GetElementColor("KeybindLabel")
			KeybindLabel.TextSize = ApplyScale(KeybindSize)
			KeybindLabel.TextXAlignment = KeybindAlignment

			local KeybindButton = Instance.new("Frame")
			KeybindButton.Parent = KeybindFrame
			KeybindButton.BackgroundColor3 = Astral:GetElementColor("KeybindButton")
			KeybindButton.BackgroundTransparency = Astral.Config.Elements.BackgroundTransparency
			KeybindButton.Position = UDim2.new(1, -ApplyScale(Astral.Config.Elements.Keybind.ButtonWidth + 12), 0.5, -ApplyScale(Astral.Config.Elements.Keybind.ButtonHeight / 2))
			KeybindButton.Size = UDim2.new(0, ApplyScale(Astral.Config.Elements.Keybind.ButtonWidth), 0, ApplyScale(Astral.Config.Elements.Keybind.ButtonHeight))

			local KeybindButtonCorner = Instance.new("UICorner")
			KeybindButtonCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Elements.Keybind.ButtonCornerRadius))
			KeybindButtonCorner.Parent = KeybindButton

			local KeybindStroke = Instance.new("UIStroke")
			KeybindStroke.Parent = KeybindButton
			KeybindStroke.Color = Astral:GetElementColor("KeybindBorder")
			KeybindStroke.Thickness = ApplyScale(Astral.Config.Elements.Keybind.StrokeThickness)
			KeybindStroke.Transparency = Astral.Config.Elements.Keybind.StrokeTransparency

			local KeybindText = Instance.new("TextButton")
			KeybindText.Parent = KeybindButton
			KeybindText.BackgroundTransparency = 1
			KeybindText.Size = UDim2.new(1, 0, 1, 0)
			KeybindText.Font = Enum.Font.GothamBold
			KeybindText.Text = Current.Name
			KeybindText.TextColor3 = Astral:GetElementColor("KeybindText")
			KeybindText.TextSize = ApplyScale(Astral.Config.Elements.Keybind.ButtonSize)
			KeybindText.AutoButtonColor = false

			local Binding = false
			KeybindText.MouseButton1Click:Connect(function()
				Binding = true
				KeybindText.Text = "..."
				KeybindText.TextColor3 = Astral.Theme.Warning
			end)

			local KeybindObject = {
				Frame = KeybindFrame,
				Label = KeybindLabel,
				Button = KeybindButton,
				Text = KeybindText,
				Type = "Keybind",
				Current = Current
			}

			UserInputService.InputBegan:Connect(function(Input, GameProcessed)
				if not GameProcessed and Binding and Input.UserInputType == Enum.UserInputType.Keyboard then
					Current = Input.KeyCode
					KeybindText.Text = Current.Name
					KeybindText.TextColor3 = Astral:GetElementColor("KeybindText")
					Binding = false
					KeybindObject.Current = Current
					Callback(KeybindObject, Current)
				elseif not GameProcessed and Input.KeyCode == Current then
					Callback(KeybindObject, Current)
				end
			end)

			function KeybindObject:Update(NewOptions)
				if NewOptions.Name then
					self.Label.Text = NewOptions.Name
				end
				if NewOptions.Callback then
					Callback = NewOptions.Callback
				end
				if NewOptions.Default then
					self.Current = NewOptions.Default
					Current = NewOptions.Default
					self.Text.Text = self.Current.Name
					self.Text.TextColor3 = Astral:GetElementColor("KeybindText")
				end
				if NewOptions.Font then
					self.Label.Font = NewOptions.Font
				end
				if NewOptions.Size then
					self.Label.TextSize = ApplyScale(NewOptions.Size)
				end
				if NewOptions.Height then
					local NewHeight = ApplyScale(NewOptions.Height)
					self.Frame.Size = KeybindWidth and 
						UDim2.new(0, ApplyScale(KeybindWidth), 0, NewHeight) or
						UDim2.new(1, 0, 0, NewHeight)
					self.Button.Position = UDim2.new(1, -ApplyScale(Astral.Config.Elements.Keybind.ButtonWidth + 12), 0.5, -ApplyScale(Astral.Config.Elements.Keybind.ButtonHeight / 2))
				end
				if NewOptions.Width then
					KeybindWidth = NewOptions.Width
					self.Frame.Size = UDim2.new(0, ApplyScale(KeybindWidth), 0, self.Frame.Size.Y.Offset)
					self.Button.Position = UDim2.new(1, -ApplyScale(Astral.Config.Elements.Keybind.ButtonWidth + 12), 0.5, -ApplyScale(Astral.Config.Elements.Keybind.ButtonHeight / 2))
				end
				if NewOptions.Alignment then
					self.Label.TextXAlignment = NewOptions.Alignment
				end
				return self
			end

			function KeybindObject:SetKey(Key)
				self.Current = Key
				Current = Key
				self.Text.Text = self.Current.Name
				self.Text.TextColor3 = Astral:GetElementColor("KeybindText")
				Callback(self, Current)
				return self
			end

			function KeybindObject:GetKey()
				return self.Current
			end

			function KeybindObject:SetText(Text)
				self.Label.Text = Text
				return self
			end

			function KeybindObject:GetText()
				return self.Label.Text
			end

			function KeybindObject:SetCallback(NewCallback)
				Callback = NewCallback
				return self
			end

			function KeybindObject:Destroy()
				self.Frame:Destroy()
			end

			function KeybindObject:UpdateTheme()
				self.Frame.BackgroundColor3 = Astral:GetElementColor("ElementBackground")
				self.Label.TextColor3 = Astral:GetElementColor("KeybindLabel")
				self.Button.BackgroundColor3 = Astral:GetElementColor("KeybindButton")
				self.Text.TextColor3 = Astral:GetElementColor("KeybindText")

				local KeybindStroke = self.Button:FindFirstChildOfClass("UIStroke")
				if KeybindStroke then
					KeybindStroke.Color = Astral:GetElementColor("KeybindBorder")
				end
			end

			table.insert(Astral.UIObjects.Elements, KeybindObject)

			return KeybindObject
		end

		function TabFunctions:Label(Options, Parent)
			Parent = Parent or PageFrame
			local LabelText = Options.Text or "Label"
			local LabelFont = Options.Font or Astral.Config.Elements.Label.Font
			local LabelSize = Options.Size or Astral.Config.Elements.Label.Size
			local LabelHeight = Options.Height
			local LabelWidth = Options.Width
			local LabelAlignment = Options.Alignment or Enum.TextXAlignment.Left
			local MaxHeight = Options.MaxHeight or ApplyScale(300)
			local MinHeight = Options.MinHeight or ApplyScale(Astral.Config.Elements.Label.Height)

			local function CalculateTextHeight(Text, Font, TextSize, MaxWidth)
				local TextService = game:GetService("TextService")
				local TextBounds = TextService:GetTextSize(
					Text,
					TextSize,
					Font,
					Vector2.new(MaxWidth, 10000)
				)
				return TextBounds.Y
			end

			local ActualWidth = LabelWidth and ApplyScale(LabelWidth) or (Parent.AbsoluteSize.X - ApplyScale(BasePadding * 2))

			local CalculatedHeight
			local IsAutoHeight = (LabelHeight == nil)

			if IsAutoHeight then
				local TextHeight = CalculateTextHeight(LabelText, LabelFont, ApplyScale(LabelSize), ActualWidth - ApplyScale(BasePadding * 2))
				CalculatedHeight = math.min(math.max(TextHeight + ApplyScale(BasePadding * 2), MinHeight), MaxHeight)
			else
				CalculatedHeight = ApplyScale(LabelHeight)
			end

			local LabelFrame = Instance.new("Frame")
			LabelFrame.Parent = Parent
			LabelFrame.BackgroundColor3 = Astral:GetElementColor("LabelBackground")
			LabelFrame.BackgroundTransparency = Astral.Config.Elements.BackgroundTransparency

			if LabelWidth then
				LabelFrame.Size = UDim2.new(0, ApplyScale(LabelWidth), 0, CalculatedHeight)
			else
				LabelFrame.Size = UDim2.new(1, 0, 0, CalculatedHeight)
			end

			local LabelCorner = Instance.new("UICorner")
			LabelCorner.CornerRadius = UDim.new(0, ApplyScale(Astral.Config.Elements.CornerRadius))
			LabelCorner.Parent = LabelFrame

			local Label = Instance.new("TextLabel")
			Label.Parent = LabelFrame
			Label.BackgroundTransparency = 1
			Label.Size = UDim2.new(1, -ApplyScale(BasePadding * 2), 1, -ApplyScale(BasePadding * 2))
			Label.Position = UDim2.new(0.5, 0, 0.5, 0)
			Label.AnchorPoint = Vector2.new(0.5, 0.5)
			Label.Font = LabelFont
			Label.Text = LabelText
			Label.TextColor3 = Astral:GetElementColor("LabelText")
			Label.TextSize = ApplyScale(LabelSize)
			Label.TextXAlignment = LabelAlignment
			Label.TextWrapped = true
			Label.TextTruncate = Enum.TextTruncate.None

			if not IsAutoHeight then
				local TextHeight = CalculateTextHeight(LabelText, LabelFont, ApplyScale(LabelSize), ActualWidth - ApplyScale(BasePadding * 2))
				if TextHeight > CalculatedHeight - ApplyScale(BasePadding * 2) then
					Label:Destroy()

					local ScrollFrame = Instance.new("ScrollingFrame")
					ScrollFrame.Parent = LabelFrame
					ScrollFrame.BackgroundTransparency = 1
					ScrollFrame.Size = UDim2.new(1, -ApplyScale(BasePadding * 2), 1, -ApplyScale(BasePadding * 2))
					ScrollFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
					ScrollFrame.AnchorPoint = Vector2.new(0.5, 0.5)
					ScrollFrame.ScrollBarThickness = 4
					ScrollFrame.ScrollBarImageColor3 = Astral:GetElementColor("LabelScrollBar")
					ScrollFrame.ScrollBarImageTransparency = 0.5
					ScrollFrame.BorderSizePixel = 0
					ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, TextHeight)

					local ScrollLabel = Instance.new("TextLabel")
					ScrollLabel.Parent = ScrollFrame
					ScrollLabel.BackgroundTransparency = 1
					ScrollLabel.Size = UDim2.new(1, 0, 0, TextHeight)
					ScrollLabel.Font = LabelFont
					ScrollLabel.Text = LabelText
					ScrollLabel.TextColor3 = Astral:GetElementColor("LabelText")
					ScrollLabel.TextSize = ApplyScale(LabelSize)
					ScrollLabel.TextXAlignment = LabelAlignment
					ScrollLabel.TextWrapped = true
					ScrollLabel.TextYAlignment = Enum.TextYAlignment.Top

					CreateScrollBar(ScrollFrame, WindowId)

					Label = ScrollLabel
				end
			end

			local LabelObject = {
				Frame = LabelFrame,
				Label = Label,
				Type = "Label",
				IsScrollable = not IsAutoHeight,
				IsAutoHeight = IsAutoHeight
			}

			local function UpdateLabelSize()
				if LabelObject.IsAutoHeight then
					local CurrentTextHeight = CalculateTextHeight(LabelObject.Label.Text, LabelObject.Label.Font, LabelObject.Label.TextSize, ActualWidth - ApplyScale(BasePadding * 2))
					local NewHeight = math.min(math.max(CurrentTextHeight + ApplyScale(BasePadding * 2), MinHeight), MaxHeight)

					LabelObject.Frame.Size = LabelWidth and 
						UDim2.new(0, ApplyScale(LabelWidth), 0, NewHeight) or
						UDim2.new(1, 0, 0, NewHeight)
				elseif LabelObject.IsScrollable then
					local ScrollFrame = LabelFrame:FindFirstChildOfClass("ScrollingFrame")
					if ScrollFrame then
						local ScrollLabel = ScrollFrame:FindFirstChildOfClass("TextLabel")
						if ScrollLabel then
							local TextHeight = CalculateTextHeight(ScrollLabel.Text, ScrollLabel.Font, ScrollLabel.TextSize, ActualWidth - ApplyScale(BasePadding * 2))
							ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, TextHeight)
							ScrollLabel.Size = UDim2.new(1, 0, 0, TextHeight)
						end
					end
				end
			end

			function LabelObject:Update(NewOptions)
				local ShouldUpdateSize = false
				local HeightChanged = false

				if NewOptions.Text then
					self.Label.Text = NewOptions.Text
					ShouldUpdateSize = true
				end
				if NewOptions.Font then
					self.Label.Font = NewOptions.Font
					ShouldUpdateSize = true
				end
				if NewOptions.Size then
					local NewSize = ApplyScale(NewOptions.Size)
					self.Label.TextSize = NewSize
					ShouldUpdateSize = true
				end
				if NewOptions.Height ~= nil then
					HeightChanged = true
					LabelHeight = NewOptions.Height
					self.IsAutoHeight = (NewOptions.Height == nil)
					self.IsScrollable = not self.IsAutoHeight

					if not self.IsAutoHeight then
						local NewHeight = ApplyScale(NewOptions.Height)
						self.Frame.Size = LabelWidth and 
							UDim2.new(0, ApplyScale(LabelWidth), 0, NewHeight) or
							UDim2.new(1, 0, 0, NewHeight)
						ShouldUpdateSize = true
					else
						ShouldUpdateSize = true
					end
				end
				if NewOptions.Width then
					LabelWidth = NewOptions.Width
					local NewWidth = ApplyScale(NewOptions.Width)
					self.Frame.Size = UDim2.new(0, NewWidth, 0, self.Frame.Size.Y.Offset)
					ActualWidth = NewWidth
					ShouldUpdateSize = true
				end
				if NewOptions.Alignment then
					self.Label.TextXAlignment = NewOptions.Alignment
				end
				if NewOptions.Color then
					self.Label.TextColor3 = NewOptions.Color
				end
				if NewOptions.MaxHeight then
					MaxHeight = ApplyScale(NewOptions.MaxHeight)
					if self.IsAutoHeight then
						ShouldUpdateSize = true
					end
				end
				if NewOptions.MinHeight then
					MinHeight = ApplyScale(NewOptions.MinHeight)
					if self.IsAutoHeight then
						ShouldUpdateSize = true
					end
				end

				if ShouldUpdateSize then
					UpdateLabelSize()
				end

				if HeightChanged and self.IsAutoHeight then
					local ScrollFrame = self.Frame:FindFirstChildOfClass("ScrollingFrame")
					if ScrollFrame then
						ScrollFrame:Destroy()

						local NewLabel = Instance.new("TextLabel")
						NewLabel.Parent = self.Frame
						NewLabel.BackgroundTransparency = 1
						NewLabel.Size = UDim2.new(1, -ApplyScale(BasePadding * 2), 1, -ApplyScale(BasePadding * 2))
						NewLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
						NewLabel.AnchorPoint = Vector2.new(0.5, 0.5)
						NewLabel.Font = self.Label.Font
						NewLabel.Text = self.Label.Text
						NewLabel.TextColor3 = self.Label.TextColor3
						NewLabel.TextSize = self.Label.TextSize
						NewLabel.TextXAlignment = self.Label.TextXAlignment
						NewLabel.TextWrapped = true
						NewLabel.TextTruncate = Enum.TextTruncate.None

						self.Label = NewLabel
					end
				end

				return self
			end

			function LabelObject:SetText(Text)
				self.Label.Text = Text
				UpdateLabelSize()
				return self
			end

			function LabelObject:GetText()
				return self.Label.Text
			end

			function LabelObject:SetFont(Font, Size, Color)
				if Font then 
					self.Label.Font = Font 
				end
				if Size then 
					self.Label.TextSize = ApplyScale(Size) 
				end
				if Color then 
					self.Label.TextColor3 = Color 
				end
				UpdateLabelSize()
				return self
			end

			function LabelObject:Destroy()
				self.Frame:Destroy()
			end

			function LabelObject:UpdateTheme()
				self.Frame.BackgroundColor3 = Astral:GetElementColor("LabelBackground")
				self.Label.TextColor3 = Astral:GetElementColor("LabelText")

				if self.IsScrollable then
					local ScrollFrame = self.Frame:FindFirstChildOfClass("ScrollingFrame")
					if ScrollFrame then
						ScrollFrame.ScrollBarImageColor3 = Astral:GetElementColor("LabelScrollBar")
					end
				end
			end

			table.insert(Astral.UIObjects.Elements, LabelObject)

			return LabelObject
		end

		return TabFunctions
	end

	local WindowData = {
		Window = {
			MainFrame = MainFrame,
			ScreenGui = ScreenGui,
			Functions = WindowFunctions
		},
		Id = WindowId
	}
	table.insert(Astral.UIObjects.Windows, WindowData)

	return WindowFunctions
end

return Astral
