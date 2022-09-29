inst_pack <- function(pkg){
new.pkg <- pkg[!(pkg %in% installed.packages()[, 'Package'])]
  if (length(new.pkg)) 
    install.packages(new.pkg,  repo = 'https://cran.rstudio.com', dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}

packages <- c('devtools', 'reticulate')
inst_pack(packages)

devtools::install_github("AlexandrovLab/SigProfilerMatrixGeneratorR")

library("reticulate")
use_python("/opt/conda/bin/python")
py_install("numpy")
py_config()
system("pip install SigProfilerMatrixGenerator")
#SigProfilerMatrixGeneratorR::install('GRCm38.p6', rsync=FALSE, bash=TRUE)
