-- Optimized Counter Blox Script: KRnl/Delta Compatible, Mobile/PC Support, Fixed GUI Toggle (Insert/Touch Button), Anti-Detect (Delays, Synonyms), Rage (Fatality Style: Spinbot AA, DT, Fake Lag, Auto Shoot, Wallbang), Semi-Rage (Mindate Style: Legit AA, Silent Aim), ESP Cleanup, Third-Person Fix
-- LocalScript for KRnl v2.1.0+, Mobile/PC Support

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local isMobile = UserInputService.TouchEnabled

-- Notification Function (Using StarterGui for Mobile/PC)
local function notifyMsg(msg, clr, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Counter Blox Script",
            Text = msg,
            Duration = duration or 3,
            Icon = clr and "rbxassetid://123456789" or nil -- Optional icon (replace if needed)
        })
    end)
end

notifyMsg("Скрипт загружается...", Color3.fromRGB(0, 255, 0), 3)

-- GUI Setup (Mobile/PC Toggle)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ConfigGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Enabled = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, isMobile and 200 or 250, 0, isMobile and 500 or 600)
Frame.Position = UDim2.new(0.5, -(isMobile and 100 or 125), 0.5, -(isMobile and 250 or 300))
Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame.Parent = ScreenGui
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel")
Title.Text = "Counter Blox Config"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Parent = Frame

-- Mobile Toggle Button
if isMobile then
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Text = "Toggle GUI"
    ToggleButton.Size = UDim2.new(0, 100, 0, 50)
    ToggleButton.Position = UDim2.new(0, 10, 0, 10)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.Parent = ScreenGui
    ToggleButton.MouseButton1Click:Connect(function()
        ScreenGui.Enabled = not ScreenGui.Enabled
    end)
end

-- Chams Inputs
local FillColorLabel = Instance.new("TextLabel")
FillColorLabel.Text = "Fill Color (R,G,B)"
FillColorLabel.Size = UDim2.new(1, 0, 0, 20)
FillColorLabel.Position = UDim2.new(0, 0, 0, 30)
FillColorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FillColorLabel.Parent = Frame

local FillColorInput = Instance.new("TextBox")
FillColorInput.Size = UDim2.new(1, 0, 0, 20)
FillColorInput.Position = UDim2.new(0, 0, 0, 50)
FillColorInput.Text = "255,0,0"
FillColorInput.Parent = Frame

local OutlineColorLabel = Instance.new("TextLabel")
OutlineColorLabel.Text = "Outline Color (R,G,B)"
OutlineColorLabel.Size = UDim2.new(1, 0, 0, 20)
OutlineColorLabel.Position = UDim2.new(0, 0, 0, 70)
OutlineColorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
OutlineColorLabel.Parent = Frame

local OutlineColorInput = Instance.new("TextBox")
OutlineColorInput.Size = UDim2.new(1, 0, 0, 20)
OutlineColorInput.Position = UDim2.new(0, 0, 0, 90)
OutlineColorInput.Text = "0,255,0"
OutlineColorInput.Parent = Frame

local FillTransLabel = Instance.new("TextLabel")
FillTransLabel.Text = "Fill Transparency (0-1)"
FillTransLabel.Size = UDim2.new(1, 0, 0, 20)
FillTransLabel.Position = UDim2.new(0, 0, 0, 110)
FillTransLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FillTransLabel.Parent = Frame

local FillTransInput = Instance.new("TextBox")
FillTransInput.Size = UDim2.new(1, 0, 0, 20)
FillTransInput.Position = UDim2.new(0, 0, 0, 130)
FillTransInput.Text = "0.5"
FillTransInput.Parent = Frame

local OutlineTransLabel = Instance.new("TextLabel")
OutlineTransLabel.Text = "Outline Transparency (0-1)"
OutlineTransLabel.Size = UDim2.new(1, 0, 0, 20)
OutlineTransLabel.Position = UDim2.new(0, 0, 0, 150)
OutlineTransLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
OutlineTransLabel.Parent = Frame

local OutlineTransInput = Instance.new("TextBox")
OutlineTransInput.Size = UDim2.new(1, 0, 0, 20)
OutlineTransInput.Position = UDim2.new(0, 0, 0, 170)
OutlineTransInput.Text = "0"
OutlineTransInput.Parent = Frame

