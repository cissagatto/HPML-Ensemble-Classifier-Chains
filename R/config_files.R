rm(list=ls())

###############################################################################
# Global Partitions with Ensemble of classifier chain                         #
# Copyright (C) 2022                                                          #
#                                                                             #
# This code is free software: you can redistribute it and/or modify it under  #
# the terms of the GNU General Public License as published by the Free        #
# Software Foundation, either version 3 of the License, or (at your option)   #
# any later version. This code is distributed in the hope that it will be     #
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty of      #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General    #
# Public License for more details.                                            #
#                                                                             #
# Elaine Cecilia Gatto | Prof. Dr. Ricardo Cerri | Prof. Dr. Mauri Ferrandin  #
# Federal University of Sao Carlos (UFSCar: https://www2.ufscar.br/) |        #
# Campus Sao Carlos | Computer Department (DC: https://site.dc.ufscar.br/)    #
# Program of Post Graduation in Computer Science                              #
# (PPG-CC: http://ppgcc.dc.ufscar.br/) | Bioinformatics and Machine Learning  #
# Group (BIOMAL: http://www.biomal.ufscar.br/)                                #                                                                                                #
###############################################################################


###############################################################################
# SET WORKSAPCE                                                               #
###############################################################################
FolderRoot = "~/Ensemble-Classifier-Chains"
FolderScripts = paste(FolderRoot, "/R", sep="")


###############################################################################
# LOAD LIBRARY/PACKAGE                                                        #
###############################################################################
library(stringr)


###############################################################################
# READING DATASET INFORMATION FROM DATASETS-ORIGINAL.CSV                      #
###############################################################################
setwd(FolderRoot)
datasets = data.frame(read.csv("datasets-original.csv"))
n = nrow(datasets)


###############################################################################
# CREATING FOLDER TO SAVE CONFIG FILES                                        #
###############################################################################
FolderCF = paste(FolderRoot, "/config-files", sep="")
if(dir.exists(FolderCF)==FALSE){dir.create(FolderCF)}


###############################################################################
# QUAL Implementation USAR
###############################################################################
# Implementation = c("utiml", "mulan", "python", "clus")
Implementation = c("python")
Implementation.2 = c("p")


###############################################################################
# CREATING CONFIG FILES FOR EACH DATASET                                      #
###############################################################################
w = 1
while(w<=length(Implementation)){
  
  FolderPa = paste(FolderCF, "/", Implementation[w], sep="")
  if(dir.exists(FolderPa)==FALSE){dir.create(FolderPa)}
  
  i = 1
  while(i<=n){
    
    # specific dataset
    ds = datasets[i,]
    
    # print the dataset name
    cat("\n================================================")
    cat("\n\tDataset:", ds$Name)
    cat("\n\tPackge:", Implementation[w])
    
    # Confi File Name
    # "~/Ensemble-Classifier-Chains/config-files/utiml/eg-3s-bbc1000.csv"
    file_name = paste(FolderPa, "/ecc", Implementation.2[w], "-",
                      ds$Name, ".csv", sep="")
    
    # Starts building the configuration file
    output.file <- file(file_name, "wb")
    
    # Config file table header
    write("Config, Value", file = output.file, append = TRUE)
    
    write("Dataset_Path, /Datasets", 
          file = output.file, append = TRUE)
    
    job_name = paste("ecc", Implementation.2[w], "-", 
                     ds$Name, sep = "")
    
    folder_name = paste("/scratch/", job_name, sep = "")
    
    
    str.0 = paste("Temporary_Path, ", folder_name, sep="")
    write(str.0,file = output.file, append = TRUE)
    
    # "implementation, utiml"
    str.1 = paste("Implementation, ", Implementation[w], sep="")
    write(str.1, file = output.file, append = TRUE)
    
    # "dataset_name, 3s-bbc1000"
    str.2 = paste("Dataset_Name, ", ds$Name, sep="")
    write(str.2, file = output.file, append = TRUE)
    
    # Dataset number according to "datasets-original.csv" file
    # "number_dataset, 1"
    str.3 = paste("Number_Dataset, ", ds$Id, sep="")
    write(str.3, file = output.file, append = TRUE)
    
    # Number used for X-Fold Cross-Validation
    write("Number_Folds, 10", file = output.file, append = TRUE)
    
    # Number of cores to use for parallel processing
    write("Number_Cores, 10", file = output.file, append = TRUE)
    
    # finish writing to the configuration file
    close(output.file)
    
    # increment
    i = i + 1
    
    # clean
    gc()
  }
  
  cat("\n================================================")
  w = w + 1
  gc()
}

###############################################################################
# Please, any errors, contact us: elainececiliagatto@gmail.com                #
# Thank you very much!                                                        #                                #
###############################################################################
