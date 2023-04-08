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



##############################################################################
# FUNCTION EXECUTE PYTHON ECC                                               #
#   Objective                                                                #
#       Tests ECC partitions                                              #
#   Parameters                                                               #
#       ds: specific dataset information                                     #
#       parameters$Config.File$Dataset.Name: dataset name. It is used to save files.                #
#       number_folds: number of folds created                                #
#       Folder: folder path                                                  #
#   Return                                                                   #
#       configurations files                                                 #
##############################################################################
execute.ecc.python <- function(parameters){
  
  f = 1
  PythonEccParalel <- foreach(f = 1:parameters$Config.File$Number.Folds) %dopar%{
  # while(f<=number_folds){
    
    #########################################################################
    cat("\nFold: ", f)
    
    ##########################################################################
    FolderRoot = "~/Ensemble-Classifier-Chains"
    FolderScripts = "~/Ensemble-Classifier-Chains/R"
    
    ##########################################################################
    setwd(FolderScripts)
    source("libraries.R")
    
    setwd(FolderScripts)
    source("utils.R")
    
    ##########################################################################
    FolderSplit = paste(parameters$Directories$folderECC , "/Split-", f, sep="")
    
    
    ##########################################################################
    train.file.name = paste(parameters$Directories$folderCVTR, "/", 
                            parameters$Config.File$Dataset.Name, 
                            "-Split-Tr-", f , ".csv", sep="")
    
    test.file.name = paste(parameters$Directories$folderCVTS, "/",
                           parameters$Config.File$Dataset.Name, 
                           "-Split-Ts-", f, ".csv", sep="")
    
    val.file.name = paste(parameters$Directories$folderCVVL, "/", 
                          parameters$Config.File$Dataset.Name, 
                            "-Split-Vl-", f , ".csv", sep="")
    
    
    ##########################################################################
    setwd(FolderSplit)
    train = data.frame(read.csv(train.file.name))
    test = data.frame(read.csv(test.file.name))
    val = data.frame(read.csv(val.file.name))
    tv = rbind(train, val)
    
    
    ##########################################################################
    labels.indices = seq(parameters$Dataset.Info$LabelStart, 
                         parameters$Dataset.Info$LabelEnd, by=1)
    
    ##########################################################################
    mldr.treino = mldr_from_dataframe(train, labelIndices = labels.indices)
    mldr.teste = mldr_from_dataframe(test, labelIndices = labels.indices)
    mldr.val = mldr_from_dataframe(val, labelIndices = labels.indices)
    mldr.tv = mldr_from_dataframe(tv, labelIndices = labels.indices)
    
    ##################################################################
    # EXECUTE ECC PYTHON
    str.execute = paste("python3 ", parameters$Directories$folderUtils,
                        "/ecc-python/main.py ", 
                        train.file.name, " ",
                        val.file.name,  " ",
                        test.file.name, " ", 
                        start = as.numeric(parameters$Dataset.Info$AttEnd), " ", 
                        FolderSplit,
                        sep="")
    
    # cat("\n", str.execute, "\n")
    
    # EXECUTA
    start <- proc.time()
    res = print(system(str.execute))
    tempo = data.matrix((proc.time() - start))
    tempo = data.frame(t(tempo))
    write.csv(tempo, paste(FolderSplit, "/runtime-fold.csv", sep=""))
    
    if(res!=0){
      break
    }
    
    ###################
    y_pred_proba = data.frame(read.csv(paste(FolderSplit, "/y_pred_proba.csv", sep="")))
    y_true = data.frame(read.csv(paste(FolderSplit, "/y_true.csv", sep="")))
    
    ####################################################################################
    y.true.2 = data.frame(sapply(y_true, function(x) as.numeric(as.character(x))))
    y.true.3 = mldr_from_dataframe(y.true.2, 
                                   labelIndices = seq(1,ncol(y.true.2)), 
                                   name = "y.true.2")
    y_pred_proba = sapply(y_pred_proba, function(x) as.numeric(as.character(x)))
    
    ########################################################################
    y_threshold_05 <- data.frame(as.matrix(fixed_threshold(y_pred_proba,
                                                           threshold = 0.5)))
    write.csv(y_threshold_05, 
              paste(FolderSplit, "/y_pred_thr05.csv", sep=""),
              row.names = FALSE)
    
    ########################################################################
    y_threshold_card = lcard_threshold(as.matrix(y_pred_proba), 
                                       mldr.tv$measures$cardinality,
                                       probability = F)
    write.csv(y_threshold_card, 
              paste(FolderSplit, "/y_pred_thrLC.csv", sep=""),
              row.names = FALSE)
    
    y_threshold_card = data.frame(as.matrix(y_threshold_card))
    
    #####################################################################
    nome.true = paste(FolderSplit, "/y_true.csv", sep="")
    nome.pred.proba = paste(FolderSplit, "/y_pred_proba.csv", sep="")
    nome.thr.05 = paste(FolderSplit, "/y_pred_thr05.csv", sep="")
    nome.thr.LC = paste(FolderSplit, "/y_pred_thrLC.csv", sep="")
    
    save.pred.proba = paste(FolderSplit, "/pred-proba-auprc.csv", sep="")
    save.thr05 = paste(FolderSplit, "/thr-05-auprc.csv", sep="")
    save.thrLC = paste(FolderSplit, "/thr-lc-auprc.csv", sep="")
    
    #################################################################
    str.execute = paste("python3 ", parameters$Directories$folderUtils,
                        "/ecc-python/auprc.py ",
                        nome.true, " ",
                        nome.pred.proba, " ",
                        save.pred.proba, " ",
                        sep="")
    res = print(system(str.execute))
    if(res!=0){
      break
    }
    
    #################################################################
    str.execute = paste("python3 ",  parameters$Directories$folderUtils,
                        "/ecc-python/auprc.py ",
                        nome.true, " ",
                        nome.thr.05, " ",
                        save.thr05, " ",
                        sep="")
    res = print(system(str.execute))
    if(res!=0){
      break
    }
    
    #################################################################
    str.execute = paste("python3 ",  parameters$Directories$folderUtils,
                        "/ecc-python/auprc.py ",
                        nome.true, " ",
                        nome.thr.LC, " ",
                        save.thrLC, " ",
                        sep="")
    res = print(system(str.execute))
    if(res!=0){
      break
    }
    
    ####################################################
    names = paste(parameters$Names.Labels$Labels, "-proba", sep="")
    y_pred_proba = data.frame(y_pred_proba)
    names(y_pred_proba) = names
    rm(names)
    
    names  = paste(parameters$Names.Labels$Labels, "-true", sep="")
    true = data.frame(y_true)
    names(y_true) = names 
    rm(names)
    
    names  = paste(parameters$Names.Labels$Labels, "-thr-05", sep="")
    y_threshold_05 = data.frame(y_threshold_05)
    names(y_threshold_05) = names 
    rm(names)
    
    names  = paste(parameters$Names.Labels$Labels, "-thr-lc", sep="")
    y_threshold_card = data.frame(as.matrix(y_threshold_card))
    names(y_threshold_card) = names 
    rm(names)
    
    all.predictions = cbind(y_true, y_pred_proba,
                            y_threshold_05, y_threshold_card)
    write.csv(all.predictions, 
              paste(FolderSplit, "/folder-predictions.csv", sep=""), 
              row.names = FALSE)
    
    
    ##############################################
    matrix.confusao(true = y_true, pred = y_threshold_05, 
                    type = "thr-05", salva = FolderSplit, 
                    nomes.rotulos = parameters$Names.Labels$Labels)
    
    matrix.confusao(true = y_true, pred = y_threshold_card, 
                    type = "thr-lc", salva = FolderSplit, 
                    nomes.rotulos = parameters$Names.Labels$Labels)
    
    
    #########################################################################    
    roc.curva(f = f, y_pred = y_pred_proba, test = mldr.teste,
              Folder = FolderSplit, nome = "pred-proba")
    
    roc.curva(f = f, y_pred = y_threshold_card, test = mldr.teste,
              Folder = FolderSplit, nome = "thr-lc")
    
    roc.curva(f = f, y_pred = y_threshold_05, test = mldr.teste,
              Folder = FolderSplit, nome = "thr-05")
    
    
    # f = f + 1
    gc()
  }
  
  gc()
  cat("\n###############################################")
  cat("\n# execute.ecc.python END                      #")
  cat("\n###############################################")
  cat("\n\n")
}




