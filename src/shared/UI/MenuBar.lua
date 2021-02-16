local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Vendor.Roact)

local MenuBar = Roact.Component:extend("MenuBar")


function MenuBar:init()
    
end

function MenuBar:render()
    
    return Roact.createElement("Frame", {
        Size = UDim2.new(1, 0, 0.1, 0),
        BackgroundColor3 = Color3.fromRGB(23, 23, 23),  
        BackgroundTransparency = 0.5
    },{
        Roact.createElement("TextButton",{
            Text = "Deploy",
            BackgroundColor3 = Color3.fromRGB(235, 180, 0),
            BorderSizePixel = 0,
            TextColor3 = Color3.fromRGB(23, 23, 23),
            Font = Enum.Font.PermanentMarker,
            TextScaled = true,  
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(0.1, 0, 0.5, 0),
            [Roact.Event.MouseButton1Click] = function()
                ReplicatedStorage.Events.Deploy:Fire()
            end
        })
    })
end

return MenuBar
