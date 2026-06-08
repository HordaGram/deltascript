local Combat = {}
local hitboxesExpanded = false

function Combat:ToggleHitboxes(size)
    hitboxesExpanded = not hitboxesExpanded
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            if hitboxesExpanded then
                -- Делаем хитбокс огромным (размер 15x15x15)
                hrp.Size = Vector3.new(size, size, size)
                hrp.Transparency = 0.7 -- Делаем его полупрозрачным, чтобы видеть
                hrp.BrickColor = BrickColor.new("Bright blue")
                hrp.CanCollide = false
            else
                -- Возвращаем стандартный размер
                hrp.Size = Vector3.new(2, 2, 1)
                hrp.Transparency = 1
            end
        end
    end
    return hitboxesExpanded
end

return Combat
