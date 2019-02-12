library(readr)
library(here)
library(dplyr)
library(stringr)

source(here::here('./R/url_to_gh_slug.R'))

cdn <- readr::read_csv('./data/oss2/processed/cdn/cdn_osi.csv')

cdn$gh_slug <- purrr::map_chr(cdn$repository.url, .GlobalEnv$parse_github_slug)

# sanity checks ----
sum(is.na(cdn$repository.url))
sum(is.na(cdn$gh_slug))

# the gh_slugs that are NA where repository URL is not missing
# does not contain any github urls
# this is evidence that the github parsing slug function is working
cdn %>%
  dplyr::select(repository.url, gh_slug) %>%
  dplyr::filter(is.na(gh_slug)) %>%
  print(n = Inf)

cdn %>%
  dplyr::select(repository.url, gh_slug) %>%
  dplyr::filter(is.na(repository.url)) %>%
  print(n = Inf)


cdn %>%
  dplyr::select(repository.url, gh_slug) %>%
  dplyr::filter(is.na(gh_slug), stringr::str_detect(cdn$repository.url, 'github'))

cdn %>%
  dplyr::select(repository.url, gh_slug) %>%
  dplyr::filter(!is.na(gh_slug), stringr::str_detect(cdn$repository.url, 'github'))

cdn %>%
  dplyr::select(repository.url, gh_slug) %>%
  dplyr::filter(is.na(gh_slug), !stringr::str_detect(cdn$repository.url, 'github'))

cdn %>%
  dplyr::select(repository.url, gh_slug) %>%
  dplyr::filter(!is.na(gh_slug), !stringr::str_detect(cdn$repository.url, 'github'))

sum(stringr::str_detect(cdn$repository.url, 'github'), na.rm = TRUE)
sum(!is.na(cdn$gh_slug))
stopifnot(sum(stringr::str_detect(cdn$repository.url, 'github'), na.rm = TRUE) == 
          sum(!is.na(cdn$gh_slug))
          )

# process data ----

cdn_gh <- cdn %>%
  dplyr::select(filename, description, license, name, repository.type, repository.url,
                version, license_first, osi_approved, gh_slug) %>%
  dplyr::filter(osi_approved == TRUE) %>%
  dplyr::filter(!is.na(gh_slug))

readr::write_csv(cdn_gh, here::here('./data/oss2/processed/cdn/cdn_gh_slugs.csv'))
