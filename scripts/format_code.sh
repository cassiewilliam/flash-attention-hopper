#!/bin/bash

# 默认设置
directory="."
file_extensions=("*.c" "*.cpp" "*.h" "*.hpp")
exclude_dir="3rdparty"

# 解析命令行参数
while getopts "d:e:x:" opt; do
    case "$opt" in
        d) directory="$OPTARG" ;;
        e) IFS=',' read -r -a file_extensions <<< "$OPTARG" ;;
        x) exclude_dir="$OPTARG" ;;
        *) echo "Usage: $0 [-d directory] [-e file_extensions] [-x exclude_dir]" ; exit 1 ;;
    esac
done

# 查找并格式化文件
for ext in "${file_extensions[@]}"; do
    find "$directory" -name "$ext" ! -path "*/$exclude_dir/*" | while read -r file; do
        echo "Formatting $file"
        clang-format -i "$file"
    done
done

echo "Code formatting completed."
