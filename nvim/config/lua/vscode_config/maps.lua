-- VSCode-Neovim Key Mappings
local vscode = require('vscode')

-- Disable 's' in normal and visual modes (common in Neovim configs)
vim.keymap.set({ 'n', 'x' }, 's', '<Nop>')

-- Navigation between editor groups
vim.keymap.set('n', '<C-h>', function() vscode.action('workbench.action.navigateLeft') end, { desc = 'Navigate left' })
vim.keymap.set('n', '<C-j>', function() vscode.action('workbench.action.navigateDown') end, { desc = 'Navigate down' })
vim.keymap.set('n', '<C-k>', function() vscode.action('workbench.action.navigateUp') end, { desc = 'Navigate up' })
vim.keymap.set('n', '<C-l>', function() vscode.action('workbench.action.navigateRight') end, { desc = 'Navigate right' })

-- File explorer
vim.keymap.set('n', '<leader>e', function() vscode.action('workbench.action.toggleSidebarVisibility') end, { desc = 'Toggle explorer' })

-- File operations
vim.keymap.set('n', '<leader>ff', function() vscode.action('workbench.action.quickOpen') end, { desc = 'Find files' })
vim.keymap.set('n', '<C-p>', function() vscode.action('workbench.action.quickOpen') end, { desc = 'Quick open' })
vim.keymap.set('n', '<leader>fg', function() vscode.action('workbench.action.findInFiles') end, { desc = 'Find in files' })
vim.keymap.set('n', '<leader>fb', function() vscode.action('workbench.action.showAllEditors') end, { desc = 'Show all editors' })
vim.keymap.set('n', '<leader>fr', function() vscode.action('workbench.action.openRecent') end, { desc = 'Recent files' })

-- LSP functionality
vim.keymap.set('n', 'gd', function() vscode.action('editor.action.revealDefinition') end, { desc = 'Go to definition' })
vim.keymap.set('n', 'gr', function() vscode.action('editor.action.goToReferences') end, { desc = 'Go to references' })
vim.keymap.set('n', 'gi', function() vscode.action('editor.action.goToImplementation') end, { desc = 'Go to implementation' })
vim.keymap.set('n', 'gt', function() vscode.action('editor.action.goToTypeDefinition') end, { desc = 'Go to type definition' })
vim.keymap.set('n', 'K', function() vscode.action('editor.action.showHover') end, { desc = 'Show hover' })

-- Preview/peek functionality (existing mapping enhanced)
vim.keymap.set('n', '<C-w>gd', function() vscode.action('editor.action.revealDefinitionAside') end, { desc = 'Peek definition aside' })
vim.keymap.set('n', 'gpd', function() vscode.action('editor.action.peekDefinition') end, { desc = 'Peek definition' })
vim.keymap.set('n', 'gpr', function() vscode.action('editor.action.referenceSearch.trigger') end, { desc = 'Peek references' })
vim.keymap.set('n', 'gpi', function() vscode.action('editor.action.peekImplementation') end, { desc = 'Peek implementation' })

-- Code actions
vim.keymap.set({ 'n', 'v' }, '<leader>ca', function() vscode.action('editor.action.codeAction') end, { desc = 'Code action' })
vim.keymap.set('n', '<leader>cr', function() vscode.action('editor.action.rename') end, { desc = 'Rename' })
vim.keymap.set('n', '<leader>cf', function() vscode.action('editor.action.formatDocument') end, { desc = 'Format document' })
vim.keymap.set('v', '<leader>cf', function() vscode.action('editor.action.formatSelection') end, { desc = 'Format selection' })

-- Diagnostics
vim.keymap.set('n', ']d', function() vscode.action('editor.action.marker.next') end, { desc = 'Next diagnostic' })
vim.keymap.set('n', '[d', function() vscode.action('editor.action.marker.prev') end, { desc = 'Previous diagnostic' })
vim.keymap.set('n', '<leader>xx', function() vscode.action('workbench.actions.view.problems') end, { desc = 'Show problems' })
vim.keymap.set('n', '<leader>xd', function() vscode.action('editor.action.showErrorsWarnings') end, { desc = 'Show diagnostics' })

-- Buffer/Tab management
vim.keymap.set('n', '<leader>bd', function() vscode.action('workbench.action.closeActiveEditor') end, { desc = 'Close buffer' })
vim.keymap.set('n', '<leader>bo', function() vscode.action('workbench.action.closeOtherEditors') end, { desc = 'Close other buffers' })
vim.keymap.set('n', '<leader>ba', function() vscode.action('workbench.action.closeAllEditors') end, { desc = 'Close all buffers' })
vim.keymap.set('n', 'H', function() vscode.action('workbench.action.previousEditor') end, { desc = 'Previous editor' })
vim.keymap.set('n', 'L', function() vscode.action('workbench.action.nextEditor') end, { desc = 'Next editor' })

