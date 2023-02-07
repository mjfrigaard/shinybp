# pkgs -----------------------------
library(shiny)
library(readxl)
library(htmltools)
library(reactable)
library(stringr)

# NEED DATA?? Download an files from links below:
# https://bit.ly/xlsx_iris
# https://bit.ly/sas7bdat_iris
# https://bit.ly/csv_iris


# utils -----------------------------
source("mod_cond_xlsx_utils.R")

# modules -----------------------------
source("mod_cond_xlsx.R")

# UI ----------------------------------
condXlsxUI <- fluidPage(
  mod_cond_xlsx_ui("import"),

  # reactives (dev only)
  br(),
  htmltools::h4(
    htmltools::code("App reactive values")
  ),
  shiny::fluidRow(
    shiny::column(
      width = 12,
      shiny::verbatimTextOutput(outputId = "values")
    )
  )
)

condXlsxServer <- function(input, output) {
  mod_cond_xlsx_server("import")
  # reactives (dev only)
  all_vals <- reactive({
    shiny::reactiveValuesToList(
      x = input,
      all.names = TRUE
    )
  })

  output$values <- shiny::renderPrint({
    # remove reactable ids
    react_ids <- stringr::str_detect(names(all_vals()),
      "__reactable__",
      negate = TRUE
    )
    all_vals()[react_ids]
  })
}
condXlsxDemo <- function() {
  shiny::shinyApp(ui = condXlsxUI,
                  server = condXlsxServer,
                  options = list(width = 800))
}
condXlsxDemo()
