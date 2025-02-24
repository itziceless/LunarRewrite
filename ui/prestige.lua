local PlayerService = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local Debris = game:GetService("Debris")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local lplr = PlayerService.LocalPlayer

local GuiLibrary = {
	ThemeUpdate = Instance.new("BindableEvent"),
	Theme = Color3.fromRGB(0, 200, 255),
	Windows = {}
}

local function darkenColor(clr, value)
	return Color3.fromRGB((clr.R * value) * 255,(clr.G * value) * 255,(clr.B * value) * 255)
end

local isfile = isfile or function(...)
	return false
end

local readfile = readfile or function(...)
	return '{"Toggles":[],"Sliders":[],"Pickers":[],"Buttons":[]}'
end

local isfolder = isfolder or function(...)
	return ...
end

local makefolder = makefolder or function(...)
	return ...
end

local writefile = writefile or function(...)
	return ...
end

local delfile = delfile or function(...)
	return ...
end

local start = tick()

local Config = {
	Buttons = {},
	Toggles = {},
	Sliders = {},
	Pickers = {}
}

if not isfolder("Moon") then
	makefolder("Moon")
	makefolder("Moon/Configs")
end

local canSave = true

local configPath = "Moon/Configs/"..game.PlaceId..".json"

local function saveconfig()
	if not canSave then return end

	if isfile(configPath) then
		delfile(configPath)
	end

	writefile(configPath, HttpService:JSONEncode(Config))
end

local function loadconfig()
	Config = HttpService:JSONDecode(readfile(configPath))
end

local Assets = {
	Glow = "rbxassetid://10822615828",
	Settings = "rbxassetid://11295281111",
	Info = "rbxassetid://11422155687",
	Success = "rbxassetid://11419719540",
	Error = "rbxassetid://11419709766",
	Circle = "rbxassetid://10928806245",
	Logo = "rbxassetid://12543567695"
}

if not isfile(configPath) then
	saveconfig()
	task.wait()
end

loadconfig()

local ScreenGui = Instance.new("ScreenGui", gethui and gethui() or lplr.PlayerGui)
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

local NotificationFrame = Instance.new("Frame", ScreenGui)
NotificationFrame.Size = UDim2.fromScale(0.3, 0.9)
NotificationFrame.Position = UDim2.fromScale(0.7,0)
NotificationFrame.BackgroundTransparency = 1
local NotificationFrameSorter = Instance.new("UIListLayout", NotificationFrame)
NotificationFrameSorter.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotificationFrameSorter.HorizontalAlignment = Enum.HorizontalAlignment.Right
NotificationFrameSorter.Padding = UDim.new(0.015,0)

local SubArrayListFrame = Instance.new("Frame", ScreenGui)
SubArrayListFrame.Size = UDim2.fromScale(0.2,0.7)
SubArrayListFrame.Position = UDim2.fromScale(0.7,0.25)
SubArrayListFrame.BackgroundTransparency = 1
SubArrayListFrame.Visible = false

local ArrayListFrame = Instance.new("Frame", SubArrayListFrame)
ArrayListFrame.Size = UDim2.fromScale(1, 1)
ArrayListFrame.Position = UDim2.fromScale(0.7,0.25)
ArrayListFrame.BackgroundTransparency = 1
ArrayListFrame.Visible = true
local ArrayListFrameSorter = Instance.new("UIListLayout", ArrayListFrame)
ArrayListFrameSorter.HorizontalAlignment = Enum.HorizontalAlignment.Right
ArrayListFrameSorter.SortOrder = Enum.SortOrder.LayoutOrder

local Logo = Instance.new("ImageLabel", SubArrayListFrame)
Logo.Size = UDim2.fromScale(1,0.5)
Logo.Position = UDim2.fromScale(0,-0.2)
Logo.BackgroundTransparency = 1
Logo.Visible = false
Logo.Image = Assets.Logo
Logo.ImageColor3 = GuiLibrary.Theme

local LogoText = Instance.new("TextLabel", SubArrayListFrame)
LogoText.Size = UDim2.fromScale(1,0.2)
LogoText.Position = UDim2.fromScale(0.58,0.15)
LogoText.BackgroundTransparency = 1
LogoText.Visible = false
LogoText.Text = "MOON"
LogoText.TextColor3 = GuiLibrary.Theme
LogoText.TextSize = 30
LogoText.TextXAlignment = Enum.TextXAlignment.Center

local function getAccurateTextSize(text, size)
	return TextService:GetTextSize(text, size, Enum.Font.SourceSans, Vector2.zero).X
end

local TargetHud = {}

local TargetHudFrame = Instance.new("Frame", ScreenGui)
TargetHudFrame.Visible = false
TargetHudFrame.Size = UDim2.fromScale(0.125, 0.06)
TargetHudFrame.Position = UDim2.fromScale(0.6,0.5)
TargetHudFrame.BorderSizePixel = 0
TargetHudFrame.BackgroundTransparency = 0.5
TargetHudFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
Instance.new("UICorner", TargetHudFrame)

