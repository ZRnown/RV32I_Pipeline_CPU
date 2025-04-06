# test_uart.S
.section .text
.global _start
_start:
    li t0, 0x00000004  # UART 数据寄存器
    li t1, 0x00000000  # UART 控制/状态寄存器
    li t2, 65          # 发送字符 'A' (ASCII 65)
    sw t2, 0(t0)       # 写入发送数据
    li t2, 1
    sw t2, 0(t1)       # 启动发送
wait:
    lw t3, 0(t1)       # 读取状态
    andi t3, t3, 2     # 检查忙碌位 (tx_busy)
    bnez t3, wait      # 等待发送完成

    # 设置测试标志
    li x26, 1          # 测试完成
    li x27, 1          # 测试成功
    j _start           # 循环发送