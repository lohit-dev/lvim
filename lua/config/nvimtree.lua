-- Mirrors NvChad's nvim-tree setup: lua/nvchad/configs/nvimtree.lua (core
-- defaults) + lua/plugins/tree.lua (the natural-number sort override and
-- view.side = "right") from lohit-dev/nvchad_config. The one thing NOT
-- replicated is `dofile(vim.g.base46_cache .. "nvimtree")` -- that's NvChad's
-- theme engine painting the tree to match the active base46 colorscheme.
-- lvim has no base46, so the tree just inherits highlights from whatever
-- colorscheme you have active, same as every other plugin in this config.

require("nvim-tree").setup {
  disable_netrw = true,
  hijack_cursor = true,
  sync_root_with_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = false,
  },
  filters = { dotfiles = false },
  git = { enable = true },
  view = {
    width = 30,
    side = "right",
    preserve_window_proportions = true,
  },
  renderer = {
    root_folder_label = false,
    highlight_git = true,
    indent_markers = { enable = true },
    icons = {
      glyphs = {
        default = "󰈚",
        folder = {
          default = "",
          empty = "",
          empty_open = "",
          open = "",
          symlink = "",
        },
        git = { unmerged = "" },
      },
    },
  },
  -- Natural sort: 1, 2, 10, 27 ... instead of the lexical 1, 10, 2, 27 ...
  sort = {
    sorter = function(nodes)
      local function natural_less(left, right)
        local a, b = left:lower(), right:lower()
        local i, j = 1, 1

        while i <= #a and j <= #b do
          local char_a, char_b = a:sub(i, i), b:sub(j, j)
          if char_a:match "%d" and char_b:match "%d" then
            local number_a = a:match("%d+", i)
            local number_b = b:match("%d+", j)
            local trimmed_a = number_a:gsub("^0+", "")
            local trimmed_b = number_b:gsub("^0+", "")
            trimmed_a = trimmed_a == "" and "0" or trimmed_a
            trimmed_b = trimmed_b == "" and "0" or trimmed_b

            if #trimmed_a ~= #trimmed_b then
              return #trimmed_a < #trimmed_b
            end
            if trimmed_a ~= trimmed_b then
              return trimmed_a < trimmed_b
            end
            i = i + #number_a
            j = j + #number_b
          else
            if char_a ~= char_b then
              return char_a < char_b
            end
            i, j = i + 1, j + 1
          end
        end

        return #a < #b
      end

      table.sort(nodes, function(a, b)
        if a.type ~= b.type and (a.type == "directory" or b.type == "directory") then
          return a.type == "directory"
        end
        return natural_less(a.name, b.name)
      end)
    end,
  },
}

-- Same two bindings NvChad ships: <C-n> toggles, <leader>e focuses (opening
-- it if closed). lvim's <leader>e used to open oil; this replaces it 1:1.
vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle file tree" })
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeFocus<cr>", { desc = "Focus file tree" })
