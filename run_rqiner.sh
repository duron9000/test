#!/bin/bash

# 检查是否存在 rqiner-x86-znver4 文件，如果不存在则下载
if [ ! -f "/rqiner/rqiner-x86-znver4" ]; then
    # 下载 rqiner-x86-znver4 文件
    wget -O /rqiner/rqiner-x86-znver4 https://github.com/Qubic-Solutions/rqiner-builds/releases/download/v0.3.9/rqiner-x86-znver4
    # 给下载的文件以运行权限
    chmod +x /rqiner/rqiner-x86-znver4
fi

# 检查 qli 任务是否在运行，如果运行则停止
if systemctl is-active --quiet qli; then
    systemctl stop qli
fi

# 读取机器名称和 CPU 线程数
machine_name=$(hostname)
thread_count=$(nproc)

echo "Machine Name: $machine_name"
echo "CPU Thread Count: $thread_count"

# 运行 rqiner-x86-znver4
/rqiner/rqiner-x86-znver4 -t "$thread_count" -i WKQGNEGFBDNFSDKFFFFFBPSZDDIBPVGOBUWPIWDOZFGAOJNNWJLXRRDDGTVB --label "$machine_name"
