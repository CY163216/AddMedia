-- 1. Setup the Confirmation Dialog
StaticPopupDialogs["ADDMEDIA_RELOAD"] = {
    text = "|cff00D1FFAddMedia:|r ElvUI Private Profile changed. Reload required.",
    button1 = "Reload UI",
    button2 = "Later",
    OnAccept = function() ReloadUI() end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
}

AddMedia = LibStub("AceAddon-3.0"):NewAddon("AddMedia", "AceConsole-3.0", "AceEvent-3.0")

local addonName = ...

-- 0. Optimized Inline Initialization
AddMediaDB = AddMediaDB or {}
-- local A = AddMediaDB

-- 1. Cache the function locally to avoid global lookups during execution
local function Sync(db, list)
    for i = 1, #list do
        local k = list[i]
        -- Short-circuit assignment: faster than 'if' blocks in modern Lua VMs
        db[k] = db[k] or {}
    end
end

-- 2. Your editable array
local mainKeys = {
    "clearedAH", 
    "bindpadOptions",
}

local playerEnteringWorldKeys = {
    "hiddenquests", 
    "disabledFriendlyNPCs", 
    "elvuiUpdated", 
    "cultQuest"
}

-- 3. Execute with local reference for top speed
Sync(AddMediaDB, mainKeys)
Sync(AddMediaDB, playerEnteringWorldKeys)

-- Optimized getter function
local function GetPlayerEnteringWorldKeys()
    return playerEnteringWorldKeys
end

local function IsReady(mynameRealm)
    -- Fallback to the local variable if no keys are passed
    local list = GetPlayerEnteringWorldKeys()
    local db = AddMediaDB
    
    for i = 1, #list do
        local k = list[i]
        -- Access the DB using the local nameRealm reference
        if not db[k] then
            -- print(("|cffFF8132AddMedia:|r DEBUG: FALSE %s (no table)"):format(k))
            return false 
        end
        if not db[k][mynameRealm] then
            -- print(("|cffFF8132AddMedia:|r DEBUG: FALSE %s"):format(k))
            return false 
        end
    end
    return true
end

-- Define your list of banker characters here (Case Sensitive)
local bindpadClasses = {
    -- ["MAGE"] = { ["realm"] = "Bloodhoof", ["name"] = "Burin", ["version"] = 3 },
    -- ["DEATHKNIGHT"] = { ["realm"] = "Bloodhoof", ["name"] = "Bari", ["version"] = 3 },
    -- ["SHAMAN"] = { ["realm"] = "Bloodhoof", ["name"] = "Borr", ["version"] = 3 },
    -- ["DEMONHUNTER"] = { ["realm"] = "Argent Dawn", ["name"] = "Mihoki", ["version"] = 3 },
    -- ["DRUID"] = { ["realm"] = "Bloodhoof", ["name"] = "Hipnox", ["version"] = 3 },
    -- ["WARRIOR"] = { ["realm"] = "Bloodhoof", ["name"] = "Jaiya", ["version"] = 3 },
    -- ["MONK"] = { ["realm"] = "Tarren Mill", ["name"] = "Gurabu", ["version"] = 3 },
    -- ["PALADIN"] = { ["realm"] = "Bloodhoof", ["name"] = "Burr", ["version"] = 3 },
    -- ["PRIEST"] = { ["realm"] = "Silvermoon", ["name"] = "Jinrami", ["version"] = 3 },
    -- ["EVOKER"] = { ["realm"] = "Silvermoon", ["name"] = "Fiyonse", ["version"] = 3 },
    -- ["ROGUE"] = { ["realm"] = "Tarren Mill", ["name"] = "Sumoka", ["version"] = 3 },
    -- ["HUNTER"] = { ["realm"] = "Bloodhoof", ["name"] = "Brokk", ["version"] = 3 },
    -- ["WARLOCK"] = { ["realm"] = "Tarren Mill", ["name"] = "Kinbo", ["version"] = 3 },

    ["MAGE"] = { ["realm"] = "Bloodhoof", ["name"] = "Burin", ["version"] = 2 },
    ["DEATHKNIGHT"] = { ["realm"] = "Bloodhoof", ["name"] = "Bari", ["version"] = 2.1 },
    ["SHAMAN"] = { ["realm"] = "Bloodhoof", ["name"] = "Borr", ["version"] = 2 },
    ["DEMONHUNTER"] = { ["realm"] = "Argent Dawn", ["name"] = "Mihoki", ["version"] = 2 },
    ["DRUID"] = { ["realm"] = "Moonglade", ["name"] = "Mokuroa", ["version"] = 2 },
    ["WARRIOR"] = { ["realm"] = "Bloodhoof", ["name"] = "Jaiya", ["version"] = 2 },
    ["MONK"] = { ["realm"] = "Tarren Mill", ["name"] = "Gurabu", ["version"] = 2 },
    ["PALADIN"] = { ["realm"] = "Bloodhoof", ["name"] = "Burr", ["version"] = 2 },
    ["PRIEST"] = { ["realm"] = "Silvermoon", ["name"] = "Jinrami", ["version"] = 2 },
    ["EVOKER"] = { ["realm"] = "Silvermoon", ["name"] = "Fiyonse", ["version"] = 2 },
    ["ROGUE"] = { ["realm"] = "Tarren Mill", ["name"] = "Sumoka", ["version"] = 2 },
    ["HUNTER"] = { ["realm"] = "Bloodhoof", ["name"] = "Brokk", ["version"] = 2.1 },
    ["WARLOCK"] = { ["realm"] = "Tarren Mill", ["name"] = "Kinbo", ["version"] = 2 },
}

