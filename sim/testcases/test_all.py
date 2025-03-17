import os
import subprocess
import sys

from compile_and_sim import compile
from compile_and_sim import list_binfiles
from compile_and_sim import sim
from compile_and_sim import bin_to_mem


def main():
    # 获取上一级路径
    rtl_dir = os.path.abspath(os.path.join(os.getcwd(), ".."))
    # 获取路径下所有bin文件
    all_bin_files = list_binfiles(rtl_dir + r"/testcases/generated/")
    # 遍历所有文件一个一个执行
    for file_bin in all_bin_files:
        cmd = r"python compile_and_sim.py" + " " + file_bin
        f = os.popen(cmd)
        r = f.read()

        index = file_bin.index("-p-")
        print_name = file_bin[index + 3 : -4]

        if r.find("pass") != -1:
            print("指令  " + print_name.ljust(10, " ") + "    PASS")
        else:
            print("指令  " + print_name.ljust(10, " ") + "    !!!FAIL!!!")
        f.close()


if __name__ == "__main__":
    main()
