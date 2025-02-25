repeat task.wait() until game:IsLoaded()

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

local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/itziceless/Lunar/'..readfile('lunar/libs/anticache.txt')..'/'..select(1, path:gsub('lunar/', '')), true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		if path:find('.lua') then
			res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n'..res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end

local function getid(placeid)
    return game:HttpGet('https://raw.githubusercontent.com/itziceless/LunarRewrite/refs/heads/main/games/'..placeid..".lua", true)
end

for _, folder in {'lunar', 'lunar/games', 'lunar/uiassets', 'lunar/libs', 'lunar/ui'} do
    if not isfolder(folder) then
        makefolder(folder)
    end
end

if not isfile('lunar/ui/mode.txt') then
    writefile('lunar/ui/mode.txt', 'prestige')
end
local uiasset = readfile('lunar/ui/mode.txt')

if not isfolder('lunar/uiassets/'..uiasset) then
    makefolder('lunar/uiassets/'..uiasset)
end

local commit = subbed:find('currentOid')
	commit = commit and subbed:sub(commit + 13, commit + 52) or nil
	commit = commit and #commit == 40 and commit or 'main'
	if commit == 'main' or (isfile('lunar/libs/anticache.txt') and readfile('lunar/libs/anticache.txt') or '') ~= commit then
		wipeFolder('lunar')
		wipeFolder('lunar/games')
		wipeFolder('lunar/ui')
		wipeFolder('lunar/libs')
	end
	writefile('lunar/libs/anticache.txt', commit)
end
--if not isfile('lunar/games/'..game.PlaceId..'.lua') then
--	writefile('newvape/games/'..game.PlaceId..'.lua')
--end
