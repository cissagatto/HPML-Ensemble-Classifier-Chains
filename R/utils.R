###############################################################################
# ECC Partitions with Ensemble of classifier chain                         #
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
FolderScripts = "~/Ensemble-Classifier-Chains/R"


############################################################################
converteArff <- function(arg1, arg2, arg3, FolderUtils){  
  str = paste("java -jar ", FolderUtils,  "/R_csv_2_arff.jar ", 
              arg1, " ", arg2, " ", arg3, sep="")
  print(system(str))
  cat("\n\n")  
}


##################################################################################################
# FUNCTION DIRECTORIES                                                                           #
#   Objective:                                                                                   #
#      Creates all the necessary folders for the project. These are the main folders that must   # 
#      be created and used before the script starts to run                                       #  
#   Parameters:                                                                                  #
#      None                                                                                      #
#   Return:                                                                                      #
#      All path directories                                                                      #
##################################################################################################
directories <- function(dataset_name, folderResults){
  
  FolderRoot = "~/Ensemble-Classifier-Chains"
  FolderScripts = "~/Ensemble-Classifier-Chains/R"
  
  retorno = list()
  
  #############################################################################
  # RESULTS FOLDER:                                                           #
  # Parameter from command line. This folder will be delete at the end of the #
  # execution. Other folder is used to store definitely the results.          #
  # Example: "/dev/shm/result"; "/scratch/result"; "/tmp/result"              #
  #############################################################################
  if(dir.exists(folderResults) == TRUE){
    setwd(folderResults)
    dir_folderResults = dir(folderResults)
    n_folderResults = length(dir_folderResults)
  } else {
    dir.create(folderResults)
    setwd(folderResults)
    dir_folderResults = dir(folderResults)
    n_folderResults = length(dir_folderResults)
  }
  
  
  
  #############################################################################
  #
  #############################################################################
  folderUtils = paste(FolderRoot, "/Utils", sep="")
  if(dir.exists(folderUtils) == TRUE){
    setwd(folderUtils)
    dir_folderUtils = dir(folderUtils)
    n_folderUtils = length(dir_folderUtils)
  } else {
    dir.create(folderUtils)
    setwd(folderUtils)
    dir_folderUtils = dir(folderUtils)
    n_folderUtils = length(dir_folderUtils)
  }
  
  
  
  #############################################################################
  # VALIDATION FOLDER: "/dev/shm/results/Validation"                          #
  #         Folder that will temporarily store the files and folders needed   #
  #     for code processing in the validation phase                           #
  #############################################################################
  folderECC = paste(folderResults, "/ECC", sep="")
  if(dir.exists(folderECC) == TRUE){
    setwd(folderECC)
    dir_folderECC = dir(folderECC)
    n_folderECC = length(dir_folderECC)
  } else {
    dir.create(folderECC)
    setwd(folderECC)
    dir_folderECC = dir(folderECC)
    n_folderECC = length(dir_folderECC)
  }
  
  
  #############################################################################
  # DATASET FOLDER: "/dev/shm/results/Dataset"                                #
  #         Folder that will temporarily store the dataset files and folders  #
  #############################################################################
  folderDataset = paste(folderResults, "/Dataset", sep="")
  if(dir.exists(folderDataset) == TRUE){
    setwd(folderDataset)
    dir_folderDataset = dir(folderDataset)
    n_folderDataset = length(dir_folderDataset)
  } else {
    dir.create(folderDataset)
    setwd(folderDataset)
    dir_folderDataset = dir(folderDataset)
    n_folderDataset = length(dir_folderDataset)
  }
  
  
  #############################################################################
  # SPECIFIC DATASET FOLDER:                                                  #
  #         "/dev/shm/results/Dataset/GpositiveGO"                            #
  #         Folder that will temporarily store the dataset files and folders  #
  #############################################################################
  folderDatasetX = paste(folderDataset, "/", dataset_name, sep="")
  if(dir.exists(folderDatasetX) == TRUE){
    setwd(folderDatasetX)
    dir_folderDatasetX = dir(folderDatasetX)
    n_folderDatasetX = length(dir_folderDatasetX)
  } else {
    dir.create(folderDatasetX)
    setwd(folderDatasetX)
    dir_folderDatasetX = dir(folderDatasetX)
    n_folderDatasetX = length(dir_folderDatasetX)
  }
  
  #############################################################################
  # CROSS VALIDATION FOLDER:                                                  #
  #         "/dev/shm/results/Dataset/GpositiveGO/CrossValidation"            #
  #         Folder that will temporarily store the dataset files and folders  #
  #############################################################################
  folderCV = paste(folderDatasetX, "/CrossValidation", sep="")
  if(dir.exists(folderCV) == TRUE){
    setwd(folderCV)
    dir_folderCV = dir(folderCV)
    n_folderCV = length(dir_folderCV)
  } else {
    dir.create(folderCV)
    setwd(folderCV)
    dir_folderCV = dir(folderCV)
    n_folderCV = length(dir_folderCV)
  }
  
  #############################################################################
  # CROSS VALIDATION TRAIN FILES/FOLDER:                                      #
  #         "/dev/shm/results/Dataset/GpositiveGO/CrossValidation/Tr"         #
  #         Folder that will temporarily store the dataset files and folders  #
  #############################################################################
  folderCVTR = paste(folderCV, "/Tr", sep="")
  if(dir.exists(folderCVTR) == TRUE){
    setwd(folderCVTR)
    dir_folderCVTR = dir(folderCVTR)
    n_folderCVTR = length(dir_folderCVTR)
  } else {
    dir.create(folderCVTR)
    setwd(folderCVTR)
    dir_folderCVTR = dir(folderCVTR)
    n_folderCVTR = length(dir_folderCVTR)
  }
  
  #############################################################################
  # CROSS VALIDATION TEST FILES/FOLDER:                                       #
  #          "/dev/shm/results/Dataset/GpositiveGO/CrossValidation/Ts"        #
  #         Folder that will temporarily store the dataset files and folders  #
  #############################################################################
  folderCVTS = paste(folderCV, "/Ts", sep="")
  if(dir.exists(folderCVTS) == TRUE){
    setwd(folderCVTS)
    dir_folderCVTS = dir(folderCVTS)
    n_folderCVTS = length(dir_folderCVTS)
  } else {
    dir.create(folderCVTS)
    setwd(folderCVTS)
    dir_folderCVTS = dir(folderCVTS)
    n_folderCVTS = length(dir_folderCVTS)
  }
  
  #############################################################################
  # CROSS VALIDATION VALIDATION FILES/FOLDER:                                 #
  #         "/dev/shm/results/Dataset/GpositiveGO/CrossValidation/Vl"         #
  #         Folder that will temporarily store the dataset files and folders  #
  #############################################################################
  folderCVVL = paste(folderCV, "/Vl", sep="")
  if(dir.exists(folderCVVL) == TRUE){
    setwd(folderCVVL)
    dir_folderCVVL = dir(folderCVVL)
    n_folderCVVL = length(dir_folderCVVL)
  } else {
    dir.create(folderCVVL)
    setwd(folderCVVL)
    dir_folderCVVL = dir(folderCVVL)
    n_folderCVVL = length(dir_folderCVVL)
  }
  
  #############################################################################
  # CROSS VALIDATION LABEL SPACE FILES/FOLDER:                                #
  #         "/dev/shm/results/Dataset/GpositiveGO/LabelSpace"                 #
  #         Folder that will temporarily store the dataset files and folders  #
  #############################################################################
  folderLabelSpace = paste(folderDatasetX, "/LabelSpace", sep="")
  if(dir.exists(folderLabelSpace) == TRUE){
    setwd(folderLabelSpace)
    dir_folderLabelSpace = dir(folderLabelSpace)
    n_folderLabelSpace = length(dir_folderLabelSpace)
  } else {
    dir.create(folderLabelSpace)
    setwd(folderLabelSpace)
    dir_folderLabelSpace = dir(folderLabelSpace)
    n_folderLabelSpace = length(dir_folderLabelSpace)
  }
  
  #############################################################################
  # CROSS VALIDATION LABELS NAMES FILES/FOLDER:                               #
  #        "/dev/shm/results/Dataset/GpositiveGO/NamesLabels"                 #
  #         Folder that will temporarily store the dataset files and folders  #
  #############################################################################
  folderNamesLabels = paste(folderDatasetX, "/NamesLabels", sep="")
  if(dir.exists(folderNamesLabels) == TRUE){
    setwd(folderNamesLabels)
    dir_folderNamesLabels = dir(folderNamesLabels)
    n_folderNamesLabels = length(dir_folderNamesLabels)
  } else {
    dir.create(folderNamesLabels)
    setwd(folderNamesLabels)
    dir_folderNamesLabels = dir(folderNamesLabels)
    n_folderNamesLabels = length(dir_folderNamesLabels)
  }
  
  
  # return folders
  retorno$folderUtils = folderUtils
  retorno$folderECC = folderECC
  retorno$folderResults = folderResults
  retorno$folderDataset = folderDataset
  retorno$folderDatasetX = folderDatasetX
  retorno$folderCV = folderCV
  retorno$folderCVTR = folderCVTR
  retorno$folderCVTS = folderCVTS
  retorno$folderCVVL = folderCVVL
  retorno$folderLabelSpace = folderLabelSpace
  retorno$folderNamesLabels = folderNamesLabels
  
  # return folder contents
  retorno$dir_folderUtils = dir_folderUtils
  retorno$dir_folderECC = dir_folderECC
  retorno$dir_folderResults = dir_folderResults
  retorno$dir_folderDataset = dir_folderDataset
  retorno$dir_folderDatasetX = dir_folderDatasetX
  retorno$dir_folderCV = dir_folderCV
  retorno$dir_folderCVTR = dir_folderCVTR
  retorno$dir_folderCVTS = dir_folderCVTS
  retorno$dir_folderCVVL = dir_folderCVVL
  retorno$dir_folderLabelSpace = dir_folderLabelSpace
  retorno$dir_folderNamesLabels = dir_folderNamesLabels
  
  # return of the number of objects inside the folder
  retorno$n_folderUtils = n_folderUtils
  retorno$n_folderECC = n_folderECC
  retorno$n_folderResults = n_folderResults
  retorno$n_folderDataset = n_folderDataset
  retorno$n_folderDatasetX = n_folderDatasetX
  retorno$n_folderCV = n_folderCV
  retorno$n_folderCVTR = n_folderCVTR
  retorno$n_folderCVTS = n_folderCVTS
  retorno$n_folderCVVL = n_folderCVVL
  retorno$n_folderLabelSpace = n_folderLabelSpace
  retorno$n_folderNamesLabels = n_folderNamesLabels
  
  return(retorno)
  gc()
  
}



