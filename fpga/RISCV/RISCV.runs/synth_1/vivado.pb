
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2$
create_project: 2default:default2
00:00:052default:default2
00:00:052default:default2
437.2772default:default2
164.9572default:defaultZ17-268h px� 
y
Command: %s
53*	vivadotcl2H
4synth_design -top cpu_top_soc -part xc7k325tffg900-22default:defaultZ4-113h px� 
:
Starting synth_design
149*	vivadotclZ4-321h px� 
�
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2
	Synthesis2default:default2
xc7k325t2default:defaultZ17-347h px� 
�
0Got license for feature '%s' and/or device '%s'
310*common2
	Synthesis2default:default2
xc7k325t2default:defaultZ17-349h px� 
�
HMultithreading enabled for synth_design using a maximum of %s processes.4828*oasys2
22default:defaultZ8-7079h px� 
a
?Launching helper process for spawning children vivado processes4827*oasysZ8-7078h px� 
`
#Helper process launched with PID %s4824*oasys2
262842default:defaultZ8-7075h px� 
�
%s*synth2�
sStarting Synthesize : Time (s): cpu = 00:00:03 ; elapsed = 00:00:03 . Memory (MB): peak = 884.336 ; gain = 422.176
2default:defaulth px� 
�
synthesizing module '%s'%s4497*oasys2
cpu_top_soc2default:default2
 2default:default2Q
;E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/cpu_top_soc.v2default:default2
12default:default8@Z8-6157h px� 
�
synthesizing module '%s'%s4497*oasys2
cpu_top2default:default2
 2default:default2V
@E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/core/top/cpu_top.v2default:default2
12default:default8@Z8-6157h px� 
�
synthesizing module '%s'%s4497*oasys2
pc_reg2default:default2
 2default:default2W
AE:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/core/fetch/pc_reg.v2default:default2
22default:default8@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
pc_reg2default:default2
 2default:default2
02default:default2
12default:default2W
AE:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/core/fetch/pc_reg.v2default:default2
22default:default8@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2
iF2default:default2
 2default:default2S
=E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/core/fetch/if.v2default:default2
22default:default8@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
iF2default:default2
 2default:default2
02default:default2
12default:default2S
=E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/core/fetch/if.v2default:default2
22default:default8@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2
if_id2default:default2
 2default:default2V
@E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/core/fetch/if_id.v2default:default2
42default:default8@Z8-6157h px� 
�
synthesizing module '%s'%s4497*oasys2 
dff_set_hold2default:default2
 2default:default2X
BE:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/utils/dff_set_hold.v2default:default2
22default:default8@Z8-6157h px� 
X
%s
*synth2@
,	Parameter DW bound to: 32 - type: integer 
2default:defaulth p
x
� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2 
dff_set_hold2default:default2
 2default:default2
02default:default2
12default:default2X
BE:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/utils/dff_set_hold.v2default:default2
22default:default8@Z8-6155h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
if_id2default:default2
 2default:default2
02default:default2
12default:default2V
@E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/core/fetch/if_id.v2default:default2
42default:default8@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2
id2default:default2
 2default:default2T
>E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/core/decode/id.v2default:default2
32default:default8@Z8-6157h px� 
�
default block is never used226*oasys2T
>E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/core/decode/id.v2default:default2
432default:default8@Z8-226h px� 
�
default block is never used226*oasys2T
>E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/core/decode/id.v2default:default2
712default:default8@Z8-226h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
id2default:default2
 2default:default2
02default:default2
12default:default2T
>E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/core/decode/id.v2default:default2
32default:default8@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2
id_ex2default:default2
 2default:default2W
AE:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/core/decode/id_ex.v2default:default2
22default:default8@Z8-6157h px� 
�
synthesizing module '%s'%s4497*oasys20
dff_set_hold__parameterized02default:default2
 2default:default2X
BE:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/utils/dff_set_hold.v2default:default2
22default:default8@Z8-6157h px� 
W
%s
*synth2?
+	Parameter DW bound to: 5 - type: integer 
2default:defaulth p
x
� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys20
dff_set_hold__parameterized02default:default2
 2default:default2
02default:default2
12default:default2X
BE:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/utils/dff_set_hold.v2default:default2
22default:default8@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys20
dff_set_hold__parameterized12default:default2
 2default:default2X
BE:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/utils/dff_set_hold.v2default:default2
22default:default8@Z8-6157h px� 
W
%s
*synth2?
+	Parameter DW bound to: 1 - type: integer 
2default:defaulth p
x
� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys20
dff_set_hold__parameterized12default:default2
 2default:default2
02default:default2
12default:default2X
BE:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/utils/dff_set_hold.v2default:default2
22default:default8@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys20
dff_set_hold__parameterized22default:default2
 2default:default2X
BE:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/utils/dff_set_hold.v2default:default2
22default:default8@Z8-6157h px� 
W
%s
*synth2?
+	Parameter DW bound to: 3 - type: integer 
2default:defaulth p
x
� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys20
dff_set_hold__parameterized22default:default2
 2default:default2
02default:default2
12default:default2X
BE:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/utils/dff_set_hold.v2default:default2
22default:default8@Z8-6155h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
id_ex2default:default2
 2default:default2
02default:default2
12default:default2W
AE:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/core/decode/id_ex.v2default:default2
22default:default8@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2
ex2default:default2
 2default:default2U
?E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/core/execute/ex.v2default:default2
32default:default8@Z8-6157h px� 
�
default block is never used226*oasys2U
?E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/core/execute/ex.v2default:default2
1012default:default8@Z8-226h px� 
�
default block is never used226*oasys2U
?E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/core/execute/ex.v2default:default2
1592default:default8@Z8-226h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
ex2default:default2
 2default:default2
02default:default2
12default:default2U
?E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/core/execute/ex.v2default:default2
32default:default8@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2
ex_mem2default:default2
 2default:default2Y
CE:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/core/execute/ex_mem.v2default:default2
12default:default8@Z8-6157h px� 
�
synthesizing module '%s'%s4497*oasys2
dff_set2default:default2
 2default:default2S
=E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/utils/dff_set.v2default:default2
22default:default8@Z8-6157h px� 
W
%s
*synth2?
+	Parameter DW bound to: 5 - type: integer 
2default:defaulth p
x
� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
dff_set2default:default2
 2default:default2
02default:default2
12default:default2S
=E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/utils/dff_set.v2default:default2
22default:default8@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2+
dff_set__parameterized02default:default2
 2default:default2S
=E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/utils/dff_set.v2default:default2
22default:default8@Z8-6157h px� 
X
%s
*synth2@
,	Parameter DW bound to: 32 - type: integer 
2default:defaulth p
x
� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2+
dff_set__parameterized02default:default2
 2default:default2
02default:default2
12default:default2S
=E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/utils/dff_set.v2default:default2
22default:default8@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2+
dff_set__parameterized12default:default2
 2default:default2S
=E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/utils/dff_set.v2default:default2
22default:default8@Z8-6157h px� 
W
%s
*synth2?
+	Parameter DW bound to: 1 - type: integer 
2default:defaulth p
x
� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2+
dff_set__parameterized12default:default2
 2default:default2
02default:default2
12default:default2S
=E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/utils/dff_set.v2default:default2
22default:default8@Z8-6155h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
ex_mem2default:default2
 2default:default2
02default:default2
12default:default2Y
CE:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/core/execute/ex_mem.v2default:default2
12default:default8@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2
mem2default:default2
 2default:default2U
?E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/core/memory/mem.v2default:default2
22default:default8@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
mem2default:default2
 2default:default2
02default:default2
12default:default2U
?E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/core/memory/mem.v2default:default2
22default:default8@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2
mem_wb2default:default2
 2default:default2X
BE:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/core/memory/mem_wb.v2default:default2
12default:default8@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
mem_wb2default:default2
 2default:default2
02default:default2
12default:default2X
BE:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/core/memory/mem_wb.v2default:default2
12default:default8@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2
wb2default:default2
 2default:default2W
AE:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/core/writeback/wb.v2default:default2
22default:default8@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
wb2default:default2
 2default:default2
02default:default2
12default:default2W
AE:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/core/writeback/wb.v2default:default2
22default:default8@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2
control2default:default2
 2default:default2Y
CE:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/core/common/control.v2default:default2
12default:default8@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
control2default:default2
 2default:default2
02default:default2
12default:default2Y
CE:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/core/common/control.v2default:default2
12default:default8@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2
regs2default:default2
 2default:default2V
@E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/core/decode/regs.v2default:default2
22default:default8@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
regs2default:default2
 2default:default2
02default:default2
12default:default2V
@E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/core/decode/regs.v2default:default2
22default:default8@Z8-6155h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
cpu_top2default:default2
 2default:default2
02default:default2
12default:default2V
@E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/core/top/cpu_top.v2default:default2
12default:default8@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2
rom2default:default2
 2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
22default:default8@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
rom2default:default2
 2default:default2
02default:default2
12default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
22default:default8@Z8-6155h px� 
�
synthesizing module '%s'%s4497*oasys2
ram2default:default2
 2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/RAM.v2default:default2
12default:default8@Z8-6157h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
ram2default:default2
 2default:default2
02default:default2
12default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/RAM.v2default:default2
12default:default8@Z8-6155h px� 
�
'done synthesizing module '%s'%s (%s#%s)4495*oasys2
cpu_top_soc2default:default2
 2default:default2
02default:default2
12default:default2Q
;E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/cpu_top_soc.v2default:default2
12default:default8@Z8-6155h px� 
�
qTrying to implement RAM '%s' in registers. Block RAM or DRAM implementation is not possible; see log for reasons.3901*oasys2
 2default:defaultZ8-4767h px� 
j
%s
*synth2R
>	1: Unable to determine number of words or word size in RAM. 
2default:defaulth p
x
� 
T
%s
*synth2<
(	2: No valid read/write found for RAM. 
2default:defaulth p
x
� 
I
%s
*synth21
RAM dissolved into registers
2default:defaulth p
x
� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
0Net %s in module/entity %s does not have driver.3422*oasys2
ROM2default:default2
rom2default:default2P
:E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/perips/ROM.v2default:default2
62default:default8@Z8-3848h px� 
�
�Message '%s' appears more than %s times and has been disabled. User can change this message limit to see more message instances.
14*common2 
Synth 8-38482default:default2
1002default:defaultZ17-14h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2"
mem_addr_i[31]2default:default2
ram2default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2"
mem_addr_i[30]2default:default2
ram2default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2"
mem_addr_i[29]2default:default2
ram2default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2"
mem_addr_i[28]2default:default2
ram2default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2"
mem_addr_i[27]2default:default2
ram2default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2"
mem_addr_i[26]2default:default2
ram2default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2"
mem_addr_i[25]2default:default2
ram2default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2"
mem_addr_i[24]2default:default2
ram2default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2"
mem_addr_i[23]2default:default2
ram2default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2"
mem_addr_i[22]2default:default2
ram2default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2"
mem_addr_i[21]2default:default2
ram2default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2"
mem_addr_i[20]2default:default2
ram2default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2"
mem_addr_i[19]2default:default2
ram2default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2"
mem_addr_i[18]2default:default2
ram2default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2"
mem_addr_i[17]2default:default2
ram2default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2"
mem_addr_i[16]2default:default2
ram2default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2"
mem_addr_i[15]2default:default2
ram2default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2"
mem_addr_i[14]2default:default2
ram2default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2

inst_i[19]2default:default2
ex2default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2

inst_i[18]2default:default2
ex2default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2

inst_i[17]2default:default2
ex2default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2

inst_i[16]2default:default2
ex2default:defaultZ8-7129h px� 
�
9Port %s in module %s is either unconnected or has no load4866*oasys2

inst_i[15]2default:default2
ex2default:defaultZ8-7129h px� 
�
%s*synth2�
tFinished Synthesize : Time (s): cpu = 00:00:05 ; elapsed = 00:00:05 . Memory (MB): peak = 1049.488 ; gain = 587.328
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
Finished Constraint Validation : Time (s): cpu = 00:00:05 ; elapsed = 00:00:06 . Memory (MB): peak = 1049.488 ; gain = 587.328
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
V
%s
*synth2>
*Start Loading Part and Timing Information
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Loading part: xc7k325tffg900-2
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Loading Part and Timing Information : Time (s): cpu = 00:00:05 ; elapsed = 00:00:06 . Memory (MB): peak = 1049.488 ; gain = 587.328
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
W
Loading part %s157*device2$
xc7k325tffg900-22default:defaultZ21-403h px� 
�
!inferring latch for variable '%s'327*oasys2"
mem_data_o_reg2default:default2T
>E:/Files/Electron/FPGA/RV32I_Pipeline_CPU/rtl/core/decode/id.v2default:default2
1222default:default8@Z8-327h px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished RTL Optimization Phase 2 : Time (s): cpu = 00:00:09 ; elapsed = 00:00:07 . Memory (MB): peak = 1156.070 ; gain = 693.910
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
L
%s
*synth24
 Start RTL Component Statistics 
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Detailed RTL Component Info : 
2default:defaulth p
x
� 
:
%s
*synth2"
+---Adders : 
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input   32 Bit       Adders := 5     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   3 Input   32 Bit       Adders := 1     
2default:defaulth p
x
� 
8
%s
*synth2 
+---XORs : 
2default:defaulth p
x
� 
Z
%s
*synth2B
.	   2 Input     32 Bit         XORs := 1     
2default:defaulth p
x
� 
=
%s
*synth2%
+---Registers : 
2default:defaulth p
x
� 
Z
%s
*synth2B
.	               32 Bit    Registers := 44    
2default:defaulth p
x
� 
Z
%s
*synth2B
.	                5 Bit    Registers := 5     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	                3 Bit    Registers := 1     
2default:defaulth p
x
� 
Z
%s
*synth2B
.	                1 Bit    Registers := 7     
2default:defaulth p
x
� 
8
%s
*synth2 
+---RAMs : 
2default:defaulth p
x
� 
k
%s
*synth2S
?	             128K Bit	(4096 X 32 bit)          RAMs := 1     
2default:defaulth p
x
� 
9
%s
*synth2!
+---Muxes : 
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input   32 Bit        Muxes := 48    
2default:defaulth p
x
� 
X
%s
*synth2@
,	   7 Input   32 Bit        Muxes := 1     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   8 Input   32 Bit        Muxes := 1     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   4 Input   32 Bit        Muxes := 2     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   6 Input   32 Bit        Muxes := 2     
2default:defaulth p
x
� 
X
%s
*synth2@
,	  10 Input   32 Bit        Muxes := 3     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input   16 Bit        Muxes := 1     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   4 Input    8 Bit        Muxes := 1     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input    8 Bit        Muxes := 1     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input    5 Bit        Muxes := 15    
2default:defaulth p
x
� 
X
%s
*synth2@
,	  10 Input    5 Bit        Muxes := 1     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   3 Input    5 Bit        Muxes := 2     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   8 Input    4 Bit        Muxes := 1     
2default:defaulth p
x
� 
X
%s
*synth2@
,	  10 Input    3 Bit        Muxes := 5     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   6 Input    3 Bit        Muxes := 1     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input    3 Bit        Muxes := 3     
2default:defaulth p
x
� 
X
%s
*synth2@
,	  10 Input    2 Bit        Muxes := 2     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input    2 Bit        Muxes := 1     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   3 Input    2 Bit        Muxes := 1     
2default:defaulth p
x
� 
X
%s
*synth2@
,	   2 Input    1 Bit        Muxes := 49    
2default:defaulth p
x
� 
X
%s
*synth2@
,	  10 Input    1 Bit        Muxes := 8     
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
O
%s
*synth27
#Finished RTL Component Statistics 
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
H
%s
*synth20
Start Part Resource Summary
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s
*synth2m
YPart Resources:
DSPs: 840 (col length:140)
BRAMs: 890 (col length: RAMB18 140 RAMB36 70)
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Finished Part Resource Summary
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
W
%s
*synth2?
+Start Cross Boundary and Area Optimization
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
H
&Parallel synthesis criteria is not met4829*oasysZ8-7080h px� 
�
�RAM (%s) has partial Byte Wide Write Enable pattern, however no output register found in fanout of RAM. Recommended to use supported Byte Wide Write Enable template. 
4703*oasys2$
u_ram/memory_reg2default:defaultZ8-6851h px� 
�
�RAM (%s) has partial Byte Wide Write Enable pattern, however no output register found in fanout of RAM. Recommended to use supported Byte Wide Write Enable template. 
4703*oasys2$
u_ram/memory_reg2default:defaultZ8-6851h px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Cross Boundary and Area Optimization : Time (s): cpu = 00:00:13 ; elapsed = 00:00:12 . Memory (MB): peak = 1291.469 ; gain = 829.309
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
F
%s
*synth2.
Start Timing Optimization
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
}Finished Timing Optimization : Time (s): cpu = 00:00:13 ; elapsed = 00:00:12 . Memory (MB): peak = 1291.469 ; gain = 829.309
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
E
%s
*synth2-
Start Technology Mapping
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
|Finished Technology Mapping : Time (s): cpu = 00:00:13 ; elapsed = 00:00:12 . Memory (MB): peak = 1291.469 ; gain = 829.309
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
?
%s
*synth2'
Start IO Insertion
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
Q
%s
*synth29
%Start Flattening Before IO Insertion
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
T
%s
*synth2<
(Finished Flattening Before IO Insertion
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
H
%s
*synth20
Start Final Netlist Cleanup
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Finished Final Netlist Cleanup
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
vFinished IO Insertion : Time (s): cpu = 00:00:16 ; elapsed = 00:00:15 . Memory (MB): peak = 1291.469 ; gain = 829.309
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
O
%s
*synth27
#Start Renaming Generated Instances
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Renaming Generated Instances : Time (s): cpu = 00:00:16 ; elapsed = 00:00:15 . Memory (MB): peak = 1291.469 ; gain = 829.309
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
L
%s
*synth24
 Start Rebuilding User Hierarchy
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Rebuilding User Hierarchy : Time (s): cpu = 00:00:16 ; elapsed = 00:00:15 . Memory (MB): peak = 1291.469 ; gain = 829.309
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Start Renaming Generated Ports
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Renaming Generated Ports : Time (s): cpu = 00:00:16 ; elapsed = 00:00:15 . Memory (MB): peak = 1291.469 ; gain = 829.309
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
M
%s
*synth25
!Start Handling Custom Attributes
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Handling Custom Attributes : Time (s): cpu = 00:00:16 ; elapsed = 00:00:15 . Memory (MB): peak = 1291.469 ; gain = 829.309
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
J
%s
*synth22
Start Renaming Generated Nets
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Renaming Generated Nets : Time (s): cpu = 00:00:16 ; elapsed = 00:00:15 . Memory (MB): peak = 1291.469 ; gain = 829.309
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
K
%s
*synth23
Start Writing Synthesis Report
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
A
%s
*synth2)

Report BlackBoxes: 
2default:defaulth p
x
� 
J
%s
*synth22
+-+--------------+----------+
2default:defaulth p
x
� 
J
%s
*synth22
| |BlackBox name |Instances |
2default:defaulth p
x
� 
J
%s
*synth22
+-+--------------+----------+
2default:defaulth p
x
� 
J
%s
*synth22
+-+--------------+----------+
2default:defaulth p
x
� 
A
%s*synth2)

Report Cell Usage: 
2default:defaulth px� 
=
%s*synth2%
+-+-----+------+
2default:defaulth px� 
=
%s*synth2%
| |Cell |Count |
2default:defaulth px� 
=
%s*synth2%
+-+-----+------+
2default:defaulth px� 
=
%s*synth2%
+-+-----+------+
2default:defaulth px� 
E
%s
*synth2-

Report Instance Areas: 
2default:defaulth p
x
� 
N
%s
*synth26
"+------+---------+-------+------+
2default:defaulth p
x
� 
N
%s
*synth26
"|      |Instance |Module |Cells |
2default:defaulth p
x
� 
N
%s
*synth26
"+------+---------+-------+------+
2default:defaulth p
x
� 
N
%s
*synth26
"|1     |top      |       |     0|
2default:defaulth p
x
� 
N
%s
*synth26
"+------+---------+-------+------+
2default:defaulth p
x
� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
�
%s*synth2�
�Finished Writing Synthesis Report : Time (s): cpu = 00:00:16 ; elapsed = 00:00:15 . Memory (MB): peak = 1291.469 ; gain = 829.309
2default:defaulth px� 
~
%s
*synth2f
R---------------------------------------------------------------------------------
2default:defaulth p
x
� 
u
%s
*synth2]
ISynthesis finished with 0 errors, 0 critical warnings and 4122 warnings.
2default:defaulth p
x
� 
�
%s
*synth2�
Synthesis Optimization Runtime : Time (s): cpu = 00:00:16 ; elapsed = 00:00:15 . Memory (MB): peak = 1291.469 ; gain = 829.309
2default:defaulth p
x
� 
�
%s
*synth2�
�Synthesis Optimization Complete : Time (s): cpu = 00:00:16 ; elapsed = 00:00:15 . Memory (MB): peak = 1291.469 ; gain = 829.309
2default:defaulth p
x
� 
B
 Translating synthesized netlist
350*projectZ1-571h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2.
Netlist sorting complete. 2default:default2
00:00:002default:default2
00:00:002default:default2
1291.4692default:default2
0.0002default:defaultZ17-268h px� 
K
)Preparing netlist for logic optimization
349*projectZ1-570h px� 
u
)Pushed %s inverter(s) to %s load pin(s).
98*opt2
02default:default2
02default:defaultZ31-138h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2.
Netlist sorting complete. 2default:default2
00:00:002default:default2
00:00:002default:default2
1344.0312default:default2
0.0002default:defaultZ17-268h px� 
~
!Unisim Transformation Summary:
%s111*project29
%No Unisim elements were transformed.
2default:defaultZ1-111h px� 
g
%Synth Design complete | Checksum: %s
562*	vivadotcl2
6ebec652default:defaultZ4-1430h px� 
U
Releasing license: %s
83*common2
	Synthesis2default:defaultZ17-83h px� 
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
632default:default2
1262default:default2
02default:default2
02default:defaultZ4-41h px� 
^
%s completed successfully
29*	vivadotcl2 
synth_design2default:defaultZ4-42h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2"
synth_design: 2default:default2
00:00:192default:default2
00:00:172default:default2
1344.0312default:default2
906.7542default:defaultZ17-268h px� 
�
 The %s '%s' has been generated.
621*common2

checkpoint2default:default2k
WE:/Files/Electron/FPGA/RV32I_Pipeline_CPU/fpga/RISCV/RISCV.runs/synth_1/cpu_top_soc.dcp2default:defaultZ17-1381h px� 
�
%s4*runtcl2�
lExecuting : report_utilization -file cpu_top_soc_utilization_synth.rpt -pb cpu_top_soc_utilization_synth.pb
2default:defaulth px� 
�
Exiting %s at %s...
206*common2
Vivado2default:default2,
Tue Mar 25 16:08:56 20252default:defaultZ17-206h px� 


End Record