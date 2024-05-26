#!/bin/bash

# 设置工作目录
workdir="."
saf_dir="${workdir}/6_macs2_callpeak/saf_files"
bam_dir="${workdir}/4_hisat2/MAPQ20/split"
output_dir="${workdir}/7_featurecounts"
logfile="${output_dir}/featurecounts_log.txt"

# 创建输出目录
mkdir -p ${output_dir}

# 获取所有SAF文件
saf_files=$(ls ${saf_dir}/*.saf)

# 运行featureCounts
for saf_file in ${saf_files}; do
    base_name=$(basename ${saf_file} .saf)

    # 提取样本名称和方向信息
    sample_name=$(echo ${base_name} | sed -E 's/(-IP_fwd_peaks_peaks|-IP_rev_peaks_peaks)//')
    direction=$(echo ${base_name} | grep -oE 'fwd|rev')

    # 定义BAM文件路径
    ip_bam=${bam_dir}/${sample_name}-IP.${direction}.bam
    input_bam=${bam_dir}/${sample_name}-input.${direction}.bam

    echo "sample name is ${sample_name}"
    echo "ip_bam is ${ip_bam}"
    echo "input_bam is ${input_bam}"

    if [[ -f ${ip_bam} && -f ${input_bam} ]]; then
        echo "Running featureCounts for ${base_name} with ${ip_bam} and ${input_bam}..."

        featureCounts -T 20 -s 2 -p -F SAF -a ${saf_file} -o ${output_dir}/${base_name}_featurecounts.txt ${ip_bam} ${input_bam} >> ${logfile} 2>&1
    else
        echo "Missing BAM files for ${base_name}" >> ${logfile}
    fi
done

echo "featureCounts completed. Output written to ${output_dir}"
