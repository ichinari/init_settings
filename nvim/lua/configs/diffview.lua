local ok, diffview = pcall(require, "diffview")
if ok then
  diffview.setup {}
  vim.keymap.set("n", "<leader>dv", "<cmd>DiffviewOpen<CR>", { desc = "Diffview open" })
  vim.keymap.set("n", "<leader>dc", "<cmd>DiffviewClose<CR>", { desc = "Diffview close" })
end

