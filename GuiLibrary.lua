-- Rise 6.0 Style UI Library for Roblox
-- With mobile support and config saving system

local RiseLib = {}
RiseLib.__index = RiseLib

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Config system
local function ensureFolder(path)
    if not isfolder(path) then
        makefolder(path)
    end
end

local function saveConfig(config, name)
    ensureFolder("Rise-6.0")
    ensureFolder("Rise-6.0/config")
    
    local success, result = pcall(function()
        return HttpService:JSONEncode(config)
    end)
    
    if success then
        writefile("Rise-6.0/config/" .. name .. ".json", result)
        return true
    end
    return false
end

local function loadConfig(name)
    if isfile("Rise-6.0/config/" .. name .. ".json") then
        local success, result = pcall(function()
            return HttpService:JSONDecode(readfile("Rise-6.0/config/" .. name .. ".json"))
        end)
        
        if success then
            return result
        end
    end
    return nil
end

-- Themes
local Themes = {
    Classic = {
        Background = Color3.fromRGB(25, 25, 25),
        Accent = Color3.fromRGB(230, 35, 69),
        LightContrast = Color3.fromRGB(35, 35, 35),
        DarkContrast = Color3.fromRGB(20, 20, 20),
        TextColor = Color3.fromRGB(255, 255, 255),
        Logo = "rbxassetid://8834748103"
    },
    Winter = {
        Background = Color3.fromRGB(20, 30, 45),
        Accent = Color3.fromRGB(95, 165, 228),
        LightContrast = Color3.fromRGB(30, 40, 55),
        DarkContrast = Color3.fromRGB(15, 25, 40),
        TextColor = Color3.fromRGB(255, 255, 255),
        Logo = "rbxassetid://8834748103"
    },
    Halloween = {
        Background = Color3.fromRGB(30, 20, 30),
        Accent = Color3.fromRGB(255, 120, 0),
        LightContrast = Color3.fromRGB(40, 30, 40),
        DarkContrast = Color3.fromRGB(25, 15, 25),
        TextColor = Color3.fromRGB(255, 240, 230),
        Logo = "rbxassetid://8834748103"
    },
    Black = {
        Background = Color3.fromRGB(10, 10, 10),
        Accent = Color3.fromRGB(100, 100, 100),
        LightContrast = Color3.fromRGB(20, 20, 20),
        DarkContrast = Color3.fromRGB(5, 5, 5),
        TextColor = Color3.fromRGB(255, 255, 255),
        Logo = "rbxassetid://8834748103"
    },
    Aesthetic = {
        Background = Color3.fromRGB(35, 25, 45),
        Accent = Color3.fromRGB(190, 90, 255),
        LightContrast = Color3.fromRGB(45, 35, 55),
        DarkContrast = Color3.fromRGB(30, 20, 40),
        TextColor = Color3.fromRGB(255, 240, 255),
        Logo = "rbxassetid://8834748103"
    }
}

-- Utility functions
local function makeDraggable(topbarObject, object)
    local dragging = false
    local dragInput, mousePos, framePos

    topbarObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = object.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    topbarObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            object.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

