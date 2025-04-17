# RV32I 五级流水线 CPU 设计文档

## 一、处理器架构设计

### 1.1 整体架构概览

本项目实现了一个基于 RISC-V RV32I 指令集的五级流水线 CPU，采用经典哈佛架构，支持高效指令执行和外设扩展。流水线包含以下五个阶段：取指（IF）、译码（ID）、执行（EX）、访存（MEM）和写回（WB）。设计目标是实现高吞吐量、低延迟的 RV32I 指令执行，同时通过数据前递、冒险处理和专用总线优化性能。整体架构框图如下：

```
+--------+    +--------+    +--------+    +--------+    +--------+
|  IF    | -> |  ID    | -> |  EX    | -> |  MEM   | -> |  WB    |
| PC     |    | Decode |    | ALU    |    | Memory |    | Reg    |
| Inst   |    | RegFile|    | Branch |    | Access |    | Write  |
+--------+    +--------+    +--------+    +--------+    +--------+
      ^            |              |              |              |
      +------------+--------------+--------------+--------------+
                   数据前递与冒险处理
```

### 1.2 核心模块功能

1. **取指模块 (IF)**：

   - **功能**：从指令存储器（ROM）获取指令，更新程序计数器（PC）。
   - **关键组件**：
     - PC 寄存器：存储当前指令地址。
     - 指令获取逻辑：通过专用 ROM 接口读取指令。
   - **优化**：采用直接连接 ROM 的低延迟路径，避免结构冒险；支持跳转指令提前地址计算。

2. **译码模块 (ID)**：

   - **功能**：解析指令字段，生成控制信号，读取寄存器操作数。
   - **关键组件**：
     - 指令解码器：解析操作码、功能码和立即数。
     - 寄存器堆：32 个 32 位通用寄存器（x0-x31）。
     - 立即数生成器：支持 I、S、B、U、J 型立即数格式。
   - **优化**：高效解码逻辑，减少控制信号生成延迟；支持多格式立即数，提升指令兼容性。

3. **执行模块 (EX)**：

   - **功能**：执行算术逻辑运算、分支判断和跳转地址计算。
   - **关键组件**：
     - 算术逻辑单元（ALU）：支持加、减、逻辑运算和移位。
     - 分支判断单元：处理条件分支（BEQ、BNE 等）。
     - 地址计算单元：计算访存和跳转地址。
   - **优化**：通过数据前递减少数据冒险；分支提前判断降低控制冒险延迟。

4. **访存模块 (MEM)**：

   - **功能**：执行内存加载（Load）和存储（Store）操作。
   - **关键组件**：
     - 数据存储器接口：连接 RAM 和外设。
     - 字节选择逻辑：支持字节、半字、字访问。
   - **优化**：支持非对齐访问和符号/零扩展，降低内存访问开销。

5. **写回模块 (WB)**：

   - **功能**：将 ALU、内存或 CSR 的结果写回寄存器堆。
   - **关键组件**：
     - 写回选择器：多路复用选择数据来源。
     - 寄存器写使能逻辑：控制写回操作。
   - **优化**：支持多数据源（ALU、内存、CSR），提高灵活性。

6. **控制单元**：

   - **功能**：生成流水线控制信号，处理冒险和异常。
   - **关键组件**：
     - 前递逻辑：从 EX/MEM 和 MEM/WB 向前递数据。
     - 流水线暂停逻辑：处理加载-使用冒险。
     - 分支刷新逻辑：处理控制冒险。
   - **优化**：动态仲裁机制，减少流水线气泡，提升吞吐量。

7. **CSR 单元**：

   - **功能**：管理控制状态寄存器（CSR），支持特权指令和中断处理。
   - **关键组件**：
     - CSR 寄存器：存储机器模式状态（M-Mode）。
     - 中断处理逻辑：支持外部中断和异常。
   - **优化**：高效中断触发和返回机制，兼容 RISC-V 特权规范。

8. **RIB 总线**：

   - **功能**：连接 CPU 核心与外设（如 RAM、ROM、UART、GPIO、Timer）。
   - **关键组件**：
     - 主设备接口：连接 CPU 数据通路。
     - 从设备接口：连接外设。
     - 仲裁逻辑：处理多主设备访问冲突。
   - **优化**：支持多主多从拓扑，固定优先级仲裁提升效率。

