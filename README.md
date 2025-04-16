# RV32I_Pipeline_CPU

# RISC-V CPU 项目待办事项

### 1.基础
- [x] 实现 RV32I 指令集的三级流水线 CPU。
  - [x] 取指阶段（Fetch Stage）。
  - [x] 译码阶段（Decode Stage）。
  - [x] 执行阶段（Execute Stage）。
- [x] 支持基本 RV32I 指令集（如算术运算、分支跳转、加载/存储等）。

### 2. 流水线扩展
- [x] 从三级流水线扩展到五级流水线。
  - [x] 增加访存阶段（Memory Stage）。
  - [x] 增加写回阶段（Write-back Stage）。
- [x] 优化流水线性能。
  - [x] 解决数据冒险（Data Hazard）。
  - [x] 解决控制冒险（Control Hazard）。
  - [ ] 实现分支预测（Branch Prediction）。

### 3. AXI 总线与外设支持
- [ ] 实现 AXI 总线接口。
  - [ ] 支持 AXI-Lite 协议。
  - [ ] 支持 AXI4 协议。
- [ ] 连接外设。
  - [ ] UART 串口通信。
  - [ ] GPIO 控制。
  - [ ] 定时器（Timer）。
  - [ ] 中断控制器（PLIC）。

### 4. 浮点运算单元（FPU）
- [ ] 集成浮点运算单元（FPU）。
  - [ ] 支持单精度浮点运算（RV32F 指令集）。
  - [ ] 支持双精度浮点运算（RV32D 指令集）。
- [ ] 优化 FPU 性能。
  - [ ] 流水线化 FPU。
  - [ ] 支持浮点异常处理。

### 5. Cache 与指令并行
- [ ] 实现指令 Cache（I-Cache）。
  - [ ] 支持直接映射或组相联映射。
  - [ ] 实现 Cache 替换策略（如 LRU）。
- [ ] 实现数据 Cache（D-Cache）。
  - [ ] 支持写回（Write-back）和写直达（Write-through）策略。
- [ ] 支持指令并行。
  - [ ] 实现超标量架构（Superscalar）。
  - [ ] 支持多发射（Multi-issue）。

### 6. 适配 RT-Thread
- [ ] 移植 RT-Thread 到 RISC-V CPU。
  - [ ] 实现 RT-Thread 的硬件抽象层（HAL）。
  - [ ] 支持 RT-Thread 的线程调度和同步机制。
- [ ] 测试 RT-Thread 功能。
  - [ ] 运行 RT-Thread 示例程序。
  - [ ] 验证 RT-Thread 的实时性和稳定性。

### 7. 烧录到 FPGA
- [ ] 准备 FPGA 开发环境。
  - [ ] 安装 Xilinx Vivado 或 Intel Quartus。
  - [ ] 配置 FPGA 开发板。
- [ ] 综合与实现。
  - [ ] 综合 RISC-V CPU 设计。
  - [ ] 生成比特流文件（Bitstream）。
- [ ] 烧录与调试。
  - [ ] 将比特流文件烧录到 FPGA。
  - [ ] 使用逻辑分析仪调试硬件。

### 8. 测试与验证
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

### 9. 文档与优化
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
```

---

# RV32I 五级流水线 CPU 设计文档

## 一、处理器原型设计框图

### 1.1 整体架构

本项目实现了一个基于 RISC-V RV32I 指令集的五级流水线 CPU，采用经典的 RISC 五级流水线结构：取指（IF）、译码（ID）、执行（EX）、访存（MEM）和写回（WB）。整体架构如下图所示：

```
+-------------+     +-------------+     +-------------+     +-------------+     +-------------+
|    取指      |     |    译码      |     |    执行      |     |    访存      |     |    写回      |
|   (IF)      |---->|   (ID)      |---->|   (EX)      |---->|   (MEM)     |---->|   (WB)      |
+-------------+     +-------------+     +-------------+     +-------------+     +-------------+
      ^                    |                  |                   |                   |
      |                    |                  |                   |                   |
      +--------------------+------------------+-------------------+-------------------+
                                       数据前递和冒险处理
