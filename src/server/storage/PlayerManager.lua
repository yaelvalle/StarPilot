local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerManager = {}

PlayerManager.ActivePlayers = {}
PlayerManager.InactivePlayers = {}

Players.PlayerAdded:Connect(function(player)
    table.insert(PlayerManager.InactivePlayers, player)
end)

local function MovePlayerFromTo(player: Player, from: table, to: table)
    for i, v in pairs(from) do
        if v == player then
            table.insert(to, v)  
        end
    end
end

function PlayerManager.PreparePlayer(player: Player)
    MovePlayerFromTo(player, PlayerManager.InactivePlayers, PlayerManager.ActivePlayers)
end




return PlayerManager