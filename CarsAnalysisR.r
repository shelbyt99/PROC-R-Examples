library(tidyverse)

VMake <- symget("Make")
carsdf <- sd2df("sashelp.cars")

mycars <- carsdf %>%
filter(Make == VMake)

# Create a macro variable in SAS from R
avg_msrp <- mean(mycars$MSRP, na.rm = TRUE)
symput("AvgPrice", avg_msrp)

df2sd(mycars, "work.filtered_cars")

p <- ggplot(mycars, aes(x = MPG_Highway)) +
     geom_histogram(binwidth = 5, fill = "#69b3a2",
     color = "#1f3552", alpha = 0.8) +
     labs(
        title = "Distribution of Highway MPG",
        x = "Highway MPG",
        y = "Count"
        ) +
     theme_minimal(base_size = 14) +
     theme(
     plot.title = element_text(hjust = 0.5, face = "bold"),
     axis.title = element_text(face = "bold"),
     panel.grid.minor = element_blank()
)

    rplot(p)

