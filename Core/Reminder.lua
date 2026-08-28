local addonName, TR = ...

TR.Reminder = {}

local frame
local text
local fadeGroup
local fadeAnim
local moveMode = false
local hideTimerToken = 0

function TR.Reminder:IsMoveMode()
    return moveMode
end

function TR.Reminder:ApplyPosition()
    if not frame or not TalentReminderDB then return end

    frame:ClearAllPoints()
    frame:SetPoint(
        TalentReminderDB.point or "CENTER",
        UIParent,
        TalentReminderDB.relativePoint or "CENTER",
        TalentReminderDB.posX or 0,
        TalentReminderDB.posY or 150
    )
end

function TR.Reminder:ApplyTextStyle()
    if not text or not TalentReminderDB then return end

    text:SetFont(
        "Fonts\\FRIZQT__.TTF",
        TalentReminderDB.fontSize or 36,
        "OUTLINE"
    )
    text:SetText(TalentReminderDB.message or "TALENT REMINDER!")
    local color = TalentReminderDB.textColor or TR.Defaults.textColor
    self.text:SetTextColor(color.r or 1, color.g or 1, color.b or 1, 1)

end

function TR.Reminder:SavePosition()
    if not frame then return end

    local point, _, relativePoint, x, y = frame:GetPoint(1)
    TalentReminderDB.point = point or "CENTER"
    TalentReminderDB.relativePoint = relativePoint or "CENTER"
    TalentReminderDB.posX = math.floor((x or 0) + 0.5)
    TalentReminderDB.posY = math.floor((y or 0) + 0.5)
end

function TR.Reminder:SetMoveMode(enabled)
    moveMode = enabled

    if enabled then
        hideTimerToken = hideTimerToken + 1

        if fadeGroup and fadeGroup:IsPlaying() then
            fadeGroup:Stop()
        end

        self:ApplyTextStyle()
        self:ApplyPosition()

        text:SetText(
            (TalentReminderDB.message or "TALENT REMINDER!") ..
            "\n|cffaaaaaa" .. TR:T("moveHint") .. "|r"
        )

        frame:SetAlpha(1)
        frame:EnableMouse(true)
        frame:RegisterForDrag("LeftButton")
        frame:Show()
    else
        frame:EnableMouse(false)
        frame:RegisterForDrag()
        self:ApplyTextStyle()
        frame:Hide()
    end
end

function TR.Reminder:Stop()
    hideTimerToken = hideTimerToken + 1

    if fadeGroup and fadeGroup:IsPlaying() then
        fadeGroup:Stop()
    end

    if frame then
        frame:SetAlpha(1)
        frame:Hide()
    end
end

function TR.Reminder:Show()
    if not TalentReminderDB or not frame then
        return
    end

    hideTimerToken = hideTimerToken + 1
    local token = hideTimerToken

    if fadeGroup:IsPlaying() then
        fadeGroup:Stop()
    end

    self:ApplyTextStyle()
    self:ApplyPosition()

    frame:SetAlpha(1)
    frame:Show()

    TR.Sound:Play()

    if moveMode then
        return
    end

    local duration = math.max(0.1, tonumber(TalentReminderDB.duration) or 5)
    local fadeTime = math.max(0, tonumber(TalentReminderDB.fadeTime) or 1)
    fadeTime = math.min(fadeTime, duration)

    local holdTime = math.max(0, duration - fadeTime)

    C_Timer.After(holdTime, function()
        if token ~= hideTimerToken or moveMode or not frame:IsShown() then
            return
        end

        if fadeTime <= 0 then
            frame:Hide()
            return
        end

        fadeAnim:SetDuration(fadeTime)
        fadeGroup:Play()
    end)
end

function TR.Reminder:Initialize()
    frame = CreateFrame("Frame", "TalentReminderDisplayFrame", UIParent)
    frame:SetSize(900, 120)
    frame:SetFrameStrata("HIGH")
    frame:SetMovable(true)
    frame:SetClampedToScreen(true)
    frame:EnableMouse(false)

    text = frame:CreateFontString(nil, "OVERLAY")
    text:SetPoint("CENTER")
    text:SetJustifyH("CENTER")
    text:SetJustifyV("MIDDLE")
    text:SetShadowOffset(1, -1)

    frame:SetScript("OnDragStart", function(self)
        if moveMode then
            self:StartMoving()
        end
    end)

    frame:SetScript("OnDragStop", function(self)
        if not moveMode then return end
        self:StopMovingOrSizing()
        TR.Reminder:SavePosition()
    end)

    fadeGroup = frame:CreateAnimationGroup()
    fadeAnim = fadeGroup:CreateAnimation("Alpha")
    fadeAnim:SetFromAlpha(1)
    fadeAnim:SetToAlpha(0)
    fadeAnim:SetOrder(1)

    fadeGroup:SetScript("OnFinished", function()
        if not moveMode then
            frame:Hide()
            frame:SetAlpha(1)
        end
    end)

    self:ApplyTextStyle()
    self:ApplyPosition()
    frame:Hide()
end
