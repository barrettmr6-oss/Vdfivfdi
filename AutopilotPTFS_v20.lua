-- ╔══════════════════════════════════════════════════════════════════╗
-- ║           PTFS AUTOPILOT v20 — CLEAN RELIABLE EDITION           ║
-- ╠══════════════════════════════════════════════════════════════════╣
-- ║  HOW IT WORKS (from research):                                   ║
-- ║   • BodyVelocity drives aircraft through waypoints               ║
-- ║   • BodyGyro keeps nose pointed correctly                        ║
-- ║   • W held 0.033s = 1% throttle (PTFS native slider synced)     ║
-- ║   • E = engine on (ONE tap only, never spam)                     ║
-- ║   • 3° ILS glideslope → flare → butter landing every time       ║
-- ║   • GPS tunnel boxes mark every phase visually                   ║
-- ║   • Clean simple UI — no mess, all draggable                     ║
-- ╚══════════════════════════════════════════════════════════════════╝

-- ── Services ────────────────────────────────────────────────────────
local RS  = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS  = game:GetService("TweenService")
local WS  = game:GetService("Workspace")
local VIM = game:GetService("VirtualInputManager")
local P   = game:GetService("Players").LocalPlayer
local PG  = P:WaitForChild("PlayerGui")

-- ── Wipe old GUIs & tunnel ──────────────────────────────────────────
for _,n in ipairs({"PTFSv20","PTFSv19","PTFSv18","PTFSMain","PTFSTunnel"}) do
    if PG:FindFirstChild(n) then PG[n]:Destroy() end
end
for _,n in ipairs({"PTFS_Tunnel"}) do
    if WS:FindFirstChild(n) then WS[n]:Destroy() end
end

-- ════════════════════════════════════════════════════════════════════
-- AIRPORT DATABASE  (all PTFS airports, correct headings)
-- heading = magnetic degrees the runway NUMBER points
-- thr     = threshold position (start of the runway you land/depart from)
-- len     = runway length in studs
-- ════════════════════════════════════════════════════════════════════
local DB = {
    -- ─── INTERNATIONAL ──────────────────────────────────────────────
    { name="Greater Rockford",     icao="IRFD", cat="Intl",
      rwys={
        {id="07L", thr=Vector3.new(-3500,3.3,20750),  hdg=67,  len=3200},
        {id="25R", thr=Vector3.new(-380, 3.3,19950),  hdg=247, len=3200},
        {id="07C", thr=Vector3.new(-3490,3.3,20700),  hdg=67,  len=3100},
        {id="25C", thr=Vector3.new(-370, 3.3,20000),  hdg=247, len=3100},
        {id="07R", thr=Vector3.new(-3481,3.3,20650),  hdg=67,  len=3000},
        {id="25L", thr=Vector3.new(-360, 3.3,20010),  hdg=247, len=3000},
    }},
    { name="Tokyo International",  icao="RJTT", cat="Intl",
      rwys={
        {id="02",  thr=Vector3.new(-6399,21.5,-32327), hdg=20,  len=4850},
        {id="20",  thr=Vector3.new(-6922,21.5,-27800), hdg=200, len=4850},
        {id="13",  thr=Vector3.new(-4900,21.5,-32100), hdg=131, len=3600},
        {id="31",  thr=Vector3.new(-7600,21.5,-29600), hdg=311, len=3600},
    }},
    { name="Perth International",  icao="YPPH", cat="Intl",
      rwys={
        {id="11",  thr=Vector3.new(6200,25,4800),      hdg=111, len=3200},
        {id="29",  thr=Vector3.new(8800,25,5600),      hdg=291, len=3200},
        {id="15",  thr=Vector3.new(6700,25,4300),      hdg=151, len=2500},
        {id="33",  thr=Vector3.new(7600,25,6500),      hdg=133, len=2500},
    }},
    { name="Izolirani Airport",    icao="LIIZ", cat="Intl",
      rwys={
        {id="10",  thr=Vector3.new(-9200,9,15800),     hdg=106, len=3200},
        {id="28",  thr=Vector3.new(-6300,9,16600),     hdg=286, len=3200},
    }},
    -- ─── REGIONAL ───────────────────────────────────────────────────
    { name="Saint Barthélemy",     icao="TFFJ", cat="Regional",
      rwys={
        {id="09",  thr=Vector3.new(5470,11.5,-4486),   hdg=92,  len=600},
        {id="27",  thr=Vector3.new(5880,11.5,-4486),   hdg=272, len=600},
    }},
    { name="Larnaca Airport",      icao="LCLK", cat="Regional",
      rwys={
        {id="04",  thr=Vector3.new(11200,18,-8200),    hdg=40,  len=2800},
        {id="22",  thr=Vector3.new(12700,18,-6500),    hdg=220, len=2800},
    }},
    { name="Paphos Airport",       icao="LCPH", cat="Regional",
      rwys={
        {id="11",  thr=Vector3.new(10100,28,-10600),   hdg=110, len=2200},
        {id="29",  thr=Vector3.new(11500,28,-9800),    hdg=290, len=2200},
    }},
    { name="Sauthemptona Airport", icao="ESOU", cat="Regional",
      rwys={
        {id="02",  thr=Vector3.new(-1200,8,-2800),     hdg=20,  len=1800},
        {id="20",  thr=Vector3.new(-900, 8,-1400),     hdg=200, len=1800},
    }},
    { name="Saba Airport",         icao="TNCS", cat="Regional",
      rwys={
        {id="12",  thr=Vector3.new(-8200,148,-24600),  hdg=120, len=400},
        {id="30",  thr=Vector3.new(-7970,148,-24270),  hdg=300, len=400},
    }},
    { name="Skopelos Airfield",    icao="LGSK", cat="Regional",
      rwys={
        {id="09",  thr=Vector3.new(14200,12,-3200),    hdg=90,  len=900},
        {id="27",  thr=Vector3.new(14900,12,-3200),    hdg=270, len=900},
    }},
    { name="Waterloo Airport",     icao="EBWL", cat="Regional",
      rwys={
        {id="06",  thr=Vector3.new(-4800,18,10200),    hdg=60,  len=1200},
        {id="24",  thr=Vector3.new(-4200,18,10640),    hdg=240, len=1200},
    }},
    { name="Sea Haven",            icao="SEAH", cat="Regional",
      rwys={
        {id="18",  thr=Vector3.new(2800,4,-14200),     hdg=180, len=1600},
        {id="36",  thr=Vector3.new(2800,4,-12850),     hdg=360, len=1600},
    }},
    -- ─── STOL ───────────────────────────────────────────────────────
    { name="Lukla Airport",        icao="VNLK", cat="STOL",
      rwys={
        {id="06",  thr=Vector3.new(7100,950,4200),     hdg=62,  len=400},
        {id="24",  thr=Vector3.new(7340,960,4310),     hdg=242, len=400},
    }},
    { name="Barra Airport",        icao="EGPR", cat="STOL",
      rwys={
        {id="12",  thr=Vector3.new(3100,4,-6200),      hdg=120, len=700},
        {id="30",  thr=Vector3.new(3490,4,-5810),      hdg=300, len=700},
        {id="07",  thr=Vector3.new(3000,4,-6050),      hdg=70,  len=600},
        {id="25",  thr=Vector3.new(3340,4,-5950),      hdg=250, len=600},
    }},
    { name="Mellor Airfield",      icao="IMLR", cat="STOL",
      rwys={
        {id="07",  thr=Vector3.new(-2800,420,17800),   hdg=70,  len=500},
        {id="25",  thr=Vector3.new(-2420,420,17935),   hdg=250, len=500},
    }},
    { name="Katcui Airfield",      icao="KATC", cat="STOL",
      rwys={
        {id="14",  thr=Vector3.new(-6600,12,-19200),   hdg=140, len=600},
        {id="32",  thr=Vector3.new(-6290,12,-18810),   hdg=320, len=600},
    }},
    -- ─── MILITARY ───────────────────────────────────────────────────
    { name="McConnell AFB",        icao="KMCC", cat="Military",
      rwys={
        {id="01L", thr=Vector3.new(-3200,8,15200),     hdg=10,  len=2800},
        {id="19R", thr=Vector3.new(-2710,8,17960),     hdg=190, len=2800},
        {id="01R", thr=Vector3.new(-3100,8,15200),     hdg=10,  len=2800},
        {id="19L", thr=Vector3.new(-2610,8,17960),     hdg=190, len=2800},
    }},
    { name="RAF Scampton",         icao="EGXP", cat="Military",
      rwys={
        {id="13",  thr=Vector3.new(-8800,9,17800),     hdg=130, len=2400},
        {id="31",  thr=Vector3.new(-7175,9,19330),     hdg=310, len=2400},
    }},
    { name="Al Najaf Airfield",    icao="ALAJ", cat="Military",
      rwys={
        {id="07",  thr=Vector3.new(-9800,9,16800),     hdg=70,  len=900},
        {id="25",  thr=Vector3.new(-9290,9,16987),     hdg=250, len=900},
    }},
    { name="Training Centre",      icao="TRNC", cat="Military",
      rwys={
        {id="09",  thr=Vector3.new(-200,4,200),        hdg=90,  len=800},
        {id="27",  thr=Vector3.new(400, 4,200),        hdg=270, len=800},
    }},
}

