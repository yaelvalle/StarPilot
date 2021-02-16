local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Settings = require(script.Parent.Parent.Settings)
local Properties = require(script.Parent.Parent.Properties)

local ShipData = require(ReplicatedStorage.Ships.Data)
local Mathf = require(ReplicatedStorage.Modules.Mathf)

local Camera = workspace.CurrentCamera

local InputManager = {}

local CurrentShipData = nil

local thrustForward: number, thrustBackward: number = 0, 0
local rollLeft: number, rollRight: number = 0, 0

local crosshairPosition: Vector2 = Vector2.new(0, 0)

local mouseDelta: Vector2 = nil

local isFiring: boolean = false
local fireRate: number = 1/8   
local lastTimeFired: number = os.clock()

local crosshairRadius = 2

local function SearchForShipData(name: string)
    for _, v in pairs(ShipData) do
        if v.Name == name then
            
            return v
        end
    end
end

function InputManager.GetCrosshairPosition()
    
    return crosshairPosition
end

function InputManager:Enable()
    CurrentShipData = SearchForShipData(Properties.Ship.Name)
    
    RunService:BindToRenderStep("INPUTMANAGER_UPDATE", Enum.RenderPriority.Input.Value, function(deltaTime: number)
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        UserInputService.MouseIconEnabled = false
        
        mouseDelta = UserInputService:GetMouseDelta()
        
        if isFiring then
            if os.clock() - lastTimeFired >= fireRate then
                ReplicatedStorage.Events.FireGuns:FireServer(Properties.Ship, CurrentShipData)
                ReplicatedStorage.Events.FireWeapons:Fire()
                
                lastTimeFired = os.clock()
            end
        end
        
        crosshairPosition = crosshairPosition - (Vector2.new(mouseDelta.X, mouseDelta.Y) * deltaTime) 
        crosshairPosition = Mathf.ClampMagnitude(crosshairPosition, 0, crosshairRadius)
        
        Properties.Thrust = thrustForward - thrustBackward
        
        Properties.Roll = Mathf.Lerp(Properties.Roll, rollLeft - rollRight, 0.05)
        Properties.Roll = math.clamp(Properties.Roll, -1, 1)
    end)
    
    ContextActionService:BindAction("FireWeapon", function(_, state)
        isFiring = state == Enum.UserInputState.Begin
    end, false, Enum.UserInputType.MouseButton1)
    
    ContextActionService:BindAction("RotateShip", function(_, state, inputObject)
        Properties.Yaw = crosshairPosition.X
        
        Properties.Pitch = crosshairPosition.Y
        
    end, false, Settings.KeyBindings.RotateShipInput)
    
    ContextActionService:BindAction("ThrottleIncrease", function(_, state)
        if state == Enum.UserInputState.Begin then
            thrustForward = 1
        else
            thrustForward = 0 
        end
    end, false, Settings.KeyBindings.ThrustForwardKey)
    
    ContextActionService:BindAction("ThrottleDecrease", function(_, state)
        if state == Enum.UserInputState.Begin then
            thrustForward = 1
        else
            thrustForward = 0 
        end
    end, false, Settings.KeyBindings.ThrustForwardKey)
    
    ContextActionService:BindAction("ThrustBackward", function(_, state)
        if state == Enum.UserInputState.Begin then
            thrustBackward = 1
        else
            thrustBackward = 0 
        end
    end, false, Settings.KeyBindings.ThrustBackwardKey)
    
    ContextActionService:BindAction("RollLeft", function(_, state)
        if state == Enum.UserInputState.Begin then
            rollLeft = 1
        else
            rollLeft = 0 
        end
    end, false, Settings.KeyBindings.RollLeftKey)
    
    ContextActionService:BindAction("RollRight", function(_, state)
        if state == Enum.UserInputState.Begin then
            rollRight = 1
        else
            rollRight = 0 
        end
    end, false, Settings.KeyBindings.RollRightKey)
end

function InputManager:Disable()
    RunService:UnbindFromRenderStep("INPUTMANAGER_UPDATE")
    
    ContextActionService:UnbindAction("RollRight")
    ContextActionService:UnbindAction("RollLeft")
    ContextActionService:UnbindAction("ThrottleDecrease")
    ContextActionService:UnbindAction("ThrottleIncrease")
    ContextActionService:UnbindAction("RotateShip")
end

return InputManager