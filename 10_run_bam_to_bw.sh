#!/bin/bash

# 初始化conda
source /home/colin/miniconda3/etc/profile.d/conda.sh

# 激活指定的conda环境
conda activate dna

# 设置工作目录
workdir="."
mapq20_dir="${workdir}/4_hisat2/MAPQ20/split"
bw_dir="${workdir}/4_hisat2/MAPQ20/split/bw"
logfile="${bw_dir}/bamCoverage_log.txt"

# 创建输出目录
mkdir -p ${bw_dir}

# 读取 SRR_Acc_List.txt 文件中的样本前缀并顺序处理
while read sample; do
    echo "Converting BAM to BW for sample ${sample}"
    bamCoverage --normalizeUsing RPKM -b ${mapq20_dir}/${sample}.bam -o ${bw_dir}/${sample}.bw \
    2>> ${logfile}
done < ${workdir}/SRR_Acc_List.txt
