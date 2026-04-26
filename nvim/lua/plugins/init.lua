-- ~/.config/nvim/lua/plugins/init.lua
-- NOTE: 重要プラグインは lazy=false で常時ロード。安定後に cmd/event へ戻す。
return {
  -- 既存: conform.nvim
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- 既存: lspconfig ★重要
  {
    "neovim/nvim-lspconfig",
    lazy = false, -- 安定後に event = "BufReadPre" へ
    config = function()
      require "configs.lspconfig"
    end,
  },

  ---------------------------------------------------------------------------
  -- 追加プラグイン
  ---------------------------------------------------------------------------

  -- JSX/HTML タグ自動閉じ（<p> の > で </p> が挿入される）
  {
    "windwp/nvim-ts-autotag",
    lazy = false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = false,
        },
      })
    end,
  },

  -- toggleterm.nvim（ターミナル統合）★重要
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    lazy = false, -- 安定後に cmd = { "ToggleTerm", "LazyGit" } へ
    config = function()
      require "configs.toggleterm"
    end,
  },

  -- winresizer（ウィンドウサイズ調整）
  {
    "simeji/winresizer",
    lazy = false,
    config = function()
      require "configs.winresizer"
    end,
  },

  -- vim-operator-convert-case（camel/snake 変換）
  {
    "kana/vim-operator-user",
  },
  {
    "mopp/vim-operator-convert-case",
    config = function()
      require "configs.vim-operator-convert-case"
    end,
  },

  -- nvim-hlslens（検索ハイライト拡張）★重要
  {
    "kevinhwang91/nvim-hlslens",
    lazy = false, -- 安定後に event = "CmdlineEnter" へ
    config = function()
      require "configs.hlslens"
    end,
  },

  -- auto-save.nvim（自動保存）★重要
  {
    "okuuva/auto-save.nvim",
    lazy = false, -- 安定後に event = { "InsertLeave", "TextChanged" } へ
    config = function()
      require "configs.auto-save"
    end,
  },

  -- comment-box.nvim（コメント枠）
  {
    "LudoPinelli/comment-box.nvim",
    config = function()
      require "configs.comment-box"
    end,
  },

  -- telescope（fuzzy finder）★重要
  {
    "nvim-telescope/telescope.nvim",
    lazy = false, -- 安定後に cmd = "Telescope" へ
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- fzf ネイティブ（任意だが高速化推奨）
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      -- devicons（任意だが見た目向上）
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require "configs.telescope"
    end,
  },

  -- lsp_signature.nvim（関数シグネチャ）★重要
  {
    "ray-x/lsp_signature.nvim",
    lazy = false, -- 安定後に event = "LspAttach" へ
    config = function()
      require "configs.lsp_signature"
    end,
  },

  -- trouble.nvim（診断ビュー）★重要
  {
    "folke/trouble.nvim",
    lazy = false, -- 安定後に cmd = "Trouble" へ
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require "configs.trouble"
    end,
  },

  -- gitsigns.nvim（行注釈など）★重要
  {
    "lewis6991/gitsigns.nvim",
    lazy = false, -- 安定後に event = "BufReadPre" へ
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require "configs.gitsigns"
    end,
  },

  -- git-messenger.nvim（その行のコミットメッセージ）
  {
    "rhysd/git-messenger.vim",
    config = function()
      require "configs.git-messenger"
    end,
  },

  -- blamer.nvim（インライン blame）★重要
  {
    "APZelos/blamer.nvim",
    lazy = false, -- 安定後に event = "BufReadPre" へ
    config = function()
      require "configs.blamer"
    end,
  },

  -- diffview.nvim（差分ビュー）★重要
  {
    "sindrets/diffview.nvim",
    lazy = false, -- 安定後に cmd = { "DiffviewOpen", "DiffviewClose" } へ
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "tpope/vim-fugitive", -- Optional: 一部操作であると便利
    },
    config = function()
      require "configs.diffview"
    end,
  },

  -- vim-translator（選択範囲の翻訳）
  {
    "voldikss/vim-translator",
    config = function()
      require "configs.vim-translator"
    end,
  },

  -- noice.nvim（UIの完全置換：メッセージ、コマンドライン、ポップアップメニュー）★重要
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",      -- UI コンポーネント（必須）
      "rcarriga/nvim-notify",      -- 通知表示（推奨）
    },
    config = function()
      require "configs.noice"
    end,
  },

  -- スタートアップダッシュボード（カスタムAA対応）
  {
    "goolord/alpha-nvim",
    lazy = false,
    priority = 1000,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      -- カスタムAAを読み込む（lua/custom/ascii_art.lua）
      local ok, ascii_art = pcall(require, "custom.ascii_art")
      if ok then
        dashboard.section.header.val = ascii_art.selected
      end
      return dashboard.opts
    end,
    config = function(_, opts)
      require("alpha").setup(opts)
    end,
  },

  -- GitHub Copilot（補完 + チャット）
  unpack(require("plugins.copilot")),
}
