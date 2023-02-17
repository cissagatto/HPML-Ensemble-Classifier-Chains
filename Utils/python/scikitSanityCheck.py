import sys
import pandas as pd
from sklearn.ensemble import RandomForestRegressor

#MEDIR ERRO OUTROS OUTPUTS
#CHEATAR USANDO OUTPUTS REAIS E N PREDICOES PARA VER PERFORMANCE
toDrop = ['Patnr', 'CENTRE','Studienaam']

icuDay1Features = [ 'ICU_Glycemia_admission', 
            'ICU_Morningglycemia_day1',
               'ICU_Creatinin_day1', 
               'ICU_Bili_day1', 
               'ICU_CRP_day1',
               'ICU_STEROIDS_day1',
               'ICU_Mechanicalventilation_Day1',
               'Sofa_PaO2FiO2d1',
               ]
baselineFeatures = ['BL_Age_ctu', 
                'BL_gender_dicho', 
                'BL_BMI_ctu',
                'BL_BMI_dicho_25to40', 
                'BL_Malignancy_dicho', 
                'BL_Diabetes_dicho',
                   'BL_preadmission_dialysidicho', 
                   'BL_Randomisation', 
                   'BL_APACHEII',
                   'BL_infection_on_admission', 
                   'BL_Sepsis_admission_dicho'
                   ]

features = baselineFeatures[:]
features.extend(icuDay1Features)

extraOutputs = [
#                'OUTCOME_ICU_STAY_days',
 #               'OUTCOME_ICUmortality',
  #             'OUTCOME_HOSP_STAY_days',
   #             'OUTCOME_daysMV',
                ]

label = ["FirstMRC_dicho"]
n_trees = 200
random_seed = 1234
random_state = 0
if __name__ == '__main__':
    n_chains = 1
    if len(sys.argv) > 2:        
        unlabeled = pd.read_csv(sys.argv[2]).drop(toDrop,axis=1)
    else:
        unlabeled = None
    for fold in range(1,6):
        print ("fold " + str(fold))
        train = pd.read_csv(sys.argv[1].replace("fold1","fold" + str(fold))).drop(toDrop,axis=1)
        test = pd.read_csv(sys.argv[1].replace("fold1","fold" + str(fold)).replace("train","test")).drop(toDrop,axis=1)
        x_train = train.drop(label, axis=1)[features]
        y_trainFinal = pd.DataFrame(train[label])
        model = RandomForestRegressor(n_estimators=n_trees, random_state = random_state)
        model.fit(x_train,
                  y_trainFinal)
#        print(x_train)
 #       print(y_trainFinal)
        x_test = test.drop(label, axis=1)[features]
        test_predictions = pd.DataFrame(model.predict(x_test))
        fileName = sys.argv[1].replace("train_fold1.csv","") + "SanityChecktest_predictions"
        train_predictions = pd.DataFrame(model.predict(x_train))
        fileNameTrain = sys.argv[1].replace("train_fold1.csv","") + "SanityChecktrain_predictions"
        print(test_predictions)
        if unlabeled is not None:
          fileName+="_unlabeled_"  
          fileNameTrain+="_unlabeled_"  
        
        fileName+= "fold" + str(fold) + ".csv"
        fileNameTrain+= "fold" + str(fold) + ".csv"

        test_predictions.to_csv(fileName, index=False)
        train_predictions.to_csv(fileNameTrain, index=False)
        if fold > 1:  
            print(test_predictions)
            sys.exit()