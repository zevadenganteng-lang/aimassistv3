do
    local g=getgenv
    local s=string.char
    local c=table.concat
    local rs=game:GetService("RunService")
    local ps=game:GetService("Players")
    local lp=ps.LocalPlayer
    local cam=workspace.CurrentCamera

    local cfg={true,0.35,150,true}
    g().Camlock={
        Enabled=cfg[1],
        Smoothness=cfg[2],
        FOVRadius=cfg[3],
        ShowFOV=cfg[4]
    }

    cam.CameraType=Enum.CameraType.Custom
    cam.CameraSubject=lp.Character or lp.CharacterAdded:Wait()

    -- popup
    local ui=Instance.new("ScreenGui",lp:WaitForChild("PlayerGui"))
    ui.ResetOnSpawn=false

    local t=Instance.new("TextLabel",ui)
    t.Size=UDim2.new(0,420,0,70)
    t.Position=UDim2.new(.5,-210,.5,-35)
    t.BackgroundTransparency=1
    t.Text=c{
        s(77),s(65),s(68),s(69),s(32),
        s(66),s(89),s(32),
        s(78),s(84),s(79),s(83),s(90),
        s(32),s(73),s(78),s(32),
        s(84),s(73),s(75),s(84),s(79),s(75),
        "\n",s(65),s(73),s(77),s(32),s(86),s(51)
    }
    t.TextScaled=true
    t.Font=Enum.Font.GothamBold
    t.TextColor3=Color3.new(1,1,1)
    t.TextStrokeTransparency=0

    task.delay(5,function()
        if ui then ui:Destroy() end
    end)

    local function vis(p)
        local o=cam.CFrame.Position
        local r=RaycastParams.new()
        r.FilterDescendantsInstances={lp.Character}
        r.FilterType=Enum.RaycastFilterType.Blacklist
        local h=workspace:Raycast(o,p.Position-o,r)
        return not h or h.Instance:IsDescendantOf(p.Parent)
    end

    local function tgt()
        local b,m=nil,cfg[3]
        local sc=Vector2.new(cam.ViewportSize.X/2,cam.ViewportSize.Y/2)
        for _,x in ipairs(ps:GetPlayers()) do
            if x~=lp and x.Character then
                local h=x.Character:FindFirstChildOfClass("Humanoid")
                if h and h.Health>0 then
                    local p=x.Character:FindFirstChild("Head") or x.Character:FindFirstChild("HumanoidRootPart")
                    if p and vis(p) then
                        local v,o=cam:WorldToViewportPoint(p.Position)
                        if o then
                            local d=(Vector2.new(v.X,v.Y)-sc).Magnitude
                            if d<m then m=d;b=p end
                        end
                    end
                end
            end
        end
        return b
    end

    local stepName="C"..math.random(100000,999999)
    rs:BindToRenderStep(
        stepName,
        Enum.RenderPriority.Camera.Value+1,
        function()
            if not g().Camlock.Enabled then return end
            local t=tgt()
            if t then
                cam.CFrame=cam.CFrame:Lerp(
                    CFrame.new(cam.CFrame.Position,t.Position),
                    cfg[2]
                )
            end
        end
    )
end
