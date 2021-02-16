local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Cmdr = require(ReplicatedStorage:WaitForChild("CmdrClient"))

local PlayerManager = {}

Cmdr:SetActivationKeys({Enum.KeyCode.Tilde})

return PlayerManager