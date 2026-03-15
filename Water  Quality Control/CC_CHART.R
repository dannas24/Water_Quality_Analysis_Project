library(qcc)
library(dplyr)

save_yearly_qcc <- function(df, variable, label) {
  # Clean dataset
  df <- df %>%
    mutate(
      Date = as.Date(Date),
      Year = format(Date, "%Y"),
      Value = as.numeric(.data[[variable]])
    ) %>%
    filter(!is.na(Value))
  years <- unique(df$Year)
  folder_name <- paste0(gsub(" ", "_", label), "_Folder")
  dir.create(folder_name, showWarnings = FALSE)
  
  for (yr in years) {
    df_year <- df %>% filter(Year == yr)
    x <- df_year$Value
    file_path <- file.path(folder_name, paste0(label, "_", yr, ".png"))
    png(filename = file_path, width = 2000, height = 1200, res = 150)
    q <- qcc(
      x,
      type = "xbar.one",
      xlab = "Observation Order",
      ylab = variable,
      title = paste(label, "-", yr),
      plot = TRUE)
    points(q$statistics, pch = 19, cex = 0.4, col = "blue")
    dev.off()  # close the PNG device
    cat("Saved chart:", file_path, "\n")}
  cat("\nAll yearly charts saved in folder:", folder_name, "\n")}

####  Data set china and  usa  ##############

china   <- read.csv("china_Cleaned.csv")
usa     <- read.csv("USA_Cleaned.csv")
usa_lake  <- subset(usa, Waterbody.Type == "Lake")
usa_river <- subset(usa, Waterbody.Type == "River")

##### CC CHINA  ##########

save_yearly_qcc(china, "Dissolved.Oxygen..mg.l.", "Dissolved_Oxygen_China")
save_yearly_qcc(china, "pH..ph.units.", "pH_China")
save_yearly_qcc(china, "Nitrogen..mg.l.", "Nitrogen_China")

##### CC USA  LAKE #######
save_yearly_qcc(usa_lake, "Dissolved.Oxygen..mg.l.", "Dissolved_Oxygen_USA_Lake")
save_yearly_qcc(usa_lake, "pH..ph.units.", "pH_Usa_Lake")
save_yearly_qcc(usa_lake, "Nitrogen..mg.l.", "Nitrogen_Usa_Lake")

#####  CC USA  RIVER ######
save_yearly_qcc(usa_river, "Dissolved.Oxygen..mg.l.", "Dissolved_Oxygen_USA_River")
save_yearly_qcc(usa_river, "pH..ph.units.", "pH_Usa_River")
save_yearly_qcc(usa_river, "Nitrogen..mg.l.", "Nitrogen_Usa_River")
