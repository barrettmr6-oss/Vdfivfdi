-- ╔══════════════════════════════════════════════════════════════════╗
-- ║      PTFS AUTOPILOT v17 — FULL REWRITE + FLIGHT GUIDE GPS      ║
-- ║  Cockpit HUD • AP Menu • Traffic Patterns • Tunnel GPS Guide   ║
-- ║  All Official PTFS Airports with correct ICAO codes            ║
-- ║  Airports: Greater Rockford, Tokyo, Perth, Izolirani,          ║
-- ║            Saint Barthélemy, Larnaca, Paphos, Barra,           ║
-- ║            Henstridge, Lukla, Sauthamptona, Skopelos,          ║
-- ║            Saba, Al Najaf, McConnell AFB, RAF Scampton,        ║
-- ║            Mellor, Training Centre, Air Base Garry,            ║
-- ║            Boltic Airfield, Grindavik, Bird Island             ║
-- ╚══════════════════════════════════════════════════════════════════╝

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local TweenS     = game:GetService("TweenService")
local Player     = Players.LocalPlayer
local PlayerGui  = Player:WaitForChild("PlayerGui")

-- Clean old GUIs
for _, name in ipairs({"PTFSMain","PTFSCockpit","PTFSTunnel"}) do
    if PlayerGui:FindFirstChild(name) then PlayerGui[name]:Destroy() end
end
-- Clean old 3D tunnel parts in workspace
local wsFolder = workspace:FindFirstChild("PTFS_Tunnel")
if wsFolder then wsFolder:Destroy() end

-- ════════════════════════════════════════════════════════════════════
-- AIRPORT & RUNWAY DATABASE  (Official PTFS ICAO codes from ptfs.app)
-- Roblox stud coordinates are approximate — use the Record tab in-game
-- to fine-tune any runway threshold to your exact server.
-- Headings in magnetic degrees.
-- ════════════════════════════════════════════════════════════════════
local Airports = {
    -- ── INTERNATIONAL ───────────────────────────────────────────
    {
        name = "Greater Rockford",
        icao = "IRFD",
        island = "Rockford",
        type = "International",
        runways = {
            { name="07L", threshold=Vector3.new(-3500,3.3,20750), heading=067.0, length=3200 },
            { name="25R", threshold=Vector3.new(-2720,3.3,20400), heading=247.0, length=3200 },
            { name="07C", threshold=Vector3.new(-3490,3.3,20700), heading=067.0, length=3100 },
            { name="25C", threshold=Vector3.new(-2730,3.3,20370), heading=247.0, length=3100 },
            { name="07R", threshold=Vector3.new(-3481,3.3,20650), heading=067.0, length=3000 },
            { name="25L", threshold=Vector3.new(-2727,3.3,20380), heading=247.0, length=3000 },
        }
    },
    {
        name = "Tokyo International",
        icao = "ITKO",
        island = "Orenji",
        type = "International",
        runways = {
            { name="02",  threshold=Vector3.new(-6399,21.5,-32327), heading=020.2, length=4850 },
            { name="20",  threshold=Vector3.new(-6922,21.5,-30891), heading=200.2, length=4850 },
            { name="13",  threshold=Vector3.new(-5800,21.5,-31200), heading=131.0, length=3600 },
            { name="31",  threshold=Vector3.new(-6600,21.5,-30500), heading=311.0, length=3600 },
        }
    },
    {
        name = "Perth International",
        icao = "IPPH",
        island = "Perth",
        type = "International",
        runways = {
            { name="11",  threshold=Vector3.new(6200,25,4800),  heading=111.0, length=3200 },
            { name="29",  threshold=Vector3.new(7600,25,5400),  heading=291.0, length=3200 },
            { name="15",  threshold=Vector3.new(6700,25,4300),  heading=151.0, length=2500 },
            { name="33",  threshold=Vector3.new(6900,25,5700),  heading=331.0, length=2500 },
        }
    },
    {
        name = "Izolirani International",
        icao = "IZOL",
        island = "Izolirani",
        type = "International",
        runways = {
            { name="10",  threshold=Vector3.new(-9200,9,15800),  heading=106.0, length=3200 },
            { name="28",  threshold=Vector3.new(-7800,9,16200),  heading=286.0, length=3200 },
        }
    },
    -- ── REGIONAL ────────────────────────────────────────────────
    {
        name = "Saint Barthélemy",
        icao = "IBTH",
        island = "Saint Barthelemy",
        type = "Regional",
        runways = {
            { name="09",  threshold=Vector3.new(5470,11.5,-4486), heading=091.5, length=600 },
            { name="27",  threshold=Vector3.new(5951,3.1,-4486),  heading=271.5, length=600 },
        }
    },
    {
        name = "Larnaca International",
        icao = "ILAR",
        island = "Cyprus",
        type = "Regional",
        runways = {
            { name="04",  threshold=Vector3.new(11200,18,-8200),  heading=040.0, length=2800 },
            { name="22",  threshold=Vector3.new(11900,18,-7300),  heading=220.0, length=2800 },
        }
    },
    {
        name = "Paphos International",
        icao = "IPAP",
        island = "Cyprus",
        type = "Regional",
        runways = {
            { name="11",  threshold=Vector3.new(10100,28,-10600), heading=110.0, length=2200 },
            { name="29",  threshold=Vector3.new(10900,28,-10200), heading=290.0, length=2200 },
        }
    },
    {
        name = "Sauthamptona Airport",
        icao = "ISAU",
        island = "Sauthamptona",
        type = "Regional",
        runways = {
            { name="02",  threshold=Vector3.new(-1200,8,-2800),  heading=020.0, length=1800 },
            { name="20",  threshold=Vector3.new(-1100,8,-2200),  heading=200.0, length=1800 },
        }
    },
    {
        name = "Saba Airport",
        icao = "IDCS",
        island = "Orenji",
        type = "Regional",
        runways = {
            { name="12",  threshold=Vector3.new(-8200,148,-24600), heading=120.0, length=400 },
            { name="30",  threshold=Vector3.new(-8100,148,-24400), heading=300.0, length=400 },
        }
    },
    {
        name = "Skopelos Airfield",
        icao = "ISKP",
        island = "Skopelos",
        type = "Regional",
        runways = {
            { name="09",  threshold=Vector3.new(14200,12,-3200),  heading=090.0, length=900 },
            { name="27",  threshold=Vector3.new(14600,12,-3200),  heading=270.0, length=900 },
        }
    },
    {
        name = "Grindavik Airport",
        icao = "IGRV",
        island = "Grindavik",
        type = "Regional",
        runways = {
            { name="08",  threshold=Vector3.new(18200,6,-6800),   heading=080.0, length=1400 },
            { name="26",  threshold=Vector3.new(18900,6,-6700),   heading=260.0, length=1400 },
        }
    },
    -- ── STOL / SMALL ────────────────────────────────────────────
    {
        name = "Lukla Airport",
        icao = "ILKL",
        island = "Perth",
        type = "STOL",
        runways = {
            { name="06",  threshold=Vector3.new(7100,950,4200),   heading=062.0, length=400 },
            { name="24",  threshold=Vector3.new(7300,960,4350),   heading=242.0, length=400 },
        }
    },
    {
        name = "Barra Airport",
        icao = "IBAR",
        island = "Cyprus",
        type = "STOL",
        runways = {
            { name="12",  threshold=Vector3.new(3100,4,-6200),    heading=120.0, length=700 },
            { name="30",  threshold=Vector3.new(3350,4,-6000),    heading=300.0, length=700 },
            { name="07",  threshold=Vector3.new(3000,4,-6000),    heading=070.0, length=600 },
            { name="25",  threshold=Vector3.new(3300,4,-5900),    heading=250.0, length=600 },
        }
    },
    {
        name = "Henstridge Airfield",
        icao = "IHEN",
        island = "Cyprus",
        type = "STOL",
        runways = {
            { name="08",  threshold=Vector3.new(9800,18,-9200),   heading=080.0, length=600 },
            { name="26",  threshold=Vector3.new(10100,18,-9150),  heading=260.0, length=600 },
        }
    },
    {
        name = "Mellor International",
        icao = "IMLR",
        island = "Rockford",
        type = "STOL",
        runways = {
            { name="08",  threshold=Vector3.new(-2800,420,17800), heading=080.0, length=500 },
            { name="26",  threshold=Vector3.new(-2600,420,17900), heading=260.0, length=500 },
        }
    },
    {
        name = "Boltic Airfield",
        icao = "IBLT",
        island = "Rockford",
        type = "STOL",
        runways = {
            { name="14",  threshold=Vector3.new(-6600,12,-19200), heading=140.0, length=600 },
            { name="32",  threshold=Vector3.new(-6500,12,-18900), heading=320.0, length=600 },
        }
    },
    {
        name = "Bird Island Airfield",
        icao = "IBRD",
        island = "Orenji",
        type = "STOL",
        runways = {
            { name="09",  threshold=Vector3.new(-10200,6,-27400), heading=090.0, length=350 },
            { name="27",  threshold=Vector3.new(-10000,6,-27400), heading=270.0, length=350 },
        }
    },
    -- ── MILITARY ────────────────────────────────────────────────
    {
        name = "McConnell AFB",
        icao = "IIAB",
        island = "Cyprus",
        type = "Military",
        runways = {
            { name="01L", threshold=Vector3.new(-3200,8,15200),   heading=010.0, length=2800 },
            { name="19R", threshold=Vector3.new(-3100,8,16400),   heading=190.0, length=2800 },
            { name="01R", threshold=Vector3.new(-3100,8,15200),   heading=010.0, length=2800 },
            { name="19L", threshold=Vector3.new(-3000,8,16400),   heading=190.0, length=2800 },
        }
    },
    {
        name = "RAF Scampton",
        icao = "ISCM",
        island = "Izolirani",
        type = "Military",
        runways = {
            { name="13",  threshold=Vector3.new(-8800,9,17800),   heading=130.0, length=2400 },
            { name="31",  threshold=Vector3.new(-8200,9,18600),   heading=310.0, length=2400 },
        }
    },
    {
        name = "Al Najaf Airfield",
        icao = "IJAF",
        island = "Izolirani",
        type = "Military",
        runways = {
            { name="07",  threshold=Vector3.new(-9800,9,16800),   heading=070.0, length=900 },
            { name="25",  threshold=Vector3.new(-9500,9,16900),   heading=250.0, length=900 },
        }
    },
    {
        name = "Air Base Garry",
        icao = "IGAR",
        island = "Rockford",
        type = "Military",
        runways = {
            { name="09",  threshold=Vector3.new(-1800,4,19600),   heading=090.0, length=1000 },
            { name="27",  threshold=Vector3.new(-1200,4,19600),   heading=270.0, length=1000 },
        }
    },
    {
        name = "Training Centre",
        icao = "ITRC",
        island = "Rockford",
        type = "Military",
        runways = {
            { name="09",  threshold=Vector3.new(-200,4,200),      heading=090.0, length=800 },
            { name="27",  threshold=Vector3.new(200,4,200),       heading=270.0, length=800 },
        }
    },
}

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
-- FLIGHT GUIDE GPS — TUNNEL SYSTEM
-- Spawns semi-transparent 3D box frames ("tunnel gates") that visually
-- guide the pilot through takeoff climb, cruise, approach and landing.
-- One gate every TUNNEL_SPACING studs along each flight segment.
-- ════════════════════════════════════════════════════════════════════
local GPS = {
    enabled    = false,
    tunnelFolder = nil,
    parts        = {},
}

