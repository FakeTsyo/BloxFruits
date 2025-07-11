--[[
BLOX FRUITS GUI -- MOBILE FRIENDLY
By: GitHub Copilot
Ícone de Ninja, AutoFarm, ESP, Teleport, etc.
]]

-- services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- GUI principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NinjaBloxFruits"
ScreenGui.Parent = game.CoreGui

-- Ícone flutuante (Ninja)
local IconButton = Instance.new("ImageButton")
IconButton.Name = "NinjaIcon"
IconButton.Parent = ScreenGui
IconButton.Size = UDim2.new(0, 80, 0, 80)
IconButton.Position = UDim2.new(0, 20, 0, 200)
IconButton.BackgroundTransparency = 1
IconButton.Image = "rbxassetid://4525871195" -- Ícone ninja

-- Arrastar ícone
local dragging, dragInput, dragStart, startPos
IconButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = IconButton.Position
	end
end)

IconButton.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

IconButton.InputChanged:Connect(function(input)
	if dragging then
		local delta = input.Position - dragStart
		IconButton.Position = startPos + UDim2.new(0, delta.X, 0, delta.Y)
	end
end)

-- Janela principal
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0, 110, 0, 160)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

-- Abrir menu ao clicar no ícone
IconButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

-- Título
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "Ninja Blox Fruits"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextSize = 24
Title.Font = Enum.Font.GothamBold

-- Funções
local buttons = {}

