-- ~/.config/nvim/lua/configs/lazy.lua
-- Lazy のUI自動オープンを抑止し、検出通知も控えめにする
return {
  defaults = { lazy = true },
  install = {
    colorscheme = { "nvchad" },
    missing = false, -- 起動時に不足プラグインのインストールUIを開かない
  },

  ui = {
    icons = {
      ft = "",
      lazy = "󰂠 ",
      loaded = "",
      not_loaded = "",
    },
  },

  checker = {
    enabled = false, -- プラグイン更新チェックを無効化（UIが開く原因になる）
  },

  change_detection = {
    enabled = true,
    notify = false, -- 設定変更検出時の通知を抑制
  },

  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "tohtml",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "matchit",
        "tar",
        "tarPlugin",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
        "tutor",
        "rplugin",
        "syntax",
        "synmenu",
        "optwin",
        "compiler",
        "bugreport",
        "ftplugin",
      },
    },
  },
}
