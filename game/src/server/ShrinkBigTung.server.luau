local Workspace = game:GetService("Workspace")

local TARGET_NAME = "bigtung"
local SCALE_FACTOR = 0.5

local function shrinkIfTarget(instance: Instance)
	if not instance:IsA("MeshPart") then
		return
	end

	if string.lower(instance.Name) ~= TARGET_NAME then
		return
	end

	instance.Size *= SCALE_FACTOR
end

for _, instance in Workspace:GetDescendants() do
	shrinkIfTarget(instance)
end

Workspace.DescendantAdded:Connect(function(instance)
	task.defer(shrinkIfTarget, instance)
end)