-- Split management
vim.keymap.set('n', '<leader>sv', function() vscode.action('workbench.action.splitEditor') end, { desc = 'Split vertical' })
vim.keymap.set('n', '<leader>sh', function() vscode.action('workbench.action.splitEditorDown') end, { desc = 'Split horizontal' })
vim.keymap.set('n', '<leader>sc', function() vscode.action('workbench.action.joinTwoGroups') end, { desc = 'Close split' })
-- 
-- Folding
vim.keymap.set('n', 'za', function() vscode.action('editor.toggleFold') end, { desc = 'Toggle fold' })
vim.keymap.set('n', 'zM', function() vscode.action('editor.foldAll') end, { desc = 'Fold all' })
vim.keymap.set('n', 'zR', function() vscode.action('editor.unfoldAll') end, { desc = 'Unfold all' })
vim.keymap.set('n', 'zo', function() vscode.action('editor.unfold') end, { desc = 'Unfold' })
vim.keymap.set('n', 'zc', function() vscode.action('editor.fold') end, { desc = 'Fold' })
vim.keymap.set('n', 'zO', function() vscode.action('editor.unfoldRecursively') end, { desc = 'Unfold recursively' })
vim.keymap.set('n', 'zC', function() vscode.action('editor.foldRecursively') end, { desc = 'Fold recursively' })

-- Search and replace
vim.keymap.set('n', '<leader>rr', function() vscode.action('editor.action.startFindReplaceAction') end, { desc = 'Find and replace' })
vim.keymap.set('n', '<leader>rw', function() vscode.action('workbench.action.replaceInFiles') end, { desc = 'Replace in files' })
vim.keymap.set('n', '<leader>/', function() vscode.action('workbench.action.findInFiles') end, { desc = 'Search in workspace' })

-- Git
vim.keymap.set('n', '<leader>gg', function() vscode.action('workbench.view.scm') end, { desc = 'Git: Source control' })
vim.keymap.set('n', '<leader>gb', function() vscode.action('gitlens.toggleFileBlame') end, { desc = 'Git: Toggle blame' })
vim.keymap.set('n', '<leader>gd', function() vscode.action('git.openChange') end, { desc = 'Git: Show changes' })
vim.keymap.set('n', '<leader>gs', function() vscode.action('git.stageSelectedRanges') end, { desc = 'Git: Stage selection' })
vim.keymap.set('n', '<leader>gu', function() vscode.action('git.unstageSelectedRanges') end, { desc = 'Git: Unstage selection' })

-- Terminal
vim.keymap.set('n', '<C-`>', function() vscode.action('workbench.action.terminal.toggleTerminal') end, { desc = 'Toggle terminal' })
vim.keymap.set('n', '<leader>tn', function() vscode.action('workbench.action.terminal.new') end, { desc = 'New terminal' })
vim.keymap.set('n', '<leader>tk', function() vscode.action('workbench.action.terminal.kill') end, { desc = 'Kill terminal' })

-- Commenting
vim.keymap.set({ 'n', 'v' }, '<leader>/', function() vscode.action('editor.action.commentLine') end, { desc = 'Toggle comment' })
vim.keymap.set('v', '<leader>cb', function() vscode.action('editor.action.blockComment') end, { desc = 'Block comment' })

-- Workspace
vim.keymap.set('n', '<leader>w', function() vscode.action('workbench.action.files.save') end, { desc = 'Save file' })
vim.keymap.set('n', '<leader>wa', function() vscode.action('workbench.action.files.saveAll') end, { desc = 'Save all' })
vim.keymap.set('n', '<leader>q', function() vscode.action('workbench.action.closeActiveEditor') end, { desc = 'Close editor' })
vim.keymap.set('n', '<leader>qq', function() vscode.action('workbench.action.quit') end, { desc = 'Quit VSCode' })

-- Zen mode and focus
vim.keymap.set('n', '<leader>z', function() vscode.action('workbench.action.toggleZenMode') end, { desc = 'Toggle zen mode' })
vim.keymap.set('n', '<leader>fc', function() vscode.action('workbench.action.toggleCenteredLayout') end, { desc = 'Toggle centered layout' })

-- Multi-cursor
vim.keymap.set('n', '<C-n>', function() vscode.action('editor.action.addSelectionToNextFindMatch') end, { desc = 'Add selection to next find match' })
vim.keymap.set('n', '<C-S-n>', function() vscode.action('editor.action.addSelectionToPreviousFindMatch') end, { desc = 'Add selection to previous find match' })
vim.keymap.set('n', '<leader>ma', function() vscode.action('editor.action.selectHighlights') end, { desc = 'Select all occurrences' })

-- Line manipulation
vim.keymap.set('v', 'J', function() vscode.action('editor.action.moveLinesDownAction') end, { desc = 'Move lines down' })
vim.keymap.set('v', 'K', function() vscode.action('editor.action.moveLinesUpAction') end, { desc = 'Move lines up' })
vim.keymap.set('n', '<A-j>', function() vscode.action('editor.action.moveLinesDownAction') end, { desc = 'Move line down' })
vim.keymap.set('n', '<A-k>', function() vscode.action('editor.action.moveLinesUpAction') end, { desc = 'Move line up' })

