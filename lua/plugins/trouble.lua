return {
  "folke/trouble.nvim",
  opts = {
    modes = {
      diagnostics = {
        win = {
          position = "right", -- 移动到右边
          wrap = true,
          width = 40, -- 侧边栏通常需要指定宽度
        },
        multiline = true,
        focus = true, -- 自动移入光标
      },
    },
  },
}
