local cloneref = cloneref or function(obj)
	return obj
end

lnr = loadstring(game:HttpGet('https://raw.githubusercontent.com/itziceless/LunarRewrite/refs/heads/main/ui/prestige.lua'))()
lunar = lnr

local playersService = cloneref(game:GetService('Players'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local runService = cloneref(game:GetService('RunService'))
local inputService = cloneref(game:GetService('UserInputService'))
local tweenService = cloneref(game:GetService('TweenService'))
local httpService = cloneref(game:GetService('HttpService'))
local textChatService = cloneref(game:GetService('TextChatService'))
local collectionService = cloneref(game:GetService('CollectionService'))
local contextActionService = cloneref(game:GetService('ContextActionService'))
local coreGui = cloneref(game:GetService('CoreGui'))
local starterGui = cloneref(game:GetService('StarterGui'))

lunar.api.Categories.Combat:CreateModule({
     Name = "Killaura"
     Function = function()
end,
})			
