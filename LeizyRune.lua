leizyrunes={}
--职业
--local class = select(2,UnitClass("player"))
leizyrunes_mainframe = CreatFrame("Frame",nil,UIParent)
--leizyrunes_mainframe:SetSize(40,40)
--leizyrunes_mainframe:SetPoint("CENTER",UIParent)


--OnLoad
function leizyrunes_mainframe:OnLoad(self)

	self:RegisterEvent("PLAYER_LOGIN")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
--	self:RegisterEvent

end

--OnEvent
function leizyrunes_mainframe:OnEvent(self,event,arg1,...)
	if select(2,UnitClass("player")) == "DEATHKNIGHT" then
		Print("Hello DK")
		if event == "PLAYER_LOGIN" then
			Print("Hello LeizyRune")
			leizyrunes_init()
		end
	end
end

--OnUpdate
function leizyrunes_mainframe:OnUpdate()
	--TODO
end

function leizyrunes_init()
	Print("leizyrunes init")
	--TODO 符文初始化
	
end



--log
function Print(str)
	DEFAUT_CHAT_FRAME:AddMessage(str)
end
