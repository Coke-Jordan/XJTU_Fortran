# Fortran / C 上机作业代码集

本仓库保存 Fortran / C 上机作业的源代码、可执行文件和部分运行结果。代码按作业次数分为四个目录，主要覆盖表达式计算、分支循环、数组、模块、数值方法、格式化输入输出、文件读写、C 语言基础语法、指针和 C/Fortran 函数编写等内容。

## 环境要求

- Windows + PowerShell
- GNU Fortran（`gfortran`）
- GNU C Compiler（`gcc`，第四次作业需要）
- 可选：Visual Studio Code
- 可选调试：`gdb`

当前 VS Code 配置默认使用：

```powershell
gfortran -std=f2018 -Wall -Wextra -g
```

第四次作业中的 C 程序可使用：

```powershell
gcc -Wall -Wextra -g
```

## 目录结构

```text
.
├── .vscode/              # VS Code 构建、运行、调试配置
├── 第一次上机作业/       # Q1-Q6：基础表达式、输入输出、排序、迭代
├── 第二次上机作业/       # Q1-Q6：素数、哥德巴赫猜想、Euler 法、数组与排序模块
├── 第三次上机作业/       # Q1-Q7：数值积分、线性方程组、集合类型、RK4、高斯消元
└── 第四次上机作业/       # 01-06：C 语言基础、数组、指针、函数、杨辉三角
```

仓库中可能包含若干 `.exe`、`.o`、`.mod` 文件，它们是编译产物；真正需要维护的是 `.f90` 和 `.c` 源文件。

## 作业内容概览

### 第一次上机作业

| 文件 | 内容 |
| --- | --- |
| `Q1.f90` | 验证 Fortran 表达式、类型转换和内置函数计算结果 |
| `Q2.f90` | 计算包含幂、平方根、对数、三角函数的表达式 |
| `Q3.f90` | 修正并计算 `sqrt(real(i+j)/k)` |
| `Q4.f90` | 根据年增长率计算若干年后人口 |
| `Q5.f90` | 输入 4 个实数并按降序排列 |
| `Q6.f90` | 使用迭代法求非负实数的平方根近似值 |

### 第二次上机作业

| 文件 | 内容 |
| --- | --- |
| `Q1.f90` | 牛顿法求方程 `7x^4 + 6x^3 - 5x^2 + 4x + 3 = 0` 的实根 |
| `Q2.f90` | 判断大于 2 的正整数是否为素数 |
| `Q3.f90` | 验证 1000 以内偶数的哥德巴赫猜想，并生成 `Q3_report.txt` |
| `Q4.f90` | 调用 `euler_solver.f90`，用 Euler 法求解 `y' = x + 2y` |
| `Q5.f90` | 输出由数组循环右移形成的方阵 |
| `Q6.f90` | 调用 `sort_module.f90`，使用冒泡排序对整数序列升序排列 |
| `prime_utils.f90` | 素数判断和素数表工具模块 |
| `euler_solver.f90` | Euler 法求解器模块 |
| `sort_module.f90` | 冒泡排序模块 |

### 第三次上机作业

| 文件 | 内容 |
| --- | --- |
| `Q1.f90` | 梯形法计算 `f(x)=x^2` 在 `[-1,1]` 上的定积分 |
| `Q2.f90` | Jacobi 迭代法求解线性方程组，并与 Gauss-Seidel 迭代比较 |
| `Q3.f90` | 使用派生类型实现整数集合，并重载并、差、交运算符 |
| `Q4.f90` | 使用指针相关操作输出两种数字图形 |
| `Q5.f90` | 整数、实数、复数、逻辑量和字符串的格式化输入输出实验 |
| `Q6_generate.f90` | 调用 `rk4_module.f90`，用四阶 Runge-Kutta 方法生成 `data1.txt` |
| `Q6_analyze.f90` | 读取 `data1.txt`，统计函数值最大点和最小点 |
| `Q7.f90` | 选做题：部分选主元高斯消元法求解线性方程组 |
| `rk4_module.f90` | 四阶 Runge-Kutta 求解器模块 |

### 第四次上机作业

