local P,RS,WS,C=game:GetService("Players"),game:GetService("RunService"),game:GetService("Workspace"),workspace.CurrentCamera
local pl=P.LocalPlayer
local gui=Instance.new("ScreenGui",pl:WaitForChild("PlayerGui"))
local t=Instance.new("TextLabel",gui)
t.Size=UDim2.new(0,600,0,50) t.Position=UDim2.new(0.5,-300,0.4,0)
t.Text="DJ_WERE - ใช้ได้เฉพาะคนรู้จัก" t.Font=Enum.Font.GothamBold t.TextSize=28 t.BackgroundTransparency=1
local h=0 RS.RenderStepped:Connect(function(d) h=(h+d*50)%360 t.TextColor3=Color3.fromHSV(h/360,1,1) end)
local l=Instance.new("TextButton",gui)
l.Size=UDim2.new(0,60,0,60) l.Position=UDim2.new(0,10,0,10) l.Text="忍" l.Font=Enum.Font.GothamBold l.TextSize=40
l.BackgroundColor3=Color3.fromRGB(50,50,50) l.AutoButtonColor=true l.Visible=false
local f=Instance.new("Frame",gui)
f.Size=UDim2.new(0,200,0,80) f.Position=UDim2.new(0,80,0,10) f.BackgroundColor3=Color3.fromRGB(40,40,40) f.Visible=false
local s=Instance.new("UIStroke",f) s.Thickness=2 s.Color=Color3.fromRGB(255,255,255) s.Transparency=0.3

local function drag(fr)
    local d=false;local sp,sip
    fr.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch then d=true;sp=fr.Position;sip=i.Position;i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then d=false end end) end end)
    fr.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch then sip=i.Position end end)
    RS.RenderStepped:Connect(function() if d and sip then local delta=sip-i.Position fr.Position=UDim2.new(sp.X.Scale,sp.X.Offset+delta.X,sp.Y.Scale,sp.Y.Offset+delta.Y) end end)
end
drag(l) drag(f)
l.MouseButton1Click:Connect(function() f.Visible=not f.Visible end)
delay(3,function() t:Destroy() f.Visible=true l.Visible=true end)

local a=false
local b=Instance.new("TextButton",f)
b.Size=UDim2.new(0,160,0,35) b.Position=UDim2.new(0,10,0,10)
b.Text="Aimbot: ปิด" b.BackgroundColor3=Color3.fromRGB(50,50,50) b.TextColor3=Color3.fromRGB(255,255,255)
b.Font=Enum.Font.GothamBold b.TextSize=18
b.MouseButton1Click:Connect(function() a=not a b.Text=a and "Aimbot: เปิด" or "Aimbot: ปิด" b.BackgroundColor3=a and Color3.fromRGB(60,150,60) or Color3.fromRGB(50,50,50) end)

local RP=RaycastParams.new()
RP.FilterType=Enum.RaycastFilterType.Blacklist RP.IgnoreWater=true
local function getClosest()
    local c=nil s=50
    for _,v in pairs(P:GetPlayers()) do
        if v~=pl and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("HumanoidRootPart") then
            local hp=v.Character.Head.Position rp=v.Character.HumanoidRootPart.Position
            RP.FilterDescendantsInstances={pl.Character}
            local dir=hp-C.Position
            local r=WS:Raycast(C.Position,dir,RP)
            if r and r.Instance:IsDescendantOf(v.Character) then
                if (pl.Character.HumanoidRootPart.Position-rp).Magnitude<=60 then
                    local sPos=C:WorldToViewportPoint(hp)
                    local cen=Vector2.new(C.ViewportSize.X/2,C.ViewportSize.Y/2)
                    local dist=(Vector2.new(sPos.X,sPos.Y)-cen).Magnitude
                    if dist<=s then s=dist c=v end
                end
            end
        end
    end
    return c
end

local char=pl.Character or pl.CharacterAdded:Wait()
local hmd=char:WaitForChild("Humanoid") local rp=char:WaitForChild("HumanoidRootPart")
local op=rp.Position isS=false sd=40 rs=math.rad(300) ang=0
if char:FindFirstChild("Head") then for _,v in pairs(char.Head:GetChildren()) do if v:IsA("BillboardGui") then v.Enabled=false end end end

RS.RenderStepped:Connect(function(d)
    if a then local t=getClosest() if t and t.Character and t.Character:FindFirstChild("Head") then C.CFrame=CFrame.lookAt(C.Position,t.Character.Head.Position) end end
    if hmd.Health<=30 then if not isS then isS=true ang=0 end ang=ang+rs*d rp.CFrame=CFrame.new(op-Vector3.new(0,sd,0))*CFrame.Angles(0,ang,0)
    elseif isS and hmd.Health>=31 then isS=false rp.CFrame=CFrame.new(op) end
end)