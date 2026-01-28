do
    local a,b,c=game:GetService("RunService"),game:GetService("Players"),game:GetService("UserInputService")
    local d,e=b.LocalPlayer,workspace.CurrentCamera
    local f={E=true,S=.45,F=150};getgenv().Camlock=f

    e.CameraType=0
    e.CameraSubject=d.Character or d.CharacterAdded:Wait()

    local g=Instance.new("ScreenGui",d.PlayerGui)
    local h=Instance.new("TextLabel",g)
    h.Size=UDim2.new(0,420,0,70)
    h.Position=UDim2.new(.5,-210,.5,-35)
    h.BackgroundTransparency=1
    h.Text=string.char(77,65,68,69,32,66,89,32,78,79,84,83,90,10,65,73,77,32,86,51)
    h.TextScaled=true
    h.Font=Enum.Font.GothamBold
    h.TextColor3=Color3.new(1,1,1)
    h.TextStrokeTransparency=0
    task.delay(5,function() g:Destroy() end)

    d.Chatted:Connect(function(x)
        x=x:lower()
        if x==string.char(47,111,110) then f.E=true
        elseif x==string.char(47,111,102,102) then f.E=false end
    end)

    c.InputBegan:Connect(function(i,p)
        if not p and i.KeyCode==Enum.KeyCode.Q then
            f.E=not f.E
        end
    end)

    local function j(k)
        local l=k:FindFirstChild("BodyEffects")
        return l and (
            (l:FindFirstChild("K.O") and l["K.O"].Value) or
            (l:FindFirstChild("Grabbed") and l.Grabbed.Value) or
            (l:FindFirstChild("Carrying") and l.Carrying.Value)
        )
    end

    local function m(n)
        local r=RaycastParams.new()
        r.FilterDescendantsInstances={d.Character}
        r.FilterType=1
        local s=workspace:Raycast(e.CFrame.Position,n.Position-e.CFrame.Position,r)
        return not s or s.Instance:IsDescendantOf(n.Parent)
    end

    local function o()
        local p,q=nil,f.F
        local r=Vector2.new(e.ViewportSize.X*.5,e.ViewportSize.Y*.5)
        for _,s in ipairs(b:GetPlayers()) do
            local t=s.Character
            if s~=d and t and not j(t) then
                local u=t:FindFirstChildOfClass("Humanoid")
                local v=t:FindFirstChild("Head") or t:FindFirstChild("HumanoidRootPart")
                if u and u.Health>0 and v and m(v) then
                    local w,x=e:WorldToViewportPoint(v.Position)
                    if x then
                        local y=(Vector2.new(w.X,w.Y)-r).Magnitude
                        if y<q then q=y;p=v end
                    end
                end
            end
        end
        return p
    end

    a:BindToRenderStep(
        string.char(67)..math.random(1e5,9e5),
        Enum.RenderPriority.Camera.Value+1,
        function()
            if not f.E then return end
            local z=o()
            if z then
                e.CFrame=e.CFrame:Lerp(
                    CFrame.new(e.CFrame.Position,z.Position),
                    f.S
                )
            end
        end
    )
end
