rm(list=ls())

##############################################################################
# Ensemble of classifier chains                                              #
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
FolderJob = paste(FolderRoot, "/jobs", sep = "")
if (dir.exists(FolderJob) == FALSE) {dir.create(FolderJob)}

FolderCF = "/Ensemble-Classifier-Chains/config-files-apptainer"


###############################################################################
# QUAL PACOTE USAR
###############################################################################
pacote = c("rf")


###############################################################################
# CREATING CONFIG FILES FOR EACH DATASET                                      #
###############################################################################
w = 1
while(w<=length(pacote)){
  
  FolderPa = paste(FolderJob, "/", pacote[w], sep="")
  if(dir.exists(FolderPa)==FALSE){dir.create(FolderPa)}
  
  FolderCa = paste(FolderCF, "/", pacote[w], sep="")
  
  cat("\n================================================")
  cat("\nPackage: \t", pacote[w])
  
  a = 1
  i = 1
  while (i <= n) {
    
    # select the specific dataset
    dataset = datasets[i, ]
    
    # print dataset name
    cat("\n\t", dataset$Name)
    
    # name 
    name = paste("ecc-", dataset$Name, sep="")
    
    # directory name - "/scratch/eg-3s-bbc1000"
    temp.name = paste("/tmp/", name, sep = "")
    
    # Confi File Name - "eg-3s-bbc1000.csv"
    config.file.name = paste(FolderCa, "/", name, ".csv", sep="")
    
    # sh file name - "~/Ensemble-Classifier-Chains/jobs/utiml/eg-3s-bbc1000.sh
    sh.name = paste(FolderPa, "/", name, ".sh", sep = "")
    
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
    write("#SBATCH --mem=0", file = output.file, append = TRUE)
    
    # amount of node memory you want to use
    # comment this line if you are using -mem=0
    # write("#SBATCH --mem-per-cpu=30GB", file = output.file, append = TRUE)
    # write("#SBATCH -mem=0", file = output.file, append = TRUE)
    
    # email to receive notification
    write("#SBATCH --mail-user=elainegatto@estudante.ufscar.br",
          file = output.file, append = TRUE)
    
    # type of notification
    write("#SBATCH --mail-type=ALL", file = output.file, append = TRUE)
    write("", file = output.file, append = TRUE)
    
    # FUNCTION TO CLEAN THE JOB
    str.2 = paste("local_job=",  "\"", temp.name, "\"", sep = "")
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
    str.5 = paste("echo SBATCH: RUNNING ECC FOR ",
                  name, sep="")
    write(str.5, file = output.file, append = TRUE)
    write("echo =============================================================", 
          file = output.file, append = TRUE)
    
    
    # write("", file = output.file, append = TRUE)
    # write("echo COPYING CONDA ENVIRONMENT", file = output.file, append = TRUE)
    # str.8 = paste("cp /home/u704616/miniconda3.tar.gz ", folder_name, sep ="")
    # write(str.8 , file = output.file, append = TRUE)
    
    
    # write(" ", file = output.file, append = TRUE)
    # write("echo UNPACKING MINICONDA", file = output.file, append = TRUE)
    # str.9 = paste("tar xzf ", folder_name, "/miniconda3.tar.gz -C ", 
    #               folder_name, sep = "")
    # write(str.9 , file = output.file, append = TRUE)
    
    
    # write(" ", file = output.file, append = TRUE)
    # write("echo DELETING MINICONDA TAR.GZ", file = output.file, append = TRUE)
    # str.10 = paste("rm -rf ", folder_name, "/miniconda3.tar.gz", sep = "")
    # write(str.10, file = output.file, append = TRUE)
    
    
    # write(" ", file = output.file, append = TRUE)
    # write("echo SOURCE", file = output.file, append = TRUE)
    # str.11 = paste("source ", folder_name,
    #               "/miniconda3/etc/profile.d/conda.sh ", sep = "")
    # write(str.11, file = output.file, append = TRUE)
    
    
    # write(" ", file = output.file, append = TRUE)
    # write("echo ACTIVATING MINICONDA ", file = output.file, append = TRUE)
    # write("conda activate AmbienteTeste", file = output.file, append = TRUE)
    # write(" ", file = output.file, append = TRUE)
    
    
    # write("echo RUNNING", file = output.file, append = TRUE)
    # str.12 = paste("Rscript /home/u704616/Global-ECC/R/global.R ", 
    #              config_name, sep = "")
    # write(str.12, file = output.file, append = TRUE)
    # write(" ", file = output.file, append = TRUE)
    
    
    write("", file = output.file, append = TRUE)
    write("echo DELETING FOLDER", file = output.file, append = TRUE)
    str.6 = paste("rm -rf ", temp.name, sep = "")
    write(str.6, file = output.file, append = TRUE)
    
    
    write("", file = output.file, append = TRUE)
    write("echo CREATING FOLDER", file = output.file, append = TRUE)
    str.7 = paste("mkdir ", temp.name, sep = "")
    write(str.7, file = output.file, append = TRUE)
    
    
    write("", file = output.file, append = TRUE)
    write("echo LISTING tmp", file = output.file, append = TRUE)
    write("cd /tmp", file = output.file, append = TRUE)
    write("ls ", file = output.file, append = TRUE)
    
    
    write("", file = output.file, append = TRUE)
    write("echo entrando na pasta", file = output.file, append = TRUE)
    str = paste("cd ", name, sep="")
    write(str, file = output.file, append = TRUE)
    
    
    write("", file = output.file, append = TRUE)
    write("echo LISTING tmp/NAME", file = output.file, append = TRUE)
    write("ls ", file = output.file, append = TRUE)
    
    
    write("", file = output.file, append = TRUE)
    write("echo COPYING SINGULARITY", file = output.file, append = TRUE)
    str.30 = paste("cp /home/u704616/Experimentos-8.sif ", temp.name, sep ="")
    write(str.30 , file = output.file, append = TRUE)
    
    
    write("", file = output.file, append = TRUE)
    write("echo CRIANDO TESTED", file = output.file, append = TRUE)
    str.29 = paste("mkdir ", temp.name, "/Ensemble-Classifier-Chains", sep="")
    write(str.29, file = output.file, append = TRUE)
    
    
    write("", file = output.file, append = TRUE)
    write("echo CRIANDO DATASET", file = output.file, append = TRUE)
    str.28 = paste("mkdir ", temp.name, "/Datasets", sep="")
    write(str.28, file = output.file, append = TRUE)
    
    
    write("", file = output.file, append = TRUE)
    write("echo CRIANDO Dataset", file = output.file, append = TRUE)
    str.26 = paste("mkdir ", temp.name, "/Datasets/", 
                   dataset$Name, sep="")
    write(str.26, file = output.file, append = TRUE)
    
    
    write("", file = output.file, append = TRUE)
    write("echo CRIANDO labelSpace", file = output.file, append = TRUE)
    str.25 = paste("mkdir ", temp.name, "/Datasets/", 
                   dataset$Name, "/LabelSpace", sep="")
    write(str.25, file = output.file, append = TRUE)
    
    write("", file = output.file, append = TRUE)
    write("echo CRIANDO properties", file = output.file, append = TRUE)
    str.40 = paste("mkdir ", temp.name, "/Datasets/", 
                   dataset$Name, "/Properties", sep="")
    write(str.40, file = output.file, append = TRUE)
    
    
    write("", file = output.file, append = TRUE)
    write("echo CRIANDO nameslabels", file = output.file, append = TRUE)
    str.24 = paste("mkdir ", temp.name, "/Datasets/", 
                   dataset$Name, "/NamesLabels", sep="")
    write(str.24, file = output.file, append = TRUE)
    
    
    write("", file = output.file, append = TRUE)
    write("echo CRIANDO CV", file = output.file, append = TRUE)
    str.23 = paste("mkdir ", temp.name, "/Datasets/", 
                   dataset$Name, "/CrosValidation", sep="")
    write(str.23, file = output.file, append = TRUE)
    
    
    write("", file = output.file, append = TRUE)
    write("echo CRIANDO CVTR", file = output.file, append = TRUE)
    str.21 = paste("mkdir ",temp.name, "/Datasets/", 
                   dataset$Name, "/CrosValidation/Tr", sep="")
    write(str.21, file = output.file, append = TRUE)
    
    
    write("", file = output.file, append = TRUE)
    write("echo CRIANDO CVTS", file = output.file, append = TRUE)
    str.20 = paste("mkdir ",temp.name, "/Datasets/", 
                   dataset$Name, "/CrosValidation/Ts", sep="")
    write(str.20, file = output.file, append = TRUE)
    
    
    write("", file = output.file, append = TRUE)
    write("echo CRIANDO CVVL", file = output.file, append = TRUE)
    str.19 = paste("mkdir ",temp.name, "/Datasets/", 
                   dataset$Name, "/CrosValidation/Vl", sep="")
    write(str.19, file = output.file, append = TRUE)
    
    
    write(" ", file = output.file, append = TRUE)
    write("echo INICIALIZANDO O SINGULARITY", file = output.file, append = TRUE)
    str = paste("singularity instance start --bind ~/.config/rclone/:/root/.config/rclone ", 
                temp.name, "/Experimentos-8.sif EXPEcc", a, sep="")
    write(str, file = output.file, append = TRUE)
    
    
    write(" ", file = output.file, append = TRUE)
    write("echo EXECUTANDO", file = output.file, append = TRUE)
    str = paste("singularity run --app Rscript instance://EXPEcc", a,
                " /Ensemble-Classifier-Chains/R/ecc.R \"",
                config.file.name, "\"", sep="")
    write(str, file = output.file, append = TRUE)
    
    
    write(" ", file = output.file, append = TRUE)
    write("echo STOP INSTANCIA", file = output.file, append = TRUE)
    str = paste("singularity instance stop EXPEcc", a, sep="")
    write(str,file = output.file, append = TRUE)
    
    
    write(" ", file = output.file, append = TRUE)
    write("echo DELETING JOB FOLDER", file = output.file, append = TRUE)
    str.13 = paste("rm -rf ", temp.name, sep = "")
    write(str.13, file = output.file, append = TRUE)
    
    
    write("", file = output.file, append = TRUE)
    write("echo ==================================", 
          file = output.file, append = TRUE)
    write("echo SBATCH: ENDED SUCCESSFULLY", file = output.file, append = TRUE)
    write("echo ==================================", 
          file = output.file, append = TRUE)
    
    close(output.file)
    
    a = a + 1
    i = i + 1
    gc()
  }
  w = w + 1
  gc()
}

cat("\n================================================")


###############################################################################
# Please, any errors, contact us: elainececiliagatto@gmail.com                #
# Thank you very much!                                                        #                                #
###############################################################################
