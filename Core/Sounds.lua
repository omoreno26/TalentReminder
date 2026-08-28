local addonName, TR = ...

TR.Sound = {}

TR.Sound.WoWSounds = {
    { name = "Raid Warning", key = "RAID_WARNING" },
    { name = "Ready Check", key = "READY_CHECK" },
    { name = "Tell Message", key = "TELL_MESSAGE" },
    { name = "Level Up", key = "LEVEL_UP" },
}

local fallbackIDs = {
    RAID_WARNING = 8959,
    READY_CHECK = 8960,
    TELL_MESSAGE = 3081,
    LEVEL_UP = 888,
}

function TR.Sound:GetLSM()
    if type(LibStub) ~= "table" and type(LibStub) ~= "function" then
        return nil
    end

    local ok, lib = pcall(function()
        return LibStub("LibSharedMedia-3.0", true)
    end)

    if ok then
        return lib
    end
end

function TR.Sound:GetSoundKitID(key)
    if SOUNDKIT and SOUNDKIT[key] then
        return SOUNDKIT[key]
    end
    return fallbackIDs[key]
end

function TR.Sound:GetSelectedLabel()
    local db = TalentReminderDB
    if not db then
        return "Raid Warning"
    end

    if db.soundType == "NONE" then
        return TR:T("noSound")
    elseif db.soundType == "LSM" then
        return db.soundValue or "SharedMedia"
    end

    for _, sound in ipairs(self.WoWSounds) do
        if sound.key == db.soundValue then
            return sound.name
        end
    end

    return "Raid Warning"
end

function TR.Sound:Play()
    local db = TalentReminderDB
    if not db or db.soundType == "NONE" then
        return
    end

    if db.soundType == "LSM" then
        local LSM = self:GetLSM()
        if LSM then
            local soundPath = LSM:Fetch("sound", db.soundValue, true)
            if soundPath then
                PlaySoundFile(soundPath, "Master")
                return
            end
        end

        local fallback = self:GetSoundKitID("RAID_WARNING")
        if fallback then
            PlaySound(fallback, "Master")
        end
        return
    end

    local kit = self:GetSoundKitID(db.soundValue)
    if kit then
        PlaySound(kit, "Master")
    end
end
