local ESP = {}
local espEnabled = false

function ESP:Toggle()
    espEnabled = not espEnabled
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    if espEnabled then
        -- Включаем
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hl = Instance.new("Highlight")
                hl.Name = "MyESP"
                hl.FillColor = Color3.fromRGB(255, 0, 0)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.5
                hl.Parent = player.Character
            end
        end
    else
        -- Выключаем
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("MyESP") then
                player.Character.MyESP:Destroy()
            end
        end
    end
    return espEnabled
end

return ESP
