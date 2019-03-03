#
# script takes about 6 minutes to run
# see the last_urls <- purrr::map(what_i_have$html_save_path, safely_get_latest_pkg_src_dl)
# on line ~83

library(here)
library(rvest)
library(tibble)
library(rvest)
library(dplyr)
library(purrr)
library(readr)

source(here('./R/scrape_pypi.R'))

scraped_pkgs_html <- list.files(here('./data/oss2/original/pypi/pypi_simple/simple_pkg_htmls'),
                                full.names = TRUE, no.. = TRUE)
scraped_pkgs_html[1:5]
scraped_pkgs_html[(length(scraped_pkgs_html) - 5):length(scraped_pkgs_html)]

pypi_pkgs <- xml2::read_html(here('./data/oss2/original/pypi/pypi_simple/2019-01-23-pypi_simple.html'))

pkg_urls <- pypi_pkgs %>%
  html_nodes('a') %>%
  html_attr('href')

# Missing html packages -----

# number of package html that were not able to be pulled from website (25)
(num_miss <- length(pkg_urls) - length(scraped_pkgs_html))
stopifnot(num_miss == 25)

BASE_URL <- 'https://pypi.org'
full_urls <- paste0(BASE_URL, pkg_urls)
paths <- create_fname_url_html(full_urls)

pypi_pkgs_names <- pypi_pkgs %>%
  html_nodes('a') %>%
  html_text()

paths[1:5]
pypi_pkgs_names[1:5]

length(paths)
length(pypi_pkgs_names)
length(scraped_pkgs_html)

scraped_html <- tibble(server_path = scraped_pkgs_html,
                       on_server = TRUE)

df <- tibble(
  name = pypi_pkgs_names,
  html_save_path = paths
)

what_i_have <- df %>%
  dplyr::left_join(scraped_html, by = c('html_save_path' = 'server_path'))

stopifnot(nrow(what_i_have) == length(pkg_urls))

table(what_i_have$on_server, useNA = 'always')

stopifnot(sum(is.na(what_i_have$on_server)) == num_miss)

# Find the url of the lastest package

get_latest_pkg_src_dl <- function(html_path) {
  html <- xml2::read_html(html_path)
  
  links <- html %>%
    html_nodes('a')
  
  last_link <- links[length(links)] %>%
    html_attr('href')
  
  return(last_link)
}

safely_get_latest_pkg_src_dl <- purrr::safely(get_latest_pkg_src_dl)

t0 <- Sys.time()
last_urls <- purrr::map(what_i_have$html_save_path, safely_get_latest_pkg_src_dl)
t1 <- Sys.time()

print(t1 - t0)

#last_urls

trans_urls <- purrr::transpose(last_urls)

get_filename_from_url <- function(url) {
  bn <- basename(url)
  fn <- stringr::str_remove(bn, '#.*')
  return(fn)
}

what_i_have <- what_i_have %>%
  dplyr::mutate(last_pkg_dl_url = as.character(trans_urls$result),
                last_pkg_dl_url = dplyr::recode(last_pkg_dl_url, 'character(0)' = NA_character_),
                filename = get_filename_from_url(last_pkg_dl_url),
                src_save_path = paste0('./data/oss2/original/pypi/pypi_simple/simple_pkg_src/', filename),
                html_save_path = stringr::str_extract(html_save_path, './data/.*')
                )

readr::write_csv(what_i_have, './data/oss2/processed/pypi/simple_url_src_paths.csv')
