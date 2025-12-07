require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "ts_ls", "tailwindcss" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers

-- 診断表示の設定（エラー箇所に赤い下線を表示）
vim.diagnostic.config({
  underline = true,           -- エラー箇所に下線を表示（画像の赤線）
  virtual_text = {
    prefix = "●",             -- 行末に表示するアイコン
    spacing = 4,
  },
  signs = true,               -- 行番号横にサインを表示
  update_in_insert = false,   -- インサートモード中は更新しない
  severity_sort = true,       -- 重要度順にソート
  float = {
    border = "rounded",
    source = true,            -- エラーのソース（どのLSPか）を表示
  },
})

-- 診断サインのカスタマイズ（アイコン）
local signs = {
  Error = " ",
  Warn = " ",
  Hint = " ",
  Info = " ",
}
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
