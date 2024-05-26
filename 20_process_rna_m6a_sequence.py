# %%
import pandas as pd
from tqdm import tqdm

# %%
m6a_merged_cpm_df = pd.read_csv('./7_featurecounts/BE2_merged_all.csv', sep='\t')
mane_gene_feature_df = pd.read_csv("./7_MANE_Gene_mRNA_feature_df.csv", sep=',')

# %%
# 初始化新的列
m6a_merged_cpm_df["Gene"] = None
m6a_merged_cpm_df["m6a_position"] = None

# 将Site列的字符串转为列表
m6a_merged_cpm_df['Site'] = m6a_merged_cpm_df['Site'].apply(eval)

# %%
# 遍历m6a_merged_cpm_df
for idx, row in tqdm(m6a_merged_cpm_df.iterrows()):
    gene_matches = []
    positions = []
    
    match = mane_gene_feature_df[
        (mane_gene_feature_df['Chr'] == row['Chr']) &
        (mane_gene_feature_df['Strand'] == row['Strand'])
    ]

    for site in row['Site']:

        for _, gene_row in match.iterrows():
            gene_start = gene_row['Start']
            gene_end = gene_row['End']

            if gene_start <= site <= gene_end:
                print(f"{site} is match")
                
                gene_matches.append(gene_row['Gene'])
                positions.append(site - gene_start)
                break
         
                
    if gene_matches:
        m6a_merged_cpm_df.at[idx, 'Gene'] = gene_matches[0]
        m6a_merged_cpm_df.at[idx, 'm6a_position'] = positions


# %%
m6a_merged_cpm_df.to_csv("./data/merge_m6a_mane_gene.csv")

# %%



