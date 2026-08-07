require("overseer").setup {
  task_list = {
    direction = "bottom",
    min_height = 20,
    max_height = 20,
    default_detail = 1,
  },
}

vim.keymap.set("n", "<leader>ot", "<cmd>OverseerToggle<cr>", { desc = "Toggle tasks" })

-- Close the vsplit from the last run before opening a new one, so repeat
-- runs replace the output in place instead of stacking vsplits sideways
-- forever. task:open_output("vertical") always does a plain vim.cmd.vsplit()
-- with no "reuse an existing window" option, so we track the window ourselves.
local last_output_win = nil

local function open_task_in_vsplit(task)
  if last_output_win and vim.api.nvim_win_is_valid(last_output_win) then
    vim.api.nvim_win_close(last_output_win, true)
  end
  require("overseer").run_action(task, "open vsplit")
  last_output_win = vim.api.nvim_get_current_win()
end

-- run_template (what :OverseerRun uses under the hood) is deprecated in favor
-- of run_task as of overseer 2026; same behavior, opts={} still triggers the
-- template picker. After you pick and it starts, force the "open vsplit"
-- action so you always see live output instead of just a pass/fail notify.
vim.keymap.set("n", "<leader>or", function()
  require("overseer").run_task({}, function(task, err)
    if err then
      vim.notify(err, vim.log.levels.ERROR)
      return
    end
    if not task then
      return
    end
    open_task_in_vsplit(task)
  end)
end, { desc = "Run task (vsplit output)" })

-- OverseerShell builds+starts the task itself with no completion callback,
-- so this bypasses the ":OverseerShell " command-line prefill and drives the
-- same new_task -> start -> "open vsplit" flow as <leader>or above, giving
-- custom one-off commands the same vsplit output instead of a silent
-- pass/fail notify.
vim.keymap.set("n", "<leader>oc", function()
  vim.ui.input({ prompt = "Shell command: " }, function(cmd)
    if not cmd or cmd == "" then
      return
    end
    local task = require("overseer").new_task { cmd = cmd }
    task:start()
    open_task_in_vsplit(task)
  end)
end, { desc = "Run custom command (vsplit output)" })

-- Task output buffers are filetype "OverseerOutput" -- scope `q`-to-close to
-- just those, so it doesn't hijack macro recording anywhere else.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "OverseerOutput",
  callback = function(args)
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = args.buf, silent = true, desc = "Close task output" })
  end,
})
