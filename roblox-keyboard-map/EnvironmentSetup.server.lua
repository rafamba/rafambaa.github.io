-- ServerScriptService/EnvironmentSetup.server.lua
--
-- Genera un entorno simple alrededor del teclado: piso de pasto,
-- un camino de asfalto y unos árboles low-poly de decoración.
-- Es opcional: si ya tienen su propio entorno armado, borren este script.
--
-- Es seguro dejarlo corriendo: se construye una sola vez (revisa si ya
-- existe la carpeta "KeyboardMapEnvironment") y no vuelve a duplicar
-- nada en los siguientes arranques del servidor.
--
-- Las posiciones de abajo son un punto de partida: ajústenlas en
-- Studio (o edítenlas acá) según el tamaño y la orientación real de
-- su teclado.

local Workspace = game:GetService("Workspace")

if Workspace:FindFirstChild("KeyboardMapEnvironment") then
	return
end

local environment = Instance.new("Folder")
environment.Name = "KeyboardMapEnvironment"
environment.Parent = Workspace

-- 1) Piso de pasto
local baseplate = Workspace:FindFirstChild("Baseplate")
if baseplate and baseplate:IsA("BasePart") then
	baseplate.Material = Enum.Material.Grass
	baseplate.Color = Color3.fromRGB(74, 155, 72)
end

-- 2) Camino de asfalto hacia el teclado
local path = Instance.new("Part")
path.Name = "Path"
path.Anchored = true
path.Material = Enum.Material.Asphalt
path.Color = Color3.fromRGB(90, 90, 90)
path.Size = Vector3.new(12, 0.4, 60)
path.CFrame = CFrame.new(0, 0.6, -30)
path.Parent = environment

-- 3) Árboles low-poly de decoración
local function createTree(position)
	local tree = Instance.new("Model")
	tree.Name = "Tree"
	tree.Parent = environment

	local trunk = Instance.new("Part")
	trunk.Name = "Trunk"
	trunk.Anchored = true
	trunk.Material = Enum.Material.Wood
	trunk.Color = Color3.fromRGB(92, 64, 51)
	trunk.Size = Vector3.new(2, 8, 2)
	trunk.CFrame = CFrame.new(position + Vector3.new(0, 4, 0))
	trunk.Parent = tree

	local leaves = Instance.new("Part")
	leaves.Name = "Leaves"
	leaves.Shape = Enum.PartType.Ball
	leaves.Anchored = true
	leaves.Material = Enum.Material.Grass
	leaves.Color = Color3.fromRGB(58, 125, 59)
	leaves.Size = Vector3.new(10, 10, 10)
	leaves.CFrame = CFrame.new(position + Vector3.new(0, 10, 0))
	leaves.Parent = tree

	tree.PrimaryPart = trunk
end

local treeSpots = {
	Vector3.new(-40, 0, -10),
	Vector3.new(-35, 0, 10),
	Vector3.new(40, 0, -10),
	Vector3.new(35, 0, 10),
	Vector3.new(-25, 0, -40),
	Vector3.new(25, 0, -40),
}

for _, spot in ipairs(treeSpots) do
	createTree(spot)
end
