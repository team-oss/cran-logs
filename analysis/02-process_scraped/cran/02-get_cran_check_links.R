library(here)
library(rvest)
library(dplyr)
library(purrr)
library(here)
library(stringr)

pkg_html_tbl <- function(pkg_path) {
  pkg_html <- read_html(e)
  
  pkg_results <- pkg_html %>%
    html_table()
  
  pkg_df <- dplyr::bind_rows(pkg_results)
  return(pkg_df)
}



cran_pkgs <- readr::read_csv(here::here('./data/oss2/processed/pkg_links.csv'))

cran_chk <- cran_pkgs %>%
  #dplyr::slice(1:5) %>%
  dplyr::mutate(#pkg_html_tbl = purrr::map(here::here(pkg_path), pkg_html_tbl),
                # https://cran.r-project.org/web/checks/check_results_ztype.html
                cran_chk_link = sprintf('https://cran.r-project.org/web/checks/check_results_%s.html', pkg_name),
                cran_chk_path = sprintf('./data/oss2/original/cran/cran_chk_pages/%s.html', pkg_name))

head(cran_chk)

readr::write_rds(cran_chk, here::here('./data/oss2/processed/cran/cran_pkg_chk.RDS'))
