while wait(1) do
self = script.Parent
c = workspace.CurrentCamera

player = game.Players.LocalPlayer
char = player.Character or player.CharacterAdded:wait()
humanoid = char:WaitForChild("Humanoid")
function ok()
humanoid.CameraOffset = Vector3.new(0,0,-1.2)
end
function ok2()
humanoid.CameraOffset = Vector3.new(0,-1,-1.2)
end
function ok3()
humanoid.CameraOffset = Vector3.new(0,-3,-1.2)
end

-- Apply some properties

player.CameraMaxZoomDistance = 8
if humanoid.CameraOffset == Vector3.new(0,0,0) then
ok()
elseif humanoid.CameraOffset == Vector3.new(0,0,-1.2) then
ok()
elseif
humanoid.CameraOffset == Vector3.new(0,-1,-1.2) then
ok2()
elseif
humanoid.CameraOffset == Vector3.new(0,-3,-1.2) then
ok3()
end
	

function lock(part)
	if part and part:IsA("BasePart") then
		part.LocalTransparencyModifier = part.Transparency
		part.Changed:connect(function (property)
			part.LocalTransparencyModifier = part.Transparency
		end)
	end
end

for _,v in pairs(char:GetChildren()) do
	lock(v)
end

char.ChildAdded:connect(lock)

c.Changed:connect(function (property)
	if property == "CameraSubject" then
		if c.CameraSubject and c.CameraSubject:IsA("VehicleSeat") and humanoid then
			-- Vehicle seats try to change the camera subject to the seat itself. This isn't what we wan't really.
			c.CameraSubject = humanoid;
		end
	end
end)
end