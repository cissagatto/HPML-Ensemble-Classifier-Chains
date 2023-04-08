##############################################################################
# ECC                                                                        #
# Copyright (C) 2023                                                         #
#                                                                            #
# This code is free software: you can redistribute it and/or modify it under #
# the terms of the GNU General Public License as published by the Free       #
# Software Foundation, either version 3 of the License, or (at your option)  #
# any later version. This code is distributed in the hope that it will be    #
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty of     #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General   #
# Public License for more details.                                           #
#                                                                            #
# PhD Elaine Cecilia Gatto | Prof. Dr. Ricardo Cerri | Prof. Dr. Mauri       #
# Ferrandin | Prof. Dr. Celine Vens | PhD Felipe Nakano Kenji                #
#                                                                            #
# Federal University of São Carlos - UFSCar - https://www2.ufscar.br         #
# Campus São Carlos - Computer Department - DC - https://site.dc.ufscar.br   #
# Post Graduate Program in Computer Science - PPGCC                          # 
# http://ppgcc.dc.ufscar.br - Bioinformatics and Machine Learning Group      #
# BIOMAL - http://www.biomal.ufscar.br                                       #
#                                                                            #
# Katholieke Universiteit Leuven Campus Kulak Kortrijk Belgium               #
# Medicine Department - https://kulak.kuleuven.be/                           #
# https://kulak.kuleuven.be/nl/over_kulak/faculteiten/geneeskunde            #
#                                                                            #
##############################################################################



###############################################################################
# SET WORKSAPCE                                                               #
###############################################################################
FolderRoot = "~/Ensemble-Classifier-Chains"
FolderScripts = "~/Ensemble-Classifier-Chains/R"



###########################################################################
# Runs for all datasets listed in the "datasets.csv" file                                        #
# n_dataset: number of the dataset in the "datasets.csv"                                         #
# number_cores: number of cores to paralell                                                      #
# number_folds: number of folds for cross validation                                             # 
# delete: if you want, or not, to delete all folders and files generated                         #
######################################################################
run.ecc.python <- function(parameters){
  
  setwd(FolderScripts)
  source("ecc-python.R")
  
  if(parameters$Config.File$Number.Cores == 0){
    
    cat("\n\n##########################################################")
    cat("\n# Zero is a disallowed value for number_cores. Please      #")
    cat("\n# choose a value greater than or equal to 1.               #")
    cat("\n############################################################\n\n")
    
  } else {
    
    cl <- parallel::makeCluster(parameters$Config.File$Number.Cores)
    doParallel::registerDoParallel(cl)
    print(cl)
    
    if(parameters$Config.File$Number.Cores==1){
      cat("\n\n########################################################")
      cat("\n# Running Sequentially!                                #")
      cat("\n########################################################\n\n")
    } else {
      cat("\n\n############################################################")
      cat("\n# Running in parallel with ", parameters$Config.File$Number.Cores, " cores! #")
      cat("\n############################################################\n\n")
    }
  }
  
  
  cl = cl
  
  retorno = list()
  
  cat("\n\n##################################################")
  cat("\n# RUN: Names Labels                              #")
  cat("\n##################################################\n\n")
  name.file = paste(parameters$Directories$folderNamesLabels, "/",
                    parameters$Config.File$Dataset.Name,
                    "-NamesLabels.csv", sep="")
  labels.names = data.frame(read.csv(name.file))
  names(labels.names) = c("Index", "Labels")
  parameters$Names.Labels = labels.names
  
  
  cat("\n\n###################################################")
  cat("\n# RUN: Execute ECC ecc                            #")
  cat("\n###################################################\n\n")
  time.execute = system.time(execute.ecc.python(parameters))
  
  
  cat("\n\n############################################################")
  cat("\n# RUN: Evaluate                                              #")
  cat("\n##############################################################\n\n")
  time.evaluate = system.time(evaluate.ecc.python(parameters))
  
  
  cat("\n\n############################################################")
  cat("\n# RUN: Gather Evaluated Measures                             #")
  cat("\n##############################################################\n\n")
  time.gather.evaluate = system.time(gather.eval.ecc.python(parameters))
  
  
  cat("\n\n############################################################")
  cat("\n# RUN: Save Runtime                                          #")
  cat("\n##############################################################\n\n")
  RunTimeecc = rbind(time.execute, time.evaluate, time.gather.evaluate)
  setwd(diretorios$folderECC)
  write.csv(RunTimeecc, paste(dataset_name, "-Run-RunTime-.csv", sep=""))
  
  
  cat("\n\n############################################################")
  cat("\n# RUN: Stop Parallel                                         #")
  cat("\n##############################################################\n\n")
  parallel::stopCluster(cl) 	
  
}


##################################################################################################
# Please, any errors, contact us: elainececiliagatto@gmail.com                                   #
# Thank you very much!                                                                           #
##################################################################################################
