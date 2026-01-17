-- 文件路径: ~/.config/nvim/lua/plugins/leetcode.lua
return {
  "kawre/leetcode.nvim",

  -- 1. 依赖项：LazyVim 默认已经装了 telescope 和 plenary
  -- 这里列出来是为了确保 leetcode 加载时它们已经就绪
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },

  -- 2. 只有当你输入 :Leet 命令时才加载插件，加快启动速度
  cmd = "Leet",

  -- 3. 构建步骤：确保安装 html 解析器 (用于解析题目描述)
  build = ":TSUpdate html",

  -- 4. 具体的配置选项 (opts)
  opts = {
    lang = "python3", -- 默认语言设为 Python3

    cn = { -- leetcode.cn
      enabled = true, ---@type boolean
      translator = true, ---@type boolean
      translate_problems = true, ---@type boolean
    },

    -- --- 文件存储位置 ---
    storage = {
      home = vim.fn.expand("~/mysrc/oj/leetcode"),
      cache = vim.fn.stdpath("cache") .. "/leetcode",
    },

    logging = true, -- 开启日志，出错了方便排查

    injector = {
      ["python3"] = {
        after = { "def test():", "    print('test')" },
      },
    },

    -- --- 这里的配置是防止因为插件改变了目录导致 LazyVim 的某些功能异常 ---
    arg = "leetcode.nvim",
  },
}
