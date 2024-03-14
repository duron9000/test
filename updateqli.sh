#!/bin/bash

# 定义下载链接和文件名
DOWNLOAD_URL="https://dl.qubic.li/downloads/qli-Client-1.8.8-Linux-x64.tar.gz"
FILE_NAME="qli-Client-1.8.8-Linux-x64.tar.gz"
TEMP_DIR="/tmp"
INSTALL_DIR="/q"
CONFIG_RESET_COMMAND="reset"
UPDATE_COMMAND="update"

# 下载更新包并解压
function update_program {
    echo "Downloading and extracting update..."
    wget -O "$TEMP_DIR/$FILE_NAME" "$DOWNLOAD_URL"
    tar -xzf "$TEMP_DIR/$FILE_NAME" -C "$TEMP_DIR"
    echo "Update extracted."
}

# 停止服务
function stop_service {
    systemctl stop qli
}

# 拷贝更新文件
function copy_files {
    echo "Copying files to $INSTALL_DIR..."
    cp -r "$TEMP_DIR/qli-Client" "$INSTALL_DIR/"
    echo "Files copied."
}

# 启动服务
function start_service {
    systemctl start qli
}

# 重置配置
function reset_configuration {
    echo "Resetting configuration..."
    systemctl stop qli --no-block
    rm /q/*.lock
    rm /q/qli-runner
    find /q/. -maxdepth 1 -regextype posix-extended -regex '.*\.e[[:digit:]]+' -delete
    find /q/. -maxdepth 1 -regextype posix-extended -regex 'state\.[[:digit:]]+' -delete
    systemctl start qli --no-block
    echo "Configuration reset completed."
}

# 主函数
function main {
    echo "Choose an action:"
    echo "1. Update program"
    echo "2. Reset configuration"
    read -p "Enter your choice: " choice

    case $choice in
        1)
            update_program
            stop_service
            copy_files
            start_service
            ;;
        2)
            reset_configuration
            ;;
        *)
            echo "Invalid choice. Exiting."
            exit 1
            ;;
    esac
}

main
