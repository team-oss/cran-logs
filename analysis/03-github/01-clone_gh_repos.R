library(readr)
library(here)
library(dplyr)
library(stringr)
library(git2r)
library(progress)

source(here::here('./R/url_to_gh_slug.R'))

clone_pull_gh_repo <- function(gh_repo_url, gh_repo_path, sleep = 0) {
  tryCatch({
    if (dir.exists(gh_repo_path)) {
      git2r::pull(repo = gh_repo_path)
    } else {
      git2r::clone(url = gh_repo_url, local_path = gh_repo_path, progress = TRUE)
    }
    Sys.sleep(sleep)
  }, error = function(e){
    Sys.sleep(sleep)
  })
}

gh_slug_to_clone_info <- function(df, ...) {
  df %>% 
    dplyr::mutate(clone_urls = stringr::str_c('https://github.com/', gh_slug,'.git'),
                  repo_name = stringr::str_extract(gh_slug, '(?<=/).*'),
                  repo_save_path = stringr::str_c(..., repo_name)
    )
}

c <- tibble::tibble(gh_slug = 'asdf/jkl') %>%
  gh_slug_to_clone_info('/some/save/path/')
c

e <- tibble::tibble(
  gh_slug = 'asdf/jkl',
  clone_urls = 'https://github.com/asdf/jkl.git',
  repo_name = 'jkl',
  repo_save_path = '/some/save/path/jkl'
)

c
e

testthat::expect_true(identical(c, e))


download_git_repo <- function(repo_url, repo_save_path) {
  if (!interactive()) {
    print(repo_url)
    print(repo_save_path)
  }
  
  tryCatch({
    if (dir.exists(repo_save_path)) {
      git2r::pull(repo = repo_save_path)
    } else {
      git2r::clone(url = repo_url, local_path = repo_save_path, progress = TRUE)
    }
    Sys.sleep(runif(1))
  }, error = function(e){
    #Sys.sleep(runif(1))
  })
}

download_git_repo('https://github.com/HSU-ANT/ACME.jl.git', './data/oss2/original/cloned_repos/julia/ACME.jl')

# CDN -----

cdn_gh <- readr::read_csv(here::here('./data/oss2/processed/cdn/cdn_gh_slugs.csv'))

cdn_gh <- cdn_gh %>%
  dplyr::mutate(clone_urls = stringr::str_c('https://github.com/', gh_slug,'.git'),
                repo_name = stringr::str_extract(gh_slug, '(?<=/).*'),
                repo_save_path = stringr::str_c('./data/oss2/original/cloned_repos/cdn/', repo_name)
                )

total <- length(cdn_gh$clone_urls)
pb <- progress_bar$new(format = "[:bar] :current/:total (:percent)", total = total)
pb$tick(0)
for (i in seq_along(cdn_gh$clone_urls)) {
  # i <- 1
  url <- cdn_gh$clone_urls[[i]]
  rpath <- here::here(cdn_gh$repo_save_path[[i]])
  if(!interactive()) {
    print(sprintf('%s / %s', i, total))
    print(url)
    print(rpath)
  }
  
  tryCatch({
    if (dir.exists(rpath)) {
      git2r::pull(repo = rpath)
    } else {
      git2r::clone(url = url, local_path = rpath, progress = TRUE)
    }
    pb$tick(1)
    #Sys.sleep(runif(1))
    #break
  }, error = function(e) {
    pb$tick(1)
    #Sys.sleep(runif(1))
  })
}



# Julia -----

julia_gh <- readr::read_tsv(here::here('./analysis/01-scrape_package_data/julia/JuliaEcosystem/data/julia.tsv'))

julia_pkgs <- julia_gh %>%
  dplyr::select(name, repository) %>%
  dplyr::distinct() %>%
  dplyr::mutate(gh_slug = purrr::map_chr(repository, .GlobalEnv$parse_github_slug)) %>%
  gh_slug_to_clone_info('./data/oss2/original/cloned_repos/julia/')

purrr::map2(.x = julia_pkgs$clone_urls,
            .y = here::here(julia_pkgs$repo_save_path),
            .f = download_git_repo)