############################################################################
#
############################################################################
evaluate.ecc.python <- function(parameters){
  
  f = 1
  avaliaParalel <- foreach (f = 1:parameters$Config.File$Number.Folds) %dopar%{
    # while(f<=parameters$Config.File$Number.Folds){
    
    #########################################################################
    cat("\nFold: ", f)
    
    ##########################################################################
    FolderRoot = "~/Ensemble-Classifier-Chains"
    FolderScripts = "~/Ensemble-Classifier-Chains/R"
    
    ##########################################################################
    setwd(FolderScripts)
    source("libraries.R")
    
    setwd(FolderScripts)
    source("utils.R")
    
    
    ###########################################################################
    FolderSplit = paste(parameters$Directories$folderECC, "/Split-", f, sep="")
    if(dir.exists(FolderSplit)==FALSE){dir.create(FolderSplit)}
    
    #####################################################################
    nome.true = paste(FolderSplit, "/y_true.csv", sep="")
    nome.pred.proba = paste(FolderSplit, "/y_pred_proba.csv", sep="")
    nome.thr.05 = paste(FolderSplit, "/y_pred_thr05.csv", sep="")
    nome.thr.LC = paste(FolderSplit, "/y_pred_thrLC.csv", sep="")
    
    #####################################################################
    y_pred_proba = data.frame(read.csv(nome.pred.proba))
    y_pred_thr_05 = data.frame(read.csv(nome.thr.05))
    y_pred_thr_lc = data.frame(read.csv(nome.thr.LC))
    y_true = data.frame(read.csv(nome.true))
    
    
    ##########################################################################
    y.true.2 = data.frame(sapply(y_true, function(x) as.numeric(as.character(x))))
    y.true.3 = mldr_from_dataframe(y.true.2, 
                                   labelIndices = seq(1,ncol(y.true.2)), 
                                   name = "y.true.2")
    y_pred_proba = sapply(y_pred_proba, function(x) as.numeric(as.character(x)))
    y_pred_thr_05 = sapply(y_pred_thr_05, function(x) as.numeric(as.character(x)))
    y_pred_thr_lc = sapply(y_pred_thr_lc, function(x) as.numeric(as.character(x)))
    
    
    ##########################################################################    
    avaliacao(f = f, y_true = y.true.3, y_pred = y_pred_proba,
              salva = FolderSplit, nome = "pred-proba")
    
    avaliacao(f = f, y_true = y.true.3, y_pred = y_pred_thr_05,
              salva = FolderSplit, nome = "thr-05")
    
    avaliacao(f = f, y_true = y.true.3, y_pred = y_pred_thr_lc,
              salva = FolderSplit, nome = "thr-lc")
    
    # f = f + 1
    gc()
  }
  
  gc()
  cat("\n##################################")
  cat("\n# END FUNCTION EVALUATE          #")
  cat("\n##################################")
  cat("\n\n\n\n")
}





