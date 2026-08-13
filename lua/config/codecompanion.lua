-- CodeCompanion, replacing ChatGPT.nvim.
--
-- Keys come from `pass` via zsh exports, never hardcoded here:
--   export GEMINI_API_KEY="$(pass show keys/gemini)"
--   export DEEPSEEK_API_KEY="$(pass show keys/deepseek)"
--   export OPENAI_API_KEY="$(pass show keys/openapi)"
--   export XAI_API_KEY="$(pass show keys/xai)"
--   export GROQ_API_KEY="$(pass show keys/groq)"
--   export COHERE_API_KEY="$(pass show keys/cohere)"
require("codecompanion").setup {
  adapters = {
    http = {
      groq = function()
        return require("codecompanion.adapters").extend("openai_compatible", {
          name = "groq",
          formatted_name = "Groq",
          env = {
            url = "https://api.groq.com/openai/v1",
            api_key = "GROQ_API_KEY",
            chat_url = "/chat/completions",
          },
          schema = {
            model = {
              default = "llama-3.3-70b-versatile",
            },
          },
        })
      end,
      cohere = function()
        return require("codecompanion.adapters").extend("openai_compatible", {
          name = "cohere",
          formatted_name = "Cohere",
          env = {
            url = "https://api.cohere.com/compatibility/v1",
            api_key = "COHERE_API_KEY",
            chat_url = "/chat/completions",
          },
          schema = {
            model = {
              default = "command-a-03-2025",
            },
          },
        })
      end,
    },
  },
  interactions = {
    chat = { adapter = "gemini" },
    inline = { adapter = "gemini" },
  },
}

-- Same leader-key shape as the old ChatGPT.nvim bindings it replaces.
vim.keymap.set({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Toggle CodeCompanion chat" })
vim.keymap.set({ "n", "v" }, "<leader>ae", "<cmd>CodeCompanion<cr>", { desc = "CodeCompanion inline edit" })
