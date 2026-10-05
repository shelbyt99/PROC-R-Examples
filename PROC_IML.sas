/* ========================================
   Check availability
   ======================================== */

/* Check if SAS/IML is installed */
proc setinit;
run;

/* Check if RLANG system option is set to RLANG */
proc options option = rlang;
run;


/* ========================================
   Basics
   ======================================== */

/* Basic Structure of PROC IML */
PROC IML;
    call ExportDataSetToR("<SAS libname.dataset>", "<R data frame>");
    submit / R;

    R code block

    end submit;
    call ImportDataSetFromR("<SAS dataset to write>", "<R data frame>");
quit;


/* Example */
PROC IML;
    call exportdatasettoR("sashelp.heart", "df");
    submit / R;

    summary(df)

    endsubmit;
quit;


/* Available Packages */
PROC IML;
submit / R;
    pkg <- data.frame(installed.packages()[,c(1,3)])
    version <- R.version.string
   
    version
    pkg
endsubmit;
quit;


/* Example */
proc iml;
call exportdatasettoR("Sashelp.heart", "df");
submit / R;
    library(tidyverse)
    df50 <- df %>%
                filter(AgeCHDdiag <=50) %>%
                mutate(BMI = (Weight*703)/Height^2)
endsubmit;
call ImportDataSetFromR("work.heart50", "df50");
quit;

proc print data=work.heart50;
run;


/* ========================================
   Regression
   ======================================== */

/* lm() function in R */
proc iml;
  submit / R;
    library(MASS, lib.loc=.Library)
    # use a data frame from MASS
    lm(VitC ~ Cult + Date + HeadWt, data=cabbages)
  endsubmit;
run;

/* proc glm in SAS */
proc iml;
  submit / R;
  library(MASS, lib.loc=.Library)
  endsubmit;
  call ImportDataSetFromR("cabbages", "cabbages");
run;

proc glm data=cabbages;
    class Cult Date;
    model VitC = Cult Date HeadWt / solution;
run;



/* ========================================
   Graphics
   ======================================== */

/* base R */
proc iml;
    call ExportDataSetToR("sashelp.cars", "df");

    submit / R;

    options(bitmapType = "cairo")

    png("/innovationlab-export/innovationlab/homes/Shelby.Taylor@sas.com/casuser/cars_plot.png", width=800, height=600)

    plot(df$Horsepower, df$MPG_City,
         main="Horsepower vs MPG City",
         xlab="Horsepower",
         ylab="MPG City",
         pch=19,
         col="blue")

    dev.off()

    endsubmit;
quit;


/*ggplot */
proc iml;
    call ExportDataSetToR("sashelp.cars", "df");

    submit / R;
    library(ggplot2)

    # Avoid X11
    options(bitmapType = "cairo")

    # Open PNG device
    png("/innovationlab-export/innovationlab/homes/Shelby.Taylor@sas.com/casuser/cars_plot_ggplot2.png", width=800, height=600)

    # Create plot
    p <- ggplot(df, aes(x = Horsepower, y = MPG_City)) +
         geom_point(color = "steelblue", size = 2) +
         ggtitle("Horsepower vs MPG City") +
         xlab("Horsepower") +
         ylab("MPG City") +
         theme_minimal()

 
    print(p)

    # Close device
    dev.off()

    endsubmit;
quit;

