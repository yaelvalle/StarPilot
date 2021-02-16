local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Vendor.Roact)
local ShipQuery = require(ReplicatedStorage.UI.ShipQuery)

local ShipData = require(ReplicatedStorage.Ships:WaitForChild("Data"))

local ShipQueries = Roact.Component:extend("ShipQueries")

function ShipQueries:init()
    self:setState({active = ShipData[1]})
end

function ShipQueries:render()
    local Ships = {}
    
    for i, v in pairs(ShipData) do
        Ships[i] = Roact.createElement(ShipQuery, {
            shipName = v.Name,
            shipid = v.Id,
            active = self.state.active == v,
            activated = function()
                self:setState({active = v})
            end
        })
    end
    
    return Roact.createFragment(Ships)
end

return ShipQueries