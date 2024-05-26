import os
import pandas as pd
import code

def convert_narrowPeak_to_saf(peak_file, strand, output_file, append=False):
    peaks = pd.read_csv(peak_file, sep='\t', header=None)
    peaks['GeneID'] = peaks.index
    peaks['Chr'] = peaks[0]
    peaks['Start'] = peaks[1]
    peaks['End'] = peaks[2]
    peaks['signalvalue'] = peaks[6]
    peaks['PeakName'] = peaks[3]
    peaks['Strand'] = strand

    saf = peaks[['GeneID', 'Chr', 'Start', 'End', 'PeakName', 'Strand', 'signalvalue']]
    
    saf.to_csv(output_file, sep='\t', index=False)

# 设置工作目录
peak_dir = './6_macs2_callpeak/01_macs2_raw'
saf_dir = './6_macs2_callpeak/saf_files'
os.makedirs(saf_dir, exist_ok=True)


peak_files = [f for f in os.listdir(peak_dir) if f.endswith('.narrowPeak')]

for peak_file in peak_files:
    base_name = os.path.splitext(peak_file)[0]
    output_file = os.path.join(saf_dir, f"{base_name}.saf")
    
    if base_name.endswith("_fwd_peaks_peaks"):
        convert_narrowPeak_to_saf(os.path.join(peak_dir, peak_file), '+', output_file)
    else:
        convert_narrowPeak_to_saf(os.path.join(peak_dir, peak_file), '-', output_file)