local TUNNEL_SPACING  = 600   -- studs between gates
local TUNNEL_W        = 280   -- gate width  (studs)
local TUNNEL_H        = 200   -- gate height (studs)
local TUNNEL_THICK    = 4     -- frame bar thickness
local TUNNEL_TRANSP   = 0.72  -- part transparency

-- Gate colours per flight phase
local GATE_COLORS = {
    TAKEOFF  = Color3.fromRGB(0, 230, 120),
    CLIMB    = Color3.fromRGB(0, 200, 255),
    CRUISE   = Color3.fromRGB(60, 140, 255),
    DESCENT  = Color3.fromRGB(255, 190, 0),
    APPROACH = Color3.fromRGB(255, 100, 40),
    LANDING  = Color3.fromRGB(255, 50, 50),
}

local function makeGatePart(size, cframe, color)
    local p = Instance.new("Part")
    p.Size   = size
    p.CFrame = cframe
    p.Anchored = true
    p.CanCollide = false
    p.Material = Enum.Material.Neon
    p.Color = color
    p.Transparency = TUNNEL_TRANSP
    p.CastShadow = false
    p.Parent = GPS.tunnelFolder
    table.insert(GPS.parts, p)
    return p
end

-- Build a single rectangular gate frame at a given CFrame (facing = forward dir)
local function buildGate(cf, color)
    local right = cf.RightVector
    local up    = cf.UpVector
    local pos   = cf.Position

    local hw = TUNNEL_W / 2
    local hh = TUNNEL_H / 2
    local th = TUNNEL_THICK

    -- top bar
    makeGatePart(
        Vector3.new(TUNNEL_W, th, th),
        CFrame.new(pos + up * hh),
        color)
    -- bottom bar
    makeGatePart(
        Vector3.new(TUNNEL_W, th, th),
        CFrame.new(pos - up * hh),
        color)
    -- left bar
    makeGatePart(
        Vector3.new(th, TUNNEL_H, th),
        CFrame.new(pos - right * hw),
        color)
    -- right bar
    makeGatePart(
        Vector3.new(th, TUNNEL_H, th),
        CFrame.new(pos + right * hw),
        color)
    -- centre crosshair dot
    local dot = makeGatePart(
        Vector3.new(th*2, th*2, th*2),
        CFrame.new(pos),
        color)
    dot.Transparency = TUNNEL_TRANSP - 0.15
end

-- Interpolate CFrames along a segment and spawn gates
local function spawnGatesAlongSegment(startPos, endPos, startAlt, endAlt, color)
    local delta = endPos - startPos
    local dist  = delta.Magnitude
    if dist < 1 then return end
    local steps = math.max(1, math.floor(dist / TUNNEL_SPACING))
    for i = 0, steps do
        local t = i / steps
        local p = startPos:Lerp(endPos, t)
        local alt = startAlt + (endAlt - startAlt) * t
        p = Vector3.new(p.X, alt, p.Z)
        -- forward vector along segment
        local fwd = (endPos - startPos)
        fwd = Vector3.new(fwd.X, (endAlt - startAlt) / (steps > 0 and steps or 1), fwd.Z).Unit
        local cf = CFrame.new(p, p + fwd)
        buildGate(cf, color)
    end
end

local function clearTunnel()
    if GPS.tunnelFolder and GPS.tunnelFolder.Parent then
        GPS.tunnelFolder:Destroy()
    end
    GPS.tunnelFolder = nil
    GPS.parts = {}
end

local function headingDir(deg)
    local r = math.rad(deg)
    return Vector3.new(math.sin(r), 0, math.cos(r))
end

local function buildTunnel()
    clearTunnel()
    if not GPS.enabled then return end
    if not AP.depRunway or not AP.arrRunway then return end

    GPS.tunnelFolder = Instance.new("Folder")
    GPS.tunnelFolder.Name = "PTFS_Tunnel"
    GPS.tunnelFolder.Parent = workspace

    local dep    = AP.depRunway
    local arr    = AP.arrRunway
    local alt    = AP.CRUISE_ALT
    local depDir = headingDir(dep.heading)
    local arrDir = headingDir(arr.heading)

    -- ── TAKEOFF climb segment (threshold → 3000 studs out at cruise alt)
    local climbOutH = dep.threshold + depDir * 3000
    spawnGatesAlongSegment(
        dep.threshold,
        climbOutH,
        dep.threshold.Y + 5,
        alt,
        GATE_COLORS.TAKEOFF)

    -- ── CRUISE segment (climbout → mid-route → descent start)
    local midX = (dep.threshold.X + arr.threshold.X) / 2
    local midZ = (dep.threshold.Z + arr.threshold.Z) / 2
    local mid  = Vector3.new(midX, alt, midZ)
    spawnGatesAlongSegment(climbOutH, mid,   alt, alt, GATE_COLORS.CRUISE)

    -- ── DESCENT segment (mid → final fix)
    local finalFix = arr.threshold - arrDir * 8000
    spawnGatesAlongSegment(mid,      finalFix, alt, alt + 200, GATE_COLORS.DESCENT)

    -- ── APPROACH funnel (final fix → runway threshold)
    -- 3° ILS-style glide: altitude drops from patternAlt down to threshold
    local appStartAlt = arr.threshold.Y + AP.PATTERN_ALT
    spawnGatesAlongSegment(
        finalFix,
        arr.threshold,
        appStartAlt,
        arr.threshold.Y + 8,
        GATE_COLORS.APPROACH)

    -- ── LANDING rollout strip (threshold → 1500 studs down the runway)
    local rolloutEnd = arr.threshold + arrDir * 1500
    spawnGatesAlongSegment(
        arr.threshold,
        rolloutEnd,
        arr.threshold.Y + 4,
        arr.threshold.Y + 2,
        GATE_COLORS.LANDING)

    -- Traffic pattern overlaid if enabled
    if AP.USE_PATTERN then
        local function perpDir(dir)
            return Vector3.new(dir.Z, 0, -dir.X).Unit
        end
        local patAlt = arr.threshold.Y + AP.PATTERN_ALT
        local perpR  = perpDir(arrDir)

        local crosswindEnd = arr.threshold + arrDir * (arr.length or 2000) + perpR * AP.PATTERN_LEG
        local downwindEnd  = arr.threshold - arrDir * 800 + perpR * AP.PATTERN_LEG
        local basePt       = arr.threshold - arrDir * 800 + perpR * (AP.PATTERN_LEG * 0.3)

        spawnGatesAlongSegment(crosswindEnd, downwindEnd, patAlt, patAlt, GATE_COLORS.DESCENT)
        spawnGatesAlongSegment(downwindEnd,  basePt,      patAlt, patAlt, GATE_COLORS.DESCENT)
        spawnGatesAlongSegment(basePt,       finalFix,    patAlt, appStartAlt, GATE_COLORS.APPROACH)
    end
end

-- ════════════════════════════════════════════════════════════════════
-- HELPERS
-- ════════════════════════════════════════════════════════════════════
local function dist2D(a, b)
    return Vector3.new(a.X - b.X, 0, a.Z - b.Z).Magnitude
end

local function pressKey(key)
    pcall(function()
        local VIM = game:GetService("VirtualInputManager")
        VIM:SendKeyEvent(true,  Enum.KeyCode[key], false, game)
        task.wait(0.1)
        VIM:SendKeyEvent(false, Enum.KeyCode[key], false, game)
    end)
end

local function fly(vel, lookDir)
    if bvel  and bvel.Parent  then bvel.Velocity  = vel end
    if bgyro and bgyro.Parent then
        if lookDir and lookDir.Magnitude > 0.001 then
            bgyro.CFrame = CFrame.new(Vector3.new(), lookDir.Unit)
        end
    end
end

local function getAlt()
    return AP.rootPart and AP.rootPart.Position.Y or 0
end

local function perpDir(dir)
    return Vector3.new(dir.Z, 0, -dir.X).Unit
end

local function logEvent(msg)
    local t = math.floor(tick())
    table.insert(flightLog, 1, string.format("[%d] %s", t, msg))
    if #flightLog > 30 then table.remove(flightLog) end
end

