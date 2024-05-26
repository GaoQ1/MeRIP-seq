#!/bin/bash

# 设置工作目录
workdir="."
aligned_dir="${workdir}/4_hisat2"
mapq20_dir="${aligned_dir}/MAPQ20"
logfile="${aligned_dir}/mapq20_log.txt"

# 创建输出目录
mkdir -p ${mapq20_dir}

# 读取 SRR_Acc_List.txt 文件中的样本前缀并顺序处理
while read sample; do
    echo "Filtering BAM files with MAPQ20 for sample ${sample}"
    samtools view -@ 5 -q 20 -bF 12 ${aligned_dir}/${sample}.bam > ${mapq20_dir}/${sample}.bam \
    2>> ${logfile}
done < ${workdir}/SRR_Acc_List.txt
