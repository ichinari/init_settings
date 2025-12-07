-- confirm.lua
local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    graphql = { "prettier" },
    vue = { "prettier" },
    svelte = { "prettier" },
  },

  format_on_save = {
    -- LSP が format も提供していると、保存時に LSP と Prettier が両方動く可能性があるため無効化推奨
    timeout_ms = 1000,
    lsp_fallback = false,
  },
}

-- conform.nvim に Prettier のローカル版を優先して使わせる（プロジェクトの node_modules/.bin を使う）
-- プラグインのロード箇所で以下を一度だけ設定してください（このファイルの下でもOK）
local ok, conform = pcall(require, "conform")
if ok then
  conform.setup(options)

  -- 明示的にローカル prettier を優先。必要なければ削ってもOKですが、環境差を避けられます。
  conform.formatters.prettier = conform.formatters.prettier or {}
  conform.formatters.prettier = vim.tbl_deep_extend("force", conform.formatters.prettier, {
    -- command を明示する方法（プロジェクト直下で動かす想定）
    -- command = vim.fn.getcwd() .. "/node_modules/.bin/prettier",
    -- 追加の引数が必要ならここに。通常は不要。
    prepend_args = {},
  })
end

return options
