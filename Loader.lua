local Rise = loadstring(game:HttpGet("https://raw.githubusercontent.com/LiesInTheDarkness/Test/refs/heads/main/GuiLibrary.lua"))()

-- Create the main window
local window = Rise:CreateWindow("Example UI", "Classic")

-- Add a tab to the window
local tab = window:AddTab("Main Tab", "rbxassetid://7072706318")

-- Add a category to the tab
local category = tab:AddCategory("Main Category")

-- Add a toggle to the category
local toggle = category:AddToggle("Example Toggle", false, function(value)
    print("Toggle value:", value)
end)

-- Add a slider to the category
local slider = category:AddSlider("Example Slider", {min = 0, max = 100, default = 50, increment = 1}, function(value)
    print("Slider value:", value)
end)

-- Add a dropdown to the category
local dropdown = category:AddDropdown("Example Dropdown", {items = {"Option 1", "Option 2", "Option 3"}, default = "Option 1"}, function(value)
    print("Dropdown value:", value)
end)
