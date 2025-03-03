local RiseLib = loadstring(game:HttpGet("URL_TO_YOUR_LIB"))() -- Load the UI library

local Window = RiseLib:CreateWindow({
    Name = "My Custom UI"
    SaveConfig = true, -- Enables saving configurations
    ConfigFolder = "Rise 6.0"
})

-- Create a Tab
local MainTab = Window:CreateTab({
    Name = "Main"
})

-- Create a Section
local MainSection = MainTab:CreateSection({
    Name = "Main Features"
})

-- Add a Button
MainSection:CreateButton({
    Name = "Click Me",
    Callback = function()
        print("Button Clicked!")
    end
})

-- Add a Keybind
MainSection:CreateKeybind({
    Name = "Toggle UI",
    Default = Enum.KeyCode.RightShift,
    Callback = function()
        Window:Toggle()
    end
})

-- Add a Color Picker
MainSection:CreateColorPicker({
    Name = "Pick a Color",
    Default = Color3.fromRGB(255, 0, 0), -- Red
    Callback = function(color)
        print("Selected Color: ", color)
    end
})

-- Add a Textbox
MainSection:CreateTextbox({
    Name = "Enter Text",
    Placeholder = "Type here...",
    Callback = function(text)
        print("Textbox Input: ", text)
    end
})

-- Add a Label
MainSection:CreateLabel({
    Text = "This is a label!"
})
