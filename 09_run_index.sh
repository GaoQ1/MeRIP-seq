#!/bin/bash

# 设置工作目录
workdir="."
mapq20_dir="${workdir}/4_hisat2/MAPQ20"
logfile="${mapq20_dir}/index_log.txt"

# 读取 SRR_Acc_List.txt 文件中的样本前缀并顺序处理
while read sample; do
    echo "Indexing BAM file for sample ${sample}"
    samtools index -@ 10 ${mapq20_dir}/${sample}.bam \
    2>> ${logfile}
done < ${workdir}/SRR_Acc_List.txt
