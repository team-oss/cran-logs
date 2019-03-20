library(readr)
library(httr)
library(stringr)
library(dplyr)
library(purrr)

# code duplicated in ./analysis/03-github/01-clone_gh_repos

source(here::here('./R/url_to_gh_slug.R'))

gh_slug_to_clone_info <- function(df, ...) {
  df %>% 
    dplyr::mutate(clone_urls = stringr::str_c('https://github.com/', gh_slug,'.git'),
                  repo_name = stringr::str_extract(gh_slug, '(?<=/).*'),
                  repo_save_path = stringr::str_c(..., repo_name)
    )
}

travis_badge_status <- function(user_repo) {
  curl_command <- sprintf('https://api.travis-ci.org/%s.svg?branch=master', user_repo)
  res <- httr::GET(curl_command)
  return(res)
}

jl <- readr::read_tsv(here::here('./analysis/01-scrape_package_data/julia/JuliaEcosystem/data/julia.tsv'))

julia_pkgs <- jl %>%
  dplyr::select(name, repository) %>%
  dplyr::distinct() %>%
  dplyr::mutate(gh_slug = purrr::map_chr(repository, .GlobalEnv$parse_github_slug)) %>%
  gh_slug_to_clone_info('./data/oss2/original/cloned_repos/julia/')

# julia_pkgs$gh_slug[[100]]
# t <- travis_badge_status(julia_pkgs$gh_slug[[100]])
# 
# s <- httr::content(t, "text")
# s
# stringr::str_detect(s, 'pass')
# stringr::str_detect(s, 'fail')
# stringr::str_detect(s, 'build')
# s
# t$url

print('getting travis status')

julia_pkgs <- julia_pkgs %>%
  dplyr::mutate(travis_master = purrr::map(gh_slug, travis_badge_status))

readr::write_rds(julia_pkgs, here::here('./data/oss2/processed/julia/pkg_travis_badge.RDS'))

print('Done')