-- ════════════════════════════════════════════════════════════════════
-- MATH HELPERS
-- ════════════════════════════════════════════════════════════════════
local function dir(deg)          -- heading degrees → unit vector
    local r = math.rad(deg)
    return Vector3.new(math.sin(r), 0, math.cos(r))
end
local function dist(a, b)        -- 2D ground distance
    return math.sqrt((a.X-b.X)^2 + (a.Z-b.Z)^2)
end
local function lerp(a, b, t)
    return a + (b-a)*math.clamp(t,0,1)
end

-- ════════════════════════════════════════════════════════════════════
-- KEY INPUT  (VirtualInputManager — works in Roblox exploits)
-- ════════════════════════════════════════════════════════════════════
local function kDown(k) pcall(function() VIM:SendKeyEvent(true,  Enum.KeyCode[k], false, game) end) end
local function kUp(k)   pcall(function() VIM:SendKeyEvent(false, Enum.KeyCode[k], false, game) end) end
local function kTap(k)  kDown(k); task.wait(0.05); kUp(k) end

-- ════════════════════════════════════════════════════════════════════
-- PTFS THROTTLE SYNC
-- W held 0.033s ≈ 1% throttle (confirmed from ptfs-joystick research)
-- We sync our internal estimate and pulse W/S each heartbeat
-- ════════════════════════════════════════════════════════════════════
local thrTarget  = 0   -- what we want (0-100)
local thrCurrent = 0   -- our internal estimate
local thrConn    = nil

local function setThr(pct) thrTarget = math.clamp(pct, 0, 100) end

local function startThr()
    if thrConn then thrConn:Disconnect() end
    thrConn = RS.Heartbeat:Connect(function(dt)
        local gap = thrTarget - thrCurrent
        if math.abs(gap) < 0.8 then
            kUp("W"); kUp("S"); return
        end
        if gap > 0 then
            kDown("W"); kUp("S")
            thrCurrent = math.min(thrCurrent + dt/0.033, 100)
        else
            kDown("S"); kUp("W")
            thrCurrent = math.max(thrCurrent - dt/0.033, 0)
        end
    end)
end
local function stopThr()
    if thrConn then thrConn:Disconnect(); thrConn = nil end
    kUp("W"); kUp("S")
    thrTarget = 0; thrCurrent = 0
end

-- ════════════════════════════════════════════════════════════════════
-- AUTOPILOT STATE
-- ════════════════════════════════════════════════════════════════════
local AP = {
    on       = false,
    phase    = "IDLE",   -- IDLE TAKEOFF CLIMB CRUISE DESCEND APPROACH FLARE ROLLOUT
    dep      = nil,      -- departure runway table
    arr      = nil,      -- arrival runway table
    root     = nil,      -- aircraft BasePart
    ac       = nil,      -- aircraft Model
    -- Tunable
    cruiseAlt  = 2500,
    cruiseSpd  = 280,
    climbSpd   = 240,
    landSpd    = 110,
    climbPitch = 12,
    gpsOn      = false,
}

local bv, bg        = nil, nil   -- BodyVelocity, BodyGyro
local loopConn      = nil
local LOG           = {}

local function log(s)
    table.insert(LOG, 1, ("[%.0f] %s"):format(tick() % 10000, s))
    if #LOG > 30 then table.remove(LOG) end
end

-- ════════════════════════════════════════════════════════════════════
-- BODY MOVERS  — BodyVelocity steers, BodyGyro orients
-- ════════════════════════════════════════════════════════════════════
local function applyFlight(velocity, lookDir)
    if bv and bv.Parent then bv.Velocity = velocity end
    if bg and bg.Parent and lookDir and lookDir.Magnitude > 0.01 then
        bg.CFrame = CFrame.new(Vector3.zero, lookDir.Unit)
    end
end

-- ════════════════════════════════════════════════════════════════════
-- WAYPOINTS
-- ════════════════════════════════════════════════════════════════════
local WPS = {}  -- list of {pos, label, onArrive}
local wpI  = 1

local function buildWPs()
    WPS = {}; wpI = 1
    local d  = AP.dep; local a = AP.arr
    local dd = dir(d.hdg); local ad = dir(a.hdg)
    local alt = AP.cruiseAlt; local at = a.thr

    -- 1. Climb-out point — 3000 st ahead at cruise alt
    local co = d.thr + dd*3000
    WPS[#WPS+1] = {
        pos = Vector3.new(co.X, alt, co.Z), label = "CLIMB-OUT",
        onArrive = function()
            AP.phase = "CRUISE"; setThr(88)
            log("Cruise phase — "..alt.."st")
        end
    }
    -- 2. Midpoint
    WPS[#WPS+1] = {
        pos = Vector3.new((d.thr.X+at.X)/2, alt, (d.thr.Z+at.Z)/2),
        label = "MID", onArrive = function() end
    }
    -- 3. Descent gate — 10000 st from arr on extended centreline
    local dg = at - ad*10000
    WPS[#WPS+1] = {
        pos = Vector3.new(dg.X, alt, dg.Z), label = "DESCENT",
        onArrive = function()
            AP.phase = "DESCEND"; setThr(45)
            task.spawn(function() kTap("F") end)
            log("Descending — flaps")
        end
    }
    -- 4. Approach fix — 5000 st out, on 3° glideslope height
    local af = at - ad*5000
    local afAlt = at.Y + math.tan(math.rad(3))*5000   -- ~262 st above thr
    WPS[#WPS+1] = {
        pos = Vector3.new(af.X, afAlt, af.Z), label = "APP FIX",
        onArrive = function()
            AP.phase = "APPROACH"; setThr(30)
            task.spawn(function() task.wait(0.5); kTap("G") end)
            log("Approach — gear down")
        end
    }
end

-- ════════════════════════════════════════════════════════════════════
-- GPS TUNNEL BOXES
-- ════════════════════════════════════════════════════════════════════
local tunnelFolder = nil
local function clearTunnel()
    if tunnelFolder and tunnelFolder.Parent then tunnelFolder:Destroy() end
    tunnelFolder = nil
end

local function makeBox(cf, sz, col)
    local p = Instance.new("Part")
    p.Anchored=true; p.CanCollide=false; p.CanQuery=false
    p.Size=sz; p.CFrame=cf; p.Color=col
    p.Material=Enum.Material.Neon; p.Transparency=0.55; p.CastShadow=false
    p.Parent=tunnelFolder
    local sel=Instance.new("SelectionBox")
    sel.Adornee=p; sel.Color3=col; sel.LineThickness=0.06
    sel.SurfaceTransparency=1; sel.Parent=tunnelFolder
end

local function buildTunnel()
    clearTunnel()
    if not AP.dep or not AP.arr then return end
    tunnelFolder = Instance.new("Folder"); tunnelFolder.Name="PTFS_Tunnel"; tunnelFolder.Parent=WS

    local d=AP.dep; local a=AP.arr
    local dd=dir(d.hdg); local ad=dir(a.hdg)
    local alt=AP.cruiseAlt; local at=a.thr

    -- Climb: 7 green boxes
    for i=1,7 do
        local frac=i/7; local pt=d.thr+dd*(i*500)
        local bAlt=d.thr.Y+(alt-d.thr.Y)*frac
        pt=Vector3.new(pt.X,bAlt,pt.Z)
        makeBox(CFrame.new(pt,pt+dd), Vector3.new(55-frac*15, 38-frac*10, 5), Color3.fromRGB(0,240,100))
    end

    -- Cruise: cyan boxes
    local csS=d.thr+dd*3500; local csE=at-ad*10000
    local csv=Vector3.new(csE.X-csS.X,0,csE.Z-csS.Z)
    local csd=csv.Magnitude
    if csd>200 then
        local csu=csv.Unit; local steps=math.max(2,math.floor(csd/1800))
        for i=1,steps do
            local pt=Vector3.new(csS.X,alt,csS.Z)+csu*(i/steps*csd)
            makeBox(CFrame.new(pt,pt+csu), Vector3.new(48,28,5), Color3.fromRGB(40,200,255))
        end
    end

    -- Approach: 15 amber→red boxes on 3° slope
    for i=1,15 do
        local frac=i/15; local d2=10000*(1-frac)
        local pt=at-ad*d2; local bAlt=at.Y+math.tan(math.rad(3))*d2
        pt=Vector3.new(pt.X,bAlt,pt.Z)
        local w=55*(1-frac*0.4); local h=38*(1-frac*0.4)
        local col=(d2<2000) and Color3.fromRGB(255,70,50) or Color3.fromRGB(255,185,0)
        makeBox(CFrame.new(pt,pt+ad), Vector3.new(w,h,5), col)
    end

    -- Touchdown stripes (cyan)
    for i=1,4 do
        local pt=at+ad*(i*160); pt=Vector3.new(pt.X,at.Y+0.6,pt.Z)
        makeBox(CFrame.new(pt,pt+ad), Vector3.new(24,4,65), Color3.fromRGB(0,255,220))
    end
