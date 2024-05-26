#!/bin/bash

# 设置工作目录
workdir="."
rrna_removed_dir="${workdir}/3_rRNA_removed"
aligned_dir="${workdir}/4_hisat2"
unmapped_dir="${aligned_dir}/unmapped"
summary_dir="${aligned_dir}/summary"
logfile="${aligned_dir}/hisat2_log.txt"
hisat2_index="${workdir}/hisat2_gene/hisat2_GRCh38_111"

# 创建输出目录
mkdir -p ${aligned_dir}
mkdir -p ${unmapped_dir}
mkdir -p ${summary_dir}

# 读取 SRR_Acc_List.txt 文件中的样本前缀并顺序处理
while read sample; do
    echo "Processing sample ${sample}"
    hisat2 -p 8 -k 30 --un-conc-gz ${unmapped_dir}/${sample}.fq.gz \
        --rna-strandness RF -x ${hisat2_index} --summary-file ${summary_dir}/${sample}.hg.summary \
        -1 ${rrna_removed_dir}/${sample}_rmrRNA.fq.1.gz -2 ${rrna_removed_dir}/${sample}_rmrRNA.fq.2.gz \
        -S ${aligned_dir}/${sample}.sam \
        2>> ${logfile} &
done < ${workdir}/SRR_Acc_List.txt

# 等待所有后台任务完成
wait
