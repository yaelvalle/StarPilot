local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerScripts = Player.PlayerScripts

local Roact = require(ReplicatedStorage.Vendor.Roact)

local SettingsComponents = Roact.Component:extend("SettingsComponents")

function SettingsComponents:init()
    
end

function SettingsComponents:render()
    return Roact.createElement("ScreenGui")
end

return SettingsComponents