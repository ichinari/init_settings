-- filename: /Users/ky/.config/nvim/lua/custom/claude_cli.lua
local M = {}

-- Claude CLI が存在するかチェック
local function has_claude()
  return vim.fn.executable("claude") == 1
end

-- 選択範囲 or バッファ全体を取得
local function get_selection_or_buffer()
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" then
    local _, ls, cs = unpack(vim.fn.getpos("'<"))
    local _, le, ce = unpack(vim.fn.getpos("'>"))
    local lines = vim.fn.getline(ls, le)
    if #lines == 0 then return "" end
    lines[#lines] = string.sub(lines[#lines], 1, ce)
    lines[1] = string.sub(lines[1], cs)
    return table.concat(lines, "\n")
  else
    return table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
  end
end

-- 返答を表示するウィンドウ
local function open_output_window(title, text)
  vim.cmd("vnew")
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(text or "", "\n"))
  vim.api.nvim_buf_set_name(buf, title or "Claude Output")
end

-- Claude CLI でプロンプトを実行（引数なしで標準入力を渡す）
local function claude_run(prompt, input_text, extra_args)
  if not has_claude() then
    return nil, "claude CLI が見つかりません。PATHに追加してください。"
  end

  local cmd = { "claude" }
  if type(extra_args) == "table" then
    for _, a in ipairs(extra_args) do table.insert(cmd, a) end
  end

  local message = (prompt and prompt ~= "" and (prompt .. "\n\nCode:\n") or "") .. (input_text or "")

  local result = vim.fn.system(cmd, message)
  if vim.v.shell_error ~= 0 then
    return nil, "claude 実行エラー: " .. (result or "")
  end
  return result
end

-- ユーザーコマンド: :ClaudeCLI {prompt}
function M.cmd(args)
  local prompt = args or "Improve this code."
  local text = get_selection_or_buffer()
  if text == "" then
    vim.notify("送信テキストが空です。選択範囲またはバッファにコードを用意してください。", vim.log.levels.WARN)
    return
  end
  local out, err = claude_run(prompt, text, {})
  if err then
    vim.notify(err, vim.log.levels.ERROR)
    return
  end
  open_output_window("Claude (CLI)", out or "")
end

-- 選択の説明
function M.explain()
  local text = get_selection_or_buffer()
  if text == "" then
    vim.notify("送信テキストが空です。", vim.log.levels.WARN)
    return
  end
  local prompt = "Explain what this code does, complexity, edge cases, and potential improvements.\n\n"
  local out, err = claude_run(prompt, text, {})
  if err then
    vim.notify(err, vim.log.levels.ERROR)
    return
  end
  open_output_window("Claude Explain (CLI)", out or "")
end

-- テスト生成
function M.tests()
  local text = get_selection_or_buffer()
  if text == "" then
    vim.notify("送信テキストが空です。", vim.log.levels.WARN)
    return
  end
  local ft = vim.bo.filetype
  local prompt = ("Generate unit tests for the following %s code. Return only test code in fenced code blocks.\n\n"):format(ft)
  local out, err = claude_run(prompt, text, {})
  if err then
    vim.notify(err, vim.log.levels.ERROR)
    return
  end
  open_output_window("Claude Tests (CLI)", out or "")
end

-- 置換適用（返答からコードブロックのみ抽出して現在バッファに貼り替える簡易版）
function M.apply()
  local text = get_selection_or_buffer()
  if text == "" then
    vim.notify("送信テキストが空です。", vim.log.levels.WARN)
    return
  end
  local prompt = "Rewrite the following code with best practices. Return only the rewritten code in a single fenced code block."
  local out, err = claude_run(prompt, text, {})
  if err then
    vim.notify(err, vim.log.levels.ERROR)
    return
  end

  local lines = vim.split(out or "", "\n")
  local in_block = false
  local code = {}
  for _, l in ipairs(lines) do
    if not in_block and l:match("^```") then
      in_block = true
    elseif in_block and l:match("^```") then
      break
    elseif in_block then
      table.insert(code, l)
    end
  end
  local new_text = table.concat(code, "\n")
  if new_text == "" then
    vim.notify("コードブロックが見つかりませんでした。出力を確認してください。", vim.log.levels.WARN)
    open_output_window("Claude (CLI) Output", out or "")
    return
  end

  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" then
    local _, ls, cs = unpack(vim.fn.getpos("'<"))
    local _, le, ce = unpack(vim.fn.getpos("'>"))
    vim.api.nvim_buf_set_text(0, ls - 1, cs - 1, le - 1, ce, vim.split(new_text, "\n"))
  else
    local ok = vim.fn.confirm("バッファ全体を提案コードで置換しますか？", "&Yes\n&No", 2)
    if ok == 1 then
      vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(new_text, "\n"))
    else
      open_output_window("Claude (CLI) Output (Preview)", out or "")
      return
    end
  end
  vim.notify("Claudeの変更を適用しました", vim.log.levels.INFO)
end

-- コマンド登録
vim.api.nvim_create_user_command("ClaudeCLI", function(opts) M.cmd(opts.args) end, { nargs = "?" })
vim.api.nvim_create_user_command("ClaudeExplain", function() M.explain() end, {})
vim.api.nvim_create_user_command("ClaudeTests", function() M.tests() end, {})
vim.api.nvim_create_user_command("ClaudeApply", function() M.apply() end, {})

return M