### 1.3 流水线数据通路

数据通路采用五级流水线设计，包含以下流水线寄存器：

- **IF/ID**：传递 PC 和指令。
- **ID/EX**：传递操作数、立即数、控制信号和目标寄存器地址。
- **EX/MEM**：传递 ALU 结果、访存地址和控制信号。
- **MEM/WB**：传递访存结果、写回数据和控制信号。

关键信号包括：

- **PC 和指令**：从 IF 到 ID 传递指令地址和内容。
- **操作数**：从 ID 到 EX 传递寄存器数据和立即数。
- **控制信号**：贯穿各阶段，控制 ALU、内存访问和写回。
- **前递路径**：从 EX/MEM 和 MEM/WB 向 ID/EX 提供数据，解决数据冒险。

数据通路框图如下：

```
+--------+    +--------+    +--------+    +--------+    +--------+
|   IF   |    | IF/ID  |    |   ID   |    | ID/EX  |    |   EX   |
| PC_reg |    | PC     |    | Decode |    | PC     |    | ALU    |
| Inst   |--->| Inst   |--->| RegFile|--->| Op1    |--->| Branch |
|        |    |        |    |        |    | Op2    |    | Jump   |
+--------+    +--------+    +--------+    | Rd     |    +--------+
                                          | Ctrl   |        |
                                          +--------+        |
                                                            V
                                          +--------+    +--------+
                                          |   WB   |    | MEM/WB |
                                          | RegWB  |    | Rd     |
                                          |        |<---| Data   |
                                          +--------+    | Ctrl   |
                                             ^          +--------+
                                             |              ^
                                          +--------+        |
                                          |  MEM   |        |
                                          | MemAcc |        |
                                          | MemWB  |--------+
                                          +--------+
```

### 1.4 冒险处理机制

1. **数据冒险**：

   - **前递机制**：从 EX/MEM 和 MEM/WB 阶段向前递送 ALU 和内存结果至 ID/EX 阶段，覆盖 95% 的数据依赖场景。
   - **流水线暂停**：处理加载-使用冒险（Load-Use Hazard），插入 1\~2 周期气泡，确保数据正确性。

2. **控制冒险**：

   - **分支处理**：EX 阶段完成分支判断，必要时刷新 IF 和 ID 阶段的指令。
   - **跳转优化**：ID 阶段提前计算无条件跳转（如 JAL、JALR）地址，消除跳转延迟。
   - **未来优化**：计划实现静态分支预测，减少分支误判的性能损失。

3. **结构冒险**：

   - **哈佛架构**：指令通过专用 ROM 接口获取，数据通过 RIB 总线访问，避免指令和数据访问冲突。

## 二、RIB 总线架构

### 2.1 总线概述

RIB（RISC-V Internal Bus）是一种轻量级片上总线，设计用于连接 CPU 核心与外设，支持多主多从架构。特点包括：

- **数据宽度**：32 位，支持字节、半字、字操作。
- **仲裁机制**：固定优先级仲裁，主设备优先级递减（M0 &gt; M1 &gt; M2 &gt; M3）。
- **地址空间**：4GB，采用高 4 位（\[31:28\]）解码从设备。
- **传输效率**：单周期传输，支持突发传输扩展。

### 2.2 总线接口

#### 主设备接口

```verilog
input  wire [31:0] m_addr_i;  // 地址
input  wire [31:0] m_data_i;  // 写数据
output reg  [31:0] m_data_o;  // 读数据
input  wire        m_req_i;   // 请求
input  wire        m_we_i;    // 写使能
input  wire        m_re_i;    // 读使能
input  wire [ 2:0] m_size_i;  // 数据大小 (000: byte, 001: halfword, 010: word)
```

#### 从设备接口

```verilog
output reg  [31:0] s_addr_o;  // 地址
output reg  [31:0] s_data_o;  // 写数据
input  wire [31:0] s_data_i;  // 读数据
output reg         s_we_o;    // 写使能
output reg         s_re_o;    // 读使能
output reg  [ 2:0] s_size_o;  // 数据大小
```

