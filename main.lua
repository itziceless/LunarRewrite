repeat task.wait() until game:IsLoaded()

local DeveloperMode = getgenv().Developer or false

local isfile = isfile or function(file)
    local suc, res = pcall(function()
        return readfile(file)
    end)
    return suc and res ~= nil and res ~= ''
end

local delfile = delfile or function(file)
    writefile(file, '')
end

local function wipeFolder(path)
    if not isfolder(path) then return end
    for _, file in listfiles(path) do
        if file:find('loader') then continue end
        if isfile(file) and select(1, readfile(file):find('--This watermark is used to delete the file if its cached, remove it to make the file persist after lunar updates.')) == 1 then
            delfile(file)
        end
    end
end

for _, folder in {'ocean', 'ocean/games', 'ocean/uiassets', 'ocean/libs', 'ocean/ui', 'ocean/config'} do
    if not isfolder(folder) then
        makefolder(folder)
    end
end

if not isfile('ocean/libs/ui.txt') then
    writefile('ocean/ui/ui.txt', loadstring(game:HttpGet('https://raw.githubusercontent.com/itziceless/LunarRewrite/refs/heads/main/libs/ui.lua'))())
end

if not isfile('ocean/games/universal.txt') then
    writefile('ocean/ui/universal.txt', loadstring(game:HttpGet('https://raw.githubusercontent.com/itziceless/LunarRewrite/refs/heads/main/games/universal.lua'))())
end

loadstring(game:HttpGet('https://raw.githubusercontent.com/itziceless/LunarRewrite/refs/heads/main/libs/ui.lua'))()
loadstring(game:HttpGet('https://raw.githubusercontent.com/itziceless/LunarRewrite/refs/heads/main/games/universal.lua'))()
