# RV32I_Pipeline_CPU

## 项目目录结构
RV32I_Pipeline_CPU/
├── docs/ # 文档目录
│ ├── architecture.md # CPU 架构设计说明（流水线、模块划分等）
│ ├── instruction_set.md # 支持的 RV32I 指令集列表
│ └── rtthread_plan.md # 未来适配 RT-Thread 的规划
├── rtl/ # 核心 RTL（Register Transfer Level）代码
│ ├── top/ # 顶层模块
│ │ └── cpu_top.v # CPU 顶层模块，连接所有流水线阶段
│ ├── fetch/ # 取指阶段
│ │ ├── if_stage.v # 取指逻辑（PC、指令存储器接口）
│ │ └── imem.v # 指令存储器（ROM 或 RAM）
│ ├── decode/ # 译码阶段
│ │ ├── id_stage.v # 译码逻辑（指令解析、寄存器读取）
│ │ └── regfile.v # 寄存器文件（32 个 32 位寄存器）
│ ├── execute/ # 执行阶段
│ │ ├── ex_stage.v # 执行逻辑（ALU、分支跳转）
│ │ └── alu.v # ALU 模块
│ ├── memory/ # 数据存储器相关（可选，未来扩展）
│ │ └── dmem.v # 数据存储器（RAM）
│ ├── pipeline/ # 流水线寄存器
│ │ ├── if_id_reg.v # IF/ID 流水线寄存器
│ │ └── id_ex_reg.v # ID/EX 流水线寄存器
│ └── common/ # 通用模块
│ ├── defines.v # 参数和宏定义（如指令操作码）
│ └── control.v # 控制单元（生成控制信号）
├── sim/ # 仿真文件
│ ├── tb_cpu_top.v # 顶层测试bench
│ ├── testcases/ # 测试用例
│ │ ├── add_test.mem # 简单的加法测试程序（机器码）
│ │ └── loop_test.mem # 循环测试程序
│ └── wave/ # 仿真波形文件（可选）
├── scripts/ # 脚本目录
│ ├── compile.sh # 编译脚本（iverilog 或 Vivado）
│ ├── sim.sh # 仿真脚本
│ └── synth.tcl # 综合脚本（Vivado TCL）
├── fpga/ # FPGA 相关文件
│ ├── constraints/ # 约束文件
│ │ └── top.xdc # 时钟、引脚约束
│ └── bitstream/ # 生成的比特流文件（编译后）
├── software/ # 软件相关（为 RT-Thread 准备）
│ ├── asm/ # 汇编代码
│ │ └── boot.s # 启动代码（初始化栈、跳转到 main）
│ ├── c/ # C 代码
│ │ └── main.c # 测试用的 C 程序
│ └── linker/ # 链接脚本
│ └── link.ld # 内存布局定义
└── README.md # 项目说明（快速上手指南）


## 项目说明

- **docs/**: 存放项目相关的文档，包括 CPU 架构设计、支持的指令集以及未来适配 RT-Thread 的规划。
- **rtl/**: 包含核心的 RTL 代码，按功能模块划分，如取指、译码、执行、存储器等。
- **sim/**: 包含仿真相关的文件，如测试用例和仿真波形。
- **scripts/**: 存放编译、仿真和综合的脚本文件。
- **fpga/**: 包含 FPGA 相关的约束文件和生成的比特流文件。
- **software/**: 存放软件相关的代码，包括汇编、C 代码和链接脚本。
- **README.md**: 项目的说明文件，提供快速上手指南。

## 快速开始

1. **编译 RTL 代码**:
   ```bash
   cd scripts/
   ./compile.sh
2. **运行仿真:**:
   ```bash
   ./sim.sh
3. **综合 FPGA 设计:**:
   ```bash
    vivado -source synth.tcl
