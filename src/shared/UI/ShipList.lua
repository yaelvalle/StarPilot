local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Vendor.Roact)

local ShipQueries = require(ReplicatedStorage.UI.ShipQueries)

local ShipList = Roact.Component:extend("ShipList")

function ShipList:init()
    
end

function ShipList:render()
    return Roact.createElement("ScrollingFrame", {
        AnchorPoint = Vector2.new(0.5, 1), 
        Position = UDim2.new(0.5, 0, 1, -50),
        Size = UDim2.new(1, 0, 0.15, 0),
        ScrollingDirection = Enum.ScrollingDirection.X,
        CanvasSize = UDim2.new(2, 0, 0, 0),
        BackgroundTransparency = 1,
        ScrollBarImageTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 0
    },{
        ListLayout = Roact.createElement("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
        }),
        Queries = Roact.createElement(ShipQueries)
    })
end

return ShipList