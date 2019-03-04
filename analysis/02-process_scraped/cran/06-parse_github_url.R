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

get_bug_from_meta_tbl <- function(tbl) {
  bug <- tbl %>%
    dplyr::filter(X1 == 'BugReports:') %>%
    dplyr::pull(X2)
  if (length(bug) == 0) {
    return(NA)
  } else {
    return(bug)
  }
}

prod_osi <- readr::read_rds(here::here('./data/oss2/processed/cran/production_ready_osi_approved.RDS'))


## we found out that some CRAN packages have the github url in the bugreport column,
# so we will need to parse that: `BugReports:`

with_url <- prod_osi %>% 
  dplyr::mutate(url_section = purrr::map_chr(pkg_metadata, get_url_from_meta_tbl),
                bug_section = purrr::map_chr(pkg_metadata, get_bug_from_meta_tbl),
                # separating the 2 vectors with a comma see the multiple_url_parse_gh_slug function for other delimiters
                url = purrr::map2_chr(url_section, bug_section, paste, sep = ',')
                )

with_url %>%
  dplyr::filter(!is.na(url_section), !is.na(bug_section)) %>%
  head() %>%
  dplyr::select(pkg_name, pkg_metadata, url_section, bug_section, url)

with_url$pkg_metadata[[1]]
with_url$pkg_metadata[[2]]
with_url$pkg_metadata[[3]]

with_url <- with_url %>%
  #dplyr::mutate(url = purrr::map_chr(pkg_metadata, get_variable_from_meta_tbl, var = 'URL:')) %>%
  dplyr::filter(!is.na(url))

gh_url <- with_url %>%
  dplyr::filter(stringr::str_detect(url, 'github'))

# gh_url$url

## findings, some libraries have multiple urls listed: delimiters are , ,\n and maybe \n
## some repos have multiple github repos listed
## sometimes the seond gh rpo is the devel version
## the first url is not necessarily the gh one

gh_url <- gh_url %>%
  dplyr::mutate(num_urls = purrr::map_dbl(url, .GlobalEnv$count_urls),
                gh_slug = purrr::map2_chr(url, num_urls, multiple_url_parse_gh_slug))


# only expect 0 values that do not have gh_slug
gh_url %>%
  dplyr::select(url, num_urls, gh_slug) %>%
  dplyr::filter(is.na(gh_slug)) %>%
  nrow() %>%
  testthat::expect_equal(0)


gh_url$gh_slug_valid <- stringr::str_detect(gh_url$gh_slug, '.+/.+')

table(gh_url$gh_slug_valid, useNA = 'always')

gh_url %>%
  dplyr::filter(gh_slug_valid == FALSE) %>%
  dplyr::select(pkg_name, url, gh_slug, gh_slug_valid) %>%
  print(n = 1000)

## findings: all the invalid slugs are just user/ so we can append the pkg_name to get a valid slug

gh_url <- gh_url %>%
  dplyr::mutate(
    gh_slug = dplyr::case_when(
      gh_slug_valid == FALSE ~ stringr::str_c(gh_slug, pkg_name),
      gh_slug_valid == TRUE ~ gh_slug
    )
  )

gh_url %>%
  dplyr::filter(gh_slug_valid == FALSE) %>%
  dplyr::select(pkg_name, url, gh_slug, gh_slug_valid) %>%
  print(n = 1000)


gh_url$gh_clone_url <- paste0('https://github.com/', gh_url$gh_slug, '.git')
gh_url
gh_url$gh_clone_path <-  paste0('./data/oss2/original/cloned_repos/cran/', gh_url$pkg_name)

gh_url %>% dplyr::select(pkg_name, gh_slug, gh_clone_url, gh_clone_path)

gh_url %>%
  dplyr::filter(production_ready == TRUE,
                osi_approved == TRUE,
                !is.na(gh_slug)) %>%
  nrow() ## 4407


readr::write_rds(gh_url, here::here('./data/oss2/processed/cran/production_osi_gh.RDS'))
