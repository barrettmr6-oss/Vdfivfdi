-- ╔══════════════════════════════════════════════════════════════════╗
-- ║      PTFS AUTOPILOT v19 — NATIVE THROTTLE EDITION               ║
-- ║                                                                  ║
-- ║  HOW PTFS THROTTLE WORKS (researched):                          ║
-- ║    W / Up Arrow  = increase throttle (PTFS's own slider)        ║
-- ║    S / Down Arrow = decrease throttle                           ║
-- ║    E = engine ON toggle (one press only — never spam it)        ║
-- ║    G = gear up/down   F = flaps   B = brakes/reverse            ║
-- ║                                                                  ║
-- ║  v19 APPROACH:                                                   ║
-- ║    • BodyGyro steers heading + pitch (smoothly)                  ║
-- ║    • W/S taps control PTFS native throttle for real speed        ║
-- ║    • NO BodyVelocity fighting PTFS physics engine               ║
-- ║    • 3° precision glideslope, multi-stage flare, butter landing  ║
-- ║    • GPS tunnel boxes for every flight phase                     ║
-- ║    • All panels draggable, mobile touch support                  ║
-- ╚══════════════════════════════════════════════════════════════════╝

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local TweenS     = game:GetService("TweenService")
local WS         = game:GetService("Workspace")
local VIM        = game:GetService("VirtualInputManager")
local Player     = Players.LocalPlayer
local PGui       = Player:WaitForChild("PlayerGui")

-- ── Clean up old versions ──────────────────────────────────────────
for _, n in ipairs({"PTFSMain","PTFSCockpit","PTFSTunnel","PTFSv18","PTFSv19"}) do
    if PGui:FindFirstChild(n) then PGui[n]:Destroy() end
end
if WS:FindFirstChild("PTFS_Tunnel") then WS.PTFS_Tunnel:Destroy() end

-- ════════════════════════════════════════════════════════════════════
-- AIRPORT DATABASE
-- ════════════════════════════════════════════════════════════════════
local Airports = {
    {
        name="Greater Rockford", icao="IRFD", type="International",
        runways={
            {name="07L", thr=Vector3.new(-3500,3.3,20750),  hdg=067, len=3200},
            {name="25R", thr=Vector3.new(-380,3.3,19950),   hdg=247, len=3200},
            {name="07C", thr=Vector3.new(-3490,3.3,20680),  hdg=067, len=3100},
            {name="25C", thr=Vector3.new(-370,3.3,19980),   hdg=247, len=3100},
            {name="07R", thr=Vector3.new(-3481,3.3,20620),  hdg=067, len=3000},
            {name="25L", thr=Vector3.new(-360,3.3,20010),   hdg=247, len=3000},
        }
    },
    {
        name="Tokyo International", icao="RJTT", type="International",
        runways={
            {name="02",  thr=Vector3.new(-6399,21.5,-32327), hdg=020, len=4850},
            {name="20",  thr=Vector3.new(-6922,21.5,-27800), hdg=200, len=4850},
            {name="13",  thr=Vector3.new(-4900,21.5,-32100), hdg=131, len=3600},
            {name="31",  thr=Vector3.new(-7600,21.5,-29600), hdg=311, len=3600},
        }
    },
    {
        name="Perth International", icao="YPPH", type="International",
        runways={
            {name="11",  thr=Vector3.new(6200,25,4800),  hdg=111, len=3200},
            {name="29",  thr=Vector3.new(8800,25,5600),  hdg=291, len=3200},
            {name="15",  thr=Vector3.new(6700,25,4300),  hdg=151, len=2500},
            {name="33",  thr=Vector3.new(7600,25,6500),  hdg=133, len=2500},
        }
    },
    {
        name="Izolirani Airport", icao="LIIZ", type="International",
        runways={
            {name="10",  thr=Vector3.new(-9200,9,15800),  hdg=106, len=3200},
            {name="28",  thr=Vector3.new(-6300,9,16600),  hdg=286, len=3200},
        }
    },
    {
        name="Saint Barthélemy", icao="TFFJ", type="Regional",
        runways={
            {name="09",  thr=Vector3.new(5470,11.5,-4486), hdg=092, len=600},
            {name="27",  thr=Vector3.new(5880,11.5,-4486), hdg=272, len=600},
        }
    },
    {
        name="Larnaca Airport", icao="LCLK", type="Regional",
        runways={
            {name="04",  thr=Vector3.new(11200,18,-8200),  hdg=040, len=2800},
            {name="22",  thr=Vector3.new(12700,18,-6500),  hdg=220, len=2800},
        }
    },
    {
        name="Paphos Airport", icao="LCPH", type="Regional",
        runways={
            {name="11",  thr=Vector3.new(10100,28,-10600), hdg=110, len=2200},
            {name="29",  thr=Vector3.new(11500,28,-9800),  hdg=290, len=2200},
        }
    },
    {
        name="Sauthemptona Airport", icao="ESOU", type="Regional",
        runways={
            {name="02",  thr=Vector3.new(-1200,8,-2800),  hdg=020, len=1800},
            {name="20",  thr=Vector3.new(-900,8,-1400),   hdg=200, len=1800},
        }
    },
    {
        name="Saba Airport", icao="TNCS", type="Regional",
        runways={
            {name="12",  thr=Vector3.new(-8200,148,-24600), hdg=120, len=400},
            {name="30",  thr=Vector3.new(-7970,148,-24270), hdg=300, len=400},
        }
    },
    {
        name="Skopelos Airfield", icao="LGSK", type="Regional",
        runways={
            {name="09",  thr=Vector3.new(14200,12,-3200), hdg=090, len=900},
            {name="27",  thr=Vector3.new(14900,12,-3200), hdg=270, len=900},
        }
    },
    {
        name="Waterloo Airport", icao="EBWL", type="Regional",
        runways={
            {name="06",  thr=Vector3.new(-4800,18,10200), hdg=060, len=1200},
            {name="24",  thr=Vector3.new(-4200,18,10640), hdg=240, len=1200},
        }
    },
    {
        name="Sea Haven", icao="SEAH", type="Regional",
        runways={
            {name="18",  thr=Vector3.new(2800,4,-14200), hdg=180, len=1600},
            {name="36",  thr=Vector3.new(2800,4,-12850), hdg=360, len=1600},
        }
    },
    {
        name="Lukla Airport", icao="VNLK", type="STOL",
        runways={
            {name="06",  thr=Vector3.new(7100,950,4200),  hdg=062, len=400},
            {name="24",  thr=Vector3.new(7340,960,4310),  hdg=242, len=400},
        }
    },
    {
        name="Barra Airport", icao="EGPR", type="STOL",
        runways={
            {name="12",  thr=Vector3.new(3100,4,-6200),  hdg=120, len=700},
            {name="30",  thr=Vector3.new(3490,4,-5810),  hdg=300, len=700},
            {name="07",  thr=Vector3.new(3000,4,-6050),  hdg=070, len=600},
            {name="25",  thr=Vector3.new(3340,4,-5950),  hdg=250, len=600},
        }
    },
    {
        name="Mellor Airfield", icao="IMLR", type="STOL",
        runways={
            {name="07",  thr=Vector3.new(-2800,420,17800), hdg=070, len=500},
            {name="25",  thr=Vector3.new(-2420,420,17935), hdg=250, len=500},
        }
    },
    {
        name="Katcui Airfield", icao="KATC", type="STOL",
        runways={
            {name="14",  thr=Vector3.new(-6600,12,-19200), hdg=140, len=600},
            {name="32",  thr=Vector3.new(-6290,12,-18810), hdg=320, len=600},
        }
    },
    {
        name="McConnell AFB", icao="KMCC", type="Military",
        runways={
            {name="01L", thr=Vector3.new(-3200,8,15200),  hdg=010, len=2800},
            {name="19R", thr=Vector3.new(-2710,8,17960),  hdg=190, len=2800},
            {name="01R", thr=Vector3.new(-3100,8,15200),  hdg=010, len=2800},
            {name="19L", thr=Vector3.new(-2610,8,17960),  hdg=190, len=2800},
        }
    },
    {
        name="RAF Scampton", icao="EGXP", type="Military",
        runways={
            {name="13",  thr=Vector3.new(-8800,9,17800),  hdg=130, len=2400},
            {name="31",  thr=Vector3.new(-7175,9,19330),  hdg=310, len=2400},
        }
    },
    {
        name="Al Najaf Airfield", icao="ALAJ", type="Military",
        runways={
            {name="07",  thr=Vector3.new(-9800,9,16800),  hdg=070, len=900},
            {name="25",  thr=Vector3.new(-9290,9,16987),  hdg=250, len=900},
        }
    },
    {
        name="Training Centre", icao="TRNC", type="Military",
        runways={
            {name="09",  thr=Vector3.new(-200,4,200),  hdg=090, len=800},
            {name="27",  thr=Vector3.new(400,4,200),   hdg=270, len=800},
        }
    },
}

-- ════════════════════════════════════════════════════════════════════
-- COLOUR PALETTE
-- ════════════════════════════════════════════════════════════════════
local C = {
    bg=Color3.fromRGB(8,12,18), panel=Color3.fromRGB(12,18,28),
    border=Color3.fromRGB(35,55,80), borderHi=Color3.fromRGB(60,120,200),
    green=Color3.fromRGB(0,230,130), greenD=Color3.fromRGB(0,140,70),
    cyan=Color3.fromRGB(40,200,255), cyanD=Color3.fromRGB(0,100,160),
    amber=Color3.fromRGB(255,190,0), amberD=Color3.fromRGB(140,90,0),
    red=Color3.fromRGB(255,65,65), redD=Color3.fromRGB(120,20,20),
    white=Color3.fromRGB(220,232,245), dim=Color3.fromRGB(90,110,135),
    sky=Color3.fromRGB(30,90,180), ground=Color3.fromRGB(110,70,30),
    magenta=Color3.fromRGB(200,60,200), purple=Color3.fromRGB(140,80,220),
    orange=Color3.fromRGB(255,140,0),
}

-- ════════════════════════════════════════════════════════════════════
-- UI BUILDER HELPERS
-- ════════════════════════════════════════════════════════════════════
local function F(par,sx,sy,ox,oy,px,py,popx,popy,col,tr,zi)
    local f=Instance.new("Frame")
    f.Size=UDim2.new(sx or 0,ox or 0,sy or 0,oy or 0)
    f.Position=UDim2.new(px or 0,popx or 0,py or 0,popy or 0)
    f.BackgroundColor3=(typeof(col)=="Color3") and col or C.panel
    f.BackgroundTransparency=(typeof(tr)=="number") and tr or 0
    f.BorderSizePixel=0; f.ZIndex=(typeof(zi)=="number") and zi or 1
    f.Parent=par; return f
end
local function L(par,txt,ts,col,font,xa,sx,sy,ox,oy,px,py,popx,popy,zi)
    local l=Instance.new("TextLabel")
    l.Text=txt or ""; l.TextSize=ts or 12; l.TextColor3=col or C.white
    l.Font=font or Enum.Font.Code; l.BackgroundTransparency=1
    l.TextXAlignment=xa or Enum.TextXAlignment.Center
    l.Size=UDim2.new(sx or 1,ox or 0,sy or 1,oy or 0)
    l.Position=UDim2.new(px or 0,popx or 0,py or 0,popy or 0)
    l.ZIndex=zi or 2; l.Parent=par; return l
end
local function Btn(par,txt,ts,col,bg,sx,sy,ox,oy,px,py,popx,popy,zi)
    local b=Instance.new("TextButton")
    b.Text=txt or ""; b.TextSize=ts or 12; b.TextColor3=col or C.white
    b.Font=Enum.Font.GothamBold; b.BackgroundColor3=bg or C.panel
    b.BorderSizePixel=0; b.AutoButtonColor=false
    b.Size=UDim2.new(sx or 0,ox or 80,sy or 0,oy or 28)
    b.Position=UDim2.new(px or 0,popx or 0,py or 0,popy or 0)
    b.ZIndex=zi or 3; b.Parent=par; return b
end
local function Rnd(i,r) local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r or 4); c.Parent=i end
local function Str(i,col,t) local s=Instance.new("UIStroke"); s.Color=col or C.border; s.Thickness=t or 1; s.Parent=i end

