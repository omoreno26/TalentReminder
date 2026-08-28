TalentReminderLocale = TalentReminderLocale or {}

local locale = GetLocale()

if locale == "esES" or locale == "esMX" then
    TalentReminderLocaleCode = "es"
else
    TalentReminderLocaleCode = "en"
end
