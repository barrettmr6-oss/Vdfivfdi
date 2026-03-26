-- ╔══════════════════════════════════════════════════════════════════════╗
-- ║       PTFS AUTOPILOT v18 — SMOOTH FLIGHT + PREMIUM UI              ║
-- ║  ILS Glideslope • Anti-Stall • Draggable UI • Toast Alerts        ║
-- ║  Phase Progress • Hover FX • Animated LED • Flare Landing         ║
-- ║  All Official PTFS Airports with correct ICAO codes               ║
-- ╚══════════════════════════════════════════════════════════════════════╝

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local TweenS     = game:GetService("TweenService")
local Player     = Players.LocalPlayer
local PlayerGui  = Player:WaitForChild("PlayerGui")

-- Clean up old GUIs
for _, name in ipairs({"PTFSMain","PTFSCockpit","PTFSTunnel","PTFSv18"}) do
    if PlayerGui:FindFirstChild(name) then PlayerGui[name]:Destroy() end
end
local wsFolder = workspace:FindFirstChild("PTFS_Tunnel")
if wsFolder then wsFolder:Destroy() end

-- ════════════════════════════════════════════════════════════════════
-- AIRPORT & RUNWAY DATABASE
-- ════════════════════════════════════════════════════════════════════
local Airports = {
    -- INTERNATIONAL
    {
        name="Greater Rockford", icao="IRFD", island="Rockford", type="International",
        runways={
            {name="07L",threshold=Vector3.new(-3500,3.3,20750),heading=067.0,length=3200},
            {name="25R",threshold=Vector3.new(-2720,3.3,20400),heading=247.0,length=3200},
            {name="07C",threshold=Vector3.new(-3490,3.3,20700),heading=067.0,length=3100},
            {name="25C",threshold=Vector3.new(-2730,3.3,20370),heading=247.0,length=3100},
            {name="07R",threshold=Vector3.new(-3481,3.3,20650),heading=067.0,length=3000},
            {name="25L",threshold=Vector3.new(-2727,3.3,20380),heading=247.0,length=3000},
        }
    },
    {
        name="Tokyo International", icao="ITKO", island="Orenji", type="International",
        runways={
            {name="02",threshold=Vector3.new(-6399,21.5,-32327),heading=020.2,length=4850},
            {name="20",threshold=Vector3.new(-6922,21.5,-30891),heading=200.2,length=4850},
            {name="13",threshold=Vector3.new(-5800,21.5,-31200),heading=131.0,length=3600},
            {name="31",threshold=Vector3.new(-6600,21.5,-30500),heading=311.0,length=3600},
        }
    },
    {
        name="Perth International", icao="IPPH", island="Perth", type="International",
        runways={
            {name="11",threshold=Vector3.new(6200,25,4800),heading=111.0,length=3200},
            {name="29",threshold=Vector3.new(7600,25,5400),heading=291.0,length=3200},
            {name="15",threshold=Vector3.new(6700,25,4300),heading=151.0,length=2500},
            {name="33",threshold=Vector3.new(6900,25,5700),heading=331.0,length=2500},
        }
    },
    {
        name="Izolirani International", icao="IZOL", island="Izolirani", type="International",
        runways={
            {name="10",threshold=Vector3.new(-9200,9,15800),heading=106.0,length=3200},
            {name="28",threshold=Vector3.new(-7800,9,16200),heading=286.0,length=3200},
        }
    },
    -- REGIONAL
    {
        name="Saint Barthélemy", icao="IBTH", island="Saint Barthelemy", type="Regional",
        runways={
            {name="09",threshold=Vector3.new(5470,11.5,-4486),heading=091.5,length=600},
            {name="27",threshold=Vector3.new(5951,3.1,-4486),heading=271.5,length=600},
        }
    },
    {
        name="Larnaca International", icao="ILAR", island="Cyprus", type="Regional",
        runways={
            {name="04",threshold=Vector3.new(11200,18,-8200),heading=040.0,length=2800},
            {name="22",threshold=Vector3.new(11900,18,-7300),heading=220.0,length=2800},
        }
    },
    {
        name="Paphos International", icao="IPAP", island="Cyprus", type="Regional",
        runways={
            {name="11",threshold=Vector3.new(10100,28,-10600),heading=110.0,length=2200},
            {name="29",threshold=Vector3.new(10900,28,-10200),heading=290.0,length=2200},
        }
    },
    {
        name="Sauthamptona Airport", icao="ISAU", island="Sauthamptona", type="Regional",
        runways={
            {name="02",threshold=Vector3.new(-1200,8,-2800),heading=020.0,length=1800},
            {name="20",threshold=Vector3.new(-1100,8,-2200),heading=200.0,length=1800},
        }
    },
    {
        name="Saba Airport", icao="IDCS", island="Orenji", type="Regional",
        runways={
            {name="12",threshold=Vector3.new(-8200,148,-24600),heading=120.0,length=400},
            {name="30",threshold=Vector3.new(-8100,148,-24400),heading=300.0,length=400},
        }
    },
    {
        name="Skopelos Airfield", icao="ISKP", island="Skopelos", type="Regional",
        runways={
            {name="09",threshold=Vector3.new(14200,12,-3200),heading=090.0,length=900},
            {name="27",threshold=Vector3.new(14600,12,-3200),heading=270.0,length=900},
        }
    },
    {
        name="Grindavik Airport", icao="IGRV", island="Grindavik", type="Regional",
        runways={
            {name="08",threshold=Vector3.new(18200,6,-6800),heading=080.0,length=1400},
            {name="26",threshold=Vector3.new(18900,6,-6700),heading=260.0,length=1400},
        }
    },
    -- STOL
    {
        name="Lukla Airport", icao="ILKL", island="Perth", type="STOL",
        runways={
            {name="06",threshold=Vector3.new(7100,950,4200),heading=062.0,length=400},
            {name="24",threshold=Vector3.new(7300,960,4350),heading=242.0,length=400},
        }
    },
    {
        name="Barra Airport", icao="IBAR", island="Cyprus", type="STOL",
        runways={
            {name="12",threshold=Vector3.new(3100,4,-6200),heading=120.0,length=700},
            {name="30",threshold=Vector3.new(3350,4,-6000),heading=300.0,length=700},
            {name="07",threshold=Vector3.new(3000,4,-6000),heading=070.0,length=600},
            {name="25",threshold=Vector3.new(3300,4,-5900),heading=250.0,length=600},
        }
    },
    {
        name="Henstridge Airfield", icao="IHEN", island="Cyprus", type="STOL",
        runways={
            {name="08",threshold=Vector3.new(9800,18,-9200),heading=080.0,length=600},
            {name="26",threshold=Vector3.new(10100,18,-9150),heading=260.0,length=600},
        }
    },
    {
        name="Mellor International", icao="IMLR", island="Rockford", type="STOL",
        runways={
            {name="08",threshold=Vector3.new(-2800,420,17800),heading=080.0,length=500},
            {name="26",threshold=Vector3.new(-2600,420,17900),heading=260.0,length=500},
        }
    },
    {
        name="Boltic Airfield", icao="IBLT", island="Rockford", type="STOL",
        runways={
            {name="14",threshold=Vector3.new(-6600,12,-19200),heading=140.0,length=600},
            {name="32",threshold=Vector3.new(-6500,12,-18900),heading=320.0,length=600},
        }
    },
    {
        name="Bird Island Airfield", icao="IBRD", island="Orenji", type="STOL",
        runways={
            {name="09",threshold=Vector3.new(-10200,6,-27400),heading=090.0,length=350},
            {name="27",threshold=Vector3.new(-10000,6,-27400),heading=270.0,length=350},
        }
    },
    -- MILITARY
    {
        name="McConnell AFB", icao="IIAB", island="Cyprus", type="Military",
        runways={
            {name="01L",threshold=Vector3.new(-3200,8,15200),heading=010.0,length=2800},
            {name="19R",threshold=Vector3.new(-3100,8,16400),heading=190.0,length=2800},
            {name="01R",threshold=Vector3.new(-3100,8,15200),heading=010.0,length=2800},
            {name="19L",threshold=Vector3.new(-3000,8,16400),heading=190.0,length=2800},
        }
    },
    {
        name="RAF Scampton", icao="ISCM", island="Izolirani", type="Military",
        runways={
            {name="13",threshold=Vector3.new(-8800,9,17800),heading=130.0,length=2400},
            {name="31",threshold=Vector3.new(-8200,9,18600),heading=310.0,length=2400},
        }
    },
    {
        name="Al Najaf Airfield", icao="IJAF", island="Izolirani", type="Military",
        runways={
            {name="07",threshold=Vector3.new(-9800,9,16800),heading=070.0,length=900},
            {name="25",threshold=Vector3.new(-9500,9,16900),heading=250.0,length=900},
        }
    },
    {
        name="Air Base Garry", icao="IGAR", island="Rockford", type="Military",
        runways={
            {name="09",threshold=Vector3.new(-1800,4,19600),heading=090.0,length=1000},
            {name="27",threshold=Vector3.new(-1200,4,19600),heading=270.0,length=1000},
        }
    },
    {
        name="Training Centre", icao="ITRC", island="Rockford", type="Military",
        runways={
            {name="09",threshold=Vector3.new(-200,4,200),heading=090.0,length=800},
            {name="27",threshold=Vector3.new(200,4,200),heading=270.0,length=800},
        }
    },
}

-- ════════════════════════════════════════════════════════════════════
-- FLIGHT PHYSICS CONSTANTS
-- ════════════════════════════════════════════════════════════════════
local GLIDE_DEG    = 3.0
local GLIDE_TAN    = math.tan(math.rad(GLIDE_DEG))  -- ~0.0524 (3° slope)
local STALL_FACTOR = 0.88   -- min speed = 88% of LANDING_SPD
local FLARE_ALT    = 55     -- studs AGL to begin flare roundout
local BRAKE_RATE   = 55     -- rollout decel (studs/s²) — smooth stop

-- ════════════════════════════════════════════════════════════════════
-- AUTOPILOT STATE
-- ════════════════════════════════════════════════════════════════════
local AP = {
    active       = false,
    phase        = "IDLE",
    depRunway    = nil,
    arrRunway    = nil,
    aircraft     = nil,
    rootPart     = nil,
    CRUISE_ALT   = 2000,
    CRUISE_SPD   = 350,
    TAKEOFF_SPD  = 280,
    LANDING_SPD  = 110,
    CLIMB_PITCH  = 15,
    PATTERN_ALT  = 600,
    PATTERN_LEG  = 1200,
    USE_PATTERN  = false,
}
local waypoints, wpIndex = {}, 1
local bvel, bgyro = nil, nil
local spd = 0
local hbConn = nil
local flightLog = {}

-- ════════════════════════════════════════════════════════════════════
-- GPS TUNNEL SYSTEM
-- ════════════════════════════════════════════════════════════════════
local GPS = { enabled=false, tunnelFolder=nil, parts={} }
local TUNNEL_SPACING = 600
local TUNNEL_W       = 280
local TUNNEL_H       = 200
local TUNNEL_THICK   = 4
local TUNNEL_TRANSP  = 0.72
local GATE_COLORS = {
    TAKEOFF  = Color3.fromRGB(0,230,120),
    CLIMB    = Color3.fromRGB(0,200,255),
    CRUISE   = Color3.fromRGB(60,140,255),
    DESCENT  = Color3.fromRGB(255,190,0),
    APPROACH = Color3.fromRGB(255,100,40),
    LANDING  = Color3.fromRGB(255,50,50),
}

local function makeGatePart(size, cframe, color)
    local p = Instance.new("Part")
    p.Size=size; p.CFrame=cframe; p.Anchored=true; p.CanCollide=false
    p.Material=Enum.Material.Neon; p.Color=color
    p.Transparency=TUNNEL_TRANSP; p.CastShadow=false
    p.Parent=GPS.tunnelFolder
    table.insert(GPS.parts, p)
    return p
end