```

### 1.2 模块组成

本 CPU 由以下主要模块组成：

1. **取指模块 (IF)**：负责从指令存储器获取指令，并计算下一条指令地址。
   - PC 寄存器：存储当前指令地址
   - 指令获取逻辑：从 ROM 中获取指令

2. **译码模块 (ID)**：解析指令，生成控制信号，读取寄存器值。
   - 指令解码器：解析指令操作码和功能码
   - 寄存器堆：32 个 32 位通用寄存器
   - 立即数生成器：生成各种指令格式的立即数

3. **执行模块 (EX)**：执行 ALU 运算，计算分支跳转地址。
   - 算术逻辑单元 (ALU)：执行算术和逻辑运算
   - 分支判断单元：处理条件分支指令
   - 地址计算单元：计算访存地址和跳转地址

4. **访存模块 (MEM)**：执行存储器访问操作。
   - 数据存储器接口：处理加载和存储指令

5. **写回模块 (WB)**：将结果写回寄存器堆。
   - 写回选择器：选择写回寄存器的数据来源

6. **控制单元**：生成控制信号，处理冒险和异常。
   - 数据冒险处理：前递和流水线暂停
   - 控制冒险处理：分支预测和流水线刷新

7. **CSR 单元**：处理控制状态寄存器相关操作。
   - CSR 寄存器：存储特权级和中断相关状态
   - 中断处理逻辑：处理中断和异常

### 1.3 流水线数据通路

```
+--------+    +--------+    +--------+    +--------+    +--------+
|   IF   |    | IF/ID  |    |   ID   |    | ID/EX  |    |   EX   |
|        |    |        |    |        |    |        |    |        |
| PC_reg |    | PC     |    | Decode |    | PC     |    | ALU    |
| Inst   |--->| Inst   |--->| RegFile|--->| Op1    |--->| Branch |
|        |    |        |    |        |    | Op2    |    | Jump   |
+--------+    +--------+    +--------+    | Rd     |    +--------+
                                          | Ctrl   |        |
                                          +--------+        |
                                                            V
                                          +--------+    +--------+
                                          |   WB   |    | MEM/WB |
                                          |        |    |        |
                                          | RegWB  |    | Rd     |
                                          |        |<---| Data   |
                                          +--------+    | Ctrl   |
                                             ^          +--------+
                                             |              ^
                                          +--------+        |
                                          |  MEM   |        |
                                          |        |        |
                                          | MemAcc |        |
                                          | MemWB  |--------+
                                          |        |
                                          +--------+
```

### 1.4 冒险处理机制

本 CPU 实现了以下冒险处理机制：

1. **数据冒险处理**：
   - 实现了完整的数据前递（Forwarding）机制，从 EX/MEM 和 MEM/WB 阶段向 ID/EX 阶段前递数据
   - 当前递无法解决的数据冒险（如加载-使用冒险）时，插入流水线气泡

2. **控制冒险处理**：
   - 在 EX 阶段确定分支结果，并在需要时刷新流水线
   - 对于无条件跳转指令，在 ID 阶段提前计算跳转地址

### 1.5 流水线各阶段详细实现

#### 1.5.1 取指阶段 (IF)

取指阶段是流水线的第一个阶段，主要负责从指令存储器中获取指令。其核心实现包括：

```verilog
// 取指模块实现摘要
module iF (
    input  wire [31:0] pc_addr_i,     // 程序计数器地址输入
    input  wire [31:0] rom_inst_i,     // 从ROM读取的指令
    output wire [31:0] if2rom_addr_o,  // 输出到ROM的地址
    output wire [31:0] inst_addr_o,    // 指令地址输出
    output wire [31:0] inst_o          // 指令输出
);
    // 简单地将输入传递到输出
    assign inst_addr_o = pc_addr_i;
    assign inst_o = rom_inst_i;
    assign if2rom_addr_o = pc_addr_i;
endmodule
```

取指阶段的主要特点：

- **PC寄存器**：程序计数器维护当前执行指令的地址，由控制单元更新
- **指令获取**：根据PC地址从指令存储器(ROM)读取32位指令
- **地址计算**：正常情况下，PC+4作为下一条指令地址；分支/跳转时，使用计算出的目标地址
- **流水线寄存器**：IF/ID流水线寄存器保存当前指令和对应PC值，传递给译码阶段

#### 1.5.2 译码阶段 (ID)

译码阶段负责解析指令，读取寄存器值，生成控制信号。其核心实现包括：

```verilog
// 译码模块实现摘要
module id (
    // 输入从IF/ID流水线寄存器
    input  wire [31:0] inst_i,         // 指令
    input  wire [31:0] inst_addr_i,    // 指令地址
    // 寄存器堆接口
    output reg  [ 4:0] rs1_addr_o,     // 源寄存器1地址
    output reg  [ 4:0] rs2_addr_o,     // 源寄存器2地址
    input  wire [31:0] rs1_data_i,     // 源寄存器1数据
    input  wire [31:0] rs2_data_i,     // 源寄存器2数据
    // 数据前递输入
    input  wire [ 4:0] ex_rd_addr_i,   // EX阶段目标寄存器地址
    input  wire [31:0] ex_result_i,    // EX阶段计算结果
    input  wire        ex_reg_wen_i,   // EX阶段寄存器写使能
    input  wire [ 4:0] mem_rd_addr_i,  // MEM阶段目标寄存器地址
    input  wire [31:0] mem_result_i,   // MEM阶段计算结果
    input  wire        mem_reg_wen_i,  // MEM阶段寄存器写使能
    // 输出到ID/EX流水线寄存器
    output reg  [31:0] op1_o,          // 操作数1
    output reg  [31:0] op2_o,          // 操作数2
    output reg  [ 4:0] rd_addr_o,      // 目标寄存器地址
    output reg         reg_wen,        // 寄存器写使能
    // 其他控制信号...
);
    // 指令字段解析
    wire [ 6:0] opcode = inst_i[6:0];  // 操作码
    wire [11:0] imm = inst_i[31:20];   // I型立即数
    wire [ 4:0] rs1 = inst_i[19:15];   // 源寄存器1
    wire [ 4:0] rs2 = inst_i[24:20];   // 源寄存器2
    wire [ 4:0] rd = inst_i[11:7];     // 目标寄存器
    wire [ 2:0] funct3 = inst_i[14:12]; // 功能码3
    wire [ 6:0] funct7 = inst_i[31:25]; // 功能码7
    
    // 数据前递逻辑
    // 指令解码逻辑
    // 控制信号生成
    // ...
