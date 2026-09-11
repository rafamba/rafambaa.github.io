local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

--------------------------------------------------
-- BORRAR MAPA ANTERIOR
--------------------------------------------------

local oldMap = Workspace:FindFirstChild("TECLADO_ROBUX")

if oldMap then
	oldMap:Destroy()
end

local map = Instance.new("Folder")
map.Name = "TECLADO_ROBUX"
map.Parent = Workspace

--------------------------------------------------
-- COLORES
--------------------------------------------------

local WHITE = Color3.fromRGB(245,245,245)
local BLACK = Color3.fromRGB(25,28,35)
local GREEN = Color3.fromRGB(40,255,70)
local GRASS = Color3.fromRGB(80,170,90)
local ROCK = Color3.fromRGB(100,100,100)

--------------------------------------------------
-- TECLAS ESPECIALES
--------------------------------------------------

local specialKeys = {
	R = true,
	O = true,
	B = true,
	U = true,
	X = true,
	ENTER = true
}

--------------------------------------------------
-- ILUMINACION
--------------------------------------------------

Lighting.ClockTime = 14
Lighting.Brightness = 2.5
Lighting.Ambient = Color3.fromRGB(120,120,120)
Lighting.OutdoorAmbient = Color3.fromRGB(150,150,150)

--------------------------------------------------
-- CREAR PARTE
--------------------------------------------------

local function createPart(name, size, position, color, material)

	local part = Instance.new("Part")

	part.Name = name
	part.Size = size
	part.Position = position

	part.Anchored = true
	part.CanCollide = true

	part.Color = color
	part.Material = material or Enum.Material.SmoothPlastic

	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth

	part.Parent = map

	return part
end

--------------------------------------------------
-- PISO COMPLETO DE PASTO
--------------------------------------------------

createPart(
	"Grass",
	Vector3.new(400,1,400),
	Vector3.new(0,0,0),
	GRASS,
	Enum.Material.Grass
)

--------------------------------------------------
-- BASE DEL TECLADO
--------------------------------------------------

createPart(
	"KeyboardBase",
	Vector3.new(100,1.5,48),
	Vector3.new(0,1,0),
	BLACK,
	Enum.Material.SmoothPlastic
)

--------------------------------------------------
-- MONTAÑAS LEJANAS
--------------------------------------------------

local function createMountain(x,z,height,width)

	local mountain = Instance.new("WedgePart")

	mountain.Name = "Mountain"

	mountain.Size = Vector3.new(
		width,
		height,
		width
	)

	mountain.Position = Vector3.new(
		x,
		height / 2,
		z
	)

	mountain.Anchored = true
	mountain.CanCollide = true

	mountain.Color = ROCK
	mountain.Material = Enum.Material.Rock

	mountain.Orientation = Vector3.new(
		0,
		math.random(0,360),
		0
	)

	mountain.Parent = map

end

--------------------------------------------------
-- MONTAÑAS ATRAS
--------------------------------------------------

for x = -170,170,35 do

	createMountain(
		x,
		-170,
		math.random(35,60),
		math.random(25,40)
	)

end

--------------------------------------------------
-- MONTAÑAS ENFRENTE
--------------------------------------------------

for x = -170,170,35 do

	createMountain(
		x,
		170,
		math.random(35,60),
		math.random(25,40)
	)

end

--------------------------------------------------
-- MONTAÑAS IZQUIERDA
--------------------------------------------------

for z = -130,130,40 do

	createMountain(
		-180,
		z,
		math.random(35,55),
		math.random(25,38)
	)

end

--------------------------------------------------
-- MONTAÑAS DERECHA
--------------------------------------------------

for z = -130,130,40 do

	createMountain(
		180,
		z,
		math.random(35,55),
		math.random(25,38)
	)

end

--------------------------------------------------
-- TEXTO DE LA TECLA
--------------------------------------------------

