# RV32I_Pipeline_CPU

## 项目目录结构
![img](https://pic1.imgdb.cn/item/67cd5a0a066befcec6e207db.png)
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