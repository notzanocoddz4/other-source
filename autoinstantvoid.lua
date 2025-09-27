-- [Auto Instant Void] developer by notzanocoddz and suggestion by demix1358

local Players = game:GetService('Players');
local StarterGui = game:GetService('StarterGui');
local localPlayer = Players.LocalPlayer

if localPlayer:GetAttribute("Character") ~= "Hunter" then
    StarterGui:SetCore("SendNotification", {
        Title = "ERROR",
        Text = "Please equip character 'Hunter'",
        Duration = 5,
    })

    repeat task.wait(0.1) until localPlayer:GetAttribute("Character") == "Hunter"

    StarterGui:SetCore("SendNotification", {
        Title = "INFO",
        Text = "Hunter equipped!",
        Duration = 5,
    })
end

print("- Creating Variables.")

local animationID = {
    ["rbxassetid://12273188754"] = {
        Delay = 1.3,
    },
    ["rbxassetid://12296113986"] = {
        Delay = 1.2,
    },
}

local oldCFrame
local isTeleporting = false

local function teleportVoid(rootpart: HumanoidRootPart)
    if isTeleporting then return end
    isTeleporting = true

    oldCFrame = rootpart.CFrame
    rootpart.CFrame = CFrame.new(oldCFrame.Position.X, -300, oldCFrame.Position.Z)

    StarterGui:SetCore("SendNotification", {
        Title = "INFO",
        Text = "Teleported to Void!",
        Duration = 3,
    })

    task.wait(0.4)

    rootpart.CFrame = oldCFrame
    oldCFrame = nil
    isTeleporting = false

    StarterGui:SetCore("SendNotification", {
        Title = "INFO",
        Text = "Returned to Old Position",
        Duration = 3,
    })
end

local function setupCharacter(char: Character)
    local rootpart = char:WaitForChild("HumanoidRootPart")
    local humanoid = char:WaitForChild("Humanoid")
    local animator = humanoid:WaitForChild("Animator")

    animator.AnimationPlayed:Connect(function(track)
        if animationID[track.Animation.AnimationId] then
            task.wait(animationID[track.Animation.AnimationId].Delay)
            teleportVoid(rootpart)
        end
    end)
end

setupCharacter(localPlayer.Character or localPlayer.CharacterAdded:Wait())
localPlayer.CharacterAdded:Connect(function(newChar: Character)
    StarterGui:SetCore("SendNotification", {
        Title = "INFO",
        Text = "Respawing...",
        Duration = 5,
    })
    setupCharacter(newChar)
    StarterGui:SetCore("SendNotification", {
        Title = "INFO",
        Text = "Respawned! Auto Instant Void is still running.",
        Duration = 5,
    })
end)

print("- Auto Instant Void has Loaded!")
StarterGui:SetCore("SendNotification", {
    Title = "Auto Instant Void is Loaded!",
    Text = "made by notzanocoddz",
    Duration = 5,
})
