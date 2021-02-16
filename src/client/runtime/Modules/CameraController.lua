local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Mathf = require(ReplicatedStorage.Modules.Mathf)

local InputManager = require(script.Parent.InputManager)

local Properties = require(script.Parent.Parent.Properties)
local Settings = require(script.Parent.Parent.Settings)

local Camera = workspace.CurrentCamera

local CameraController = {}

local Starfield = ReplicatedStorage.Effects.Starfield:Clone()

local crosshairPosition: Vector2 = Vector2.new(0, 0)

local cameraX: number = 0
local cameraY: number = 0

function CameraController:Enable()
    Starfield.Parent = Camera 
    Camera.FieldOfView = 40
    
    RunService:BindToRenderStep("CAMERACONTROLLER_UPDATE", Enum.RenderPriority.First.Value, function(deltaTime: number)
        crosshairPosition = InputManager.GetCrosshairPosition()
        
        cameraX = Mathf.Lerp(cameraX, -crosshairPosition.X * 10, 0.1)
        cameraY = Mathf.Lerp(cameraY, Settings.Camera.Height + crosshairPosition.Y * 3, 0.1)
        
        Camera.CFrame = Properties.Ship:GetPrimaryPartCFrame() * CFrame.new(cameraX, cameraY, Settings.Camera.Distance)
        Starfield.CFrame = Camera.CFrame
    end)
end

function CameraController:Disable()
    RunService:UnbindFromRenderStep("CAMERACONTROLLER_UPDATE")
    Starfield.Parent = nil
end

return CameraController