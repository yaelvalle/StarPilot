local ServerStorage = game:GetService("ServerStorage")
local InsertService = game:GetService("InsertService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerManager = require(ServerStorage.PlayerManager)
local Utils = require(ReplicatedStorage.Modules.Utils)

ReplicatedStorage.Functions.LoadAsset.OnServerInvoke = function(player, assetId)
    local asset = InsertService:LoadAsset(assetId)
    
    asset.Parent = player
    
    return asset
end

ReplicatedStorage.Events.FireGuns.OnServerEvent:Connect(function(player, ship, shipData)
    
end)

local function CreateRootPart(parent: Instance)
    local rootPart = Instance.new("Part")
    rootPart.Size = Vector3.new(1, 1, 1)
    rootPart.Anchored = true
    rootPart.CanCollide = false
    
    rootPart.Parent = parent
    
    return rootPart
end

ReplicatedStorage.Events.PreparePilotForLaunch.OnServerEvent:Connect(function(player: Player, ship: Model, shipSkin: string)
    PlayerManager.PreparePlayer(player)
    
    ship.Name = player.Name
    ship.PrimaryPart = CreateRootPart(ship)
    ship.Parent = workspace

    ReplicatedStorage.Events.PilotDeployed:FireAllClients(player, ship)
end)


