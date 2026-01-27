-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- 定义一个模块级变量，用来记录上一次的运行终端
local runner_term = nil

vim.keymap.set("i", "jk", "<Esc>", { desc = "Escape insert mode" })

-- 智能运行代码 (Python / Rust / C++)
vim.keymap.set("n", "<leader>r", function()
  local ft = vim.bo.filetype
  local file = vim.fn.expand("%")
  local cmd = ""

  -- ===========================
  -- 1. 语言命令配置区
  -- ===========================
  if ft == "python" then
    cmd = "python3 " .. file
  elseif ft == "rust" then
    -- 获取当前文件的绝对路径
    local full_path = vim.fn.expand("%:p")
    -- 使用 Lua 模式匹配检查路径中是否包含 src/bin (同时兼容 / 和 \ 分隔符)
    if full_path:match("src[/\\]bin") then
      -- 如果在 bin 目录下，提取文件名（不含后缀），运行指定 bin
      local file_root = vim.fn.expand("%:t:r")
      cmd = "cargo run --bin " .. file_root
    else
      -- 默认情况（如 src/main.rs），直接运行默认 target
      cmd = "cargo run"
    end
  elseif ft == "cpp" then
    -- C++ 编译逻辑
    local file_dir = vim.fn.expand("%:p:h")
    local file_root = vim.fn.expand("%:t:r")
    local bin_path = file_dir .. "/out/" .. file_root

    -- === 关键修改在这里 ===
    -- 1. -DLOCAL: 配合模板启用 debug(...) 输出
    -- 2. -D_GLIBCXX_DEBUG: 开启标准库调试模式 (抓 vector 越界的神器)
    -- 3. -D_GLIBCXX_DEBUG_PEDANTIC: 更严格的检查
    -- 4. -fsanitize=address,undefined: 谷歌的大杀器，检测内存错误和未定义行为
    -- 5. -g: 生成调试符号，报错时能显示行号
    -- 6. -Wall -Wextra: 开启常用警告
    -- local debug_flags = "-g -Wall -Wextra -DLOCAL -D_GLIBCXX_DEBUG -fsanitize=address,undefined"
    local debug_flags = "-g -Wall -Wextra -DLOCAL -D_GLIBCXX_DEBUG"

    -- 如果你是在 Windows (MinGW) 下，-fsanitize 可能无法使用，请去掉它，只保留 -D_GLIBCXX_DEBUG
    -- local debug_flags = "-g -Wall -Wextra -DLOCAL -D_GLIBCXX_DEBUG"

    -- 构造命令
    cmd = string.format(
      'mkdir -p "%s/out" && g++ -std=c++17 %s "%s" -o "%s" && "%s"',
      file_dir,
      debug_flags,
      file,
      bin_path,
      bin_path
    )
  else
    vim.notify("不支持的语言: " .. ft, vim.log.levels.WARN)
    return
  end

  -- ===========================
  -- 2. 核心修复逻辑：重置终端
  -- ===========================
  if _G.Snacks then
    -- 如果之前已经有一个运行窗口 (runner_term)，先把它彻底关掉！
    -- 这样可以防止看到上一次的旧结果，也可以强制刷新缓冲区
    if runner_term and runner_term.buf and vim.api.nvim_buf_is_valid(runner_term.buf) then
      runner_term:close()
    end

    -- 启动新的终端，并把引用保存在 runner_term 变量里
    runner_term = Snacks.terminal(cmd, {
      win = {
        position = "float", -- 浮动窗口
        close_on_exit = false, -- 跑完不自动关，让你看结果
        enter = true, -- 光标跳进去，方便你看日志或滚动
      },
      interactive = false, -- 非交互模式，告诉它这是个任务
      start_insert = true,
    })
  else
    -- 兼容旧版
    require("lazyvim.util").terminal(cmd)
  end
end, { desc = "Run Code (Reset)" })

-- 插入模式下的光标移动 (Alt + h/j/k/l)
vim.keymap.set("i", "<A-h>", "<Left>", { desc = "Move Left" })
vim.keymap.set("i", "<A-j>", "<Down>", { desc = "Move Down" })
vim.keymap.set("i", "<A-k>", "<Up>", { desc = "Move Up" })
vim.keymap.set("i", "<A-l>", "<Right>", { desc = "Move Right" })

-- 将 Ctrl+a 映射为全选 (ggVG)
vim.keymap.set("n", "<C-a>", "ggVG", { desc = "Select All" })

-- 插入模式下：Ctrl+a 全选 (先退到普通模式，再全选)
vim.keymap.set("i", "<C-a>", "<Esc>ggVG", { desc = "Select All" })

-- 当在命令行输入 %% 时，自动展开为当前文件所在的目录
vim.keymap.set("c", "%%", function()
  if vim.fn.getcmdtype() == ":" then
    return vim.fn.expand("%:h") .. "/"
  else
    return "%%"
  end
end, { expr = true })
