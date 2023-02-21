rm(list = ls())

##############################################################################
# TEST BEST HYBRID PARTITION                                                 #
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
# Elaine Cecilia Gatto | Prof. Dr. Ricardo Cerri | Prof. Dr. Mauri           #
# Ferrandin | Prof. Dr. Celine Vens | Dr. Felipe Nakano Kenji                #
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


##################################################
# SET WORK SPACE
##################################################
FolderRoot = "~/Ensemble-Classifier-Chains"
FolderScripts = "~/Ensemble-Classifier-Chains"

##################################################
# PACKAGES
##################################################
library(stringr)


##################################################
# DATASETS INFORMATION
##################################################
setwd(FolderRoot)
datasets = data.frame(read.csv("datasets-original.csv"))
n = nrow(datasets)


##################################################
# WHICH IMPLEMENTATION WILL BE USED?
##################################################
Implementation.1 = c("python", "clus")
Implementation.2 = c("p", "c")


######################################################
FolderJobs = paste(FolderRoot, "/jobs", sep="")
if(dir.exists(FolderJobs)==FALSE){dir.create(FolderJobs)}

FolderCF = paste(FolderRoot, "/config-files", sep="")
if(dir.exists(FolderCF)==FALSE){dir.create(FolderCF)}


# IMPLEMENTAÇÃO
p = 1
while(p<=length(Implementation.1)){
  
  FolderImplementation = paste(FolderJobs, "/", Implementation.1[p], sep="")
  if(dir.exists(FolderImplementation)==FALSE){dir.create(FolderImplementation)}
  
  FolderI = paste(FolderCF, "/", Implementation.1[p], sep="")
  
  # DATASET
  d = 1
  while(d<=nrow(datasets)){
    
    ds = datasets[d,]
    
    cat("\n\n=======================================")
    cat("\n", Implementation.1[p])
    cat("\n\t", ds$Name)
    
    name = paste("ecc", 
                 Implementation.2[p], "", 
                 ds$Name, sep="")  
    
    # directory name - "/scratch/eg-3s-bbc1000"
    scratch.name = paste("/scratch/", name, sep = "")
    
    # Confi File Name - "eg-3s-bbc1000.csv"
    config.file.name = paste(name, ".csv", sep="")
    
    # sh file name - "~/Global-Partitions/jobs/utiml/eg-3s-bbc1000.sh
    sh.name = paste(FolderImplementation, "/", name, ".sh", sep = "")
    
    # config file name - "~/Global-Partitions/config-files/utiml/eg-3s-bbc1000.csv"
    config.name = paste(FolderCF, "/", config.file.name, sep = "")
    
    # start writing
    output.file <- file(sh.name, "wb")
    
    # bash parameters
    write("#!/bin/bash", file = output.file)
    
    str.1 = paste("#SBATCH -J ", name, sep = "")
    write(str.1, file = output.file, append = TRUE)
    
    write("#SBATCH -o %j.out", file = output.file, append = TRUE)
    
    # number of processors
    write("#SBATCH -n 1", file = output.file, append = TRUE)
    
    # number of cores
    write("#SBATCH -c 10", file = output.file, append = TRUE)
    
    # uncomment this line if you are using slow partition
    # write("#SBATCH --partition slow", file = output.file, append = TRUE)
    
    # uncomment this line if you are using slow partition
    # write("#SBATCH -t 720:00:00", file = output.file, append = TRUE)
    
    # comment this line if you are using slow partition
    write("#SBATCH -t 128:00:00", file = output.file, append = TRUE)
    
    # uncomment this line if you need to use all node memory
    # write("#SBATCH --mem=0", file = output.file, append = TRUE)
    
    # amount of node memory you want to use
    # comment this line if you are using -mem=0
    write("#SBATCH --mem-per-cpu=30GB", file = output.file, append = TRUE)
    # write("#SBATCH -mem=0", file = output.file, append = TRUE)
    
    # email to receive notification
    write("#SBATCH --mail-user=elainegatto@estudante.ufscar.br",
          file = output.file, append = TRUE)
    
    # type of notification
    write("#SBATCH --mail-type=ALL", file = output.file, append = TRUE)
    write("", file = output.file, append = TRUE)
    
    # FUNCTION TO CLEAN THE JOB
    str.2 = paste("local_job=", scratch.name, sep = "")
    write(str.2, file = output.file, append = TRUE)
    
    write("function clean_job(){", file = output.file, append = TRUE)
    
    str.3 = paste(" echo", "\"CLEANING ENVIRONMENT...\"", sep = " ")
    write(str.3, file = output.file, append = TRUE)
    
    str.4 = paste(" rm -rf ", "\"${local_job}\"", sep = "")
    write(str.4, file = output.file, append = TRUE)
    
    write("}", file = output.file, append = TRUE)
    
    write("trap clean_job EXIT HUP INT TERM ERR", 
          file = output.file, append = TRUE)
    
    write("", file = output.file, append = TRUE)
    
    
    # MANDATORY PARAMETERS
    write("set -eE", file = output.file, append = TRUE)
    write("umask 077", file = output.file, append = TRUE)
    
    
    write("", file = output.file, append = TRUE)
    write("echo =============================================================", 
          file = output.file, append = TRUE)
    str.5 = paste("echo SBATCH: RUNNING TBHP FOR ", ds$Name, sep="")
    write(str.5, file = output.file, append = TRUE)
    write("echo =============================================================", 
          file = output.file, append = TRUE)
    
    
    write("", file = output.file, append = TRUE)
    write("echo DELETING FOLDER", file = output.file, append = TRUE)
    str.6 = paste("rm -rf ", scratch.name, sep = "")
    write(str.6, file = output.file, append = TRUE)
    
    
    write("", file = output.file, append = TRUE)
    write("echo CREATING FOLDER", file = output.file, append = TRUE)
    str.7 = paste("mkdir ", scratch.name, sep = "")
    write(str.7, file = output.file, append = TRUE)
    
    
    write("", file = output.file, append = TRUE)
    write("echo COPYING SINGULARITY", file = output.file, append = TRUE)
    str.30 = paste("cp /home/u704616/Experimentos.sif ", scratch.name, sep ="")
    write(str.30 , file = output.file, append = TRUE)
    
    
    write("", file = output.file, append = TRUE)
    write("echo listing", file = output.file, append = TRUE)
    str.8 = paste("ls /", scratch.name, sep ="")
    write(str.8, file = output.file, append = TRUE)
    
    
    write(" ", file = output.file, append = TRUE)
    write("echo SETANDO RCLONE", file = output.file, append = TRUE)
    write("singularity instance start --bind ~/.config/rclone/:/root/.config/rclone Experimentos.sif EXP", 
          file = output.file, append = TRUE)
    
    
    write(" ", file = output.file, append = TRUE)
    write("echo EXECUTANDO", file = output.file, append = TRUE)
    str = paste("singularity run --app Rscript instance://EXP /Ensemble-Classifier-Chains/R/start.R \"/Ensemble-Classifier-Chains/config-files/",
                config.file.name, "\"", sep="")
    write(str, file = output.file, append = TRUE)
    
    
    write(" ", file = output.file, append = TRUE)
    write("echo STOP INSTANCIA", file = output.file, append = TRUE)
    write("singularity instance stop EXP", 
          file = output.file, append = TRUE)
    
    
    write(" ", file = output.file, append = TRUE)
    write("echo DELETING JOB FOLDER", file = output.file, append = TRUE)
    str.13 = paste("rm -rf ", scratch.name, sep = "")
    write(str.13, file = output.file, append = TRUE)
    
    
    write("", file = output.file, append = TRUE)
    write("echo ==================================", 
          file = output.file, append = TRUE)
    write("echo SBATCH: ENDED SUCCESSFULLY", 
          file = output.file, append = TRUE)
    write("echo ==================================", 
          file = output.file, append = TRUE)
    
    close(output.file)
    
    d = d + 1
    gc()
  } # FIM DO DATASET
  
  
  
  p = p + 1
  gc()
} # FIM DA IMPLEMENTAÇÃO


###############################################################################
# Please, any errors, contact us: elainececiliagatto@gmail.com                #
# Thank you very much!                                                        #                                #
###############################################################################
