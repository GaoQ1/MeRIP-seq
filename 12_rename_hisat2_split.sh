#!/bin/bash

# 设置工作目录
workdir="."
split_dir="${workdir}/4_hisat2/MAPQ20/split"
json_file="${workdir}/srr_gsm.json"

# 读取 json 文件并进行重命名
python3 - <<EOF
import os
import json

# 读取 JSON 文件
with open("${json_file}", 'r') as f:
    srr_gsm = json.load(f)

# 遍历 JSON 文件中的键值对
for srr, info in srr_gsm.items():
    name = info['name']
    for suffix in ['.rev.bam', '.fwd.bam', '.rev.bam.bai', '.fwd.bam.bai']:
        old_file = os.path.join("${split_dir}", srr + suffix)
        new_file = os.path.join("${split_dir}", name + suffix)
        if os.path.exists(old_file):
            print(f"Renaming {old_file} to {new_file}")
            os.rename(old_file, new_file)
        else:
            print(f"{old_file} does not exist.")
EOF
