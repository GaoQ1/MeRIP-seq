#!/bin/bash

# 初始化conda
source /home/colin/miniconda3/etc/profile.d/conda.sh

# 激活指定的conda环境
conda activate dna

# 设置工作目录
workdir="."
split_dir="${workdir}/4_hisat2/MAPQ20/split"
peak_dir="${workdir}/6_macs2_callpeak/01_macs2_raw"
logfile="${peak_dir}/macs2_log.txt"
json_file="${workdir}/srr_gsm.json"

# 创建输出目录
mkdir -p ${peak_dir}

# 读取 json 文件
treats=()
controls=()
while IFS= read -r sample; do
    name=$(jq -r --arg srr "$sample" '.[$srr].name' ${json_file})
    if [[ $name == *"-IP" ]]; then
        treats+=("${name}")
    elif [[ $name == *"-input" ]]; then
        controls+=("${name}")
    fi
done < <(jq -r 'keys[]' ${json_file})

# MACS2 Peak Calling
for treat in "${treats[@]}"; do
    # 对应的 control 样本
    control=${treat/-IP/-input}

    if [ -f ${split_dir}/${treat}.fwd.bam ] && [ -f ${split_dir}/${control}.fwd.bam ]; then
        echo "Calling peaks for ${treat} with control ${control}"
        
        macs2 callpeak -t ${split_dir}/${treat}.fwd.bam -c ${split_dir}/${control}.fwd.bam -n ${treat}_fwd_peaks --bdg --SPMR --keep-dup 5 -q 0.01 -f BAM --verbose 3 --nomodel --extsize 150 -g 1.43e8 -B --outdir ${output_dir} 2> ${output_dir}/${treat}_fwd_peaks.macs.out
        
        macs2 callpeak -t ${split_dir}/${treat}.rev.bam -c ${split_dir}/${control}.rev.bam -n ${treat}_rev_peaks --bdg --SPMR --keep-dup 5 -q 0.01 -f BAM --verbose 3 --nomodel --extsize 150 -g 1.43e8 -B --outdir ${output_dir} 2> ${output_dir}/${treat}_rev_peaks.macs.out
    else
        echo "Missing files for ${treat} or ${control}" >> ${logfile}
    fi



done
