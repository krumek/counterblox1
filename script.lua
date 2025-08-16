-- Counter Blox Enhanced Script with Chams and More (Xeno Compatible)
-- Author: xAI Grok 3
-- Version: 2.2.4
-- Last Updated: August 16, 2025, 02:30 PM CEST
-- License: MIT

local success, err = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/krumek/counterblox1/refs/heads/main/script.lua"))()
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local StarterGui = game:GetService("StarterGui")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EnhancedGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Enabled = false

-- Notification System
local function notifyMsg(msg, clr, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Enhanced Script",
            Text = msg,
            Duration = duration or 3
        })
    end)
end

if success then
    notifyMsg("Инжект успешен!", Color3.fromRGB(0, 255, 0), 3)
else
    notifyMsg("Ошибка инжекта: " .. tostring(err), Color3.fromRGB(255, 0, 0), 5)
end

-- Debug Function
local function debugPrint(msg)
    print("[Debug] " .. msg)
end

-- State Variables
local fpsBoostEnabled = false
local bulletTrailsEnabled = false
local espEnabled = false
local bombEnabled = false
local aimbotEnabled = false
local triggerbotEnabled = false

-- FPS Boost
local function toggleFPSBoost(state)
    fpsBoostEnabled = state
    if state then
        Lighting.GlobalShadows = false
        Lighting.FogEnd = math.huge
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") then v.Enabled = false end
        end
    else
        Lighting.GlobalShadows = true
        Lighting.FogEnd = 100000
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") then v.Enabled = true end
        end
    end
    notifyMsg("FPS Boost: " .. (state and "Включён" or "Выключен"), Color3.fromRGB(0, 255, 0), 2)
end

-- Bullet Trails (Only Local Player)
local bulletTrails = {}
local function createBulletTrail(startPos, endPos)
    if bulletTrailsEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local shooter = LocalPlayer.Character.HumanoidRootPart
        if (startPos - shooter.Position).Magnitude < 10 then
            local trail = Instance.new("Part")
            trail.Size = Vector3.new(0.1, 0.1, (startPos - endPos).Magnitude)
            trail.Position = (startPos + endPos) / 2
            trail.CFrame = CFrame.lookAt(startPos, endPos) * CFrame.new(0, 0, -trail.Size.Z / 2)
            trail.Anchored = true
            trail.CanCollide = false
            trail.BrickColor = BrickColor.new("Bright red")
            trail.Material = Enum.Material.Neon
            trail.Parent = Workspace
            table.insert(bulletTrails, trail)
            task.wait(5)
            trail:Destroy()
        end
    end
end

-- ESP
local espDrawings = {}
local function addESP(player)
    if player == LocalPlayer or not player.Character then return end
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Color = Color3.fromRGB(255, 0, 0)
    box.Filled = false
    espDrawings[player] = {box = box}
    player.CharacterRemoving:Connect(function()
        box:Remove()
        espDrawings[player] = nil
    end)
end

local function updateESP()
    for player, drawings in pairs(espDrawings) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart
            local headPos, onScreen = Camera:WorldToViewportPoint(root.Position + Vector3.new(0, 3, 0))
            local footPos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
            if onScreen then
                drawings.box.Visible = espEnabled
                drawings.box.Size = Vector2.new(2000 / headPos.Z, footPos.Y - headPos.Y)
                drawings.box.Position = Vector2.new(headPos.X - drawings.box.Size.X / 2, headPos.Y)
            else
                drawings.box.Visible = false
            end
        end
    end
end

-- Bomb Info HUD
local BombInfoFrame = Instance.new("Frame")
BombInfoFrame.Size = UDim2.new(0, 200, 0, 50)
BombInfoFrame.Position = UDim2.new(0.5, -100, 0, 10)
BombInfoFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BombInfoFrame.BorderSizePixel = 0
BombInfoFrame.BackgroundTransparency = 0.3
BombInfoFrame.Parent = ScreenGui
BombInfoFrame.Active = true
BombInfoFrame.Draggable = true
BombInfoFrame.Visible = false

local BombInfoText = Instance.new("TextLabel")
BombInfoText.Size = UDim2.new(1, 0, 1, 0)
BombInfoText.BackgroundTransparency = 1
BombInfoText.TextColor3 = Color3.fromRGB(255, 255, 255)
BombInfoText.Font = Enum.Font.SourceSans
BombInfoText.TextSize = 14
BombInfoText.Text = "Bomb: No Info"
BombInfoText.Parent = BombInfoFrame

