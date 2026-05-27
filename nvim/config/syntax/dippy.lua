if vim.b.current_syntax then
  return
end

local cmd = vim.cmd

cmd([[syn match DippyComment /#.*$/]])

cmd(
  [[syn match DippyKeyword /^\s*\(allow-redirect\|ask-redirect\|deny-redirect\|allow-mcp\|ask-mcp\|deny-mcp\|after-mcp\|allow\|ask\|deny\|after\|alias\|set\)\>/]])
cmd([[syn match DippySetting /^\s*set\s\+\zs[a-zA-Z_-]\+/]])

cmd([[syn region DippyString start=/"/ end=/"/ skip=/\\./ contains=DippyEscape]])
cmd([[syn match DippyEscape /\\./ contained]])

cmd([[syn match DippyGlob /[*?~]/]])

cmd([[hi def link DippyComment Comment]])
cmd([[hi def link DippyKeyword Keyword]])
cmd([[hi def link DippySetting Type]])
cmd([[hi def link DippyString String]])
cmd([[hi def link DippyEscape SpecialChar]])
cmd([[hi def link DippyGlob Operator]])

vim.b.current_syntax = "dippy"
