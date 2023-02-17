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
FolderRoot = "~/Global-Partitions"
FolderScripts = "~/Global-Partitions/R"



##################################################################################################
# FUNCTION EXECUTE CLUS GLOBAL                                                                   #
#   Objective                                                                                    #
#       Tests global partitions                                                                  #
#   Parameters                                                                                   #
#       ds: specific dataset information                                                         #
#       dataset_name: dataset name. It is used to save files.                                    #
#       number_folds: number of folds created                                                    #
#       Folder: folder path                                                                      #
#   Return                                                                                       #
#       configurations files                                                                     #
##################################################################################################
execute.global.utiml <- function(ds, dataset_name, number_folds, 
                          number_cores, folderResults){
  
  # from fold = 1 to number_folds
    i = 1
    #clusGlobalParalel <- foreach(i = 1:number_folds) %dopar% {
    while(i<=number_folds){
      
      ####################################################################################
      FolderRoot = "~/Global-Partitions/"
      FolderScripts = paste(FolderRoot, "/R/", sep="")
      
      ####################################################################################
      setwd(FolderScripts)
      source("libraries.R")
      
      setwd(FolderScripts)
      source("utils.R")
      
      ####################################################################################
      diretorios = directories(dataset_name, folderResults)
      
      ####################################################################################
      cat("\nFold: ", i)
      
      ####################################################################################
      FolderSplit = paste(diretorios$folderGlobal, "/Split-", i, sep="")
      if(dir.create(FolderSplit)==FALSE){dir.create(FolderSplit)}
  
      ########################################################################################
      cat("\nOpen Train file ", i)
      setwd(diretorios$folderCVTR)
      nome_arq_tr = paste(dataset_name, "-Split-Tr-", i, ".csv", sep="")
      arquivo_tr = data.frame(read.csv(nome_arq_tr))
      
      #######################################################################################
      cat("\nOpen Validation file ", i)
      setwd(diretorios$folderCVVL)
      nome_arq_vl = paste(dataset_name, "-Split-Vl-", i, ".csv", sep="")
      arquivo_vl = data.frame(read.csv(nome_arq_vl))
      
      ########################################################################################
      cat("\nOpen Test file ", i)
      setwd(diretorios$folderCVTS)
      nome_arq_ts = paste(dataset_name, "-Split-Ts-", i, ".csv", sep="")
      arquivo_ts = data.frame(read.csv(nome_arq_ts))
      
      ###################################################
      arquivo_tr2 = rbind(arquivo_tr, arquivo_vl)
      
      # separando os rótulos verdadeiros
      y_true = arquivo_ts[,ds$LabelStart:ds$LabelEnd]
      
      # gerando indices
      number = seq(ds$LabelStart, ds$LabelEnd, by=1)
      
      # transformando treino em mldr
      ds_train = mldr_from_dataframe(arquivo_tr2, labelIndices = number)
      
      # transformando test em mldr
      ds_test = mldr_from_dataframe(arquivo_ts, labelIndices = number)
      
      # aplicando modelo br
      eccmodel = ecc(ds_train, "C5.0", seed=123, 
                     cores=number_cores, attr.space=1.0)
      
      # testando modelo br
      predict <- predict(eccmodel, ds_test, cores= number_cores)
      
      # Apply a threshold
      thresholds <- scut_threshold(predict, ds_test, cores = number_cores)
      new.test <- fixed_threshold(predict, thresholds)
      
      new.test2 = as.matrix(new.test)
      y_predict = data.frame(new.test2)
      
      setwd(FolderSplit)
      write.csv(y_predict, "y_predict.csv", row.names = FALSE)
      write.csv(y_true, "y_true.csv", row.names = FALSE)
      
      
      i =i + 1
      gc()
    }

  gc()
  cat("\n##################################################################################################")
  cat("\n# GLOBAL CLUS: END OF FUNCTION EXECUTE CLUS                                                      #") 
  cat("\n##################################################################################################")
  cat("\n\n\n\n")
}

##################################################################################################
# FUNCTION EVALUATE GENERAL                                                                      #
#   Objective:                                                                                   #
#       Evaluate Multilabel                                                                      #  
#   Parameters:                                                                                  #
#       ds: specific dataset information                                                         #
#       dataset_name: dataset name. It is used to save files.                                    #
#       number_folds: number of folds to be created                                              #
#       Folder: folder where the folds are                                                       #
#   Return:                                                                                      #
#       Confusion Matrix                                                                         #
##################################################################################################
evaluate.global.utiml <- function(ds, dataset_name, 
                           number_folds, number_cores, 
                           folderResults){    

  
  apagar = c(0)
  resConfMatFinal = data.frame(apagar)
  
  f = 1
  avaliaParalel <- foreach (f = 1:number_folds) %dopar%{    
  #while(f<=number_folds){
        
    FolderRoot = "~/Global-Partitions/"
    FolderScripts = paste(FolderRoot, "/R/", sep="")
    
    ####################################################################################
    setwd(FolderScripts)
    source("utils.R")
    
    library("mldr")
    library("utiml")
    
    ####################################################################################
    diretorios = directories(dataset_name, folderResults)
    
    cat("\n\nSplit: ", f)    
    
    FolderSplit = paste(diretorios$folderGlobal, "/Split-", f, sep="")
    
    ####################################################################################
    cat("\nAbrindo pred and true")
    setwd(FolderSplit)
    y_pred = data.frame(read.csv("y_predict.csv"))
    y_true = data.frame(read.csv("y_true.csv"))
    
    cat("\nConvertendo em numerico")
    y_true2 = data.frame(sapply(y_true, function(x) as.numeric(as.character(x))))
    y_true3 = mldr_from_dataframe(y_true2 , labelIndices = seq(1,ncol(y_true2 )), name = "y_true2")
    y_pred2 = sapply(y_pred, function(x) as.numeric(as.character(x)))
    
    cat("\nsalvando")
    salva3 = paste("ConfMatFold-", f, ".txt", sep="")
    setwd(FolderSplit)
    sink(file=salva3, type="output")
    confmat = multilabel_confusion_matrix(y_true3, y_pred2)
    print(confmat)
    sink()
    
    cat("\nmatriz de confusão")
    resConfMat = multilabel_evaluate(confmat)
    resConfMat = data.frame(resConfMat)
    names(resConfMat) = paste("Fold-", f, sep="")
    setwd(FolderSplit)
    write.csv(resConfMat, "ResConfMat.csv")    
    
    #f = f + 1
    gc()
  }
  
  gc()
  cat("\n##################################################################################################")
  cat("\n# END OF THE EVALUATION MISCELLANEOUS FUNCTION                                                   #") 
  cat("\n##################################################################################################")
  cat("\n\n\n\n")
}





