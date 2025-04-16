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

8. **RIB 总线**：负责连接 CPU 核心与外设。
   - 主设备接口：连接 CPU 数据通路
   - 从设备接口：连接 RAM、ROM、UART、GPIO 等外设
   - 仲裁逻辑：处理多个主设备的访问请求

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

## 二、RIB 总线架构与接口设计

### 2.1 RIB 总线概述

RIB（RISC-V Internal Bus）是本项目中实现的一种简化的片上总线，用于连接 CPU 核心与各种外设。RIB 总线采用主从架构，支持多主多从的连接拓扑，具有以下特点：

- **多主设备支持**：可连接多个主设备（如 CPU 数据通路、DMA 控制器等）
- **多从设备支持**：可连接多个从设备（如 RAM、ROM、外设等）
- **仲裁机制**：采用固定优先级仲裁，解决多主设备访问冲突
- **地址映射**：通过高位地址解码，将访问请求路由到对应的从设备
- **数据宽度**：支持 32 位数据传输
- **传输类型**：支持字节、半字、字级别的读写操作

### 2.2 RIB 总线接口定义

#### 2.2.1 主设备接口

每个主设备接口包含以下信号：

```verilog
// 主设备接口示例 (Master 0)
input  wire [31:0] m0_addr_i,  // 地址输入
input  wire [31:0] m0_data_i,  // 写数据输入
output reg  [31:0] m0_data_o,  // 读数据输出
input  wire        m0_req_i,   // 请求信号
input  wire        m0_we_i,    // 写使能
input  wire        m0_re_i,    // 读使能
input  wire [ 2:0] m0_size_i,  // 数据大小 (000:字节, 001:半字, 010:字)
```

#### 2.2.2 从设备接口

每个从设备接口包含以下信号：

```verilog
// 从设备接口示例 (Slave 0 - RAM)
output reg  [31:0] s0_addr_o,  // 地址输出
output reg  [31:0] s0_data_o,  // 写数据输出
input  wire [31:0] s0_data_i,  // 读数据输入
output reg         s0_we_o,    // 写使能
output reg         s0_re_o,    // 读使能
output reg  [ 2:0] s0_size_o,  // 数据大小
```

### 2.3 地址映射与解码

RIB 总线使用地址的高 4 位（[31:28]）来确定访问的从设备：

```verilog
parameter [3:0] slave_0 = 4'b0000;  // RAM
parameter [3:0] slave_1 = 4'b0001;  // ROM
parameter [3:0] slave_2 = 4'b0010;  // Timer
parameter [3:0] slave_3 = 4'b0011;  // UART
parameter [3:0] slave_4 = 4'b0100;  // GPIO
parameter [3:0] slave_5 = 4'b0101;  // SPI
```

这种映射方式将整个 4GB 地址空间划分为多个 256MB 的区域，每个区域分配给一个从设备。

### 2.4 仲裁机制

RIB 总线采用固定优先级仲裁机制，优先级从高到低依次为：Master 0 > Master 1 > Master 2 > Master 3。仲裁逻辑如下：

```verilog
wire [3:0] req;
reg  [1:0] grant;
assign req = {m3_req_i, m2_req_i, m1_req_i, m0_req_i};

// 仲裁逻辑
always @(*) begin
  if (req[0]) begin
    grant = grant0;  // Master 0 获得总线
  end else if (req[1]) begin
    grant = grant1;  // Master 1 获得总线
  end else if (req[2]) begin
    grant = grant2;  // Master 2 获得总线
  end else begin
    grant = grant3;  // Master 3 获得总线
  end
end
```

### 2.5 数据传输流程

1. **主设备发起请求**：主设备通过设置 `m*_req_i` 信号发起总线请求
2. **仲裁**：总线仲裁逻辑根据优先级选择一个主设备授予总线访问权
3. **地址解码**：根据地址高位选择目标从设备
4. **数据传输**：
   - 读操作：从设备将数据通过 `s*_data_i` 返回，总线将其转发到主设备的 `m*_data_o`
   - 写操作：主设备的数据通过 `m*_data_i` 传入，总线将其转发到从设备的 `s*_data_o`

