local M = {}

M.base46 = {
  theme = "kanagawa",
  transparency = true,

  hl_override = {
    Normal = { bg = "NONE" },
    NormalFloat = { bg = "NONE" },
    NvDashAscii = { bg = "NONE" },
    NvDashButtons = { bg = "NONE" },
    NvimTreeNormal = { bg = "NONE" },
    NvimTreeNormalNC = { bg = "NONE" },
    NvimTreeWinSeparator = { bg = "NONE" },
    TelescopeNormal = { bg = "NONE" },
    TelescopeBorder = { bg = "NONE" },
  },
}

M.ui = {
  statusline = { theme = "vscode_colored", separator_style = "round" },
}

M.plugins = "custom.plugins"
M.mappings = require("custom.mappings")

return M