local function buildGate(cf, color)
    local right=cf.RightVector; local up=cf.UpVector; local pos=cf.Position
    local hw=TUNNEL_W/2; local hh=TUNNEL_H/2; local th=TUNNEL_THICK
    makeGatePart(Vector3.new(TUNNEL_W,th,th),CFrame.new(pos+up*hh),color)
    makeGatePart(Vector3.new(TUNNEL_W,th,th),CFrame.new(pos-up*hh),color)
    makeGatePart(Vector3.new(th,TUNNEL_H,th),CFrame.new(pos-right*hw),color)
    makeGatePart(Vector3.new(th,TUNNEL_H,th),CFrame.new(pos+right*hw),color)
    local dot=makeGatePart(Vector3.new(th*2,th*2,th*2),CFrame.new(pos),color)
    dot.Transparency=TUNNEL_TRANSP-0.15
end

local function spawnGatesAlongSegment(startPos, endPos, startAlt, endAlt, color)
    local delta=endPos-startPos; local dist=delta.Magnitude
    if dist < 1 then return end
    local steps=math.max(1,math.floor(dist/TUNNEL_SPACING))
    for i=0,steps do
        local t=i/steps
        local p=startPos:Lerp(endPos,t)
        local alt=startAlt+(endAlt-startAlt)*t
        p=Vector3.new(p.X,alt,p.Z)
        local fwd=endPos-startPos
        fwd=Vector3.new(fwd.X,(endAlt-startAlt)/(steps>0 and steps or 1),fwd.Z).Unit
        buildGate(CFrame.new(p,p+fwd),color)
    end
end

local function clearTunnel()
    if GPS.tunnelFolder and GPS.tunnelFolder.Parent then GPS.tunnelFolder:Destroy() end
    GPS.tunnelFolder=nil; GPS.parts={}
end

local function headingDir(deg)
    local r=math.rad(deg)
    return Vector3.new(math.sin(r),0,math.cos(r))
end

local function buildTunnel()
    clearTunnel()
    if not GPS.enabled then return end
    if not AP.depRunway or not AP.arrRunway then return end
    GPS.tunnelFolder=Instance.new("Folder")
    GPS.tunnelFolder.Name="PTFS_Tunnel"
    GPS.tunnelFolder.Parent=workspace
    local dep=AP.depRunway; local arr=AP.arrRunway
    local alt=AP.CRUISE_ALT
    local depDir=headingDir(dep.heading); local arrDir=headingDir(arr.heading)
    local climbOutH=dep.threshold+depDir*3000
    spawnGatesAlongSegment(dep.threshold,climbOutH,dep.threshold.Y+5,alt,GATE_COLORS.TAKEOFF)
    local midX=(dep.threshold.X+arr.threshold.X)/2
    local midZ=(dep.threshold.Z+arr.threshold.Z)/2
    local mid=Vector3.new(midX,alt,midZ)
    spawnGatesAlongSegment(climbOutH,mid,alt,alt,GATE_COLORS.CRUISE)
    -- ILS funnel: 15k studs out
    local finalFix=arr.threshold-arrDir*15000
    spawnGatesAlongSegment(mid,finalFix,alt,alt+200,GATE_COLORS.DESCENT)
    local appStartAlt=arr.threshold.Y+AP.PATTERN_ALT
    spawnGatesAlongSegment(finalFix,arr.threshold,appStartAlt,arr.threshold.Y+8,GATE_COLORS.APPROACH)
    local rolloutEnd=arr.threshold+arrDir*1500
    spawnGatesAlongSegment(arr.threshold,rolloutEnd,arr.threshold.Y+4,arr.threshold.Y+2,GATE_COLORS.LANDING)
    if AP.USE_PATTERN then
        local function perpD(d) return Vector3.new(d.Z,0,-d.X).Unit end
        local patAlt=arr.threshold.Y+AP.PATTERN_ALT
        local perpR=perpD(arrDir)
        local crosswindEnd=arr.threshold+arrDir*(arr.length or 2000)+perpR*AP.PATTERN_LEG
        local downwindEnd=arr.threshold-arrDir*800+perpR*AP.PATTERN_LEG
        local basePt=arr.threshold-arrDir*800+perpR*(AP.PATTERN_LEG*0.3)
        spawnGatesAlongSegment(crosswindEnd,downwindEnd,patAlt,patAlt,GATE_COLORS.DESCENT)
        spawnGatesAlongSegment(downwindEnd,basePt,patAlt,patAlt,GATE_COLORS.DESCENT)
        spawnGatesAlongSegment(basePt,finalFix,patAlt,appStartAlt,GATE_COLORS.APPROACH)
    end
end

-- ════════════════════════════════════════════════════════════════════
-- HELPERS
-- ════════════════════════════════════════════════════════════════════
local function dist2D(a,b)
    return Vector3.new(a.X-b.X,0,a.Z-b.Z).Magnitude
end

local function pressKey(key)
    pcall(function()
        local VIM=game:GetService("VirtualInputManager")
        VIM:SendKeyEvent(true,Enum.KeyCode[key],false,game)
        task.wait(0.1)
        VIM:SendKeyEvent(false,Enum.KeyCode[key],false,game)
    end)
end

local function fly(vel, lookDir)
    if bvel  and bvel.Parent  then bvel.Velocity=vel end
    if bgyro and bgyro.Parent then
        if lookDir and lookDir.Magnitude>0.001 then
            bgyro.CFrame=CFrame.new(Vector3.new(),lookDir.Unit)
        end
    end
end

local function getAlt()
    return AP.rootPart and AP.rootPart.Position.Y or 0
end

local function perpDir(dir)
    return Vector3.new(dir.Z,0,-dir.X).Unit
end

local function logEvent(msg)
    local t=math.floor(tick())
    table.insert(flightLog,1,string.format("[%d] %s",t,msg))
    if #flightLog>30 then table.remove(flightLog) end
end

-- ════════════════════════════════════════════════════════════════════
-- WAYPOINT BUILDER — improved approach distances
-- ════════════════════════════════════════════════════════════════════
local function buildWaypoints()
    waypoints={}; wpIndex=1
    local dep=AP.depRunway; local arr=AP.arrRunway
    local alt=AP.CRUISE_ALT
    local depDir=headingDir(dep.heading); local arrDir=headingDir(arr.heading)

    -- CLIMB
    local climbOut=dep.threshold+depDir*3000
    climbOut=Vector3.new(climbOut.X,alt,climbOut.Z)
    table.insert(waypoints,{
        pos=climbOut, label="CLIMB",
        onArrive=function() spd=AP.CRUISE_SPD; logEvent("Cruise speed set") end
    })

    -- CRUISE MID
    local midX=(dep.threshold.X+arr.threshold.X)/2
    local midZ=(dep.threshold.Z+arr.threshold.Z)/2
    table.insert(waypoints,{
        pos=Vector3.new(midX,alt,midZ), label="CRUISE",
        onArrive=function() end
    })

    if AP.USE_PATTERN then
        local patAlt=arr.threshold.Y+AP.PATTERN_ALT
        local perpR=perpDir(arrDir)
        local crosswindEnd=arr.threshold+arrDir*(arr.length or 2000)+perpR*AP.PATTERN_LEG
        crosswindEnd=Vector3.new(crosswindEnd.X,patAlt,crosswindEnd.Z)
        local downwindEnd=arr.threshold-arrDir*800+perpR*AP.PATTERN_LEG
        downwindEnd=Vector3.new(downwindEnd.X,patAlt,downwindEnd.Z)
        local basePt=arr.threshold-arrDir*800+perpR*(AP.PATTERN_LEG*0.3)
        basePt=Vector3.new(basePt.X,patAlt,basePt.Z)
        local finalFix=arr.threshold-arrDir*5000
        finalFix=Vector3.new(finalFix.X,patAlt,finalFix.Z)
        table.insert(waypoints,{pos=crosswindEnd,label="CROSSWIND",onArrive=function()
            spd=AP.LANDING_SPD*1.3; logEvent("Crosswind leg")
        end})
        table.insert(waypoints,{pos=downwindEnd,label="DOWNWIND",onArrive=function()
            spd=AP.LANDING_SPD*1.2; logEvent("Downwind – flaps")
            task.spawn(function() pressKey("F") end)
        end})
        table.insert(waypoints,{pos=basePt,label="BASE",onArrive=function()
            spd=AP.LANDING_SPD*1.1; logEvent("Base – gear down")
            task.spawn(function() pressKey("G") end)
        end})
        table.insert(waypoints,{pos=finalFix,label="FINAL",onArrive=function()
            AP.phase="APPROACH"; spd=AP.LANDING_SPD; logEvent("Final approach")
        end})
    else
        -- IMPROVED: start approach much further out for smooth ILS capture
        local airportDist = dist2D(dep.threshold, arr.threshold)
        local maxFinalLeg = math.min(airportDist * 0.38, 22000)
        local maxDescentStart = math.min(airportDist * 0.28, 15000)

        local finalLegPos = arr.threshold - arrDir * maxFinalLeg
        finalLegPos = Vector3.new(finalLegPos.X, alt, finalLegPos.Z)
        local descentStartPos = arr.threshold - arrDir * maxDescentStart
        descentStartPos = Vector3.new(descentStartPos.X, alt, descentStartPos.Z)

        table.insert(waypoints,{
            pos=finalLegPos, label="FINAL FIX",
            onArrive=function()
                spd=AP.LANDING_SPD*1.3
                task.spawn(function() pressKey("F") end)
                logEvent("Final fix – flaps")
            end
        })
        table.insert(waypoints,{
            pos=descentStartPos, label="DESCENT",
            onArrive=function()
                AP.phase="APPROACH"; spd=AP.LANDING_SPD*1.15
                task.spawn(function() task.wait(0.3); pressKey("G") end)
                logEvent("Descent – gear down")
            end
        })
    end
end

-- ════════════════════════════════════════════════════════════════════
-- STOP AP
-- ════════════════════════════════════════════════════════════════════
local function stopAP(reason)
    AP.active=false; AP.phase="IDLE"
    if hbConn then hbConn:Disconnect(); hbConn=nil end
    if bvel  and bvel.Parent  then bvel:Destroy();  bvel=nil  end
    if bgyro and bgyro.Parent then bgyro:Destroy(); bgyro=nil end
    logEvent("AP STOP: "..(reason or "Manual"))
    print("⏹️ AP: "..(reason or "Manual"))
end