-- Create main UI
function RiseLib:CreateWindow(title, defaultTheme)
    defaultTheme = defaultTheme or "Classic"
    
    -- Instance creation
    local RiseUI = Instance.new("ScreenGui")
    local Main = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local Shadow = Instance.new("ImageLabel")
    local Topbar = Instance.new("Frame")
    local UICorner_2 = Instance.new("UICorner")
    local Title = Instance.new("TextLabel")
    local ThemeButton = Instance.new("ImageButton")
    local CloseButton = Instance.new("ImageButton")
    local MinimizeButton = Instance.new("ImageButton")
    local TabContainer = Instance.new("Frame")
    local UIListLayout = Instance.new("UIListLayout")
    local UIPadding = Instance.new("UIPadding")
    local ContentContainer = Instance.new("Frame")
    local CategoryContainer = Instance.new("Frame")
    local ModuleContainer = Instance.new("ScrollingFrame")
    local UIListLayout_2 = Instance.new("UIListLayout")
    local UIPadding_2 = Instance.new("UIPadding")
    local Logo = Instance.new("ImageLabel")
    local RiseLogo = Instance.new("TextLabel")
    local Version = Instance.new("TextLabel")
    
    -- Mobile UI elements
    local MobileControls = Instance.new("Frame")
    local MobileMenuButton = Instance.new("ImageButton")
    local MobileThemeButton = Instance.new("ImageButton")
    
    -- Set attributes and properties
    RiseUI.Name = "RiseUI"
    RiseUI.Parent = CoreGui
    RiseUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    RiseUI.DisplayOrder = 999
    
    Main.Name = "Main"
    Main.Parent = RiseUI
    Main.BackgroundColor3 = Themes[defaultTheme].Background
    Main.Position = UDim2.new(0.5, -300, 0.5, -200)
    Main.Size = UDim2.new(0, 600, 0, 400)
    Main.ClipsDescendants = true
    
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = Main
    
    Shadow.Name = "Shadow"
    Shadow.Parent = Main
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.BackgroundTransparency = 1.000
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.ZIndex = -1
    Shadow.Image = "rbxassetid://5028857084"
    Shadow.ImageColor3 = Themes[defaultTheme].Accent
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(24, 24, 276, 276)
    
    Topbar.Name = "Topbar"
    Topbar.Parent = Main
    Topbar.BackgroundColor3 = Themes[defaultTheme].LightContrast
    Topbar.Size = UDim2.new(1, 0, 0, 38)
    
    UICorner_2.CornerRadius = UDim.new(0, 6)
    UICorner_2.Parent = Topbar
    
    Title.Name = "Title"
    Title.Parent = Topbar
    Title.BackgroundTransparency = 1.000
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Font = Enum.Font.GothamSemibold
    Title.Text = title
    Title.TextColor3 = Themes[defaultTheme].TextColor
    Title.TextSize = 14.000
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    ThemeButton.Name = "ThemeButton"
    ThemeButton.Parent = Topbar
    ThemeButton.BackgroundTransparency = 1.000
    ThemeButton.Position = UDim2.new(1, -80, 0, 8)
    ThemeButton.Size = UDim2.new(0, 22, 0, 22)
    ThemeButton.Image = "rbxassetid://7059346373"
    ThemeButton.ImageColor3 = Themes[defaultTheme].TextColor
    
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = Topbar
    CloseButton.BackgroundTransparency = 1.000
    CloseButton.Position = UDim2.new(1, -30, 0, 8)
    CloseButton.Size = UDim2.new(0, 22, 0, 22)
    CloseButton.Image = "rbxassetid://7072725342"
    CloseButton.ImageColor3 = Themes[defaultTheme].TextColor
    
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Parent = Topbar
    MinimizeButton.BackgroundTransparency = 1.000
    MinimizeButton.Position = UDim2.new(1, -55, 0, 8)
    MinimizeButton.Size = UDim2.new(0, 22, 0, 22)
    MinimizeButton.Image = "rbxassetid://7072719338"
    MinimizeButton.ImageColor3 = Themes[defaultTheme].TextColor
    
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = Main
    TabContainer.BackgroundTransparency = 1.000
    TabContainer.Position = UDim2.new(0, 0, 0, 38)
    TabContainer.Size = UDim2.new(0, 125, 1, -38)
    
    UIListLayout.Parent = TabContainer
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)
    
    UIPadding.Parent = TabContainer
    UIPadding.PaddingTop = UDim.new(0, 10)
    
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = Main
    ContentContainer.BackgroundTransparency = 1.000
    ContentContainer.Position = UDim2.new(0, 125, 0, 38)
    ContentContainer.Size = UDim2.new(1, -125, 1, -38)
    
    CategoryContainer.Name = "CategoryContainer"
    CategoryContainer.Parent = ContentContainer
    CategoryContainer.BackgroundColor3 = Themes[defaultTheme].DarkContrast
    CategoryContainer.Size = UDim2.new(1, 0, 0, 36)
    
    ModuleContainer.Name = "ModuleContainer"
    ModuleContainer.Parent = ContentContainer
    ModuleContainer.BackgroundTransparency = 1.000
    ModuleContainer.Position = UDim2.new(0, 0, 0, 36)
    ModuleContainer.Size = UDim2.new(1, 0, 1, -36)
    ModuleContainer.ScrollBarThickness = 3
    ModuleContainer.ScrollBarImageColor3 = Themes[defaultTheme].Accent
    ModuleContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    UIListLayout_2.Parent = ModuleContainer
    UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout_2.Padding = UDim.new(0, 10)
    
    UIPadding_2.Parent = ModuleContainer
    UIPadding_2.PaddingTop = UDim.new(0, 10)
    UIPadding_2.PaddingBottom = UDim.new(0, 10)
    
    Logo.Name = "Logo"
    Logo.Parent = Main
    Logo.BackgroundTransparency = 1.000
    Logo.Position = UDim2.new(0, 10, 1, -65)
    Logo.Size = UDim2.new(0, 25, 0, 25)
    Logo.Image = Themes[defaultTheme].Logo
    Logo.ImageColor3 = Themes[defaultTheme].Accent
    
    RiseLogo.Name = "RiseLogo"
    RiseLogo.Parent = Main
    RiseLogo.BackgroundTransparency = 1.000
    RiseLogo.Position = UDim2.new(0, 40, 1, -65)
    RiseLogo.Size = UDim2.new(0, 80, 0, 25)
    RiseLogo.Font = Enum.Font.GothamBold
    RiseLogo.Text = "RISE"
    RiseLogo.TextColor3 = Themes[defaultTheme].Accent
    RiseLogo.TextSize = 18.000
    RiseLogo.TextXAlignment = Enum.TextXAlignment.Left
    
    Version.Name = "Version"
    Version.Parent = Main
    Version.BackgroundTransparency = 1.000
    Version.Position = UDim2.new(0, 40, 1, -40)
    Version.Size = UDim2.new(0, 80, 0, 20)
    Version.Font = Enum.Font.Gotham
    Version.Text = "v6.0"
    Version.TextColor3 = Themes[defaultTheme].TextColor
    Version.TextSize = 12.000
    Version.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Mobile UI setup
    if isMobile then
        MobileControls.Name = "MobileControls"
        MobileControls.Parent = RiseUI
        MobileControls.BackgroundTransparency = 1
        MobileControls.Position = UDim2.new(1, -90, 1, -90)
        MobileControls.Size = UDim2.new(0, 80, 0, 80)
        
        MobileMenuButton.Name = "MobileMenuButton"
        MobileMenuButton.Parent = MobileControls
        MobileMenuButton.BackgroundColor3 = Themes[defaultTheme].LightContrast
        MobileMenuButton.Position = UDim2.new(0, 0, 0, 0)
        MobileMenuButton.Size = UDim2.new(0, 50, 0, 50)
        MobileMenuButton.Image = "rbxassetid://7059346373"
        MobileMenuButton.ImageColor3 = Themes[defaultTheme].TextColor
        
        local UICorner_Mobile = Instance.new("UICorner")
        UICorner_Mobile.CornerRadius = UDim.new(0, 25)
        UICorner_Mobile.Parent = MobileMenuButton
        
        MobileThemeButton.Name = "MobileThemeButton"
        MobileThemeButton.Parent = MobileControls
        MobileThemeButton.BackgroundColor3 = Themes[defaultTheme].LightContrast
        MobileThemeButton.Position = UDim2.new(1, -50, 0, 0)
        MobileThemeButton.Size = UDim2.new(0, 50, 0, 50)
        MobileThemeButton.Image = "rbxassetid://7059346373"
        MobileThemeButton.ImageColor3 = Themes[defaultTheme].Accent
        
        local UICorner_Mobile2 = Instance.new("UICorner")
        UICorner_Mobile2.CornerRadius = UDim.new(0, 25)
        UICorner_Mobile2.Parent = MobileThemeButton
        
        -- Make UI more touch-friendly
        Main.Size = UDim2.new(0, 500, 0, 350)
        TabContainer.Size = UDim2.new(0, 140, 1, -38)
        ContentContainer.Position = UDim2.new(0, 140, 0, 38)
        ContentContainer.Size = UDim2.new(1, -140, 1, -38)
    end
    
    -- Make UI draggable
    makeDraggable(Topbar, Main)
    
    -- Setup close and minimize buttons
    local minimized = false
    local originalSize = Main.Size
    
    CloseButton.MouseButton1Click:Connect(function()
        RiseUI:Destroy()
    end)
    
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Main.Size = UDim2.new(0, originalSize.X.Offset, 0, 38)
        else
            Main.Size = originalSize
        end
    end)
    
    -- Theme selector functionality
    local function themeSelector()
        local ThemePickerFrame = Instance.new("Frame")
        local UICorner_Theme = Instance.new("UICorner")
        local ThemeList = Instance.new("ScrollingFrame")
        local UIListLayout_Theme = Instance.new("UIListLayout")
        local UIPadding_Theme = Instance.new("UIPadding")
        
        ThemePickerFrame.Name = "ThemePickerFrame"
        ThemePickerFrame.Parent = Main
        ThemePickerFrame.BackgroundColor3 = Themes[defaultTheme].LightContrast
        ThemePickerFrame.Position = UDim2.new(1, -180, 0, 38)
        ThemePickerFrame.Size = UDim2.new(0, 170, 0, 200)
        ThemePickerFrame.ZIndex = 10
        ThemePickerFrame.Visible = false
        
        UICorner_Theme.CornerRadius = UDim.new(0, 6)
        UICorner_Theme.Parent = ThemePickerFrame
        
        ThemeList.Name = "ThemeList"
        ThemeList.Parent = ThemePickerFrame
        ThemeList.BackgroundTransparency = 1.000
        ThemeList.Size = UDim2.new(1, 0, 1, 0)
        ThemeList.ScrollBarThickness = 3
        ThemeList.ScrollBarImageColor3 = Themes[defaultTheme].Accent
        
        UIListLayout_Theme.Parent = ThemeList
        UIListLayout_Theme.HorizontalAlignment = Enum.HorizontalAlignment.Center
        UIListLayout_Theme.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout_Theme.Padding = UDim.new(0, 5)
        
        UIPadding_Theme.Parent = ThemeList
        UIPadding_Theme.PaddingTop = UDim.new(0, 10)
        UIPadding_Theme.PaddingBottom = UDim.new(0, 10)
        
        -- Add theme options
        for themeName, _ in pairs(Themes) do
            local ThemeOption = Instance.new("TextButton")
            local ThemeColor = Instance.new("Frame")
            local UICorner_Color = Instance.new("UICorner")
            
            ThemeOption.Name = themeName
            ThemeOption.Parent = ThemeList
            ThemeOption.BackgroundTransparency = 1.000
            ThemeOption.Size = UDim2.new(0.9, 0, 0, 30)
            ThemeOption.Font = Enum.Font.Gotham
            ThemeOption.Text = "  " .. themeName
            ThemeOption.TextColor3 = Themes[defaultTheme].TextColor
            ThemeOption.TextSize = 14.000
            ThemeOption.TextXAlignment = Enum.TextXAlignment.Left
            
            ThemeColor.Name = "ThemeColor"
            ThemeColor.Parent = ThemeOption
            ThemeColor.BackgroundColor3 = Themes[themeName].Accent
            ThemeColor.Position = UDim2.new(1, -30, 0.5, -10)
            ThemeColor.Size = UDim2.new(0, 20, 0, 20)
            
            UICorner_Color.CornerRadius = UDim.new(0, 4)
            UICorner_Color.Parent = ThemeColor
            
            ThemeOption.MouseButton1Click:Connect(function()
                self:ChangeTheme(themeName)
                ThemePickerFrame.Visible = false
            end)
        end
        
        -- Update canvas size
        ThemeList.CanvasSize = UDim2.new(0, 0, 0, UIListLayout_Theme.AbsoluteContentSize.Y + 20)
        
        return ThemePickerFrame
    end
    
    local themeFrame = themeSelector()
    
    ThemeButton.MouseButton1Click:Connect(function()
        themeFrame.Visible = not themeFrame.Visible
    end)
    
    if isMobile then
        MobileThemeButton.MouseButton1Click:Connect(function()
            themeFrame.Visible = not themeFrame.Visible
        end)
    end
    
    -- Initialize window
    local window = {}
    window.Tabs = {}
    window.ActiveTab = nil
    window.ThemeObjects = {
        Main = Main,
        Shadow = Shadow,
        Topbar = Topbar,
        Title = Title,
        ThemeButton = ThemeButton,
        CloseButton = CloseButton,
        MinimizeButton = MinimizeButton,
        CategoryContainer = CategoryContainer,
        ModuleContainer = ModuleContainer,
        Logo = Logo,
        RiseLogo = RiseLogo,
        Version = Version,
        ThemeFrame = themeFrame
    }
    
    if isMobile then
        window.ThemeObjects.MobileMenuButton = MobileMenuButton
        window.ThemeObjects.MobileThemeButton = MobileThemeButton
    end
    
    -- Load configuration if it exists
    local config = loadConfig("uisettings")
    if config and config.Theme then
        self:ChangeTheme(config.Theme, window)
    else
        self.CurrentTheme = defaultTheme
    end
    
    -- Add tab functionality
    function window:AddTab(name, icon)
        local tabButton = Instance.new("TextButton")
        local UICorner_Tab = Instance.new("UICorner")
        local TabIcon = Instance.new("ImageLabel")
        local TabName = Instance.new("TextLabel")
        
        tabButton.Name = name
        tabButton.Parent = TabContainer
        tabButton.BackgroundColor3 = self.ActiveTab == nil and Themes[RiseLib.CurrentTheme].Accent or Themes[RiseLib.CurrentTheme].LightContrast
        tabButton.Size = UDim2.new(0.9, 0, 0, 32)
        tabButton.Font = Enum.Font.Gotham
        tabButton.Text = ""
        tabButton.TextColor3 = Themes[RiseLib.CurrentTheme].TextColor
        tabButton.TextSize = 14.000
        
        UICorner_Tab.CornerRadius = UDim.new(0, 4)
        UICorner_Tab.Parent = tabButton
        
        TabIcon.Name = "TabIcon"
        TabIcon.Parent = tabButton
        TabIcon.BackgroundTransparency = 1.000
        TabIcon.Position = UDim2.new(0, 8, 0.5, -8)
        TabIcon.Size = UDim2.new(0, 16, 0, 16)
        TabIcon.Image = icon or "rbxassetid://7072706318"
        TabIcon.ImageColor3 = Themes[RiseLib.CurrentTheme].TextColor
        
        TabName.Name = "TabName"
        TabName.Parent = tabButton
        TabName.BackgroundTransparency = 1.000
        TabName.Position = UDim2.new(0, 32, 0, 0)
        TabName.Size = UDim2.new(1, -40, 1, 0)
        TabName.Font = Enum.Font.Gotham
        TabName.Text = name
        TabName.TextColor3 = Themes[RiseLib.CurrentTheme].TextColor
        TabName.TextSize = 14.000
        TabName.TextXAlignment = Enum.TextXAlignment.Left
        
        -- Create content frame for this tab
        local tabContent = Instance.new("Frame")
        tabContent.Name = name.."Content"
        tabContent.Parent = ContentContainer
        tabContent.BackgroundTransparency = 1.000
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.Visible = self.ActiveTab == nil
        
        -- Create category frame for this tab
        local categoryFrame = Instance.new("Frame")
        categoryFrame.Name = "CategoryFrame"
        categoryFrame.Parent = tabContent
        categoryFrame.BackgroundColor3 = Themes[RiseLib.CurrentTheme].DarkContrast
        categoryFrame.Size = UDim2.new(1, 0, 0, 36)
        
        local categoryLayout = Instance.new("UIListLayout")
        categoryLayout.Parent = categoryFrame
        categoryLayout.FillDirection = Enum.FillDirection.Horizontal
        categoryLayout.SortOrder = Enum.SortOrder.LayoutOrder
        categoryLayout.Padding = UDim.new(0, 5)
        
        local categoryPadding = Instance.new("UIPadding")
        categoryPadding.Parent = categoryFrame
        categoryPadding.PaddingLeft = UDim.new(0, 10)
        
        -- Create module container for this tab
        local moduleFrame = Instance.new("ScrollingFrame")
        moduleFrame.Name = "ModuleFrame"
        moduleFrame.Parent = tabContent
        moduleFrame.BackgroundTransparency = 1.000
        moduleFrame.Position = UDim2.new(0, 0, 0, 36)
        moduleFrame.Size = UDim2.new(1, 0, 1, -36)
        moduleFrame.ScrollBarThickness = 3
        moduleFrame.ScrollBarImageColor3 = Themes[RiseLib.CurrentTheme].Accent
        moduleFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        
        local moduleLayout = Instance.new("UIListLayout")
        moduleLayout.Parent = moduleFrame
        moduleLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        moduleLayout.SortOrder = Enum.SortOrder.LayoutOrder
        moduleLayout.Padding = UDim.new(0, 10)
        
        local modulePadding = Instance.new("UIPadding")
        modulePadding.Parent = moduleFrame
        modulePadding.PaddingTop = UDim.new(0, 10)
        modulePadding.PaddingBottom = UDim.new(0, 10)
        
        -- Initialize new tab
        local tab = {}
        tab.Button = tabButton
        tab.Content = tabContent
        tab.CategoryFrame = categoryFrame
        tab.ModuleFrame = moduleFrame
        tab.Categories = {}
        tab.Name = name
        
        -- Add to window tabs
        self.Tabs[name] = tab
        
        -- Auto-adjust content container
        moduleLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            moduleFrame.CanvasSize = UDim2.new(0, 0, 0, moduleLayout.AbsoluteContentSize.Y + 20)
        end)
        
        -- Set as active tab if it's the first one
        if self.ActiveTab == nil then
            self.ActiveTab = tab
        end
        
        -- Handle tab switching
        tabButton.MouseButton1Click:Connect(function()
            if self.ActiveTab ~= tab then
                -- Update appearance
                self.ActiveTab.Button.BackgroundColor3 = Themes[RiseLib.CurrentTheme].LightContrast
                self.ActiveTab.Content.Visible = false
                
                tab.Button.BackgroundColor3 = Themes[RiseLib.CurrentTheme].Accent
                tab.Content.Visible = true
                
                self.ActiveTab = tab
            end
        end)
        
        -- Add category functionality
        function tab:AddCategory(categoryName)
            local categoryButton = Instance.new("TextButton")
            
            categoryButton.Name = categoryName
            categoryButton.Parent = self.CategoryFrame
            categoryButton.BackgroundTransparency = 1.000
            categoryButton.Size = UDim2.new(0, 100, 1, 0)
            categoryButton.Font = Enum.Font.GothamSemibold
            categoryButton.Text = categoryName
            categoryButton.TextColor3 = #self.Categories == 0 and Themes[RiseLib.CurrentTheme].Accent or Themes[RiseLib.CurrentTheme].TextColor
            categoryButton.TextSize = 14.000
            
            -- Create module container for this category
            local categoryModules = Instance.new("Frame")
            categoryModules.Name = categoryName.."Modules"
            categoryModules.Parent = self.ModuleFrame
            categoryModules.BackgroundTransparency = 1.000
            categoryModules.Size = UDim2.new(0.95, 0, 0, 0)
            categoryModules.AutomaticSize = Enum.AutomaticSize.Y
            categoryModules.Visible = #self.Categories == 0
            
            local categoryModuleLayout = Instance.new("UIListLayout")
            categoryModuleLayout.Parent = categoryModules
            categoryModuleLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            categoryModuleLayout.SortOrder = Enum.SortOrder.LayoutOrder
            categoryModuleLayout.Padding = UDim.new(0, 8)
            
            -- Initialize new category
            local category = {}
            category.Button = categoryButton
            category.ModuleContainer = categoryModules
            category.Name = categoryName
            category.Modules = {}
            
            -- Add to tab categories
            self.Categories[categoryName] = category
            
            -- Handle category switching
            categoryButton.MouseButton1Click:Connect(function()
                for _, cat in pairs(self.Categories) do
                    cat.Button.TextColor3 = Themes[RiseLib.CurrentTheme].TextColor
                    cat.ModuleContainer.Visible = false
                end
                
                categoryButton.TextColor3 = Themes[RiseLib.CurrentTheme].Accent
                categoryModules.Visible = true
            end)
            
            -- Module functions
            function category:AddToggle(name, default, callback)
                default = default or false
                callback = callback or function() end
                
                local toggleModule = Instance.new("Frame")
                local toggleName = Instance.new("TextLabel")
                local toggleButton = Instance.new("TextButton")
                local UICorner_Toggle = Instance.new("UICorner")
                local toggleCircle = Instance.new("Frame")
                local UICorner_Circle = Instance.new("UICorner")
                
                toggleModule.Name = name
                toggleModule.Parent = self.ModuleContainer
                toggleModule.BackgroundColor3 = Themes[RiseLib.CurrentTheme].LightContrast
                toggleModule.Size = UDim2.new(1, 0, 0, 40)
                
                local UICorner_Module = Instance.new("UICorner")
                UICorner_Module.CornerRadius = UDim.new(0, 4)
                UICorner_Module.Parent = toggleModule
                
                toggleName.Name = "ToggleName"
                toggleName.Parent = toggleModule
                toggleName.BackgroundTransparency = 1.000
                toggleName.Position = UDim2.new(0, 12, 0, 0)
                toggleName.Size = UDim2.new(1, -80, 1, 0)
                toggleName.Font = Enum.Font.Gotham
                toggleName.Text = name
                toggleName.TextColor3 = Themes[RiseLib.CurrentTheme].TextColor
                toggleName.TextSize = 14.000
                toggleName.TextXAlignment = Enum.TextXAlignment.Left
                
                toggleButton.Name = "ToggleButton"
                toggleButton.Parent = toggleModule
                toggleButton.BackgroundColor3 = default and Themes[RiseLib.CurrentTheme].Accent or Themes[RiseLib.CurrentTheme].DarkContrast
                toggleButton.Position = UDim2.new(1, -60, 0.5, -10)
                toggleButton.Size = UDim2.new(0, 50, 0, 20)
                toggleButton.Font = Enum.Font.SourceSans
                toggleButton.Text = ""
                toggleButton.TextColor3 = Themes[RiseLib.CurrentTheme].TextColor
                toggleButton.TextSize = 14.000
                
                UICorner_Toggle.CornerRadius = UDim.new(0, 10)
                UICorner_Toggle.Parent = toggleButton
                
                toggleCircle.Name = "ToggleCircle"
                toggleCircle.Parent = toggleButton
                toggleCircle.BackgroundColor3 = Themes[RiseLib.CurrentTheme].TextColor
                toggleCircle.Position = default and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
                toggleCircle.Size = UDim2.new(0, 12, 0, 12)
                
                UICorner_Circle.CornerRadius = UDim.new(1, 0)
                UICorner_Circle.Parent = toggleCircle
                
                local toggle = {
                    Type = "Toggle",
                    Name = name,
                    Value = default,
                    Callback = callback,
                    Instance = toggleModule,
                    Button = toggleButton,
                    Circle = toggleCircle
                }
                
                -- Handle toggle functionality
                toggleButton.MouseButton1Click:Connect(function()
                    toggle.Value = not toggle.Value
                    
                    -- Animation
                    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    local targetPosition = toggle.Value and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
                    local targetColor = toggle.Value and Themes[RiseLib.CurrentTheme].Accent or Themes[RiseLib.CurrentTheme].DarkContrast
                    
                    TweenService:Create(toggleCircle, tweenInfo, {Position = targetPosition}):Play()
                    TweenService:Create(toggleButton, tweenInfo, {BackgroundColor3 = targetColor}):Play()
                    
                    callback(toggle.Value)
                end)
                
                -- Add to category modules
                table.insert(self.Modules, toggle)
                return toggle
            end
            
            function category:AddSlider(name, options, callback)
                options = options or {}
                options.min = options.min or 0
                options.max = options.max or 100
                options.default = options.default or (options.min + options.max) / 2
                options.increment = options.increment or 1
                callback = callback or function() end
                
                local sliderModule = Instance.new("Frame")
                local sliderName = Instance.new("TextLabel")
                local sliderValueDisplay = Instance.new("TextLabel")
                local sliderContainer = Instance.new("Frame")
                local UICorner_SliderContainer = Instance.new("UICorner")
                local sliderFill = Instance.new("Frame")
                local UICorner_SliderFill = Instance.new("UICorner")
                local sliderDrag = Instance.new("TextButton")
                
                sliderModule.Name = name
                sliderModule.Parent = self.ModuleContainer
                sliderModule.BackgroundColor3 = Themes[RiseLib.CurrentTheme].LightContrast
                sliderModule.Size = UDim2.new(1, 0, 0, 60)
                
                local UICorner_Module = Instance.new("UICorner")
                UICorner_Module.CornerRadius = UDim.new(0, 4)
                UICorner_Module.Parent = sliderModule
                
                sliderName.Name = "SliderName"
                sliderName.Parent = sliderModule
                sliderName.BackgroundTransparency = 1.000
                sliderName.Position = UDim2.new(0, 12, 0, 5)
                sliderName.Size = UDim2.new(1, -80, 0, 25)
                sliderName.Font = Enum.Font.Gotham
                sliderName.Text = name
                sliderName.TextColor3 = Themes[RiseLib.CurrentTheme].TextColor
                sliderName.TextSize = 14.000
                sliderName.TextXAlignment = Enum.TextXAlignment.Left
                
                sliderValueDisplay.Name = "SliderValue"
                sliderValueDisplay.Parent = sliderModule
                sliderValueDisplay.BackgroundTransparency = 1.000
                sliderValueDisplay.Position = UDim2.new(1, -70, 0, 5)
                sliderValueDisplay.Size = UDim2.new(0, 60, 0, 25)
                sliderValueDisplay.Font = Enum.Font.Gotham
                sliderValueDisplay.Text = tostring(options.default)
                sliderValueDisplay.TextColor3 = Themes[RiseLib.CurrentTheme].TextColor
                sliderValueDisplay.TextSize = 14.000
                sliderValueDisplay.TextXAlignment = Enum.TextXAlignment.Right
                
                sliderContainer.Name = "SliderContainer"
                sliderContainer.Parent = sliderModule
                sliderContainer.BackgroundColor3 = Themes[RiseLib.CurrentTheme].DarkContrast
                sliderContainer.Position = UDim2.new(0, 12, 0, 35)
                sliderContainer.Size = UDim2.new(1, -24, 0, 10)
                
                UICorner_SliderContainer.CornerRadius = UDim.new(0, 5)
                UICorner_SliderContainer.Parent = sliderContainer
                
                sliderFill.Name = "SliderFill"
                sliderFill.Parent = sliderContainer
                sliderFill.BackgroundColor3 = Themes[RiseLib.CurrentTheme].Accent
                sliderFill.Size = UDim2.new((options.default - options.min) / (options.max - options.min), 0, 1, 0)
                
                UICorner_SliderFill.CornerRadius = UDim.new(0, 5)
                UICorner_SliderFill.Parent = sliderFill
                
                sliderDrag.Name = "SliderDrag"
                sliderDrag.Parent = sliderModule
                sliderDrag.BackgroundTransparency = 1.000
                sliderDrag.Position = UDim2.new(0, 12, 0, 35)
                sliderDrag.Size = UDim2.new(1, -24, 0, 10)
                sliderDrag.Font = Enum.Font.SourceSans
                sliderDrag.Text = ""
                sliderDrag.TextColor3 = Themes[RiseLib.CurrentTheme].TextColor
                sliderDrag.TextSize = 14.000
                
                local slider = {
                    Type = "Slider",
                    Name = name,
                    Value = options.default,
                    Min = options.min,
                    Max = options.max,
                    Increment = options.increment,
                    Callback = callback,
                    Instance = sliderModule,
                    Fill = sliderFill,
                    Display = sliderValueDisplay
                }
                
                -- Handle slider functionality
                local function updateSlider(input)
                    local pos = UDim2.new(math.clamp((input.Position.X - sliderContainer.AbsolutePosition.X) / sliderContainer.AbsoluteSize.X, 0, 1), 0, 1, 0)
                    sliderFill.Size = pos
                    
                    local value = math.floor((pos.X.Scale * (options.max - options.min) + options.min) / options.increment + 0.5) * options.increment
                    value = math.clamp(value, options.min, options.max)
                    
                    sliderValueDisplay.Text = tostring(value)
                    slider.Value = value
                    callback(value)
                end
                
                sliderDrag.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        updateSlider(input)
                    end
                end)
                
                sliderDrag.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        updateSlider(input)
                    end
                end)
                
                -- Add to category modules
                table.insert(self.Modules, slider)
                return slider
            end
            
            function category:AddDropdown(name, options, callback)
                options = options or {}
                options.items = options.items or {}
                options.default = options.default or options.items[1] or ""
                callback = callback or function() end
                
                local dropdownModule = Instance.new("Frame")
                local dropdownName = Instance.new("TextLabel")
                local dropdownButton = Instance.new("TextButton")
                local UICorner_Dropdown = Instance.new("UICorner")
                local dropdownArrow = Instance.new("ImageLabel")
                local dropdownSelection = Instance.new("TextLabel")
                local dropdownContainer = Instance.new("Frame")
                local UICorner_Container = Instance.new("UICorner")
                local dropdownItemLayout = Instance.new("UIListLayout")
                
                dropdownModule.Name = name
                dropdownModule.Parent = self.ModuleContainer
                dropdownModule.BackgroundColor3 = Themes[RiseLib.CurrentTheme].LightContrast
                dropdownModule.Size = UDim2.new(1, 0, 0, 40)
                
                local UICorner_Module = Instance.new("UICorner")
                UICorner_Module.CornerRadius = UDim.new(0, 4)
                UICorner_Module.Parent = dropdownModule
                
                dropdownName.Name = "DropdownName"
                dropdownName.Parent = dropdownModule
                dropdownName.BackgroundTransparency = 1.000
                dropdownName.Position = UDim2.new(0, 12, 0, 0)
                dropdownName.Size = UDim2.new(0, 100, 1, 0)
                dropdownName.Font = Enum.Font.Gotham
                dropdownName.Text = name
                dropdownName.TextColor3 = Themes[RiseLib.CurrentTheme].TextColor
                dropdownName.TextSize = 14.000
                dropdownName.TextXAlignment = Enum.TextXAlignment.Left
                
                dropdownButton.Name = "DropdownButton"
                dropdownButton.Parent = dropdownModule
                dropdownButton.BackgroundColor3 = Themes[RiseLib.CurrentTheme].DarkContrast
                dropdownButton.Position = UDim2.new(1, -170, 0.5, -15)
                dropdownButton.Size = UDim2.new(0, 160, 0, 30)
                dropdownButton.Font = Enum.Font.SourceSans
                dropdownButton.Text = ""
                dropdownButton.TextColor3 = Themes[RiseLib.CurrentTheme].TextColor
                dropdownButton.TextSize = 14.000
                
                UICorner_Dropdown.CornerRadius = UDim.new(0, 4)
                UICorner_Dropdown.Parent = dropdownButton
                
                dropdownArrow.Name = "DropdownArrow"
                dropdownArrow.Parent = dropdownButton
                dropdownArrow.BackgroundTransparency = 1.000
                dropdownArrow.Position = UDim2.new(1, -20, 0.5, -6)
                dropdownArrow.Size = UDim2.new(0, 12, 0, 12)
                dropdownArrow.Image = "rbxassetid://7072706318"
                dropdownArrow.ImageColor3 = Themes[RiseLib.CurrentTheme].TextColor
                dropdownArrow.Rotation = 90
                
                dropdownSelection.Name = "DropdownSelection"
                dropdownSelection.Parent = dropdownButton
                dropdownSelection.BackgroundTransparency = 1.000
                dropdownSelection.Position = UDim2.new(0, 10, 0, 0)
                dropdownSelection.Size = UDim2.new(1, -30, 1, 0)
                dropdownSelection.Font = Enum.Font.Gotham
                dropdownSelection.Text = options.default
                dropdownSelection.TextColor3 = Themes[RiseLib.CurrentTheme].TextColor
                dropdownSelection.TextSize = 14.000
                dropdownSelection.TextXAlignment = Enum.TextXAlignment.Left
                
                dropdownContainer.Name = "DropdownContainer"
                dropdownContainer.Parent = RiseUI
                dropdownContainer.BackgroundColor3 = Themes[RiseLib.CurrentTheme].LightContrast
                dropdownContainer.Position = UDim2.new(0, 0, 0, 0)
                dropdownContainer.Size = UDim2.new(0, 160, 0, 0)
                dropdownContainer.Visible = false
                dropdownContainer.ZIndex = 100
                dropdownContainer.ClipsDescendants = true
                
                UICorner_Container.CornerRadius = UDim.new(0, 4)
                UICorner_Container.Parent = dropdownContainer
                
                dropdownItemLayout.Parent = dropdownContainer
                dropdownItemLayout.SortOrder = Enum.SortOrder.LayoutOrder
                
                local dropdown = {
                    Type = "Dropdown",
                    Name = name,
                    Value = options.default,
                    Items = options.items,
                    Callback = callback,
                    Instance = dropdownModule,
                    Container = dropdownContainer,
                    Button = dropdownButton,
                    Selection = dropdownSelection,
                    Arrow = dropdownArrow,
                    Open = false
                }
                
                -- Create dropdown items
                for _, item in ipairs(options.items) do
                    local itemButton = Instance.new("TextButton")
                    
                    itemButton.Name = item
                    itemButton.Parent = dropdownContainer
                    itemButton.BackgroundTransparency = 1.000
                    itemButton.Size = UDim2.new(1, 0, 0, 30)
                    itemButton.Font = Enum.Font.Gotham
                    itemButton.Text = item
                    itemButton.TextColor3 = Themes[RiseLib.CurrentTheme].TextColor
                    itemButton.TextSize = 14.000
                    itemButton.ZIndex = 100
                    
                    itemButton.MouseButton1Click:Connect(function()
                        dropdown.Value = item
                        dropdownSelection.Text = item
                        
                        -- Close dropdown
                        TweenService:Create(dropdownContainer, TweenInfo.new(0.2), {Size = UDim2.new(0, 160, 0, 0)}):Play()
                        TweenService:Create(dropdownArrow, TweenInfo.new(0.2), {Rotation = 90}):Play()
                        dropdown.Open = false
                        
                        -- Wait for animation before hiding
                        task.delay(0.2, function()
                            dropdownContainer.Visible = false
                        end)
                        
                        callback(item)
                    end)
                end
                
                -- Handle dropdown open/close
                dropdownButton.MouseButton1Click:Connect(function()
                    dropdown.Open = not dropdown.Open
                    
                    if dropdown.Open then
                        -- Update position before showing
                        local buttonAbsPos = dropdownButton.AbsolutePosition
                        local buttonAbsSize = dropdownButton.AbsoluteSize
                        
                        dropdownContainer.Position = UDim2.new(0, buttonAbsPos.X, 0, buttonAbsPos.Y + buttonAbsSize.Y + 5)
                        dropdownContainer.Size = UDim2.new(0, 160, 0, 0)
                        dropdownContainer.Visible = true
                        
                        -- Animate opening
                        TweenService:Create(dropdownContainer, TweenInfo.new(0.2), {Size = UDim2.new(0, 160, 0, #options.items * 30)}):Play()
                        TweenService:Create(dropdownArrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
                    else
                        -- Animate closing
                        TweenService:Create(dropdownContainer, TweenInfo.new(0.2), {Size = UDim2.new(0, 160, 0, 0)}):Play()
                        TweenService:Create(dropdownArrow, TweenInfo.new(0.2), {Rotation = 90}):Play()
                        
                        -- Wait for animation before hiding
                        task.delay(0.2, function()
                            dropdownContainer.Visible = false
                        end)
                    end
                end)
                
                -- Close dropdown when clicking elsewhere
                UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        if dropdown.Open and not dropdownButton:IsDescendantOf(game) then
                            dropdown.Open = false
                            TweenService:Create(dropdownContainer, TweenInfo.new(0.2), {Size = UDim2.new(0, 160, 0, 0)}):Play()
                            TweenService:Create(dropdownArrow, TweenInfo.new(0.2), {Rotation = 90}):Play()
                            
                            task.delay(0.2, function()
                                dropdownContainer.Visible = false
                            end)
                        end
                    end
                end)
                
                -- Add to category modules
                table.insert(self.Modules, dropdown)
                return dropdown
            end
            
            function category:AddButton(name, callback)
                callback = callback or function() end
                
                local buttonModule = Instance.new("Frame")
                local buttonElement = Instance.new("TextButton")
                local UICorner_Button = Instance.new("UICorner")
                
                buttonModule.Name = name
                buttonModule.Parent = self.ModuleContainer
                buttonModule.BackgroundColor3 = Themes[RiseLib.CurrentTheme].LightContrast
                buttonModule.Size = UDim2.new(1, 0, 0, 40)
                
                local UICorner_Module = Instance.new("UICorner")
                UICorner_Module.CornerRadius = UDim.new(0, 4)
                UICorner_Module.Parent = buttonModule
                
                buttonElement.Name = "ButtonElement"
                buttonElement.Parent = buttonModule
                buttonElement.BackgroundColor3 = Themes[RiseLib.CurrentTheme].DarkContrast
                buttonElement.Position = UDim2.new(0, 10, 0.5, -15)
                buttonElement.Size = UDim2.new(1, -20, 0, 30)
                buttonElement.Font = Enum.Font.GothamSemibold
                buttonElement.Text = name
                buttonElement.TextColor3 = Themes[RiseLib.CurrentTheme].TextColor
                buttonElement.TextSize = 14.000
                
                UICorner_Button.CornerRadius = UDim.new(0, 4)
                UICorner_Button.Parent = buttonElement
                
                local button = {
                    Type = "Button",
                    Name = name,
                    Callback = callback,
                    Instance = buttonModule,
                    Button = buttonElement
                }
                
                -- Handle button click
                buttonElement.MouseButton1Click:Connect(function()
                    callback()
                    
                    -- Button press animation
                    TweenService:Create(buttonElement, TweenInfo.new(0.1), {BackgroundColor3 = Themes[RiseLib.CurrentTheme].Accent}):Play()
                    task.delay(0.1, function()
                        TweenService:Create(buttonElement, TweenInfo.new(0.1), {BackgroundColor3 = Themes[RiseLib.CurrentTheme].DarkContrast}):Play()
                    end)
                end)
                
                -- Add to category modules
                table.insert(self.Modules, button)
                return button
            end
            
            function category:AddKeybind(name, defaultKey, callback)
    defaultKey = defaultKey or "None"
    callback = callback or function() end
    
    local keybindModule = Instance.new("Frame")
    local keybindName = Instance.new("TextLabel")
    local keybindButton = Instance.new("TextButton")
    local UICorner_Keybind = Instance.new("UICorner")
    
    keybindModule.Name = name
    keybindModule.Parent = self.ModuleContainer
    keybindModule.BackgroundColor3 = Themes[RiseLib.CurrentTheme].LightContrast
    keybindModule.Size = UDim2.new(1, 0, 0, 40)
    
    local UICorner_Module = Instance.new("UICorner")
    UICorner_Module.CornerRadius = UDim.new(0, 4)
    UICorner_Module.Parent = keybindModule
    
    keybindName.Name = "KeybindName"
    keybindName.Parent = keybindModule
    keybindName.BackgroundTransparency = 1.000
    keybindName.Position = UDim2.new(0, 12, 0, 0)
    keybindName.Size = UDim2.new(1, -80, 1, 0)
    keybindName.Font = Enum.Font.Gotham
    keybindName.Text = name
    keybindName.TextColor3 = Themes[RiseLib.CurrentTheme].TextColor
    keybindName.TextSize = 14.000
    keybindName.TextXAlignment = Enum.TextXAlignment.Left
    
    keybindButton.Name = "KeybindButton"
    keybindButton.Parent = keybindModule
    keybindButton.BackgroundColor3 = Themes[RiseLib.CurrentTheme].DarkContrast
    keybindButton.Position = UDim2.new(1, -70, 0.5, -15)
    keybindButton.Size = UDim2.new(0, 60, 0, 30)
    keybindButton.Font = Enum.Font.Gotham
    keybindButton.Text = defaultKey
    keybindButton.TextColor3 = Themes[RiseLib.CurrentTheme].TextColor
    keybindButton.TextSize = 14.000
    
    UICorner_Keybind.CornerRadius = UDim.new(0, 4)
    UICorner_Keybind.Parent = keybindButton
    
    local keybind = {
        Type = "Keybind",
        Name = name,
        Key = defaultKey,
        Value = defaultKey ~= "None",
        Listening = false,
        Callback = callback,
        Instance = keybindModule,
        Button = keybindButton,
        FloatingButton = nil,
        ButtonPosition = nil  -- Store the position for saving/loading
    }
    
    -- Mobile floating button functionality
    local function createFloatingButton(position)
        if keybind.FloatingButton then return end
        
        -- Create parent for the floating button that's outside the main UI
        local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
        local floatingButtonsGui = playerGui:FindFirstChild("RiseLibFloatingButtons")
        
        if not floatingButtonsGui then
            floatingButtonsGui = Instance.new("ScreenGui")
            floatingButtonsGui.Name = "RiseLibFloatingButtons"
            floatingButtonsGui.ResetOnSpawn = false
            floatingButtonsGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            floatingButtonsGui.Parent = playerGui
        end
        
        -- Use provided position or default
        local defaultPosition = UDim2.new(0.8, 0, 0.5, 0)
        local buttonPosition = position or defaultPosition
        
        -- Create the floating button
        local floatingButton = Instance.new("Frame")
        floatingButton.Name = "FloatingButton_" .. name
        floatingButton.Size = UDim2.new(0, 50, 0, 50)
        floatingButton.Position = buttonPosition
        floatingButton.BackgroundColor3 = Themes[RiseLib.CurrentTheme].Accent
        floatingButton.BackgroundTransparency = 0.3
        floatingButton.Parent = floatingButtonsGui
        
        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = UDim.new(1, 0) -- Makes it perfectly round
        uiCorner.Parent = floatingButton
        
        local buttonLabel = Instance.new("TextLabel")
        buttonLabel.Name = "Label"
        buttonLabel.BackgroundTransparency = 1
        buttonLabel.Size = UDim2.new(1, 0, 1, 0)
        buttonLabel.Font = Enum.Font.GothamBold
        buttonLabel.TextColor3 = Color3.new(1, 1, 1)
        buttonLabel.TextSize = 16
        buttonLabel.Text = string.sub(name, 1, 3) -- First 3 characters of name
        buttonLabel.Parent = floatingButton
        
        local activeIndicator = Instance.new("Frame")
        activeIndicator.Name = "ActiveIndicator"
        activeIndicator.Size = UDim2.new(0.8, 0, 0.8, 0)
        activeIndicator.Position = UDim2.new(0.1, 0, 0.1, 0)
        activeIndicator.BackgroundColor3 = Color3.new(1, 1, 1)
        activeIndicator.BackgroundTransparency = 1 -- Initially invisible
        activeIndicator.Parent = floatingButton
        
        local uiCorner2 = Instance.new("UICorner")
        uiCorner2.CornerRadius = UDim.new(1, 0)
        uiCorner2.Parent = activeIndicator
        
        -- Setup tooltip that shows on touch
        local tooltip = Instance.new("Frame")
        tooltip.Name = "Tooltip"
        tooltip.Size = UDim2.new(0, 150, 0, 40)
        tooltip.Position = UDim2.new(0.5, 0, -0.8, 0)
        tooltip.AnchorPoint = Vector2.new(0.5, 0)
        tooltip.BackgroundColor3 = Themes[RiseLib.CurrentTheme].DarkContrast
        tooltip.BackgroundTransparency = 0.2
        tooltip.Visible = false
        tooltip.Parent = floatingButton
        
        local tooltipCorner = Instance.new("UICorner")
        tooltipCorner.CornerRadius = UDim.new(0, 6)
        tooltipCorner.Parent = tooltip
        
        local tooltipText = Instance.new("TextLabel")
        tooltipText.Name = "Text"
        tooltipText.BackgroundTransparency = 1
        tooltipText.Size = UDim2.new(1, 0, 1, 0)
        tooltipText.Font = Enum.Font.Gotham
        tooltipText.TextColor3 = Color3.new(1, 1, 1)
        tooltipText.TextSize = 14
        tooltipText.Text = name
        tooltipText.Parent = tooltip
        
        -- Variables for touch control
        local touchStartTime = 0
        local isDragging = false
        local startPos = nil
        local touchConnectionBegan, touchConnectionMoved, touchConnectionEnded
        
        -- Update active indicator based on keybind state
        local function updateActiveIndicator()
            if keybind.Value then
                activeIndicator.BackgroundTransparency = 0.5
                floatingButton.BackgroundColor3 = Themes[RiseLib.CurrentTheme].Accent
            else
                activeIndicator.BackgroundTransparency = 1
                floatingButton.BackgroundColor3 = Themes[RiseLib.CurrentTheme].DarkContrast
            end
        end
        
        -- Save position to keybind object
        local function saveButtonPosition()
            keybind.ButtonPosition = floatingButton.Position
        end
        
        touchConnectionBegan = floatingButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                touchStartTime = tick()
                startPos = input.Position
                
                -- Show tooltip on touch
                tooltip.Visible = true
                
                -- Schedule to hide tooltip
                task.delay(2, function()
                    tooltip.Visible = false
                end)
            end
        end)
        
        touchConnectionMoved = floatingButton.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                if startPos and (startPos - input.Position).Magnitude > 10 then
                    isDragging = true
                    
                    -- Calculate new position
                    local delta = input.Position - startPos
                    local newPosition = UDim2.new(
                        floatingButton.Position.X.Scale, 
                        floatingButton.Position.X.Offset + delta.X,
                        floatingButton.Position.Y.Scale, 
                        floatingButton.Position.Y.Offset + delta.Y
                    )
                    
                    -- Clamp to screen bounds
                    local viewportSize = workspace.CurrentCamera.ViewportSize
                    local buttonSize = floatingButton.AbsoluteSize
                    
                    local xOffset = math.clamp(newPosition.X.Offset, 0, viewportSize.X - buttonSize.X)
                    local yOffset = math.clamp(newPosition.Y.Offset, 0, viewportSize.Y - buttonSize.Y)
                    
                    -- Update position
                    floatingButton.Position = UDim2.new(0, xOffset, 0, yOffset)
                    startPos = input.Position
                end
            end
        end)
        
        touchConnectionEnded = floatingButton.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                local touchDuration = tick() - touchStartTime
                
                if isDragging then
                    -- Save position after dragging
                    saveButtonPosition()
                    isDragging = false
                elseif touchDuration >= 1.5 then
                    -- Long press - destroy the button
                    keybind.FloatingButton = nil
                    keybind.ButtonPosition = nil
                    
                    -- Fade out animation
                    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    local tween = TweenService:Create(floatingButton, tweenInfo, {BackgroundTransparency = 1, Size = UDim2.new(0, 0, 0, 0)})
                    tween.Completed:Connect(function()
                        -- Clean up
                        touchConnectionBegan:Disconnect()
                        touchConnectionMoved:Disconnect()
                        touchConnectionEnded:Disconnect()
                        floatingButton:Destroy()
                    end)
                    tween:Play()
                    
                    -- Change keybind back to None
                    keybind.Key = "None"
                    keybindButton.Text = "None"
                elseif touchDuration < 0.5 and not isDragging then
                    -- Short press - toggle the function
                    keybind.Value = not keybind.Value
                    updateActiveIndicator()
                    callback(keybind.Value)
                end
            end
        end)
        
        keybind.FloatingButton = floatingButton
        keybind.ButtonPosition = buttonPosition
        updateActiveIndicator()
    end
    
    -- Handle keybind listening and activation
    keybindButton.MouseButton1Click:Connect(function()
        keybind.Listening = true
        keybindButton.Text = "..."
    end)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if keybind.Listening then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                keybind.Key = input.KeyCode.Name
                keybindButton.Text = input.KeyCode.Name
                keybind.Listening = false
            elseif input.UserInputType == Enum.UserInputType.Touch then
                keybind.Key = "Mobile"
                keybindButton.Text = "Mobile"
                keybind.Listening = false
                
                -- Create floating button for mobile when keybind is set
                if isMobile then
                    createFloatingButton(keybind.ButtonPosition)
                end
            end
        elseif not gameProcessed then
            if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == keybind.Key then
                keybind.Value = not keybind.Value
                
                -- Update floating button indicator if it exists
                if keybind.FloatingButton then
                    local activeIndicator = keybind.FloatingButton:FindFirstChild("ActiveIndicator")
                    if activeIndicator then
                        activeIndicator.BackgroundTransparency = keybind.Value and 0.5 or 1
                    end
                    
                    keybind.FloatingButton.BackgroundColor3 = keybind.Value 
                        and Themes[RiseLib.CurrentTheme].Accent 
                        or Themes[RiseLib.CurrentTheme].DarkContrast
                end
                
                callback(keybind.Value)
            end
        end
    end)
    
    -- Handle escape key to cancel listening
    UserInputService.InputBegan:Connect(function(input)
        if keybind.Listening and input.KeyCode == Enum.KeyCode.Escape then
            keybind.Key = "None"
            keybindButton.Text = "None"
            keybind.Listening = false
        end
    end)
    
    -- Add special functions for saving/loading the keybind configuration
    -- These will be called by the tab:SaveConfig and tab:LoadConfig methods
    
    -- Custom value serializer for saving
    keybind.GetSaveData = function()
        return {
            Type = "Keybind",
            Value = keybind.Value,
            Key = keybind.Key,
            ButtonPosition = keybind.ButtonPosition
        }
    end
    
    -- Custom loading function
    keybind.LoadFromData = function(data)
        keybind.Value = data.Value
        keybind.Key = data.Key
        keybindButton.Text = data.Key
        
        -- Recreate floating button if this is a mobile keybind and we have position data
        if isMobile and data.Key == "Mobile" then
            if keybind.FloatingButton then
                keybind.FloatingButton:Destroy()
                keybind.FloatingButton = nil
            end
            
            createFloatingButton(data.ButtonPosition)
        end
    end
    
    -- Add to category modules
    table.insert(self.Modules, keybind)
    return keybind
