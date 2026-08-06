-- ts-error-translator.nvim: rewrites TS error codes (TS2322, TS2339, ...)
-- into plain-English explanations, shown as a normal diagnostic.
--
-- It only patches servers whose LSP client name is in `servers` below. Your
-- client is defined in lsp/tsc.lua and is named "tsc" (native config -- the
-- client name comes from the filename, not the binary), so the plugin's
-- defaults (ts_ls, tsserver, vtsls, ...) would silently never match. Adding
-- "tsc" here is what actually makes it attach.
require("ts-error-translator").setup {
  auto_attach = true,
  servers = { "tsc" },
}
