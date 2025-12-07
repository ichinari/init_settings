require("hlslens").setup()
local kopts = { noremap = true, silent = true }

vim.keymap.set("n", "n", function()
  local ok = pcall(vim.cmd, "normal! n")
  if ok then require("hlslens").start() end
end, kopts)
vim.keymap.set("n", "N", function()
  local ok = pcall(vim.cmd, "normal! N")
  if ok then require("hlslens").start() end
end, kopts)
vim.keymap.set("n", "*", function()
  local ok = pcall(vim.cmd, "normal! *")
  if ok then require("hlslens").start() end
end, kopts)
vim.keymap.set("n", "#", function()
  local ok = pcall(vim.cmd, "normal! #")
  if ok then require("hlslens").start() end
end, kopts)

