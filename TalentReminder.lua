local addonName, TR = ...

local eventFrame = CreateFrame("Frame")

local function CheckCurrentInstance()
    local instanceName, instanceType, difficultyID, difficultyName,
          maxPlayers, dynamicDifficulty, isDynamic, instanceID = GetInstanceInfo()

    if TR.Instances:IsTracked(instanceID) then
        TR.Reminder:Show()
        return
    end

    if TalentReminderDB.remindInWorld and TR.Instances:IsWorld(instanceID) then
        TR.Reminder:Show()
    end
end

local function PrintCurrentInstance()
    local instanceName, instanceType, difficultyID, difficultyName,
          maxPlayers, dynamicDifficulty, isDynamic, instanceID = GetInstanceInfo()

    print("|cffffcc00Talent Reminder|r")
    print(TR:T("instance") .. ": " .. tostring(instanceName))
    print("instanceID: " .. tostring(instanceID))
    print("difficultyID: " .. tostring(difficultyID))
end

SLASH_TALENTREMINDER1 = "/tr"
SLASH_TALENTREMINDER2 = "/talentreminder"

SlashCmdList["TALENTREMINDER"] = function(msg)
    msg = (msg or ""):lower():match("^%s*(.-)%s*$")

    if msg == "test" then
        TR.Reminder:Show()
    elseif msg == "instances" or msg:match("^instances%s") then
        local args = msg:match("^instances%s*(.-)%s*$") or ""
        local first, second = args:match("^(%S+)%s*(%S*)$")

        if not first or first == "" then
            TR.InstanceDump:Print("all")
        elseif first == "all" or first == "dungeons" or first == "dungeon"
            or first == "raids" or first == "raid"
            or first == "delves" or first == "delve" then
            TR.InstanceDump:Print(first, second ~= "" and second or nil)
        else
            TR.InstanceDump:Print(second ~= "" and second or "all", first)
        end
    elseif msg == "move" then
        TR.Reminder:SetMoveMode(not TR.Reminder:IsMoveMode())
        print("|cffffcc00Talent Reminder:|r " ..
            (TR.Reminder:IsMoveMode() and TR:T("moveOn") or TR:T("moveOff")))
    elseif msg == "id" then
        PrintCurrentInstance()
    elseif msg == "stop" then
        TR.Reminder:SetMoveMode(false)
        TR.Reminder:Stop()
    else
        TR.Options:Open()
    end
end

eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

eventFrame:SetScript("OnEvent", function(_, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
        TalentReminderDB = TalentReminderDB or {}
        TR:CopyDefaults(TR.Defaults, TalentReminderDB)

        TR.Reminder:Initialize()
        TR.Options:Initialize()

        eventFrame:UnregisterEvent("ADDON_LOADED")
        return
    end

    if event == "PLAYER_ENTERING_WORLD" then
        C_Timer.After(0.5, CheckCurrentInstance)
    end
end)