-- Universal drag — mouse + touch
local function makeDraggable(handle, target)
    local drag,si,sp=false,nil,nil
    handle.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            drag=true; si=i.Position; sp=target.Position
        end
    end)
    handle.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            drag=false
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and si and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            local d=i.Position-si
            target.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
        end
    end)
end

-- ════════════════════════════════════════════════════════════════════
-- PTFS KEY CONTROL
-- W = throttle up, S = throttle down, E = engine toggle (ONE press)
-- G = gear, F = flaps, B = brakes, R = reverse/spoilers
-- ════════════════════════════════════════════════════════════════════
local function keyDown(key)
    pcall(function() VIM:SendKeyEvent(true, Enum.KeyCode[key], false, game) end)
end
local function keyUp(key)
    pcall(function() VIM:SendKeyEvent(false, Enum.KeyCode[key], false, game) end)
end
local function tapKey(key, dur)
    dur = dur or 0.06
    pcall(function()
        VIM:SendKeyEvent(true,  Enum.KeyCode[key], false, game)
        task.wait(dur)
        VIM:SendKeyEvent(false, Enum.KeyCode[key], false, game)
    end)
end

-- Throttle manager: holds W or S to reach target throttle %
-- PTFS throttle goes 0-100%. Each % takes ~0.033s of W held.
-- We track internally and pulse W/S to adjust.
local throttleTarget = 0   -- 0-100
local throttleActual = 0   -- our estimate (PTFS doesn't expose it directly)
local throttleConn   = nil

local function setThrottleTarget(pct)
    throttleTarget = math.clamp(pct, 0, 100)
end

local function startThrottleManager()
    if throttleConn then throttleConn:Disconnect() end
    throttleConn = RunService.Heartbeat:Connect(function(dt)
        local diff = throttleTarget - throttleActual
        if math.abs(diff) < 0.5 then
            -- At target — release both
            keyUp("W"); keyUp("S"); return
        end
        if diff > 0 then
            -- Need more throttle — hold W
            keyDown("W"); keyUp("S")
            throttleActual = math.min(throttleActual + (dt * 30), 100)
        else
            -- Need less throttle — hold S
            keyDown("S"); keyUp("W")
            throttleActual = math.max(throttleActual + (dt * 30) * -1, 0)
        end
    end)
end

local function stopThrottleManager()
    if throttleConn then throttleConn:Disconnect(); throttleConn=nil end
    keyUp("W"); keyUp("S")
    throttleTarget = 0; throttleActual = 0
end

-- ════════════════════════════════════════════════════════════════════
-- MATH HELPERS
-- ════════════════════════════════════════════════════════════════════
local function hDir(deg)
    local r=math.rad(deg)
    return Vector3.new(math.sin(r),0,math.cos(r))
end
local function dist2D(a,b)
    return math.sqrt((a.X-b.X)^2+(a.Z-b.Z)^2)
end
local function logEv(msg)
    -- flightLog defined later; stub safe
    if _G.PTFS_LOG then
        table.insert(_G.PTFS_LOG,1,string.format("[%.0f] %s",tick(),msg))
        if #_G.PTFS_LOG>40 then table.remove(_G.PTFS_LOG) end
    end
    print("[PTFS v19] "..msg)
end

_G.PTFS_LOG = {}
local function logE(msg)
    table.insert(_G.PTFS_LOG,1,string.format("[%.0f] %s",tick(),msg))
    if #_G.PTFS_LOG>40 then table.remove(_G.PTFS_LOG) end
    print("[PTFS v19] "..msg)
end

-- ════════════════════════════════════════════════════════════════════
-- AUTOPILOT STATE
-- ════════════════════════════════════════════════════════════════════
local AP = {
    active=false,
    -- IDLE / TAKEOFF / CLIMB / CRUISE / DESCEND / APPROACH / FLARE / ROLLOUT
    phase="IDLE",
    dep=nil, arr=nil,
    aircraft=nil, root=nil,
    -- Settings (pilot-adjustable)
    CRUISE_ALT   = 2500,   -- studs
    CRUISE_THR   = 95,     -- % throttle for cruise
    CLIMB_THR    = 100,    -- % throttle for climb
    TO_THR       = 100,    -- % throttle for takeoff roll
    APP_THR      = 40,     -- % throttle for approach (idle-ish)
    LAND_THR     = 20,     -- % throttle near touchdown
    CLIMB_PITCH  = 12,     -- degrees nose-up during climb
    APP_PITCH    = -3,     -- degrees nose-down on approach
    GPS_ON       = false,
}
local waypoints, wpIdx = {}, 1
local bGyro = nil         -- BodyGyro for heading/pitch only
local hbConn = nil

-- ════════════════════════════════════════════════════════════════════
-- GYRO CONTROL — smooth heading + pitch via BodyGyro
-- ════════════════════════════════════════════════════════════════════
local function setGyro(headingDeg, pitchDeg)
    if not bGyro or not bGyro.Parent then return end
    local hr = math.rad(headingDeg)
    local pr = math.rad(-pitchDeg)  -- negative = nose up in Roblox Y-up
    -- Build CFrame: face heading, then tilt pitch
    local lookDir = Vector3.new(math.sin(hr), 0, math.cos(hr))
    local up = CFrame.new(Vector3.new(), lookDir) * CFrame.Angles(pr, 0, 0)
    bGyro.CFrame = up
end

-- ════════════════════════════════════════════════════════════════════
-- WAYPOINT BUILDER
-- ════════════════════════════════════════════════════════════════════
local function buildWaypoints()
    waypoints = {}; wpIdx = 1
    local dep = AP.dep; local arr = AP.arr
    local alt = AP.CRUISE_ALT
    local dDir = hDir(dep.hdg); local aDir = hDir(arr.hdg)
    local aThr = arr.thr

    -- 1. CLIMB-OUT: 3500 studs ahead, at cruise alt
    local climbPt = dep.thr + dDir * 3500
    climbPt = Vector3.new(climbPt.X, alt, climbPt.Z)
    table.insert(waypoints, {pos=climbPt, label="CLIMB-OUT", arrive=function()
        AP.phase = "CRUISE"
        setThrottleTarget(AP.CRUISE_THR)
        logE("Cruising at "..alt.." st")
    end})

    -- 2. MID-ROUTE
    local midX = (dep.thr.X + aThr.X) / 2
    local midZ = (dep.thr.Z + aThr.Z) / 2
    table.insert(waypoints, {pos=Vector3.new(midX, alt, midZ), label="CRUISE", arrive=function() end})

    -- 3. DESCENT GATE: 12000 studs out on approach centreline
    local desGate = aThr - aDir * 12000
    desGate = Vector3.new(desGate.X, alt, desGate.Z)
    table.insert(waypoints, {pos=desGate, label="DESCENT GATE", arrive=function()
        AP.phase = "DESCEND"
        setThrottleTarget(AP.APP_THR + 15)
        task.spawn(function() tapKey("F") end)   -- flaps
        logE("Descending, flaps")
    end})

    -- 4. APPROACH FIX: 5000 studs out, on 3° slope
    local appFix = aThr - aDir * 5000
    local appAlt = aThr.Y + math.tan(math.rad(3)) * 5000  -- ~262 st above threshold
    table.insert(waypoints, {pos=Vector3.new(appFix.X, appAlt, appFix.Z), label="APP FIX", arrive=function()
        AP.phase = "APPROACH"
        setThrottleTarget(AP.APP_THR)
        task.spawn(function() task.wait(0.3); tapKey("G") end)  -- gear down
        logE("Approach — gear down")
    end})
end

-- ════════════════════════════════════════════════════════════════════
-- GPS TUNNEL
-- ════════════════════════════════════════════════════════════════════
local tunnelFolder = nil

local function clearTunnel()
    if tunnelFolder and tunnelFolder.Parent then tunnelFolder:Destroy() end
    tunnelFolder = nil
end

local function makeTunnelBox(cf, sz, col, tr)
    local p = Instance.new("Part")
    p.Anchored=true; p.CanCollide=false; p.CanQuery=false
    p.Size=sz; p.CFrame=cf
    p.Material=Enum.Material.Neon; p.Color=col
    p.Transparency=tr or 0.6; p.CastShadow=false
    p.Parent=tunnelFolder
    local sel=Instance.new("SelectionBox")
    sel.Adornee=p; sel.Color3=col; sel.LineThickness=0.05
    sel.SurfaceTransparency=1; sel.Parent=tunnelFolder
end

local function buildTunnel()
    clearTunnel()
    if not AP.dep or not AP.arr then return end
    tunnelFolder=Instance.new("Folder"); tunnelFolder.Name="PTFS_Tunnel"; tunnelFolder.Parent=WS

    local dep=AP.dep; local arr=AP.arr
    local dDir=hDir(dep.hdg); local aDir=hDir(arr.hdg)
    local alt=AP.CRUISE_ALT; local aThr=arr.thr

    -- TAKEOFF / CLIMB boxes (green) — 7 boxes, climbing to cruise alt
    for i=1,7 do
        local frac=i/7
        local d=i*600
        local pt=dep.thr + dDir*d
        local boxAlt=dep.thr.Y + (alt-dep.thr.Y)*frac
        pt=Vector3.new(pt.X, boxAlt, pt.Z)
        local cf=CFrame.new(pt, pt+dDir)
        local w=60-frac*18; local h=40-frac*10
        makeTunnelBox(cf, Vector3.new(w, h, 5), Color3.fromRGB(0,255,100), 0.65)
    end

    -- CRUISE boxes (cyan) — every 2000 studs
    local csStart = dep.thr + dDir*4200
    local csEnd   = arr.thr - aDir*12000
    local csVec   = Vector3.new(csEnd.X-csStart.X, 0, csEnd.Z-csStart.Z)
    local csDist  = csVec.Magnitude
    if csDist > 100 then
        local csUnit = csVec.Unit
        local steps  = math.max(2, math.floor(csDist/2000))
        for i=1,steps do
            local pt = Vector3.new(csStart.X, alt, csStart.Z) + csUnit*(i/steps*csDist)
            local cf = CFrame.new(pt, pt+csUnit)
            makeTunnelBox(cf, Vector3.new(50, 30, 5), Color3.fromRGB(40,200,255), 0.72)
        end
    end

    -- APPROACH / GLIDESLOPE boxes (amber → red) — 15 boxes, 12000→0 studs out
    for i=1,15 do
        local frac = i/15
        local d    = 12000*(1-frac)            -- distance to threshold
        local pt   = aThr - aDir*d
        local bAlt = aThr.Y + math.tan(math.rad(3))*d
        pt = Vector3.new(pt.X, bAlt, pt.Z)
        local cf = CFrame.new(pt, pt+aDir)
        local w  = 60*(1-frac*0.5); local h = 40*(1-frac*0.5)
        local col= (d<2000) and Color3.fromRGB(255,80,60) or Color3.fromRGB(255,190,0)
        makeTunnelBox(cf, Vector3.new(w, h, 5), col, 0.60)
    end

    -- TOUCHDOWN zone stripes (cyan) on the runway surface
    for i=1,3 do
        local pt = aThr + aDir*(i*180)
        pt = Vector3.new(pt.X, aThr.Y+0.8, pt.Z)
        local cf = CFrame.new(pt, pt+aDir)
        makeTunnelBox(cf, Vector3.new(28, 5, 70), Color3.fromRGB(0,255,255), 0.45)
    end
end

-- ════════════════════════════════════════════════════════════════════
-- STOP AP
-- ════════════════════════════════════════════════════════════════════
local function stopAP(reason)
    AP.active=false; AP.phase="IDLE"
    stopThrottleManager()
    if hbConn then hbConn:Disconnect(); hbConn=nil end
    if bGyro and bGyro.Parent then bGyro:Destroy(); bGyro=nil end
    if not AP.GPS_ON then clearTunnel() end
    logE("STOP: "..(reason or "Manual"))
end

-- ════════════════════════════════════════════════════════════════════
-- FLIGHT LOOP
-- Uses BodyGyro for attitude, PTFS W/S for throttle
-- ════════════════════════════════════════════════════════════════════
local function startLoop()
    wpIdx = 1
    if hbConn then hbConn:Disconnect() end

    hbConn = RunService.Heartbeat:Connect(function(dt)
        if not AP.active then hbConn:Disconnect(); hbConn=nil; return end

        -- Re-acquire root if lost
        if not AP.root or not AP.root.Parent then
            local char=Player.Character
            if char then
                local hum=char:FindFirstChildOfClass("Humanoid")
                if hum and hum.SeatPart then
                    AP.aircraft=hum.SeatPart.Parent
                    AP.root=AP.aircraft:FindFirstChild("Body")
                        or AP.aircraft:FindFirstChild("Fuselage")
                        or AP.aircraft:FindFirstChild("Main")
                        or hum.SeatPart
                end
            end
            return
        end

        -- Recreate BodyGyro if gone
        if not bGyro or not bGyro.Parent then
            pcall(function()
                bGyro=Instance.new("BodyGyro")
                bGyro.MaxTorque=Vector3.new(4e5, 4e5, 4e5)  -- enough to steer, not override physics
                bGyro.P=8000; bGyro.D=800
                bGyro.CFrame=AP.root.CFrame
                bGyro.Parent=AP.root
            end)
            return
        end

        local pos = AP.root.Position
        local alt = pos.Y
        local aThr = AP.arr.thr
        local aDir = hDir(AP.arr.hdg)
        local dDir = hDir(AP.dep.hdg)

        -- ─── TAKEOFF ──────────────────────────────────────────────────
        if AP.phase == "TAKEOFF" then
            -- Full throttle, nose level until liftoff
            setThrottleTarget(AP.TO_THR)
            setGyro(AP.dep.hdg, 0)

            -- Once airborne, pitch up
            local vel = AP.root.AssemblyLinearVelocity
            if vel.Magnitude > 50 and alt > AP.dep.thr.Y + 15 then
                AP.phase = "CLIMB"
                setThrottleTarget(AP.CLIMB_THR)
                task.spawn(function() task.wait(1.5); tapKey("G") end)  -- gear up after climb
                logE("Climbing — gear up in 1.5s")
            end

        -- ─── CLIMB ────────────────────────────────────────────────────
        elseif AP.phase == "CLIMB" then
            if wpIdx > #waypoints then AP.phase="CRUISE"; return end
            local wp = waypoints[wpIdx]
            local toWP = wp.pos - pos
            local d2D  = dist2D(pos, wp.pos)

            -- Heading toward waypoint
            local hdgToWP = math.deg(math.atan2(toWP.X, toWP.Z))
            if hdgToWP < 0 then hdgToWP = hdgToWP + 360 end

            -- Pitch: climb until we're near the waypoint altitude
            local altErr = wp.pos.Y - alt
            local climbPitch = altErr > 100 and AP.CLIMB_PITCH or math.clamp(altErr * 0.1, 0, AP.CLIMB_PITCH)

            setGyro(hdgToWP, climbPitch)
            setThrottleTarget(AP.CLIMB_THR)

            if d2D < 800 then
                wp.arrive(); wpIdx = wpIdx + 1
            end

        -- ─── CRUISE ───────────────────────────────────────────────────
        elseif AP.phase == "CRUISE" then
            if wpIdx > #waypoints then AP.phase="DESCEND"; return end
            local wp = waypoints[wpIdx]
            local toWP = wp.pos - pos
            local d2D  = dist2D(pos, wp.pos)
            local hdgToWP = math.deg(math.atan2(toWP.X, toWP.Z))
            if hdgToWP < 0 then hdgToWP = hdgToWP + 360 end

            -- Level cruise, maintain altitude
            local altErr = wp.pos.Y - alt
            local levelPitch = math.clamp(altErr * 0.05, -5, 8)

            setGyro(hdgToWP, levelPitch)
            setThrottleTarget(AP.CRUISE_THR)

            if d2D < 1000 then
                wp.arrive(); wpIdx = wpIdx + 1
            end

        -- ─── DESCEND ──────────────────────────────────────────────────
        elseif AP.phase == "DESCEND" then
            if wpIdx > #waypoints then AP.phase="APPROACH"; return end
            local wp = waypoints[wpIdx]
            local toWP = wp.pos - pos
            local d2D  = dist2D(pos, wp.pos)
            local hdgToWP = math.deg(math.atan2(toWP.X, toWP.Z))
            if hdgToWP < 0 then hdgToWP = hdgToWP + 360 end

            -- Descend: negative pitch, reduced throttle
            local altErr = wp.pos.Y - alt   -- negative = need to go lower
            local desPitch = math.clamp(altErr * 0.04, -6, 3)

            setGyro(hdgToWP, desPitch)
            setThrottleTarget(AP.APP_THR + 15)

            if d2D < 700 then
                wp.arrive(); wpIdx = wpIdx + 1
            end

        -- ─── APPROACH — precision 3° ILS-style glideslope ─────────────
        elseif AP.phase == "APPROACH" then
            -- Service any remaining waypoints
            if wpIdx <= #waypoints then
                local wp = waypoints[wpIdx]
                if dist2D(pos, wp.pos) < 600 then
                    wp.arrive(); wpIdx = wpIdx + 1
                end
            end

            -- Always fly toward the threshold on extended centreline
            local toThr = Vector3.new(aThr.X-pos.X, 0, aThr.Z-pos.Z)
            local hdgToThr = math.deg(math.atan2(toThr.X, toThr.Z))
            if hdgToThr < 0 then hdgToThr = hdgToThr + 360 end

            local horizDist = dist2D(pos, aThr)
            local heightAbove = alt - aThr.Y

            -- Ideal altitude on 3° glideslope
            local idealAlt = aThr.Y + math.tan(math.rad(3)) * horizDist
            local altErr   = idealAlt - alt  -- positive = we're too low

            -- Pitch to track glideslope (nose down to descend, nose up to climb onto slope)
            -- Clamp: max 3° up (catching slope), max -5° down (not too steep)
            local gsPitch = math.clamp(altErr * 0.08 + AP.APP_PITCH, -5, 3)

            -- Throttle: idle-ish on approach, a little more if we're below slope
            local appThr = AP.APP_THR
            if altErr < -30 then appThr = AP.APP_THR + 10 end  -- slightly below slope
            if altErr >  30 then appThr = math.max(AP.APP_THR - 10, 5) end  -- above slope
            setThrottleTarget(appThr)

            setGyro(hdgToThr, gsPitch)

            -- Transition to FLARE when very close to ground
            if heightAbove < 40 then
                AP.phase = "FLARE"
                logE("FLARE initiated at "..string.format("%.0f",heightAbove).."st")
            end

        -- ─── FLARE — smooth touchdown ─────────────────────────────────
        elseif AP.phase == "FLARE" then
            local toThr = Vector3.new(aThr.X-pos.X, 0, aThr.Z-pos.Z)
            local hdgToThr = math.deg(math.atan2(toThr.X, toThr.Z))
            if hdgToThr < 0 then hdgToThr = hdgToThr + 360 end
            local heightAbove = alt - aThr.Y

            -- Gradually bring nose up and kill throttle for butter landing
            -- 40st: -2° | 20st: 0° | 10st: +1° | 5st: +2° (gentle flare)
            local flarePitch
            if heightAbove > 25 then flarePitch = -1.5
            elseif heightAbove > 12 then flarePitch = 0
            elseif heightAbove > 5  then flarePitch = 1
            else                         flarePitch = 2
            end

            -- Reduce throttle progressively to idle on touchdown
            local flareThr = math.max(AP.LAND_THR, math.floor(AP.APP_THR * (heightAbove/40)))
            setThrottleTarget(flareThr)

            setGyro(hdgToThr, flarePitch)

            if heightAbove <= 2 or alt <= aThr.Y + 2 then
                AP.phase = "ROLLOUT"
                -- Set throttle to 0, then apply reverse/brakes
                setThrottleTarget(0)
                task.spawn(function()
                    task.wait(0.3)
                    tapKey("S")  -- throttle to idle/reverse in PTFS
                    task.wait(0.2)
                    tapKey("B")  -- brakes
                end)
                logE("Touchdown! ✈ Rolling out")
            end

        -- ─── ROLLOUT — decelerate, stay on centreline ─────────────────
        elseif AP.phase == "ROLLOUT" then
            local toThr = Vector3.new(aThr.X-pos.X, 0, aThr.Z-pos.Z)
            local hdgToThr = math.deg(math.atan2(toThr.X, toThr.Z))
            if hdgToThr < 0 then hdgToThr = hdgToThr + 360 end

            -- Keep nose straight and flat during rollout
            setGyro(hdgToThr, 0)
            setThrottleTarget(0)  -- kill throttle

            -- Check if we've stopped (velocity check)
            local vel = AP.root.AssemblyLinearVelocity
            if vel.Magnitude < 5 then
                task.spawn(function()
                    tapKey("B"); task.wait(0.2); tapKey("X")
                end)
                stopAP("Flight complete ✅")
            end
        end
    end)
end

-- ════════════════════════════════════════════════════════════════════
-- START AP
-- ════════════════════════════════════════════════════════════════════
local function startAP()
    if AP.active        then return false,"Already active!" end
    if not AP.dep       then return false,"Select departure runway!" end
    if not AP.arr       then return false,"Select arrival runway!" end
    if AP.dep == AP.arr then return false,"Dep = Arr!" end

    local char=Player.Character
    if not char then return false,"No character!" end
    local hum=char:FindFirstChildOfClass("Humanoid")
    if not hum or not hum.SeatPart then return false,"Board an aircraft first!" end

    local ac   = hum.SeatPart.Parent
    local root = ac:FindFirstChild("Body")
        or ac:FindFirstChild("Fuselage")
        or ac:FindFirstChild("Main")
        or hum.SeatPart

    AP.aircraft=ac; AP.root=root
    AP.active=true; AP.phase="TAKEOFF"
    _G.PTFS_LOG={}
    logE("START: "..AP.dep.name.." → "..AP.arr.name)

    -- Destroy old gyro if any
    if bGyro and bGyro.Parent then bGyro:Destroy() end

    bGyro = Instance.new("BodyGyro")
    bGyro.MaxTorque = Vector3.new(4e5,4e5,4e5)
    bGyro.P=8000; bGyro.D=800
    bGyro.CFrame = root.CFrame
    bGyro.Parent = root

    -- Teleport to runway threshold
    local dDir = hDir(AP.dep.hdg)
    local spawnPos = AP.dep.thr - dDir*90
    spawnPos = Vector3.new(spawnPos.X, AP.dep.thr.Y+2, spawnPos.Z)
    pcall(function() ac:PivotTo(CFrame.new(spawnPos, spawnPos+dDir)) end)

    buildWaypoints()
    if AP.GPS_ON then buildTunnel() end

    -- Start throttle manager
    startThrottleManager()

    task.wait(0.3)
    -- Start engine with ONE press of E (not held — PTFS toggles on one press)
    task.spawn(function()
        tapKey("E", 0.08)  -- one clean engine start press
        task.wait(0.5)
        -- Flaps for takeoff
        tapKey("F", 0.08)
    end)

    task.wait(0.6)
    startLoop()
    return true, "Flight started! 🛫"
end

Player.CharacterAdded:Connect(function()
    if AP.active then stopAP("Character reset") end
end)

-- ════════════════════════════════════════════════════════════════════
-- ══════════════ SCREEN GUI ═════════════════════════════════════════
-- ════════════════════════════════════════════════════════════════════
local sg = Instance.new("ScreenGui")
sg.Name="PTFSv19"; sg.ResetOnSpawn=false
sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
sg.DisplayOrder=120; sg.Parent=PGui

-- ════════════════════════════════════════════════════════════════════
-- ── COCKPIT HUD ──────────────────────────────────────────────────
-- ════════════════════════════════════════════════════════════════════
local HW,HH=740,270
local TH=28
local SPD_W=68; local ALT_W=76
local PFD_W=HW-SPD_W-ALT_W-4
local ND_W=148

local hud=F(sg,0,0,HW,HH,0.5,1,-HW/2,-HH-10,C.bg,0,1)
Rnd(hud,10); Str(hud,C.borderHi,1.5)

local hudTitle=F(hud,1,0,0,TH,0,0,0,0,Color3.fromRGB(10,16,28),0,2)
Rnd(hudTitle,10)
L(hudTitle,"✈  PTFS  FLIGHT  DECK  v19",11,C.cyan,Enum.Font.GothamBold)
makeDraggable(hudTitle,hud)

local hudClose=Btn(hud,"✕",11,C.white,C.redD,0,0,24,22,1,0,-28,3,5)
Rnd(hudClose,4); Str(hudClose,C.red,1)
hudClose.MouseButton1Click:Connect(function() hud.Visible=not hud.Visible end)

local hudC=F(hud,1,1,-2,-(TH+2),0,0,1,TH+1,Color3.fromRGB(0,0,0),1,1)

-- ── SPEED TAPE ───────────────────────────────────────────────────
local spdPanel=F(hudC,0,1,SPD_W,0,0,0,0,0,Color3.fromRGB(10,16,14),0,2)
Rnd(spdPanel,6); Str(spdPanel,Color3.fromRGB(0,80,50),1)
L(spdPanel,"SPD",8,C.greenD,Enum.Font.GothamBold,nil,1,0,0,14,0,0,0,0,3)
L(spdPanel,"KTS",8,C.greenD,Enum.Font.GothamBold,nil,1,0,0,14,1,0,0,-14,3)
local spdBox=F(spdPanel,1,0,-8,32,0,0,4,0,Color3.fromRGB(0,20,12),0,3)
spdBox.Position=UDim2.new(0,4,0.5,-16); Rnd(spdBox,4); Str(spdBox,C.green,1)
local spdVal=L(spdBox,"0",18,C.green,Enum.Font.Code,nil,1,1,0,0,0,0,0,0,4)
-- Throttle % indicator below speed box
local thrBox=F(spdPanel,1,0,-8,18,0,0,4,0,Color3.fromRGB(0,15,8),0,3)
thrBox.Position=UDim2.new(0,4,0.5,18); Rnd(thrBox,3); Str(thrBox,C.greenD,1)
local thrVal=L(thrBox,"THR ---%",7,C.greenD,Enum.Font.Code,nil,1,1,0,0,0,0,0,0,4)

-- Tick marks
local spdTicks=F(spdPanel,1,1,0,-72,0,0,0,36,Color3.fromRGB(0,0,0),1,2)
spdTicks.ClipsDescendants=true
for i=0,20 do
    local v=i*50; local yPct=1-(v/1000); local maj=v%100==0
    F(spdTicks,0,0,maj and 18 or 10,1,1,0,-(maj and 18 or 10),0,0,yPct,0,-1,
        maj and Color3.fromRGB(0,180,80) or Color3.fromRGB(0,80,40),0,3)
    if maj then L(spdTicks,tostring(v),8,Color3.fromRGB(0,160,70),Enum.Font.Code,
        Enum.TextXAlignment.Right,0,0,SPD_W-22,14,0,yPct,0,-8,3) end
end

-- ── ALT TAPE ─────────────────────────────────────────────────────
local altPanel=F(hudC,0,1,ALT_W,0,1,0,-ALT_W,0,Color3.fromRGB(10,12,22),0,2)
Rnd(altPanel,6); Str(altPanel,Color3.fromRGB(30,50,120),1)
L(altPanel,"ALT",8,C.cyanD,Enum.Font.GothamBold,nil,1,0,0,14,0,0,0,0,3)
L(altPanel,"STD",8,C.cyanD,Enum.Font.GothamBold,nil,1,0,0,14,1,0,0,-14,3)
local altBox=F(altPanel,1,0,-8,32,0,0,4,0,Color3.fromRGB(5,8,28),0,3)
altBox.Position=UDim2.new(0,4,0.5,-16); Rnd(altBox,4); Str(altBox,C.cyan,1)
local altVal=L(altBox,"0",15,C.cyan,Enum.Font.Code,nil,1,1,0,0,0,0,0,0,4)
local altTicks=F(altPanel,1,1,0,-36,0,0,0,18,Color3.fromRGB(0,0,0),1,2)
altTicks.ClipsDescendants=true
for i=0,20 do
    local v=i*500; local yPct=1-(v/10000)
    F(altTicks,0,0,14,1,0,yPct,0,-1,Color3.fromRGB(40,80,180),0,3)
    L(altTicks,tostring(v),8,Color3.fromRGB(40,100,200),Enum.Font.Code,
        Enum.TextXAlignment.Left,0,0,ALT_W-20,14,0,yPct,18,-8,3)
end

-- ── ATTITUDE INDICATOR ───────────────────────────────────────────
local aiW=PFD_W-ND_W-2
local pfdArea=F(hudC,0,1,PFD_W,0,0,0,SPD_W+2,0,Color3.fromRGB(0,0,0),1,1)
local ai=F(pfdArea,0,1,aiW,0,0,0,0,0,C.sky,0,2)
Rnd(ai,6); ai.ClipsDescendants=true

local skyTop=F(ai,1,0.6,0,0,0,0,0,0,Color3.fromRGB(20,70,160),0,2)
local skyBot=F(ai,1,0.5,0,0,0,0.5,0,0,Color3.fromRGB(50,120,220),0,2)
local gndTop=F(ai,1,0.5,0,0,0,0.5,0,0,Color3.fromRGB(130,85,35),0,2)
local gndBot=F(ai,1,0.5,0,0,0,1,0,0,Color3.fromRGB(90,55,20),0,2)
gndBot.AnchorPoint=Vector2.new(0,1)
local horizLine=F(ai,1,0,0,2,0,0.5,0,-1,C.amber,0,5)

for _,deg in ipairs({-15,-10,-5,5,10,15}) do
    local yB=0.5-(deg*0.018); local w=math.abs(deg)>=10 and 0.42 or 0.28
    F(ai,w,0,0,1,(1-w)/2,yB,0,0,Color3.fromRGB(220,220,200),0.3,4)
    L(ai,string.format("%+d",deg),8,Color3.fromRGB(220,220,180),Enum.Font.Code,
        Enum.TextXAlignment.Right,0,0,(1-w)/2*aiW-4,12,0,yB,0,-6,4)
end
F(ai,0,0,44,3,0.5,0.5,-52,-1,Color3.fromRGB(255,210,0),0,6)
F(ai,0,0,44,3,0.5,0.5,8,-1,Color3.fromRGB(255,210,0),0,6)
local wDot=F(ai,0,0,8,8,0.5,0.5,-4,-4,Color3.fromRGB(255,210,0),0,6); Rnd(wDot,4)
F(ai,0,0,3,14,0.5,0.5,-1,-14,Color3.fromRGB(255,210,0),0,6)

local fpvF=F(ai,0,0,18,18,0.5,0.5,-9,-9,Color3.fromRGB(0,0,0),1,7)
local fpvC=F(fpvF,1,1,0,0,0,0,0,0,Color3.fromRGB(0,0,0),1,7); Str(fpvC,C.green,1.5); Rnd(fpvC,9)
F(fpvF,0,0,8,1,1,0.5,1,0,Color3.fromRGB(0,230,120),0,8)
F(fpvF,0,0,8,1,0,0.5,-9,0,Color3.fromRGB(0,230,120),0,8)
F(fpvF,0,0,1,8,0.5,0,-1,-9,Color3.fromRGB(0,230,120),0,8)

-- Heading strip
local hdgStripH=28
local hdgStrip=F(pfdArea,0,0,aiW,hdgStripH,0,1,0,-hdgStripH,Color3.fromRGB(10,14,24),0,3)
Str(hdgStrip,C.border,1); Rnd(hdgStrip,4)
for i=0,35 do
    local deg=i*10; local xPct=deg/360; local maj=deg%30==0
    F(hdgStrip,0,0,1,maj and 10 or 6,xPct,0,0,0,
        maj and Color3.fromRGB(60,110,180) or Color3.fromRGB(30,55,90),0,4)
    if maj then
        local dirs={[0]="N",[90]="E",[180]="S",[270]="W"}
        L(hdgStrip,dirs[deg] or tostring(deg),8,Color3.fromRGB(60,120,200),Enum.Font.Code,
            nil,0,0,22,12,xPct,0,-11,10,4)
    end
end
local hdgPtr=F(hdgStrip,0,0,2,hdgStripH,0,0,-1,0,Color3.fromRGB(255,200,0),0,6)
local hdgRead=L(hdgStrip,"000°",10,C.amber,Enum.Font.Code,nil,0,0,44,18,0.5,1,-22,-20,5)

local topH=22
local topStrip=F(pfdArea,0,0,aiW,topH,0,0,0,0,Color3.fromRGB(6,10,20),0,3); Rnd(topStrip,4)
local pitchRead=L(topStrip,"PTH +0.0°",9,C.amber,Enum.Font.Code,Enum.TextXAlignment.Left,0.5,1,0,0,0,0,3,0,4)
local vsRead=L(topStrip,"V/S +0 fpm",9,C.cyan,Enum.Font.Code,Enum.TextXAlignment.Right,0.5,1,0,0,0.5,0,-3,0,4)

-- ── ND ───────────────────────────────────────────────────────────
local nd=F(pfdArea,0,1,ND_W,-(hdgStripH+topH+2),0,0,aiW+2,topH+1,Color3.fromRGB(8,14,26),0,2)
Rnd(nd,6); Str(nd,C.border,1)
L(nd,"✈ NAV",9,C.cyan,Enum.Font.GothamBold,nil,1,0,0,18,0,0,0,2,3)
local compassR=50
local compassBG=F(nd,0,0,compassR*2,compassR*2,0.5,0,-compassR,22,Color3.fromRGB(10,18,34),0,3)
Rnd(compassBG,compassR); Str(compassBG,Color3.fromRGB(40,65,100),1)
for _,cd in ipairs({{t="N",a=0,c=C.cyan},{t="E",a=90,c=C.white},{t="S",a=180,c=C.white},{t="W",a=270,c=C.white}}) do
    local r2=math.rad(cd.a)
    L(compassBG,cd.t,9,cd.c,Enum.Font.GothamBold,nil,0,0,16,14,0.5,0.5,
        math.sin(r2)*(compassR-10)-8,-math.cos(r2)*(compassR-10)-7,4)
end
F(compassBG,0,0,2,compassR-8,0.5,0.5,-1,-(compassR-8),C.cyan,0,5)
L(compassBG,"✈",16,C.white,Enum.Font.GothamBold,nil,0,0,22,22,0.5,0.5,-11,-12,5)
local ndHdgLbl=L(nd,"000°",14,C.cyan,Enum.Font.Code,nil,1,0,0,20,0,0,0,compassR*2+26,3)
local ndDestLbl=L(nd,"DEST: ---",9,C.green,Enum.Font.Code,nil,1,0,0,16,0,0,0,compassR*2+48,3)
local ndWPLbl=L(nd,"WP: -/-",9,C.amber,Enum.Font.Code,nil,1,0,0,16,0,0,0,compassR*2+66,3)
local ndPhaseLbl=L(nd,"IDLE",10,C.red,Enum.Font.GothamBold,nil,1,0,0,18,0,0,0,compassR*2+84,3)

-- ── BOTTOM DATA BAR ──────────────────────────────────────────────
local barH=34
local bar=F(hud,1,0,0,barH,0,1,0,-barH-1,Color3.fromRGB(8,11,20),0,3)
Rnd(bar,6); Str(bar,C.border,1)
local barCells={
    {k="gs",l="G/S",c=C.green},{k="vs",l="V/S",c=C.cyan},
    {k="thr",l="THR",c=C.amber},{k="dist",l="DIST",c=C.orange},
    {k="phase",l="PHASE",c=C.magenta},{k="dep",l="DEP",c=C.dim},{k="arr",l="ARR",c=C.dim},
}
local barVals={}
local cw=HW/#barCells
for i,cell in ipairs(barCells) do
    local cx=(i-1)*cw
    local bg=F(bar,0,1,cw-2,-4,0,0,cx+1,2,Color3.fromRGB(11,16,28),0,3); Rnd(bg,3)
    L(bg,cell.l,7,C.dim,Enum.Font.GothamBold,nil,1,0,0,12,0,0,0,2,4)
    barVals[cell.k]=L(bg,"--",12,cell.c,Enum.Font.Code,nil,1,0,0,16,0,0,0,12,4)
    if i<#barCells then F(bar,0,1,1,-8,0,0,cx+cw,4,C.border,0,4) end
end

-- ── HUD LIVE UPDATER ─────────────────────────────────────────────
RunService.Heartbeat:Connect(function()
    if not hud.Visible then return end
    pcall(function()
        local char=Player.Character; if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        local vel=hrp.AssemblyLinearVelocity
        local gs=math.floor(vel.Magnitude)
        local alt=math.floor(hrp.Position.Y)
        local look=hrp.CFrame.LookVector
        local hdg=math.deg(math.atan2(look.X,look.Z)); if hdg<0 then hdg=hdg+360 end
        local pitch=vel.Magnitude>0.5 and math.deg(math.asin(math.clamp(vel.Y/vel.Magnitude,-1,1))) or 0
        local vs=math.floor(vel.Y*60)

        local sc=gs<80 and C.red or (gs<200 and C.amber or C.green)
        spdVal.Text=tostring(gs); spdVal.TextColor3=sc

        local ac2=alt<60 and C.amber or (alt<300 and C.white or C.cyan)
        altVal.Text=tostring(alt); altVal.TextColor3=ac2

        -- Throttle readout (from our internal tracker)
        local tPct=math.floor(throttleActual)
        thrVal.Text=string.format("THR %d%%",tPct)
        thrVal.TextColor3=tPct>70 and C.green or (tPct>30 and C.amber or C.dim)

        -- Attitude
        local aiH=ai.AbsoluteSize.Y
        local pxPitch=math.clamp(pitch*(aiH*0.018),-(aiH*0.45),aiH*0.45)
        local skyRat=math.clamp(0.5+pxPitch/aiH,0.05,0.95)
        skyTop.Size=UDim2.new(1,0,skyRat,0)
        skyBot.Size=UDim2.new(1,0,skyRat,0)
        gndTop.Position=UDim2.new(0,0,skyRat,0); gndTop.Size=UDim2.new(1,0,1-skyRat,0)
        gndBot.Position=UDim2.new(0,0,1,0); gndBot.Size=UDim2.new(1,0,1-skyRat,0)
        horizLine.Position=UDim2.new(0,0,skyRat,-1)

        if vel.Magnitude>2 then
            local fp=math.deg(math.asin(math.clamp(vel.Y/vel.Magnitude,-1,1)))
            fpvF.Position=UDim2.new(0.5,-9,0.5,(-fp*(aiH*0.018))-9); fpvF.Visible=true
        else fpvF.Visible=false end

        hdgPtr.Position=UDim2.new(hdg/360,-1,0,0)
        hdgRead.Text=string.format("%03.0f°",hdg)
        ndHdgLbl.Text=string.format("%03.0f°",hdg)
        pitchRead.Text=string.format("PTH %+.1f°",pitch)
        vsRead.Text=string.format("V/S %+d fpm",vs)

        barVals.gs.Text=tostring(gs).." kts"
        barVals.vs.Text=(vs>=0 and "+" or "")..tostring(vs).." fpm"
        barVals.thr.Text=string.format("%d%%",tPct)
        barVals.phase.Text=AP.phase
        local dist2=AP.arr and tostring(math.floor(dist2D(hrp.Position,AP.arr.thr))).." st" or "---"
        barVals.dist.Text=dist2
        barVals.dep.Text=AP.dep and AP.dep.name or "---"
        barVals.arr.Text=AP.arr and AP.arr.name or "---"

        ndDestLbl.Text="DEST: "..(AP.arr and tostring(math.floor(dist2D(hrp.Position,AP.arr.thr))).." st" or "---")
        ndWPLbl.Text="WP: "..(AP.active and (tostring(wpIdx).."/"..tostring(#waypoints)) or "-/-")
        ndPhaseLbl.Text=AP.phase; ndPhaseLbl.TextColor3=AP.active and C.green or C.red
    end)
end)

-- ════════════════════════════════════════════════════════════════════
-- ══ MAIN MENU ══════════════════════════════════════════════════════
-- ════════════════════════════════════════════════════════════════════
local MENU_W=256
local menuPanel=F(sg,0,0,MENU_W,540,0,0.5,0,-270,C.bg,0,10)
menuPanel.Visible=false; Rnd(menuPanel,10); Str(menuPanel,C.borderHi,1.5)
local menuTitle=F(menuPanel,1,0,0,34,0,0,0,0,Color3.fromRGB(10,18,32),0,11); Rnd(menuTitle,10)
L(menuTitle,"✈ PTFS  AUTOPILOT  v19",12,C.cyan,Enum.Font.GothamBold,nil,1,1,0,0,0,0,0,0,12)
makeDraggable(menuTitle,menuPanel)
local menuClose=Btn(menuPanel,"✕",11,C.white,C.redD,0,0,24,22,1,0,-28,6,13); Rnd(menuClose,4)
menuClose.MouseButton1Click:Connect(function() menuPanel.Visible=false end)

local tabs={"Takeoff","Landing","Settings","Record","Log"}
local tabBtns,tabContents={},{}
local tabBar=F(menuPanel,1,0,0,30,0,0,0,36,Color3.fromRGB(8,12,20),0,11)
local tabArea=F(menuPanel,1,1,0,-70,0,0,0,68,Color3.fromRGB(0,0,0),1,11)
local tabW=MENU_W/#tabs
for i,name in ipairs(tabs) do
    local tbtn=Btn(tabBar,name,9,C.dim,Color3.fromRGB(10,14,22),0,1,tabW-2,0,0,0,(i-1)*tabW+1,0,12)
    Rnd(tbtn,3); table.insert(tabBtns,tbtn)
    local tc=F(tabArea,1,1,0,0,0,0,0,0,Color3.fromRGB(0,0,0),1,11)
    tc.Visible=(i==1); table.insert(tabContents,tc)
    tbtn.MouseButton1Click:Connect(function()
        for j,tb in ipairs(tabBtns) do
            tb.BackgroundColor3=(j==i) and Color3.fromRGB(16,28,50) or Color3.fromRGB(10,14,22)
            tb.TextColor3=(j==i) and C.cyan or C.dim
            tabContents[j].Visible=(j==i)
        end
    end)
end
tabBtns[1].BackgroundColor3=Color3.fromRGB(16,28,50); tabBtns[1].TextColor3=C.cyan

local function makeScroll(par)
    local sf=Instance.new("ScrollingFrame")
    sf.Size=UDim2.new(1,-4,1,0); sf.Position=UDim2.new(0,2,0,0)
    sf.BackgroundTransparency=1; sf.BorderSizePixel=0
    sf.ScrollBarThickness=4; sf.ScrollBarImageColor3=C.cyanD
    sf.CanvasSize=UDim2.new(0,0,0,0); sf.AutomaticCanvasSize=Enum.AutomaticSize.Y; sf.Parent=par
    local ul=Instance.new("UIListLayout"); ul.SortOrder=Enum.SortOrder.LayoutOrder; ul.Padding=UDim.new(0,3); ul.Parent=sf
    return sf
end
local function sHdr(par,txt)
    local h=F(par,1,0,0,22,0,0,0,0,Color3.fromRGB(8,18,36),0,12); Rnd(h,3)
    L(h,txt,9,C.cyan,Enum.Font.GothamBold,Enum.TextXAlignment.Left,1,1,-8,0,0,0,4,0,13)
end
local function typeCol(t)
    if t=="International" then return C.cyan elseif t=="Regional" then return C.green
    elseif t=="Military" then return C.amber elseif t=="STOL" then return C.magenta
    else return C.dim end
end

local function rwyBtn(par,apName,rwy,isArr,selLbl)
    local bf=F(par,1,0,-8,34,0,0,4,0,Color3.fromRGB(12,18,32),0,12); Rnd(bf,5); Str(bf,C.border,1)
    L(bf,string.format("RWY %s  %03.0f°  %dm",rwy.name,rwy.hdg,rwy.len),10,C.white,
        Enum.Font.Code,Enum.TextXAlignment.Left,1,1,-8,0,0,0,5,0,13)
    local cb=Btn(bf,"",10,C.white,Color3.fromRGB(0,0,0),1,1,0,0,0,0,0,0,14)
    cb.BackgroundTransparency=1
    cb.MouseButton1Click:Connect(function()
        if isArr then AP.arr=rwy else AP.dep=rwy end
        if selLbl then
            selLbl.Text="✅ "..apName.." · RWY "..rwy.name.." ("..string.format("%03.0f",rwy.hdg).."°)"
            selLbl.TextColor3=isArr and C.cyan or C.green
        end
        TweenS:Create(bf,TweenInfo.new(0.15),{BackgroundColor3=isArr and C.cyanD or C.greenD}):Play()
        task.delay(0.4,function() TweenS:Create(bf,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(12,18,32)}):Play() end)
        -- Auto-rebuild tunnel if GPS is on
        if AP.GPS_ON and AP.dep and AP.arr then buildTunnel() end
    end)
    return bf
end

local function buildApList(scroll,isArr)
    local selF=F(scroll,1,0,0,28,0,0,0,0,Color3.fromRGB(8,14,24),0,12); Rnd(selF,4); Str(selF,C.border,1)
    local selLbl=L(selF,"Not selected",10,C.amber,Enum.Font.Code,Enum.TextXAlignment.Left,1,1,-8,0,0,0,5,0,13)
    local typeOrd={"International","Regional","STOL","Military"}
    local grp={}
    for _,ap in ipairs(Airports) do
        local t=ap.type or "Regional"; if not grp[t] then grp[t]={} end; table.insert(grp[t],ap)
    end
    for _,tName in ipairs(typeOrd) do
        local lst=grp[tName]; if not lst then continue end
        local th=F(scroll,1,0,0,16,0,0,0,0,Color3.fromRGB(6,10,22),0,12); Rnd(th,3)
        L(th,"── "..tName.." ──",8,typeCol(tName),Enum.Font.GothamBold)
        for _,ap in ipairs(lst) do
            local ah=F(scroll,1,0,0,20,0,0,0,0,Color3.fromRGB(10,22,40),0,12); Rnd(ah,3)
            L(ah,"📍 "..ap.name..(ap.icao and " ["..ap.icao.."]" or ""),9,C.white,Enum.Font.GothamBold,
                Enum.TextXAlignment.Left,1,1,-8,0,0,0,4,0,13)
            for _,rwy in ipairs(ap.runways) do rwyBtn(scroll,ap.name,rwy,isArr,selLbl) end
        end
    end
end

do local sc=makeScroll(tabContents[1]); sHdr(sc,"SELECT DEPARTURE RUNWAY"); buildApList(sc,false) end
do local sc=makeScroll(tabContents[2]); sHdr(sc,"SELECT ARRIVAL RUNWAY");   buildApList(sc,true) end

-- ── SETTINGS TAB ─────────────────────────────────────────────────
do
    local scroll=makeScroll(tabContents[3])
    sHdr(scroll,"AP SETTINGS")

    local function makeSlider(par,label,mn,mx,def,suf,cb)
        local grp=F(par,1,0,0,60,0,0,0,0,Color3.fromRGB(10,16,28),0,12); Rnd(grp,5); Str(grp,C.border,1)
        L(grp,label,9,C.dim,Enum.Font.GothamBold,Enum.TextXAlignment.Left,1,0,-8,14,0,0,4,4,13)
        local vl=L(grp,tostring(def)..suf,10,C.cyan,Enum.Font.Code,Enum.TextXAlignment.Right,0,0,64,14,1,0,-68,4,13)
        local track=F(grp,1,0,-16,6,0,0,8,38,Color3.fromRGB(20,30,50),0,13); Rnd(track,3)
        local fill=F(track,0,1,0,0,0,0,0,0,C.cyanD,0,14); Rnd(fill,3)
        local thumb=F(track,0,0,14,14,0,0.5,-7,-7,C.cyan,0,15); Rnd(thumb,7)
        local function setV(v)
            v=math.clamp(math.floor(v),mn,mx)
            local p=(v-mn)/(mx-mn)
            fill.Size=UDim2.new(p,0,1,0)
            thumb.Position=UDim2.new(p,-7,0.5,-7)
            vl.Text=tostring(v)..suf; if cb then cb(v) end
        end
        setV(def)
        local dragging=false
        local function applyPos(ix)
            local rx=track.AbsolutePosition.X; local rw=track.AbsoluteSize.X
            setV(mn+math.clamp((ix-rx)/rw,0,1)*(mx-mn))
        end
        thumb.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true end
        end)
        UIS.InputEnded:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end
        end)
        UIS.InputChanged:Connect(function(i)
            if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then applyPos(i.Position.X) end
        end)
        track.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then applyPos(i.Position.X) end
        end)
    end

    makeSlider(scroll,"Cruise Altitude",500,8000,2500," st",function(v) AP.CRUISE_ALT=v end)
    makeSlider(scroll,"Cruise Throttle",50,100,95,"%",function(v) AP.CRUISE_THR=v end)
    makeSlider(scroll,"Climb Throttle",80,100,100,"%",function(v) AP.CLIMB_THR=v end)
    makeSlider(scroll,"Approach Throttle",10,60,40,"%",function(v) AP.APP_THR=v end)
    makeSlider(scroll,"Climb Pitch",5,20,12,"°",function(v) AP.CLIMB_PITCH=v end)

    -- GPS Toggle
    local togF=F(scroll,1,0,0,36,0,0,0,0,Color3.fromRGB(10,16,28),0,12); Rnd(togF,5); Str(togF,C.border,1)
    L(togF,"GPS Tunnel Boxes",10,C.white,Enum.Font.GothamBold,Enum.TextXAlignment.Left,0.6,1,0,0,0,0,6,0,13)
    local gpsT=Btn(togF,"OFF",10,C.red,Color3.fromRGB(30,8,8),0,1,-8,-8,1,0,-82,4,13)
    Rnd(gpsT,5); Str(gpsT,C.red,1)
    gpsT.MouseButton1Click:Connect(function()
        AP.GPS_ON=not AP.GPS_ON
        if AP.GPS_ON then
            gpsT.Text="ON"; gpsT.TextColor3=C.green; gpsT.BackgroundColor3=Color3.fromRGB(0,25,12); Str(gpsT,C.green,1)
            if AP.dep and AP.arr then buildTunnel() end
        else
            gpsT.Text="OFF"; gpsT.TextColor3=C.red; gpsT.BackgroundColor3=Color3.fromRGB(30,8,8); Str(gpsT,C.red,1)
            clearTunnel()
        end
    end)
