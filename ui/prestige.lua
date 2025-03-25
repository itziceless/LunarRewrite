local api = {
	Categories = {},
	HeldKeybinds = {},
	Keybind = {'RightShift'},
	Loaded = false,
	Libraries = {},
	Modules = {},
	Toggles = {},
	Place = game.PlaceId,
	Scale = {Value = 1},
	ToggleNotifications = {},
	Version = 'V2',
	Windows = {}
}

local color = {}
local tween = {
	tweens = {},
	tweenstwo = {}
}

local colorpallet = {
	Main = Color3.fromRGB(10,10,10),
	Text = Color3.fromRGB(120,120,120),
	TextEnabled = Color3.new(200,200,200),
	Prestige = Color3.fromRGB(133, 75, 250),
	Lav = Color3.fromRGB(155, 140, 185),
	Font = Font.new('rbxasset://fonts/families/Arial.json'),
	Settings = Color3.fromRGB(42,42,42),
	Tween = TweenInfo.new(0.16, Enum.EasingStyle.Linear)
}

local playersService = game:GetService('Players')
local inputService = game:GetService("UserInputService")
local lplr = playersService.LocalPlayer
local guiService = game:GetService("GuiService")
local tweenservice = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local textservice = game:GetService("TextService")
local textchatservice = game:GetService("TextChatService")
local scale

local function addCorner(parent, radius)
	local corner = Instance.new('UICorner')
	corner.CornerRadius = radius or UDim.new(0, 5)
	corner.Parent = parent
	return corner
end

local fontsize = Instance.new('GetTextBoundsParams')
fontsize.Width = math.huge

local getfontsize = function(text, size, font)
	fontsize.Text = text
	fontsize.Size = size
	if typeof(font) == 'Font' then
		fontsize.Font = font
	end
	return textservice:GetTextBoundsAsync(fontsize)
end

function color.Dark(col, num)
	local h, s, v = col:ToHSV()
	return Color3.fromHSV(h, s, math.clamp(select(3, colorpallet.Main:ToHSV()) > 0.5 and v + num or v - num, 0, 1))
end

function color.Light(col, num)
	local h, s, v = col:ToHSV()
	return Color3.fromHSV(h, s, math.clamp(select(3, colorpallet.Main:ToHSV()) > 0.5 and v - num or v + num, 0, 1))
end

local function getAccurateTextSize(text, size)
	return textservice:GetTextSize(text, size, Enum.Font.SourceSans, Vector2.zero).X
end

local function addMaid(object)
	object.Connections = {}
	function object:Clean(callback)
		if typeof(callback) == 'Instance' then
			table.insert(self.Connections, {
				Disconnect = function()
					callback:ClearAllChildren()
					callback:Destroy()
				end
			})
		elseif type(callback) == 'function' then
			table.insert(self.Connections, {
				Disconnect = callback
			})
		else
			table.insert(self.Connections, callback)
		end
	end
end

local main = Instance.new("ScreenGui")
local clickgui = Instance.new("Frame")
clickgui.BackgroundTransparency = 0
clickgui.Position = UDim2.new(0, 0, 0, 0)
clickgui.Size = UDim2.new(0, 3000, 0, 1000)
clickgui.Parent = main
clickgui.Name = "clickgui"
clickgui.Transparency = 1
clickgui.Visible = false

main.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
main.Name = "main"

--[[local SubArrayListFrame = Instance.new("Frame", main)
SubArrayListFrame.Size = UDim2.fromScale(0.2,0.7)
SubArrayListFrame.Position = UDim2.fromScale(0.2, 0)
SubArrayListFrame.BackgroundTransparency = 1
SubArrayListFrame.Visible = true--]]

local ArrayListFrame = Instance.new("Frame", main)
ArrayListFrame.Size = UDim2.fromScale(0.2,0.7)
ArrayListFrame.Name = "ArrayListFrame"
ArrayListFrame.Position = UDim2.fromScale(0.3,0.25)
ArrayListFrame.BackgroundTransparency = 1
ArrayListFrame.Visible = true
local ArrayListFrameSorter = Instance.new("UIListLayout")
ArrayListFrameSorter.Parent = ArrayListFrame
ArrayListFrameSorter.HorizontalAlignment = Enum.HorizontalAlignment.Right
ArrayListFrameSorter.SortOrder = Enum.SortOrder.LayoutOrder
ArrayListFrameSorter.Padding = UDim.new(0, 0.9)

local ArrayItems = {}

local NotificationFrame = Instance.new("Frame")
NotificationFrame.Size = UDim2.fromScale(0.3, 0.9)
NotificationFrame.Position = UDim2.fromScale(0.7,0)
NotificationFrame.BackgroundTransparency = 1
NotificationFrame.Parent = main
local NotificationFrameSorter = Instance.new("UIListLayout", NotificationFrame)
NotificationFrameSorter.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotificationFrameSorter.HorizontalAlignment = Enum.HorizontalAlignment.Right
NotificationFrameSorter.Padding = UDim.new(0.015,0)

