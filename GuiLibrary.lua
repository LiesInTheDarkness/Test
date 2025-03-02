-- Rise 6.0 Style UI Library for Roblox
-- Compatible with both PC and Mobile devices

local RiseLib = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Utility functions
local function dragify(Frame)
    local dragToggle, dragInput, dragStart, startPos
    local dragSpeed = 0.1
    
    local function updateInput(input)
        local Delta = input.Position - dragStart
        local Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
        TweenService:Create(Frame, TweenInfo.new(dragSpeed), {Position = Position}):Play()
    end
    
    Frame.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not UserInputService:GetFocusedTextBox() then
            dragToggle = true
            dragStart = input.Position
            startPos = Frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)
    
    Frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragToggle then
            updateInput(input)
        end
    end)
end

function RiseLib:CreateWindow(title, color)
    local color = color or Color3.fromRGB(85, 170, 255) -- Default Rise blue color
    local Rise6Window = {}
    
    -- Create the main GUI
    local RiseUI = Instance.new("ScreenGui")
    RiseUI.Name = "RiseUI"
    RiseUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    RiseUI.ResetOnSpawn = false
    RiseUI.Parent = game.CoreGui
    
    -- Main window
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -175)
    MainFrame.Size = UDim2.new(0, 600, 0, 350)
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = RiseUI
    
    -- Apply corner radius to main frame
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 8)
    MainCorner.Parent = MainFrame
    
    -- Apply shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.Size = UDim2.new(1, 40, 1, 40)
    Shadow.ZIndex = -1
    Shadow.Image = "rbxassetid://6014261993"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    Shadow.Parent = MainFrame
    
    -- Top bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TopBar.BorderSizePixel = 0
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.Parent = MainFrame
    
    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 8)
    TopCorner.Parent = TopBar
    
    local TopbarFix = Instance.new("Frame")
    TopbarFix.Name = "TopbarFix"
    TopbarFix.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TopbarFix.BorderSizePixel = 0
    TopbarFix.Position = UDim2.new(0, 0, 0.5, 0)
    TopbarFix.Size = UDim2.new(1, 0, 0.5, 0)
    TopbarFix.Parent = TopBar
    
    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.Size = UDim2.new(1, -15, 1, 0)
    TitleLabel.Font = Enum.Font.GothamSemibold
    TitleLabel.Text = title or "Rise 6.0"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TopBar
    
    -- Close button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -40, 0, 0)
    CloseButton.Size = UDim2.new(0, 40, 0, 40)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 24
    CloseButton.Parent = TopBar
    
    CloseButton.MouseButton1Click:Connect(function()
        RiseUI:Destroy()
    end)
    
    -- Minimize button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Position = UDim2.new(1, -80, 0, 0)
    MinimizeButton.Size = UDim2.new(0, 40, 0, 40)
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.TextSize = 24
    MinimizeButton.Parent = TopBar
    
    local minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 600, 0, 40)}):Play()
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 600, 0, 350)}):Play()
        end
    end)
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 0, 0, 40)
    TabContainer.Size = UDim2.new(0, 150, 1, -40)
    TabContainer.Parent = MainFrame
    
    local TabContainerCorner = Instance.new("UICorner")
    TabContainerCorner.CornerRadius = UDim.new(0, 8)
    TabContainerCorner.Parent = TabContainer
    
    local TabContainerFix = Instance.new("Frame")
    TabContainerFix.Name = "TabContainerFix"
    TabContainerFix.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TabContainerFix.BorderSizePixel = 0
    TabContainerFix.Position = UDim2.new(1, -8, 0, 0)
    TabContainerFix.Size = UDim2.new(0, 8, 1, 0)
    TabContainerFix.Parent = TabContainer
    
    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Name = "TabScroll"
    TabScroll.Active = true
    TabScroll.BackgroundTransparency = 1
    TabScroll.Position = UDim2.new(0, 0, 0, 10)
    TabScroll.Size = UDim2.new(1, 0, 1, -10)
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScroll.ScrollBarThickness = 0
    TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabScroll.Parent = TabContainer
    
    local TabList = Instance.new("UIListLayout")
    TabList.Name = "TabList"
    TabList.Padding = UDim.new(0, 5)
    TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Parent = TabScroll
    
    -- Container for tab content
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 150, 0, 40)
    ContentContainer.Size = UDim2.new(1, -150, 1, -40)
    ContentContainer.Parent = MainFrame
    
    -- Make the window draggable
    dragify(MainFrame)
    
    -- Mobile Toggle Button (only shows on mobile devices)
    local MobileToggle
    if isMobile then
        MobileToggle = Instance.new("ImageButton")
        MobileToggle.Name = "MobileToggle"
        MobileToggle.BackgroundColor3 = color
        MobileToggle.Position = UDim2.new(0, 10, 0, 10)
        MobileToggle.Size = UDim2.new(0, 50, 0, 50)
        MobileToggle.Image = "rbxassetid://3926307971"
        MobileToggle.ImageRectOffset = Vector2.new(804, 4)
        MobileToggle.ImageRectSize = Vector2.new(36, 36)
        MobileToggle.ImageColor3 = Color3.fromRGB(255, 255, 255)
        MobileToggle.Parent = RiseUI
        
        local MobileToggleCorner = Instance.new("UICorner")
        MobileToggleCorner.CornerRadius = UDim.new(1, 0)
        MobileToggleCorner.Parent = MobileToggle
        
        local MobileToggleShadow = Instance.new("ImageLabel")
        MobileToggleShadow.Name = "Shadow"
        MobileToggleShadow.AnchorPoint = Vector2.new(0.5, 0.5)
        MobileToggleShadow.BackgroundTransparency = 1
        MobileToggleShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
        MobileToggleShadow.Size = UDim2.new(1, 10, 1, 10)
        MobileToggleShadow.ZIndex = -1
        MobileToggleShadow.Image = "rbxassetid://6014261993"
        MobileToggleShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
        MobileToggleShadow.ImageTransparency = 0.5
        MobileToggleShadow.ScaleType = Enum.ScaleType.Slice
        MobileToggleShadow.SliceCenter = Rect.new(49, 49, 450, 450)
        MobileToggleShadow.Parent = MobileToggle
        
        -- Make Mobile Toggle draggable
        local function makeToggleDraggable()
            local dragging = false
            local dragStart, startPos
            
            MobileToggle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    dragStart = input.Position
                    startPos = MobileToggle.Position
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            dragging = false
                        end
                    end)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.Touch then
                    local delta = input.Position - dragStart
                    MobileToggle.Position = UDim2.new(
                        startPos.X.Scale, 
                        startPos.X.Offset + delta.X,
                        startPos.Y.Scale,
                        startPos.Y.Offset + delta.Y
                    )
                end
            end)
        end
        
        makeToggleDraggable()
        
        -- Toggle UI visibility on button click
        local uiVisible = true
        MobileToggle.MouseButton1Click:Connect(function()
            uiVisible = not uiVisible
            MainFrame.Visible = uiVisible
        end)
    end
    
    local tabs = {}
    local tabContents = {}
    local selectedTab = nil
    
    -- Function to create a new tab
    function Rise6Window:AddTab(tabName, icon)
        local tab = {}
        
        -- Create Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName .. "Tab"
        TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        TabButton.BackgroundTransparency = 1
        TabButton.Size = UDim2.new(0, 140, 0, 35)
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Text = tabName
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.TextSize = 14
        TabButton.Parent = TabScroll
        
        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 6)
        TabButtonCorner.Parent = TabButton
        
        -- Tab Icon (if provided)
        if icon then
            local TabIcon = Instance.new("ImageLabel")
            TabIcon.Name = "TabIcon"
            TabIcon.BackgroundTransparency = 1
            TabIcon.Position = UDim2.new(0, 10, 0.5, -10)
            TabIcon.Size = UDim2.new(0, 20, 0, 20)
            TabIcon.Image = icon
            TabIcon.Parent = TabButton
            
            -- Adjust text position
            TabButton.Text = "  " .. tabName
            TabButton.TextXAlignment = Enum.TextXAlignment.Center
        end
        
        -- Create Content Frame
        local ContentFrame = Instance.new("ScrollingFrame")
        ContentFrame.Name = tabName .. "Content"
        ContentFrame.BackgroundTransparency = 1
        ContentFrame.BorderSizePixel = 0
        ContentFrame.Size = UDim2.new(1, 0, 1, 0)
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        ContentFrame.ScrollBarThickness = 3
        ContentFrame.ScrollBarImageColor3 = color
        ContentFrame.Visible = false
        ContentFrame.Parent = ContentContainer
        ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        
        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.PaddingLeft = UDim.new(0, 15)
        ContentPadding.PaddingRight = UDim.new(0, 15)
        ContentPadding.PaddingTop = UDim.new(0, 15)
        ContentPadding.PaddingBottom = UDim.new(0, 15)
        ContentPadding.Parent = ContentFrame
        
        local ContentList = Instance.new("UIListLayout")
        ContentList.Name = "ContentList"
        ContentList.Padding = UDim.new(0, 10)
        ContentList.SortOrder = Enum.SortOrder.LayoutOrder
        ContentList.Parent = ContentFrame
        
        -- Add tab to the tab list
        table.insert(tabs, TabButton)
        tabContents[TabButton] = ContentFrame
        
        -- Select first tab by default
        if #tabs == 1 then
            selectedTab = TabButton
            TabButton.BackgroundTransparency = 0
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            ContentFrame.Visible = true
        end
        
        -- Tab button on click
        TabButton.MouseButton1Click:Connect(function()
            if selectedTab ~= TabButton then
                -- Deselect current tab
                if selectedTab then
                    TweenService:Create(selectedTab, TweenInfo.new(0.2), {
                        BackgroundTransparency = 1,
                        TextColor3 = Color3.fromRGB(200, 200, 200)
                    }):Play()
                    tabContents[selectedTab].Visible = false
                end
                
                -- Select new tab
                selectedTab = TabButton
                TweenService:Create(TabButton, TweenInfo.new(0.2), {
                    BackgroundTransparency = 0,
                    BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                    TextColor3 = Color3.fromRGB(255, 255, 255)
                }):Play()
                ContentFrame.Visible = true
            end
        end)
        
        -- Create elements for the tab
        function tab:AddSection(sectionName)
            local section = {}
            
            -- Section Container
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = sectionName .. "Section"
            SectionFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            SectionFrame.Size = UDim2.new(1, 0, 0, 40)
            SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            SectionFrame.Parent = ContentFrame
            
            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 6)
            SectionCorner.Parent = SectionFrame
            
            -- Section Title
            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "SectionTitle"
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Position = UDim2.new(0, 10, 0, 8)
            SectionTitle.Size = UDim2.new(1, -20, 0, 22)
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.Text = sectionName
            SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            SectionTitle.TextSize = 14
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = SectionFrame
            
            -- Content Container
            local SectionContent = Instance.new("Frame")
            SectionContent.Name = "SectionContent"
            SectionContent.BackgroundTransparency = 1
            SectionContent.Position = UDim2.new(0, 0, 0, 30)
            SectionContent.Size = UDim2.new(1, 0, 0, 0)
            SectionContent.AutomaticSize = Enum.AutomaticSize.Y
            SectionContent.Parent = SectionFrame
            
            local SectionList = Instance.new("UIListLayout")
            SectionList.Name = "SectionList"
            SectionList.Padding = UDim.new(0, 8)
            SectionList.SortOrder = Enum.SortOrder.LayoutOrder
            SectionList.Parent = SectionContent
            
            local SectionPadding = Instance.new("UIPadding")
            SectionPadding.PaddingLeft = UDim.new(0, 10)
            SectionPadding.PaddingRight = UDim.new(0, 10)
            SectionPadding.PaddingBottom = UDim.new(0, 10)
            SectionPadding.Parent = SectionContent
            
            -- Button element
            function section:AddButton(buttonName, callback)
                callback = callback or function() end
                
                local Button = Instance.new("TextButton")
                Button.Name = buttonName .. "Button"
                Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                Button.Size = UDim2.new(1, 0, 0, 35)
                Button.Font = Enum.Font.GothamSemibold
                Button.Text = buttonName
                Button.TextColor3 = Color3.fromRGB(255, 255, 255)
                Button.TextSize = 14
                Button.Parent = SectionContent
                
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 6)
                ButtonCorner.Parent = Button
                
                -- Button hover and click effects
                Button.MouseEnter:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(55, 55, 55)
                    }):Play()
                end)
                
                Button.MouseLeave:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                    }):Play()
                end)
                
                Button.MouseButton1Down:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.1), {
                        BackgroundColor3 = color
                    }):Play()
                end)
                
                Button.MouseButton1Up:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.1), {
                        BackgroundColor3 = Color3.fromRGB(55, 55, 55)
                    }):Play()
                    callback()
                end)
                
                return Button
            end
            
            -- Toggle element
            function section:AddToggle(toggleName, default, callback)
                default = default or false
                callback = callback or function() end
                
                local toggleValue = default
                
                local Toggle = Instance.new("Frame")
                Toggle.Name = toggleName .. "Toggle"
                Toggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                Toggle.Size = UDim2.new(1, 0, 0, 35)
                Toggle.Parent = SectionContent
                
                local ToggleCorner = Instance.new("UICorner")
                ToggleCorner.CornerRadius = UDim.new(0, 6)
                ToggleCorner.Parent = Toggle
                
                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Name = "ToggleLabel"
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
                ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
                ToggleLabel.Font = Enum.Font.GothamSemibold
                ToggleLabel.Text = toggleName
                ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                ToggleLabel.TextSize = 14
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Parent = Toggle
                
                local ToggleButton = Instance.new("Frame")
                ToggleButton.Name = "ToggleButton"
                ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
                ToggleButton.Size = UDim2.new(0, 40, 0, 20)
                ToggleButton.Parent = Toggle
                
                local ToggleButtonCorner = Instance.new("UICorner")
                ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
                ToggleButtonCorner.Parent = ToggleButton
                
                local ToggleCircle = Instance.new("Frame")
                ToggleCircle.Name = "ToggleCircle"
                ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ToggleCircle.Position = UDim2.new(0, 2, 0.5, -8)
                ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
                ToggleCircle.Parent = ToggleButton
                
                local ToggleCircleCorner = Instance.new("UICorner")
                ToggleCircleCorner.CornerRadius = UDim.new(1, 0)
                ToggleCircleCorner.Parent = ToggleCircle
                
                -- Set default state
                if default then
                    ToggleButton.BackgroundColor3 = color
                    ToggleCircle.Position = UDim2.new(1, -18, 0.5, -8)
                end
                
                -- Click event
                local ToggleClickRegion = Instance.new("TextButton")
                ToggleClickRegion.Name = "ToggleClickRegion"
                ToggleClickRegion.BackgroundTransparency = 1
                ToggleClickRegion.Size = UDim2.new(1, 0, 1, 0)
                ToggleClickRegion.Font = Enum.Font.SourceSans
                ToggleClickRegion.Text = ""
                ToggleClickRegion.TextColor3 = Color3.fromRGB(0, 0, 0)
                ToggleClickRegion.TextSize = 14
                ToggleClickRegion.Parent = Toggle
                
                ToggleClickRegion.MouseButton1Click:Connect(function()
                    toggleValue = not toggleValue
                    
                    if toggleValue then
                        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                            BackgroundColor3 = color
                        }):Play()
                        TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
                            Position = UDim2.new(1, -18, 0.5, -8)
                        }):Play()
                    else
                        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                            BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                        }):Play()
                        TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
                            Position = UDim2.new(0, 2, 0.5, -8)
                        }):Play()
                    end
                    
                    callback(toggleValue)
                end)
                
                -- Toggle API
                local toggleApi = {}
                
                function toggleApi:Set(value)
                    toggleValue = value
                    
                    if toggleValue then
                        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                            BackgroundColor3 = color
                        }):Play()
                        TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
                            Position = UDim2.new(1, -18, 0.5, -8)
                        }):Play()
                    else
                        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                            BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                        }):Play()
                        TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
                            Position = UDim2.new(0, 2, 0.5, -8)
                        }):Play()
                    end
                    
                    callback(toggleValue)
                end
                
                function toggleApi:Get()
                    return toggleValue
                end
                
                return toggleApi
            end
            
            -- Slider element
            function section:AddSlider(sliderName, min, max, default, precision, callback)
                min = min or 0
                max = max or 100
                default = default or min
                precision = precision or 1
                callback = callback or function() end
                
                local sliderValue = default
                
                local Slider = Instance.new("Frame")
                Slider.Name = sliderName .. "Slider"
                Slider.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                Slider.Size = UDim2.new(1, 0, 0, 50)
                Slider.Parent = SectionContent
                
                local SliderCorner = Instance.new("UICorner")
                SliderCorner.CornerRadius = UDim.new(0, 6)
                SliderCorner.Parent = Slider
                
                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Name = "SliderLabel"
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Position = UDim2.new(0, 10, 0, 5)
                SliderLabel.Size = UDim2.new(1, -20, 0, 20)
                SliderLabel.Font = Enum.Font.GothamSemibold
                SliderLabel.Text = sliderName
                SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                SliderLabel.TextSize = 14
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                SliderLabel.Parent = Slider
                
                local SliderValue = Instance.new("TextLabel")
                SliderValue.Name = "SliderValue"
                SliderValue.BackgroundTransparency = 1
                SliderValue.Position = UDim2.new(1, -50, 0, 5)
                SliderValue.Size = UDim2.new(0, 40, 0, 20)
                SliderValue.Font = Enum.Font.GothamSemibold
                SliderValue.Text = tostring(default)
                SliderValue.TextColor3 = Color3.fromRGB(255, 255, 255)
                SliderValue.TextSize = 14
                SliderValue.TextXAlignment = Enum.TextXAlignment.Right
                SliderValue.Parent = Slider
                
                local SliderBar = Instance.new("Frame")
                SliderBar.Name = "SliderBar"
                SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                SliderBar.Position = UDim2.new(0, 10, 0, 30)
                SliderBar.Size = UDim2.new(1, -20, 0, 6)
                SliderBar.Parent = Slider
                
                local SliderBarCorner = Instance.new("UICorner")
                SliderBarCorner.CornerRadius = UDim.new(1, 0)
                SliderBarCorner.Parent = SliderBar
                
                local SliderFill = Instance.new("Frame")
                SliderFill.Name = "SliderFill"
                SliderFill.BackgroundColor3 = color
                SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                SliderFill.Parent = SliderBar
                
                local SliderFillCorner = Instance.new("UICorner")
                SliderFillCorner.CornerRadius = UDim.new(1, 0)
                SliderFillCorner.Parent = SliderFill
                
                local SliderCircle = Instance.new("Frame")
                SliderCircle.Name = "SliderCircle"
                SliderCircle.AnchorPoint = Vector2.new(0.5, 0.5)
                SliderCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SliderCircle.Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0)
                SliderCircle.Size = UDim2.new(0, 14, 0, 14)
                SliderCircle.ZIndex = 2
                SliderCircle.Parent = SliderBar
                
                local SliderCircleCorner = Instance.new("UICorner")
                SliderCircleCorner.CornerRadius = UDim.new(1, 0)
                SliderCircleCorner.Parent = SliderCircle
                
                -- Click and drag functionality
                local SliderButton = Instance.new("TextButton")
                SliderButton.Name = "SliderButton"
                SliderButton.BackgroundTransparency = 1
                SliderButton.Position = UDim2.new(0, 0, 0, 0)
                SliderButton.Size = UDim2.new(1, 0, 1, 0)
                SliderButton.Font = Enum.Font.SourceSans
                SliderButton.Text = ""
                SliderButton.TextColor3 = Color3.fromRGB(0, 0, 0)
                SliderButton.TextSize = 14
                SliderButton.ZIndex = 3
                SliderButton.Parent = Slider
                
                local function updateSlider(input)
                    local sizeX = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    TweenService:Create(SliderFill, TweenInfo.new(0.1), {
                        Size = UDim2.new(sizeX, 0, 1, 0)
                    }):Play()
                    TweenService:Create(SliderCircle, TweenInfo.new(0.1), {
                        Position = UDim2.new(sizeX, 0, 0.5, 0)
                    }):Play()
                    
                    local value = min + ((max - min) * sizeX)
                    local roundedValue = math.floor(value / precision + 0.5) * precision
                    roundedValue = math.clamp(roundedValue, min, max)
                    
                    SliderValue.Text = tostring(roundedValue)
                    sliderValue = roundedValue
                    callback(roundedValue)
                end
                
                SliderButton.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        updateSlider(input)
                        local dragging = true
                        
                        input.Changed:Connect(function()
                            if input.UserInputState == Enum.UserInputState.End then
                                dragging = false
                            end
                        end)
                        
                        while dragging and RunService.RenderStepped:Wait() do
                            updateSlider(input)
                        end
                    end
                end)
                
                -- Slider API
                local sliderApi = {}
                
                function sliderApi:Set(value)
                    value = math.clamp(value, min, max)
                    sliderValue = value
                    local sizeX = (value - min) / (max - min)
                    
                    TweenService:Create(SliderFill, TweenInfo.new(0.1), {
                        Size = UDim2.new(sizeX, 0, 1, 0)
                    }):Play()
                    
                    TweenService:Create(SliderCircle, TweenInfo.new(0.1), {
                        Position = UDim2.new(sizeX, 0, 0.5, 0)
                    }):Play()
                    
                    SliderValue.Text = tostring(value)
                    callback(value)
                end
                
                function sliderApi:Get()
                    return sliderValue
                end
                
                return sliderApi
            end
            
            -- Dropdown element
            function section:AddDropdown(dropdownName, options, default, callback)
                options = options or {}
                callback = callback or function() end
                
                local selectedOption = default or options[1] or ""
                local dropdownOpen = false
                
                local Dropdown = Instance.new("Frame")
                Dropdown.Name = dropdownName .. "Dropdown"
                Dropdown.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                Dropdown.ClipsDescendants = true
                Dropdown.Size = UDim2.new(1, 0, 0, 35)
                Dropdown.Parent = SectionContent
                
                local DropdownCorner = Instance.new("UICorner")
                DropdownCorner.CornerRadius = UDim.new(0, 6)
                DropdownCorner.Parent = Dropdown
                
                local DropdownButton = Instance.new("TextButton")
                DropdownButton.Name = "DropdownButton"
                DropdownButton.BackgroundTransparency = 1
                DropdownButton.Size = UDim2.new(1, 0, 0, 35)
                DropdownButton.Font = Enum.Font.GothamSemibold
                DropdownButton.Text = ""
                DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                DropdownButton.TextSize = 14
                DropdownButton.Parent = Dropdown
                
                local DropdownLabel = Instance.new("TextLabel")
                DropdownLabel.Name = "DropdownLabel"
                DropdownLabel.BackgroundTransparency = 1
                DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
                DropdownLabel.Size = UDim2.new(1, -40, 0, 35)
                DropdownLabel.Font = Enum.Font.GothamSemibold
                DropdownLabel.Text = dropdownName
                DropdownLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                DropdownLabel.TextSize = 14
                DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
                DropdownLabel.Parent = Dropdown
                
                local DropdownSelected = Instance.new("TextLabel")
                DropdownSelected.Name = "DropdownSelected"
                DropdownSelected.BackgroundTransparency = 1
                DropdownSelected.Position = UDim2.new(0, 10, 0, 35)
                DropdownSelected.Size = UDim2.new(1, -40, 0, 20)
                DropdownSelected.Font = Enum.Font.Gotham
                DropdownSelected.Text = selectedOption
                DropdownSelected.TextColor3 = Color3.fromRGB(200, 200, 200)
                DropdownSelected.TextSize = 13
                DropdownSelected.TextXAlignment = Enum.TextXAlignment.Left
                DropdownSelected.Parent = Dropdown
                
                local DropdownIcon = Instance.new("ImageLabel")
                DropdownIcon.Name = "DropdownIcon"
                DropdownIcon.BackgroundTransparency = 1
                DropdownIcon.Position = UDim2.new(1, -30, 0, 8)
                DropdownIcon.Rotation = 90
                DropdownIcon.Size = UDim2.new(0, 20, 0, 20)
                DropdownIcon.Image = "rbxassetid://6031091004"
                DropdownIcon.Parent = Dropdown
                
                local OptionContainer = Instance.new("Frame")
                OptionContainer.Name = "OptionContainer"
                OptionContainer.BackgroundTransparency = 1
                OptionContainer.Position = UDim2.new(0, 0, 0, 60)
                OptionContainer.Size = UDim2.new(1, 0, 0, 0)
                OptionContainer.Parent = Dropdown
                
                local OptionList = Instance.new("UIListLayout")
                OptionList.Name = "OptionList"
                OptionList.SortOrder = Enum.SortOrder.LayoutOrder
                OptionList.Parent = OptionContainer
                
                -- Create option buttons
                local optionButtons = {}
                
                local function updateDropdown()
                    DropdownSelected.Text = selectedOption
                    
                    if dropdownOpen then
                        TweenService:Create(Dropdown, TweenInfo.new(0.2), {
                            Size = UDim2.new(1, 0, 0, 60 + #options * 25)
                        }):Play()
                        TweenService:Create(DropdownIcon, TweenInfo.new(0.2), {
                            Rotation = 270
                        }):Play()
                    else
                        TweenService:Create(Dropdown, TweenInfo.new(0.2), {
                            Size = UDim2.new(1, 0, 0, 60)
                        }):Play()
                        TweenService:Create(DropdownIcon, TweenInfo.new(0.2), {
                            Rotation = 90
                        }):Play()
                    end
                    
                    for i, button in ipairs(optionButtons) do
                        if button.Text == selectedOption then
                            button.TextColor3 = color
                        else
                            button.TextColor3 = Color3.fromRGB(200, 200, 200)
                        end
                    end
                end
                
                for i, option in ipairs(options) do
                    local OptionButton = Instance.new("TextButton")
                    OptionButton.Name = "Option_" .. option
                    OptionButton.BackgroundTransparency = 1
                    OptionButton.Size = UDim2.new(1, 0, 0, 25)
                    OptionButton.Font = Enum.Font.Gotham
                    OptionButton.Text = option
                    OptionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
                    OptionButton.TextSize = 13
                    OptionButton.Parent = OptionContainer
                    
                    table.insert(optionButtons, OptionButton)
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        selectedOption = option
                        dropdownOpen = false
                        updateDropdown()
                        callback(selectedOption)
                    end)
                    
                    OptionButton.MouseEnter:Connect(function()
                        if OptionButton.Text ~= selectedOption then
                            TweenService:Create(OptionButton, TweenInfo.new(0.1), {
                                TextColor3 = Color3.fromRGB(255, 255, 255)
                            }):Play()
                        end
                    end)
                    
                    OptionButton.MouseLeave:Connect(function()
                        if OptionButton.Text ~= selectedOption then
                            TweenService:Create(OptionButton, TweenInfo.new(0.1), {
                                TextColor3 = Color3.fromRGB(200, 200, 200)
                            }):Play()
                        end
                    end)
                end
                
                -- Size the initial dropdown
                Dropdown.Size = UDim2.new(1, 0, 0, 60)
                
                DropdownButton.MouseButton1Click:Connect(function()
                    dropdownOpen = not dropdownOpen
                    updateDropdown()
                end)
                
                -- Dropdown API
                local dropdownApi = {}
                
                function dropdownApi:Set(option)
                    if table.find(options, option) then
                        selectedOption = option
                        updateDropdown()
                        callback(selectedOption)
                    end
                end
                
                function dropdownApi:Get()
                    return selectedOption
                end
                
                function dropdownApi:Refresh(newOptions, keepSelection)
                    options = newOptions or {}
                    
                    -- Clear old options
                    for _, button in ipairs(optionButtons) do
                        button:Destroy()
                    end
                    optionButtons = {}
                    
                    -- Update selection if needed
                    if not keepSelection or not table.find(options, selectedOption) then
                        selectedOption = options[1] or ""
                    end
                    
                    -- Recreate option buttons
                    for i, option in ipairs(options) do
                        local OptionButton = Instance.new("TextButton")
                        OptionButton.Name = "Option_" .. option
                        OptionButton.BackgroundTransparency = 1
                        OptionButton.Size = UDim2.new(1, 0, 0, 25)
                        OptionButton.Font = Enum.Font.Gotham
                        OptionButton.Text = option
                        OptionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
                        OptionButton.TextSize = 13
                        OptionButton.Parent = OptionContainer
                        
                        table.insert(optionButtons, OptionButton)
                        
                        OptionButton.MouseButton1Click:Connect(function()
                            selectedOption = option
                            dropdownOpen = false
                            updateDropdown()
                            callback(selectedOption)
                        end)
                        
                        OptionButton.MouseEnter:Connect(function()
                            if OptionButton.Text ~= selectedOption then
                                TweenService:Create(OptionButton, TweenInfo.new(0.1), {
                                    TextColor3 = Color3.fromRGB(255, 255, 255)
                                }):Play()
                            end
                        end)
                        
                        OptionButton.MouseLeave:Connect(function()
                            if OptionButton.Text ~= selectedOption then
                                TweenService:Create(OptionButton, TweenInfo.new(0.1), {
                                    TextColor3 = Color3.fromRGB(200, 200, 200)
                                }):Play()
                            end
                        end)
                    end
                    
                    dropdownOpen = false
                    updateDropdown()
                end
                
                updateDropdown()
                return dropdownApi
            end
            
            -- Keybind element
            function section:AddKeybind(keybindName, default, callback)
                default = default or Enum.KeyCode.Unknown
                callback = callback or function() end
                
                local currentKey = default
                local keyChanging = false
                
                local Keybind = Instance.new("Frame")
                Keybind.Name = keybindName .. "Keybind"
                Keybind.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                Keybind.Size = UDim2.new(1, 0, 0, 35)
                Keybind.Parent = SectionContent
                
                local KeybindCorner = Instance.new("UICorner")
                KeybindCorner.CornerRadius = UDim.new(0, 6)
                KeybindCorner.Parent = Keybind
                
                local KeybindLabel = Instance.new("TextLabel")
                KeybindLabel.Name = "KeybindLabel"
                KeybindLabel.BackgroundTransparency = 1
                KeybindLabel.Position = UDim2.new(0, 10, 0, 0)
                KeybindLabel.Size = UDim2.new(1, -130, 1, 0)
                KeybindLabel.Font = Enum.Font.GothamSemibold
                KeybindLabel.Text = keybindName
                KeybindLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                KeybindLabel.TextSize = 14
                KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
                KeybindLabel.Parent = Keybind
                
                local KeybindButton = Instance.new("TextButton")
                KeybindButton.Name = "KeybindButton"
                KeybindButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
                KeybindButton.Position = UDim2.new(1, -120, 0.5, -15)
                KeybindButton.Size = UDim2.new(0, 110, 0, 30)
                KeybindButton.Font = Enum.Font.GothamSemibold
                KeybindButton.Text = default.Name
                KeybindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                KeybindButton.TextSize = 14
                KeybindButton.Parent = Keybind
                
                local KeybindButtonCorner = Instance.new("UICorner")
                KeybindButtonCorner.CornerRadius = UDim.new(0, 6)
                KeybindButtonCorner.Parent = KeybindButton
                
                -- Button hover effect
                KeybindButton.MouseEnter:Connect(function()
                    if not keyChanging then
                        TweenService:Create(KeybindButton, TweenInfo.new(0.2), {
                            BackgroundColor3 = Color3.fromRGB(65, 65, 65)
                        }):Play()
                    end
                end)
                
                KeybindButton.MouseLeave:Connect(function()
                    if not keyChanging then
                        TweenService:Create(KeybindButton, TweenInfo.new(0.2), {
                            BackgroundColor3 = Color3.fromRGB(55, 55, 55)
                        }):Play()
                    end
                end)
                
                -- Keybind functionality
                KeybindButton.MouseButton1Click:Connect(function()
                    if not keyChanging then
                        keyChanging = true
                        KeybindButton.Text = "..."
                        TweenService:Create(KeybindButton, TweenInfo.new(0.2), {
                            BackgroundColor3 = color
                        }):Play()
                    end
                end)
                
                UserInputService.InputBegan:Connect(function(input, processed)
                    if keyChanging and input.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = input.KeyCode
                        KeybindButton.Text = input.KeyCode.Name
                        keyChanging = false
                        TweenService:Create(KeybindButton, TweenInfo.new(0.2), {
                            BackgroundColor3 = Color3.fromRGB(55, 55, 55)
                        }):Play()
                        
                    elseif not processed and input.KeyCode == currentKey then
                        callback(currentKey)
                    end
                end)
                
                -- Keybind API
                local keybindApi = {}
                
                function keybindApi:Set(key)
                    if typeof(key) == "EnumItem" then
                        currentKey = key
                        KeybindButton.Text = key.Name
                    end
                end
                
                function keybindApi:Get()
                    return currentKey
                end
                
                return keybindApi
            end
            
            -- ColorPicker element
            function section:AddColorPicker(colorpickerName, default, callback)
                default = default or Color3.fromRGB(255, 255, 255)
                callback = callback or function() end
                
                local currentColor = default
                local colorPickerOpen = false
                
                local ColorPicker = Instance.new("Frame")
                ColorPicker.Name = colorpickerName .. "ColorPicker"
                ColorPicker.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                ColorPicker.ClipsDescendants = true
                ColorPicker.Size = UDim2.new(1, 0, 0, 35)
                ColorPicker.Parent = SectionContent
                
                local ColorPickerCorner = Instance.new("UICorner")
                ColorPickerCorner.CornerRadius = UDim.new(0, 6)
                ColorPickerCorner.Parent = ColorPicker
                
                local ColorPickerLabel = Instance.new("TextLabel")
                ColorPickerLabel.Name = "ColorPickerLabel"
                ColorPickerLabel.BackgroundTransparency = 1
                ColorPickerLabel.Position = UDim2.new(0, 10, 0, 0)
                ColorPickerLabel.Size = UDim2.new(1, -60, 1, 0)
                ColorPickerLabel.Font = Enum.Font.GothamSemibold
                ColorPickerLabel.Text = colorpickerName
                ColorPickerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                ColorPickerLabel.TextSize = 14
                ColorPickerLabel.TextXAlignment = Enum.TextXAlignment.Left
                ColorPickerLabel.Parent = ColorPicker
                
                local ColorDisplay = Instance.new("Frame")
                ColorDisplay.Name = "ColorDisplay"
                ColorDisplay.BackgroundColor3 = default
                ColorDisplay.Position = UDim2.new(1, -50, 0.5, -15)
                ColorDisplay.Size = UDim2.new(0, 40, 0, 30)
                ColorDisplay.Parent = ColorPicker
                
                local ColorDisplayCorner = Instance.new("UICorner")
                ColorDisplayCorner.CornerRadius = UDim.new(0, 6)
                ColorDisplayCorner.Parent = ColorDisplay
                
                local ColorPickerButton = Instance.new("TextButton")
                ColorPickerButton.Name = "ColorPickerButton"
                ColorPickerButton.BackgroundTransparency = 1
                ColorPickerButton.Size = UDim2.new(1, 0, 0, 35)
                ColorPickerButton.Font = Enum.Font.SourceSans
                ColorPickerButton.Text = ""
                ColorPickerButton.TextColor3 = Color3.fromRGB(0, 0, 0)
                ColorPickerButton.TextSize = 14
                ColorPickerButton.Parent = ColorPicker
                
                -- Create color picker UI
                local ColorPickerFrame = Instance.new("Frame")
                ColorPickerFrame.Name = "ColorPickerFrame"
                ColorPickerFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                ColorPickerFrame.Position = UDim2.new(0, 0, 0, 40)
                ColorPickerFrame.Size = UDim2.new(1, 0, 0, 130)
                ColorPickerFrame.Visible = false
                ColorPickerFrame.Parent = ColorPicker
                
                local ColorPickerFrameCorner = Instance.new("UICorner")
                ColorPickerFrameCorner.CornerRadius = UDim.new(0, 6)
                ColorPickerFrameCorner.Parent = ColorPickerFrame
                
                -- Color picker main gradient
                local ColorGradient = Instance.new("ImageLabel")
                ColorGradient.Name = "ColorGradient"
                ColorGradient.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                ColorGradient.Position = UDim2.new(0, 10, 0, 10)
                ColorGradient.Size = UDim2.new(1, -60, 0, 80)
                ColorGradient.Image = "rbxassetid://4155801252"
                ColorGradient.Parent = ColorPickerFrame
                
                local ColorGradientCorner = Instance.new("UICorner")
                ColorGradientCorner.CornerRadius = UDim.new(0, 6)
                ColorGradientCorner.Parent = ColorGradient
                
                -- Hue slider
                local HueSlider = Instance.new("ImageLabel")
                HueSlider.Name = "HueSlider"
                HueSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                HueSlider.Position = UDim2.new(1, -40, 0, 10)
                HueSlider.Size = UDim2.new(0, 20, 0, 80)
                HueSlider.Image = "rbxassetid://3641079629"
                HueSlider.Parent = ColorPickerFrame
                
                local HueSliderCorner = Instance.new("UICorner")
                HueSliderCorner.CornerRadius = UDim.new(0, 6)
                HueSliderCorner.Parent = HueSlider
                
                -- RGB fields
                local RGBField = Instance.new("Frame")
                RGBField.Name = "RGBField"
                RGBField.BackgroundTransparency = 1
                RGBField.Position = UDim2.new(0, 10, 0, 95)
                RGBField.Size = UDim2.new(1, -20, 0, 25)
                RGBField.Parent = ColorPickerFrame
                
                local RField = Instance.new("TextBox")
                RField.Name = "RField"
                RField.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                RField.Size = UDim2.new(0, 50, 0, 25)
                RField.Font = Enum.Font.Gotham
                RField.PlaceholderText = "R"
                RField.Text = tostring(math.floor(default.R * 255))
                RField.TextColor3 = Color3.fromRGB(255, 255, 255)
                RField.TextSize = 14
                RField.Parent = RGBField
                
                local RFieldCorner = Instance.new("UICorner")
                RFieldCorner.CornerRadius = UDim.new(0, 6)
                RFieldCorner.Parent = RField
                
                local GField = Instance.new("TextBox")
                GField.Name = "GField"
                GField.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                GField.Position = UDim2.new(0, 60, 0, 0)
                GField.Size = UDim2.new(0, 50, 0, 25)
                GField.Font = Enum.Font.Gotham
                GField.PlaceholderText = "G"
                GField.Text = tostring(math.floor(default.G * 255))
                GField.TextColor3 = Color3.fromRGB(255, 255, 255)
                GField.TextSize = 14
                GField.Parent = RGBField
                
                local GFieldCorner = Instance.new("UICorner")
                GFieldCorner.CornerRadius = UDim.new(0, 6)
                GFieldCorner.Parent = GField
                
                local BField = Instance.new("TextBox")
                BField.Name = "BField"
                BField.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                BField.Position = UDim2.new(0, 120, 0, 0)
                BField.Size = UDim2.new(0, 50, 0, 25)
                BField.Font = Enum.Font.Gotham
                BField.PlaceholderText = "B"
                BField.Text = tostring(math.floor(default.B * 255))
                BField.TextColor3 = Color3.fromRGB(255, 255, 255)
                BField.TextSize = 14
                BField.Parent = RGBField
                
                local BFieldCorner = Instance.new("UICorner")
                BFieldCorner.CornerRadius = UDim.new(0, 6)
                BFieldCorner.Parent = BField
                
                local function updateColorDisplay()
                    ColorDisplay.BackgroundColor3 = currentColor
                    callback(currentColor)
                    
                    -- Update RGB fields
                    RField.Text = tostring(math.floor(currentColor.R * 255))
                    GField.Text = tostring(math.floor(currentColor.G * 255))
                    BField.Text = tostring(math.floor(currentColor.B * 255))
                end
                
                -- Color picker functionality
                local function updateColor(hue, sat, val)
                    currentColor = Color3.fromHSV(hue, sat, val)
                    updateColorDisplay()
                end
                
                -- Colorpicker interactions
                local hueConnection
                local gradientConnection
                
                local function onInputEnded()
                    if hueConnection then
                        hueConnection:Disconnect()
                        hueConnection = nil
                    end
                    
                    if gradientConnection then
                        gradientConnection:Disconnect()
                        gradientConnection = nil
                    end
                end
                
                -- Hue slider interaction
                HueSlider.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        if hueConnection then
                            hueConnection:Disconnect()
                        end
                        
                        hueConnection = RunService.RenderStepped:Connect(function()
                            local mouseY = UserInputService:GetMouseLocation().Y
                            local hueY = math.clamp((mouseY - HueSlider.AbsolutePosition.Y) / HueSlider.AbsoluteSize.Y, 0, 1)
                            local hue = 1 - hueY
                            
                            ColorGradient.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                            local h, s, v = Color3.toHSV(currentColor)
                            updateColor(hue, s, v)
                        end)
                    end
                end)
                
                -- Color gradient interaction
                ColorGradient.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        if gradientConnection then
                            gradientConnection:Disconnect()
                        end
                        
                        gradientConnection = RunService.RenderStepped:Connect(function()
                            local mouse = UserInputService:GetMouseLocation()
                            local satX = math.clamp((mouse.X - ColorGradient.AbsolutePosition.X) / ColorGradient.AbsoluteSize.X, 0, 1)
                            local valY = math.clamp((mouse.Y - ColorGradient.AbsolutePosition.Y) / ColorGradient.AbsoluteSize.Y, 0, 1)
                            
                            local h = Color3.toHSV(ColorGradient.BackgroundColor3)
                            updateColor(h, satX, 1 - valY)
                        end)
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        onInputEnded()
                    end
                end)
                
                -- RGB field input
                local function updateFromRGB()
                    local r = tonumber(RField.Text) or 0
                    local g = tonumber(GField.Text) or 0
                    local b = tonumber(BField.Text) or 0
                    
                    r = math.clamp(r, 0, 255) / 255
                    g = math.clamp(g, 0, 255) / 255
                    b = math.clamp(b, 0, 255) / 255
                    
                    currentColor = Color3.new(r, g, b)
                    local h, s, v = Color3.toHSV(currentColor)
                    ColorGradient.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    
                    updateColorDisplay()
                end
                
                RField.FocusLost:Connect(updateFromRGB)
                GField.FocusLost:Connect(updateFromRGB)
                BField.FocusLost:Connect(updateFromRGB)
                
                -- Toggle color picker
                ColorPickerButton.MouseButton1Click:Connect(function()
                    colorPickerOpen = not colorPickerOpen
                    
                    if colorPickerOpen then
                        TweenService:Create(ColorPicker, TweenInfo.new(0.2), {
                            Size = UDim2.new(1, 0, 0, 175)
                        }):Play()
                        ColorPickerFrame.Visible = true
                    else
                        TweenService:Create(ColorPicker, TweenInfo.new(0.2), {
                            Size = UDim2.new(1, 0, 0, 35)
                        }):Play()
                        ColorPickerFrame.Visible = false
                    end
                end)
                
                -- ColorPicker API
                local colorPickerApi = {}
                
                function colorPickerApi:Set(color)
                    currentColor = color
                    local h, s, v = Color3.toHSV(color)
                    ColorGradient.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    updateColorDisplay()
                end
                
                function colorPickerApi:Get()
                    return currentColor
                end
                
                return colorPickerApi
            end
            
            -- Label element
            function section:AddLabel(labelText)
                local Label = Instance.new("TextLabel")
                Label.Name = "Label"
                Label.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                Label.Size = UDim2.new(1, 0, 0, 30)
                Label.Font = Enum.Font.GothamSemibold
                Label.Text = labelText
                Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                Label.TextSize = 14
                Label.Parent = SectionContent
                
                local LabelCorner = Instance.new("UICorner")
                LabelCorner.CornerRadius = UDim.new(0, 6)
                LabelCorner.Parent = Label
                
                -- Label API
                local labelApi = {}
                
                function labelApi:Set(text)
                    Label.Text = text
                end
                
                function labelApi:Get()
                    return Label.Text
                end
                
                return labelApi
            end
            
            -- Textbox element
            function section:AddTextbox(textboxName, defaultText, placeholder, callback)
                defaultText = defaultText or ""
                placeholder = placeholder or "Enter text..."
                callback = callback or function() end
                
                local Textbox = Instance.new("Frame")
                Textbox.Name = textboxName .. "Textbox"
                Textbox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                Textbox.Size = UDim2.new(1, 0, 0, 35)
                Textbox.Parent = SectionContent
                
                local TextboxCorner = Instance.new("UICorner")
                TextboxCorner.CornerRadius = UDim.new(0, 6)
                TextboxCorner.Parent = Textbox
                
                local TextboxLabel = Instance.new("TextLabel")
                TextboxLabel.Name = "TextboxLabel"
                TextboxLabel.BackgroundTransparency = 1
                TextboxLabel.Position = UDim2.new(0, 10, 0, 0)
                TextboxLabel.Size = UDim2.new(0, 200, 1, 0)
                TextboxLabel.Font = Enum.Font.GothamSemibold
                TextboxLabel.Text = textboxName
                TextboxLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextboxLabel.TextSize = 14
                TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
                TextboxLabel.Parent = Textbox
                
                local TextboxField = Instance.new("TextBox")
                TextboxField.Name = "TextboxField"
                TextboxField.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
                TextboxField.Position = UDim2.new(1, -160, 0.5, -15)
                TextboxField.Size = UDim2.new(0, 150, 0, 30)
                TextboxField.Font = Enum.Font.Gotham
                TextboxField.PlaceholderText = placeholder
                TextboxField.Text = defaultText
                TextboxField.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextboxField.TextSize = 14
                TextboxField.TextTruncate = Enum.TextTruncate.AtEnd
                TextboxField.ClearTextOnFocus = false
                TextboxField.Parent = Textbox
                
                local TextboxFieldCorner = Instance.new("UICorner")
                TextboxFieldCorner.CornerRadius = UDim.new(0, 6)
                TextboxFieldCorner.Parent = TextboxField
                
                TextboxField.FocusLost:Connect(function(enterPressed)
                    callback(TextboxField.Text, enterPressed)
                end)
                
                -- Textbox API
                local textboxApi = {}
                
                function textboxApi:Set(text)
                    TextboxField.Text = text
                    callback(text, false)
                end
                
                function textboxApi:Get()
                    return TextboxField.Text
                end
                
                return textboxApi
            end
            
            return section
        end
        
        return tab
    end
    
    -- Set keybind
    function Rise6Window:SetKeybind(keybind)
        if isMobile then return end -- Skip keybind for mobile
        
        local keyCode = keybind or Enum.KeyCode.RightShift
        local toggled = false
        
        UserInputService.InputBegan:Connect(function(input, processed)
            if not processed and input.KeyCode == keyCode then
                toggled = not toggled
                MainFrame.Visible = toggled
            end
        end)
    end
    
    -- Set library theme color
    function Rise6Window:SetThemeColor(newColor)
        color = newColor
    end
    
    return Rise6Window
end

return RiseLib
