library(rvest)
library(progress)
library(stringr)
library(here)

source(here('./R/scrape_pypi.R'))

download_simple_pkg_page <- function(url,
                                     save_path_dir = here('./data/oss2/original/pypi/pypi_simple/simple_pkg_htmls/'),
                                     overwrite = FALSE,
                                     sleep = runif(1)) {
  #pkg_name <- stringr::str_remove(url, "https://pypi.org/*simple/")
  #pkg_name_clean <- stringr::str_remove_all(pkg_name, '/')
  #save_path <- paste0(save_path_dir, pkg_name_clean, '.html')
  save_path <- create_fname_url_html(url, save_path_dir)
  
  # You want to skip the html download if the file exists or if overwrite is TRUE
  # this prevents unnecessary pings to the server
  if (file.exists(save_path)) {
    if (overwrite) {
      # if the file exists and overwrite is TRUE
      # download
      tryCatch({
        html <- xml2::read_html(url)
        xml2::write_html(x = html, save_path)
        Sys.sleep(sleep)
        return(save_path)
      }, error = function(e) {
        Sys.sleep(sleep)
        return(NULL)
      })
    } else {
      # if the file exists and overwrite is FALSE
      # don't download
      return(sprintf('exists: %s', save_path))
    }
  } else {
    # if the file does not exist, download
    tryCatch({
      html <- xml2::read_html(url)
      xml2::write_html(x = html, save_path)
      Sys.sleep(sleep)
      return(save_path)
    }, error = function(e) {
      Sys.sleep(sleep)
      return(NULL)
    })
  }
}

pypi_pkgs <- xml2::read_html(here('./data/oss2/original/pypi/pypi_simple/2019-01-23-pypi_simple.html'))

pkg_urls <- pypi_pkgs %>%
  html_nodes('a') %>%
  html_attr('href')

BASE_URL <- 'https://pypi.org'

full_urls <- paste0(BASE_URL, pkg_urls)

# test
# download_simple_pkg_page(full_urls[[1]])

# 2019-01-24: loop broke after cerberus.html
# seems like the 404 error comes from cerberus_collections
# https://pypi.org/simple/cerberus-collections/
# link seems to work, 404 may be from server block...?

# download the html for all the package URLS
pb <- progress_bar$new(format = "[:bar] :current/:total (:percent)", total = length(full_urls))
pb$tick(0)
for (pkg_i in seq_along(full_urls)) {
  pkg <- full_urls[[pkg_i]]
  if(!interactive()) {
    print(sprintf('%s: %s', pkg_i, pkg))
  }
  download_simple_pkg_page(pkg) # sleep done in the function
  if (interactive()) {
    pb$tick(1)
  }
  # worst case is this will take almost 2 days
  # break
}