-- Indentation
vim.keymap.set('v', '<', function() vscode.action('editor.action.outdentLines') end, { desc = 'Outdent lines' })
vim.keymap.set('v', '>', function() vscode.action('editor.action.indentLines') end, { desc = 'Indent lines' })

-- Symbol search
vim.keymap.set('n', '<leader>ss', function() vscode.action('workbench.action.gotoSymbol') end, { desc = 'Go to symbol' })
vim.keymap.set('n', '<leader>sS', function() vscode.action('workbench.action.showAllSymbols') end, { desc = 'Show all symbols' })
vim.keymap.set('n', '<leader>so', function() vscode.action('outline.focus') end, { desc = 'Focus outline' })

-- Debug
vim.keymap.set('n', '<leader>db', function() vscode.action('editor.debug.action.toggleBreakpoint') end, { desc = 'Toggle breakpoint' })
vim.keymap.set('n', '<leader>dB', function() vscode.action('editor.debug.action.conditionalBreakpoint') end, { desc = 'Conditional breakpoint' })
vim.keymap.set('n', '<leader>dc', function() vscode.action('workbench.action.debug.continue') end, { desc = 'Debug continue' })
vim.keymap.set('n', '<leader>do', function() vscode.action('workbench.action.debug.stepOver') end, { desc = 'Debug step over' })
vim.keymap.set('n', '<leader>di', function() vscode.action('workbench.action.debug.stepInto') end, { desc = 'Debug step into' })
vim.keymap.set('n', '<leader>dO', function() vscode.action('workbench.action.debug.stepOut') end, { desc = 'Debug step out' })
vim.keymap.set('n', '<leader>dr', function() vscode.action('workbench.action.debug.restart') end, { desc = 'Debug restart' })
vim.keymap.set('n', '<leader>ds', function() vscode.action('workbench.action.debug.stop') end, { desc = 'Debug stop' })

-- Panel and view management
vim.keymap.set('n', '<leader>p', function() vscode.action('workbench.action.togglePanel') end, { desc = 'Toggle panel' })
vim.keymap.set('n', '<leader>P', function() vscode.action('workbench.action.toggleAuxiliaryBar') end, { desc = 'Toggle auxiliary bar' })

-- Focus management for sidebars
vim.keymap.set('n', '<leader>fs', function() vscode.action('workbench.action.focusSideBar') end, { desc = 'Focus left sidebar' })
vim.keymap.set('n', '<leader>fa', function() vscode.action('workbench.action.focusAuxiliaryBar') end, { desc = 'Focus auxiliary bar (Cursor AI)' })
vim.keymap.set('n', '<leader>fe', function() vscode.action('workbench.action.focusActiveEditorGroup') end, { desc = 'Focus editor' })

-- Toggle and focus combinations
vim.keymap.set('n', '<leader>ts', function() 
    vscode.action('workbench.action.toggleSidebarVisibility')
    -- Small delay to ensure sidebar is open before focusing
    vim.defer_fn(function()
        vscode.action('workbench.action.focusSideBar')
    end, 50)
end, { desc = 'Toggle and focus left sidebar' })

vim.keymap.set('n', '<leader>ta', function() 
    vscode.action('workbench.action.toggleAuxiliaryBar')
    -- Small delay to ensure auxiliary bar is open before focusing
    vim.defer_fn(function()
        vscode.action('workbench.action.focusAuxiliaryBar')
    end, 50)
end, { desc = 'Toggle and focus auxiliary bar (Cursor AI)' })

vim.keymap.set('n', '<leader>tp', function() 
    vscode.action('workbench.action.togglePanel')
    -- Small delay to ensure panel is open before focusing
    vim.defer_fn(function()
        vscode.action('workbench.action.focusPanel')
    end, 50)
end, { desc = 'Toggle and focus bottom panel' })

-- Command palette and quick access
vim.keymap.set('n', '<leader><leader>', function() vscode.action('workbench.action.showCommands') end, { desc = 'Command palette' })
vim.keymap.set('n', '<leader>:', function() vscode.action('workbench.action.showCommands') end, { desc = 'Command palette' })

-- Exit insert mode (common Vim pattern)
vim.keymap.set('i', 'jj', '<Esc>', { desc = 'Exit insert mode' })
vim.keymap.set('i', 'jk', '<Esc>', { desc = 'Exit insert mode' })

-- Text manipulation
vim.keymap.set('n', '<leader>u', function() vscode.action('editor.action.transformToUppercase') end, { desc = 'Transform to uppercase' })
vim.keymap.set('n', '<leader>l', function() vscode.action('editor.action.transformToLowercase') end, { desc = 'Transform to lowercase' })

-- Workspace folders
vim.keymap.set('n', '<leader>wf', function() vscode.action('workbench.action.addRootFolder') end, { desc = 'Add workspace folder' })
vim.keymap.set('n', '<leader>wr', function() vscode.action('workbench.action.removeRootFolder') end, { desc = 'Remove workspace folder' })
