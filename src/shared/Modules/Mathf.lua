local Mathf = {}

Mathf.TAU = 6.28318530717959
Mathf.PI = 3.14159265359
Mathf.E = 2.71828182846
Mathf.GOLDEN_RATIO = 1.61803398875 

--Rounds a number to the closest integer
function Mathf.RoundToInt(n: number)
    if n % 1 >= 0.5 then
        
        return math.ceil(n)
    else
       
        return math.floor(n)
    end
end

--Interpolates between /a/ and /b/ by /t/. /t/ is clamped between 0 and 1.
function Mathf.Lerp(a: number, b: number, t: number)
    
    return a + (b - a) * math.clamp(t, 0, 1)
end

--Interpolates between /a/ and /b/ by /t/ without clamping the interpolant.
function Mathf.LerpUnclamped(a: number, b: number, t: number)
    
    return a + (b - a) * t
end

--Same as Lerp but makes sure the values interpolate correctly when they wrap around 360 degrees.
function Mathf.LerpAngle(a: number, b: number, t: number)
    local delta = Mathf.Repeat((b - a), 360)
    
    if delta > 180 then
        delta -= 360
    end
    
    return a + delta * math.clamp(t, 0, 1)
end

--Moves a value /current/ towards /target/.
function Mathf.MoveTowards(current: number, target: number, maxDelta: number)
    if math.abs(target - current) <= maxDelta then
        return target
    end
    
    return current + math.sign(target - current) * maxDelta
end

--Same as MoveTowards but makes sure the values interpolate correctly when they wrap around 360 degrees.
function Mathf.MoveTowardsAngle(current: number, target: number, maxDelta: number)
    local deltaAngle = Mathf.DeltaAngle(current, target)
    
    if -maxDelta < deltaAngle and deltaAngle < maxDelta then
        return target
    end
    
    target = current + deltaAngle
    
    return Mathf.MoveTowards(current, target, maxDelta)
end

-- Loops the value t, so that it is never larger than length and never smaller than 0.
function Mathf.Repeat(t: number, length: number)
    
    return math.clamp(t - math.floor(t/length) * length, 0, length)
end

--Interpolates between /min/ and /max/ with smoothing at the limits.
function Mathf.SmoothStep(from: number, to: number, t: number)
    t = math.clamp(t, 0, 1)
    t = -2 * t * t * t + 3 * t * t
    
    return to * t + from * (1 - t)
end

--PingPongs the value t, so that it is never larger than length and never smaller than 0.
function Mathf.PingPong(t: number, length: number)
    t = Mathf.Repeat(t, length * 2)
    
    return length - math.abs(t - length)
end

--Calculates the shortest difference between two given angles.
function Mathf.DeltaAngle(current: number, target: number)
    local delta = Mathf.Repeat((target - current), 360)
    
    if delta > 180 then
        delta -= 360
    end
    
    return delta
end

function Mathf.InverseLerp(a: number, b: number, value: number)
    if a ~= b then
        
        return math.clamp((value - a)/(b - a))
    else
       
        return 0
    end
end

--Gradually changes a value towards a desired goal over time.
function Mathf.SmoothDamp(current: number, target: number, currentVelocity: number, smoothTime: number, maxSpeed: number, deltaTime: number)
    smoothTime = math.max(0.0001, smoothTime)
    
    local omega = 2/smoothTime
    
    local x = omega * deltaTime
    local exp = 1/(1 + x + 0.48 * x * x + 0.235 * x * x * x)
    local change = current - target
    local originalTo = target
    
    --Clamp Maximum Speed
    local maxChange = maxSpeed * smoothTime
    change = math.clamp(change, -maxChange, maxChange)
    target = current - change
    
    local temp = (currentVelocity + omega * change) * deltaTime
    currentVelocity = (currentVelocity - omega * temp) * exp
    
    local output = target + (change + temp) * exp
    
    --Prevent overshooting
    if originalTo - current > 0 == output > originalTo then
        output = originalTo
        currentVelocity = (output - originalTo)/deltaTime
    end
    
    return output
end

--Gradually changes an angle given in degrees towards a desired goal angle over time.
function Mathf.SmoothDampAngle(current: number, target: number, currentVelocity: number, smoothTime: number, maxSpeed: number?, deltaTime: number)
    target = current + Mathf.DeltaAngle(current, target)
    
    return Mathf.SmoothDamp(current, target, currentVelocity, smoothTime, maxSpeed or math.huge, deltaTime)
