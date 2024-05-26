import pandas as pd
import os
import subprocess

# 设置工作目录
workdir = "."
split_dir = os.path.join(workdir, "4_hisat2/MAPQ20/split")
output_dir = os.path.join(workdir, "7_featurecounts")

import code

# 读取featureCounts输出文件
featurecounts_files = [f for f in os.listdir(output_dir) if f.endswith("_featurecounts.txt")]

# 定义CPM计算函数
def calculate_cpm(counts, total_counts):
    """
    计算CPM值
    counts: DataFrame，包含每个基因的reads计数
    total_counts: Series，包含每个样本的总 reads 数
    """
    cpm = counts.div(total_counts, axis=1) * 1e6
    return cpm

# 获取每个样本的测序深度（总 reads 数）
def get_total_reads(bam_file):
    result = subprocess.run(['samtools', 'flagstat', bam_file], capture_output=True, text=True)
    for line in result.stdout.split('\n'):
        if 'mapped (' in line:
            return int(line.split(' ')[0])
    return 0

# 处理每个featureCounts输出文件
for file in featurecounts_files:
    filepath = os.path.join(output_dir, file)
    
    # 读取featureCounts输出文件
    df = pd.read_csv(filepath, sep='\t', comment='#', header=0)
    
    # 提取gene_id和length列
    gene_lengths = df.set_index('Geneid')['Length'] / 1000  # 转换为kb
    
    # 提取每个样本的counts列
    counts = df.set_index('Geneid').iloc[:, 5:]  # 假设样本列从第6列开始
    
    # 计算每个样本的总 reads 数
    total_counts = pd.Series({bam_file: get_total_reads(os.path.join(bam_file))
                              for bam_file in counts.columns})
    
    # 计算CPM
    cpm = calculate_cpm(counts, total_counts)
    
    # 保存CPM结果
    output_cpm_file = os.path.join(output_dir, file.replace("_featurecounts.txt", "_cpm.txt"))
    
    cpm.to_csv(output_cpm_file, sep='\t')
    
    print(f"CPM计算完成，结果保存在: {output_cpm_file}")