##################################################################################################
# FUNCTION INFO DATA SET                                                                         #
#  Objective                                                                                     #
#     Gets the information that is in the "datasets.csv" file.                                    #  
#  Parameters                                                                                    #
#     dataset: the specific dataset                                                              #
#  Return                                                                                        #
#     Everything in the spreadsheet                                                              #
##################################################################################################
infoDataSet <- function(dataset){
  retorno = list()
  retorno$id = dataset$ID
  retorno$name = dataset$Name
  retorno$instances = dataset$Instances
  retorno$inputs = dataset$Inputs
  retorno$labels = dataset$Labels
  retorno$LabelsSets = dataset$LabelsSets
  retorno$single = dataset$Single
  retorno$maxfreq = dataset$MaxFreq
  retorno$card = dataset$Card
  retorno$dens = dataset$Dens
  retorno$mean = dataset$Mean
  retorno$scumble = dataset$Scumble
  retorno$tcs = dataset$TCS
  retorno$attStart = dataset$AttStart
  retorno$attEnd = dataset$AttEnd
  retorno$labStart = dataset$LabelStart
  retorno$labEnd = dataset$LabelEnd
  return(retorno)
  gc()
}



roc.curva <- function(predictions, probabilities, test, Folder){
  
  #####################################################################
  y_pred2 = sapply(predictions, function(x) as.numeric(as.character(x)))
  res.pred = mldr_evaluate(test, y_pred2)
  
  #####################################################################
  y_proba2 = sapply(probabilities, function(x) as.numeric(as.character(x)))
  res.proba = mldr_evaluate(test, y_proba2)
  
  ###############################################################
  # PLOTANDO ROC CURVE
  name = paste(Folder, "/roc-bin.pdf", sep="")
  pdf(name, width = 10, height = 8)
  print(plot(res.pred$roc, print.thres = 'all', print.auc=TRUE, 
             print.thres.cex=0.7, grid = TRUE, identity=TRUE,
             axes = TRUE, legacy.axes = TRUE, 
             identity.col = "#a91e0e", col = "#1161d5",
             main = "binary predictions"))
  dev.off()
  cat("\n")
  
  ###############################################################
  # PLOTANDO ROC CURVE
  name = paste(Folder, "/roc-proba.pdf", sep="")
  pdf(name, width = 10, height = 8)
  print(plot(res.proba$roc, print.thres = 'best', print.auc=TRUE, 
             print.thres.cex=0.7, grid = TRUE, identity=TRUE,
             axes = TRUE, legacy.axes = TRUE, 
             identity.col = "#a91e0e", col = "#1161d5",
             main = "probabilities predictions"))
  dev.off()
  cat("\n")
  
  
  ###############################################################
  setwd(Folder)
  write.csv(as.numeric(res.pred$roc$auc), "bin-auc.csv")
  write.csv(as.numeric(res.pred$macro_auc), "bin-macro-auc.csv")
  write.csv(as.numeric(res.pred$micro_auc), "bin-micro-auc.csv")
  
  
  ###############################################################
  setwd(Folder)
  write.csv(as.numeric(res.proba$roc$auc), "proba-auc.csv")
  write.csv(as.numeric(res.proba$macro_auc), "proba-macro-auc.csv")
  write.csv(as.numeric(res.proba$micro_auc), "proba-micro-auc.csv")
  
  
  ###############################################################
  # SALVANDO AS INFORMAÇÕES DO ROC SEPARADAMENTE
  name = paste(Folder, "/roc-proba-1.txt", sep="")
  output.file <- file(name, "wb")
  
  write(" ", file = output.file, append = TRUE)
  write("percent: ", file = output.file, append = TRUE)
  write(res.proba$roc$percent, file = output.file, append = TRUE)
  
  write(" ", file = output.file, append = TRUE)
  write("sensitivities: ", file = output.file, append = TRUE)
  write(res.proba$roc$sensitivities, file = output.file, append = TRUE)
  
  write(" ", file = output.file, append = TRUE)
  write("specificities: ", file = output.file, append = TRUE)
  write(res.proba$roc$specificities, file = output.file, append = TRUE)
  
  write(" ", file = output.file, append = TRUE)
  write("thresholds: ", file = output.file, append = TRUE)
  write(res.proba$roc$thresholds, file = output.file, append = TRUE)
  
  write(" ", file = output.file, append = TRUE)
  write("direction: ", file = output.file, append = TRUE)
  write(res.proba$roc$direction, file = output.file, append = TRUE)
  
  write(" ", file = output.file, append = TRUE)
  write("cases: ", file = output.file, append = TRUE)
  write(res.proba$roc$cases, file = output.file, append = TRUE)
  
  write(" ", file = output.file, append = TRUE)
  write("controls: ", file = output.file, append = TRUE)
  write(res.proba$roc$controls, file = output.file, append = TRUE)
  
  write(" ", file = output.file, append = TRUE)
  write("auc: ", file = output.file, append = TRUE)
  write(res.proba$roc$auc, file = output.file, append = TRUE)
  
  write(" ", file = output.file, append = TRUE)
  write("original predictor: ", file = output.file, append = TRUE)
  write(res.proba$roc$original.predictor, file = output.file, append = TRUE)
  
  write(" ", file = output.file, append = TRUE)
  write("original response: ", file = output.file, append = TRUE)
  write(res.proba$roc$original.response, file = output.file, append = TRUE)
  
  write(" ", file = output.file, append = TRUE)
  write("predictor: ", file = output.file, append = TRUE)
  write(res.proba$roc$predictor, file = output.file, append = TRUE)
  
  write(" ", file = output.file, append = TRUE)
  write("response: ", file = output.file, append = TRUE)
  write(res.proba$roc$response, file = output.file, append = TRUE)
  
  write(" ", file = output.file, append = TRUE)
  write("levels: ", file = output.file, append = TRUE)
  write(res.proba$roc$levels, file = output.file, append = TRUE)
  
  close(output.file)
  
  ###############################################################
  # SALVANDO AS INFORMAÇÕES DO ROC SEPARADAMENTE
  name = paste(Folder, "/roc-bin-1.txt", sep="")
  output.file <- file(name, "wb")
  
  write(" ", file = output.file, append = TRUE)
  write("percent: ", file = output.file, append = TRUE)
  write(res.pred$roc$percent, file = output.file, append = TRUE)
  
  write(" ", file = output.file, append = TRUE)
  write("sensitivities: ", file = output.file, append = TRUE)
  write(res.pred$roc$sensitivities, file = output.file, append = TRUE)
  
  write(" ", file = output.file, append = TRUE)
  write("specificities: ", file = output.file, append = TRUE)
  write(res.pred$roc$specificities, file = output.file, append = TRUE)
  
  write(" ", file = output.file, append = TRUE)
  write("thresholds: ", file = output.file, append = TRUE)
  write(res.pred$roc$thresholds, file = output.file, append = TRUE)
  
  write(" ", file = output.file, append = TRUE)
  write("direction: ", file = output.file, append = TRUE)
  write(res.pred$roc$direction, file = output.file, append = TRUE)
  
  write(" ", file = output.file, append = TRUE)
  write("cases: ", file = output.file, append = TRUE)
  write(res.pred$roc$cases, file = output.file, append = TRUE)
  
  write(" ", file = output.file, append = TRUE)
  write("controls: ", file = output.file, append = TRUE)
  write(res.pred$roc$controls, file = output.file, append = TRUE)
  
  write(" ", file = output.file, append = TRUE)
  write("auc: ", file = output.file, append = TRUE)
  write(res.pred$roc$auc, file = output.file, append = TRUE)
  
  write(" ", file = output.file, append = TRUE)
  write("original predictor: ", file = output.file, append = TRUE)
  write(res.pred$roc$original.predictor, file = output.file, append = TRUE)
  
  write(" ", file = output.file, append = TRUE)
  write("original response: ", file = output.file, append = TRUE)
  write(res.pred$roc$original.response, file = output.file, append = TRUE)
  
  write(" ", file = output.file, append = TRUE)
  write("predictor: ", file = output.file, append = TRUE)
  write(res.pred$roc$predictor, file = output.file, append = TRUE)
  
  write(" ", file = output.file, append = TRUE)
  write("response: ", file = output.file, append = TRUE)
  write(res.pred$roc$response, file = output.file, append = TRUE)
  
  write(" ", file = output.file, append = TRUE)
  write("levels: ", file = output.file, append = TRUE)
  write(res.pred$roc$levels, file = output.file, append = TRUE)
  
  close(output.file)
  
  
  ###############################################################
  # SALVANDO AS OUTRAS INFORMAÇÕES
  name = paste(Folder, "/roc-pred-2.txt", sep="")
  sink(name, type = "output")
  print(res.pred$roc)
  cat("\n\n")
  str(res.pred)
  sink()
  
  
  ###############################################################
  # SALVANDO AS OUTRAS INFORMAÇÕES
  name = paste(Folder, "/roc-proba-2.txt", sep="")
  sink(name, type = "output")
  print(res.proba$roc)
  cat("\n\n")
  str(res.proba)
  sink()
}


