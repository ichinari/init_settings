-- ~/.config/nvim/lua/user/terminal_keys.lua
local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", { silent = true, noremap = true }, opts))
  end
  
  -- Jobからノーマルへ
  map("t", "<Esc><Esc>", [[<C-\><C-n>]])
  map("t", "<C-Space>",  [[<C-\><C-n>]])
  map("t", "<A-Esc>",    [[<C-\><C-n>]])
  
  -- Job中でも分割移動
  map("t", "<A-h>", [[<C-\><C-n><C-w>h]])
  map("t", "<A-j>", [[<C-\><C-n><C-w>j]])
  map("t", "<A-k>", [[<C-\><C-n><C-w>k]])
  map("t", "<A-l>", [[<C-\><C-n><C-w>l]])
  
  -- ノーマルでも分割移動
  map("n", "<A-h>", [[<C-w>h]])
  map("n", "<A-j>", [[<C-w>j]])
  map("n", "<A-k>", [[<C-w>k]])
  map("n", "<A-l>", [[<C-w>l]])
  