end

-- ════════════════════════════════════════════════════════════════════
-- STOP
-- ════════════════════════════════════════════════════════════════════
local function stopAP(reason)
    AP.on=false; AP.phase="IDLE"
    stopThr()
    if loopConn then loopConn:Disconnect(); loopConn=nil end
    if bv and bv.Parent  then bv:Destroy();  bv=nil end
    if bg and bg.Parent  then bg:Destroy();  bg=nil end
    if not AP.gpsOn then clearTunnel() end
    log("STOPPED: "..(reason or "manual"))
end

-- ════════════════════════════════════════════════════════════════════
-- MAIN FLIGHT LOOP
-- ════════════════════════════════════════════════════════════════════
local function startLoop()
    wpI = 1
    if loopConn then loopConn:Disconnect() end

    loopConn = RS.Heartbeat:Connect(function(dt)
        if not AP.on then loopConn:Disconnect(); loopConn=nil; return end

        -- Re-acquire root
        if not AP.root or not AP.root.Parent then
            local char=P.Character; if not char then return end
            local hum=char:FindFirstChildOfClass("Humanoid")
            if hum and hum.SeatPart then
                AP.ac=hum.SeatPart.Parent
                AP.root = AP.ac:FindFirstChild("Body")
                    or AP.ac:FindFirstChild("Fuselage")
                    or AP.ac:FindFirstChild("Main")
                    or hum.SeatPart
            end; return
        end

        -- Ensure BodyVelocity
        if not bv or not bv.Parent then
            pcall(function()
                bv=Instance.new("BodyVelocity")
                bv.MaxForce=Vector3.new(1e9,1e9,1e9); bv.P=1e5
                bv.Velocity=Vector3.new(0,0,0); bv.Parent=AP.root
            end); return
        end

        -- Ensure BodyGyro
        if not bg or not bg.Parent then
            pcall(function()
                bg=Instance.new("BodyGyro")
                bg.MaxTorque=Vector3.new(1e9,1e9,1e9)
                bg.P=5e4; bg.D=3000
                bg.CFrame=AP.root.CFrame; bg.Parent=AP.root
            end); return
        end

        local pos  = AP.root.Position
        local alt  = pos.Y
        local at   = AP.arr.thr
        local ad   = dir(AP.arr.hdg)
        local dd   = dir(AP.dep.hdg)

        -- ── TAKEOFF ──────────────────────────────────────────────────
        if AP.phase == "TAKEOFF" then
            setThr(100)
            -- Full throttle roll, then rotate when fast enough
            local spd = AP.root.AssemblyLinearVelocity.Magnitude
            local pitchFrac = spd > 80 and math.tan(math.rad(AP.climbPitch)) or 0
            local moveDir = (dd + Vector3.new(0, pitchFrac, 0)).Unit
            applyFlight(moveDir * AP.climbSpd, moveDir)

            if alt > AP.dep.thr.Y + 60 then
                AP.phase = "CLIMB"
                task.spawn(function() task.wait(2); kTap("G") end)   -- gear up after 2s
                log("Climbing")
            end

        -- ── CLIMB ────────────────────────────────────────────────────
        elseif AP.phase == "CLIMB" then
            setThr(100)
            if wpI > #WPS then AP.phase="CRUISE"; return end
            local wp = WPS[wpI]
            local toWP  = wp.pos - pos
            local hFlat = Vector3.new(toWP.X, 0, toWP.Z)
            local hDir  = hFlat.Magnitude > 5 and hFlat.Unit or dd
            local altErr = wp.pos.Y - alt
            local yComp  = math.clamp(altErr * 0.005, -0.2, 0.4)
            applyFlight((hDir + Vector3.new(0,yComp,0)).Unit * AP.climbSpd, hDir)

            if dist(pos, wp.pos) < 700 then
                wp.onArrive(); wpI = wpI + 1
            end

        -- ── CRUISE ───────────────────────────────────────────────────
        elseif AP.phase == "CRUISE" then
            setThr(88)
            if wpI > #WPS then AP.phase="DESCEND"; return end
            local wp = WPS[wpI]
            local toWP  = wp.pos - pos
            local hFlat = Vector3.new(toWP.X, 0, toWP.Z)
            local hDir  = hFlat.Magnitude > 5 and hFlat.Unit or ad
            local altErr = wp.pos.Y - alt
            local yComp  = math.clamp(altErr * 0.003, -0.1, 0.1)
            applyFlight((hDir + Vector3.new(0,yComp,0)).Unit * AP.cruiseSpd, hDir)

            if dist(pos, wp.pos) < 900 then
                wp.onArrive(); wpI = wpI + 1
            end

        -- ── DESCEND ──────────────────────────────────────────────────
        elseif AP.phase == "DESCEND" then
            setThr(45)
            if wpI > #WPS then AP.phase="APPROACH"; return end
            local wp = WPS[wpI]
            local toWP  = wp.pos - pos
            local hFlat = Vector3.new(toWP.X, 0, toWP.Z)
            local hDir  = hFlat.Magnitude > 5 and hFlat.Unit or ad
            local altErr = wp.pos.Y - alt
            local yComp  = math.clamp(altErr * 0.005, -0.3, 0.08)
            local spd    = lerp(AP.cruiseSpd, AP.landSpd*1.3, math.clamp((AP.cruiseAlt-alt)/(AP.cruiseAlt-wp.pos.Y),0,1))
            applyFlight((hDir + Vector3.new(0,yComp,0)).Unit * spd, hDir)

            if dist(pos, wp.pos) < 700 then
                wp.onArrive(); wpI = wpI + 1
            end

        -- ── APPROACH — precision 3° ILS ───────────────────────────────
        elseif AP.phase == "APPROACH" then
            setThr(30)

            -- Service remaining waypoints
            if wpI <= #WPS then
                if dist(pos, WPS[wpI].pos) < 500 then
                    WPS[wpI].onArrive(); wpI = wpI + 1
                end
            end

            -- Fly straight to threshold
            local toThr  = Vector3.new(at.X-pos.X, 0, at.Z-pos.Z)
            local hDir   = toThr.Magnitude > 5 and toThr.Unit or ad
            local hDist  = dist(pos, at)
            local hAbove = alt - at.Y

            -- 3° ideal altitude: tan(3°)*hDist above threshold
            local idealAlt = at.Y + math.tan(math.rad(3)) * hDist
            local altErr   = idealAlt - alt   -- positive = we're below slope (need to climb)
            -- Clamp vertical component: gentle, no steep dives
            local yComp = math.clamp(altErr * 0.06, -0.35, 0.06)

            -- Speed: reduce from 1.4x to 1.0x landing speed as we get close
            local spdFrac = math.clamp(hDist / 8000, 1.0, 1.4)
            local spd = AP.landSpd * spdFrac

            applyFlight((hDir + Vector3.new(0, yComp, 0)).Unit * spd, hDir)

            if hAbove < 45 then
                AP.phase = "FLARE"
                log("Flare at "..string.format("%.0f", hAbove).." st AGL")
            end

        -- ── FLARE — smooth butter landing ────────────────────────────
        elseif AP.phase == "FLARE" then
            -- Kill throttle during flare
            setThr(0)

            local toThr  = Vector3.new(at.X-pos.X, 0, at.Z-pos.Z)
            local hDir   = toThr.Magnitude > 5 and toThr.Unit or ad
            local hAbove = alt - at.Y

            -- Progressive sink rate: less and less as we get closer to ground
            local sink
            if hAbove > 28 then      sink = -0.10
            elseif hAbove > 16 then  sink = -0.06
            elseif hAbove > 8  then  sink = -0.03
            elseif hAbove > 3  then  sink = -0.012
            elseif hAbove > 1  then  sink = -0.004
            else                     sink = 0
            end

            -- Speed: slow to landing speed
            local spd = math.max(AP.landSpd, lerp(AP.landSpd*1.3, AP.landSpd, (45-hAbove)/45))
            applyFlight((hDir + Vector3.new(0, sink, 0)).Unit * spd, hDir)

            if hAbove <= 1.5 or alt <= at.Y + 1.5 then
                AP.phase = "ROLLOUT"
                task.spawn(function()
                    kTap("B")   -- brakes
                    task.wait(0.3); kTap("R")   -- reverse/spoilers
                end)
                log("Touchdown! ✅")
            end

        -- ── ROLLOUT — brake on runway ─────────────────────────────────
        elseif AP.phase == "ROLLOUT" then
            setThr(0)
            local toThr = Vector3.new(at.X-pos.X, 0, at.Z-pos.Z)
            local hDir  = toThr.Magnitude > 10 and toThr.Unit or ad
            local vel   = AP.root.AssemblyLinearVelocity
            local spd   = math.max(vel.Magnitude - 800*dt, 0)
            applyFlight(hDir * spd, hDir)

            if spd < 3 then
                applyFlight(Vector3.zero, hDir)
                task.spawn(function() kTap("B"); task.wait(0.2); kTap("X") end)
                stopAP("Flight complete ✅")
            end
        end
    end)
