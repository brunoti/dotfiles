# Neovim memory investigation

**Date:** 2025-02-09  
**Scope:** Config under `nvim/config` (init, plugins, LSP, treesitter, completion).

---

## Summary

The main memory use comes from:

1. **VTSLS (TypeScript LSP)** – Node process allowed up to **8 GB** (`--max-old-space-size=8192`) with `maxTsServerMemory = 4096`. This is the largest single consumer.
2. **Multiple LSPs** – vtsls, biome, lua_ls (and jsonls configured). Each keeps project/buffer state.
3. **Completion stack** – blink.cmp with several providers (LSP, copilot, codeium, lazydev, ripgrep, codecompanion, avante). Caches and async work add to memory.
4. **AI/chat** – codecompanion.nvim with multiple adapters and chat history.
5. **Startup-loaded plugins** – Several plugins use `lazy = false`, so they load at startup and stay resident.

---

## 1. VTSLS (TypeScript LSP)

| Setting | Current | Effect |
|--------|---------|--------|
| `--max-old-space-size` | 8192 (8 GB) | Node heap ceiling for the TS server process |
| `maxTsServerMemory` | 4096 (4 GB) | TS server internal memory limit |
| `performance_mode` | `false` | Full features; no reduction of work |

**Location:** `after/plugin/lsp.lua` (cmd, init_options, vtsls.tsserver).

**Recommendation:** If memory is tight:

- Set `performance_mode = true` (line 81). This halves Node/TS limits and turns off autoimports and some expensive features.
- Or lower only the limits: e.g. `--max-old-space-size=4096` and `maxTsServerMemory = 2048`.

---

## 2. LSP setup

- **Enabled:** `vtsls`, `biome`, `lua_ls` (and jsonls is configured).
- **ts_ls** is configured but **not** in `vim.lsp.enable()`, so only one TS server (vtsls) runs. No duplicate TS LSP.

No change required unless you want to disable an LSP for certain projects.

---

## 3. Treesitter

- **Active config** is in `lua/plugins.lua` (nvim-treesitter plugin): `sync_install = true`, `auto_install = true`. No `ensure_installed = "all"` there, so parsers are installed on demand.
- **`lua/treesitter.lua`** has `ensure_installed = "all"` but is **never required** anywhere. It’s dead code; removing or fixing it avoids accidental “install all parsers” if something ever loads it.

---

## 4. Completion and AI

- **blink.cmp** with: lazydev, LSP, path, buffer, ripgrep, copilot (and codecompanion/codeium/avante in various contexts).
- **copilot.lua** and **codecompanion.nvim** (chat + multiple adapters) add resident memory and caches.

To reduce memory you can disable or lazy-load individual completion providers or codecompanion features you don’t need.

---

## 5. Plugins with `lazy = false` (load at startup)

| Plugin | Notes |
|--------|--------|
| markview.nvim | priority 1 |
| nvim-treesitter | priority 2 |
| snacks.nvim | priority 1000, indent/scope/chunk |
| nvim-various-textobjs | text objects |
| mini.ai | ai text objects |
| tokyyonight.nvim | colorscheme |
| github-monochrome.nvim | theme-related |
| monoglow / lackluster / persistence | disabled in config |

Consider setting `lazy = true` and an appropriate `event`/`ft`/`cmd` for any you don’t need immediately on startup (e.g. markview, textobjs) to spread load and reduce baseline memory.

---

## 6. Other options

- **`_init.lua`:** `history = 10000`, `undofile = true`. Undo and history have modest impact; reducing history or disabling undofile can trim a bit.
- **Lualine** init requires `overseer`, so overseer loads when lualine does. Acceptable unless you want to defer task-runner UI.
- **navic:** `depth_limit = 0` (unlimited breadcrumb depth). You could set a small `depth_limit` to cap work per buffer.

---

## 7. Quick wins

1. **Enable performance_mode** in `after/plugin/lsp.lua` (line 81):  
   `local performance_mode = true`  
   Cuts VTSLS memory and disables some heavy features (autoimports, etc.).

2. **Lower VTSLS memory without full performance_mode:**  
   In the same file, change the `cmd` for vtsls to use e.g. `--max-old-space-size=4096` and set `maxTsServerMemory = 2048` in init_options.

3. **Remove or fix `lua/treesitter.lua`** so nothing can load `ensure_installed = "all"`.

4. **Lazy-load non-essential plugins** (e.g. markview, nvim-various-textobjs) with `lazy = true` and events/commands so they load only when used.

---

## 8. Verifying memory

- **`:lua _G.check_vtsls_memory()`** – Prints VTSLS/tsserver and system memory (from `after/plugin/lsp.lua`).
- **`:lua _G.lsp_debug()`** – Lists LSP clients and roots; helps spot duplicate or unexpected servers.
- **OS:** `ps aux` / Activity Monitor for `nvim`, `node` (vtsls/tsserver), and `biome`.

Focus first on VTSLS (Node/tsserver) and the number of LSPs; then completion and AI plugins; then startup-loaded plugins if you need further reduction.
