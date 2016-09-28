local addonname = ...

local f = CreateFrame("Frame",nil,UIParent)
f:EnableMouse(true)
local f_text = f:CreateFontString(nil,"OVERLAY")
f_text:SetFont("Fonts\\ARHei.ttf",13,"OUTLINE")
f:SetAllPoints(f_text)
-- local i = 1
f:SetScript("OnEvent",function(self,event,...)
	if event == "ADDON_LOADED" then
		local name = ...
		if name == addonname then
			-- testDB = testDB or {}
			f:UnregisterEvent("ADDON_LOADED")
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
		
	elseif event == "PLAYER_REGEN_DISABLED" then
		
	elseif event == "UNIT_COMBAT" then
		
		-- for i = 1, select("#",...) do
			-- print(select(i,...).."; ")
		-- end
		-- print("==========")
		-- print("combat")
		-- local unit,action,modifier,damage,damageType = ...
		-- if unit == "player" then
			-- print(#(...))
			-- print("player__"..unit.."; "..action.."; "..modifier.."; "..damage.."; "..damageType)
		-- else
		-- if unit == "target" then
			-- print(#(...))
			-- local unit,action,modifier,damage,damageType,x = ...
			-- print("target__"..unit.."; "..action.."; "..modifier.."; "..damage.."; "..damageType.."; "..x)
		-- end
	-- elseif event == "PLAYER_DAMAGE_DONE_MODS" then
		-- print(...)
	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local timestamp, eventtype, hideCaster, srcGUID, srcName, srcFlags, srcRaidFlags, dstGUID, dstName, dstFlags, dstRaidFlags = ...
		-- print(timestamp.."; "..eventtype.."; "..hideCaster.."; "..)
		-- if eventtype = "SPELL_DAMAGE" then
			-- testDB[i].timestamp = timestamp
			-- testDB[i].eventtype = eventtype
			-- testDB[i].hideCaster = hideCaster
			-- testDB[i].srcGUID = srcGUID
			-- testDB[i].srcName = srcName
			-- testDB[i].srcFlags = srcFlags
			-- testDB[i].srcRaidFlags = srcRaidFlags
			-- testDB[i].dstGUID = dstGUID
			-- testDB[i].dstName = dstName
			-- testDB[i].dstFlags = dstFlags
			-- testDB[i].dstRaidFlags = dstRaidFlags
			-- i = i+1
			for i = 1, select("#",...) do
				print(i..", "..tostring(select(i,...)).."; ")
			end
			print("==========")
		-- end
	end
end)

f:RegisterEvent("PLAYER_REGEN_DISABLED")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:RegisterEvent("UNIT_COMBAT")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
-- f:RegisterEvent("PLAYER_DAMAGE_DONE_MODS")