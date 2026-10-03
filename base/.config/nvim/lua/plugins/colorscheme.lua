return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      -- match ghostty: dark:Catppuccin Mocha,light:Catppuccin Latte
      background = { dark = "mocha", light = "latte" },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
