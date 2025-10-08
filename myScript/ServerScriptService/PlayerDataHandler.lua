-- ServerScriptService.PlayerDataHandler
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")

local StatModule = require(ReplicatedStorage.Modules.StatModule)

-- 데이터 스토어 설정
local playerDataStore = DataStoreService:GetDataStore("PlayerData_V1")

-- 실시간 스탯을 관리하는 테이블
local playerStats = {}

-- 플레이어가 접속했을 때 데이터 불러오기
Players.PlayerAdded:Connect(function(player)
	local userId = "Player_" .. player.UserId
	local savedData

	-- pcall로 안전하게 데이터 로드 시도
	local success, err = pcall(function()
		savedData = playerDataStore:GetAsync(userId)
	end)

	if success then
		if savedData then
			-- 저장된 데이터가 있으면 테이블에 로드
			playerStats[player] = savedData
		else
			-- 저장된 데이터가 없으면 (신규 플레이어) 새로 생성
			playerStats[player] = StatModule.new()
		end
	else
		-- 로드 실패 시 일단 기본값으로 시작
		print("경고: " .. player.Name .. "님의 데이터를 불러오는 데 실패했습니다: " .. tostring(err))
		playerStats[player] = StatModule.new()
	end
end)

-- 플레이어가 나갈 때 데이터 저장하기
Players.PlayerRemoving:Connect(function(player)
	local userId = "Player_" .. player.UserId
	local dataToSave = playerStats[player]

	if dataToSave then
		-- pcall로 안전하게 데이터 저장 시도
		local success, err = pcall(function()
			playerDataStore:SetAsync(userId, dataToSave)
		end)

		if not success then
			print("경고: " .. player.Name .. "님의 데이터를 저장하는 데 실패했습니다: " .. tostring(err))
		end

		-- 실시간 테이블에서 데이터 삭제
		playerStats[player] = nil
	end
end)

return playerStats
