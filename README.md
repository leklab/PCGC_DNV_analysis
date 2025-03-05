# PCGC de novo calling in Hail

## Overview
This analysis is based on the latest VCF from Steve D. Palma (`pcgc-exomes-n24140.hg38.unannot.vcf.gz`), containing **24,140 samples**. The goal is to perform **de novo variant calling** using **Hail** and apply further **quality control filtering**.

## Scripts
The analysis consists of two main scripts:

1. **`pcgc_data_freeze_2024_n24140_Ken.ipynb`** (Jupyter Notebook)  
   - This script is written in **Python** and utilizes **Hail**.  
   - It reads in the VCF, performs **de novo calling**, and applies initial filtering.  
   - Key line to import the VCF:
     
     ```python
     mt = hl.import_vcf(vcf, force_bgz=True, reference_genome='GRCh38', contig_recoding=recode, array_elements_required=False)
     ```

2. **`dnv_cleanup_Ken.R`** (R script)  
   - This script reads the output of the previous step and applies further **QC filtering**.  
   - The filtering criteria are preliminary and will be refined to **maximize discovery**.

## Next Steps
- Further refinements of filtering criteria.  
- Additional downstream analyses and validations.  
