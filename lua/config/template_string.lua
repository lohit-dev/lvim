-- template-string.nvim: auto-converts a string to a template literal (``)
-- the moment you type `${` inside it, and converts it back to a normal
-- string if you delete the last `${}`.
-- It was in vim.pack.add but never had .setup() called, so it was
-- effectively inert -- that's why nothing happened when typing "${".
require("template-string").setup {
  jsx_brackets = true, -- also handle `className={}` -> `className={``}` in jsx/tsx
  remove_template_string = true, -- turn `` back into "" when the last ${} is deleted
  filetypes = {
    "html",
    "typescript",
    "javascript",
    "typescriptreact",
    "javascriptreact",
    "vue",
    "svelte",
  },
}
