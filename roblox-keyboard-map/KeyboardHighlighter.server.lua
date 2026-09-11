-- Poné este Script DENTRO del Model/Folder del teclado en Workspace
-- (el que contiene todas las Parts de las teclas).
--
-- Ilumina de verde SOLO las teclas R, O, B, U, X y Enter al pisarlas.
-- Cada tecla debe tener su Name exacto (por ejemplo "R", "Enter").

local TARGET_KEYS = {
	["R"] = true,
	["O"] = true,
	["B"] = true,
	["U"] = true,
	["X"] = true,
	["ENTER"] = true,
}

local LIT_COLOR = Color3.fromRGB(0, 255, 0)

for _, key in ipairs(script.Parent:GetDescendants()) do
	if key:IsA("BasePart") and TARGET_KEYS[string.upper(key.Name)] then
		local lit = false

		key.Touched:Connect(function(hit)
			local humanoid = hit.Parent and hit.Parent:FindFirstChildOfClass("Humanoid")
			if lit or not humanoid then
				return
			end

			lit = true
			key.Color = LIT_COLOR
		end)
	end
end
