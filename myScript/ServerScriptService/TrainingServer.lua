-- ServerScriptService.TrainingServer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local TrainEvent = ReplicatedStorage.RemoteEvents.TrainEvent
local StatModule = require(ReplicatedStorage.Modules.StatModule)
local playerStats = require(ServerScriptService.PlayerDataHandler)

-- 훈련 이벤트 처리
TrainEvent.OnServerEvent:Connect(function(player)
	local stats = playerStats[player]
	if not stats then return end

	-- 스탯 모듈을 사용하여 Strength 증가
	stats = StatModule.Train(stats)
	playerStats[player] = stats -- 핸들러의 테이블을 직접 업데이트

	-- 클라이언트로 현재 Strength 전송
	TrainEvent:FireClient(player, stats.Strength)
end)
