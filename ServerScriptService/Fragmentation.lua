local Debris = game:GetService("Debris")

local fragmentPart = Instance.new("BindableEvent")
local tau = math.pi * 2

local function rollAngles(count)
	local result = {}
	
	for i = 1,count do
		result[i] = math.random() * tau
	end
	
	return unpack(result)
end

local function subtract(part, negativePart, collisionFidelity)
	if part:IsDescendantOf(workspace) then
		local sub = {negativePart}
		return part:SubtractAsync(sub, collisionFidelity)
	end
end

local function onFragmentPart(part, depth)
	if not part:IsDescendantOf(workspace) then
		return
	end
	
	local depth = depth or 0
	if depth > 4 then
		return
	end

	local size = part.Size
	if size.X < 1 or size.Y < 1 or size.Z < 1 then
		return
	end
	
	local magnitude = size.Magnitude
	if magnitude < 6 then
		return
	end
	
	local cf = part.CFrame
	local rx,ry,rz = rollAngles(3)
	local cutPlane = cf * CFrame.Angles(rx, ry, rz)
	
	local cut0 = Instance.new("Part")
	cut0.Size = size*4
	cut0.CFrame = cutPlane * CFrame.new(0,-size.Y*2,0)
	
	local cut1 = cut0:Clone()
	cut1.CFrame = cutPlane * CFrame.new(0,size.Y*2,0)
	
	local part0, part1
	
	pcall(function ()
		part0 = subtract(part, cut0, "Hull")
		part1 = subtract(part, cut1, "Hull")
	end)

	if part0 and part1 then
		local parent = part.Parent
		local velocity = part.Velocity
		local rotVel = part.RotVelocity
		part:Destroy()
		
		local c0 = cf:toObjectSpace(part0.CFrame)
		part0.CFrame = part.CFrame * c0
		part0.Velocity = velocity
		part0.RotVelocity = rotVel
		part0.Parent = parent

		local c1 = cf:toObjectSpace(part1.CFrame)
		part1.CFrame = part.CFrame * c1
		part1.Velocity = velocity
		part1.RotVelocity = rotVel
		part1.Parent = parent
		
		-- Recursively fragment
		fragmentPart:Fire(part0, depth+1)
		fragmentPart:Fire(part1, depth+1)
	end
end

local function onDescendantAdded(desc)
	if desc:IsA("Explosion") then
		local hasHit = {}

		local function onExplosionHit(hit)
			if not (hasHit[hit] or hit.Anchored or hit:FindFirstChildOfClass("FileMesh")) then
				hasHit[hit] = true
				fragmentPart:Fire(hit)
			end
		end

		local hitSignal = desc.Hit:Connect(onExplosionHit)
		
		delay(3,function ()
			-- Garbage collect after the explosion is gone.
			hitSignal:Disconnect()
			hasHit = nil
		end)
	end
end

fragmentPart.Event:Connect(onFragmentPart)
workspace.DescendantAdded:Connect(onDescendantAdded)