-- ════════════════════════════════════════════════════════════════════
-- MAIN FLIGHT LOOP — complete physics rewrite
-- ════════════════════════════════════════════════════════════════════
local function startLoop()
    spd=0; wpIndex=1
    if hbConn then hbConn:Disconnect() end

    hbConn=RunService.Heartbeat:Connect(function(dt)
        if not AP.active then hbConn:Disconnect(); hbConn=nil; return end

        -- Re-find aircraft if needed
        if not AP.rootPart or not AP.rootPart.Parent then
            local char=Player.Character
            if char then
                local hum=char:FindFirstChildOfClass("Humanoid")
                if hum and hum.SeatPart then
                    AP.aircraft=hum.SeatPart.Parent
                    AP.rootPart=AP.aircraft:FindFirstChild("Body")
                        or AP.aircraft:FindFirstChild("Fuselage")
                        or AP.aircraft:FindFirstChild("Main")
                        or hum.SeatPart
                end
            end
            return
        end

        -- Create BodyVelocity
        if not bvel or not bvel.Parent then
            pcall(function()
                bvel=Instance.new("BodyVelocity")
                bvel.MaxForce=Vector3.new(1e9,1e9,1e9)
                bvel.Velocity=Vector3.new(0,0,0)
                bvel.P=8e4        -- slightly softer P for smoother response
                bvel.Parent=AP.rootPart
            end); return
        end

        -- Create BodyGyro
        if not bgyro or not bgyro.Parent then
            pcall(function()
                bgyro=Instance.new("BodyGyro")
                bgyro.MaxTorque=Vector3.new(1e9,1e9,1e9)
                bgyro.P=4e4; bgyro.D=4500  -- higher D for less oscillation
                bgyro.CFrame=AP.rootPart.CFrame
                bgyro.Parent=AP.rootPart
            end); return
        end

        local pos    = AP.rootPart.Position
        local alt    = getAlt()
        local arrThr = AP.arrRunway.threshold
        local arrDir = headingDir(AP.arrRunway.heading)
        local depDir = headingDir(AP.depRunway.heading)

        pcall(function()
            -- ── TAKEOFF ──────────────────────────────────────────────────────
            if AP.phase == "TAKEOFF" then
                local accelRate = AP.TAKEOFF_SPD * 1.8
                spd = math.min(spd + accelRate * dt, AP.TAKEOFF_SPD)

                -- Rotate at 82% of takeoff speed for smooth liftoff
                local rotFactor = math.clamp((spd/AP.TAKEOFF_SPD - 0.72) / 0.28, 0, 1)
                local pitchY = math.tan(math.rad(AP.CLIMB_PITCH)) * rotFactor
                local moveDir = (depDir + Vector3.new(0, pitchY, 0)).Unit
                fly(moveDir * spd, moveDir)

                if alt >= AP.CRUISE_ALT then
                    AP.phase="CRUISE"; spd=AP.CRUISE_SPD
                    task.spawn(function() pressKey("G") end)
                    logEvent("Cruise altitude reached")
                end

            -- ── CRUISE (waypoint following) ──────────────────────────────────
            elseif AP.phase == "CRUISE" then
                if wpIndex > #waypoints then
                    AP.phase="APPROACH"; spd=AP.LANDING_SPD*1.15; return
                end
                local wp = waypoints[wpIndex]
                local d2D = dist2D(pos, wp.pos)
                local toWP = Vector3.new(wp.pos.X-pos.X, 0, wp.pos.Z-pos.Z)
                local hDir = d2D > 1 and toWP.Unit or arrDir

                -- Smooth altitude hold: proportional + small cap
                local altErr = wp.pos.Y - alt
                local yComp = math.clamp(altErr * 0.004, -0.14, 0.14)
                -- Anti-stall: don't climb if speed is dropping
                if yComp > 0 and AP.CRUISE_SPD - spd > 30 then
                    yComp = math.min(yComp, 0.04)
                end
                fly((hDir + Vector3.new(0, yComp, 0)).Unit * AP.CRUISE_SPD, hDir)

                if d2D < 700 then
                    wp.onArrive(); wpIndex=wpIndex+1
                    if AP.phase == "APPROACH" then return end
                end

            -- ── APPROACH — ILS Glideslope + Flare ───────────────────────────
            elseif AP.phase == "APPROACH" then
                local toThr = Vector3.new(arrThr.X-pos.X, 0, arrThr.Z-pos.Z)
                local hDir  = toThr.Magnitude > 10 and toThr.Unit or arrDir
                local heightAbove = alt - arrThr.Y
                local dThresh = dist2D(pos, arrThr)

                -- ILS 3° glideslope: ideal altitude at current distance
                local gsTargetAlt = arrThr.Y + dThresh * GLIDE_TAN
                local gsError = alt - gsTargetAlt   -- above = positive

                local sinkComp
                if gsError > 0 then
                    -- Above glideslope: descend to intercept
                    -- Allow steeper initial capture (max ~15°) but smooth on final
                    local maxDive = math.min(0.26, GLIDE_TAN + gsError * 0.0005)
                    sinkComp = -maxDive
                else
                    -- Below glideslope: climb gently to intercept
                    sinkComp = -GLIDE_TAN + math.clamp(-gsError * 0.0004, 0, 0.05)
                end

                -- FLARE: smooth quadratic roundout starting at FLARE_ALT
                if heightAbove < FLARE_ALT then
                    local t = math.max(0, heightAbove / FLARE_ALT)
                    sinkComp = sinkComp * (t * t)
                    sinkComp = math.max(sinkComp, -0.010)   -- very soft cap
                end

                -- Hard pitch/dive cap — prevents stall-inducing extreme attitudes
                sinkComp = math.clamp(sinkComp, -0.28, 0.10)

                -- Speed management: smoothly reduce toward landing speed
                local targetSpd = AP.LANDING_SPD
                if dThresh > 10000 then targetSpd = AP.LANDING_SPD * 1.2
                elseif dThresh > 5000 then
                    targetSpd = AP.LANDING_SPD * (1.0 + 0.2 * (dThresh-5000)/5000)
                end
                spd = spd + (targetSpd - spd) * math.min(dt * 0.8, 1.0)

                -- ANTI-STALL: never drop below minimum approach speed
                local minSpd = AP.LANDING_SPD * STALL_FACTOR
                spd = math.max(spd, minSpd)

                -- Fly: velocity includes sink, gyro follows horizontal heading
                local moveDir = (hDir + Vector3.new(0, sinkComp, 0)).Unit
                fly(moveDir * spd, hDir)

                -- TOUCHDOWN detection
                if heightAbove <= 2 or (dThresh < 400 and heightAbove < 10) then
                    AP.phase="ROLLOUT"
                    task.spawn(function() pressKey("R") end)
                    logEvent("Touchdown! 🛬")
                end

            -- ── ROLLOUT — smooth braking along runway heading ─────────────────
            -- FIXED: use arrDir (runway heading) NOT toward-threshold (which reverses!)
            elseif AP.phase == "ROLLOUT" then
                spd = math.max(spd - BRAKE_RATE * dt, 0)
                fly(arrDir * spd, arrDir)    -- always roll along runway, never reverse

                if spd <= 1 then
                    fly(Vector3.new(0,0,0), arrDir)
                    task.spawn(function()
                        task.wait(0.1); pressKey("R")
                        task.wait(0.3); pressKey("X")
                    end)
                    stopAP("Flight complete ✅")
                end
            end
        end)
    end)
end

-- ════════════════════════════════════════════════════════════════════
-- START AP
-- ════════════════════════════════════════════════════════════════════
local function startAP()
    if AP.active         then return false,"Already active!" end
    if not AP.depRunway  then return false,"Select departure runway!" end
    if not AP.arrRunway  then return false,"Select arrival runway!" end
    if AP.depRunway==AP.arrRunway then return false,"Dep = Arr not allowed!" end
    local char=Player.Character
    if not char then return false,"No character!" end
    local hum=char:FindFirstChildOfClass("Humanoid")
    if not hum or not hum.SeatPart then return false,"Board an aircraft first!" end
    local ac   = hum.SeatPart.Parent
    local root = ac:FindFirstChild("Body") or ac:FindFirstChild("Fuselage")
        or ac:FindFirstChild("Main") or hum.SeatPart
    AP.aircraft=ac; AP.rootPart=root
    AP.active=true; AP.phase="TAKEOFF"; flightLog={}
    logEvent("AP START: "..AP.depRunway.name.." → "..AP.arrRunway.name)
    if bvel  and bvel.Parent  then bvel:Destroy()  end
    if bgyro and bgyro.Parent then bgyro:Destroy() end
    bvel=Instance.new("BodyVelocity")
    bvel.MaxForce=Vector3.new(1e9,1e9,1e9); bvel.Velocity=Vector3.new(0,0,0)
    bvel.P=8e4; bvel.Parent=root
    bgyro=Instance.new("BodyGyro")
    bgyro.MaxTorque=Vector3.new(1e9,1e9,1e9)
    bgyro.P=4e4; bgyro.D=4500; bgyro.CFrame=root.CFrame; bgyro.Parent=root
    local depDir=headingDir(AP.depRunway.heading)
    local spawnPos=AP.depRunway.threshold-depDir*80
    spawnPos=Vector3.new(spawnPos.X,AP.depRunway.threshold.Y+3,spawnPos.Z)
    local ok=pcall(function() ac:PivotTo(CFrame.new(spawnPos,spawnPos+depDir)) end)
    if not ok then
        local offset=spawnPos-root.Position
        for _,p in pairs(ac:GetDescendants()) do
            if p:IsA("BasePart") then p.CFrame=p.CFrame+offset end
        end
    end
    buildWaypoints()
    if GPS.enabled then buildTunnel() end
    task.wait(0.5)
    task.spawn(function() pressKey("E"); task.wait(0.3); pressKey("F") end)
    task.wait(0.6)
    startLoop()
    return true,"Flight started! 🛫"
end

Player.CharacterAdded:Connect(function()
    if AP.active then stopAP("Character reset") end
end)

-- ════════════════════════════════════════════════════════════════════
-- COLOUR PALETTE — enhanced
-- ════════════════════════════════════════════════════════════════════
local C = {
    bg       = Color3.fromRGB(6, 9, 16),
    bgGlass  = Color3.fromRGB(10, 15, 26),
    panel    = Color3.fromRGB(12, 18, 30),
    panelB   = Color3.fromRGB(16, 24, 40),
    panelC   = Color3.fromRGB(20, 30, 52),
    border   = Color3.fromRGB(32, 52, 78),
    borderHi = Color3.fromRGB(55, 115, 200),
    green    = Color3.fromRGB(0,  235, 140),
    greenD   = Color3.fromRGB(0,  130, 65),
    greenHL  = Color3.fromRGB(60, 255, 160),
    cyan     = Color3.fromRGB(40, 205, 255),
    cyanD    = Color3.fromRGB(0,  100, 165),
    cyanHL   = Color3.fromRGB(120,230,255),
    amber    = Color3.fromRGB(255, 195, 0),
    amberD   = Color3.fromRGB(130, 85, 0),
    red      = Color3.fromRGB(255, 70, 70),
    redD     = Color3.fromRGB(110, 18, 18),
    redHL    = Color3.fromRGB(255,120,120),
    white    = Color3.fromRGB(220, 232, 245),
    dim      = Color3.fromRGB(85, 108, 132),
    dimL     = Color3.fromRGB(140, 165, 195),
    sky      = Color3.fromRGB(28, 88, 180),
    skyHi    = Color3.fromRGB(55, 135, 255),
    ground   = Color3.fromRGB(108, 68, 28),
    groundHi = Color3.fromRGB(158, 108, 48),
    magenta  = Color3.fromRGB(200, 65, 200),
    purple   = Color3.fromRGB(145, 85, 225),
    gold     = Color3.fromRGB(255, 215, 0),
    teal     = Color3.fromRGB(0, 200, 180),
}

-- ════════════════════════════════════════════════════════════════════
-- UI BUILDER UTILITIES
-- ════════════════════════════════════════════════════════════════════
local function F(parent,sx,sy,ox,oy,px,py,popx,popy,col,transp,zi)
    local f=Instance.new("Frame")
    f.Size=UDim2.new(sx or 0,ox or 0,sy or 0,oy or 0)
    f.Position=UDim2.new(px or 0,popx or 0,py or 0,popy or 0)
    f.BackgroundColor3=(typeof(col)=="Color3") and col or C.panel
    f.BackgroundTransparency=(typeof(transp)=="number") and transp or 0
    f.BorderSizePixel=0
    f.ZIndex=(typeof(zi)=="number") and zi or 1
    f.Parent=parent
    return f
end

local function L(parent,text,ts,col,font,xa,sx,sy,ox,oy,px,py,popx,popy,zi)
    local l=Instance.new("TextLabel")
    l.Text=text or ""; l.TextSize=ts or 12
    l.TextColor3=col or C.white; l.Font=font or Enum.Font.Code
    l.BackgroundTransparency=1
    l.TextXAlignment=xa or Enum.TextXAlignment.Center
    l.Size=UDim2.new(sx or 1,ox or 0,sy or 1,oy or 0)
    l.Position=UDim2.new(px or 0,popx or 0,py or 0,popy or 0)
    l.ZIndex=zi or 2; l.Parent=parent
    return l
end

local function Btn(parent,text,ts,col,bgcol,sx,sy,ox,oy,px,py,popx,popy,zi)
    local b=Instance.new("TextButton")
    b.Text=text or ""; b.TextSize=ts or 12
    b.TextColor3=col or C.white; b.Font=Enum.Font.GothamBold
    b.BackgroundColor3=bgcol or C.panel; b.BorderSizePixel=0
    b.AutoButtonColor=false
    b.Size=UDim2.new(sx or 0,ox or 80,sy or 0,oy or 24)
    b.Position=UDim2.new(px or 0,popx or 0,py or 0,popy or 0)
    b.ZIndex=zi or 3; b.Parent=parent
    return b
end

local function Rnd(inst,r)
    local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r or 4); c.Parent=inst
end

local function Str(inst,col,thick)
    local s=Instance.new("UIStroke"); s.Color=col or C.border
    s.Thickness=thick or 1; s.Parent=inst
end