local TargetHud = {}
local targinfobkg = Instance.new("Frame")
targinfobkg.Size = UDim2.fromOffset(270, 90)
targinfobkg.Position =  UDim2.new(0.4, 0, 0.5, 0)
targinfobkg.BackgroundColor3 = Color3.new(0,0,0)
targinfobkg.BackgroundTransparency = 0
targinfobkg.Visible = false
targinfobkg.Parent = main
targinfobkg.Name = "targinfobkg"
addCorner(targinfobkg, UDim.new(0, 15))
local targetinfoshot = Instance.new('ImageLabel')
targetinfoshot.Size = UDim2.fromOffset(64, 64)
targetinfoshot.Position = UDim2.new(0, 48, 0.5, 1)
targetinfoshot.AnchorPoint = Vector2.new(0.5, 0.5)
targetinfoshot.BackgroundTransparency = 1
targetinfoshot.Image = 'rbxthumb://type=AvatarHeadShot&id=1&w=420&h=420'
targetinfoshot.Parent = targinfobkg
addCorner(targetinfoshot)
local targetinfoname = Instance.new('TextLabel')
targetinfoname.Size = UDim2.fromOffset(60, 30)
targetinfoname.Position = UDim2.fromOffset(85, 15)
targetinfoname.BackgroundTransparency = 1
targetinfoname.Text = 'Prestige'
targetinfoname.Font = Enum.Font.ArialBold
targetinfoname.TextSize = 20
targetinfoname.TextXAlignment = Enum.TextXAlignment.Left
targetinfoname.TextColor3 = colorpallet.Prestige
targetinfoname.FontFace = colorpallet.Font
targetinfoname.Parent = targinfobkg
local targetinfohealthtext = targetinfoname:Clone()
targetinfohealthtext.Position = UDim2.fromOffset(240, 63)
targetinfohealthtext.Text = '20.0'
targetinfohealthtext.Size = UDim2.fromOffset(50, 11)
targetinfohealthtext.TextSize = 14
targetinfohealthtext.Font = Enum.Font.ArialBold
targetinfohealthtext.Parent = targinfobkg
local targetinfohealthbkg = Instance.new('Frame')
targetinfohealthbkg.Name = 'HealthBKG'
targetinfohealthbkg.Size = UDim2.fromOffset(150, 10)
targetinfohealthbkg.Position = UDim2.fromOffset(83, 65)
targetinfohealthbkg.BackgroundColor3 = color.Dark(colorpallet.Prestige, 0.5)
targetinfohealthbkg.BackgroundTransparency = 0.5
targetinfohealthbkg.BorderSizePixel = 0
targetinfohealthbkg.Parent = targinfobkg
addCorner(targetinfohealthbkg, UDim.new(0, 10))
local targetinfohealth = targetinfohealthbkg:Clone()
targetinfohealth.Size = UDim2.fromScale(0.8, 1)
targetinfohealth.Position = UDim2.new()
targetinfohealth.BackgroundColor3 = Color3.new(0.294118, 1, 0.317647)
targetinfohealth.BackgroundTransparency = 0
targetinfohealth.Parent = targetinfohealthbkg

function api:CreateNotification(title, text, duration)
	
	local size = getAccurateTextSize("  "..text, 22)

	local Notification = Instance.new("Frame", NotificationFrame)
	Notification.BorderSizePixel = 0
	Notification.BackgroundColor3 = colorpallet.Main
	Notification.Size = UDim2.new(0,size,0.13,0)--UDim2.fromOffset(math.max(getfontsize(removeTags(text), 13, colorpallet.Font).X + 80, 266), 60)
	--[[Notification.Text = "  "..text
	Notification.TextColor3 = Color3.fromRGB(255,255,255)
	Notification.TextSize = 22
	Notification.TextXAlignment = Enum.TextXAlignment.Left
	Notification.Font = Enum.Font.SourceSans--]]
	Notification.BackgroundTransparency = 0
	
	local titlelabel = Instance.new('TextLabel')
	titlelabel.Name = 'Title'
	titlelabel.Size = UDim2.new(1, -56, 0, 20)
	titlelabel.Position = UDim2.fromOffset(20, 10)
	titlelabel.ZIndex = 5
	titlelabel.BackgroundTransparency = 1
	titlelabel.Text = "<stroke color='#FFFFFF' joins='round' thickness='0.3' transparency='0.5'>"..title..'</stroke>'
	titlelabel.TextXAlignment = Enum.TextXAlignment.Left
	titlelabel.TextYAlignment = Enum.TextYAlignment.Top
	titlelabel.TextColor3 = colorpallet.Text
	titlelabel.TextSize = 14
	titlelabel.RichText = true
	titlelabel.FontFace = colorpallet.Font
	titlelabel.Parent = Notification
	
	local textllabel = Instance.new('TextLabel')
	textllabel.Name = 'Title'
	textllabel.Size = UDim2.new(1, -56, 0, 20)
	textllabel.Position = UDim2.fromOffset(20, 25)
	textllabel.BackgroundTransparency = 1
	textllabel.Text = text
	textllabel.TextXAlignment = Enum.TextXAlignment.Left
	textllabel.TextColor3 = Color3.fromRGB(209, 209, 209)
	textllabel.TextSize = 14
	textllabel.RichText = true
	textllabel.FontFace = colorpallet.Font
	textllabel.Parent = Notification


	tweenservice:Create(Notification, TweenInfo.new(0.3, Enum.EasingStyle.Bounce), {
		AnchorPoint = Vector2.new(1, 0),
	}):Play()

	local NotificationDuration = Instance.new("Frame", Notification)
	NotificationDuration.Size = UDim2.fromScale(1, 0.05)
	NotificationDuration.BorderSizePixel = 0
	NotificationDuration.BackgroundColor3 = colorpallet.Prestige
	NotificationDuration.Position = UDim2.fromScale(0,0.95)

	tweenservice:Create(NotificationDuration, TweenInfo.new(duration + 0.3), {
		Size = UDim2.fromScale(0, 0.05)
	}):Play()

	task.delay(duration, function()
		tweenservice:Create(Notification, TweenInfo.new(0.3), {
			Size = UDim2.fromScale(0, 0.055)
		}):Play()


		task.delay(0.35, function()
			Notification:Destroy()
		end)
	end)
