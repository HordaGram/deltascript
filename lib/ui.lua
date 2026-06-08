local UILib = {}

function UILib:CreateWindow(titleText)
    local CoreGui = game:GetService("CoreGui")
    if CoreGui:FindFirstChild("LiquidGlassUI") then
        CoreGui.LiquidGlassUI:Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LiquidGlassUI"
    screenGui.Parent = (gethui and gethui()) or CoreGui

    -- Плавающая кнопка
    local floatBtn = Instance.new("TextButton", screenGui)
    floatBtn.Size = UDim2.new(0, 50, 0, 50)
    floatBtn.Position = UDim2.new(0.05, 0, 0.5, 0)
    floatBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    floatBtn.BackgroundTransparency = 0.3
    floatBtn.Text = "🔮"
    floatBtn.TextScaled = true
    Instance.new("UICorner", floatBtn).CornerRadius = UDim.new(1, 0)
    local stroke1 = Instance.new("UIStroke", floatBtn)
    stroke1.Color = Color3.fromRGB(100, 100, 100)
    stroke1.Thickness = 1.5
    stroke1.Transparency = 0.4

    -- Главное меню (Жидкое стекло)
    local menuFrame = Instance.new("Frame", screenGui)
    menuFrame.Size = UDim2.new(0, 300, 0, 350)
    menuFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
    menuFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    menuFrame.BackgroundTransparency = 0.45
    menuFrame.Visible = false
    Instance.new("UICorner", menuFrame).CornerRadius = UDim.new(0, 12)
    local stroke2 = Instance.new("UIStroke", menuFrame)
    stroke2.Color = Color3.fromRGB(255, 255, 255)
    stroke2.Transparency = 0.85

    -- Заголовок
    local title = Instance.new("TextLabel", menuFrame)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundTransparency = 1
    title.Text = titleText
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16

    -- Контейнер для кнопок
    local container = Instance.new("ScrollingFrame", menuFrame)
    container.Size = UDim2.new(1, -20, 1, -50)
    container.Position = UDim2.new(0, 10, 0, 40)
    container.BackgroundTransparency = 1
    container.ScrollBarThickness = 2
    
    local layout = Instance.new("UIListLayout", container)
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Логика кнопки
    floatBtn.MouseButton1Click:Connect(function()
        menuFrame.Visible = not menuFrame.Visible
    end)

    -- Простая драгалка (перемещение)
    local function makeDraggable(obj)
        local UserInputService = game:GetService("UserInputService")
        local dragging, dragStart, startPos
        obj.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true dragStart = input.Position startPos = obj.Position
            end
        end)
        obj.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end
    makeDraggable(floatBtn)
    makeDraggable(menuFrame)

    local WindowObj = {Container = container}

    -- Функция добавления кнопок
    function WindowObj:AddButton(text, callback)
        local btn = Instance.new("TextButton", self.Container)
        btn.Size = UDim2.new(1, 0, 0, 35)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        btn.BackgroundTransparency = 0.5
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 14
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        
        btn.MouseButton1Click:Connect(function()
            callback()
        end)
    end

    return WindowObj
end

return UILib
