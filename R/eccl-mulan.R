###############################################################################
# Global Partitions with Clus                                                 #
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


###############################################################################
# FUNCTION GATHER FILES FOLDS GLOBAL                                          #
#   Objective                                                                 #
#       Joins the configuration, training and test files in a single folder   #
#     running the clus                                                        #
#   Parameters                                                                #
#       ds: specific dataset information                                      #
#       dataset_name: dataset name. It is used to save files                  #
#       number_folds: number of folds created                                 #
#       FolderConfifFiles: folder path                                        #
#   Return                                                                    #
#       configurations files                                                  #
###############################################################################
gather.files.mulan <- function(ds, dataset_name, number_folds, folderResults){
  
  f = 1
  # foldsParalel <- foreach(f = 1:number_folds) %dopar% {
  while(f<=number_folds){
    
    cat("\nFold: ", f)
    
    ###########################################################################
    FolderRoot = "~/Global-Partitions/"
    FolderScripts = paste(FolderRoot, "/R/", sep="")
    
    ###########################################################################
    setwd(FolderScripts)
    source("libraries.R")
    
    setwd(FolderScripts)
    source("utils.R")
    
    ###########################################################################
    diretorios = directories(dataset_name, folderResults)
    
    ###########################################################################
    FolderSplit = paste(diretorios$folderGlobal, "/Split-", f, sep="")
    if(dir.exists(FolderSplit)==FALSE){dir.create(FolderSplit)}
    
    # names files
    nome.tr.csv = paste(dataset_name, "-Split-Tr-", f, ".csv", sep="")
    nome.ts.csv = paste(dataset_name, "-Split-Ts-", f, ".csv", sep="")
    nome.vl.csv = paste(dataset_name, "-Split-Vl-", f, ".csv", sep="")
    nome.tr.arff = paste(dataset_name, "-Split-Tr-", f, ".arff", sep="")
    nome.ts.arff = paste(dataset_name, "-Split-Ts-", f, ".arff", sep="")
    nome.config.s = paste(dataset_name, "-Split-", f, ".s", sep="")
    
    # train
    setwd(diretorios$folderCVTR)
    if(file.exists(nome.tr.csv) == TRUE){
      setwd(diretorios$folderCVTR)
      copia = paste(diretorios$folderCVTR, "/", nome.tr.csv, sep="")
      cola = paste(FolderSplit, "/", nome.tr.csv, sep="")
      file.copy(copia, cola, overwrite = TRUE)
    }
    
    # test
    setwd(diretorios$folderCVTS)
    if(file.exists(nome.ts.csv) == TRUE){
      setwd(diretorios$folderCVTS)
      copia = paste(diretorios$folderCVTS, "/", nome.ts.csv, sep="")
      cola = paste(FolderSplit, "/", nome.ts.csv, sep="")
      file.copy(copia, cola, overwrite = TRUE)
    }
    
    # validation
    setwd(diretorios$folderCVVL)
    if(file.exists(nome.vl.csv) == TRUE){
      setwd(diretorios$folderCVVL)
      copia = paste(diretorios$folderCVVL, "/", nome.vl.csv, sep="")
      cola = paste(FolderSplit, "/", nome.vl.csv, sep="")
      file.copy(copia, cola, overwrite = TRUE)
    }
    
    
    ##########################################################################
    setwd(FolderSplit)
    validation = data.frame(read.csv(nome.vl.csv))
    train = data.frame(read.csv(nome.tr.csv))
    test = data.frame(read.csv(nome.ts.csv))
    
    treino = rbind(train, validation)
    
    ##########################################################################
    unlink(nome.tr.csv)
    nome.tr.csv = paste(dataset_name, "-Split-Tr-", f, ".csv", sep="")
    write.csv(treino, nome.tr.csv, row.names = FALSE)
    
    ##########################################################################
    inicio = ds$LabelStart
    fim = ncol(treino)
    ifr = data.frame(inicio, fim)
    write.csv(ifr, "inicioFimRotulos.csv", row.names = FALSE)
    
    ##########################################################################
    arg1Tr = nome.tr.csv
    arg2Tr = nome.tr.arff
    arg3Tr = paste(inicio, "-", fim, sep="")
    converteArff(arg1Tr, arg2Tr, arg3Tr, diretorios$folderUtils)
    
    ##########################################################################
    str0 = paste("sed -i 's/{0}/{0,1}/g;s/{1}/{0,1}/g' ", nome.tr.arff, sep="")
    cat("\n")
    print(system(str0))
    cat("\n")
    
    ##########################################################################
    arg1Ts = nome.ts.csv
    arg2Ts = nome.ts.arff
    arg3Ts = paste(inicio, "-", fim, sep="")
    converteArff(arg1Ts, arg2Ts, arg3Ts, diretorios$folderUtils)
    
    ##########################################################################
    str0 = paste("sed -i 's/{0}/{0,1}/g;s/{1}/{0,1}/g' ", nome.ts.arff, sep="")
    cat("\n")
    print(system(str0))
    cat("\n")
    
    ##########################################################################
    indices = seq(inicio, fim, by=1)
    
    ##########################################################################
    unlink(nome.ts.csv)
    unlink(nome.tr.csv)
    unlink(nome.vl.csv)
    
    ##########################################################################
    f = f + 1
    gc()
  }
  
  gc()
  cat("\n#################################################################")
  cat("\n# GLOBAL CLUS: END OF THE GATHER FILES FOLDS FUNCTION           #")
  cat("\n#################################################################")
  cat("\n\n")
}