local function updateBombInfo()
    local bomb = Workspace:FindFirstChild("Bomb") or Workspace:FindFirstChild("planted_c4")
    if bomb then
        if bomb.Parent:FindFirstChild("Humanoid") then
            local carrier = Players:GetPlayerFromCharacter(bomb.Parent)
            BombInfoText.Text = "Bomb: Carrier - " .. (carrier and carrier.Name or "Unknown")
            BombInfoText.TextColor3 = Color3.fromRGB(0, 255, 0)
        else
            BombInfoText.Text = "Bomb: Planted"
            BombInfoText.TextColor3 = Color3.fromRGB(255, 0, 0)
        end
    else
        BombInfoText.Text = "Bomb: No Info"
        BombInfoText.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

-- Aimbot and Triggerbot
local function canFire() return true end
local function getClosestEnemy()
    local closest, dist = nil, math.huge
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Team ~= LocalPlayer.Team then
            local head = player.Character.Head
            local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local mouseDist = (mousePos - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                if mouseDist < dist then
                    dist = mouseDist
                    closest = head
                end
            end
        end
    end
    return closest
end

-- Main Loop
RunService.RenderStepped:Connect(function()
    if aimbotEnabled and canFire() then
        local target = getClosestEnemy()
        if target then
            local targetPos = target.Position + target.Velocity * 0.1
            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, targetPos)
            createBulletTrail(Camera.CFrame.Position, targetPos)
        end
    end
    if triggerbotEnabled and canFire() then
        local ray = Camera:ScreenPointToRay(Mouse.X, Mouse.Y)
        local result = Workspace:Raycast(ray.Origin, ray.Direction * 500)
        if result and result.Instance.Parent:FindFirstChild("Humanoid") then
            local player = Players:GetPlayerFromCharacter(result.Instance.Parent)
            if player and player.Team ~= LocalPlayer.Team then
                VirtualInputManager:SendMouseButtonEvent(Mouse.X, Mouse.Y, 0, true, game)
                task.wait(0.05)
                VirtualInputManager:SendMouseButtonEvent(Mouse.X, Mouse.Y, 0, false, game)
            end
        end
    end
    updateESP()
    if bombEnabled then
        BombInfoFrame.Visible = true
        updateBombInfo()
    else
        BombInfoFrame.Visible = false
    end
end)

-- Keybinds with Notifications
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        ScreenGui.Enabled = not ScreenGui.Enabled
        notifyMsg("GUI: " .. (ScreenGui.Enabled and "Включён" or "Выключен"), Color3.fromRGB(0, 255, 0), 2)
        debugPrint("GUI toggled: " .. tostring(ScreenGui.Enabled))
    elseif input.KeyCode == Enum.KeyCode.F2 then
        aimbotEnabled = not aimbotEnabled
        notifyMsg("Aimbot: " .. (aimbotEnabled and "Включён" or "Выключен"), Color3.fromRGB(0, 255, 0), 2)
    elseif input.KeyCode == Enum.KeyCode.F3 then
        triggerbotEnabled = not triggerbotEnabled
        notifyMsg("Triggerbot: " .. (triggerbotEnabled and "Включён" or "Выключен"), Color3.fromRGB(0, 255, 0), 2)
    elseif input.KeyCode == Enum.KeyCode.F4 then
        espEnabled = not espEnabled
        notifyMsg("ESP: " .. (espEnabled and "Включён" or "Выключен"), Color3.fromRGB(0, 255, 0), 2)
    elseif input.KeyCode == Enum.KeyCode.F5 then
        bombEnabled = not bombEnabled
        notifyMsg("Bomb Info: " .. (bombEnabled and "Включён" or "Выключен"), Color3.fromRGB(0, 255, 0), 2)
    elseif input.KeyCode == Enum.KeyCode.F6 then
        fpsBoostEnabled = not fpsBoostEnabled
        toggleFPSBoost(fpsBoostEnabled)
    end
end)

-- Initial Setup
Players.PlayerAdded:Connect(function(player) addESP(player) end)
for _, player in ipairs(Players:GetPlayers()) do addESP(player) end