predictions.information <- function(nomes.rotulos, 
                                    proba, 
                                    preds, 
                                    trues, 
                                    folder){
  
  #####################################################################
  pred.o = paste(colnames(preds), "-pred", sep="")
  names(preds) = pred.o
  
  true.labels = paste(colnames(trues), "-true", sep="")
  names(trues) = true.labels
  
  proba.n = paste(nomes.rotulos, "-proba", sep="")
  names(proba) = proba.n
  
  all.predictions = cbind(proba, preds, trues)
  setwd(folder)
  write.csv(all.predictions, "predictions.csv", row.names = FALSE)
  
  ###############################################
  bipartition = data.frame(trues, preds)
  
  # número de instâncias do conjunto
  num.instancias = nrow(bipartition)
  
  # número de rótulos do conjunto
  num.rotulos = ncol(trues)
  
  # número de instâncias positivas
  num.positive.instances = apply(bipartition, 2, sum)
  
  # número de instâncias negativas
  num.negative.instances = num.instancias - num.positive.instances 
  
  # salvando
  res = rbind(num.positive.instances, num.negative.instances)
  name = paste(folder, "/instances-pn.csv", sep="")
  write.csv(res, name)
  
  # calcular rótulo verdadeiro igual a 1
  true_1 = data.frame(ifelse(trues==1,1,0))
  total_true_1 = apply(true_1, 2, sum)
  
  # calcular rótulo verdadeiro igual a 0
  true_0 = data.frame(ifelse(trues==0,1,0))
  total_true_0 = apply(true_0, 2, sum)
  
  # calcular rótulo predito igual a 1
  pred_1 = data.frame(ifelse(preds==1,1,0))
  total_pred_1 = apply(pred_1, 2, sum)
  
  # calcular rótulo verdadeiro igual a 0
  pred_0 = data.frame(ifelse(preds==0,1,0))
  total_pred_0 = apply(pred_0, 2, sum)
  
  matriz_totais = cbind(total_true_0, total_true_1, total_pred_0, total_pred_1)
  row.names(matriz_totais) = nomes.rotulos
  name = paste(folder, "/trues-preds.csv", sep="")
  write.csv(matriz_totais, name)
  
  # Verdadeiro Positivo: O modelo previu 1 e a resposta correta é 1
  TPi  = data.frame(ifelse((true_1 & true_1),1,0))
  tpi = paste(nomes.rotulos, "-TP", sep="")
  names(TPi) = tpi
  
  # Verdadeiro Negativo: O modelo previu 0 e a resposta correta é 0
  TNi  = data.frame(ifelse((true_0 & pred_0),1,0))
  tni = paste(nomes.rotulos, "-TN", sep="")
  names(TNi) = tni
  
  # Falso Positivo: O modelo previu 1 e a resposta correta é 0
  FPi  = data.frame(ifelse((true_0 & pred_1),1,0))
  fpi = paste(nomes.rotulos, "-FP", sep="")
  names(FPi) = fpi
  
  # Falso Negativo: O modelo previu 0 e a resposta correta é 1
  FNi  = data.frame(ifelse((true_1 & pred_0),1,0))
  fni = paste(nomes.rotulos, "-FN", sep="")
  names(FNi) = fni
  
  fpnt = data.frame(TPi, FPi, FNi, TNi)
  name = paste(folder, "/tfpn.csv", sep="")
  write.csv(fpnt, name, row.names = FALSE)
  
  # total de verdadeiros positivos
  TPl = apply(TPi, 2, sum)
  tpl = paste(nomes.rotulos, "-TP", sep="")
  names(TPl) = tpl
  
  # total de verdadeiros negativos
  TNl = apply(TNi, 2, sum)
  tnl = paste(nomes.rotulos, "-TN", sep="")
  names(TNl) = tnl
  
  # total de falsos negativos
  FNl = apply(FNi, 2, sum)
  fnl = paste(nomes.rotulos, "-FN", sep="")
  names(FNl) = fnl
  
  # total de falsos positivos
  FPl = apply(FPi, 2, sum)
  fpl = paste(nomes.rotulos, "-FP", sep="")
  names(FPl) = fpl
  
  matriz_confusao_por_rotulos = data.frame(TPl, FPl, FNl, TNl)
  colnames(matriz_confusao_por_rotulos) = c("TP","FP", "FN", "TN")
  row.names(matriz_confusao_por_rotulos) = nomes.rotulos
  name = paste(folder, "/matrix-confusion-2.csv", sep="")
  write.csv(matriz_confusao_por_rotulos, name)
  
}


##################################################################################################
# Please, any errors, contact us: elainececiliagatto@gmail.com                                   #
# Thank you very much!                                                                           #
##################################################################################################
