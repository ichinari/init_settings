require("lsp_signature").setup {
  hint_enable = true,
  hint_prefix = " ",
  -- フローティングウィンドウは出さず、インラインのヒントだけにする
  floating_window = false,
  floating_window_above_cur_line = false,
  toggle_key = "<M-s>",
}


