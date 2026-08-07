-- nvim-treesitter 'main' branch — full rewrite, Neovim 0.12+ only.
-- Requires the tree-sitter CLI on PATH (not the npm package):
--   brew install tree-sitter

require("nvim-treesitter").setup {}

-- Core languages: installed eagerly on startup so the ones you use daily
-- have zero first-open lag.
local core_parsers = {
  "go",
  "gomod",
  "gowork",
  "gosum",
  "rust",
  "typescript",
  "tsx",
  "javascript",
  "jsdoc",
  "dockerfile",
  "yaml",
  "html",
  "lua",
  "vim",
  "vimdoc",
  "query",
  "markdown",
  "markdown_inline",
}
require("nvim-treesitter").install(core_parsers)

-- Everything else: install-on-demand for ANY filetype that has an available
-- treesitter parser, not just the core list above. First time you open a
-- new language there's a beat of lag while its parser compiles in the
-- background; vim.treesitter.start() then kicks in automatically and every
-- open after that is instant, same as the core list.
local ts_parsers = require "nvim-treesitter.parsers"
local ts_config = require "nvim-treesitter.config"

-- Tracks languages currently being installed so opening several buffers of
-- a brand-new filetype at once doesn't fire off duplicate installs.
local installing = {} ---@type table<string, boolean>

local function start_treesitter(bufnr, lang)
  local ok = pcall(vim.treesitter.start, bufnr, lang)
  if not ok then
    return
  end
  vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
  vim.wo[0][0].foldmethod = "expr"
  vim.wo[0][0].foldenable = false -- don't collapse everything on open
  vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end

local ft_group = vim.api.nvim_create_augroup("treesitter-start", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = ft_group,
  pattern = "*",
  callback = function(args)
    local ft = args.match
    -- Skip special buffers (Telescope prompts, oil, quickfix, etc.) and
    -- filetype-less scratch buffers -- there's nothing sensible to attach
    -- treesitter to there.
    if ft == "" or vim.bo[args.buf].buftype ~= "" then
      return
    end

    local lang = vim.treesitter.language.get_lang(ft) or ft
    if not ts_parsers[lang] then
      return -- no treesitter grammar exists for this language at all
    end

    if vim.list_contains(ts_config.get_installed "parsers", lang) then
      start_treesitter(args.buf, lang)
      return
    end

    if installing[lang] then
      return -- already installing, this buffer will pick it up next open
    end
    installing[lang] = true

    require("nvim-treesitter").install(lang):await(function(err)
      installing[lang] = nil
      if err then
        vim.notify("Treesitter: failed to install " .. lang, vim.log.levels.WARN)
        return
      end
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(args.buf) then
          start_treesitter(args.buf, lang)
        end
      end)
    end)
  end,
})
