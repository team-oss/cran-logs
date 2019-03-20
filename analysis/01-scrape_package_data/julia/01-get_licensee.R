library(magrittr)
library(readr)

jl_travis <- read_rds(here::here('./data/oss2/processed/julia/pkg_travis_badge.RDS'))

jl_travis <- jl_travis %>%
  #dplyr::slice(1:5) %>%
  dplyr::mutate(
    travis_content = purrr::map_chr(travis_master, httr::content, as = 'text', encoding = 'UTF-8'),
    travis_has_pass = purrr::map_lgl(travis_content, stringr::str_detect, pattern = 'pass'),
    travis_has_fail = purrr::map_lgl(travis_content, stringr::str_detect, pattern = 'fail')
  ) %>%
  {.}

## get license information

safe_list_files <- purrr::safely(list.files)
license_f <- purrr::map(jl_travis$repo_save_path, safe_list_files, pattern = 'LICENSE', full.names = TRUE, ignore.case = TRUE) %>%
  purrr::transpose() %>%
  .[['result']]
jl_travis$license_f <- license_f

# jl_travis %>%
#   dplyr::slice(1:10) %>%
#   dplyr::mutate(
#     license_1_line = purrr::map_chr(license_f, ~ readLines(., n = 1)[[1]])
#   ) -> t
# 
# jl_travis$license_f[[1]]
# readLines("./data/oss2/original/cloned_repos/julia/ACME.jl/LICENSE.md", n = 1)

# jl_travis$repo_save_path[[1]]

# l <- capture.output(system('licensee detect https://github.com/facebook/react'))


# l <- system('licensee detect https://github.com/facebook/react')


# get licensee detect text
jl_travis <- jl_travis %>%
  dplyr::mutate(
    licensee_detect = purrr::map(repo_save_path, ~ system(sprintf('licensee detect %s', .), intern = TRUE))
  )

readr::write_rds(jl_travis, here::here('./data/oss2/processed/julia/pkg_licensee_detect.RDS'))