-- Toggles (Mobile/PC Buttons)
local function createToggle(name, position, key, callback)
    local button = Instance.new("TextButton")
    button.Text = name .. ": Off (" .. key .. ")"
    button.Size = UDim2.new(1, 0, 0, 30)
    button.Position = UDim2.new(0, 0, 0, position)
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Parent = Frame
    local state = false
    button.MouseButton1Click:Connect(function()
        state = not state
        button.Text = name .. ": " .. (state and "On" or "Off") .. " (" .. key .. ")"
        callback(state)
        UpdateHUD()
    end)
    return button, function(newState) 
        state = newState
        button.Text = name .. ": " .. (state and "On" or "Off") .. " (" .. key .. ")"
    end
end

local BunnyhopToggle, setBunnyhop = createToggle("Bunnyhop", 190, "F1", function(state) bhEnabled = state end)
local bhEnabled = false
local AimbotToggle, setAimbot = createToggle("Silent Aimbot", 220, "F2", function(state) aimbotEnabled = state end)
local aimbotEnabled = false
local TriggerbotToggle, setTriggerbot = createToggle("Triggerbot", 250, "F3", function(state) triggerbotEnabled = state end)
local triggerbotEnabled = false
local ESPToggle, setESP = createToggle("ESP", 280, "F4", function(state) espEnabled = state end)
local espEnabled = false
local BombToggle, setBomb = createToggle("Bomb Info", 310, "F5", function(state) bombEnabled = state end)
local bombEnabled = false
local GrenadeToggle, setGrenade = createToggle("Grenade Pred", 340, "F6", function(state) grenadeEnabled = state end)
local grenadeEnabled = false
local AntiAimToggle, setAntiAim = createToggle("Anti-Aim (Spinbot)", 370, "F7", function(state) antiAimEnabled = state end)
local antiAimEnabled = false
local DoubleTapToggle, setDoubleTap = createToggle("Double Tap", 400, "F8", function(state) doubleTapEnabled = state end)
local doubleTapEnabled = false
local FakeLagToggle, setFakeLag = createToggle("Fake Lag", 430, "F9", function(state) fakeLagEnabled = state end)
local fakeLagEnabled = false
local AutoShootToggle, setAutoShoot = createToggle("Auto Shoot", 460, "F10", function(state) autoShootEnabled = state end)
local autoShootEnabled = false
local WallbangToggle, setWallbang = createToggle("Wallbang", 490, "F11", function(state) wallbangEnabled = state end)
local wallbangEnabled = false
local LegitAAToggle, setLegitAA = createToggle("Legit AA", 520, "F12", function(state) legitAAEnabled = state end)
local legitAAEnabled = false
local ThirdPersonToggle, setThirdPerson = createToggle("Third-Person", 550, "Home", function(state) thirdPersonEnabled = state end)
local thirdPersonEnabled = false

local ApplyButton = Instance.new("TextButton")
ApplyButton.Text = "Apply Chams"
ApplyButton.Size = UDim2.new(1, 0, 0, 30)
ApplyButton.Position = UDim2.new(0, 0, 0, 580)
ApplyButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ApplyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplyButton.Parent = Frame

-- Chams Logic
local chamsSettings = {
    FillColor = Color3.fromRGB(255, 0, 0),
    OutlineColor = Color3.fromRGB(0, 255, 0),
    FillTransparency = 0.5,
    OutlineTransparency = 0
}

local function parseColor(text)
    local r, g, b = text:match("(%d+),(%d+),(%d+)")
    r, g, b = tonumber(r), tonumber(g), tonumber(b)
    if r and g and b and r >= 0 and r <= 255 and g >= 0 and g <= 255 and b >= 0 and b <= 255 then
        return Color3.fromRGB(r, g, b)
    end
    return Color3.fromRGB(255, 0, 0)
end

local function parseTransparency(text)
    local num = tonumber(text)
    if num and num >= 0 and num <= 1 then
        return num
    end
    return 0.5
end

local function addChams(char, player)
    if char and player.Team ~= LocalPlayer.Team and char:FindFirstChild("Humanoid") then
        local existing = char:FindFirstChildOfClass("Highlight")
        if existing then existing:Destroy() end
        local highlight = Instance.new("Highlight")
        highlight.Adornee = char
        highlight.FillColor = chamsSettings.FillColor
        highlight.OutlineColor = chamsSettings.OutlineColor
        highlight.FillTransparency = chamsSettings.FillTransparency
        highlight.OutlineTransparency = chamsSettings.OutlineTransparency
        highlight.Parent = char
    end