end

-- ════════════════════════════════════════════════════════════════════
-- START AP
-- ════════════════════════════════════════════════════════════════════
local function startAP()
    if AP.on         then return false, "Already active" end
    if not AP.dep    then return false, "Select departure runway" end
    if not AP.arr    then return false, "Select arrival runway" end
    if AP.dep==AP.arr then return false, "Dep = Arr!" end

    local char = P.Character; if not char then return false, "No character" end
    local hum  = char:FindFirstChildOfClass("Humanoid")
    if not hum or not hum.SeatPart then return false, "Sit in an aircraft first" end

    AP.ac   = hum.SeatPart.Parent
    AP.root = AP.ac:FindFirstChild("Body")
        or AP.ac:FindFirstChild("Fuselage")
        or AP.ac:FindFirstChild("Main")
        or hum.SeatPart

    AP.on=true; AP.phase="TAKEOFF"; LOG={}
    log("START "..AP.dep.id.." → "..AP.arr.id)

    -- Destroy old movers
    if bv and bv.Parent then bv:Destroy() end
    if bg and bg.Parent then bg:Destroy() end

    bv = Instance.new("BodyVelocity")
    bv.MaxForce=Vector3.new(1e9,1e9,1e9); bv.P=1e5
    bv.Velocity=Vector3.new(0,0,0); bv.Parent=AP.root

    bg = Instance.new("BodyGyro")
    bg.MaxTorque=Vector3.new(1e9,1e9,1e9)
    bg.P=5e4; bg.D=3000
    bg.CFrame=AP.root.CFrame; bg.Parent=AP.root

    -- Position at runway threshold
    local dd = dir(AP.dep.hdg)
    local sp = AP.dep.thr - dd*80
    sp = Vector3.new(sp.X, AP.dep.thr.Y+2, sp.Z)
    pcall(function() AP.ac:PivotTo(CFrame.new(sp, sp+dd)) end)

    buildWPs()
    if AP.gpsOn then buildTunnel() end

    -- Engine ON (one press only — PTFS toggles on single press)
    startThr()
    task.wait(0.3)
    task.spawn(function()
        kTap("E")            -- engine on
        task.wait(0.6)
        kTap("F")            -- takeoff flaps
    end)

    task.wait(0.8)
    startLoop()
    return true, "Departed! 🛫"
end

P.CharacterAdded:Connect(function()
    if AP.on then stopAP("Respawn") end
end)

-- ════════════════════════════════════════════════════════════════════
-- ════════════════════════════════════════════════════════════════════
--                          CLEAN UI
-- ════════════════════════════════════════════════════════════════════
-- ════════════════════════════════════════════════════════════════════

local Col = {
    bg   = Color3.fromRGB(10,13,20),
    card = Color3.fromRGB(15,20,32),
    hi   = Color3.fromRGB(18,28,48),
    bdr  = Color3.fromRGB(40,65,100),
    bdrHi= Color3.fromRGB(55,130,220),
    grn  = Color3.fromRGB(0,220,120),
    grnD = Color3.fromRGB(0,110,60),
    cyn  = Color3.fromRGB(30,190,255),
    cynD = Color3.fromRGB(0,90,150),
    amb  = Color3.fromRGB(255,185,0),
    red  = Color3.fromRGB(255,60,60),
    redD = Color3.fromRGB(110,18,18),
    wht  = Color3.fromRGB(215,228,245),
    dim  = Color3.fromRGB(80,100,128),
    mag  = Color3.fromRGB(195,55,195),
    pur  = Color3.fromRGB(135,75,215),
    sky  = Color3.fromRGB(25,80,170),
    gnd  = Color3.fromRGB(105,68,28),
}

-- ─── Raw UI builders ────────────────────────────────────────────────
local function fr(par,sx,sy,ox,oy,px,py,opx,opy,col,tr,zi)
    local f=Instance.new("Frame"); f.BorderSizePixel=0
    f.Size=UDim2.new(sx,ox,sy,oy); f.Position=UDim2.new(px,opx,py,opy)
    f.BackgroundColor3=col or Col.card
    f.BackgroundTransparency=tr or 0
    f.ZIndex=zi or 1; f.Parent=par; return f
end
local function lb(par,txt,ts,col,fnt,xa,sx,sy,ox,oy,px,py,opx,opy,zi)
    local l=Instance.new("TextLabel"); l.BorderSizePixel=0
    l.Text=txt or ""; l.TextSize=ts or 11; l.TextColor3=col or Col.wht
    l.Font=fnt or Enum.Font.GothamBold; l.BackgroundTransparency=1
    l.TextXAlignment=xa or Enum.TextXAlignment.Center
    l.Size=UDim2.new(sx or 1,ox or 0,sy or 1,oy or 0)
    l.Position=UDim2.new(px or 0,opx or 0,py or 0,opy or 0)
    l.ZIndex=zi or 2; l.Parent=par; return l
end
local function bt(par,txt,ts,col,bg,sx,sy,ox,oy,px,py,opx,opy,zi)
    local b=Instance.new("TextButton"); b.BorderSizePixel=0
    b.Text=txt or ""; b.TextSize=ts or 11; b.TextColor3=col or Col.wht
    b.Font=Enum.Font.GothamBold; b.AutoButtonColor=false
    b.BackgroundColor3=bg or Col.card
    b.Size=UDim2.new(sx or 0,ox or 80,sy or 0,oy or 30)
    b.Position=UDim2.new(px or 0,opx or 0,py or 0,opy or 0)
    b.ZIndex=zi or 3; b.Parent=par; return b
end
local function rnd(i,r) local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r or 6); c.Parent=i end
local function strk(i,col,t) local s=Instance.new("UIStroke"); s.Color=col; s.Thickness=t or 1; s.Parent=i end

