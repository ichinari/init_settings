-- ~/.config/nvim/lua/custom/plugins/init.lua
return {
  -- フォーマッタ統合（Conform）
  {
    "stevearc/conform.nvim",
    -- event = "BufWritePre", -- 保存時フォーマットを有効化したい場合はコメント解除
    opts = function()
      -- configs/conform.lua に置いている場合は require を使ってもOK
      -- return require("configs.conform")
      return {
        formatters_by_ft = {
          javascript = { "prettier" },
          typescript = { "prettier" },
          javascriptreact = { "prettier" },
          typescriptreact = { "prettier" },
          json = { "prettier" },
          css = { "prettier" },
          html = { "prettier" },
          markdown = { "prettier" },
        },
      }
    end,
  },

  -- LSP本体設定（vtsls を Mason で導入）
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "yioneko/nvim-vtsls",
    },
    config = function()
      require("mason").setup({})
      require("mason-lspconfig").setup({
        ensure_installed = { "vtsls", "html", "cssls", "tailwindcss" },
        automatic_installation = true,
      })
    end,
  },

  -- JSXタグ自動閉じ（既存）
  {
    "windwp/nvim-ts-autotag",
    event = "BufReadPre",
    ft = { "html", "javascript", "typescript", "javascriptreact", "typescriptreact", "vue", "svelte", "xml" },
    config = function()
      require("nvim-ts-autotag").setup({})
    end,
  },

  -- 括弧ペア補完（既存）
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },

  -- ESLint診断（既存）
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescriptreact = { "eslint_d" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "TextChanged" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },

  -- 任意：Treesitterの確実化（React/TSX）
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "javascript",
        "typescript",
        "tsx",
        "json",
        "html",
        "css",
        "lua",
        "vim",
        "vimdoc",
        "vue",
        "svelte",
        "xml",
      },
      highlight = { enable = true },
    },
    build = ":TSUpdate",
  },

  -- 任意：ファイルツリー、スクロール、Git差分など（必要なら）
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle NvimTree" },
      { "<leader>E", "<cmd>NvimTreeFindFile<cr>", desc = "Reveal current file in NvimTree" },
    },
    opts = {
      hijack_netrw = true,
      update_focused_file = { enable = true, update_cwd = true },
      renderer = { highlight_git = true },
      git = { enable = true, ignore = false },
      filters = { git_ignored = false, dotfiles = false },
      view = { width = 32 },
    },
    config = function(_, opts)
      require("nvim-tree").setup(opts)
    end,
  },
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    opts = {
      easing_function = "quadratic",
      hide_cursor = true,
      respect_scrolloff = true,
    },
    config = function(_, opts)
      require("neoscroll").setup(opts)
      local t = {}
      t["<C-u>"] = { "scroll", { "-vim.wo.scroll", "true", "100" } }
      t["<C-d>"] = { "scroll", { "vim.wo.scroll", "true", "100" } }
      t["<C-b>"] = { "scroll", { "-vim.api.nvim_win_get_height(0)", "true", "150" } }
      t["<C-f>"] = { "scroll", { "vim.api.nvim_win_get_height(0)", "true", "150" } }
      require("neoscroll.config").set_mappings(t)
    end,
  },
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Open Diffview" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History (current file)" },
    },
    opts = { enhanced_diff_hl = true, use_icons = true },
  },
  {
    "shellRaining/hlchunk.nvim",
    event = "VeryLazy",
    opts = {
      chunk = { enable = true, style = { { fg = "#9ece6a" } }, duration = 200 },
      indent = { enable = true, chars = { "│" } },
    },
  },
  {
    "ysmb-wtsg/in-and-out.nvim",
    event = "InsertEnter",
    opts = {
      mappings = {
        exit_pair = "<C-l>",
        exit_quotes = "<C-'>",
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    opts = {
      heading = { border = true },
      code = { border = "rounded" },
      bullet = { icons = { "•", "◦", "▪" } },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      current_line_blame = true,
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end
        map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
        map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
        map("n", "]h", gs.next_hunk, "Next hunk")
        map("n", "[h", gs.prev_hunk, "Prev hunk")
      end,
    },
  },

  -- スタートアップダッシュボード
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
      require("alpha").setup(require("alpha.themes.dashboard").config)
    end,
  },
}