###########################################################################
#
###########################################################################
gather.eval.ecc.python <- function(parameters){
  
  measures = c("accuracy", "average-precision", "clp", "coverage",
               "F1", "hamming-loss", "macro-AUC", "macro-F1", 
               "macro-precision", "macro-recall", "margin-loss", 
               "micro-AUC","micro-F1", "micro-precision",
               "micro-recall", "mlp", "one-error", "precision", 
               "ranking-loss", "recall", "subset-accuracy", "wlp")
  
  folds = c(0)
  
  nomes.preds = c("pred-proba", "thr-05", "thr-lc")
  
  i = 1
  while(i<=length(nomes.preds)){
    
    cat("\n\npredicao: ", i)
    
    final.roc.auc = data.frame()
    final.roc.auc.micro = data.frame()
    final.roc.auc.macro = data.frame()
    
    final.auprc.macro = data.frame(fold = c(0), value=c(0))
    final.auprc.micro = data.frame(fold = c(0), value=c(0))
    
    final.runtime = data.frame()
    final.conf.mat = data.frame(measures)
    
    
    f = 1
    while(f<=parameters$Config.File$Number.Folds){
      
      cat("\nFold: ", f)
      
      #########################################################################
      folderSplit = paste(parameters$Directories$folderECC,
                          "/Split-", f, sep="")
      
      #########################################################################
      confMat = data.frame(read.csv(paste(folderSplit, "/", nomes.preds[i], 
                                          "-evaluated.csv", sep="")))
      names(confMat) = c("Measures", "Fold")
      
      #########################################################################
      confMat[is.na(confMat)] <- 0
      
      #########################################################################
      final.conf.mat = cbind(final.conf.mat, confMat$Fold) 
      folds[f] = paste("Fold-", f, sep="")
      
      #########################################################################
      roc.auc = data.frame(read.csv(paste(folderSplit, "/", nomes.preds[i], 
                                          "-roc-auc.csv", sep="")))       
      final.roc.auc = rbind(final.roc.auc, roc.auc)
      
      #########################################################################
      roc.micro.auc = data.frame(read.csv(paste(folderSplit, "/", nomes.preds[i], 
                                                "-roc-auc-micro.csv", sep="")))       
      final.roc.auc.micro = rbind(final.roc.auc.micro, roc.micro.auc)
      
      #########################################################################
      roc.macro.auc = data.frame(read.csv(paste(folderSplit, "/", nomes.preds[i], 
                                                "-roc-auc-macro.csv", sep="")))       
      final.roc.auc.macro = rbind(final.roc.auc.macro, roc.macro.auc)
      
      #########################################################################
      auprc = data.frame(read.csv(paste(folderSplit, "/", nomes.preds[i], 
                                        "-auprc.csv", sep="")))       
      final.auprc.macro = rbind(final.auprc.macro, 
                                data.frame(fold = f, value = auprc$Macro.AUPRC))
      final.auprc.micro = rbind(final.auprc.micro, 
                                data.frame(fold = f, value = auprc$Micro.AUPRC))
      
      #################################
      runtime = data.frame(read.csv(paste(folderSplit, "/runtime-fold.csv", sep="")))
      names(runtime) = c("fold", "user.self", "sys.self",
                         "elapsed","user.child","sys.child")
      final.runtime = rbind(final.runtime, runtime)
      
      #################################
      f = f + 1
      gc()
    } 
    
    
    names(final.conf.mat) = c("Measures", folds)
    names(final.roc.auc) = c("Fold", "Value")
    names(final.roc.auc.micro) = c("Fold", "Value")
    names(final.roc.auc.macro) = c("Fold", "Value")
    names(final.auprc.micro) = c("Fold", "Value")
    names(final.auprc.macro) = c("Fold", "Value")
    final.auprc.macro = final.auprc.macro[-1,]
    final.auprc.micro = final.auprc.micro[-1,]
    
    ###########################################
    fold = seq(1, parameters$Config.File$Number.Folds, by =1)
    
    ###########################################
    names(final.conf.mat) = c("Measures", folds)
    final.conf.mat[is.na(final.conf.mat)] <- 0
    write.csv(final.conf.mat, 
              paste(parameters$Directories$folderECC, "/", nomes.preds[i], 
                    "-Test-Evaluated.csv", sep=""), 
              row.names = FALSE)
    
    #######################
    media = data.frame(apply(final.conf.mat[,-1], 1, mean))
    media = cbind(measures, media)
    names(media) = c("Measures", "Mean10Folds")
    write.csv(media, 
              paste(parameters$Directories$folderECC, "/", 
                    nomes.preds[i], "-Mean10Folds.csv", sep=""), 
              row.names = FALSE)
    
    #######################
    mediana = data.frame(apply(final.conf.mat[,-1], 1, median))
    mediana = cbind(measures, mediana)
    names(mediana) = c("Measures", "Median10Folds")
    write.csv(mediana, 
              paste(parameters$Directories$folderECC, "/", 
                    nomes.preds[i], "-Median10Folds.csv", sep=""), 
              row.names = FALSE)
    
    
    #######################
    desvio = data.frame(apply(final.conf.mat[,-1], 1, sd))
    desvio  = cbind(measures, desvio)
    names(desvio ) = c("Measures", "Deviation10Folds")
    write.csv(desvio , 
              paste(parameters$Directories$folderECC, "/", 
                    nomes.preds[i], "-Deviation10Folds.csv", sep=""), 
              row.names = FALSE)
    
    ###########################################
    write.csv(final.roc.auc, 
              paste(parameters$Directories$folderECC, "/", nomes.preds[i], 
                    "-roc-auc.csv", sep=""), 
              row.names = FALSE)
    
    ###########################################
    write.csv(final.roc.auc.micro, 
              paste(parameters$Directories$folderECC, "/", nomes.preds[i], 
                    "-roc-auc-micro.csv", sep=""), 
              row.names = FALSE)
    
    ###########################################
    write.csv(final.roc.auc.macro, 
              paste(parameters$Directories$folderECC, "/", nomes.preds[i], 
                    "-roc-auc-macro.csv", sep=""), 
              row.names = FALSE)
    
    ###########################################
    write.csv(final.auprc.micro, 
              paste(parameters$Directories$folderECC, "/", nomes.preds[i], 
                    "-roc-auprc-micro.csv", sep=""), 
              row.names = FALSE)
    
    ###########################################
    final.runtime$fold = fold
    write.csv(final.runtime, 
              paste(parameters$Directories$folderECC, 
                    "/runtime-folds.csv", sep=""), 
              row.names = FALSE)
    
    ################
    i = i + 1
    gc()
  }
  
  gc()
  cat("\n########################################################")
  cat("\n# END EVALUATED                                        #") 
  cat("\n########################################################")
  cat("\n\n\n\n")
}



##################################################################################################
# Please, any errors, contact us: elainececiliagatto@gmail.com                                   #
# Thank you very much!                                                                           #
################################################################################################
