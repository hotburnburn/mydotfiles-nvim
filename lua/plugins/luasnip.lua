return {
  "L3MON4D3/LuaSnip",
  config = function(_, opts)
    -- 初始化 LuaSnip 的默认配置
    require("luasnip").setup(opts)

    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node
    local fmt = require("luasnip.extras.fmt").fmt
    local rep = require("luasnip.extras").rep

    ls.add_snippets("cpp", {
      -- 1. 读入一个整数 (ii -> int n; cin >> n;)
      s("ii", fmt("int {}; cin >> {};", { i(1, "n"), rep(1) })),

      -- 2. 读入两个整数 (iii -> int n, m; cin >> n >> m;)
      s("iii", fmt("int {}, {}; cin >> {} >> {};", { i(1, "n"), i(2, "m"), rep(1), rep(2) })),

      -- 3. 读入三个整数 (iiii -> int a, b, c; cin >> a >> b >> c;)
      s(
        "iiii",
        fmt("int {}, {}, {}; cin >> {} >> {} >> {};", { i(1, "a"), i(2, "b"), i(3, "c"), rep(1), rep(2), rep(3) })
      ),

      -- 4. 读入字符串 (ss -> string s; cin >> s;)
      s("ss", fmt("string {}; cin >> {};", { i(1, "s"), rep(1) })),

      -- 5. 读入 Vector (vin -> vector<int> a(n); for(...) cin >> x;)
      -- C++17 风格，使用引用读入，不依赖宏
      s(
        "vin",
        fmt(
          [[
    vector<{}> {}({});
    for (auto& x : {}) cin >> x;
    ]],
          { i(1, "int"), i(2, "a"), i(3, "n"), rep(2) }
        )
      ),

      -- 6. 读入 Grid/矩阵 (grid -> vector<vector<int>> g...)
      s(
        "grid",
        fmt(
          [[
    vector<vector<{}>> {}({}, vector<{}>({}));
    for (int i = 0; i < {}; ++i) {{
        for (int j = 0; j < {}; ++j) {{
            cin >> {}[i][j];
        }}
    }}
    ]],
          {
            i(1, "int"),
            i(2, "g"),
            i(3, "n"),
            rep(1),
            i(4, "m"), -- 定义
            rep(3),
            rep(4), -- 循环边界
            rep(2), -- cin
          }
        )
      ),

      -- 7. 快速 IO (fio)
      s("fio", {
        t("ios::sync_with_stdio(false);"),
        t({ "", "cin.tie(nullptr);" }),
      }),

      -- 8. 多组数据循环 (case)
      s(
        "case",
        fmt(
          [[
    int {};
    cin >> {};
    while ({}--) {{
        {}
    }}
    ]],
          { i(1, "t"), rep(1), rep(1), i(0) }
        )
      ),

      s(
        "oj",
        fmt(
          [[
#include <bits/stdc++.h>
using namespace std;
using ll = long long;
using ull = unsigned long long;
using ld = long double;
using pii = pair<int, int>;
using pll = pair<ll, ll>;
using vi = vector<int>;
using vll = vector<ll>;
#define len(x) (int)(x).size()
#define rep(i, a, b) for(int i = (a); i < (b); ++i)
#define per(i, a, b) for(int i = (b) - 1; i >= (a); --i)

void solve() {
  [1]
}

int main() {
  ios::sync_with_stdio(false);
  cin.tie(nullptr);
  int t = 1;
  // cin >> t;
  while (t--) {
    solve();
  }
  return 0;
}
]],
          {
            -- [1] 对应这里的第一个节点 i(0)
            i(0),
          },
          { delimiters = "[]" }
        )
      ), -- 使用 [] 作为分隔符
    })

    -- 定义 Python 的代码片段
    ls.add_snippets("python", {

      -- 1. 输入 ii -> int(input())
      s("ii", {
        t("int(input())"),
      }),

      -- 2. 输入 mii -> map(int, input().split())
      s("mii", {
        t("map(int, input().split())"),
      }),

      -- 3. 输入 lmii -> list(map(int, input().split()))
      s("lmii", {
        t("list(map(int, input().split()))"),
      }),

      s("oj", {
        t({ "import sys", "", "" }),
        t({ "input = sys.stdin.readline", "", "" }),
        t({ "def solve():", "\t" }),
        i(0), -- 光标停留在这里写逻辑
        t({ "", "", "if __name__ == '__main__':", "\tsolve()" }),
      }),

      s("ojt", {
        t({ "import sys", "", "" }),
        t({ "input = sys.stdin.readline", "", "" }),
        t({ "def solve():", "\t" }),
        i(0), -- 光标停留在这里写逻辑
        t({ "", "", "if __name__ == '__main__':", "\tfor _ in range(int(input())):", "\t\tsolve()" }),
      }),
    })
  end,
}
