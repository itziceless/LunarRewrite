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
		if isfile(file) and select(1, readfile(file):find('--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.')) == 1 then
			delfile(file)
		end
	end
end

for _, folder in {'lunar', 'lunar/games', 'lunar/uiassets', 'lunar/libs', 'lunar/ui'} do
	if not isfolder(folder) then
		makefolder(folder)
	end
end

if not isfile('lunar/games/'..game.PlaceId..'.lua') then
	writefile('lunar/games/'..game.PlaceId..'.lua')
end
