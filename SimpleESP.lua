-- ESP + Botão móvel com "ESP TEST" (layout fixo e funcional)
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Proteção contra múltiplas execuções
if CoreGui:FindFirstChild("ESP_UI") then CoreGui.ESP_UI:Destroy() end

-- Criar UI
local screenGui = Instance.new("ScreenGui", CoreGui)
screenGui.Name = "ESP_UI"
screenGui.ResetOnSpawn = false

-- Frame arrastável
local dragFrame = Instance.new("Frame", screenGui)
dragFrame.Size = UDim2.new(0, 160, 0, 60)
dragFrame.Position = UDim2.new(0, 100, 0, 100)
dragFrame.BackgroundColor3 = Color3.fromRGB(60, 0, 90)
dragFrame.BackgroundTransparency = 0.25
dragFrame.Active = true
dragFrame.Draggable = true
dragFrame.BorderSizePixel = 0

-- Label "ESP TEST"
local title = Instance.new("TextLabel", dragFrame)
title.Size = UDim2.new(1, 0, 0.4, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "ESP TEST"
title.TextColor3 = Color3.fromRGB(200, 200, 255)
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true

-- Botão ligar/desligar
local button = Instance.new("TextButton", dragFrame)
button.Size = UDim2.new(0.9, 0, 0.4, 0)
button.Position = UDim2.new(0.05, 0, 0.5, 0)
button.BackgroundColor3 = Color3.fromRGB(120, 0, 170)
button.Text = "Ativar ESP"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.GothamBold
button.TextScaled = true
button.BorderSizePixel = 0
button.AutoButtonColor = true

-- ESP Core
local ESP_Enabled = false
local highlights = {}

local function applyESP(player)
    if player ~= LocalPlayer and player.Character and not highlights[player] then
        local highlight = Instance.new("Highlight", player.Character)
        highlight.FillColor = Color3.fromRGB(255, 0, 255)
        highlight.OutlineColor = Color3.new(1, 1, 1)
        highlight.FillTransparency = 0.6
        highlight.OutlineTransparency = 0.2
        highlights[player] = highlight
    end
end

local function removeESP(player)
    if highlights[player] then
        highlights[player]:Destroy()
        highlights[player] = nil
    end
end

local function toggleESP()
    ESP_Enabled = not ESP_Enabled
    button.Text = ESP_Enabled and "Desativar ESP" or "Ativar ESP"

    for _, player in ipairs(Players:GetPlayers()) do
        if ESP_Enabled then
            applyESP(player)
        else
            removeESP(player)
        end
    end
end

-- Eventos
button.MouseButton1Click:Connect(toggleESP)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if ESP_Enabled then
            wait(1)
            applyESP(player)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

RunService.RenderStepped:Connect(function()
    if ESP_Enabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character and not highlights[player] then
                applyESP(player)
            end
        end
    end
end)
