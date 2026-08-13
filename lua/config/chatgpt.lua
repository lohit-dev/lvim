-- Chat/explain-in-buffer AI, replacing CopilotChat. Needs only an
-- OPENAI_API_KEY env var (or api_key_cmd below) -- no separate GitHub
-- Copilot subscription/auth required for this part.
require("chatgpt").setup {
  -- api_key_cmd = "op read op://Private/openai-api-key/credential --no-newline",
}

vim.keymap.set("n", "<leader>aa", "<cmd>ChatGPT<cr>", { desc = "Toggle ChatGPT" })
vim.keymap.set("n", "<leader>ae", "<cmd>ChatGPTEditWithInstructions<cr>", { desc = "Edit with ChatGPT instructions" })
vim.keymap.set("x", "<leader>ae", "<cmd>ChatGPTEditWithInstructions<cr>", { desc = "Edit selection with ChatGPT instructions" })
