-- ~/.config/nvim/lua/configs/noice.lua
-- noice.nvim の設定

require("noice").setup({
  -- cmdline の設定
  cmdline = {
    enabled = true,
    view = "cmdline_popup", -- cmdline_popup または cmdline
    opts = {},
    format = {
      cmdline = { pattern = "^:", icon = "", lang = "vim" },
      search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
      search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
      filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
      lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
      help = { pattern = "^:%s*he?l?p?%s+", icon = "󰋖" },
      input = { view = "cmdline_input", icon = "󰥻 " },
    },
  },

  -- メッセージの設定
  messages = {
    enabled = true,
    view = "notify",
    view_error = "notify",
    view_warn = "notify",
    view_history = "messages",
    view_search = "virtualtext",
  },

  -- ポップアップメニューの設定
  popupmenu = {
    enabled = true,
    backend = "nui", -- nui または cmp
    kind_icons = {},
  },

  -- リダイレクト設定
  redirect = {
    view = "popup",
    filter = { event = "msg_show" },
  },

  -- コマンド
  commands = {
    history = {
      view = "split",
      opts = { enter = true, format = "details" },
      filter = {
        any = {
          { event = "notify" },
          { error = true },
          { warning = true },
          { event = "msg_show", kind = { "" } },
          { event = "lsp", kind = "message" },
        },
      },
    },
    last = {
      view = "popup",
      opts = { enter = true, format = "details" },
      filter = {
        any = {
          { event = "notify" },
          { error = true },
          { warning = true },
          { event = "msg_show", kind = { "" } },
          { event = "lsp", kind = "message" },
        },
      },
      filter_opts = { count = 1 },
    },
    errors = {
      view = "popup",
      opts = { enter = true, format = "details" },
      filter = { error = true },
      filter_opts = { reverse = true },
    },
    all = {
      view = "split",
      opts = { enter = true, format = "details" },
      filter = {},
    },
  },

  -- 通知設定
  notify = {
    enabled = true,
    view = "notify",
  },

  -- LSP設定
  lsp = {
    progress = {
      enabled = true,
      format = "lsp_progress",
      format_done = "lsp_progress_done",
      throttle = 1000 / 30,
      view = "mini",
    },
    override = {
      -- LSP hover/signature を noice で処理
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
    hover = {
      enabled = true,
      silent = false,
      view = nil,
      opts = {},
    },
    signature = {
      enabled = false, -- lspconfig で「行の上」に表示するため noice のシグネチャは使わない
      auto_open = { enabled = false, trigger = false, luasnip = false, throttle = 50 },
      view = nil,
      opts = {},
    },
    message = {
      enabled = true,
      view = "notify",
      opts = {},
    },
    documentation = {
      view = "hover",
      opts = {
        lang = "markdown",
        replace = true,
        render = "plain",
        format = { "{message}" },
        win_options = { concealcursor = "n", conceallevel = 3 },
      },
    },
  },

  -- マークダウン設定
  markdown = {
    hover = {
      ["|(%S-)|"] = vim.cmd.help,
      ["%[.-%]%((%S-)%)"] = require("noice.util").open,
    },
    highlights = {
      ["|%S-|"] = "@text.reference",
      ["@%S+"] = "@parameter",
      ["^%s*(Parameters:)"] = "@text.title",
      ["^%s*(Return:)"] = "@text.title",
      ["^%s*(See also:)"] = "@text.title",
      ["{%S-}"] = "@parameter",
    },
  },

  -- ヘルスチェック
  health = {
    checker = true,
  },

  -- プリセット
  presets = {
    bottom_search = false,        -- 検索を下部に表示
    command_palette = true,       -- コマンドパレットスタイル
    long_message_to_split = true, -- 長いメッセージを split に
    inc_rename = false,           -- inc-rename.nvim 用
    lsp_doc_border = true,        -- LSP hover に border を追加
  },

  -- スロットリング
  throttle = 1000 / 30,

  -- ビュー設定
  views = {},

  -- ルート設定
  routes = {
    -- 書き込み時のメッセージを非表示
    {
      filter = {
        event = "msg_show",
        kind = "",
        find = "written",
      },
      opts = { skip = true },
    },
    -- 検索メッセージを virtualtext に
    {
      filter = { event = "msg_show", kind = "search_count" },
      opts = { skip = true },
    },
  },

  -- ステータス
  status = {},

  -- フォーマット
  format = {},
})

-- nvim-notify の設定（任意でカスタマイズ）
local notify_ok, notify = pcall(require, "notify")
if notify_ok then
  notify.setup({
    background_colour = "#000000",
    fps = 30,
    icons = {
      DEBUG = "",
      ERROR = "",
      INFO = "",
      TRACE = "✎",
      WARN = "",
    },
    level = 2,
    minimum_width = 50,
    render = "default",
    stages = "fade_in_slide_out",
    time_formats = {
      notification = "%T",
      notification_history = "%FT%T",
    },
    timeout = 3000,
    top_down = true,
  })
  vim.notify = notify
end

