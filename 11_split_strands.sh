#!/bin/bash

# 设置工作目录
workdir="."
mapq20_dir="${workdir}/4_hisat2/MAPQ20"
split_dir="${mapq20_dir}/split"
logfile="${split_dir}/split_log.txt"

# 创建输出目录
mkdir -p ${split_dir}

# 读取 SRR_Acc_List.txt 文件中的样本前缀并顺序处理
while read sample; do
    echo "Splitting BAM file for sample ${sample}"

    # 负链处理
    samtools view -@ 10 -b -f 147 ${mapq20_dir}/${sample}.bam > ${split_dir}/${sample}.rev1.bam 2>> ${logfile}
    samtools view -@ 10 -b -f 99 ${mapq20_dir}/${sample}.bam > ${split_dir}/${sample}.rev2.bam 2>> ${logfile}
    samtools merge -@ 10 -f ${split_dir}/${sample}.rev.bam ${split_dir}/${sample}.rev1.bam ${split_dir}/${sample}.rev2.bam 2>> ${logfile}
    samtools index -@ 10 ${split_dir}/${sample}.rev.bam 2>> ${logfile}

    # 正链处理
    samtools view -@ 20 -b -f 83 ${mapq20_dir}/${sample}.bam > ${split_dir}/${sample}.fwd1.bam 2>> ${logfile}
    samtools view -@ 20 -b -f 163 ${mapq20_dir}/${sample}.bam > ${split_dir}/${sample}.fwd2.bam 2>> ${logfile}
    samtools merge -@ 20 -f ${split_dir}/${sample}.fwd.bam ${split_dir}/${sample}.fwd1.bam ${split_dir}/${sample}.fwd2.bam 2>> ${logfile}
    samtools index -@ 20 ${split_dir}/${sample}.fwd.bam 2>> ${logfile}

    # 清理临时文件
    rm -f ${split_dir}/${sample}.rev1.bam ${split_dir}/${sample}.rev2.bam ${split_dir}/${sample}.fwd1.bam ${split_dir}/${sample}.fwd2.bam 2>> ${logfile}
done < ${workdir}/SRR_Acc_List.txt
