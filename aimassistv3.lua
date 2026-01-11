--// UNIVERSAL FPS CAMLOCK (FIXED)
getgenv().Camlock = {
    Enabled = true,
    Smoothness = 0.35, -- FPS game perlu lebih tinggi
    FOVRadius = 150,
    ShowFOV = true
}

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// Force camera control
Camera.CameraType = Enum.CameraType.Custom
Camera.CameraSubject = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

--// FOV UI
local gui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
gui.Name = "FPSCamlockUI"

local fov = Instance.new("Frame", gui)
fov.Size = UDim2.new(0, Camlock.FOVRadius*2, 0, Camlock.FOVRadius*2)
fov.Position = UDim2.new(0.5, -Camlock.FOVRadius, 0.5, -Camlock.FOVRadius)
fov.BackgroundTransparency = 1
fov.BorderSizePixel = 0
fov.Visible = Camlock.ShowFOV

local stroke = Instance.new("UIStroke", fov)
stroke.Thickness = 1.5
stroke.Color = Color3.fromRGB(255,255,255)

--// Visibility check (aggressive)
local function IsVisible(part)
    local origin = Camera.CFrame.Position
    local direction = part.Position - origin

    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {LocalPlayer.Character}
    params.FilterType = Enum.RaycastFilterType.Blacklist

    local result = workspace:Raycast(origin, direction, params)
    return result == nil or result.Instance:IsDescendantOf(part.Parent)
end

--// Get target (HEAD > HRP)
local function GetTarget()
    local closest, shortest = nil, Camlock.FOVRadius
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local part =
                    plr.Character:FindFirstChild("Head")
                    or plr.Character:FindFirstChild("HumanoidRootPart")

                if part and IsVisible(part) then
                    local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local dist = (Vector2.new(pos.X,pos.Y) - center).Magnitude
                        if dist < shortest then
                            shortest = dist
                            closest = part
                        end
                    end
                end
            end
        end
    end
    return closest
end

--// Main loop (FPS override)
RunService:BindToRenderStep(
    "FPSCamlock",
    Enum.RenderPriority.Camera.Value + 1,
    function()
        if not Camlock.Enabled then return end

        local target = GetTarget()
        if target then
            Camera.CFrame = Camera.CFrame:Lerp(
                CFrame.new(Camera.CFrame.Position, target.Position),
                Camlock.Smoothness
            )
        end
    end
)
