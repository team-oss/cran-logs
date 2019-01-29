library(readr)
library(here)

pypi_dl_urls <- readr::read_csv(here::here('./data/oss2/processed/pypi/simple_url_src_paths.csv'))

pypi_dl_urls

for (i in seq_along(pypi_dl_urls$last_pkg_dl_url)) {
  if(!interactive()){
    print(i)
  }
  dl_url <- pypi_dl_urls$last_pkg_dl_url[[i]]
  
  if (is.na(dl_url) | is.null(dl_url) | dl_url == "NULL") {
    next
  } else {
    sv_pth <- here::here(pypi_dl_urls$src_save_path[[i]])
    tryCatch({
      if(!interactive()){
        print(dl_url)
        print(sv_pth)
      }
      if (file.exists(sv_pth)) {
        next
      } else {
        download.file(dl_url, sv_pth)
        Sys.sleep(runif(1))
      }
    }, error = function(e) {
      Sys.sleep(runif(1))
      next
    })
  }
  #break
}
