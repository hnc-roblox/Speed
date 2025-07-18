local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "HNC_SpeedGui"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 90)
frame.Position = UDim2.new(0.1, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Viền cầu vồng wave
local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 2
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.LineJoinMode = Enum.LineJoinMode.Round
local gradient = Instance.new("UIGradient", stroke)
gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
	ColorSequenceKeypoint.new(0.14, Color3.fromRGB(255, 165, 0)),
	ColorSequenceKeypoint.new(0.28, Color3.fromRGB(255, 255, 0)),
	ColorSequenceKeypoint.new(0.42, Color3.fromRGB(0, 255, 0)),
	ColorSequenceKeypoint.new(0.57, Color3.fromRGB(0, 255, 255)),
	ColorSequenceKeypoint.new(0.71, Color3.fromRGB(0, 0, 255)),
	ColorSequenceKeypoint.new(0.85, Color3.fromRGB(128, 0, 255)),
	ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 255))
})
task.spawn(function()
	while gui and gui.Parent do
		gradient.Rotation = (gradient.Rotation + 3) % 360
		task.wait(0.01)
	end
end)

-- Tiêu đề
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 20)
title.BackgroundTransparency = 1
title.Text = "HNC Speed Hub"
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Nút thu gọn [-]
local collapseBtn = Instance.new("TextButton", frame)
collapseBtn.Size = UDim2.new(0, 20, 0, 20)
collapseBtn.Position = UDim2.new(1, -50, 0, 0)
collapseBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
collapseBtn.Text = "-"
collapseBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
collapseBtn.Font = Enum.Font.GothamBold
collapseBtn.TextSize = 14
collapseBtn.BorderSizePixel = 0
Instance.new("UICorner", collapseBtn).CornerRadius = UDim.new(0, 6)

-- Nút đóng ✖
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -25, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.Text = "✖"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.BorderSizePixel = 0
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- Nút + hiện lại GUI
local showBtn = Instance.new("TextButton", gui)
showBtn.Size = UDim2.new(0, 30, 0, 30)
showBtn.Position = UDim2.new(0, 10, 0.4, 0)
showBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 60)
showBtn.Text = "+"
showBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
showBtn.Font = Enum.Font.GothamBold
showBtn.TextSize = 20
showBtn.Visible = false
Instance.new("UICorner", showBtn).CornerRadius = UDim.new(0, 8)

-- Tạo nút
local function createButton(name, text, pos, parent, color)
	local btn = Instance.new("TextButton", parent)
	btn.Name = name
	btn.Text = text
	btn.Size = UDim2.new(0, 50, 0, 25)
	btn.Position = pos
	btn.BackgroundColor3 = color or Color3.fromRGB(60, 0, 90)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	return btn
end

-- Các nút
local plus = createButton("Plus", "+", UDim2.new(0, 70, 0, 55), frame, Color3.fromRGB(0, 200, 100))
local minus = createButton("Minus", "-", UDim2.new(0, 130, 0, 55), frame, Color3.fromRGB(200, 50, 50))
local toggleFly = createButton("Fly", "OFF", UDim2.new(0, 130, 0, 25), frame, Color3.fromRGB(60, 60, 60))

-- Hiển thị tốc độ
local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Name = "SpeedDisplay"
speedLabel.Text = "1"
speedLabel.Size = UDim2.new(0, 50, 0, 25)
speedLabel.Position = UDim2.new(0, 10, 0, 55)
speedLabel.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
speedLabel.BorderSizePixel = 0
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Font = Enum.Font.GothamBold
speedLabel.TextSize = 18
speedLabel.TextXAlignment = Enum.TextXAlignment.Center
speedLabel.TextYAlignment = Enum.TextYAlignment.Center
speedLabel.TextWrapped = true
Instance.new("UICorner", speedLabel).CornerRadius = UDim.new(0, 6)

-- Logic
local speed = 1
local flying = false

-- Cầu vồng nền ON
local function enableRainbow(button)
	task.spawn(function()
		while flying and button and button.Parent do
			for _, color in ipairs({
				Color3.fromRGB(255, 0, 0),
				Color3.fromRGB(255, 80, 0),
				Color3.fromRGB(255, 255, 0),
				Color3.fromRGB(0, 255, 0),
				Color3.fromRGB(0, 200, 255),
				Color3.fromRGB(0, 0, 255),
				Color3.fromRGB(170, 0, 255),
				Color3.fromRGB(255, 0, 255)
			}) do
				if not flying then break end
				button.BackgroundColor3 = color
				task.wait(0.06)
			end
		end
	end)
end

-- Bay
local function startFly()
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	flying = true
	toggleFly.Text = "ON"
	enableRainbow(toggleFly)
	while flying do
		char:TranslateBy(char.Humanoid.MoveDirection * speed)
		task.wait()
	end
end

-- Sự kiện nút
toggleFly.MouseButton1Click:Connect(function()
	flying = not flying
	if flying then
		startFly()
	else
		toggleFly.Text = "OFF"
		toggleFly.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	end
end)

plus.MouseButton1Click:Connect(function()
	speed += 1
	speedLabel.Text = tostring(speed)
end)

minus.MouseButton1Click:Connect(function()
	if speed > 1 then
		speed -= 1
		speedLabel.Text = tostring(speed)
	end
end)

-- Nút -
collapseBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	showBtn.Visible = true
end)

-- Nút +
showBtn.MouseButton1Click:Connect(function()
	frame.Visible = true
	showBtn.Visible = false
end)

-- Nút ✖
closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- Kéo
frame.Active = true
frame.Draggable = true

-- Thông báo
game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "HNC Speed Hub",
	Text = "Đã bật!",
	Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150"
})
