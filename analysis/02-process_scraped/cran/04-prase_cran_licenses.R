library(readr)
library(here)
library(rvest)
library(dplyr)

get_pkg_metadata_tbl <- function(pkg_html_path) {
  meta_tbl <- here::here(pkg_html_path) %>%
    xml2::read_html() %>%
    rvest::html_table() %>%
    magrittr::extract2(1)
  return(meta_tbl)
}

get_license_from_meta_tbl <- function(tbl) {
  tbl %>%
    dplyr::filter(X1 == 'License:') %>%
    dplyr::pull(X2)
}

crn_pkg_pg <- read_csv(here::here('./data/oss2/processed/pkg_links.csv'))

crn_pkg_pg <- crn_pkg_pg %>%
  dplyr::mutate(pkg_metadata = purrr::map(pkg_path, get_pkg_metadata_tbl),
                license_raw = purrr::map_chr(pkg_metadata, get_license_from_meta_tbl)
                )

readr::write_rds(crn_pkg_pg, here::here('./data/oss2/processed/cran/cran_meta_licenses_raw.RDS'))
