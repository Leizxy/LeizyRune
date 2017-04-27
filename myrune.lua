--
-- Created by IntelliJ IDEA.
-- User: leizy
-- Date: 2017/4/27 0027
-- Time: 上午 10:55
-- To change this template use File | Settings | File Templates.
--

-- DK专属符文条工具。
local LeizyRune, ns = ...

if (select(2, UnitClass("player"))) ~= "DEATHKNIGHT" then
    return
end

local runedatas = {}
runedatas.R = 85
runedatas.Scale = 0.8
-- 符文透明度
runedatas.Alpha = 0.45
-- 位置（屏幕正中为原点）
runedatas.PositionX = 0
runedatas.PositionY = -30
-- 字体大小
runedatas.FontSize = 22
-- 存储符文CD时间
runedatas.CDs = { 0, 0, 0, 0, 0, 0 }
runedatas.Color = { "|cff0CD809", "|cffE8DA0F", "|cffD80909" }

local leizyrune_MainFrame = CreateFrame("Frame", nil, UIParent)
leizyrune_MainFrame:SetWidth(1)
leizyrune_MainFrame:SetHeight(1)
leizyrune_MainFrame:SetPoint("CENTER", UIParent, "CENTER", runedatas.PositionX, runedatas.PositionY)
local leizyrunes_runeFrames
local leizyrunes_runeTextures
local leizyrunes_runeCDTexts
--获取专精
function getSpec()
    local spec = 0
    if GetSpecialization() ~= nil then
        if GetSpecializationInfo(GetSpecialization()) ~= nil then
            spec = select(1, GetSpecializationInfo(GetSpecialization()))
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

function init_rune()
    leizyrune_MainFrame:SetAlpha(runedatas.Alpha)
    leizyrunes_runeFrames = {}
    leizyrunes_runeTextures = {}
    leizyrunes_runeCDTexts = {}

    for i = 1, 6 do
        leizyrunes_runeFrames[i] = CreateFrame("Frame", nil, leizyrune_MainFrame)
        leizyrunes_runeTextures[i] = leizyrunes_runeFrames[i]:CreateTexture(nil, "ARTWORK")
        leizyrunes_runeTextures[i]:SetTexture(setTextureOfSpec(getSpec()))
        leizyrunes_runeTextures[i]:SetPoint("CENTER", leizyrunes_runeFrames[i], 0, 0)
        leizyrunes_runeCDTexts[i] = leizyrunes_runeFrames[i]:CreateFontString(nil, "ARTWORK")
    end

    setRunesPosition()
    --    setRunesTextures()
    setRunesCDText()
end

function setRunesPosition()
    for i = 1, 6 do
        leizyrunes_runeFrames[i]:SetWidth(20)
        leizyrunes_runeFrames[i]:SetHeight(20)
        leizyrunes_runeFrames[i]:SetScale(runedatas.Scale)
        leizyrunes_runeFrames[i]:SetPoint("CENTER", leizyrune_MainFrame, runedatas.R * math.sin(math.rad(30 * (i - 1) - 75)), -runedatas.R * math.cos(math.rad(30 * (i - 1) - 75)))
    end
end

function setTextures()
    for i = 1, 6 do
        if leizyrunes_runeTextures ~= nil then
            leizyrunes_runeTextures[i]:SetTexture(setTextureOfSpec(getSpec()))
            leizyrunes_runeTextures[i]:SetPoint("CENTER", leizyrunes_runeFrames[i], 0, 0)
        end
    end
end

function setRunesCDText()
    for i = 1, 6 do
        leizyrunes_runeCDTexts[i]:SetFont("Fonts\\ARHei.ttf", runedatas.FontSize, "OUTLINE")
        leizyrunes_runeCDTexts[i]:SetPoint("CENTER", leizyrunes_runeFrames[i], 2, 1)
    end
end

-- CD时间
function setRuneCDs()
    for i = 1, 6 do
        local starttime, spellduration, runeReady = GetRuneCooldown(i)
        if runeReady then
            runedatas.CDs[i] = 0
            leizyrunes_runeCDTexts[i]:SetText("")
        else
            local currentTime = GetTime()
            local durationLeft = (starttime + spellduration - currentTime) <= 0 and 0 or (starttime + spellduration - currentTime)
            runedatas.CDs[i] = durationLeft
            if durationLeft > 5 then
                leizyrunes_runeCDTexts[i]:SetText(runedatas.Color[1] .. math.ceil(durationLeft))
            else
                leizyrunes_runeCDTexts[i]:SetText(runedatas.Color[3] .. math.ceil(durationLeft))
            end
        end

        if runedatas.CDs[i] > 0 then
            leizyrunes_runeTextures[i]:SetAlpha(runedatas.Alpha)
        else
            leizyrunes_runeTextures[i]:SetAlpha(1)
        end
    end
end

leizyrune_MainFrame:SetScript("OnEvent", function(_, event, _)
    if (select(2, UnitClass("player"))) == "DEATHKNIGHT" then
        if event == "PLAYER_LOGIN" then
            init_rune()
        elseif event == "ACTIVE_TALENT_GROUP_CHANGED" then
            setTextures()
        elseif event == "PLAYER_REGEN_ENABLED" then
            UIFrameFadeIn(leizyrune_MainFrame, 1, 1.0, runedatas.Alpha)
        elseif event == "PLAYER_REGEN_DISABLED" then
            UIFrameFadeIn(leizyrune_MainFrame, 0.5, runedatas.Alpha, 1.0)
        elseif event == "PET_BATTLE_OPENING_START" then
            UIFrameFadeIn(leizyrune_MainFrame, 1, runedatas.Alpha, 0)
        elseif event == "PET_BATTLE_CLOSE" or event == "PLAYER_ENTERING_WORLD" then
            UIFrameFadeIn(leizyrune_MainFrame, 1, 0, runedatas.Alpha)
        end
    end
end)

leizyrune_MainFrame:RegisterEvent("PLAYER_LOGIN")
leizyrune_MainFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
leizyrune_MainFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
leizyrune_MainFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
leizyrune_MainFrame:RegisterEvent("RUNE_TYPE_UPDATE")
leizyrune_MainFrame:RegisterEvent("UNIT_ENTERED_VEHICLE")
leizyrune_MainFrame:RegisterEvent("UNIT_EXITED_VEHICLE")
leizyrune_MainFrame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
leizyrune_MainFrame:RegisterEvent("PET_BATTLE_OPENING_START")
leizyrune_MainFrame:RegisterEvent("PET_BATTLE_CLOSE")

leizyrune_MainFrame:SetScript("OnUpdate", function() setRuneCDs() end)

