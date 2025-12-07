-- 翻訳のUIと方向を簡単に設定（英→日/日→英をトグル）
vim.g.translator_target_lang = "ja"
vim.g.translator_default_engines = { "google" }
-- ノーマル/ビジュアルで選択範囲の翻訳
vim.keymap.set({ "n", "v" }, "<leader>tr", "<Plug>(translator-translate)", { silent = true, desc = "translate" })
vim.keymap.set({ "n", "v" }, "<leader>ts", "<Plug>(translator-translate-and-substitute)", { silent = true, desc = "translate & substitute" })