### 2.6 与 CPU 的集成

在本项目中，CPU 核心通过两个独立的接口与外部存储器交互：

1. **指令获取接口**：直接连接到 ROM，不经过 RIB 总线，用于获取指令
2. **数据访问接口**：通过 RIB 总线连接到各种外设，用于数据读写操作

这种设计实现了哈佛架构，指令和数据使用独立的访问路径，避免了结构冒险，提高了性能。

```verilog
// CPU 到 ROM 的直接连接（指令获取）
wire [31:0] cpu_to_rom_addr;  // CPU 输出到 ROM 的指令地址
wire [31:0] rom_to_cpu_inst;  // ROM 输出到 CPU 的指令

// CPU 到 RIB 总线的连接（数据访问）
wire [31:0] cpu_to_bus_addr;  // CPU 输出到总线的数据地址
wire [31:0] cpu_to_bus_data;  // CPU 输出到总线的写数据
wire [31:0] bus_to_cpu_data;  // 总线返回到 CPU 的读数据
wire        cpu_to_bus_we;    // 数据写使能
wire        cpu_to_bus_re;    // 数据读使能
wire [ 2:0] cpu_to_bus_size;  // 数据大小
```

## 三、外设接口与集成

### 3.1 RAM（数据存储器）

RAM 模块实现了数据存储功能，支持字节、半字和字级别的读写操作：

```verilog
module ram (
    input  wire        clk,         // 时钟信号
    input  wire [31:0] mem_addr_i,  // 内存地址输入
    input  wire [31:0] mem_data_i,  // 写入数据输入
    input  wire        mem_we_i,    // 写使能
    input  wire        mem_re_i,    // 读使能
    input  wire [ 2:0] mem_size_i,  // 操作大小 (000: byte, 001: halfword, 010: word)
    output reg  [31:0] mem_data_o   // 读取数据输出
);
```

主要特点：
- 支持不同粒度的访问（字节、半字、字）
- 实现字节选择逻辑，支持非对齐访问
- 支持有符号和无符号加载操作（符号扩展和零扩展）
- 写优先设计，同时读写同一地址时，返回新写入的数据

### 3.2 ROM（指令存储器）

ROM 模块存储程序指令，支持从 RIB 总线写入（用于加载程序）和 CPU 直接读取（指令获取）：

```verilog
module rom (
    input rst,
    input clk,
    input wire we_i,
    input wire [31:0] addr_i,
    input wire [31:0] data_i,
    output reg [31:0] data_o
);
```

主要特点：
- 支持在复位后通过总线加载程序
- 提供低延迟的指令获取路径
- 实现 4KB 的指令存储空间

### 3.3 UART 接口

UART 模块实现了串行通信功能，支持与外部设备进行数据交换：

```verilog
module uart (
    input  wire        clk,    // 时钟信号
    input  wire        rst,    // 复位信号
    input  wire        we_i,   // 写使能
    input  wire [31:0] addr_i, // 地址输入
    input  wire [31:0] data_i, // 写数据输入
    output reg  [31:0] data_o, // 读数据输出
    input  wire        rx,     // 接收引脚
    output wire        tx      // 发送引脚
);
```

主要特点：
- 支持可配置的波特率
- 实现发送和接收缓冲区
- 提供状态寄存器，指示发送/接收状态
- 支持中断触发机制

### 3.4 GPIO 接口

GPIO 模块提供了通用输入/输出功能，用于控制和监测外部信号：

```verilog
module gpio (
    input  wire        clk,    // 时钟信号
    input  wire        rst,    // 复位信号
    input  wire        we_i,   // 写使能
    input  wire [31:0] addr_i, // 地址输入
    input  wire [31:0] data_i, // 写数据输入
    output reg  [31:0] data_o  // 读数据输出
);
```

