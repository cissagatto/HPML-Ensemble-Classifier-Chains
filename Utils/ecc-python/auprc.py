##############################################################################
# HYBRID PARTITIONS FOR MULTI-LABEL CLASSIFICATION (HPML)                    #
# ENSEMBLE OF CLASSIFIERS CHAINS IN PYTHON                                   #
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


import sys
from sklearn.metrics import average_precision_score
import matplotlib.pyplot as plt
import pandas as pd

y_true = pd.read_csv(sys.argv[1])
y_pred = pd.read_csv(sys.argv[2])
name = sys.argv[3]

micro = average_precision_score(y_true, y_pred, average = "micro")
macro = average_precision_score(y_true, y_pred, average = "macro")

res = pd.DataFrame([micro, macro]).T
res.columns = ["Micro-AUPRC", "Macro-AUPRC"]
res.to_csv(name, index=False)