end
            
            function category:AddColorPicker(name, defaultColor, callback)
                defaultColor = defaultColor or Color3.fromRGB(255, 255, 255)
                callback = callback or function() end
                
                local colorModule = Instance.new("Frame")
                local colorName = Instance.new("TextLabel")
                local colorDisplay = Instance.new("Frame")
                local UICorner_ColorDisplay = Instance.new("UICorner")
                local colorButton = Instance.new("TextButton")
                local colorPickerFrame = Instance.new("Frame")
                local UICorner_ColorPicker = Instance.new("UICorner")
                local colorCanvas = Instance.new("ImageLabel")
                local colorCanvasCursor = Instance.new("Frame")
                local UICorner_CanvasCursor = Instance.new("UICorner")
                local colorHueSlider = Instance.new("ImageLabel")
                local colorHueCursor = Instance.new("Frame")
                local UICorner_HueCursor = Instance.new("UICorner")
                local colorPreview = Instance.new("Frame")
                local UICorner_ColorPreview = Instance.new("UICorner")
                local colorCloseButton = Instance.new("TextButton")
                
                colorModule.Name = name
                colorModule.Parent = self.ModuleContainer
                colorModule.BackgroundColor3 = Themes[RiseLib.CurrentTheme].LightContrast
                colorModule.Size = UDim2.new(1, 0, 0, 40)
                
                local UICorner_Module = Instance.new("UICorner")
                UICorner_Module.CornerRadius = UDim.new(0, 4)
                UICorner_Module.Parent = colorModule
                
                colorName.Name = "ColorName"
                colorName.Parent = colorModule
                colorName.BackgroundTransparency = 1.000
                colorName.Position = UDim2.new(0, 12, 0, 0)
                colorName.Size = UDim2.new(1, -80, 1, 0)
                colorName.Font = Enum.Font.Gotham
                colorName.Text = name
                colorName.TextColor3 = Themes[RiseLib.CurrentTheme].TextColor
                colorName.TextSize = 14.000
                colorName.TextXAlignment = Enum.TextXAlignment.Left
                
                colorDisplay.Name = "ColorDisplay"
                colorDisplay.Parent = colorModule
                colorDisplay.BackgroundColor3 = defaultColor
                colorDisplay.Position = UDim2.new(1, -50, 0.5, -10)
                colorDisplay.Size = UDim2.new(0, 40, 0, 20)
                
                UICorner_ColorDisplay.CornerRadius = UDim.new(0, 4)
                UICorner_ColorDisplay.Parent = colorDisplay
                
                colorButton.Name = "ColorButton"
                colorButton.Parent = colorDisplay
                colorButton.BackgroundTransparency = 1.000
                colorButton.Size = UDim2.new(1, 0, 1, 0)
                colorButton.Font = Enum.Font.SourceSans
                colorButton.Text = ""
                colorButton.TextColor3 = Themes[RiseLib.CurrentTheme].TextColor
                colorButton.TextSize = 14.000
                
                colorPickerFrame.Name = "ColorPickerFrame"
                colorPickerFrame.Parent = RiseUI
                colorPickerFrame.BackgroundColor3 = Themes[RiseLib.CurrentTheme].LightContrast
                colorPickerFrame.Position = UDim2.new(0.5, -100, 0.5, -100)
                colorPickerFrame.Size = UDim2.new(0, 200, 0, 220)
                colorPickerFrame.Visible = false
                colorPickerFrame.ZIndex = 100
                
                UICorner_ColorPicker.CornerRadius = UDim.new(0, 6)
                UICorner_ColorPicker.Parent = colorPickerFrame
                
                colorCanvas.Name = "ColorCanvas"
                colorCanvas.Parent = colorPickerFrame
                colorCanvas.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                colorCanvas.Position = UDim2.new(0, 10, 0, 10)
                colorCanvas.Size = UDim2.new(0, 180, 0, 130)
                colorCanvas.ZIndex = 100
                colorCanvas.Image = "rbxassetid://4155801252"
                
                colorCanvasCursor.Name = "ColorCanvasCursor"
                colorCanvasCursor.Parent = colorCanvas
                colorCanvasCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                colorCanvasCursor.Position = UDim2.new(0.5, -5, 0.5, -5)
                colorCanvasCursor.Size = UDim2.new(0, 10, 0, 10)
                colorCanvasCursor.ZIndex = 101
                
                UICorner_CanvasCursor.CornerRadius = UDim.new(1, 0)
                UICorner_CanvasCursor.Parent = colorCanvasCursor
                
                colorHueSlider.Name = "ColorHueSlider"
                colorHueSlider.Parent = colorPickerFrame
                colorHueSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                colorHueSlider.Position = UDim2.new(0, 10, 0, 150)
                colorHueSlider.Size = UDim2.new(0, 180, 0, 20)
                colorHueSlider.ZIndex = 100
                colorHueSlider.Image = "rbxassetid://3283557176"
                
                colorHueCursor.Name = "ColorHueCursor"
                colorHueCursor.Parent = colorHueSlider
                colorHueCursor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                colorHueCursor.Position = UDim2.new(0.5, -2, 0, -2)
                colorHueCursor.Size = UDim2.new(0, 4, 1, 4)
                colorHueCursor.ZIndex = 101
                
                UICorner_HueCursor.CornerRadius = UDim.new(1, 0)
                UICorner_HueCursor.Parent = colorHueCursor
                
                colorPreview.Name = "ColorPreview"
                colorPreview.Parent = colorPickerFrame
                colorPreview.BackgroundColor3 = defaultColor
                colorPreview.Position = UDim2.new(0, 10, 0, 180)
                colorPreview.Size = UDim2.new(0, 130, 0, 30)
                colorPreview.ZIndex = 100
                
                UICorner_ColorPreview.CornerRadius = UDim.new(0, 4)
                UICorner_ColorPreview.Parent = colorPreview
                
                colorCloseButton.Name = "ColorCloseButton"
                colorCloseButton.Parent = colorPickerFrame
                colorCloseButton.BackgroundColor3 = Themes[RiseLib.CurrentTheme].Accent
                colorCloseButton.Position = UDim2.new(0, 150, 0, 180)
                colorCloseButton.Size = UDim2.new(0, 40, 0, 30)
                colorCloseButton.Font = Enum.Font.GothamBold
                colorCloseButton.Text = "OK"
                colorCloseButton.TextColor3 = Themes[RiseLib.CurrentTheme].TextColor
                colorCloseButton.TextSize = 14.000
                colorCloseButton.ZIndex = 100
                
                local UICorner_CloseButton = Instance.new("UICorner")
                UICorner_CloseButton.CornerRadius = UDim.new(0, 4)
                UICorner_CloseButton.Parent = colorCloseButton
                
                local colorPicker = {
                    Type = "ColorPicker",
                    Name = name,
                    Value = defaultColor,
                    Callback = callback,
                    Instance = colorModule,
                    Display = colorDisplay,
                    Button = colorButton,
                    PickerFrame = colorPickerFrame,
                    Canvas = colorCanvas,
                    CanvasCursor = colorCanvasCursor,
                    HueSlider = colorHueSlider,
                    HueCursor = colorHueCursor,
                    Preview = colorPreview,
                    CloseButton = colorCloseButton,
                    Open = false
                }
                
                -- HSV to RGB conversion
                local function hsvToRgb(h, s, v)
                    if s <= 0 then return v, v, v end
                    
                    h = h * 6
                    local c = v * s
                    local x = c * (1 - math.abs((h % 2) - 1))
                    local m = v - c
                    local r, g, b
                    
                    if h < 1 then
                        r, g, b = c, x, 0
                    elseif h < 2 then
                        r, g, b = x, c, 0
                    elseif h < 3 then
                        r, g, b = 0, c, x
                    elseif h < 4 then
                        r, g, b = 0, x, c
                    elseif h < 5 then
                        r, g, b = x, 0, c
                    else
                        r, g, b = c, 0, x
                    end
                    
                    return r + m, g + m, b + m
                end
                
                -- RGB to HSV conversion
                local function rgbToHsv(r, g, b)
                    local max = math.max(r, g, b)
                    local min = math.min(r, g, b)
                    local h, s, v
                    
                    v = max
                    local delta = max - min
                    
                    if max ~= 0 then
                        s = delta / max
                    else
                        s = 0
                        h = -1
                        return h, s, v
                    end
                    
                    if r == max then
                        h = (g - b) / delta
                    elseif g == max then
                        h = 2 + (b - r) / delta
                    else
                        h = 4 + (r - g) / delta
                    end
                    
                    h = h / 6
                    if h < 0 then h = h + 1 end
                    
                    return h, s, v
                end
                
                -- Handle color picker functionality
                colorButton.MouseButton1Click:Connect(function()
                    colorPicker.Open = not colorPicker.Open
                    colorPickerFrame.Visible = colorPicker.Open
                    
                    if colorPicker.Open then
                        -- Position picker near the button
                        local buttonPos = colorButton.AbsolutePosition
                        colorPickerFrame.Position = UDim2.new(0, buttonPos.X - 100, 0, buttonPos.Y + 30)
                    end
                end)
                
                colorCloseButton.MouseButton1Click:Connect(function()
                    colorPicker.Open = false
                    colorPickerFrame.Visible = false
                end)
                
                -- Handle canvas and hue interactions
                local draggingCanvas, draggingHue = false, false
                
                colorCanvas.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        draggingCanvas = true
                    end
                end)
                
                colorCanvas.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        draggingCanvas = false
                    end
                end)
                
                colorHueSlider.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        draggingHue = true
                    end
                end)
                
                colorHueSlider.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        draggingHue = false
                    end
                end)
                
                -- Update color based on user input
                UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                        if draggingCanvas then
                            -- Update canvas cursor position
                            local canvasPos = colorCanvas.AbsolutePosition
                            local canvasSize = colorCanvas.AbsoluteSize
                            local relativeX = math.clamp((input.Position.X - canvasPos.X) / canvasSize.X, 0, 1)
                            local relativeY = math.clamp((input.Position.Y - canvasPos.Y) / canvasSize.Y, 0, 1)
                            
                            colorCanvasCursor.Position = UDim2.new(relativeX, -5, relativeY, -5)
                            
                            -- Calculate color
                            local hue = colorHueCursor.Position.X.Scale
                            local saturation = relativeX
                            local value = 1 - relativeY
                            
                            local r, g, b = hsvToRgb(hue, saturation, value)
                            local color = Color3.new(r, g, b)
                            
                            colorPreview.BackgroundColor3 = color
                            colorDisplay.BackgroundColor3 = color
                            colorPicker.Value = color
                            callback(color)
                            
                        elseif draggingHue then
                            -- Update hue cursor position
                            local sliderPos = colorHueSlider.AbsolutePosition
                            local sliderSize = colorHueSlider.AbsoluteSize
                            local relativeX = math.clamp((input.Position.X - sliderPos.X) / sliderSize.X, 0, 1)
                            
                            colorHueCursor.Position = UDim2.new(relativeX, -2, 0, -2)
                            
                            -- Update canvas background
                            local h = relativeX
                            local r, g, b = hsvToRgb(h, 1, 1)
                            colorCanvas.BackgroundColor3 = Color3.new(r, g, b)
                            
                            -- Calculate color
                            local saturation = colorCanvasCursor.Position.X.Scale
                            local value = 1 - colorCanvasCursor.Position.Y.Scale
                            
                            r, g, b = hsvToRgb(h, saturation, value)
                            local color = Color3.new(r, g, b)
                            
                            colorPreview.BackgroundColor3 = color
                            colorDisplay.BackgroundColor3 = color
                            colorPicker.Value = color
                            callback(color)
                        end
                    end
                end)
                
                -- Setup initial color
                local h, s, v = rgbToHsv(defaultColor.R, defaultColor.G, defaultColor.B)
                colorHueCursor.Position = UDim2.new(h, -2, 0, -2)
                colorCanvasCursor.Position = UDim2.new(s, -5, 1 - v, -5)
                
                local r, g, b = hsvToRgb(h, 1, 1)
                colorCanvas.BackgroundColor3 = Color3.new(r, g, b)
                
                -- Add to category modules
                table.insert(self.Modules, colorPicker)
                return colorPicker
            end
            
            function category:AddTextBox(name, defaultText, callback)
                defaultText = defaultText or ""
                callback = callback or function() end
                
                local textboxModule = Instance.new("Frame")
                local textboxName = Instance.new("TextLabel")
                local textboxInput = Instance.new("TextBox")
                local UICorner_TextBox = Instance.new("UICorner")
                
                textboxModule.Name = name
                textboxModule.Parent = self.ModuleContainer
                textboxModule.BackgroundColor3 = Themes[RiseLib.CurrentTheme].LightContrast
                textboxModule.Size = UDim2.new(1, 0, 0, 40)
                
                local UICorner_Module = Instance.new("UICorner")
                UICorner_Module.CornerRadius = UDim.new(0, 4)
                UICorner_Module.Parent = textboxModule
                
                textboxName.Name = "TextBoxName"
                textboxName.Parent = textboxModule
                textboxName.BackgroundTransparency = 1.000
                textboxName.Position = UDim2.new(0, 12, 0, 0)
                textboxName.Size = UDim2.new(0, 100, 1, 0)
                textboxName.Font = Enum.Font.Gotham
                textboxName.Text = name
                textboxName.TextColor3 = Themes[RiseLib.CurrentTheme].TextColor
                textboxName.TextSize = 14.000
                textboxName.TextXAlignment = Enum.TextXAlignment.Left
                
                textboxInput.Name = "TextBoxInput"
                textboxInput.Parent = textboxModule
                textboxInput.BackgroundColor3 = Themes[RiseLib.CurrentTheme].DarkContrast
                textboxInput.Position = UDim2.new(1, -170, 0.5, -15)
                textboxInput.Size = UDim2.new(0, 160, 0, 30)
                textboxInput.Font = Enum.Font.Gotham
                textboxInput.PlaceholderText = "Enter text..."
                textboxInput.Text = defaultText
                textboxInput.TextColor3 = Themes[RiseLib.CurrentTheme].TextColor
                textboxInput.TextSize = 14.000
                textboxInput.ClearTextOnFocus = false
                
                UICorner_TextBox.CornerRadius = UDim.new(0, 4)
                UICorner_TextBox.Parent = textboxInput
                
                local textbox = {
                    Type = "TextBox",
                    Name = name,
                    Value = defaultText,
                    Callback = callback,
                    Instance = textboxModule,
                    Input = textboxInput
                }
                
                -- Handle input changes
                textboxInput.FocusLost:Connect(function(enterPressed)
                    textbox.Value = textboxInput.Text
                    callback(textboxInput.Text, enterPressed)
                end)
                
                -- Add to category modules
                table.insert(self.Modules, textbox)
                return textbox
            end
            
            function category:AddLabel(text)
                local labelModule = Instance.new("Frame")
                local labelText = Instance.new("TextLabel")
                
                labelModule.Name = "Label"
                labelModule.Parent = self.ModuleContainer
                labelModule.BackgroundColor3 = Themes[RiseLib.CurrentTheme].LightContrast
                labelModule.Size = UDim2.new(1, 0, 0, 30)
                
                local UICorner_Module = Instance.new("UICorner")
                UICorner_Module.CornerRadius = UDim.new(0, 4)
                UICorner_Module.Parent = labelModule
                
                labelText.Name = "LabelText"
                labelText.Parent = labelModule
                labelText.BackgroundTransparency = 1.000
                labelText.Position = UDim2.new(0, 0, 0, 0)
                labelText.Size = UDim2.new(1, 0, 1, 0)
                labelText.Font = Enum.Font.GothamSemibold
                labelText.Text = text
                labelText.TextColor3 = Themes[RiseLib.CurrentTheme].TextColor
                labelText.TextSize = 14.000
                
                local label = {
                    Type = "Label",
                    Text = text,
                    Instance = labelModule,
                    TextLabel = labelText
                }
                
                -- Function to update label text
                function label:UpdateText(newText)
                    labelText.Text = newText
                    label.Text = newText
                end
                
                -- Add to category modules
                table.insert(self.Modules, label)
                return label
            end
            
            return category
        end
        
        -- Add config saving/loading functionality
