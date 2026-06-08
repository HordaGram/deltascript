-- Указываем базовую ссылку на твой репозиторий (Raw)
local repo = "https://raw.githubusercontent.com/HordaGram/deltascript/main/"

-- Функция для удобной загрузки модулей
local function loadModule(path)
    return loadstring(game:HttpGet(repo .. path))()
end

-- 1. Загружаем наши модули
local UILib = loadModule("lib/ui.lua")
local ESP = loadModule("features/esp.lua")
local Combat = loadModule("features/combat.lua")

-- 2. Создаем интерфейс
local window = UILib:CreateWindow("FLUXO PVP HUB")

-- 3. Добавляем кнопки в меню, которые обращаются к модулям
window:AddButton("Включить / Выключить ESP", function()
    local state = ESP:Toggle()
    if state then
        print("ВХ включено")
    end
end)

window:AddButton("Увеличить Хитбоксы", function()
    local state = Combat:ToggleHitboxes(15) -- 15 - это размер хитбокса
    if state then
        print("Хитбоксы увеличены")
    end
end)

-- Простая кнопка без модуля, просто для примера
window:AddButton("Максимальная скорость", function()
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 100
    end
end)
