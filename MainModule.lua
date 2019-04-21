-- THIS IS A MAINMODULE.
-- This is the parent. All the folders in this repository is a child of this script.

function Load()
	for _,v in pairs(script:GetChildren()) do
		if game:FindFirstChild(v.Name) then
			for _,x in pairs(v:GetChildren()) do
				x.Parent = game[v.Name]
			end
		elseif game.StarterPlayer:FindFirstChild(v.Name) then
			for _,x in pairs(v:GetChildren()) do
				x.Parent = game.StarterPlayer[v.Name]
			end
		end
	end
end

return Load
