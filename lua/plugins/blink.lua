return {
  {
    "saghen/blink.cmp",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
    opts = {
      -- 关键配置：告诉 blink 使用 luasnip
      snippets = {
        preset = "luasnip",
      },

      -- 确保 sources 里包含了 snippets
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
  },
}