-- Drag: mouse + touch
local function drag(handle, win)
    local on,si,sp=false,nil,nil
    local function b(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            on=true; si=i.Position; sp=win.Position
        end
    end
    local function e(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then on=false end
    end
    local function m(i)
        if on and si and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            local d=i.Position-si
            win.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
        end
    end
    handle.InputBegan:Connect(b); handle.InputEnded:Connect(e); UIS.InputChanged:Connect(m)
end

-- ── Root ScreenGui ───────────────────────────────────────────────────
local sg=Instance.new("ScreenGui"); sg.Name="PTFSv20"; sg.ResetOnSpawn=false
sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; sg.DisplayOrder=120; sg.Parent=PG

-- ════════════════════════════════════════════════════════════════════
-- SIDE DOCK  (always visible, draggable)
-- ════════════════════════════════════════════════════════════════════
local DOCK_W=136
local dock=fr(sg,0,0,DOCK_W,174,1,0.5,-DOCK_W-10,-87,Col.bg,0,20)
rnd(dock,10); strk(dock,Col.bdr,1); drag(dock,dock)

local dkTop=fr(dock,1,0,0,26,0,0,0,0,Col.hi,0,21); rnd(dkTop,10)
lb(dkTop,"✈  PTFS  v20",10,Col.cyn,Enum.Font.GothamBold)
drag(dkTop,dock)

-- AP status strip in dock
local dkSt=fr(dock,1,0,-8,14,0,0,4,138,Color3.fromRGB(28,8,8),0,21); rnd(dkSt,4)
local dkStL=lb(dkSt,"AP  OFF",8,Col.red,Enum.Font.GothamBold)

task.spawn(function()
    while task.wait(0.4) do pcall(function()
        dkStL.Text=AP.on and ("AP  "..AP.phase) or "AP  OFF"
        dkStL.TextColor3=AP.on and Col.grn or Col.red
        dkSt.BackgroundColor3=AP.on and Color3.fromRGB(4,26,10) or Color3.fromRGB(28,8,8)
    end) end
end)

-- Dock buttons
local menuWin, apWin, hudWin   -- forward declare

local function dockBt(y,txt,bgc,brd,fn)
    local b=bt(dock,txt,10,Col.wht,bgc,1,0,-8,30,0,0,4,y,21)
    rnd(b,6); strk(b,brd,1); b.MouseButton1Click:Connect(fn); return b
end

local MENU_W, AP_W, AP_H = 264, 284, 250

dockBt(28,"☰  MENU",    Color3.fromRGB(12,20,42),Col.bdrHi,function()
    if menuWin then menuWin.Visible=not menuWin.Visible
        if menuWin.Visible then menuWin.Position=UDim2.new(1,-DOCK_W-12-MENU_W,0.5,-260) end
    end
end)
local apDkBt=dockBt(62,"✈  AUTOPILOT",Color3.fromRGB(0,18,8),Col.grn,function()
    if apWin then apWin.Visible=not apWin.Visible
        if apWin.Visible then apWin.Position=UDim2.new(1,-DOCK_W-12-AP_W,0.5,-AP_H/2) end
    end
end); strk(apDkBt,Col.grn,1)

dockBt(96,"🖥  HUD",    Color3.fromRGB(8,12,28),Col.bdrHi,function()
    if hudWin then hudWin.Visible=not hudWin.Visible end
end)

-- ════════════════════════════════════════════════════════════════════
-- AUTOPILOT POPUP
-- ════════════════════════════════════════════════════════════════════
apWin=fr(sg,0,0,AP_W,AP_H,0.5,0.5,-AP_W/2,-AP_H/2,Col.bg,0,25)
apWin.Visible=false; rnd(apWin,12); strk(apWin,Col.bdrHi,1.5)

local apTop=fr(apWin,1,0,0,34,0,0,0,0,Col.hi,0,26); rnd(apTop,12)
lb(apTop,"  AUTOPILOT  CONTROL",12,Col.cyn,Enum.Font.GothamBold,Enum.TextXAlignment.Left,1,1,-4,0,0,0,4,0,27)
drag(apTop,apWin)

local apX=bt(apWin,"✕",11,Col.wht,Col.redD,0,0,26,24,1,0,-28,5,27); rnd(apX,5)
apX.MouseButton1Click:Connect(function() apWin.Visible=false end)

-- Status row
local apStF=fr(apWin,1,0,-12,32,0,0,6,40,Color3.fromRGB(10,28,10),0,26); rnd(apStF,7); strk(apStF,Col.grnD,1)
local apStL=lb(apStF,"●  AP  OFF",13,Col.red,Enum.Font.GothamBold)

-- Route row
local apRtF=fr(apWin,1,0,-12,22,0,0,6,76,Col.card,0,26); rnd(apRtF,5)
local apRtL=lb(apRtF,"DEP: —   ARR: —",9,Col.dim,Enum.Font.Code,Enum.TextXAlignment.Left,1,1,-8,0,0,0,5,0,27)

-- Throttle bar
local apThF=fr(apWin,1,0,-12,22,0,0,6,102,Col.card,0,26); rnd(apThF,5)
lb(apThF,"THROTTLE",8,Col.dim,Enum.Font.GothamBold,Enum.TextXAlignment.Left,0,0,70,22,0,0,4,0,27)
local apThTr=fr(apThF,1,0,-82,10,0,0.5,78,-5,Color3.fromRGB(12,22,12),0,27); rnd(apThTr,4)
local apThFl=fr(apThTr,0,1,0,0,0,0,0,0,Col.grn,0,28); rnd(apThFl,4)
local apThLb=lb(apThF,"0%",9,Col.grn,Enum.Font.Code,Enum.TextXAlignment.Right,0,0,30,22,1,0,-6,0,27)

-- Phase / WP row
local apPhF=fr(apWin,1,0,-12,20,0,0,6,128,Col.card,0,26); rnd(apPhF,5)
local apPhL=lb(apPhF,"PHASE: IDLE   WP: -/-",9,Col.amb,Enum.Font.Code,Enum.TextXAlignment.Left,1,1,-8,0,0,0,5,0,27)

-- Start / Stop buttons
local stBt=bt(apWin,"▶  START AUTOPILOT",12,Col.grn,Color3.fromRGB(0,28,12),1,0,-12,34,0,0,6,154,26)
rnd(stBt,8); strk(stBt,Col.grn,1)
stBt.MouseButton1Click:Connect(function()
    local ok,msg=startAP()
    stBt.Text=ok and ("✅  "..msg) or ("❌  "..msg)
    task.delay(3,function() stBt.Text="▶  START AUTOPILOT" end)
end)

local spBt=bt(apWin,"■  STOP",12,Col.red,Color3.fromRGB(30,8,8),1,0,-12,30,0,0,6,196,26)
rnd(spBt,8); strk(spBt,Col.red,1)
spBt.MouseButton1Click:Connect(function() stopAP("Manual") end)

-- AP popup updater
task.spawn(function()
    while task.wait(0.25) do pcall(function()
        -- Status
        apStL.Text=AP.on and ("●  AP  "..AP.phase) or "●  AP  OFF"
        apStL.TextColor3=AP.on and Col.grn or Col.red
        apStF.BackgroundColor3=AP.on and Color3.fromRGB(4,26,10) or Color3.fromRGB(28,8,8)
        -- Route
        apRtL.Text="DEP: "..(AP.dep and AP.dep.id or "—").."   ARR: "..(AP.arr and AP.arr.id or "—")
        -- Throttle bar
        local t=math.clamp(thrCurrent/100,0,1)
        apThFl.Size=UDim2.new(t,0,1,0)
        apThFl.BackgroundColor3=t>0.65 and Col.grn or (t>0.3 and Col.amb or Col.dim)
        apThLb.Text=("%.0f%%"):format(thrCurrent)
        -- Phase
        apPhL.Text=("PHASE: %s   WP: %s/%s"):format(AP.phase,tostring(wpI),tostring(#WPS))
    end) end
end)

-- ════════════════════════════════════════════════════════════════════
-- MAIN MENU
-- ════════════════════════════════════════════════════════════════════
menuWin=fr(sg,0,0,MENU_W,520,0,0.5,0,-260,Col.bg,0,30)
menuWin.Visible=false; rnd(menuWin,12); strk(menuWin,Col.bdrHi,1.5)

local mnTop=fr(menuWin,1,0,0,34,0,0,0,0,Col.hi,0,31); rnd(mnTop,12)
lb(mnTop,"  ✈  PTFS  AUTOPILOT  v20",12,Col.cyn,Enum.Font.GothamBold,Enum.TextXAlignment.Left,1,1,-4,0,0,0,4,0,32)
drag(mnTop,menuWin)

local mnX=bt(menuWin,"✕",11,Col.wht,Col.redD,0,0,26,24,1,0,-28,5,32); rnd(mnX,5)
mnX.MouseButton1Click:Connect(function() menuWin.Visible=false end)

-- Tabs
local TABS={"Takeoff","Landing","Settings","Record","Log"}
local tBtns,tPanes={},{}
local tabBar=fr(menuWin,1,0,0,30,0,0,0,36,Color3.fromRGB(8,12,20),0,31)
local tabBody=fr(menuWin,1,1,0,-70,0,0,0,68,Col.bg,0,31)
for i,nm in ipairs(TABS) do
    local tbw=MENU_W/#TABS
    local tb=bt(tabBar,nm,9,Col.dim,Color3.fromRGB(10,15,24),0,1,tbw-2,0,0,0,(i-1)*tbw+1,0,32)
    rnd(tb,4); table.insert(tBtns,tb)
    local tp=fr(tabBody,1,1,0,0,0,0,0,0,Col.bg,0,31); tp.Visible=(i==1); table.insert(tPanes,tp)
    tb.MouseButton1Click:Connect(function()
        for j,x in ipairs(tBtns) do
            x.BackgroundColor3=(j==i) and Color3.fromRGB(14,26,48) or Color3.fromRGB(10,15,24)
            x.TextColor3=(j==i) and Col.cyn or Col.dim
            tPanes[j].Visible=(j==i)
        end
    end)
end
tBtns[1].BackgroundColor3=Color3.fromRGB(14,26,48); tBtns[1].TextColor3=Col.cyn

-- Scroll helper
local function scrl(par)
    local sf=Instance.new("ScrollingFrame"); sf.Parent=par
    sf.Size=UDim2.new(1,-4,1,0); sf.Position=UDim2.new(0,2,0,0)
    sf.BackgroundTransparency=1; sf.BorderSizePixel=0
    sf.ScrollBarThickness=4; sf.ScrollBarImageColor3=Col.cynD
    sf.CanvasSize=UDim2.new(0,0,0,0); sf.AutomaticCanvasSize=Enum.AutomaticSize.Y
    local ul=Instance.new("UIListLayout"); ul.SortOrder=Enum.SortOrder.LayoutOrder
    ul.Padding=UDim.new(0,3); ul.Parent=sf; return sf
end

local function hdr(par,txt)
    local h=fr(par,1,0,0,22,0,0,0,0,Color3.fromRGB(8,16,34),0,32); rnd(h,4)
    lb(h,txt,9,Col.cyn,Enum.Font.GothamBold,Enum.TextXAlignment.Left,1,1,-8,0,0,0,4,0,33)
end

local function catCol(c)
    if c=="Intl" then return Col.cyn elseif c=="Regional" then return Col.grn
    elseif c=="Military" then return Col.amb elseif c=="STOL" then return Col.mag
    else return Col.dim end
end

-- Runway selection button
local function rwyBt(par,apName,rwy,isArr,selLbl)
    local bf=fr(par,1,0,-8,34,0,0,4,0,Color3.fromRGB(12,18,32),0,32); rnd(bf,6); strk(bf,Col.bdr,1)
    lb(bf,("RWY %s  %03d°  %dm"):format(rwy.id,rwy.hdg,rwy.len),10,Col.wht,
        Enum.Font.Code,Enum.TextXAlignment.Left,1,1,-8,0,0,0,5,0,33)
    local cb=bt(bf,"",10,Col.wht,Col.bg,1,1,0,0,0,0,0,0,34); cb.BackgroundTransparency=1
    cb.MouseButton1Click:Connect(function()
        if isArr then AP.arr=rwy else AP.dep=rwy end
        if selLbl then
            selLbl.Text=("✅  %s  RWY %s  (%03d°)"):format(apName,rwy.id,rwy.hdg)
            selLbl.TextColor3=isArr and Col.cyn or Col.grn
        end
        TS:Create(bf,TweenInfo.new(0.12),{BackgroundColor3=isArr and Col.cynD or Col.grnD}):Play()
        task.delay(0.35,function()
            TS:Create(bf,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(12,18,32)}):Play()
        end)
        if AP.gpsOn and AP.dep and AP.arr then buildTunnel() end
    end)
    return bf
end

local function buildList(sc,isArr)
    local sf=fr(sc,1,0,0,28,0,0,0,0,Color3.fromRGB(8,14,24),0,32); rnd(sf,5); strk(sf,Col.bdr,1)
    local sl=lb(sf,"Not selected",10,Col.amb,Enum.Font.Code,Enum.TextXAlignment.Left,1,1,-8,0,0,0,5,0,33)
    local order={"Intl","Regional","STOL","Military"}
    local grps={}
    for _,a in ipairs(DB) do
        if not grps[a.cat] then grps[a.cat]={} end; table.insert(grps[a.cat],a)
    end
    for _,cat in ipairs(order) do
        local lst=grps[cat]; if not lst then continue end
        local ch=fr(sc,1,0,0,16,0,0,0,0,Color3.fromRGB(6,10,22),0,32); rnd(ch,3)
        lb(ch," ── "..cat.." ──",8,catCol(cat),Enum.Font.GothamBold,Enum.TextXAlignment.Left)
        for _,ap in ipairs(lst) do
            local ah=fr(sc,1,0,0,20,0,0,0,0,Color3.fromRGB(10,20,38),0,32); rnd(ah,4)
            lb(ah,"  📍 "..ap.name..(ap.icao and "  ["..ap.icao.."]" or ""),9,Col.wht,
                Enum.Font.GothamBold,Enum.TextXAlignment.Left,1,1,-8,0,0,0,0,0,33)
            for _,rwy in ipairs(ap.rwys) do rwyBt(sc,ap.name,rwy,isArr,sl) end
        end
    end
end

-- ── TAB 1: Takeoff ──────────────────────────────────────────────────
do local sc=scrl(tPanes[1]); hdr(sc,"SELECT DEPARTURE RUNWAY"); buildList(sc,false) end

-- ── TAB 2: Landing ──────────────────────────────────────────────────
do local sc=scrl(tPanes[2]); hdr(sc,"SELECT ARRIVAL RUNWAY");   buildList(sc,true)  end

-- ── TAB 3: Settings ─────────────────────────────────────────────────
do
    local sc=scrl(tPanes[3]); hdr(sc,"SETTINGS")

    local function slider(par,lbl,mn,mx,def,suf,cb)
        local g=fr(par,1,0,0,60,0,0,0,0,Color3.fromRGB(10,16,28),0,32); rnd(g,6); strk(g,Col.bdr,1)
        lb(g,lbl,9,Col.dim,Enum.Font.GothamBold,Enum.TextXAlignment.Left,1,0,-8,15,0,0,4,4,33)
        local vl=lb(g,tostring(def)..suf,10,Col.cyn,Enum.Font.Code,Enum.TextXAlignment.Right,0,0,66,15,1,0,-70,4,33)
        local tr=fr(g,1,0,-16,7,0,0,8,39,Color3.fromRGB(18,28,48),0,33); rnd(tr,4)
        local fl=fr(tr,0,1,0,0,0,0,0,0,Col.cynD,0,34); rnd(fl,4)
        local th=fr(tr,0,0,14,14,0,0.5,-7,-7,Col.cyn,0,35); rnd(th,7)
        local function setV(v)
            v=math.clamp(math.floor(v),mn,mx)
            local p=(v-mn)/(mx-mn); fl.Size=UDim2.new(p,0,1,0)
            th.Position=UDim2.new(p,-7,0.5,-7); vl.Text=tostring(v)..suf; if cb then cb(v) end
        end
        setV(def)
        local drag2=false
        local function applyX(ix)
            local rx=tr.AbsolutePosition.X; local rw=tr.AbsoluteSize.X
            setV(mn+math.clamp((ix-rx)/rw,0,1)*(mx-mn))
        end
        th.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag2=true end
        end)
        UIS.InputEnded:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag2=false end
        end)
        UIS.InputChanged:Connect(function(i)
            if drag2 and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then applyX(i.Position.X) end
        end)
        tr.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then applyX(i.Position.X) end
        end)
    end

    slider(sc,"Cruise Altitude (st)",  500, 8000, 2500, " st",  function(v) AP.cruiseAlt=v end)
    slider(sc,"Cruise Speed (kts)",     80,  500,  280, " kts", function(v) AP.cruiseSpd=v end)
    slider(sc,"Landing Speed (kts)",    60,  200,  110, " kts", function(v) AP.landSpd=v end)
    slider(sc,"Climb Pitch (°)",         5,   25,   12, "°",    function(v) AP.climbPitch=v end)

    -- GPS toggle
    local tg=fr(sc,1,0,0,38,0,0,0,0,Color3.fromRGB(10,16,28),0,32); rnd(tg,6); strk(tg,Col.bdr,1)
    lb(tg,"GPS Tunnel Boxes",10,Col.wht,Enum.Font.GothamBold,Enum.TextXAlignment.Left,0.62,1,0,0,0,0,6,0,33)
    local gBtn=bt(tg,"OFF",10,Col.red,Color3.fromRGB(28,8,8),0,1,-8,-8,1,0,-80,4,33); rnd(gBtn,6); strk(gBtn,Col.red,1)
    gBtn.MouseButton1Click:Connect(function()
        AP.gpsOn=not AP.gpsOn
        if AP.gpsOn then
            gBtn.Text="ON"; gBtn.TextColor3=Col.grn; gBtn.BackgroundColor3=Col.grnD; strk(gBtn,Col.grn,1)
            if AP.dep and AP.arr then buildTunnel() end
        else
            gBtn.Text="OFF"; gBtn.TextColor3=Col.red; gBtn.BackgroundColor3=Color3.fromRGB(28,8,8); strk(gBtn,Col.red,1)
            clearTunnel()
        end
    end)
