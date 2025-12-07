-- 保険: setup後に明示的に有効化（読み込み順の影響を回避）
vim.schedule(function()
  local ok2, mod = pcall(require, "auto-save")
  if ok2 and mod and mod.enable then
    mod.enable()
  end
end)

-- 書き込み後の軽い通知（任意）
vim.api.nvim_create_autocmd("User", {
  pattern = "AutoSaveWritePost",
  callback = function(args)
    local name = vim.api.nvim_buf_get_name(args.buf)
    if name == "" then name = "[No Name]" end
    vim.schedule(function()
      vim.api.nvim_echo({ { "Auto-saved: " .. name, "Comment" } }, false, {})
    end)
  end,
})

-- 状態確認・手動ロード・トグル（必要に応じて利用）
vim.api.nvim_create_user_command("AutoSaveStatus", function()
  local ok3, mod = pcall(require, "auto-save")
  if not ok3 then
    print("auto-save not loaded")
    return
  end
  local state = mod.is_enabled and mod.is_enabled() or false
  print("auto-save enabled:", state)
end, {})

vim.api.nvim_create_user_command("AutoSaveDebugLoad", function()
  pcall(function()
    require("lazy").load({ plugins = { "okuuva/auto-save.nvim", "auto-save.nvim" } })
  end)
  local ok = pcall(require, "auto-save")
  print("auto-save loaded:", ok)
end, {})

vim.api.nvim_create_user_command("AutoSaveToggle", function()
  local ok, mod = pcall(require, "auto-save")
  if not ok then
    print("auto-save not loaded")
    return
  end
  if mod.is_enabled and mod.is_enabled() then
    mod.disable()
    print("auto-save disabled")
  else
    mod.enable()
    print("auto-save enabled")
  end
end, {})

-- ==== 自前トグル/ステータス管理（プラグインAPIに依存しない） ====

-- 有効/無効の状態を自前で保持（起動時ON）
vim.g.autosave_enabled = true

-- 現在の設定の保存条件を満たすかを関数化（必要ならあなたのconditionに合わせて調整）
local function autosave_should_write(buf)
  local fn = vim.fn
  if fn.getbufvar(buf, "&modifiable") == 0 then return false end
  local name = fn.bufname(buf)
  if name == "" then return false end
  local ft = fn.getbufvar(buf, "&filetype")
  if ft == "DiffviewFiles" then return false end
  return true
end

-- 実際の自動保存処理（enabled と条件を満たす場合のみ保存）
local function autosave_maybe_write(buf)
  if not vim.g.autosave_enabled then return end
  if not autosave_should_write(buf) then return end
  -- 書き込み（変更があるときのみ）
  if vim.bo[buf].modified then
    -- conform.nvim でフォーマットを実行（Prettierなど）
    local conform_ok, conform = pcall(require, "conform")
    if conform_ok then
      conform.format({
        bufnr = buf,
        timeout_ms = 1000,
        lsp_fallback = true,
      })
    end
    -- silent write
    vim.api.nvim_buf_call(buf, function()
      vim.cmd("silent write")
    end)
    -- 通知（任意）
    local name = vim.api.nvim_buf_get_name(buf)
    if name == "" then name = "[No Name]" end
    vim.schedule(function()
      vim.api.nvim_echo({ { "Auto-saved: " .. name, "Comment" } }, false, {})
    end)
  end
end

-- 既存の auto-save.nvim のトリガに合わせて autocmd を張る
-- InsertLeave と TextChanged で自前保存を行う
local autosave_group = vim.api.nvim_create_augroup("DiaAutoSaveFallback", { clear = true })

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  group = autosave_group,
  callback = function(args)
    autosave_maybe_write(args.buf)
  end,
})

-- コマンド群（トグル、ステータス、手動保存）
vim.api.nvim_create_user_command("AutoSaveToggle", function()
  vim.g.autosave_enabled = not vim.g.autosave_enabled
  print("auto-save enabled:", vim.g.autosave_enabled)
end, {})

vim.api.nvim_create_user_command("AutoSaveStatus", function()
  print("auto-save enabled:", vim.g.autosave_enabled == true)
end, {})

vim.api.nvim_create_user_command("AutoSaveNow", function()
  autosave_maybe_write(vim.api.nvim_get_current_buf())
end, {})
