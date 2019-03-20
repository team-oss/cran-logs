library(readr)
library(dplyr)

get_first_licensee <- function(df) {
  df %>%
    tidyr::separate(
      l_detect, c('var', 'value'), sep = ':'
    ) %>%
    dplyr::mutate(var = stringr::str_trim(var),
                  value = stringr::str_trim(value)) %>%
    dplyr::filter(var == 'License') %>%
    dplyr::slice(1) %>%
    dplyr::pull(value)
}

get_first_line_f <- function(fp) {
  if (file.exists(fp)) {
    lines <- readLines(fp)
    return(lines[[1]])
  } else{
    return(NA)
  }
}

# comes from: ./analysis/04-git_analysis/julia/02-travis_badge.R
jl_travis <- readr::read_rds(here::here('./data/oss2/processed/julia/pkg_licensee_detect.RDS'))
jl_travis

# passing CI
jl_travis %>%
  dplyr::filter(travis_has_pass == TRUE) %>%
  nrow() ## 1381

# osi approved
jl_travis %>%
  dplyr::mutate(license = purrr::map_chr(licensee_detect, magrittr::extract2, 1)) %>%
  dplyr::select(name, gh_slug, license) %>%
  dplyr::filter(license != 'License:        NOASSERTION') %>%
  nrow() ## 418

# production ready and osi
jl_travis %>%
  dplyr::mutate(license = purrr::map_chr(licensee_detect, magrittr::extract2, 1)) %>%
  dplyr::select(name, gh_slug, travis_has_pass, license) %>%
  dplyr::filter(license != 'License:        NOASSERTION',
                travis_has_pass == TRUE) %>%
  nrow() ## 324


# looking at those that are NOASSERTION
jl_travis %>%
  dplyr::mutate(license = purrr::map_chr(licensee_detect, magrittr::extract2, 1)) %>%
  dplyr::select(name, gh_slug, clone_urls, travis_has_pass, license) %>%
  dplyr::filter(license == 'License:        NOASSERTION')





###############################################################################




# parse the licensee text and get the first license response
jl_license <-jl_travis %>%
  #slice(1:10) %>%
  dplyr::mutate(licensee_df = purrr::map(licensee_detect, ~ tibble::tibble(l_detect = .))) %>%
  #dplyr::mutate(licensee_detect_df = purrr::map(licensee_df, ~ dplyr::rename(., l_detect = `<chr>`))) %>%
  #dplyr::mutate(licensee_detect_df = purrr::map(licensee_df, ~ names(.))) %>%
  dplyr::mutate(licensee_license = purrr::map_chr(licensee_df, get_first_licensee)) %>%
  {.}

jl_license


jl_travis %>%
  dplyr::mutate(licensee_df = purrr::map(licensee_detect, tibble::tibble(txt = .))) %>%
  dplyr::pull(licensee_df)

# jl_travis$licensee_detect_df[[1]]


# system(sprintf('licensee detect %s', jl_travis$repo_save_path[[1]]))

# l <- system(sprintf('licensee detect %s', jl_travis$repo_save_path[[1]]), intern = TRUE)
# matrix(l, ncol = 1, byrow = FALSE)

# df <- tibble::tibble(l)
# df



t <- jl_travis %>%
  slice(1:10) %>%
  dplyr::mutate(licensee_df = purrr::map(licensee_detect, tibble::tibble)) %>%
  dplyr::mutate(licensee_detect_df = purrr::map(licensee_df, ~ dplyr::rename(., l_detect = `<chr>`))) %>%
  dplyr::mutate(licensee_license = purrr::map_chr(licensee_detect_df, get_first_licensee)) %>%
  {.}
t$licensee_df

t$licensee_detect_df[[1]]
t$licensee_license

get_first_licensee(t$licensee_df[[1]])

t %>%

purrr::map(t$licensee_df, get_first_licensee)


t <- jl_license %>%
  dplyr::select(name, license_f) %>%
  #slice(1:100) %>%
  dplyr::mutate(
    lf_1 = purrr::map_chr(license_f, magrittr::extract, 1),
    license_1 = purrr::map_chr(lf_1, get_first_line_f),
    license = stringr::str_extract(license_1, '(?<=the).*(?=License)')
  ) %>%
  #pull(license) %>%
  #table(useNA = 'always') %>%
  {.}
t

t %>%
  pull(license) %>%
  table(useNA = 'always')

t %>% dplyr::filter(is.na(license)) %>% print(n=100)

t %>% dplyr::filter(is.na(license))  %>% pull(license_1) %>% table()
