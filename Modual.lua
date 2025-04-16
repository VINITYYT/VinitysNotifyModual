local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Ensure we only create the module if it doesn't already exist
if not ReplicatedStorage:FindFirstChild("NotificationModule") then
	local module = Instance.new("ModuleScript")
	module.Name = "NotificationModule"

	module.Source = [[
		local TweenService = game:GetService("TweenService")
		local Players = game:GetService("Players")

		local module = {}
		local gui
		local holder
		local notifications = {}

		local function init()
			if gui then return end
			local player = Players.LocalPlayer
			local playerGui = player:WaitForChild("PlayerGui")

			gui = Instance.new("ScreenGui")
			gui.Name = "NotificationGui"
			gui.ResetOnSpawn = false
			gui.Parent = playerGui

			holder = Instance.new("Frame")
			holder.Name = "NotificationHolder"
			holder.Size = UDim2.new(1, 0, 1, 0)
			holder.BackgroundTransparency = 1
			holder.Position = UDim2.new(0, 0, 0, 0)
			holder.Parent = gui
		end

		function module.Notify(text)
			init()
			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(0, 300, 0, 50)
			label.Position = UDim2.new(0.5, 0, 1, 0)
			label.AnchorPoint = Vector2.new(0.5, 1)
			label.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			label.TextColor3 = Color3.fromRGB(255, 255, 255)
			label.BackgroundTransparency = 1
			label.TextTransparency = 1
			label.Font = Enum.Font.GothamBold
			label.TextSize = 20
			label.Text = text
			label.ZIndex = 10
			label.Parent = holder

			table.insert(notifications, 1, label)

			for i, notif in ipairs(notifications) do
				local yOffset = -10 - ((i - 1) * 55)
				TweenService:Create(notif, TweenInfo.new(0.25), {
					Position = UDim2.new(0.5, 0, 1, yOffset)
				}):Play()
			end

			TweenService:Create(label, TweenInfo.new(0.3), {
				TextTransparency = 0,
				BackgroundTransparency = 0.2
			}):Play()

			task.delay(3, function()
				TweenService:Create(label, TweenInfo.new(0.3), {
					TextTransparency = 1,
					BackgroundTransparency = 1
				}):Play()
				task.wait(0.4)
				label:Destroy()
				for i, v in ipairs(notifications) do
					if v == label then
						table.remove(notifications, i)
						break
					end
				end
			end)
		end

		return module
	]]

	module.Parent = ReplicatedStorage
end
