--- Keymap Configuration
-- This file defines all keymaps for Neovim using which-key.nvim.
-- Helper functions for keymap processing are located in app.mapping_helpers.
--
-- @see app.mapping_helpers

if vim.g.vscode then return end

local lib = require('lib')
local _ = require('lib.fp')
local pred = require('lib.predicate')
local app_workspace = require "app.workspace"
local wk = require("which-key")
local mapping_helpers = require("app.mapping_helpers")

vim.keymap.set({ 'n', 'x' }, 's', '<Nop>')

_G.buffer_calls = {
  next = lib.get_command("BufferLineCycleNext"),
  previous = lib.get_command("BufferLineCyclePrev"),
  delete = function() Snacks.bufdelete.delete() end,
  only = function() Snacks.bufdelete.other() end,
}

-- Utility functions are now in app.mapping_helpers
_G.code_companion_call = mapping_helpers.code_companion_call

-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local TEST_FILE_PATTERN = {
  "*.test.js",
  "*.test.jsx",
  "*.test.ts",
  "*.test.tsx",
  "*.spec.js",
  "*.spec.jsx",
  "*.spec.ts",
  "*.spec.tsx",
}

local FILETYPE_MAP = {
  CODE_COMPANION = "codecompanion"
}

-- Keymaps converted to which-key format
-- Note: Leader key disable is handled by which-key's default behavior

-- Map jj as <Esc> for faster exit from insert mode
wk.add({
  "jj",
  function() vim.cmd.stopinsert() end,
  mode = { "i" },
  desc = "Escape from insert mode (jj)",
})

-- Clear search highlighting with 2x <leader>
wk.add({
  "<space><space>",
  function() vim.cmd.nohlsearch() end,
  mode = { "n" },
  desc = "Clear search highlighting",
})

-- Indentation helpers (normal and visual modes)
wk.add({
  "<Tab>",
  function() vim.cmd.normal(">>") end,
  mode = { "n" },
  desc = "Indent line(s)",
})

wk.add({
  "<Tab>",
  function() vim.cmd.normal(">gv") end,
  mode = { "v" },
  desc = "Indent line(s)",
})

wk.add({
  "<S-Tab>",
  function() vim.cmd.normal("<<") end,
  mode = { "n" },
  desc = "Unindent line(s)",
})

wk.add({
  "<S-Tab>",
  function() vim.cmd.normal("<gv") end,
  mode = { "v" },
  desc = "Unindent line(s)",
})

wk.add({
  "#",
  function()
    local search_term = lib.get_visual_selection()
    search_term = search_term:gsub("\n", "\\n")
    lib.press("<esc>?\\V" .. search_term .. "<CR>")
  end,
  mode = { "v" },
  desc = "Visual # search (escaped)",
})

-- Escape from terminal mode
wk.add({
  "<Esc>",
  function() vim.cmd.stopinsert() end,
  mode = { "t" },
  desc = "Escape from terminal mode",
})

-- Show which-key help for buffer-local mappings
wk.add({
  "<leader>?",
  function()
    require("which-key").show({ global = false })
  end,
  mode = { "n" },
  desc = "Buffer Local Keymaps (which-key)",
})

-- Notifications group
wk.add({
  "<leader>n",
  group = "Notifications",
  mode = { "n" },
  {
    "<leader>nn",
    Snacks.notifier.show_history,
    mode = { "n" },
    desc = "Snacks: show notification history"
  },
  {
    "<leader>nq",
    Snacks.notifier.hide,
    mode = { "n" },
    desc = "Snacks: hide all notifications"
  },
})


wk.add({
  "K",
  function()
    vim.lsp.buf.hover({
      height = 100,
      border = true,
    })
  end,
  desc = "LSP: Show hover documentation",
  icon = " ",
  mode = { "n" },
})