end

-- ── TAB 4: Record custom runway ──────────────────────────────────────
do
    local sc=scrl(tPanes[4]); hdr(sc,"RECORD CUSTOM RUNWAY")
    local recAp,recRwy="My Airport","09"
    local function inp(par,ph,cb)
        local b=Instance.new("TextBox"); b.Parent=par; b.BorderSizePixel=0
        b.Size=UDim2.new(1,-8,0,28); b.Position=UDim2.new(0,4,0,0)
        b.PlaceholderText=ph; b.Text=""; b.TextSize=10; b.Font=Enum.Font.Code
        b.TextColor3=Col.wht; b.PlaceholderColor3=Col.dim
        b.BackgroundColor3=Color3.fromRGB(10,16,28); b.ClearTextOnFocus=false; b.ZIndex=33
        rnd(b,5); strk(b,Col.bdr,1); b.FocusLost:Connect(function() if cb then cb(b.Text) end end); return b
    end
    inp(sc,"Airport name (e.g. My Base)",function(t) if t~="" then recAp=t end end)
    inp(sc,"Runway ID (e.g. 09)",function(t) if t~="" then recRwy=t end end)

    local posF=fr(sc,1,0,0,26,0,0,0,0,Color3.fromRGB(8,12,20),0,32); rnd(posF,4)
    local posL=lb(posF," Pos: ---",9,Col.dim,Enum.Font.Code,Enum.TextXAlignment.Left,1,1,-4,0,0,0,0,0,33)

    local svBt=bt(sc,"💾  SAVE (saves both directions)",10,Col.grn,Col.grnD,1,0,-8,30,0,0,4,0,33)
    rnd(svBt,6); strk(svBt,Col.grn,1)
    local svL=fr(sc,1,0,0,32,0,0,0,0,Color3.fromRGB(8,12,20),0,32); rnd(svL,4)
    local svLb=lb(svL,"—",9,Col.dim,Enum.Font.Code,Enum.TextXAlignment.Left,1,1,-4,0,0,0,4,0,33)

    svBt.MouseButton1Click:Connect(function()
        pcall(function()
            local char=P.Character; if not char then return end
            local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
            local cam=WS.CurrentCamera
            local fwd=Vector3.new(cam.CFrame.LookVector.X,0,cam.CFrame.LookVector.Z).Unit
            local hdg=math.deg(math.atan2(fwd.X,fwd.Z)); if hdg<0 then hdg=hdg+360 end
            local p=hrp.Position
            local thr=Vector3.new(math.floor(p.X*10)/10,math.floor(p.Y*10)/10,math.floor(p.Z*10)/10)
            local rn=tonumber(recRwy:match("%d+"))
            local oppH=(hdg+180)%360
            local oppId=rn and string.format("%02d",(rn+17)%36+1) or recRwy.."_R"
            local r1={id=recRwy,thr=thr,hdg=math.floor(hdg*10)/10,len=1000}
            local r2={id=oppId, thr=thr,hdg=math.floor(oppH*10)/10,len=1000}
            local found; for _,a in ipairs(DB) do if a.name==recAp then found=a; break end end
            if not found then found={name=recAp,icao="CUST",cat="Regional",rwys={}}; table.insert(DB,found) end
            table.insert(found.rwys,r1); table.insert(found.rwys,r2)
            svLb.Text="✅  "..recAp.."  "..recRwy.." + "..oppId; svLb.TextColor3=Col.grn
        end)
    end)

    task.spawn(function()
        while task.wait(0.3) do pcall(function()
            local char=P.Character; if not char then return end
            local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
            local cam=WS.CurrentCamera
            local fwd=Vector3.new(cam.CFrame.LookVector.X,0,cam.CFrame.LookVector.Z).Unit
            local hdg=math.deg(math.atan2(fwd.X,fwd.Z)); if hdg<0 then hdg=hdg+360 end
            local p=hrp.Position
            posL.Text=(" X:%.0f  Y:%.0f  Z:%.0f  Hdg:%03.0f°"):format(p.X,p.Y,p.Z,hdg)
        end) end
    end)
