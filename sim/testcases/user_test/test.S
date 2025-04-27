# CSR 寄存器测试程序 (RV32I + Zicsr)
# 修正说明：
# 1. 所有 andi 立即数改为 12 位有符号范围内
# 2. 对大立即数使用 li + and 组合
# 3. 保持所有 CSR 操作不变（依赖 zicsr 扩展）

.section .text
.global _start
_start:
    # 1. 测试 cycle 计数器 (只读)
    csrr t0, cycle          # 读取 cycle 计数器
    csrr t1, cycleh         # 读取 cycle 高32位 (如果支持)

    # 2. 测试 mscratch (可读写)
    li t2, 0x12345678       # 加载测试值
    csrw mscratch, t2       # 写入 mscratch
    csrr t3, mscratch       # 读回 mscratch
    bne t2, t3, fail        # 检查是否匹配

    # 3. 测试 mtvec (异常向量基址)
    la t2, trap_handler     # 加载陷阱处理程序地址
    csrw mtvec, t2          # 设置 mtvec
    csrr t3, mtvec          # 读回 mtvec
    li t4, 0xFFFFFFFC       # 掩码：清除低2位模式标志
    and t3, t3, t4          # 使用寄存器掩码（原 andi 立即数过大）
    bne t2, t3, fail        # 检查是否匹配

    # 4. 测试 mie (中断使能)
    li t2, 0x888            # 设置测试值
    csrw mie, t2            # 写入 mie
    csrr t3, mie            # 读回 mie
    li t4, 0x888            # 预期的掩码值
    and t3, t3, t4          # 使用寄存器掩码（原 andi 立即数过大）
    bne t4, t3, fail        # 检查是否匹配

    # 5. 测试 mstatus (状态寄存器)
    li t2, 0x1800           # 设置 MPP=0x3, MPIE=1
    csrs mstatus, t2        # 设置 mstatus 的某些位
    csrr t3, mstatus        # 读回 mstatus
    li t4, 0x1800           # 预期的掩码值
    and t3, t3, t4          # 使用寄存器掩码（原 andi 立即数过大）
    bne t4, t3, fail        # 检查是否匹配

    # 6. 测试 CSR 读写指令 (csrrw, csrrs, csrrc)
    # 测试 csrrw
    li t2, 0x55AA55AA
    csrrw t3, mscratch, t2  # 交换 t2 和 mscratch
    csrr t4, mscratch       # 读回 mscratch
    bne t2, t4, fail        # 检查是否写入成功

    # 测试 csrrs
    li t2, 0x0000000F
    csrrs t3, mscratch, t2  # 设置低4位
    csrr t4, mscratch       # 读回 mscratch
    li t5, 0xF              # 预期的低4位掩码
    and t6, t4, t5          # 提取低4位
    bne t5, t6, fail        # 检查低4位是否被设置

    # 测试 csrrc
    li t2, 0x0000000F
    csrrc t3, mscratch, t2  # 清除低4位
    csrr t4, mscratch       # 读回 mscratch
    andi t5, t4, 0xF        # 合法的12位立即数
    bnez t5, fail           # 检查低4位是否被清除

    # 7. 测试异常相关 CSR (通过触发一个异常)
    # 保存测试值到 mepc 和 mcause
    li t2, 0x87654321
    csrw mepc, t2           # 设置 mepc
    li t2, 0x0000000B       # 设置测试异常原因 (环境调用)
    csrw mcause, t2         # 设置 mcause

    # 读取检查
    csrr t3, mepc           # 读回 mepc
    bne t2, t3, fail        # 检查 mepc
    csrr t3, mcause         # 读回 mcause
    li t4, 0x0000000B
    bne t4, t3, fail        # 检查 mcause

    # 测试结束 - 成功
    li a0, 0                # 返回0表示成功
    j exit

fail:
    li a0, 1                # 返回1表示失败
    j exit

trap_handler:
    # 异常处理程序
    csrr t0, mepc           # 读取 mepc
    addi t0, t0, 4          # 跳过 ecall 指令
    csrw mepc, t0           # 更新 mepc
    mret                    # 返回

exit:
    # 退出程序
    j exit