wk.add({
  "<S-K>",
  function()
    local cur = vim.api.nvim_get_current_win()
    local cfg = vim.api.nvim_win_get_config(cur)
    -- If we're inside a float (e.g. focused hover), close it
    if cfg.relative ~= "" then
      vim.api.nvim_win_close(cur, true)
      return
    end
    -- Otherwise show hover (don't close other floats: avoids blocking hover when another UI float exists)
    vim.lsp.buf.hover({ height = 100, border = true })
  end,
  desc = "LSP: Show hover; close hover if focused in float",
  icon = " ",
  mode = { "n" },
})

wk.add({
  "<leader>a",
  group = " Code Actions",
  icon = " ",
  {
    "<leader>af",
    require('format-on-save').format,
    mode = { 'n' },
    desc = "LSP: Format current buffer",
    icon = " "
  },
  {
    "<leader>ar",
    function() vim.lsp.buf.rename() end,
    desc = "LSP: Rename symbol",
    icon = "󰑕 ",
    mode = { "n" },
  },
  {
    "<leader>ac",
    vim.lsp.buf.code_action,
    desc = "LSP: Code action",
    icon = "",
    mode = { "n", "v" },
  },
  {
    "<leader>aa",
    vim.lsp.buf.code_action,
    desc = "LSP: Code action",
    icon = "",
    mode = { "n", "v" },
  },
})

wk.add({
  "]",
  group = " Movement   Next (])",
  icon = " ",
  mode = { "n" },
  {
    "]d",
    function() vim.diagnostic.jump({ count = 1 }) end,
    desc = "Next diagnostic",
    icon = " ",
  },
  {
    "]]",
    function() Snacks.words.jump(vim.v.count1) end,
    desc = "Next Reference",
    icon = " ",
  },
  {
    "]t",
    function() vim.cmd.tabnext() end,
    desc = "next tab",
    icon = " ",
  },
})

wk.add({
  "[",
  group = " Movement   Previous ([)",
  icon = " ",
  mode = { "n" },
  {
    "[d",
    function() vim.diagnostic.jump({ count = -1 }) end,
    desc = "Previous diagnostic",
    icon = " ",
  },
  {
    "[[",
    function() Snacks.words.jump(-vim.v.count1) end,
    desc = "Prev Reference",
    icon = " ",
  },
  {
    "[t",
    function() vim.cmd.tabprevious() end,
    desc = "previous tab",
    icon = " ",
  },
})

wk.add({
  "m",
  group = " Movement   Previous (m)",
  icon = " ",
  mode = { "n" },
  {
    "md",
    function() vim.diagnostic.goto_prev() end,
    desc = "Previous diagnostic",
    icon = " ",
  },
  {
    "mm",
    function() Snacks.words.jump(-vim.v.count1) end,
    desc = "Prev Reference",
    icon = " ",
  },
  {
    "mt",
    function() vim.cmd.tabprevious() end,
    desc = "previous tab",
    icon = " ",
  },
  {
    "mb",
    buffer_calls.previous,
    desc = "previous buffer",
    icon = " ",
  },
})

wk.add({
  ",",
  group = " Movement   Next (,)",
  icon = " ",
  mode = { "n" },
  {
    ",d",
    function() vim.diagnostic.goto_next() end,
    desc = "Next diagnostic",
    icon = " ",
  },
  {
    ",,",
    function() Snacks.words.jump(vim.v.count1) end,
    desc = "Next Reference",
    icon = " ",
  },
  {
    ",t",
    function() vim.cmd.tabnext() end,
    desc = "next tab",
    icon = " ",
  },
  {
    ",b",
    buffer_calls.next,
    desc = "next buffer",
    icon = " ",
  },
})

wk.add({
  "<leader>u",
  group = " Toggle",
  icon = "  ",
})

wk.add({
  "g",
  group = " Goto",
  icon = " ",
  mode = { "n" },
  {
    "gd",
    function() Snacks.picker.lsp_definitions() end,
    desc = "LSP: Go to Definition",
    icon = "",
  },
  {
    "gr",
    function() Snacks.picker.lsp_references() end,
    desc = "LSP: Find References",
    icon = "",
  },
  {
    "gi",
    function() Snacks.picker.lsp_implementations() end,
    desc = "LSP: Go to Implementation",
    icon = "",
  },
  {
    "gt",
    function() Snacks.picker.lsp_type_definitions() end,
    desc = "LSP: Go to Type Definition",
    icon = "",
  },
  {
    "gP",
    function() require('goto-preview').close_all_win() end,
    desc = "Goto Preview: Close All Windows",
    icon = "",
    mode = { "n" },
  },
  {
    group = " Goto Preview",
    icon = " ",
    mode = { "n" },
    {
      "gpp",
      function() require('goto-preview').goto_preview_definition() end,
      desc = "Goto Preview: Definition",
      icon = " ",
    },
    {
      "gpt",
      function() require('goto-preview').goto_preview_type_definition() end,
      desc = "Goto Preview: Type Definition",
      icon = " ",
    },
    {
      "gpi",
      function() require('goto-preview').goto_preview_implementation() end,
      desc = "Goto Preview: Implementation",
      icon = " ",
    },
    {
      "gpD",
      function() require('goto-preview').goto_preview_declaration() end,
      desc = "Goto Preview: Declaration",
      icon = " ",
    },
    {
      "gpr",
      function() require('goto-preview').goto_preview_references() end,
      desc = "Goto Preview: References",
      icon = " ",
    },
  }
})

wk.add({
  {
    "<leader>at",
    ":TSC<cr>",
    mode = { "n" },
    desc = "TypeScript check",
    cond = function()
      return _.contains(
        vim.bo.filetype,
        { "typescript", "typescriptreact", "javascript", "javascriptreact" }
      )
    end
  },
})

-- Cabs to avoid errors on saving, quitting
local cmd_abbreviations = {
  { "W",    "w" },
  { "Wq",   "wq" },
  { "Wqa",  "wqa" },
  { "WqA",  "wqa" },
  { "WQa",  "wqa" },
  { "WQA",  "wqa" },
  { "wQA",  "wqa" },
  { "wqA",  "wqa" },
  { "wQ",   "wq" },
  { "WA",   "wa" },
  { "Wa",   "wa" },
  { "Q",    "q" },
  { "Qa",   "qa" },
  { "lazy", "Lazy" },
  { "ccc",  "CodeCompanion" },
  { "ccb",  "CodeCompanion #{buffer}" },
  { "cca",  "CodeCompanionActions" },
}

-- Create the command abbreviations
mapping_helpers.create_command_abbreviations(cmd_abbreviations)


wk.add({
  "<C-w>",
  "<C-\\><C-o><C-w>",
  mode = { 't' },
  desc = "Window Management: Terminal"
})


wk.add({
  "<leader>r",
  group = " Replace",
  icon = "",
  {
    "<leader>rr",
    ':<C-u>lua require("grug-far").with_visual_selection({ prefills = { paths = vim.fn.expand("%") } })<cr>',
    mode = { 'x' },
    desc = "Grug: Replace selection"
  },
  {
    "<leader>rl",
    function()
      vim.api.nvim_feedkeys("V", 'n', false);
      vim.schedule(function()
        require('grug-far').open({ visualSelectionUsage = 'operate-within-range' })
      end)
    end,
    mode = { 'n', "x" },
    desc = "Grug: Replace in line"
  },
  {
    "<leader>rv",
    function()
      require('grug-far').open({ visualSelectionUsage = 'operate-within-range' })
    end,
    mode = { 'n', "x" },
    desc = "Grug: Replace in selection"
  },
  {
    "<leader>rr",
    function()
      require("grug-far").open({ prefills = { paths = vim.fn.getcwd() } })
    end,
    mode = { 'n' },
    desc = "Grug: Replace in workspace"
  },
  {
    "<leader>rf",
    function()
      require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
    end,
    mode = { 'n', "x" },
    desc = "Grug: Replace in file"
  }
})

wk.add({
  "<leader>o",
  group = "  Open",
  icon = " ",
  {
    "<leader>od",
    function() vim.diagnostic.open_float() end,
    desc = "LSP: Show diagnostics in a floating window",
    icon = " ",
    mode = { "n" },
  },
  {
    "<leader>oe",
    function()
      Snacks.explorer()
    end,
    desc = "Open file explorer",
    icon = " ",
    mode = { "n", "x" },
  },
  {
    "<leader>oo",
    function()
      require('mini.files').open()
    end,
    desc = "Open mini.files",
    icon = " ",
    mode = { "n", "x" },
  },
  {
    "<leader>of",
    function()
      require('mini.files').open(vim.api.nvim_buf_get_name(0))
    end,
    desc = "Open mini.files for current buffer",
    icon = " ",
    mode = { "n", "x" },
  },
  {
    "<leader>oa",
    "<cmd>AerialToggle<cr>",
    desc = "Open aerial side bar",
    icon = " ",
    mode = { "n", "x" },
  },
})

wk.add({
  "<leader>s",
  mode = { "n", "x" },
  group = "󰢷 Pickers",
  icon = "󰢷 ",
  {
    "<leader>sy",
    Snacks.picker.yanky,
    desc = "Show yank history",
    icon = " ",
  },
  {
    "<leader>si",
    Snacks.picker.icons,
    desc = "Show available icons",
    icon = " "
  },
  {
    "<leader>sf",
    function() Snacks.picker.files() end,
    desc = "Open file finder",
    icon = " ",
  },
  {
    "<leader>s,",
    function() Snacks.picker.git_files() end,
    desc = "Open git files",
    icon = " ",
  },
  {
    "<leader>sb",
    function() Snacks.picker.lines() end,
    desc = "Show buffer lines",
    icon = " ",
  },
  {
    "<leader>sB",
    function() Snacks.picker.grep_buffers() end,
    desc = "Grep open buffers",
    icon = " ",
  },
  {
    "<leader>sg",
    function() Snacks.picker.grep() end,
    desc = "Grep in project",
    icon = " ",
  },
  {
    "<leader>sw",
    app_workspace.picker,
    desc = "Open workspace picker",
    icon = " ",
  },
  {
    '<leader>s"',
    function() Snacks.picker.registers() end,
    desc = "Show registers",
    icon = " ",
  },
  {
    "<leader>sa",
    function() require("aerial").snacks_picker() end,
    desc = "Aerial",
    icon = " ",
  },
  {
    "<leader>sc",
    function() Snacks.picker.command_history() end,
    desc = "Show command history",
    icon = " ",
  },
  {
    "<leader>sC",
    function() Snacks.picker.commands() end,
    desc = "Show available commands",
    icon = " ",
  },
  {
    "<leader>sd",
    function() Snacks.picker.diagnostics() end,
    desc = "Show diagnostics",
    icon = " ",
  },
  {
    "<leader>sh",
    function() Snacks.picker.help() end,
    desc = "Show help pages",
    icon = "󰋖",
  },
  {
    "<leader>sH",
    function() Snacks.picker.highlights() end,
    desc = "Show highlights",
    icon = " ",
  },
  {
    "<leader>sj",
    function() Snacks.picker.jumps() end,
    desc = "Show jumps",
    icon = " ",
  },
  {
    "<leader>sk",
    function() Snacks.picker.keymaps() end,
    desc = "Show keymaps",
    icon = " ",
  },
  {
    "<leader>sl",
    function() Snacks.picker.loclist() end,
    desc = "Show location list",
    icon = " ",
  },
  {
    "<leader>sM",
    function() Snacks.picker.man() end,
    desc = "Show man pages",
    icon = " ",
  },
  {
    "<leader>sm",
    function() Snacks.picker.marks() end,
    desc = "Show marks",
    icon = " ",
  },
  {
    "<leader>sR",
    function() Snacks.picker.resume() end,
    desc = "Resume last picker",
    icon = " ",
  },
  {
    "<leader>sq",
    function() Snacks.picker.qflist() end,
    desc = "Show quickfix list",
    icon = " ",
  },
  {
    "<leader>sS",
    function() Snacks.picker.lsp_symbols() end,
    desc = "Show LSP symbols",
    icon = " ",
  },
  {
    "<leader>ss",
    function() require('window-picker').pick_window() end,
    desc = "Pick window",
    icon = " ",
  },
})

wk.add({
  group = "  Yanky",
  {
    mode = { "n", "x" },
    { "p", "<Plug>(YankyPutAfter)", desc = "Yanky: Put after", icon = "󰄬" }, -- Icon for paste
    { "P", "<Plug>(YankyPutBefore)", desc = "Yanky: Put before", icon = "󰄬" }, -- Icon for paste
    { "gp", "<Plug>(YankyGPutAfter)", desc = "Yanky: GPut after", icon = "󰄬" }, -- Icon for paste
    { "gP", "<Plug>(YankyGPutBefore)", desc = "Yanky: GPut before", icon = "󰄬" }, -- Icon for paste
  },
  {
    mode = { "n" },
    { "<c-j>", "<Plug>(YankyPreviousEntry)", desc = "Yanky: Previous entry", icon = "󰄉" }, -- Icon for previous
    { "<c-k>", "<Plug>(YankyNextEntry)", desc = "Yanky: Next entry", icon = "󰄊" } -- Icon for next
  }
})


wk.add({
  group = "  Buffers",
  icon = " ",
  {
    "<A-q>",
    buffer_calls.delete,
    mode = "n",
  },
  {
    "<leader>b",
    mode = { "n" },
    group = "  Buffers",
    icon = " ",
    {
      "<leader>bb",
      '<cmd>BufferLinePick<CR>',
      desc = "Go to next buffer",
      icon = " ", -- Icon for next buffer
    },
    {
      "<leader>bn",
      buffer_calls.next,
      desc = "Go to next buffer",
      icon = " ", -- Icon for next buffer
    },
    {
      "<leader>bp",
      buffer_calls.previous,
      desc = "Go to previous buffer",
      icon = " ", -- Icon for previous buffer
    },
    {
      "<leader>bd",
      buffer_calls.delete,
      desc = "Delete current buffer",
      icon = "", -- Icon for delete buffer
    },
    {
      "<leader>bo",
      buffer_calls.only,
      desc = "Delete other buffers",
      icon = " ", -- Icon for delete buffer
    },
  }
})

wk.add({
  group = "  Window Navigation",
  icon = " ",
  {
    "<A-h>",
    function() require("tmux").move_left() end,
    mode = "n",
    desc = "Navigate to left window",
    icon = " ",
  },
  {
    "<A-j>",
    function() require("tmux").move_bottom() end,
    mode = "n",
    desc = "Navigate to window below",
    icon = " ",
  },
  {
    "<A-k>",
    function() require("tmux").move_top() end,
    mode = "n",
    desc = "Navigate to window above",
    icon = " ",
  },
  {
    "<A-l>",
    function() require("tmux").move_right() end,
    mode = "n",
    desc = "Navigate to right window",
    icon = " ",
  },
})

wk.add({
  "<leader>t",
  mode = { "n" },
  group = "  Tabs",
  {
    "<leader>tt",
    function()
      lib.press("<esc>")
      if mapping_helpers.is_dashboard() then
        lib.run_command("ene")
      end
      if not mapping_helpers.is_dashboard() then
        lib.run_command("tabe")
      end
      vim.schedule(function()
        app_workspace.picker(
          function(workspace)
            lib.run_command("BufferLineTabRename " .. workspace.name)
          end
        )
      end)
    end,
    desc = "New tab",
    icon = " "
  },
  {
    "<leader>te",
    function() lib.start_command("tabedit") end,
    desc = "Open file in new tab",
    icon = " " -- Icon for open new tab
  },
  {
    "<leader>tn",
    function() vim.cmd.tabnext() end,
    desc = "Go to next tab",
    icon = "" -- Icon for next tab
  },
  {
    "<leader>tp",
    function() vim.cmd.tabprevious() end,
    desc = "Go to previous tab",
    icon = "" -- Icon for previous tab
  },
  {
    "<leader>to",
    function() vim.cmd.tabonly() end,
    desc = "Close all other tabs",
    icon = "" -- Icon for close other tabs
  },
  {
    "<leader>tq",
    function() vim.cmd.tabclose() end,
    desc = "Close tab",
    icon = "" -- Icon for close other tabs
  },
})

wk.add({
  group = " First level actions",
  icon = " ",
  {
    "<leader>w",
    ":w<CR>",
    desc = "Save the current file",
    icon = " ",
    mode = { "n" },
  },
  {
    "<leader>q",
    function()
      if vim.bo.filetype == FILETYPE_MAP.CODE_COMPANION then
        lib.run_command("CodeCompanionChat Toggle")
      else
        lib.run_command("q")
      end
    end,
    desc = "Quit the current file",
    icon = "",
    mode = { "n" },
  },
  {
    "<leader>S",
    ":wq<CR>",
    desc = "Save and quit the current file",
    icon = " ",
    mode = { "n" },
  },
  {
    "<leader>Q",
    ":q!<CR>",
    desc = "Force quit the current file",
    icon = "",
    mode = { "n" },
  },
})

wk.add({
  "<leader>c",
  group = "󱐏  AI Chat",
  icon = "󱐏 ",
  {
    "<leader>cc",
    "<cmd>CodeCompanionChat Toggle<cr>",
    desc = "Code Companion: Chat",
    icon = "󱐏 ",
    mode = { "n" },
  },
  {
    "<leader>cc",
    function()
      lib.start_command("CodeCompanion #{buffer}")
    end,
    desc = "Code Companion",
    icon = "󱐏 ",
    mode = { "x" },
  },
  {
    "<leader>ca",
    function()
      lib.start_command("CodeCompanion #{buffer}")
    end,
    desc = "Code Companion: Write action",
    icon = "󱐏 ",
    mode = { "n", "x" },
  },
})

wk.add({
  "<leader>x",
  group = " Textcase Current",
  icon = " ",
  mode = { "x", "n" },
  {
    "<leader>xu",
    function()
      if lib.is_visual_mode() then
        require('textcase').current_word('to_upper_case')
        lib.press('<bs>')
      else
        require('textcase').operator('to_upper_case')
      end
    end,
    desc = "Textcase: Convert to UPPER CASE",
  },
  {
    "<leader>xl",
    function()
      if lib.is_visual_mode() then
        require('textcase').current_word('to_lower_case')
      else
        require('textcase').operator('to_lower_case')
      end
    end,
    desc = "Textcase: Convert to lower case",
  },
  {
    "<leader>xs",
    function()
      if lib.is_visual_mode() then
        require('textcase').current_word('to_snake_case')
      else
        require('textcase').operator('to_snake_case')
      end
    end,
    desc = "Textcase: Convert to snake_case",
  },
  {
    "<leader>xd",
    function()
      if lib.is_visual_mode() then
        require('textcase').current_word('to_dash_case')
      else
        require('textcase').operator('to_dash_case')
      end
    end,
    desc = "Textcase: Convert to dash-case",
  },
  {
    "<leader>xn",
    function()
      if lib.is_visual_mode() then
        require('textcase').current_word('to_constant_case')
      else
        require('textcase').operator('to_constant_case')
      end
    end,
    desc = "Textcase: Convert to CONSTANT_CASE",
  },
  {
    "<leader>xD",
    function()
      if lib.is_visual_mode() then
        require('textcase').current_word('to_dot_case')
      else
        require('textcase').operator('to_dot_case')
      end
    end,
    desc = "Textcase: Convert to dot.case",
  },
  {
    "<leader>x,",
    function()
      if lib.is_visual_mode() then
        require('textcase').current_word('to_comma_case')
      else
        require('textcase').operator('to_comma_case')
      end
    end,
    desc = "Textcase: Convert to comma,case",
  },
  {
    "<leader>xa",
    function()
      if lib.is_visual_mode() then
        require('textcase').current_word('to_phrase_case')
      else
        require('textcase').operator('to_phrase_case')
      end
    end,
    desc = "Textcase: Convert to phrase case",
  },
  {
    "<leader>xc",
    function()
      if lib.is_visual_mode() then
        require('textcase').current_word('to_camel_case')
      else
        require('textcase').operator('to_camel_case')
      end
    end,
    desc = "Textcase: Convert to camelCase",
  },
  {
    "<leader>xp",
    function()
      if lib.is_visual_mode() then
        require('textcase').current_word('to_pascal_case')
      else
        require('textcase').operator('to_pascal_case')
      end
    end,
    desc = "Textcase: Convert to PascalCase",
  },
  {
    "<leader>xt",
    function()
      if lib.is_visual_mode() then
        require('textcase').current_word('to_title_case')
      else
        require('textcase').operator('to_title_case')
      end
    end,
    desc = "Textcase: Convert to Title Case",
  },
  {
    "<leader>xf",
    function()
      if lib.is_visual_mode() then
        require('textcase').current_word('to_path_case')
      else
        require('textcase').operator('to_path_case')
      end
    end,
    desc = "Textcase: Convert to path/case",
  },
})

wk.add({
  "<leader>f",
  group = "  File",
  icon = " ",
  mode = { "n" },
  {
    "<leader>fG",
    function() Snacks.picker.grep() end,
    desc = "Snacks: Open live grep",
    icon = " ",
  },
  {
    "<leader>fb",
    function()
      Snacks.picker.buffers({
        filter = { cwd = vim.fn.getcwd() },
      })
    end,
    desc = "Snacks: Open Workspace buffers",
    icon = " ",
  },
  {
    "<leader>fB",
    function()
      Snacks.picker.buffers()
    end,
    desc = "Snacks: Open buffers",
    icon = " ",
  },
  {
    "<leader>f,",
    function() Snacks.picker.git_files() end,
    desc = "Snacks: Open git files",
    icon = " ",
  },
  {
    "<leader>ff",
    function() require('fff').find_files() end,
    desc = "FFF: Find files",
    icon = " ",
  },
  {
    "<leader>fa",
    function() Snacks.picker.git_files() end,
    desc = "Snacks: Git files",
    icon = " ",
  },
  {
    "<leader>fg",
    function() require('fff').live_grep() end,
    desc = "FFF: Open grep",
    icon = " ",
  },
  {
    "<leader>fz",
    function() require('fff').live_grep({ grep = { modes = { 'fuzzy', 'plain' } } }) end,
    desc = "FFF: Open fuzzy grep",
    icon = " ",
  },
  {
    "<leader>fc",
    function() require('fff').live_grep({ query = vim.fn.expand("<cword>") }) end,
    desc = "FFF: seach current word",
    icon = " ",
  },
  {
    "<leader>fr",
    function() Snacks.picker.recent({ filter = { cwd = vim.fn.getcwd() } }) end,
    desc = "Snacks: Recent files (workspaces)",
    icon = " ",
  },
  {
    "<leader>fR",
    function() Snacks.picker.recent() end,
    desc = "Snacks: Recent files",
    icon = " ",
  },
  {
    "<leader>fy",
    lib.copy_file_name,
    desc = "Copy file path to clipboard",
    icon = " ",
  },
})


wk.add({
  "<leader>g",
  group = " Git",
  icon = " ",
  desc = "Git and Lazygit operations",
  mode = { "n" },
  {
    "<leader>gc",
    function() Snacks.picker.git_log() end,
    desc = "View Git Log",
    icon = " ",
  },
  {
    "<leader>gs",
    function() Snacks.picker.git_status() end,
    desc = "View Git Status",
    icon = " ",
  },
  {
    "<leader>gg",
    function() Snacks.lazygit() end,
    desc = "Open Lazygit",
    icon = " ",
  },
  {
    "<leader>gl",
    function() Snacks.lazygit.log_file() end,
    desc = "Open Lazygit Log for current buffer",
    icon = " ",
  },
  {
    "<leader>gL",
    function() Snacks.lazygit.log() end,
    desc = "Open Lazygit Log",
    icon = " ",
  },
  {
    "<leader>gb",
    function() Snacks.git.blame_line() end,
    desc = "Show Git Blame for Line",
    icon = " ",
  },
  {
    "<leader>gB",
    function() Snacks.gitbrowse() end,
    desc = "Browse Git Repository",
    icon = " ",
  },
  {
    "<leader>gd",
    '<cmd>DiffviewOpen<cr>',
    desc = "Open diff view",
    icon = " ",
  },
})


wk.add({
  "<leader>e",
  group = " Execute",
  icon = " ",
  mode = { "n" },
  {
    "<leader>er",
    "<cmd>OverseerRun<cr>",
    desc = "Overseer: Show tasks",
    icon = " ",
  },
  {
    "<leader>et",
    "<cmd>OverseerToggle right<cr>",
    desc = "Overseer toggle",
    icon = " ",
  },
})


wk.add({
  {
    "<C-g>",
    function() Snacks.lazygit() end,
    desc = "LazyGit",
    icon = " ",
    mode = { "n", "t", "x" },
  },
  {
    "<C-e>",
    function() Snacks.explorer() end,
    desc = "Explorer",
    icon = " ",
    mode = { "n", "t", "x" },
  },
  {
    "<C-t><C-t>",
    function()
      Snacks.terminal.toggle('zsh', {
        cwd = vim.fn.getcwd(),
        win = {
          backdrop = 10,
          border = "solid",
          position = "float",
          title = "🔮 term: " .. vim.fn.getcwd(),
          wo = {
            winbar = "🔮 term: " .. vim.fn.getcwd()
          }
        }
      })
    end,
    mode = { "n", "t", "x" },
    icon = " ",
    desc = "Toggle terminal",
  },
  {
    "<C-t><C-v>",
    function()
      Snacks.terminal.toggle('zsh', {
        cwd = vim.fn.getcwd(),
        win = {
          backdrop = 10,
          border = "solid",
          position = "right",
          title = "🔮 term: " .. vim.fn.getcwd(),
          wo = {
            winbar = "🔮 term: " .. vim.fn.getcwd()
          }
        }
      })
    end,
    mode = { "n", "t", "x" },
    icon = " ",
    desc = "Toggle terminal",
  },
  {
    "<C-t><C-h>",
    function()
      Snacks.terminal.toggle('zsh', {
        cwd = vim.fn.getcwd(),
        win = {
          backdrop = 10,
          border = "solid",
          position = "bottom",
          title = "🔮 term: " .. vim.fn.getcwd(),
          wo = {
            winbar = "🔮 term: " .. vim.fn.getcwd()
          }
        }
      })
    end,
    mode = { "n", "t", "x" },
    icon = " ",
    desc = "Toggle terminal",
  },
  {
    "<C-p>",
    function()
      Snacks.picker.files()
    end,
    mode = { "n" },
    desc = "File finder",
    icon = " ",
  },
  {
    "<C-a>",
    function()
      vim.lsp.buf.code_action()
    end,
    mode = { "n", "x" },
    desc = "LSP: Code action",
    icon = " ",
  },
  {
    "<C-p>",
    "<C-r>\"",
    mode = { "i" },
    desc = "Paste from register",
    icon = " "
  },
  {
    "<C-w>",
    "<Esc><C-w>",
    mode = { "i" },
    desc = "Window Management: Insert",
    icon = " ",
  }
})


-- Mini.files keymap setup
-- Uses helper functions from app.mapping_helpers for cleaner code
vim.api.nvim_create_autocmd("FileType", {
  pattern = "minifiles",
  callback = function()
    local minifiles = require('mini.files')

    -- Use helper functions from mapping_helpers module
    wk.add(mapping_helpers.minifiles.close("<leader>q"))
    wk.add(mapping_helpers.minifiles.close("q"))

    wk.add(mapping_helpers.minifiles.refresh("<leader>r"))

    wk.add(mapping_helpers.minifiles.go_in("L", { close_on_file = false }))
    wk.add(mapping_helpers.minifiles.go_in("<Tab>", { close_on_file = false }))
    wk.add(mapping_helpers.minifiles.go_in("<CR>", { close_on_file = true }))

    wk.add(mapping_helpers.minifiles.go_out("H"))
    wk.add(mapping_helpers.minifiles.go_out("<BS>"))
    wk.add(mapping_helpers.minifiles.go_out("<S-Tab>"))

    wk.add({
      "<leader>w",
      function()
        minifiles.synchronize()
      end,
      mode = { "n" },
      desc = "Sync",
      buffer = true,
      noremap = true,
      silent = true,
    })
  end,
})
-- Neovide-only: Cmd+C/V/S and other Cmd keybindings (IDE-like). Only registered when g:neovide is set.
-- See https://neovide.dev/faq.html#how-can-i-use-cmd-ccmd-v-to-copy-and-paste
if vim.g.neovide then
  local function neovide_paste()
    vim.api.nvim_paste(vim.fn.getreg("+"), true, -1)
  end
  wk.add({
    group = " Neovide",
    icon = " ",
    {
      "<D-s>",
      function() vim.cmd.write() end,
      desc = "Save",
      icon = " ",
      mode = { "n", "i", "v" },
    },
    {
      "<D-c>",
      function() vim.cmd([[normal! "+y]]) end,
      desc = "Copy",
      icon = " ",
      mode = { "v" },
    },
    {
      "<D-v>",
      function() vim.cmd([[normal! "+p]]) end,
      desc = "Paste",
      icon = " ",
      mode = { "n" },
    },
    {
      "<D-v>",
      '"+p',
      desc = "Paste",
      icon = " ",
      mode = { "v" },
    },
    {
      "<D-v>",
      neovide_paste,
      desc = "Paste (insert/cmdline/term)",
      icon = " ",
      mode = { "i", "c", "t" },
    },
    {
      "<D-a>",
      function()
        local t = function(s) return vim.api.nvim_replace_termcodes(s, true, true, true) end
        if vim.fn.mode() == "i" then
          vim.api.nvim_feedkeys(t("<C-o>ggVG"), "n", false)
        else
          vim.cmd([[normal! ggVG]])
        end
      end,
      desc = "Select all",
      icon = " ",
      mode = { "n", "i" },
    },
    {
      "<D-z>",
      function()
        local t = function(s) return vim.api.nvim_replace_termcodes(s, true, true, true) end
        if vim.fn.mode() == "i" then
          vim.api.nvim_feedkeys(t("<C-o>u"), "n", false)
        else
          vim.cmd([[normal! u]])
        end
      end,
      desc = "Undo",
      icon = " ",
      mode = { "n", "i", "v" },
    },
    {
      "<D-S-z>",
      function()
        local t = function(s) return vim.api.nvim_replace_termcodes(s, true, true, true) end
        if vim.fn.mode() == "i" then
          vim.api.nvim_feedkeys(t("<C-o><C-r>"), "n", false)
        else
          vim.api.nvim_feedkeys(t("<C-r>"), "n", false)
        end
      end,
      desc = "Redo",
      icon = " ",
      mode = { "n", "i", "v" },
    },
    {
      "<C-=>",
      function()
        vim.g.neovide_scale_factor = (vim.g.neovide_scale_factor or 1.0) * 1.25
      end,
      desc = "Increase Neovide scale factor",
      icon = " ",
      mode = { "n" },
    },
    {
      "<C-->",
      function()
        vim.g.neovide_scale_factor = (vim.g.neovide_scale_factor or 1.0) / 1.25
      end,
      desc = "Decrease Neovide scale factor",
      icon = " ",
      mode = { "n" },
    },
  })
end

wk.add({
  {
    "<leader>y",
    "\"+y",
    desc = "Yank to system clipboard",
    mode = { "v", "n" },
  },
  {
    "<leader>p",
    "\"+p",
    desc = "Paste from system clipboard",
    mode = { "n", "v" },
  }
})