local TargetHudImage = Instance.new("ImageLabel", TargetHudFrame)
TargetHudImage.Size = UDim2.fromScale(0.2,0.8)
TargetHudImage.Position = UDim2.fromScale(0.03,0.1)
TargetHudImage.BorderSizePixel = 0
TargetHudImage.BackgroundTransparency = 0.5
TargetHudImage.BackgroundColor3 = Color3.fromRGB(0,0,0)
Instance.new("UICorner", TargetHudImage).CornerRadius = UDim.new(0.25,0)

local TargetHudName = Instance.new("TextLabel", TargetHudFrame)
TargetHudName.Text = "Username"
TargetHudName.Position = UDim2.fromScale(0.26,0.25)
TargetHudName.TextColor3 = Color3.fromRGB(255,255,255)
TargetHudName.Size = UDim2.fromScale(0.6, 0.05)
TargetHudName.TextSize = 11
TargetHudName.TextXAlignment = Enum.TextXAlignment.Left
TargetHudName.BackgroundTransparency = 1

local TargetHudHealthbarBack = Instance.new("Frame", TargetHudFrame)
TargetHudHealthbarBack.Position = UDim2.fromScale(0.26, 0.49)
TargetHudHealthbarBack.Size = UDim2.fromScale(0.67,0.33)
TargetHudHealthbarBack.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner", TargetHudHealthbarBack).CornerRadius = UDim.new(0.4,0)

local TargetHudHealthbar = Instance.new("Frame", TargetHudHealthbarBack)
TargetHudHealthbar.Size = UDim2.fromScale(1,1)
TargetHudHealthbar.BackgroundColor3 = GuiLibrary.Theme
Instance.new("UICorner", TargetHudHealthbar).CornerRadius = UDim.new(0.4,0)

GuiLibrary.ThemeUpdate.Event:Connect(function(newTheme)
	TargetHudHealthbar.BackgroundColor3 = newTheme
end)

local TargetHudEvent

function TargetHud.SetTarget(player)
	task.spawn(function()
		if player and player.Character and player.Character:FindFirstChild("Humanoid") then
			TargetHudFrame.Visible = true
			TargetHudName.Text = player.DisplayName
			TargetHudImage.Image = PlayerService:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size60x60)
			local lasthp = player.Character.Humanoid.Health
			TargetHudEvent = player.Character.Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
				TweenService:Create(TargetHudHealthbar, TweenInfo.new(0.1), {
					Size = UDim2.fromScale(player.Character.Humanoid.Health / player.Character.Humanoid.MaxHealth, 1)
				}):Play()

				if player.Character.Humanoid.Health < lasthp then
					TweenService:Create(TargetHudImage, TweenInfo.new(0.1), {
						BackgroundColor3 = Color3.fromRGB(150,0,0)
					}):Play()
					task.delay(0.1, function()
						TweenService:Create(TargetHudImage, TweenInfo.new(0.1), {
							BackgroundColor3 = Color3.fromRGB(0,0,0)
						}):Play()
					end)
				end

				lasthp = player.Character.Humanoid.Health
			end)
		end
	end)
end

function TargetHud.Clear()
	task.spawn(function()

		TargetHudFrame.Visible = false

		pcall(function()
			TargetHudEvent:Disconnect()
		end)
	end)
end

GuiLibrary.TargetHud = TargetHud

local ArrayItems = {}
local ArrayList = {
	Create = function(name)
		local Item = Instance.new("TextLabel", ArrayListFrame)
		Item.Text = name
		Item.TextSize = 22
		Item.TextColor3 = GuiLibrary.Theme
		Item.BackgroundTransparency = 0.5
		Item.BorderSizePixel = 0
		Item.Font = Enum.Font.SourceSans
		Item.ZIndex = 3

		local size = getAccurateTextSize(name, 22)

		Item.Size = UDim2.new(0.03, size, 0.048, 0)
		Item.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

		local Shadow = Item:Clone()
		Shadow.Parent = Item
		Shadow.TextColor3 = Color3.fromRGB(50,50,50)
		Shadow.Size = UDim2.fromScale(1,1)
		Shadow.Position = UDim2.fromScale(0.02,0.02)
		Shadow.ZIndex = 2		
		Shadow.BackgroundTransparency = 1
		Shadow.Name = "Shadow"
		Shadow.Visible = false

		local Line = Instance.new("Frame", Item)
		Line.Name = "Line"
		Line.Size = UDim2.new(0,3,1,0)
		Line.BorderSizePixel = 0
		Line.BackgroundColor3 = GuiLibrary.Theme
		Line.Position = UDim2.fromScale(1,0)

		ArrayItems[name] = Item

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

	Remove = function(name)
		pcall(function()
			if ArrayItems[name] then
				ArrayItems[name]:Destroy()
				ArrayItems[name] = nil
			end

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
		end)
	end,
}