end

--Infinite Line Intersection (line1 is p1-p2 and line2 is p3-p4)
function Mathf.LineIntersection(p1: Vector2, p2: Vector2, p3: Vector2, p4: Vector2)
    local result: Vector2
    
    local bx = p2.X - p1.X
    local by = p2.Y - p1.Y
    local dx = p4.X - p3.X
    local dy = p4.Y - p3.Y
    local bDotDPerp = bx * dy - by * dx
    
    if bDotDPerp == 0 then
        
        return false
    end
    
    local cx = p3.X - p1.X
    local cy = p3.Y - p1.Y
    local t = (cx * dy - cy * dx) / bDotDPerp
    
    result = Vector2.new(p1.X + t * bx, p1.Y + t * by)
    
    return result
end

--Line Segment Intersection (line1 is p1-p2 and line2 is p3-p4)
function Mathf.LineSegmentIntersection( p1: Vector2,  p2: Vector2,  p3: Vector2,  p4: Vector2)
    local bx = p2.X - p1.X
    local by = p2.Y - p1.Y
    local dx = p4.X - p3.X
    local dy = p4.Y - p3.Y
    local bDotDPerp = bx * dy - by * dx;
    
    if bDotDPerp == 0 then
        
        return false
    end
    
    local cx = p3.X - p1.X
    local cy = p3.Y - p1.Y
    local t = (cx * dy - cy * dx) / bDotDPerp
    
    if t < 0 or t > 1 then
        
        return false
    end
    
    local u = (cx * by - cy * bx) / bDotDPerp
    if u < 0 or u > 1 then
        
        return false
    end
    
    return Vector2.new(p1.X + t * bx, p1.Y + t * by)
end

--From https://github.com/FreyaHolmer/Mathfs/blob/master/Extensions.cs
function Mathf.Angle(v: Vector2)
	
	return math.atan2(v.Y, v.X)
end

function Mathf.Rotate(v: Vector2, angRad: number)
    local ca = math.cos(angRad)
    local sa = math.sin(angRad)
    
    return Vector2(ca * v.X - sa * v.Y, sa * v.X - ca * v.Y)
end

function Mathf.RotateAround(v: Vector2, pivot: Vector2, angRad: number)
    
    return Mathf.Rotate(v - pivot, angRad) + pivot
end

function Mathf.ClampMagnitude(v: Vector2 | Vector3, min: number, max: number)
    local mag = v.Magnitude
    
    if mag < min then
        local dir: Vector2 = v/mag
        
        return dir * min
    end
    
    if mag > max then
        local dir: Vector2 = v/mag
        
        return dir * max
    end
    
    return v
end

--Circles
function Mathf.RadiusToArea(radius: number)
    
    return radius * radius * (0.5 * Mathf.TAU)
end

function Mathf.AreaToRadius(area: number)
    
    return  math.sqrt(2 * area / Mathf.TAU)
end

function Mathf.AreaToCircumference(area: number)
    
    return  math.sqrt(2 * area / Mathf.TAU) * Mathf.TAU
end

function Mathf.CircumferenceToArea(circumference: number)
    
    return  circumference * circumference / (0.5 * Mathf.TAU)
end

function Mathf.RadiusToCircumference(radius: number)
    
    return  radius * Mathf.TAU
end

function Mathf.CircumferenceToRadius(circumference: number)
    
    return  circumference / Mathf.TAU
end

--Lines
function Mathf.GetPoint(origin: Vector2 | Vector3, dir: Vector2 | Vector3, t: number)
    
    return origin + t * dir
end

function Mathf.ProjectPointToLine(origin: Vector2 | Vector3, dir: Vector2 | Vector3, point: Vector2 | Vector3)
    local coord: Vector2 | Vector3 = point - origin
    local t = dir:Dot(coord)/dir:Dot(dir)
    
    return origin + dir * t
end

function Mathf.PointToPlaneSignedDistance(origin: Vector2 | Vector3, normal: Vector2 | Vector3, point: Vector2 | Vector3)
    
    return (point - origin):Dot(normal)
end

function Mathf.PointToPlaneDistance(origin: Vector2 | Vector3, normal: Vector2 | Vector3, point: Vector2 | Vector3)
    
    return math.abs(Mathf.PointToPlaneSignedDistance(origin, normal, point))
end


return Mathf