-- OJO: en la cara "Top" de un SurfaceGui, Roblox mapea el ANCHO del
-- lienzo al Size.Z de la parte (el lado corto) y el ALTO al Size.X
-- (el lado largo) -- al revés de lo intuitivo. Por eso "SPACE" o
-- "ENTER" salían apiladas letra por letra en vez de leerse de corrido.
-- El "rotator" de abajo arma el texto en una caja con la proporción
-- correcta (ancho real = Size.X) y la rota para que encaje en el
-- lienzo real de la cara.

local function addText(keyPart,text)

	local gui = Instance.new("SurfaceGui")

	gui.Name = "KeyText"
	gui.Face = Enum.NormalId.Top

	gui.AlwaysOnTop = true
	gui.LightInfluence = 0

	gui.SizingMode =
		Enum.SurfaceGuiSizingMode.PixelsPerStud

	gui.PixelsPerStud = 60

	gui.Parent = keyPart


	local canvasWidth = keyPart.Size.Z * gui.PixelsPerStud
	local canvasHeight = keyPart.Size.X * gui.PixelsPerStud

	local rotator = Instance.new("Frame")

	rotator.Name = "Rotator"
	rotator.BackgroundTransparency = 1
	rotator.BorderSizePixel = 0

	rotator.AnchorPoint = Vector2.new(0.5,0.5)
	rotator.Position = UDim2.new(0.5,0,0.5,0)

	-- Caja "acostada" (ancho = lado largo) que después de rotar
	-- termina ocupando justo el lienzo real (angosto x alto).
	rotator.Size = UDim2.new(0,canvasHeight,0,canvasWidth)
	rotator.Rotation = -90

	rotator.Parent = gui


	local label = Instance.new("TextLabel")

	label.Size = UDim2.new(1,0,1,0)

	label.BackgroundTransparency = 1

	label.Text = text

	label.TextColor3 =
		Color3.fromRGB(10,10,10)

	label.Font = Enum.Font.GothamBlack

	label.TextScaled = true

	label.TextXAlignment =
		Enum.TextXAlignment.Center

	label.TextYAlignment =
		Enum.TextYAlignment.Center

	label.Parent = rotator


	local padding =
		Instance.new("UIPadding")

	padding.PaddingTop =
		UDim.new(0.18,0)

	padding.PaddingBottom =
		UDim.new(0.18,0)

	padding.PaddingLeft =
		UDim.new(0.12,0)

	padding.PaddingRight =
		UDim.new(0.12,0)

	padding.Parent = label

end

--------------------------------------------------
-- CREAR TECLA
--------------------------------------------------

local function createKey(text,x,z,width,depth)

	local key =
		createPart(
			text,
			Vector3.new(
				width,
				1,
				depth
			),
			Vector3.new(
				x,
				2.25,
				z
			),
			WHITE,
			Enum.Material.SmoothPlastic
		)

	addText(key,text)


	--------------------------------------------------
	-- ILUMINACION VERDE
	--------------------------------------------------

	if specialKeys[text] then

		local active = false

		key.Touched:Connect(function(hit)

			local character = hit.Parent

			if not character then
				return
			end

			local humanoid =
				character:FindFirstChildOfClass(
					"Humanoid"
				)

			if humanoid and not active then

				active = true

				key.Color = GREEN
				key.Material = Enum.Material.Neon

				local light =
					Instance.new("PointLight")

				light.Color = GREEN
				light.Brightness = 2
				light.Range = 12

				light.Parent = key

				task.wait(0.8)

				light:Destroy()

				key.Color = WHITE

				key.Material =
					Enum.Material.SmoothPlastic

				task.wait(0.1)

				active = false

			end

		end)

	end

end

--------------------------------------------------
-- MEDIDAS
--------------------------------------------------

local KEY = 6
local DEPTH = 6

--------------------------------------------------
-- FILA DE NUMEROS
--------------------------------------------------

createKey("ESC",-43,-15,7,DEPTH)

local numbers = {
	"1","2","3","4","5",
	"6","7","8","9","0"
}

for i,number in ipairs(numbers) do

	createKey(
		number,
		-34 + ((i-1)*6.5),
		-15,
		KEY,
		DEPTH
	)

end