-- ════════════════════════════════════════════════════════════════════
-- WAYPOINT BUILDER
-- ════════════════════════════════════════════════════════════════════
local function buildWaypoints()
    waypoints = {}
    wpIndex   = 1
    local dep    = AP.depRunway
    local arr    = AP.arrRunway
    local alt    = AP.CRUISE_ALT
    local depDir = headingDir(dep.heading)
    local arrDir = headingDir(arr.heading)

    -- CLIMB waypoint
    local climbOut = dep.threshold + depDir * 3000
    climbOut = Vector3.new(climbOut.X, alt, climbOut.Z)
    table.insert(waypoints, {
        pos      = climbOut,
        label    = "CLIMB",
        onArrive = function() spd = AP.CRUISE_SPD; logEvent("Cruise speed set") end
    })

    -- CRUISE mid-point
    local midX = (dep.threshold.X + arr.threshold.X) / 2
    local midZ = (dep.threshold.Z + arr.threshold.Z) / 2
    table.insert(waypoints, {
        pos      = Vector3.new(midX, alt, midZ),
        label    = "CRUISE",
        onArrive = function() end
    })

    if AP.USE_PATTERN then
        local patAlt = arr.threshold.Y + AP.PATTERN_ALT
        local perpR  = perpDir(arrDir)

        local crosswindEnd = arr.threshold + arrDir * (arr.length or 2000) + perpR * AP.PATTERN_LEG
        crosswindEnd = Vector3.new(crosswindEnd.X, patAlt, crosswindEnd.Z)
        local downwindEnd = arr.threshold - arrDir * 800 + perpR * AP.PATTERN_LEG
        downwindEnd = Vector3.new(downwindEnd.X, patAlt, downwindEnd.Z)
        local basePt = arr.threshold - arrDir * 800 + perpR * (AP.PATTERN_LEG * 0.3)
        basePt = Vector3.new(basePt.X, patAlt, basePt.Z)
        local finalFix = arr.threshold - arrDir * 5000
        finalFix = Vector3.new(finalFix.X, patAlt, finalFix.Z)

        table.insert(waypoints, {
            pos   = crosswindEnd, label = "CROSSWIND",
            onArrive = function()
                spd = AP.LANDING_SPD * 1.3; logEvent("Crosswind leg")
            end
        })
        table.insert(waypoints, {
            pos   = downwindEnd, label = "DOWNWIND",
            onArrive = function()
                spd = AP.LANDING_SPD * 1.2; logEvent("Downwind – flaps")
                task.spawn(function() pressKey("F") end)
            end
        })
        table.insert(waypoints, {
            pos   = basePt, label = "BASE",
            onArrive = function()
                spd = AP.LANDING_SPD * 1.1; logEvent("Base – gear down")
                task.spawn(function() pressKey("G") end)
            end
        })
        table.insert(waypoints, {
            pos   = finalFix, label = "FINAL",
            onArrive = function()
                AP.phase = "APPROACH"; spd = AP.LANDING_SPD
                logEvent("Final approach")
            end
        })
    else
        local finalLeg = arr.threshold - arrDir * 12000
        finalLeg = Vector3.new(finalLeg.X, alt, finalLeg.Z)
        local descentStart = arr.threshold - arrDir * 5000
        descentStart = Vector3.new(descentStart.X, alt, descentStart.Z)

        table.insert(waypoints, {
            pos   = finalLeg, label = "FINAL FIX",
            onArrive = function()
                spd = AP.LANDING_SPD * 1.2
                task.spawn(function() pressKey("F") end)
                logEvent("Final fix – flaps")
            end
        })
        table.insert(waypoints, {
            pos   = descentStart, label = "DESCENT",
            onArrive = function()
                AP.phase = "APPROACH"; spd = AP.LANDING_SPD
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
    AP.active = false
    AP.phase  = "IDLE"
    if hbConn then hbConn:Disconnect(); hbConn = nil end
    if bvel   and bvel.Parent  then bvel:Destroy();  bvel  = nil end
    if bgyro  and bgyro.Parent then bgyro:Destroy(); bgyro = nil end
    logEvent("AP STOP: " .. (reason or "Manual"))
    print("⏹️ AP: " .. (reason or "Manual"))
end

-- ════════════════════════════════════════════════════════════════════
-- MAIN FLIGHT LOOP
-- ════════════════════════════════════════════════════════════════════
local function startLoop()
    spd = 0; wpIndex = 1
    if hbConn then hbConn:Disconnect() end

    hbConn = RunService.Heartbeat:Connect(function(dt)
        if not AP.active then hbConn:Disconnect(); hbConn = nil; return end

        if not AP.rootPart or not AP.rootPart.Parent then
            local char = Player.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and hum.SeatPart then
                    AP.aircraft = hum.SeatPart.Parent
                    AP.rootPart = AP.aircraft:FindFirstChild("Body")
                        or AP.aircraft:FindFirstChild("Fuselage")
                        or AP.aircraft:FindFirstChild("Main")
                        or hum.SeatPart
                end
            end
            return
        end

        if not bvel or not bvel.Parent then
            pcall(function()
                bvel = Instance.new("BodyVelocity")
                bvel.MaxForce = Vector3.new(1e9,1e9,1e9)
                bvel.Velocity = Vector3.new(0,0,0)
                bvel.P = 1e5
                bvel.Parent = AP.rootPart
            end); return
        end

        if not bgyro or not bgyro.Parent then
            pcall(function()
                bgyro = Instance.new("BodyGyro")
                bgyro.MaxTorque = Vector3.new(1e9,1e9,1e9)
                bgyro.P = 5e4; bgyro.D = 3000
                bgyro.CFrame = AP.rootPart.CFrame
                bgyro.Parent = AP.rootPart
            end); return
        end

        local pos    = AP.rootPart.Position
        local alt    = getAlt()
        local arrThr = AP.arrRunway.threshold
        local arrDir = headingDir(AP.arrRunway.heading)
        local depDir = headingDir(AP.depRunway.heading)

        pcall(function()
            -- TAKEOFF
            if AP.phase == "TAKEOFF" then
                spd = math.min(spd + math.max(AP.TAKEOFF_SPD * 0.6, 300) * dt, AP.TAKEOFF_SPD)
                local pitchY  = math.tan(math.rad(AP.CLIMB_PITCH))
                local moveDir = (depDir + Vector3.new(0, pitchY, 0)).Unit
                fly(moveDir * spd, moveDir)
                if alt >= AP.CRUISE_ALT then
                    AP.phase = "CRUISE"; spd = AP.CRUISE_SPD
                    task.spawn(function() pressKey("G") end)
                    logEvent("Climbing to cruise alt")
                end

            -- CRUISE (waypoint following)
            elseif AP.phase == "CRUISE" then
                if wpIndex > #waypoints then
                    AP.phase = "APPROACH"; spd = AP.LANDING_SPD; return
                end
                local wp   = waypoints[wpIndex]
                local d2D  = dist2D(pos, wp.pos)
                local toWP = Vector3.new(wp.pos.X - pos.X, 0, wp.pos.Z - pos.Z)
                local hDir = d2D > 1 and toWP.Unit or arrDir
                local altErr = wp.pos.Y - alt
                local yComp  = math.clamp(altErr * 0.003, -0.12, 0.12)
                fly((hDir + Vector3.new(0, yComp, 0)).Unit * AP.CRUISE_SPD, hDir)
                if d2D < 700 then
                    wp.onArrive(); wpIndex = wpIndex + 1
                    if AP.phase == "APPROACH" then return end
                end

            -- APPROACH
            elseif AP.phase == "APPROACH" then
                spd = AP.LANDING_SPD
                local toThr = Vector3.new(arrThr.X - pos.X, 0, arrThr.Z - pos.Z)
                local hDir  = toThr.Magnitude > 1 and toThr.Unit or arrDir
                local heightAbove = alt - arrThr.Y
                local dThresh = dist2D(pos, arrThr)

                local idealSink = dThresh > 5 and -math.clamp(heightAbove / dThresh, 0, 0.5) or 0
                if heightAbove < 80  then idealSink = math.max(idealSink, -0.08) end
                if heightAbove < 40  then idealSink = math.max(idealSink, -0.05) end
                if heightAbove < 15  then idealSink = math.max(idealSink, -0.02) end
                if heightAbove < 5   then idealSink = 0 end

                if dThresh < 3000 then
                    local spd_frac = math.clamp(dThresh / 3000, 0.85, 1.0)
                    spd = AP.LANDING_SPD * spd_frac
                end

                fly((hDir + Vector3.new(0, idealSink, 0)).Unit * spd, hDir)

                if heightAbove <= 3 or (dThresh < 15 and heightAbove < 15) then
                    AP.phase = "ROLLOUT"
                    task.spawn(function() pressKey("R") end)
                    logEvent("Touchdown!")
                end

            -- ROLLOUT
            elseif AP.phase == "ROLLOUT" then
                local toThr = Vector3.new(arrThr.X - pos.X, 0, arrThr.Z - pos.Z)
                local hDir  = toThr.Magnitude > 10 and toThr.Unit or arrDir
                spd = math.max(spd - math.max(AP.LANDING_SPD * 0.7, 250) * dt, 0)
                fly(hDir * spd, hDir)
                if spd <= 2 then
                    fly(Vector3.new(0,0,0), hDir)
                    task.spawn(function()
                        pressKey("R"); task.wait(0.2); pressKey("X")
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
    if AP.active        then return false, "Already active!" end
    if not AP.depRunway then return false, "Select departure runway!" end
    if not AP.arrRunway then return false, "Select arrival runway!" end
    if AP.depRunway == AP.arrRunway then return false, "Dep = Arr not allowed!" end

    local char = Player.Character
    if not char then return false, "No character!" end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or not hum.SeatPart then return false, "Board an aircraft first!" end

    local ac   = hum.SeatPart.Parent
    local root = ac:FindFirstChild("Body")
        or ac:FindFirstChild("Fuselage")
        or ac:FindFirstChild("Main")
        or hum.SeatPart

    AP.aircraft = ac
    AP.rootPart = root
    AP.active   = true
    AP.phase    = "TAKEOFF"
    flightLog   = {}
    logEvent("AP START: " .. AP.depRunway.name .. " → " .. AP.arrRunway.name)

    if bvel  and bvel.Parent  then bvel:Destroy()  end
    if bgyro and bgyro.Parent then bgyro:Destroy() end

    bvel = Instance.new("BodyVelocity")
    bvel.MaxForce = Vector3.new(1e9,1e9,1e9)
    bvel.Velocity = Vector3.new(0,0,0)
    bvel.P = 1e5
    bvel.Parent = root

    bgyro = Instance.new("BodyGyro")
    bgyro.MaxTorque = Vector3.new(1e9,1e9,1e9)
    bgyro.P = 5e4; bgyro.D = 3000
    bgyro.CFrame = root.CFrame
    bgyro.Parent = root

    -- Teleport to runway threshold
    local depDir   = headingDir(AP.depRunway.heading)
    local spawnPos = AP.depRunway.threshold - depDir * 80
    spawnPos = Vector3.new(spawnPos.X, AP.depRunway.threshold.Y + 3, spawnPos.Z)
    local ok = pcall(function()
        ac:PivotTo(CFrame.new(spawnPos, spawnPos + depDir))
    end)
    if not ok then
        local offset = spawnPos - root.Position
        for _, p in pairs(ac:GetDescendants()) do
            if p:IsA("BasePart") then p.CFrame = p.CFrame + offset end
        end
    end

    buildWaypoints()
    -- Rebuild tunnel if GPS is on
    if GPS.enabled then buildTunnel() end
    task.wait(0.5)
    task.spawn(function() pressKey("E"); task.wait(0.3); pressKey("F") end)
    task.wait(0.6)
    startLoop()
    return true, "Flight started! 🛫"
end

Player.CharacterAdded:Connect(function()
    if AP.active then stopAP("Character reset") end
end)

-- ════════════════════════════════════════════════════════════════════
-- UI COLOUR PALETTE
-- ════════════════════════════════════════════════════════════════════
local C = {
    bg       = Color3.fromRGB(8,  12, 18),
    panel    = Color3.fromRGB(12, 18, 28),
    panelB   = Color3.fromRGB(16, 24, 38),
    border   = Color3.fromRGB(35, 55, 80),
    borderHi = Color3.fromRGB(60, 120, 200),
    green    = Color3.fromRGB(0,  230, 130),
    greenD   = Color3.fromRGB(0,  140, 70),
    cyan     = Color3.fromRGB(40, 200, 255),
    cyanD    = Color3.fromRGB(0,  100, 160),
    amber    = Color3.fromRGB(255, 190, 0),
    amberD   = Color3.fromRGB(140, 90, 0),
    red      = Color3.fromRGB(255, 65, 65),
    redD     = Color3.fromRGB(120, 20, 20),
    white    = Color3.fromRGB(220, 232, 245),
    dim      = Color3.fromRGB(90, 110, 135),
    sky      = Color3.fromRGB(30, 90, 180),
    skyHi    = Color3.fromRGB(60, 140, 255),
    ground   = Color3.fromRGB(110, 70, 30),
    groundHi = Color3.fromRGB(160, 110, 50),
    magenta  = Color3.fromRGB(200, 60, 200),
    purple   = Color3.fromRGB(140, 80, 220),
}

-- ════════════════════════════════════════════════════════════════════
-- UI BUILDER UTILITIES
-- ════════════════════════════════════════════════════════════════════
local function F(parent, sx, sy, ox, oy, px, py, popx, popy, col, transp, zi)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(sx or 0, ox or 0, sy or 0, oy or 0)
    f.Position = UDim2.new(px or 0, popx or 0, py or 0, popy or 0)
    f.BackgroundColor3 = (typeof(col) == "Color3") and col or C.panel
    f.BackgroundTransparency = (typeof(transp) == "number") and transp or 0
    f.BorderSizePixel = 0
    f.ZIndex = (typeof(zi) == "number") and zi or 1
    f.Parent = parent
    return f
end

local function L(parent, text, ts, col, font, xa, sx, sy, ox, oy, px, py, popx, popy, zi)
    local l = Instance.new("TextLabel")
    l.Text = text or ""
    l.TextSize = ts or 12
    l.TextColor3 = col or C.white
    l.Font = font or Enum.Font.Code
    l.BackgroundTransparency = 1
    l.TextXAlignment = xa or Enum.TextXAlignment.Center
    l.Size = UDim2.new(sx or 1, ox or 0, sy or 1, oy or 0)
    l.Position = UDim2.new(px or 0, popx or 0, py or 0, popy or 0)
    l.ZIndex = zi or 2
    l.Parent = parent
    return l
end

local function Btn(parent, text, ts, col, bgcol, sx, sy, ox, oy, px, py, popx, popy, zi)
    local b = Instance.new("TextButton")
    b.Text = text or ""
    b.TextSize = ts or 12
    b.TextColor3 = col or C.white
    b.Font = Enum.Font.GothamBold
    b.BackgroundColor3 = bgcol or C.panel
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.Size = UDim2.new(sx or 0, ox or 80, sy or 0, oy or 24)
    b.Position = UDim2.new(px or 0, popx or 0, py or 0, popy or 0)
    b.ZIndex = zi or 3
    b.Parent = parent
    return b
end

local function Rnd(inst, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 4)
    c.Parent = inst
end

local function Str(inst, col, thick)
    local s = Instance.new("UIStroke")
    s.Color = col or C.border
    s.Thickness = thick or 1
    s.Parent = inst
end

local function makeDraggable(handle, target)
    local drag, ds, sp = false, nil, nil
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true; ds = i.Position; sp = target.Position
        end
    end)
    handle.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - ds
            target.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
        end
    end)
end

-- ════════════════════════════════════════════════════════════════════
-- MAIN SCREENGUI
-- ════════════════════════════════════════════════════════════════════
local sg = Instance.new("ScreenGui")
sg.Name = "PTFSMain"
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.DisplayOrder = 100
sg.Parent = PlayerGui

-- ════════════════════════════════════════════════════════════════════
-- COCKPIT HUD
-- ════════════════════════════════════════════════════════════════════
local HW, HH = 720, 260
local TH      = 26
local SPD_W   = 64
local ALT_W   = 72
local PFD_W   = HW - SPD_W - ALT_W - 4
local PFD_H   = HH - TH - 2
local ND_W    = 140
local AI_W    = PFD_W - ND_W - 2

local hud = F(sg, 0, 0, HW, HH, 0.5, 1, -HW/2, -HH-8, C.bg, 0, 1)
Rnd(hud, 10); Str(hud, C.borderHi, 1.5)

local hudTitle = F(hud, 1, 0, 0, TH, 0, 0, 0, 0, Color3.fromRGB(10,16,28), 0, 2)
Rnd(hudTitle, 10)
L(hudTitle, "✈  PTFS  FLIGHT  DECK  v17", 11, C.cyan, Enum.Font.GothamBold)
local hudClose = Btn(hud, "✕", 11, C.white, C.redD, 0, 0, 22, 20, 1, 0, -26, 3, 5)
Rnd(hudClose, 4); Str(hudClose, C.red, 1)

local hudC = F(hud, 1, 1, -2, -(TH+2), 0, 0, 1, TH+1, Color3.fromRGB(0,0,0), 1, 1)

-- SPD TAPE
local spdPanel = F(hudC, 0, 1, SPD_W, 0, 0, 0, 0, 0, Color3.fromRGB(10,16,14), 0, 2)
Rnd(spdPanel, 6); Str(spdPanel, Color3.fromRGB(0,80,50), 1)
L(spdPanel, "SPD", 8, C.greenD, Enum.Font.GothamBold, nil, 1, 0, 0, 14, 0, 0, 0, 0, 3)
L(spdPanel, "KTS", 8, C.greenD, Enum.Font.GothamBold, nil, 1, 0, 0, 14, 1, 0, 0, -14, 3)

local spdBox = F(spdPanel, 1, 0, -8, 30, 0, 0, 4, 0, Color3.fromRGB(0,20,12), 0, 3)
spdBox.Position = UDim2.new(0, 4, 0.5, -15)
Rnd(spdBox, 4); Str(spdBox, C.green, 1)
local spdVal = L(spdBox, "0", 17, C.green, Enum.Font.Code, nil, 1, 1, 0, 0, 0, 0, 0, 0, 4)

local spdTickContainer = F(spdPanel, 1, 1, 0, -34, 0, 0, 0, 16, Color3.fromRGB(0,0,0), 1, 2)
spdTickContainer.ClipsDescendants = true
for i = 0, 20 do
    local v = i * 50
    local yPct = 1 - (v / 1000)
    local major = v % 100 == 0
    F(spdTickContainer, 0, 0, major and 18 or 10, 1, 1, 0, -(major and 18 or 10), 0,
        0, yPct, 0, -1, major and Color3.fromRGB(0,180,80) or Color3.fromRGB(0,80,40), 0, 3)
    if major then
        L(spdTickContainer, tostring(v), 8, Color3.fromRGB(0,160,70), Enum.Font.Code,
            Enum.TextXAlignment.Right, 0, 0, SPD_W-22, 14, 0, yPct, 0, -8, 3)
    end
end
F(spdPanel, 1, 0, -4, 2, 0, 0.5, 2, -1, C.green, 0, 5)

-- ALT TAPE
local altPanel = F(hudC, 0, 1, ALT_W, 0, 1, 0, -ALT_W, 0, Color3.fromRGB(10,12,22), 0, 2)
Rnd(altPanel, 6); Str(altPanel, Color3.fromRGB(30,50,120), 1)
L(altPanel, "ALT", 8, C.cyanD, Enum.Font.GothamBold, nil, 1, 0, 0, 14, 0, 0, 0, 0, 3)
L(altPanel, "STD", 8, C.cyanD, Enum.Font.GothamBold, nil, 1, 0, 0, 14, 1, 0, 0, -14, 3)

local altBox = F(altPanel, 1, 0, -8, 30, 0, 0, 4, 0, Color3.fromRGB(5,8,28), 0, 3)
altBox.Position = UDim2.new(0, 4, 0.5, -15)
Rnd(altBox, 4); Str(altBox, C.cyan, 1)
local altVal = L(altBox, "0", 15, C.cyan, Enum.Font.Code, nil, 1, 1, 0, 0, 0, 0, 0, 0, 4)

local altTickContainer = F(altPanel, 1, 1, 0, -34, 0, 0, 0, 16, Color3.fromRGB(0,0,0), 1, 2)
altTickContainer.ClipsDescendants = true
for i = 0, 16 do
    local v = i * 500
    local yPct = 1 - (v / 8000)
    F(altTickContainer, 0, 0, 14, 1, 0, yPct, 0, -1, Color3.fromRGB(40,80,180), 0, 3)
    L(altTickContainer, tostring(v), 8, Color3.fromRGB(40,100,200), Enum.Font.Code,
        Enum.TextXAlignment.Left, 0, 0, ALT_W-20, 14, 0, yPct, 16, -8, 3)
end
F(altPanel, 1, 0, -4, 2, 0, 0.5, 2, -1, C.cyan, 0, 5)

-- PFD AREA
local pfdArea = F(hudC, 0, 1, PFD_W, 0, 0, 0, SPD_W+2, 0, Color3.fromRGB(0,0,0), 1, 1)

-- Attitude Indicator
local aiW = AI_W
local ai  = F(pfdArea, 0, 1, aiW, 0, 0, 0, 0, 0, C.sky, 0, 2)
Rnd(ai, 6); ai.ClipsDescendants = true

local skyTop  = F(ai, 1, 0.6, 0, 0, 0, 0,   0, 0, Color3.fromRGB(20,70,160),  0, 2)
local skyBot  = F(ai, 1, 0.5, 0, 0, 0, 0.5, 0, 0, Color3.fromRGB(50,120,220), 0, 2)
local gndTop  = F(ai, 1, 0.5, 0, 0, 0, 0.5, 0, 0, Color3.fromRGB(130,85,35),  0, 2)
local gndBot  = F(ai, 1, 0.5, 0, 0, 0, 1,   0, 0, Color3.fromRGB(90,55,20),   0, 2)
gndBot.AnchorPoint = Vector2.new(0, 1)
local horizLine = F(ai, 1, 0, 0, 2, 0, 0.5, 0, -1, C.amber, 0, 5)

for _, deg in ipairs({-15,-10,-5,5,10,15}) do
    local yBase = 0.5 - (deg * 0.018)
    local w = math.abs(deg) >= 10 and 0.42 or 0.28
    F(ai, w, 0, 0, 1, (1-w)/2, yBase, 0, 0, Color3.fromRGB(220,220,200), 0.3, 4)
    L(ai, string.format("%+d",deg), 8, Color3.fromRGB(220,220,180), Enum.Font.Code,
        Enum.TextXAlignment.Right, 0, 0, (1-w)/2*aiW-4, 12, 0, yBase, 0, -6, 4)
    L(ai, string.format("%+d",deg), 8, Color3.fromRGB(220,220,180), Enum.Font.Code,
        Enum.TextXAlignment.Left, 0, 0, (1-w)/2*aiW-4, 12, (1+w)/2, yBase, 4, -6, 4)
end

-- Aircraft symbol
F(ai, 0, 0, 44, 3, 0.5, 0.5, -52, -1, Color3.fromRGB(255,210,0), 0, 6)
F(ai, 0, 0, 44, 3, 0.5, 0.5,   8, -1, Color3.fromRGB(255,210,0), 0, 6)
local wDot = F(ai, 0, 0, 8, 8, 0.5, 0.5, -4, -4, Color3.fromRGB(255,210,0), 0, 6)
Rnd(wDot, 4)
F(ai, 0, 0, 3, 14, 0.5, 0.5, -1, -14, Color3.fromRGB(255,210,0), 0, 6)

-- FPV
local fpvFrame  = F(ai, 0, 0, 18, 18, 0.5, 0.5, -9, -9, Color3.fromRGB(0,0,0), 1, 7)
local fpvCircle = F(fpvFrame, 1, 1, 0, 0, 0, 0, 0, 0, Color3.fromRGB(0,0,0), 1, 7)
Str(fpvCircle, C.green, 1.5); Rnd(fpvCircle, 9)
F(fpvFrame, 0, 0, 8, 1, 1, 0.5,  1, 0, Color3.fromRGB(0,230,120), 0, 8)
F(fpvFrame, 0, 0, 8, 1, 0, 0.5, -9, 0, Color3.fromRGB(0,230,120), 0, 8)
F(fpvFrame, 0, 0, 1, 8, 0.5, 0, 0, -9, Color3.fromRGB(0,230,120), 0, 8)

-- Heading strip
local hdgStripH = 28
local hdgStrip  = F(pfdArea, 0, 0, aiW, hdgStripH, 0, 1, 0, -hdgStripH, Color3.fromRGB(10,14,24), 0, 3)
Str(hdgStrip, C.border, 1); Rnd(hdgStrip, 4)
for i = 0, 35 do
    local deg = i * 10
    local xPct = deg / 360
    local major = deg % 30 == 0
    F(hdgStrip, 0, 0, 1, major and 10 or 6, xPct, 0, 0, 0,
        major and Color3.fromRGB(60,110,180) or Color3.fromRGB(30,55,90), 0, 4)
    if major then
        local dirs = {[0]="N",[90]="E",[180]="S",[270]="W"}
        local txt = dirs[deg] or tostring(deg)
        L(hdgStrip, txt, 8, Color3.fromRGB(60,120,200), Enum.Font.Code, nil, 0, 0, 20, 12, xPct, 0, -10, 10, 4)
    end
end
local hdgPtr = F(hdgStrip, 0, 0, 2, 16, 0.5, 0, -1, 0, C.cyan, 0, 5)
local hdgReadBox = F(hdgStrip, 0, 1, 54, -4, 0.5, 0, -27, 2, Color3.fromRGB(5,10,30), 0, 5)
Rnd(hdgReadBox, 3); Str(hdgReadBox, C.cyan, 1)
local hdgRead = L(hdgReadBox, "000°", 13, C.cyan, Enum.Font.Code, nil, 1, 1, 0, 0, 0, 0, 0, 0, 6)

-- Top strip
local topStrip = F(pfdArea, 0, 0, aiW, 22, 0, 0, 0, 0, Color3.fromRGB(8,12,20), 0, 3)
Rnd(topStrip, 4)
local pitchRead = L(topStrip, "PTH +0.0°", 10, C.amber, Enum.Font.Code, Enum.TextXAlignment.Left, 0, 1, 0, 0, 0, 0, 6, 0, 4)
local vsRead    = L(topStrip, "V/S +0",    10, C.green, Enum.Font.Code, Enum.TextXAlignment.Right, 0, 1, 0, 0, 0, 0, -6, 0, 4)

-- NAV DISPLAY
local ndX = aiW + 2
local nd  = F(pfdArea, 0, 1, ND_W, 0, 0, 0, ndX, 0, Color3.fromRGB(8,10,20), 0, 2)
Rnd(nd, 6); Str(nd, C.border, 1)
L(nd, "NAV", 9, C.cyan, Enum.Font.GothamBold, nil, 1, 0, 0, 18, 0, 0, 0, 0, 3)

local compassR  = 52
local compassBG = F(nd, 0, 0, compassR*2, compassR*2, 0.5, 0, -compassR, 22, Color3.fromRGB(8,12,24), 0, 3)
Rnd(compassBG, compassR); Str(compassBG, Color3.fromRGB(40,65,100), 1)
local compassGlow = F(nd, 0, 0, compassR*2+6, compassR*2+6, 0.5, 0, -compassR-3, 19, Color3.fromRGB(0,0,0), 1, 2)
Rnd(compassGlow, compassR+3); Str(compassGlow, Color3.fromRGB(20,50,100), 1)

for _, cd in ipairs({{t="N",a=0,c=C.cyan},{t="E",a=90,c=C.white},{t="S",a=180,c=C.white},{t="W",a=270,c=C.white}}) do
    local r2 = math.rad(cd.a)
    local cx = math.sin(r2) * (compassR-10)
    local cy = -math.cos(r2) * (compassR-10)
    L(compassBG, cd.t, 9, cd.c, Enum.Font.GothamBold, nil, 0, 0, 16, 14, 0.5, 0.5, cx-8, cy-7, 4)
end
for i = 0, 35 do
    local r2    = math.rad(i * 10)
    local major = (i * 10) % 30 == 0
    local rm    = compassR - (major and 10 or 6)
    local tx    = math.sin(r2) * (rm + (compassR - 2 - rm)/2)
    local ty    = -math.cos(r2) * (rm + (compassR - 2 - rm)/2)
    F(compassBG, 0, 0, major and 2 or 1, major and 2 or 1, 0.5, 0.5, tx-1, ty-1,
        major and Color3.fromRGB(60,120,200) or Color3.fromRGB(30,60,100), 0, 4)
end
L(compassBG, "✈", 16, C.white, Enum.Font.GothamBold, nil, 0, 0, 22, 22, 0.5, 0.5, -11, -12, 5)
F(compassBG, 0, 0, 2, compassR-8, 0.5, 0.5, -1, -(compassR-8), C.cyan, 0, 5)

local ndHdgLbl   = L(nd, "000°",    14, C.cyan,  Enum.Font.Code, nil, 1, 0, 0, 20, 0, 0, 0, compassR*2+26, 3)
local ndDestLbl  = L(nd, "DEST: ---", 9, C.green, Enum.Font.Code, nil, 1, 0, 0, 16, 0, 0, 0, compassR*2+48, 3)
local ndWPLbl    = L(nd, "WP: -/-",   9, C.amber, Enum.Font.Code, nil, 1, 0, 0, 16, 0, 0, 0, compassR*2+66, 3)
local ndPhaseLbl = L(nd, "IDLE",     10, C.red,   Enum.Font.GothamBold, nil, 1, 0, 0, 18, 0, 0, 0, compassR*2+84, 3)

-- GPS tunnel indicator on NAV display
local ndGPSLbl = L(nd, "GPS OFF", 8, C.dim, Enum.Font.Code, nil, 1, 0, 0, 14, 0, 0, 0, compassR*2+102, 3)

-- BOTTOM BAR
local barH = 32
local bar  = F(hud, 1, 0, 0, barH, 0, 1, 0, -barH-1, Color3.fromRGB(8,11,20), 0, 3)
Rnd(bar, 6); Str(bar, C.border, 1)

local barCells = {
    {k="gs",    l="G/S",   c=C.green},
    {k="vs",    l="V/S",   c=C.cyan},
    {k="dist",  l="DIST",  c=C.amber},
    {k="wp",    l="WYPT",  c=Color3.fromRGB(180,180,255)},
    {k="phase", l="PHASE", c=C.magenta},
    {k="dep",   l="DEP",   c=C.dim},
    {k="arr",   l="ARR",   c=C.dim},
}
local barVals = {}
local cw = HW / #barCells
for i, cell in ipairs(barCells) do
    local cx = (i-1)*cw
    local bg = F(bar, 0, 1, cw-2, -4, 0, 0, cx+1, 2, Color3.fromRGB(11,16,28), 0, 3)
    Rnd(bg, 3)
    L(bg, cell.l, 7, C.dim, Enum.Font.GothamBold, nil, 1, 0, 0, 12, 0, 0, 0, 2, 4)
    barVals[cell.k] = L(bg, "--", 12, cell.c, Enum.Font.Code, nil, 1, 0, 0, 16, 0, 0, 0, 12, 4)
    if i < #barCells then F(bar, 0, 1, 1, -8, 0, 0, cx+cw, 4, C.border, 0, 4) end
end

hudClose.MouseButton1Click:Connect(function() hud.Visible = false end)
makeDraggable(hudTitle, hud)

-- ════════════════════════════════════════════════════════════════════
-- MAIN MENU
-- ════════════════════════════════════════════════════════════════════
local MENU_W = 240
local menuVisible = false

local menuPanel = F(sg, 0, 0, MENU_W, 540, 0, 0.5, 0, -270, C.bg, 0, 10)
menuPanel.Visible = false
Rnd(menuPanel, 10); Str(menuPanel, C.borderHi, 1.5)

local menuTitle = F(menuPanel, 1, 0, 0, 32, 0, 0, 0, 0, Color3.fromRGB(10,18,32), 0, 11)
Rnd(menuTitle, 10)
L(menuTitle, "✈ PTFS  AP  v17", 12, C.cyan, Enum.Font.GothamBold, nil, 1, 1, 0, 0, 0, 0, 0, 0, 12)
makeDraggable(menuTitle, menuPanel)

local menuClose = Btn(menuPanel, "✕", 11, C.white, C.redD, 0, 0, 22, 22, 1, 0, -26, 5, 13)
Rnd(menuClose, 4)
menuClose.MouseButton1Click:Connect(function() menuPanel.Visible = false; menuVisible = false end)

-- Tab system (added GPS tab)
local tabs = {"Dep","Arr","Ayar","GPS","Log"}
local tabBtns, tabContents = {}, {}
local activeTab = 1

local tabBar         = F(menuPanel, 1, 0, 0, 28,  0, 0, 0, 34, Color3.fromRGB(8,12,20),  0, 11)
local tabContentArea = F(menuPanel, 1, 1, 0, -66, 0, 0, 0, 64, Color3.fromRGB(0,0,0),    1, 11)

local tabW = MENU_W / #tabs
for i, name in ipairs(tabs) do
    local tbtn = Btn(tabBar, name, 8, C.dim, Color3.fromRGB(10,14,22),
        0, 1, tabW-2, 0, 0, 0, (i-1)*tabW+1, 0, 12)
    Rnd(tbtn, 3)
    table.insert(tabBtns, tbtn)
    local tc = F(tabContentArea, 1, 1, 0, 0, 0, 0, 0, 0, Color3.fromRGB(0,0,0), 1, 11)
    tc.Visible = (i == 1)
    table.insert(tabContents, tc)
    tbtn.MouseButton1Click:Connect(function()
        for j, tb in ipairs(tabBtns) do
            tb.BackgroundColor3 = (j==i) and Color3.fromRGB(16,28,50) or Color3.fromRGB(10,14,22)
            tb.TextColor3       = (j==i) and C.cyan or C.dim
            tabContents[j].Visible = (j==i)
        end
        activeTab = i
    end)
end
tabBtns[1].BackgroundColor3 = Color3.fromRGB(16,28,50)
tabBtns[1].TextColor3 = C.cyan

local function makeScroll(parent)
    local sf = Instance.new("ScrollingFrame")
    sf.Size = UDim2.new(1,-4,1,0)
    sf.Position = UDim2.new(0,2,0,0)
    sf.BackgroundTransparency = 1
    sf.BorderSizePixel = 0
    sf.ScrollBarThickness = 3
    sf.ScrollBarImageColor3 = C.cyanD
    sf.CanvasSize = UDim2.new(0,0,0,0)
    sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sf.Parent = parent
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0,3)
    layout.Parent = sf
    return sf
end

local function sectionHdr(parent, txt)
    local h = F(parent, 1, 0, 0, 22, 0, 0, 0, 0, Color3.fromRGB(8,18,36), 0, 12)
    Rnd(h, 3)
    L(h, txt, 9, C.cyan, Enum.Font.GothamBold, Enum.TextXAlignment.Left, 1, 1, -8, 0, 0, 0, 4, 0, 13)
    return h
end

local function typeColor(t)
    if t == "International" then return C.cyan
    elseif t == "Regional"  then return C.green
    elseif t == "Military"  then return C.amber
    elseif t == "STOL"      then return C.magenta
    else return C.dim end
end

local function runwayBtn(parent, apName, rwy, isArr, selLabel)
    local btnF = F(parent, 1, 0, -8, 30, 0, 0, 4, 0, Color3.fromRGB(12,18,32), 0, 12)
    Rnd(btnF, 5); Str(btnF, C.border, 1)
    local lbl = string.format("RWY %s  HDG %.0f°  %dm", rwy.name, rwy.heading, rwy.length or 0)
    L(btnF, lbl, 9, C.white, Enum.Font.Code, Enum.TextXAlignment.Left, 1, 1, -8, 0, 0, 0, 5, 0, 13)
    local clickBtn = Btn(btnF, "", 10, C.white, Color3.fromRGB(0,0,0), 1, 1, 0, 0, 0, 0, 0, 0, 14)
    clickBtn.BackgroundTransparency = 1
    clickBtn.MouseButton1Click:Connect(function()
        if isArr then AP.arrRunway = rwy else AP.depRunway = rwy end
        if selLabel then
            selLabel.Text = "✅ " .. apName .. " · RWY " .. rwy.name .. " (" .. string.format("%.0f",rwy.heading) .. "°)"
            selLabel.TextColor3 = isArr and C.cyan or C.green
        end
        local hiCol = isArr and C.cyanD or C.greenD
        TweenS:Create(btnF, TweenInfo.new(0.15), {BackgroundColor3 = hiCol}):Play()
        task.delay(0.4, function()
            TweenS:Create(btnF, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(12,18,32)}):Play()
        end)
        -- Rebuild GPS tunnel if enabled
        if GPS.enabled then buildTunnel() end
    end)
    return btnF
end

local function buildAirportList(scroll, isArr)
    local selF = F(scroll, 1, 0, 0, 28, 0, 0, 0, 0, Color3.fromRGB(8,14,24), 0, 12)
    Rnd(selF, 4); Str(selF, C.border, 1)
    local selLabel = L(selF, "Not selected", 10, C.amber, Enum.Font.Code, Enum.TextXAlignment.Left,
        1, 1, -8, 0, 0, 0, 5, 0, 13)

    local typeOrder = {"International","Regional","STOL","Military"}
    local grouped = {}
    for _, ap in ipairs(Airports) do
        local t = ap.type or "Regional"
        if not grouped[t] then grouped[t] = {} end
        table.insert(grouped[t], ap)
    end

    for _, typeName in ipairs(typeOrder) do
        local list = grouped[typeName]
        if list then
            local th = F(scroll, 1, 0, 0, 16, 0, 0, 0, 0, Color3.fromRGB(6,10,22), 0, 12)
            Rnd(th, 3)
            L(th, "── " .. typeName .. " ──", 8, typeColor(typeName), Enum.Font.GothamBold)
            for _, ap in ipairs(list) do
                local apH = F(scroll, 1, 0, 0, 20, 0, 0, 0, 0, Color3.fromRGB(10,22,40), 0, 12)
                Rnd(apH, 3)
                local icaoTxt = ap.icao and (" [" .. ap.icao .. "]") or ""
                L(apH, "📍 " .. ap.name .. icaoTxt, 9, C.white, Enum.Font.GothamBold,
                    Enum.TextXAlignment.Left, 1, 1, -8, 0, 0, 0, 4, 0, 13)
                for _, rwy in ipairs(ap.runways) do
                    runwayBtn(scroll, ap.name, rwy, isArr, selLabel)
                end
            end
        end
    end
    return selLabel
end

-- Departure Tab
do
    local sc = makeScroll(tabContents[1])
    sectionHdr(sc, "DEPARTURE RUNWAY")
    buildAirportList(sc, false)
end

-- Arrival Tab
do
    local sc = makeScroll(tabContents[2])
    sectionHdr(sc, "ARRIVAL RUNWAY")
    buildAirportList(sc, true)
end

-- Settings Tab (index 3)
do
    local scroll = makeScroll(tabContents[3])
    sectionHdr(scroll, "AUTOPILOT SETTINGS")

    local function makeSlider(parent, label, min, max, default, suffix, callback)
        local grp = F(parent, 1, 0, 0, 58, 0, 0, 0, 0, Color3.fromRGB(10,16,28), 0, 12)
        Rnd(grp, 5); Str(grp, C.border, 1)
        L(grp, label, 9, C.dim, Enum.Font.GothamBold, Enum.TextXAlignment.Left, 1, 0, -8, 14, 0, 0, 4, 4, 13)
        local valLbl = L(grp, tostring(default)..suffix, 10, C.cyan, Enum.Font.Code,
            Enum.TextXAlignment.Right, 0, 0, 60, 14, 1, 0, -64, 4, 13)
        local track = F(grp, 1, 0, -16, 6, 0, 0, 8, 36, Color3.fromRGB(20,30,50), 0, 13)
        Rnd(track, 3)
        local fill  = F(track, 0, 1, 0, 0, 0, 0, 0, 0, C.cyanD, 0, 14); Rnd(fill, 3)
        local thumb = F(track, 0, 0, 10, 10, 0, 0.5, -5, -5, C.cyan, 0, 15); Rnd(thumb, 5)
        local function setVal(v)
            v = math.clamp(math.floor(v), min, max)
            local pct = (v-min)/(max-min)
            fill.Size  = UDim2.new(pct, 0, 1, 0)
            thumb.Position = UDim2.new(pct, -5, 0.5, -5)
            valLbl.Text = tostring(v)..suffix
            if callback then callback(v) end
        end
        setVal(default)
        local dragging = false
        thumb.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
        end)
        UIS.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
        UIS.InputChanged:Connect(function(i)
            if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                local rx = track.AbsolutePosition.X
                local rw = track.AbsoluteSize.X
                setVal(min + math.clamp((i.Position.X - rx) / rw, 0, 1) * (max-min))
            end
        end)
        track.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                local rx = track.AbsolutePosition.X
                local rw = track.AbsoluteSize.X
                setVal(min + math.clamp((i.Position.X - rx) / rw, 0, 1) * (max-min))
            end
        end)
    end

    makeSlider(scroll, "Cruise Speed",   100, 600,  350, " kts", function(v) AP.CRUISE_SPD=v end)
    makeSlider(scroll, "Takeoff Speed",  80,  400,  280, " kts", function(v) AP.TAKEOFF_SPD=v end)
    makeSlider(scroll, "Landing Speed",  60,  200,  110, " kts", function(v) AP.LANDING_SPD=v end)
    makeSlider(scroll, "Cruise Alt",     500, 8000, 2000, " st",  function(v) AP.CRUISE_ALT=v; if GPS.enabled then buildTunnel() end end)
    makeSlider(scroll, "Climb Angle",    5,   30,   15,  "°",    function(v) AP.CLIMB_PITCH=v end)
    makeSlider(scroll, "Pattern Alt",    200, 1500, 600,  " st",  function(v) AP.PATTERN_ALT=v; if GPS.enabled then buildTunnel() end end)
    makeSlider(scroll, "Pattern Leg",    400, 3000, 1200, " st",  function(v) AP.PATTERN_LEG=v; if GPS.enabled then buildTunnel() end end)

    -- Traffic pattern toggle
    local togF = F(scroll, 1, 0, 0, 34, 0, 0, 0, 0, Color3.fromRGB(10,16,28), 0, 12)
    Rnd(togF, 5); Str(togF, C.border, 1)
    L(togF, "Traffic Pattern", 10, C.white, Enum.Font.GothamBold, Enum.TextXAlignment.Left, 0.6, 1, 0, 0, 0, 0, 6, 0, 13)
    local togBtn = Btn(togF, "OFF", 10, C.red, Color3.fromRGB(30,8,8), 0, 1, -8, -8, 1, 0, -80+4, 4, 13)
    Rnd(togBtn, 5); Str(togBtn, C.red, 1)
    togBtn.MouseButton1Click:Connect(function()
        AP.USE_PATTERN = not AP.USE_PATTERN
        if AP.USE_PATTERN then
            togBtn.Text = "ON"; togBtn.TextColor3 = C.green
            togBtn.BackgroundColor3 = Color3.fromRGB(0,25,12)
            Str(togBtn, C.green, 1)
        else
            togBtn.Text = "OFF"; togBtn.TextColor3 = C.red
            togBtn.BackgroundColor3 = Color3.fromRGB(30,8,8)
            Str(togBtn, C.red, 1)
        end
        if GPS.enabled then buildTunnel() end
    end)
