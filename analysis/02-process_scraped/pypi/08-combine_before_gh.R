# returns a dataset of production ready packages with OSI approved licences with a github repository

library(readr)
library(here)
library(dplyr)

source(here::here('./R/url_to_gh_slug.R'))

prod_rdy <- readr::read_csv(here::here('./data/oss2/processed/working/pypi/production_ready.csv'))
osi_appr <- readr::read_rds(here::here('./data/oss2/processed/pypi/osi_approved.RDS'))

prod_rdy <- dplyr::mutate(prod_rdy, prod_rdy = dev_status_clean == 'production/stable' | dev_status_clean == 'mature')
osi_appr

# is pandas in here?
stopifnot('pandas' %in% prod_rdy$name_pypi)
stopifnot('pandas' %in% osi_appr$name)

# make sure no duplicates
stopifnot(all(!duplicated(prod_rdy$name_pypi)))
stopifnot(all(!duplicated(osi_appr$name)))

prod_osi_status <- dplyr::full_join(prod_rdy, osi_appr, by = c('name'))
stopifnot('pandas' %in% prod_osi_status$name_pypi)

prod <- dplyr::filter(prod_osi_status, prod_rdy == TRUE)
stopifnot('pandas' %in% prod$name_pypi)

osi <- dplyr::filter(prod_osi_status, osi_approved == TRUE)
stopifnot('pandas' %in% osi$name_pypi)

nrow(prod) ## 17482
nrow(osi) ## 30909



prod_osi <- dplyr::filter(prod_osi_status,
                          prod_rdy == TRUE,
                          osi_approved == TRUE)
stopifnot('pandas' %in% prod$name_pypi)
nrow(prod_osi) ## 15043


## home_page seems to be where the gh_urls are held

prod_osi <- prod_osi %>%
  dplyr::mutate(gh_slug = purrr::map_chr(home_page, .GlobalEnv$parse_github_slug), # use the home_page column to parse github link first
                gh_slug = dplyr::case_when(is.na(gh_slug) ~ purrr::map_chr(download_url, .GlobalEnv$parse_github_slug),
                                           TRUE ~ gh_slug)# if that doesnt work use the download_url column
                )
# in pandas, none of the values in the row have 'github' in it, so unable to even find a column to use for github analysis
# prod_osi %>% dplyr::filter(name_pypi == 'pandas') %>% as.character() %>% stringr::str_detect('github') %>% any(na.rm = TRUE)

# look at missing gh_slugs
prod_osi %>%
  dplyr::select(name_pypi, download_url, home_page, gh_slug) %>%
  dplyr::filter(is.na(gh_slug)) %>%
  dplyr::arrange(name_pypi) %>%
  print(n = 100000)
## findings there are bitbucket, gitlab, sourceforge links in hered

prod_osi_gh <- prod_osi %>%
  dplyr::filter(!is.na(gh_slug)) %>%
  dplyr::mutate(gh_clone_url = paste0('https://github.com/', gh_slug, '.git'),
                gh_clone_path = paste0('./data/oss2/original/cloned_repos/pypi/', name),
                gh_slug_valid = stringr::str_detect(gh_slug, '.+/.+')
                )
# pandas is not in here beacuase it has no gihub link
# 'pandas' %in% prod_osi_gh$name_pypi

nrow(prod_osi_gh) ## 11019

## findings: except for 3, all the other slugs are user/ so we can append the name to it
## and get a valid slug

table(prod_osi_gh$gh_slug_valid, useNA = 'always')

prod_osi_gh %>%
  dplyr::select(name, home_page, gh_slug, gh_slug_valid) %>%
  dplyr::filter(gh_slug_valid == FALSE) %>%
  print(n = 100000)

prod_osi_gh <- prod_osi_gh %>%
  dplyr::mutate(
    gh_slug = dplyr::case_when(
      gh_slug_valid == FALSE & gh_slug != '/' ~ stringr::str_c(gh_slug, name),
      gh_slug_valid == TRUE ~ gh_slug
    ),
    gh_clone_url = paste0('https://github.com/', gh_slug, '.git')
  )

prod_osi_gh %>%
  dplyr::select(name, home_page, gh_slug, gh_slug_valid, gh_clone_url) %>%
  dplyr::filter(gh_slug_valid == FALSE)

prod_osi_gh <- prod_osi_gh %>%
  dplyr::filter(!is.na(gh_slug))

nrow(prod_osi_gh) ## 11016

prod_osi_gh <- dplyr::arrange(prod_osi_gh, name)

readr::write_rds(prod_osi_gh, here::here('./data/oss2/processed/pypi/prod_osi_gh.RDS'))
