-- Define the Popup Dialog
StaticPopupDialogs["VAULT_REWARD_AVAILABLE"] = {
    text = "You have unclaimed rewards in the Great Vault!",
    button1 = "Got it",
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,
}

-- Function to check rewards
local function CheckVaultRewards()
    -- Midnight 12.0 API sync check
    if C_WeeklyRewards.HasAvailableRewards() then
        StaticPopup_Show("VAULT_REWARD_AVAILABLE")
        -- print("|cFFFFD700[VaultWarning]:|r Weekly reward available!")
    end
end

-- Use EventRegistry instead of CreateFrame
-- This hooks directly into the Midnight event bus
EventRegistry:RegisterCallback("PLAYER_ENTERING_WORLD", function()
    -- Delay for 3 seconds to let server data stabilize
    C_Timer.After(3, CheckVaultRewards)
end)