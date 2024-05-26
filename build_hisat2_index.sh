wget https://ftp.ensembl.org/pub/release-111/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa.gz

gunzip -c  Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa.gz  >Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa

hisat2-build Homo_sapiens.GRCh38.dna_sm.primary_assembly.fa hisat2_GRCh38_111