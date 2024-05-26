#!/bin/bash

# 设置工作目录
workdir="."
trimmed_dir="${workdir}/2_trimmed_data"
rrna_removed_dir="${workdir}/3_rRNA_removed"
logfile="${rrna_removed_dir}/bowtie2_log.txt"
bowtie2_index="${workdir}/rRNA_index/rRNA/rRNA"

# 创建输出目录
mkdir -p ${rrna_removed_dir}
mkdir -p ${rrna_removed_dir}/rRNA_file

# 读取 SRR_Acc_List.txt 文件中的样本前缀并顺序处理
while read sample; do
    echo "Processing sample ${sample}"
    bowtie2 -p 15 -I 1 -X 1000 -x ${bowtie2_index} \
        --un-conc-gz ${rrna_removed_dir}/${sample}_rmrRNA.fq.gz \
        -1 ${trimmed_dir}/${sample}_1_val_1.fq.gz -2 ${trimmed_dir}/${sample}_2_val_2.fq.gz \
        -S ${rrna_removed_dir}/rRNA_file/${sample}_rRNA.sam \
        1>> ${logfile} 2>&1 &
done < ${workdir}/SRR_Acc_List.txt

# 等待所有后台任务完成
wait