-- Improved draggable — all major panels
local function makeDraggable(handle, target)
    local drag,ds,sp=false,nil,nil
    handle.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            drag=true; ds=i.Position; sp=target.Position
        end
    end)
    handle.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and i.UserInputType==Enum.UserInputType.MouseMovement then
            local d=i.Position-ds
            target.Position=UDim2.new(
                sp.X.Scale, sp.X.Offset+d.X,
                sp.Y.Scale, sp.Y.Offset+d.Y)
        end
    end)
end

-- Hover effect helper
local function addHover(btn, normalCol, hoverCol)
    normalCol=normalCol or btn.BackgroundColor3
    if not hoverCol then
        hoverCol=Color3.new(
            math.min(normalCol.R+0.10,1),
            math.min(normalCol.G+0.10,1),
            math.min(normalCol.B+0.10,1))
    end
    btn.MouseEnter:Connect(function()
        TweenS:Create(btn,TweenInfo.new(0.12),{BackgroundColor3=hoverCol}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenS:Create(btn,TweenInfo.new(0.18),{BackgroundColor3=normalCol}):Play()
    end)
end

-- Animate panel open
local function panelOpen(panel, targetPos)
    panel.Visible=true
    panel.Position=UDim2.new(
        targetPos.X.Scale, targetPos.X.Offset,
        targetPos.Y.Scale, targetPos.Y.Offset+18)
    TweenS:Create(panel,TweenInfo.new(0.22,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
        {Position=targetPos}):Play()
end

local function panelClose(panel)
    local curPos=panel.Position
    TweenS:Create(panel,TweenInfo.new(0.16,Enum.EasingStyle.Quad,Enum.EasingDirection.In),
        {Position=UDim2.new(curPos.X.Scale,curPos.X.Offset,curPos.Y.Scale,curPos.Y.Offset+12)}):Play()
    task.delay(0.18,function() panel.Visible=false end)
end

-- ════════════════════════════════════════════════════════════════════
-- MAIN SCREENGUI
-- ════════════════════════════════════════════════════════════════════
local sg=Instance.new("ScreenGui")
sg.Name="PTFSMain"; sg.ResetOnSpawn=false
sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
sg.DisplayOrder=100; sg.Parent=PlayerGui

-- ════════════════════════════════════════════════════════════════════
-- TOAST NOTIFICATION SYSTEM
-- ════════════════════════════════════════════════════════════════════
local toastBG = F(sg,0,0,340,52,0.5,1,-170,-80,C.panel,0,98)
Rnd(toastBG,10); Str(toastBG,C.border,1.5)
toastBG.Visible=false
-- accent line
local toastAccent=F(toastBG,0,1,4,0,0,0,0,0,C.green,0,99); Rnd(toastAccent,10)
local toastIconL=L(toastBG,"✈",22,C.green,Enum.Font.GothamBold,nil,0,1,42,0,0,0,6,0,100)
local toastMsgL=L(toastBG,"",11,C.white,Enum.Font.Gotham,Enum.TextXAlignment.Left,1,0,
    -56,-2,0,0,52,24,100)
local toastSubL=L(toastBG,"",9,C.dim,Enum.Font.Code,Enum.TextXAlignment.Left,1,0,
    -56,0,0,0,52,38,100)
local toastActive=false
local toastQueue={}

local function processToastQueue()
    if toastActive or #toastQueue==0 then return end
    toastActive=true
    local t=table.remove(toastQueue,1)
    toastIconL.Text=t.icon or "✈"
    toastIconL.TextColor3=t.color or C.green
    toastMsgL.Text=t.msg or ""
    toastSubL.Text=t.sub or ""
    toastAccent.BackgroundColor3=t.color or C.green
    Str(toastBG,t.color or C.border,1.5)
    toastBG.Visible=true
    toastBG.Position=UDim2.new(0.5,-170,1,10)
    TweenS:Create(toastBG,TweenInfo.new(0.32,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
        {Position=UDim2.new(0.5,-170,1,-80)}):Play()
    task.delay(3.2,function()
        TweenS:Create(toastBG,TweenInfo.new(0.22,Enum.EasingStyle.Quad),
            {Position=UDim2.new(0.5,-170,1,10)}):Play()
        task.delay(0.24,function()
            toastBG.Visible=false; toastActive=false
            task.delay(0.1,processToastQueue)
        end)
    end)
end

local function toast(msg, icon, color, sub)
    table.insert(toastQueue,{msg=msg,icon=icon,color=color,sub=sub})
    processToastQueue()
end

-- ════════════════════════════════════════════════════════════════════
-- COCKPIT HUD — enhanced
-- ════════════════════════════════════════════════════════════════════
local HW,HH = 740,268
local TH=28; local SPD_W=68; local ALT_W=76
local PFD_W=HW-SPD_W-ALT_W-4; local PFD_H=HH-TH-2
local ND_W=148; local AI_W=PFD_W-ND_W-2

local hud=F(sg,0,0,HW,HH,0.5,1,-HW/2,-HH-10,C.bg,0,1)
Rnd(hud,12); Str(hud,C.borderHi,1.5)

local hudTitle=F(hud,1,0,0,TH,0,0,0,0,Color3.fromRGB(8,14,26),0,2)
Rnd(hudTitle,12)
L(hudTitle,"✈   PTFS  FLIGHT  DECK  v18",11,C.cyan,Enum.Font.GothamBold)
-- AP active indicator in title
local hudAPDot=F(hudTitle,0,0,8,8,1,0.5,-40,-4,C.red,0,3); Rnd(hudAPDot,4)
local hudAPLbl=L(hudTitle,"AP OFF",9,C.red,Enum.Font.GothamBold,Enum.TextXAlignment.Right,
    0,0,60,0,1,0,-44,0,3)
local hudClose=Btn(hud,"✕",11,C.white,C.redD,0,0,22,20,1,0,-26,4,5)
Rnd(hudClose,4); Str(hudClose,C.red,1)
addHover(hudClose,C.redD,Color3.fromRGB(150,25,25))
hudClose.MouseButton1Click:Connect(function() panelClose(hud) end)

local hudC=F(hud,1,1,-2,-(TH+2),0,0,1,TH+1,Color3.fromRGB(0,0,0),1,1)

-- SPD TAPE
local spdPanel=F(hudC,0,1,SPD_W,0,0,0,0,0,Color3.fromRGB(8,15,12),0,2)
Rnd(spdPanel,6); Str(spdPanel,Color3.fromRGB(0,75,45),1)
L(spdPanel,"SPD",8,C.greenD,Enum.Font.GothamBold,nil,1,0,0,14,0,0,0,0,3)
L(spdPanel,"KTS",8,C.greenD,Enum.Font.GothamBold,nil,1,0,0,14,1,0,0,-14,3)
local spdBox=F(spdPanel,1,0,-8,32,0,0,4,0,Color3.fromRGB(0,18,10),0,3)
spdBox.Position=UDim2.new(0,4,0.5,-16); Rnd(spdBox,4); Str(spdBox,C.green,1)
local spdVal=L(spdBox,"0",18,C.green,Enum.Font.Code,nil,1,1,0,0,0,0,0,0,4)
local spdTickContainer=F(spdPanel,1,1,0,-36,0,0,0,18,Color3.fromRGB(0,0,0),1,2)
spdTickContainer.ClipsDescendants=true
for i=0,20 do
    local v=i*50; local yPct=1-(v/1000); local major=v%100==0
    F(spdTickContainer,0,0,major and 18 or 10,1,1,0,-(major and 18 or 10),0,
        major and Color3.fromRGB(0,185,85) or Color3.fromRGB(0,75,38),0,3)
    if major then
        L(spdTickContainer,tostring(v),8,Color3.fromRGB(0,165,72),Enum.Font.Code,
            Enum.TextXAlignment.Right,0,0,SPD_W-22,14,0,yPct,0,-8,3)
    end
end
F(spdPanel,1,0,-4,2,0,0.5,2,-1,C.green,0,5)

-- ALT TAPE
local altPanel=F(hudC,0,1,ALT_W,0,1,0,-ALT_W,0,Color3.fromRGB(8,11,22),0,2)
Rnd(altPanel,6); Str(altPanel,Color3.fromRGB(28,48,118),1)
L(altPanel,"ALT",8,C.cyanD,Enum.Font.GothamBold,nil,1,0,0,14,0,0,0,0,3)
L(altPanel,"STD",8,C.cyanD,Enum.Font.GothamBold,nil,1,0,0,14,1,0,0,-14,3)
local altBox=F(altPanel,1,0,-8,32,0,0,4,0,Color3.fromRGB(4,7,26),0,3)
altBox.Position=UDim2.new(0,4,0.5,-16); Rnd(altBox,4); Str(altBox,C.cyan,1)
local altVal=L(altBox,"0",16,C.cyan,Enum.Font.Code,nil,1,1,0,0,0,0,0,0,4)
local altTickContainer=F(altPanel,1,1,0,-36,0,0,0,18,Color3.fromRGB(0,0,0),1,2)
altTickContainer.ClipsDescendants=true
for i=0,16 do
    local v=i*500; local yPct=1-(v/8000)
    F(altTickContainer,0,0,14,1,0,yPct,0,-1,Color3.fromRGB(38,78,178),0,3)
    L(altTickContainer,tostring(v),8,Color3.fromRGB(38,98,198),Enum.Font.Code,
        Enum.TextXAlignment.Left,0,0,ALT_W-20,14,0,yPct,16,-8,3)
end
F(altPanel,1,0,-4,2,0,0.5,2,-1,C.cyan,0,5)

-- PFD AREA
local pfdArea=F(hudC,0,1,PFD_W,0,0,0,SPD_W+2,0,Color3.fromRGB(0,0,0),1,1)

-- Attitude Indicator
local aiW=AI_W
local ai=F(pfdArea,0,1,aiW,0,0,0,0,0,C.sky,0,2)
Rnd(ai,6); ai.ClipsDescendants=true
local skyTop =F(ai,1,0.6,0,0,0,0,   0,0,Color3.fromRGB(18,68,158),0,2)
local skyBot =F(ai,1,0.5,0,0,0,0.5, 0,0,Color3.fromRGB(48,118,218),0,2)
local gndTop =F(ai,1,0.5,0,0,0,0.5, 0,0,Color3.fromRGB(128,82,32), 0,2)
local gndBot =F(ai,1,0.5,0,0,0,1,   0,0,Color3.fromRGB(88,52,18),  0,2)
gndBot.AnchorPoint=Vector2.new(0,1)
local horizLine=F(ai,1,0,0,2,0,0.5,0,-1,C.amber,0,5)
for _,deg in ipairs({-15,-10,-5,5,10,15}) do
    local yBase=0.5-(deg*0.018)
    local w=math.abs(deg)>=10 and 0.42 or 0.28
    F(ai,w,0,0,1,(1-w)/2,yBase,0,0,Color3.fromRGB(218,218,195),0.3,4)
    L(ai,string.format("%+d",deg),8,Color3.fromRGB(218,218,178),Enum.Font.Code,
        Enum.TextXAlignment.Right,0,0,(1-w)/2*aiW-4,12,0,yBase,0,-6,4)
    L(ai,string.format("%+d",deg),8,Color3.fromRGB(218,218,178),Enum.Font.Code,
        Enum.TextXAlignment.Left,0,0,(1-w)/2*aiW-4,12,(1+w)/2,yBase,4,-6,4)
end
-- Aircraft symbol
F(ai,0,0,44,3,0.5,0.5,-52,-1,Color3.fromRGB(255,212,0),0,6)
F(ai,0,0,44,3,0.5,0.5,  8,-1,Color3.fromRGB(255,212,0),0,6)
local wDot=F(ai,0,0,8,8,0.5,0.5,-4,-4,Color3.fromRGB(255,212,0),0,6); Rnd(wDot,4)
F(ai,0,0,3,14,0.5,0.5,-1,-14,Color3.fromRGB(255,212,0),0,6)
-- FPV
local fpvFrame=F(ai,0,0,18,18,0.5,0.5,-9,-9,Color3.fromRGB(0,0,0),1,7)
local fpvCircle=F(fpvFrame,1,1,0,0,0,0,0,0,Color3.fromRGB(0,0,0),1,7)
Str(fpvCircle,C.green,1.5); Rnd(fpvCircle,9)
F(fpvFrame,0,0,8,1,1,0.5, 1,0,Color3.fromRGB(0,232,122),0,8)
F(fpvFrame,0,0,8,1,0,0.5,-9,0,Color3.fromRGB(0,232,122),0,8)
F(fpvFrame,0,0,1,8,0.5,0,-1,-9,Color3.fromRGB(0,232,122),0,8)

-- GLIDE SLOPE deviation bar (new in v18)
local gsBarW=10
local gsPanel=F(pfdArea,0,1,gsBarW,-(20+hdgStripH or 0),0,0,aiW-gsBarW-2,22,
    Color3.fromRGB(8,10,20),0,3)
gsPanel.Size=UDim2.new(0,gsBarW,1,-54)
Rnd(gsPanel,4); Str(gsPanel,Color3.fromRGB(40,55,80),1)
local gsDot=F(gsPanel,1,0,0,6,0,0.5,0,-3,C.amber,0,5); Rnd(gsDot,3)
local gsAbove=F(gsPanel,0,0,6,2,0.5,0,2,6,C.dim,0,4); Rnd(gsAbove,1)
local gsBelow=F(gsPanel,0,0,6,2,0.5,1,2,-8,C.dim,0,4); Rnd(gsBelow,1)
L(gsPanel,"G",7,C.amber,Enum.Font.GothamBold,nil,1,0,0,12,0,0,0,0,4)
L(gsPanel,"S",7,C.amber,Enum.Font.GothamBold,nil,1,0,0,12,1,0,0,-12,4)

-- Heading strip
local hdgStripH=28
local hdgStrip=F(pfdArea,0,0,aiW,hdgStripH,0,1,0,-hdgStripH,Color3.fromRGB(8,13,22),0,3)
Str(hdgStrip,C.border,1); Rnd(hdgStrip,4)
for i=0,35 do
    local deg=i*10; local xPct=deg/360; local major=deg%30==0
    F(hdgStrip,0,0,1,major and 10 or 6,xPct,0,0,0,
        major and Color3.fromRGB(58,108,178) or Color3.fromRGB(28,52,88),0,4)
    if major then
        local dirs={[0]="N",[90]="E",[180]="S",[270]="W"}
        local txt=dirs[deg] or tostring(deg)
        L(hdgStrip,txt,8,Color3.fromRGB(58,118,198),Enum.Font.Code,nil,0,0,20,12,xPct,0,-10,10,4)
    end
end
local hdgPtr=F(hdgStrip,0,0,2,16,0.5,0,-1,0,C.cyan,0,5)
local hdgReadBox=F(hdgStrip,0,1,56,-4,0.5,0,-28,2,Color3.fromRGB(4,9,28),0,5)
Rnd(hdgReadBox,3); Str(hdgReadBox,C.cyan,1)
local hdgRead=L(hdgReadBox,"000°",13,C.cyan,Enum.Font.Code,nil,1,1,0,0,0,0,0,0,6)

-- Top strip
local topStrip=F(pfdArea,0,0,aiW,22,0,0,0,0,Color3.fromRGB(7,11,19),0,3); Rnd(topStrip,4)
local pitchRead=L(topStrip,"PTH +0.0°",10,C.amber,Enum.Font.Code,Enum.TextXAlignment.Left,0,1,0,0,0,0,6,0,4)
local vsRead   =L(topStrip,"V/S +0",   10,C.green, Enum.Font.Code,Enum.TextXAlignment.Right,0,1,0,0,0,0,-6,0,4)
local apModeL  =L(topStrip,"",         10,C.cyan,  Enum.Font.GothamBold,nil,1,1,-12,0,0,0,0,0,4)

-- NAV DISPLAY
local ndX=aiW+2
local nd=F(pfdArea,0,1,ND_W,0,0,0,ndX,0,Color3.fromRGB(7,9,19),0,2)
Rnd(nd,6); Str(nd,C.border,1)
L(nd,"NAV",9,C.cyan,Enum.Font.GothamBold,nil,1,0,0,18,0,0,0,0,3)
local compassR=52
local compassBG=F(nd,0,0,compassR*2,compassR*2,0.5,0,-compassR,22,Color3.fromRGB(7,11,22),0,3)
Rnd(compassBG,compassR); Str(compassBG,Color3.fromRGB(38,62,98),1)
local compassGlow=F(nd,0,0,compassR*2+6,compassR*2+6,0.5,0,-compassR-3,19,Color3.fromRGB(0,0,0),1,2)
Rnd(compassGlow,compassR+3); Str(compassGlow,Color3.fromRGB(18,48,98),1)
for _,cd in ipairs({{t="N",a=0,c=C.cyan},{t="E",a=90,c=C.white},{t="S",a=180,c=C.white},{t="W",a=270,c=C.white}}) do
    local r2=math.rad(cd.a); local cx=math.sin(r2)*(compassR-10); local cy=-math.cos(r2)*(compassR-10)
    L(compassBG,cd.t,9,cd.c,Enum.Font.GothamBold,nil,0,0,16,14,0.5,0.5,cx-8,cy-7,4)
end
for i=0,35 do
    local r2=math.rad(i*10); local major=(i*10)%30==0
    local rm=compassR-(major and 10 or 6)
    local tx=math.sin(r2)*(rm+(compassR-2-rm)/2)
    local ty=-math.cos(r2)*(rm+(compassR-2-rm)/2)
    F(compassBG,0,0,major and 2 or 1,major and 2 or 1,0.5,0.5,tx-1,ty-1,
        major and Color3.fromRGB(58,118,198) or Color3.fromRGB(28,58,98),0,4)
end
L(compassBG,"✈",16,C.white,Enum.Font.GothamBold,nil,0,0,22,22,0.5,0.5,-11,-12,5)
F(compassBG,0,0,2,compassR-8,0.5,0.5,-1,-(compassR-8),C.cyan,0,5)
local ndHdgLbl  =L(nd,"000°",     14,C.cyan,  Enum.Font.Code,nil,1,0,0,20,0,0,0,compassR*2+26,3)
local ndDestLbl =L(nd,"DEST: ---", 9,C.green, Enum.Font.Code,nil,1,0,0,16,0,0,0,compassR*2+48,3)
local ndWPLbl   =L(nd,"WP: -/-",  9,C.amber, Enum.Font.Code,nil,1,0,0,16,0,0,0,compassR*2+66,3)
local ndPhaseLbl=L(nd,"IDLE",    10,C.red,   Enum.Font.GothamBold,nil,1,0,0,18,0,0,0,compassR*2+84,3)
local ndGPSLbl  =L(nd,"GPS OFF", 8,C.dim,   Enum.Font.Code,nil,1,0,0,14,0,0,0,compassR*2+102,3)
local ndGSLbl   =L(nd,"GS ---",  8,C.amber, Enum.Font.Code,nil,1,0,0,14,0,0,0,compassR*2+116,3)

-- BOTTOM BAR
local barH=34
local bar=F(hud,1,0,0,barH,0,1,0,-barH-1,Color3.fromRGB(7,10,19),0,3)
Rnd(bar,6); Str(bar,C.border,1)
local barCells={
    {k="gs",   l="G/S",  c=C.green},
    {k="vs",   l="V/S",  c=C.cyan},
    {k="dist", l="DIST", c=C.amber},
    {k="wp",   l="WYPT", c=Color3.fromRGB(178,178,255)},
    {k="phase",l="PHASE",c=C.magenta},
    {k="dep",  l="DEP",  c=C.dim},
    {k="arr",  l="ARR",  c=C.dim},
}
local barVals={}
local cw=HW/#barCells
for i,cell in ipairs(barCells) do
    local cx=(i-1)*cw
    local bg=F(bar,0,1,cw-2,-4,0,0,cx+1,2,Color3.fromRGB(10,15,26),0,3); Rnd(bg,3)
    L(bg,cell.l,7,C.dim,Enum.Font.GothamBold,nil,1,0,0,12,0,0,0,2,4)
    barVals[cell.k]=L(bg,"--",12,cell.c,Enum.Font.Code,nil,1,0,0,16,0,0,0,13,4)
    if i<#barCells then F(bar,0,1,1,-8,0,0,cx+cw,4,C.border,0,4) end
end

makeDraggable(hudTitle, hud)

-- ════════════════════════════════════════════════════════════════════
-- MAIN MENU — redesigned (wider, better tabs)
-- ════════════════════════════════════════════════════════════════════
local MENU_W=268
local menuPanel=F(sg,0,0,MENU_W,560,0,0.5,0,-280,C.bg,0,10)
menuPanel.Visible=false; Rnd(menuPanel,12); Str(menuPanel,C.borderHi,1.5)
local menuTitle=F(menuPanel,1,0,0,34,0,0,0,0,Color3.fromRGB(8,16,30),0,11)
Rnd(menuTitle,12)
-- gradient effect via two overlapping frames
local menuTitleGrad=F(menuTitle,0.5,1,0,0,0.5,0,0,0,Color3.fromRGB(16,30,58),0,11)
L(menuTitle,"✈  PTFS  AUTOPILOT  v18",12,C.cyan,Enum.Font.GothamBold,nil,1,1,0,0,0,0,0,0,12)
makeDraggable(menuTitle,menuPanel)
local menuClose=Btn(menuPanel,"✕",11,C.white,C.redD,0,0,24,24,1,0,-28,5,13)
Rnd(menuClose,5); addHover(menuClose,C.redD,Color3.fromRGB(145,22,22))
menuClose.MouseButton1Click:Connect(function() panelClose(menuPanel) end)

local tabs={"✈ Dep","🛬 Arr","⚙ Cfg","🛰 GPS","📋 Log"}
local tabBtns,tabContents={},{}
local activeTab=1
local tabBar        =F(menuPanel,1,0,0,30,0,0,0,36,Color3.fromRGB(7,11,19),0,11)
local tabContentArea=F(menuPanel,1,1,0,-70,0,0,0,68,Color3.fromRGB(0,0,0),1,11)
local tabW=MENU_W/#tabs
for i,name in ipairs(tabs) do
    local tbtn=Btn(tabBar,name,8,C.dim,Color3.fromRGB(9,13,22),0,1,tabW-2,0,0,0,(i-1)*tabW+1,0,12)
    Rnd(tbtn,4)
    table.insert(tabBtns,tbtn)
    local tc=F(tabContentArea,1,1,0,0,0,0,0,0,Color3.fromRGB(0,0,0),1,11)
    tc.Visible=(i==1); table.insert(tabContents,tc)
    tbtn.MouseButton1Click:Connect(function()
        for j,tb in ipairs(tabBtns) do
            TweenS:Create(tb,TweenInfo.new(0.12),{
                BackgroundColor3=(j==i) and Color3.fromRGB(14,26,48) or Color3.fromRGB(9,13,22),
                TextColor3=(j==i) and C.cyan or C.dim
            }):Play()
            tabContents[j].Visible=(j==i)
        end; activeTab=i
    end)
end
tabBtns[1].BackgroundColor3=Color3.fromRGB(14,26,48); tabBtns[1].TextColor3=C.cyan

local function makeScroll(parent)
    local sf=Instance.new("ScrollingFrame")
    sf.Size=UDim2.new(1,-4,1,0); sf.Position=UDim2.new(0,2,0,0)
    sf.BackgroundTransparency=1; sf.BorderSizePixel=0
    sf.ScrollBarThickness=3; sf.ScrollBarImageColor3=C.cyanD
    sf.CanvasSize=UDim2.new(0,0,0,0)
    sf.AutomaticCanvasSize=Enum.AutomaticSize.Y; sf.Parent=parent
    local layout=Instance.new("UIListLayout")
    layout.SortOrder=Enum.SortOrder.LayoutOrder
    layout.Padding=UDim.new(0,3); layout.Parent=sf
    return sf
end

local function sectionHdr(parent,txt,col)
    local h=F(parent,1,0,0,24,0,0,0,0,Color3.fromRGB(7,16,34),0,12); Rnd(h,4)
    local acc=F(h,0,1,3,0,0,0,0,0,col or C.cyan,0,13)
    L(h,txt,9,col or C.cyan,Enum.Font.GothamBold,Enum.TextXAlignment.Left,1,1,-12,0,0,0,8,0,13)
    return h
end

local function typeColor(t)
    if t=="International" then return C.cyan
    elseif t=="Regional"  then return C.green
    elseif t=="Military"  then return C.amber
    elseif t=="STOL"      then return C.magenta
    else return C.dim end
end

local function runwayBtn(parent, apName, rwy, isArr, selLabel)
    local btnF=F(parent,1,0,-8,32,0,0,4,0,Color3.fromRGB(11,17,30),0,12)
    Rnd(btnF,6); Str(btnF,C.border,1)
    -- Runway info
    local lbl=string.format("RWY %s  HDG %.0f°  %dm",rwy.name,rwy.heading,rwy.length or 0)
    L(btnF,lbl,9,C.white,Enum.Font.Code,Enum.TextXAlignment.Left,1,0,-8,0,0,0.3,6,0,13)
    -- Heading mini-indicator
    local hdgDot=F(btnF,0,0,8,8,1,0.5,-10,-4,isArr and C.cyanD or C.greenD,0,13); Rnd(hdgDot,4)
    local clickBtn=Btn(btnF,"",10,C.white,Color3.fromRGB(0,0,0),1,1,0,0,0,0,0,0,14)
    clickBtn.BackgroundTransparency=1
    addHover(clickBtn,Color3.fromRGB(0,0,0),
        isArr and Color3.fromRGB(0,20,35) or Color3.fromRGB(0,22,12))
    clickBtn.MouseButton1Click:Connect(function()
        if isArr then AP.arrRunway=rwy else AP.depRunway=rwy end
        if selLabel then
            selLabel.Text="✅ "..apName.." · RWY "..rwy.name.." ("..string.format("%.0f",rwy.heading).."°)"
            selLabel.TextColor3=isArr and C.cyan or C.green
        end
        local hiCol=isArr and C.cyanD or C.greenD
        TweenS:Create(btnF,TweenInfo.new(0.12),{BackgroundColor3=hiCol}):Play()
        task.delay(0.5,function()
            TweenS:Create(btnF,TweenInfo.new(0.22),{BackgroundColor3=Color3.fromRGB(11,17,30)}):Play()
        end)
        if GPS.enabled then buildTunnel() end
        toast(apName.." RWY "..rwy.name,isArr and "🛬" or "✈",isArr and C.cyan or C.green,
            isArr and "Arrival selected" or "Departure selected")
    end)
    return btnF
end

local function buildAirportList(scroll, isArr)
    local selF=F(scroll,1,0,0,30,0,0,0,0,Color3.fromRGB(7,13,22),0,12)
    Rnd(selF,5); Str(selF,C.border,1)
    local selLabel=L(selF,"Not selected",10,C.amber,Enum.Font.Code,Enum.TextXAlignment.Left,
        1,1,-8,0,0,0,5,0,13)
    local typeOrder={"International","Regional","STOL","Military"}
    local grouped={}
    for _,ap in ipairs(Airports) do
        local t=ap.type or "Regional"
        if not grouped[t] then grouped[t]={} end
        table.insert(grouped[t],ap)
    end
    for _,typeName in ipairs(typeOrder) do
        local list=grouped[typeName]
        if list then
            local th=F(scroll,1,0,0,18,0,0,0,0,Color3.fromRGB(5,9,20),0,12); Rnd(th,3)
            L(th,"── "..typeName.." ──",8,typeColor(typeName),Enum.Font.GothamBold)
            for _,ap in ipairs(list) do
                local apH=F(scroll,1,0,0,22,0,0,0,0,Color3.fromRGB(9,20,38),0,12); Rnd(apH,4)
                local icaoTxt=ap.icao and (" ["..ap.icao.."]") or ""
                L(apH,"📍 "..ap.name..icaoTxt,9,C.white,Enum.Font.GothamBold,
                    Enum.TextXAlignment.Left,1,1,-8,0,0,0,4,0,13)
                for _,rwy in ipairs(ap.runways) do
                    runwayBtn(scroll,ap.name,rwy,isArr,selLabel)
                end
            end
        end
    end
    return selLabel
end

-- Departure Tab
do local sc=makeScroll(tabContents[1]); sectionHdr(sc,"DEPARTURE RUNWAY",C.green); buildAirportList(sc,false) end
-- Arrival Tab
do local sc=makeScroll(tabContents[2]); sectionHdr(sc,"ARRIVAL RUNWAY",C.cyan); buildAirportList(sc,true) end

-- Settings Tab
do
    local scroll=makeScroll(tabContents[3])
    sectionHdr(scroll,"AUTOPILOT SETTINGS")
    local function makeSlider(parent,label,min,max,default,suffix,callback)
        local grp=F(parent,1,0,0,60,0,0,0,0,Color3.fromRGB(9,15,26),0,12)
        Rnd(grp,6); Str(grp,C.border,1)
        L(grp,label,9,C.dimL,Enum.Font.GothamBold,Enum.TextXAlignment.Left,1,0,-8,14,0,0,4,5,13)
        local valLbl=L(grp,tostring(default)..suffix,11,C.cyan,Enum.Font.Code,
            Enum.TextXAlignment.Right,0,0,68,14,1,0,-72,5,13)
        local track=F(grp,1,0,-16,6,0,0,8,38,Color3.fromRGB(18,28,48),0,13); Rnd(track,3)
        local fill=F(track,0,1,0,0,0,0,0,0,C.cyanD,0,14); Rnd(fill,3)
        local thumb=F(track,0,0,12,12,0,0.5,-6,-6,C.cyan,0,15); Rnd(thumb,6)
        local function setVal(v)
            v=math.clamp(math.floor(v),min,max)
            local pct=(v-min)/(max-min)
            fill.Size=UDim2.new(pct,0,1,0)
            thumb.Position=UDim2.new(pct,-6,0.5,-6)
            valLbl.Text=tostring(v)..suffix
            if callback then callback(v) end
        end
        setVal(default)
        local dragging=false
        thumb.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true end end)
        UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
        UIS.InputChanged:Connect(function(i)
            if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
                local rx=track.AbsolutePosition.X; local rw=track.AbsoluteSize.X
                setVal(min+math.clamp((i.Position.X-rx)/rw,0,1)*(max-min))
            end
        end)
        track.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 then
                local rx=track.AbsolutePosition.X; local rw=track.AbsoluteSize.X
                setVal(min+math.clamp((i.Position.X-rx)/rw,0,1)*(max-min))
            end
        end)
    end
    makeSlider(scroll,"Cruise Speed",   100,600, 350," kts",function(v) AP.CRUISE_SPD=v end)
    makeSlider(scroll,"Takeoff Speed",  80, 400, 280," kts",function(v) AP.TAKEOFF_SPD=v end)
    makeSlider(scroll,"Landing Speed",  60, 200, 110," kts",function(v) AP.LANDING_SPD=v end)
    makeSlider(scroll,"Cruise Alt",     500,8000,2000," st", function(v) AP.CRUISE_ALT=v; if GPS.enabled then buildTunnel() end end)
    makeSlider(scroll,"Climb Angle",    5,  30,  15,  "°",   function(v) AP.CLIMB_PITCH=v end)
    makeSlider(scroll,"Glide Slope",    2,  6,   3,   "°",   function(v)
        GLIDE_DEG=v; GLIDE_TAN=math.tan(math.rad(v)); if GPS.enabled then buildTunnel() end end)
    makeSlider(scroll,"Flare Height",   20, 120, 55,  " st", function(v) FLARE_ALT=v end)
    makeSlider(scroll,"Pattern Alt",    200,1500,600, " st", function(v) AP.PATTERN_ALT=v; if GPS.enabled then buildTunnel() end end)
    -- Traffic Pattern toggle
    local togF=F(scroll,1,0,0,36,0,0,0,0,Color3.fromRGB(9,15,26),0,12)
    Rnd(togF,6); Str(togF,C.border,1)
    L(togF,"Traffic Pattern",10,C.white,Enum.Font.GothamBold,Enum.TextXAlignment.Left,0.6,1,0,0,0,0,6,0,13)
    local togBtn=Btn(togF,"OFF",10,C.red,Color3.fromRGB(28,7,7),0,1,-8,-8,1,0,-82+4,4,13)
    Rnd(togBtn,6); Str(togBtn,C.red,1)
    togBtn.MouseButton1Click:Connect(function()
        AP.USE_PATTERN=not AP.USE_PATTERN
        if AP.USE_PATTERN then
            togBtn.Text="ON"; togBtn.TextColor3=C.green
            togBtn.BackgroundColor3=Color3.fromRGB(0,22,10); Str(togBtn,C.green,1)
        else
            togBtn.Text="OFF"; togBtn.TextColor3=C.red
            togBtn.BackgroundColor3=Color3.fromRGB(28,7,7); Str(togBtn,C.red,1)
        end
        if GPS.enabled then buildTunnel() end
    end)
end

-- GPS Tab
do
    local scroll=makeScroll(tabContents[4])
    sectionHdr(scroll,"✈ FLIGHT GUIDE GPS",C.green)
    local descF=F(scroll,1,0,0,74,0,0,0,0,Color3.fromRGB(7,13,24),0,12)
    Rnd(descF,5); Str(descF,C.border,1)
    L(descF,"3D tunnel gates guide you through\ntakeoff, cruise, approach & landing.\nSelect DEP+ARR first, then enable.",9,
        C.dim,Enum.Font.Code,Enum.TextXAlignment.Left,1,1,-8,0,0,0,4,0,13)
    local function legendRow(parent,col,label)
        local rf=F(parent,1,0,0,22,0,0,0,0,Color3.fromRGB(7,11,20),0,12); Rnd(rf,3)
        local dot=F(rf,0,0,12,12,0,0.5,7,-6,col,0,13); Rnd(dot,6)
        L(rf,label,9,C.white,Enum.Font.Code,Enum.TextXAlignment.Left,1,1,-28,0,0,0,25,0,13)
    end
    legendRow(scroll,GATE_COLORS.TAKEOFF, "TAKEOFF / CLIMB")
    legendRow(scroll,GATE_COLORS.CRUISE,  "CRUISE")
    legendRow(scroll,GATE_COLORS.DESCENT, "DESCENT / PATTERN")
    legendRow(scroll,GATE_COLORS.APPROACH,"APPROACH / FINAL")
    legendRow(scroll,GATE_COLORS.LANDING, "LANDING ROLLOUT")
    -- Gate spacing slider
    local spacingF=F(scroll,1,0,0,52,0,0,0,0,Color3.fromRGB(9,15,26),0,12)
    Rnd(spacingF,5); Str(spacingF,C.border,1)
    L(spacingF,"Gate Spacing",9,C.dim,Enum.Font.GothamBold,Enum.TextXAlignment.Left,1,0,-8,14,0,0,4,4,13)
    local spacingLbl=L(spacingF,"600 st",10,C.cyan,Enum.Font.Code,Enum.TextXAlignment.Right,0,0,60,14,1,0,-64,4,13)
    local sTrack=F(spacingF,1,0,-16,6,0,0,8,32,Color3.fromRGB(18,28,48),0,13); Rnd(sTrack,3)
    local sFill=F(sTrack,0,1,0,0,0,0,0,0,C.cyanD,0,14); Rnd(sFill,3)
    local sThumb=F(sTrack,0,0,12,12,0,0.5,-6,-6,C.cyan,0,15); Rnd(sThumb,6)
    local spacingDrag=false
    local function setSpacing(v)
        v=math.clamp(math.floor(v/50)*50,200,2000)
        TUNNEL_SPACING=v
        local pct=(v-200)/(2000-200)
        sFill.Size=UDim2.new(pct,0,1,0); sThumb.Position=UDim2.new(pct,-6,0.5,-6)
        spacingLbl.Text=tostring(v).." st"
        if GPS.enabled then buildTunnel() end
    end
    setSpacing(600)
    sThumb.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then spacingDrag=true end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then spacingDrag=false end end)
    UIS.InputChanged:Connect(function(i)
        if spacingDrag and i.UserInputType==Enum.UserInputType.MouseMovement then
            local rx=sTrack.AbsolutePosition.X; local rw=sTrack.AbsoluteSize.X
            setSpacing(200+math.clamp((i.Position.X-rx)/rw,0,1)*1800)
        end
    end)
    sTrack.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            local rx=sTrack.AbsolutePosition.X; local rw=sTrack.AbsoluteSize.X
            setSpacing(200+math.clamp((i.Position.X-rx)/rw,0,1)*1800)
        end
    end)
    -- GPS Toggle
    local gpsTogF=F(scroll,1,0,0,40,0,0,0,0,Color3.fromRGB(9,17,9),0,12)
    Rnd(gpsTogF,7); Str(gpsTogF,C.greenD,1.5)
    L(gpsTogF,"Flight Guide GPS",11,C.white,Enum.Font.GothamBold,Enum.TextXAlignment.Left,0.62,1,0,0,0,0,9,0,13)
    local gpsTog=Btn(gpsTogF,"OFF",11,C.red,Color3.fromRGB(28,7,7),0,1,-8,-10,1,0,-78,5,14)
    Rnd(gpsTog,7); Str(gpsTog,C.red,1.5)
    gpsTog.MouseButton1Click:Connect(function()
        GPS.enabled=not GPS.enabled
        if GPS.enabled then
            gpsTog.Text="ON ✈"; gpsTog.TextColor3=C.green
            gpsTog.BackgroundColor3=Color3.fromRGB(0,26,11); Str(gpsTog,C.green,1.5)
            buildTunnel(); ndGPSLbl.TextColor3=C.green; ndGPSLbl.Text="GPS ON"
            toast("Flight Guide GPS enabled","🛰",C.green,"Tunnel gates built")
        else
            gpsTog.Text="OFF"; gpsTog.TextColor3=C.red
            gpsTog.BackgroundColor3=Color3.fromRGB(28,7,7); Str(gpsTog,C.red,1.5)
            clearTunnel(); ndGPSLbl.TextColor3=C.dim; ndGPSLbl.Text="GPS OFF"
        end
    end)
    local rebuildBtn=Btn(scroll,"🔄  REBUILD TUNNEL",10,C.cyan,Color3.fromRGB(0,15,28),1,0,-8,30,0,0,4,0,13)
    Rnd(rebuildBtn,6); Str(rebuildBtn,C.cyanD,1); addHover(rebuildBtn,Color3.fromRGB(0,15,28),Color3.fromRGB(0,25,45))
    rebuildBtn.MouseButton1Click:Connect(function()
        if GPS.enabled then buildTunnel(); rebuildBtn.Text="✅ Rebuilt!"
        else rebuildBtn.Text="❌ Enable GPS first" end
        task.delay(2,function() rebuildBtn.Text="🔄  REBUILD TUNNEL" end)
    end)
    local clearBtn=Btn(scroll,"🗑  CLEAR TUNNEL",10,C.red,Color3.fromRGB(26,5,5),1,0,-8,30,0,0,4,0,13)
    Rnd(clearBtn,6); Str(clearBtn,C.redD,1)
    clearBtn.MouseButton1Click:Connect(function()
        clearTunnel(); GPS.enabled=false; gpsTog.Text="OFF"
        gpsTog.TextColor3=C.red; gpsTog.BackgroundColor3=Color3.fromRGB(28,7,7)
        ndGPSLbl.TextColor3=C.dim; ndGPSLbl.Text="GPS OFF"
    end)
    local gateCountF=F(scroll,1,0,0,22,0,0,0,0,Color3.fromRGB(7,9,19),0,12); Rnd(gateCountF,3)
    local gateCountLbl=L(gateCountF,"Gates: 0",9,C.dim,Enum.Font.Code,Enum.TextXAlignment.Left,1,1,-8,0,0,0,4,0,13)
    task.spawn(function()
        while task.wait(1) do pcall(function()
            gateCountLbl.Text=string.format("Gates: %d  |  GPS: %s",#GPS.parts,GPS.enabled and "ON" or "OFF")
            gateCountLbl.TextColor3=GPS.enabled and C.green or C.dim
        end) end
    end)
end

-- Log Tab
do
    local scroll=makeScroll(tabContents[5])
    sectionHdr(scroll,"FLIGHT LOG")
    local logEntries={}
    for i=1,22 do
        local ef=F(scroll,1,0,0,19,0,0,0,0,Color3.fromRGB(7,11,20),0,12); Rnd(ef,2)
        local el=L(ef,"",8,C.dim,Enum.Font.Code,Enum.TextXAlignment.Left,1,1,-8,0,0,0,3,0,13)
        table.insert(logEntries,el)
    end
    task.spawn(function()
        while task.wait(0.5) do pcall(function()
            for i,lbl in ipairs(logEntries) do
                local entry=flightLog[i]
                lbl.Text=entry or ""
                lbl.TextColor3=entry and (entry:find("Touchdown") and C.green or C.white) or C.dim
            end
        end) end
    end)
end

-- ════════════════════════════════════════════════════════════════════
-- DOCK — completely redesigned, draggable, animated LED
-- ════════════════════════════════════════════════════════════════════
local dockW=148
local dock=F(sg,0,0,dockW,202,1,0.5,-dockW-10,-101,C.bg,0,15)
Rnd(dock,10); Str(dock,C.borderHi,1.5)

-- Header
local dockHdr=F(dock,1,0,0,32,0,0,0,0,Color3.fromRGB(8,14,28),0,16); Rnd(dockHdr,10)
local dockHdrAccent=F(dockHdr,1,0,0,3,0,1,0,-3,C.cyan,0,17)
L(dockHdr,"PTFS  ✈  v18",10,C.cyan,Enum.Font.GothamBold)
makeDraggable(dockHdr,dock)

-- AP Status LED (animated pulse when active)
local ledDot=F(dock,0,0,10,10,0,0,8,40,C.red,0,17); Rnd(ledDot,5)
local ledLbl=L(dock,"AP OFF",9,C.red,Enum.Font.GothamBold,Enum.TextXAlignment.Left,
    0,0,dockW-28,0,0,0,22,40,17)
task.spawn(function()
    while true do
        if AP.active then
            TweenS:Create(ledDot,TweenInfo.new(0.7),{BackgroundTransparency=0.4}):Play()
            task.wait(0.7)
            TweenS:Create(ledDot,TweenInfo.new(0.7),{BackgroundTransparency=0.0}):Play()
            task.wait(0.7)
        else
            task.wait(0.5)
        end
    end
end)

-- Divider
F(dock,1,0,-12,1,0,0,6,56,C.border,0,16)

local function dockBtn(y, icon, lbl, bg, brd, callback)
    local bF=F(dock,1,0,-10,38,0,0,5,y,Color3.fromRGB(10,16,28),0,16); Rnd(bF,7); Str(bF,brd,1)
    local iconL=L(bF,icon,16,C.white,Enum.Font.GothamBold,nil,0,1,34,0,0,0,4,0,17)
    local lblL =L(bF,lbl, 9, C.dimL, Enum.Font.Gotham, Enum.TextXAlignment.Left,1,0,-44,0,0,0,40,0,17)
    local cb_but=Btn(bF,"",10,C.white,Color3.fromRGB(0,0,0),1,1,0,0,0,0,0,0,18)
    cb_but.BackgroundTransparency=1
    addHover(bF,Color3.fromRGB(10,16,28),Color3.fromRGB(16,26,46))
    cb_but.MouseButton1Click:Connect(callback)
    return bF,iconL,lblL
end

local _,_,menuLblDock = dockBtn(62,"☰","MENU",C.panel,C.border,function()
    if menuPanel.Visible then panelClose(menuPanel)
    else
        local tgt=UDim2.new(1,-dockW-10-MENU_W-10,0.5,-280)
        panelOpen(menuPanel,tgt)
    end
end)

local apDockF,apDockIcon,apDockLbl = dockBtn(106,"✈","AUTOPILOT",C.panel,C.greenD,function()
    if apMenu.Visible then panelClose(apMenu)
    else
        local tgt=UDim2.new(1,-dockW-10-AP_W-10,0.5,-AP_H/2)
        panelOpen(apMenu,tgt)
    end
end)
apDockIcon.TextColor3=C.green

local _,cockpitIcon,_ = dockBtn(150,"🖥","COCKPIT",C.panel,C.border,function()
    if hud.Visible then panelClose(hud)
    else
        local tgt=UDim2.new(0.5,-(HW/2),1,-HH-10)
        panelOpen(hud,tgt)
    end
end)

-- GPS quick-toggle dock
local gpsDockF=F(dock,1,0,-10,26,0,0,5,182,Color3.fromRGB(9,15,24),0,16)
Rnd(gpsDockF,6); Str(gpsDockF,C.border,1)
local gpsDockIcon=L(gpsDockF,"🛰",12,C.dim,Enum.Font.GothamBold,nil,0,1,28,0,0,0,2,0,17)
local gpsDockLbl=L(gpsDockF,"GPS OFF",8,C.dim,Enum.Font.GothamBold,
    Enum.TextXAlignment.Left,1,0,-34,0,0,0,32,0,17)
local gpsDockCB=Btn(gpsDockF,"",10,C.white,Color3.fromRGB(0,0,0),1,1,0,0,0,0,0,0,18)
gpsDockCB.BackgroundTransparency=1
addHover(gpsDockF,Color3.fromRGB(9,15,24),Color3.fromRGB(0,22,14))
gpsDockCB.MouseButton1Click:Connect(function()
    GPS.enabled=not GPS.enabled
    if GPS.enabled then
        buildTunnel(); ndGPSLbl.Text="GPS ON"; ndGPSLbl.TextColor3=C.green
        toast("GPS Tunnel enabled","🛰",C.green)
    else
        clearTunnel(); ndGPSLbl.Text="GPS OFF"; ndGPSLbl.TextColor3=C.dim
    end
end)

-- Dock status updater
task.spawn(function()
    while task.wait(0.35) do pcall(function()
        local isActive=AP.active
        local phaseStr=AP.phase
        -- LED
        ledDot.BackgroundColor3=isActive and C.green or C.red
        ledLbl.Text=isActive and ("AP "..phaseStr) or "AP OFF"
        ledLbl.TextColor3=isActive and C.green or C.red
        -- AP dock button
        apDockIcon.TextColor3=isActive and C.greenHL or C.green
        apDockLbl.Text=isActive and phaseStr or "AUTOPILOT"
        apDockF.BackgroundColor3=isActive and Color3.fromRGB(0,22,10) or Color3.fromRGB(10,16,28)
        -- GPS dock
        gpsDockIcon.TextColor3=GPS.enabled and C.green or C.dim
        gpsDockLbl.Text=GPS.enabled and "GPS ON" or "GPS OFF"
        gpsDockLbl.TextColor3=GPS.enabled and C.green or C.dim
        gpsDockF.BackgroundColor3=GPS.enabled and Color3.fromRGB(0,20,9) or Color3.fromRGB(9,15,24)
        -- HUD title dot
        hudAPDot.BackgroundColor3=isActive and C.green or C.red
        hudAPLbl.Text=isActive and ("AP "..phaseStr) or "AP OFF"
        hudAPLbl.TextColor3=isActive and C.green or C.red
    end) end
end)

-- ════════════════════════════════════════════════════════════════════
-- AP CONTROL POPUP — redesigned with phase progress
-- ════════════════════════════════════════════════════════════════════
local AP_W,AP_H=290,260
local apMenu=F(sg,0,0,AP_W,AP_H,0,0.5,0,-AP_H/2,C.bg,0,20)
apMenu.Visible=false; Rnd(apMenu,12); Str(apMenu,C.borderHi,1.5)

local apMenuTitle=F(apMenu,1,0,0,32,0,0,0,0,Color3.fromRGB(8,18,38),0,21); Rnd(apMenuTitle,12)
local apMenuTitleGrad=F(apMenuTitle,0.5,1,0,0,0.5,0,0,0,Color3.fromRGB(14,28,56),0,21)
L(apMenuTitle,"AUTOPILOT CONTROL",11,C.cyan,Enum.Font.GothamBold)
makeDraggable(apMenuTitle,apMenu)
local apMenuClose=Btn(apMenu,"✕",11,C.white,C.redD,0,0,24,24,1,0,-28,4,22)
Rnd(apMenuClose,5); addHover(apMenuClose,C.redD,Color3.fromRGB(145,22,22))
apMenuClose.MouseButton1Click:Connect(function() panelClose(apMenu) end)

-- AP Status banner
local apStatF=F(apMenu,1,0,-12,32,0,0,6,36,Color3.fromRGB(25,8,8),0,21)
Rnd(apStatF,6); Str(apStatF,C.redD,1)
local apStatLbl=L(apStatF,"●  AUTOPILOT  OFF",13,C.red,Enum.Font.GothamBold,nil,1,1,0,0,0,0,0,0,22)

-- Route display
local routeF=F(apMenu,1,0,-12,26,0,0,6,72,Color3.fromRGB(7,11,22),0,21); Rnd(routeF,5)
local routeLbl=L(routeF,"DEP: --   →   ARR: --",9,C.dim,Enum.Font.Code,
    Enum.TextXAlignment.Left,1,1,-8,0,0,0,5,0,22)

-- Phase progress bar
local progF=F(apMenu,1,0,-12,22,0,0,6,102,Color3.fromRGB(7,10,20),0,21); Rnd(progF,5); Str(progF,C.border,1)
local progFill=F(progF,0,1,0,0,0,0,0,0,C.cyanD,0,22); Rnd(progFill,5)
local progLbl=L(progF,"IDLE",9,C.white,Enum.Font.GothamBold,nil,1,1,0,0,0,0,0,0,23)

-- Phase dots row
local phaseNames={"TAKEOFF","CRUISE","APPROACH","ROLLOUT"}
local phaseDots={}
local phaseDotRow=F(apMenu,1,0,-12,18,0,0,6,128,Color3.fromRGB(0,0,0),1,21)
local pdW=(AP_W-12)/#phaseNames
for i,ph in ipairs(phaseNames) do
    local pd=F(phaseDotRow,0,0,pdW-4,14,0,0.5,(i-1)*pdW,0,-7,Color3.fromRGB(12,18,32),0,22)
    Rnd(pd,3)
    L(pd,ph,7,C.dim,Enum.Font.GothamBold,nil,1,1,0,0,0,0,0,0,23)
    table.insert(phaseDots,pd)
end

-- WP and GPS info
local wpF=F(apMenu,1,0,-12,20,0,0,6,150,Color3.fromRGB(7,9,19),0,21); Rnd(wpF,4)
local wpLbl=L(wpF,"PHASE: IDLE   WP: -/-",9,C.amber,Enum.Font.Code,
    Enum.TextXAlignment.Left,1,1,-8,0,0,0,4,0,22)
local wpNameF=F(apMenu,1,0,-12,18,0,0,6,174,Color3.fromRGB(7,9,19),0,21); Rnd(wpNameF,3)
local wpNameLbl=L(wpNameF,"NEXT: ---",9,C.purple,Enum.Font.Code,
    Enum.TextXAlignment.Left,1,1,-8,0,0,0,4,0,22)

-- Start/Stop buttons
local startBtn=Btn(apMenu,"▶  START AUTOPILOT",12,C.green,Color3.fromRGB(0,28,14),
    1,0,-12,32,0,0,6,196,22)
Rnd(startBtn,7); Str(startBtn,C.green,1)
addHover(startBtn,Color3.fromRGB(0,28,14),Color3.fromRGB(0,42,22))
startBtn.MouseButton1Click:Connect(function()
    local ok,msg=startAP()
    startBtn.Text=ok and ("✅ "..msg) or ("❌ "..msg)
    if ok then toast("Autopilot engaged!","✈",C.green,"Have a smooth flight ✈") end
    task.delay(2.5,function() startBtn.Text="▶  START AUTOPILOT" end)
end)
local stopBtn=Btn(apMenu,"■  STOP",12,C.red,Color3.fromRGB(28,7,7),
    1,0,-12,28,0,0,6,232,22)
Rnd(stopBtn,7); Str(stopBtn,C.red,1)
addHover(stopBtn,Color3.fromRGB(28,7,7),Color3.fromRGB(48,12,12))
stopBtn.MouseButton1Click:Connect(function()
    stopAP("Manual"); toast("Autopilot disengaged","⏹","","Manual stop")
end)

-- AP popup updater
local phaseIdxMap={TAKEOFF=1,CRUISE=2,APPROACH=3,ROLLOUT=4}
task.spawn(function()
    while task.wait(0.25) do pcall(function()
        local isActive=AP.active
        local ph=AP.phase
        if isActive then
            apStatLbl.Text="●  AP  ENGAGED  —  "..ph
            apStatLbl.TextColor3=C.green; apStatF.BackgroundColor3=Color3.fromRGB(4,28,10)
            Str(apStatF,C.greenD,1)
        else
            apStatLbl.Text="●  AUTOPILOT  OFF"
            apStatLbl.TextColor3=C.red; apStatF.BackgroundColor3=Color3.fromRGB(25,7,7)
            Str(apStatF,C.redD,1)
        end
        local dep=AP.depRunway and AP.depRunway.name or "--"
        local arr=AP.arrRunway and AP.arrRunway.name or "--"
        routeLbl.Text="DEP: "..dep.."   →   ARR: "..arr
        -- Phase progress bar
        local pidx=phaseIdxMap[ph] or 0
        local pct=isActive and (pidx/#phaseNames) or 0
        TweenS:Create(progFill,TweenInfo.new(0.3),{Size=UDim2.new(pct,0,1,0)}):Play()
        progLbl.Text=ph
        -- Phase dot highlights
        for i,dot in ipairs(phaseDots) do
            local isCurrentPhase=(phaseNames[i]==ph and isActive)
            local isPastPhase=(i<pidx and isActive)
            dot.BackgroundColor3=isCurrentPhase and C.cyanD or (isPastPhase and Color3.fromRGB(0,50,20) or Color3.fromRGB(12,18,32))
            -- Text color
            local txtLbl=dot:FindFirstChildOfClass("TextLabel")
            if txtLbl then txtLbl.TextColor3=isCurrentPhase and C.cyan or (isPastPhase and C.greenD or C.dim) end
        end
        local wpI=waypoints[wpIndex]
        wpLbl.Text=string.format("PHASE: %s   WP: %s/%s",ph,tostring(wpIndex),tostring(#waypoints))
        wpNameLbl.Text="NEXT: "..(wpI and wpI.label or "---")
    end) end
end)

-- ════════════════════════════════════════════════════════════════════
-- HUD LIVE UPDATE — enhanced with GS deviation
-- ════════════════════════════════════════════════════════════════════
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
        local pitch=0
        if vel.Magnitude>0.5 then
            pitch=math.deg(math.asin(math.clamp(vel.Y/vel.Magnitude,-1,1)))
        end
        local vs=math.floor(vel.Y*60)

        -- Speed color
        local speedColor=gs<80 and C.red or (gs<150 and C.amber or C.green)
        spdVal.Text=tostring(gs); spdVal.TextColor3=speedColor
        -- Alt color
        local altColor=alt<50 and C.amber or (alt<200 and C.white or C.cyan)
        altVal.Text=tostring(alt); altVal.TextColor3=altColor

        -- AI update
        local aiH=ai.AbsoluteSize.Y
        local pxPitch=math.clamp(pitch*(aiH*0.018),-(aiH*0.45),aiH*0.45)
        local skyRatio=math.clamp(0.5+pxPitch/aiH,0.05,0.95)
        skyTop.Size=UDim2.new(1,0,skyRatio,0)
        skyBot.Size=UDim2.new(1,0,skyRatio,0)
        gndTop.Position=UDim2.new(0,0,skyRatio,0)
        gndTop.Size=UDim2.new(1,0,1-skyRatio,0)
        gndBot.Position=UDim2.new(0,0,1,0)
        gndBot.Size=UDim2.new(1,0,1-skyRatio,0)
        horizLine.Position=UDim2.new(0,0,skyRatio,-1)

        -- FPV
        if vel.Magnitude>2 then
            local fpvPitch=math.deg(math.asin(math.clamp(vel.Y/vel.Magnitude,-1,1)))
            fpvFrame.Position=UDim2.new(0.5,-9,0.5,-fpvPitch*(aiH*0.018)-9)
            fpvFrame.Visible=true
        else fpvFrame.Visible=false end

        -- Heading
        local hdgFrac=hdg/360
        hdgPtr.Position=UDim2.new(hdgFrac,-1,0,0)
        hdgRead.Text=string.format("%03.0f°",hdg)
        ndHdgLbl.Text=string.format("%03.0f°",hdg)

        -- Top strip
        pitchRead.Text=string.format("PTH %+.1f°",pitch)
        vsRead.Text=string.format("V/S %+d fpm",vs)
        apModeL.Text=AP.active and AP.phase or ""

        -- Glide slope deviation indicator (v18 new)
        if AP.active and AP.phase=="APPROACH" and AP.arrRunway then
            local arrThrPos=AP.arrRunway.threshold
            local hPos=hrp.Position
            local dThresh=dist2D(hPos,arrThrPos)
            local heightAbove=hPos.Y-arrThrPos.Y
            local gsTargetAlt=arrThrPos.Y+dThresh*GLIDE_TAN
            local gsErr=hPos.Y-gsTargetAlt   -- above=positive
            local gsDev=math.clamp(gsErr/300,-.9,.9)  -- normalize
            -- Move GS dot: center=on slope, up=below slope, down=above slope
            gsDot.Position=UDim2.new(0,0,0.5-gsDev*0.45,-3)
            gsDot.BackgroundColor3=math.abs(gsDev)>0.5 and C.red or (math.abs(gsDev)>0.2 and C.amber or C.green)
            gsPanel.Visible=true
            local gsAlt=math.floor(gsTargetAlt); local gsSign=gsErr>0 and "+" or ""
            ndGSLbl.Text=string.format("GS %s%d",gsSign,math.floor(gsErr))
            ndGSLbl.TextColor3=math.abs(gsErr)>200 and C.red or C.amber
        else
            gsPanel.Visible=false
            ndGSLbl.Text="GS ---"; ndGSLbl.TextColor3=C.dim
        end

        -- Bottom bar
        barVals.gs.Text=tostring(gs).." kts"
        barVals.vs.Text=(vs>=0 and "+" or "")..tostring(vs).." fpm"
        barVals.phase.Text=AP.phase
        local dist=AP.arrRunway and
            tostring(math.floor(dist2D(hrp.Position,AP.arrRunway.threshold))).." st" or "---"
        barVals.dist.Text=dist
        barVals.wp.Text=AP.active and (tostring(wpIndex).."/"..tostring(#waypoints)) or "-/-"
        barVals.dep.Text=AP.depRunway and AP.depRunway.name or "---"
        barVals.arr.Text=AP.arrRunway and AP.arrRunway.name or "---"
        -- NAV panel
        local dStr=AP.arrRunway and tostring(math.floor(dist2D(hrp.Position,AP.arrRunway.threshold))) or "---"
        ndDestLbl.Text="DEST: "..dStr.." st"
        ndWPLbl.Text="WP: "..(AP.active and (tostring(wpIndex).."/"..tostring(#waypoints)) or "-/-")
        ndPhaseLbl.Text=AP.phase
        ndPhaseLbl.TextColor3=AP.active and C.green or C.red
    end)
end)

-- Flight event toast integration
local lastPhase=""
task.spawn(function()
    while task.wait(0.5) do
        if AP.phase~=lastPhase then
            local ph=AP.phase
            if ph=="CRUISE" and AP.active then
                toast("Cruise altitude reached","✈",C.cyan,"Autopilot cruising")
            elseif ph=="APPROACH" and AP.active then
                toast("ILS Approach initiated","📡",C.amber,"3° glideslope engaged")
            elseif ph=="ROLLOUT" and AP.active then
                toast("Touchdown! 🛬","🛬",C.green,"Applying brakes")
            elseif ph=="IDLE" and lastPhase=="ROLLOUT" then
                toast("Flight complete! ✅","🏁",C.greenHL,"Welcome to your destination")
            end
            lastPhase=ph
        end
    end
end)

-- ════════════════════════════════════════════════════════════════════
-- INIT
-- ════════════════════════════════════════════════════════════════════
local totalRunways=0
for _,a in ipairs(Airports) do totalRunways=totalRunways+#a.runways end
print("✅ PTFS Autopilot v18 loaded! — Fixed landing + Premium UI")
print(string.format("   %d airports | %d runways",#Airports,totalRunways))
print("   Fixes: ILS 3° glideslope • Anti-stall • Flare landing • Proper rollout")
print("   UI: Draggable all panels • Hover FX • Toast alerts • Phase progress • GS indicator")
print("   Dock: Right side — drag header to reposition")
