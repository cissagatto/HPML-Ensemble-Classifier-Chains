library("mldr")
library("utiml")

# comando java inicial para executar o mulan (tem que ser jdk 1.8)
mulan <- "/usr/lib/jvm/java-1.8.0-openjdk-amd64/bin/java  -Xmx8g -jar /home/mauri/Downloads/MulanParaElaine/mymulanexec.jar"

# arquivos de entrada (sem a extensão .arff)
train_file <- "/home/mauri/Downloads/MulanParaElaine/yeast_train_1"
test_file <- "/home/mauri/Downloads/MulanParaElaine/yeast_test_1"

# vai gerar as predições em um arquivo pred_out.csv no diretório escolhido
# aqui estou direcionando para o diretório temporário individual de cada seção do R
setwd(tempdir())

# os parâmetros seguem esta implementação: https://github.com/kdis-lab/ExecuteMulan
# chama o mulan MLknn
#mulanstr <- paste(mulan, " -t ", train_file, ".arff -T ", test_file, ".arff -x ", train_file, ".xml -o out.csv -a MLkNN", sep = "")
mulanstr <- paste(mulan, " -t ", train_file, ".arff -T ", test_file, ".arff -x ", train_file, ".xml -o out.csv -a ECC -c J48", sep = "")

# apresenta o comando 
print(mulanstr)

# executa o comando
system(mulanstr)

# medias do mulan
system("cat out.csv")


# apurando as medidas com o utiml
# ler as predições no pred_out.csv
preds <- as.matrix(read.csv("pred_out.csv", header = FALSE))

# obtendo o arquivo de teste
dstest <- mldr(test_file, force_read_from_file = T)

# calculando os resultados (threshold 0.5 default)
result <- multilabel_evaluate(dstest, preds, labels=TRUE)

result
