TalentReminderLocale = TalentReminderLocale or {}

local locale = GetLocale()

if locale == "esES" or locale == "esMX" then
    TalentReminderLocaleCode = "es"
elseif locale == "deDE" then
    TalentReminderLocaleCode = "de"
elseif locale == "frFR" then
    TalentReminderLocaleCode = "fr"
elseif locale == "itIT" then
    TalentReminderLocaleCode = "it"
elseif locale == "ptBR" or locale == "ptPT" then
    TalentReminderLocaleCode = "pt"
elseif locale == "ruRU" then
    TalentReminderLocaleCode = "ru"
else
    TalentReminderLocaleCode = "en"
end
