/* ========================================
   DEMO 1: Basic rplot() with Base R
   ======================================== */
proc r;
submit;
# Create a simple scatter plot
x <- 1:100
y <- x^2 + rnorm(100, 0, 100)
 
# Use rplot to display in SAS output
rplot({
  plot(x, y,
       main = "Base R Scatter Plot",
       xlab = "X Values",
       ylab = "Y Values",
       col = "blue",
       pch = 19)
  abline(lm(y ~ x), col = "red", lwd = 2)
})
endsubmit;
run;
 
/* ========================================
   DEMO 2: rplot() with ggplot2
   ======================================== */
proc r;
submit;
library(ggplot2)
 
# Create sample data
df <- data.frame(
  category = rep(c("A", "B", "C", "D"), each = 25),
  value = c(rnorm(25, 10, 2),
            rnorm(25, 15, 3),
            rnorm(25, 12, 2.5),
            rnorm(25, 18, 4))
)
 
# Create ggplot object
p <- ggplot(df, aes(x = category, y = value, fill = category)) +
  geom_boxplot(alpha = 0.7) +
  theme_minimal() +
  labs(title = "Distribution by Category",
       x = "Category",
       y = "Value") +
  scale_fill_brewer(palette = "Set2")
 
# Display in SAS output
rplot(p, filename = "boxplot_demo.png")
endsubmit;
run;
 
/* ========================================
   DEMO 3: Multiple plots in sequence
   ======================================== */
proc r;
submit;
library(ggplot2)
 
# Dataset from SAS
cars_df <- sd2df("sashelp.cars")
 
# Plot 1: Scatter plot
p1 <- ggplot(cars_df, aes(x = Weight, y = MPG_City)) +
  geom_point(aes(color = Type), alpha = 0.6, size = 3) +
  geom_smooth(method = "lm", se = TRUE, color = "red") +
  theme_minimal() +
  labs(title = "Fuel Efficiency vs Weight",
       x = "Weight (lbs)",
       y = "City MPG")
 
rplot(p1, filename = "scatter_mpg.png")
 
# Plot 2: Bar chart
type_summary <- aggregate(MSRP ~ Type, data = cars_df, FUN = mean)
 
p2 <- ggplot(type_summary, aes(x = reorder(Type, MSRP), y = MSRP)) +
  geom_col(fill = "steelblue", alpha = 0.8) +
  coord_flip() +
  theme_minimal() +
  labs(title = "Average MSRP by Vehicle Type",
       x = "Vehicle Type",
       y = "Average MSRP ($)")
 
rplot(p2, filename = "bar_msrp.png")
 
# Plot 3: Histogram
p3 <- ggplot(cars_df, aes(x = Horsepower)) +
  geom_histogram(binwidth = 20, fill = "darkgreen",
                 alpha = 0.7, color = "black") +
  theme_minimal() +
  labs(title = "Distribution of Horsepower",
       x = "Horsepower",
       y = "Count")
 
rplot(p3, filename = "hist_hp.png")
endsubmit;
run;
 