function tab:SaveConfig(configName)
    local configData = {}
    
    for _, category in pairs(self.Categories) do
        configData[category.Name] = {}
        
        for _, module in ipairs(category.Modules) do
            if module.Type ~= "Button" and module.Type ~= "Label" then
                -- Use custom GetSaveData function if available (for complex modules like Keybind)
                if module.GetSaveData then
                    configData[category.Name][module.Name] = module.GetSaveData()
                else
                    configData[category.Name][module.Name] = {
                        Type = module.Type,
                        Value = module.Value
                    }
                end
            end
        end
    end
    
    return saveConfig(configData, configName)
end

function tab:LoadConfig(configName)
    local configData = loadConfig(configName)
    if not configData then return false end
    
    for categoryName, categoryData in pairs(configData) do
        if self.Categories[categoryName] then
            local category = self.Categories[categoryName]
            
            for moduleName, moduleData in pairs(categoryData) do
                for _, module in ipairs(category.Modules) do
                    if module.Name == moduleName and module.Type == moduleData.Type then
                        -- Use custom loader if available
                        if module.LoadFromData then
                            module.LoadFromData(moduleData)
                        else
                            -- Update module based on type
                            if module.Type == "Toggle" then
                                module.Value = moduleData.Value
                                module.Button.BackgroundColor3 = module.Value and Themes[RiseLib.CurrentTheme].Accent or Themes[RiseLib.CurrentTheme].DarkContrast
                                module.Circle.Position = module.Value and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
                                module.Callback(module.Value)
                            elseif module.Type == "Slider" then
                                module.Value = moduleData.Value
                                module.Display.Text = tostring(module.Value)
                                module.Fill.Size = UDim2.new((module.Value - module.Min) / (module.Max - module.Min), 0, 1, 0)
                                module.Callback(module.Value)
                            elseif module.Type == "Dropdown" then
                                module.Value = moduleData.Value
                                module.Selection.Text = module.Value
                                module.Callback(module.Value)
                            elseif module.Type == "ColorPicker" then
                                module.Value = moduleData.Value
                                module.Display.BackgroundColor3 = moduleData.Value
                                module.Preview.BackgroundColor3 = moduleData.Value
                                module.Callback(moduleData.Value)
                            elseif module.Type == "TextBox" then
                                module.Value = moduleData.Value
                                module.Input.Text = moduleData.Value
                                module.Callback(moduleData.Value, false)
                            end
                        end
                    end
                end
            end
        end
    end
    
    return true
