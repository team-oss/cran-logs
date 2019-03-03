library(readr)
library(rvest)
library(tibble)

get_src_pkg_fn <- function(pkg_html_path) {
  pkg_html <- pkg_html_path %>%
    xml2::read_html()
  
  pkg_dl_tbl <- pkg_html %>%
    html_table() %>%
    magrittr::extract2(2) %>%
    dplyr::mutate(X1 = stringi::stri_enc_toascii(X1))
  
  pkg_source_fn <- pkg_dl_tbl %>%
    dplyr::filter(X1 == "Package\032source:") %>%
    dplyr::pull(X2)
  
  return(pkg_source_fn)
}

cran_pkgs <- readr::read_csv(here::here('./data/oss2/processed/pkg_links.csv'))

cran_pkgs <- cran_pkgs %>%
  dplyr::mutate(
    src_pkg_fn = purrr::map_chr(here::here(pkg_path), get_src_pkg_fn)
  )

cran_pkgs <- cran_pkgs %>%
  dplyr::mutate(
    src_pkg_dl_url = paste0('https://cran.r-project.org/src/contrib/', src_pkg_fn),
    src_pkg_dl_sv_pth = paste0('./data/oss2/original/cran/cran_pkg_source/', src_pkg_fn)
  )

readr::write_csv(cran_pkgs, here::here('./data/oss2/processed/cran/cran_src_pkg_dl_links.csv'))