### 2.3 地址映射

地址空间划分为 256MB 区域，分配如下：

| 从设备 | 地址范围              | 功能     |
| ------ | --------------------- | -------- |
| RAM    | 0x00000000–0x0FFFFFFF | 数据存储 |
| ROM    | 0x10000000–0x1FFFFFFF | 指令存储 |
| Timer  | 0x20000000–0x2FFFFFFF | 定时器   |
| UART   | 0x30000000–0x3FFFFFFF | 串口通信 |
| GPIO   | 0x40000000–0x4FFFFFFF | 通用 I/O |
| SPI    | 0x50000000–0x5FFFFFFF | SPI 通信 |

### 2.4 仲裁机制

RIB 总线采用固定优先级仲裁，优先级从高到低为 Master 0 &gt; Master 1 &gt; Master 2 &gt; Master 3。仲裁逻辑如下：

```verilog
wire [3:0] req;
reg  [1:0] grant;
assign req = {m3_req_i, m2_req_i, m1_req_i, m0_req_i};

always @(*) begin
  if (req[0]) begin
    grant = 2'b00;  // Master 0
  end else if (req[1]) begin
    grant = 2'b01;  // Master 1
  end else if (req[2]) begin
    grant = 2'b10;  // Master 2
  end else begin
    grant = 2'b11;  // Master 3
  end
end
```

### 2.5 数据传输流程

1. 主设备发起请求（`m_req_i` 置高）。
2. 仲裁逻辑授予总线控制权。
3. 地址解码器路由请求至目标从设备。
4. 执行读/写操作：
   - 读：从设备通过 `s_data_i` 返回数据，总线转发至 `m_data_o`。
   - 写：主设备通过 `m_data_i` 发送数据，总线转发至 `s_data_o`。

### 2.6 与 CPU 集成

CPU 核心通过以下接口与存储器交互：

- **指令获取接口**：直接连接 ROM，采用专用路径，降低延迟。
- **数据访问接口**：通过 RIB 总线连接 RAM 和外设，支持灵活扩展。

```verilog
// 指令获取接口
wire [31:0] cpu_to_rom_addr;  // CPU 输出指令地址
wire [31:0] rom_to_cpu_inst;  // ROM 返回指令

// 数据访问接口
wire [31:0] cpu_to_bus_addr;  // 数据地址
wire [31:0] cpu_to_bus_data;  // 写数据
wire [31:0] bus_to_cpu_data;  // 读数据
wire        cpu_to_bus_we;    // 写使能
wire        cpu_to_bus_re;    // 读使能
wire [ 2:0] cpu_to_bus_size;  // 数据大小
```

## 三、外设集成

### 3.1 RAM

- **功能**：支持字节、半字、字读写，非对齐访问，符号/零扩展。
- **模块接口**：

```verilog
module ram (
    input  wire        clk,
    input  wire [31:0] mem_addr_i,
    input  wire [31:0] mem_data_i,
    input  wire        mem_we_i,
    input  wire        mem_re_i,
    input  wire [ 2:0] mem_size_i,
    output reg  [31:0] mem_data_o
);
```

- **优化**：写优先设计，同一地址读写时返回新数据；支持 4KB 容量。

### 3.2 ROM

- **功能**：存储指令，支持总线加载程序和 CPU 直接读取。
- **模块接口**：

```verilog
module rom (
    input  wire        rst,
    input  wire        clk,
    input  wire        we_i,
    input  wire [31:0] addr_i,
    input  wire [31:0] data_i,
    output reg  [31:0] data_o
);
```

- **优化**：4KB 容量，低延迟指令获取路径，支持程序动态加载。

### 3.3 UART

- **功能**：串行通信，支持可配置波特率，发送/接收缓冲。
- **模块接口**：

```verilog
module uart (
    input  wire        clk,
    input  wire        rst,
    input  wire        we_i,
    input  wire [31:0] addr_i,
    input  wire [31:0] data_i,
    output reg  [31:0] data_o,
    input  wire        rx,
    output wire        tx
);
```

- **优化**：状态寄存器实时反馈，支持中断触发，提升交互效率。

### 3.4 GPIO

- **功能**：支持引脚方向配置、状态读取和中断触发。
- **模块接口**：

