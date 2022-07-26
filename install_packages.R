inst_pack <- function(pkg){
new.pkg <- pkg[!(pkg %in% installed.packages()[, 'Package'])]
  if (length(new.pkg)) 
    install.packages(new.pkg,  repo = 'https://cran.rstudio.com', dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}

packages <- c('devtools', 'reticulate')
inst_pack(packages)

devtools::install_github("AlexandrovLab/SigProfilerMatrixGeneratorR")
