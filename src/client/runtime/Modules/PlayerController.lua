local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Properties = require(script.Parent.Parent.Properties)
local InputManager = require(script.Parent.InputManager)

local ShipData = require(ReplicatedStorage.Ships.Data)
local Mathf = require(ReplicatedStorage.Modules.Mathf)


local PlayerController = {}

local CurrentShipData = nil

local velocity: Vector3 = Vector3.new(0, 0, 0)
local angularVelocity: CFrame = CFrame.fromEulerAnglesYXZ(0, 0, 0)

local lookVector: Vector3 = Vector3.new(0, 0, 0)
local rightVector: Vector3 = Vector3.new(0, 0, 0)
local crosshairPosition: Vector2 = Vector2.new(0, 0)

local rotationOffsetZ = 0

local AccelerationRate: NumberSequence = NumberSequence.new({
    NumberSequenceKeypoint.new(0.0, 0.25),
    NumberSequenceKeypoint.new(0.25, 0.25),
    NumberSequenceKeypoint.new(0.5, 1),
    NumberSequenceKeypoint.new(0.7, 1),
    NumberSequenceKeypoint.new(0.85, 0.75),
    NumberSequenceKeypoint.new(1, 0.5),
})

local function GetValueFromSequenceAt(sequence: NumberSequence, sequenceTime: number)
    if sequenceTime <= 0 then
        return sequence.Keypoints[1].Value
    end
    
    if sequenceTime >= 1 then
        return sequence.Keypoints[#sequence.Keypoints].Value
    end
    
    for i = 1, #sequence.Keypoints - 1 do
		local key1 = sequence.Keypoints[i]
        local key2 = sequence.Keypoints[i + 1]
        
		if sequenceTime >= key1.Time and sequenceTime < key2.Time then
			-- Calculate how far alpha lies between the points
			local alpha = (sequenceTime - key1.Time) / (key2.Time - key1.Time)
            
			-- Evaluate the real value between the points using alpha
			return (key2.Value - key1.Value) * alpha + key1.Value
		end
	end
end

local function SearchForShipData(name: string)
    for _, v in pairs(ShipData) do
        if v.Name == name then
            
            return v
        end
    end
end

function PlayerController:Enable()
    CurrentShipData = SearchForShipData(Properties.Ship.ShipName.Value)
    
    RunService:BindToRenderStep("PLAYERCONTROLLER_UPDATE", Enum.RenderPriority.First.Value, function(deltaTime: number)
        crosshairPosition = InputManager.GetCrosshairPosition() * 10
        
        lookVector = Properties.Ship:GetPrimaryPartCFrame().LookVector
        rightVector = Properties.Ship:GetPrimaryPartCFrame().RightVector
        
        Properties.Acceleration = GetValueFromSequenceAt(AccelerationRate, Properties.Speed/CurrentShipData.MaxSpeed) * CurrentShipData.MaxAcceleration
        
        Properties.DesiredSpeed += Properties.Thrust * Properties.Acceleration * deltaTime
        Properties.DesiredSpeed = math.clamp(Properties.DesiredSpeed, 0, CurrentShipData.MaxSpeed)
        
        Properties.Speed = Mathf.Lerp(Properties.Speed, Properties.DesiredSpeed,  Properties.Acceleration * deltaTime)
        
        velocity = (lookVector * Properties.Speed) + (rightVector * Properties.Strafe)
        angularVelocity = CFrame.fromEulerAnglesYXZ(math.rad(Properties.Pitch), math.rad(Properties.Yaw), math.rad(Properties.Roll))
        
        rotationOffsetZ = Mathf.Lerp(rotationOffsetZ, math.rad(crosshairPosition.X), 0.1)   
        
        Properties.Ship:TranslateBy(velocity * deltaTime)
        Properties.Ship:SetPrimaryPartCFrame(Properties.Ship:GetPrimaryPartCFrame() * angularVelocity)
        
        Properties.Ship.Ship.CFrame = Properties.Ship:GetPrimaryPartCFrame() * CFrame.fromEulerAnglesYXZ(0, 0, rotationOffsetZ)
    end)
end

function PlayerController:Disable()
    RunService:UnbindFromRenderStep("PLAYERCONTROLLER_UPDATE")
    CurrentShipData = nil
end

return PlayerController