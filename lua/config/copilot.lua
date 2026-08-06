-- GitHub Copilot inline (ghost-text) suggestions.
--
-- Requires Node.js on $PATH (the Copilot language server runs on Node) and a
-- one-time `:Copilot auth` after first launch.
--
local settings = require "config.settings"

require("copilot").setup {
  panel = { enabled = false },
  suggestion = {
    enabled = true,
    -- seeded from disk so a toggle survives a restart, see <leader>at below
    auto_trigger = settings.get "copilot_auto_trigger",
    hide_during_completion = true,
    keymap = {
      accept = "<C-l>",
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
  },
}

vim.keymap.set("n", "<leader>an", "<cmd>Copilot enable<cr>", { desc = "Enable Copilot" })
vim.keymap.set("n", "<leader>ad", "<cmd>Copilot disable<cr>", { desc = "Disable Copilot" })
vim.keymap.set("n", "<leader>as", "<cmd>Copilot status<cr>", { desc = "Copilot status" })

-- Toggles just the auto-trigger ghost-text (suggestions), not the whole
-- Copilot client -- <leader>an/<leader>ad above fully attach/detach it,
-- this just quiets the inline noise. Persisted via config.settings, same
-- pattern as <leader>tn for line numbers, so it's remembered next launch.
vim.keymap.set("n", "<leader>at", function()
  require("copilot.suggestion").toggle_auto_trigger()
  local enabled = not settings.get "copilot_auto_trigger"
  settings.set("copilot_auto_trigger", enabled)
  vim.notify("Copilot suggestions " .. (enabled and "enabled" or "disabled"), vim.log.levels.INFO)
end, { desc = "Toggle Copilot suggestions (remembered)" })
