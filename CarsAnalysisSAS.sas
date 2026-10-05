%let Make = Honda;

proc R infile="/innovationlab-export/innovationlab/homes/Shelby.Taylor@sas.com/CarsAnalysisR.r";
run;

%put Average MSRP from R = &AvgPrice;

proc print data=filtered_cars(obs=5);
title "First 5 &Make Cars (Avg MSRP = %sysfunc(putn(&AvgPrice, dollar12.)))";
run;