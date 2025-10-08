-- StarterPlayerScripts.TrainingClient
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local TrainEvent = ReplicatedStorage.RemoteEvents.TrainEvent

-- 키 입력 감지
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.Space then
		-- 서버에 훈련 요청
		print("클라이언트: 스페이스바 입력. 서버에 훈련을 요청합니다.")
		TrainEvent:FireServer()
	end
end)

-- 서버로부터 스탯 업데이트 수신
TrainEvent.OnClientEvent:Connect(function(strength)
	print("클라이언트: 서버로부터 업데이트된 힘 스탯 수신. 현재 힘: " .. strength)
	-- 이 부분에서 화면의 UI(TextLabel 등)를 업데이트하는 코드를 추가할 수 있습니다.
end)