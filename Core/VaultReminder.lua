local addonName, TR = ...

-- Add player-cast SpellIDs here to test the loot-spec reminder anywhere.
local VAULT_OPENING_SPELL_IDS = {
    [449976] = true,  -- Great Vault
    [1271478] = true, -- Great Vault (Silvermoon)
    [8936] = false, -- resto druid Regrowth for testing
}

local function GetLootSpecText()
    local specID = GetLootSpecialization()
    local specName, specIcon

    if specID == 0 then
        local activeSpecIndex = GetSpecialization()
        if not activeSpecIndex then
            return nil
        end
        _, specName, _, specIcon = GetSpecializationInfo(activeSpecIndex)
    else
        _, specName, _, specIcon = GetSpecializationInfoByID(specID)
    end

    if not specName or not specIcon then
        return nil
    end

    local _, class = UnitClass("player")
    local classColor = (RAID_CLASS_COLORS[class] and RAID_CLASS_COLORS[class].colorStr) or "FFFFFFFF"
    return "|c" .. classColor .. format("|T%d:0|t %s", specIcon, specName) .. "|r"
end

-- Track the exact cast and reminder shown by this module.
local activeCastGUID
local activeReminderToken

local function ClearActiveCast()
    activeCastGUID = nil
    activeReminderToken = nil
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("UNIT_SPELLCAST_START")
eventFrame:RegisterEvent("UNIT_SPELLCAST_STOP")
eventFrame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
eventFrame:RegisterEvent("UNIT_SPELLCAST_FAILED")

eventFrame:SetScript("OnEvent", function(_, event, unit, castGUID, spellID)
    if unit ~= "player" then
        return
    end

    if event == "UNIT_SPELLCAST_START" then
        -- A different cast replaces the tracked one; never stop another reminder.
        ClearActiveCast()
        if not TalentReminderDB or TalentReminderDB.showVaultLootSpec == false or not VAULT_OPENING_SPELL_IDS[spellID] then
            return
        end

        local message = GetLootSpecText()
        if message then
            TR.Reminder:Show(message, false)
            activeCastGUID = castGUID
            activeReminderToken = TR.Reminder:GetDisplayToken()
        end
        return
    end

    -- Only the same cast may dismiss the reminder it originally displayed.
    if activeCastGUID and castGUID == activeCastGUID then
        if activeReminderToken == TR.Reminder:GetDisplayToken() then
            TR.Reminder:Stop()
        end
        ClearActiveCast()
    end
end)