end
    
    -- Theme changing functionality
    function window:ChangeTheme(newTheme)
        if not Themes[newTheme] then return end
        
        -- Update theme in UI
        for element, instance in pairs(self.ThemeObjects) do
            if element == "Main" or element == "ThemeFrame" then
                instance.BackgroundColor3 = Themes[newTheme].Background
            elseif element == "Topbar" or element == "CategoryContainer" then
                instance.BackgroundColor3 = Themes[newTheme].LightContrast
            elseif element == "Shadow" or element == "Logo" or element == "RiseLogo" then
                instance.ImageColor3 = Themes[newTheme].Accent
            elseif element == "ModuleContainer" then
                instance.ScrollBarImageColor3 = Themes[newTheme].Accent
            elseif element == "Title" or element == "Version" or element == "ThemeButton" or element == "CloseButton" or element == "MinimizeButton" then
                instance.TextColor3 = Themes[newTheme].TextColor
            end
        end
        
        -- Update mobile controls if they exist
        if isMobile then
            window.ThemeObjects.MobileMenuButton.BackgroundColor3 = Themes[newTheme].LightContrast
            window.ThemeObjects.MobileMenuButton.ImageColor3 = Themes[newTheme].TextColor
            window.ThemeObjects.MobileThemeButton.BackgroundColor3 = Themes[newTheme].LightContrast
            window.ThemeObjects.MobileThemeButton.ImageColor3 = Themes[newTheme].Accent
        end
        
        -- Update active tabs
        for _, tab in pairs(self.Tabs) do
            -- Update tab buttons
            if tab == self.ActiveTab then
                tab.Button.BackgroundColor3 = Themes[newTheme].Accent
            else
                tab.Button.BackgroundColor3 = Themes[newTheme].LightContrast
            end
            
            -- Update tab icon and text
            tab.Button.TabIcon.ImageColor3 = Themes[newTheme].TextColor
            tab.Button.TabName.TextColor3 = Themes[newTheme].TextColor
            
            -- Update category frame
            tab.CategoryFrame.BackgroundColor3 = Themes[newTheme].DarkContrast
            
            -- Update module frame
            tab.ModuleFrame.ScrollBarImageColor3 = Themes[newTheme].Accent
            
            -- Update categories
            for _, category in pairs(tab.Categories) do
                -- Update category buttons
                local isActiveCategory = category.ModuleContainer.Visible
                category.Button.TextColor3 = isActiveCategory and Themes[newTheme].Accent or Themes[newTheme].TextColor
                
                -- Update modules
                for _, module in ipairs(category.Modules) do
                    if module.Type == "Toggle" then
                        module.Instance.BackgroundColor3 = Themes[newTheme].LightContrast
                        module.Button.BackgroundColor3 = module.Value and Themes[newTheme].Accent or Themes[newTheme].DarkContrast
                        module.Circle.BackgroundColor3 = Themes[newTheme].TextColor
                        module.Instance.ToggleName.TextColor3 = Themes[newTheme].TextColor
                    elseif module.Type == "Slider" then
                        module.Instance.BackgroundColor3 = Themes[newTheme].LightContrast
                        module.Instance.SliderContainer.BackgroundColor3 = Themes[newTheme].DarkContrast
                        module.Fill.BackgroundColor3 = Themes[newTheme].Accent
                        module.Instance.SliderName.TextColor3 = Themes[newTheme].TextColor
                        module.Display.TextColor3 = Themes[newTheme].TextColor
                    elseif module.Type == "Dropdown" then
                        module.Instance.BackgroundColor3 = Themes[newTheme].LightContrast
                        module.Button.BackgroundColor3 = Themes[newTheme].DarkContrast
                        module.Arrow.ImageColor3 = Themes[newTheme].TextColor
                        module.Instance.DropdownName.TextColor3 = Themes[newTheme].TextColor
                        module.Selection.TextColor3 = Themes[newTheme].TextColor
                        module.Container.BackgroundColor3 = Themes[newTheme].LightContrast
                        
                        for _, child in pairs(module.Container:GetChildren()) do
                            if child:IsA("TextButton") then
                                child.TextColor3 = Themes[newTheme].TextColor
                            end
                        end
                    elseif module.Type == "Button" then
                        module.Instance.BackgroundColor3 = Themes[newTheme].LightContrast
                        module.Button.BackgroundColor3 = Themes[newTheme].DarkContrast
                        module.Button.TextColor3 = Themes[newTheme].TextColor
                    elseif module.Type == "Keybind" then
                        module.Instance.BackgroundColor3 = Themes[newTheme].LightContrast
                        module.Button.BackgroundColor3 = Themes[newTheme].DarkContrast
                        module.Button.TextColor3 = Themes[newTheme].TextColor
                        module.Instance.KeybindName.TextColor3 = Themes[newTheme].TextColor
                    elseif module.Type == "ColorPicker" then
                        module.Instance.BackgroundColor3 = Themes[newTheme].LightContrast
                        module.Instance.ColorName.TextColor3 = Themes[newTheme].TextColor
                        module.PickerFrame.BackgroundColor3 = Themes[newTheme].LightContrast
                        module.CloseButton.BackgroundColor3 = Themes[newTheme].Accent
                        module.CloseButton.TextColor3 = Themes[newTheme].TextColor
                    elseif module.Type == "TextBox" then
                        module.Instance.BackgroundColor3 = Themes[newTheme].LightContrast
                        module.Input.BackgroundColor3 = Themes[newTheme].DarkContrast
                        module.Input.TextColor3 = Themes[newTheme].TextColor
                        module.Instance.TextBoxName.TextColor3 = Themes[newTheme].TextColor
                    elseif module.Type == "Label" then
                        module.Instance.BackgroundColor3 = Themes[newTheme].LightContrast
                        module.TextLabel.TextColor3 = Themes[newTheme].TextColor
                    end
                end
            end
        end
        
        -- Save theme preference
        saveConfig({Theme = newTheme}, "uisettings")
        RiseLib.CurrentTheme = newTheme
    end
    
    return window
