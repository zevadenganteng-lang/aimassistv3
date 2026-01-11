local c=string.char;local l=loadstring
l(c(103,101,116,103,101,110,118,40,41,46,67,97,109,108,111,99,107,61,123,69,110,97,98,108,101,100,61,116,114,117,101,44,83,109,111,111,116,104,110,101,115,115,61,48,46,51,53,44,70,79,86,82,97,100,105,117,115,61,49,53,48,44,83,104,111,119,70,79,86,61,116,114,117,101,125))()

local P=game:GetService("Players")
local R=game:GetService("RunService")
local L=P.LocalPlayer
local C=workspace.CurrentCamera

C.CameraType=Enum.CameraType.Custom
C.CameraSubject=L.Character or L.CharacterAdded:Wait()

--// POPUP UI
local PopupGui = Instance.new("ScreenGui", L:WaitForChild("PlayerGui"))
PopupGui.Name = "MadeByPopup"
PopupGui.ResetOnSpawn = false

local Text = Instance.new("TextLabel", PopupGui)
Text.Size = UDim2.new(0, 420, 0, 60)
Text.Position = UDim2.new(0.5, -210, 0.5, -30)
Text.BackgroundTransparency = 1
Text.Text = "MADE BY NTOSZ IN TIKTOK"
Text.TextColor3 = Color3.fromRGB(255,255,255)
Text.TextScaled = true
Text.Font = Enum.Font.GothamBold
Text.TextStrokeTransparency = 0

task.delay(5, function()
    PopupGui:Destroy()
end)

--// FOV UI
local G=Instance.new("ScreenGui",L.PlayerGui)
G.Name="FPSCamlockUI"

local F=Instance.new("Frame",G)
F.Size=UDim2.new(0,Camlock.FOVRadius*2,0,Camlock.FOVRadius*2)
F.Position=UDim2.new(.5,-Camlock.FOVRadius,.5,-Camlock.FOVRadius)
F.BackgroundTransparency=1
F.BorderSizePixel=0
F.Visible=Camlock.ShowFOV

local S=Instance.new("UIStroke",F)
S.Thickness=1.5
S.Color=Color3.fromRGB(255,255,255)

local function V(p)
    local o=C.CFrame.Position
    local d=p.Position-o
    local r=RaycastParams.new()
    r.FilterDescendantsInstances={L.Character}
    r.FilterType=Enum.RaycastFilterType.Blacklist
    local h=workspace:Raycast(o,d,r)
    return not h or h.Instance:IsDescendantOf(p.Parent)
end

local function T()
    local b,m=nil,Camlock.FOVRadius
    local c2=Vector2.new(C.ViewportSize.X/2,C.ViewportSize.Y/2)
    for _,pl in ipairs(P:GetPlayers()) do
        if pl~=L and pl.Character then
            local h=pl.Character:FindFirstChildOfClass("Humanoid")
            if h and h.Health>0 then
                local p=pl.Character:FindFirstChild("Head") or pl.Character:FindFirstChild("HumanoidRootPart")
                if p and V(p) then
                    local v,o=C:WorldToViewportPoint(p.Position)
                    if o then
                        local d=(Vector2.new(v.X,v.Y)-c2).Magnitude
                        if d<m then m=d;b=p end
                    end
                end
            end
        end
    end
    return b
end

R:BindToRenderStep("FPSCamlock",Enum.RenderPriority.Camera.Value+1,function()
    if not Camlock.Enabled then return end
    local t=T()
    if t then
        C.CFrame=C.CFrame:Lerp(
            CFrame.new(C.CFrame.Position,t.Position),
            Camlock.Smoothness
        )
    end
end)
