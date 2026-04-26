local nv_defaults = require("nvchad.configs.lspconfig")
nv_defaults.defaults()

local on_attach = nv_defaults.on_attach
local capabilities = nv_defaults.capabilities

-- Mason で入れた LSP を確実に実行できるよう PATH の先頭に追加
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
if vim.fn.isdirectory(mason_bin) == 1 then
  vim.env.PATH = mason_bin .. ":" .. (vim.env.PATH or "")
end

-- vtsls の実行ファイル（Mason が入れたものを絶対パスで指定）
local vtsls_cmd = mason_bin .. "/vtsls"
if vim.fn.executable(vtsls_cmd) ~= 1 then
  vtsls_cmd = "vtsls" -- フォールバック（npm -g など）
end

-- vtsls（TypeScript/JavaScript）- 型エラーはここで診断として表示される
vim.lsp.config("vtsls", {
  cmd = { vtsls_cmd, "--stdio" },
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    if on_attach then
      on_attach(client, bufnr)
    end
  end,
  capabilities = capabilities,
  -- study_6 のような front/ backend/ 構成で、package.json/tsconfig があるディレクトリを root にする
  root_dir = function(bufnr, on_dir)
    local buf_path = vim.api.nvim_buf_get_name(bufnr)
    if buf_path == "" then
      on_dir(vim.fn.getcwd())
      return
    end
    local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock", ".git" }
    local root = vim.fs.root(bufnr, root_markers)
    on_dir((root and root ~= "") and root or vim.fn.getcwd())
  end,
  init_options = {
    typescript = {
      suggest = { autoImports = true },
      inlayHints = { parameterNames = { enabled = "all" }, variableTypes = { enabled = true } },
    },
    javascript = {
      suggest = { autoImports = true },
      inlayHints = { parameterNames = { enabled = "all" }, variableTypes = { enabled = true } },
    },
  },
})
vim.lsp.enable("vtsls")

-- HTML / CSS / Tailwind（Mason で cssls を入れておくこと: :MasonInstall css_lsp など）
vim.lsp.enable({ "html", "cssls", "tailwindcss" })

-- read :h vim.lsp.config for changing options of lsp servers

-- 診断表示の設定（型エラーなどを下線・行末・ガターに表示）
vim.diagnostic.config({
  underline = true,
  virtual_text = {
    prefix = "●",
    spacing = 4,
    format = function(diag)
      return diag.message
    end,
  },
  -- Neovim 0.11 向けの宣言的サイン（行番号横のアイコン）
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = " ",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
  },
})

-- シグネチャヘルプを「カーソル行の上」に表示してコードを遮らないようにする
local util = vim.lsp.util
vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, _config)
  if err or not result or not result.signatures or not result.signatures[1] then
    return
  end
  local lines = util.convert_signature_help_to_markdown_lines(result)
  if not lines or #lines == 0 then
    return
  end
  local bufnr = ctx.bufnr or 0
  local ft = vim.bo[bufnr].filetype
  util.open_floating_preview(lines, ft, {
    border = "rounded",
    focusable = false,
    close_events = { "BufHidden", "InsertLeave" },
    relative = "cursor",
    row = 0,
    col = 0,
    anchor = "SW", -- フロートの下辺をカーソルに合わせる＝ウィンドウは行の上に表示
  })
end
