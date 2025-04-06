# RV32I Pipeline CPU 地址映射文档

## 概述

本文档详细说明了RV32I Pipeline CPU系统中各个外设的地址映射。系统采用AXI4-Lite总线连接CPU和外设，通过高4位地址(31:28)进行外设选择。

## 地址映射表

| 外设名称 | 基地址范围                | 描述             |
| -------- | ------------------------- | ---------------- |
| UART     | 0x0000_0000 - 0x0FFF_FFFF | 串口通信接口     |
| GPIO     | 0x1000_0000 - 0x1FFF_FFFF | 通用输入输出接口 |
| Timer    | 0x2000_0000 - 0x2FFF_FFFF | 定时器           |
| Memory   | 0x3000_0000 - 0x3FFF_FFFF | 内存映射区域     |

## UART 寄存器映射

基地址: 0x0000_0000

| 寄存器名称   | 偏移量 | 地址        | 描述                                                                            |
| ------------ | ------ | ----------- | ------------------------------------------------------------------------------- |
| 状态寄存器   | 0x00   | 0x0000_0000 | [0]: rx_valid - 接收数据有效标志<br>[1]: tx_busy - 发送忙碌标志<br>[31:2]: 保留 |
| 数据寄存器   | 0x04   | 0x0000_0004 | [7:0]: 发送/接收数据<br>[31:8]: 保留                                            |
| 波特率寄存器 | 0x08   | 0x0000_0008 | [15:0]: 波特率分频值<br>[31:16]: 保留                                           |

### 状态寄存器操作
- 读操作: 获取UART状态，包括接收数据是否有效和发送是否忙碌
- 写操作: 写入bit[0]=1触发数据发送

### 数据寄存器操作
- 读操作: 读取接收到的数据
- 写操作: 写入要发送的数据

### 波特率寄存器操作
- 读操作: 读取当前波特率分频值
- 写操作: 设置新的波特率分频值
  - 分频值计算公式: 分频值 = 系统时钟频率 / 波特率
  - 例如: 100MHz系统时钟，115200波特率，分频值 = 100,000,000 / 115,200 ≈ 868

## GPIO 寄存器映射

基地址: 0x1000_0000 (待实现)

## Timer 寄存器映射

基地址: 0x2000_0000 (待实现)

## 内存映射

基地址: 0x3000_0000 (待实现)

## 编程示例

### UART发送数据示例
```c
// 定义UART寄存器地址
#define UART_STAT_REG (*(volatile unsigned int*)0x00000000)
#define UART_DATA_REG (*(volatile unsigned int*)0x00000004)
#define UART_BAUD_REG (*(volatile unsigned int*)0x00000008)

// 发送一个字节
void uart_send_byte(unsigned char data) {
    // 等待发送空闲
    while(UART_STAT_REG & 0x2) {}
    
    // 写入数据
    UART_DATA_REG = data;
    
    // 触发发送
    UART_STAT_REG = 0x1;
}

// 接收一个字节
unsigned char uart_receive_byte(void) {
    // 等待接收数据有效
    while(!(UART_STAT_REG & 0x1)) {}
    
    // 读取数据
    return (unsigned char)UART_DATA_REG;
}

// 设置波特率
void uart_set_baudrate(unsigned short div_value) {
    UART_BAUD_REG = div_value;
}
```