end

-- ── RECORD TAB ───────────────────────────────────────────────────
do
    local scroll=makeScroll(tabContents[4])
    sHdr(scroll,"RECORD CUSTOM RUNWAY")
    local function makeInput(par,ph,cb)
        local bx=Instance.new("TextBox")
        bx.Size=UDim2.new(1,-8,0,28); bx.Position=UDim2.new(0,4,0,0)
        bx.PlaceholderText=ph; bx.Text=""; bx.TextSize=10; bx.Font=Enum.Font.Code
        bx.TextColor3=C.white; bx.PlaceholderColor3=C.dim; bx.BackgroundColor3=Color3.fromRGB(10,16,28)
        bx.BorderSizePixel=0; bx.ClearTextOnFocus=false; bx.ZIndex=13; bx.Parent=par; Rnd(bx,4); Str(bx,C.border,1)
        bx.FocusLost:Connect(function() if cb then cb(bx.Text) end end); return bx
    end
    local recAp,recRwy="New Airport","00"
    local livePos
    makeInput(scroll,"Airport name",function(t) if t~="" then recAp=t end end)
    makeInput(scroll,"Runway no (e.g. 07R)",function(t) if t~="" then recRwy=t end end)
    local posF=F(scroll,1,0,0,26,0,0,0,0,Color3.fromRGB(8,12,20),0,12); Rnd(posF,3)
    livePos=L(posF,"Position: -",9,C.dim,Enum.Font.Code,Enum.TextXAlignment.Left,1,1,-8,0,0,0,4,0,13)
    local savBtn=Btn(scroll,"💾  SAVE RUNWAY",11,C.green,Color3.fromRGB(0,25,12),1,0,-8,30,0,0,4,0,13)
    Rnd(savBtn,5); Str(savBtn,C.green,1)
    local lsF=F(scroll,1,0,0,38,0,0,0,0,Color3.fromRGB(8,12,20),0,12); Rnd(lsF,3)
    local lastSave=L(lsF,"Last saved: -",9,C.dim,Enum.Font.Code,Enum.TextXAlignment.Left,1,1,-8,0,0,0,4,0,13)
    savBtn.MouseButton1Click:Connect(function()
        pcall(function()
            local char=Player.Character; if not char then return end
            local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
            local flat=Vector3.new(WS.CurrentCamera.CFrame.LookVector.X,0,WS.CurrentCamera.CFrame.LookVector.Z).Unit
            local hdg=math.deg(math.atan2(flat.X,flat.Z)); if hdg<0 then hdg=hdg+360 end
            local p=hrp.Position
            local thr=Vector3.new(math.floor(p.X*10)/10,math.floor(p.Y*10)/10,math.floor(p.Z*10)/10)
            local newR={name=recRwy,thr=thr,hdg=math.floor(hdg*10)/10,len=1000}
            local oppH=(hdg+180)%360; local rn=tonumber(recRwy:match("%d+"))
            local on2=rn and ((rn+17)%36+1) or nil; local onm=on2 and string.format("%02d",on2) or (recRwy.."_R")
            local oppR={name=onm,thr=thr,hdg=math.floor(oppH*10)/10,len=1000}
            local apF; for _,ap in ipairs(Airports) do if ap.name==recAp then apF=ap; break end end
            if not apF then apF={name=recAp,icao="CUST",type="Regional",runways={}}; table.insert(Airports,apF) end
            table.insert(apF.runways,newR); table.insert(apF.runways,oppR)
            lastSave.Text="✅ "..recAp.." RWY"..recRwy.."+"..onm; lastSave.TextColor3=C.green
        end)
    end)
    task.spawn(function()
        while task.wait(0.3) do pcall(function()
            local char=Player.Character; if not char then return end
            local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
            local flat=Vector3.new(WS.CurrentCamera.CFrame.LookVector.X,0,WS.CurrentCamera.CFrame.LookVector.Z).Unit
            local hdg=math.deg(math.atan2(flat.X,flat.Z)); if hdg<0 then hdg=hdg+360 end
            local pos=hrp.Position
            livePos.Text=string.format("X:%.0f Y:%.0f Z:%.0f  %03.0f°",pos.X,pos.Y,pos.Z,hdg)
        end) end
    end)
