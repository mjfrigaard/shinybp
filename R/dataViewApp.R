#' dataViewApp (demo)
#'
#' @importFrom shiny shinyApp
#' @importFrom shiny fluidPage column
#' @importFrom shiny verbatimTextOutput reactive
#' @importFrom shiny reactiveValuesToList renderPrint
#' @importFrom stringr str_detect
#' @importFrom htmltools h4 code
#'
#' @return shiny app
#' @export dataViewApp
#'
#' @examples
#' # library(shinybp)
#' # dataViewApp()
dataViewApp <- function() {

  # NEED DATA?? Download example files from links below:
  # https://bit.ly/xlsx_iris
  # https://bit.ly/sas7bdat_iris
  # https://bit.ly/csv_iris

  shiny::shinyApp(
    ui = shiny::fluidPage(
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
    ),
    server = function(input, output) {
      mod_cond_xlsx_server("import")
      # reactives (dev only)
      all_vals <- shiny::reactive({
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
    },
    options = list(width = 800)
  )
}
