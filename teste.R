
# Load all packages
packages_activate <- function() {
  library(diann) # to extract the MaxLFQ matrix from DIANN report
  library(arrow) # to read the report.parquet file
  library(here) # to avoid the need for use the path while loading the data
  library(tidyverse) # to do the data wrangling, plots, etc...
  library(janitor) # to clean the column names
  library(ggpointdensity) # to reconstruct the m/z density map
  library(naniar) # for sparsity analysis
  library(factoextra) # to plot the PCA
  library(patchwork) # to combine plots
  library(lsa) # to calculate the cosine similarity
  library(ggvenn) # to plot the Venn diagram
  library(paletteer) # to use the nice color palette
  library(ggtext) # to provide Markdown and HTML formatting in ggplot2
  library(ggrepel) # to avoid the overlapping of the labels in the plots
  library(kableExtra) # to format the tables
  library(limma)  # to calculate the differential abundance
  library(DIAgui) # to extract iBAQ values
  
  cat("All the necessary packages were activated.")
}

# Helper functions

# Return a dataset with the coefficients of variation
cv_matrix <- function(data, condition) {
  
  df <- as.data.frame(data)
  
  selected <- dplyr::select(df,
                            protein,
                            str_subset(colnames(data), condition))
  
  selected_rowwise <- rowwise(selected)
  
  mutated <- dplyr::mutate(selected_rowwise,
                           across(where(is.numeric),~2^(.) - 1),
                           cv = 100 * 
                            (
                              sd(c_across(where(is.numeric)),na.rm = TRUE) /
                              mean(c_across(where(is.numeric)),na.rm = TRUE)
                            ),
                           condition = condition)
  
  
  #TODO: Não dá pra usar o apply (protein_missingness) ao invés de usar o rowwise + mutate + select?
  
  return(
    dplyr::select(mutated,
                  protein,
                  cv,
                  condition)
    )
}

# Return a dataset without lines with a missingness above a threhold
protein_missingness <- function(data, threhold) {
  
  df <- as.data.frame(data)
 
  # Add the mean of missingness (NA) per line
  missingness = dplyr::mutate(df,
                              prot_miss = apply(df, 1, mean(df))
                              )
   
  dplyr::filter(prot_miss)
  
}











# adjust the general theme for the plots
# theme_update(
#   text = element_text(color = "black", size = 20),
#   axis.text = element_text(color = "black"),
#   axis.title = element_text(color = "black", face = "bold"),
#   strip.background = element_blank(),
#   strip.text = element_text(face = "bold"),
#   legend.title = element_text(face = "bold", hjust = 0.5),
#   legend.title.position = "top"
# )