end

local function updateAllChams()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Team ~= LocalPlayer.Team then
            addChams(player.Character, player)
        end
    end
end

ApplyButton.MouseButton1Click:Connect(function()
    chamsSettings.FillColor = parseColor(FillColorInput.Text)
    chamsSettings.OutlineColor = parseColor(OutlineColorInput.Text)
    chamsSettings.FillTransparency = parseTransparency(FillTransInput.Text)
    chamsSettings.OutlineTransparency = parseTransparency(OutlineTransInput.Text)
    updateAllChams()
end)

-- Player Handling
local respawnDebounce = {}
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function(char)
            task.defer(addChams, char, player)
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.Died:Connect(function()
                    if not respawnDebounce[player] then
                        respawnDebounce[player] = true
                        task.wait(6 + math.random(0, 1))
                        if player.Character then addChams(player.Character, player) end
                        respawnDebounce[player] = false
                    end
                end)
            end
        end)
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1 + math.random(0, 0.5))
    updateAllChams()
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        if player.Character then addChams(player.Character, player) end
        player.CharacterAdded:Connect(function(char)
            addChams(char, player)
        end)
    end
end

-- Bunnyhop
RunService.Heartbeat:Connect(function()
    if bhEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local humanoid = LocalPlayer.Character.Humanoid
        if humanoid.FloorMaterial ~= Enum.Material.Air and (isMobile or UserInputService:IsKeyDown(Enum.KeyCode.Space)) then
            humanoid.Jump = true
        end
    end
end)

-- Silent Aimbot
local function isVisible(target)
    if not visibleCheck then return true end
    local origin = Camera.CFrame.Position
    local direction = (target.Position - origin)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    local result = workspace:Raycast(origin, direction, raycastParams)
    return not result or result.Instance:IsDescendantOf(target.Parent)
end

local function canFire()
    if not fireCheck then return true end
    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
    return tool ~= nil
end

local function getClosestEnemy()
    local closest, dist = nil, math.huge
    local mousePos = isMobile and Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2) or Vector2.new(Mouse.X, Mouse.Y)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Character.Humanoid.Health > 0 and player.Team ~= LocalPlayer.Team then
            local head = player.Character.Head
            local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local mouseDist = (mousePos - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                if mouseDist < dist and mouseDist < (isMobile and 300 or 200) and isVisible(head) then
                    dist = mouseDist
                    closest = head
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if aimbotEnabled and canFire() then
        local target = getClosestEnemy()
        if target then
            local smoothFactor = smoothEnabled and (tonumber(SmoothInput.Text) or 0.5) + math.random(-0.1, 0.1) or 1
            local targetPos = target.Position + target.Velocity * 0.1
            local currentCFrame = Camera.CFrame
            local newCFrame = CFrame.lookAt(currentCFrame.Position, targetPos)
            Camera.CFrame = currentCFrame:Lerp(newCFrame, smoothFactor)
        end
    end
end)

-- Triggerbot (VirtualInputManager for Mobile/PC)
local lastTrigger = 0
RunService.Heartbeat:Connect(function()
    if triggerbotEnabled and canFire() and tick() - lastTrigger > 0.1 then
        local ray = Camera:ScreenPointToRay(isMobile and Camera.ViewportSize.X / 2 or Mouse.X, isMobile and Camera.ViewportSize.Y / 2 or Mouse.Y)
        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        local result = workspace:Raycast(ray.Origin, ray.Direction * 500, raycastParams)
        if result and result.Instance and result.Instance.Parent:FindFirstChild("Humanoid") then
            local player = Players:GetPlayerFromCharacter(result.Instance.Parent)
            if player and player.Team ~= LocalPlayer.Team then
                local highlight = result.Instance.Parent:FindFirstChildOfClass("Highlight")
                if highlight and highlight.FillColor == chamsSettings.FillColor then
                    VirtualInputManager:SendMouseButtonEvent(isMobile and Camera.ViewportSize.X / 2 or Mouse.X, isMobile and Camera.ViewportSize.Y / 2 or Mouse.Y, 0, true, game, 0)
                    task.wait(0.05 + math.random(0, 0.05))
                    VirtualInputManager:SendMouseButtonEvent(isMobile and Camera.ViewportSize.X / 2 or Mouse.X, isMobile and Camera.ViewportSize.Y / 2 or Mouse.Y, 0, false, game, 0)
                    lastTrigger = tick()
                end
            end
        end
    end
end)

