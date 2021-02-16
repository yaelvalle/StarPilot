local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Roact = require(ReplicatedStorage.Vendor.Roact)
local Flipper = require(ReplicatedStorage.Vendor.Flipper)

local ShipQuery = Roact.Component:extend("ShipQuery")

function ShipQuery:init(props)
    self.shipModel = nil
    
    if props.active then
        self.motor = Flipper.SingleMotor.new(1)
        
        self.shipModel = ReplicatedStorage.Functions.LoadAsset:InvokeServer(self.props.shipid)
        
        ReplicatedStorage.Events.LoadPreview:Fire(self.shipModel, self.props.shipName)
    else
        self.motor = Flipper.SingleMotor.new(0)
    end
    
    self.effect, self.setEffect = Roact.createBinding(self.motor:getValue())
    
    self.motor:onStep(self.setEffect)
end

function ShipQuery:willUpdate(props)
    if props.active then
        self.motor:setGoal(Flipper.Spring.new(1), {
            frequency = 5,
            dampingRatio = 1
        })
    else
        self.motor:setGoal(Flipper.Spring.new(0), {
            frequency = 5,
            dampingRatio = 1
        })
    end
end

function ShipQuery:render()
    return Roact.createElement("Frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(0.075, 0, 1, 0),
    }, {
        Roact.createElement("TextButton", {
            Text = self.props.shipName,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0.85, 0),
            BackgroundColor3 = Color3.new(0, 0, 0),
            TextColor3 = Color3.fromRGB(189, 189, 189),
            BackgroundTransparency = 0.5,
            [Roact.Event.Activated] = function()
                self.props.activated()
                
                self.shipModel = ReplicatedStorage.Functions.LoadAsset:InvokeServer(self.props.shipid)
                
                ReplicatedStorage.Events.LoadPreview:Fire(self.shipModel, self.props.shipName)
            end
        }),
        Roact.createElement("Frame", {
            AnchorPoint = Vector2.new(0.5, 1),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.new(0.913725, 0.784313, 0.047058),
            Position = UDim2.new(0.5, 0, 1, 0),
            Size = self.effect:map(function(value)
                return UDim2.new(0, 0, 0.15, 0):Lerp(UDim2.new(0.85, 0, 0.15, 0), value)
            end),
        })
    })
end

return ShipQuery