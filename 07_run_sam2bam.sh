#!/bin/bash

# 设置工作目录
workdir="."
aligned_dir="${workdir}/4_hisat2"
logfile="${aligned_dir}/sam2bam_log.txt"

# 读取 SRR_Acc_List.txt 文件中的样本前缀并顺序处理
while read sample; do
    echo "Converting SAM to BAM and sorting for sample ${sample}"
    samtools view -bS -@ 10 ${aligned_dir}/${sample}.sam | samtools sort -@ 10 -o ${aligned_dir}/${sample}.bam \
    2>> ${logfile}
done < ${workdir}/SRR_Acc_List.txt
