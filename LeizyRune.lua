local leizyrunes={}
--职业
--local class = select(2,UnitClass("player"))
leizyrunes.R=85
--记录符文CD
leizyrunes.runeCDs = {0,0,0,0,0,0}
--符文放缩值
leizyrunes.Scale = 0.8
--CD颜色
leizyrunes.Color = {"|cff0CD809","|cffE8DA0F","|cffD80909"}
--CD字大小
leizyrunes.FontSize = 22
--CD时Alpha值
leizyrunes.Alpha = 0.45
--Position(以屏幕中心点为原点)
leizyrunes.PositionX = 0
leizyrunes.PositionY = -30
--是否进站斗
leizyrunes.infight = false
--是否在宠物对战
leizyrunes.inPetBattle = false
--logboolean
-- isShowLog = false
if select(2,UnitClass("player")) ~= "DEATHKNIGHT" then
	return
end

--获取专精
function getSpec()
	local spec = 0
	if GetSpecialization() ~= nil then
		if GetSpecializationInfo(GetSpecialization()) ~= nil then
			spec = select(1,GetSpecializationInfo(GetSpecialization()))
		else
			-- print("GetSpecializationInfo is nil")
		end
	else
		-- print("GetSpecialization is nil")
	end
	return spec
end
--根据专精换材质
function setTextureOfSpec(num)
	local texture = ""
	if num == 250 then texture = "Interface\\AddOns\\LeizyRune\\textures\\blood" 
	elseif num == 251 then texture = "Interface\\AddOns\\LeizyRune\\textures\\frost"
	elseif num == 252 then texture = "Interface\\AddOns\\LeizyRune\\textures\\unholy"
	end
	return texture
end
--初始化符文
function leizyrunes_init()
	-- print("leizyrunes init")
	-- print(math.pi)
	--TODO 符文初始化
	leizyrunes.runes = {1,1,1,1,1,1}
	leizyrunes_setMainFrame()
	--单个frame
	-- test = "123"
	leizyrunes_runeFrame = {}
	leizyrunes_runeTexture = {}
	leizyrunes_runeCDText = {}
	for i = 1,6 do
		leizyrunes_runeFrame[i] = CreateFrame("Frame",nil,leizyrunes_mainframe)
		leizyrunes_runeTexture[i] = leizyrunes_runeFrame[i]:CreateTexture(nil,"ARTWORK")
		leizyrunes_runeCDText[i] = leizyrunes_runeFrame[i]:CreateFontString(nil,"ARTWORK")
	end
	leizyrunes_setRunesFrame()
	leizyrunes_setRunesTexture()
	leizyrunes_setRunesCDText()
	--test

end
-- 设置主Frame
function leizyrunes_setMainFrame()
	-- print("leizyrunes_setMainFrame")
	--leizyrunes_mainframe = CreateFrame("Frame",LeizyRuneFrame,UIParent)
	--leizyrunes_mainframe:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8", edgeFile="", tile = false, edgeSize=1})
	--leizyrunes_mainframe:SetBackdropColor(.5,.5,.5,.5)
	--leizyrunes_mainframe:SetBackdropBorderColor(1,0,1,1)
	leizyrunes_mainframe:SetWidth(200)
	leizyrunes_mainframe:SetHeight(100)
	leizyrunes_mainframe:SetPoint("CENTER",UIParent,"CENTER",leizyrunes.PositionX,leizyrunes.PositionY)
	changeAlpha(leizyrunes_mainframe,leizyrunes.Alpha)
	--test Texture&Text
	--[[
	leizyrunes_mainframe.Texture = leizyrunes_mainframe:CreateTexture(nil,"ARTWORK")
	leizyrunes_mainframe.Texture:SetTexture(setTextureOfSpec(getSpec()))	
	leizyrunes_mainframe.Texture:SetPoint("CENTER",leizyrunes_mainframe,0,0)
	leizyrunes_mainframe.Text = leizyrunes_mainframe:CreateFontString(nil,"OVERLAY")
	leizyrunes_mainframe.Text:SetFont("Fonts\\ARHei.ttf",16,"THINOUTLINE")
	leizyrunes_mainframe.Text:SetText("|cffff0000Lei|cff00ff00zy|cff0000ffRunes")
	leizyrunes_mainframe.Text:SetPoint("CENTER",leizyrunes_mainframe,0,0)]]
	
	
end


--设置单个符文
function leizyrunes_setRunesFrame()
	for i=1,6 do
		-- print("leizyrunes_runeFrame"..i)
		--leizyrunes_runeFrame[i]:SetBackdrop({bgFile="Interface\\Buttons\\WHITE8X8", edgeFile="", tile = false, edgeSize=1})
		--leizyrunes_runeFrame[i]:SetBackdropColor(1,0,0,.8)
		--leizyrunes_runeFrame[i]:SetBackdropBorderColor(1,0,1,1)
		leizyrunes_runeFrame[i]:SetWidth(20)
		leizyrunes_runeFrame[i]:SetHeight(20)
		leizyrunes_runeFrame[i]:SetScale(leizyrunes.Scale)
		leizyrunes_runeFrame[i]:SetPoint("CENTER",leizyrunes_mainframe,"CENTER",leizyrunes.R*math.sin(math.rad(30*(i-1)-75)),-leizyrunes.R*math.cos(math.rad(30*(i-1)-75)))
		--leizyrunes_runeFrame[i]:SetPoint("CENTER",leizyrunes_mainframe,"CENTER",i*30-105,0)
	end

