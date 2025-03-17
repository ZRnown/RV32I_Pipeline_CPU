import os
import subprocess
import sys


def list_binfiles(path):
    files = []
    list_dir = os.walk(path)
    for maindir, subdir, all_file in list_dir:
        for filename in all_file:
            apath = os.path.join(maindir, filename)
            if apath.endswith(".bin"):
                files.append(apath)
    return files


def bin_to_mem(infile, outfile):
    os.makedirs(os.path.dirname(outfile), exist_ok=True)
    binfile = open(infile, "rb")
    binfile_content = binfile.read(os.path.getsize(infile))
    datafile = open(outfile, "w")

    index = 0
    b0 = b1 = b2 = b3 = 0

    for b in binfile_content:
        if index == 0:
            b0 = b
            index += 1
        elif index == 1:
            b1 = b
            index += 1
        elif index == 2:
            b2 = b
            index += 1
        elif index == 3:
            b3 = b
            index = 0
            array = [b3, b2, b1, b0]
            datafile.write(bytearray(array).hex() + "\n")

    binfile.close()
    datafile.close()


def compile():
    # 获取项目根目录（脚本在 sim/testcases 下，根目录退两级）
    root_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
    rtl_dir = os.path.join(root_dir, "rtl")

    iverilog_cmd = ["iverilog", "-o", "out.vvp"]
    iverilog_cmd += ["-I", os.path.join(rtl_dir, "core", "common")]
    # 测试台文件
    iverilog_cmd.append(os.path.join(root_dir, "sim", "testcases", "tb.v"))
    # RTL 文件
    iverilog_cmd.extend(
        [
            os.path.join(rtl_dir, "core", "common", "defines.v"),
            os.path.join(rtl_dir, "core", "common", "control.v"),
            os.path.join(rtl_dir, "core", "fetch", "pc_reg.v"),
            os.path.join(rtl_dir, "core", "fetch", "if.v"),
            os.path.join(rtl_dir, "core", "fetch", "if_id.v"),
            os.path.join(rtl_dir, "core", "decode", "id.v"),
            os.path.join(rtl_dir, "core", "decode", "id_ex.v"),
            os.path.join(rtl_dir, "core", "decode", "regs.v"),
            os.path.join(rtl_dir, "core", "execute", "ex.v"),
            os.path.join(rtl_dir, "core", "execute", "ex_mem.v"),
            os.path.join(rtl_dir, "core", "memory", "mem.v"),
            os.path.join(rtl_dir, "core", "memory", "mem_wb.v"),
            os.path.join(rtl_dir, "core", "writeback", "wb.v"),
            os.path.join(rtl_dir, "core", "top", "cpu_top.v"),
            os.path.join(rtl_dir, "cpu_top_soc.v"),
            os.path.join(rtl_dir, "perips", "RAM.v"),
            os.path.join(rtl_dir, "perips", "ROM.v"),
            os.path.join(rtl_dir, "utils", "dff_set.v"),
            os.path.join(rtl_dir, "utils", "dff_set_hold.v"),
        ]
    )

    print("iverilog 命令:", " ".join(iverilog_cmd))

    process = subprocess.Popen(
        iverilog_cmd,
        stderr=subprocess.PIPE,
        stdout=subprocess.PIPE,
        text=True,
        shell=False,
    )
    stdout, stderr = process.communicate(timeout=5)
    if process.returncode != 0:
        print("编译失败，错误信息如下：")
        print("STDOUT:", stdout)
        print("STDERR:", stderr)
        sys.exit(1)


def sim():
    compile()
    vvp_cmd = ["vvp", "out.vvp"]
    process = subprocess.Popen(
        vvp_cmd, stderr=subprocess.PIPE, stdout=subprocess.PIPE, text=True, shell=False
    )
    stdout, stderr = process.communicate(timeout=10)
    if process.returncode != 0:
        print("仿真失败，错误信息如下：")
        print("STDOUT:", stdout)
        print("STDERR:", stderr)
        sys.exit(1)
    else:
        print("仿真输出：")
        print(stdout)


def run(test_binfile):
    root_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
    test_binfile = os.path.abspath(os.path.join(os.getcwd(), test_binfile))
    out_mem = os.path.join(root_dir, "sim", "testcases", "generated", "inst_data.txt")

    if not os.path.exists(test_binfile):
        print(f"错误：.bin 文件 '{test_binfile}' 不存在")
        sys.exit(1)

    bin_to_mem(test_binfile, out_mem)
    sim()


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("错误：请提供 .bin 文件路径作为参数（例如 generated\\rv32ui-p-and.bin）")
        sys.exit(1)
    sys.exit(run(sys.argv[1]))