createKey(
	"BACK",
	38,
	-15,
	12,
	DEPTH
)

--------------------------------------------------
-- FILA QWERTY
--------------------------------------------------

createKey(
	"TAB",
	-42,
	-8,
	9,
	DEPTH
)

local row1 = {
	"Q","W","E","R","T",
	"Y","U","I","O","P"
}

for i,letter in ipairs(row1) do

	createKey(
		letter,
		-32 + ((i-1)*6.5),
		-8,
		KEY,
		DEPTH
	)

end

--------------------------------------------------
-- FILA ASDF
--------------------------------------------------

createKey(
	"CAPS",
	-40,
	-1,
	12,
	DEPTH
)

local row2 = {
	"A","S","D","F","G",
	"H","J","K","L"
}

for i,letter in ipairs(row2) do

	createKey(
		letter,
		-28 + ((i-1)*6.5),
		-1,
		KEY,
		DEPTH
	)

end

createKey(
	"ENTER",
	36,
	-1,
	16,
	DEPTH
)

--------------------------------------------------
-- FILA ZXCV
--------------------------------------------------

createKey(
	"SHIFT",
	-38,
	6,
	16,
	DEPTH
)

local row3 = {
	"Z","X","C","V","B","N","M"
}

for i,letter in ipairs(row3) do

	createKey(
		letter,
		-25 + ((i-1)*6.5),
		6,
		KEY,
		DEPTH
	)

end

createKey(
	"SHIFT",
	34,
	6,
	18,
	DEPTH
)

--------------------------------------------------
-- FILA INFERIOR
--------------------------------------------------

createKey(
	"CTRL",
	-41,
	13,
	9,
	DEPTH
)

createKey(
	"ALT",
	-31,
	13,
	8,
	DEPTH
)

--------------------------------------------------
-- SPACE GRANDE
--------------------------------------------------

createKey(
	"SPACE",
	0,
	13,
	46,
	DEPTH
)

createKey(
	"ALT",
	31,
	13,
	8,
	DEPTH
)

createKey(
	"CTRL",
	41,
	13,
	9,
	DEPTH
)

--------------------------------------------------
-- CAMINO
--------------------------------------------------

createPart(
	"Path",
	Vector3.new(14,0.4,45),
	Vector3.new(0,0.75,45),
	Color3.fromRGB(110,110,110),
	Enum.Material.Concrete
)

--------------------------------------------------
-- SPAWN
--------------------------------------------------

local spawn =
	Workspace:FindFirstChildWhichIsA(
		"SpawnLocation"
	)

if spawn then

	spawn.Position =
		Vector3.new(0,2,70)

	spawn.Size =
		Vector3.new(10,1,10)

	spawn.Anchored = true
	spawn.Neutral = true

else

	spawn =
		Instance.new("SpawnLocation")

	spawn.Name =
		"SpawnLocation"

	spawn.Position =
		Vector3.new(0,2,70)

	spawn.Size =
		Vector3.new(10,1,10)

	spawn.Anchored = true
	spawn.Neutral = true

	spawn.Parent =
		Workspace

end

--------------------------------------------------
-- CARTEL
--------------------------------------------------

local sign =
	createPart(
		"ROBUX_SIGN",
		Vector3.new(50,10,1),
		Vector3.new(0,9,-35),
		BLACK,
		Enum.Material.SmoothPlastic
	)

local signGui =
	Instance.new("SurfaceGui")

signGui.Face =
	Enum.NormalId.Front

signGui.AlwaysOnTop = true

signGui.LightInfluence = 0

signGui.Parent = sign

local signText =
	Instance.new("TextLabel")

signText.Size =
	UDim2.new(1,0,1,0)

signText.BackgroundTransparency = 1

signText.Text =
	"R O B U X"

signText.TextColor3 =
	Color3.fromRGB(255,255,255)

signText.TextScaled = true

signText.Font =
	Enum.Font.GothamBlack

signText.Parent =
	signGui

--------------------------------------------------

print("MAPA ROBUX CREADO CORRECTAMENTE")
