#!/bin/bash

# 设置工作目录
workdir="."
fastqdir="${workdir}/fastq"
outputdir="${workdir}/2_trimmed_data"
logfile="${outputdir}/trim_galore_log.txt"

# 创建输出目录
mkdir -p ${outputdir}

# 读取 SRR_Acc_List.txt 文件中的样本前缀并顺序处理
while read sample; do
    echo "Processing sample ${sample}"
    trim_galore -q 20 -j 8 --clip_R2 10 --three_prime_clip_R1 10 --clip_R1 10 --three_prime_clip_R2 10 --phred33 --illumina --stringency 3 --paired --length 36 -e 0.1 \
        ${fastqdir}/${sample}_1.fastq.gz ${fastqdir}/${sample}_2.fastq.gz \
        --gzip --fastqc -o ${outputdir} \
        >> ${logfile} 2>&1 &
done < ${workdir}/SRR_Acc_List.txt

# 等待所有后台任务完成
wait
