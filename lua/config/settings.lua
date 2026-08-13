local M = {}

local state_dir = vim.fn.stdpath "state"
local state_file = state_dir .. "/lvim-settings.json"
local values = {
  inlay_hints = true,
  line_numbers = true,
  -- Off until you explicitly toggle it on with <leader>at (see
  -- config.copilot). A fresh clone has no state file yet, so this default
  -- is what actually applies right after `git clone` -- keeping it false
  -- means Copilot never starts throwing ghost text at you unasked.
  copilot_auto_trigger = false,
}

if vim.fn.filereadable(state_file) == 1 then
  local ok, saved = pcall(vim.json.decode, table.concat(vim.fn.readfile(state_file), "\n"))
  if ok and type(saved) == "table" then
    for key, default in pairs(values) do
      if type(saved[key]) == type(default) then
        values[key] = saved[key]
      end
    end
  end
end

function M.get(key)
  return values[key]
end

function M.set(key, value)
  values[key] = value
  vim.fn.mkdir(state_dir, "p")
  vim.fn.writefile({ vim.json.encode(values) }, state_file)
end

return M