end

-- ════════════════════════════════════════════════════════════════════
-- GPS FLIGHT GUIDE TAB (index 4)
-- ════════════════════════════════════════════════════════════════════
do
    local scroll = makeScroll(tabContents[4])
    sectionHdr(scroll, "✈ FLIGHT GUIDE GPS")

    -- Description
    local descF = F(scroll, 1, 0, 0, 72, 0, 0, 0, 0, Color3.fromRGB(8,14,26), 0, 12)
    Rnd(descF, 4); Str(descF, C.border, 1)
    L(descF, "Semi-transparent 3D tunnel\nguides you through takeoff,\ncruise, approach & landing.\nSelect DEP+ARR first.", 9,
        C.dim, Enum.Font.Code, Enum.TextXAlignment.Left, 1, 1, -8, 0, 0, 0, 4, 0, 13)

    -- Colour legend
    local function legendRow(parent, col, label)
        local rf = F(parent, 1, 0, 0, 20, 0, 0, 0, 0, Color3.fromRGB(8,12,22), 0, 12)
        Rnd(rf, 3)
        local dot = F(rf, 0, 0, 12, 12, 0, 0.5, 6, -6, col, 0, 13); Rnd(dot, 6)
        L(rf, label, 9, C.white, Enum.Font.Code, Enum.TextXAlignment.Left, 1, 1, -28, 0, 0, 0, 24, 0, 13)
    end
    legendRow(scroll, GATE_COLORS.TAKEOFF,  "TAKEOFF / CLIMB")
    legendRow(scroll, GATE_COLORS.CRUISE,   "CRUISE")
    legendRow(scroll, GATE_COLORS.DESCENT,  "DESCENT / PATTERN")
    legendRow(scroll, GATE_COLORS.APPROACH, "APPROACH / FINAL")
    legendRow(scroll, GATE_COLORS.LANDING,  "LANDING ROLLOUT")

    -- Tunnel spacing slider
    local spacingF = F(scroll, 1, 0, 0, 50, 0, 0, 0, 0, Color3.fromRGB(10,16,28), 0, 12)
    Rnd(spacingF, 5); Str(spacingF, C.border, 1)
    L(spacingF, "Gate Spacing", 9, C.dim, Enum.Font.GothamBold, Enum.TextXAlignment.Left, 1, 0, -8, 14, 0, 0, 4, 4, 13)
    local spacingLbl = L(spacingF, "600 st", 10, C.cyan, Enum.Font.Code, Enum.TextXAlignment.Right, 0, 0, 60, 14, 1, 0, -64, 4, 13)
    local sTrack = F(spacingF, 1, 0, -16, 6, 0, 0, 8, 30, Color3.fromRGB(20,30,50), 0, 13); Rnd(sTrack, 3)
    local sFill  = F(sTrack, 0, 1, 0, 0, 0, 0, 0, 0, C.cyanD, 0, 14); Rnd(sFill, 3)
    local sThumb = F(sTrack, 0, 0, 10, 10, 0, 0.5, -5, -5, C.cyan, 0, 15); Rnd(sThumb, 5)
    local spacingDrag = false
    local function setSpacing(v)
        v = math.clamp(math.floor(v/50)*50, 200, 2000)
        TUNNEL_SPACING = v
        local pct = (v-200)/(2000-200)
        sFill.Size = UDim2.new(pct,0,1,0)
        sThumb.Position = UDim2.new(pct,-5,0.5,-5)
        spacingLbl.Text = tostring(v) .. " st"
        if GPS.enabled then buildTunnel() end
    end
    setSpacing(600)
    sThumb.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then spacingDrag = true end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then spacingDrag = false end end)
    UIS.InputChanged:Connect(function(i)
        if spacingDrag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local rx = sTrack.AbsolutePosition.X; local rw = sTrack.AbsoluteSize.X
            setSpacing(200 + math.clamp((i.Position.X-rx)/rw,0,1)*1800)
        end
    end)
    sTrack.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            local rx = sTrack.AbsolutePosition.X; local rw = sTrack.AbsoluteSize.X
            setSpacing(200 + math.clamp((i.Position.X-rx)/rw,0,1)*1800)
        end
    end)

    -- GPS ON/OFF toggle
    local gpsTogF = F(scroll, 1, 0, 0, 38, 0, 0, 0, 0, Color3.fromRGB(10,18,10), 0, 12)
    Rnd(gpsTogF, 6); Str(gpsTogF, C.greenD, 1.5)
    L(gpsTogF, "Flight Guide GPS", 11, C.white, Enum.Font.GothamBold, Enum.TextXAlignment.Left, 0.6, 1, 0, 0, 0, 0, 8, 0, 13)
    local gpsTog = Btn(gpsTogF, "OFF", 11, C.red, Color3.fromRGB(30,8,8), 0, 1, -8, -8, 1, 0, -76, 5, 14)
    Rnd(gpsTog, 6); Str(gpsTog, C.red, 1.5)
    gpsTog.MouseButton1Click:Connect(function()
        GPS.enabled = not GPS.enabled
        if GPS.enabled then
            gpsTog.Text = "ON ✈"; gpsTog.TextColor3 = C.green
            gpsTog.BackgroundColor3 = Color3.fromRGB(0,28,12)
            Str(gpsTog, C.green, 1.5)
            buildTunnel()
            ndGPSLbl.TextColor3 = C.green
            ndGPSLbl.Text = "GPS ON"
        else
            gpsTog.Text = "OFF"; gpsTog.TextColor3 = C.red
            gpsTog.BackgroundColor3 = Color3.fromRGB(30,8,8)
            Str(gpsTog, C.red, 1.5)
            clearTunnel()
            ndGPSLbl.TextColor3 = C.dim
            ndGPSLbl.Text = "GPS OFF"
        end
    end)

    -- Rebuild button
    local rebuildBtn = Btn(scroll, "🔄  REBUILD TUNNEL", 10, C.cyan, Color3.fromRGB(0,16,30), 1, 0, -8, 28, 0, 0, 4, 0, 13)
    Rnd(rebuildBtn, 5); Str(rebuildBtn, C.cyanD, 1)
    rebuildBtn.MouseButton1Click:Connect(function()
        if GPS.enabled then
            buildTunnel()
            rebuildBtn.Text = "✅ Rebuilt!"
            task.delay(2, function() rebuildBtn.Text = "🔄  REBUILD TUNNEL" end)
        else
            rebuildBtn.Text = "❌ Enable GPS first"
            task.delay(2, function() rebuildBtn.Text = "🔄  REBUILD TUNNEL" end)
        end
    end)

    -- Clear button
    local clearBtn = Btn(scroll, "🗑  CLEAR TUNNEL", 10, C.red, Color3.fromRGB(28,6,6), 1, 0, -8, 28, 0, 0, 4, 0, 13)
    Rnd(clearBtn, 5); Str(clearBtn, C.redD, 1)
    clearBtn.MouseButton1Click:Connect(function()
        clearTunnel()
        GPS.enabled = false
        gpsTog.Text = "OFF"; gpsTog.TextColor3 = C.red
        gpsTog.BackgroundColor3 = Color3.fromRGB(30,8,8)
        ndGPSLbl.TextColor3 = C.dim; ndGPSLbl.Text = "GPS OFF"
    end)

    -- Info: gate count label
    local gateCountF = F(scroll, 1, 0, 0, 22, 0, 0, 0, 0, Color3.fromRGB(8,10,20), 0, 12); Rnd(gateCountF, 3)
    local gateCountLbl = L(gateCountF, "Gates: 0", 9, C.dim, Enum.Font.Code, Enum.TextXAlignment.Left, 1, 1, -8, 0, 0, 0, 4, 0, 13)
    task.spawn(function()
        while task.wait(1) do
            pcall(function()
                gateCountLbl.Text = string.format("Gates in world: %d  |  GPS: %s", #GPS.parts, GPS.enabled and "ON" or "OFF")
                gateCountLbl.TextColor3 = GPS.enabled and C.green or C.dim
            end)
        end
    end)
end

-- Log Tab (index 5)
do
    local scroll = makeScroll(tabContents[5])
    sectionHdr(scroll, "FLIGHT LOG")

    local logEntries = {}
    for i = 1, 20 do
        local ef = F(scroll, 1, 0, 0, 18, 0, 0, 0, 0, Color3.fromRGB(8,12,22), 0, 12)
        Rnd(ef, 2)
        local el = L(ef, "", 8, C.dim, Enum.Font.Code, Enum.TextXAlignment.Left, 1, 1, -8, 0, 0, 0, 3, 0, 13)
        table.insert(logEntries, el)
    end

    task.spawn(function()
        while task.wait(0.5) do
            pcall(function()
                for i, lbl in ipairs(logEntries) do
                    local entry = flightLog[i]
                    lbl.Text = entry or ""
                    lbl.TextColor3 = entry and C.white or C.dim
                end
            end)
        end
    end)
end

-- ════════════════════════════════════════════════════════════════════
-- RIGHT DOCK
-- ════════════════════════════════════════════════════════════════════
local dockW = 120
local dock = F(sg, 0, 0, dockW, 160, 1, 0.5, -dockW-8, -80, Color3.fromRGB(8,12,20), 0, 15)
Rnd(dock, 8); Str(dock, C.border, 1)

local dockTitle = F(dock, 1, 0, 0, 22, 0, 0, 0, 0, Color3.fromRGB(10,16,30), 0, 16)
Rnd(dockTitle, 8)
L(dockTitle, "✈ PTFS v17", 9, C.cyan, Enum.Font.GothamBold)

local function dockBtn(y, txt, bg, brd, callback)
    local b = Btn(dock, txt, 10, C.white, bg, 1, 0, -8, 26, 0, 0, 4, y, 16)
    Rnd(b, 5); Str(b, brd, 1)
    b.MouseButton1Click:Connect(callback)
    return b
end

local AP_W, AP_H = 260, 230
local apMenu = F(sg, 0, 0, AP_W, AP_H, 0, 0.5, 0, -AP_H/2, C.bg, 0, 20)
apMenu.Visible = false; Rnd(apMenu, 10); Str(apMenu, C.borderHi, 1.5)

dockBtn(26, "☰  MENU",     Color3.fromRGB(12,20,40), C.borderHi, function()
    menuVisible = not menuVisible
    menuPanel.Visible = menuVisible
    if menuVisible then
        menuPanel.Position = UDim2.new(1, -dockW-8-MENU_W-8, 0.5, -270)
    end
end)

local apDockBtn = dockBtn(56, "✈  AUTOPILOT", Color3.fromRGB(0,18,8), C.green, function()
    apMenu.Visible = not apMenu.Visible
    if apMenu.Visible then
        apMenu.Position = UDim2.new(1, -dockW-8-AP_W-8, 0.5, -AP_H/2)
    end
end)
Str(apDockBtn, C.green, 1)

dockBtn(86, "🖥  COCKPIT",  Color3.fromRGB(8,12,28), C.borderHi, function()
    hud.Visible = not hud.Visible
end)

-- GPS quick-toggle on dock
local gpsDockBtn = dockBtn(116, "🛰  GPS: OFF", Color3.fromRGB(8,18,8), C.greenD, function()
    GPS.enabled = not GPS.enabled
    if GPS.enabled then
        buildTunnel()
        ndGPSLbl.Text = "GPS ON"; ndGPSLbl.TextColor3 = C.green
    else
        clearTunnel()
        ndGPSLbl.Text = "GPS OFF"; ndGPSLbl.TextColor3 = C.dim
    end
end)

-- AP status badge on dock
local dockAPF = F(dock, 1, 0, -8, 12, 0, 0, 4, 148, Color3.fromRGB(25,8,8), 0, 16); Rnd(dockAPF, 3)
local dockAPLbl = L(dockAPF, "AP OFF", 8, C.red, Enum.Font.GothamBold, nil, 1, 1, 0, 0, 0, 0, 0, 0, 17)

task.spawn(function()
    while task.wait(0.5) do pcall(function()
        dockAPLbl.Text = AP.active and ("AP "..AP.phase) or "AP OFF"
        dockAPLbl.TextColor3 = AP.active and C.green or C.red
        dockAPF.BackgroundColor3 = AP.active and Color3.fromRGB(5,30,10) or Color3.fromRGB(25,8,8)
        apDockBtn.BackgroundColor3 = AP.active and Color3.fromRGB(0,30,12) or Color3.fromRGB(0,18,8)
        -- GPS dock button label
        gpsDockBtn.Text = GPS.enabled and "🛰  GPS: ON" or "🛰  GPS: OFF"
        gpsDockBtn.TextColor3 = GPS.enabled and C.green or C.dim
        gpsDockBtn.BackgroundColor3 = GPS.enabled and Color3.fromRGB(0,20,10) or Color3.fromRGB(8,18,8)
    end) end
end)

-- ════════════════════════════════════════════════════════════════════
-- AP CONTROL POPUP
-- ════════════════════════════════════════════════════════════════════
local apMenuTitle = F(apMenu, 1, 0, 0, 30, 0, 0, 0, 0, Color3.fromRGB(10,20,40), 0, 21)
Rnd(apMenuTitle, 10)
L(apMenuTitle, "AUTOPILOT CONTROL", 11, C.cyan, Enum.Font.GothamBold)
makeDraggable(apMenuTitle, apMenu)

local apMenuClose = Btn(apMenu, "✕", 11, C.white, C.redD, 0, 0, 22, 22, 1, 0, -26, 4, 22)
Rnd(apMenuClose, 4)
apMenuClose.MouseButton1Click:Connect(function() apMenu.Visible = false end)

local apStatF  = F(apMenu, 1, 0, -12, 28, 0, 0, 6, 34, Color3.fromRGB(10,30,10), 0, 21)
Rnd(apStatF, 5); Str(apStatF, C.greenD, 1)
local apStatLbl = L(apStatF, "●  AP  OFF", 13, C.red, Enum.Font.GothamBold, nil, 1, 1, 0, 0, 0, 0, 0, 0, 22)

local routeF  = F(apMenu, 1, 0, -12, 24, 0, 0, 6, 66, Color3.fromRGB(8,12,24), 0, 21)
Rnd(routeF, 4)
local routeLbl = L(routeF, "DEP: --  →  ARR: --", 9, C.dim, Enum.Font.Code, Enum.TextXAlignment.Left, 1, 1, -8, 0, 0, 0, 4, 0, 22)

local wpF  = F(apMenu, 1, 0, -12, 20, 0, 0, 6, 94, Color3.fromRGB(8,10,20), 0, 21)
Rnd(wpF, 3)
local wpLbl = L(wpF, "PHASE: IDLE   WP: -/-", 9, C.amber, Enum.Font.Code, Enum.TextXAlignment.Left, 1, 1, -8, 0, 0, 0, 4, 0, 22)

local wpNameF = F(apMenu, 1, 0, -12, 18, 0, 0, 6, 118, Color3.fromRGB(8,10,20), 0, 21)
Rnd(wpNameF, 3)
local wpNameLbl = L(wpNameF, "WP: ---", 9, C.purple, Enum.Font.Code, Enum.TextXAlignment.Left, 1, 1, -8, 0, 0, 0, 4, 0, 22)

-- GPS status in AP popup
local apGpsF = F(apMenu, 1, 0, -12, 18, 0, 0, 6, 140, Color3.fromRGB(8,10,18), 0, 21)
Rnd(apGpsF, 3)
local apGpsLbl = L(apGpsF, "GPS: OFF", 9, C.dim, Enum.Font.Code, Enum.TextXAlignment.Left, 1, 1, -8, 0, 0, 0, 4, 0, 22)

local startBtn = Btn(apMenu, "▶  START AUTOPILOT", 12, C.green, Color3.fromRGB(0,30,15),
    1, 0, -12, 30, 0, 0, 6, 162, 22)
Rnd(startBtn, 6); Str(startBtn, C.green, 1)
startBtn.MouseButton1Click:Connect(function()
    local ok, msg = startAP()
    startBtn.Text = ok and ("✅ " .. msg) or ("❌ " .. msg)
    task.delay(2.5, function() startBtn.Text = "▶  START AUTOPILOT" end)
end)

local stopBtn = Btn(apMenu, "■  STOP", 12, C.red, Color3.fromRGB(30,8,8),
    1, 0, -12, 28, 0, 0, 6, 198, 22)
Rnd(stopBtn, 6); Str(stopBtn, C.red, 1)
stopBtn.MouseButton1Click:Connect(function() stopAP("Manual") end)

-- AP popup updater
task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            if AP.active then
                apStatLbl.Text = "●  AP  ON  — " .. AP.phase
                apStatLbl.TextColor3 = C.green
                apStatF.BackgroundColor3 = Color3.fromRGB(5,30,12)
            else
                apStatLbl.Text = "●  AP  OFF"
                apStatLbl.TextColor3 = C.red
                apStatF.BackgroundColor3 = Color3.fromRGB(25,8,8)
            end
            local dep = AP.depRunway and AP.depRunway.name or "--"
            local arr = AP.arrRunway and AP.arrRunway.name or "--"
            routeLbl.Text = "DEP: " .. dep .. "   →   ARR: " .. arr
            wpLbl.Text = string.format("PHASE: %s   WP: %s/%s", AP.phase, tostring(wpIndex), tostring(#waypoints))
            local curWP = waypoints[wpIndex]
            wpNameLbl.Text = "NEXT: " .. (curWP and curWP.label or "---")
            apGpsLbl.Text = GPS.enabled and ("GPS ON  gates:" .. #GPS.parts) or "GPS OFF"
            apGpsLbl.TextColor3 = GPS.enabled and C.green or C.dim
        end)
    end
end)

-- ════════════════════════════════════════════════════════════════════
-- HUD LIVE UPDATE
-- ════════════════════════════════════════════════════════════════════
RunService.Heartbeat:Connect(function()
    if not hud.Visible then return end
    pcall(function()
        local char = Player.Character; if not char then return end
        local hrp  = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end

        local vel   = hrp.AssemblyLinearVelocity
        local gs    = math.floor(vel.Magnitude)
        local alt   = math.floor(hrp.Position.Y)
        local look  = hrp.CFrame.LookVector
        local hdg   = math.deg(math.atan2(look.X, look.Z)); if hdg < 0 then hdg = hdg + 360 end
        local pitch = 0
        if vel.Magnitude > 0.5 then
            pitch = math.deg(math.asin(math.clamp(vel.Y / vel.Magnitude, -1, 1)))
        end
        local vs = math.floor(vel.Y * 60)

        local speedColor = gs < 100 and C.red or (gs < 200 and C.amber or C.green)
        spdVal.Text = tostring(gs); spdVal.TextColor3 = speedColor

        local altColor = alt < 50 and C.amber or (alt < 200 and C.white or C.cyan)
        altVal.Text = tostring(alt); altVal.TextColor3 = altColor

        local aiH = ai.AbsoluteSize.Y
        local pxPitch = math.clamp(pitch * (aiH * 0.018), -(aiH*0.45), aiH*0.45)
        local skyRatio = math.clamp(0.5 + pxPitch/aiH, 0.05, 0.95)
        skyTop.Size = UDim2.new(1, 0, skyRatio, 0)
        skyBot.Size = UDim2.new(1, 0, skyRatio, 0)
        gndTop.Position = UDim2.new(0, 0, skyRatio, 0)
        gndTop.Size = UDim2.new(1, 0, 1-skyRatio, 0)
        gndBot.Position = UDim2.new(0, 0, 1, 0)
        gndBot.Size = UDim2.new(1, 0, 1-skyRatio, 0)
        horizLine.Position = UDim2.new(0, 0, skyRatio, -1)

        if vel.Magnitude > 2 then
            local fpvPitch = math.deg(math.asin(math.clamp(vel.Y/vel.Magnitude,-1,1)))
            local fpvYPx = -fpvPitch * (aiH * 0.018)
            fpvFrame.Position = UDim2.new(0.5, -9, 0.5, fpvYPx - 9)
            fpvFrame.Visible = true
        else
            fpvFrame.Visible = false
        end

        local hdgFrac = hdg / 360
        hdgPtr.Position = UDim2.new(hdgFrac, -1, 0, 0)
        hdgRead.Text  = string.format("%03.0f°", hdg)
        ndHdgLbl.Text = string.format("%03.0f°", hdg)

        pitchRead.Text = string.format("PTH %+.1f°", pitch)
        vsRead.Text    = string.format("V/S %+d fpm", vs)

        barVals.gs.Text    = tostring(gs) .. " kts"
        barVals.vs.Text    = (vs >= 0 and "+" or "") .. tostring(vs) .. " fpm"
        barVals.phase.Text = AP.phase
        local dist = AP.arrRunway and tostring(math.floor(dist2D(hrp.Position, AP.arrRunway.threshold))) .. " st" or "---"
        barVals.dist.Text  = dist
        barVals.wp.Text    = AP.active and (tostring(wpIndex).."/"..tostring(#waypoints)) or "-/-"
        barVals.dep.Text   = AP.depRunway and AP.depRunway.name or "---"
        barVals.arr.Text   = AP.arrRunway and AP.arrRunway.name or "---"

        local dStr = AP.arrRunway and tostring(math.floor(dist2D(hrp.Position, AP.arrRunway.threshold))) or "---"
        ndDestLbl.Text  = "DEST: " .. dStr .. " st"
        ndWPLbl.Text    = "WP: " .. (AP.active and (tostring(wpIndex).."/"..tostring(#waypoints)) or "-/-")
        ndPhaseLbl.Text = AP.phase
        ndPhaseLbl.TextColor3 = AP.active and C.green or C.red
    end)
end)

-- ════════════════════════════════════════════════════════════════════
-- INIT
-- ════════════════════════════════════════════════════════════════════
local totalRunways = 0
for _, a in ipairs(Airports) do totalRunways = totalRunways + #a.runways end

print("✅ PTFS Autopilot v17 loaded!")
print(string.format("   %d airports | %d runways", #Airports, totalRunways))
print("   Dock: ☰ Menu | ✈ Autopilot | 🖥 Cockpit | 🛰 GPS")
print("   GPS: Semi-transparent tunnel gates across all flight phases")
print("   Official PTFS ICAOs: IRFD ITKO IPPH IZOL IBTH ILAR IPAP ISAU")
print("                        IDCS ISKP IGRV ILKL IBAR IHEN IMLR IBLT")
print("                        IBRD IIAB ISCM IJAF IGAR ITRC")
