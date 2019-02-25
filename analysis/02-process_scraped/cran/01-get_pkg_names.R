library(xml2)
library(rvest)
library(dplyr)
library(stringr)

pkg_html <- xml2::read_html('./data/oss2/original/cran/2019-02-16-cran-pkgs.html')
pkg_html

# this number mis matches the manual parsing below
# because of missing values
tbl <- pkg_html %>%
  rvest::html_table(fill = TRUE) %>%
  .[[1]] %>%
  dplyr::rename(pkg_name = X1,
                pkg_description = X2) %>%
  dplyr::filter(pkg_name != '')

td <- pkg_html %>%
  html_nodes('td')

pkg_links <- td%>%
  html_nodes('a') %>%
  html_attr('href')

pkg_names <- td%>%
  html_nodes('a') %>%
  html_text()

# 13,719 packages
length(pkg_names)
nrow(tbl)

## add links to df
tbl <- tbl %>%
  dplyr::mutate(pkg_links = pkg_links,
                pkg_links = stringr::str_replace(pkg_links, '../../', 'https://cran.r-project.org/'),
                pkg_path = stringr::str_c('./data/oss2/original/cran/cran_pkg_html_pages/', pkg_name, '.html'))
head(tbl)

head(tbl$pkg_links)

readr::write_csv(tbl, './data/oss2/processed/pkg_links.csv')
