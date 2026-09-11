-- Poné este Script directo en Workspace y dale Play.
--
-- Arma un teclado gigante tirado sobre pasto (si todavía no existe) y
-- hace que SOLO las teclas R, O, B, U, X y Enter se iluminen de verde
-- al pisarlas. El resto de las teclas no hacen nada.
--
-- Si ya le diste Play una vez y tocaste algo a mano en Studio (moviste
-- una tecla, le cambiaste el color, etc.), el script no lo pisa: solo
-- construye el teclado si todavía no existe un Model "Keyboard".
--
-- IMPORTANTE: usá el botón "Play" (F5), no "Run" (F8) -- Run no pone
-- un personaje en el mundo, así que no hay nadie a quien teletransportar
-- y la cámara se queda donde estaba antes de correr el script.

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local KEY_SIZE = 4    -- studs (ancho/profundidad de una tecla normal)
local GAP = 0.5       -- studs entre teclas
local THICKNESS = 1.5 -- alto de cada tecla

-- Cada fila es una lista de teclas {texto, ancho_en_unidades}.
-- 1 unidad de ancho = KEY_SIZE.
local ROWS = {
	{ {"Esc",1}, {"1",1}, {"2",1}, {"3",1}, {"4",1}, {"5",1}, {"6",1}, {"7",1}, {"8",1}, {"9",1}, {"0",1} },
	{ {"Tab",1.5}, {"Q",1}, {"W",1}, {"E",1}, {"R",1}, {"T",1}, {"Y",1}, {"U",1}, {"I",1}, {"O",1}, {"P",1} },
	{ {"Bloq Mayus",1.75}, {"A",1}, {"S",1}, {"D",1}, {"F",1}, {"G",1}, {"H",1}, {"J",1}, {"K",1}, {"L",1}, {"Enter",2} },
	{ {"Shift",2.25}, {"Z",1}, {"X",1}, {"C",1}, {"V",1}, {"B",1}, {"N",1}, {"M",1}, {"Shift",2.25} },
	{ {"Ctrl",1.5}, {"Win",1}, {"Alt",1}, {"Space",6}, {"Alt",1}, {"Win",1}, {"Ctrl",1.5} },
}

local TARGET_KEYS = {
	["R"] = true, ["O"] = true, ["B"] = true,
	["U"] = true, ["X"] = true, ["ENTER"] = true,
}
local LIT_COLOR = Color3.fromRGB(0, 255, 0)

local function createKeyPart(label, width, cframe, parent)
	local key = Instance.new("Part")
	key.Name = label
	key.Anchored = true
	key.Material = Enum.Material.SmoothPlastic
	key.Color = Color3.fromRGB(255, 255, 255)
	key.Size = Vector3.new(width, THICKNESS, KEY_SIZE)
	key.CFrame = cframe
	key.Parent = parent

	local gui = Instance.new("SurfaceGui")
	gui.Face = Enum.NormalId.Top
	gui.Parent = key

	local text = Instance.new("TextLabel")
	text.Size = UDim2.new(1, 0, 1, 0)
	text.BackgroundTransparency = 1
	text.Text = label
	text.TextScaled = true
	text.Font = Enum.Font.GothamBold
	text.TextColor3 = Color3.fromRGB(40, 40, 40)
	text.Parent = gui

	return key
end

local function buildKeyboard()
	local keyboard = Instance.new("Model")
	keyboard.Name = "Keyboard"

	local rowDepth = KEY_SIZE + GAP

	for rowIndex, row in ipairs(ROWS) do
		local totalWidth = -GAP
		for _, keyData in ipairs(row) do
			totalWidth = totalWidth + keyData[2] * KEY_SIZE + GAP
		end

		local x = -totalWidth / 2
		local z = (rowIndex - 1) * rowDepth

		for _, keyData in ipairs(row) do
			local label, widthUnits = keyData[1], keyData[2]
			local width = widthUnits * KEY_SIZE + (widthUnits - 1) * GAP

			createKeyPart(label, width, CFrame.new(x + width / 2, THICKNESS / 2, z), keyboard)

			x = x + width + GAP
		end
	end

	keyboard.Parent = Workspace
	return keyboard
end

local function buildGround()
	local totalDepth = #ROWS * (KEY_SIZE + GAP)

	local ground = Instance.new("Part")
	ground.Name = "Ground"
	ground.Anchored = true
	ground.Material = Enum.Material.Grass
	ground.Color = Color3.fromRGB(74, 155, 72)
	ground.Size = Vector3.new(140, 1, 140)
	ground.CFrame = CFrame.new(0, -0.5, totalDepth / 2)
	ground.Parent = Workspace
end

local function highlightTargetKeys(keyboard)
	for _, key in ipairs(keyboard:GetDescendants()) do
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
end

-- El teclado se arma siempre en (0,0,0). Si tu mapa ya tenía otro
-- spawn en otro lado del mundo, ibas a aparecer lejos y no ibas a
-- ver nada: por eso acá abajo se teletransporta al jugador justo
-- enfrente del teclado apenas aparece, sin importar dónde esté el
-- SpawnLocation.
local START_CFRAME = CFrame.new(0, THICKNESS + 3, -10)

local function moveCharacterToKeyboard(character)
	local root = character:WaitForChild("HumanoidRootPart", 5)
	if root then
		character:PivotTo(START_CFRAME)
	end
end

local function onPlayerAdded(player)
	player.CharacterAdded:Connect(moveCharacterToKeyboard)
	if player.Character then
		moveCharacterToKeyboard(player.Character)
	end
end

for _, player in ipairs(Players:GetPlayers()) do
	onPlayerAdded(player)
end
Players.PlayerAdded:Connect(onPlayerAdded)

local keyboard = Workspace:FindFirstChild("Keyboard")
if not keyboard then
	keyboard = buildKeyboard()
	buildGround()
	print("[KeyboardMap] Teclado creado en Workspace.Keyboard (busca 'Keyboard' y 'Ground' en el Explorer si no lo ves).")
end

highlightTargetKeys(keyboard)
