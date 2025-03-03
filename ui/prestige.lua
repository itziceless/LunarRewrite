local api = {
	Categories = {},
	GUIColor = {
		Hue = 0.46,
		Sat = 0.96,
		Value = 0.52
	},
	HeldKeybinds = {},
	Keybind = {'RightShift'},
	Loaded = false,
	Libraries = {},
	Modules = {},
	Place = game.PlaceId,
	Profile = 'Lunar',
	Profiles = {},
	RainbowSpeed = {Value = 1},
	RainbowUpdateSpeed = {Value = 60},
	RainbowTable = {},
	Scale = {Value = 1},
	ToggleNotifications = {},
	BlatantMode = {},
	Version = 'V2',
	Windows = {}
}

local colorpallet = {
	Main = Color3.fromRGB(26, 25, 26),
	Text = Color3.fromRGB(215, 215, 215),
	Prestige = Color3.fromRGB(138, 43, 226)
}

local inputService = game:GetService("UserInputService")
local guiService = game:GetService("GuiService")
local tweenservice = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local textservice = game:GetService("TextService")

local function addCorner(parent, radius)
	local corner = Instance.new('UICorner')
	corner.CornerRadius = radius or UDim.new(0, 5)
	corner.Parent = parent
	return corner
end

local main = Instance.new("ScreenGui")
local clickgui = Instance.new("Frame")
clickgui.BackgroundTransparency = 0
clickgui.Position = UDim2.new(0, 0, 0, 0)
clickgui.Size = UDim2.new(0, 3000, 0, 1000)
clickgui.Parent = main
clickgui.Transparency = 1

main.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local NotificationFrame = Instance.new("Frame")
NotificationFrame.Size = UDim2.fromScale(0.3, 0.9)
NotificationFrame.Position = UDim2.fromScale(0.7,0)
NotificationFrame.BackgroundTransparency = 1
NotificationFrame.Parent = main
local NotificationFrameSorter = Instance.new("UIListLayout", NotificationFrame)
NotificationFrameSorter.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotificationFrameSorter.HorizontalAlignment = Enum.HorizontalAlignment.Right
NotificationFrameSorter.Padding = UDim.new(0.015,0)

local function getAccurateTextSize(text, size)
	return textservice:GetTextSize(text, size, Enum.Font.SourceSans, Vector2.zero).X
end

function api:CreateNotification(text, duration)

	local Notification = Instance.new("TextLabel", NotificationFrame)
	Notification.BorderSizePixel = 0
	Notification.BackgroundColor3 = Color3.fromRGB(40,40,40)
	Notification.Text = "  "..text
	Notification.TextColor3 = Color3.fromRGB(255,255,255)
	Notification.TextSize = 22
	Notification.TextXAlignment = Enum.TextXAlignment.Left
	Notification.Font = Enum.Font.SourceSans
	Notification.BackgroundTransparency = 0

	local size = getAccurateTextSize("  "..text, 22)

	Notification.Size = UDim2.new(0,0,0.055,0)

	tweenservice:Create(Notification, TweenInfo.new(0.3, Enum.EasingStyle.Bounce), {
		Size = UDim2.new(0.05,size,0.055,0)
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

		Debris:AddItem(Notification, 0.35)

		task.delay(0.35, function()
		end)
	end)
end

function api:CreateCategory(categorysettings)
	local categoryapi = {
		Type = 'Category',
		Expanded = false
	}

	local window = Instance.new('TextButton')
	window.Name = categorysettings.Name..'Category'
	window.Size = UDim2.fromOffset(220, 50)
	window.Position = categorysettings.pos
	window.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	window.Font = Enum.Font.ArialBold
	window.Text = ''
	window.Visible = true
	window.Parent = clickgui
	addCorner(window, UDim.new(0, 5))
	local icon = Instance.new('ImageLabel')
	icon.Name = 'Icon'
	icon.BackgroundColor3 = colorpallet.Prestige
	icon.Size = categorysettings.Size
	icon.Position = UDim2.new(0.05, 0, 0.25, 0)
	icon.BackgroundTransparency = 0
	icon.Image = categorysettings.Icon
	addCorner(icon, UDim.new(0, 3))
	--icon.ImageColor3 = 
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
	local children = Instance.new('ScrollingFrame')
	children.Name = 'Children'
	children.Size = UDim2.new(1, 0, 1, -41)
	children.Position = UDim2.fromOffset(0, 37)
	children.BackgroundTransparency = 1
	children.BorderSizePixel = 0
	children.Visible = false
	children.ScrollBarThickness = 2
	children.ScrollBarImageTransparency = 0.75
	children.CanvasSize = UDim2.new()
	children.Parent = window
end

local prestigelogo = Instance.new("ImageLabel")
prestigelogo.Image = "http://www.roblox.com/asset/?id=86813668617692"
prestigelogo.Position = UDim2.new(0.01, 0, 0.02, 0)
prestigelogo.Parent = main
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
	local children = Instance.new('ScrollingFrame')
	children.Name = 'Children'
	children.Size = UDim2.new(1, 0, 1, -37)
	children.Position = UDim2.fromOffset(0, 34)
	children.BackgroundTransparency = 1
	children.BorderSizePixel = 0
	children.ScrollBarThickness = 2
	children.ScrollBarImageTransparency = 0.75
	children.CanvasSize = UDim2.new()
	children.Parent = searchbkg
end

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

api:CreateNotification("This is a test!", 6)
api:CreateNotification("This is a test!", 5)
api:CreateNotification("This is a test!", 4)
api:CreateNotification("This is a test!", 3)
