
<!-- README.md is generated from README.Rmd. Please edit that file -->

# shinybp

<!-- badges: start -->
<!-- badges: end -->

The goal of `shinybp` is to document a collection of shiny app testing
best practices (and *hopefully* generate a test report with a
traceability matrix)

## Installation

You can install the development version of `shinybp` from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("mjfrigaard/shinybp")
```

## To-dos

1.  Create a documented list of shiny app testing best practices
    - differentiate between:
      - unit testing  
      - integration testing  
      - sanity tests  
      - system testing
2.  Create a demo application for listing features and performing tests
    - [x] `condXlsxApp` (demo):
      - The `condXlsxApp` has:
        1.  modules  
        2.  utility functions  
        3.  conditional UI features  
        4.  uploads  
        5.  downloads  
      - <https://mjfrigaard.shinyapps.io/condXlsxDemo/>