task.spawn(function()
	repeat task.wait()
		pcall(function()

			local SortedArray = {}
			for i, v in pairs(ArrayItems) do
				table.insert(SortedArray, v)
			end

			table.sort(SortedArray, function(a, b)
				return getAccurateTextSize(a.Text, a.TextSize) > getAccurateTextSize(b.Text, b.TextSize)
			end)

			local index = 0
			for i,v in ipairs(SortedArray) do
				index += 1
				v.BackgroundTransparency = ArrayBackground.Enabled and 0.4 or 1
				v.Line.BackgroundTransparency = ArrayLine.Enabled and 0 or 1
				v.Shadow.Visible = ArrayShadow.Enabled

				if CustomThemeRainbow.Enabled then
					local hue = (tick() * 0.5 + (index / #SortedArray)) % 1
					local rainbowColor = Color3.fromHSV(hue, 1, 1)

					v.TextColor3 = rainbowColor
					v.Line.BackgroundColor3 = rainbowColor
				else
					v.TextColor3 = GuiLibrary.Theme
					v.Line.BackgroundColor3 = GuiLibrary.Theme
				end

			end

			table.clear(SortedArray)
		end)
	until false
end)

function GuiLibrary:CreateNotification(text, duration)

	local Notification = Instance.new("TextLabel", NotificationFrame)
	Notification.BorderSizePixel = 0
	Notification.BackgroundColor3 = Color3.fromRGB(40,40,40)
	Notification.Text = "  "..text
	Notification.TextColor3 = Color3.fromRGB(255,255,255)
	Notification.TextSize = 22
	Notification.TextXAlignment = Enum.TextXAlignment.Left
	Notification.Font = Enum.Font.SourceSans
	Notification.BackgroundTransparency = 0.5

	local size = getAccurateTextSize("  "..text, 22)

	Notification.Size = UDim2.new(0.05,size,0.055,0)

	local NotificationDuration = Instance.new("Frame", Notification)
	NotificationDuration.Size = UDim2.fromScale(1, 0.05)
	NotificationDuration.BorderSizePixel = 0
	NotificationDuration.BackgroundColor3 = GuiLibrary.Theme
	NotificationDuration.Position = UDim2.fromScale(0,0.95)

	local themeEvent = GuiLibrary.ThemeUpdate.Event:Connect(function(newTheme)
		NotificationDuration.BackgroundColor3 = newTheme
	end)

	TweenService:Create(NotificationDuration, TweenInfo.new(duration + 0.3), {
		Size = UDim2.fromScale(0, 0.05)
	}):Play()

	task.delay(duration, function()
		TweenService:Create(Notification, TweenInfo.new(0.3), {
			Size = UDim2.fromScale(0, 0.055)
		}):Play()

		Debris:AddItem(Notification, 0.35)

		task.delay(0.35, function()
			themeEvent:Disconnect()
		end)
	end)
end

local WindowPositionConfig = {}

if isfile("Moon/GuiLocations.json") then
	WindowPositionConfig = HttpService:JSONDecode(readfile("Moon/GuiLocations.json"))
end

local WindowCount = 0
function GuiLibrary:CreateWindow(name)

	if WindowPositionConfig[name] == nil then
		WindowPositionConfig[name] = {x = nil, y = nil}
	end

	local Top = Instance.new("TextLabel", ScreenGui)
	Top.Size = UDim2.fromScale(0.1, 0.04)
	Top.Position = UDim2.fromScale(0.15 + (0.12 * WindowCount), 0.15)
	Top.BorderSizePixel = 0
	Top.BackgroundColor3 = GuiLibrary.Theme
	Top.Text = "  "..name
	Top.TextColor3 = Color3.fromRGB(255,255,255)
	Top.TextSize = 12
	Top.TextXAlignment = Enum.TextXAlignment.Left
	Top.BackgroundTransparency = 0.25
	Top.Draggable = true
	Top.Active = true
	Top.DragStopped:Connect(function(x, y)
		WindowPositionConfig[name].x = x
		WindowPositionConfig[name].y = y
		task.delay(0.1,function()
			if isfile("Moon/GuiLocations.json") then
				delfile("Moon/GuiLocations.json")
			end
			writefile("Moon/GuiLocations.json", HttpService:JSONEncode(WindowPositionConfig))
		end)
	end)

	if WindowPositionConfig[name].x ~= nil then
		Top.Position = UDim2.fromOffset(WindowPositionConfig[name].x,WindowPositionConfig[name].y)
	end

	GuiLibrary.ThemeUpdate.Event:Connect(function(newTheme)
		Top.BackgroundColor3 = newTheme
	end)

	local ModuleFrame = Instance.new("ScrollingFrame", Top)
	ModuleFrame.Position = UDim2.fromScale(0,1)
	ModuleFrame.Size = UDim2.fromScale(1,15)
	ModuleFrame.BackgroundTransparency = 1
	local ModuleFrameSorter = Instance.new("UIListLayout", ModuleFrame)
	ModuleFrameSorter.SortOrder = Enum.SortOrder.LayoutOrder

	local Modules = {}

	GuiLibrary.Windows[name] = {
		CreateModuleButton = function(tab)

			if Config.Buttons[tab.Name] == nil then
				Config.Buttons[tab.Name] = {Enabled = false, Keybind = "Unknown"}
			end

			local Button = Instance.new("TextButton", ModuleFrame)
			Button.Size = UDim2.fromScale(1,0.07)
			Button.BorderSizePixel = 0
			Button.BackgroundColor3 = Color3.fromRGB(50,50,50)
			Button.TextColor3 = Color3.fromRGB(255,255,255)
			Button.TextSize = 10
			Button.Text = "  "..tab.Name
			Button.TextXAlignment = Enum.TextXAlignment.Left
			Button.LayoutOrder = #ModuleFrame:GetChildren()
			Button.BorderSizePixel = 0
			Button.BackgroundTransparency = 0.5

			local SettingsLogo = Instance.new("ImageLabel", Button)
			SettingsLogo.BackgroundTransparency = 1
			SettingsLogo.Image = Assets.Settings
			SettingsLogo.Size = UDim2.new(0.16, 0, 0,25)
			SettingsLogo.Position = UDim2.fromScale(0.84,0.12)
			SettingsLogo.ZIndex = 4

			local SettingsFrame = Instance.new("Frame", ModuleFrame)
			SettingsFrame.Size = UDim2.fromScale(1,0)
			SettingsFrame.AutomaticSize = Enum.AutomaticSize.Y
			SettingsFrame.LayoutOrder = Button.LayoutOrder + 1
			SettingsFrame.Visible = false
			SettingsFrame.BackgroundTransparency = 1

			local KeybindButton = Instance.new("TextButton", SettingsFrame)
			KeybindButton.Size = UDim2.new(1, 0, 0, 30)
			KeybindButton.BorderSizePixel = 0
			KeybindButton.BackgroundColor3 = Color3.fromRGB(35,35,35)
			KeybindButton.TextColor3 = Color3.fromRGB(255,255,255)
			KeybindButton.TextSize = 10
			KeybindButton.Text = "  Keybind: NONE"
			KeybindButton.TextXAlignment = Enum.TextXAlignment.Left
			KeybindButton.LayoutOrder = 1
			KeybindButton.BackgroundTransparency = 0.5

			local KeybindConnection
			local Keybind = Enum.KeyCode.Unknown
			KeybindButton.MouseButton1Down:Connect(function()
				task.wait()
				UserInputService.InputBegan:Once(function(key, gpe)
					if gpe then return end
					if key.KeyCode == Keybind then
						Keybind = Enum.KeyCode.Unknown
						return
					end
					task.wait()
					Keybind = key.KeyCode

					KeybindButton.Text = "  Keybind: "..tostring(Keybind):split(".")[3]:upper()

					Config.Buttons[tab.Name].Keybind = tostring(Keybind):split(".")[3]:upper()
					task.delay(0.1, saveconfig)
				end)
			end)

			local KeybindSideLine = Instance.new("Frame", KeybindButton)
			KeybindSideLine.Size = UDim2.fromScale(0.015,1)
			KeybindSideLine.Position = UDim2.fromScale(0,0)
			KeybindSideLine.BorderSizePixel = 0
			KeybindSideLine.BackgroundColor3 = GuiLibrary.Theme


			GuiLibrary.ThemeUpdate.Event:Connect(function(newTheme)
				KeybindSideLine.BackgroundColor3 = darkenColor(newTheme, 0.6)
			end)


			local SettingsFrameSorter = Instance.new("UIListLayout", SettingsFrame)
			SettingsFrameSorter.SortOrder = Enum.SortOrder.LayoutOrder
			SettingsFrameSorter.FillDirection = Enum.FillDirection.Vertical
			SettingsFrameSorter.VerticalAlignment = Enum.VerticalAlignment.Bottom

			local ButtonFunctions = {Enabled = false}
			local DuplicateButton
			local DuplicateConnection
			local DuplicateColorConnection
			local DuplicateB2Connection

			function ButtonFunctions:Toggle()
				ButtonFunctions.Enabled = not ButtonFunctions.Enabled

				if ButtonFunctions.Enabled then
					DuplicateButton = Button:Clone()
					DuplicateButton.ImageLabel:Destroy()
					DuplicateButton.ZIndex = 2
					DuplicateButton.Parent = Button
					DuplicateButton.Size = UDim2.fromScale(0,1)
					DuplicateButton.BackgroundColor3 = GuiLibrary.Theme
					DuplicateButton.BackgroundTransparency = 0.5
					TweenService:Create(DuplicateButton, TweenInfo.new(0.3), {
						Size = UDim2.fromScale(1,1)
					}):Play()

					DuplicateConnection = DuplicateButton.MouseButton1Down:Connect(function()
						ButtonFunctions:Toggle()
					end)
					DuplicateB2Connection = DuplicateButton.MouseButton2Down:Connect(function()
						SettingsFrame.Visible = not SettingsFrame.Visible
					end)
					DuplicateColorConnection = GuiLibrary.ThemeUpdate.Event:Connect(function(newTheme)
						if CustomThemeRainbow.Enabled then
							DuplicateButton.BackgroundColor3 = darkenColor(newTheme,0.8)
							return
						end


						DuplicateButton.BackgroundColor3 = newTheme
					end)
					ArrayList.Create(tab.Name)
					GuiLibrary:CreateNotification("Module ".. tab.Name .." has been Enabled!", 1)
				else
					ArrayList.Remove(tab.Name)
					TweenService:Create(DuplicateButton, TweenInfo.new(0.3), {
						Size = UDim2.fromScale(0,1)
					}):Play()

					task.delay(0.3, function()
						DuplicateButton:Destroy()
						pcall(function()
							DuplicateConnection:Disconnect()
							DuplicateColorConnection:Disconnect()
							DuplicateB2Connection:Disconnect()
						end)
					end)

					GuiLibrary:CreateNotification("Module ".. tab.Name .." has been Disabled!", 1)
				end

				Config.Buttons[tab.Name].Enabled = ButtonFunctions.Enabled

				task.spawn(tab.Function, ButtonFunctions.Enabled)

				task.delay(0.1, saveconfig)
			end

			function ButtonFunctions.CreateToggle(tab2)
				local toggleKey = tab.Name.."_"..tab2.Name

				if type(Config.Toggles[toggleKey]) ~= "table" then
					Config.Toggles[toggleKey] = {Enabled = false}
				elseif Config.Toggles[toggleKey].Enabled == nil then
					Config.Toggles[toggleKey].Enabled = false
				end

				local Toggle = Instance.new("TextButton", SettingsFrame)
				Toggle.Size = UDim2.new(1, 0, 0, 30)
				Toggle.BorderSizePixel = 0
				Toggle.BackgroundColor3 = Color3.fromRGB(35,35,35)
				Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
				Toggle.TextSize = 10
				Toggle.Text = "  " .. tab2.Name
				Toggle.TextXAlignment = Enum.TextXAlignment.Left
				Toggle.BackgroundTransparency = 0.5

				local SettingsSideLine = Instance.new("Frame", Toggle)
				SettingsSideLine.Size = UDim2.fromScale(0.015, 1)
				SettingsSideLine.Position = UDim2.fromScale(0, 0)
				SettingsSideLine.BorderSizePixel = 0
				SettingsSideLine.BackgroundColor3 = darkenColor(GuiLibrary.Theme, 0.6)

				local ToggleFunctions = {Enabled = false}

				local FakeToggleText = Toggle:Clone()
				FakeToggleText.Frame:Destroy()
				FakeToggleText.Visible = false
				FakeToggleText.BackgroundTransparency = 1
				FakeToggleText.ZIndex = 6
				FakeToggleText.Parent = Toggle
				FakeToggleText.Size = UDim2.fromScale(1, 1)

				function ToggleFunctions:Toggle()
					ToggleFunctions.Enabled = not ToggleFunctions.Enabled

					if tab2.Function then
						tab2.Function(ToggleFunctions.Enabled)
					end

					if ToggleFunctions.Enabled then
						TweenService:Create(SettingsSideLine, TweenInfo.new(0.3), {
							Size = UDim2.fromScale(1, 1),
							BackgroundTransparency = 0.5
						}):Play()
						FakeToggleText.Visible = true
					else
						TweenService:Create(SettingsSideLine, TweenInfo.new(0.3), {
							Size = UDim2.fromScale(0.015, 1),
							BackgroundTransparency = 0
						}):Play()
						task.delay(0.3, function()
							FakeToggleText.Visible = false
						end)
					end

					if type(Config.Toggles[toggleKey]) ~= "table" then
						Config.Toggles[toggleKey] = {}
					end
					Config.Toggles[toggleKey].Enabled = ToggleFunctions.Enabled

					task.delay(0.1, saveconfig)
				end

				Toggle.MouseButton1Down:Connect(function()
					ToggleFunctions:Toggle()
				end)

				FakeToggleText.MouseButton1Down:Connect(function()
					ToggleFunctions:Toggle()
				end)

				if Config.Toggles[toggleKey].Enabled then
					ToggleFunctions:Toggle()
				end

				GuiLibrary.ThemeUpdate.Event:Connect(function(newTheme)
					SettingsSideLine.BackgroundColor3 = darkenColor(newTheme, 0.6)
				end)

				return ToggleFunctions
			end


			function ButtonFunctions.CreatePicker(tab2)
				local pickerKey = tab.Name .. "_" .. tab2.Name

				if not Config.Pickers[pickerKey] or not Config.Pickers[pickerKey].Option then
					Config.Pickers[pickerKey] = { Option = tab2.Options[1] }
				end

				local Picker = Instance.new("TextButton", SettingsFrame)
				Picker.Size = UDim2.new(1, 0, 0, 30)
				Picker.BorderSizePixel = 0
				Picker.BackgroundColor3 = Color3.fromRGB(35,35,35)
				Picker.TextColor3 = Color3.fromRGB(255, 255, 255)
				Picker.TextSize = 10
				Picker.TextXAlignment = Enum.TextXAlignment.Left
				Picker.BackgroundTransparency = 0.5

				local SettingsSideLine = Instance.new("Frame", Picker)
				SettingsSideLine.Size = UDim2.fromScale(0.015, 1)
				SettingsSideLine.Position = UDim2.fromScale(0, 0)
				SettingsSideLine.BorderSizePixel = 0
				SettingsSideLine.BackgroundColor3 = GuiLibrary.Theme

				local PickerFunctions = { Option = Config.Pickers[pickerKey].Option }

				local function updatePickerText()
					Picker.Text = "  " .. tab2.Name .. ": " .. (PickerFunctions.Option or "N/A")
				end

				local index = table.find(tab2.Options, PickerFunctions.Option) or 1

				function PickerFunctions:Select(selection)
					if selection == nil then
						index = index % #tab2.Options + 1
					else
						for i, v in ipairs(tab2.Options) do
							if v:lower() == selection:lower() then
								index = i
								break
							end
						end
					end

					PickerFunctions.Option = tab2.Options[index] or tab2.Options[1]
					Config.Pickers[pickerKey].Option = PickerFunctions.Option
					updatePickerText()
					task.delay(0.1, saveconfig)

					if tab2.Function then
						tab2.Function(PickerFunctions.Option)
					end
				end

				Picker.MouseButton1Down:Connect(function()
					PickerFunctions:Select()
				end)

				GuiLibrary.ThemeUpdate.Event:Connect(function(newTheme)
					SettingsSideLine.BackgroundColor3 = darkenColor(newTheme, 0.6)
				end)

				updatePickerText()
				return PickerFunctions
			end



			function ButtonFunctions.CreateSlider(tab2)

				if Config.Sliders[tab.Name.."_"..tab2.Name] == nil then
					Config.Sliders[tab.Name.."_"..tab2.Name] = {Value = tab2.Default}
				end

				local SliderFrame = Instance.new("Frame", SettingsFrame)
				SliderFrame.Size = UDim2.new(1, 0, 0, 40)
				SliderFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
				SliderFrame.BorderSizePixel = 0
				SliderFrame.BackgroundTransparency = 0.5

				local SettingsSideLine = Instance.new("Frame", SliderFrame)
				SettingsSideLine.Size = UDim2.fromScale(0.015,1)
				SettingsSideLine.Position = UDim2.fromScale(0,0)
				SettingsSideLine.BorderSizePixel = 0
				SettingsSideLine.BackgroundColor3 = Color3.fromRGB(30,30,30)

				local SliderName = Instance.new("TextLabel", SliderFrame)
				SliderName.Size = UDim2.new(1, 0, 0.5, 0)
				SliderName.Position = UDim2.new(0, 5, 0, 0)
				SliderName.Text = tab2.Name .. " (" .. tab2.Default .. ")"
				SliderName.TextColor3 = Color3.fromRGB(255, 255, 255)
				SliderName.BackgroundTransparency = 1
				SliderName.TextXAlignment = Enum.TextXAlignment.Center
				SliderName.TextSize = 10

				local SliderBar = Instance.new("Frame", SliderFrame)
				SliderBar.Size = UDim2.fromScale(0.7, 0.3)
				SliderBar.Position = UDim2.fromScale(0.15, 0.55)
				SliderBar.BackgroundColor3 = Color3.fromRGB(30,30,30)
				SliderBar.ClipsDescendants = true
				local SliderBarRound = Instance.new("UICorner", SliderBar)

				local SliderFill = Instance.new("Frame", SliderBar)
				SliderFill.Size = UDim2.new(0, 0, 1, 0)
				SliderFill.BackgroundColor3 = Color3.fromRGB(30,30,30)
				local SliderFillRound = Instance.new("UICorner", SliderFill)

				local SliderButton = Instance.new("TextButton", SliderBar)
				SliderButton.Size = UDim2.fromScale(0.1,1)
				SliderButton.Position = UDim2.fromScale(0,0)
				SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				SliderButton.AutoButtonColor = false
				SliderButton.Text = ""
				SliderButton.BorderSizePixel = 0
				SliderButton.ZIndex = 9
				local SliderButtonRound = Instance.new("UICorner", SliderButton)
				SliderButtonRound.CornerRadius = UDim.new(1,0)

				local SliderFunctions = {}
				SliderFunctions.Value = tab2.Default

				function SliderFunctions.UpdateSlide(inputX)
					local barSize = SliderBar.AbsoluteSize.X
					local relativeX = math.clamp((inputX - SliderBar.AbsolutePosition.X) / barSize, 0, 1)
					local value = math.floor((relativeX * (tab2.Max - tab2.Min) + tab2.Min) / tab2.Step) * tab2.Step

					SliderFunctions.Value = value
					Config.Sliders[tab.Name.."_"..tab2.Name].Value = value
					SliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
					SliderName.Text = tab2.Name .. " (" .. value .. ")"

					TweenService:Create(SliderButton, TweenInfo.new(0.1), {Position = UDim2.new(relativeX, -7, 0, 0)}):Play()

					if tab2.Function then
						tab2.Function(value)
					end

					task.delay(0.1,saveconfig)

					return value
				end


				function SliderFunctions.Input(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						local moveConnection, releaseConnection

						local initialX = input.Position.X
						local snapPosition = (initialX - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X
						snapPosition = math.clamp(snapPosition, 0, 1)
						SliderFunctions.UpdateSlide(SliderBar.AbsolutePosition.X + snapPosition * SliderBar.AbsoluteSize.X)

						moveConnection = UserInputService.InputChanged:Connect(function(moveInput)
							if moveInput.UserInputType == Enum.UserInputType.MouseMovement then
								SliderFunctions.UpdateSlide(moveInput.Position.X)
							end
						end)

						releaseConnection = UserInputService.InputEnded:Connect(function(releaseInput)
							if releaseInput.UserInputType == Enum.UserInputType.MouseButton1 then
								moveConnection:Disconnect()
								releaseConnection:Disconnect()
							end
						end)
					end
				end

				function SliderFunctions.SetValue(value)
					SliderFunctions.Value = value
					Config.Sliders[tab.Name.."_"..tab2.Name].Value = value
					SliderFill.Size = UDim2.new((value - tab2.Min) / (tab2.Max - tab2.Min), 0, 1, 0)
					SliderName.Text = tab2.Name .. " (" .. value .. ")"
					TweenService:Create(SliderButton, TweenInfo.new(0.1), {Position = UDim2.new((value - tab2.Min) / (tab2.Max - tab2.Min), -7, 0, 0)}):Play()
					if tab2.Function then
						tab2.Function(value)
					end
					task.delay(0.1,saveconfig)
				end

				SliderFunctions.SetValue(Config.Sliders[tab.Name.."_"..tab2.Name].Value)

				SliderButton.InputBegan:Connect(SliderFunctions.Input)
				SliderBar.InputBegan:Connect(SliderFunctions.Input)

				GuiLibrary.ThemeUpdate.Event:Connect(function(newTheme)
					SettingsSideLine.BackgroundColor3 = darkenColor(newTheme, 0.6)
					SliderFill.BackgroundColor3 = darkenColor(newTheme, 0.6)
				end)

				return SliderFunctions
			end


			Button.MouseButton1Down:Connect(function()
				ButtonFunctions:Toggle()
			end)

			Button.MouseButton2Down:Connect(function()
				SettingsFrame.Visible = not SettingsFrame.Visible
			end)

			UserInputService.InputBegan:Connect(function(key, gpe)
				if gpe or key.KeyCode ~= Keybind or Keybind == Enum.KeyCode.Unknown then return end
				ButtonFunctions:Toggle()
			end)

			if Config.Buttons[tab.Name].Enabled then
				task.delay(0.5, function()
					ButtonFunctions:Toggle()
				end)
			end

			Keybind = Enum.KeyCode[Config.Buttons[tab.Name].Keybind]
			if Keybind ~= Enum.KeyCode.Unknown then
				KeybindButton.Text = "  Keybind: "..Config.Buttons[tab.Name].Keybind
			end

			table.insert(Modules, ButtonFunctions)

			return ButtonFunctions
		end,
		Toggle = function()
			Top.Visible = not Top.Visible
		end,
		GetModules = function()
			return Modules
		end,
	}

	WindowCount += 1
end

UserInputService.InputBegan:Connect(function(key, gpe)
	if gpe or key.KeyCode ~= Enum.KeyCode.RightShift then
		return
	end

	for i,v in pairs(GuiLibrary.Windows) do
		v:Toggle()
	end
end)

GuiLibrary:CreateWindow("Combat")
GuiLibrary:CreateWindow("Movement")
GuiLibrary:CreateWindow("Render")
GuiLibrary:CreateWindow("World")
GuiLibrary:CreateWindow("Utility")

local origArraySize = SubArrayListFrame.Size
ArrayListModule = GuiLibrary.Windows.Render.CreateModuleButton({
	Name = "ArrayList",
	Function = function(callback)
		SubArrayListFrame.Visible = callback

		task.spawn(function()
			repeat

				local suc, ret = pcall(function()
					return ArrayScale.Value / 100
				end)

				if suc then
					SubArrayListFrame.Size = UDim2.fromScale(origArraySize.X.Scale * ret, origArraySize.Y.Scale * ret)
				end

				if ArrayLogo then

					if ArrayLogo.Option == "Image" then
						--Logo.Visible = true
						--LogoText.Visible = false
					else
						--Logo.Visible = false
						--LogoText.Visible = true
					end

				end

				task.wait()
			until not ArrayListModule.Enabled
		end)
	end,
})

ArrayBackground = ArrayListModule.CreateToggle({
	Name = "Background",
	Function = function() end,
})

ArrayLine = ArrayListModule.CreateToggle({
	Name = "Line",
	Function = function() end,
})

ArrayShadow = ArrayListModule.CreateToggle({
	Name = "Shadow",
	Function = function() end,
})
ArrayScale = ArrayListModule.CreateSlider({
	Name = "Scale",
	Default = 100,
	Min = 0,
	Max = 100,
	Step = 1,
})
ArrayX = ArrayListModule.CreateSlider({
	Name = "X",
	Default = 1000,
	Min = 0,
	Max = 1000,
	Step = 1,
	Function = function(v)
		
		v -= 350
		
		if v <= 300 then
			ArrayListFrameSorter.HorizontalAlignment = Enum.HorizontalAlignment.Left
		else
			ArrayListFrameSorter.HorizontalAlignment = Enum.HorizontalAlignment.Right
		end
		
		SubArrayListFrame.Position = UDim2.fromScale(v / 1000, SubArrayListFrame.Position.Y.Scale)
	end,
})

ArrayY = ArrayListModule.CreateSlider({
	Name = "Y",
	Default = 0,
	Min = 0,
	Max = 1000,
	Step = 1,
	Function = function(v)
		SubArrayListFrame.Position = UDim2.fromScale(SubArrayListFrame.Position.X.Scale, v / 1000)
	end,
})

CustomTheme = GuiLibrary.Windows.Render.CreateModuleButton({
	Name = "CustomTheme",
	Function = function(callback)
		if callback then
			task.spawn(function()
				local last = GuiLibrary.Theme
				repeat
					pcall(function()
						if CustomThemeRainbow.Enabled then
							local hue = (tick() * 0.5 + (0.1)) % 1
							local rainbowColor = Color3.fromHSV(hue, 1, 1)
							GuiLibrary.Theme = rainbowColor
							GuiLibrary.ThemeUpdate:Fire(GuiLibrary.Theme)
							Logo.ImageColor3 = GuiLibrary.Theme
							LogoText.TextColor3 = GuiLibrary.Theme
						else
							GuiLibrary.Theme = Color3.fromRGB(CustomThemeColorRed.Value,CustomThemeColorGreen.Value,CustomThemeColorBlue.Value)

							if GuiLibrary.Theme ~= last then
								GuiLibrary.ThemeUpdate:Fire(GuiLibrary.Theme)
								Logo.ImageColor3 = GuiLibrary.Theme
								LogoText.TextColor3 = GuiLibrary.Theme
							end

							last = GuiLibrary.Theme
						end
					end)
					task.wait()
				until not CustomTheme.Enabled
			end)
		else
			task.delay(0.1, function()
				GuiLibrary.Theme = Color3.fromRGB(0, 200, 255)
			end)
		end
	end,
})

CustomThemeRainbow = CustomTheme.CreateToggle({
	Name = "Rainbow",
	Function = function() end,
})

CustomThemeColorRed = CustomTheme.CreateSlider({
	Name = "Red",
	Default = 0,
	Min = 0,
	Max = 255,
	Step = 1,
})

CustomThemeColorGreen = CustomTheme.CreateSlider({
	Name = "Green",
	Default = 200,
	Min = 0,
	Max = 255,
	Step = 1
})

CustomThemeColorBlue = CustomTheme.CreateSlider({
	Name = "Blue",
	Default = 255,
	Min = 0,
	Max = 255,
	Step = 1
})

local oldTargetHudCreate = TargetHud.SetTarget
TargetHudModule = GuiLibrary.Windows.Render.CreateModuleButton({
	Name = "TargetHud",
	Function = function(callback)
		if callback then
			TargetHud.SetTarget = oldTargetHudCreate
		else
			TargetHud.SetTarget = function() end
			TargetHud.Clear()
		end
	end,
})

TargetHudX = TargetHudModule.CreateSlider({
	Name = "X",
	Default = 600,
	Min = 0,
	Max = 1000,
	Step = 1,
	Function = function(v)
		TargetHudFrame.Position = UDim2.fromScale(v / 1000, TargetHudFrame.Position.Y.Scale)
	end,
})

TargetHudY = TargetHudModule.CreateSlider({
	Name = "Y",
	Default = 600,
	Min = 0,
	Max = 1000,
	Step = 1,
	Function = function(v)
		TargetHudFrame.Position = UDim2.fromScale(TargetHudFrame.Position.X.Scale, v / 1000)
	end,
})

Uninject = GuiLibrary.Windows.Utility.CreateModuleButton({
	Name = "Uninject",
	Function = function(callback)
		canSave = false
		task.wait(0.5)
		for i,v in pairs(GuiLibrary.Windows) do
			for i2,v2 in pairs(v:GetModules()) do
				if v2.Enabled then
					v2:Toggle()
				end
			end
		end

		ScreenGui:Destroy()
		shared.GuiLibrary = nil
	end,
})

shared.GuiLibrary = GuiLibrary
