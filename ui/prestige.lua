local api = {
	Categories = {
		"Combat",
		"Movement",
		"Misc",
		"Menu",
		"Configs"
	},
	HeldKeybinds = {},
	Keybind = {'RightShift'},
	Loaded = true,
	Libraries = {},
	Modules = {},
	Place = game.PlaceId,
	Scale = {Value = 1},
	ToggleNotifications = {},
	Version = 'V2',
	Windows = {}
}

local colorpallet = {
	Main = Color3.fromRGB(26, 25, 26),
	Text = Color3.fromRGB(215, 215, 215),
	Prestige = Color3.fromRGB(138, 43, 226),
	Font = Font.new('rbxasset://fonts/families/Arial.json')
}

local inputService = game:GetService("UserInputService")
local guiService = game:GetService("GuiService")
local tweenservice = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local textservice = game:GetService("TextService")
local scale

local function addCorner(parent, radius)
	local corner = Instance.new('UICorner')
	corner.CornerRadius = radius or UDim.new(0, 5)
	corner.Parent = parent
	return corner
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


-- First, modify the category creation function to include `CreateModule` for all categories
-- Create a table to store categories by name
api.Categories = {}

-- Modify the CreateCategory function to store categories as objects in api.Categories
function api:CreateCategory(categorysettings)
	local categoryapi = {
		Type = 'Category',
		Expanded = false
	}

	-- Create the window for the category
	local window = Instance.new('TextButton')
	window.Name = categorysettings.Name .. 'Category'
	window.Size = UDim2.fromOffset(220, 50)
	window.Position = categorysettings.pos
	window.BackgroundColor3 = colorpallet.Main
	window.Font = Enum.Font.ArialBold
	window.Text = ''
	window.Visible = true
	window.Parent = clickgui
	addCorner(window, UDim.new(0, 5))

	-- Create the icon for the category
	local icon = Instance.new('ImageLabel')
	icon.Name = 'Icon'
	icon.BackgroundColor3 = colorpallet.Prestige
	icon.Size = categorysettings.Size
	icon.Position = UDim2.new(0.05, 0, 0.25, 0)
	icon.BackgroundTransparency = 0
	icon.Image = categorysettings.Icon
	addCorner(icon, UDim.new(0, 3))
	icon.Parent = window

	-- Create the title for the category
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

	-- Create the frame to hold the modules
	local ModuleFrame = Instance.new("ScrollingFrame")
	ModuleFrame.Parent = window
	ModuleFrame.Position = UDim2.fromScale(0, 1)
	ModuleFrame.Size = UDim2.fromScale(1, 15)
	ModuleFrame.BackgroundTransparency = 1
	local ModuleFrameSorter = Instance.new("UIListLayout", ModuleFrame)
	ModuleFrameSorter.SortOrder = Enum.SortOrder.LayoutOrder

	
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
		arrow.Position = UDim2.fromOffset(3, 12)
		arrow.BackgroundTransparency = 1
		arrow.Image = "http://www.roblox.com/asset/?id=99555841278473"
		arrow.Parent = arrowbutton

		
		addMaid(moduleapi)

		
		api.Modules[modulesettings.Name] = moduleapi

		
		modulebutton.MouseButton1Click:Connect(function()
			modulesettings.Function()
		end)


		if modulesettings.Bind then
			inputService.InputBegan:Connect(function(input, processed)
				if processed then return end
				for _, bind in pairs(modulesettings.Bind) do
					if input.UserInputType == bind.InputType and input.KeyCode == bind.Key then
						modulesettings.Function()
					end
				end
			end)
		end
	end

	api.Categories[categorysettings.Name] = categoryapi
end


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

api.Categories.Menu:CreateModule({
	Name = "HUD",
	Function = function()
		api:CreateNotification("HUD works", 6)
	end,
})
