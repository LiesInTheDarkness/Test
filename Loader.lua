local scriptContent = game:HttpGet("https://raw.githubusercontent.com/LiesInTheDarkness/Test/main/GuiLibrary.lua")
print("Script content fetched:", scriptContent and #scriptContent or "nil")
print("Script content:", scriptContent)

if not scriptContent then
    error("Failed to fetch script content")
end

local RiseLib = loadstring(scriptContent)()
print("RiseLib loaded:", RiseLib and "success" or "nil")

if not RiseLib then
    error("Failed to load GuiLibrary")
end

local window = RiseLib:CreateWindow("My Window", "Classic")
print("Window created:", window and "success" or "nil")
local tab = window:AddTab("My Tab")
print("Tab created:", tab and "success" or "nil")
local category = tab:AddCategory("My Category")
print("Category created:", category and "success" or "nil")
category:AddToggle("My Toggle", false, function(value) print(value) end)
print("Toggle added")