end

--[[if isfile('lunar/banned') then
	readfile('lunar/banned')
	if readfile('lunar/banned') == lplr.Name then
	lplr:Kick("You've been banned.")
	end
end
--]]

api.Categories = {}

function api:CreateCategory(categorysettings)
	local categoryapi = {
		Type = 'Category',
		Expanded = false
	}

	
	local window = Instance.new('TextLabel')
	window.Name = categorysettings.Name .. 'Category'
	window.Size = UDim2.fromOffset(220, 50)
	window.Position = categorysettings.pos
	window.BackgroundColor3 = colorpallet.Main
	window.Font = Enum.Font.ArialBold
	window.Text = ''
	window.Visible = true
	window.Parent = clickgui
	local icon = Instance.new('ImageLabel')
	icon.Name = 'Icon'
	icon.BackgroundColor3 = colorpallet.Prestige
	icon.Size = categorysettings.Size
	icon.Position = UDim2.new(0.05, 0, 0.25, 0)
	icon.BackgroundTransparency = 0
	icon.Image = categorysettings.Icon
	addCorner(icon, UDim.new(0, 5))
	icon.Parent = window
	local title = Instance.new('TextLabel')
	title.Name = 'Title'
	title.Size = UDim2.new(1, -10, 0, 30)
	title.Position = UDim2.new(0, 5, 0, 10)
	title.TextColor3 = colorpallet.Text
	title.BackgroundTransparency = 1
	title.Text = categorysettings.Name
	title.TextSize = 17
	title.FontFace = Font.new('rbxasset://fonts/families/Arial.json')
	title.Parent = window
	local ModuleFrame = Instance.new("ScrollingFrame")
	ModuleFrame.Parent = window
	ModuleFrame.Name = "ModuleFrame"
	ModuleFrame.Position = UDim2.fromScale(0, 1)
	ModuleFrame.Size = UDim2.fromScale(1, 15)
	ModuleFrame.BackgroundTransparency = 1
	local ModuleFrameSorter = Instance.new("UIListLayout", ModuleFrame)
	ModuleFrameSorter.SortOrder = Enum.SortOrder.LayoutOrder
	ModuleFrameSorter.HorizontalAlignment = Enum.HorizontalAlignment.Center

	
	function categoryapi:CreateModule(modulesettings)
		
		if api.Modules[modulesettings.Name] then
			return
		end

		local moduleapi = {
			Enabled = false,
			Options = {},
			Bind = {},
			ExtraText = modulesettings.ExtraText,
			Name = modulesettings.Name,
			Category = categorysettings.Name
		}

		local modulebutton = Instance.new('TextButton')
		modulebutton.Name = modulesettings.Name
		modulebutton.Size = UDim2.fromOffset(220, 40)
		modulebutton.BackgroundColor3 = colorpallet.Main
		modulebutton.BorderSizePixel = 0
		modulebutton.AutoButtonColor = false
		modulebutton.Text = '            '..modulesettings.Name
		modulebutton.TextXAlignment = Enum.TextXAlignment.Left
		modulebutton.TextColor3 = colorpallet.Text
		modulebutton.TextSize = 14
		modulebutton.FontFace = colorpallet.Font
		modulebutton.Parent = ModuleFrame
		local gradient = Instance.new('UIGradient')
		gradient.Rotation = 90
		gradient.Enabled = true
		gradient.Parent = modulebutton
		local arrowbutton = Instance.new('TextButton')
		arrowbutton.Name = 'Arrow'
		arrowbutton.Size = UDim2.fromOffset(25, 40)
		arrowbutton.Position = UDim2.new(1, -30, 0, 0)
		arrowbutton.BackgroundTransparency = 1
		arrowbutton.Text = ''
		arrowbutton.Parent = modulebutton
		local arrow = Instance.new('ImageLabel')
		arrow.Name = 'Arrow'
		arrow.Size = UDim2.fromOffset(16, 16)
		arrow.Position = UDim2.fromOffset(3, 15)
		arrow.BackgroundTransparency = 1
		arrow.Image = "http://www.roblox.com/asset/?id=119372369617448"
		arrow.Parent = arrowbutton
		arrow.Rotation = 90
		--[[local modulechildren = Instance.new('Frame')
		modulechildren.Name = modulesettings.Name..'Children'
		modulechildren.Size = UDim2.new(1, 0, 0, 0)
		modulechildren.BackgroundColor3 = colorpallet.Main
		modulechildren.BorderSizePixel = 0
		modulechildren.Visible = true
		modulechildren.Parent = ModuleFrame
		moduleapi.Children = modulechildren
		local childrensorter = Instance.new('UIListLayout')
		childrensorter.SortOrder = Enum.SortOrder.LayoutOrder
		childrensorter.HorizontalAlignment = Enum.HorizontalAlignment.Center
		childrensorter.Parent = modulechildren--]]
		
		addMaid(moduleapi)

		api.Modules[modulesettings.Name] = moduleapi
		
		local ArrayList = {
			Create = function(Name)
				local Item = Instance.new("TextLabel")
				Item.Parent = ArrayListFrame
				Item.Name = Name
				Item.Text = Name
				Item.BorderSizePixel = -1
				Item.TextSize = 20
				Item.TextColor3 = colorpallet.Prestige
				Item.BackgroundTransparency = 1
				Item.FontFace = Font.new('rbxasset://fonts/families/Arial.json')
				local ItemArrayHolder = Instance.new("Frame", Item)
				ItemArrayHolder.Size = UDim2.new(1,0,0,1)
				ItemArrayHolder.Position = UDim2.fromScale(0, 0.94)
				ItemArrayHolder.BorderSizePixel = 0
				ItemArrayHolder.Visible = true
				ItemArrayHolder.BackgroundTransparency = 0
				local Line = Instance.new("Frame")
				Line.Name = "Line"
				Line.Size = UDim2.new(0, 3, 1, 0)
				Line.Parent = Item
				Line.BorderSizePixel = 0
				Line.Visible = false
				Line.BackgroundColor3 = colorpallet.Prestige
				Line.Position = UDim2.fromScale(1,0)

				local size = getAccurateTextSize(Name, 23)

				Item.Size = UDim2.new(0.03, size, 0.048, 0)
				
				ArrayItems[Name] = Item

				local SortedArray = {}
				for i, v in pairs(ArrayItems) do
					table.insert(SortedArray, v)
				end

				table.sort(SortedArray, function(a, b)
					return getAccurateTextSize(a.Text, a.TextSize) > getAccurateTextSize(b.Text, b.TextSize)
				end)


				for i, v in ipairs(SortedArray) do
					v.LayoutOrder = i
				end
			end,

			Remove = function(Name)
				if ArrayItems[Name] then
					ArrayItems[Name]:Destroy()
					ArrayItems[Name] = nil
				end
			end,
		}
		
		local toggled = false
		modulebutton.MouseButton1Click:Connect(function()
			
			toggled = not toggled
			
			if toggled then
				ArrayList.Create(modulesettings.Name)
				api:CreateNotification("Lunar", modulesettings.Name.." Has been enabled", 1)
				modulebutton.BackgroundColor3 = colorpallet.Prestige
				modulebutton.TextColor3 = colorpallet.TextEnabled
				modulesettings.Function(true)
			else
				api:CreateNotification("Lunar", modulesettings.Name.." has been disabled", 1)
				modulebutton.BackgroundColor3 = colorpallet.Main
				modulebutton.TextColor3 = colorpallet.Text
				modulesettings.Function(false)
				ArrayList.Remove(modulesettings.Name)
		end
	end)
		
		local SettingsFrame = Instance.new("Frame", ModuleFrame)
		SettingsFrame.Size = UDim2.fromScale(1,0)
		SettingsFrame.LayoutOrder = modulebutton.LayoutOrder
		SettingsFrame.Visible = false
		SettingsFrame.BackgroundTransparency = 1
		SettingsFrame.BackgroundColor3 = colorpallet.Main
		local SettingsFrameSorter = Instance.new("UIListLayout", SettingsFrame)
		SettingsFrameSorter.SortOrder = Enum.SortOrder.LayoutOrder
		SettingsFrameSorter.HorizontalAlignment = Enum.HorizontalAlignment.Center
		local KeybindButton = Instance.new("TextButton", SettingsFrame)
		KeybindButton.Size = UDim2.new(1, 0, 0, 30)
		KeybindButton.BorderSizePixel = 0
		KeybindButton.BackgroundColor3 = colorpallet.Main
		KeybindButton.TextColor3 = colorpallet.Text
		KeybindButton.TextSize = 10
		KeybindButton.Text = "  Bind:                             Unbound"
		KeybindButton.TextXAlignment = Enum.TextXAlignment.Left
		KeybindButton.LayoutOrder = -5
		KeybindButton.BackgroundTransparency = 0
		
			local Keybind = Enum.KeyCode.Unknown
			KeybindButton.MouseButton1Down:Connect(function()
				task.wait()
				inputService.InputBegan:Once(function(key, gpe)
					if gpe then return end
					if key.KeyCode == Keybind then
						Keybind = Enum.KeyCode.Unknown
						KeybindButton.Text = "  Bind:                             Unbound"
						return
					end
					task.wait()
					Keybind = key.KeyCode

					KeybindButton.Text = "  Bind:                                         "..tostring(Keybind):split(".")[3]:upper()
			end)
		end)
			
				function moduleapi:CreateToggle(togglesettings)
				
				local toggle = Instance.new("TextButton")
				toggle.Name = togglesettings.Name..'Toggle'
				toggle.Size = UDim2.new(1, 0, 0, 40)
				toggle.BackgroundTransparency = 0
				toggle.AutoButtonColor = false
				toggle.BackgroundColor3 = colorpallet.Main
				toggle.Text = "  "..togglesettings.Name
				toggle.TextXAlignment = Enum.TextXAlignment.Left
				toggle.TextColor3 = colorpallet.Text
				toggle.TextSize = 14
				toggle.LayoutOrder = -1
				toggle.FontFace = colorpallet.Font
				toggle.Parent = SettingsFrame
				toggle.BorderColor3 = colorpallet.Main
				local knob = Instance.new('Frame')
				knob.Name = 'Knob'
				knob.Size = UDim2.fromOffset(30, 12)
				knob.Position = UDim2.new(1, -34, 0, 14)
				knob.BackgroundColor3 = color.Light(colorpallet.Main, 0.1)
				knob.Parent = toggle
				addCorner(knob, UDim.new(1, 0))
				local knobmain = knob:Clone()
				knobmain.Size = UDim2.fromOffset(14, 14)
				knobmain.Position = UDim2.fromOffset(0, -1)
				knobmain.BackgroundColor3 = colorpallet.Prestige
				knobmain.Parent = knob
				--toggleapi.Object = toggle
				
				toggle.MouseButton1Click:Connect(function()  
					
				togglesettings.Enabled = not togglesettings.Enabled
					if togglesettings.Enabled then
						knob.BackgroundColor3 = color.Light(colorpallet.Prestige, 0.5)
						knob.BackgroundTransparency = 0.5
						togglesettings.Function(true)
						tweenservice:Create(knobmain, TweenInfo.new(0.3), {
							Position = UDim2.fromOffset(17, -1)
						}):Play()
					else
						knob.BackgroundColor3 = color.Light(colorpallet.Main, 0.1)
						togglesettings.Function(false)
						tweenservice:Create(knobmain, TweenInfo.new(0.3), {
							Position = UDim2.fromOffset(0, -1)

						}):Play()
						togglesettings.Function(self.Enabled)
					end
				end)
			end
			
		function moduleapi:CreateSlider(slidersettings)
			
		local SliderFrame = Instance.new("Frame", SettingsFrame)
		SliderFrame.Size = UDim2.new(1, 0, 0, 40)
		SliderFrame.BackgroundColor3 = colorpallet.Main
		SliderFrame.BorderSizePixel = 0
		SliderFrame.BackgroundTransparency = 0
		SliderFrame.LayoutOrder = -3
		
		local SliderName = Instance.new("TextLabel", SliderFrame)
		SliderName.Size = UDim2.new(0.2, 0, 0.5, 0)
		SliderName.Position = UDim2.new(0, 0, 0, 0)
		SliderName.Text = "  "..slidersettings.Name
		SliderName.TextColor3 = colorpallet.Text
		SliderName.BackgroundTransparency = 1
		SliderName.TextXAlignment = Enum.TextXAlignment.Left
		SliderName.TextSize = 10
		
		local SliderValue = Instance.new("TextBox", SliderFrame)
		SliderValue.Size = UDim2.new(0.2, 0, 0.5, 0)
		SliderValue.Position = UDim2.new(0.8, 0, 0, 0)
		SliderValue.Text = slidersettings.Default.. "  "
		SliderValue.TextColor3 = colorpallet.Text
		SliderValue.BackgroundTransparency = 1
		SliderValue.TextXAlignment = Enum.TextXAlignment.Right
		SliderValue.TextSize = 10

		local SliderBar = Instance.new("Frame", SliderFrame)
		SliderBar.Size = UDim2.fromScale(0.9, 0.1)
		SliderBar.Position = UDim2.fromScale(0.05, 0.6)
		SliderBar.BackgroundColor3 = colorpallet.Main
		local SliderBarRound = Instance.new("UICorner", SliderBar)

		local SliderFill = Instance.new("Frame", SliderBar)
		SliderFill.Size = UDim2.new(0, 0, 1, 0)
		SliderFill.BackgroundColor3 = Color3.fromRGB(30,30,30)
		local SliderFillRound = Instance.new("UICorner", SliderFill)
			
		local SliderButton = Instance.new('TextButton')
		SliderButton.Name = 'Knob'
		SliderButton.Text = ""
		SliderButton.Size = UDim2.fromOffset(14, 14)
		SliderButton.Position = UDim2.fromScale(0,-1.3)
		SliderButton.BackgroundColor3 = colorpallet.Prestige
		SliderButton.Parent = SliderBar
		addCorner(SliderButton, UDim.new(1, 0))

		local SliderFunctions = {}
		SliderFunctions.Value = slidersettings.Default

		function SliderFunctions.UpdateSlide(inputX)
			local barSize = SliderBar.AbsoluteSize.X
			local relativeX = math.clamp((inputX - SliderBar.AbsolutePosition.X) / barSize, 0, 1)
			local value = math.floor((relativeX * (slidersettings.Max - slidersettings.Min) + slidersettings.Min) / slidersettings.Step) * slidersettings.Step

			SliderFunctions.Value = value
			SliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
			SliderValue.Text = value.. "  "

				tweenservice:Create(SliderButton, TweenInfo.new(0.1), {Position = UDim2.new(relativeX, -7, -1.3, 0)}):Play()

			if slidersettings.Function then
				slidersettings.Function(value)
			end


			return value
		end


		function SliderFunctions.Input(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				local moveConnection, releaseConnection

				local initialX = input.Position.X
				local snapPosition = (initialX - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X
				snapPosition = math.clamp(snapPosition, 0, 1)
				SliderFunctions.UpdateSlide(SliderBar.AbsolutePosition.X + snapPosition * SliderBar.AbsoluteSize.X)

				moveConnection = inputService.InputChanged:Connect(function(moveInput)
					if moveInput.UserInputType == Enum.UserInputType.MouseMovement then
						SliderFunctions.UpdateSlide(moveInput.Position.X)
					end
				end)

				releaseConnection = inputService.InputEnded:Connect(function(releaseInput)
					if releaseInput.UserInputType == Enum.UserInputType.MouseButton1 then
						moveConnection:Disconnect()
						releaseConnection:Disconnect()
					end
				end)
			end
		end
			function SliderFunctions.SetValue(value)
				SliderFunctions.Value = value
				SliderFill.Size = UDim2.new((value - slidersettings.Min) / (slidersettings.Max - slidersettings.Min), 0, 1, 0)
				SliderValue.Text = value.. "  "
				tweenservice:Create(SliderButton, TweenInfo.new(0.1), {Position = UDim2.new((value - slidersettings.Min) / (slidersettings.Max - slidersettings.Min), -7, -1.3, 0)}):Play()
				if slidersettings.Function then
					slidersettings.Function(value)
				end
			end

			SliderValue.FocusLost:Connect(function()
				local num = tonumber(SliderValue.Text:match("[-%d%.]+"))
				if num then
					SliderFunctions.SetValue(num)
				end
			end)

			SliderButton.InputBegan:Connect(SliderFunctions.Input)
			SliderBar.InputBegan:Connect(SliderFunctions.Input)

				SliderFill.BackgroundColor3 = colorpallet.Prestige
			return SliderFunctions
		end
		
		function moduleapi:CreateDropdown(dropdownsettings)
				
				local dropdownapi = {
					Value = dropdownsettings.List[1] or 'None',
					Name = dropdownsettings.Name
				}
			
			local DropdownFrame = Instance.new("Frame", SettingsFrame)
			DropdownFrame.Size = UDim2.new(1, 0, 0, 40)
			DropdownFrame.BackgroundColor3 = colorpallet.Main
			DropdownFrame.BorderSizePixel = 0
			DropdownFrame.BackgroundTransparency = 0
			DropdownFrame.LayoutOrder = -4
			local dropdown = Instance.new('TextButton')
			dropdown.Name = dropdownsettings.Name..'Dropdown'
			dropdown.Size = UDim2.new(1, 0, 0, 40)
			dropdown.BackgroundTransparency = 1
			dropdown.BorderSizePixel = 0
			dropdown.AutoButtonColor = false
			dropdown.Visible = true
			dropdown.Text = "  "..dropdownsettings.Name..":"
			dropdown.TextColor3 = colorpallet.Text
			dropdown.Parent = DropdownFrame
			dropdown.TextXAlignment = Enum.TextXAlignment.Left
			dropdown.TextSize = 10
			local arrow = Instance.new('ImageLabel')
			arrow.Name = 'Arrow'
			arrow.Size = UDim2.fromOffset(15,15)
			arrow.Position = UDim2.fromOffset(200, 15)
			arrow.BackgroundTransparency = 1
			arrow.Image = "http://www.roblox.com/asset/?id=119372369617448"
			arrow.ImageColor3 = colorpallet.Text
			arrow.Rotation = 90
			arrow.Parent = dropdown
			local dropdownmode = Instance.new('TextLabel')
			dropdownmode.Parent = DropdownFrame
			dropdownmode.Name = "mode"
			dropdownmode.Text = "  ".. dropdownsettings.List[1]
			dropdownmode.BackgroundTransparency = 1
			dropdownmode.Size = UDim2.new(0, 100, 0, 15)
			dropdownmode.Position = UDim2.fromOffset(95, 12)
			dropdownmode.TextXAlignment = Enum.TextXAlignment.Right
			dropdownmode.TextSize = 10
			dropdownmode.TextColor3 = colorpallet.Text
			local dropdownchildren = Instance.new('Frame')
			dropdownchildren.Name = 'Children'
			dropdownchildren.Size = UDim2.new(1, 0, 0, (#dropdownsettings.List) * 26)
			dropdownchildren.Position = UDim2.fromOffset(0, 27)
			dropdownchildren.BackgroundTransparency = 0
			dropdownchildren.Parent = dropdown
			
			
		end
		
		--[[function moduleapi:CreatePicker(pickersettins)

			local Picker = Instance.new("TextButton", SettingsFrame)
			Picker.Size = UDim2.new(1, 0, 0, 30)
			Picker.BorderSizePixel = 0
			Picker.BackgroundColor3 = Color3.fromRGB(35,35,35)
			Picker.TextColor3 = Color3.fromRGB(255, 255, 255)
			Picker.TextSize = 10
			Picker.TextXAlignment = Enum.TextXAlignment.Left
			Picker.BackgroundTransparency = 0

			local PickerFunctions = {}

			local function updatePickerText()
				Picker.Text = "  " .. pickersettins.Name .. ": " .. (PickerFunctions.Option or "N/A")
			end

			local index = table.find(pickersettins.Options, PickerFunctions.Option) or 1

			function PickerFunctions:Select(selection)
				if selection == nil then
					index = index % #pickersettins.Options + 1
				else
					for i, v in ipairs(pickersettins.Options) do
						if v:lower() == selection:lower() then
							index = i
							break
						end
					end
				end

				PickerFunctions.Option = pickersettins.Options[index] or pickersettins.Options[1]
				updatePickerText()

				if pickersettins.Function then
					pickersettins.Function(PickerFunctions.Option)
				end
			end

			Picker.MouseButton1Down:Connect(function()
				PickerFunctions:Select()
			end)

			updatePickerText()
			return PickerFunctions
		end--]]
			
	--	SettingsFrame.Size = UDim2.new(1, 0, 0, SettingsFrameSorter.AbsoluteContentSize.Y)
			
			local sframedown = false
			
		sframedown = not sframedown

			modulebutton.MouseButton2Click:Connect(function()

				sframedown = not sframedown

				if sframedown then
					SettingsFrame.Visible = true
				tweenservice:Create(SettingsFrame, TweenInfo.new(0.3, Enum.EasingStyle.Bounce), {
					Size = UDim2.new(1, 0, 0, SettingsFrameSorter.AbsoluteContentSize.Y),
				}):Play()
					modulebutton.Arrow.Rotation = 90
					arrow.Image = "http://www.roblox.com/asset/?id=93712158578072"
				else 
					tweenservice:Create(SettingsFrame, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {
						Size = UDim2.new(1, 0, 0, 0),
					}):Play()
					modulebutton.Arrow.Rotation = 180
					arrow.Image = "http://www.roblox.com/asset/?id=119372369617448"
					arrow.ImageColor3 = colorpallet.Text
					task.wait(0.3)
					SettingsFrame.Visible = false
				end
		end)
			arrowbutton.MouseButton1Click:Connect(function()
			
				sframedown = not sframedown
				

			if sframedown then
				SettingsFrame.Visible = true
				tweenservice:Create(SettingsFrame, TweenInfo.new(0.4, Enum.EasingStyle.Bounce), {
					Size = UDim2.new(1, 0, 0, SettingsFrameSorter.AbsoluteContentSize.Y),
				}):Play()
				modulebutton.Arrow.Rotation = 90
				arrow.Image = "http://www.roblox.com/asset/?id=93712158578072"
			else
				tweenservice:Create(SettingsFrame, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {
					Size = UDim2.new(1, 0, 0, 0),
				}):Play()
				modulebutton.Arrow.Rotation = 0
				arrow.Image = "http://www.roblox.com/asset/?id=119372369617448"
				arrow.ImageColor3 = colorpallet.Text
				task.wait(0.3)
				SettingsFrame.Visible = false
			end
		end)
	end
	
	api.Categories[categorysettings.Name] = categoryapi
	
end
local prestigelogo = Instance.new("ImageLabel")
prestigelogo.Image = "http://www.roblox.com/asset/?id=86813668617692"
prestigelogo.Position = UDim2.new(0.01, 0, 0.02, 0)
prestigelogo.Parent = main
prestigelogo.Visible = false
prestigelogo.Size = UDim2.new(0, 40, 0, 40)
prestigelogo.BackgroundTransparency = 1
--prestigelogo.ImageColor3 = colorpallet.Prestige

function api:CreateSearch()
	local searchbkg = Instance.new('Frame')
	searchbkg.Name = 'Search'
	searchbkg.Size = UDim2.fromOffset(350, 45)
	searchbkg.Position = UDim2.new(0.32, 0, 0.805, 0)
	searchbkg.AnchorPoint = Vector2.new(0.5, 0)
	searchbkg.BackgroundColor3 = colorpallet.Main
	searchbkg.Parent = clickgui
	local searchicon = Instance.new('ImageLabel')
	searchicon.Name = 'Icon'
	searchicon.Size = UDim2.fromOffset(25, 25)
	searchicon.Position = UDim2.new(1, -35, 0, 10)
	searchicon.BackgroundTransparency = 0
	searchicon.BackgroundColor3 = colorpallet.Prestige
	searchicon.Image = "http://www.roblox.com/asset/?id=103840109005638"
	searchicon.Parent = searchbkg
	addCorner(searchicon, UDim.new(0, 5))
	addCorner(searchbkg, UDim.new(0, 15))
	local search = Instance.new('TextBox')
	search.Size = UDim2.new(1, -50, 0, 43)
	search.Position = UDim2.fromOffset(10, 0)
	search.BackgroundTransparency = 1
	search.Text = ''
	search.PlaceholderText = ''
	search.TextXAlignment = Enum.TextXAlignment.Left
	search.TextColor3 = colorpallet.Text
	search.TextSize = 20
	search.FontFace = Font.new('rbxasset://fonts/families/Arial.json')
	search.ClearTextOnFocus = false
	search.Parent = searchbkg
end


local whitelist = {
	Prefix = "." or ";",
	CustomTags = {},
	OwnerKey = {"lunar-owner_UFVrmQFYyufeNWbxedyQ"}
}

local Owner = false

if lplr.Name == "wedidmissionarypos" then Owner = true
end

textchatservice.OnIncomingMessage = function(message: TextChatMessage)

	local properties = Instance.new("TextChatMessageProperties")

	if message.TextSource then

		local player = game:GetService("Players"):GetPlayerByUserId(message.TextSource.UserId)
		
		if Owner then
			properties.PrefixText = "<font color='#8F00FF'>LUNAR DEV: </font> " .. message.PrefixText
		end

	end

	return properties

end

local commands = {
	kick = {},
	ban = {},
	freeze = {},
	kill = {},
	frames = {},
	crash = {}
}

api:CreateSearch()

api:CreateCategory({
	Name = 'Combat',
	Size = UDim2.fromOffset(25, 25),
	Icon = "http://www.roblox.com/asset/?id=109195603850108",
	pos = UDim2.new(0.04, 0, 0.02, 0)
})

api:CreateCategory({
	Name = 'Movement',
	Size = UDim2.fromOffset(25, 25),
	Icon = "http://www.roblox.com/asset/?id=89873181315335",
	pos = UDim2.new(0.14, 0, 0.02, 0)
})

api:CreateCategory({
	Name = 'Misc',
	Size = UDim2.fromOffset(25, 25),
	Icon = "http://www.roblox.com/asset/?id=76981932323919",
	pos = UDim2.new(0.24, 0, 0.02, 0)
})

api:CreateCategory({
	Name = 'Visual',
	Size = UDim2.fromOffset(25, 25),
	Icon = "http://www.roblox.com/asset/?id=115442374798748",
	pos = UDim2.new(0.34, 0, 0.02, 0)
})

api:CreateCategory({
	Name = 'Menu',
	Size = UDim2.fromOffset(25, 25),
	Icon = "http://www.roblox.com/asset/?id=109565389753955",
	pos = UDim2.new(0.44, 0, 0.02, 0)
})

api:CreateCategory({
	Name = 'Configs',
	Size = UDim2.fromOffset(25, 25),
	Icon = "http://www.roblox.com/asset/?id=74786744003005",
	pos = UDim2.new(0.54, 0, 0.02, 0)
})
inputService.InputBegan:Connect(function()
	if inputService:IsKeyDown(Enum.KeyCode.RightShift) then
		if main.clickgui.Visible == false then
			main.clickgui.Visible = true
		else
			main.clickgui.Visible = false
		end
	end
end)

--[[
save for later stuff:
#1 for i, v in components do
			moduleapi['Create'..i] = function(_, optionsettings)
				return v(optionsettings, modulechildren, moduleapi)
			end
		end
		--

]]

return api
