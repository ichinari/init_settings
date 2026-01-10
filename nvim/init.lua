vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

vim.g.netrw_hide = 0
vim.g.netrw_list_hide = ''


-- カスタムヘルプ用に runtimepath を追加
vim.opt.runtimepath:append(vim.fn.stdpath("config") .. "/pack/personal/start/my-custom-help")

-- 外部変更の自動取り込み設定（追加）
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  command = "checktime",
})
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  callback = function()
    vim.notify("File changed on disk. Buffer reloaded.", vim.log.levels.INFO)
  end,
})

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "autocmds"

vim.schedule(function()
  require "mappings"
end)

-- 検証：重要プラグインを起動時にロード（再起動でNot Loadedを減らす）
local loader = require("lazy.core.loader")

for _, name in ipairs({
  "nvim-telescope/telescope.nvim",
  "nvim-lua/plenary.nvim",
  "akinsho/toggleterm.nvim",
  "folke/trouble.nvim",
  "sindrets/diffview.nvim",
  "lewis6991/gitsigns.nvim",
  "APZelos/blamer.nvim",
  "rmagatti/auto-save.nvim",
  "kevinhwang91/nvim-hlslens",
  "nvim-tree/nvim-tree.lua",
  "nvim-tree/nvim-web-devicons",
  "neovim/nvim-lspconfig",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "ray-x/lsp_signature.nvim",
}) do
  local ok, spec = pcall(require, "lazy.core.config")
  if ok and spec.plugins then
    local p = spec.plugins[name]
    if p then loader.load(p, { cause = "startup" }) end
  end
end

-- 最低限のsetupを一度だけ走らせる（重複を避けるためpcall）
pcall(function()
  require("telescope").setup({})
  pcall(require("telescope").load_extension, "fzf")
  require("toggleterm").setup({ direction = "float" })
  require("trouble").setup({})
  require("gitsigns").setup({})
  vim.g.blamer_enabled = 1
  require("auto-save").setup({ enabled = true, trigger_events = { "InsertLeave", "TextChanged" } })
  require("hlslens").setup({})
  require("nvim-tree").setup({})
  require("mason").setup({})
  require("mason-lspconfig").setup({ automatic_installation = true })
  require("lsp_signature").setup({})
end)

-- 起動時に :Lazy を開くオートコマンドがあれば削除（保険）
pcall(function()
  local autocmds = vim.api.nvim_get_autocmds({ event = "VimEnter" })
  for _, aug in ipairs(autocmds) do
    local cmd = aug.command or ""
    local desc = aug.desc or ""
    local pat = aug.pattern or ""
    if cmd:match("Lazy") or desc:match("Lazy") or pat:match("Lazy") then
      pcall(vim.api.nvim_del_autocmd, aug.id)
    end
  end
end)

-- 引数なしで起動した場合、alpha-nvimのダッシュボードを表示
if vim.fn.argc() == 0 then
  vim.schedule(function()
    vim.defer_fn(function()
      -- Lazyウィンドウが開いていたら閉じる
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local ft = vim.bo[buf].filetype
        if ft == "lazy" then
          pcall(vim.api.nvim_win_close, win, true)
        end
      end
      -- alpha-nvimを開く
      pcall(function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")
        alpha.setup(dashboard.config)
      end)
      pcall(vim.cmd, "Alpha")
      -- Alphaバッファが閉じられないよう再度開く
      vim.defer_fn(function()
        local ft = vim.bo.filetype
        if ft ~= "alpha" then
          pcall(vim.cmd, "Alpha")
        end
      end, 100)
    end, 300)
  end)
end