end

-- ── FLIGHT LOG TAB ───────────────────────────────────────────────
do
    local scroll=makeScroll(tabContents[5]); sHdr(scroll,"FLIGHT LOG")
    local logEntries={}
    for i=1,25 do
        local ef=F(scroll,1,0,0,18,0,0,0,0,Color3.fromRGB(8,12,22),0,12); Rnd(ef,2)
        table.insert(logEntries,L(ef,"",8,C.dim,Enum.Font.Code,Enum.TextXAlignment.Left,1,1,-8,0,0,0,3,0,13))
    end
    task.spawn(function()
        while task.wait(0.4) do pcall(function()
            for i,lbl in ipairs(logEntries) do
                local e=_G.PTFS_LOG[i]; lbl.Text=e or ""; lbl.TextColor3=e and C.white or C.dim
            end
        end) end
    end)
end

-- ════════════════════════════════════════════════════════════════════
-- ── AP POPUP ─────────────────────────────────────────────────────
-- ════════════════════════════════════════════════════════════════════
local AP_W,AP_H=278,238
local apMenu=F(sg,0,0,AP_W,AP_H,0,0.5,0,-AP_H/2,C.bg,0,20)
apMenu.Visible=false; Rnd(apMenu,10); Str(apMenu,C.borderHi,1.5)
local apTitle=F(apMenu,1,0,0,32,0,0,0,0,Color3.fromRGB(10,20,40),0,21); Rnd(apTitle,10)
L(apTitle,"AUTOPILOT CONTROL",11,C.cyan,Enum.Font.GothamBold)
makeDraggable(apTitle,apMenu)
local apClose=Btn(apMenu,"✕",11,C.white,C.redD,0,0,24,22,1,0,-28,5,22); Rnd(apClose,4)
apClose.MouseButton1Click:Connect(function() apMenu.Visible=false end)

