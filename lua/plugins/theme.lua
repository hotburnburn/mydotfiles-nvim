return {
  {
    "folke/tokyonight.nvim",
    opts = {
      -- 1. 这是子欣原来的配置，保持不变
      style = "night",

      -- 2. 这是我们要新加的颜色配置
      on_highlights = function(hl, c)
        hl.Folded = {
          bg = "#22202C", -- 子欣指定的那个深色背景
          italic = true, -- 斜体更有感觉
        }
      end,
    },
  },

  -- vim.cmd.colorscheme("catppuccin-mocha"),
}
