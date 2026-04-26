-- ~/.config/nvim/lua/plugins/copilot.lua
-- 参考: https://note.com/dd_techblog/n/n17675317acaa

return {
  -- GitHub Copilot 補完（Lua製・nvim-cmp と統合）
  -- lazy = false で起動時ロード（:Copilot auth 実行時に module not found を防ぐ）
  {
    "zbirenbaum/copilot.lua",
    lazy = false,
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = false, -- copilot-cmp で表示するため無効化
          auto_trigger = false,
          keymap = { accept = false },
        },
        panel = { enabled = false },
        filetypes = {
          markdown = true,
          ["."] = false,
        },
      })

      -- :Copilot auth が「何も起きない」対策: LSP 起動後に認証を実行するコマンド
      vim.api.nvim_create_user_command("CopilotAuth", function()
        local client = require("copilot.client")
        client.ensure_client_started()
        vim.defer_fn(function()
          local c = client.get()
          if c then
            require("copilot.auth").setup(c)
          else
            vim.notify(
              "[Copilot] LSP が起動していません。Node.js をインストールし、:Copilot status で状態を確認してください。",
              vim.log.levels.ERROR
            )
          end
        end, 800)
      end, {})
    end,
  },

  -- copilot-cmp: nvim-cmp の補完ソースとして Copilot を統合
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },

  -- nvim-cmp に copilot ソースを追加（NvChad の cmp 設定を拡張）
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      if type(opts.sources) == "table" then
        table.insert(opts.sources, 1, { name = "copilot", group_index = 1 })
      end
      return opts
    end,
    dependencies = { "zbirenbaum/copilot-cmp" },
  },

  -- Copilot Chat（チャット機能・日本語プロンプト）
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      "zbirenbaum/copilot.lua",
      "nvim-lua/plenary.nvim",
    },
    opts = {
      debug = false,
      window = {
        layout = "vertical",
        width = 0.5,
      },
      system_prompt = [[
あなたは経験豊富な日本人のシニアプログラマーです。
以下のルールに従って回答してください：
1. すべての説明は日本語で行う
2. コード内のコメントも日本語で記述する
3. 技術用語は必要に応じて英語併記する
4. コードは実践的で本番環境で使用できる品質にする
5. ベストプラクティスとデザインパターンを適用する
      ]],
      question_header = "## User ",
      answer_header = "## Copilot ",
      error_header = "## Error ",
    },
    keys = {
      { "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "Copilot Chat" },
      { "<leader>ce", "<cmd>CopilotChatExplain<cr>", desc = "Copilot Explain" },
      { "<leader>cf", "<cmd>CopilotChatFix<cr>", desc = "Copilot Fix" },
    },
  },
}
