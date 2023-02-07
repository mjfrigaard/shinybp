# ===================================================#
# File name: data.R
# This is code to create: data for shinymods
# Authored by and feedback to: mjfrigaard
# Last updated: 2022-09-10
# MIT License
# Version: 0.1.3
# ===================================================#

# packages ------------------------------------------
library(dplyr)
library(openxlsx)
library(Lahman)
library(readr)

# export iris -------------------------------------------------------------
readr::write_csv(x = iris, file = "inst/extdata/csv/iris.csv")
readr::write_tsv(x = iris, file = "inst/extdata/tsv/iris.tsv")
readr::write_delim(x = iris, file = "inst/extdata/txt/iris.txt")

# create starwars data ----------------------------------------------------
sw_data <- dplyr::select(.data = dplyr::starwars, !where(is.list))
readr::write_csv(sw_data, file = "inst/extdata/csv/sw_data.csv")

# create Lahman workbook --------------------------------------------------
lahman_wb <- openxlsx::createWorkbook()
# create lahman datasets  --------------------------------------------------
People <- Lahman::People
People500 <- dplyr::slice_sample(.data = People, n = 500, replace = FALSE)
openxlsx::addWorksheet(lahman_wb, sheetName = "People", gridLines = FALSE)
openxlsx::writeDataTable(lahman_wb, sheet = "People", x = People500,
  colNames = TRUE, rowNames = FALSE, withFilter = FALSE)

Batting <- Lahman::Batting
Batting500 <- dplyr::slice_sample(.data = Batting, n = 500, replace = FALSE)
openxlsx::addWorksheet(lahman_wb, sheetName = "Batting", gridLines = FALSE)
openxlsx::writeDataTable(lahman_wb, sheet = "Batting", x = Batting500,
  colNames = TRUE, rowNames = FALSE, withFilter = FALSE)

Teams <- Lahman::Teams
Teams500 <- dplyr::slice_sample(.data = Teams, n = 500, replace = FALSE)
openxlsx::addWorksheet(lahman_wb, sheetName = "Teams", gridLines = FALSE)
openxlsx::writeDataTable(lahman_wb, sheet = "Teams", x = Teams500,
  colNames = TRUE, rowNames = FALSE, withFilter = FALSE)

Salaries <- Lahman::Salaries
Salaries500 <- dplyr::slice_sample(.data = Salaries, n = 500, replace = FALSE)
openxlsx::addWorksheet(lahman_wb, sheetName = "Salaries", gridLines = FALSE)
openxlsx::writeDataTable(lahman_wb, sheet = "Salaries", x = Salaries500,
  colNames = TRUE, rowNames = FALSE, withFilter = FALSE)

# save xlsx workbook ------------------------------------------------------
openxlsx::saveWorkbook(lahman_wb, "inst/extdata/xlsx/lahman500.xlsx",
  overwrite = TRUE)

# export Lahman csv files -------------------------------------------------
readr::write_csv(People500, "inst/extdata/csv/People500.csv")
readr::write_csv(Batting500, "inst/extdata/csv/Batting500.csv")

# export Lahman tsv files -------------------------------------------------
readr::write_tsv(People500, "inst/extdata/tsv/People500.tsv")
readr::write_tsv(Batting500, "inst/extdata/tsv/Batting500.tsv")

# export Lahman txt files -------------------------------------------------
readr::write_delim(People500, "inst/extdata/txt/People500.txt")
readr::write_delim(Batting500, "inst/extdata/txt/Batting500.txt")
