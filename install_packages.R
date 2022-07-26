inst_pack <- function(pkg){
new.pkg <- pkg[!(pkg %in% installed.packages()[, 'Package'])]
  if (length(new.pkg)) 
    install.packages(new.pkg,  repo = 'https://cran.rstudio.com', dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}

packages <- c('ggplot2', 'plyr', 'dplyr', 'data.table', 'reshape', 'RColorBrewer', 'reshape2', 
              'circlize', 'BiocManager', 'knitr', 'xtable', 'pheatmap', 'RColorBrewer', 
              'rmarkdown', 'reshape', 'gplots', 'devtools', 'reticulate')
inst_pack(packages)

devtools::install_github("AlexandrovLab/SigProfilerMatrixGeneratorR")

library("SigProfilerMatrixGeneratorR")
install('GRCh37', rsync=TRUE, bash=TRUE)
install('GRCm38.p6 ', rsync=TRUE, bash=TRUE)