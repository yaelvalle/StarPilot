local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui
local PlayerScripts = Player.PlayerScripts

local Roact = require(ReplicatedStorage:WaitForChild("Vendor").Roact)

local LoadingScreenComponents: RoactComponent = require(ReplicatedStorage.UI.LoadingScreenComponents)

local LoadingScreen = Roact.createElement(LoadingScreenComponents)

local LoadingScreen_TREE: RoactTree = nil

StarterGui:SetCore("TopbarEnabled", false)
ReplicatedFirst:RemoveDefaultLoadingScreen()

LoadingScreen_TREE = Roact.mount(LoadingScreen, PlayerGui, "LoadingScreen")

if not game.IsLoaded then
    game.Loaded:Wait()
end

Roact.unmount(LoadingScreen_TREE)