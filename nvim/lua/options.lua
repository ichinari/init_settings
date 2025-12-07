require "nvchad.options"

-- add yours here!

-- コマンドエイリアス
vim.api.nvim_create_user_command("Vt", function(opts)
  vim.cmd("vert term " .. opts.args)
  -- Terminal-Normalモードに切り替え
  vim.cmd("stopinsert")
end, { nargs = "*" })

-- ディレクトリ作成コマンド (:mkdir path/to/dir)
vim.api.nvim_create_user_command("Mkdir", function(opts)
  local path = opts.args
  if path == "" then
    vim.notify("Usage: :Mkdir <path>", vim.log.levels.WARN)
    return
  end
  local ok, err = pcall(vim.fn.mkdir, path, "p")
  if ok then
    vim.notify("Created: " .. path, vim.log.levels.INFO)
  else
    vim.notify("Failed to create: " .. path .. " (" .. err .. ")", vim.log.levels.ERROR)
  end
end, { nargs = 1, complete = "dir" })

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
