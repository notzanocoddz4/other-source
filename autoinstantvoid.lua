-- [Auto Instant Void] Developer: notzanocoddz | Suggestion: demix1358
-- duels is not working :sob:

local Players = game:GetService('Players');
local StarterGui = game:GetService('StarterGui');
local localPlayer = Players.LocalPlayer

local function notify(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 3,
    })
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TOOGLE_UI"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = game.CoreGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 150, 0, 85)
main.Position = UDim2.new(0.5, 0, 0.15, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundTransparency = 1
main.Parent = screenGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, 0, 1, 0)
button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
button.Text = "OFF"
button.TextScaled = true
button.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json")
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(131, 131, 131)
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = button

local corner = Instance.new("UICorner")
corner.Parent = button

local enabled = false
button.MouseButton1Click:Connect(function()
    enabled = not enabled
    button.Text = enabled and "ON" or "OFF"
    notify("Toggle", "Auto Instant Void: " .. (enabled and "Enabled" or "Disabled"), 2)
end)

local animationData = {
    Hunter = {
        ["rbxassetid://12273188754"] = 1.01, -- Skill 1
        ["rbxassetid://12296113986"] = 1.05, -- Skill 2
    },
    Batter = {
        ["rbxassetid://14705929107"] = 1.45, -- Skill 4
    },
    Blade = {
        ["rbxassetid://15145462680"] = 1.41, -- Skill 2
        ["rbxassetid://15295895753"] = 0.31, -- Skill 3
    },
    Esper = {
        ["rbxassetid://16139108718"] = 0.25, -- Skill 1
    }
}

local isTeleporting = false
local oldCFrame

local function teleportVoid(rootpart)
    if isTeleporting or not enabled then return end
    isTeleporting = true

    oldCFrame = rootpart.CFrame
    rootpart.CFrame = CFrame.new(oldCFrame.X, -300, oldCFrame.Z) -- teleport underground
    notify("INFO", "Teleported to Void!", 2)

    task.wait(1)

    if rootpart.Parent and rootpart:IsDescendantOf(workspace) then
        rootpart.CFrame = oldCFrame
    end

    isTeleporting = false
    oldCFrame = nil
    notify("INFO", "Returned to Old Position", 2)
end

local function setupCharacter(char)
    local rootpart = char:WaitForChild("HumanoidRootPart")
    local animator = char:WaitForChild("Humanoid"):WaitForChild("Animator")

    animator.AnimationPlayed:Connect(function(track)
        if not enabled then return end

        local charType = localPlayer:GetAttribute("Character")
        local charData = animationData[charType]

        if charData and charData[track.Animation.AnimationId] then
            local delay = charData[track.Animation.AnimationId]
            task.wait(delay)
            teleportVoid(rootpart)
        end
    end)
end

setupCharacter(localPlayer.Character or localPlayer.CharacterAdded:Wait())
localPlayer.CharacterAdded:Connect(function(newChar)
    notify("INFO", "Respawning...", 3)
    setupCharacter(newChar)
    notify("INFO", "Respawned! Auto Instant Void is running.", 5)
end)

print("- Auto Instant Void Loaded!")
notify("Auto Instant Void Loaded!", "Made by notzanocoddz", 5)
