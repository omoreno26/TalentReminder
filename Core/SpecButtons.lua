local addonName, TR = ...

TR.SpecButtons = TR.SpecButtons or {}

local addon = CreateFrame("Frame")
local container
local hookedTalentFrame

local function GetTalentFrame()
    return PlayerSpellsFrame and PlayerSpellsFrame.TalentsFrame
end

local function UpdateButton(button)
    local specIndex = button:GetID()
    if C_SpecializationInfo.GetSpecialization() == specIndex then
        button:Disable()
        button:DesaturateHierarchy(0)
    else
        button:Enable()
        button:DesaturateHierarchy(1)
    end
end

local function UpdateContainer()
    if not container then return end

    for _, button in pairs(container.buttons) do
        UpdateButton(button)
    end

    local talentFrame = GetTalentFrame()
    if talentFrame and talentFrame.IsInspecting and talentFrame:IsInspecting() then
        container:Hide()
    else
        container:Show()
    end
end

local buttonMixin = {}

function buttonMixin:OnEnter()
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetText(self.name)
    GameTooltip:AddLine(TR:T("specButtonTooltip"))
    GameTooltip:Show()
end

function buttonMixin:OnLeave()
    GameTooltip:Hide()
end

function buttonMixin:OnClick()
    local specIndex = self:GetID()
    if C_SpecializationInfo.GetSpecialization() == specIndex then return end

    C_SpecializationInfo.SetSpecialization(specIndex)

    local talentFrame = GetTalentFrame()
    if talentFrame and talentFrame.SetCommitStarted then
        talentFrame:SetCommitStarted(0)
    end
end

function buttonMixin:OnEvent()
    UpdateButton(self)
end

local function Setup()
    local talentFrame = GetTalentFrame()
    if not talentFrame or not talentFrame.PvPTalentSlotTray or not talentFrame.PvPTalentSlotTray.Label then
        return false
    end

    -- If Blizzard has rebuilt the talent frame, rebuild our hook/container.
    if hookedTalentFrame ~= talentFrame then
        hookedTalentFrame = talentFrame

        if container then
            container:Hide()
            container = nil
        end

        container = CreateFrame("Frame", nil, talentFrame)
        talentFrame.TalentSpecButtonsContainer = container
        container.buttons = {}

        for specIndex = 1, GetNumSpecializations() do
            local _, name, _, icon = C_SpecializationInfo.GetSpecializationInfo(specIndex)

            local button = CreateFrame(
                "Button",
                nil,
                container,
                "UIPanelButtonNoTooltipTemplate, UIButtonTemplate"
            )
            Mixin(button, buttonMixin)

            button:SetSize(40, 40)
            button.name = name
            button:SetID(specIndex)

            -- Exactly the same icon call as TalentTreeTweaks.
            button:SetNormalTexture(icon)

            button:SetScript("OnEnter", buttonMixin.OnEnter)
            button:SetScript("OnLeave", buttonMixin.OnLeave)
            button:SetScript("OnClick", buttonMixin.OnClick)
            button:SetScript("OnEvent", buttonMixin.OnEvent)
            button:RegisterEvent("ACTIVE_PLAYER_SPECIALIZATION_CHANGED")
            button:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED")

            container["RespecButton" .. specIndex] = button
            container.buttons[specIndex] = button

            button:OnEvent("ACTIVE_PLAYER_SPECIALIZATION_CHANGED")

            button:ClearAllPoints()
            if specIndex == 1 then
                button:SetPoint("LEFT", container, "LEFT", 0, 0)
            else
                button:SetPoint("LEFT", container.buttons[specIndex - 1], "RIGHT", 1, 0)
            end

            button:Show()
        end

        container:SetSize(41 * GetNumSpecializations(), 40)
        container:ClearAllPoints()
        container:SetPoint("RIGHT", talentFrame.PvPTalentSlotTray.Label, "LEFT", -20, 0)
        container:Show()

        -- This is the same lifecycle hook used by TalentTreeTweaks.
        hooksecurefunc(talentFrame, "UpdateInspecting", UpdateContainer)

        -- Also cover opening/closing the parent window.
        talentFrame:HookScript("OnShow", function()
            C_Timer.After(0, UpdateContainer)
        end)
    end

    UpdateContainer()
    return true
end

local function TrySetup()
    if not Setup() then
        C_Timer.After(0.2, TrySetup)
    end
end

addon:RegisterEvent("PLAYER_LOGIN")
addon:RegisterEvent("PLAYER_ENTERING_WORLD")
addon:RegisterEvent("ACTIVE_PLAYER_SPECIALIZATION_CHANGED")
addon:RegisterEvent("TRAIT_CONFIG_LIST_UPDATED")

addon:SetScript("OnEvent", function(_, event)
    if event == "ACTIVE_PLAYER_SPECIALIZATION_CHANGED" or event == "TRAIT_CONFIG_LIST_UPDATED" then
        if container then
            for _, button in pairs(container.buttons) do
                button:OnEvent()
            end
        end
        return
    end

    TrySetup()
end)

TrySetup()
