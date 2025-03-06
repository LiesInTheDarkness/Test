local RiseLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/LiesInTheDarkness/Test/main/GuiLibrary.lua"))()
if not RiseLib then
    error("Failed to load GuiLibrary")
end
local window = RiseLib:CreateWindow("My Window", "Classic")
local tab = window:AddTab("My Tab")
local category = tab:AddCategory("My Category")
category:AddToggle("My Toggle", false, function(value) print(value) end)