-- ESP (Simplified for Mobile)
local espLabels = {}
local function addESP(player)
    if player == LocalPlayer or not player.Character then return end
    local char = player.Character
    local label = Instance.new("BillboardGui")
    label.Name = "ESP"
    label.Adornee = char:FindFirstChild("Head")
    label.Size = UDim2.new(0, 100, 0, 50)
    label.StudsOffset = Vector3.new(0, 2, 0)
    label.AlwaysOnTop = true
    label.Parent = char

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Text = player.Name
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Parent = label

    local healthLabel = Instance.new("TextLabel")
    healthLabel.Text = "100"
    healthLabel.Size = UDim2.new(1, 0, 0.5, 0)
    healthLabel.Position = UDim2.new(0, 0, 0.5, 0)
    healthLabel.BackgroundTransparency = 1
    healthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    healthLabel.TextStrokeTransparency = 0
    healthLabel.Parent = label

    espLabels[player] = {label = label, name = nameLabel, health = healthLabel}

    player.CharacterRemoving:Connect(function()
        if espLabels[player] then
            espLabels[player].label:Destroy()
            espLabels[player] = nil
        end
    end)
end

local function updateESP()
    for player, data in pairs(espLabels) do
        if player.Character and player.Character:FindFirstChild("Humanoid") and player.Team ~= LocalPlayer.Team then
            local humanoid = player.Character.Humanoid
            data.health.Text = tostring(math.floor(humanoid.Health))
            data.health.TextColor3 = Color3.fromRGB(255 * (1 - humanoid.Health / humanoid.MaxHealth), 255 * (humanoid.Health / humanoid.MaxHealth), 0)
            data.label.Enabled = espEnabled
        else
            data.label.Enabled = false
        end
    end
end

RunService.RenderStepped:Connect(function()
    if espEnabled then
        updateESP()
    end
end)

Players.PlayerAdded:Connect(function(player)
    addESP(player)
end)

Players.PlayerRemoving:Connect(function(player)
    if espLabels[player] then
        espLabels[player].label:Destroy()
        espLabels[player] = nil
    end
end)

for _, player in ipairs(Players:GetPlayers()) do
    addESP(player)
end

-- Bomb Info
RunService.RenderStepped:Connect(function()
    if bombEnabled then
        local wkspc = ReplicatedStorage:FindFirstChild("wkspc")
        if wkspc then
            local status = wkspc:FindFirstChild("Status")
            if status then
                local bombTimer = status:FindFirstChild("RoundTime") or status:FindFirstChild("BombTime")
                if bombTimer then
                    BombStatus.Text = "Bomb Timer: " .. bombTimer.Value .. "s"
                else
                    BombStatus.Text = "Bomb: Not Planted"
                end
            end
        end
    end
end)

-- Grenade Prediction
local grenadeLabels = {}
RunService.RenderStepped:Connect(function()
    if grenadeEnabled then
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj.Name == "Grenade" or obj.Name == "Flashbang" or obj.Name == "Smoke" then
                local label = Instance.new("BillboardGui")
                label.Size = UDim2.new(0, 50, 0, 50)
                label.StudsOffset = Vector3.new(0, 1, 0)
                label.AlwaysOnTop = true
                label.Parent = obj
                local text = Instance.new("TextLabel")
                text.Text = "!"
                text.Size = UDim2.new(1, 0, 1, 0)
                text.BackgroundTransparency = 1
                text.TextColor3 = Color3.fromRGB(255, 255, 0)
                text.TextStrokeTransparency = 0
                text.Parent = label
                table.insert(grenadeLabels, label)
                task.wait(0.1)
                label:Destroy()
            end
        end
    end
end)

-- Rage: Anti-Aim (Spinbot)
RunService.Stepped:Connect(function()
    if antiAimEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(1800), 0)
    end
end)

