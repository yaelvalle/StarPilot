local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Projectile = {}

function Projectile.new(origin: CFrame, speed: number, maxRenderDistance)
   local self = {}
   
   self.gameObject = ReplicatedStorage.Prefabs.Projectile:Clone()
   self.gameObject.CFrame = origin
   
   self.gameObject.Parent = workspace
   
   self.projectUpdateConnection = nil
   
   self.projectUpdateConnection = RunService.RenderStepped:Connect(function(deltaTime)
        
       self.gameObject.Position = self.gameObject.Position + self.gameObject.CFrame.LookVector * speed * deltaTime
       
       if (self.gameObject.Position - origin.Position).Magnitude >= maxRenderDistance then
            self.projectUpdateConnection:Disconnect()
            
            self.gameObject:Destroy()
        end
   end)
   
   self.gameObject.Touched:Connect(function(object: Instance)
        if object.Name == "Ship" then
            self.projectUpdateConnection:Disconnect()
            
            self.gameObject:Destroy() 
        end
   end)
   
   return self
end


return Projectile