local apStatF=F(apMenu,1,0,-12,30,0,0,6,36,Color3.fromRGB(10,30,10),0,21); Rnd(apStatF,5); Str(apStatF,C.greenD,1)
local apStatLbl=L(apStatF,"●  AP  OFF",13,C.red,Enum.Font.GothamBold,nil,1,1,0,0,0,0,0,0,22)

local routeF=F(apMenu,1,0,-12,22,0,0,6,70,Color3.fromRGB(8,12,24),0,21); Rnd(routeF,4)
local routeLbl=L(routeF,"DEP: --  →  ARR: --",9,C.dim,Enum.Font.Code,Enum.TextXAlignment.Left,1,1,-8,0,0,0,4,0,22)

-- Throttle visual bar in popup
local thrBarF=F(apMenu,1,0,-12,22,0,0,6,96,Color3.fromRGB(8,12,24),0,21); Rnd(thrBarF,4)
L(thrBarF,"THR",8,C.dim,Enum.Font.GothamBold,Enum.TextXAlignment.Left,0,0,30,22,0,0,4,0,22)
local thrBarBg=F(thrBarF,1,0,-44,10,0,0,36,6,Color3.fromRGB(15,25,15),0,22); Rnd(thrBarBg,3)
local thrBarFill=F(thrBarBg,0,1,0,0,0,0,0,0,C.green,0,23); Rnd(thrBarFill,3)
local thrBarLbl=L(thrBarF,"0%",9,C.green,Enum.Font.Code,Enum.TextXAlignment.Right,0,0,36,22,1,0,-4,0,22)