-- Rage: Double Tap
local lastShot = 0
RunService.RenderStepped:Connect(function()
    if doubleTapEnabled and canFire() and tick() - lastShot > 0.05 then
        VirtualInputManager:SendMouseButtonEvent(isMobile and Camera.ViewportSize.X / 2 or Mouse.X, isMobile and Camera.ViewportSize.Y / 2 or Mouse.Y, 0, true, game, 0)
        task.wait(0.01)
        VirtualInputManager:SendMouseButtonEvent(isMobile and Camera.ViewportSize.X / 2 or Mouse.Y, isMobile and Camera.ViewportSize.Y / 2 or Mouse.Y, 0, false, game, 0)
        VirtualInputManager:SendMouseButtonEvent(isMobile and Camera.ViewportSize.X / 2 or Mouse.X, isMobile and Camera.ViewportSize.Y / 2 or Mouse.Y, 0, true, game, 0)
        task.wait(0.01)
        VirtualInputManager:SendMouseButtonEvent(isMobile and Camera.ViewportSize.X / 2 or Mouse.X, isMobile and Camera.ViewportSize.Y / 2 or Mouse.Y, 0, false, game, 0)
        lastShot = tick()
    end
end)

-- Rage: Fake Lag
local lagTicks = 0
RunService.Stepped:Connect(function()
    if fakeLagEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        lagTicks = lagTicks + 1
        if lagTicks % 10 == 0 then
            LocalPlayer.Character.HumanoidRootPart.Anchored = true
        elseif lagTicks % 20 == 0 then
            LocalPlayer.Character.HumanoidRootPart.Anchored = false
            lagTicks = 0
        end
    end
end)

-- Rage: Auto Shoot
RunService.RenderStepped:Connect(function()
    if autoShootEnabled and canFire() then
        local target = getClosestEnemy()
        if target then
            VirtualInputManager:SendMouseButtonEvent(isMobile and Camera.ViewportSize.X / 2 or Mouse.X, isMobile and Camera.ViewportSize.Y / 2 or Mouse.Y, 0, true, game, 0)
            task.wait(0.05)
            VirtualInputManager:SendMouseButtonEvent(isMobile and Camera.ViewportSize.X / 2 or Mouse.X, isMobile and Camera.ViewportSize.Y / 2 or Mouse.Y, 0, false, game, 0)
        end
    end
end)

-- Rage: Wallbang
local function isVisible(target)
    if wallbangEnabled then return true end
    if not visibleCheck then return true end
    local origin = Camera.CFrame.Position
    local direction = (target.Position - origin)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    local result = workspace:Raycast(origin, direction, raycastParams)
    return not result or result.Instance:IsDescendantOf(target.Parent)
end

-- Semi-Rage: Legit AA
RunService.Stepped:Connect(function()
    if legitAAEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(45), 0)
    end
end)

-- Third-Person Fix
RunService.RenderStepped:Connect(function()
    if thirdPersonEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        Camera.CameraType = Enum.CameraType.Scriptable
        local root = LocalPlayer.Character.HumanoidRootPart
        Camera.CFrame = CFrame.new(root.Position - (root.CFrame.LookVector * 10) + Vector3.new(0, 5, 0), root.Position)
    else
        Camera.CameraType = Enum.CameraType.Custom
    end
end)

-- HUD
local HudGui = Instance.new("ScreenGui")
HudGui.Name = "HUD"
HudGui.ResetOnSpawn = false
HudGui.Parent = LocalPlayer.PlayerGui

local HudFrame = Instance.new("Frame")
HudFrame.Size = UDim2.new(0, isMobile and 150 or 200, 0, isMobile and 250 or 300)
HudFrame.Position = UDim2.new(1, -(isMobile and 160 or 210), 0, 10)
HudFrame.BackgroundTransparency = 0.3
HudFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
HudFrame.Parent = HudGui

local HudTitle = Instance.new("TextLabel")
HudTitle.Text = "Counter Blox HUD"
HudTitle.Size = UDim2.new(1, 0, 0, 20)
HudTitle.BackgroundTransparency = 1
HudTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HudTitle.Parent = HudFrame

local BhStatus = Instance.new("TextLabel")
BhStatus.Size = UDim2.new(1, 0, 0, 20)
BhStatus.Position = UDim2.new(0, 0, 0, 20)
BhStatus.BackgroundTransparency = 1
BhStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
BhStatus.Parent = HudFrame

