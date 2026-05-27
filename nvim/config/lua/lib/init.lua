local M = {}

---Checks if some LSP server is active.
---@return boolean # True if the LSP server is active, false otherwise.
function M.is_lsp_active(lsp_name)
  local clients = vim.lsp.get_clients()
  for _, client in ipairs(clients) do
    if client.name == lsp_name then
      return true -- LSP is active
    end
  end
  return false -- LSP is not active
end

---Checks if the current mode is visual.
---@return boolean # True if in visual mode, false otherwise.
function M.is_visual_mode()
  local mode = vim.fn.mode()
  return mode == 'v' or mode == 'V' or mode == '\22' -- '\22' is the character for CTRL-V
end

---Checks if the current mode is visual.
---@return boolean # True if in normal mode, false otherwise.
function M.is_normal_mode()
  return vim.api.nvim_get_mode().mode == "n"
end

function M.start_command(command)
  vim.api.nvim_feedkeys(':' .. command .. ' ', vim.api.nvim_get_mode().mode, false)
end

function M.get_command(command)
  return "<cmd>" .. command .. "<cr>"
end

function M.press(key)
  local final_key = vim.api.nvim_replace_termcodes(key, true, false, true)
  vim.api.nvim_feedkeys(final_key, 'n', false)
end

function M.run_command(command)
  local final_command = vim.api.nvim_replace_termcodes("<cmd>" .. command .. "<cr>", true, false, true)
  vim.api.nvim_feedkeys(final_command, 'n', false)
end

function M.set_registry(name, value)
  vim.fn.setreg(name, value)
end

function M.get_registry(name)
  vim.fn.getreg(name)
end

function M.get_last_yanked()
  return M.get_registry('"')
end

function M.copy_last_yank()
  return M.copy_to_clipboard(M.get_last_yanked())
end

function M.to_clipboard(text)
  M.set_registry('+', text)
  vim.fn.system({ 'pbcopy' }, text)
end

function M.get_visual_selection()
  -- Returns the text currently selected in visual mode (character, line or block).
  local bufnr = vim.api.nvim_get_current_buf()
  local mode = vim.fn.mode()

  -- Get start and end marks for visual selection
  local start_pos = vim.fn.getpos("'") -- fallback to current cursor if marks not set
  local start_mark = vim.fn.getpos("'<")
  local end_mark = vim.fn.getpos("'>")

  -- Use the visual marks when available
  local s_row = start_mark[2]
  local s_col = start_mark[3]
  local e_row = end_mark[2]
  local e_col = end_mark[3]

  -- Convert to 0-indexed rows and 0-indexed start column (Lua strings are 1-indexed so we'll adjust when slicing)
  local start_row = math.max(0, s_row - 1)
  local start_col = math.max(0, s_col - 1)
  local end_row = math.max(0, e_row - 1)
  local end_col = math.max(0, e_col) -- keep end_col as 1-indexed for string.sub usage on last line

  -- Ensure ordering: start <= end
  if start_row > end_row or (start_row == end_row and start_col > (end_col - 1)) then
    start_row, end_row = end_row, start_row
    start_col, end_col = (end_col - 1), (start_col + 1)
  end

  -- Handle linewise visual
  if mode == 'V' then
    local lines = vim.api.nvim_buf_get_lines(bufnr, start_row, end_row + 1, false)
    return table.concat(lines, "\n")
  end

  -- Handle characterwise visual
  if mode == 'v' then
    if start_row == end_row then
      local line = vim.api.nvim_buf_get_lines(bufnr, start_row, start_row + 1, false)[1] or ""
      -- start_col is 0-indexed, end_col is 1-indexed -> string.sub uses 1-indexing
      return string.sub(line, start_col + 1, end_col)
    end

    local parts = {}
    -- first line: from start_col to end
    local first = vim.api.nvim_buf_get_lines(bufnr, start_row, start_row + 1, false)[1] or ""
    table.insert(parts, string.sub(first, start_col + 1))

    -- middle full lines (if any)
    if end_row - start_row > 1 then
      local middle = vim.api.nvim_buf_get_lines(bufnr, start_row + 1, end_row, false)
      for _, l in ipairs(middle) do table.insert(parts, l) end
    end

    -- last line: from start to end_col
    local last = vim.api.nvim_buf_get_lines(bufnr, end_row, end_row + 1, false)[1] or ""
    table.insert(parts, string.sub(last, 1, end_col))

    return table.concat(parts, "\n")
  end

  -- Handle block visual (CTRL-V)
  if mode == '\22' then
    local s_col = start_col
    local e_col = (end_col - 1)
    if s_col > e_col then s_col, e_col = e_col, s_col end

    local lines = {}
    for row = start_row, end_row do
      local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1] or ""
      -- string.sub uses 1-indexing, so add 1 to both column indexes
      table.insert(lines, string.sub(line, s_col + 1, e_col + 1))
    end
    return table.concat(lines, "\n")
  end

  -- If not in a recognized visual mode, return empty string
  return ""
end

function M.copy_file_name()
  local file_name = vim.fn.expand('%:p')
  M.to_clipboard(file_name)
  Snacks.notify('Copied current file path to clipboard. \n\npath: ' .. file_name)
end

local wk = require("which-key")
wk.add({
  "<leader>co",
  function()
    local text = M.get_visual_selection()
    if text ~= "" then
      M.to_clipboard(text)
      Snacks.notify('Copied visual selection to clipboard.')
      Snacks.notify(text)
    else
      Snacks.notify('No visual selection found to copy.')
    end
  end,
  mode = { "v" },
})

return M
