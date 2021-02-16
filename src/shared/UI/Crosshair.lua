local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerScripts = Player.PlayerScripts

local Roact = require(ReplicatedStorage.Vendor.Roact)
local InputManager = require(PlayerScripts.Modules.InputManager)

local Crosshair = Roact.Component:extend("Crosshair")

--Amplifies the distance the crosshair moves
local multiplier = 100

function Crosshair:init()
    self.crosshair = Roact.createRef()
    self.update = nil
    self.position = Vector2.new(0, 0) 
end

function Crosshair:didMount()
    self.update = RunService.RenderStepped:Connect(function()
        self.position = InputManager.GetCrosshairPosition()
        
        self.crosshair:getValue().Position = UDim2.new(0.5, -self.position.X * multiplier, 0.5, -self.position.Y * multiplier)
    end)
end

function Crosshair:willUnmount()
    self.update:Disconnect()
end

function Crosshair:render()
    
    return Roact.createElement("ImageLabel",{
        Image = "rbxassetid://6373420981",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 50, 0, 50),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        [Roact.Ref] = self.crosshair
    })
end

return Crosshair