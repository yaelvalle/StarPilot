local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--Modules
local Mathf = require(ReplicatedStorage.Modules.Mathf)

local Roact = require(ReplicatedStorage.Vendor.Roact)

--Data
local ShipData = require(ReplicatedStorage.Ships.Data)

--Roact Modules
local HUDComponents = require(ReplicatedStorage.UI.HUDComponents)

local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local Events = ReplicatedStorage. Events
local Functions = ReplicatedStorage.Functions

local HUDManager = {}

local mouseDelta: Vector2 = Vector2.new(0, 0)

local cameraRotation: Vector3 = Vector3.new(0, 0, 0)

--Roact Trees
local HUDInterface_TREE: RoactTree = nil 
local HUDInterface = Roact.createElement(HUDComponents)

function HUDManager:Enable()
    HUDInterface_TREE = Roact.mount(HUDInterface, PlayerGui, "HUD")
end

function HUDManager:Disable()
    Roact.unmount(HUDInterface_TREE)
end

return HUDManager