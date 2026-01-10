require "nvchad.autocmds"

-- ターミナルバッファの設定
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    -- タブラインに表示しないようにbuflisted=false
    vim.bo.buflisted = false
    -- フロートウィンドウでない場合のみ右側に移動
    local win = vim.api.nvim_get_current_win()
    local config = vim.api.nvim_win_get_config(win)
    if config.relative == "" then
      -- 通常ウィンドウの場合のみ右側に固定
      vim.cmd("wincmd L")
    end
  end,
})

-- 透過設定を強制適用
vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
  callback = function()
    local groups = {
      "Normal",
      "NormalNC",
      "NormalFloat",
      "NvDashAscii",
      "NvDashButtons",
      "NvimTreeNormal",
      "NvimTreeNormalNC",
      "NvimTreeWinSeparator",
      "TelescopeNormal",
      "TelescopeBorder",
      "TelescopePromptNormal",
      "TelescopeResultsNormal",
      "TelescopePreviewNormal",
      "SignColumn",
      "EndOfBuffer",
      "MsgArea",
      "FloatBorder",
      "Pmenu",
      "TabLine",
      "TabLineFill",
    }
    for _, group in ipairs(groups) do
      vim.cmd("hi " .. group .. " guibg=NONE ctermbg=NONE")
    end
  end,
})
