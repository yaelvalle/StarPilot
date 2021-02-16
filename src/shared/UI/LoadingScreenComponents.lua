local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Roact = require(ReplicatedStorage.Vendor.Roact)
local Flipper = require(ReplicatedStorage.Vendor.Flipper)

local LoadingScreen = Roact.Component:extend("LoadingScreen")

function LoadingScreen:init()
    self.motor = Flipper.SingleMotor.new(0)
    
    self.unmountTween, self.setUnmountTween = Roact.createBinding(self.motor:getValue())
    
    self.motor:onStep(self.setUnmountTween) 
end

function LoadingScreen:willUnmount()
    self.motor:setGoal(Flipper.Spring.new(1), {
        frequency = 5,
        dampingRatio = 1
    })
    
    while not self.motor._state.complete do
        wait()
    end
end

function LoadingScreen:render()
    return Roact.createElement("ScreenGui", {
        DisplayOrder = 100,
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
    }, {
        Roact.createElement("Frame",{
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = Color3.fromRGB(27, 27, 27),
            
            BackgroundTransparency = self.unmountTween:map(function(value)
                return value
            end)
        },{
            Roact.createElement("TextLabel",{
                Text = "Yael",
                AnchorPoint = Vector2.new(0.5, 0.5),
                Size = UDim2.new(0.25, 0, 0.25, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                TextColor3 = Color3.fromRGB(182, 182, 182),
                BackgroundTransparency = 1,
                TextTransparency = self.unmountTween:map(function(value)
                    return value
                end),
                Font = Enum.Font.PermanentMarker,
                TextSize = 100
            })
        })
    })
end

return LoadingScreen