# Neovim Plugins Reorganization Plan

## Current State Analysis

### File: `lua/plugins.lua`
- **Lines**: 3240+
- **Issues**:
  - Single massive file (unwieldy)
  - No logical grouping
  - Duplicate code: `codecompanion_progress_module()` defined twice (lines 3328-3400 and 3402-3474)
  - Disabled plugins mixed with enabled ones
  - Inconsistent lazy loading strategies
  - Some inline configs are 100+ lines

---

## Recommended Structure

Use lazy.nvim's `import` feature to split into multiple files:

```
lua/plugins/
├── init.lua        -- bootstrap + lazy.setup() with spec import
├── core.lua        -- lazy.nvim self, treesitter, utilities
├── ui.lua          -- colorschemes, lualine, statuscolumn
├── ai.lua          -- copilot, codecompanion, avante, blink.cmp
├── lsp.lua         -- LSP config, null-ls, lspconfig
├── git.lua         -- gitsigns, diffview, neogit, conflict
├── navigation.lua  -- telescope, nvim-tree, mini.files
├── treesitter.lua  -- nvim-treesitter, textobjects
├── utils.lua       -- snacks, which-key, mini.* plugins
├── completion.lua  -- completion engines
├── editing.lua     -- textobjs, surround, pairs
├── search.lua      -- spectre, ctrlsf, grug-far
└── disabled.lua    -- all disabled plugins
```

---

## Quick Wins (Immediate)

### 1. Remove Duplicate Function
**File**: `lua/plugins.lua`  
**Lines**: 3328-3400 and 3402-3474  
**Action**: Delete one of the two identical `codecompanion_progress_module()` definitions

### 2. Add Section Comments (Optional Quick Fix)
Even without splitting files, add comment headers:

```lua
-- ═══════════════════════════════════════════════════════════════════════════════
-- UI & APPEARANCE
-- ═══════════════════════════════════════════════════════════════════════════════
{ "folke/tokyonight.nvim", ... },
{ "nvim-lualine/lualine.nvim", ... },

-- ═══════════════════════════════════════════════════════════════════════════════
-- AI & COMPLETION
-- ═══════════════════════════════════════════════════════════════════════════════
{ "saghen/blink.cmp", ... },
{ "zbirenbaum/copilot.lua", ... },
{ "olimorris/codecompanion.nvim", ... },

-- ═══════════════════════════════════════════════════════════════════════════════
-- LSP & DIAGNOSTICS
-- ═══════════════════════════════════════════════════════════════════════════════
{ "neovim/nvim-lspconfig", ... },
...
```

---

## Implementation Plan (Option B)

### Phase 1: Create Directory Structure
```bash
mkdir -p lua/plugins
```

### Phase 2: Create `lua/plugins/init.lua`
```lua
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not uv.fs_stat(lazypath) then
  vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  spec = {
    { import = 'plugins.core' },
    { import = 'plugins.ui' },
    { import = 'plugins.ai' },
    { import = 'plugins.lsp' },
    { import = 'plugins.git' },
    { import = 'plugins.navigation' },
    { import = 'plugins.treesitter' },
    { import = 'plugins.utils' },
    { import = 'plugins.completion' },
    { import = 'plugins.editing' },
    { import = 'plugins.search' },
    { import = 'plugins.disabled' },
  },
})
```

### Phase 3: Extract Plugin Groups

| New File | Plugins to Move |
|----------|-----------------|
| `core.lua` | lazy.nvim bootstrap, treesitter, plenary, nui |
| `ui.lua` | tokyonight, lualine, snacks, statuscolumn, mini.hipatterns |
| `ai.lua` | copilot, blink.cmp, codecompanion, avante, opencode, claude-code |
| `lsp.lua` | lspconfig, none-ls, lsp-progress, goto-preview |
| `git.lua` | gitsigns, diffview, neogit, git-conflict, mini.git, mini.diff |
| `navigation.lua` | telescope, nvim-tree, mini.files, which-key |
| `treesitter.lua` | treesitter, textobjects, ts-autotag, nvim-vtsls |
| `utils.lua` | snacks (remaining), which-key, overseer, workspaces |
| `completion.lua` | blink.cmp (if separate from ai), luasnip |
| `editing.lua` | mini.surround, mini.pairs, mini.ai, vim-wordmotion |
| `search.lua` | spectre, ctrlsf, grug-far, nvim-spectre |
| `disabled.lua` | All `enabled = false` plugins |

### Phase 4: Cleanup
1. Remove duplicate `codecompanion_progress_module()`
2. Move helper functions to appropriate plugin files or `lua/plugins/helpers.lua`
3. Remove old `lua/plugins.lua` or rename to backup

---

## Validation Against Lazy.nvim Docs

- ✅ `import` feature is officially supported
- ✅ Grouping improves maintainability
- ✅ Lazy loading best practices still apply
- ✅ No functional changes, only organizational

---

## Effort Estimate

- **Option A** (comments only): 10 min
- **Option B** (full split): 30-45 min
