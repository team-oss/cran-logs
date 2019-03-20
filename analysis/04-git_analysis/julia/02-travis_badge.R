library(here)
library(readr)
library(dplyr)
library(purrr)
library(httr)
library(stringr)
library(tibble)

jl_travis <- read_rds(here::here('./data/oss2/processed/julia/pkg_travis_badge.RDS'))

jl_travis <- jl_travis %>%
  #dplyr::slice(1:5) %>%
  dplyr::mutate(
    travis_content = purrr::map_chr(travis_master, httr::content, as = 'text', encoding = 'UTF-8'),
    travis_has_pass = purrr::map_lgl(travis_content, stringr::str_detect, pattern = 'pass'),
    travis_has_fail = purrr::map_lgl(travis_content, stringr::str_detect, pattern = 'fail')
  ) %>%
  {.}

sum(jl_travis$travis_has_pass, na.rm = TRUE)
# 1381 out of 1618 passing (2019-02-18)
