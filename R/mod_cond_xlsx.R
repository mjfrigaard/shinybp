#' Conditional xlsx panel (UI)
#'
#' @param id
#'
#' @return shiny UI layout
#' @export mod_cond_xlsx_ui
#'
#' @importFrom shiny NS tagList fluidRow
#' @importFrom shiny column fileInput uiOutput
#' @importFrom shiny verbatimTextOutput
#' @importFrom htmltools br strong code
#' @importFrom reactable reactableOutput
#'
mod_cond_xlsx_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
  shiny::fluidRow(
    shiny::column(width = 4,
      # import a data file
      shiny::fileInput(
        inputId = ns("data_import"),
        label = "Please upload a data file"
      ),
      # any file type
      accept = c(
        ".csv", ".tsv", ".txt",
        ".sas7bdat", ".dta", ".sav"
      )
    ),
    # conditional sheets for .xlsx
    shiny::column(width = 4,
      shiny::uiOutput(ns("cond_xlsx")))
  ),
  # file extension output
  shiny::fluidRow(
    shiny::column(width = 6,
      shiny::uiOutput(ns("upload_ext_txt")))
  ),
  # reactive values (dev only)
  shiny::fluidRow(
    shiny::column(width = 12,
      htmltools::br(),
      htmltools::strong(
        htmltools::code("module reactive values")
      ),
      shiny::verbatimTextOutput(outputId = ns("values"))
    )
  ),
    shiny::fluidRow(
      shiny::column(width = 12,
        reactable::reactableOutput(ns("display_upload")))
    )
  )
}

#' Conditional xlsx panel (Server)
#'
#' @param id
#'
#' @return shiny server
#' @export mod_cond_xlsx_server
#'
#' @importFrom shiny moduleServer NS renderUI
#' @importFrom shiny renderUI req updateSelectInput
#' @importFrom shiny reactive observe bindEvent
#' @importFrom shiny reactiveValuesToList renderPrint
#' @importFrom htmltools em
#' @importFrom tools file_ext
#' @importFrom stringr str_detect
#' @importFrom readxl excel_sheets
#' @importFrom reactable reactable reactableOutput
mod_cond_xlsx_server <- function(id) {

    shiny::moduleServer( id, function(input, output, session){
    ns <- session$ns

# UI output for file extension
  output$upload_ext_txt <- shiny::renderUI({
    htmltools::em(
      paste(
        "The uploaded file extension is: ",
        tools::file_ext(input$data_import$datapath)
      )
    )
  })

  # conditional selectInput() for xlsx files
  output$cond_xlsx <- shiny::renderUI({

    shiny::req(
      tools::file_ext(input$data_import$datapath) == "xlsx")

    shiny::selectInput(
      inputId = ns("sheet"),
      label = "please selelct a sheet",
      choices = c("", NULL),
      selected = NULL)

  })

  # update selectInput() with excel sheets
  shiny::observe({

    shiny::req(
      tools::file_ext(input$data_import$datapath) == "xlsx")

    sheets <- readxl::excel_sheets(
                path = input$data_import$datapath)

    shiny::updateSelectInput(
      inputId = "sheet",
      choices =  sheets)
    }) |>
    # bound to the conditional 'data import'
    shiny::bindEvent(c(input$data_import))

    # reactive imported data
    imported_data <- shiny::reactive({
        if (tools::file_ext(input$data_import$datapath) == "xlsx") {
          imp_sheet <- input$sheet
          uploaded <- import_data(
                          path = input$data_import$datapath,
                          sheet = imp_sheet)
        } else {
          uploaded <- import_data(
                          path = input$data_import$datapath)
        }
        return(uploaded)
      }) |>
      # bind to imported data and sheets
      shiny::bindEvent(c(input$data_import, input$sheet),
                       ignoreNULL = FALSE)

    # display imported data
    shiny::observe({
      shiny::req(input$data_import)
    output$display_upload <- reactable::renderReactable(
        reactable::reactable(
          data = imported_data(),
          defaultPageSize = 5,
          width = 800,
          resizable = TRUE,
          highlight = TRUE,
          compact = TRUE,
          wrap = FALSE,
          bordered = TRUE
        )
      )
    }) |>
      # bind to imported data
      shiny::bindEvent(input$data_import)

  # all reactives (dev only)
  vals <- reactive({
    shiny::reactiveValuesToList(x = input,
                            all.names = TRUE)
  })

  # reactives (dev only)
  output$values <- shiny::renderPrint({
    # remove reactable ids
    react_ids <- stringr::str_detect(names(vals()),
                             "__reactable__",
                             negate = TRUE)
    vals()[react_ids]
  })

    })
}
