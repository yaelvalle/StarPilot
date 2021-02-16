local Utils = {}

function Utils.ServerFindPlayerShip(player: string)
	for _, v: Model in pairs(workspace:GetChildren()) do
		if v:IsA("Model") and v.Name ~= "Markers" then
			print(v)
		end
	end
end


return Utils