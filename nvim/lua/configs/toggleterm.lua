require("toggleterm").setup {
  size = 12,
  open_mapping = [[<C-`>]],  -- <C-\> は Terminal-Normal 用に空けておく
  shade_terminals = true,
  direction = "float",
  float_opts = {
    border = "rounded",
    width = function() return math.floor(vim.o.columns * 0.9) end,
    height = function() return math.floor(vim.o.lines * 0.9) end,
  },
}

-- NOTE: LazyGit は lazygit.nvim プラグインで管理（lua/plugins/lazyvim.lua）