function AddButton(name, callback)
	local btn = Instance.new("TextButton")
	btn.Parent = MainFrame
	btn.Size = UDim2.new(1, -20, 0, 40)
	btn.Position = UDim2.new(0, 10, 0, 50 + #buttons*45)
	btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
	btn.Text = name
	btn.TextColor3 = Color3.new(1,1,1)
	btn.TextSize = 18
	btn.Font = Enum.Font.Gotham
	btn.MouseButton1Click:Connect(callback)
	table.insert(buttons, btn)
end

-- AutoFarm Level
local autofarm = false
AddButton("AutoFarm Level", function()
	autofarm = not autofarm
	buttons[1].BackgroundColor3 = autofarm and Color3.fromRGB(0,150,0) or Color3.fromRGB(40,40,40)
	if autofarm then
		spawn(function()
			while autofarm do
				-- Seleciona missão de acordo com o level
				local level = LocalPlayer.Data.Level.Value
				-- Exemplo: Missões fictícias
				local questName, mobName, questPos, mobPos
				if level < 50 then
					questName = "Bandit"
					mobName = "Bandit"
					questPos = Vector3.new(400, 10, 900)
					mobPos = Vector3.new(420, 10, 920)
				elseif level < 100 then
					questName = "Monkey"
					mobName = "Monkey"
					questPos = Vector3.new(-1600, 40, 60)
					mobPos = Vector3.new(-1590, 40, 80)
				else
					questName = "Pirate"
					mobName = "Pirate"
					questPos = Vector3.new(-1120, 10, 3900)
					mobPos = Vector3.new(-1100, 10, 3920)
				end
				-- Teleporta até a missão
				LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(questPos)
				wait(1)
				-- Pega a missão (simula click)
				fireclickdetector(workspace:FindFirstChild(questName.."Quest").ClickDetector)
				wait(0.5)
				-- Teleporta até o mob
				LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(mobPos)
				wait(0.5)
				-- Ataca o mob (simula click na arma selecionada)
				local tool = LocalPlayer.Backpack:FindFirstChildOfClass("Tool") or LocalPlayer.Character:FindFirstChildOfClass("Tool")
				if tool then
					tool.Parent = LocalPlayer.Character
					for _,mob in pairs(workspace.Enemies:GetChildren()) do
						if mob.Name == mobName and mob:FindFirstChild("HumanoidRootPart") then
							repeat
								LocalPlayer.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
								tool:Activate()
								wait(0.2)
							until mob.Humanoid.Health <= 0 or not autofarm
						end
					end
				end
				wait(0.5)
			end
		end)
	end
end)

-- ESP Frutas
local espFrutas = false
AddButton("ESP Frutas", function()
	espFrutas = not espFrutas
	buttons[2].BackgroundColor3 = espFrutas and Color3.fromRGB(0,150,0) or Color3.fromRGB(40,40,40)
	for _,v in pairs(workspace:GetChildren()) do
		if v:IsA("Tool") and v:FindFirstChild("Handle") then
			if v.Name:find("Fruit") then
				if espFrutas then
					if not v:FindFirstChild("EspLabel") then
						local bill = Instance.new("BillboardGui", v.Handle)
						bill.Name = "EspLabel"
						bill.Size = UDim2.new(0,100,0,40)
						bill.AlwaysOnTop = true
						local txt = Instance.new("TextLabel", bill)
						txt.Size = UDim2.new(1,0,1,0)
						txt.BackgroundTransparency = 1
						txt.Text = v.Name
						txt.TextColor3 = Color3.new(1,0.5,0)
						txt.TextStrokeTransparency = 0
						txt.TextScaled = true
					end
				else
					if v.Handle:FindFirstChild("EspLabel") then
						v.Handle.EspLabel:Destroy()
					end
				end
			end
		end
	end
end)

-- ESP Players
local espPlayers = false
AddButton("ESP Players", function()
	espPlayers = not espPlayers
	buttons[3].BackgroundColor3 = espPlayers and Color3.fromRGB(0,150,0) or Color3.fromRGB(40,40,40)
	for _,plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
			if espPlayers then
				if not plr.Character.Head:FindFirstChild("EspLabel") then
					local bill = Instance.new("BillboardGui", plr.Character.Head)
					bill.Name = "EspLabel"
					bill.Size = UDim2.new(0,100,0,40)
					bill.AlwaysOnTop = true
					local txt = Instance.new("TextLabel", bill)
					txt.Size = UDim2.new(1,0,1,0)
					txt.BackgroundTransparency = 1
					txt.Text = plr.Name
					txt.TextColor3 = Color3.new(0,1,1)
					txt.TextStrokeTransparency = 0
					txt.TextScaled = true
				end
			else
				if plr.Character.Head:FindFirstChild("EspLabel") then
					plr.Character.Head.EspLabel:Destroy()
				end
			end
		end
	end
end)

-- Aimbot (trava visão em mob mais próximo)
local aimbot = false
AddButton("Aimbot Mob Próximo", function()
	aimbot = not aimbot
	buttons[4].BackgroundColor3 = aimbot and Color3.fromRGB(0,150,0) or Color3.fromRGB(40,40,40)
	spawn(function()
		while aimbot do
			local closestMob,dist = nil,9999
			for _,mob in pairs(workspace.Enemies:GetChildren()) do
				if mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
					local d = (mob.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
					if d < dist then
						closestMob = mob
						dist = d
					end
				end
			end
			if closestMob then
				workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, closestMob.HumanoidRootPart.Position)
			end
			wait(0.1)
		end
	end)
end)

-- Teleportar para Mar
AddButton("Teleportar Mar 1", function()
	LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1050, 10, 1650) -- Exemplo coordenada Mar 1
end)
AddButton("Teleportar Mar 2", function()
	LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(5400, 10, 270) -- Exemplo coordenada Mar 2
end)
AddButton("Teleportar Mar 3", function()
	LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5100, 10, 8900) -- Exemplo coordenada Mar 3
end)

-- Teleportar para ilha de acordo com o mar do usuário
AddButton("TP Ilha (Mar Atual)", function()
	local sea = LocalPlayer.Data.Sea.Value
	if sea == 1 then
		LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(400, 10, 900) -- Ilha do Mar 1
	elseif sea == 2 then
		LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(5400, 10, 270) -- Ilha do Mar 2
	elseif sea == 3 then
		LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5100, 10, 8900) -- Ilha do Mar 3
	end
end)

-- Mobile adaptativo
ScreenGui.ResetOnSpawn = false

-- Fim
