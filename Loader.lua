-- First, require the UI library module
-- Assuming you've saved the library code in a ModuleScript named "RiseLib"
local RiseLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/LiesInTheDarkness/Test/refs/heads/main/GuiLibrary.lua"))()

-- Create a window with title
local Window = RiseLib:CreateWindow("Rise 6.0 Client", Color3.fromRGB(85, 170, 255))

-- Set toggle keybind (for PC)
Window:SetKeybind(Enum.KeyCode.RightShift)

-- Create tabs
local CombatTab = Window:AddTab("Combat", "rbxassetid://7072706318") -- Combat icon
local MovementTab = Window:AddTab("Movement", "rbxassetid://7072724538") -- Movement icon
local UtilityTab = Window:AddTab("Utility", "rbxassetid://7072717857") -- Utility icon
local RenderTab = Window:AddTab("Render", "rbxassetid://7072720892") -- Render icon
local ConfigTab = Window:AddTab("Config", "rbxassetid://7072715646") -- Settings icon

-- Add sections to the Combat tab
local AimbotSection = CombatTab:AddSection("Aimbot")
local KillauraSection = CombatTab:AddSection("Killaura")

-- Add elements to the Aimbot section
local AimbotToggle = AimbotSection:AddToggle("Enable Aimbot", false, function(value)
    print("Aimbot enabled:", value)
    -- Your aimbot code here
end)

AimbotSection:AddSlider("Aimbot FOV", 30, 360, 180, 1, function(value)
    print("Aimbot FOV set to:", value)
    -- Adjust FOV here
end)

AimbotSection:AddDropdown("Aimbot Target", {"Head", "Torso", "Random"}, "Head", function(selected)
    print("Aimbot targeting:", selected)
    -- Set target part here
end)

AimbotSection:AddKeybind("Aimbot Keybind", Enum.KeyCode.E, function()
    print("Aimbot key pressed")
    -- Toggle aimbot on key press
end)

-- Add elements to the Killaura section
local KillauraToggle = KillauraSection:AddToggle("Enable Killaura", false, function(value)
    print("Killaura enabled:", value)
    -- Your killaura code here
end)

KillauraSection:AddSlider("Attack Range", 1, 10, 4, 0.1, function(value)
    print("Killaura range set to:", value)
    -- Set killaura range
end)

KillauraSection:AddSlider("Attack Speed", 1, 20, 8, 1, function(value)
    print("Killaura speed set to:", value)
    -- Set killaura attack speed
end)

KillauraSection:AddDropdown("Target Priority", {"Closest", "Lowest Health", "Highest Health"}, "Closest", function(selected)
    print("Killaura targeting:", selected)
    -- Set target priority
end)

-- Add sections to the Movement tab
local SpeedSection = MovementTab:AddSection("Speed")
local JumpSection = MovementTab:AddSection("Jump")
local FlightSection = MovementTab:AddSection("Flight")

-- Speed section elements
local SpeedToggle = SpeedSection:AddToggle("Enable Speed", false, function(value)
    print("Speed enabled:", value)
    -- Speed hack code
end)

SpeedSection:AddSlider("Speed Multiplier", 1, 10, 2, 0.1, function(value)
    print("Speed multiplier:", value)
    -- Set speed multiplier
end)

SpeedSection:AddDropdown("Speed Mode", {"Normal", "CFrame", "Velocity"}, "Normal", function(selected)
    print("Speed mode:", selected)
    -- Change speed mode
end)

-- Jump section elements
local JumpToggle = JumpSection:AddToggle("High Jump", false, function(value)
    print("High Jump enabled:", value)
    -- High jump code
end)

JumpSection:AddToggle("Infinite Jump", false, function(value)
    print("Infinite Jump enabled:", value)
    -- Infinite jump code
    
    local InfJump
    if value then
        InfJump = game:GetService("UserInputService").JumpRequest:Connect(function()
            game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end)
    else
        if InfJump then
            InfJump:Disconnect()
        end
    end
end)

