local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Astral = {}

--// Configuration & Theme
Astral.Config = {
	Duration = 0.25,
	EasingStyle = Enum.EasingStyle.Quart,
	EasingDirection = Enum.EasingDirection.Out,
	FontMain = Enum.Font.GothamMedium,
	FontBold = Enum.Font.GothamBold,
}

Astral.Theme = {
	Background = Color3.fromRGB(12, 12, 14),
	Section = Color3.fromRGB(18, 18, 20),
	Element = Color3.fromRGB(24, 24, 26),
	Text = Color3.fromRGB(240, 240, 240),
	TextDim = Color3.fromRGB(160, 160, 160),
	Accent = Color3.fromRGB(88, 139, 255),
	Stroke = Color3.fromRGB(35, 35, 40),
	StrokeFocus = Color3.fromRGB(50, 50, 55),
	Success = Color3.fromRGB(100, 255, 140),
	Warning = Color3.fromRGB(255, 200, 80),
	Error = Color3.fromRGB(255, 90, 90),
}

--// Utility Functions
local Utility = {}

function Utility:Tween(object, goals, callback)
	local tween = TweenService:Create(object, TweenInfo.new(Astral.Config.Duration, Astral.Config.EasingStyle, Astral.Config.EasingDirection), goals)
	tween:Play()
	if callback then tween.Completed:Connect(callback) end
	return tween
end

function Utility:Create(className, properties)
	local instance = Instance.new(className)
	for k, v in pairs(properties) do
		instance[k] = v
	end
	return instance
end

function Utility:AddPadding(parent, px)
	return Utility:Create("UIPadding", {
		Parent = parent,
		PaddingTop = UDim.new(0, px),
		PaddingBottom = UDim.new(0, px),
		PaddingLeft = UDim.new(0, px),
		PaddingRight = UDim.new(0, px)
	})
end

function Utility:AddCorner(parent, px)
	return Utility:Create("UICorner", {Parent = parent, CornerRadius = UDim.new(0, px)})
end

function Utility:AddStroke(parent, color, transparency)
	return Utility:Create("UIStroke", {
		Parent = parent,
		Color = color or Astral.Theme.Stroke,
		Thickness = 1,
		Transparency = transparency or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	})
end

--// Dragging Logic
function Utility:MakeDraggable(dragFrame, targetFrame)
	local dragging, dragInput, dragStart, startPos

	dragFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = targetFrame.Position
			
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)

	dragFrame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			targetFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

