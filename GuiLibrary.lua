--[[
    Rise UI Library
    Inspired by Rise 6.0 Winter Theme
    Mobile-friendly implementation
]]

local RiseLib = {}
local configs = {}
local windows = {}
local configFolder = "Rise/configs/"

-- Utility functions
local function createFolder(path)
    if not isfolder(path) then
        makefolder(path)
    end
end

local function saveConfig(name)
    createFolder(configFolder)
    local configPath = configFolder .. name .. ".json"
    writefile(configPath, game:GetService("HttpService"):JSONEncode(configs))
end

local function loadConfig(name)
    local configPath = configFolder .. name .. ".json"
    if isfile(configPath) then
        configs = game:GetService("HttpService"):JSONDecode(readfile(configPath))
        return true
    end
    return false
end

local function getConfigs()
    createFolder(configFolder)
    local files = listfiles(configFolder)
    local configFiles = {}
    
    for _, file in ipairs(files) do
        if file:sub(-5) == ".json" then
            table.insert(configFiles, file:match("([^/]+)%.json$"))
        end
    end
    
    return configFiles
end

-- Create main UI
function RiseLib:CreateWindow(title)
    createFolder(configFolder)
    
    -- Core UI Services
    local UIS = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local mouse = player:GetMouse()
    local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled and not UIS.MouseEnabled
    
    -- Main Colors (Winter Theme)
    local colors = {
        background = Color3.fromRGB(20, 25, 30),
        accent = Color3.fromRGB(90, 160, 230),
        secondary = Color3.fromRGB(30, 35, 45),
        tertiary = Color3.fromRGB(40, 45, 55),
        text = Color3.fromRGB(220, 230, 240),
        subText = Color3.fromRGB(180, 190, 210),
        disabled = Color3.fromRGB(100, 110, 130),
        success = Color3.fromRGB(100, 200, 100),
        warning = Color3.fromRGB(230, 180, 60),
        error = Color3.fromRGB(230, 90, 90)
    }
    
    -- Create UI Elements
    local Rise = Instance.new("ScreenGui")
    Rise.Name = "Rise"
    Rise.ResetOnSpawn = false
    Rise.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Rise.DisplayOrder = 999
    
    -- Set parent based on environment
    if syn and syn.protect_gui then
        syn.protect_gui(Rise)
        Rise.Parent = game.CoreGui
    elseif gethui then
        Rise.Parent = gethui()
    else
        Rise.Parent = game.CoreGui
    end
    
    -- Main window
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.BackgroundColor3 = colors.background
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, -300, 0.5, -200)
    Main.Size = UDim2.new(0, 600, 0, 400)
    Main.ClipsDescendants = true
    Main.Parent = Rise
    
    -- Apply corner radius
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Main
    
    -- Add shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.Image = "rbxassetid://6014054959"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(80, 80, 80, 80)
    Shadow.SliceScale = 0.3
    Shadow.ZIndex = -1
    Shadow.Parent = Main
    
    -- Top bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.BackgroundColor3 = colors.secondary
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.Parent = Main
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 8)
    TopBarCorner.Parent = TopBar
    
    local TopBarCover = Instance.new("Frame")
    TopBarCover.Name = "TopBarCover"
    TopBarCover.BackgroundColor3 = colors.secondary
    TopBarCover.BorderSizePixel = 0
    TopBarCover.Position = UDim2.new(0, 0, 0.5, 0)
    TopBarCover.Size = UDim2.new(1, 0, 0.5, 0)
    TopBarCover.ZIndex = 2
    TopBarCover.Parent = TopBar
    
    -- Logo and title
    local LogoHolder = Instance.new("Frame")
    LogoHolder.Name = "LogoHolder"
    LogoHolder.BackgroundTransparency = 1
    LogoHolder.Position = UDim2.new(0, 15, 0, 5)
    LogoHolder.Size = UDim2.new(0, 30, 0, 30)
    LogoHolder.Parent = TopBar
    
    local LogoR = Instance.new("TextLabel")
    LogoR.Name = "LogoR"
    LogoR.BackgroundTransparency = 1
    LogoR.Size = UDim2.new(1, 0, 1, 0)
    LogoR.Font = Enum.Font.GothamBold
    LogoR.Text = "R"
    LogoR.TextColor3 = colors.accent
    LogoR.TextSize = 24
    LogoR.Parent = LogoHolder
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 55, 0, 0)
    Title.Size = UDim2.new(1, -210, 1, 0)
    Title.Font = Enum.Font.Gotham
    Title.Text = title or "Rise Client"
    Title.TextColor3 = colors.text
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar
    
    -- Menu buttons
    local ConfigButton = Instance.new("ImageButton")
    ConfigButton.Name = "ConfigButton"
    ConfigButton.BackgroundTransparency = 1
    ConfigButton.Position = UDim2.new(1, -130, 0, 5)
    ConfigButton.Size = UDim2.new(0, 30, 0, 30)
    ConfigButton.Image = "rbxassetid://7059346373" -- Config icon
    ConfigButton.ImageColor3 = colors.text
    ConfigButton.Parent = TopBar
    
    local MinimizeButton = Instance.new("ImageButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Position = UDim2.new(1, -95, 0, 5)
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Image = "rbxassetid://7059346982" -- Minimize icon
    MinimizeButton.ImageColor3 = colors.text
    MinimizeButton.Parent = TopBar
    
    local CloseButton = Instance.new("ImageButton")
    CloseButton.Name = "CloseButton"
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -45, 0, 5)
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Image = "rbxassetid://7059346611" -- Close icon
    CloseButton.ImageColor3 = colors.text
    CloseButton.Parent = TopBar
    
    -- Tab system
    local TabHolder = Instance.new("Frame")
    TabHolder.Name = "TabHolder"
    TabHolder.BackgroundColor3 = colors.tertiary
    TabHolder.BorderSizePixel = 0
    TabHolder.Position = UDim2.new(0, 0, 0, 40)
    TabHolder.Size = UDim2.new(0, 150, 1, -40)
    TabHolder.Parent = Main
    
    local TabHolderCorner = Instance.new("UICorner")
    TabHolderCorner.CornerRadius = UDim.new(0, 8)
    TabHolderCorner.Parent = TabHolder
    
    local TabHolderCover = Instance.new("Frame")
    TabHolderCover.Name = "TabHolderCover"
    TabHolderCover.BackgroundColor3 = colors.tertiary
    TabHolderCover.BorderSizePixel = 0
    TabHolderCover.Position = UDim2.new(1, -8, 0, 0)
    TabHolderCover.Size = UDim2.new(0, 8, 1, 0)
    TabHolderCover.ZIndex = 2
    TabHolderCover.Parent = TabHolder
    
    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Name = "TabScroll"
    TabScroll.Active = true
    TabScroll.BackgroundTransparency = 1
    TabScroll.Position = UDim2.new(0, 0, 0, 10)
    TabScroll.Size = UDim2.new(1, 0, 1, -10)
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScroll.ScrollBarThickness = 0
    TabScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabScroll.Parent = TabHolder
    
    local TabList = Instance.new("UIListLayout")
    TabList.Name = "TabList"
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 10)
    TabList.Parent = TabScroll
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.Name = "TabPadding"
    TabPadding.PaddingLeft = UDim.new(0, 10)
    TabPadding.PaddingRight = UDim.new(0, 10)
    TabPadding.PaddingTop = UDim.new(0, 5)
    TabPadding.PaddingBottom = UDim.new(0, 5)
    TabPadding.Parent = TabScroll
    
    -- Content container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 150, 0, 40)
    ContentContainer.Size = UDim2.new(1, -150, 1, -40)
    ContentContainer.Parent = Main
    
    -- Config menu
    local ConfigMenu = Instance.new("Frame")
    ConfigMenu.Name = "ConfigMenu"
    ConfigMenu.BackgroundColor3 = colors.secondary
    ConfigMenu.BorderSizePixel = 0
    ConfigMenu.Position = UDim2.new(1, 10, 0, 40)
    ConfigMenu.Size = UDim2.new(0, 200, 0, 250)
    ConfigMenu.Visible = false
    ConfigMenu.ZIndex = 5
    ConfigMenu.Parent = Main
    
    local ConfigMenuCorner = Instance.new("UICorner")
    ConfigMenuCorner.CornerRadius = UDim.new(0, 8)
    ConfigMenuCorner.Parent = ConfigMenu
    
    local ConfigTitle = Instance.new("TextLabel")
    ConfigTitle.Name = "ConfigTitle"
    ConfigTitle.BackgroundTransparency = 1
    ConfigTitle.Position = UDim2.new(0, 0, 0, 10)
    ConfigTitle.Size = UDim2.new(1, 0, 0, 20)
    ConfigTitle.Font = Enum.Font.GothamBold
    ConfigTitle.Text = "Configurations"
    ConfigTitle.TextColor3 = colors.text
    ConfigTitle.TextSize = 16
    ConfigTitle.ZIndex = 5
    ConfigTitle.Parent = ConfigMenu
    
    local ConfigScroll = Instance.new("ScrollingFrame")
    ConfigScroll.Name = "ConfigScroll"
    ConfigScroll.Active = true
    ConfigScroll.BackgroundTransparency = 1
    ConfigScroll.Position = UDim2.new(0, 10, 0, 40)
    ConfigScroll.Size = UDim2.new(1, -20, 0, 120)
    ConfigScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    ConfigScroll.ScrollBarThickness = 3
    ConfigScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    ConfigScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ConfigScroll.ZIndex = 5
    ConfigScroll.Parent = ConfigMenu
    
    local ConfigList = Instance.new("UIListLayout")
    ConfigList.Name = "ConfigList"
    ConfigList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ConfigList.SortOrder = Enum.SortOrder.LayoutOrder
    ConfigList.Padding = UDim.new(0, 5)
    ConfigList.Parent = ConfigScroll
    
    local ConfigInput = Instance.new("TextBox")
    ConfigInput.Name = "ConfigInput"
    ConfigInput.BackgroundColor3 = colors.tertiary
    ConfigInput.BorderSizePixel = 0
    ConfigInput.Position = UDim2.new(0, 10, 0, 170)
    ConfigInput.Size = UDim2.new(1, -20, 0, 25)
    ConfigInput.Font = Enum.Font.Gotham
    ConfigInput.PlaceholderText = "Config name..."
    ConfigInput.Text = ""
    ConfigInput.TextColor3 = colors.text
    ConfigInput.PlaceholderColor3 = colors.subText
    ConfigInput.TextSize = 14
    ConfigInput.ZIndex = 5
    ConfigInput.Parent = ConfigMenu
    
    local ConfigInputCorner = Instance.new("UICorner")
    ConfigInputCorner.CornerRadius = UDim.new(0, 4)
    ConfigInputCorner.Parent = ConfigInput
    
    local SaveButton = Instance.new("TextButton")
    SaveButton.Name = "SaveButton"
    SaveButton.BackgroundColor3 = colors.accent
    SaveButton.BorderSizePixel = 0
    SaveButton.Position = UDim2.new(0, 10, 0, 205)
    SaveButton.Size = UDim2.new(0.5, -15, 0, 30)
    SaveButton.Font = Enum.Font.GothamBold
    SaveButton.Text = "Save"
    SaveButton.TextColor3 = colors.text
    SaveButton.TextSize = 14
    SaveButton.ZIndex = 5
    SaveButton.Parent = ConfigMenu
    
    local SaveButtonCorner = Instance.new("UICorner")
    SaveButtonCorner.CornerRadius = UDim.new(0, 4)
    SaveButtonCorner.Parent = SaveButton
    
    local LoadButton = Instance.new("TextButton")
    LoadButton.Name = "LoadButton"
    LoadButton.BackgroundColor3 = colors.accent
    LoadButton.BorderSizePixel = 0
    LoadButton.Position = UDim2.new(0.5, 5, 0, 205)
    LoadButton.Size = UDim2.new(0.5, -15, 0, 30)
    LoadButton.Font = Enum.Font.GothamBold
    LoadButton.Text = "Load"
    LoadButton.TextColor3 = colors.text
    LoadButton.TextSize = 14
    LoadButton.ZIndex = 5
    LoadButton.Parent = ConfigMenu
    
    local LoadButtonCorner = Instance.new("UICorner")
    LoadButtonCorner.CornerRadius = UDim.new(0, 4)
    LoadButtonCorner.Parent = LoadButton
    
    -- Config menu shadow
    local ConfigShadow = Instance.new("ImageLabel")
    ConfigShadow.Name = "ConfigShadow"
    ConfigShadow.BackgroundTransparency = 1
    ConfigShadow.Position = UDim2.new(0, -15, 0, -15)
    ConfigShadow.Size = UDim2.new(1, 30, 1, 30)
    ConfigShadow.Image = "rbxassetid://6014054959"
    ConfigShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    ConfigShadow.ImageTransparency = 0.5
    ConfigShadow.ScaleType = Enum.ScaleType.Slice
    ConfigShadow.SliceCenter = Rect.new(80, 80, 80, 80)
    ConfigShadow.SliceScale = 0.3
    ConfigShadow.ZIndex = 4
    ConfigShadow.Parent = ConfigMenu
    
    -- Key bind menu
    local KeyBindMenu = Instance.new("Frame")
    KeyBindMenu.Name = "KeyBindMenu"
    KeyBindMenu.BackgroundColor3 = colors.secondary
    KeyBindMenu.BorderSizePixel = 0
    KeyBindMenu.Position = UDim2.new(0.5, -125, 0.5, -75)
    KeyBindMenu.Size = UDim2.new(0, 250, 0, 150)
    KeyBindMenu.Visible = false
    KeyBindMenu.ZIndex = 10
    KeyBindMenu.Parent = Rise
    
    local KeyBindMenuCorner = Instance.new("UICorner")
    KeyBindMenuCorner.CornerRadius = UDim.new(0, 8)
    KeyBindMenuCorner.Parent = KeyBindMenu
    
    local KeyBindTitle = Instance.new("TextLabel")
    KeyBindTitle.Name = "KeyBindTitle"
    KeyBindTitle.BackgroundTransparency = 1
    KeyBindTitle.Position = UDim2.new(0, 0, 0, 10)
    KeyBindTitle.Size = UDim2.new(1, 0, 0, 25)
    KeyBindTitle.Font = Enum.Font.GothamBold
    KeyBindTitle.Text = "Press a key"
    KeyBindTitle.TextColor3 = colors.text
    KeyBindTitle.TextSize = 18
    KeyBindTitle.ZIndex = 10
    KeyBindTitle.Parent = KeyBindMenu
    
    local KeyBindSubtitle = Instance.new("TextLabel")
    KeyBindSubtitle.Name = "KeyBindSubtitle"
    KeyBindSubtitle.BackgroundTransparency = 1
    KeyBindSubtitle.Position = UDim2.new(0, 0, 0, 35)
    KeyBindSubtitle.Size = UDim2.new(1, 0, 0, 20)
    KeyBindSubtitle.Font = Enum.Font.Gotham
    KeyBindSubtitle.Text = "Setting keybind for: Feature Name"
    KeyBindSubtitle.TextColor3 = colors.subText
    KeyBindSubtitle.TextSize = 14
    KeyBindSubtitle.ZIndex = 10
    KeyBindSubtitle.Parent = KeyBindMenu
    
    local KeyBindOptions = Instance.new("Frame")
    KeyBindOptions.Name = "KeyBindOptions"
    KeyBindOptions.BackgroundTransparency = 1
    KeyBindOptions.Position = UDim2.new(0, 0, 0, 70)
    KeyBindOptions.Size = UDim2.new(1, 0, 0, 30)
    KeyBindOptions.ZIndex = 10
    KeyBindOptions.Parent = KeyBindMenu
    
    local KeyBindCurrentKey = Instance.new("TextLabel")
    KeyBindCurrentKey.Name = "KeyBindCurrentKey"
    KeyBindCurrentKey.BackgroundColor3 = colors.tertiary
    KeyBindCurrentKey.BorderSizePixel = 0
    KeyBindCurrentKey.Position = UDim2.new(0.5, -70, 0, 0)
    KeyBindCurrentKey.Size = UDim2.new(0, 140, 0, 30)
    KeyBindCurrentKey.Font = Enum.Font.Gotham
    KeyBindCurrentKey.Text = "None"
    KeyBindCurrentKey.TextColor3 = colors.text
    KeyBindCurrentKey.TextSize = 14
    KeyBindCurrentKey.ZIndex = 10
    KeyBindCurrentKey.Parent = KeyBindOptions
    
    local KeyBindCurrentKeyCorner = Instance.new("UICorner")
    KeyBindCurrentKeyCorner.CornerRadius = UDim.new(0, 4)
    KeyBindCurrentKeyCorner.Parent = KeyBindCurrentKey
    
    local KeyBindButtons = Instance.new("Frame")
    KeyBindButtons.Name = "KeyBindButtons"
    KeyBindButtons.BackgroundTransparency = 1
    KeyBindButtons.Position = UDim2.new(0, 0, 0, 110)
    KeyBindButtons.Size = UDim2.new(1, 0, 0, 30)
    KeyBindButtons.ZIndex = 10
    KeyBindButtons.Parent = KeyBindMenu
    
    local CancelButton = Instance.new("TextButton")
    CancelButton.Name = "CancelButton"
    CancelButton.BackgroundColor3 = colors.warning
    CancelButton.BorderSizePixel = 0
    CancelButton.Position = UDim2.new(0, 20, 0, 0)
    CancelButton.Size = UDim2.new(0, 100, 0, 30)
    CancelButton.Font = Enum.Font.GothamBold
    CancelButton.Text = "Cancel"
    CancelButton.TextColor3 = colors.text
    CancelButton.TextSize = 14
    CancelButton.ZIndex = 10
    CancelButton.Parent = KeyBindButtons
    
    local CancelButtonCorner = Instance.new("UICorner")
    CancelButtonCorner.CornerRadius = UDim.new(0, 4)
    CancelButtonCorner.Parent = CancelButton
    
    local ApplyButton = Instance.new("TextButton")
    ApplyButton.Name = "ApplyButton"
    ApplyButton.BackgroundColor3 = colors.success
    ApplyButton.BorderSizePixel = 0
    ApplyButton.Position = UDim2.new(1, -120, 0, 0)
    ApplyButton.Size = UDim2.new(0, 100, 0, 30)
    ApplyButton.Font = Enum.Font.GothamBold
    ApplyButton.Text = "Apply"
    ApplyButton.TextColor3 = colors.text
    ApplyButton.TextSize = 14
    ApplyButton.ZIndex = 10
    ApplyButton.Parent = KeyBindButtons
    
    local ApplyButtonCorner = Instance.new("UICorner")
    ApplyButtonCorner.CornerRadius = UDim.new(0, 4)
    ApplyButtonCorner.Parent = ApplyButton
    
    -- Mobile touch menu for keybinds
    local MobileBindMenu = Instance.new("Frame")
    MobileBindMenu.Name = "MobileBindMenu"
    MobileBindMenu.BackgroundColor3 = colors.tertiary
    MobileBindMenu.BorderSizePixel = 0
    MobileBindMenu.Position = UDim2.new(0, 0, 0, 0)
    MobileBindMenu.Size = UDim2.new(0.2, 0, 1, 0)
    MobileBindMenu.Visible = false
    MobileBindMenu.ZIndex = 15
    MobileBindMenu.Parent = Rise
    
    local MobileBindCorner = Instance.new("UICorner")
    MobileBindCorner.CornerRadius = UDim.new(0, 8)
    MobileBindCorner.Parent = MobileBindMenu
    
    local MobileBindTitle = Instance.new("TextLabel")
    MobileBindTitle.Name = "MobileBindTitle"
    MobileBindTitle.BackgroundTransparency = 1
    MobileBindTitle.Position = UDim2.new(0, 0, 0, 10)
    MobileBindTitle.Size = UDim2.new(1, 0, 0, 25)
    MobileBindTitle.Font = Enum.Font.GothamBold
    MobileBindTitle.Text = "Keybinds"
    MobileBindTitle.TextColor3 = colors.text
    MobileBindTitle.TextSize = 18
    MobileBindTitle.ZIndex = 15
    MobileBindTitle.Parent = MobileBindMenu
    
    local MobileBindScroll = Instance.new("ScrollingFrame")
    MobileBindScroll.Name = "MobileBindScroll"
    MobileBindScroll.Active = true
    MobileBindScroll.BackgroundTransparency = 1
    MobileBindScroll.Position = UDim2.new(0, 5, 0, 45)
    MobileBindScroll.Size = UDim2.new(1, -10, 1, -50)
    MobileBindScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    MobileBindScroll.ScrollBarThickness = 3
    MobileBindScroll.ScrollingDirection = Enum.ScrollingDirection.Y
    MobileBindScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    MobileBindScroll.ZIndex = 15
    MobileBindScroll.Parent = MobileBindMenu
    
    local MobileBindList = Instance.new("UIListLayout")
    MobileBindList.Name = "MobileBindList"
    MobileBindList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    MobileBindList.SortOrder = Enum.SortOrder.LayoutOrder
    MobileBindList.Padding = UDim.new(0, 10)
    MobileBindList.Parent = MobileBindScroll
    
    -- Notification system
    local NotificationHolder = Instance.new("Frame")
    NotificationHolder.Name = "NotificationHolder"
    NotificationHolder.BackgroundTransparency = 1
    NotificationHolder.Position = UDim2.new(1, -330, 0, 20)
    NotificationHolder.Size = UDim2.new(0, 300, 1, -40)
    NotificationHolder.ZIndex = 100
    NotificationHolder.Parent = Rise
    
    local NotificationList = Instance.new("UIListLayout")
    NotificationList.Name = "NotificationList"
    NotificationList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    NotificationList.SortOrder = Enum.SortOrder.LayoutOrder
    NotificationList.VerticalAlignment = Enum.VerticalAlignment.Top
    NotificationList.Padding = UDim.new(0, 10)
    NotificationList.Parent = NotificationHolder
    
    -- UI functionality
    local activeTab
    local currentBindingButton
    local keybinds = {}
    
    -- Dragging functionality
    local dragging, dragStart, startPos
    
    local function updateDrag(input)
        if dragging then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            updateDrag(input)
        end
    end)
    
    -- Window behavior
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Main.Size = UDim2.new(0, 600, 0, 40)
            TabHolder.Visible = false
            ContentContainer.Visible = false
        else
            Main.Size = UDim2.new(0, 600, 0, 400)
            TabHolder.Visible = true
            ContentContainer.Visible = true
        end
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        Rise:Destroy()
    end)
    
    -- Config menu functionality
    local configMenuOpen = false
    
    local function updateConfigList()
        -- Clear existing config buttons
        for _, child in pairs(ConfigScroll:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        -- Get configs and create buttons
        local configFiles = getConfigs()
        for i, configName in ipairs(configFiles) do
            local ConfigButton = Instance.new("TextButton")
            ConfigButton.Name = configName
            ConfigButton.BackgroundColor3 = colors.tertiary
            ConfigButton.BorderSizePixel = 0
            ConfigButton.Size = UDim2.new(1, -20, 0, 25)
            ConfigButton.Font = Enum.Font.Gotham
            ConfigButton.Text = configName
            ConfigButton.TextColor3 = colors.text
            ConfigButton.TextSize = 14
            ConfigButton.ZIndex = 5
            ConfigButton.Parent = ConfigScroll
            
            local ConfigButtonCorner = Instance.new("UICorner")
            ConfigButtonCorner.CornerRadius = UDim.new(0, 4)
            ConfigButtonCorner.Parent = ConfigButton
            
            ConfigButton.MouseButton1Click:Connect(function()
                ConfigInput.Text = configName
            end)
        end
    end
    
    ConfigButton.MouseButton1Click:Connect(function()
        configMenuOpen = not configMenuOpen
        ConfigMenu.Visible = configMenuOpen
        
        if configMenuOpen then
            updateConfigList()
            ConfigMenu.Position = UDim2.new(1, -210, 0, 40)
        end
    end)
    
    SaveButton.MouseButton1Click:Connect(function()
        local configName = ConfigInput.Text
        if configName ~= "" then
            saveConfig(configName)
            updateConfigList()
            RiseLib:Notify("Config Saved", "Saved configuration: " .. configName, 3)
        else
            RiseLib:Notify("Error", "Please enter a config name", 3, colors.warning)
        end
    end)
    
    LoadButton.MouseButton1Click:Connect(function()
        local configName = ConfigInput.Text
        if configName ~= "" then
            if loadConfig(configName) then
                -- Apply loaded configs to UI elements
                for feature, value in pairs(configs) do
                    if value.Type == "Toggle" then
                        if value.State ~= nil and value.Object and value.Object.Parent then
                            local toggle = value.Object
                            local indicator = toggle:FindFirstChild("Indicator")
                            if indicator then
                                toggle.BackgroundColor3 = value.State and colors.accent or colors.tertiary
                            end
                        end
                    elseif value.Type == "Slider" then
                        if value.Value ~= nil and value.Object and value.Object.Parent then
                            local slider = value.Object
                            local fill = slider:FindFirstChild("Fill")
                            local valueLabel = slider:FindFirstChild("Value")
                            if fill and valueLabel then
                                fill.Size = UDim2.new(value.Value / value.Max, 0, 1, 0)
                                valueLabel.Text = tostring(value.Value)
                            end
                        end
                    elseif value.Type == "Dropdown" then
                        if value.Selected ~= nil and value.Object and value.Object.Parent then
                            local dropdown = value.Object
                            local selected = dropdown:FindFirstChild("Selected")
                            if selected then
                                selected.Text = value.Selected
                            end
                        end
                    elseif value.Type == "ColorPicker" then
                        if value.Color ~= nil and value.Object and value.Object.Parent then
                            local picker = value.Object
                            local preview = picker:FindFirstChild("Preview")
                            if preview then
                                preview.BackgroundColor3 = Color3.fromRGB(value.Color[1], value.Color[2], value.Color[3])
                            end
                        end
                    end
                end
                
                RiseLib:Notify("Config Loaded", "Loaded configuration: " .. configName, 3)
            else
                RiseLib:Notify("Error", "Config not found: " .. configName, 3, colors.warning)
            end
        else
            RiseLib:Notify("Error", "Please enter a config name", 3, colors.warning)
        end
    end)
    
    -- Mobile keybind menu toggle button
    local MobileMenuButton = Instance.new("ImageButton")
    MobileMenuButton.Name = "MobileMenuButton"
    MobileMenuButton.BackgroundColor3 = colors.accent
    MobileMenuButton.BorderSizePixel = 0
    MobileMenuButton.Position = UDim2.new(0, 20, 0, 100)
    MobileMenuButton.Size = UDim2.new(0, 40, 0, 40)
    MobileMenuButton.Image = "rbxassetid://7059346373" -- Keybind icon
    MobileMenuButton.ImageColor3 = colors.text
    MobileMenuButton.Visible = isMobile
    MobileMenuButton.ZIndex = 15
    MobileMenuButton.Parent = Rise
    
    local MobileMenuButtonCorner = Instance.new("UICorner")
    MobileMenuButtonCorner.CornerRadius = UDim.new(1, 0)
    MobileMenuButtonCorner.Parent = MobileMenuButton
    
    local mobileMenuOpen = false
    MobileMenuButton.MouseButton1Click:Connect(function()
        mobileMenuOpen = not mobileMenuOpen
        MobileBindMenu.Visible = mobileMenuOpen
    end)
    
    -- Keybind system
    local function handleKeybindPress(input, bind)
        if bind and bind.Callback and typeof(bind.Callback) == "function" then
            bind.Callback()
            RiseLib:Notify("Keybind Activated", bind.Name, 2)
        end
    end
    
    UIS.InputBegan:Connect(function(input, processed)
        if processed then return end
        
        if input.UserInputType == Enum.UserInputType.Keyboard then
            for _, bind in pairs(keybinds) do
                if bind.Key == input.KeyCode then
                    handleKeybindPress(input, bind)
                end
            end
        end
    end)
    
    -- Set keybind function
    local function setKeybind(button, name, callback)
        KeyBindMenu.Visible = true
        KeyBindSubtitle.Text = "Setting keybind for: " .. name
        KeyBindCurrentKey.Text = "Press a key..."
        
        currentBindingButton = button
        
        local connection
        connection = UIS.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                KeyBindCurrentKey.Text = input.KeyCode.Name
                
                -- Wait for confirmation button
                ApplyButton.MouseButton1Click:Connect(function()
                    if currentBindingButton == button then
                        -- Update keybind
                        local bindInfo = {
                            Name = name,
                            Key = input.KeyCode,
                            Callback = callback
                        }
                        
                        -- Store in keybinds table
                        keybinds[name] = bindInfo
                        
                        -- Update button text
                        button.Text = input.KeyCode.Name
                        
                        -- Add to mobile menu if on mobile
                        if isMobile then
                            local mobileBindButton = Instance.new("TextButton")
                            mobileBindButton.Name = name
                            mobileBindButton.BackgroundColor3 = colors.tertiary
                            mobileBindButton.BorderSizePixel = 0
                            mobileBindButton.Size = UDim2.new(1, -20, 0, 40)
                            mobileBindButton.Font = Enum.Font.Gotham
                            mobileBindButton.Text = name
                            mobileBindButton.TextColor3 = colors.text
                            mobileBindButton.TextSize = 14
                            mobileBindButton.ZIndex = 15
                            mobileBindButton.Parent = MobileBindScroll
                            
                            local mobileBindButtonCorner = Instance.new("UICorner")
                            mobileBindButtonCorner.CornerRadius = UDim.new(0, 4)
                            mobileBindButtonCorner.Parent = mobileBindButton
                            
                            mobileBindButton.MouseButton1Click:Connect(function()
                                callback()
                                RiseLib:Notify("Keybind Activated", name, 2)
                            end)
                        end
                        
                        KeyBindMenu.Visible = false
                        currentBindingButton = nil
                    end
                    connection:Disconnect()
                end)
                
                CancelButton.MouseButton1Click:Connect(function()
                    KeyBindMenu.Visible = false
                    currentBindingButton = nil
                    connection:Disconnect()
                end)
            end
        end)
    end
    
    -- Notification system
    function RiseLib:Notify(title, message, duration, color)
        duration = duration or 3
        color = color or colors.accent
        
        local Notification = Instance.new("Frame")
        Notification.Name = "Notification"
        Notification.BackgroundColor3 = colors.secondary
        Notification.BorderSizePixel = 0
        Notification.Size = UDim2.new(1, -20, 0, 80)
        Notification.ClipsDescendants = true
        Notification.ZIndex = 100
        Notification.Parent = NotificationHolder
        
        local NotificationCorner = Instance.new("UICorner")
        NotificationCorner.CornerRadius = UDim.new(0, 8)
        NotificationCorner.Parent = Notification
        
        local NotificationAccent = Instance.new("Frame")
        NotificationAccent.Name = "NotificationAccent"
        NotificationAccent.BackgroundColor3 = color
        NotificationAccent.BorderSizePixel = 0
        NotificationAccent.Size = UDim2.new(0, 5, 1, 0)
        NotificationAccent.ZIndex = 100
        NotificationAccent.Parent = Notification
        
        local NotificationAccentCorner = Instance.new("UICorner")
        NotificationAccentCorner.CornerRadius = UDim.new(0, 8)
        NotificationAccentCorner.Parent = NotificationAccent
        
        local NotificationTitle = Instance.new("TextLabel")
        NotificationTitle.Name = "NotificationTitle"
        NotificationTitle.BackgroundTransparency = 1
        NotificationTitle.Position = UDim2.new(0, 15, 0, 10)
        NotificationTitle.Size = UDim2.new(1, -25, 0, 25)
        NotificationTitle.Font = Enum.Font.GothamBold
        NotificationTitle.Text = title
        NotificationTitle.TextColor3 = colors.text
        NotificationTitle.TextSize = 16
        NotificationTitle.TextXAlignment = Enum.TextXAlignment.Left
        NotificationTitle.ZIndex = 100
        NotificationTitle.Parent = Notification
        
        local NotificationMessage = Instance.new("TextLabel")
        NotificationMessage.Name = "NotificationMessage"
        NotificationMessage.BackgroundTransparency = 1
        NotificationMessage.Position = UDim2.new(0, 15, 0, 35)
        NotificationMessage.Size = UDim2.new(1, -25, 0, 35)
        NotificationMessage.Font = Enum.Font.Gotham
        NotificationMessage.Text = message
        NotificationMessage.TextColor3 = colors.subText
        NotificationMessage.TextSize = 14
        NotificationMessage.TextWrapped = true
        NotificationMessage.TextXAlignment = Enum.TextXAlignment.Left
        NotificationMessage.TextYAlignment = Enum.TextYAlignment.Top
        NotificationMessage.ZIndex = 100
        NotificationMessage.Parent = Notification
        
        local NotificationProgress = Instance.new("Frame")
        NotificationProgress.Name = "NotificationProgress"
        NotificationProgress.BackgroundColor3 = color
        NotificationProgress.BorderSizePixel = 0
        NotificationProgress.Position = UDim2.new(0, 0, 1, -3)
        NotificationProgress.Size = UDim2.new(1, 0, 0, 3)
        NotificationProgress.ZIndex = 100
        NotificationProgress.Parent = Notification
        
        -- Animation
        Notification.Position = UDim2.new(1, 20, 0, 0)
        TweenService:Create(Notification, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Position = UDim2.new(0, 10, 0, 0)}):Play()
        
        -- Progress
        TweenService:Create(NotificationProgress, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 3)}):Play()
        
        -- Auto remove
        task.delay(duration, function()
            TweenService:Create(Notification, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Position = UDim2.new(1, 20, 0, 0)}):Play()
            task.delay(0.35, function()
                Notification:Destroy()
            end)
        end)
        
        return Notification
    end
    
    -- Tab system
    function RiseLib:CreateTab(name, icon)
        local tabIcon = icon or "rbxassetid://7059353376" -- Default icon
        
        -- Create tab button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name .. "Tab"
        TabButton.BackgroundColor3 = colors.tertiary
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = ""
        TabButton.AutoButtonColor = false
        TabButton.Parent = TabScroll
        
        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 6)
        TabButtonCorner.Parent = TabButton
        
        local TabIcon = Instance.new("ImageLabel")
        TabIcon.Name = "TabIcon"
        TabIcon.BackgroundTransparency = 1
        TabIcon.Position = UDim2.new(0, 10, 0.5, -10)
        TabIcon.Size = UDim2.new(0, 20, 0, 20)
        TabIcon.Image = tabIcon
        TabIcon.ImageColor3 = colors.subText
        TabIcon.Parent = TabButton
        
        local TabName = Instance.new("TextLabel")
        TabName.Name = "TabName"
        TabName.BackgroundTransparency = 1
        TabName.Position = UDim2.new(0, 40, 0, 0)
        TabName.Size = UDim2.new(1, -50, 1, 0)
        TabName.Font = Enum.Font.Gotham
        TabName.Text = name
        TabName.TextColor3 = colors.subText
        TabName.TextSize = 14
        TabName.TextXAlignment = Enum.TextXAlignment.Left
        TabName.Parent = TabButton
        
        -- Create tab page
        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Name = name .. "Page"
        TabPage.Active = true
        TabPage.BackgroundTransparency = 1
        TabPage.BorderSizePixel = 0
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabPage.ScrollBarThickness = 3
        TabPage.ScrollingDirection = Enum.ScrollingDirection.Y
        TabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabPage.Visible = false
        TabPage.Parent = ContentContainer
        
        local TabPagePadding = Instance.new("UIPadding")
        TabPagePadding.PaddingLeft = UDim.new(0, 15)
        TabPagePadding.PaddingRight = UDim.new(0, 15)
        TabPagePadding.PaddingTop = UDim.new(0, 15)
        TabPagePadding.PaddingBottom = UDim.new(0, 15)
        TabPagePadding.Parent = TabPage
        
        local TabPageList = Instance.new("UIListLayout")
        TabPageList.SortOrder = Enum.SortOrder.LayoutOrder
        TabPageList.Padding = UDim.new(0, 10)
        TabPageList.Parent = TabPage
        
        -- Tab button functionality
        TabButton.MouseButton1Click:Connect(function()
            if activeTab then
                -- De-select previous tab
                local prevTabButton = TabScroll:FindFirstChild(activeTab.Name .. "Tab")
                if prevTabButton then
                    TweenService:Create(prevTabButton, TweenInfo.new(0.2), {BackgroundColor3 = colors.tertiary}):Play()
                    TweenService:Create(prevTabButton.TabIcon, TweenInfo.new(0.2), {ImageColor3 = colors.subText}):Play()
                    TweenService:Create(prevTabButton.TabName, TweenInfo.new(0.2), {TextColor3 = colors.subText}):Play()
                end
                
                activeTab.Visible = false
            end
            
            -- Select new tab
            activeTab = TabPage
            activeTab.Visible = true
            
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = colors.accent}):Play()
            TweenService:Create(TabIcon, TweenInfo.new(0.2), {ImageColor3 = colors.text}):Play()
            TweenService:Create(TabName, TweenInfo.new(0.2), {TextColor3 = colors.text}):Play()
        end)
        
        -- Select first tab by default
        if not activeTab then
            activeTab = TabPage
            activeTab.Visible = true
            
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = colors.accent}):Play()
            TweenService:Create(TabIcon, TweenInfo.new(0.2), {ImageColor3 = colors.text}):Play()
            TweenService:Create(TabName, TweenInfo.new(0.2), {TextColor3 = colors.text}):Play()
        end
        
        -- Tab API
        local Tab = {}
        
        -- Function to create section
        function Tab:CreateSection(sectionName)
            local Section = Instance.new("Frame")
            Section.Name = sectionName .. "Section"
            Section.BackgroundColor3 = colors.secondary
            Section.BorderSizePixel = 0
            Section.Size = UDim2.new(1, 0, 0, 40)
            Section.AutomaticSize = Enum.AutomaticSize.Y
            Section.Parent = TabPage
            
            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 8)
            SectionCorner.Parent = Section
            
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "SectionTitle"
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Position = UDim2.new(0, 15, 0, 0)
            SectionTitle.Size = UDim2.new(1, -30, 0, 40)
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.Text = sectionName
            SectionTitle.TextColor3 = colors.text
            SectionTitle.TextSize = 16
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = Section
            
            local SectionContent = Instance.new("Frame")
            SectionContent.Name = "SectionContent"
            SectionContent.BackgroundTransparency = 1
            SectionContent.Position = UDim2.new(0, 15, 0, 40)
            SectionContent.Size = UDim2.new(1, -30, 0, 0)
            SectionContent.AutomaticSize = Enum.AutomaticSize.Y
            SectionContent.Parent = Section
            
            local SectionList = Instance.new("UIListLayout")
            SectionList.SortOrder = Enum.SortOrder.LayoutOrder
            SectionList.Padding = UDim.new(0, 10)
            SectionList.Parent = SectionContent
            
            -- Update section size based on content
            SectionList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionContent.Size = UDim2.new(1, -30, 0, SectionList.AbsoluteContentSize.Y)
                Section.Size = UDim2.new(1, 0, 0, 40 + SectionContent.Size.Y.Offset + 15)
            end)
            
            -- Section API
            local SectionAPI = {}
            
            -- Create toggle
            function SectionAPI:CreateToggle(toggleInfo)
                local name = toggleInfo.Name
                local default = toggleInfo.Default or false
                local callback = toggleInfo.Callback or function() end
                local flag = toggleInfo.Flag
                
                local Toggle = Instance.new("TextButton")
                Toggle.Name = name .. "Toggle"
                Toggle.BackgroundColor3 = default and colors.accent or colors.tertiary
                Toggle.BorderSizePixel = 0
                Toggle.Size = UDim2.new(1, 0, 0, 40)
                Toggle.Font = Enum.Font.Gotham
                Toggle.Text = ""
                Toggle.AutoButtonColor = false
                Toggle.Parent = SectionContent
                
                local ToggleCorner = Instance.new("UICorner")
                ToggleCorner.CornerRadius = UDim.new(0, 6)
                ToggleCorner.Parent = Toggle
                
                local ToggleName = Instance.new("TextLabel")
                ToggleName.Name = "ToggleName"
                ToggleName.BackgroundTransparency = 1
                ToggleName.Position = UDim2.new(0, 15, 0, 0)
                ToggleName.Size = UDim2.new(1, -80, 1, 0)
                ToggleName.Font = Enum.Font.Gotham
                ToggleName.Text = name
                ToggleName.TextColor3 = colors.text
                ToggleName.TextSize = 14
                ToggleName.TextXAlignment = Enum.TextXAlignment.Left
                ToggleName.Parent = Toggle
                
                local Indicator = Instance.new("Frame")
                Indicator.Name = "Indicator"
                Indicator.BackgroundColor3 = default and colors.success : colors.disabled
                Indicator.BorderSizePixel = 0
                Indicator.Position = UDim2.new(1, -50, 0.5, -10)
                Indicator.Size = UDim2.new(0, 40, 0, 20)
                Indicator.Parent = Toggle
                
                local IndicatorCorner = Instance.new("UICorner")
                IndicatorCorner.CornerRadius = UDim.new(0, 10)
                IndicatorCorner.Parent = Indicator
                
                local Circle = Instance.new("Frame")
                Circle.Name = "Circle"
                Circle.BackgroundColor3 = colors.text
                Circle.BorderSizePixel = 0
                Circle.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                Circle.Size = UDim2.new(0, 16, 0, 16)
                Circle.Parent = Indicator
                
                local CircleCorner = Instance.new("UICorner")
                CircleCorner.CornerRadius = UDim.new(1, 0)
                CircleCorner.Parent = Circle
                
                -- Keybind button
                local KeybindButton = Instance.new("TextButton")
                KeybindButton.Name = "KeybindButton"
                KeybindButton.BackgroundColor3 = colors.tertiary
                KeybindButton.BorderSizePixel = 0
                KeybindButton.Position = UDim2.new(1, -95, 0.5, -10)
                KeybindButton.Size = UDim2.new(0, 40, 0, 20)
                KeybindButton.Font = Enum.Font.Gotham
                KeybindButton.Text = "None"
                KeybindButton.TextColor3 = colors.subText
                KeybindButton.TextSize = 12
                KeybindButton.AutoButtonColor = false
                KeybindButton.Visible = false
                KeybindButton.Parent = Toggle
                
                local KeybindCorner = Instance.new("UICorner")
                KeybindCorner.CornerRadius = UDim.new(0, 4)
                KeybindCorner.Parent = KeybindButton
                
                -- Toggle state
                local enabled = default
                
                -- Update config
                if flag then
                    configs[flag] = {
                        Type = "Toggle",
                        State = enabled,
                        Object = Toggle
                    }
                end
                
                -- Toggle functionality
                Toggle.MouseButton1Click:Connect(function()
                    enabled = not enabled
                    
                    -- Animate toggle
                    if enabled then
                        TweenService:Create(Toggle, TweenInfo.new(0.2), {BackgroundColor3 = colors.accent}):Play()
                        TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = colors.success}):Play()
                        TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
                    else
                        TweenService:Create(Toggle, TweenInfo.new(0.2), {BackgroundColor3 = colors.tertiary}):Play()
                        TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = colors.disabled}):Play()
                        TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
                    end
                    
                    -- Update config
                    if flag then
                        configs[flag].State = enabled
                    end
                    
                    -- Callback
                    callback(enabled)
                end)
                
                -- Keybind functionality
                KeybindButton.MouseButton1Click:Connect(function()
                    setKeybind(KeybindButton, name, function()
                        Toggle.MouseButton1Click:Fire()
                    end)
                end)
                
                -- Toggle API
                local ToggleAPI = {}
                
                function ToggleAPI:Set(value)
                    enabled = value
                    
                    -- Animate toggle
                    if enabled then
                        TweenService:Create(Toggle, TweenInfo.new(0.2), {BackgroundColor3 = colors.accent}):Play()
                        TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = colors.success}):Play()
                        TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
                    else
                        TweenService:Create(Toggle, TweenInfo.new(0.2), {BackgroundColor3 = colors.tertiary}):Play()
                        TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = colors.disabled}):Play()
                        TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
                    end
                    
                    -- Update config
                    if flag then
                        configs[flag].State = enabled
                    end
                    
                    -- Callback
                    callback(enabled)
                end
                
                function ToggleAPI:Get()
                    return enabled
                end
                
                function ToggleAPI:SetKeybind(key)
                    KeybindButton.Visible = true
                    KeybindButton.Text = key
                    keybinds[name] = {
                        Name = name,
                        Key = Enum.KeyCode[key],
                        Callback = function()
                            Toggle.MouseButton1Click:Fire()
                        end
                    }
                    
                    -- Add to mobile menu if on mobile
                    if isMobile then
                        local mobileBindButton = Instance.new("TextButton")
                        mobileBindButton.Name = name
                        mobileBindButton.BackgroundColor3 = colors.tertiary
                        mobileBindButton.BorderSizePixel = 0
                        mobileBindButton.Size = UDim2.new(1, -20, 0, 40)
                        mobileBindButton.Font = Enum.Font.Gotham
                        mobileBindButton.Text = name
                        mobileBindButton.TextColor3 = colors.text
                        mobileBindButton.TextSize = 14
                        mobileBindButton.ZIndex = 15
                        mobileBindButton.Parent = MobileBindScroll
                        
                        local mobileBindButtonCorner = Instance.new("UICorner")
                        mobileBindButtonCorner.CornerRadius = UDim.new(0, 4)
                        mobileBindButtonCorner.Parent = mobileBindButton
                        
                        mobileBindButton.MouseButton1Click:Connect(function()
                            Toggle.MouseButton1Click:Fire()
                        end)
                    end
                end
                
                return ToggleAPI
            end
            
            -- Create slider
            function SectionAPI:CreateSlider(sliderInfo)
                local name = sliderInfo.Name
                local min = sliderInfo.Min or 0
                local max = sliderInfo.Max or 100
                local default = sliderInfo.Default or min
                local callback = sliderInfo.Callback or function() end
                local flag = sliderInfo.Flag
                
                -- Clamp default value
                default = math.clamp(default, min, max)
                
                local Slider = Instance.new("Frame")
                Slider.Name = name .. "Slider"
                Slider.BackgroundColor3 = colors.tertiary
                Slider.BorderSizePixel = 0
                Slider.Size = UDim2.new(1, 0, 0, 60)
                Slider.Parent = SectionContent
                
                local SliderCorner = Instance.new("UICorner")
                SliderCorner.CornerRadius = UDim.new(0, 6)
                SliderCorner.Parent = Slider
                
                local SliderName = Instance.new("TextLabel")
                SliderName.Name = "SliderName"
                SliderName.BackgroundTransparency = 1
                SliderName.Position = UDim2.new(0, 15, 0, 0)
                SliderName.Size = UDim2.new(1, -30, 0, 30)
                SliderName.Font = Enum.Font.Gotham
                SliderName.Text = name
                SliderName.TextColor3 = colors.text
                SliderName.TextSize = 14
                SliderName.TextXAlignment = Enum.TextXAlignment.Left
                SliderName.Parent = Slider
                
                local SliderBg = Instance.new("Frame")
                SliderBg.Name = "SliderBg"
                SliderBg.BackgroundColor3 = colors.background
                SliderBg.BorderSizePixel = 0
                SliderBg.Position = UDim2.new(0, 15, 0, 40)
                SliderBg.Size = UDim2.new(1, -100, 0, 6)
                SliderBg.Parent = Slider
                
                local SliderBgCorner = Instance.new("UICorner")
                SliderBgCorner.CornerRadius = UDim.new(0, 3)
                SliderBgCorner.Parent = SliderBg
                
                local Fill = Instance.new("Frame")
                Fill.Name = "Fill"
                Fill.BackgroundColor3 = colors.accent
                Fill.BorderSizePixel = 0
                Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                Fill.Parent = SliderBg
                
                local FillCorner = Instance.new("UICorner")
                FillCorner.CornerRadius = UDim.new(0, 3)
                FillCorner.Parent = Fill
                
                local Value = Instance.new("TextLabel")
                Value.Name = "Value"
                Value.BackgroundTransparency = 1
                Value.Position = UDim2.new(1, -70, 0, 0)
                Value.Size = UDim2.new(0, 50, 0, 30)
                Value.Font = Enum.Font.Gotham
                Value.Text = tostring(default)
                Value.TextColor3 = colors.text
                Value.TextSize = 14
                Value.Parent = Slider
                
                -- Slider functionality
                local value = default
                local dragging = false
                
                -- Update config
                if flag then
                    configs[flag] = {
                        Type = "Slider",
                        Value = value,
                        Min = min,
                        Max = max,
                        Object = Slider
                    }
                end
                
                local function updateSlider(input)
                    local pos = UDim2.new(math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1), 0, 1, 0)
                    Fill.Size = pos
                    
                    value = math.floor(min + ((max - min) * pos.X.Scale))
                    Value.Text = tostring(value)
                    
                    -- Update config
                    if flag then
                        configs[flag].Value = value
                    end
                    
                    callback(value)
                end
                
                SliderBg.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        updateSlider(input)
                    end
                end)
                
                SliderBg.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)
                
                UIS.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        updateSlider(input)
                    end
                end)
                
                -- Slider API
                local SliderAPI = {}
                
                function SliderAPI:Set(val)
                    value = math.clamp(val, min, max)
                    Fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
                    Value.Text = tostring(value)
                    
                    -- Update config
                    if flag then
                        configs[flag].Value = value
                    end
                    
                    callback(value)
                end
                
                function SliderAPI:Get()
                    return value
                end
                
                return SliderAPI
            end
            
            -- Create dropdown
            function SectionAPI:CreateDropdown(dropInfo)
                local name = dropInfo.Name
                local options = dropInfo.Options or {}
                local default = dropInfo.Default or options[1]
                local callback = dropInfo.Callback or function() end
                local flag = dropInfo.Flag
                
                local Dropdown = Instance.new("Frame")
                Dropdown.Name = name .. "Dropdown"
                Dropdown.BackgroundColor3 = colors.tertiary
                Dropdown.BorderSizePixel = 0
                Dropdown.Size = UDim2.new(1, 0, 0, 40)
                Dropdown.ClipsDescendants = true
                Dropdown.Parent = SectionContent
                
                local DropdownCorner = Instance.new("UICorner")
                DropdownCorner.CornerRadius = UDim.new(0, 6)
                DropdownCorner.Parent = Dropdown
                
                local DropdownName = Instance.new("TextLabel")
                DropdownName.Name = "DropdownName"
                DropdownName.BackgroundTransparency = 1
                DropdownName.Position = UDim2.new(0, 15, 0, 0)
                DropdownName.Size = UDim2.new(1, -70, 0, 40)
                DropdownName.Font = Enum.Font.Gotham
                DropdownName.Text = name
                DropdownName.TextColor3 = colors.text
                DropdownName.TextSize = 14
                DropdownName.TextXAlignment = Enum.TextXAlignment.Left
                DropdownName.Parent = Dropdown
                
                local Selected = Instance.new("TextLabel")
                Selected.Name = "Selected"
                Selected.BackgroundTransparency = 1
                Selected.Position = UDim2.new(1, -170, 0, 0)
                Selected.Size = UDim2.new(0, 150, 0, 40)
                Selected.Font = Enum.Font.Gotham
                Selected.Text = default or "Select..."
                Selected.TextColor3 = colors.subText
                Selected.TextSize = 14
                Selected.TextXAlignment = Enum.TextXAlignment.Right
                Selected.Parent = Dropdown
                
                local DropdownArrow = Instance.new("ImageLabel")
                DropdownArrow.Name = "DropdownArrow"
                DropdownArrow.BackgroundTransparency = 1
                DropdownArrow.Position = UDim2.new(1, -30, 0.5, -10)
                DropdownArrow.Size = UDim2.new(0, 20, 0, 20)
                DropdownArrow.Image = "rbxassetid://7072706318"
                DropdownArrow.ImageColor3 = colors.subText
                DropdownArrow.Parent = Dropdown
                
                local OptionHolder = Instance.new("Frame")
                OptionHolder.Name = "OptionHolder"
                OptionHolder.BackgroundTransparency = 1
                OptionHolder.Position = UDim2.new(0, 0, 0, 40)
                OptionHolder.Size = UDim2.new(1, 0, 0, #options * 30)
                OptionHolder.Parent = Dropdown
                
                local OptionList = Instance.new("UIListLayout")
                OptionList.SortOrder = Enum.SortOrder.LayoutOrder
                OptionList.Parent = OptionHolder
                
                -- Dropdown functionality
                local selectedOption = default
                local open = false
                
                -- Update config
                if flag then
                    configs[flag] = {
                        Type = "Dropdown",
                        Selected = selectedOption,
                        Options = options,
                        Object = Dropdown
                    }
                end
                
                -- Create options
                for i, option in ipairs(options) do
                    local Option = Instance.new("TextButton")
                    Option.Name = option
                    Option.BackgroundColor3 = colors.background
                    Option.BorderSizePixel = 0
                    Option.Size = UDim2.new(1, 0, 0, 30)
                    Option.Font = Enum.Font.Gotham
                    Option.Text = option
                    Option.TextColor3 = option == selectedOption and colors.accent or colors.subText
                    Option.TextSize = 14
                    Option.Parent = OptionHolder
                    
                    Option.MouseButton1Click:Connect(function()
                        selectedOption = option
                        Selected.Text = option
                        
                        -- Update selected option color
                        for _, opt in ipairs(OptionHolder:GetChildren()) do
                            if opt:IsA("TextButton") then
                                opt.TextColor3 = opt.Name == selectedOption and colors.accent or colors.subText
                            end
                        end
                        
                        -- Close dropdown
                        TweenService:Create(Dropdown, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 40)}):Play()
                        TweenService:Create(DropdownArrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                        open = false
                        
                        -- Update config
                        if flag then
                            configs[flag].Selected = selectedOption
                        end
                        
                        callback(selectedOption)
                    end)
                end
                
                -- Toggle dropdown
                Dropdown.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        open = not open
                        
                        if open then
                            TweenService:Create(Dropdown, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 40 + OptionHolder.Size.Y.Offset)}):Play()
                            TweenService:Create(DropdownArrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
                        else
                            TweenService:Create(Dropdown, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 40)}):Play()
                            TweenService:Create(DropdownArrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                        end
                    end
                end)
                
                -- Dropdown API
                local DropdownAPI = {}
                
                function DropdownAPI:Set(option)
                    if table.find(options, option) then
                        selectedOption = option
                        Selected.Text = option
                        
                        -- Update selected option color
                        for _, opt in ipairs(OptionHolder:GetChildren()) do
                            if opt:IsA("TextButton") then
                                opt.TextColor3 = opt.Name == selectedOption and colors.accent or colors.subText
                            end
                        end
                        
                        -- Update config
                        if flag then
                            configs[flag].Selected = selectedOption
                        end
                        
                        callback(selectedOption)
                    end
                end
                
                function DropdownAPI:Get()
                    return selectedOption
                end
                
                function DropdownAPI:Refresh(newOptions, keepSelection)
                    options = newOptions
                    
                    -- Clear existing options
                    for _, child in pairs(OptionHolder:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    
                    -- Update size
                    OptionHolder.Size = UDim2.new(1, 0, 0, #options * 30)
                    
                    -- Keep selection if possible
                    if not keepSelection or not table.find(options, selectedOption) then
                        selectedOption = options[1]
                        Selected.Text = selectedOption
                    end
                    
                    -- Update config
                    if flag then
                        configs[flag].Selected = selectedOption
                        configs[flag].Options = options
                    end
                    
                    -- Create new options
                    for i, option in ipairs(options) do
                        local Option = Instance.new("TextButton")
                        Option.Name = option
                        Option.BackgroundColor3 = colors.background
                        Option.BorderSizePixel = 0
                        Option.Size = UDim2.new(1, 0, 0, 30)
                        Option.Font = Enum.Font.Gotham
                        Option.Text = option
                        Option.TextColor3 = option == selectedOption and colors.accent or colors.subText
                        Option.TextSize = 14
                        Option.Parent = OptionHolder
                        
                        Option.MouseButton1Click:Connect(function()
                            selectedOption = option
                            Selected.Text = option
                            
                            -- Update selected option color
                            for _, opt in ipairs(OptionHolder:GetChildren()) do
                                if opt:IsA("TextButton") then
                                    opt.TextColor3 = opt.Name == selectedOption and colors.accent or colors.subText
                                end
                            end
                            
                            -- Close dropdown
                            TweenService:Create(Dropdown, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 40)}):Play()
                            TweenService:Create(DropdownArrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                            open = false
                            
                            -- Update config
                            if flag then
                                configs[flag].Selected = selectedOption
                            end
                            
                            callback(selectedOption)
                        end)
                    end
                end
                
                return DropdownAPI
            end
            
            -- Create button
            function SectionAPI:CreateButton(buttonInfo)
                local name = buttonInfo.Name
                local callback = buttonInfo.Callback or function() end
                
                local Button = Instance.new("TextButton")
                Button.Name = name .. "Button"
                Button.BackgroundColor3 = colors.tertiary
                Button.BorderSizePixel = 0
                Button.Size = UDim2.new(1, 0, 0, 40)
                Button.Font = Enum.Font.GothamBold
                Button.Text = name
                Button.TextColor3 = colors.text
                Button.TextSize = 14
                Button.AutoButtonColor = false
                Button.Parent = SectionContent
                
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 6)
                ButtonCorner.Parent = Button
                
                -- Button effects
                Button.MouseButton1Down:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = colors.accent}):Play()
                end)
                
                Button.MouseButton1Up:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = colors.tertiary}):Play()
                end)
                
                Button.MouseLeave:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = colors.tertiary}):Play()
                end)
                
                -- Button functionality
                Button.MouseButton1Click:Connect(function()
                    callback()
                end)
                
                -- Button API
                local ButtonAPI = {}
                
                function ButtonAPI:Fire()
                    callback()
                end
                
                function ButtonAPI:SetCallback(newCallback)
                    callback = newCallback
                end
                
                function ButtonAPI:SetKeybind(key)
                    local KeybindButton = Instance.new("TextButton")
                    KeybindButton.Name = "KeybindButton"
                    KeybindButton.BackgroundColor3 = colors.background
                    KeybindButton.BorderSizePixel = 0
                    KeybindButton.Position = UDim2.new(1, -95, 0.5, -10)
                    KeybindButton.Size = UDim2.new(0, 80, 0, 20)
                    KeybindButton.Font = Enum.Font.Gotham
                    KeybindButton.Text = key
                    KeybindButton.TextColor3 = colors.subText
                    KeybindButton.TextSize = 12
                    KeybindButton.AutoButtonColor = false
                    KeybindButton.Parent = Button
                    
                    local KeybindCorner = Instance.new("UICorner")
                    KeybindCorner.CornerRadius = UDim.new(0, 4)
                    KeybindCorner.Parent = KeybindButton
                    
                    keybinds[name] = {
                        Name = name,
                        Key = Enum.KeyCode[key],
                        Callback = callback
                    }
                    
                    -- Add to mobile menu if on mobile
                    if isMobile then
                        local mobileBindButton = Instance.new("TextButton")
                        mobileBindButton.Name = name
                        mobileBindButton.BackgroundColor3 = colors.tertiary
                        mobileBindButton.BorderSizePixel = 0
                        mobileBindButton.Size = UDim2.new(1, -20, 0, 40)
                        mobileBindButton.Font = Enum.Font.Gotham
                        mobileBindButton.Text = name
                        mobileBindButton.TextColor3 = colors.text
                        mobileBindButton.TextSize = 14
                        mobileBindButton.ZIndex = 15
                        mobileBindButton.Parent = MobileBindScroll
                        
                        local mobileBindButtonCorner = Instance.new("UICorner")
                        mobileBindButtonCorner.CornerRadius = UDim.new(0, 4)
                        mobileBindButtonCorner.Parent = mobileBindButton
                        
                        mobileBindButton.MouseButton1Click:Connect(callback)
                    end
                    
                    KeybindButton.MouseButton1Click:Connect(function()
                        setKeybind(KeybindButton, name, callback)
                    end)
                end
                
                return ButtonAPI
            end
            
            -- Create color picker
            function SectionAPI:CreateColorPicker(colorInfo)
                local name = colorInfo.Name
                local default = colorInfo.Default or Color3.fromRGB(255, 255, 255)
                local callback = colorInfo.Callback or function() end
                local flag = colorInfo.Flag
                
                local ColorPicker = Instance.new("Frame")
                ColorPicker.Name = name .. "ColorPicker"
                ColorPicker.BackgroundColor3 = colors.tertiary
                ColorPicker.BorderSizePixel = 0
                ColorPicker.Size = UDim2.new(1, 0, 0, 40)
                ColorPicker.ClipsDescendants = true
                ColorPicker.Parent = SectionContent
                
                local ColorPickerCorner = Instance.new("UICorner")
                ColorPickerCorner.CornerRadius = UDim.new(0, 6)
                ColorPickerCorner.Parent = ColorPicker
                
                local ColorPickerName = Instance.new("TextLabel")
                ColorPickerName.Name = "ColorPickerName"
                ColorPickerName.BackgroundTransparency = 1
                ColorPickerName.Position = UDim2.new(0, 15, 0, 0)
                ColorPickerName.Size = UDim2.new(1, -70, 0, 40)
                ColorPickerName.Font = Enum.Font.Gotham
                ColorPickerName.Text = name
                ColorPickerName.TextColor3 = colors.text
                ColorPickerName.TextSize = 14
                ColorPickerName.TextXAlignment = Enum.TextXAlignment.Left
                ColorPickerName.Parent = ColorPicker
                
                local Preview = Instance.new("Frame")
                Preview.Name = "Preview"
                Preview.BackgroundColor3 = default
                Preview.BorderSizePixel = 0
                Preview.Position = UDim2.new(1, -50, 0.5, -10)
                Preview.Size = UDim2.new(0, 40, 0, 20)
                Preview.Parent = ColorPicker
                
                local PreviewCorner = Instance.new("UICorner")
                PreviewCorner.CornerRadius = UDim.new(0, 4)
                PreviewCorner.Parent = Preview
                
                -- Color picker functionality
                local selectedColor = default
                local expanded = false
                
                -- Update config
                if flag then
                    configs[flag] = {
                        Type = "ColorPicker",
                        Color = {
                            math.floor(default.R * 255),
                            math.floor(default.G * 255),
                            math.floor(default.B * 255)
                        },
                        Object = ColorPicker
                    }
                end
                
                -- Toggle color picker
                local ColorPickerExpanded = Instance.new("Frame")
                ColorPickerExpanded.Name = "ColorPickerExpanded"
                ColorPickerExpanded.BackgroundColor3 = colors.background
                ColorPickerExpanded.BorderSizePixel = 0
                ColorPickerExpanded.Position = UDim2.new(0, 0, 0, 40)
                ColorPickerExpanded.Size = UDim2.new(1, 0, 0, 120)
                ColorPickerExpanded.Visible = false
                ColorPickerExpanded.Parent = ColorPicker
                
                local ColorPickerExpandedCorner = Instance.new("UICorner")
                ColorPickerExpandedCorner.CornerRadius = UDim.new(0, 6)
                ColorPickerExpandedCorner.Parent = ColorPickerExpanded
                
                -- Placeholder for color picker UI (simplified for this example)
                local ColorPickerPlaceholder = Instance.new("TextLabel")
                ColorPickerPlaceholder.Name = "ColorPickerPlaceholder"
                ColorPickerPlaceholder.BackgroundTransparency = 1
                ColorPickerPlaceholder.Position = UDim2.new(0, 0, 0, 0)
                ColorPickerPlaceholder.Size = UDim2.new(1, 0, 1, 0)
                ColorPickerPlaceholder.Font = Enum.Font.Gotham
                ColorPickerPlaceholder.Text = "Color Picker Interface"
                ColorPickerPlaceholder.TextColor3 = colors.subText
                ColorPickerPlaceholder.TextSize = 14
                ColorPickerPlaceholder.Parent = ColorPickerExpanded
                
                -- Toggle expanded view
                Preview.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        expanded = not expanded
                        
                        if expanded then
                            ColorPicker.Size = UDim2.new(1, 0, 0, 160)
                            ColorPickerExpanded.Visible = true
                        else
                            ColorPicker.Size = UDim2.new(1, 0, 0, 40)
                            ColorPickerExpanded.Visible = false
                        end
                    end
                end)
                
                -- Simplified color picker API
                local ColorPickerAPI = {}
                
                function ColorPickerAPI:Set(color)
                    selectedColor = color
                    Preview.BackgroundColor3 = color
                    
                    -- Update config
                    if flag then
                        configs[flag].Color = {
                            math.floor(color.R * 255),
                            math.floor(color.G * 255),
                            math.floor(color.B * 255)
                        }
                    end
                    
                    callback(color)
                end
                
                function ColorPickerAPI:Get()
                    return selectedColor
                end
                
                return ColorPickerAPI
            end
            
            -- Create textbox
            function SectionAPI:CreateTextbox(textboxInfo)
                local name = textboxInfo.Name
                local default = textboxInfo.Default or ""
                local placeholder = textboxInfo.Placeholder or "Enter text..."
                local callback = textboxInfo.Callback or function() end
                local flag = textboxInfo.Flag
                
                local Textbox = Instance.new("Frame")
                Textbox.Name = name .. "Textbox"
                Textbox.BackgroundColor3 = colors.tertiary
                Textbox.BorderSizePixel = 0
                Textbox.Size = UDim2.new(1, 0, 0, 40)
                Textbox.Parent = SectionContent
                
                local TextboxCorner = Instance.new("UICorner")
                TextboxCorner.CornerRadius = UDim.new(0, 6)
                TextboxCorner.Parent = Textbox
                
                local TextboxName = Instance.new("TextLabel")
                TextboxName.Name = "TextboxName"
                TextboxName.BackgroundTransparency = 1
                TextboxName.Position = UDim2.new(0, 15, 0, 0)
                TextboxName.Size = UDim2.new(0.5, -20, 1, 0)
                TextboxName.Font = Enum.Font.Gotham
                TextboxName.Text = name
                TextboxName.TextColor3 = colors.text
                TextboxName.TextSize = 14
                TextboxName.TextXAlignment = Enum.TextXAlignment.Left
                TextboxName.Parent = Textbox
                
                local TextboxInput = Instance.new("TextBox")
                TextboxInput.Name = "TextboxInput"
                TextboxInput.BackgroundColor3 = colors.background
                TextboxInput.BorderSizePixel = 0
                TextboxInput.Position = UDim2.new(0.5, 5, 0.5, -15)
                TextboxInput.Size = UDim2.new(0.5, -20, 0, 30)
                TextboxInput.Font = Enum.Font.Gotham
                TextboxInput.Text = default
                TextboxInput.PlaceholderText = placeholder
                TextboxInput.TextColor3 = colors.text
                TextboxInput.PlaceholderColor3 = colors.subText
                TextboxInput.TextSize = 14
                TextboxInput.Parent = Textbox
                
                local TextboxInputCorner = Instance.new("UICorner")
                TextboxInputCorner.CornerRadius = UDim.new(0, 4)
                TextboxInputCorner.Parent = TextboxInput
                
                -- Textbox functionality
                local text = default
                
                -- Update config
                if flag then
                    configs[flag] = {
                        Type = "Textbox",
                        Value = text,
                        Object = Textbox
                    }
                end
                
                TextboxInput.FocusLost:Connect(function(enterPressed)
                    text = TextboxInput.Text
                    
                    -- Update config
                    if flag then
                        configs[flag].Value = text
                    end
                    
                    callback(text, enterPressed)
                end)
                
                -- Textbox API
                local TextboxAPI = {}
                
                function TextboxAPI:Set(value)
                    text = value
                    TextboxInput.Text = value
                    
                    -- Update config
                    if flag then
                        configs[flag].Value = text
                    end
                    
                    callback(text, false)
                end
                
                function TextboxAPI:Get()
                    return text
                end
                
                return TextboxAPI
            end
            
            -- Create label
            function SectionAPI:CreateLabel(labelInfo)
                local text = labelInfo.Text or "Label"
                local color = labelInfo.Color or colors.text
                
                local Label = Instance.new("Frame")
                Label.Name = "Label"
                Label.BackgroundColor3 = colors.tertiary
                Label.BorderSizePixel = 0
                Label.Size = UDim2.new(1, 0, 0, 30)
                Label.Parent = SectionContent
                
                local LabelCorner = Instance.new("UICorner")
                LabelCorner.CornerRadius = UDim.new(0, 6)
                LabelCorner.Parent = Label
                
                local LabelText = Instance.new("TextLabel")
                LabelText.Name = "LabelText"
                LabelText.BackgroundTransparency = 1
                LabelText.Position = UDim2.new(0, 15, 0, 0)
                LabelText.Size = UDim2.new(1, -30, 1, 0)
                LabelText.Font = Enum.Font.Gotham
                LabelText.Text = text
                LabelText.TextColor3 = color
                LabelText.TextSize = 14
                LabelText.TextXAlignment = Enum.TextXAlignment.Left
                LabelText.Parent = Label
                
                -- Label API
                local LabelAPI = {}
                
                function LabelAPI:Set(newText, newColor)
                    LabelText.Text = newText
                    if newColor then
                        LabelText.TextColor3 = newColor
                    end
                end
                
                return LabelAPI
            end
            
            -- Create keybind
            function SectionAPI:CreateKeybind(keybindInfo)
                local name = keybindInfo.Name
                local default = keybindInfo.Default
                local callback = keybindInfo.Callback or function() end
                local flag = keybindInfo.Flag
                
                local Keybind = Instance.new("Frame")
                Keybind.Name = name .. "Keybind"
                Keybind.BackgroundColor3 = colors.tertiary
                Keybind.BorderSizePixel = 0
                Keybind.Size = UDim2.new(1, 0, 0, 40)
                Keybind.Parent = SectionContent
                
                local KeybindCorner = Instance.new("UICorner")
                KeybindCorner.CornerRadius = UDim.new(0, 6)
                KeybindCorner.Parent = Keybind
                
                local KeybindName = Instance.new("TextLabel")
                KeybindName.Name = "KeybindName"
                KeybindName.BackgroundTransparency = 1
                KeybindName.Position = UDim2.new(0, 15, 0, 0)
                KeybindName.Size = UDim2.new(1, -125, 1, 0)
                KeybindName.Font = Enum.Font.Gotham
                KeybindName.Text = name
                KeybindName.TextColor3 = colors.text
                KeybindName.TextSize = 14
                KeybindName.TextXAlignment = Enum.TextXAlignment.Left
                KeybindName.Parent = Keybind
                
                local KeybindButton = Instance.new("TextButton")
                KeybindButton.Name = "KeybindButton"
                KeybindButton.BackgroundColor3 = colors.background
                KeybindButton.BorderSizePixel = 0
                KeybindButton.Position = UDim2.new(1, -100, 0.5, -15)
                KeybindButton.Size = UDim2.new(0, 80, 0, 30)
                KeybindButton.Font = Enum.Font.Gotham
                KeybindButton.Text = default and default.Name or "None"
                KeybindButton.TextColor3 = colors.subText
                KeybindButton.TextSize = 14
                KeybindButton.Parent = Keybind
                
                local KeybindButtonCorner = Instance.new("UICorner")
                KeybindButtonCorner.CornerRadius = UDim.new(0, 4)
                KeybindButtonCorner.Parent = KeybindButton
                
                -- Keybind functionality
                local key = default
                
                -- Update config
                if flag then
                    configs[flag] = {
                        Type = "Keybind",
                        Key = key and key.Name or "None",
                        Object = Keybind
                    }
                end
                
                -- Add to keybinds table
                if key then
                    keybinds[name] = {
                        Name = name,
                        Key = key,
                        Callback = callback
                    }
                    
                    -- Add to mobile menu if on mobile
                    if isMobile then
                        local mobileBindButton = Instance.new("TextButton")
                        mobileBindButton.Name = name
                        mobileBindButton.BackgroundColor3 = colors.tertiary
                        mobileBindButton.BorderSizePixel = 0
                        mobileBindButton.Size = UDim2.new(1, -20, 0, 40)
                        mobileBindButton.Font = Enum.Font.Gotham
                        mobileBindButton.Text = name
                        mobileBindButton.TextColor3 = colors.text
                        mobileBindButton.TextSize = 14
                        mobileBindButton.ZIndex = 15
                        mobileBindButton.Parent = MobileBindScroll
                        
                        local mobileBindButtonCorner = Instance.new("UICorner")
                        mobileBindButtonCorner.CornerRadius = UDim.new(0, 4)
                        mobileBindButtonCorner.Parent = mobileBindButton
                        
                        mobileBindButton.MouseButton1Click:Connect(callback)
                    end
                end
                
                KeybindButton.MouseButton1Click:Connect(function()
                    setKeybind(KeybindButton, name, callback)
                end)
                
                -- Keybind API
                local KeybindAPI = {}
                
                function KeybindAPI:Set(newKey)
                    key = newKey
                    KeybindButton.Text = newKey and newKey.Name or "None"
                    
                    -- Update keybinds table
                    if newKey then
                        keybinds[name] = {
                            Name = name,
                            Key = newKey,
                            Callback = callback
                        }
                    else
                        keybinds[name] = nil
                    end
                    
                    -- Update config
                    if flag then
                        configs[flag].Key = newKey and newKey.Name or "None"
                    end
                end
                
                function KeybindAPI:Get()
                    return key
                end
                
                return KeybindAPI
            end
            
            return SectionAPI
        end
        
        return Tab
    end
    
    return RiseLib
end
