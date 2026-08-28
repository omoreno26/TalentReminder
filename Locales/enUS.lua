if TalentReminderLocaleCode ~= "en" then
    return
end

local L = TalentReminderLocale

L["title"] = "Talent Reminder"
L["subtitle"] = "Configure how the reminder appears when entering a tracked instance."
L["messageLabel"] = "Reminder text"
L["fontSize"] = "Font size"
L["duration"] = "Total duration"
L["fade"] = "Fade out"
L["world"] = "Notify in World"
L["sound"] = "Sound"
L["noSound"] = "No sound"
L["lsmFound"] = "LibSharedMedia detected: registered sounds are available in the list."
L["lsmMissing"] = "LibSharedMedia not detected: native WoW sounds are used."
L["move"] = "Move reminder"
L["lock"] = "Lock position"
L["test"] = "Test reminder"
L["center"] = "Center position"
L["moveHint"] = "Drag to move"
L["info"] = "instanceIDs are configured inside TalentReminder.lua and are not shown here.\nCommands: /tr, /tr test, /tr move, /tr id, /tr instances"
L["moveOn"] = "move mode enabled."
L["moveOff"] = "move mode disabled."
L["instance"] = "Instance"
L["worldInfo"] = "World = when WoW reports that you are not inside an instance."

L["textColor"] = "Text color"
L["color1"] = "White"
L["color2"] = "Red"
L["color3"] = "Green"
L["color4"] = "Orange"
