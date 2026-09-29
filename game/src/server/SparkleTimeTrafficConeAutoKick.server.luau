local Players = game:GetService("Players")

local SPARKLE_TIME_TRAFFIC_CONE_ASSET_ID = 151784526
local KICK_MESSAGE = "Sparkle Time Traffic Cone is not allowed in this experience."

local ACCESSORY_PROPERTIES = {
	"HatAccessory",
	"HairAccessory",
	"FaceAccessory",
	"NeckAccessory",
	"ShouldersAccessory",
	"FrontAccessory",
	"BackAccessory",
	"WaistAccessory",
}

local function descriptionHasAsset(description: HumanoidDescription, assetId: number): boolean
	local targetId = tostring(assetId)

	for _, propertyName in ACCESSORY_PROPERTIES do
		local accessoryIds = description[propertyName]

		if typeof(accessoryIds) == "string" then
			for id in string.gmatch(accessoryIds, "%d+") do
				if id == targetId then
					return true
				end
			end
		end
	end

	return false
end

local function checkCharacter(player: Player, character: Model)
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		humanoid = character:WaitForChild("Humanoid", 10)
	end

	if not humanoid or not player.Parent then
		return
	end

	local success, description = pcall(function()
		return humanoid:GetAppliedDescription()
	end)

	if not success or not description then
		warn(("Could not inspect avatar for %s"):format(player.Name))
		return
	end

	if descriptionHasAsset(description, SPARKLE_TIME_TRAFFIC_CONE_ASSET_ID) then
		player:Kick(KICK_MESSAGE)
	end
end

local function onPlayerAdded(player: Player)
	player.CharacterAppearanceLoaded:Connect(function(character)
		checkCharacter(player, character)
	end)

	if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
		task.defer(checkCharacter, player, player.Character)
	end
end

Players.PlayerAdded:Connect(onPlayerAdded)

for _, player in Players:GetPlayers() do
	task.spawn(onPlayerAdded, player)
end