--// Main Window Function
function Astral:Window(options)
	options = options or {}
	local Title = options.Name or "Astral UI"
	local Icon = options.Icon or "rbxassetid://7733954760"
	local BaseScale = options.Scale or 1.0

	-- Cleanup existing
	local TargetParent = RunService:IsStudio() and LocalPlayer.PlayerGui or CoreGui
	for _, v in pairs(TargetParent:GetChildren()) do
		if v.Name == "AstralMain" then v:Destroy() end
	end

	local ScreenGui = Utility:Create("ScreenGui", {
		Name = "AstralMain",
		Parent = TargetParent,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		ResetOnSpawn = false,
		IgnoreGuiInset = true
	})
	
	-- Global Scale Wrapper
	local MainFrame = Utility:Create("Frame", {
		Name = "MainFrame",
		Parent = ScreenGui,
		BackgroundColor3 = Astral.Theme.Background,
		Size = UDim2.new(0, 600, 0, 400),
		Position = UDim2.new(0.5, -300, 0.5, -200),
		BorderSizePixel = 0,
		ClipsDescendants = true -- Important for rounded corners
	})

	local WindowScale = Utility:Create("UIScale", {
		Parent = MainFrame,
		Scale = BaseScale
	})
	
	Utility:AddCorner(MainFrame, 10)
	Utility:AddStroke(MainFrame, Astral.Theme.Stroke, 0)
	
	-- Shadow (Optional visual polish)
	local Shadow = Utility:Create("ImageLabel", {
		Parent = MainFrame,
		BackgroundTransparency = 1,
		Image = "rbxassetid://6014261993",
		ImageColor3 = Color3.new(0,0,0),
		ImageTransparency = 0.6,
		Size = UDim2.new(1, 40, 1, 40),
		Position = UDim2.new(0, -20, 0, -20),
		ZIndex = -1,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(49, 49, 450, 450)
	})

	--// Topbar
	local Topbar = Utility:Create("Frame", {
		Parent = MainFrame,
		Size = UDim2.new(1, 0, 0, 38),
		BackgroundColor3 = Astral.Theme.Section,
		BorderSizePixel = 0
	})
	
	local TopbarLine = Utility:Create("Frame", {
		Parent = Topbar,
		Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = Astral.Theme.Stroke,
		BorderSizePixel = 0
	})
	
	local TitleLabel = Utility:Create("TextLabel", {
		Parent = Topbar,
		Size = UDim2.new(1, -100, 1, 0),
		Position = UDim2.new(0, 14, 0, 0),
		BackgroundTransparency = 1,
		Text = Title,
		Font = Astral.Config.FontBold,
		TextSize = 14,
		TextColor3 = Astral.Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left
	})

	Utility:MakeDraggable(Topbar, MainFrame)

	--// Content Containers
	local Sidebar = Utility:Create("ScrollingFrame", {
		Parent = MainFrame,
		Size = UDim2.new(0, 150, 1, -39),
		Position = UDim2.new(0, 0, 0, 39),
		BackgroundColor3 = Astral.Theme.Section,
		BorderSizePixel = 0,
		ScrollBarThickness = 0,
		CanvasSize = UDim2.new(0, 0, 0, 0)
	})
	
	local SidebarBorder = Utility:Create("Frame", {
		Parent = Sidebar,
		Size = UDim2.new(0, 1, 1, 0),
		Position = UDim2.new(1, -1, 0, 0),
		BackgroundColor3 = Astral.Theme.Stroke,
		BorderSizePixel = 0,
		ZIndex = 2
	})
	
	Utility:AddPadding(Sidebar, 10)
	local SidebarLayout = Utility:Create("UIListLayout", {
		Parent = Sidebar,
		Padding = UDim.new(0, 5),
		SortOrder = Enum.SortOrder.LayoutOrder
	})
	
	SidebarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		Sidebar.CanvasSize = UDim2.new(0, 0, 0, SidebarLayout.AbsoluteContentSize.Y + 20)
	end)

	local PageContainer = Utility:Create("Frame", {
		Parent = MainFrame,
		Size = UDim2.new(1, -150, 1, -39),
		Position = UDim2.new(0, 150, 0, 39),
		BackgroundTransparency = 1
	})
	
	--// Controls (Minimize/Close)
	local ControlContainer = Utility:Create("Frame", {
		Parent = Topbar,
		Size = UDim2.new(0, 70, 1, 0),
		Position = UDim2.new(1, -70, 0, 0),
		BackgroundTransparency = 1
	})

	local function CreateControl(text, color, callback)
		local btn = Utility:Create("TextButton", {
			Parent = ControlContainer,
			Size = UDim2.new(0, 35, 1, 0),
			BackgroundTransparency = 1,
			Text = text,
			Font = Astral.Config.FontMain,
			TextSize = 16,
			TextColor3 = Astral.Theme.TextDim,
			AutoButtonColor = false
		})
		
		local layout = Utility:Create("UIListLayout", {Parent = ControlContainer, FillDirection = Enum.FillDirection.Horizontal})
		
		btn.MouseEnter:Connect(function() 
			Utility:Tween(btn, {TextColor3 = color}) 
		end)
		btn.MouseLeave:Connect(function() 
			Utility:Tween(btn, {TextColor3 = Astral.Theme.TextDim}) 
		end)
		btn.MouseButton1Click:Connect(callback)
	end

	CreateControl("−", Astral.Theme.Accent, function()
		MainFrame.Visible = not MainFrame.Visible
	end)
	
	CreateControl("×", Astral.Theme.Error, function()
		ScreenGui:Destroy()
	end)

	--// Bubble / Minimize Icon
	local Bubble = Utility:Create("Frame", {
		Name = "Bubble",
		Parent = ScreenGui,
		Size = UDim2.new(0, 50, 0, 50),
		Position = UDim2.new(0.1, 0, 0.1, 0),
		BackgroundColor3 = Astral.Theme.Background,
		Visible = false,
		Active = true
	})
	Utility:AddCorner(Bubble, 25)
	Utility:AddStroke(Bubble, Astral.Theme.Accent, 0)
	
	local BubbleBtn = Utility:Create("TextButton", {
		Parent = Bubble, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = ""
	})
	local BubbleImg = Utility:Create("ImageLabel", {
		Parent = Bubble, Size = UDim2.new(0, 24, 0, 24), AnchorPoint = Vector2.new(0.5,0.5), 
		Position = UDim2.new(0.5,0,0.5,0), BackgroundTransparency = 1, Image = Icon, ImageColor3 = Astral.Theme.Text
	})
	Utility:MakeDraggable(Bubble, Bubble)
	BubbleBtn.MouseButton1Click:Connect(function()
		MainFrame.Visible = not MainFrame.Visible
	end)

	MainFrame:GetPropertyChangedSignal("Visible"):Connect(function()
		Bubble.Visible = not MainFrame.Visible
	end)

	--// Notifications System
	local Notifications = Utility:Create("Frame", {
		Parent = ScreenGui,
		Size = UDim2.new(0, 250, 1, 0),
		Position = UDim2.new(1, -270, 0, 0),
		BackgroundTransparency = 1,
		ClipsDescendants = false
	})
	local NotifLayout = Utility:Create("UIListLayout", {
		Parent = Notifications,
		Padding = UDim.new(0, 10),
		VerticalAlignment = Enum.VerticalAlignment.Bottom,
		HorizontalAlignment = Enum.HorizontalAlignment.Right
	})
	Utility:AddPadding(Notifications, 20)

	local LibraryFunctions = {}
	
	function LibraryFunctions:Notify(opts)
		local nTitle = opts.Title or "Notification"
		local nContent = opts.Content or "Message"
		local nDuration = opts.Duration or 3
		
		local nFrame = Utility:Create("Frame", {
			Parent = Notifications,
			Size = UDim2.new(1, 0, 0, 0), -- Starts small
			BackgroundColor3 = Astral.Theme.Element,
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 0.1
		})
		Utility:AddCorner(nFrame, 6)
		Utility:AddStroke(nFrame, Astral.Theme.Stroke, 0)
		
		local nPad = Utility:AddPadding(nFrame, 12)
		
		local nTitleLbl = Utility:Create("TextLabel", {
			Parent = nFrame,
			Size = UDim2.new(1, 0, 0, 16),
			BackgroundTransparency = 1,
			Text = nTitle,
			Font = Astral.Config.FontBold,
			TextSize = 13,
			TextColor3 = Astral.Theme.Accent,
			TextXAlignment = Enum.TextXAlignment.Left
		})
		
		local nTextLbl = Utility:Create("TextLabel", {
			Parent = nFrame,
			Size = UDim2.new(1, 0, 0, 0),
			Position = UDim2.new(0, 0, 0, 20),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Text = nContent,
			Font = Astral.Config.FontMain,
			TextSize = 12,
			TextColor3 = Astral.Theme.Text,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left
		})

		-- Animate In
		nFrame.BackgroundTransparency = 1
		nTitleLbl.TextTransparency = 1
		nTextLbl.TextTransparency = 1
		
		Utility:Tween(nFrame, {BackgroundTransparency = 0.1})
		Utility:Tween(nTitleLbl, {TextTransparency = 0})
		Utility:Tween(nTextLbl, {TextTransparency = 0})

		task.delay(nDuration, function()
			Utility:Tween(nFrame, {BackgroundTransparency = 1})
			Utility:Tween(nTitleLbl, {TextTransparency = 1})
			Utility:Tween(nTextLbl, {TextTransparency = 1})
			task.wait(Astral.Config.Duration)
			nFrame:Destroy()
		end)
	end
	
	function LibraryFunctions:SetScale(newScale)
		WindowScale.Scale = newScale
	end

	--// Tabs
	local Tabs = {}
	local FirstTab = true

	function LibraryFunctions:Tab(tabOptions)
		local TabName = tabOptions.Name or "Tab"
		local TabIcon = tabOptions.Icon -- Optional ID
		
		-- Tab Button
		local TabBtn = Utility:Create("TextButton", {
			Parent = Sidebar,
			Size = UDim2.new(1, 0, 0, 32),
			BackgroundColor3 = Astral.Theme.Background,
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false
		})
		Utility:AddCorner(TabBtn, 6)
		
		local TabBtnStroke = Utility:AddStroke(TabBtn, Astral.Theme.Stroke, 1) -- Hidden by default
		
		local TabLabel = Utility:Create("TextLabel", {
			Parent = TabBtn,
			Size = UDim2.new(1, -20, 1, 0),
			Position = UDim2.new(0, 10, 0, 0),
			BackgroundTransparency = 1,
			Text = TabName,
			Font = Astral.Config.FontMain,
			TextSize = 12,
			TextColor3 = Astral.Theme.TextDim,
			TextXAlignment = Enum.TextXAlignment.Left
		})

		-- Page
		local Page = Utility:Create("ScrollingFrame", {
			Parent = PageContainer,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Visible = false,
			ScrollBarThickness = 2,
			ScrollBarImageColor3 = Astral.Theme.Accent,
			BorderSizePixel = 0,
			CanvasSize = UDim2.new(0, 0, 0, 0)
		})
		Utility:AddPadding(Page, 12)
		
		local PageLayout = Utility:Create("UIListLayout", {
			Parent = Page,
			Padding = UDim.new(0, 8),
			SortOrder = Enum.SortOrder.LayoutOrder
		})
		
		PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 24)
		end)

		-- Activation Logic
		local function Activate()
			-- Reset all other tabs
			for _, t in pairs(Tabs) do
				Utility:Tween(t.Label, {TextColor3 = Astral.Theme.TextDim})
				Utility:Tween(t.Btn, {BackgroundTransparency = 1})
				Utility:Tween(t.Stroke, {Transparency = 1})
				t.Page.Visible = false
			end
			
			-- Activate current
			Utility:Tween(TabLabel, {TextColor3 = Astral.Theme.Text})
			Utility:Tween(TabBtn, {BackgroundTransparency = 0.8}) -- Slight highlight
			Utility:Tween(TabBtnStroke, {Transparency = 0.8})
			Page.Visible = true
		end

		TabBtn.MouseButton1Click:Connect(Activate)
		table.insert(Tabs, {Btn = TabBtn, Label = TabLabel, Page = Page, Stroke = TabBtnStroke})
		
		if FirstTab then
			FirstTab = false
			Activate()
		end

		local ElementHandler = {}

		-- Helper for consistent element background
		local function CreateElementContainer(height)
			local Container = Utility:Create("Frame", {
				Parent = Page,
				Size = UDim2.new(1, 0, 0, height or 34),
				BackgroundColor3 = Astral.Theme.Element,
				AutomaticSize = height and Enum.AutomaticSize.None or Enum.AutomaticSize.Y
			})
			Utility:AddCorner(Container, 6)
			Utility:AddStroke(Container, Astral.Theme.Stroke, 0)
			Utility:AddPadding(Container, 8)
			return Container
		end

		function ElementHandler:Section(text)
			local SectionFrame = Utility:Create("Frame", {
				Parent = Page,
				Size = UDim2.new(1, 0, 0, 20),
				BackgroundTransparency = 1
			})
			local SectionLabel = Utility:Create("TextLabel", {
				Parent = SectionFrame,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Text = text,
				Font = Astral.Config.FontBold,
				TextSize = 12,
				TextColor3 = Astral.Theme.Accent,
				TextXAlignment = Enum.TextXAlignment.Left
			})
			local SectionFunctions = {}
			-- You could implement nesting here, but keeping it flat for simplicity
			return SectionFunctions
		end
		
		function ElementHandler:Label(text)
			local Container = CreateElementContainer(28)
			Container.BackgroundTransparency = 1
			Container:FindFirstChild("UIStroke").Transparency = 1
			
			local Label = Utility:Create("TextLabel", {
				Parent = Container,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Text = text,
				Font = Astral.Config.FontMain,
				TextSize = 12,
				TextColor3 = Astral.Theme.TextDim,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextWrapped = true
			})
			
			local LabelFunc = {}
			function LabelFunc:Set(t) Label.Text = t end
			return LabelFunc
		end

		function ElementHandler:Button(btnOptions)
			local text = btnOptions.Name or "Button"
			local callback = btnOptions.Callback or function() end
			
			local Container = CreateElementContainer(32)
			local Button = Utility:Create("TextButton", {
				Parent = Container,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Text = text,
				Font = Astral.Config.FontMain,
				TextSize = 12,
				TextColor3 = Astral.Theme.Text
			})
			
			-- Interactive effects
			local Stroke = Container:FindFirstChild("UIStroke")
			Button.MouseEnter:Connect(function()
				Utility:Tween(Container, {BackgroundColor3 = Color3.fromRGB(30,30,35)})
				Utility:Tween(Stroke, {Color = Astral.Theme.TextDim})
			end)
			Button.MouseLeave:Connect(function()
				Utility:Tween(Container, {BackgroundColor3 = Astral.Theme.Element})
				Utility:Tween(Stroke, {Color = Astral.Theme.Stroke})
			end)
			Button.MouseButton1Click:Connect(function()
				Utility:Tween(Container, {Size = UDim2.new(0.98, 0, 0, 30)}, function()
					Utility:Tween(Container, {Size = UDim2.new(1, 0, 0, 32)})
				end)
				callback()
			end)
		end

		function ElementHandler:Toggle(togOptions)
			local text = togOptions.Name or "Toggle"
			local state = togOptions.Default or false
			local callback = togOptions.Callback or function() end
			
			local Container = CreateElementContainer(32)
			local Label = Utility:Create("TextLabel", {
				Parent = Container,
				Size = UDim2.new(1, -50, 1, 0),
				BackgroundTransparency = 1,
				Text = text,
				Font = Astral.Config.FontMain,
				TextSize = 12,
				TextColor3 = Astral.Theme.Text,
				TextXAlignment = Enum.TextXAlignment.Left
			})
			
			local SwitchBg = Utility:Create("Frame", {
				Parent = Container,
				Size = UDim2.new(0, 36, 0, 18),
				Position = UDim2.new(1, -36, 0.5, -9),
				BackgroundColor3 = state and Astral.Theme.Accent or Astral.Theme.Stroke,
			})
			Utility:AddCorner(SwitchBg, 9)
			
			local SwitchCircle = Utility:Create("Frame", {
				Parent = SwitchBg,
				Size = UDim2.new(0, 14, 0, 14),
				Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
				BackgroundColor3 = Astral.Theme.Text
			})
			Utility:AddCorner(SwitchCircle, 7)
			
			local Trigger = Utility:Create("TextButton", {
				Parent = Container, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = ""
			})
			
			local function Update()
				local targetPos = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
				local targetColor = state and Astral.Theme.Accent or Astral.Theme.Stroke
				
				Utility:Tween(SwitchCircle, {Position = targetPos})
				Utility:Tween(SwitchBg, {BackgroundColor3 = targetColor})
				callback(state)
			end
			
			Trigger.MouseButton1Click:Connect(function()
				state = not state
				Update()
			end)
		end

		function ElementHandler:Slider(slideOptions)
			local text = slideOptions.Name or "Slider"
			local min = slideOptions.Min or 0
			local max = slideOptions.Max or 100
			local default = slideOptions.Default or min
			local callback = slideOptions.Callback or function() end
			
			local value = default
			local dragging = false
			
			local Container = CreateElementContainer(46)
			
			local Label = Utility:Create("TextLabel", {
				Parent = Container,
				Size = UDim2.new(1, 0, 0, 14),
				BackgroundTransparency = 1,
				Text = text,
				Font = Astral.Config.FontMain,
				TextSize = 12,
				TextColor3 = Astral.Theme.Text,
				TextXAlignment = Enum.TextXAlignment.Left
			})
			
			local ValueLabel = Utility:Create("TextLabel", {
				Parent = Container,
				Size = UDim2.new(1, 0, 0, 14),
				BackgroundTransparency = 1,
				Text = tostring(value),
				Font = Astral.Config.FontMain,
				TextSize = 12,
				TextColor3 = Astral.Theme.TextDim,
				TextXAlignment = Enum.TextXAlignment.Right
			})
			
			local SliderBg = Utility:Create("Frame", {
				Parent = Container,
				Size = UDim2.new(1, 0, 0, 4),
				Position = UDim2.new(0, 0, 1, -8),
				BackgroundColor3 = Astral.Theme.Stroke
			})
			Utility:AddCorner(SliderBg, 2)
			
			local SliderFill = Utility:Create("Frame", {
				Parent = SliderBg,
				Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
				BackgroundColor3 = Astral.Theme.Accent
			})
			Utility:AddCorner(SliderFill, 2)
			
			local Trigger = Utility:Create("TextButton", {
				Parent = Container, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = ""
			})
			
			local function Update(input)
				local sizeX = SliderBg.AbsoluteSize.X
				local posX = input.Position.X - SliderBg.AbsolutePosition.X
				local percent = math.clamp(posX / sizeX, 0, 1)
				
				value = math.floor(min + (max - min) * percent)
				ValueLabel.Text = tostring(value)
				
				Utility:Tween(SliderFill, {Size = UDim2.new(percent, 0, 1, 0)})
				callback(value)
			end
			
			Trigger.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = true
					Update(input)
				end
			end)
			
			Trigger.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = false
				end
			end)
			
			UserInputService.InputChanged:Connect(function(input)
				if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					Update(input)
				end
			end)
		end
		
		function ElementHandler:Dropdown(dropOptions)
			local text = dropOptions.Name or "Dropdown"
			local list = dropOptions.Options or {}
			local callback = dropOptions.Callback or function() end
			local default = dropOptions.Default
			
			local expanded = false
			local Container = CreateElementContainer(nil) -- Auto size
			
			local Header = Utility:Create("TextButton", {
				Parent = Container,
				Size = UDim2.new(1, 0, 0, 20),
				BackgroundTransparency = 1,
				Text = "",
				AutoButtonColor = false
			})
			
			local Label = Utility:Create("TextLabel", {
				Parent = Header,
				Size = UDim2.new(0.6, 0, 1, 0),
				BackgroundTransparency = 1,
				Text = text,
				Font = Astral.Config.FontMain,
				TextSize = 12,
				TextColor3 = Astral.Theme.Text,
				TextXAlignment = Enum.TextXAlignment.Left
			})
			
			local SelectedLabel = Utility:Create("TextLabel", {
				Parent = Header,
				Size = UDim2.new(0.4, -20, 1, 0),
				Position = UDim2.new(0.6, 0, 0, 0),
				BackgroundTransparency = 1,
				Text = default or "...",
				Font = Astral.Config.FontMain,
				TextSize = 12,
				TextColor3 = Astral.Theme.Accent,
				TextXAlignment = Enum.TextXAlignment.Right
			})
			
			local Arrow = Utility:Create("ImageLabel", {
				Parent = Header,
				Size = UDim2.new(0, 16, 0, 16),
				Position = UDim2.new(1, -16, 0.5, -8),
				BackgroundTransparency = 1,
				Image = "rbxassetid://6031091004",
				ImageColor3 = Astral.Theme.TextDim
			})
			
			local OptionContainer = Utility:Create("Frame", {
				Parent = Container,
				Size = UDim2.new(1, 0, 0, 0),
				Position = UDim2.new(0, 0, 0, 24),
				BackgroundTransparency = 1,
				ClipsDescendants = true
			})
			
			local OptionLayout = Utility:Create("UIListLayout", {
				Parent = OptionContainer,
				Padding = UDim.new(0, 4)
			})
			
			local function RenderOptions()
				for _, v in pairs(OptionContainer:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
				
				for _, opt in pairs(list) do
					local Btn = Utility:Create("TextButton", {
						Parent = OptionContainer,
						Size = UDim2.new(1, 0, 0, 20),
						BackgroundColor3 = Astral.Theme.Background,
						BackgroundTransparency = 0.5,
						Text = opt,
						Font = Astral.Config.FontMain,
						TextSize = 12,
						TextColor3 = Astral.Theme.TextDim,
						AutoButtonColor = false
					})
					Utility:AddCorner(Btn, 4)
					
					Btn.MouseEnter:Connect(function() Utility:Tween(Btn, {TextColor3 = Astral.Theme.Text, BackgroundColor3 = Astral.Theme.Stroke}) end)
					Btn.MouseLeave:Connect(function() Utility:Tween(Btn, {TextColor3 = Astral.Theme.TextDim, BackgroundColor3 = Astral.Theme.Background}) end)
					
					Btn.MouseButton1Click:Connect(function()
						SelectedLabel.Text = opt
						callback(opt)
						expanded = false
						Utility:Tween(Arrow, {Rotation = 0})
						Utility:Tween(OptionContainer, {Size = UDim2.new(1, 0, 0, 0)})
					end)
				end
			end
			
			Header.MouseButton1Click:Connect(function()
				expanded = not expanded
				RenderOptions()
				
				local targetHeight = expanded and math.min(#list * 24, 150) or 0
				Utility:Tween(Arrow, {Rotation = expanded and 180 or 0})
				Utility:Tween(OptionContainer, {Size = UDim2.new(1, 0, 0, targetHeight)})
			end)
		end

		return ElementHandler
	end

	return LibraryFunctions
end

return Astral