endmodule
```

译码阶段的主要特点：

- **指令解析**：根据RISC-V指令格式解析操作码、功能码、寄存器地址和立即数
- **寄存器读取**：从寄存器堆读取源操作数
- **立即数生成**：根据不同指令格式（I、S、B、U、J型）生成适当的立即数
- **控制信号生成**：根据指令类型生成ALU操作、内存访问、寄存器写回等控制信号
- **数据前递检测**：检测数据依赖，准备接收前递数据

#### 1.5.3 执行阶段 (EX)

执行阶段负责进行算术逻辑运算、比较操作和地址计算。其核心实现包括：

```verilog
// 执行模块实现摘要
module ex (
    // 从ID/EX流水线寄存器输入
    input  wire [31:0] inst_i,        // 指令
    input  wire [31:0] inst_addr_i,   // 指令地址
    input  wire [31:0] op1_i,         // 操作数1
    input  wire [31:0] op2_i,         // 操作数2
    input  wire [ 4:0] rd_addr_i,     // 目标寄存器地址
    input  wire        rd_wen_i,      // 寄存器写使能
    // 数据前递输入
    input  wire [31:0] mem_rd_data,   // MEM阶段目标寄存器数据
    input  wire [ 4:0] mem_rd_addr,   // MEM阶段目标寄存器地址
    input  wire        mem_reg_wen,   // MEM阶段寄存器写使能
    input  wire [31:0] wb_rd_data,    // WB阶段目标寄存器数据
    input  wire [ 4:0] wb_rd_addr,    // WB阶段目标寄存器地址
    input  wire        wb_reg_wen,    // WB阶段寄存器写使能
    // 输出到EX/MEM流水线寄存器
    output reg  [31:0] rd_data_o,     // 计算结果
    output reg  [ 4:0] rd_addr_o,     // 目标寄存器地址
    output reg         rd_wen_o,      // 寄存器写使能
    // 跳转控制
    output reg  [31:0] jump_addr_o,   // 跳转地址
    output reg         jump_en_o,     // 跳转使能
    output reg         hold_flag_o    // 流水线暂停标志
);
    // 数据前递逻辑
    reg [31:0] op1;  // 前递后的操作数1
    reg [31:0] op2;  // 前递后的操作数2
    
    // 前递逻辑实现
    // ALU操作实现
    // 分支跳转逻辑
    // ...
endmodule
```

执行阶段的主要特点：

- **数据前递**：从MEM和WB阶段接收前递数据，解决数据依赖
- **ALU操作**：执行算术运算（加、减）、逻辑运算（与、或、异或）、移位操作和比较操作
- **分支判断**：对条件分支指令进行条件判断，确定是否跳转
- **地址计算**：计算跳转目标地址和内存访问地址
- **冒险处理**：检测并处理无法通过前递解决的数据冒险，必要时发出流水线暂停信号

#### 1.5.4 访存阶段 (MEM)

访存阶段负责执行内存读写操作。其核心实现包括：

```verilog
// 访存模块实现摘要
module mem (
    // 从EX/MEM流水线寄存器输入
    input  wire [31:0] mem_addr_i,    // 内存访问地址
    input  wire [31:0] mem_data_i,    // 内存写数据
    input  wire [ 2:0] mem_size_i,    // 访问大小(字节/半字/字)
    input  wire        mem_we_i,      // 内存写使能
    input  wire        mem_re_i,      // 内存读使能
    input  wire [31:0] rd_data_i,     // 寄存器写数据
    input  wire [ 4:0] rd_addr_i,     // 寄存器地址
    input  wire        rd_wen_i,      // 寄存器写使能
    // 从RAM输入
    input  wire [31:0] ram_data_i,    // RAM读数据
    // 输出到RAM
    output reg  [31:0] ram_addr_o,    // RAM地址
    output reg  [31:0] ram_data_o,    // RAM写数据
    output reg  [ 3:0] ram_sel_o,     // 字节选择信号
    output reg         ram_we_o,      // RAM写使能
    output reg         ram_re_o,      // RAM读使能
    // 输出到MEM/WB流水线寄存器
    output reg  [31:0] rd_data_o,     // 寄存器写数据
    output reg  [ 4:0] rd_addr_o,     // 寄存器地址
    output reg         rd_wen_o       // 寄存器写使能
);
    // 内存访问逻辑
    // 数据对齐和扩展
    // ...
