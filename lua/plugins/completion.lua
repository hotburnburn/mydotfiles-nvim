-- lua/plugins/completion.lua
return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        -- 设置为 'default' 或 'super-tab'，这里我们自定义覆盖
        preset = "default",

        -- 【核心修改】
        -- 1. 按 Tab 键：选中并接受 (Select and Accept)
        --    如果当前没有补全菜单，则回退到原始 Tab 功能 (缩进)
        ["<Tab>"] = { "select_and_accept", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },

        -- 2. 按 Enter 键：仅仅是换行 (Fallback)
        --    这样你就不会因为手快，想换行结果误触了补全
        ["<CR>"] = { "fallback" },
      },
    },
  },
}
