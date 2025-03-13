# RV32I_Pipeline_CPU

## 项目说明

# RISC-V CPU 项目待办事项

## 已完成
- [x] 实现 RV32I 指令集的三级流水线 CPU。
  - [x] 取指阶段（Fetch Stage）。
  - [x] 译码阶段（Decode Stage）。
  - [x] 执行阶段（Execute Stage）。
- [x] 支持基本 RV32I 指令集（如算术运算、分支跳转、加载/存储等）。

## 待完成

### 1. AXI 总线与外设支持
- [ ] 实现 AXI 总线接口。
  - [ ] 支持 AXI-Lite 协议。
  - [ ] 支持 AXI4 协议。
- [ ] 连接外设。
  - [ ] UART 串口通信。
  - [ ] GPIO 控制。
  - [ ] 定时器（Timer）。
  - [ ] 中断控制器（PLIC）。

### 2. 浮点运算单元（FPU）
- [ ] 集成浮点运算单元（FPU）。
  - [ ] 支持单精度浮点运算（RV32F 指令集）。
  - [ ] 支持双精度浮点运算（RV32D 指令集）。
- [ ] 优化 FPU 性能。
  - [ ] 流水线化 FPU。
  - [ ] 支持浮点异常处理。

### 3. Cache 与指令并行
- [ ] 实现指令 Cache（I-Cache）。
  - [ ] 支持直接映射或组相联映射。
  - [ ] 实现 Cache 替换策略（如 LRU）。
- [ ] 实现数据 Cache（D-Cache）。
  - [ ] 支持写回（Write-back）和写直达（Write-through）策略。
- [ ] 支持指令并行。
  - [ ] 实现超标量架构（Superscalar）。
  - [ ] 支持多发射（Multi-issue）。

### 4. 流水线扩展
- [ ] 从三级流水线扩展到五级流水线。
  - [ ] 增加访存阶段（Memory Stage）。
  - [ ] 增加写回阶段（Write-back Stage）。
- [ ] 优化流水线性能。
  - [ ] 解决数据冒险（Data Hazard）。
  - [ ] 解决控制冒险（Control Hazard）。
  - [ ] 实现分支预测（Branch Prediction）。

### 5. 适配 RT-Thread
- [ ] 移植 RT-Thread 到 RISC-V CPU。
  - [ ] 实现 RT-Thread 的硬件抽象层（HAL）。
  - [ ] 支持 RT-Thread 的线程调度和同步机制。
- [ ] 测试 RT-Thread 功能。
  - [ ] 运行 RT-Thread 示例程序。
  - [ ] 验证 RT-Thread 的实时性和稳定性。

### 6. 烧录到 FPGA
- [ ] 准备 FPGA 开发环境。
  - [ ] 安装 Xilinx Vivado 或 Intel Quartus。
  - [ ] 配置 FPGA 开发板。
- [ ] 综合与实现。
  - [ ] 综合 RISC-V CPU 设计。
  - [ ] 生成比特流文件（Bitstream）。
- [ ] 烧录与调试。
  - [ ] 将比特流文件烧录到 FPGA。
  - [ ] 使用逻辑分析仪调试硬件。

### 7. 测试与验证
- [ ] 完成 RISC-V 指令集测试。
  - [ ] 编写测试程序，覆盖所有 RV32I 指令。
  - [ ] 使用仿真工具验证指令功能。
- [ ] 完成性能测试。
  - [ ] 测试 CPU 的时钟频率和吞吐量。
  - [ ] 测试 Cache 命中率和内存访问延迟。
  - [ ] 测试 FPU 的浮点运算性能。
- [ ] 编写测试报告。
  - [ ] 记录测试结果和分析。
  - [ ] 提出优化建议。

### 8. 文档与优化
- [ ] 编写项目文档。
  - [ ] 设计文档。
  - [ ] 用户手册。
- [ ] 优化代码性能。
  - [ ] 减少关键路径延迟。
  - [ ] 优化资源利用率。
- [ ] 改进代码可读性。
  - [ ] 添加注释。
  - [ ] 统一代码风格。

---

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