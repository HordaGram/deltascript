-- Защита от двойного запуска (удаляет старое меню, если оно было)
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("LiquidGlassUI") then
    CoreGui.LiquidGlassUI:Destroy()
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-----------------------------------------
-- 1. СОЗДАЕМ ИНТЕРФЕЙС (ЖИДКОЕ СТЕКЛО)
-----------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LiquidGlassUI"
screenGui.Parent = (gethui and gethui()) or CoreGui

-- Плавающая кнопка для открытия/закрытия
local floatBtn = Instance.new("TextButton", screenGui)
floatBtn.Size = UDim2.new(0, 50, 0, 50)
floatBtn.Position = UDim2.new(0.05, 0, 0.5, 0)
floatBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
floatBtn.BackgroundTransparency = 0.3
floatBtn.Text = "🔮"
floatBtn.TextScaled = true
Instance.new("UICorner", floatBtn).CornerRadius = UDim.new(1, 0)
local btnStroke = Instance.new("UIStroke", floatBtn)
btnStroke.Color = Color3.fromRGB(100, 100, 100)
btnStroke.Thickness = 1.5
btnStroke.Transparency = 0.4

-- Главное окно меню
local menuFrame = Instance.new("Frame", screenGui)
menuFrame.Size = UDim2.new(0, 300, 0, 250)
menuFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
menuFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
menuFrame.BackgroundTransparency = 0.45
menuFrame.Visible = false -- Скрыто по умолчанию
Instance.new("UICorner", menuFrame).CornerRadius = UDim.new(0, 12)
local menuStroke = Instance.new("UIStroke", menuFrame)
menuStroke.Color = Color3.fromRGB(255, 255, 255)
menuStroke.Transparency = 0.85

-- Заголовок
local title = Instance.new("TextLabel", menuFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "FLUXO HUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- Линия под заголовком
local line = Instance.new("Frame", menuFrame)
line.Size = UDim2.new(1, -20, 0, 1)
line.Position = UDim2.new(0, 10, 0, 40)
line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
line.BackgroundTransparency = 0.8

-- Контейнер для кнопок
local container = Instance.new("ScrollingFrame", menuFrame)
container.Size = UDim2.new(1, -20, 1, -50)
container.Position = UDim2.new(0, 10, 0, 45)
container.BackgroundTransparency = 1
container.ScrollBarThickness = 2
local layout = Instance.new("UIListLayout", container)
layout.Padding = UDim.new(0, 10)

-----------------------------------------
-- 2. ЛОГИКА ИНТЕРФЕЙСА (Перемещение)
-----------------------------------------
floatBtn.MouseButton1Click:Connect(function()
    menuFrame.Visible = not menuFrame.Visible
end)

local function makeDraggable(obj)
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

-----------------------------------------
-- 3. ФУНКЦИИ ЧИТА И КНОПКИ
-----------------------------------------
-- Переменные состояний (Вкл/Выкл)
local espEnabled = false
local hitboxesEnabled = false

-- Функция для создания красивых кнопок-переключателей
local function createToggleButton(name, callback)
    local btn = Instance.new("TextButton", container)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.BackgroundTransparency = 0.5
    btn.Text = name .. " [OFF]"
    btn.TextColor3 = Color3.fromRGB(200, 50, 50) -- Красный текст по умолчанию
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(function()
        local state = callback() -- Вызываем функцию и получаем новый статус (true/false)
        if state then
            btn.Text = name .. " [ON]"
            btn.TextColor3 = Color3.fromRGB(50, 200, 50) -- Зеленый текст
        else
            btn.Text = name .. " [OFF]"
            btn.TextColor3 = Color3.fromRGB(200, 50, 50) -- Красный текст
        end
    end)
end

-- КНОПКА 1: ВХ (ESP)
createToggleButton("ESP (Валлхак)", function()
    espEnabled = not espEnabled
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if espEnabled then
                if not player.Character:FindFirstChild("MyESP") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "MyESP"
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.5
                    hl.Parent = player.Character
                end
            else
                if player.Character:FindFirstChild("MyESP") then
                    player.Character.MyESP:Destroy()
                end
            end
        end
    end
    return espEnabled
end)

-- КНОПКА 2: ХИТБОКСЫ
createToggleButton("Увеличить Хитбоксы", function()
    hitboxesEnabled = not hitboxesEnabled
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            if hitboxesEnabled then
                hrp.Size = Vector3.new(15, 15, 15)
                hrp.Transparency = 0.6
                hrp.BrickColor = BrickColor.new("Bright blue")
                hrp.CanCollide = false
            else
                hrp.Size = Vector3.new(2, 2, 1)
                hrp.Transparency = 1
            end
        end
    end
    return hitboxesEnabled
end)

-- КНОПКА 3: БЫСТРЫЙ БЕГ (Просто для теста)
createToggleButton("Быстрый бег", function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        if char.Humanoid.WalkSpeed == 16 then
            char.Humanoid.WalkSpeed = 100
            return true -- Возвращаем true (ON)
        else
            char.Humanoid.WalkSpeed = 16
            return false -- Возвращаем false (OFF)
        end
    end
    return false
end)

print("Fluxo Hub Успешно запущен!")
