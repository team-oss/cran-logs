library(readr)

cran_chk <- readr::read_rds(here::here('./data/oss2/processed/cran/cran_pkg_chk.RDS'))

for (i in seq_along(cran_chk$cran_chk_link)) {
  pkg_name <- cran_chk$pkg_name[[i]]
  cran_chk_link <- cran_chk$cran_chk_link[[i]]
  cran_chk_path <- here::here(cran_chk$cran_chk_path)[[i]]
  
  if (file.exists(cran_chk_path)) {
    next
  } else {
    
    if (!interactive()) {
      print(i)
      print(pkg_name)
      print(cran_chk_link)
      print(cran_chk_path)
    }
    
    pkg_html <- xml2::read_html(cran_chk_link)
    xml2::write_html(x = pkg_html, cran_chk_path)
    Sys.sleep(runif(1, min = 0, 5))
  }
}

print('Done.')