endmodule
```

访存阶段的主要特点：

- **内存读写**：执行加载(LB/LH/LW/LBU/LHU)和存储(SB/SH/SW)指令
- **地址对齐**：确保内存访问地址正确对齐
- **数据扩展**：对加载指令进行符号扩展或零扩展
- **字节选择**：对于部分写入(SB/SH)，生成适当的字节选择信号
- **数据前递**：将内存读取结果前递到需要的阶段

#### 1.5.5 写回阶段 (WB)

写回阶段是流水线的最后一个阶段，负责将结果写回寄存器堆。其核心实现包括：

```verilog
// 写回模块实现摘要
module wb (
    // 从MEM/WB流水线寄存器输入
    input  wire [31:0] rd_data_i,     // 寄存器写数据
    input  wire [ 4:0] rd_addr_i,     // 寄存器地址
    input  wire        rd_wen_i,      // 寄存器写使能
    // 输出到寄存器堆
    output wire [31:0] rd_data_o,     // 寄存器写数据
    output wire [ 4:0] rd_addr_o,     // 寄存器地址
    output wire        rd_wen_o       // 寄存器写使能
);
    // 简单传递信号
    assign rd_data_o = rd_data_i;
    assign rd_addr_o = rd_addr_i;
    assign rd_wen_o = rd_wen_i;
endmodule
```

写回阶段的主要特点：

- **寄存器写回**：将计算结果或内存读取数据写回到目标寄存器
- **写回选择**：根据指令类型选择写回数据来源（ALU结果、内存数据、PC+4等）
- **零寄存器处理**：确保x0寄存器始终为0（不允许写入）

### 1.6 数据冒险处理详细机制

数据冒险是指当一条指令需要使用前面指令的结果，而该结果尚未写回寄存器堆时产生的冲突。本CPU实现了以下数据冒险处理机制：

#### 1.6.1 数据前递（Forwarding）

数据前递是解决大多数数据冒险的主要技术，通过直接将结果从产生阶段传递到需要使用的阶段，避免等待写回。

```verilog
// 执行阶段的数据前递逻辑
// rs1前递逻辑
if (mem_reg_wen && mem_rd_addr != 5'b0 && mem_rd_addr == rs1_addr_i) begin
    op1 = mem_mem_re_i ? ram_data_i : mem_rd_data;  // 从MEM阶段前递
end else if (wb_reg_wen && wb_rd_addr != 5'b0 && wb_rd_addr == rs1_addr_i) begin
    op1 = wb_mem_re_i ? ram_data_i : wb_rd_data;    // 从WB阶段前递
end else begin
    op1 = op1_i;  // 使用ID阶段数据
end

// rs2前递逻辑
if (mem_reg_wen && mem_rd_addr != 5'b0 && mem_rd_addr == rs2_addr_i) begin
    op2 = mem_mem_re_i ? ram_data_i : mem_rd_data;  // 从MEM阶段前递
end else if (wb_reg_wen && wb_rd_addr != 5'b0 && wb_rd_addr == rs2_addr_i) begin
    op2 = wb_mem_re_i ? ram_data_i : wb_rd_data;    // 从WB阶段前递
end else begin
    op2 = op2_i;  // 使用ID阶段数据
end
```

前递机制的主要特点：

- **EX阶段前递**：从EX/MEM和MEM/WB流水线寄存器获取结果，直接传递给需要的指令
- **优先级处理**：当多个阶段都有可用的前递数据时，优先使用较新的结果（EX/MEM优先于MEM/WB）
- **零寄存器处理**：对于x0寄存器，不进行前递（始终为0）
- **内存读取特殊处理**：对于加载指令，需要特殊处理前递逻辑，因为数据直到MEM阶段才可用

#### 1.6.2 流水线暂停（Pipeline Stall）

对于无法通过前递解决的数据冒险（如加载-使用冒险），需要插入流水线气泡：

```verilog
// 加载-使用冒险检测
if (mem_re_i && rd_addr_i != 5'b0 && 
    (rd_addr_i == rs1_addr_i || rd_addr_i == rs2_addr_i)) begin
    hold_flag