end

-- ── TAB 5: Log ──────────────────────────────────────────────────────
do
    local sc=scrl(tPanes[5]); hdr(sc,"FLIGHT LOG")
    local entries={}
    for i=1,20 do
        local ef=fr(sc,1,0,0,18,0,0,0,0,Color3.fromRGB(8,12,22),0,32); rnd(ef,3)
        table.insert(entries,lb(ef,"",8,Col.dim,Enum.Font.Code,Enum.TextXAlignment.Left,1,1,-6,0,0,0,3,0,33))
    end
    task.spawn(function()
        while task.wait(0.45) do pcall(function()
            for i,l in ipairs(entries) do
                local e=LOG[i]; l.Text=e or ""; l.TextColor3=e and Col.wht or Col.dim
            end
        end) end
    end)
end

-- ════════════════════════════════════════════════════════════════════
-- COCKPIT HUD
-- ════════════════════════════════════════════════════════════════════
local HW,HH=680,250; local TH=28
local SPW=66; local ALW=74; local PFDW=HW-SPW-ALW-4; local NDW=142

hudWin=fr(sg,0,0,HW,HH,0.5,1,-HW/2,-HH-10,Col.bg,0,10)
rnd(hudWin,10); strk(hudWin,Col.bdrHi,1.5)

local hdTop=fr(hudWin,1,0,0,TH,0,0,0,0,Col.hi,0,11); rnd(hdTop,10)
lb(hdTop,"✈  PTFS  FLIGHT  DECK  v20",11,Col.cyn,Enum.Font.GothamBold)
drag(hdTop,hudWin)

local hdX=bt(hudWin,"✕",11,Col.wht,Col.redD,0,0,24,22,1,0,-28,3,14); rnd(hdX,5); strk(hdX,Col.red,1)
hdX.MouseButton1Click:Connect(function() hudWin.Visible=not hudWin.Visible end)

local hudC=fr(hudWin,1,1,-2,-(TH+2),0,0,1,TH+1,Col.bg,1,10)

-- Speed tape
local spP=fr(hudC,0,1,SPW,0,0,0,0,0,Color3.fromRGB(8,14,12),0,11); rnd(spP,6); strk(spP,Col.grnD,1)
lb(spP,"SPD",7,Col.grnD,Enum.Font.GothamBold,nil,1,0,0,13,0,0,0,0,12)
lb(spP,"KTS",7,Col.grnD,Enum.Font.GothamBold,nil,1,0,0,13,1,0,0,-13,12)
local spBox=fr(spP,1,0,-6,30,0,0,3,0,Color3.fromRGB(0,18,10),0,12)
spBox.Position=UDim2.new(0,3,0.5,-15); rnd(spBox,4); strk(spBox,Col.grn,1)
local spVal=lb(spBox,"0",17,Col.grn,Enum.Font.Code,nil,1,1,0,0,0,0,0,0,13)

-- Alt tape
local alP=fr(hudC,0,1,ALW,0,1,0,-ALW,0,Color3.fromRGB(8,11,20),0,11); rnd(alP,6); strk(alP,Col.cynD,1)
lb(alP,"ALT",7,Col.cynD,Enum.Font.GothamBold,nil,1,0,0,13,0,0,0,0,12)
lb(alP,"STD",7,Col.cynD,Enum.Font.GothamBold,nil,1,0,0,13,1,0,0,-13,12)
local alBox=fr(alP,1,0,-6,30,0,0,3,0,Color3.fromRGB(4,7,24),0,12)
alBox.Position=UDim2.new(0,3,0.5,-15); rnd(alBox,4); strk(alBox,Col.cyn,1)
local alVal=lb(alBox,"0",14,Col.cyn,Enum.Font.Code,nil,1,1,0,0,0,0,0,0,13)

-- PFD area
local pfdA=fr(hudC,0,1,PFDW,0,0,0,SPW+2,0,Col.bg,1,10)
local aiW=PFDW-NDW-2
local ai=fr(pfdA,0,1,aiW,0,0,0,0,0,Col.sky,0,11); rnd(ai,6); ai.ClipsDescendants=true

local skyT=fr(ai,1,0.6,0,0,0,0,0,0,Color3.fromRGB(18,65,155),0,11)
local skyB=fr(ai,1,0.5,0,0,0,0.5,0,0,Color3.fromRGB(45,115,210),0,11)
local gndT=fr(ai,1,0.5,0,0,0,0.5,0,0,Color3.fromRGB(120,80,30),0,11)
local gndB=fr(ai,1,0.5,0,0,0,1,0,0,Color3.fromRGB(85,52,18),0,11); gndB.AnchorPoint=Vector2.new(0,1)
local hLine=fr(ai,1,0,0,2,0,0.5,0,-1,Col.amb,0,14)

for _,d in ipairs({-15,-10,-5,5,10,15}) do
    local y=0.5-(d*0.018); local w=math.abs(d)>=10 and 0.42 or 0.28
    fr(ai,w,0,0,1,(1-w)/2,y,0,0,Color3.fromRGB(215,215,195),0.35,13)
    lb(ai,("%+d"):format(d),8,Color3.fromRGB(215,215,180),Enum.Font.Code,
        Enum.TextXAlignment.Right,0,0,(1-w)/2*aiW-4,12,0,y,0,-6,13)
end
fr(ai,0,0,40,3,0.5,0.5,-50,-1,Color3.fromRGB(255,205,0),0,15)
fr(ai,0,0,40,3,0.5,0.5, 10,-1,Color3.fromRGB(255,205,0),0,15)
local wDot=fr(ai,0,0,8,8,0.5,0.5,-4,-4,Color3.fromRGB(255,205,0),0,15); rnd(wDot,4)
fr(ai,0,0,3,12,0.5,0.5,-1,-12,Color3.fromRGB(255,205,0),0,15)

-- FPV
local fpvF=fr(ai,0,0,18,18,0.5,0.5,-9,-9,Col.bg,1,16)
local fpvC=fr(fpvF,1,1,0,0,0,0,0,0,Col.bg,1,16); strk(fpvC,Col.grn,1.5); rnd(fpvC,9)
fr(fpvF,0,0,7,1,1,0.5, 1,0,Color3.fromRGB(0,225,115),0,17)
fr(fpvF,0,0,7,1,0,0.5,-8,0,Color3.fromRGB(0,225,115),0,17)
fr(fpvF,0,0,1,7,0.5,0,-1,-8,Color3.fromRGB(0,225,115),0,17)

