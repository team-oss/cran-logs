# get the cran check results and parse out the table to determine the production status
library(readr)
library(dplyr)
library(xml2)
library(rvest)
library(stringr)

#' Are all the CRAN builds "OK"
#' read in the path where the html of the cran check results are
#' get the first table and return whether or not all the builds are "OK"
#' 
#' filter by *-release-* then look at status if status showed ERROR FAIL, it is not production ready
#' OK NOTE WARN it was marked as production ready
status_all_ok <- function(cran_chk_path) {
  pg <- xml2::read_html(cran_chk_path)
  tbl <- rvest::html_table(pg)[[1]]
  release <- dplyr::filter(tbl, stringr::str_detect(Flavor, 'release'))
  stat <- dplyr::pull(release, Status)
  #print(release)
  #print(stat)
  
  if (any(stat %in% c("ERROR", "FAIL"))){
    return(FALSE)
  } else if (all(stat %in% c("OK", "NOTE", "WARN"))) {
    return(TRUE)
  } else {
    return(NA)
  }
}

cran_chk <- readr::read_rds(here::here('./data/oss2/processed/cran/cran_pkg_chk.RDS'))

cran_chk <- cran_chk %>%
  dplyr::mutate(cran_chk_exist = file.exists(cran_chk_path)) %>%
  {.}

# check if we got all the packages
for_test <- cran_chk %>%
  dplyr::summarize(missing_download = sum(!cran_chk_exist, na.rm = TRUE)) %>%
  dplyr::pull(missing_download)

for_test %>% testthat::expect_equal(0)
stopifnot(for_test == 0)


# add production status
cran_chk <- cran_chk %>%
  dplyr::mutate(
    production_ready = purrr::map_lgl(cran_chk$cran_chk_path, status_all_ok)
)

# counts
sum(cran_chk$production_ready)
nrow(cran_chk) - sum(cran_chk$production_ready) # 369 not production ready

cran_chk %>% head()

readr::write_csv(cran_chk, here::here('./data/oss2/processed/cran/cran_prod_rdy.csv'))
