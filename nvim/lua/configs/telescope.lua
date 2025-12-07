local telescope = require("telescope")
telescope.setup {
  defaults = {
    mappings = {
      i = { ["<C-j>"] = "move_selection_next", ["<C-k>"] = "move_selection_previous" },
    },
    layout_config = { width = 0.9, height = 0.9 },
  },
}
pcall(telescope.load_extension, "fzf")