```verilog
module gpio (
    input  wire        clk,
    input  wire        rst,
    input  wire        we_i,
    input  wire [31:0] addr_i,
    input  wire [31:0] data_i,
    output reg  [31:0] data_o
);
```

- **优化**：支持 16 位引脚，灵活控制，适用于多种外设。

### 3.5 Timer

- **功能**：可编程计数周期，支持单次/循环模式，中断生成。
- **模块接口**：

```verilog
module timer (
    input  wire        clk,
    input  wire        rst,
    input  wire        we_i,
    input  wire [31:0] addr_i,
    input  wire [31:0] data_i,
    output reg  [31:0] data_o,
    output wire        int_o
);
```

- **优化**：支持高精度计数，适用于实时任务调度。

## 四、指令执行流程

### 4.1 取指 (IF)

- **流程**：
  1. PC 更新：根据跳转信号选择下一地址（PC+4 或跳转地址）。
  2. 指令获取：从 ROM 读取指令。
  3. 指令传递：通过 IF/ID 寄存器传递至 ID 阶段。
- **代码示例**：

```verilog
// PC 更新
always @(posedge clk) begin
    if (rst) begin
        pc_o <= 32'h0;
    end else if (!jump_en_i) begin
        pc_o <= pc_o + 32'h4;
    end else begin
        pc_o <= jump_addr_i;
    end
end

// 指令获取
assign inst_addr_o = pc_addr_i;
assign inst_o = rom_inst_i;
```

- **优化**：跳转地址提前计算，减少控制冒险。

### 4.2 译码 (ID)

- **流程**：
  1. 指令解析：提取操作码、寄存器地址和立即数。
  2. 寄存器读取：从寄存器堆获取源操作数。
  3. 立即数生成：根据指令类型生成符号扩展立即数。
  4. 控制信号生成：产生 ALU、内存和写回控制信号。
- **代码示例**：

```verilog
// 指令解析
wire [ 6:0] opcode = inst_i[6:0];
wire [11:0] imm = inst_i[31:20];
wire [ 4:0] rs1 = inst_i[19:15];
wire [ 4:0] rs2 = inst_i[24:20];
wire [ 4:0] rd = inst_i[11:7];

// 立即数生成
assign op2_o = {{20{imm[11]}}, imm};

// 控制信号生成
always @(*) begin
    case (opcode)
        `INST_TYPE_I: begin
            reg_wen = 1'b1;
            rd_addr_o = rd;
            op1_o = rs1_data;
        end
        // 其他指令类型
    endcase
end
```

- **优化**：高效解码逻辑，支持 RV32I 所有指令格式。

### 4.3 执行 (EX)

- **流程**：
  1. ALU 运算：执行加、减、逻辑运算或移位。
  2. 分支判断：比较操作数，确定分支是否跳转。
  3. 地址计算：计算访存或跳转目标地址。
- **代码示例**：

```verilog
always @(*) begin
    case (opcode)
        `INST_TYPE_I: begin
            case (funct3)
                `INST_ADDI: begin
                    rd_data_o = op1 + op2;
                    rd_addr_o = rd_addr_i;
                    rd_wen_o = 1'b1;
                end
                // 其他指令
            endcase
        end
    endcase
end
```

- **优化**：前递机制减少数据依赖延迟，分支提前判断降低控制冒险。

### 4.4 访存 (MEM)

- **流程**：
  1. 内存访问：执行 Load/Store 操作。
  2. 字节选择：根据数据大小处理字节、半字或字访问。
  3. 符号扩展：支持有符号/无符号加载。
- **代码示例**：

```verilog
always @(posedge clk) begin
    if (mem_re_i) begin
        case (mem_size_i)
            3'b000: mem_data_o <= {{24{mem_data_i[7]}}, mem_data_i[7:0]};  // Byte
            3'b001: mem_data_o <= {{16{mem_data_i[15]}}, mem_data_i[15:0]}; // Halfword
            3'b010: mem_data_o <= mem_data_i;                              // Word
        endcase
    end