local AimStatus = Instance.new("TextLabel")
AimStatus.Size = UDim2.new(1, 0, 0, 20)
AimStatus.Position = UDim2.new(0, 0, 0, 40)
AimStatus.BackgroundTransparency = 1
AimStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
AimStatus.Parent = HudFrame

local TrigStatus = Instance.new("TextLabel")
TrigStatus.Size = UDim2.new(1, 0, 0, 20)
TrigStatus.Position = UDim2.new(0, 0, 0, 60)
TrigStatus.BackgroundTransparency = 1
TrigStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
TrigStatus.Parent = HudFrame

local ESPStatus = Instance.new("TextLabel")
ESPStatus.Size = UDim2.new(1, 0, 0, 20)
ESPStatus.Position = UDim2.new(0, 0, 0, 80)
ESPStatus.BackgroundTransparency = 1
ESPStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPStatus.Parent = HudFrame

local BombStatus = Instance.new("TextLabel")
BombStatus.Size = UDim2.new(1, 0, 0, 20)
BombStatus.Position = UDim2.new(0, 0, 0, 100)
BombStatus.BackgroundTransparency = 1
BombStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
BombStatus.Parent = HudFrame

local GrenadeStatus = Instance.new("TextLabel")
GrenadeStatus.Size = UDim2.new(1, 0, 0, 20)
GrenadeStatus.Position = UDim2.new(0, 0, 0, 120)
GrenadeStatus.BackgroundTransparency = 1
GrenadeStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
GrenadeStatus.Parent = HudFrame

local AntiAimStatus = Instance.new("TextLabel")
AntiAimStatus.Size = UDim2.new(1, 0, 0, 20)
AntiAimStatus.Position = UDim2.new(0, 0, 0, 140)
AntiAimStatus.BackgroundTransparency = 1
AntiAimStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiAimStatus.Parent = HudFrame

local DoubleTapStatus = Instance.new("TextLabel")
DoubleTapStatus.Size = UDim2.new(1, 0, 0, 20)
DoubleTapStatus.Position = UDim2.new(0, 0, 0, 160)
DoubleTapStatus.BackgroundTransparency = 1
DoubleTapStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
DoubleTapStatus.Parent = HudFrame

local FakeLagStatus = Instance.new("TextLabel")
FakeLagStatus.Size = UDim2.new(1, 0, 0, 20)
FakeLagStatus.Position = UDim2.new(0, 0, 0, 180)
FakeLagStatus.BackgroundTransparency = 1
FakeLagStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
FakeLagStatus.Parent = HudFrame

local AutoShootStatus = Instance.new("TextLabel")
AutoShootStatus.Size = UDim2.new(1, 0, 0, 20)
AutoShootStatus.Position = UDim2.new(0, 0, 0, 200)
AutoShootStatus.BackgroundTransparency = 1
AutoShootStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoShootStatus.Parent = HudFrame

local WallbangStatus = Instance.new("TextLabel")
WallbangStatus.Size = UDim2.new(1, 0, 0, 20)
WallbangStatus.Position = UDim2.new(0, 0, 0, 220)
WallbangStatus.BackgroundTransparency = 1
WallbangStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
WallbangStatus.Parent = HudFrame

local LegitAAStatus = Instance.new("TextLabel")
LegitAAStatus.Size = UDim2.new(1, 0, 0, 20)
LegitAAStatus.Position = UDim2.new(0, 0, 0, 240)
LegitAAStatus.BackgroundTransparency = 1
LegitAAStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
LegitAAStatus.Parent = HudFrame

local ThirdPersonStatus = Instance.new("TextLabel")
ThirdPersonStatus.Size = UDim2.new(1, 0, 0, 20)
ThirdPersonStatus.Position = UDim2.new(0, 0, 0, 260)
ThirdPersonStatus.BackgroundTransparency = 1
ThirdPersonStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
ThirdPersonStatus.Parent = HudFrame

