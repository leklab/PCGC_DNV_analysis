library(dplyr)

input_file <- './pcgc_dnv_pcgc1_16__n24140_GRCh38.tsv'
output_file <- './pcgc_dnv_pcgc1_16_n24140_GRCh38_cleanup_AC4.tsv'

dnv <- read.delim(input_file, header = T, fill = T)

dnv$alleles <- gsub('"', "", dnv$alleles)

### Function to remove DNVs if probands have more than one DNV in a gene
remove_duplicate_samples <- function(df) {
  df_counts <- df %>%
    group_by(gene, id) %>%
    summarise(count = n())
  df_filtered <- df %>%
    left_join(df_counts, by = c("gene", "id")) %>%
    filter(is.na(count) | count == 1) %>%
    select(-count)
  
  return(df_filtered)
}

dnv <- remove_duplicate_samples(dnv)

### Remove by in-cohort allele frequency ###
counts_df <- dnv %>% 
  group_by(locus, alleles) %>% 
  summarise(count = n())

dnv <- dnv %>% 
  left_join(counts_df, by = c("locus", "alleles")) %>% 
  filter(is.na(count) | count <= 4) %>% 
  select(-count)

### Remove if reads supporting alt allele <= 5 ###
dnv <- dnv[dnv$proband_n_alt > 5,]

### Remove outlier samples high with DNVs ###
counts_df <- as.data.frame(table(dnv$id))
colnames(counts_df) <- c("id", "count")
ids_to_remove <- counts_df[counts_df$count > 100, "id"]
cat("Number of IDs with counts > 100:", length(ids_to_remove), "\n")
dnv <- dnv[!dnv$id %in% ids_to_remove, ]

### Write table to output ###
write.table(dnv, file=output_file, quote=FALSE, sep='\t',row.names=F)
