# 时钟信号（差分输入）
set_property PACKAGE_PIN AD12 [get_ports clk_p]
set_property PACKAGE_PIN AD11 [get_ports clk_n]
set_property IOSTANDARD DIFF_SSTL15 [get_ports clk_p]
set_property IOSTANDARD DIFF_SSTL15 [get_ports clk_n]

# 创建时钟约束（假设 100MHz，调整周期根据实际需要）
create_clock -period 10.000 -name sys_clk [get_ports clk_p]

# 复位信号（绑定到 KEY1）
set_property PACKAGE_PIN D11 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

# LED 信号（绑定到 LED1 到 LED4）
set_property PACKAGE_PIN G24 [get_ports {led[0]}]
set_property PACKAGE_PIN E24 [get_ports {led[1]}]
set_property PACKAGE_PIN C24 [get_ports {led[2]}]
set_property PACKAGE_PIN E25 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]

# UART 信号（可选，绑定到调试引脚）
# 如果需要使用 UART，可以选择 SW 或其他空闲引脚
# set_property PACKAGE_PIN T21 [get_ports rx]
# set_property PACKAGE_PIN U22 [get_ports tx]
# set_property IOSTANDARD LVCMOS33 [get_ports rx]
# set_property IOSTANDARD LVCMOS33 [get_ports tx]