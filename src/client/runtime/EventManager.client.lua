local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Modules = script.Parent:WaitForChild("Modules")

local HangarManager = require(Modules.HangarManager)
local PlayerController = require(Modules.PlayerController)
local CameraController = require(Modules.CameraController)
local InputManager = require(Modules.InputManager)
local PlayerManager = require(Modules.PlayerManager)
local HUDManager = require(Modules.HUDManager)

local Roact = require(ReplicatedStorage.Vendor.Roact)

local Projectile = require(ReplicatedStorage.Modules.Projectile)

local Properties = require(script.Parent.Properties)

local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local Events = ReplicatedStorage.Events

HangarManager:Enable()

ReplicatedStorage.Events.PilotDeployed.OnClientEvent:Connect(function(player: Player, ship: Model)
    if player == Player then
        Properties.Ship = ship
        
        InputManager:Enable()
        PlayerController:Enable()
        CameraController:Enable()
        HangarManager:Disable()
        HUDManager:Enable()
    end
end)

local LeftShot = true

ReplicatedStorage.Events.FireWeapons.Event:Connect(function()
    local p = nil
    local speed = 3000
    
    if LeftShot then
       p = Projectile.new(Properties.Ship.Ship.RightGunLocation.WorldCFrame, Properties.Speed + speed, 1000)
        
        LeftShot = false
    else
        p = Projectile.new(Properties.Ship.Ship.LeftGunLocation.WorldCFrame, Properties.Speed + speed, 1000) 
        
        LeftShot = true
    end
end)