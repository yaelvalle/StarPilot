local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Vendor.Roact)

local HUDComponents = Roact.Component:extend("HUDComponents")

local Crosshair = require(ReplicatedStorage.UI.Crosshair)

function HUDComponents:init()
    
end

function HUDComponents:render()
    
    return Roact.createElement("ScreenGui",{
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
    },{
        Roact.createElement(Crosshair)
    })
end

return HUDComponents