end
--单个符文材质
function leizyrunes_setRunesTexture()
	for i=1,6 do
		-- print("leizyrunes_runeTexture"..i)
		--leizyrunes_runeTexture[i]:SetScale(1.1)
		leizyrunes_runeTexture[i]:SetTexture(setTextureOfSpec(getSpec()))
		leizyrunes_runeTexture[i]:SetPoint("CENTER",leizyrunes_runeFrame[i],"CENTER",0,0)
	end
end
--符文CD文字
function leizyrunes_setRunesCDText()
	for i=1,6 do
		-- print("leizyrunes_runeCDText"..i)
		leizyrunes_runeCDText[i]:SetFont("Fonts\\ARHei.ttf",leizyrunes.FontSize,"OUTLINE")
		--leizyrunes_runeCDText[i]:SetText("5")
		
		leizyrunes_runeCDText[i]:SetPoint("CENTER",leizyrunes_runeFrame[i],"CENTER",2,1)
	end
end
--改变透明度
function changeAlpha(frame,alpha)
	--[[if leizyrunes.runeCDs[num] > 0 then
		leizyrunes_runeTexture[num]:SetAlpha(leizyrunes.Alpha)
	else
		leizyrunes_runeTexture[num]:SetAlpha(1)
	end]]
	frame:SetAlpha(alpha)
end
--CD剩余时间
function setRuneCDs()
	for i=1,6 do
		local starttime, spellduration, runeReady = GetRuneCooldown(i)
		if runeReady then
			leizyrunes.runeCDs[i]=0
			leizyrunes_runeCDText[i]:SetText("")
		else
			local currentTime = GetTime()
			local durationLeft = (starttime + spellduration - currentTime)<= 0 and 0 or (starttime + spellduration - currentTime)
			leizyrunes.runeCDs[i] = durationLeft
			if durationLeft > 5 then
				leizyrunes_runeCDText[i]:SetText(leizyrunes.Color[1]..math.ceil(durationLeft))
			else
				leizyrunes_runeCDText[i]:SetText(leizyrunes.Color[3]..math.ceil(durationLeft))
			end
		end
		--透明度改变
		if leizyrunes.runeCDs[i] > 0 then
			changeAlpha(leizyrunes_runeTexture[i],leizyrunes.Alpha)
		else
			--leizyrunes_runeTexture[i]:SetAlpha(1)
			changeAlpha(leizyrunes_runeTexture[i],1)
		end
	end
end


--渐隐、渐现动画
-- function frameFade(frame,timetoFade,startAlpha,endAlpha)
	-- UIFrameFadeIn(frame,timetoFade,startAlpha,endAlpha)
	-- UIFrameFadeOut(frame,timetoFade,startAlpha,endAlpha)
-- end

--log
-- function -- print(str)
	-- if isShowLog then
		-- DEFAULT_CHAT_FRAME:AddMessage(str)
	-- end
-- end
function lr_onEvent(self, event, arg1, ...)
	if select(2,UnitClass("player")) == "DEATHKNIGHT" then
		---- print("DK")
		if event == "PLAYER_LOGIN" then
			-- print("Hello player")
			leizyrunes_init()
		elseif event == "ACTIVE_TALENT_GROUP_CHANGED" then
			-- print("专精切换")
			--leizyrunes_mainframe.Hide()
			--leizyrunes_init()
			leizyrunes_setRunesTexture()
		elseif event == "PLAYER_REGEN_ENABLED" then
			leizyrunes.infight = false
			-- print("outfight")
			UIFrameFadeIn(leizyrunes_mainframe,1,1.0,leizyrunes.Alpha)
		elseif event == "PLAYER_REGEN_DISABLED" then
			leizyrunes.infight = true
			-- print("infight")
			UIFrameFadeIn(leizyrunes_mainframe,0.5,leizyrunes.Alpha,1.0)
		elseif event == "PET_BATTLE_OPENING_START" then
			--leizyrunes.inPetBattle = true
			UIFrameFadeIn(leizyrunes_mainframe,1,leizyrunes.Alpha,0)
		elseif event == "PET_BATTLE_CLOSE" then
			--leizyrunes.inPetBattle = false
			UIFrameFadeIn(leizyrunes_mainframe,1,0,leizyrunes.Alpha)
		elseif event == "PLAYER_ENTER_WORLD" then
			UIFrameFadeIn(leizyrunes_mainframe,1,0,leizyrunes.Alpha)
		elseif event == "UNIT_ENTERED_VEHICLE" then
			if leizyrunes.infight then
				UIFrameFadeIn(leizyrunes_mainframe,0.5,1.0,leizyrunes.Alpha)
			else
				UIFrameFadeIn(leizyrunes_mainframe,1,leizyrunes.Alpha,0)
			end
		elseif event == "UNIT_EXITED_VEHICLE" then
			if leizyrunes.infight then
				UIFrameFadeIn(leizyrunes_mainframe,0.5,leizyrunes.Alpha,1.0)
			else
				UIFrameFadeIn(leizyrunes_mainframe,1,0,leizyrunes.Alpha)
			end
		end
	end
end
function lr_onUpdate()
	setRuneCDs()
end