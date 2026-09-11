-- ServerScriptService/KeyboardHighlighter.server.lua
--
-- Ilumina de verde SOLO las teclas R, O, B, U, X y Enter cuando un
-- jugador las pisa. El resto de las teclas del teclado no hacen nada.
--
-- Requisito en el mapa: un Folder (o Model) en Workspace llamado
-- "Keyboard" que contenga una BasePart por cada tecla, nombrada
-- exactamente como esa tecla (por ejemplo: "R", "O", "B", "U", "X",
-- "Enter", "Q", "W", "Ctrl", etc.). Pueden estar agrupadas en
-- carpetas/filas dentro de "Keyboard", el script las encuentra igual.

local TweenService = game:GetService("TweenService")

local keyboard = workspace:WaitForChild("Keyboard")

-- Nombres de partes que deben iluminarse (en mayúsculas para comparar
-- sin importar cómo las hayan escrito). Se agregan un par de alias
-- comunes para la tecla Enter por si la nombraron distinto.
local TARGET_KEYS = {
	["R"] = true,
	["O"] = true,
	["B"] = true,
	["U"] = true,
	["X"] = true,
	["ENTER"] = true,
	["INTRO"] = true,
	["RETURN"] = true,
}

local LIT_COLOR = Color3.fromRGB(0, 255, 0)
local TWEEN_INFO = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Confirma que lo que tocó la tecla es el personaje de un jugador vivo
-- (y no un objeto suelto, una parte del propio teclado, etc.)
local function isPlayerCharacterPart(part)
	local model = part:FindFirstAncestorOfClass("Model")
	if not model then
		return false
	end

	local humanoid = model:FindFirstChildOfClass("Humanoid")
	return humanoid ~= nil and humanoid.Health > 0
end

local function setupKey(key)
	if not key:IsA("BasePart") then
		return
	end

	if not TARGET_KEYS[string.upper(key.Name)] then
		return
	end

	local lit = false

	key.Touched:Connect(function(hit)
		if lit then
			return
		end

		if not isPlayerCharacterPart(hit) then
			return
		end

		lit = true
		TweenService:Create(key, TWEEN_INFO, { Color = LIT_COLOR }):Play()
	end)
end

for _, key in ipairs(keyboard:GetDescendants()) do
	setupKey(key)
end

-- Por si agregan/streamean teclas después de que arrancó el servidor.
keyboard.ChildAdded:Connect(setupKey)
