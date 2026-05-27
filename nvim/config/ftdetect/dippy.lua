vim.filetype.add({
  filename = {
    [".dippy"] = "dippy",
    ["config"] = function(path)
      if path:match("%.dippy/config$") then
        return "dippy"
      end
    end,
  },
  pattern = {
    [".*%.dippy"] = "dippy",
  },
})
