local CAMERA_MOVEMENT_SPEED = .05
local SAVE_VIEW = true
local COUNTDOWN_TIME = 10

local countdownFrame
local countdownText

local function startCameraMovement()
    local cameraSmoothing = GetCVar("cameraSmoothStyle")
    if SAVE_VIEW then
        SaveView(5)
    end
    MoveViewLeftStart(CAMERA_MOVEMENT_SPEED)
    UIParent:Hide()
    countdownFrame:Hide()
end

local function stopCameraMovement()
    MoveViewLeftStop()
    if SAVE_VIEW then
        SetView(5)
    end
    UIParent:Show()
    SetCVar("cameraSmoothStyle", cameraSmoothing)
    countdownFrame:Hide()
end

local function onFlagChange(self, event, ...)
    if UnitIsAFK("player") and not C_PetBattles.IsInBattle() then
        countdownFrame:Show()
        countdownText:SetText(COUNTDOWN_TIME)
    else
        stopCameraMovement()
    end
end

local function onUpdate(self, elapsed)
    COUNTDOWN_TIME = COUNTDOWN_TIME - elapsed
    countdownText:SetText(math.floor(COUNTDOWN_TIME))
    if COUNTDOWN_TIME <= 0 then
        startCameraMovement()
    end
end



local function main()
    local f = CreateFrame("Frame", "AfkCameraFrame")
    f:RegisterEvent("PLAYER_FLAGS_CHANGED")
    f:SetScript("OnEvent", onFlagChange)

    countdownFrame = CreateFrame("Frame", nil, UIParent)
    countdownFrame:SetSize(100, 50)
    countdownFrame:SetPoint("TOP", UIParent, "TOP", 0, -50)

local countdownTitle = countdownFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    countdownTitle:SetPoint("TOP", countdownFrame, "TOP", 0, 0)
    countdownTitle:SetText("COUNTDOWN")
	countdownTitle:SetTextColor(1, 0, 0, 1)
    countdownTitle:SetFont ("Fonts\\FRIZQT__.TTF", 36)

    countdownText = countdownFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    countdownText:SetPoint("TOP", countdownTitle, "BOTTOM", 0, 0)
    countdownText:SetFont("Fonts\\FRIZQT__.TTF", 36)

    countdownFrame:SetScript("OnUpdate", onUpdate)
    countdownFrame:Hide()

end



main()


