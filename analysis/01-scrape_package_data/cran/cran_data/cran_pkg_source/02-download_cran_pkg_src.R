library(readr)
library(purrr)

pkg_dl_links <-  readr::read_csv(here::here('./data/oss2/processed/cran/cran_src_pkg_dl_links.csv'))

#safely_dl_file <- purrr::safely(download.file)
#purrr::walk(.x = pkg_dl_links$src_pkg_dl_url, .f = safely_dl_file, destfile = here::here(pkg_dl_links$src_pkg_dl_sv_pth))


for (i in seq_along(pkg_dl_links$src_pkg_dl_url)) {
  url <- pkg_dl_links$src_pkg_dl_url[[i]]
  pth <- here::here(pkg_dl_links$src_pkg_dl_sv_pth[[i]])
  
  if (file.exists(pth)) {
    next
  } else {
    print(i)
    print(url)
    print(pth)
    tryCatch({
      utils::download.file(url = url, destfile = pth)
    }, error = function(e) {
      print("FAIL")
      print("****************************************************************")
    })
  }
}

print('done.')