-- ~/.config/nvim/lua/mappings.lua

-- まずNvChad既定を読み込む
require "nvchad.mappings"

local map = vim.keymap.set

-- ### Insert Mode
map("i", "jj", "<ESC>")
map("i", "<C-y>", 'copilot#Accept("<CR>")', { noremap = true, silent = true, expr = true, script = true, replace_keycodes = false })

-- ### Normal Mode
map("n", "<leader>h", "^", { desc = "move beginning of line" })
map("n", "<leader>l", "$", { desc = "move ending of line" })
map("n", "<leader>q", "<cmd>q!<CR>", { desc = "quit" })

-- LazyGit を toggleterm のフロートに統一
map("n", "<leader>t", function()
  vim.cmd("LazyGit")
end, { desc = "LazyGit (float via toggleterm)" })

-- ### Visual Mode
map("v", "v", "$h", { desc = "行末まで選択" })

-- ### Terminal Mode
map("t", "<C-n>", [[<C-\><C-n>]], { desc = "Terminal-Normal" })

-- 追記: よく使う汎用
map("n", "<leader>w", "<cmd>w<CR>", { desc = "write file" })
map("n", "<leader>nh", "<cmd>nohlsearch<CR>", { desc = "clear search highlight" })

-- 追記: Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "help tags" })

-- 追記: LSP
map("n", "gd", function() vim.lsp.buf.definition() end, { desc = "go to definition" })
map("n", "gr", "<cmd>Telescope lsp_references<CR>", { desc = "references" })
map("n", "K", function() vim.lsp.buf.hover() end, { desc = "hover" })
map("n", "<leader>rn", function() vim.lsp.buf.rename() end, { desc = "rename symbol" })
map("n", "<leader>ca", function() vim.lsp.buf.code_action() end, { desc = "code action" })
map("n", "<leader>fd", function() vim.diagnostic.open_float() end, { desc = "diagnostics float" })
map("n", "[d", function() vim.diagnostic.goto_prev() end, { desc = "prev diagnostic" })
map("n", "]d", function() vim.diagnostic.goto_next() end, { desc = "next diagnostic" })

-- 追記: Formatter
map("n", "<leader>fm", function() vim.lsp.buf.format({ async = false }) end, { desc = "format" })

-- Claude CLI
pcall(require, "custom.claude_cli")
map({ "n", "v" }, "<leader>ce", ":ClaudeCLI Improve this code for readability and best practices.<CR>", { desc = "Claude (CLI): edit/improve selection" })
map({ "n", "v" }, "<leader>cx", ":ClaudeExplain<CR>", { desc = "Claude (CLI): explain selection" })
map({ "n", "v" }, "<leader>ct", ":ClaudeTests<CR>", { desc = "Claude (CLI): generate tests" })
map({ "n", "v" }, "<leader>ca", ":ClaudeApply<CR>", { desc = "Claude (CLI): apply rewritten code" })

-- 追記: ToggleTerm
map("n", "<leader>tt", "<cmd>ToggleTerm<CR>", { desc = "toggle terminal" })

-- 追記: Trouble
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Trouble diagnostics" })
map("n", "<leader>xq", "<cmd>Trouble qflist toggle<CR>", { desc = "Trouble quickfix" })