local wpF=F(apMenu,1,0,-12,20,0,0,6,122,Color3.fromRGB(8,10,20),0,21); Rnd(wpF,3)
local wpLbl=L(wpF,"PHASE: IDLE   WP: -/-",9,C.amber,Enum.Font.Code,Enum.TextXAlignment.Left,1,1,-8,0,0,0,4,0,22)

local startBtn=Btn(apMenu,"▶  START AUTOPILOT",12,C.green,Color3.fromRGB(0,30,15),1,0,-12,32,0,0,6,148,22)
Rnd(startBtn,6); Str(startBtn,C.green,1)
startBtn.MouseButton1Click:Connect(function()
    local ok,msg=startAP()
    startBtn.Text=ok and ("✅ "..msg) or ("❌ "..msg)
    task.delay(2.5,function() startBtn.Text="▶  START AUTOPILOT" end)
end)

local stopBtn=Btn(apMenu,"■  STOP",12,C.red,Color3.fromRGB(30,8,8),1,0,-12,30,0,0,6,188,22)
Rnd(stopBtn,6); Str(stopBtn,C.red,1)
stopBtn.MouseButton1Click:Connect(function() stopAP("Manual") end)

-- AP popup updater
task.spawn(function()
    while task.wait(0.25) do pcall(function()
        if AP.active then
            apStatLbl.Text="●  AP  ON — "..AP.phase; apStatLbl.TextColor3=C.green
            apStatF.BackgroundColor3=Color3.fromRGB(5,30,12)
        else
            apStatLbl.Text="●  AP  OFF"; apStatLbl.TextColor3=C.red
            apStatF.BackgroundColor3=Color3.fromRGB(25,8,8)
        end
        routeLbl.Text="DEP: "..(AP.dep and AP.dep.name or "--").."   →   ARR: "..(AP.arr and AP.arr.name or "--")

        -- Live throttle bar
        local tPct=math.clamp(throttleActual/100,0,1)
        thrBarFill.Size=UDim2.new(tPct,0,1,0)
        thrBarFill.BackgroundColor3=tPct>0.7 and C.green or (tPct>0.3 and C.amber or C.dim)
        thrBarLbl.Text=string.format("%.0f%%",throttleActual)

        wpLbl.Text=string.format("PHASE: %s   WP: %s/%s",AP.phase,tostring(wpIdx),tostring(#waypoints))
    end) end
end)

-- ════════════════════════════════════════════════════════════════════
-- ── RIGHT DOCK ────────────────────────────────────────────────────
-- ════════════════════════════════════════════════════════════════════
local dockW=130
local dock=F(sg,0,0,dockW,162,1,0.5,-dockW-8,-81,C.bg,0,15)
Rnd(dock,8); Str(dock,C.border,1)
makeDraggable(dock,dock)

local dockTitle=F(dock,1,0,0,24,0,0,0,0,Color3.fromRGB(10,16,30),0,16); Rnd(dockTitle,8)
L(dockTitle,"✈ PTFS v19",10,C.cyan,Enum.Font.GothamBold)
makeDraggable(dockTitle,dock)

local function dockBtn(y,txt,bg,brd,cb)
    local b=Btn(dock,txt,10,C.white,bg,1,0,-8,28,0,0,4,y,16)
    Rnd(b,5); Str(b,brd,1); b.MouseButton1Click:Connect(cb); return b
end

local dockApF=F(dock,1,0,-8,14,0,0,4,130,Color3.fromRGB(25,8,8),0,16); Rnd(dockApF,3)
local dockApLbl=L(dockApF,"AP OFF",8,C.red,Enum.Font.GothamBold,nil,1,1,0,0,0,0,0,0,17)
task.spawn(function()
    while task.wait(0.4) do pcall(function()
        dockApLbl.Text=AP.active and ("AP "..AP.phase) or "AP OFF"
        dockApLbl.TextColor3=AP.active and C.green or C.red
        dockApF.BackgroundColor3=AP.active and Color3.fromRGB(5,30,10) or Color3.fromRGB(25,8,8)
    end) end
end)

dockBtn(26,"☰  MENU",Color3.fromRGB(12,20,40),C.borderHi,function()
    menuPanel.Visible=not menuPanel.Visible
    if menuPanel.Visible then menuPanel.Position=UDim2.new(1,-dockW-8-MENU_W-8,0.5,-270) end
end)
local apDockBtn=dockBtn(58,"✈  AUTOPILOT",Color3.fromRGB(0,18,8),C.green,function()
    apMenu.Visible=not apMenu.Visible
    if apMenu.Visible then apMenu.Position=UDim2.new(1,-dockW-8-AP_W-8,0.5,-AP_H/2) end
end)
Str(apDockBtn,C.green,1)
dockBtn(92,"🖥  HUD",Color3.fromRGB(8,12,28),C.borderHi,function() hud.Visible=not hud.Visible end)

-- Mobile: larger touch targets
if UIS.TouchEnabled then
    for _,d in ipairs(dock:GetDescendants()) do
        if d:IsA("TextButton") then d.TextSize=math.ceil((d.TextSize or 10)*1.15) end
    end
end

-- ════════════════════════════════════════════════════════════════════
print("════════════════════════════════════════")
print("✅ PTFS Autopilot v19 loaded!")
print("   NATIVE THROTTLE: W/S keys drive PTFS slider")
print("   BodyGyro: heading + pitch control only")
print("   "..#Airports.." airports loaded")
local nr=0; for _,a in ipairs(Airports) do nr=nr+#a.runways end
print("   "..nr.." runways | GPS tunnel | Mobile ready")
print("════════════════════════════════════════")