##############################################################################
# FUNCTION EXECUTE CLUS GLOBAL                                               #
#   Objective                                                                #
#       Tests global partitions                                              #
#   Parameters                                                               #
#       ds: specific dataset information                                     #
#       dataset_name: dataset name. It is used to save files.                #
#       number_folds: number of folds created                                #
#       Folder: folder path                                                  #
#   Return                                                                   #
#       configurations files                                                 #
##############################################################################
execute.global.mulan <- function(ds, 
                                 dataset_name, 
                                 number_folds, 
                                 number_cores, 
                                 folderResults){
  
  f = 1
  clusGlobalParalel <- foreach(f = 1:number_folds) %dopar%{
    # while(f<=number_folds){
    
    #########################################################################
    cat("\nFold: ", f)
    
    ##########################################################################
    FolderRoot = "~/Global-Partitions/"
    FolderScripts = paste(FolderRoot, "/R/", sep="")
    
    ##########################################################################
    setwd(FolderScripts)
    source("libraries.R")
    
    setwd(FolderScripts)
    source("utils.R")
    
    ##########################################################################
    diretorios = directories(dataset_name, folderResults)
    
    
    ##########################################################################
    FolderSplit = paste(diretorios$folderGlobal, "/Split-", f, sep="")
    
    
    ##########################################################################
    inicio = ds$LabelStart
    fim = ds$LabelEnd
    indices = seq(inicio, fim, by = 1)
    
    
    ##########################################################################
    train.file.name = paste(FolderSplit, "/", dataset_name, 
                            "-Split-Tr-", f , ".arff", sep="")
    
    test.file.name = paste(FolderSplit, "/", dataset_name, 
                           "-Split-Ts-", f, ".arff", sep="")
    
    
    ##########################################################################
    setwd(FolderSplit)
    train.2 = data.frame(foreign::read.arff(train.file.name))
    train.3 = data.frame(apply(train.2, 2, as.numeric))
    test.2 = data.frame(foreign::read.arff(test.file.name))
    test.3 = data.frame(apply(test.2, 2, as.numeric))
    
    ##########################################################################
    labels = colnames(train.2[,ds$LabelStart:ds$LabelEnd])
    
    
    ##########################################################################
    y_true = select(test.2, labels)
    setwd(FolderSplit)
    write.csv(y_true, "y_true.csv", row.names = FALSE)
    
    ##########################################################################
    train.file.name.2 = paste(FolderSplit, "/", dataset_name, 
                              "-Split-Tr-", f , "-2.arff", sep="")
    
    test.file.name.2 = paste(FolderSplit, "/", dataset_name, 
                             "-Split-Ts-", f, "-2.arff", sep="")
    
    system(paste("mv ", train.file.name, " " , train.file.name.2, sep=""))
    system(paste("mv ", test.file.name, " " , test.file.name.2, sep=""))
    
    ##############################################
    str.tr = paste(ds$Name, "-Split-Tr-", f,
                   "-weka.filters.unsupervised.attribute.NumericToNominal-R",
                   inicio, "-", fim, sep="")
    
    train.4 <- mldr::mldr_from_dataframe(dataframe = train.3,
                                         labelIndices = indices)
    #name = str.tr
    
    train.xml.name = paste(FolderSplit, "/", ds$Name, "-Split-Tr-", f, sep="")
    mldr::write_arff(train.4, train.xml.name, write.xml = T)
    
    
    #############################################
    str.ts = paste(ds$Name, "-Split-Ts-", f,
                   "-weka.filters.unsupervised.attribute.NumericToNominal-R",
                   inicio, "-", fim, sep="")
    
    test.4 <- mldr::mldr_from_dataframe(dataframe = test.3,
                                        labelIndices = indices)
    
    test.xml.name = paste(FolderSplit, "/", ds$Name, "-Split-Ts-", f, sep="")
    mldr::write_arff(test.4, test.xml.name, write.xml = T)
    
    #####################################################################
    # cat("\nConfigura a linha de comando")
    #
    mulan = paste("/usr/lib/jvm/java-1.8.0-openjdk-amd64/bin/java -Xmx8g -jar ", 
                  diretorios$folderUtils, "/mymulanexec.jar", sep="")
    
    # mulan = paste("/home/u704616/miniconda3/envs/AmbienteTeste/bin/java -Xmx8g -jar ", 
    #              diretorios$folderUtils, "/mymulanexec.jar", sep="")
    
    str = paste(FolderSplit, "/predict-fold-", f, ".csv", sep="")
    
    mulanst = paste(mulan, " -t ", train.file.name, " -T ", 
                    test.file.name, " -x ", train.xml.name,
                    ".xml -o out.csv -a ECC -c J48", sep = "")
    
    
    cat("\n\n\n")
    cat("=============================================")
    print(mulanst)
    cat("=============================================")
    cat("\n\n\n")
    
    #################################
    # cat("\nExecuta o ECC do MULAN")
    time.mulan <- system.time(system(mulanst))
    result <- t(data.matrix(time.mulan))
    setwd(diretorios$folderGlobal)
    write.csv(result, "time-mulan.csv")
    
    # cat("\nObtém as predições")
    setwd(FolderSplit)
    preds <- as.matrix(read.csv("pred_out.csv", header = FALSE))
    
    # cat("\nAbrindo o arquivo de teste gerado aqui")
    test_name_group = paste(FolderSplit, "/", ds$Name, 
                            "-Split-Ts-", f, sep="")
    test.file. <- mldr(test_name_group, force_read_from_file = T)
    
    # cat("\nCalculando os resultados - threshold 0.5 default")
    result <- multilabel_evaluate(test.file., preds, labels=TRUE)
    preds = data.frame(preds)
    colnames(preds) = labels
    
    # cat("\nAplicando thresold no resultado")
    threshold <- scut_threshold(preds, test.file., cores = number_cores)
    new.test <- fixed_threshold(preds, threshold)
    new.test.2 = as.matrix(new.test)
    new.test.3 = data.frame(new.test.2)
    
    # cat("\nSALVANDO OS Y PREDICT")
    y_pred = data.frame(new.test.3)
    colnames(y_pred) = labels
    setwd(FolderSplit)
    write.csv(y_pred, "y_pred.csv", row.names = FALSE)
    
    # cat("\nMatriz de confusão")
    matriz_confusao = multilabel_confusion_matrix(test.file., preds)
    nome_config = paste(FolderSplit, "/matriz_confusao_fold_", 
                        f, ".txt", sep="")
    sink(nome_config, type = "output")
    print(matriz_confusao)
    cat("\n")
    sink()
    
    # APAGANDO
    setwd(FolderSplit)
    unlink("inicioFimRotulos.csv")
    unlink("pred_out.csv")
    unlink(train.file.name)
    unlink(train.file.name.2)
    unlink(test.file.name)
    unlink(test.file.name.2)
    unlink(paste(test.xml.name, ".xml", sep=""))
    unlink(paste(train.xml.name, ".xml", sep=""))
    
    
    # f = f + 1
    gc()
  }
  
  gc()
  cat("\n###################################################################")
  cat("\n# GLOBAL CLUS: END OF FUNCTION EXECUTE CLUS                       #")
  cat("\n###################################################################")
  cat("\n\n")
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
evaluate.global.mulan <- function(ds,
                                  dataset_name,
                                  number_folds,
                                  number_cores,
                                  folderResults){
  
  
  apagar = c(0)
  resConfMatFinal = data.frame(apagar)
  
  f = 1
  avaliaParalel <- foreach (f = 1:number_folds) %dopar%{
    #while(f<=number_folds){
    
    #########################################################################
    cat("\nFold: ", f)
    
    FolderRoot = "~/Global-Partitions/"
    FolderScripts = paste(FolderRoot, "/R/", sep="")
    
    #########################################################################
    setwd(FolderScripts)
    source("utils.R")
    
    setwd(FolderScripts)
    source("libraries.R")
    
    ####################################################################
    diretorios = directories(dataset_name, folderResults)
    
    ####################################################################
    FolderSplit = paste(diretorios$folderGlobal, "/Split-", f, sep="")
    
    ####################################################################################
    # cat("\nAbrindo pred and true")
    setwd(FolderSplit)
    y_pred = data.frame(read.csv("y_pred.csv"))
    y_true = data.frame(read.csv("y_true.csv"))
    
    # cat("\nConvertendo em numerico")
    y_true2 = data.frame(sapply(y_true, function(x) as.numeric(as.character(x))))
    y_true3 = mldr_from_dataframe(y_true2 , labelIndices = seq(1,ncol(y_true2 )), name = "y_true2")
    y_pred2 = sapply(y_pred, function(x) as.numeric(as.character(x)))
    
    # cat("\nsalvando")
    salva3 = paste("ConfMatFold-", f, ".txt", sep="")
    setwd(FolderSplit)
    sink(file=salva3, type="output")
    confmat = multilabel_confusion_matrix(y_true3, y_pred2)
    print(confmat)
    sink()
    
    # cat("\nmatriz de confusão")
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
gather.eval.mulan <- function(ds, 
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
  # 
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
  cat("\n# MULAN GLOBAL: END OF THE FUNCTION GATHER EVALUATED                                              #") 
  cat("\n##################################################################################################")
  cat("\n\n\n\n")
}


##################################################################################################
# Please, any errors, contact us: elainececiliagatto@gmail.com                                   #
# Thank you very much!                                                                           #
################################################################################################
