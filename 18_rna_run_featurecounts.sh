#!/bin/bash

# 设置工作目录
workdir="."
bam_dir="${workdir}/4_hisat2/MAPQ20"
output_dir="${workdir}/7_featurecounts_rna"
gtf_file="${workdir}/gene_gtf/Homo_sapiens.GRCh38.111.chr.gtf"
logfile="${output_dir}/featurecounts_log.txt"


# 创建输出目录
mkdir -p ${output_dir}

# 运行featureCounts
echo "Running featureCounts for RNA-seq data..."
featureCounts -T 20 -s 2 -p -a ${gtf_file} -t exon -o ${output_dir}/gene_exon_counts.txt ${bam_dir}/*.bam >> ${logfile} 2>&1

echo "featureCounts completed. Output written to ${output_dir}/gene_exon_counts.txt"
