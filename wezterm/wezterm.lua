local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Kanagawa カラースキーム（公式リポジトリからダウンロード）
local kanagawa_wave = dofile(os.getenv('HOME') .. '/.config/wezterm/colors/kanagawa-wave.lua')
local kanagawa_dragon = dofile(os.getenv('HOME') .. '/.config/wezterm/colors/kanagawa-dragon.lua')

config.color_schemes = {
  ['Kanagawa Wave'] = kanagawa_wave.colors,
  ['Kanagawa Dragon'] = kanagawa_dragon.colors,
}

config.color_scheme = 'Kanagawa Wave'

-- フォント設定（Nerd Font推奨）
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 12.0
config.use_ime = true

-- ウィンドウ設定
config.window_background_opacity = 1.0
config.window_decorations = "RESIZE"
config.window_padding = {
  left = 10,
  right = 10,
  top = 10,
  bottom = 10,
}

-- タブバー設定
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true -- タブ一つのときは非表示
-- タブバー非表示
config.window_frame = {
   inactive_titlebar_bg = "none",
   active_titlebar_bg = "none",
 }

-- タブの＋ボタン非表示
config.show_new_tab_button_in_tab_bar = false
-- アクティブタブに色を付ける
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local background = "#5c6d74"
  local foreground = "#FFFFFF"
  local edge_background = "none"

  if tab.is_active then
    background = "#ae8b2d"
    foreground = "#FFFFFF"
  end
  local edge_foreground = background

  local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "

  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_LEFT_ARROW },

    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },

    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)
-- タブの形を変更
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

-- ステータス更新間隔（ミリ秒）
config.status_update_interval = 1000

-- macOS: 透過を有効にするために必要
config.macos_window_background_blur = 0

-- ===========================================
-- Gitブランチ取得のヘルパー
-- ===========================================
local function get_git_branch(cwd)
  if not cwd then return nil end
  local path = cwd:gsub("^file://[^/]*", "")
  local success, stdout, stderr = wezterm.run_child_process({
    "git", "-C", path, "rev-parse", "--abbrev-ref", "HEAD",
  })
  if success and stdout and #stdout > 0 then
    local branch = stdout:gsub("%s+$", "")
    if branch ~= "" and branch ~= "HEAD" then
      return branch
    end
  end
  return nil
end

-- カラーとアイコン（Nerd Font）
local palette = {
  fg = "#DCD7BA",      -- Kanagawa fujiWhite
  dim = "#727169",     -- Kanagawa fujiGray
  accent = "#7E9CD8",  -- Kanagawa crystalBlue
  green = "#98BB6C",   -- Kanagawa springGreen
}

local icons = {
  git = "",     -- nf-dev-git_branch
  folder = "",  -- nf-fa-folder
  clock = "",   -- nf-fa-clock_o
}

-- ===========================================
-- タブタイトルのカスタマイズ
-- ===========================================
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local pane = tab.active_pane
  local cwd = pane and pane.current_working_dir and tostring(pane.current_working_dir) or ""
  local branch = get_git_branch(cwd)

  -- cwdのベース名のみ
  local cwd_path = cwd:gsub("^file://[^/]*", "")
  local base = cwd_path:match("([^/]+)/*$") or cwd_path

  local time = wezterm.strftime("%H:%M:%S")

  local parts = {}
  -- Git branch
  table.insert(parts, {Foreground={Color=palette.accent}})
  table.insert(parts, {Text=" " .. icons.git .. " "})
  table.insert(parts, {Foreground={Color=palette.fg}})
  table.insert(parts, {Text=(branch and branch or "no-git") .. "  "})

  -- Folder
  table.insert(parts, {Foreground={Color=palette.green}})
  table.insert(parts, {Text=icons.folder .. " "})
  table.insert(parts, {Foreground={Color=palette.fg}})
  table.insert(parts, {Text=base .. "  "})

  -- Time
  table.insert(parts, {Foreground={Color=palette.dim}})
  table.insert(parts, {Text=icons.clock .. " "})
  table.insert(parts, {Text=time .. " "})

  return parts
end)

-- ===========================================
-- 右ステータス（定期更新）
-- ===========================================
wezterm.on("update-right-status", function(window, pane)
  local cwd = pane and pane.current_working_dir and tostring(pane.current_working_dir) or ""
  local cwd_path = cwd:gsub("^file://[^/]*", "")
  local base = cwd_path:match("([^/]+)/*$") or cwd_path
  local branch = get_git_branch(cwd)
  local time = wezterm.strftime("%Y-%m-%d %H:%M:%S")

  local text = string.format(
    " %s %s  %s %s  %s %s ",
    icons.git, branch or "no-git",
    icons.folder, base,
    icons.clock, time
  )

  window:set_right_status(wezterm.format({
    {Foreground={Color=palette.dim}},
    {Text=text},
  }))
end)

-- ===========================================
-- キーバインド設定
-- ===========================================
config.keys = {
  -- Cmd+Shift+F で透過度を切り替え（1.0 ↔ 0.85）
  {
    key = 'f',
    mods = 'CMD|SHIFT',
    action = wezterm.action_callback(function(window, pane)
      local overrides = window:get_config_overrides() or {}
      local current = overrides.window_background_opacity or 1.0

      if current < 1.0 then
        overrides.window_background_opacity = 1.0
      else
        overrides.window_background_opacity = 0.85
      end

      window:set_config_overrides(overrides)
    end),
  },

  -- Cmd+Shift+3 で3ペインレイアウト作成
  {
    key = '3',
    mods = 'CMD|SHIFT',
    action = wezterm.action_callback(function(window, pane)
      local cwd = pane:get_current_working_dir()
      local cwd_path = cwd and cwd.file_path or os.getenv('HOME')

      local right_pane = pane:split({
        direction = 'Right',
        size = 0.5,
        cwd = cwd_path,
      })

      local bottom_right_pane = right_pane:split({
        direction = 'Bottom',
        size = 0.5,
        cwd = cwd_path,
      })

      right_pane:send_text('claude\n')
    end),
  },
}

return config