-- Create the visual frame
local frame = CreateFrame("Frame", "WarmodeAlertFrame", UIParent)
frame:SetSize(600, 100)
frame:SetPoint("TOP", 0, -240)

local text = frame:CreateFontString(nil, "OVERLAY")
-- Fetch the font path from LibSharedMedia
local LSM = LibStub("LibSharedMedia-3.0", true)
local fontPath = LSM and LSM:Fetch("font", "TeX Bold") or "Fonts\\FRIZQT__.TTF"

-- Apply the font with a massive size (e.g., 72)
text:SetFont(fontPath, 48, "OUTLINE")
text:SetPoint("CENTER")
text:SetText("|cffff0000WARMODE ENABLED|r")

-- Update function
local function UpdateVisibility()
    -- Check if player is in a resting area and has Warmode enabled
    local isResting = IsResting()
    local isWarmodeActive = C_PvP.IsWarModeDesired()
    
    if isResting and isWarmodeActive then
        frame:Show()
    else
        frame:Hide()
    end
end

-- local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_UPDATE_RESTING")
frame:RegisterEvent("WAR_MODE_STATUS_UPDATE")
frame:RegisterEvent("PLAYER_FLAGS_CHANGED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("AUCTION_HOUSE_SHOW")
frame:RegisterEvent("AUCTION_HOUSE_BROWSE_RESULTS_UPDATED")
frame:RegisterEvent("ADDON_LOADED")


frame:SetScript("OnEvent", function(self, event, addon, ...)
    -- Use the "Name - Realm" format used by ElvUI
    local myname = UnitName("player")
    local myrealm = GetRealmName()
    local mynameRealm = format('%s - %s', myname, myrealm)
    local _, myclass = UnitClass("player")
    local mylevel = UnitLevel("player")

    UpdateVisibility()

    if event == "PLAYER_LOGIN" then
        -- 1. ElvUI Private Profile Logic
        if C_AddOns.IsAddOnLoaded("ElvUI") and not AddMediaDB.elvuiUpdated[mynameRealm] then
            -- 2. ElvUI Private Profile Logic
            if _G.ElvUI and not AddMediaDB.elvuiUpdated[mynameRealm] then
                -- if _G.ElvUI then
                local E = unpack(_G.ElvUI) 
                local targetPrivate = "midnight"
                local targetBanker = "banker"

                -- Define your list of banker characters here (Case Sensitive)
                local bankerChars = {
                    ["Melios"] = true,
                    ["Kujaku"] = true,
                    ["Jisumi"] = true,
                    ["Shipusuheddo"] = true,
                    ["Kozaburo"] = true,
                    ["Kurogan"] = true,
                    ["Cygnax"] = true,
                }

                -- B. Handle GLOBAL Profile (Apply ONLY if name is in the table)
                if bankerChars[myname] then
                    if _G.ElvDB and _G.ElvDB.profileKeys then
                        if _G.ElvDB.profileKeys[mynameRealm] ~= targetBanker then
                            if _G.ElvDB.profiles and _G.ElvDB.profiles[targetBanker] then
                                _G.ElvDB.profileKeys[mynameRealm] = targetBanker
                                print("|cff00D1FFAddMedia:|r Changed profile to banker profile '" .. targetBanker .. "'")
                            else
                                print("|cff00D1FFAddMedia:|r Global profile '" .. targetBanker .. "' not found!")
                            end
                        end
                    end
                end

                if ElvPrivateDB and ElvPrivateDB.profileKeys then
                    if ElvPrivateDB.profileKeys[mynameRealm] ~= targetPrivate then
                        -- Verify the profile exists in the DB before attempting switch
                        if ElvPrivateDB.profiles and ElvPrivateDB.profiles[targetPrivate] then
                            ElvPrivateDB.profileKeys[mynameRealm] = targetPrivate
                            AddMediaDB.elvuiUpdated[mynameRealm] = true
                            if ElvUIInstallFrame then
                                ElvUIInstallFrame:Hide()
                            end
                            if ElvUI_StaticPopup1 and ElvUI_StaticPopup1.which == "INCOMPATIBLE_ADDON" then
                                E:StaticPopup_Hide("INCOMPATIBLE_ADDON")
                            end
                            StaticPopup_Show("ADDMEDIA_RELOAD")
                            return -- HALT: Stop further execution of this event handler
                        else
                            print("|cff00D1FFAddMedia:|r Error - Private profile '" .. targetPrivate .. "' not found!")
                        end
                    elseif not AddMediaDB.elvuiUpdated[mynameRealm] then
                        AddMediaDB.elvuiUpdated[mynameRealm] = true
                    end
                end
            end
        end

        -- 2. Auction House Favorites Clear Logic
        if AddMediaDB.elvuiUpdated[mynameRealm] then
            if not AddMediaDB.clearedAH[mynameRealm] then
                print("|cffFF8132AddMedia:|r Open auction house")
            else
                self:UnregisterEvent("AUCTION_HOUSE_SHOW")
                self:UnregisterEvent("AUCTION_HOUSE_BROWSE_RESULTS_UPDATED")
            end
        end

        -- 2. The conditional logic
        if IsReady(mynameRealm) then  
            -- Optimization: Unregister specific heavy-hitters first
            self:UnregisterEvent("PLAYER_LOGIN")
        else
            -- 3. Remove Hidden Quests from Watch List (One-time check)
            if not AddMediaDB.hiddenquests[mynameRealm] then
                local numEntries = C_QuestLog.GetNumQuestLogEntries()
                for i = 1, numEntries do
                    local info = C_QuestLog.GetInfo(i)
                    -- Stop tracking quests that are marked 'hidden' but are being watched
                    if info and info.isHidden and C_QuestLog.GetQuestWatchType(info.questID) then
                        C_QuestLog.RemoveQuestWatch(info.questID)
                    end
                end
                AddMediaDB.hiddenquests[mynameRealm] = true
                -- print("|cff00D1FFAddMedia:|r Hidden quests tracking disabled")
            end

            -- 4. Disable Friendly NPC Nameplates (One-time check)
            if not AddMediaDB.disabledFriendlyNPCs[mynameRealm] then
                SetCVar("nameplateShowFriendlyNPCs", 0) -- Hides friendly NPC plates
                -- SetCVar("nameplateShowFriends", 0)      -- Hides friendly Player plates (optional)
                AddMediaDB.disabledFriendlyNPCs[mynameRealm] = true
                -- print("|cff00D1FFAddMedia:|r Friendly NPC nameplates disabled")
            end

            -- Remove Cult Quest (12.0) from quest log
            if not AddMediaDB.cultQuest then
                AddMediaDB.cultQuest = {}
                AddMediaDB.cultQuest[mynameRealm] = true
            elseif not AddMediaDB.cultQuest[mynameRealm] then
                -- 90764 -- Horde, The Cult Within
                -- 90759 -- Alliance, The Cult Within
                local questIDS = {90764, 90759}
                for _, questID in ipairs(questIDS) do
                    if C_QuestLog.IsOnQuest(questID) then
                        C_Timer.After(0.1, function()
                            local questName = C_QuestLog.GetTitleForQuestID(questID) or "Unknown Quest"
                            C_QuestLog.RemoveQuestWatch(questID)
                            -- print("|cff00D1FFAddMedia:|r Cult quest tracking disabld, ID " .. questID .. ": " .. questName)
                        end)
                    end
                end
                AddMediaDB.cultQuest[mynameRealm] = true
            end
        end

    -- 5. Clear AH Favorites on first visit
    elseif event == "AUCTION_HOUSE_SHOW" then
        if not AddMediaDB.clearedAH[mynameRealm] then
            C_AuctionHouse.SearchForFavorites({})
        else
            self:UnregisterEvent("AUCTION_HOUSE_SHOW")
            self:UnregisterEvent("AUCTION_HOUSE_BROWSE_RESULTS_UPDATED")
        end
        
    elseif event == "AUCTION_HOUSE_BROWSE_RESULTS_UPDATED" then
        if not AddMediaDB.clearedAH[mynameRealm] then
            local results = C_AuctionHouse.GetBrowseResults()
            if results and #results > 0 then
                for _, item in ipairs(results) do
                    C_AuctionHouse.SetFavoriteItem(item.itemKey, false)
                end
            end
            AddMediaDB.clearedAH[mynameRealm] = true
            print("|cff00FFC0AddMedia:|r Cleared AH favorites.")
            self:UnregisterEvent("AUCTION_HOUSE_SHOW")
            self:UnregisterEvent("AUCTION_HOUSE_BROWSE_RESULTS_UPDATED")
        end

    -- 6. BindPad Logic
    elseif event == "ADDON_LOADED" then
        if addon == addonName then
            if AddMediaDB.bindpadOptions[mynameRealm] ~= bindpadClasses[myclass]["version"] and bindpadClasses[myclass]["name"] ~= myname then
                -- 1. Check if BindPad already loaded before us
                if C_AddOns.IsAddOnLoaded("BindPad") then
                    C_Timer.After(0.1, function()
                        if BindPadFrame and not InCombatLockdown() then
                            -- ShowUIPanel(BindPadFrame)
                            local arg = bindpadClasses[myclass]["realm"] .. "_" .. bindpadClasses[myclass]["name"]
                            BindPadCore.DoCopyFrom(arg)
                        end
                    end)
                end
                AddMediaDB.bindpadOptions[mynameRealm] = bindpadClasses[myclass]["version"] 
            end
            self:UnregisterEvent("ADDON_LOADED")
        end
    end
end)

-- 5. Slash Command Logic
SLASH_ADDMEDIA1 = "/addmedia"
SlashCmdList["ADDMEDIA"] = function(msg)
    local myname = UnitName("player")
    local myrealm = GetRealmName()
    local mynameRealm = format('%s - %s', myname, myrealm)

    if msg == "reset" then
        -- Clear saved variables for this character
        AddMediaDB.hiddenquests[mynameRealm] = nil
        AddMediaDB.clearedAH[mynameRealm] = nil
        AddMediaDB.disabledFriendlyNPCs[mynameRealm] = nil
        AddMediaDB.elvuiUpdated[mynameRealm] = nil
        AddMediaDB.bindpadOptions[mynameRealm] = nil

        -- Re-register events so the script triggers again
        frame:RegisterEvent("PLAYER_LOGIN")
        frame:RegisterEvent("AUCTION_HOUSE_SHOW")
        frame:RegisterEvent("AUCTION_HOUSE_BROWSE_RESULTS_UPDATED")
        
        print("|cff00D1FFAddMedia:|r Data reset for " .. mynameRealm)
    elseif msg == "cult" then
        AddMediaDB.cultQuest[mynameRealm] = nil
        print("|cff00D1FFAddMedia:|r Cult quest data reset for " .. mynameRealm)
    else
        print("|cff00D1FFAddMedia:|r Usage: /addmedia reset")
    end
end