| 文件 | 内容 |
| --- | --- |
| `01_tax.c` | 根据货物价格区间计算税率和应缴税金 |
| `02_insert_sorted.c` | 将一组数据排序，并把新输入的数按大小插入数组 |
| `03_squeeze.c` | 使用指针删除 `s1` 中所有与 `s2` 任意字符相同的字符 |
| `04_digits.c` | 判断不多于 5 位正整数的位数，顺序和逆序输出各位数字 |
| `05_hexagon_area.c` | 使用海伦公式计算六边形拆分后的四个三角形面积和总面积 |
| `06_yang_c.c` | C 语言函数 `yang(int n)` 打印杨辉三角 |
| `06_yang_fortran.f90` | Fortran 子程序 `YANG(n)` 打印杨辉三角 |

## 使用 VS Code 编译和运行

1. 用 VS Code 打开仓库根目录。
2. 打开需要运行的 `.f90` 文件，例如 `第二次上机作业/Q4.f90`。
3. 执行 `Terminal: Run Task`，选择 `Build Active Fortran` 编译当前文件。
4. 执行 `Terminal: Run Task`，选择 `Run Active Fortran` 编译并运行当前文件。
5. 如需调试，安装 `gdb` 后按 `F5`，使用 `Debug Fortran & build` 配置。

`.vscode/build-fortran.ps1` 会在当前源文件所在目录中查找需要的模块文件，先编译模块，再链接主程序。例如运行 `Q4.f90` 时会自动编译 `euler_solver.f90`。

第四次作业中的 C 文件可以在 VS Code 终端中使用 `gcc` 手动编译运行。

## 使用命令行编译和运行

在仓库根目录打开 PowerShell。

编译单个 Fortran 源文件：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\.vscode\build-fortran.ps1 ".\第一次上机作业\Q5.f90"
```

编译并运行单个 Fortran 源文件：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\.vscode\run-fortran.ps1 ".\第二次上机作业\Q4.f90"
```

也可以手动进入对应目录编译：

```powershell
Set-Location ".\第二次上机作业"
gfortran -std=f2018 -Wall -Wextra -g Q2.f90 -o Q2.exe
.\Q2.exe
```

带模块依赖的程序需要先编译模块：

```powershell
Set-Location ".\第二次上机作业"
gfortran -std=f2018 -Wall -Wextra -g -c euler_solver.f90
gfortran -std=f2018 -Wall -Wextra -g euler_solver.o Q4.f90 -o Q4.exe
.\Q4.exe
```

第三次作业的 `Q6_analyze.f90` 依赖 `Q6_generate.f90` 生成的 `data1.txt`。请先运行：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\.vscode\run-fortran.ps1 ".\第三次上机作业\Q6_generate.f90"
powershell -NoProfile -ExecutionPolicy Bypass -File .\.vscode\run-fortran.ps1 ".\第三次上机作业\Q6_analyze.f90"
```

第四次作业的 C 程序可以这样编译运行：

```powershell
Set-Location ".\第四次上机作业"
gcc -Wall -Wextra -g 01_tax.c -o 01_tax.exe
.\01_tax.exe
```

第四次作业的 Fortran 杨辉三角程序可以这样编译运行：

```powershell
Set-Location ".\第四次上机作业"
gfortran -std=f2018 -Wall -Wextra -g 06_yang_fortran.f90 -o 06_yang_fortran.exe
.\06_yang_fortran.exe
```

## 生成文件说明

- `.exe`：Windows 可执行文件。
- `.o`：目标文件。
- `.mod`：Fortran 模块接口文件。
- `第二次上机作业/Q3_report.txt`：哥德巴赫猜想验证报告。
- `第三次上机作业/data1.txt`：Runge-Kutta 方法生成的数据文件。
- `第三次上机作业/pdf_pages/`：作业 PDF 页面截图或辅助图片。

如需重新构建，可以删除旧的 `.exe`、`.o`、`.mod` 后重新运行构建脚本或手动编译命令。

## 编码注意事项

项目中的中文提示建议使用 UTF-8 环境查看和运行。VS Code 配置已设置 `"files.encoding": "utf8"`，PowerShell 脚本也会切换控制台到 UTF-8。若终端仍出现中文乱码，可先执行：

```powershell
chcp 65001
```

然后重新运行程序。