local function UpdateHUD()
    BhStatus.Text = "Bunnyhop: " .. (bhEnabled and "On" or "Off")
    AimStatus.Text = "Silent Aimbot: " .. (aimbotEnabled and "On" or "Off")
    TrigStatus.Text = "Triggerbot: " .. (triggerbotEnabled and "On" or "Off")
    ESPStatus.Text = "ESP: " .. (espEnabled and "On" or "Off")
    BombStatus.Text = "Bomb Info: " .. (bombEnabled and "On" or "Off")
    GrenadeStatus.Text = "Grenade Pred: " .. (grenadeEnabled and "On" or "Off")
    AntiAimStatus.Text = "Anti-Aim: " .. (antiAimEnabled and "On" or "Off")
    DoubleTapStatus.Text = "Double Tap: " .. (doubleTapEnabled and "On" or "Off")
    FakeLagStatus.Text = "Fake Lag: " .. (fakeLagEnabled and "On" or "Off")
    AutoShootStatus.Text = "Auto Shoot: " .. (autoShootEnabled and "On" or "Off")
    WallbangStatus.Text = "Wallbang: " .. (wallbangEnabled and "On" or "Off")
    LegitAAStatus.Text = "Legit AA: " .. (legitAAEnabled and "On" or "Off")
    ThirdPersonStatus.Text = "Third-Person: " .. (thirdPersonEnabled and "On" or "Off")
end
UpdateHUD()

-- Keybinds (Insert for GUI, F1-F12, Home for Third-Person)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.Insert then
            ScreenGui.Enabled = not ScreenGui.Enabled
        elseif input.KeyCode == Enum.KeyCode.F1 then
            bhEnabled = not bhEnabled
            setBunnyhop(bhEnabled)
            UpdateHUD()
        elseif input.KeyCode == Enum.KeyCode.F2 then
            aimbotEnabled = not aimbotEnabled
            setAimbot(aimbotEnabled)
            UpdateHUD()
        elseif input.KeyCode == Enum.KeyCode.F3 then
            triggerbotEnabled = not triggerbotEnabled
            setTriggerbot(triggerbotEnabled)
            UpdateHUD()
        elseif input.KeyCode == Enum.KeyCode.F4 then
            espEnabled = not espEnabled
            setESP(espEnabled)
            UpdateHUD()
        elseif input.KeyCode == Enum.KeyCode.F5 then
            bombEnabled = not bombEnabled
            setBomb(bombEnabled)
            UpdateHUD()
        elseif input.KeyCode == Enum.KeyCode.F6 then
            grenadeEnabled = not grenadeEnabled
            setGrenade(grenadeEnabled)
            UpdateHUD()
        elseif input.KeyCode == Enum.KeyCode.F7 then
            antiAimEnabled = not antiAimEnabled
            setAntiAim(antiAimEnabled)
            UpdateHUD()
        elseif input.KeyCode == Enum.KeyCode.F8 then
            doubleTapEnabled = not doubleTapEnabled
            setDoubleTap(doubleTapEnabled)
            UpdateHUD()
        elseif input.KeyCode == Enum.KeyCode.F9 then
            fakeLagEnabled = not fakeLagEnabled
            setFakeLag(fakeLagEnabled)
            UpdateHUD()
        elseif input.KeyCode == Enum.KeyCode.F10 then
            autoShootEnabled = not autoShootEnabled
            setAutoShoot(autoShootEnabled)
            UpdateHUD()
        elseif input.KeyCode == Enum.KeyCode.F11 then
            wallbangEnabled = not wallbangEnabled
            setWallbang(wallbangEnabled)
            UpdateHUD()
        elseif input.KeyCode == Enum.KeyCode.F12 then
            legitAAEnabled = not legitAAEnabled
            setLegitAA(legitAAEnabled)
            UpdateHUD()
        elseif input.KeyCode == Enum.KeyCode.Home then
            thirdPersonEnabled = not thirdPersonEnabled
            setThirdPerson(thirdPersonEnabled)
            UpdateHUD()
        end
    end
end)

-- Mobile Tap Support
if isMobile then
    UserInputService.TouchTap:Connect(function(touchPositions, gameProcessed)
        if gameProcessed then return end
        ScreenGui.Enabled = not ScreenGui.Enabled
    end)
end

-- Initial
local success, err = pcall(updateAllChams)
if not success then
    notifyMsg("Ошибка инициализации чамсов: " .. tostring(err), Color3.fromRGB(255, 0, 0), 5)
end
notifyMsg("Скрипт успешно загружен!", Color3.fromRGB(0, 255, 0), 3)
UpdateHUD()
