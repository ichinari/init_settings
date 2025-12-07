require("toggleterm").setup {
  size = 12,
  open_mapping = [[<C-`>]],  -- <C-\> は Terminal-Normal 用に空けておく
  shade_terminals = true,
  direction = "float",
  float_opts = { border = "rounded" },
}

-- lazygitを浮遊で
vim.api.nvim_create_user_command("LazyGit", function()
  local Terminal = require("toggleterm.terminal").Terminal
  Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" }):toggle()
end, {})

