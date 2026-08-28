local addonName, TR = ...

TR = TR or {}
_G[addonName] = TR

function TR:T(key)
    return (TalentReminderLocale and TalentReminderLocale[key]) or key
end
