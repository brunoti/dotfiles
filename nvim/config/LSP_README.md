# Neovim LSP Configuration

## Overview

This Neovim configuration uses the modern `vim.lsp.config` API (Neovim 0.11+) with only two LSP servers for optimal performance:

- **VTSLS** - TypeScript/JavaScript with full refactoring support
- **Biome** - Fast linting and formatting

## Configuration Structure

### LSP Servers

#### VTSLS (TypeScript/JavaScript)
- **Full refactoring support** enabled
- **Performance optimized** settings
- **12GB memory limit** for large projects
- **All extract/inline/move operations** working
- **Starts for**: `javascript`, `javascriptreact`, `typescript`, `typescriptreact`

#### Biome (Linting/Formatting)
- **Fast linting** and formatting for JS/TS/JSON files
- **Auto-fixes** and quick fixes via code actions
- **Import organization** and code cleanup
- **Starts for**: `javascript`, `typescript`, `json` (complements VTSLS)
- **Note**: Works alongside VTSLS for different functionality (linting vs language features)

### Key Features

- ✅ **Modern API** - Uses `vim.lsp.config` (no lspconfig dependency)
- ✅ **Refactoring** - Extract, inline, move operations all work
- ✅ **Import Completion** - Auto-import suggestions from project files
- ✅ **Performance** - Aggressive optimizations for large codebases
- ✅ **Root Detection** - Proper tsconfig.json/jsconfig.json finding
- ✅ **Format-on-save** - ESLint, Prettier, Biome integration
- ✅ **Diagnostics** - Hover diagnostics and floating windows

## Usage

### Basic LSP Commands
```vim
:LspInfo                    " Show active LSP clients
:lua vim.lsp.buf.hover()    " Show documentation
:lua vim.lsp.buf.definition() " Go to definition
:lua vim.lsp.buf.code_action() " Show code actions
```

### Import Completion
VTSLS automatically suggests imports from your project:
- Start typing a class/function name
- Auto-import suggestions appear in blink.cmp
- Press Enter to accept and auto-add the import statement

### LSP Status and Testing
```vim
:lua _G.lsp_status()            " Check LSP status for current buffer
:lua _G.test_refactoring()      " Test refactoring functionality
:lua _G.test_import_completion() " Test import completion
```

### Refactoring (VTSLS)
```vim
" Extract operations
:lua vim.lsp.buf.code_action() " Select code and choose "Extract to function"

" Inline operations
:lua vim.lsp.buf.code_action() " Place cursor on variable/function

" Move to file
:lua vim.lsp.buf.code_action() " Select "Move to a new file"
```

### Biome Fixes
```vim
:lua _G.fix_all_biome()     " Auto-apply all Biome fixes
```

## Configuration Details

### VTSLS Settings
```lua
vim.lsp.config.vtsls = {
    -- Full refactoring enabled
    enableMoveToFileCodeAction = true,
    enableRefactorActions = true,

    -- Performance optimized
    maxTsServerMemory = 12288, -- 12GB
    separateSyntaxServer = true,

    -- Code actions enabled
    codeActionKinds = {
        "refactor", "refactor.extract", "refactor.inline",
        "refactor.move", "source.addMissingImports"
    }
}
```

### Performance Optimizations
- Semantic tokens disabled
- Inlay hints disabled
- Document/workspace symbols disabled
- Call/Type hierarchy disabled
- Aggressive file watching exclusions

## Debug Commands

```vim
:lua _G.check_vtsls_memory()         " Check VTSLS memory usage
:lua _G.check_code_action_performance() " Show configuration status
:lua _G.debug_all_code_actions()     " Debug available actions
:lua _G.test_refactoring()           " Test refactoring functionality
```

## Format-on-Save

Automatically formats files using:
1. **Biome** (if `biome.json` exists)
2. **ESLint** (if `eslint.config.*` exists)
3. **Prettier** (if `.prettierrc*` exists)

## Files

- `after/plugin/lsp.lua` - Main LSP configuration
- `LSP_README.md` - This documentation

## Migration Notes

This configuration replaces the old lspconfig setup with:
- Modern Neovim 0.11+ API
- Focused on TypeScript/JavaScript development
- Removed null-ls (Biome handles linting/formatting)
- Streamlined for performance

## Troubleshooting

### LSP Servers Not Starting?
```vim
:lua _G.lsp_status() " Check if LSP servers are attached to current buffer
:LspInfo             " Show all active LSP clients
```

LSP servers start automatically when you open supported files:
- VTSLS: `.js`, `.jsx`, `.ts`, `.tsx` files
- Biome: `.js`, `.jsx`, `.ts`, `.tsx`, `.json` files

If servers aren't starting, check:
- File type detection: `:set filetype?`
- File extensions: Make sure you're opening `.ts`/`.js`/`.json` files
- Command availability: `:lua _G.lsp_debug()`

### No Refactoring Actions?
```vim
:lua _G.test_refactoring() " Test if refactoring works
:LspInfo                   " Check if VTSLS is attached
```

### tsconfig.json Not Found on First Load?
```vim
:lua _G.lsp_debug()        " Shows root directory and config file detection
:LspRestart                " Restart LSP (should find tsconfig on restart)
```

The LSP now searches for `tsconfig.json`/`jsconfig.json` to determine project root.

### Performance Issues?
```vim
:lua _G.check_vtsls_memory() " Monitor memory usage
" Consider reducing memory limits if < 24GB RAM
```

### Biome Not Working?
```vim
" Check for biome.json
:lua vim.fn.findfile("biome.json", ".;")
" Install Biome: npm install -g @biomejs/biome
```
