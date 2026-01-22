return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        -- 修改所有使用 sidebar 布局的窗口（包括 Explorer）
        layouts = {
          sidebar = {
            layout = {
              width = 25, -- 在这里设置你想要的宽度（比如 40）
            },
          },
        },
      },
    },
  },
}