##################################################################################################
# FUNCTION GATHER PREDICTS GLOBAL PARTITIONS                                                     #
#   Objective                                                                                    #
#      Evaluates the global partitions                                                           #
#   Parameters                                                                                   #
#       ds: specific dataset information                                                         #
#       dataset_name: dataset name. It is used to save files.                                    #
#       number_folds: number of folds created                                                    #
#       Folder: path of global partition results                                                 #
#   Return                                                                                       #
#       Assessment measures for each global partition                                            #
##################################################################################################
gather.eval.utiml <- function(ds, 
                             dataset_name, 
                             number_folds, 
                             number_cores, 
                             folderResults){
  
  diretorios = directories(dataset_name, folderResults) 
  
  retorno = list()
  
  # vector with names measures
  measures = c("accuracy","average-precision","clp","coverage","F1","hamming-loss","macro-AUC",
              "macro-F1","macro-precision","macro-recall","margin-loss","micro-AUC","micro-F1",
              "micro-precision","micro-recall","mlp","one-error","precision","ranking-loss",
              "recall","subset-accuracy","wlp")
  
  # dta frame
  confMatFinal = data.frame(measures)
  folds = c("")
  
  # from fold = 1 to number_labels
  f = 1
  while(f<= number_folds){
    cat("\nFold: ", f)
    
    FolderSplit = paste(diretorios$folderGlobal, "/Split-", f, sep="")
    setwd(FolderSplit)
    
    # cat("\n\tOpen ResConfMat ", f)
    confMat = data.frame(read.csv(paste(FolderSplit, "/ResConfMat.csv", sep="")))
    names(confMat) = c("Measures", "Fold")
    confMatFinal = cbind(confMatFinal, confMat$Fold) 
    
    folds[f] = paste("Fold-", f, sep="")
    
    f = f + 1
    gc()
  } 
  
  cat("\nsave measures")
  names(confMatFinal) = c("Measures", folds)
  setwd(diretorios$folderGlobal)
  write.csv(confMatFinal, "All-Folds-Global.csv", row.names = FALSE)
  
  # cat("\nadjust")
  # confMatFinal2 = data.frame(t(confMatFinal))
  # confMatFinal3 = confMatFinal2[-1,]
  # colnames(confMatFinal3) = medidas
  # teste = data.frame(sapply(confMatFinal3, function(x) as.numeric(as.character(x))))
  # write.csv(confMatFinal3, paste(dataset_name, "-Global-fold-per-measure.csv", sep=""), row.names = FALSE)
  
  # cat("\nsummary")
  # sumary = apply(teste,2,mean)
  # sumary2 = data.frame(sumary)
  # sumary3 = cbind(medidas, sumary2)
  # names(sumary3) = c("Measures", "Mean")
  # write.csv(sumary3, paste(dataset_name, "-Global-Mean-10-folds.csv", sep=""), row.names = FALSE)
  
  # calculando a média dos 10 folds para cada medida
  media = data.frame(apply(confMatFinal[,-1], 1, mean))
  media = cbind(measures, media)
  names(media) = c("Measures", "Mean10Folds")
  
  setwd(diretorios$folderGlobal)
  write.csv(media, "Mean10Folds.csv", row.names = FALSE)
  
  mediana = data.frame(apply(confMatFinal[,-1], 1, median))
  mediana = cbind(measures, mediana)
  names(mediana) = c("Measures", "Median10Folds")
  
  setwd(diretorios$folderGlobal)
  write.csv(mediana, "Median10Folds.csv", row.names = FALSE)
  
  dp = data.frame(apply(confMatFinal[,-1], 1, sd))
  dp = cbind(measures, dp)
  names(dp) = c("Measures", "SD10Folds")
  
  setwd(diretorios$folderGlobal)
  write.csv(dp, "desvio-padrão-10-folds.csv", row.names = FALSE)
  
  gc()
  cat("\n##################################################################################################")
  cat("\n# UTIML GLOBAL: END OF THE FUNCTION GATHER EVALUATED                                              #") 
  cat("\n##################################################################################################")
  cat("\n\n\n\n")
}



##################################################################################################
# Please, any errors, contact us: elainececiliagatto@gmail.com                                   #
# Thank you very much!                                                                           #
##################################################################################################
