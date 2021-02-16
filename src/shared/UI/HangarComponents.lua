local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContextActionService = game:GetService("ContextActionService")

local Roact = require(ReplicatedStorage.Vendor.Roact)

local Mathf = require(ReplicatedStorage.Modules.Mathf)

local ShipList = require(ReplicatedStorage.UI.ShipList)
local MenuBar = require(ReplicatedStorage.UI.MenuBar)

local HangarComponents = Roact.Component:extend("HangarComponents")

function HangarComponents:init()
    self.viewportFrame = Roact.createRef()
    self.uiContainer = Roact.createRef()
    
    self.previewModel = nil
    
    ReplicatedStorage.Events.LoadPreview.Event:Connect(function(model: Model, name: string)
        --Destroy the previous model
        if self.previewModel ~= nil then
            if self.previewModel.Name == name then
                model:Destroy()
                
                return    
            end
            
            self.previewModel:Destroy()
        end
        
        self.previewModel = model
        self.previewModel.Parent = self.viewportFrame:getValue()
    end)
    
    ReplicatedStorage.Events.Deploy.Event:Connect(function()
        ReplicatedStorage.Events.PreparePilotForLaunch:FireServer(self.previewModel)
    end)
end

function HangarComponents:didMount()
    self.viewportCamera = Instance.new("Camera")
    self.viewportSkySphere = ReplicatedStorage.Effects.ViewportSkySphere:Clone()
    
    self.viewportSkySphere:SetPrimaryPartCFrame(CFrame.new(0, 0, 0))
    self.viewportSkySphere.Parent = self.viewportFrame:getValue()
    
    self.viewportCamera.FieldOfView = 70
    self.viewportCamera.Parent = self.viewportFrame:getValue()
    self.viewportFrame:getValue().CurrentCamera = self.viewportCamera
    
    local cameraRotationActive: boolean = false
    local mouseDelta: Vector2 = Vector2.new(0, 0)
    
    local rotX, rotY = 0, 0
    local dRotX, dRotY = 0, math.rad(180)
    
    ContextActionService:BindAction("ToggleCameraRotationActive", function(_, state)
        self.cameraRotationActive = state == Enum.UserInputState.Begin
    end, false, Enum.UserInputType.MouseButton2)
    
    RunService:BindToRenderStep("HangarViewportUpdate", Enum.RenderPriority.Input.Value, function(deltaTime: number)
        if self.cameraRotationActive then
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
            mouseDelta = UserInputService:GetMouseDelta()
            
            dRotX += -math.rad(mouseDelta.Y) * deltaTime
            dRotY += -math.rad(mouseDelta.X) * deltaTime
            
            dRotX = math.clamp(dRotX, math.rad(-90), math.rad(90))
        else
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        end
        
        rotY = Mathf.Lerp(rotY, dRotY, 5 * deltaTime)
        rotX = Mathf.Lerp(rotX, dRotX, 5 * deltaTime)
        
        if self.previewModel then
            self.viewportCamera.CFrame = CFrame.fromEulerAnglesYXZ(rotX, rotY, 0) * CFrame.new(0, 0, 50)
        end
    end)
end

function HangarComponents:willUnmount()
    RunService:UnbindFromRenderStep("HangarViewportUpdate")
    ContextActionService:UnbindAction("ToggleCameraRotationActive")
end

function HangarComponents:render()
    
    return Roact.createElement("ScreenGui", {
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        [Roact.Ref] = self.uiContainer
    },  
    {
        Roact.createElement("ViewportFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
            [Roact.Ref] = self.viewportFrame
        },{
    }),
        Roact.createElement(MenuBar),
        Roact.createElement(ShipList),
    })
end

return HangarComponents