end

-- Set current theme on initialization
RiseLib.CurrentTheme = "Classic"

-- Add this function inside your RiseLib table (e.g., after initializing Themes and RiseLib.CurrentTheme)
function RiseLib:Notify(title, message, duration)
    duration = duration or 3 -- seconds; default if not provided

    -- Create the notification ScreenGui
    local notificationGui = Instance.new("ScreenGui")
    notificationGui.Name = "RiseNotification"
    notificationGui.ResetOnSpawn = false
    notificationGui.Parent = game:GetService("CoreGui")
    
    -- Create the main frame for the notification
    local frame = Instance.new("Frame")
    frame.Name = "NotificationFrame"
    frame.AnchorPoint = Vector2.new(0.5, 0)
    frame.Position = UDim2.new(0.5, 0, -0.2, 0) -- start off-screen at top
    frame.Size = UDim2.new(0, 300, 0, 80)
    frame.BackgroundColor3 = Themes[RiseLib.CurrentTheme] and Themes[RiseLib.CurrentTheme].LightContrast or Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    frame.Parent = notificationGui

    -- Rounded corners for that extra drip
    local uicorner = Instance.new("UICorner", frame)
    uicorner.CornerRadius = UDim.new(0, 8)
    
    -- Title label
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Text = title or "Notification"
    titleLabel.Size = UDim2.new(1, -20, 0, 30)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Themes[RiseLib.CurrentTheme] and Themes[RiseLib.CurrentTheme].TextColor or Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = frame

    -- Message label
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Name = "MessageLabel"
    messageLabel.Text = message or ""
    messageLabel.Size = UDim2.new(1, -20, 0, 30)
    messageLabel.Position = UDim2.new(0, 10, 0, 40)
    messageLabel.BackgroundTransparency = 1
    messageLabel.TextColor3 = Themes[RiseLib.CurrentTheme] and Themes[RiseLib.CurrentTheme].TextColor or Color3.fromRGB(230, 230, 230)
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextSize = 16
    messageLabel.TextWrapped = true
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.Parent = frame

    -- Tween services for smooth slide in and out
    local TweenService = game:GetService("TweenService")
    local tweenInfoIn = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tweenInfoOut = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

    -- Slide in from the top
    local tweenIn = TweenService:Create(frame, tweenInfoIn, {Position = UDim2.new(0.5, 0, 0.1, 0)})
    tweenIn:Play()

    tweenIn.Completed:Connect(function()
        task.wait(duration)
        -- Fade out and slide up for the exit
        local tweenOut = TweenService:Create(frame, tweenInfoOut, {Position = UDim2.new(0.5, 0, -0.2, 0), BackgroundTransparency = 1})
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            notificationGui:Destroy()
        end)
    end)
end

return RiseLib
