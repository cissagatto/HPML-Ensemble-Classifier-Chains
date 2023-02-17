##############################################################################
# BEST PARTITION SILHOUETTE ECC                                              #
# Copyright (C) 2022                                                         #
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
# Ferrandin | Federal University of Sao Carlos                               #
# (UFSCar: https://www2.ufscar.br/) Campus Sao Carlos | Computer Department  #
# (DC: https://site.dc.ufscar.br/) | Program of Post Graduation in Computer  #
# Science (PPG-CC: http://ppgcc.dc.ufscar.br/) | Bioinformatics and Machine  #
# Learning Group (BIOMAL: http://www.biomal.ufscar.br/)                      #
#                                                                            #
##############################################################################


###########################################################################
#
###########################################################################
FolderRoot = "~/Ensemble-Classifier-Chains"
FolderScripts = "~/Ensemble-Classifier-Chains/R"



######################################################################
# Load Packages    
######################################################################

library("foreign", quietly = TRUE)
library("stringr", quietly = TRUE)
# library("tidyverse", quietly = TRUE)
# library("lme4", quietly = TRUE)
# library("caret")
# library("lubridate", quietly = TRUE)
# library("dplyr", quietly = TRUE)
library("tidyverse")
library("parallel", quietly = TRUE)
library("rJava", quietly = TRUE)
library("RWeka", quietly = TRUE)
library("mldr", quietly = TRUE)
library("utiml", quietly = TRUE)
library("foreach", quietly = TRUE)
library("doParallel", quietly = TRUE)
library("caTools", quietly = TRUE)


#############################################################################
# Please, any errors, contact us: elainececiliagatto@gmail.com              #
# Thank you very much!                                                      #
#############################################################################
