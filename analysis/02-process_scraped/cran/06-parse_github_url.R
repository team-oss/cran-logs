library(readr)
library(dplyr)
library(purrr)
library(stringr)

source(here::here('./R/url_to_gh_slug.R'))

get_url_from_meta_tbl <- function(tbl) {
  url <- tbl %>%
    dplyr::filter(X1 == 'URL:') %>%
    dplyr::pull(X2)
  if (length(url) == 0) {
    return(NA)
  } else {
    return(url)
  }
}

prod_osi <- readr::read_rds(here::here('./data/oss2/processed/cran/production_ready_osi_approved.RDS'))

with_url <- prod_osi %>% 
  dplyr::mutate(url = purrr::map_chr(pkg_metadata, get_url_from_meta_tbl))

with_url$pkg_metadata[[1]]
with_url$pkg_metadata[[2]]
with_url$pkg_metadata[[3]]

with_url <- prod_osi %>% 
  dplyr::mutate(url = purrr::map_chr(pkg_metadata, get_url_from_meta_tbl)) %>%
  dplyr::filter(!is.na(url))

gh_url <- with_url %>%
  dplyr::filter(stringr::str_detect(url, 'github'))

gh_url$url

## findings, some libraries have multiple urls listed: delimiters are , ,\n and maybe \n
## some repos have multiple github repos listed
## sometimes the seond gh rpo is the devel version
## the first url is not necessarily the gh one


count_urls <- function(url_string, url_delim_pattern = ',\\n|,|\\n') {
  # the order of ,\\n and \n or , matter here
  stringr::str_count(url_string, url_delim_pattern) + 1
}
testthat::expect_equal(count_urls('a,b,c'), 3)
testthat::expect_equal(count_urls('a,\nb,\nc'), 3)
testthat::expect_equal(count_urls('a\nb\nc'), 3)
testthat::expect_equal(count_urls('a\nb,c'), 3)


gh_url <- gh_url %>%
  dplyr::mutate(num_urls = purrr::map_dbl(url, count_urls),
                gh_slug = purrr::map2_chr(url, num_urls, multiple_url_parse_gh_slug))


# only expect 9 values that do not have gh_slug
gh_url %>%
  dplyr::select(url, num_urls, gh_slug) %>%
  dplyr::filter(is.na(gh_slug)) %>%
  nrow() %>%
  testthat::expect_equal(9)

gh_url$gh_clone_url <- paste0('https://github.com/', gh_url$gh_slug, '.git')
gh_url
gh_url$gh_clone_path <-  paste0('./data/oss2/original/cloned_repos/cran/', gh_url$pkg_name)

gh_url %>% dplyr::select(pkg_name, gh_slug, gh_clone_url, gh_clone_path)

gh_url %>%
  dplyr::filter(production_ready == TRUE,
                osi_approved == TRUE,
                !is.na(gh_slug)) %>%
  nrow() ## 3888

readr::write_rds(gh_url, here::here('./data/oss2/processed/cran/production_osi_gh.RDS'))
