vim.g.blamer_enabled = 0
vim.g.blamer_delay = 500
vim.g.blamer_show_in_visual_modes = 0
vim.keymap.set("n", "<leader>gb", function()
  vim.g.blamer_enabled = (vim.g.blamer_enabled == 1) and 0 or 1
end, { desc = "toggle blamer" })

