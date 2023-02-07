#' Import flat data file
#'
#' @param path path to file
#'
#' @return imported flat file
#' @export import_flat_file
#'
#' @importFrom vroom vroom
#' @importFrom haven read_sas read_sav read_dta
#' @importFrom tibble as_tibble
#'
import_flat_file <- function(path) {
  ext <- tools::file_ext(path)
  data <- switch(ext,
    txt = vroom::vroom(path),
    csv = vroom::vroom(path, delim = ","),
    tsv = vroom::vroom(path, delim = "\t"),
    sas7bdat = haven::read_sas(data_file = path),
    sas7bcat = haven::read_sas(data_file = path),
    sav = haven::read_sav(file = path),
    dta = haven::read_dta(file = path)
  )
  # just to be sure
  return_data <- tibble::as_tibble(data)
  return(return_data)
}


#' Import data
#'
#' @param path path to file
#' @param sheet sheet number or name (if .xlsx)
#'
#' @return imported data
#' @export import_data
#'
#' @importFrom tools file_ext
#' @importFrom readxl read_excel
#' @importFrom tibble as_tibble
#'
import_data <- function(path, sheet = NULL) {
  ext <- tools::file_ext(path)
  if (ext == "xlsx") {
    raw_data <- readxl::read_excel(
        path = path,
        sheet = sheet
      )
    uploaded <- tibble::as_tibble(raw_data)
  } else {
    # call the import function
    uploaded <- import_flat_file(path = path)
  }
  return(uploaded)
}
