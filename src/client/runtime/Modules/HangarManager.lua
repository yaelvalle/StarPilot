local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--Modules
local Mathf = require(ReplicatedStorage.Modules.Mathf)

local Roact = require(ReplicatedStorage.Vendor.Roact)

--Data
local ShipData = require(ReplicatedStorage.Ships.Data)

--Roact Modules
local HangarComponents = require(ReplicatedStorage.UI.HangarComponents)

local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local Events = ReplicatedStorage. Events
local Functions = ReplicatedStorage.Functions

local HangarManager = {}

local previewModel: Model = nil
local previewCamera: Camera = nil

local DeployButtonConnection: RBXScriptConnection = nil 

local isCameraRotationActive: boolean = false

local cameraZoomRate: number = 15
local cameraZoomRange: NumberRange = NumberRange.new(30, 50)
local cameraDesiredZoomValue: number = cameraZoomRange.Max
local cameraCurrentZoomValue: number = cameraZoomRange.Max

local mouseDelta: Vector2 = Vector2.new(0, 0)

local cameraRotation: Vector3 = Vector3.new(0, 0, 0)

--Roact Trees
local HangarInterface_TREE: RoactTree = nil 
local HangarInterface = Roact.createElement(HangarComponents)

function HangarManager:Enable()
    HangarInterface_TREE = Roact.mount(HangarInterface, PlayerGui, "Hangar")
end

function HangarManager:Disable()
    Roact.unmount(HangarInterface_TREE)
end

return HangarManager