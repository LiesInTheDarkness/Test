local RiseLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/LiesInTheDarkness/Test/refs/heads/main/GuiLibrary.lua"))()
local window = RiseLib:CreateWindow("My Window", "Classic")
local tab = window:AddTab("My Tab")
local category = tab:AddCategory("My Category")
-- Now you can add modules like:
category:AddToggle("My Toggle", false, function(value) print(value) end)