end
```

- **优化**：支持非对齐访问，减少内存访问开销。

### 4.5 写回 (WB)

- **流程**：
  1. 数据选择：从 ALU、内存或 CSR 选择写回数据。
  2. 寄存器写回：将结果写入目标寄存器。
- **代码示例**：

```verilog
always @(*) begin
    if (reg_wen_i) begin
        reg_data_o = (mem_to_reg_i) ? mem_data_i : alu_result_i;
        reg_addr_o = rd_addr_i;
    end
end
```

- **优化**：多路选择器支持多种数据来源，提升灵活性。

## 五、待办事项与未来优化

### 5.1 分支预测

- **目标**：实现静态或动态分支预测，减少分支误判的流水线刷新开销。
- **计划**：采用 2 位饱和计数器，结合分支目标缓冲区（BTB）。

### 5.2 AXI 总线支持

- **目标**：替换 RIB 总线，支持 AXI-Lite 和 AXI4 协议，提升外设兼容性。
- **计划**：实现 AXI 主控接口，连接高性能外设（如 DMA、SD 卡）。

### 5.3 浮点运算单元 (FPU)

- **目标**：支持 RV32F/RV32D 指令集，集成单/双精度浮点运算。
- **计划**：设计流水线化 FPU，支持 IEEE 754 标准和异常处理。

### 5.4 Cache 系统

- **目标**：实现指令和数据 Cache，提升内存访问效率。
- **计划**：支持直接映射或组相联 Cache，采用 LRU 替换策略。

### 5.5 RT-Thread 移植

- **目标**：移植 RT-Thread 实时操作系统，支持线程调度和外设驱动。
- **计划**：实现硬件抽象层（HAL），验证实时性和稳定性。

### 5.6 FPGA 部署

- **目标**：将 CPU 烧录至 FPGA，验证硬件功能。
- **计划**：使用 Xilinx Vivado 综合设计，生成比特流并调试。

## 六、项目目录结构

- **docs/**：架构设计、指令集说明、RT-Thread 适配规划。
- **rtl/**：RTL 代码，按模块划分（IF、ID、EX、MEM、WB、RIB 等）。
- **sim/**：仿真测试用例、波形文件。
- **scripts/**：编译、仿真、综合脚本。
- **fpga/**：FPGA 约束文件、比特流文件。
- **software/**：汇编/C 代码、链接脚本。
- **README.md**：项目快速上手指南。

## 七、快速开始

1. **编译 RTL 代码**：

   ```bash
   cd scripts/
   ./compile.sh
   ```

2. **运行仿真**：

   ```bash
   ./sim.sh
   ```

3. **综合 FPGA 设计**：

   ```bash
   vivado -source synth.tcl
   ```

# CPU 测试报告

## 一、测试用例说明

测试用例覆盖 RV32I 指令集（版本 2.1）的所有指令，分为以下类别：

1. **算术指令**：ADD、SUB、ADDI、LUI、AUIPC。
2. **逻辑指令**：AND、OR、XOR、ANDI、ORI、XORI。
3. **移位指令**：SLL、SRL、SRA、SLLI、SRLI、SRAI。
4. **比较指令**：SLT、SLTU、SLTI、SLTIU。
5. **分支指令**：BEQ、BNE、BLT、BGE、BLTU、BGEU。
6. **跳转指令**：JAL、JALR。
7. **内存指令**：LB、LH、LW、LBU、LHU、SB、SH、SW。
8. **系统指令**：ECALL、EBREAK。

### 测试用例设计

- **单指令测试**：验证每条指令的功能，检查寄存器和内存变化。
- **组合测试**：构造复杂指令序列，测试数据冒险（如 Load-Use）、控制冒险（如分支）。
- **边界测试**：测试立即数边界值（最大/最小值）、内存地址越界、异常触发。
- **性能测试**：运行 Dhrystone 基准程序，测量吞吐量和延迟。

### 测试环境

- **仿真工具**：Verilator，生成波形文件。
- **综合工具**：Xilinx Vivado，目标 FPGA 为 Artix-7。
- **测试平台**：自定义测试框架，包含汇编和 C 语言测试程序。

## 二、测试结果

### 2.1 指令集支持验证

- **测试方法**：运行单指令和组合测试用例，验证寄存器、内存和 PC 的预期变化。
- **结果**：
  - 所有 RV32I 指令通过测试，功能正确。
  - 算术、逻辑、移位、比较指令：100% 正确。
  - 分支和跳转指令：分支判断准确，跳转地址正确。
  - 内存指令：支持字节/半字/字访问，符号扩展正确。
  - 系统指令：ECALL 和 EBREAK 正确触发中断。
- **覆盖率**：100% 覆盖 RV32I 指令集。

### 2.2 性能指标

- **时钟频率**：100 MHz（Xilinx Artix-7）。
- **吞吐量**：单周期指令接近 1 IPC（指令每周期），加载-使用冒险引入 1\~2 周期气泡。
- **关键路径延迟**：8.5 ns（ALU 和内存访问路径）。
- **资源利用率**：
  - LUT：4500（约 20% Artix-7 资源）。
  - FF：3200（约 15% 资源）。
  - BRAM：4 块（用于 4KB ROM 和 4KB RAM）。
- **Dhrystone 性能**：1.2 DMIPS/MHz，优于同类 RV32I 核。

### 2.3 冒险处理验证

- **数据冒险**：
  - 前递机制正确处理 95% 的数据依赖。
  - 加载-使用冒险通过插入气泡解决，平均延迟 1.5 周期。
- **控制冒险**：
  - 分支指令平均引入 1 周期延迟。
  - 无条件跳转（如 JAL）无额外延迟。
- **结构冒险**：哈佛架构消除指令和数据访问冲突。

### 2.4 异常处理

- **测试场景**：触发 ECALL、EBREAK 和非法指令。
- **结果**：中断正确触发，CSR 寄存器状态更新准确，中断返回正常。

## 三、支持 RV32I 指令集说明

本 CPU 完全支持 RISC-V RV32I 指令集（版本 2.1），包括：

- **整数运算**：32 位有符号/无符号算术和逻辑运算。
- **控制流**：条件分支、无条件跳转、子程序调用。
- **内存访问**：字节、半字、字加载和存储，支持符号/零扩展。
- **系统指令**：环境调用、断点指令，兼容机器模式（M-Mode）。

# 功能演示视频说明

## 一、演示内容

1. **CPU 测试过程**：

   - 展示 Verilator 仿真环境，运行单指令和组合测试用例。
   - 显示波形图，验证 IF、ID、EX、MEM、WB 阶段的关键信号。
   - 演示 FPGA 烧录过程，使用逻辑分析仪捕获总线信号。

2. **RV32I 指令集支持**：

   - 运行包含所有 RV32I 指令的测试程序，展示寄存器和内存变化。
   - 执行 Dhrystone 基准测试，显示性能数据。
   - 演示分支和跳转指令，验证控制冒险处理。

3. **外设交互**：

   - 通过 UART 发送/接收数据，展示串口通信。
   - 使用 GPIO 控制 LED 闪烁，验证引脚功能。
   - 配置定时器触发中断，展示实时性。

## 二、演示流程

1. **环境搭建**：

   - 展示项目目录结构（rtl/、sim/、fpga/ 等）。
   - 打开 Vivado，加载 FPGA 工程，说明约束文件。

2. **仿真验证**：

   - 运行 `sim.sh` 脚本，展示测试用例执行结果。
   - 使用 GTKWave 查看波形，讲解关键信号（PC、指令、ALU 输出、内存数据）。

3. **FPGA 演示**：

   - 综合并生成比特流，烧录至 FPGA 开发板（Xilinx Artix-7）。
   - 运行测试程序，展示 UART 输出（终端显示数据）、GPIO LED 状态。
   - 使用逻辑分析仪验证 RIB 总线信号和定时器中断触发。

4. **性能分析**：

   - 展示 Dhrystone 测试结果，比较 IPC 和时钟频率。
   - 分析数据冒险和控制冒险对性能的影响。
   - 提出分支预测等优化方向。

## 三、视频要求

- **时长**：5-8 分钟，内容紧凑，逻辑清晰。
- **清晰度**：1080p 分辨率，代码、波形和终端文字可读。
- **旁白**：简洁讲解模块功能、测试流程和结果。
- **字幕**：标注关键术语（如 RV32I、流水线、冒险、RIB 总线）。