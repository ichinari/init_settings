-- ~/.config/nvim/lua/plugins/auto-save.lua
return {
  "okuuva/auto-save.nvim",
  version = "*",          -- 安定版を使うなら指定
  lazy = false,           -- 検証中は起動時ロード（後でeventに戻す）
  config = function()
    require("configs.auto-save")     -- あなたの既存の設定ファイルを呼ぶ
  end,
}