主要特点：
- 支持引脚方向配置（输入/输出）
- 提供引脚状态读取功能
- 支持引脚中断配置

### 3.5 定时器（Timer）

定时器模块提供了精确的时间计数和中断生成功能：

```verilog
module timer (
    input  wire        clk,    // 时钟信号
    input  wire        rst,    // 复位信号
    input  wire        we_i,   // 写使能
    input  wire [31:0] addr_i, // 地址输入
    input  wire [31:0] data_i, // 写数据输入
    output reg  [31:0] data_o, // 读数据输出
    output wire        int_o   // 中断输出
);
```

主要特点：
- 支持可编程的计数周期
- 提供计数值读取功能
- 支持中断生成和清除
- 实现多种工作模式（单次计数、循环计数等）

## 四、指令执行流程分析

### 4.1 指令获取流程

1. **PC 更新**：PC 寄存器根据控制信号更新为下一条指令地址
   ```verilog
   // 正常顺序执行
   if (!jump_en_i) begin
     pc_o <= pc_o + 32'h4;
   end else begin
     // 跳转执行
     pc_o <= jump_addr_i;
   end
   ```

2. **指令获取**：IF 阶段从 ROM 读取当前 PC 指向的指令
   ```verilog
   assign inst_addr_o = pc_addr_i;
   assign inst_o = rom_inst_i;
   assign if2rom_addr_o = pc_addr_i;
   ```

3. **指令传递**：指令通过 IF/ID 流水线寄存器传递到译码阶段
   ```verilog
   always @(posedge clk) begin
     if (rst == 1'b1) begin
       inst_o <= 32'h0;
       inst_addr_o <= 32'h0;
     end else if (hold_flag_i) begin
       // 流水线暂停，保持当前值
     end else begin
       inst_o <= inst_i;
       inst_addr_o <= inst_addr_i;
     end
   end
   ```

### 4.2 指令译码流程

1. **指令解析**：ID 阶段解析指令字段
   ```verilog
   wire [ 6:0] opcode = inst_i[6:0];  // 操作码
   wire [11:0] imm = inst_i[31:20];    // I-type立即数
   wire [ 4:0] rs1 = inst_i[19:15];    // 源寄存器1
   wire [ 4:0] rs2 = inst_i[24:20];    // 源寄存器2
   wire [ 4:0] rd = inst_i[11:7];      // 目标寄存器
   wire [ 2:0] funct3 = inst_i[14:12]; // 功能码3
   wire [ 6:0] funct7 = inst_i[31:25]; // 功能码7
   ```

2. **寄存器读取**：从寄存器堆读取源操作数
   ```verilog
   rs1_addr_o = rs1;
   rs2_addr_o = rs2;
   // 寄存器堆返回数据到 rs1_data_i 和 rs2_data_i
   ```

3. **立即数生成**：根据指令类型生成立即数
   ```verilog
   // I型指令立即数（符号扩展）
   op2_o = {{20{imm[11]}}, imm};
   ```

4. **控制信号生成**：根据指令类型生成控制信号
   ```verilog
   case (opcode)
     `INST_TYPE_I: begin
       // 算术I型指令处理
       reg_wen = 1'b1;  // 寄存器写使能
       rd_addr_o = rd;  // 目标寄存器地址
       op1_o = rs1_data;  // 操作数1为rs1值
       // ...
     end
     // 其他指令类型处理
   endcase
   ```

### 4.3 指令执行流程

1. **ALU 操作**：EX 阶段执行算术逻辑运算
   ```verilog
   case (opcode)
     `INST_TYPE_I: begin
       case (funct3)
         `INST_ADDI: begin
           rd_data_o = op1 + op2;  // 加法操作
           rd_addr_o = rd_addr_i;
           rd_wen_o  = 1'b1;
         end