-- Heading strip
local hdgH=26
local hdgS=fr(pfdA,0,0,aiW,hdgH,0,1,0,-hdgH,Color3.fromRGB(8,12,22),0,12); rnd(hdgS,4); strk(hdgS,Col.bdr,1)
for i=0,35 do
    local deg=i*10; local x=deg/360; local maj=deg%30==0
    fr(hdgS,0,0,1,maj and 9 or 5,x,0,0,0,maj and Color3.fromRGB(55,105,175) or Color3.fromRGB(28,52,88),0,13)
    if maj then
        local dirs={[0]="N",[90]="E",[180]="S",[270]="W"}
        lb(hdgS,dirs[deg] or tostring(deg),8,Color3.fromRGB(55,115,190),Enum.Font.Code,nil,0,0,22,12,x,0,-11,9,13)
    end
end
local hdgPtr=fr(hdgS,0,0,2,hdgH,0,0,-1,0,Color3.fromRGB(255,195,0),0,15)
local hdgRd=lb(hdgS,"000°",9,Col.amb,Enum.Font.Code,nil,0,0,40,16,0.5,1,-20,-18,14)

-- Top strip
local topH=20
local topS=fr(pfdA,0,0,aiW,topH,0,0,0,0,Color3.fromRGB(5,9,18),0,12); rnd(topS,4)
local pitchL=lb(topS,"PTH +0.0°",8,Col.amb,Enum.Font.Code,Enum.TextXAlignment.Left,0.5,1,0,0,0,0,3,0,13)
local vsL=lb(topS,"V/S +0",8,Col.cyn,Enum.Font.Code,Enum.TextXAlignment.Right,0.5,1,0,0,0.5,0,-3,0,13)

-- ND compass
local nd=fr(pfdA,0,1,NDW,-(hdgH+topH+2),0,0,aiW+2,topH+1,Color3.fromRGB(7,13,24),0,11); rnd(nd,6); strk(nd,Col.bdr,1)
lb(nd,"NAV",8,Col.cyn,Enum.Font.GothamBold)
local cR=48
local cBG=fr(nd,0,0,cR*2,cR*2,0.5,0,-cR,22,Color3.fromRGB(8,16,32),0,12); rnd(cBG,cR); strk(cBG,Col.bdr,1)
for _,cd in ipairs({{t="N",a=0,c=Col.cyn},{t="E",a=90,c=Col.wht},{t="S",a=180,c=Col.wht},{t="W",a=270,c=Col.wht}}) do
    local r=math.rad(cd.a)
    lb(cBG,cd.t,8,cd.c,Enum.Font.GothamBold,nil,0,0,14,12,0.5,0.5,math.sin(r)*(cR-10)-7,-math.cos(r)*(cR-10)-6,13)
end
fr(cBG,0,0,2,cR-8,0.5,0.5,-1,-(cR-8),Col.cyn,0,14)
lb(cBG,"✈",14,Col.wht,Enum.Font.GothamBold,nil,0,0,20,20,0.5,0.5,-10,-11,15)
local ndHdg=lb(nd,"000°",13,Col.cyn,Enum.Font.Code,nil,1,0,0,18,0,0,0,cR*2+24,12)
local ndDst=lb(nd,"DEST: ---",8,Col.grn,Enum.Font.Code,nil,1,0,0,14,0,0,0,cR*2+44,12)
local ndWP=lb(nd,"WP: -/-",8,Col.amb,Enum.Font.Code,nil,1,0,0,14,0,0,0,cR*2+60,12)
local ndPh=lb(nd,"IDLE",9,Col.red,Enum.Font.GothamBold,nil,1,0,0,16,0,0,0,cR*2+76,12)

-- Bottom bar
local barH=32
local bar=fr(hudWin,1,0,0,barH,0,1,0,-barH-1,Color3.fromRGB(7,10,18),0,12); rnd(bar,6); strk(bar,Col.bdr,1)
local cells={
    {k="gs",l="G/S",c=Col.grn},{k="vs",l="V/S",c=Col.cyn},
    {k="thr",l="THR",c=Col.amb},{k="dist",l="DIST",c=Col.pur},
    {k="phase",l="PHASE",c=Col.mag},{k="dep",l="DEP",c=Col.dim},{k="arr",l="ARR",c=Col.dim},
}
local bv2={}
for i,cell in ipairs(cells) do
    local cx=(i-1)*(HW/#cells)
    local bg2=fr(bar,0,1,HW/#cells-2,-4,0,0,cx+1,2,Color3.fromRGB(10,14,26),0,12); rnd(bg2,3)
    lb(bg2,cell.l,6,Col.dim,Enum.Font.GothamBold,nil,1,0,0,11,0,0,0,2,13)
    bv2[cell.k]=lb(bg2,"—",11,cell.c,Enum.Font.Code,nil,1,0,0,15,0,0,0,11,13)
    if i<#cells then fr(bar,0,1,1,-6,0,0,cx+HW/#cells,3,Col.bdr,0,13) end
end

-- HUD live update
RS.Heartbeat:Connect(function()
    if not hudWin or not hudWin.Visible then return end
    pcall(function()
        local char=P.Character; if not char then return end
        local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        local vel=hrp.AssemblyLinearVelocity
        local gs=math.floor(vel.Magnitude)
        local alt=math.floor(hrp.Position.Y)
        local lv=hrp.CFrame.LookVector
        local hdg=math.deg(math.atan2(lv.X,lv.Z)); if hdg<0 then hdg=hdg+360 end
        local pitch=vel.Magnitude>0.5 and math.deg(math.asin(math.clamp(vel.Y/vel.Magnitude,-1,1))) or 0
        local vs=math.floor(vel.Y*60)

        -- Speed colour
        spVal.Text=tostring(gs)
        spVal.TextColor3=gs<70 and Col.red or (gs<180 and Col.amb or Col.grn)

        -- Alt colour
        alVal.Text=tostring(alt)
        alVal.TextColor3=alt<60 and Col.amb or (alt<300 and Col.wht or Col.cyn)

        -- Attitude
        local aH=ai.AbsoluteSize.Y
        local pxP=math.clamp(pitch*(aH*0.018),-(aH*0.45),aH*0.45)
        local sR=math.clamp(0.5+pxP/aH,0.05,0.95)
        skyT.Size=UDim2.new(1,0,sR,0); skyB.Size=UDim2.new(1,0,sR,0)
        gndT.Position=UDim2.new(0,0,sR,0); gndT.Size=UDim2.new(1,0,1-sR,0)
        gndB.Size=UDim2.new(1,0,1-sR,0); hLine.Position=UDim2.new(0,0,sR,-1)

        -- FPV
        if vel.Magnitude>2 then
            local fp=math.deg(math.asin(math.clamp(vel.Y/vel.Magnitude,-1,1)))
            fpvF.Position=UDim2.new(0.5,-9,0.5,(-fp*(aH*0.018))-9); fpvF.Visible=true
        else fpvF.Visible=false end

        -- Heading
        hdgPtr.Position=UDim2.new(hdg/360,-1,0,0)
        hdgRd.Text=("%03.0f°"):format(hdg)
        ndHdg.Text=("%03.0f°"):format(hdg)
        pitchL.Text=("PTH %+.1f°"):format(pitch)
        vsL.Text=("V/S %+d"):format(vs)

        -- Bottom bar
        bv2.gs.Text=tostring(gs).." kts"
        bv2.vs.Text=(vs>=0 and "+" or "")..tostring(vs)
        bv2.thr.Text=("%.0f%%"):format(thrCurrent)
        bv2.dist.Text=AP.arr and (tostring(math.floor(dist(hrp.Position,AP.arr.thr))).." st") or "—"
        bv2.phase.Text=AP.phase
        bv2.dep.Text=AP.dep and AP.dep.id or "—"
        bv2.arr.Text=AP.arr and AP.arr.id or "—"

        ndDst.Text="DEST: "..(AP.arr and tostring(math.floor(dist(hrp.Position,AP.arr.thr))).." st" or "—")
        ndWP.Text="WP: "..(AP.on and (tostring(wpI).."/"..tostring(#WPS)) or "-/-")
        ndPh.Text=AP.phase; ndPh.TextColor3=AP.on and Col.grn or Col.red
    end)
end)

-- ════════════════════════════════════════════════════════════════════
print("✅ PTFS Autopilot v20 loaded")
print("   "..#DB.." airports | "..(function() local n=0; for _,a in ipairs(DB) do n=n+#a.rwys end; return n end)().." runways")
print("   BodyVelocity flight | W/S throttle sync | 3° ILS glideslope | GPS tunnel")
