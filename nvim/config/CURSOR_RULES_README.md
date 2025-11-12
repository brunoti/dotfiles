# CodeCompanion Cursor Rules Integration

This configuration extends `codecompanion.nvim` to automatically load and utilize `.cursorrules` and `.cursor/rules` files for providing project-specific context to AI assistants.

## Features

- **Automatic Loading**: Cursor rules are automatically loaded when Neovim starts and when changing directories
- **Multiple File Support**: Loads from `.cursorrules`, `.cursor/rules`, `~/.cursorrules`, and `~/.cursor/rules`
- **Live Reloading**: Rules are automatically reloaded when cursor rules files are saved
- **Multiple Access Methods**: Slash commands, keymaps, and manual commands
- **Smart Project Detection**: Automatically finds project root using common markers (`.git`, `.cursorrules`, etc.)
- **Standalone Plugin**: Works independently without requiring specific default prompts

## File Locations

The extension prioritizes Git repositories and searches for cursor rules in the following order:

### Project Root Detection (Priority Order)
1. **Git root** (using `git rev-parse --show-toplevel`) - **Highest Priority**
2. Directory with `.git` folder
3. Directory with `.cursorrules` file
4. Directory with `.cursor` folder
5. Directory with `package.json`, `pyproject.toml`, or `Cargo.toml`
6. Current working directory (fallback)

### Cursor Rules File Search Order
1. `{project_root}/.cursorrules`
2. `{project_root}/.cursor/rules`
3. `~/.cursorrules` (global user rules)
4. `~/.cursor/rules` (global user rules)

All found files are concatenated and made available to CodeCompanion. Files loaded from the git root are clearly marked in the formatted output.

## Usage

### Keymaps

- `<leader>cr` - Add cursor rules to current chat
- `<leader>cl` - Load/reload cursor rules from files

### Slash Commands

In any CodeCompanion chat, use these slash commands:

- `/cursor-rules` or `/cr` - Load cursor rules into current chat context
- `/reload-cursor-rules` or `/rcr` - Reload cursor rules from files

### Automatic Integration

- **Default System Prompt**: All new chats automatically include cursor rules and expert personas
- **Variable Access**: Cursor rules are available via the `${cursor_rules}` variable in custom prompts
- **Consistent Context**: Rules are applied automatically without needing specific "apply rules" commands

### Manual Commands

- `:CodeCompanionLoadCursorRules` - Load cursor rules as variables
- `:CodeCompanionAddCursorRules` - Add cursor rules to current chat

### Example Cursor Rules File

Create a `.cursorrules` file in your git repository root (or project root):

```markdown
# Project Coding Rules

## General Guidelines
- Use TypeScript for all new JavaScript code
- Prefer functional programming patterns
- Write comprehensive JSDoc comments for all functions
- Use descriptive variable names

## Code Style
- Use 2 spaces for indentation
- Prefer const over let, avoid var
- Use arrow functions for inline functions
- Use template literals instead of string concatenation

## Testing
- Write unit tests for all new functions
- Use Jest for testing framework
- Aim for >90% code coverage
- Write integration tests for API endpoints

## Error Handling
- Always handle errors explicitly
- Use proper error types and messages
- Log errors with appropriate context
- Never fail silently
```

## Automatic Behavior

1. **On Startup**: Cursor rules are automatically loaded when Neovim starts
2. **Directory Changes**: Rules are reloaded when changing directories
3. **File Saves**: Rules are reloaded when `.cursorrules` or `rules` files are saved
4. **Live Updates**: Variables are automatically updated with the latest cursor rules

## Integration with Other Extensions

This cursor rules integration works alongside:

- **mcphub.nvim**: MCP tools and resources
- **codecompanion-history.nvim**: Chat history and summaries
- **Other CodeCompanion extensions**: Variables and slash commands are shared

## Technical Details

### Files Created

- `lua/codecompanion/cursor_rules.lua` - Main extension logic
- `lua/codecompanion/init.lua` - Extension initialization
- Modified `lua/plugins.lua` - CodeCompanion configuration with new slash commands
- Modified `after/plugin/mappings.lua` - Added keymaps for cursor rules functionality

### Variables

The cursor rules content is available as:

- `${cursor_rules}` - CodeCompanion variable (if supported)
- `vim.g.codecompanion_cursor_rules` - Global Vim variable (fallback)

### Auto Commands

The extension creates auto commands for:

- `BufWritePost` on `.cursorrules` and `rules` files - Reload rules
- `DirChanged` - Reload rules when changing directories

## Troubleshooting

### No Rules Found

If you see "No cursor rules files found":

1. Check that you have a `.cursorrules` or `.cursor/rules` file in your git repository root
2. Verify you're in a git repository (run `git status` to check)
3. Ensure the files are readable and contain content
4. Try manually running `:CodeCompanionLoadCursorRules` to see detailed output
5. Check if the plugin detected the correct project root by looking at notification messages

### Rules Not Loading

If rules aren't being applied:

1. Check that the files contain content (not empty)
2. Verify you're in the correct project directory
3. Try reloading with `<leader>cl` or the slash command `/rcr`

### Variable Not Working

If `${cursor_rules}` doesn't work in prompts:

1. The extension falls back to `vim.g.codecompanion_cursor_rules`
2. Use the fallback in your custom prompts:
   ```lua
   local cursor_rules = vim.g.codecompanion_cursor_rules or "No rules found"
   ```

## Customization

You can modify the extension by editing `after/plugin/codecompanion_cursor_rules.lua`:

- Change file search locations
- Modify the formatting of rules
- Add additional auto-reload triggers
- Customize the prompt templates

## Contributing

Feel free to suggest improvements or report issues with the cursor rules integration.
