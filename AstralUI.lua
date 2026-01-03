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

local function ApplyPadding(Parent, Padding)
	if type(Padding) == "table" then
		local Pad = Instance.new("UIPadding")
		Pad.Parent = Parent
		Pad.PaddingTop = UDim.new(0, Padding.Top or 0)
		Pad.PaddingRight = UDim.new(0, Padding.Right or 0)
		Pad.PaddingBottom = UDim.new(0, Padding.Bottom or 0)
		Pad.PaddingLeft = UDim.new(0, Padding.Left or 0)
		return Pad
	else
		local Pad = Instance.new("UIPadding")
		Pad.Parent = Parent
		Pad.PaddingTop = UDim.new(0, Padding)
		Pad.PaddingRight = UDim.new(0, Padding)
		Pad.PaddingBottom = UDim.new(0, Padding)
		Pad.PaddingLeft = UDim.new(0, Padding)
		return Pad
	end
end

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
				ScrollBarImageTransparency = 0.3
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

function Astral:Window(Options)
	local Name = Options.Name or "Astral"
	local Scale = Options.Scale or 1

	local function ApplyScale(value)
		return value * Scale
	end

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "AstralUI"
	ScreenGui.Parent = TargetParent
	ScreenGui.DisplayOrder = 999
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.ResetOnSpawn = false

	local NotificationQueue = {}
	local ActiveNotifications = {}
	local MaxNotifications = 5

	local BaseWidth = 580
	local BaseHeight = 420
	local BasePadding = 8
	local ElementHeight = 34
	local TopbarHeight = 36
	local ButtonSize = 26

	local CurrentWidth = ApplyScale(BaseWidth)
	local CurrentHeight = ApplyScale(BaseHeight)

	local MainFrame = Instance.new("Frame")
	MainFrame.Parent = ScreenGui
	MainFrame.BackgroundColor3 = Astral.Theme.Main
	MainFrame.BackgroundTransparency = 0.15
	MainFrame.Position = UDim2.new(0.5, -CurrentWidth / 2, 0.5, -CurrentHeight / 2)
	MainFrame.Size = UDim2.new(0, CurrentWidth, 0, CurrentHeight)
	MainFrame.ClipsDescendants = true
	MainFrame.Active = true

	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0, ApplyScale(12))
	MainCorner.Parent = MainFrame

	local MainStroke = Instance.new("UIStroke")
	MainStroke.Color = Astral.Theme.Stroke
	MainStroke.Thickness = ApplyScale(1.5)
	MainStroke.Transparency = 0.4
	MainStroke.Parent = MainFrame

	local TopbarFrame = Instance.new("Frame")
	TopbarFrame.Name = "Topbar"
	TopbarFrame.Parent = MainFrame
	TopbarFrame.BackgroundColor3 = Astral.Theme.Tertiary
	TopbarFrame.BackgroundTransparency = 0.2
	TopbarFrame.Position = UDim2.new(0, ApplyScale(BasePadding), 0, ApplyScale(BasePadding))
	TopbarFrame.Size = UDim2.new(1, -ApplyScale(88), 0, ApplyScale(TopbarHeight))
	TopbarFrame.ZIndex = 5

	local TopbarCorner = Instance.new("UICorner")
	TopbarCorner.CornerRadius = UDim.new(0, ApplyScale(8))
	TopbarCorner.Parent = TopbarFrame

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Parent = TopbarFrame
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Size = UDim2.new(1, 0, 1, 0)
	ApplyPadding(TitleLabel, ApplyScale(BasePadding))
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.Text = Name
	TitleLabel.TextColor3 = Astral.Theme.Text
	TitleLabel.TextSize = ApplyScale(14)
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

	MakeDraggable(TopbarFrame, MainFrame)

	local ControlsFrame = Instance.new("Frame")
	ControlsFrame.Parent = MainFrame
	ControlsFrame.BackgroundTransparency = 1
	ControlsFrame.Position = UDim2.new(1, -ApplyScale(88), 0, ApplyScale(BasePadding))
	ControlsFrame.Size = UDim2.new(0, ApplyScale(80), 0, ApplyScale(TopbarHeight))
	ControlsFrame.ZIndex = 10

	local function MakeButton(Text, Position, Color)
		local Button = Instance.new("TextButton")
		Button.Parent = ControlsFrame
		Button.BackgroundColor3 = Astral.Theme.Tertiary
		Button.BackgroundTransparency = 0.25
		Button.Position = Position
		Button.Size = UDim2.new(0, ApplyScale(ButtonSize), 0, ApplyScale(ButtonSize))
		Button.AutoButtonColor = false
		Button.Font = Enum.Font.GothamBold
		Button.Text = Text
		Button.TextColor3 = Color
		Button.TextSize = ApplyScale(14)
		Button.ZIndex = 11

		local ButtonCorner = Instance.new("UICorner")
		ButtonCorner.CornerRadius = UDim.new(0, ApplyScale(6))
		ButtonCorner.Parent = Button

		AddHoverEffect(Button, Astral.Theme.HoverBright, Astral.Theme.Tertiary, 0.15, 0.25)
		AddClickEffect(Button)
		return Button
	end

	local CloseButton = MakeButton("×", UDim2.new(1, -ApplyScale(ButtonSize + BasePadding), 0.5, -ApplyScale(ButtonSize / 2)), Astral.Theme.Error)
	CloseButton.TextSize = ApplyScale(18)
	CloseButton.MouseButton1Click:Connect(function()
		local Tween = TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 0, 0, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0)
		})
		Tween:Play()
		task.wait(0.25)
		ScreenGui:Destroy()
	end)

	local MinimizeButton = MakeButton("−", UDim2.new(1, -ApplyScale(ButtonSize * 2 + BasePadding * 1.5), 0.5, -ApplyScale(ButtonSize / 2)), Astral.Theme.TextDark)
	MinimizeButton.TextSize = ApplyScale(16)
	MinimizeButton.MouseButton1Click:Connect(function()
		MainFrame.Visible = not MainFrame.Visible
	end)

	local Bubble = Instance.new("TextButton")
	Bubble.Name = "AstralBubble"
	Bubble.Parent = ScreenGui
	Bubble.BackgroundColor3 = Astral.Theme.Main
	Bubble.Position = UDim2.new(1, -ApplyScale(70), 0.5, -ApplyScale(25))
	Bubble.Size = UDim2.new(0, ApplyScale(50), 0, ApplyScale(50))
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
	BubbleIcon.Image = Options.Icon or "rbxassetid://7733954760"
	BubbleIcon.ImageColor3 = Astral.Theme.Accent
	BubbleIcon.ScaleType = Enum.ScaleType.Fit

	local BubbleStroke = Instance.new("UIStroke")
	BubbleStroke.Thickness = ApplyScale(2)
	BubbleStroke.Color = Astral.Theme.Stroke
	BubbleStroke.Transparency = 0.3
	BubbleStroke.Parent = Bubble

	local BubbleDragging = false
	local DragInput, DragStart, StartPos

	local function SnapToSide()
		local ScreenSize = ScreenGui.AbsoluteSize
		local CurrentPos = Bubble.AbsolutePosition
		local CenterX = ScreenSize.X / 2

		local TargetX = (CurrentPos.X + ApplyScale(25) < CenterX) and ApplyScale(15) or (ScreenSize.X - ApplyScale(65))
		local TargetY = math.clamp(CurrentPos.Y, ApplyScale(15), ScreenSize.Y - ApplyScale(65))

		if TargetY < ApplyScale(100) then TargetY = ApplyScale(15) end
		if TargetY > ScreenSize.Y - ApplyScale(165) then TargetY = ScreenSize.Y - ApplyScale(65) end

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
		if (StartPos.X.Offset - Bubble.Position.X.Offset) < ApplyScale(5) then
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
	SidebarFrame.BackgroundTransparency = 0.2
	SidebarFrame.Position = UDim2.new(0, ApplyScale(BasePadding), 0, 0)
	SidebarFrame.Size = UDim2.new(0, ApplyScale(130), 1, -ApplyScale(BasePadding))

	local SidebarCorner = Instance.new("UICorner")
	SidebarCorner.CornerRadius = UDim.new(0, ApplyScale(8))
	SidebarCorner.Parent = SidebarFrame

	local SidebarStroke = Instance.new("UIStroke")
	SidebarStroke.Color = Astral.Theme.StrokeDark
	SidebarStroke.Thickness = ApplyScale(1)
	SidebarStroke.Transparency = 0.4
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
	TabLayout.Padding = UDim.new(0, ApplyScale(BasePadding))
	TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		TabContainer.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + ApplyScale(BasePadding))
	end)

	local PagesFrame = Instance.new("Frame")
	PagesFrame.Parent = ContentFrame
	PagesFrame.BackgroundColor3 = Astral.Theme.Secondary
	PagesFrame.BackgroundTransparency = 0.2
	PagesFrame.Position = UDim2.new(0, ApplyScale(130 + BasePadding * 2), 0, 0)
	PagesFrame.Size = UDim2.new(1, -ApplyScale(130 + BasePadding * 3), 1, -ApplyScale(BasePadding))

	local PagesCorner = Instance.new("UICorner")
	PagesCorner.CornerRadius = UDim.new(0, ApplyScale(8))
	PagesCorner.Parent = PagesFrame

	local PagesContainer = Instance.new("Frame")
	PagesContainer.Parent = PagesFrame
	PagesContainer.BackgroundTransparency = 1
	PagesContainer.Size = UDim2.new(1, 0, 1, 0)
	local PagesPadding = Instance.new("UIPadding")
	PagesPadding.Parent = PagesContainer
	PagesPadding.PaddingTop = UDim.new(0, ApplyScale(BasePadding))
	PagesPadding.PaddingRight = UDim.new(0, ApplyScale(BasePadding))
	PagesPadding.PaddingLeft = UDim.new(0, ApplyScale(BasePadding))
	PagesPadding.PaddingBottom = UDim.new(0, ApplyScale(BasePadding))
	PagesContainer.ClipsDescendants = true

	local WindowFunctions = {}
	local FirstTab = true
	local AllTabs = {}

	local function UpdateNotificationPositions()
		for Index, Notification in ipairs(ActiveNotifications) do
			local TargetYOffset = -ApplyScale(20) - ((Index - 1) * ApplyScale(80))
			TweenService:Create(Notification, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
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

		local ExitTween = TweenService:Create(NotificationFrame, TweenInfo.new(0.3), {
			Position = UDim2.new(1, ApplyScale(20), NotificationFrame.Position.Y.Scale, NotificationFrame.Position.Y.Offset)
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
		NotificationFrame.BackgroundTransparency = 0.15
		NotificationFrame.Size = UDim2.new(0, ApplyScale(300), 0, ApplyScale(70))
		NotificationFrame.AnchorPoint = Vector2.new(1, 1)
		NotificationFrame.Position = UDim2.new(1.5, 0, 1, -ApplyScale(20))
		NotificationFrame.ZIndex = 100

		local NotificationCorner = Instance.new("UICorner")
		NotificationCorner.CornerRadius = UDim.new(0, ApplyScale(8))
		NotificationCorner.Parent = NotificationFrame

		local NotificationStroke = Instance.new("UIStroke")
		NotificationStroke.Color = TypeColors[Type]
		NotificationStroke.Thickness = ApplyScale(1.5)
		NotificationStroke.Transparency = 0.4
		NotificationStroke.Parent = NotificationFrame

		local NotificationTitle = Instance.new("TextLabel")
		NotificationTitle.Parent = NotificationFrame
		NotificationTitle.BackgroundTransparency = 1
		NotificationTitle.Size = UDim2.new(1, 0, 0, ApplyScale(18))
		ApplyPadding(NotificationTitle, ApplyScale(BasePadding))
		NotificationTitle.Font = Enum.Font.GothamBold
		NotificationTitle.Text = Title
		NotificationTitle.TextColor3 = Astral.Theme.Text
		NotificationTitle.TextSize = ApplyScale(13)
		NotificationTitle.TextXAlignment = Enum.TextXAlignment.Left

		local NotificationContent = Instance.new("TextLabel")
		NotificationContent.Parent = NotificationFrame
		NotificationContent.BackgroundTransparency = 1
		NotificationContent.Position = UDim2.new(0, 0, 0, ApplyScale(28))
		NotificationContent.Size = UDim2.new(1, 0, 1, -ApplyScale(36))
		ApplyPadding(NotificationContent, ApplyScale(BasePadding))
		NotificationContent.Font = Enum.Font.Gotham
		NotificationContent.Text = Content
		NotificationContent.TextColor3 = Astral.Theme.TextDark
		NotificationContent.TextSize = ApplyScale(11)
		NotificationContent.TextXAlignment = Enum.TextXAlignment.Left
		NotificationContent.TextYAlignment = Enum.TextYAlignment.Top
		NotificationContent.TextWrapped = true

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

	function WindowFunctions:SetScale(newScale)
		if newScale <= 0 then return end

		CurrentWidth = ApplyScale(BaseWidth)
		CurrentHeight = ApplyScale(BaseHeight)

		Scale = newScale

		TweenService:Create(MainFrame, TweenInfo.new(0.3), {
			Size = UDim2.new(0, CurrentWidth, 0, CurrentHeight),
			Position = UDim2.new(0.5, -CurrentWidth/2, 0.5, -CurrentHeight/2)
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
		TabButton.BackgroundTransparency = 0.25
		TabButton.Size = UDim2.new(1, 0, 0, ApplyScale(ElementHeight))
		TabButton.AutoButtonColor = false
		TabButton.Text = ""

		local TabButtonCorner = Instance.new("UICorner")
		TabButtonCorner.CornerRadius = UDim.new(0, ApplyScale(8))
		TabButtonCorner.Parent = TabButton

		local IconImage = Instance.new("ImageLabel")
		IconImage.Parent = TabButton
		IconImage.BackgroundTransparency = 1
		IconImage.Position = UDim2.new(0, ApplyScale(BasePadding), 0.5, -ApplyScale(8))
		IconImage.Size = UDim2.new(0, ApplyScale(16), 0, ApplyScale(16))
		IconImage.Image = TabIcon
		IconImage.ImageColor3 = Astral.Theme.TextDark

		local LabelText = Instance.new("TextLabel")
		LabelText.Parent = TabButton
		LabelText.BackgroundTransparency = 1
		LabelText.Position = UDim2.new(0, ApplyScale(30), 0, 0)
		LabelText.Size = UDim2.new(1, -ApplyScale(35), 1, 0)
		LabelText.Font = Enum.Font.GothamMedium
		LabelText.Text = TabName
		LabelText.TextColor3 = Astral.Theme.TextDark
		LabelText.TextSize = ApplyScale(11)
		LabelText.TextXAlignment = Enum.TextXAlignment.Left

		local IndicatorFrame = Instance.new("Frame")
		IndicatorFrame.Name = "Indicator"
		IndicatorFrame.Parent = TabButton
		IndicatorFrame.BackgroundColor3 = Astral.Theme.Accent
		IndicatorFrame.BorderSizePixel = 0
		IndicatorFrame.Position = UDim2.new(0, ApplyScale(2), 0.5, -ApplyScale(8))
		IndicatorFrame.Size = UDim2.new(0, ApplyScale(2), 0, ApplyScale(16))
		IndicatorFrame.Visible = false

		AddHoverEffect(TabButton, Astral.Theme.HoverBright, Astral.Theme.Main, 0.2, 0.3)
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
		ApplyPadding(PageFrame, ApplyScale(BasePadding))

		local PageLayout = Instance.new("UIListLayout")
		PageLayout.Parent = PageFrame
		PageLayout.Padding = UDim.new(0, ApplyScale(BasePadding))
		PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			PageFrame.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + ApplyScale(BasePadding * 2))
		end)

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
					BackgroundTransparency = 0.25
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

		function TabFunctions:Section(Options)
			local SectionName = Options.Name or "Section"

			local SectionFrame = Instance.new("Frame")
			SectionFrame.Parent = PageFrame
			SectionFrame.BackgroundColor3 = Astral.Theme.Tertiary
			SectionFrame.BackgroundTransparency = 0.25
			SectionFrame.Size = UDim2.new(1, 0, 0, 0)
			SectionFrame.AutomaticSize = Enum.AutomaticSize.Y

			local SectionCorner = Instance.new("UICorner")
			SectionCorner.CornerRadius = UDim.new(0, ApplyScale(8))
			SectionCorner.Parent = SectionFrame

			local HeaderFrame = Instance.new("Frame")
			HeaderFrame.Parent = SectionFrame
			HeaderFrame.BackgroundColor3 = Astral.Theme.Main
			HeaderFrame.BackgroundTransparency = 0.2
			HeaderFrame.Size = UDim2.new(1, 0, 0, ApplyScale(ElementHeight))

			local HeaderCorner = Instance.new("UICorner")
			HeaderCorner.CornerRadius = UDim.new(0, ApplyScale(8))
			HeaderCorner.Parent = HeaderFrame

			local SectionLabel = Instance.new("TextLabel")
			SectionLabel.Parent = HeaderFrame
			SectionLabel.BackgroundTransparency = 1
			SectionLabel.Size = UDim2.new(1, 0, 1, 0)
			ApplyPadding(SectionLabel, ApplyScale(BasePadding))
			SectionLabel.Font = Enum.Font.GothamBold
			SectionLabel.Text = SectionName
			SectionLabel.TextColor3 = Astral.Theme.Text
			SectionLabel.TextSize = ApplyScale(13)
			SectionLabel.TextXAlignment = Enum.TextXAlignment.Left

			local SectionContent = Instance.new("Frame")
			SectionContent.Parent = SectionFrame
			SectionContent.BackgroundTransparency = 1
			SectionContent.Position = UDim2.new(0, 0, 0, ApplyScale(ElementHeight))
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

			local ButtonFrame = Instance.new("TextButton")
			ButtonFrame.Parent = Parent
			ButtonFrame.BackgroundColor3 = Astral.Theme.Main
			ButtonFrame.BackgroundTransparency = 0.25
			ButtonFrame.Size = UDim2.new(1, 0, 0, ApplyScale(ElementHeight))
			ButtonFrame.AutoButtonColor = false
			ButtonFrame.Text = ""

			local ButtonCorner = Instance.new("UICorner")
			ButtonCorner.CornerRadius = UDim.new(0, ApplyScale(6))
			ButtonCorner.Parent = ButtonFrame

			local ButtonLabel = Instance.new("TextLabel")
			ButtonLabel.Parent = ButtonFrame
			ButtonLabel.BackgroundTransparency = 1
			ButtonLabel.Size = UDim2.new(1, 0, 1, 0)
			ApplyPadding(ButtonLabel, ApplyScale(BasePadding))
			ButtonLabel.Font = Enum.Font.GothamMedium
			ButtonLabel.Text = ButtonName
			ButtonLabel.TextColor3 = Astral.Theme.Text
			ButtonLabel.TextSize = ApplyScale(12)
			ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left

			AddHoverEffect(ButtonFrame, Astral.Theme.HoverBright, Astral.Theme.Main, 0.15, 0.25)
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
			ToggleFrame.BackgroundTransparency = 0.25
			ToggleFrame.Size = UDim2.new(1, 0, 0, ApplyScale(ElementHeight))
			ToggleFrame.ClipsDescendants = true

			local ToggleCorner = Instance.new("UICorner")
			ToggleCorner.CornerRadius = UDim.new(0, ApplyScale(6))
			ToggleCorner.Parent = ToggleFrame

			local ToggleLabel = Instance.new("TextLabel")
			ToggleLabel.Parent = ToggleFrame
			ToggleLabel.BackgroundTransparency = 1
			ToggleLabel.Size = UDim2.new(1, 0, 1, 0)
			ApplyPadding(ToggleLabel, ApplyScale(BasePadding))
			ToggleLabel.Font = Enum.Font.GothamMedium
			ToggleLabel.Text = ToggleName
			ToggleLabel.TextColor3 = Astral.Theme.Text
			ToggleLabel.TextSize = ApplyScale(12)
			ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left

			local CheckButton = Instance.new("TextButton")
			CheckButton.Parent = ToggleFrame
			CheckButton.BackgroundColor3 = State and Astral.Theme.Accent or Astral.Theme.Tertiary
			CheckButton.Position = UDim2.new(1, -ApplyScale(46), 0.5, -ApplyScale(9))
			CheckButton.Size = UDim2.new(0, ApplyScale(38), 0, ApplyScale(18))
			CheckButton.AutoButtonColor = false
			CheckButton.Text = ""

			local CheckCorner = Instance.new("UICorner")
			CheckCorner.CornerRadius = UDim.new(1, 0)
			CheckCorner.Parent = CheckButton

			local CircleFrame = Instance.new("Frame")
			CircleFrame.Parent = CheckButton
			CircleFrame.BackgroundColor3 = Astral.Theme.Text
			CircleFrame.Size = UDim2.new(0, ApplyScale(14), 0, ApplyScale(14))
			CircleFrame.Position = State and UDim2.new(1, -ApplyScale(16), 0.5, -ApplyScale(7)) or UDim2.new(0, ApplyScale(2), 0.5, -ApplyScale(7))

			local CircleCorner = Instance.new("UICorner")
			CircleCorner.CornerRadius = UDim.new(1, 0)
			CircleCorner.Parent = CircleFrame

			local function Update()
				local Position = State and UDim2.new(1, -ApplyScale(16), 0.5, -ApplyScale(7)) or UDim2.new(0, ApplyScale(2), 0.5, -ApplyScale(7))
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
			SliderFrame.BackgroundTransparency = 0.25
			SliderFrame.Size = UDim2.new(1, 0, 0, ApplyScale(50))
			SliderFrame.ClipsDescendants = true

			local SliderCorner = Instance.new("UICorner")
			SliderCorner.CornerRadius = UDim.new(0, ApplyScale(6))
			SliderCorner.Parent = SliderFrame

			local SliderLabel = Instance.new("TextLabel")
			SliderLabel.Parent = SliderFrame
			SliderLabel.BackgroundTransparency = 1
			SliderLabel.Size = UDim2.new(1, 0, 0, ApplyScale(16))
			ApplyPadding(SliderLabel, ApplyScale(BasePadding))
			SliderLabel.Font = Enum.Font.GothamMedium
			SliderLabel.Text = SliderName
			SliderLabel.TextColor3 = Astral.Theme.Text
			SliderLabel.TextSize = ApplyScale(12)
			SliderLabel.TextXAlignment = Enum.TextXAlignment.Left

			local ValueInput = Instance.new("TextBox")
			ValueInput.Parent = SliderFrame
			ValueInput.BackgroundColor3 = Astral.Theme.Tertiary
			ValueInput.BackgroundTransparency = 0.25
			ValueInput.Position = UDim2.new(1, -ApplyScale(60), 0, ApplyScale(4))
			ValueInput.Size = UDim2.new(0, ApplyScale(48), 0, ApplyScale(20))
			ValueInput.Font = Enum.Font.GothamBold
			ValueInput.Text = tostring(Value)
			ValueInput.TextColor3 = Astral.Theme.Accent
			ValueInput.TextSize = ApplyScale(11)
			ValueInput.ClearTextOnFocus = false

			local InputStroke = Instance.new("UIStroke")
			InputStroke.Parent = ValueInput
			InputStroke.Color = Astral.Theme.Stroke
			InputStroke.Thickness = ApplyScale(1)
			InputStroke.Transparency = 0.5

			local BackgroundFrame = Instance.new("Frame")
			BackgroundFrame.Parent = SliderFrame
			BackgroundFrame.BackgroundColor3 = Astral.Theme.Tertiary
			BackgroundFrame.Position = UDim2.new(0, ApplyScale(BasePadding), 1, -ApplyScale(18))
			BackgroundFrame.Size = UDim2.new(1, -ApplyScale(BasePadding * 2), 0, ApplyScale(6))

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
			BallFrame.Size = UDim2.new(0, ApplyScale(14), 0, ApplyScale(14))
			BallFrame.Position = UDim2.new((Value - Min) / (Max - Min), -ApplyScale(7), 0.5, -ApplyScale(7))
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
				TweenService:Create(BallFrame, TweenInfo.new(0.05), {Position = UDim2.new(VisualPercentage, -ApplyScale(7), 0.5, -ApplyScale(7))}):Play()

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
					TweenService:Create(BallFrame, TweenInfo.new(0.2), {Position = UDim2.new(VisualPercentage, -ApplyScale(7), 0.5, -ApplyScale(7))}):Play()
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
			TextBoxFrame.BackgroundTransparency = 0.25
			TextBoxFrame.Size = UDim2.new(1, 0, 0, ApplyScale(44))
			TextBoxFrame.ClipsDescendants = true

			local TextBoxCorner = Instance.new("UICorner")
			TextBoxCorner.CornerRadius = UDim.new(0, ApplyScale(6))
			TextBoxCorner.Parent = TextBoxFrame

			local TextBoxLabel = Instance.new("TextLabel")
			TextBoxLabel.Parent = TextBoxFrame
			TextBoxLabel.BackgroundTransparency = 1
			TextBoxLabel.Size = UDim2.new(1, 0, 0, ApplyScale(16))
			ApplyPadding(TextBoxLabel, ApplyScale(BasePadding))
			TextBoxLabel.Font = Enum.Font.GothamMedium
			TextBoxLabel.Text = TextBoxName
			TextBoxLabel.TextColor3 = Astral.Theme.Text
			TextBoxLabel.TextSize = ApplyScale(12)
			TextBoxLabel.TextXAlignment = Enum.TextXAlignment.Left

			local InputBox = Instance.new("TextBox")
			InputBox.Parent = TextBoxFrame
			InputBox.BackgroundColor3 = Astral.Theme.Tertiary
			InputBox.BackgroundTransparency = 0.25
			InputBox.Position = UDim2.new(0, ApplyScale(BasePadding), 0, ApplyScale(24))
			InputBox.Size = UDim2.new(1, -ApplyScale(BasePadding * 2), 0, ApplyScale(16))
			InputBox.Font = Enum.Font.Gotham
			InputBox.PlaceholderText = Placeholder
			InputBox.PlaceholderColor3 = Astral.Theme.TextDarker
			InputBox.Text = Default
			InputBox.TextColor3 = Astral.Theme.Text
			InputBox.TextSize = ApplyScale(11)
			InputBox.TextXAlignment = Enum.TextXAlignment.Left
			InputBox.ClearTextOnFocus = false

			local InputCorner = Instance.new("UICorner")
			InputCorner.CornerRadius = UDim.new(0, ApplyScale(4))
			InputCorner.Parent = InputBox

			local InputStroke = Instance.new("UIStroke")
			InputStroke.Parent = InputBox
			InputStroke.Color = Astral.Theme.Stroke
			InputStroke.Thickness = ApplyScale(1)
			InputStroke.Transparency = 0.5

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

			local BaseElementHeight = ApplyScale(ElementHeight)
			local ItemHeight = ApplyScale(22) -- Smaller base size for items
			local ItemPadding = ApplyScale(3) -- Tighter padding
			local HeaderHeight = ApplyScale(28) -- Compact header
			local ListMaxHeight = ApplyScale(110) -- Restrict total height
			
			local DropdownFrame = Instance.new("Frame")
			DropdownFrame.Parent = Parent
			DropdownFrame.BackgroundColor3 = Astral.Theme.Main
			DropdownFrame.BackgroundTransparency = 0.25
			DropdownFrame.Size = UDim2.new(1, 0, 0, BaseElementHeight)
			DropdownFrame.ClipsDescendants = true
			
			local DropdownCorner = Instance.new("UICorner")
			DropdownCorner.CornerRadius = UDim.new(0, ApplyScale(6))
			DropdownCorner.Parent = DropdownFrame

			local DropdownButton = Instance.new("TextButton")
			DropdownButton.Parent = DropdownFrame
			DropdownButton.BackgroundTransparency = 1
			DropdownButton.Size = UDim2.new(1, 0, 0, BaseElementHeight)
			DropdownButton.Text = ""

			local DropdownLabel = Instance.new("TextLabel")
			DropdownLabel.Parent = DropdownButton
			DropdownLabel.Size = UDim2.new(1, -ApplyScale(30), 1, 0)
			ApplyPadding(DropdownLabel, ApplyScale(BasePadding))
			DropdownLabel.Font = Enum.Font.GothamMedium
			DropdownLabel.Text = DropdownName .. (CurrentSelected and (": " .. tostring(CurrentSelected)) or "")
			DropdownLabel.TextColor3 = Astral.Theme.Text
			DropdownLabel.TextSize = ApplyScale(12)
			DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
			DropdownLabel.TextTruncate = Enum.TextTruncate.AtEnd
			DropdownLabel.BackgroundTransparency = 1

			local ArrowImage = Instance.new("ImageLabel")
			ArrowImage.Parent = DropdownButton
			ArrowImage.BackgroundTransparency = 1
			ArrowImage.Position = UDim2.new(1, -ApplyScale(26), 0.5, -ApplyScale(6))
			ArrowImage.Size = UDim2.new(0, ApplyScale(12), 0, ApplyScale(12))
			ArrowImage.Image = "rbxassetid://6031091004"
			ArrowImage.ImageColor3 = Astral.Theme.Accent

			-- Header Container
			local Header = Instance.new("Frame")
			Header.Parent = DropdownFrame
			Header.Position = UDim2.new(0, ApplyScale(BasePadding), 0, BaseElementHeight)
			Header.Size = UDim2.new(1, -ApplyScale(BasePadding * 2), 0, HeaderHeight)
			Header.BackgroundTransparency = 1
			Header.Visible = false

			local SearchBox = Instance.new("TextBox")
			SearchBox.Parent = Header
			SearchBox.Size = UDim2.new(1, -ApplyScale(50), 1, -ApplyScale(6))
			SearchBox.Position = UDim2.new(0, 0, 0, 0)
			SearchBox.BackgroundColor3 = Astral.Theme.Tertiary
			SearchBox.BackgroundTransparency = 0.25
			SearchBox.PlaceholderText = "Search..."
			SearchBox.Text = ""
			SearchBox.TextColor3 = Astral.Theme.Text
			SearchBox.Font = Enum.Font.Gotham
			SearchBox.TextSize = ApplyScale(11)
			SearchBox.TextXAlignment = Enum.TextXAlignment.Left
			
			local SearchPadding = Instance.new("UIPadding")
			SearchPadding.Parent = SearchBox
			SearchPadding.PaddingLeft = UDim.new(0, ApplyScale(6))

			local SearchBoxCorner = Instance.new("UICorner")
			SearchBoxCorner.CornerRadius = UDim.new(0, ApplyScale(4))
			SearchBoxCorner.Parent = SearchBox

			local SearchStroke = Instance.new("UIStroke")
			SearchStroke.Parent = SearchBox
			SearchStroke.Color = Astral.Theme.Stroke
			SearchStroke.Thickness = ApplyScale(1)
			SearchStroke.Transparency = 0.5

			local ClearBtn = Instance.new("TextButton")
			ClearBtn.Parent = Header
			ClearBtn.Position = UDim2.new(1, -ApplyScale(45), 0, 0)
			ClearBtn.Size = UDim2.new(0, ApplyScale(45), 1, -ApplyScale(6))
			ClearBtn.BackgroundColor3 = Astral.Theme.Error
			ClearBtn.BackgroundTransparency = 0.25
			ClearBtn.Text = "CLEAR"
			ClearBtn.Font = Enum.Font.GothamBold
			ClearBtn.TextColor3 = Astral.Theme.Text
			ClearBtn.TextSize = ApplyScale(9)
			
			local ClearBtnCorner = Instance.new("UICorner")
			ClearBtnCorner.CornerRadius = UDim.new(0, ApplyScale(4))
			ClearBtnCorner.Parent = ClearBtn

			local DropdownList = Instance.new("ScrollingFrame")
			DropdownList.Parent = DropdownFrame
			DropdownList.BackgroundTransparency = 1
			DropdownList.Position = UDim2.new(0, ApplyScale(BasePadding), 0, BaseElementHeight + HeaderHeight)
			DropdownList.Size = UDim2.new(1, -ApplyScale(BasePadding * 2), 0, 0)
			DropdownList.ScrollBarThickness = 2
			DropdownList.ScrollBarImageTransparency = 0.5
			DropdownList.BorderSizePixel = 0
			DropdownList.ScrollBarImageColor3 = Astral.Theme.Accent
			DropdownList.VerticalScrollBarInset = Enum.ScrollBarInset.None
			DropdownList.HorizontalScrollBarInset = Enum.ScrollBarInset.None
			DropdownList.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
			DropdownList.ScrollingEnabled = false
			DropdownList.Visible = false
			
			local DropdownLayout = Instance.new("UIListLayout")
			DropdownLayout.Parent = DropdownList
			DropdownLayout.Padding = UDim.new(0, ItemPadding)

			local function UpdateHeight(Count)
				if not Dropped then 
					TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, BaseElementHeight)}):Play()
					return 
				end

				-- Calculate exact height based on count to avoid layout lag
				local CalculatedContentHeight = (Count * ItemHeight) + (math.max(0, Count - 1) * ItemPadding)
				local ViewableHeight = math.min(CalculatedContentHeight, ListMaxHeight)
				local TotalHeight = BaseElementHeight + HeaderHeight + ViewableHeight + ApplyScale(BasePadding)
				
				DropdownList.Size = UDim2.new(1, -ApplyScale(BasePadding * 2), 0, ViewableHeight)
				DropdownList.CanvasSize = UDim2.new(0, 0, 0, CalculatedContentHeight)
				DropdownList.ScrollingEnabled = CalculatedContentHeight > ListMaxHeight

				TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, TotalHeight)}):Play()
				CenterElement(PageFrame, DropdownFrame, TotalHeight)
			end

			local function Refresh(filter)
				for _, Child in pairs(DropdownList:GetChildren()) do
					if Child:IsA("TextButton") then Child:Destroy() end
				end
				
				local Count = 0
				for _, Option in pairs(DropdownOptions) do
					if filter and filter ~= "" and not string.find(string.lower(Option), string.lower(filter)) then continue end
					Count = Count + 1

					local IsSelected = (CurrentSelected == Option)
					local OptionButton = Instance.new("TextButton")
					OptionButton.Parent = DropdownList
					OptionButton.BackgroundColor3 = IsSelected and Astral.Theme.Accent or Astral.Theme.Tertiary
					OptionButton.BackgroundTransparency = IsSelected and 0.2 or 0.5
					OptionButton.Size = UDim2.new(1, 0, 0, ItemHeight)
					OptionButton.Text = Option
					OptionButton.Font = IsSelected and Enum.Font.GothamBold or Enum.Font.Gotham
					OptionButton.TextColor3 = IsSelected and Astral.Theme.Text or Astral.Theme.TextDark
					OptionButton.TextSize = ApplyScale(11)
					
					local OptionCorner = Instance.new("UICorner")
					OptionCorner.CornerRadius = UDim.new(0, ApplyScale(4))
					OptionCorner.Parent = OptionButton

					OptionButton.MouseButton1Click:Connect(function()
						CurrentSelected = Option
						DropdownLabel.Text = DropdownName .. ": " .. Option
						Callback(Option)
						Refresh(SearchBox.Text)
					end)
				end
				
				UpdateHeight(Count)
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
					TweenService:Create(ArrowImage, TweenInfo.new(0.2), {Rotation = 180}):Play()
				else
					UpdateHeight(0) -- Force retract
					Header.Visible = false
					DropdownList.Visible = false
					TweenService:Create(ArrowImage, TweenInfo.new(0.2), {Rotation = 0}):Play()
				end
			end)
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

			local BaseElementHeight = ApplyScale(ElementHeight)
			local ItemHeight = ApplyScale(22) -- Smaller base size for items
			local ItemPadding = ApplyScale(3)
			local HeaderHeight = ApplyScale(28)
			local ListMaxHeight = ApplyScale(110)
			
			local DropdownFrame = Instance.new("Frame")
			DropdownFrame.Parent = Parent
			DropdownFrame.BackgroundColor3 = Astral.Theme.Main
			DropdownFrame.BackgroundTransparency = 0.25
			DropdownFrame.Size = UDim2.new(1, 0, 0, BaseElementHeight)
			DropdownFrame.ClipsDescendants = true
			
			local DropdownCorner = Instance.new("UICorner")
			DropdownCorner.CornerRadius = UDim.new(0, ApplyScale(6))
			DropdownCorner.Parent = DropdownFrame

			local DropdownButton = Instance.new("TextButton")
			DropdownButton.Parent = DropdownFrame
			DropdownButton.BackgroundTransparency = 1
			DropdownButton.Size = UDim2.new(1, 0, 0, BaseElementHeight)
			DropdownButton.Text = ""

			local DropdownLabel = Instance.new("TextLabel")
			DropdownLabel.Parent = DropdownButton
			DropdownLabel.Size = UDim2.new(1, -ApplyScale(30), 1, 0)
			ApplyPadding(DropdownLabel, ApplyScale(BasePadding))
			DropdownLabel.Font = Enum.Font.GothamMedium
			DropdownLabel.TextColor3 = Astral.Theme.Text
			DropdownLabel.TextSize = ApplyScale(12)
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
			ArrowImage.Position = UDim2.new(1, -ApplyScale(26), 0.5, -ApplyScale(6))
			ArrowImage.Size = UDim2.new(0, ApplyScale(12), 0, ApplyScale(12))
			ArrowImage.Image = "rbxassetid://6031091004"
			ArrowImage.ImageColor3 = Astral.Theme.Accent

			-- Header Container
			local Header = Instance.new("Frame")
			Header.Parent = DropdownFrame
			Header.Position = UDim2.new(0, ApplyScale(BasePadding), 0, BaseElementHeight)
			Header.Size = UDim2.new(1, -ApplyScale(BasePadding * 2), 0, HeaderHeight)
			Header.BackgroundTransparency = 1
			Header.Visible = false

			local SearchBox = Instance.new("TextBox")
			SearchBox.Parent = Header
			SearchBox.Size = UDim2.new(1, -ApplyScale(100), 1, -ApplyScale(6))
			SearchBox.BackgroundColor3 = Astral.Theme.Tertiary
			SearchBox.BackgroundTransparency = 0.25
			SearchBox.PlaceholderText = "Search..."
			SearchBox.Text = ""
			SearchBox.TextColor3 = Astral.Theme.Text
			SearchBox.Font = Enum.Font.Gotham
			SearchBox.TextSize = ApplyScale(11)
			SearchBox.TextXAlignment = Enum.TextXAlignment.Left
			
			local SearchPadding = Instance.new("UIPadding")
			SearchPadding.Parent = SearchBox
			SearchPadding.PaddingLeft = UDim.new(0, ApplyScale(6))
			
			local SearchBoxCorner = Instance.new("UICorner")
			SearchBoxCorner.CornerRadius = UDim.new(0, ApplyScale(4))
			SearchBoxCorner.Parent = SearchBox
			
			local SearchStroke = Instance.new("UIStroke")
			SearchStroke.Parent = SearchBox
			SearchStroke.Color = Astral.Theme.Stroke
			SearchStroke.Thickness = ApplyScale(1)
			SearchStroke.Transparency = 0.5

			local SelectAllBtn = Instance.new("TextButton")
			SelectAllBtn.Parent = Header
			SelectAllBtn.Position = UDim2.new(1, -ApplyScale(95), 0, 0)
			SelectAllBtn.Size = UDim2.new(0, ApplyScale(45), 1, -ApplyScale(6))
			SelectAllBtn.BackgroundColor3 = Astral.Theme.Success
			SelectAllBtn.BackgroundTransparency = 0.25
			SelectAllBtn.Text = "ALL"
			SelectAllBtn.Font = Enum.Font.GothamBold
			SelectAllBtn.TextColor3 = Astral.Theme.Text
			SelectAllBtn.TextSize = ApplyScale(9)
			
			local SelectAllCorner = Instance.new("UICorner")
			SelectAllCorner.CornerRadius = UDim.new(0, ApplyScale(4))
			SelectAllCorner.Parent = SelectAllBtn

			local ClearAllBtn = Instance.new("TextButton")
			ClearAllBtn.Parent = Header
			ClearAllBtn.Position = UDim2.new(1, -ApplyScale(45), 0, 0)
			ClearAllBtn.Size = UDim2.new(0, ApplyScale(45), 1, -ApplyScale(6))
			ClearAllBtn.BackgroundColor3 = Astral.Theme.Error
			ClearAllBtn.BackgroundTransparency = 0.25
			ClearAllBtn.Text = "CLEAR"
			ClearAllBtn.Font = Enum.Font.GothamBold
			ClearAllBtn.TextColor3 = Astral.Theme.Text
			ClearAllBtn.TextSize = ApplyScale(9)
			
			local ClearAllCorner = Instance.new("UICorner")
			ClearAllCorner.CornerRadius = UDim.new(0, ApplyScale(4))
			ClearAllCorner.Parent = ClearAllBtn

			local DropdownList = Instance.new("ScrollingFrame")
			DropdownList.Parent = DropdownFrame
			DropdownList.BackgroundTransparency = 1
			DropdownList.Position = UDim2.new(0, ApplyScale(BasePadding), 0, BaseElementHeight + HeaderHeight)
			DropdownList.Size = UDim2.new(1, -ApplyScale(BasePadding * 2), 0, 0) -- Dynamic height
			DropdownList.ScrollBarThickness = 2
			DropdownList.ScrollBarImageTransparency = 0.5
			DropdownList.ScrollBarImageColor3 = Astral.Theme.Accent
			DropdownList.BorderSizePixel = 0
			DropdownList.VerticalScrollBarInset = Enum.ScrollBarInset.None
			DropdownList.HorizontalScrollBarInset = Enum.ScrollBarInset.None
			DropdownList.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
			DropdownList.Visible = false

			local DropdownLayout = Instance.new("UIListLayout")
			DropdownLayout.Parent = DropdownList
			DropdownLayout.Padding = UDim.new(0, ItemPadding)

			local function UpdateHeight(Count)
				if not Dropped then 
					TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, BaseElementHeight)}):Play()
					return 
				end

				-- Calculate exact height based on count
				local CalculatedContentHeight = (Count * ItemHeight) + (math.max(0, Count - 1) * ItemPadding)
				local ViewableHeight = math.min(CalculatedContentHeight, ListMaxHeight)
				local TotalHeight = BaseElementHeight + HeaderHeight + ViewableHeight + ApplyScale(BasePadding)
				
				DropdownList.Size = UDim2.new(1, -ApplyScale(BasePadding * 2), 0, ViewableHeight)
				DropdownList.CanvasSize = UDim2.new(0, 0, 0, CalculatedContentHeight)
				DropdownList.ScrollingEnabled = CalculatedContentHeight > ListMaxHeight

				TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, TotalHeight)}):Play()
				CenterElement(PageFrame, DropdownFrame, TotalHeight)
			end

			local function Refresh(filter)
				for _, Child in pairs(DropdownList:GetChildren()) do
					if Child:IsA("TextButton") then Child:Destroy() end
				end
				
				local Count = 0
				for _, Option in pairs(DropdownOptions) do
					if filter and filter ~= "" and not string.find(string.lower(Option), string.lower(filter)) then continue end
					Count = Count + 1

					local IsSelected = Selected[Option]
					local OptionButton = Instance.new("TextButton")
					OptionButton.Parent = DropdownList
					OptionButton.BackgroundColor3 = IsSelected and Astral.Theme.Accent or Astral.Theme.Tertiary
					OptionButton.BackgroundTransparency = IsSelected and 0.2 or 0.5
					OptionButton.Size = UDim2.new(1, 0, 0, ItemHeight)
					OptionButton.Text = Option
					OptionButton.Font = IsSelected and Enum.Font.GothamBold or Enum.Font.Gotham
					OptionButton.TextColor3 = IsSelected and Astral.Theme.Text or Astral.Theme.TextDark
					OptionButton.TextSize = ApplyScale(11)
					
					local OptionCorner = Instance.new("UICorner")
					OptionCorner.CornerRadius = UDim.new(0, ApplyScale(4))
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
				
				UpdateHeight(Count)
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
					TweenService:Create(ArrowImage, TweenInfo.new(0.2), {Rotation = 180}):Play()
				else
					UpdateHeight(0)
					Header.Visible = false
					DropdownList.Visible = false
					TweenService:Create(ArrowImage, TweenInfo.new(0.2), {Rotation = 0}):Play()
				end
			end)
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
			KeybindFrame.BackgroundTransparency = 0.25
			KeybindFrame.Size = UDim2.new(1, 0, 0, ApplyScale(ElementHeight))
			KeybindFrame.ClipsDescendants = true

			local KeybindCorner = Instance.new("UICorner")
			KeybindCorner.CornerRadius = UDim.new(0, ApplyScale(6))
			KeybindCorner.Parent = KeybindFrame

			local KeybindLabel = Instance.new("TextLabel")
			KeybindLabel.Parent = KeybindFrame
			KeybindLabel.BackgroundTransparency = 1
			KeybindLabel.Size = UDim2.new(1, 0, 1, 0)
			ApplyPadding(KeybindLabel, ApplyScale(BasePadding))
			KeybindLabel.Font = Enum.Font.GothamMedium
			KeybindLabel.Text = KeybindName
			KeybindLabel.TextColor3 = Astral.Theme.Text
			KeybindLabel.TextSize = ApplyScale(12)
			KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left

			local KeybindButton = Instance.new("Frame")
			KeybindButton.Parent = KeybindFrame
			KeybindButton.BackgroundColor3 = Astral.Theme.Tertiary
			KeybindButton.BackgroundTransparency = 0.25
			KeybindButton.Position = UDim2.new(1, -ApplyScale(70), 0.5, -ApplyScale(12))
			KeybindButton.Size = UDim2.new(0, ApplyScale(58), 0, ApplyScale(24))

			local KeybindButtonCorner = Instance.new("UICorner")
			KeybindButtonCorner.CornerRadius = UDim.new(0, ApplyScale(4))
			KeybindButtonCorner.Parent = KeybindButton

			local KeybindStroke = Instance.new("UIStroke")
			KeybindStroke.Parent = KeybindButton
			KeybindStroke.Color = Astral.Theme.Stroke
			KeybindStroke.Thickness = ApplyScale(1)
			KeybindStroke.Transparency = 0.5

			local KeybindText = Instance.new("TextButton")
			KeybindText.Parent = KeybindButton
			KeybindText.BackgroundTransparency = 1
			KeybindText.Size = UDim2.new(1, 0, 1, 0)
			KeybindText.Font = Enum.Font.GothamBold
			KeybindText.Text = Current.Name
			KeybindText.TextColor3 = Astral.Theme.Accent
			KeybindText.TextSize = ApplyScale(10)
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

		function TabFunctions:Label(Options, Parent)
			Parent = Parent or PageFrame
			local LabelText = Options.Text or "Label"

			local LabelFrame = Instance.new("Frame")
			LabelFrame.Parent = Parent
			LabelFrame.BackgroundColor3 = Astral.Theme.Main
			LabelFrame.BackgroundTransparency = 0.25
			LabelFrame.Size = UDim2.new(1, 0, 0, ApplyScale(30))
			LabelFrame.ClipsDescendants = true

			local LabelCorner = Instance.new("UICorner")
			LabelCorner.CornerRadius = UDim.new(0, ApplyScale(6))
			LabelCorner.Parent = LabelFrame

			local Label = Instance.new("TextLabel")
			Label.Parent = LabelFrame
			Label.BackgroundTransparency = 1
			Label.Size = UDim2.new(1, 0, 1, 0)
			ApplyPadding(Label, ApplyScale(BasePadding))
			Label.Font = Enum.Font.Gotham
			Label.Text = LabelText
			Label.TextColor3 = Astral.Theme.TextDark
			Label.TextSize = ApplyScale(11)
			Label.TextXAlignment = Enum.TextXAlignment.Left
			Label.TextWrapped = true

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
