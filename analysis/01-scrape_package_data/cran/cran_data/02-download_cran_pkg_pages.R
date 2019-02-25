library(readr)
library(here)

cran_pkgs <- readr::read_csv(here::here('./data/oss2/processed/pkg_links.csv'))

head(cran_pkgs$pkg_links)

for (i in seq_along(cran_pkgs$pkg_name)) {
  pkg_name <- cran_pkgs$pkg_name[[i]]
  pkg_link <- cran_pkgs$pkg_links[[i]]
  pkg_path <- here::here(cran_pkgs$pkg_path)[[i]]
  
  if (!interactive()) {
    print(pkg_name)
    print(pkg_link)
    print(pkg_path)
  }
  
  if (file.exists(pkg_path)) {
    next
  } else {
    pkg_html <- xml2::read_html(pkg_link)
    xml2::write_html(x = pkg_html, pkg_path)
    Sys.sleep(runif(1))
  }
}
