--[[
    Command Center UI Library
    Themed after modern dashboard designs.
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function getGuiParent()
    local success, parent = pcall(function()
        return CoreGui
    end)
    if success and parent then
        return parent
    end
    return LocalPlayer:WaitForChild("PlayerGui")
end


local Library = {
    Theme = {
        MainBackground = Color3.fromRGB(11, 14, 20),
        SidebarBackground = Color3.fromRGB(15, 18, 26),
        HeaderBackground = Color3.fromRGB(13, 16, 23),
        AccentColor = Color3.fromRGB(59, 130, 246),
        TextColor = Color3.fromRGB(255, 255, 255),
        SubTextColor = Color3.fromRGB(160, 160, 160),
        CardBackground = Color3.fromRGB(20, 24, 32),
        OutlineColor = Color3.fromRGB(30, 35, 45),
        SuccessColor = Color3.fromRGB(16, 185, 129),
        WarningColor = Color3.fromRGB(245, 158, 11),
        Font = Enum.Font.Builder,
    },
    Notifications = {},
    Components = {}
}

-- Utility for Notifications
function Library:Notify(title, content, duration)
    local NotificationFrame = Instance.new("Frame")
    NotificationFrame.Name = "Notification"
    NotificationFrame.Size = UDim2.fromOffset(250, 80)
    NotificationFrame.Position = UDim2.new(1, 20, 1, -100 - (#Library.Notifications * 90))
    NotificationFrame.BackgroundColor3 = Library.Theme.CardBackground
    NotificationFrame.Parent = getGuiParent():FindFirstChild("CommandCenter") or getGuiParent()

    local Corner = Instance.new("UICorner", NotificationFrame)
    Corner.CornerRadius = UDim.new(0, 8)
    
    local Stroke = Instance.new("UIStroke", NotificationFrame)
    Stroke.Color = Library.Theme.AccentColor
    Stroke.Thickness = 1.5

    local TitleLabel = Instance.new("TextLabel", NotificationFrame)
    TitleLabel.Text = title or "Notification"
    TitleLabel.Size = UDim2.new(1, -20, 0, 25)
    TitleLabel.Position = UDim2.fromOffset(10, 5)
    TitleLabel.TextColor3 = Library.Theme.TextColor
    TitleLabel.Font = Enum.Font.Builder
    TitleLabel.TextSize = 16
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local ContentLabel = Instance.new("TextLabel", NotificationFrame)
    ContentLabel.Text = content or ""
    ContentLabel.Size = UDim2.new(1, -20, 1, -35)
    ContentLabel.Position = UDim2.fromOffset(10, 30)
    ContentLabel.TextColor3 = Library.Theme.SubTextColor
    ContentLabel.Font = Enum.Font.Builder
    ContentLabel.TextSize = 14
    ContentLabel.BackgroundTransparency = 1
    ContentLabel.TextWrapped = true
    ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
    ContentLabel.TextYAlignment = Enum.TextYAlignment.Top

    table.insert(Library.Notifications, NotificationFrame)
    
    Library:Tween(NotificationFrame, {Position = UDim2.new(1, -270, 1, -100 - ((#Library.Notifications - 1) * 90))})

    task.delay(duration or 5, function()
        Library:Tween(NotificationFrame, {Position = UDim2.new(1, 20, 1, -100 - ((#Library.Notifications - 1) * 90))})
        task.wait(0.3)
        NotificationFrame:Destroy()
        -- Re-index notifications? For now keep it simple.
    end)
end


-- Utility for Tweens
function Library:Tween(object, data, duration, style, direction)
    local tweenInfo = TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quart, direction or Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, data)
    tween:Play()
    return tween
end

function Library:CreateWindow(title, subtitle)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CommandCenter"
    ScreenGui.Parent = getGuiParent()

    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.fromOffset(900, 560)
    MainFrame.Position = UDim2.fromScale(0.5, 0.5)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Library.Theme.MainBackground
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Library.Theme.OutlineColor
    UIStroke.Thickness = 1.2
    UIStroke.Parent = MainFrame

    -- Sidebar Container
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 70, 1, 0)
    Sidebar.BackgroundColor3 = Library.Theme.SidebarBackground
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame

    local SidebarStroke = Instance.new("UIStroke")
    SidebarStroke.Color = Library.Theme.OutlineColor
    SidebarStroke.Thickness = 1
    SidebarStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    SidebarStroke.Parent = Sidebar

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 12)
    SidebarCorner.Parent = Sidebar

    -- Logo Area
    local Logo = Instance.new("ImageLabel")
    Logo.Name = "Logo"
    Logo.Size = UDim2.fromOffset(40, 40)
    Logo.Position = UDim2.fromOffset(15, 20)
    Logo.BackgroundTransparency = 1
    Logo.Image = "rbxassetid://18228189311" -- Better logo rbxassetid or fallback

    Logo.Parent = Sidebar

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 15)
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, 0, 1, -80)
    TabContainer.Position = UDim2.fromOffset(0, 80)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = Sidebar
    UIListLayout.Parent = TabContainer

    -- Header Area
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, -70, 0, 80)
    Header.Position = UDim2.fromOffset(70, 0)
    Header.BackgroundTransparency = 1
    Header.Parent = MainFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Text = title or "Command Center"
    TitleLabel.Font = Enum.Font.Builder
    TitleLabel.TextSize = 24
    TitleLabel.TextColor3 = Library.Theme.TextColor
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Position = UDim2.fromOffset(25, 25)
    TitleLabel.Size = UDim2.fromOffset(300, 30)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = Header

    local SubtitleLabel = Instance.new("TextLabel")
    SubtitleLabel.Name = "Subtitle"
    SubtitleLabel.Text = subtitle or "Welcome, user, get ready to troll!"
    SubtitleLabel.Font = Enum.Font.Builder
    SubtitleLabel.TextSize = 14
    SubtitleLabel.TextColor3 = Library.Theme.SubTextColor
    SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubtitleLabel.Position = UDim2.fromOffset(25, 52)
    SubtitleLabel.Size = UDim2.fromOffset(400, 20)
    SubtitleLabel.BackgroundTransparency = 1
    SubtitleLabel.Parent = Header

    -- Content Area
    local Content = Instance.new("Frame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, -70, 1, -80)
    Content.Position = UDim2.fromOffset(70, 80)
    Content.BackgroundTransparency = 1
    Content.Parent = MainFrame

    local Window = {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        Content = Content,
        Tabs = {},
        ActiveTab = nil
    }

    function Window:CreateTab(name, iconId)
        local TabButton = Instance.new("ImageButton")
        TabButton.Name = name .. "Tab"
        TabButton.Size = UDim2.fromOffset(40, 40)
        TabButton.BackgroundTransparency = 1
        TabButton.Image = iconId or "rbxassetid://18228189311" -- Valid default icon

        TabButton.ImageColor3 = Library.Theme.SubTextColor
        TabButton.Parent = TabContainer

        local Glow = Instance.new("ImageLabel")
        Glow.Name = "Glow"
        Glow.Size = UDim2.fromScale(1.5, 1.5)
        Glow.Position = UDim2.fromScale(-0.25, -0.25)
        Glow.BackgroundTransparency = 1
        Glow.Image = "rbxassetid://18228189311" -- Glow fallback

        Glow.ImageColor3 = Library.Theme.AccentColor
        Glow.ImageTransparency = 1
        Glow.Parent = TabButton

        local Page = Instance.new("ScrollingFrame")
        Page.Name = name .. "Page"
        Page.Size = UDim2.fromScale(1, 1)
        Page.BackgroundTransparency = 1
        Page.BorderSizePixel = 0
        Page.ScrollBarThickness = 0
        Page.Visible = false
        Page.Parent = Content

        local PagePadding = Instance.new("UIPadding")
        PagePadding.PaddingLeft = UDim.new(0, 25)
        PagePadding.PaddingTop = UDim.new(0, 10)
        PagePadding.Parent = Page

        local PageList = Instance.new("UIListLayout")
        PageList.Padding = UDim.new(0, 20)
        PageList.SortOrder = Enum.SortOrder.LayoutOrder
        PageList.Parent = Page

        local Tab = {
            Button = TabButton,
            Page = Page
        }

        function Tab:Select()
            if Window.ActiveTab then
                Window.ActiveTab.Page.Visible = false
                Library:Tween(Window.ActiveTab.Button, {ImageColor3 = Library.Theme.SubTextColor})
                Library:Tween(Window.ActiveTab.Button.Glow, {ImageTransparency = 1})
            end
            Window.ActiveTab = Tab
            Page.Visible = true
            Library:Tween(TabButton, {ImageColor3 = Library.Theme.TextColor})
            Library:Tween(Glow, {ImageTransparency = 0.5})
        end

        TabButton.MouseButton1Click:Connect(function()
            Tab:Select()
        end)

        function Tab:CreateSection(title)
            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Name = title .. "Section"
            SectionLabel.Text = title:upper()
            SectionLabel.Font = Enum.Font.Builder
            SectionLabel.TextSize = 14
            SectionLabel.TextColor3 = Library.Theme.SubTextColor
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            SectionLabel.Size = UDim2.new(1, -50, 0, 30)
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Parent = Page

            return SectionLabel
        end

        function Tab:CreateCard(title, description, iconId)
            local Card = Instance.new("Frame")
            Card.Name = title .. "Card"
            Card.Size = UDim2.new(0, 260, 0, 100)
            Card.BackgroundColor3 = Library.Theme.CardBackground
            Card.BorderSizePixel = 0
            Card.Parent = Page

            local CardCorner = Instance.new("UICorner")
            CardCorner.CornerRadius = UDim.new(0, 10)
            CardCorner.Parent = Card

            local CardStroke = Instance.new("UIStroke")
            CardStroke.Color = Library.Theme.OutlineColor
            CardStroke.Thickness = 1
            CardStroke.Parent = Card

            local Icon = Instance.new("ImageLabel")
            Icon.Name = "Icon"
            Icon.Size = UDim2.fromOffset(24, 24)
            Icon.Position = UDim2.fromOffset(216, 15)
            Icon.BackgroundTransparency = 1
            Icon.Image = iconId or "rbxassetid://6031265976"
            Icon.ImageColor3 = Library.Theme.TextColor
            Icon.Parent = Card

            local Title = Instance.new("TextLabel")
            Title.Name = "Title"
            Title.Text = title
            Title.Font = Enum.Font.Builder
            Title.TextSize = 14
            Title.TextColor3 = Library.Theme.SubTextColor
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.Position = UDim2.fromOffset(15, 15)
            Title.Size = UDim2.fromOffset(180, 20)
            Title.BackgroundTransparency = 1
            Title.Parent = Card

            local Desc = Instance.new("TextLabel")
            Desc.Name = "Description"
            Desc.Text = description or "Value"
            Desc.Font = Enum.Font.Builder
            Desc.TextSize = 20
            Desc.TextColor3 = Library.Theme.TextColor
            Desc.TextXAlignment = Enum.TextXAlignment.Left
            Desc.Position = UDim2.fromOffset(15, 40)
            Desc.Size = UDim2.fromOffset(230, 40)
            Desc.BackgroundTransparency = 1
            Desc.TextWrapped = true
            Desc.Parent = Card

            local CardObj = {}
            function CardObj:SetDescription(val)
                Desc.Text = val
            end
            return CardObj
        end

        function Tab:CreateButton(text, callback)
            local Button = Instance.new("TextButton")
            Button.Name = text .. "Button"
            Button.Size = UDim2.new(1, -50, 0, 40)
            Button.BackgroundColor3 = Library.Theme.CardBackground
            Button.Font = Enum.Font.Builder
            Button.Text = text
            Button.TextColor3 = Library.Theme.TextColor
            Button.TextSize = 16
            Button.AutoButtonColor = false
            Button.Parent = Page

            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 8)
            ButtonCorner.Parent = Button

            local ButtonStroke = Instance.new("UIStroke")
            ButtonStroke.Color = Library.Theme.OutlineColor
            ButtonStroke.Thickness = 1
            ButtonStroke.Parent = Button

            Button.MouseEnter:Connect(function()
                Library:Tween(Button, {BackgroundColor3 = Library.Theme.MainBackground})
                Library:Tween(ButtonStroke, {Color = Library.Theme.AccentColor})
            end)

            Button.MouseLeave:Connect(function()
                Library:Tween(Button, {BackgroundColor3 = Library.Theme.CardBackground})
                Library:Tween(ButtonStroke, {Color = Library.Theme.OutlineColor})
            end)

            Button.MouseButton1Click:Connect(function()
                if callback then callback() end
                
                -- Flash effect
                local Flash = Instance.new("Frame")
                Flash.Size = UDim2.fromScale(1, 1)
                Flash.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Flash.BackgroundTransparency = 0.8
                Flash.ZIndex = Button.ZIndex + 1
                Flash.Parent = Button
                Instance.new("UICorner", Flash).CornerRadius = ButtonCorner.CornerRadius
                
                Library:Tween(Flash, {BackgroundTransparency = 1}, 0.2):Completed:Connect(function()
                    Flash:Destroy()
                end)
            end)
        end

        function Tab:CreateToggle(text, default, callback)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = text .. "Toggle"
            ToggleFrame.Size = UDim2.new(1, -50, 0, 40)
            ToggleFrame.BackgroundColor3 = Library.Theme.CardBackground
            ToggleFrame.Parent = Page

            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 8)
            ToggleCorner.Parent = ToggleFrame

            local ToggleStroke = Instance.new("UIStroke")
            ToggleStroke.Color = Library.Theme.OutlineColor
            ToggleStroke.Thickness = 1
            ToggleStroke.Parent = ToggleFrame

            local Label = Instance.new("TextLabel")
            Label.Text = text
            Label.Font = Enum.Font.Builder
            Label.TextSize = 16
            Label.TextColor3 = Library.Theme.TextColor
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Position = UDim2.fromOffset(15, 0)
            Label.Size = UDim2.new(1, -80, 1, 0)
            Label.BackgroundTransparency = 1
            Label.Parent = ToggleFrame

            local Switch = Instance.new("Frame")
            Switch.Name = "Switch"
            Switch.Size = UDim2.fromOffset(40, 22)
            Switch.Position = UDim2.new(1, -55, 0.5, 0)
            Switch.AnchorPoint = Vector2.new(0, 0.5)
            Switch.BackgroundColor3 = Library.Theme.MainBackground
            Switch.Parent = ToggleFrame

            local SwitchCorner = Instance.new("UICorner")
            SwitchCorner.CornerRadius = UDim.new(1, 0)
            SwitchCorner.Parent = Switch

            local Indicator = Instance.new("Frame")
            Indicator.Name = "Indicator"
            Indicator.Size = UDim2.fromOffset(18, 18)
            Indicator.Position = UDim2.fromOffset(2, 2)
            Indicator.BackgroundColor3 = Library.Theme.TextColor
            Indicator.Parent = Switch

            local IndicatorCorner = Instance.new("UICorner")
            IndicatorCorner.CornerRadius = UDim.new(1, 0)
            IndicatorCorner.Parent = Indicator

            local Enabled = default or false
            local function Update()
                if Enabled then
                    Library:Tween(Switch, {BackgroundColor3 = Library.Theme.AccentColor})
                    Library:Tween(Indicator, {Position = UDim2.fromOffset(20, 2)})
                else
                    Library:Tween(Switch, {BackgroundColor3 = Library.Theme.MainBackground})
                    Library:Tween(Indicator, {Position = UDim2.fromOffset(2, 2)})
                end
                if callback then callback(Enabled) end
            end

            local ClickButton = Instance.new("TextButton")
            ClickButton.Size = UDim2.fromScale(1, 1)
            ClickButton.BackgroundTransparency = 1
            ClickButton.Text = ""
            ClickButton.Parent = ToggleFrame

            ClickButton.MouseButton1Click:Connect(function()
                Enabled = not Enabled
                Update()
            end)

            Update()
        end

        function Tab:CreateStatusCard(title, subtitle, status)
            local Card = Instance.new("Frame")
            Card.Name = title .. "StatusCard"
            Card.Size = UDim2.new(0, 260, 0, 100)
            Card.BackgroundColor3 = Library.Theme.CardBackground
            Card.BorderSizePixel = 0
            Card.Parent = Page

            Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 10)
            local Stroke = Instance.new("UIStroke", Card)
            Stroke.Color = Library.Theme.OutlineColor
            Stroke.Thickness = 1

            local Icon = Instance.new("ImageLabel")
            Icon.Name = "Icon"
            Icon.Size = UDim2.fromOffset(24, 24)
            Icon.Position = UDim2.fromOffset(15, 15)
            Icon.BackgroundTransparency = 1
            Icon.Image = "rbxassetid://6031265976"
            Icon.ImageColor3 = Library.Theme.SubTextColor
            Icon.Parent = Card

            local Title = Instance.new("TextLabel")
            Title.Text = title
            Title.Font = Enum.Font.Builder
            Title.TextSize = 14
            Title.TextColor3 = Library.Theme.TextColor
            Title.TextXAlignment = Enum.TextXAlignment.Left
            Title.Position = UDim2.fromOffset(45, 15)
            Title.Size = UDim2.fromOffset(180, 20)
            Title.BackgroundTransparency = 1
            Title.Parent = Card

            local Sub = Instance.new("TextLabel")
            Sub.Text = subtitle or "Operational"
            Sub.Font = Enum.Font.Builder
            Sub.TextSize = 12
            Sub.TextColor3 = Library.Theme.SubTextColor
            Sub.TextXAlignment = Enum.TextXAlignment.Left
            Sub.Position = UDim2.fromOffset(45, 32)
            Sub.Size = UDim2.fromOffset(180, 15)
            Sub.BackgroundTransparency = 1
            Sub.Parent = Card

            local StatusDot = Instance.new("Frame")
            StatusDot.Size = UDim2.fromOffset(8, 8)
            StatusDot.Position = UDim2.fromOffset(15, 75)
            StatusDot.BackgroundColor3 = Library.Theme.SuccessColor
            StatusDot.Parent = Card
            Instance.new("UICorner", StatusDot).CornerRadius = UDim.new(1, 0)

            local StatusText = Instance.new("TextLabel")
            StatusText.Text = status or "Operational"
            StatusText.Font = Enum.Font.Builder
            StatusText.TextSize = 12
            StatusText.TextColor3 = Library.Theme.TextColor
            StatusText.TextXAlignment = Enum.TextXAlignment.Left
            StatusText.Position = UDim2.fromOffset(30, 71)
            StatusText.Size = UDim2.fromOffset(100, 15)
            StatusText.BackgroundTransparency = 1
            StatusText.Parent = Card

            local Checkmark = Instance.new("ImageLabel")
            Checkmark.Size = UDim2.fromOffset(16, 16)
            Checkmark.Position = UDim2.fromOffset(230, 71)
            Checkmark.BackgroundTransparency = 1
            Checkmark.Image = "rbxassetid://6031068433"
            Checkmark.ImageColor3 = Library.Theme.SuccessColor
            Checkmark.Parent = Card

            local StatusObj = {}
            function StatusObj:SetStatus(newStatus, color)
                StatusText.Text = newStatus
                StatusDot.BackgroundColor3 = color or Library.Theme.SuccessColor
                Checkmark.ImageColor3 = color or Library.Theme.SuccessColor
            end
            return StatusObj
        end

        if #Window.Tabs == 0 then


            Tab:Select()
        end

        table.insert(Window.Tabs, Tab)
        return Tab
    end

    return Window
end

return Library