-- Flight section elements
local FlightToggle = FlightSection:AddToggle("Enable Flight", false, function(value)
    print("Flight enabled:", value)
    -- Flight code
end)

FlightSection:AddSlider("Flight Speed", 1, 20, 10, 1, function(value)
    print("Flight speed:", value)
    -- Set flight speed
end)

FlightSection:AddKeybind("Flight Keybind", Enum.KeyCode.F, function()
    print("Flight key pressed")
    -- Toggle flight
    FlightToggle:Set(not FlightToggle:Get())
end)

-- Add sections to the Utility tab
local ESPSection = UtilityTab:AddSection("ESP")
local AutoFarmSection = UtilityTab:AddSection("Auto Farm")

-- ESP section elements
local ESPToggle = ESPSection:AddToggle("Enable ESP", false, function(value)
    print("ESP enabled:", value)
    -- ESP code
end)

ESPSection:AddToggle("Show Names", true, function(value)
    print("Show names:", value)
    -- Toggle names
end)

ESPSection:AddToggle("Show Health", true, function(value)
    print("Show health:", value)
    -- Toggle health display
end)

ESPSection:AddColorPicker("ESP Color", Color3.fromRGB(255, 50, 50), function(color)
    print("ESP color changed to:", color)
    -- Update ESP color
end)

-- Auto Farm section
local AutoFarmToggle = AutoFarmSection:AddToggle("Enable Auto Farm", false, function(value)
    print("Auto Farm enabled:", value)
    -- Auto farm code
end)

AutoFarmSection:AddDropdown("Farm Target", {"Coins", "XP", "Enemies"}, "Coins", function(selected)
    print("Farm target:", selected)
    -- Set farm target
end)

-- Add sections to the Render tab
local VisualsSection = RenderTab:AddSection("Visuals")
local CameraSection = RenderTab:AddSection("Camera")

-- Visuals section
VisualsSection:AddToggle("Fullbright", false, function(value)
    print("Fullbright enabled:", value)
    -- Fullbright code
    if value then
        game:GetService("Lighting").Brightness = 2
        game:GetService("Lighting").GlobalShadows = false
    else
        game:GetService("Lighting").Brightness = 1
        game:GetService("Lighting").GlobalShadows = true
    end
end)

VisualsSection:AddToggle("No Fog", false, function(value)
    print("No Fog enabled:", value)
    -- No fog code
    if value then
        game:GetService("Lighting").FogEnd = 1000000
    else
        game:GetService("Lighting").FogEnd = 500
    end
end)

-- Camera section
local FOVSlider = CameraSection:AddSlider("FOV", 70, 120, 90, 1, function(value)
    print("FOV set to:", value)
    -- Set FOV
    game:GetService("Workspace").CurrentCamera.FieldOfView = value
end)

CameraSection:AddToggle("Freecam", false, function(value)
    print("Freecam enabled:", value)
    -- Freecam code
end)

-- Add sections to the Config tab
local SettingsSection = ConfigTab:AddSection("Settings")
local ThemeSection = ConfigTab:AddSection("Theme")

-- Settings section
SettingsSection:AddButton("Reset All Settings", function()
    print("Resetting all settings")
    -- Reset code
    AimbotToggle:Set(false)
    SpeedToggle:Set(false)
    FlightToggle:Set(false)
    ESPToggle:Set(false)
    AutoFarmToggle:Set(false)
    FOVSlider:Set(90)
end)

-- Theme section
ThemeSection:AddColorPicker("UI Color", Color3.fromRGB(85, 170, 255), function(color)
    print("UI color changed to:", color)
    -- Change UI theme color
    Window:SetThemeColor(color)
end)

ThemeSection:AddTextbox("UI Title", "Rise 6.0 Client", "Enter new title", function(text)
    print("Title changed to:", text)
    -- You could reload the UI with new title if needed
end)

-- Add a label with credits
ThemeSection:AddLabel("Made with Rise 6.0 UI Library")


